
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
  80003e:	e8 c1 18 00 00       	call   801904 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 3c 80 00       	push   $0x803c40
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 96 14 00 00       	call   8014ec <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 3c 80 00       	push   $0x803c42
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 80 14 00 00       	call   8014ec <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 3c 80 00       	push   $0x803c49
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 6a 14 00 00       	call   8014ec <sget>
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
  800098:	68 57 3c 80 00       	push   $0x803c57
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 38 36 00 00       	call   8036de <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 44 36 00 00       	call   8036f8 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 74 18 00 00       	call   801937 <sys_get_virtual_time>
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
  8000e6:	e8 4c 36 00 00       	call   803737 <env_sleep>
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
  8000fe:	e8 34 18 00 00       	call   801937 <sys_get_virtual_time>
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
  800126:	e8 0c 36 00 00       	call   803737 <env_sleep>
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
  80013d:	e8 f5 17 00 00       	call   801937 <sys_get_virtual_time>
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
  800165:	e8 cd 35 00 00       	call   803737 <env_sleep>
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
  800183:	e8 63 17 00 00       	call   8018eb <sys_getenvindex>
  800188:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	c1 e0 03             	shl    $0x3,%eax
  800193:	01 d0                	add    %edx,%eax
  800195:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80019c:	01 c8                	add    %ecx,%eax
  80019e:	01 c0                	add    %eax,%eax
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001a9:	01 c8                	add    %ecx,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001bc:	8a 40 20             	mov    0x20(%eax),%al
  8001bf:	84 c0                	test   %al,%al
  8001c1:	74 0d                	je     8001d0 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8001c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c8:	83 c0 20             	add    $0x20,%eax
  8001cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d4:	7e 0a                	jle    8001e0 <libmain+0x63>
		binaryname = argv[0];
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 4a fe ff ff       	call   800038 <_main>
  8001ee:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001f1:	e8 79 14 00 00       	call   80166f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 74 3c 80 00       	push   $0x803c74
  8001fe:	e8 8d 01 00 00       	call   800390 <cprintf>
  800203:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 50 80 00       	mov    0x805020,%eax
  80020b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800211:	a1 20 50 80 00       	mov    0x805020,%eax
  800216:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 9c 3c 80 00       	push   $0x803c9c
  800226:	e8 65 01 00 00       	call   800390 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800239:	a1 20 50 80 00       	mov    0x805020,%eax
  80023e:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800244:	a1 20 50 80 00       	mov    0x805020,%eax
  800249:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80024f:	51                   	push   %ecx
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 c4 3c 80 00       	push   $0x803cc4
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 1c 3d 80 00       	push   $0x803d1c
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 74 3c 80 00       	push   $0x803c74
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 f9 13 00 00       	call   801689 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800290:	e8 19 00 00 00       	call   8002ae <exit>
}
  800295:	90                   	nop
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029e:	83 ec 0c             	sub    $0xc,%esp
  8002a1:	6a 00                	push   $0x0
  8002a3:	e8 0f 16 00 00       	call   8018b7 <sys_destroy_env>
  8002a8:	83 c4 10             	add    $0x10,%esp
}
  8002ab:	90                   	nop
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <exit>:

void
exit(void)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b4:	e8 64 16 00 00       	call   80191d <sys_exit_env>
}
  8002b9:	90                   	nop
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	8b 00                	mov    (%eax),%eax
  8002c7:	8d 48 01             	lea    0x1(%eax),%ecx
  8002ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cd:	89 0a                	mov    %ecx,(%edx)
  8002cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d2:	88 d1                	mov    %dl,%cl
  8002d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e5:	75 2c                	jne    800313 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002e7:	a0 28 50 80 00       	mov    0x805028,%al
  8002ec:	0f b6 c0             	movzbl %al,%eax
  8002ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f2:	8b 12                	mov    (%edx),%edx
  8002f4:	89 d1                	mov    %edx,%ecx
  8002f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f9:	83 c2 08             	add    $0x8,%edx
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	50                   	push   %eax
  800300:	51                   	push   %ecx
  800301:	52                   	push   %edx
  800302:	e8 26 13 00 00       	call   80162d <sys_cputs>
  800307:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	8b 40 04             	mov    0x4(%eax),%eax
  800319:	8d 50 01             	lea    0x1(%eax),%edx
  80031c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800322:	90                   	nop
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800335:	00 00 00 
	b.cnt = 0;
  800338:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	68 bc 02 80 00       	push   $0x8002bc
  800354:	e8 11 02 00 00       	call   80056a <vprintfmt>
  800359:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80035c:	a0 28 50 80 00       	mov    0x805028,%al
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	50                   	push   %eax
  80036e:	52                   	push   %edx
  80036f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800375:	83 c0 08             	add    $0x8,%eax
  800378:	50                   	push   %eax
  800379:	e8 af 12 00 00       	call   80162d <sys_cputs>
  80037e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800381:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800388:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800396:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80039d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ac:	50                   	push   %eax
  8003ad:	e8 73 ff ff ff       	call   800325 <vcprintf>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003c3:	e8 a7 12 00 00       	call   80166f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d7:	50                   	push   %eax
  8003d8:	e8 48 ff ff ff       	call   800325 <vcprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003e3:	e8 a1 12 00 00       	call   801689 <sys_unlock_cons>
	return cnt;
  8003e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	53                   	push   %ebx
  8003f1:	83 ec 14             	sub    $0x14,%esp
  8003f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800400:	8b 45 18             	mov    0x18(%ebp),%eax
  800403:	ba 00 00 00 00       	mov    $0x0,%edx
  800408:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80040b:	77 55                	ja     800462 <printnum+0x75>
  80040d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800410:	72 05                	jb     800417 <printnum+0x2a>
  800412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800415:	77 4b                	ja     800462 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800417:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80041d:	8b 45 18             	mov    0x18(%ebp),%eax
  800420:	ba 00 00 00 00       	mov    $0x0,%edx
  800425:	52                   	push   %edx
  800426:	50                   	push   %eax
  800427:	ff 75 f4             	pushl  -0xc(%ebp)
  80042a:	ff 75 f0             	pushl  -0x10(%ebp)
  80042d:	e8 a2 35 00 00       	call   8039d4 <__udivdi3>
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	ff 75 20             	pushl  0x20(%ebp)
  80043b:	53                   	push   %ebx
  80043c:	ff 75 18             	pushl  0x18(%ebp)
  80043f:	52                   	push   %edx
  800440:	50                   	push   %eax
  800441:	ff 75 0c             	pushl  0xc(%ebp)
  800444:	ff 75 08             	pushl  0x8(%ebp)
  800447:	e8 a1 ff ff ff       	call   8003ed <printnum>
  80044c:	83 c4 20             	add    $0x20,%esp
  80044f:	eb 1a                	jmp    80046b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 20             	pushl  0x20(%ebp)
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	ff d0                	call   *%eax
  80045f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800462:	ff 4d 1c             	decl   0x1c(%ebp)
  800465:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800469:	7f e6                	jg     800451 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80046e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800479:	53                   	push   %ebx
  80047a:	51                   	push   %ecx
  80047b:	52                   	push   %edx
  80047c:	50                   	push   %eax
  80047d:	e8 62 36 00 00       	call   803ae4 <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 54 3f 80 00       	add    $0x803f54,%eax
  80048a:	8a 00                	mov    (%eax),%al
  80048c:	0f be c0             	movsbl %al,%eax
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	50                   	push   %eax
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	ff d0                	call   *%eax
  80049b:	83 c4 10             	add    $0x10,%esp
}
  80049e:	90                   	nop
  80049f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ab:	7e 1c                	jle    8004c9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	8d 50 08             	lea    0x8(%eax),%edx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	89 10                	mov    %edx,(%eax)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	83 e8 08             	sub    $0x8,%eax
  8004c2:	8b 50 04             	mov    0x4(%eax),%edx
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	eb 40                	jmp    800509 <getuint+0x65>
	else if (lflag)
  8004c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004cd:	74 1e                	je     8004ed <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	83 e8 04             	sub    $0x4,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004eb:	eb 1c                	jmp    800509 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	8d 50 04             	lea    0x4(%eax),%edx
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	89 10                	mov    %edx,(%eax)
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	83 e8 04             	sub    $0x4,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80050e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800512:	7e 1c                	jle    800530 <getint+0x25>
		return va_arg(*ap, long long);
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	8d 50 08             	lea    0x8(%eax),%edx
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	89 10                	mov    %edx,(%eax)
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	83 e8 08             	sub    $0x8,%eax
  800529:	8b 50 04             	mov    0x4(%eax),%edx
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	eb 38                	jmp    800568 <getint+0x5d>
	else if (lflag)
  800530:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800534:	74 1a                	je     800550 <getint+0x45>
		return va_arg(*ap, long);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	8d 50 04             	lea    0x4(%eax),%edx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 10                	mov    %edx,(%eax)
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	83 e8 04             	sub    $0x4,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	99                   	cltd   
  80054e:	eb 18                	jmp    800568 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 50 04             	lea    0x4(%eax),%edx
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	89 10                	mov    %edx,(%eax)
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 e8 04             	sub    $0x4,%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	99                   	cltd   
}
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	56                   	push   %esi
  80056e:	53                   	push   %ebx
  80056f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800572:	eb 17                	jmp    80058b <vprintfmt+0x21>
			if (ch == '\0')
  800574:	85 db                	test   %ebx,%ebx
  800576:	0f 84 c1 03 00 00    	je     80093d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	53                   	push   %ebx
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	ff d0                	call   *%eax
  800588:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058b:	8b 45 10             	mov    0x10(%ebp),%eax
  80058e:	8d 50 01             	lea    0x1(%eax),%edx
  800591:	89 55 10             	mov    %edx,0x10(%ebp)
  800594:	8a 00                	mov    (%eax),%al
  800596:	0f b6 d8             	movzbl %al,%ebx
  800599:	83 fb 25             	cmp    $0x25,%ebx
  80059c:	75 d6                	jne    800574 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80059e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005be:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c1:	8d 50 01             	lea    0x1(%eax),%edx
  8005c4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c7:	8a 00                	mov    (%eax),%al
  8005c9:	0f b6 d8             	movzbl %al,%ebx
  8005cc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005cf:	83 f8 5b             	cmp    $0x5b,%eax
  8005d2:	0f 87 3d 03 00 00    	ja     800915 <vprintfmt+0x3ab>
  8005d8:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  8005df:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005e5:	eb d7                	jmp    8005be <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005eb:	eb d1                	jmp    8005be <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	c1 e0 02             	shl    $0x2,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	01 c0                	add    %eax,%eax
  800600:	01 d8                	add    %ebx,%eax
  800602:	83 e8 30             	sub    $0x30,%eax
  800605:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800608:	8b 45 10             	mov    0x10(%ebp),%eax
  80060b:	8a 00                	mov    (%eax),%al
  80060d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800610:	83 fb 2f             	cmp    $0x2f,%ebx
  800613:	7e 3e                	jle    800653 <vprintfmt+0xe9>
  800615:	83 fb 39             	cmp    $0x39,%ebx
  800618:	7f 39                	jg     800653 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80061d:	eb d5                	jmp    8005f4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	83 c0 04             	add    $0x4,%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 e8 04             	sub    $0x4,%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800633:	eb 1f                	jmp    800654 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800635:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800639:	79 83                	jns    8005be <vprintfmt+0x54>
				width = 0;
  80063b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800642:	e9 77 ff ff ff       	jmp    8005be <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800647:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80064e:	e9 6b ff ff ff       	jmp    8005be <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800653:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800658:	0f 89 60 ff ff ff    	jns    8005be <vprintfmt+0x54>
				width = precision, precision = -1;
  80065e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800664:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80066b:	e9 4e ff ff ff       	jmp    8005be <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800670:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800673:	e9 46 ff ff ff       	jmp    8005be <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	83 c0 04             	add    $0x4,%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	50                   	push   %eax
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	ff d0                	call   *%eax
  800695:	83 c4 10             	add    $0x10,%esp
			break;
  800698:	e9 9b 02 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	83 e8 04             	sub    $0x4,%eax
  8006ac:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006ae:	85 db                	test   %ebx,%ebx
  8006b0:	79 02                	jns    8006b4 <vprintfmt+0x14a>
				err = -err;
  8006b2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006b4:	83 fb 64             	cmp    $0x64,%ebx
  8006b7:	7f 0b                	jg     8006c4 <vprintfmt+0x15a>
  8006b9:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 65 3f 80 00       	push   $0x803f65
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 70 02 00 00       	call   800945 <printfmt>
  8006d5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d8:	e9 5b 02 00 00       	jmp    800938 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006dd:	56                   	push   %esi
  8006de:	68 6e 3f 80 00       	push   $0x803f6e
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 57 02 00 00       	call   800945 <printfmt>
  8006ee:	83 c4 10             	add    $0x10,%esp
			break;
  8006f1:	e9 42 02 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	83 c0 04             	add    $0x4,%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	83 e8 04             	sub    $0x4,%eax
  800705:	8b 30                	mov    (%eax),%esi
  800707:	85 f6                	test   %esi,%esi
  800709:	75 05                	jne    800710 <vprintfmt+0x1a6>
				p = "(null)";
  80070b:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	7e 6d                	jle    800783 <vprintfmt+0x219>
  800716:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80071a:	74 67                	je     800783 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80071c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	50                   	push   %eax
  800723:	56                   	push   %esi
  800724:	e8 1e 03 00 00       	call   800a47 <strnlen>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80072f:	eb 16                	jmp    800747 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800731:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	50                   	push   %eax
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	ff d0                	call   *%eax
  800741:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800744:	ff 4d e4             	decl   -0x1c(%ebp)
  800747:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074b:	7f e4                	jg     800731 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074d:	eb 34                	jmp    800783 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80074f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800753:	74 1c                	je     800771 <vprintfmt+0x207>
  800755:	83 fb 1f             	cmp    $0x1f,%ebx
  800758:	7e 05                	jle    80075f <vprintfmt+0x1f5>
  80075a:	83 fb 7e             	cmp    $0x7e,%ebx
  80075d:	7e 12                	jle    800771 <vprintfmt+0x207>
					putch('?', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 3f                	push   $0x3f
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	eb 0f                	jmp    800780 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800780:	ff 4d e4             	decl   -0x1c(%ebp)
  800783:	89 f0                	mov    %esi,%eax
  800785:	8d 70 01             	lea    0x1(%eax),%esi
  800788:	8a 00                	mov    (%eax),%al
  80078a:	0f be d8             	movsbl %al,%ebx
  80078d:	85 db                	test   %ebx,%ebx
  80078f:	74 24                	je     8007b5 <vprintfmt+0x24b>
  800791:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800795:	78 b8                	js     80074f <vprintfmt+0x1e5>
  800797:	ff 4d e0             	decl   -0x20(%ebp)
  80079a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079e:	79 af                	jns    80074f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a0:	eb 13                	jmp    8007b5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 20                	push   $0x20
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b9:	7f e7                	jg     8007a2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007bb:	e9 78 01 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	e8 3c fd ff ff       	call   80050b <getint>
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	79 23                	jns    800805 <vprintfmt+0x29b>
				putch('-', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	6a 2d                	push   $0x2d
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f8:	f7 d8                	neg    %eax
  8007fa:	83 d2 00             	adc    $0x0,%edx
  8007fd:	f7 da                	neg    %edx
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800802:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800805:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80080c:	e9 bc 00 00 00       	jmp    8008cd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 e8             	pushl  -0x18(%ebp)
  800817:	8d 45 14             	lea    0x14(%ebp),%eax
  80081a:	50                   	push   %eax
  80081b:	e8 84 fc ff ff       	call   8004a4 <getuint>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800826:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800829:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800830:	e9 98 00 00 00       	jmp    8008cd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 58                	push   $0x58
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	6a 58                	push   $0x58
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 58                	push   $0x58
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			break;
  800865:	e9 ce 00 00 00       	jmp    800938 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	6a 30                	push   $0x30
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80087a:	83 ec 08             	sub    $0x8,%esp
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	6a 78                	push   $0x78
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80089b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008a5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ac:	eb 1f                	jmp    8008cd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b7:	50                   	push   %eax
  8008b8:	e8 e7 fb ff ff       	call   8004a4 <getuint>
  8008bd:	83 c4 10             	add    $0x10,%esp
  8008c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008c6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008cd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d4:	83 ec 04             	sub    $0x4,%esp
  8008d7:	52                   	push   %edx
  8008d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008db:	50                   	push   %eax
  8008dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008df:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 00 fb ff ff       	call   8003ed <printnum>
  8008ed:	83 c4 20             	add    $0x20,%esp
			break;
  8008f0:	eb 46                	jmp    800938 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	53                   	push   %ebx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			break;
  800901:	eb 35                	jmp    800938 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800903:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80090a:	eb 2c                	jmp    800938 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80090c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800913:	eb 23                	jmp    800938 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	6a 25                	push   $0x25
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800925:	ff 4d 10             	decl   0x10(%ebp)
  800928:	eb 03                	jmp    80092d <vprintfmt+0x3c3>
  80092a:	ff 4d 10             	decl   0x10(%ebp)
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	48                   	dec    %eax
  800931:	8a 00                	mov    (%eax),%al
  800933:	3c 25                	cmp    $0x25,%al
  800935:	75 f3                	jne    80092a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800937:	90                   	nop
		}
	}
  800938:	e9 35 fc ff ff       	jmp    800572 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80093d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80093e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80094b:	8d 45 10             	lea    0x10(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800954:	8b 45 10             	mov    0x10(%ebp),%eax
  800957:	ff 75 f4             	pushl  -0xc(%ebp)
  80095a:	50                   	push   %eax
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 04 fc ff ff       	call   80056a <vprintfmt>
  800966:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800969:	90                   	nop
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80096f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800972:	8b 40 08             	mov    0x8(%eax),%eax
  800975:	8d 50 01             	lea    0x1(%eax),%edx
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8b 10                	mov    (%eax),%edx
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 40 04             	mov    0x4(%eax),%eax
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	73 12                	jae    80099f <sprintputch+0x33>
		*b->buf++ = ch;
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	8d 48 01             	lea    0x1(%eax),%ecx
  800995:	8b 55 0c             	mov    0xc(%ebp),%edx
  800998:	89 0a                	mov    %ecx,(%edx)
  80099a:	8b 55 08             	mov    0x8(%ebp),%edx
  80099d:	88 10                	mov    %dl,(%eax)
}
  80099f:	90                   	nop
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	01 d0                	add    %edx,%eax
  8009b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c7:	74 06                	je     8009cf <vsnprintf+0x2d>
  8009c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cd:	7f 07                	jg     8009d6 <vsnprintf+0x34>
		return -E_INVAL;
  8009cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8009d4:	eb 20                	jmp    8009f6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d6:	ff 75 14             	pushl  0x14(%ebp)
  8009d9:	ff 75 10             	pushl  0x10(%ebp)
  8009dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	68 6c 09 80 00       	push   $0x80096c
  8009e5:	e8 80 fb ff ff       	call   80056a <vprintfmt>
  8009ea:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009f6:	c9                   	leave  
  8009f7:	c3                   	ret    

008009f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a07:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	ff 75 08             	pushl  0x8(%ebp)
  800a14:	e8 89 ff ff ff       	call   8009a2 <vsnprintf>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a31:	eb 06                	jmp    800a39 <strlen+0x15>
		n++;
  800a33:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a36:	ff 45 08             	incl   0x8(%ebp)
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 f1                	jne    800a33 <strlen+0xf>
		n++;
	return n;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a54:	eb 09                	jmp    800a5f <strnlen+0x18>
		n++;
  800a56:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a59:	ff 45 08             	incl   0x8(%ebp)
  800a5c:	ff 4d 0c             	decl   0xc(%ebp)
  800a5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a63:	74 09                	je     800a6e <strnlen+0x27>
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	84 c0                	test   %al,%al
  800a6c:	75 e8                	jne    800a56 <strnlen+0xf>
		n++;
	return n;
  800a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a7f:	90                   	nop
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8d 50 01             	lea    0x1(%eax),%edx
  800a86:	89 55 08             	mov    %edx,0x8(%ebp)
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a8f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a92:	8a 12                	mov    (%edx),%dl
  800a94:	88 10                	mov    %dl,(%eax)
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	84 c0                	test   %al,%al
  800a9a:	75 e4                	jne    800a80 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800aad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab4:	eb 1f                	jmp    800ad5 <strncpy+0x34>
		*dst++ = *src;
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8d 50 01             	lea    0x1(%eax),%edx
  800abc:	89 55 08             	mov    %edx,0x8(%ebp)
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac2:	8a 12                	mov    (%edx),%dl
  800ac4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	84 c0                	test   %al,%al
  800acd:	74 03                	je     800ad2 <strncpy+0x31>
			src++;
  800acf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad2:	ff 45 fc             	incl   -0x4(%ebp)
  800ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800adb:	72 d9                	jb     800ab6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800add:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af2:	74 30                	je     800b24 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800af4:	eb 16                	jmp    800b0c <strlcpy+0x2a>
			*dst++ = *src++;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8d 50 01             	lea    0x1(%eax),%edx
  800afc:	89 55 08             	mov    %edx,0x8(%ebp)
  800aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b02:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b05:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b08:	8a 12                	mov    (%edx),%dl
  800b0a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b0c:	ff 4d 10             	decl   0x10(%ebp)
  800b0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b13:	74 09                	je     800b1e <strlcpy+0x3c>
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	75 d8                	jne    800af6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2a:	29 c2                	sub    %eax,%edx
  800b2c:	89 d0                	mov    %edx,%eax
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b33:	eb 06                	jmp    800b3b <strcmp+0xb>
		p++, q++;
  800b35:	ff 45 08             	incl   0x8(%ebp)
  800b38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	84 c0                	test   %al,%al
  800b42:	74 0e                	je     800b52 <strcmp+0x22>
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8a 10                	mov    (%eax),%dl
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	38 c2                	cmp    %al,%dl
  800b50:	74 e3                	je     800b35 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8a 00                	mov    (%eax),%al
  800b57:	0f b6 d0             	movzbl %al,%edx
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	8a 00                	mov    (%eax),%al
  800b5f:	0f b6 c0             	movzbl %al,%eax
  800b62:	29 c2                	sub    %eax,%edx
  800b64:	89 d0                	mov    %edx,%eax
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b6b:	eb 09                	jmp    800b76 <strncmp+0xe>
		n--, p++, q++;
  800b6d:	ff 4d 10             	decl   0x10(%ebp)
  800b70:	ff 45 08             	incl   0x8(%ebp)
  800b73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7a:	74 17                	je     800b93 <strncmp+0x2b>
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	74 0e                	je     800b93 <strncmp+0x2b>
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8a 10                	mov    (%eax),%dl
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	38 c2                	cmp    %al,%dl
  800b91:	74 da                	je     800b6d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b97:	75 07                	jne    800ba0 <strncmp+0x38>
		return 0;
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9e:	eb 14                	jmp    800bb4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	0f b6 d0             	movzbl %al,%edx
  800ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	0f b6 c0             	movzbl %al,%eax
  800bb0:	29 c2                	sub    %eax,%edx
  800bb2:	89 d0                	mov    %edx,%eax
}
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 04             	sub    $0x4,%esp
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc2:	eb 12                	jmp    800bd6 <strchr+0x20>
		if (*s == c)
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bcc:	75 05                	jne    800bd3 <strchr+0x1d>
			return (char *) s;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	eb 11                	jmp    800be4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bd3:	ff 45 08             	incl   0x8(%ebp)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	84 c0                	test   %al,%al
  800bdd:	75 e5                	jne    800bc4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 04             	sub    $0x4,%esp
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf2:	eb 0d                	jmp    800c01 <strfind+0x1b>
		if (*s == c)
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bfc:	74 0e                	je     800c0c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 ea                	jne    800bf4 <strfind+0xe>
  800c0a:	eb 01                	jmp    800c0d <strfind+0x27>
		if (*s == c)
			break;
  800c0c:	90                   	nop
	return (char *) s;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c24:	eb 0e                	jmp    800c34 <memset+0x22>
		*p++ = c;
  800c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c29:	8d 50 01             	lea    0x1(%eax),%edx
  800c2c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c32:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c34:	ff 4d f8             	decl   -0x8(%ebp)
  800c37:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c3b:	79 e9                	jns    800c26 <memset+0x14>
		*p++ = c;

	return v;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c54:	eb 16                	jmp    800c6c <memcpy+0x2a>
		*d++ = *s++;
  800c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c59:	8d 50 01             	lea    0x1(%eax),%edx
  800c5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c65:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c68:	8a 12                	mov    (%edx),%dl
  800c6a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c72:	89 55 10             	mov    %edx,0x10(%ebp)
  800c75:	85 c0                	test   %eax,%eax
  800c77:	75 dd                	jne    800c56 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c93:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c96:	73 50                	jae    800ce8 <memmove+0x6a>
  800c98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9e:	01 d0                	add    %edx,%eax
  800ca0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ca3:	76 43                	jbe    800ce8 <memmove+0x6a>
		s += n;
  800ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cab:	8b 45 10             	mov    0x10(%ebp),%eax
  800cae:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cb1:	eb 10                	jmp    800cc3 <memmove+0x45>
			*--d = *--s;
  800cb3:	ff 4d f8             	decl   -0x8(%ebp)
  800cb6:	ff 4d fc             	decl   -0x4(%ebp)
  800cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbc:	8a 10                	mov    (%eax),%dl
  800cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	75 e3                	jne    800cb3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd0:	eb 23                	jmp    800cf5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd5:	8d 50 01             	lea    0x1(%eax),%edx
  800cd8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cdb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cde:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ce4:	8a 12                	mov    (%edx),%dl
  800ce6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cee:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	75 dd                	jne    800cd2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d0c:	eb 2a                	jmp    800d38 <memcmp+0x3e>
		if (*s1 != *s2)
  800d0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 16                	je     800d32 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f b6 d0             	movzbl %al,%edx
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	0f b6 c0             	movzbl %al,%eax
  800d2c:	29 c2                	sub    %eax,%edx
  800d2e:	89 d0                	mov    %edx,%eax
  800d30:	eb 18                	jmp    800d4a <memcmp+0x50>
		s1++, s2++;
  800d32:	ff 45 fc             	incl   -0x4(%ebp)
  800d35:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	75 c9                	jne    800d0e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 45 10             	mov    0x10(%ebp),%eax
  800d58:	01 d0                	add    %edx,%eax
  800d5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d5d:	eb 15                	jmp    800d74 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	0f b6 d0             	movzbl %al,%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	0f b6 c0             	movzbl %al,%eax
  800d6d:	39 c2                	cmp    %eax,%edx
  800d6f:	74 0d                	je     800d7e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d71:	ff 45 08             	incl   0x8(%ebp)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d7a:	72 e3                	jb     800d5f <memfind+0x13>
  800d7c:	eb 01                	jmp    800d7f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d7e:	90                   	nop
	return (void *) s;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d91:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d98:	eb 03                	jmp    800d9d <strtol+0x19>
		s++;
  800d9a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3c 20                	cmp    $0x20,%al
  800da4:	74 f4                	je     800d9a <strtol+0x16>
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	3c 09                	cmp    $0x9,%al
  800dad:	74 eb                	je     800d9a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	3c 2b                	cmp    $0x2b,%al
  800db6:	75 05                	jne    800dbd <strtol+0x39>
		s++;
  800db8:	ff 45 08             	incl   0x8(%ebp)
  800dbb:	eb 13                	jmp    800dd0 <strtol+0x4c>
	else if (*s == '-')
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 2d                	cmp    $0x2d,%al
  800dc4:	75 0a                	jne    800dd0 <strtol+0x4c>
		s++, neg = 1;
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd4:	74 06                	je     800ddc <strtol+0x58>
  800dd6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dda:	75 20                	jne    800dfc <strtol+0x78>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 17                	jne    800dfc <strtol+0x78>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	40                   	inc    %eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	3c 78                	cmp    $0x78,%al
  800ded:	75 0d                	jne    800dfc <strtol+0x78>
		s += 2, base = 16;
  800def:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800df3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dfa:	eb 28                	jmp    800e24 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	75 15                	jne    800e17 <strtol+0x93>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3c 30                	cmp    $0x30,%al
  800e09:	75 0c                	jne    800e17 <strtol+0x93>
		s++, base = 8;
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e15:	eb 0d                	jmp    800e24 <strtol+0xa0>
	else if (base == 0)
  800e17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1b:	75 07                	jne    800e24 <strtol+0xa0>
		base = 10;
  800e1d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	3c 2f                	cmp    $0x2f,%al
  800e2b:	7e 19                	jle    800e46 <strtol+0xc2>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	3c 39                	cmp    $0x39,%al
  800e34:	7f 10                	jg     800e46 <strtol+0xc2>
			dig = *s - '0';
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	0f be c0             	movsbl %al,%eax
  800e3e:	83 e8 30             	sub    $0x30,%eax
  800e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e44:	eb 42                	jmp    800e88 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	3c 60                	cmp    $0x60,%al
  800e4d:	7e 19                	jle    800e68 <strtol+0xe4>
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3c 7a                	cmp    $0x7a,%al
  800e56:	7f 10                	jg     800e68 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f be c0             	movsbl %al,%eax
  800e60:	83 e8 57             	sub    $0x57,%eax
  800e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e66:	eb 20                	jmp    800e88 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 40                	cmp    $0x40,%al
  800e6f:	7e 39                	jle    800eaa <strtol+0x126>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 5a                	cmp    $0x5a,%al
  800e78:	7f 30                	jg     800eaa <strtol+0x126>
			dig = *s - 'A' + 10;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f be c0             	movsbl %al,%eax
  800e82:	83 e8 37             	sub    $0x37,%eax
  800e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e8e:	7d 19                	jge    800ea9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e90:	ff 45 08             	incl   0x8(%ebp)
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e9f:	01 d0                	add    %edx,%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ea4:	e9 7b ff ff ff       	jmp    800e24 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ea9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eaa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eae:	74 08                	je     800eb8 <strtol+0x134>
		*endptr = (char *) s;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ebc:	74 07                	je     800ec5 <strtol+0x141>
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	f7 d8                	neg    %eax
  800ec3:	eb 03                	jmp    800ec8 <strtol+0x144>
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <ltostr>:

void
ltostr(long value, char *str)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ed7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee2:	79 13                	jns    800ef7 <ltostr+0x2d>
	{
		neg = 1;
  800ee4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ef1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ef4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eff:	99                   	cltd   
  800f00:	f7 f9                	idiv   %ecx
  800f02:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	89 c2                	mov    %eax,%edx
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f18:	83 c2 30             	add    $0x30,%edx
  800f1b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f20:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f25:	f7 e9                	imul   %ecx
  800f27:	c1 fa 02             	sar    $0x2,%edx
  800f2a:	89 c8                	mov    %ecx,%eax
  800f2c:	c1 f8 1f             	sar    $0x1f,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
  800f33:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3a:	75 bb                	jne    800ef7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f46:	48                   	dec    %eax
  800f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f4e:	74 3d                	je     800f8d <ltostr+0xc3>
		start = 1 ;
  800f50:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f57:	eb 34                	jmp    800f8d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	01 d0                	add    %edx,%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c2                	add    %eax,%edx
  800f6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	01 c8                	add    %ecx,%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	01 c2                	add    %eax,%edx
  800f82:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f85:	88 02                	mov    %al,(%edx)
		start++ ;
  800f87:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f8a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f93:	7c c4                	jl     800f59 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f95:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	01 d0                	add    %edx,%eax
  800f9d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa0:	90                   	nop
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa9:	ff 75 08             	pushl  0x8(%ebp)
  800fac:	e8 73 fa ff ff       	call   800a24 <strlen>
  800fb1:	83 c4 04             	add    $0x4,%esp
  800fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	e8 65 fa ff ff       	call   800a24 <strlen>
  800fbf:	83 c4 04             	add    $0x4,%esp
  800fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd3:	eb 17                	jmp    800fec <strcconcat+0x49>
		final[s] = str1[s] ;
  800fd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	01 c2                	add    %eax,%edx
  800fdd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	01 c8                	add    %ecx,%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe9:	ff 45 fc             	incl   -0x4(%ebp)
  800fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff2:	7c e1                	jl     800fd5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ffb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801002:	eb 1f                	jmp    801023 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801004:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100d:	89 c2                	mov    %eax,%edx
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	01 c2                	add    %eax,%edx
  801014:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	01 c8                	add    %ecx,%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801020:	ff 45 f8             	incl   -0x8(%ebp)
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801029:	7c d9                	jl     801004 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80102b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	01 d0                	add    %edx,%eax
  801033:	c6 00 00             	movb   $0x0,(%eax)
}
  801036:	90                   	nop
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80103c:	8b 45 14             	mov    0x14(%ebp),%eax
  80103f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801045:	8b 45 14             	mov    0x14(%ebp),%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80105c:	eb 0c                	jmp    80106a <strsplit+0x31>
			*string++ = 0;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8d 50 01             	lea    0x1(%eax),%edx
  801064:	89 55 08             	mov    %edx,0x8(%ebp)
  801067:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	84 c0                	test   %al,%al
  801071:	74 18                	je     80108b <strsplit+0x52>
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f be c0             	movsbl %al,%eax
  80107b:	50                   	push   %eax
  80107c:	ff 75 0c             	pushl  0xc(%ebp)
  80107f:	e8 32 fb ff ff       	call   800bb6 <strchr>
  801084:	83 c4 08             	add    $0x8,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	75 d3                	jne    80105e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 5a                	je     8010ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801094:	8b 45 14             	mov    0x14(%ebp),%eax
  801097:	8b 00                	mov    (%eax),%eax
  801099:	83 f8 0f             	cmp    $0xf,%eax
  80109c:	75 07                	jne    8010a5 <strsplit+0x6c>
		{
			return 0;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a3:	eb 66                	jmp    80110b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b0:	89 0a                	mov    %ecx,(%edx)
  8010b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	01 c2                	add    %eax,%edx
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c3:	eb 03                	jmp    8010c8 <strsplit+0x8f>
			string++;
  8010c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	84 c0                	test   %al,%al
  8010cf:	74 8b                	je     80105c <strsplit+0x23>
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	0f be c0             	movsbl %al,%eax
  8010d9:	50                   	push   %eax
  8010da:	ff 75 0c             	pushl  0xc(%ebp)
  8010dd:	e8 d4 fa ff ff       	call   800bb6 <strchr>
  8010e2:	83 c4 08             	add    $0x8,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	74 dc                	je     8010c5 <strsplit+0x8c>
			string++;
	}
  8010e9:	e9 6e ff ff ff       	jmp    80105c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fe:	01 d0                	add    %edx,%eax
  801100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801106:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801113:	83 ec 04             	sub    $0x4,%esp
  801116:	68 e8 40 80 00       	push   $0x8040e8
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 0a 41 80 00       	push   $0x80410a
  801125:	e8 c1 26 00 00       	call   8037eb <_panic>

0080112a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	e8 9d 0a 00 00       	call   801bd8 <sys_sbrk>
  80113b:	83 c4 10             	add    $0x10,%esp
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114a:	75 0a                	jne    801156 <malloc+0x16>
  80114c:	b8 00 00 00 00       	mov    $0x0,%eax
  801151:	e9 07 02 00 00       	jmp    80135d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801156:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	48                   	dec    %eax
  801166:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801169:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80116c:	ba 00 00 00 00       	mov    $0x0,%edx
  801171:	f7 75 dc             	divl   -0x24(%ebp)
  801174:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801177:	29 d0                	sub    %edx,%eax
  801179:	c1 e8 0c             	shr    $0xc,%eax
  80117c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80117f:	a1 20 50 80 00       	mov    0x805020,%eax
  801184:	8b 40 78             	mov    0x78(%eax),%eax
  801187:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80118c:	29 c2                	sub    %eax,%edx
  80118e:	89 d0                	mov    %edx,%eax
  801190:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801193:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119b:	c1 e8 0c             	shr    $0xc,%eax
  80119e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8011a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8011a8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8011af:	77 42                	ja     8011f3 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8011b1:	e8 a6 08 00 00       	call   801a5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 e6 0d 00 00       	call   801fab <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 b8 08 00 00       	call   801a8d <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 7f 12 00 00       	call   802467 <alloc_block_BF>
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ee:	e9 67 01 00 00       	jmp    80135a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8011f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011f6:	48                   	dec    %eax
  8011f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8011fa:	0f 86 53 01 00 00    	jbe    801353 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801200:	a1 20 50 80 00       	mov    0x805020,%eax
  801205:	8b 40 78             	mov    0x78(%eax),%eax
  801208:	05 00 10 00 00       	add    $0x1000,%eax
  80120d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801210:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801217:	e9 de 00 00 00       	jmp    8012fa <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 40 78             	mov    0x78(%eax),%eax
  801224:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801227:	29 c2                	sub    %eax,%edx
  801229:	89 d0                	mov    %edx,%eax
  80122b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801230:	c1 e8 0c             	shr    $0xc,%eax
  801233:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80123a:	85 c0                	test   %eax,%eax
  80123c:	0f 85 ab 00 00 00    	jne    8012ed <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80124d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801254:	eb 47                	jmp    80129d <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801256:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80125d:	76 0a                	jbe    801269 <malloc+0x129>
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	e9 f4 00 00 00       	jmp    80135d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801269:	a1 20 50 80 00       	mov    0x805020,%eax
  80126e:	8b 40 78             	mov    0x78(%eax),%eax
  801271:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801274:	29 c2                	sub    %eax,%edx
  801276:	89 d0                	mov    %edx,%eax
  801278:	2d 00 10 00 00       	sub    $0x1000,%eax
  80127d:	c1 e8 0c             	shr    $0xc,%eax
  801280:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801287:	85 c0                	test   %eax,%eax
  801289:	74 08                	je     801293 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80128b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80128e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801291:	eb 5a                	jmp    8012ed <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801293:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80129a:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80129d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012a0:	48                   	dec    %eax
  8012a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012a4:	77 b0                	ja     801256 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8012a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8012ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8012b4:	eb 2f                	jmp    8012e5 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8012b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b9:	c1 e0 0c             	shl    $0xc,%eax
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c8:	8b 40 78             	mov    0x78(%eax),%eax
  8012cb:	29 c2                	sub    %eax,%edx
  8012cd:	89 d0                	mov    %edx,%eax
  8012cf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012d4:	c1 e8 0c             	shr    $0xc,%eax
  8012d7:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8012de:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8012e2:	ff 45 e0             	incl   -0x20(%ebp)
  8012e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8012eb:	72 c9                	jb     8012b6 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8012ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f1:	75 16                	jne    801309 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012f3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012fa:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801301:	0f 86 15 ff ff ff    	jbe    80121c <malloc+0xdc>
  801307:	eb 01                	jmp    80130a <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801309:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80130a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130e:	75 07                	jne    801317 <malloc+0x1d7>
  801310:	b8 00 00 00 00       	mov    $0x0,%eax
  801315:	eb 46                	jmp    80135d <malloc+0x21d>
		ptr = (void*)i;
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80131d:	a1 20 50 80 00       	mov    0x805020,%eax
  801322:	8b 40 78             	mov    0x78(%eax),%eax
  801325:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801328:	29 c2                	sub    %eax,%edx
  80132a:	89 d0                	mov    %edx,%eax
  80132c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801331:	c1 e8 0c             	shr    $0xc,%eax
  801334:	89 c2                	mov    %eax,%edx
  801336:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801339:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	ff 75 f0             	pushl  -0x10(%ebp)
  801349:	e8 c1 08 00 00       	call   801c0f <sys_allocate_user_mem>
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	eb 07                	jmp    80135a <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	eb 03                	jmp    80135d <malloc+0x21d>
	}
	return ptr;
  80135a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801365:	a1 20 50 80 00       	mov    0x805020,%eax
  80136a:	8b 40 78             	mov    0x78(%eax),%eax
  80136d:	05 00 10 00 00       	add    $0x1000,%eax
  801372:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80137c:	a1 20 50 80 00       	mov    0x805020,%eax
  801381:	8b 50 78             	mov    0x78(%eax),%edx
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	39 c2                	cmp    %eax,%edx
  801389:	76 24                	jbe    8013af <free+0x50>
		size = get_block_size(va);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	ff 75 08             	pushl  0x8(%ebp)
  801391:	e8 95 08 00 00       	call   801c2b <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 c8 1a 00 00       	call   802e6f <free_block>
  8013a7:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8013aa:	e9 ac 00 00 00       	jmp    80145b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b5:	0f 82 89 00 00 00    	jb     801444 <free+0xe5>
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8013c3:	77 7f                	ja     801444 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8013c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8013cd:	8b 40 78             	mov    0x78(%eax),%eax
  8013d0:	29 c2                	sub    %eax,%edx
  8013d2:	89 d0                	mov    %edx,%eax
  8013d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d9:	c1 e8 0c             	shr    $0xc,%eax
  8013dc:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8013e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8013e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e9:	c1 e0 0c             	shl    $0xc,%eax
  8013ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8013ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f6:	eb 2f                	jmp    801427 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8013f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fb:	c1 e0 0c             	shl    $0xc,%eax
  8013fe:	89 c2                	mov    %eax,%edx
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	01 c2                	add    %eax,%edx
  801405:	a1 20 50 80 00       	mov    0x805020,%eax
  80140a:	8b 40 78             	mov    0x78(%eax),%eax
  80140d:	29 c2                	sub    %eax,%edx
  80140f:	89 d0                	mov    %edx,%eax
  801411:	2d 00 10 00 00       	sub    $0x1000,%eax
  801416:	c1 e8 0c             	shr    $0xc,%eax
  801419:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801420:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801424:	ff 45 f4             	incl   -0xc(%ebp)
  801427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80142d:	72 c9                	jb     8013f8 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	ff 75 ec             	pushl  -0x14(%ebp)
  801438:	50                   	push   %eax
  801439:	e8 b5 07 00 00       	call   801bf3 <sys_free_user_mem>
  80143e:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801441:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801442:	eb 17                	jmp    80145b <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	68 18 41 80 00       	push   $0x804118
  80144c:	68 84 00 00 00       	push   $0x84
  801451:	68 42 41 80 00       	push   $0x804142
  801456:	e8 90 23 00 00       	call   8037eb <_panic>
	}
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 28             	sub    $0x28,%esp
  801463:	8b 45 10             	mov    0x10(%ebp),%eax
  801466:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801469:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146d:	75 07                	jne    801476 <smalloc+0x19>
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
  801474:	eb 74                	jmp    8014ea <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801483:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801489:	39 d0                	cmp    %edx,%eax
  80148b:	73 02                	jae    80148f <smalloc+0x32>
  80148d:	89 d0                	mov    %edx,%eax
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	50                   	push   %eax
  801493:	e8 a8 fc ff ff       	call   801140 <malloc>
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80149e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a2:	75 07                	jne    8014ab <smalloc+0x4e>
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	eb 3f                	jmp    8014ea <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014ab:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014af:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	e8 3c 03 00 00       	call   8017fa <sys_createSharedObject>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014c8:	74 06                	je     8014d0 <smalloc+0x73>
  8014ca:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014ce:	75 07                	jne    8014d7 <smalloc+0x7a>
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 13                	jmp    8014ea <smalloc+0x8d>
	 cprintf("153\n");
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	68 4e 41 80 00       	push   $0x80414e
  8014df:	e8 ac ee ff ff       	call   800390 <cprintf>
  8014e4:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8014e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	e8 24 03 00 00       	call   801824 <sys_getSizeOfSharedObject>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801506:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80150a:	75 07                	jne    801513 <sget+0x27>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	eb 5c                	jmp    80156f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	39 d0                	cmp    %edx,%eax
  801528:	7d 02                	jge    80152c <sget+0x40>
  80152a:	89 d0                	mov    %edx,%eax
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	50                   	push   %eax
  801530:	e8 0b fc ff ff       	call   801140 <malloc>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80153b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80153f:	75 07                	jne    801548 <sget+0x5c>
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	eb 27                	jmp    80156f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	ff 75 e8             	pushl  -0x18(%ebp)
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	e8 e8 02 00 00       	call   801841 <sys_getSharedObject>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80155f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801563:	75 07                	jne    80156c <sget+0x80>
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
  80156a:	eb 03                	jmp    80156f <sget+0x83>
	return ptr;
  80156c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	68 54 41 80 00       	push   $0x804154
  80157f:	68 c2 00 00 00       	push   $0xc2
  801584:	68 42 41 80 00       	push   $0x804142
  801589:	e8 5d 22 00 00       	call   8037eb <_panic>

0080158e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 78 41 80 00       	push   $0x804178
  80159c:	68 d9 00 00 00       	push   $0xd9
  8015a1:	68 42 41 80 00       	push   $0x804142
  8015a6:	e8 40 22 00 00       	call   8037eb <_panic>

008015ab <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	68 9e 41 80 00       	push   $0x80419e
  8015b9:	68 e5 00 00 00       	push   $0xe5
  8015be:	68 42 41 80 00       	push   $0x804142
  8015c3:	e8 23 22 00 00       	call   8037eb <_panic>

008015c8 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	68 9e 41 80 00       	push   $0x80419e
  8015d6:	68 ea 00 00 00       	push   $0xea
  8015db:	68 42 41 80 00       	push   $0x804142
  8015e0:	e8 06 22 00 00       	call   8037eb <_panic>

008015e5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 9e 41 80 00       	push   $0x80419e
  8015f3:	68 ef 00 00 00       	push   $0xef
  8015f8:	68 42 41 80 00       	push   $0x804142
  8015fd:	e8 e9 21 00 00       	call   8037eb <_panic>

00801602 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	57                   	push   %edi
  801606:	56                   	push   %esi
  801607:	53                   	push   %ebx
  801608:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801614:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801617:	8b 7d 18             	mov    0x18(%ebp),%edi
  80161a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161d:	cd 30                	int    $0x30
  80161f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	5b                   	pop    %ebx
  801629:	5e                   	pop    %esi
  80162a:	5f                   	pop    %edi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 04             	sub    $0x4,%esp
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801639:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	52                   	push   %edx
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	50                   	push   %eax
  801649:	6a 00                	push   $0x0
  80164b:	e8 b2 ff ff ff       	call   801602 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	90                   	nop
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <sys_cgetc>:

int
sys_cgetc(void)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 02                	push   $0x2
  801665:	e8 98 ff ff ff       	call   801602 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 03                	push   $0x3
  80167e:	e8 7f ff ff ff       	call   801602 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 04                	push   $0x4
  801698:	e8 65 ff ff ff       	call   801602 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	6a 08                	push   $0x8
  8016b6:	e8 47 ff ff ff       	call   801602 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	51                   	push   %ecx
  8016d7:	52                   	push   %edx
  8016d8:	50                   	push   %eax
  8016d9:	6a 09                	push   $0x9
  8016db:	e8 22 ff ff ff       	call   801602 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	6a 0a                	push   $0xa
  8016fd:	e8 00 ff ff ff       	call   801602 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	6a 0b                	push   $0xb
  801718:	e8 e5 fe ff ff       	call   801602 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 0c                	push   $0xc
  801731:	e8 cc fe ff ff       	call   801602 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 0d                	push   $0xd
  80174a:	e8 b3 fe ff ff       	call   801602 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 0e                	push   $0xe
  801763:	e8 9a fe ff ff       	call   801602 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 0f                	push   $0xf
  80177c:	e8 81 fe ff ff       	call   801602 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	6a 10                	push   $0x10
  801796:	e8 67 fe ff ff       	call   801602 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 11                	push   $0x11
  8017af:	e8 4e fe ff ff       	call   801602 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_cputc>:

void
sys_cputc(const char c)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	50                   	push   %eax
  8017d3:	6a 01                	push   $0x1
  8017d5:	e8 28 fe ff ff       	call   801602 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 14                	push   $0x14
  8017ef:	e8 0e fe ff ff       	call   801602 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	8b 45 10             	mov    0x10(%ebp),%eax
  801803:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801806:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801809:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	51                   	push   %ecx
  801813:	52                   	push   %edx
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	6a 15                	push   $0x15
  80181a:	e8 e3 fd ff ff       	call   801602 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	6a 16                	push   $0x16
  801837:	e8 c6 fd ff ff       	call   801602 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	51                   	push   %ecx
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 17                	push   $0x17
  801856:	e8 a7 fd ff ff       	call   801602 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 18                	push   $0x18
  801873:	e8 8a fd ff ff       	call   801602 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	ff 75 14             	pushl  0x14(%ebp)
  801888:	ff 75 10             	pushl  0x10(%ebp)
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	50                   	push   %eax
  80188f:	6a 19                	push   $0x19
  801891:	e8 6c fd ff ff       	call   801602 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	50                   	push   %eax
  8018aa:	6a 1a                	push   $0x1a
  8018ac:	e8 51 fd ff ff       	call   801602 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	50                   	push   %eax
  8018c6:	6a 1b                	push   $0x1b
  8018c8:	e8 35 fd ff ff       	call   801602 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 05                	push   $0x5
  8018e1:	e8 1c fd ff ff       	call   801602 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 06                	push   $0x6
  8018fa:	e8 03 fd ff ff       	call   801602 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 07                	push   $0x7
  801913:	e8 ea fc ff ff       	call   801602 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_exit_env>:


void sys_exit_env(void)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 1c                	push   $0x1c
  80192c:	e8 d1 fc ff ff       	call   801602 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	90                   	nop
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80193d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801940:	8d 50 04             	lea    0x4(%eax),%edx
  801943:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 1d                	push   $0x1d
  801950:	e8 ad fc ff ff       	call   801602 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return result;
  801958:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801961:	89 01                	mov    %eax,(%ecx)
  801963:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	c9                   	leave  
  80196a:	c2 04 00             	ret    $0x4

0080196d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 10             	pushl  0x10(%ebp)
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	ff 75 08             	pushl  0x8(%ebp)
  80197d:	6a 13                	push   $0x13
  80197f:	e8 7e fc ff ff       	call   801602 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return ;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_rcr2>:
uint32 sys_rcr2()
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 1e                	push   $0x1e
  801999:	e8 64 fc ff ff       	call   801602 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019af:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	50                   	push   %eax
  8019bc:	6a 1f                	push   $0x1f
  8019be:	e8 3f fc ff ff       	call   801602 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <rsttst>:
void rsttst()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 21                	push   $0x21
  8019d8:	e8 25 fc ff ff       	call   801602 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019ef:	8b 55 18             	mov    0x18(%ebp),%edx
  8019f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f6:	52                   	push   %edx
  8019f7:	50                   	push   %eax
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 20                	push   $0x20
  801a03:	e8 fa fb ff ff       	call   801602 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0b:	90                   	nop
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <chktst>:
void chktst(uint32 n)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 22                	push   $0x22
  801a1e:	e8 df fb ff ff       	call   801602 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <inctst>:

void inctst()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 23                	push   $0x23
  801a38:	e8 c5 fb ff ff       	call   801602 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <gettst>:
uint32 gettst()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 24                	push   $0x24
  801a52:	e8 ab fb ff ff       	call   801602 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 25                	push   $0x25
  801a6e:	e8 8f fb ff ff       	call   801602 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
  801a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a79:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a7d:	75 07                	jne    801a86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a84:	eb 05                	jmp    801a8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 25                	push   $0x25
  801a9f:	e8 5e fb ff ff       	call   801602 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
  801aa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aaa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aae:	75 07                	jne    801ab7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ab0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab5:	eb 05                	jmp    801abc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 25                	push   $0x25
  801ad0:	e8 2d fb ff ff       	call   801602 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
  801ad8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801adb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801adf:	75 07                	jne    801ae8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ae1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae6:	eb 05                	jmp    801aed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 25                	push   $0x25
  801b01:	e8 fc fa ff ff       	call   801602 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
  801b09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b0c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b10:	75 07                	jne    801b19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b12:	b8 01 00 00 00       	mov    $0x1,%eax
  801b17:	eb 05                	jmp    801b1e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	6a 26                	push   $0x26
  801b30:	e8 cd fa ff ff       	call   801602 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
	return ;
  801b38:	90                   	nop
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	53                   	push   %ebx
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 27                	push   $0x27
  801b53:	e8 aa fa ff ff       	call   801602 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 28                	push   $0x28
  801b73:	e8 8a fa ff ff       	call   801602 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	51                   	push   %ecx
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 29                	push   $0x29
  801b93:	e8 6a fa ff ff       	call   801602 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	6a 12                	push   $0x12
  801baf:	e8 4e fa ff ff       	call   801602 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 2a                	push   $0x2a
  801bcd:	e8 30 fa ff ff       	call   801602 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	50                   	push   %eax
  801be7:	6a 2b                	push   $0x2b
  801be9:	e8 14 fa ff ff       	call   801602 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	6a 2c                	push   $0x2c
  801c04:	e8 f9 f9 ff ff       	call   801602 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	ff 75 08             	pushl  0x8(%ebp)
  801c1e:	6a 2d                	push   $0x2d
  801c20:	e8 dd f9 ff ff       	call   801602 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return;
  801c28:	90                   	nop
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	83 e8 04             	sub    $0x4,%eax
  801c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c3d:	8b 00                	mov    (%eax),%eax
  801c3f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	83 e8 04             	sub    $0x4,%eax
  801c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c56:	8b 00                	mov    (%eax),%eax
  801c58:	83 e0 01             	and    $0x1,%eax
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	0f 94 c0             	sete   %al
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c72:	83 f8 02             	cmp    $0x2,%eax
  801c75:	74 2b                	je     801ca2 <alloc_block+0x40>
  801c77:	83 f8 02             	cmp    $0x2,%eax
  801c7a:	7f 07                	jg     801c83 <alloc_block+0x21>
  801c7c:	83 f8 01             	cmp    $0x1,%eax
  801c7f:	74 0e                	je     801c8f <alloc_block+0x2d>
  801c81:	eb 58                	jmp    801cdb <alloc_block+0x79>
  801c83:	83 f8 03             	cmp    $0x3,%eax
  801c86:	74 2d                	je     801cb5 <alloc_block+0x53>
  801c88:	83 f8 04             	cmp    $0x4,%eax
  801c8b:	74 3b                	je     801cc8 <alloc_block+0x66>
  801c8d:	eb 4c                	jmp    801cdb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 11 03 00 00       	call   801fab <alloc_block_FF>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ca0:	eb 4a                	jmp    801cec <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	ff 75 08             	pushl  0x8(%ebp)
  801ca8:	e8 fa 19 00 00       	call   8036a7 <alloc_block_NF>
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cb3:	eb 37                	jmp    801cec <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	ff 75 08             	pushl  0x8(%ebp)
  801cbb:	e8 a7 07 00 00       	call   802467 <alloc_block_BF>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cc6:	eb 24                	jmp    801cec <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	e8 b7 19 00 00       	call   80368a <alloc_block_WF>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cd9:	eb 11                	jmp    801cec <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	68 b0 41 80 00       	push   $0x8041b0
  801ce3:	e8 a8 e6 ff ff       	call   800390 <cprintf>
  801ce8:	83 c4 10             	add    $0x10,%esp
		break;
  801ceb:	90                   	nop
	}
	return va;
  801cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801cf8:	83 ec 0c             	sub    $0xc,%esp
  801cfb:	68 d0 41 80 00       	push   $0x8041d0
  801d00:	e8 8b e6 ff ff       	call   800390 <cprintf>
  801d05:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d08:	83 ec 0c             	sub    $0xc,%esp
  801d0b:	68 fb 41 80 00       	push   $0x8041fb
  801d10:	e8 7b e6 ff ff       	call   800390 <cprintf>
  801d15:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1e:	eb 37                	jmp    801d57 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	ff 75 f4             	pushl  -0xc(%ebp)
  801d26:	e8 19 ff ff ff       	call   801c44 <is_free_block>
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	0f be d8             	movsbl %al,%ebx
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	ff 75 f4             	pushl  -0xc(%ebp)
  801d37:	e8 ef fe ff ff       	call   801c2b <get_block_size>
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	53                   	push   %ebx
  801d43:	50                   	push   %eax
  801d44:	68 13 42 80 00       	push   $0x804213
  801d49:	e8 42 e6 ff ff       	call   800390 <cprintf>
  801d4e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d51:	8b 45 10             	mov    0x10(%ebp),%eax
  801d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5b:	74 07                	je     801d64 <print_blocks_list+0x73>
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 00                	mov    (%eax),%eax
  801d62:	eb 05                	jmp    801d69 <print_blocks_list+0x78>
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
  801d69:	89 45 10             	mov    %eax,0x10(%ebp)
  801d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	75 ad                	jne    801d20 <print_blocks_list+0x2f>
  801d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d77:	75 a7                	jne    801d20 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	68 d0 41 80 00       	push   $0x8041d0
  801d81:	e8 0a e6 ff ff       	call   800390 <cprintf>
  801d86:	83 c4 10             	add    $0x10,%esp

}
  801d89:	90                   	nop
  801d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	83 e0 01             	and    $0x1,%eax
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	74 03                	je     801da2 <initialize_dynamic_allocator+0x13>
  801d9f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801da2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da6:	0f 84 c7 01 00 00    	je     801f73 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801dac:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801db3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801db6:	8b 55 08             	mov    0x8(%ebp),%edx
  801db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbc:	01 d0                	add    %edx,%eax
  801dbe:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801dc3:	0f 87 ad 01 00 00    	ja     801f76 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	0f 89 a5 01 00 00    	jns    801f79 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dda:	01 d0                	add    %edx,%eax
  801ddc:	83 e8 04             	sub    $0x4,%eax
  801ddf:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801deb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df3:	e9 87 00 00 00       	jmp    801e7f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfc:	75 14                	jne    801e12 <initialize_dynamic_allocator+0x83>
  801dfe:	83 ec 04             	sub    $0x4,%esp
  801e01:	68 2b 42 80 00       	push   $0x80422b
  801e06:	6a 79                	push   $0x79
  801e08:	68 49 42 80 00       	push   $0x804249
  801e0d:	e8 d9 19 00 00       	call   8037eb <_panic>
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	74 10                	je     801e2b <initialize_dynamic_allocator+0x9c>
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 00                	mov    (%eax),%eax
  801e20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e23:	8b 52 04             	mov    0x4(%edx),%edx
  801e26:	89 50 04             	mov    %edx,0x4(%eax)
  801e29:	eb 0b                	jmp    801e36 <initialize_dynamic_allocator+0xa7>
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	8b 40 04             	mov    0x4(%eax),%eax
  801e31:	a3 30 50 80 00       	mov    %eax,0x805030
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 40 04             	mov    0x4(%eax),%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 0f                	je     801e4f <initialize_dynamic_allocator+0xc0>
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 40 04             	mov    0x4(%eax),%eax
  801e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e49:	8b 12                	mov    (%edx),%edx
  801e4b:	89 10                	mov    %edx,(%eax)
  801e4d:	eb 0a                	jmp    801e59 <initialize_dynamic_allocator+0xca>
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	8b 00                	mov    (%eax),%eax
  801e54:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6c:	a1 38 50 80 00       	mov    0x805038,%eax
  801e71:	48                   	dec    %eax
  801e72:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e77:	a1 34 50 80 00       	mov    0x805034,%eax
  801e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e83:	74 07                	je     801e8c <initialize_dynamic_allocator+0xfd>
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 00                	mov    (%eax),%eax
  801e8a:	eb 05                	jmp    801e91 <initialize_dynamic_allocator+0x102>
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	a3 34 50 80 00       	mov    %eax,0x805034
  801e96:	a1 34 50 80 00       	mov    0x805034,%eax
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	0f 85 55 ff ff ff    	jne    801df8 <initialize_dynamic_allocator+0x69>
  801ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea7:	0f 85 4b ff ff ff    	jne    801df8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ebc:	a1 44 50 80 00       	mov    0x805044,%eax
  801ec1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801ec6:	a1 40 50 80 00       	mov    0x805040,%eax
  801ecb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	83 c0 08             	add    $0x8,%eax
  801ed7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	83 c0 04             	add    $0x4,%eax
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	83 ea 08             	sub    $0x8,%edx
  801ee6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	83 e8 08             	sub    $0x8,%eax
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	83 ea 08             	sub    $0x8,%edx
  801ef9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f12:	75 17                	jne    801f2b <initialize_dynamic_allocator+0x19c>
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 64 42 80 00       	push   $0x804264
  801f1c:	68 90 00 00 00       	push   $0x90
  801f21:	68 49 42 80 00       	push   $0x804249
  801f26:	e8 c0 18 00 00       	call   8037eb <_panic>
  801f2b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f34:	89 10                	mov    %edx,(%eax)
  801f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f39:	8b 00                	mov    (%eax),%eax
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	74 0d                	je     801f4c <initialize_dynamic_allocator+0x1bd>
  801f3f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f47:	89 50 04             	mov    %edx,0x4(%eax)
  801f4a:	eb 08                	jmp    801f54 <initialize_dynamic_allocator+0x1c5>
  801f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4f:	a3 30 50 80 00       	mov    %eax,0x805030
  801f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f66:	a1 38 50 80 00       	mov    0x805038,%eax
  801f6b:	40                   	inc    %eax
  801f6c:	a3 38 50 80 00       	mov    %eax,0x805038
  801f71:	eb 07                	jmp    801f7a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f73:	90                   	nop
  801f74:	eb 04                	jmp    801f7a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f76:	90                   	nop
  801f77:	eb 01                	jmp    801f7a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f79:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f82:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	83 e8 04             	sub    $0x4,%eax
  801f96:	8b 00                	mov    (%eax),%eax
  801f98:	83 e0 fe             	and    $0xfffffffe,%eax
  801f9b:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	01 c2                	add    %eax,%edx
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	89 02                	mov    %eax,(%edx)
}
  801fa8:	90                   	nop
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	83 e0 01             	and    $0x1,%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	74 03                	je     801fbe <alloc_block_FF+0x13>
  801fbb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fbe:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fc2:	77 07                	ja     801fcb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fc4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fcb:	a1 24 50 80 00       	mov    0x805024,%eax
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	75 73                	jne    802047 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	83 c0 10             	add    $0x10,%eax
  801fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801fdd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fea:	01 d0                	add    %edx,%eax
  801fec:	48                   	dec    %eax
  801fed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff8:	f7 75 ec             	divl   -0x14(%ebp)
  801ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ffe:	29 d0                	sub    %edx,%eax
  802000:	c1 e8 0c             	shr    $0xc,%eax
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	50                   	push   %eax
  802007:	e8 1e f1 ff ff       	call   80112a <sbrk>
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	6a 00                	push   $0x0
  802017:	e8 0e f1 ff ff       	call   80112a <sbrk>
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802025:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	50                   	push   %eax
  80202c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80202f:	e8 5b fd ff ff       	call   801d8f <initialize_dynamic_allocator>
  802034:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802037:	83 ec 0c             	sub    $0xc,%esp
  80203a:	68 87 42 80 00       	push   $0x804287
  80203f:	e8 4c e3 ff ff       	call   800390 <cprintf>
  802044:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802047:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204b:	75 0a                	jne    802057 <alloc_block_FF+0xac>
	        return NULL;
  80204d:	b8 00 00 00 00       	mov    $0x0,%eax
  802052:	e9 0e 04 00 00       	jmp    802465 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80205e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802063:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802066:	e9 f3 02 00 00       	jmp    80235e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	ff 75 bc             	pushl  -0x44(%ebp)
  802077:	e8 af fb ff ff       	call   801c2b <get_block_size>
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	83 c0 08             	add    $0x8,%eax
  802088:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80208b:	0f 87 c5 02 00 00    	ja     802356 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	83 c0 18             	add    $0x18,%eax
  802097:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80209a:	0f 87 19 02 00 00    	ja     8022b9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8020a6:	83 e8 08             	sub    $0x8,%eax
  8020a9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8d 50 08             	lea    0x8(%eax),%edx
  8020b2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	83 c0 08             	add    $0x8,%eax
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	6a 01                	push   $0x1
  8020c5:	50                   	push   %eax
  8020c6:	ff 75 bc             	pushl  -0x44(%ebp)
  8020c9:	e8 ae fe ff ff       	call   801f7c <set_block_data>
  8020ce:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 40 04             	mov    0x4(%eax),%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	75 68                	jne    802143 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020db:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020df:	75 17                	jne    8020f8 <alloc_block_FF+0x14d>
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 64 42 80 00       	push   $0x804264
  8020e9:	68 d7 00 00 00       	push   $0xd7
  8020ee:	68 49 42 80 00       	push   $0x804249
  8020f3:	e8 f3 16 00 00       	call   8037eb <_panic>
  8020f8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802101:	89 10                	mov    %edx,(%eax)
  802103:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	74 0d                	je     802119 <alloc_block_FF+0x16e>
  80210c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802111:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802114:	89 50 04             	mov    %edx,0x4(%eax)
  802117:	eb 08                	jmp    802121 <alloc_block_FF+0x176>
  802119:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211c:	a3 30 50 80 00       	mov    %eax,0x805030
  802121:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802124:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802129:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802133:	a1 38 50 80 00       	mov    0x805038,%eax
  802138:	40                   	inc    %eax
  802139:	a3 38 50 80 00       	mov    %eax,0x805038
  80213e:	e9 dc 00 00 00       	jmp    80221f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 65                	jne    8021b1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80214c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802150:	75 17                	jne    802169 <alloc_block_FF+0x1be>
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	68 98 42 80 00       	push   $0x804298
  80215a:	68 db 00 00 00       	push   $0xdb
  80215f:	68 49 42 80 00       	push   $0x804249
  802164:	e8 82 16 00 00       	call   8037eb <_panic>
  802169:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80216f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802172:	89 50 04             	mov    %edx,0x4(%eax)
  802175:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802178:	8b 40 04             	mov    0x4(%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0c                	je     80218b <alloc_block_FF+0x1e0>
  80217f:	a1 30 50 80 00       	mov    0x805030,%eax
  802184:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802187:	89 10                	mov    %edx,(%eax)
  802189:	eb 08                	jmp    802193 <alloc_block_FF+0x1e8>
  80218b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802193:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802196:	a3 30 50 80 00       	mov    %eax,0x805030
  80219b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a9:	40                   	inc    %eax
  8021aa:	a3 38 50 80 00       	mov    %eax,0x805038
  8021af:	eb 6e                	jmp    80221f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b5:	74 06                	je     8021bd <alloc_block_FF+0x212>
  8021b7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021bb:	75 17                	jne    8021d4 <alloc_block_FF+0x229>
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	68 bc 42 80 00       	push   $0x8042bc
  8021c5:	68 df 00 00 00       	push   $0xdf
  8021ca:	68 49 42 80 00       	push   $0x804249
  8021cf:	e8 17 16 00 00       	call   8037eb <_panic>
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 10                	mov    (%eax),%edx
  8021d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
  8021de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0b                	je     8021f2 <alloc_block_FF+0x247>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021ef:	89 50 04             	mov    %edx,0x4(%eax)
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f8:	89 10                	mov    %edx,(%eax)
  8021fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802200:	89 50 04             	mov    %edx,0x4(%eax)
  802203:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802206:	8b 00                	mov    (%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	75 08                	jne    802214 <alloc_block_FF+0x269>
  80220c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80220f:	a3 30 50 80 00       	mov    %eax,0x805030
  802214:	a1 38 50 80 00       	mov    0x805038,%eax
  802219:	40                   	inc    %eax
  80221a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80221f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802223:	75 17                	jne    80223c <alloc_block_FF+0x291>
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 2b 42 80 00       	push   $0x80422b
  80222d:	68 e1 00 00 00       	push   $0xe1
  802232:	68 49 42 80 00       	push   $0x804249
  802237:	e8 af 15 00 00       	call   8037eb <_panic>
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 10                	je     802255 <alloc_block_FF+0x2aa>
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224d:	8b 52 04             	mov    0x4(%edx),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	eb 0b                	jmp    802260 <alloc_block_FF+0x2b5>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	a3 30 50 80 00       	mov    %eax,0x805030
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 04             	mov    0x4(%eax),%eax
  802266:	85 c0                	test   %eax,%eax
  802268:	74 0f                	je     802279 <alloc_block_FF+0x2ce>
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 40 04             	mov    0x4(%eax),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	8b 12                	mov    (%edx),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	eb 0a                	jmp    802283 <alloc_block_FF+0x2d8>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802296:	a1 38 50 80 00       	mov    0x805038,%eax
  80229b:	48                   	dec    %eax
  80229c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	6a 00                	push   $0x0
  8022a6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022a9:	ff 75 b0             	pushl  -0x50(%ebp)
  8022ac:	e8 cb fc ff ff       	call   801f7c <set_block_data>
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	e9 95 00 00 00       	jmp    80234e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	6a 01                	push   $0x1
  8022be:	ff 75 b8             	pushl  -0x48(%ebp)
  8022c1:	ff 75 bc             	pushl  -0x44(%ebp)
  8022c4:	e8 b3 fc ff ff       	call   801f7c <set_block_data>
  8022c9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d0:	75 17                	jne    8022e9 <alloc_block_FF+0x33e>
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	68 2b 42 80 00       	push   $0x80422b
  8022da:	68 e8 00 00 00       	push   $0xe8
  8022df:	68 49 42 80 00       	push   $0x804249
  8022e4:	e8 02 15 00 00       	call   8037eb <_panic>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 10                	je     802302 <alloc_block_FF+0x357>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fa:	8b 52 04             	mov    0x4(%edx),%edx
  8022fd:	89 50 04             	mov    %edx,0x4(%eax)
  802300:	eb 0b                	jmp    80230d <alloc_block_FF+0x362>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 04             	mov    0x4(%eax),%eax
  802308:	a3 30 50 80 00       	mov    %eax,0x805030
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 40 04             	mov    0x4(%eax),%eax
  802313:	85 c0                	test   %eax,%eax
  802315:	74 0f                	je     802326 <alloc_block_FF+0x37b>
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 04             	mov    0x4(%eax),%eax
  80231d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802320:	8b 12                	mov    (%edx),%edx
  802322:	89 10                	mov    %edx,(%eax)
  802324:	eb 0a                	jmp    802330 <alloc_block_FF+0x385>
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802343:	a1 38 50 80 00       	mov    0x805038,%eax
  802348:	48                   	dec    %eax
  802349:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80234e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802351:	e9 0f 01 00 00       	jmp    802465 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802356:	a1 34 50 80 00       	mov    0x805034,%eax
  80235b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802362:	74 07                	je     80236b <alloc_block_FF+0x3c0>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	eb 05                	jmp    802370 <alloc_block_FF+0x3c5>
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	a3 34 50 80 00       	mov    %eax,0x805034
  802375:	a1 34 50 80 00       	mov    0x805034,%eax
  80237a:	85 c0                	test   %eax,%eax
  80237c:	0f 85 e9 fc ff ff    	jne    80206b <alloc_block_FF+0xc0>
  802382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802386:	0f 85 df fc ff ff    	jne    80206b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	83 c0 08             	add    $0x8,%eax
  802392:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802395:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80239c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80239f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a2:	01 d0                	add    %edx,%eax
  8023a4:	48                   	dec    %eax
  8023a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b0:	f7 75 d8             	divl   -0x28(%ebp)
  8023b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b6:	29 d0                	sub    %edx,%eax
  8023b8:	c1 e8 0c             	shr    $0xc,%eax
  8023bb:	83 ec 0c             	sub    $0xc,%esp
  8023be:	50                   	push   %eax
  8023bf:	e8 66 ed ff ff       	call   80112a <sbrk>
  8023c4:	83 c4 10             	add    $0x10,%esp
  8023c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023ca:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023ce:	75 0a                	jne    8023da <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	e9 8b 00 00 00       	jmp    802465 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023da:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	48                   	dec    %eax
  8023ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f5:	f7 75 cc             	divl   -0x34(%ebp)
  8023f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023fb:	29 d0                	sub    %edx,%eax
  8023fd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802400:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802403:	01 d0                	add    %edx,%eax
  802405:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80240a:	a1 40 50 80 00       	mov    0x805040,%eax
  80240f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802415:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80241c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80241f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802422:	01 d0                	add    %edx,%eax
  802424:	48                   	dec    %eax
  802425:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802428:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80242b:	ba 00 00 00 00       	mov    $0x0,%edx
  802430:	f7 75 c4             	divl   -0x3c(%ebp)
  802433:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802436:	29 d0                	sub    %edx,%eax
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	6a 01                	push   $0x1
  80243d:	50                   	push   %eax
  80243e:	ff 75 d0             	pushl  -0x30(%ebp)
  802441:	e8 36 fb ff ff       	call   801f7c <set_block_data>
  802446:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff 75 d0             	pushl  -0x30(%ebp)
  80244f:	e8 1b 0a 00 00       	call   802e6f <free_block>
  802454:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802457:	83 ec 0c             	sub    $0xc,%esp
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	e8 49 fb ff ff       	call   801fab <alloc_block_FF>
  802462:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	74 03                	je     80247a <alloc_block_BF+0x13>
  802477:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80247a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80247e:	77 07                	ja     802487 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802480:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802487:	a1 24 50 80 00       	mov    0x805024,%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	75 73                	jne    802503 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	83 c0 10             	add    $0x10,%eax
  802496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802499:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a6:	01 d0                	add    %edx,%eax
  8024a8:	48                   	dec    %eax
  8024a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024af:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b4:	f7 75 e0             	divl   -0x20(%ebp)
  8024b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024ba:	29 d0                	sub    %edx,%eax
  8024bc:	c1 e8 0c             	shr    $0xc,%eax
  8024bf:	83 ec 0c             	sub    $0xc,%esp
  8024c2:	50                   	push   %eax
  8024c3:	e8 62 ec ff ff       	call   80112a <sbrk>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	6a 00                	push   $0x0
  8024d3:	e8 52 ec ff ff       	call   80112a <sbrk>
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024e4:	83 ec 08             	sub    $0x8,%esp
  8024e7:	50                   	push   %eax
  8024e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8024eb:	e8 9f f8 ff ff       	call   801d8f <initialize_dynamic_allocator>
  8024f0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	68 87 42 80 00       	push   $0x804287
  8024fb:	e8 90 de ff ff       	call   800390 <cprintf>
  802500:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802503:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80250a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802511:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80251f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802527:	e9 1d 01 00 00       	jmp    802649 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	ff 75 a8             	pushl  -0x58(%ebp)
  802538:	e8 ee f6 ff ff       	call   801c2b <get_block_size>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	83 c0 08             	add    $0x8,%eax
  802549:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80254c:	0f 87 ef 00 00 00    	ja     802641 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	83 c0 18             	add    $0x18,%eax
  802558:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80255b:	77 1d                	ja     80257a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802563:	0f 86 d8 00 00 00    	jbe    802641 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802569:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80256c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80256f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802572:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802575:	e9 c7 00 00 00       	jmp    802641 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	83 c0 08             	add    $0x8,%eax
  802580:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802583:	0f 85 9d 00 00 00    	jne    802626 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	6a 01                	push   $0x1
  80258e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802591:	ff 75 a8             	pushl  -0x58(%ebp)
  802594:	e8 e3 f9 ff ff       	call   801f7c <set_block_data>
  802599:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80259c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a0:	75 17                	jne    8025b9 <alloc_block_BF+0x152>
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 2b 42 80 00       	push   $0x80422b
  8025aa:	68 2c 01 00 00       	push   $0x12c
  8025af:	68 49 42 80 00       	push   $0x804249
  8025b4:	e8 32 12 00 00       	call   8037eb <_panic>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	74 10                	je     8025d2 <alloc_block_BF+0x16b>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ca:	8b 52 04             	mov    0x4(%edx),%edx
  8025cd:	89 50 04             	mov    %edx,0x4(%eax)
  8025d0:	eb 0b                	jmp    8025dd <alloc_block_BF+0x176>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 0f                	je     8025f6 <alloc_block_BF+0x18f>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 04             	mov    0x4(%eax),%eax
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	8b 12                	mov    (%edx),%edx
  8025f2:	89 10                	mov    %edx,(%eax)
  8025f4:	eb 0a                	jmp    802600 <alloc_block_BF+0x199>
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802613:	a1 38 50 80 00       	mov    0x805038,%eax
  802618:	48                   	dec    %eax
  802619:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80261e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802621:	e9 24 04 00 00       	jmp    802a4a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802629:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80262c:	76 13                	jbe    802641 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80262e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802635:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802638:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80263b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80263e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802641:	a1 34 50 80 00       	mov    0x805034,%eax
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264d:	74 07                	je     802656 <alloc_block_BF+0x1ef>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	eb 05                	jmp    80265b <alloc_block_BF+0x1f4>
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
  80265b:	a3 34 50 80 00       	mov    %eax,0x805034
  802660:	a1 34 50 80 00       	mov    0x805034,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	0f 85 bf fe ff ff    	jne    80252c <alloc_block_BF+0xc5>
  80266d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802671:	0f 85 b5 fe ff ff    	jne    80252c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802677:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80267b:	0f 84 26 02 00 00    	je     8028a7 <alloc_block_BF+0x440>
  802681:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802685:	0f 85 1c 02 00 00    	jne    8028a7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80268b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268e:	2b 45 08             	sub    0x8(%ebp),%eax
  802691:	83 e8 08             	sub    $0x8,%eax
  802694:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	8d 50 08             	lea    0x8(%eax),%edx
  80269d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a0:	01 d0                	add    %edx,%eax
  8026a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	83 c0 08             	add    $0x8,%eax
  8026ab:	83 ec 04             	sub    $0x4,%esp
  8026ae:	6a 01                	push   $0x1
  8026b0:	50                   	push   %eax
  8026b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b4:	e8 c3 f8 ff ff       	call   801f7c <set_block_data>
  8026b9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 68                	jne    80272e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_BF+0x27c>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 64 42 80 00       	push   $0x804264
  8026d4:	68 45 01 00 00       	push   $0x145
  8026d9:	68 49 42 80 00       	push   $0x804249
  8026de:	e8 08 11 00 00       	call   8037eb <_panic>
  8026e3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ec:	89 10                	mov    %edx,(%eax)
  8026ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	74 0d                	je     802704 <alloc_block_BF+0x29d>
  8026f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
  802702:	eb 08                	jmp    80270c <alloc_block_BF+0x2a5>
  802704:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802707:	a3 30 50 80 00       	mov    %eax,0x805030
  80270c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80270f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802714:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271e:	a1 38 50 80 00       	mov    0x805038,%eax
  802723:	40                   	inc    %eax
  802724:	a3 38 50 80 00       	mov    %eax,0x805038
  802729:	e9 dc 00 00 00       	jmp    80280a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	75 65                	jne    80279c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802737:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80273b:	75 17                	jne    802754 <alloc_block_BF+0x2ed>
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 98 42 80 00       	push   $0x804298
  802745:	68 4a 01 00 00       	push   $0x14a
  80274a:	68 49 42 80 00       	push   $0x804249
  80274f:	e8 97 10 00 00       	call   8037eb <_panic>
  802754:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80275a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275d:	89 50 04             	mov    %edx,0x4(%eax)
  802760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 0c                	je     802776 <alloc_block_BF+0x30f>
  80276a:	a1 30 50 80 00       	mov    0x805030,%eax
  80276f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 08                	jmp    80277e <alloc_block_BF+0x317>
  802776:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802779:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80277e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802781:	a3 30 50 80 00       	mov    %eax,0x805030
  802786:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278f:	a1 38 50 80 00       	mov    0x805038,%eax
  802794:	40                   	inc    %eax
  802795:	a3 38 50 80 00       	mov    %eax,0x805038
  80279a:	eb 6e                	jmp    80280a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80279c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a0:	74 06                	je     8027a8 <alloc_block_BF+0x341>
  8027a2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027a6:	75 17                	jne    8027bf <alloc_block_BF+0x358>
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	68 bc 42 80 00       	push   $0x8042bc
  8027b0:	68 4f 01 00 00       	push   $0x14f
  8027b5:	68 49 42 80 00       	push   $0x804249
  8027ba:	e8 2c 10 00 00       	call   8037eb <_panic>
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 10                	mov    (%eax),%edx
  8027c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c7:	89 10                	mov    %edx,(%eax)
  8027c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 0b                	je     8027dd <alloc_block_BF+0x376>
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027da:	89 50 04             	mov    %edx,0x4(%eax)
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027eb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 08                	jne    8027ff <alloc_block_BF+0x398>
  8027f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802804:	40                   	inc    %eax
  802805:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80280a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280e:	75 17                	jne    802827 <alloc_block_BF+0x3c0>
  802810:	83 ec 04             	sub    $0x4,%esp
  802813:	68 2b 42 80 00       	push   $0x80422b
  802818:	68 51 01 00 00       	push   $0x151
  80281d:	68 49 42 80 00       	push   $0x804249
  802822:	e8 c4 0f 00 00       	call   8037eb <_panic>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	74 10                	je     802840 <alloc_block_BF+0x3d9>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802838:	8b 52 04             	mov    0x4(%edx),%edx
  80283b:	89 50 04             	mov    %edx,0x4(%eax)
  80283e:	eb 0b                	jmp    80284b <alloc_block_BF+0x3e4>
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	a3 30 50 80 00       	mov    %eax,0x805030
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 40 04             	mov    0x4(%eax),%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	74 0f                	je     802864 <alloc_block_BF+0x3fd>
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 40 04             	mov    0x4(%eax),%eax
  80285b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285e:	8b 12                	mov    (%edx),%edx
  802860:	89 10                	mov    %edx,(%eax)
  802862:	eb 0a                	jmp    80286e <alloc_block_BF+0x407>
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802881:	a1 38 50 80 00       	mov    0x805038,%eax
  802886:	48                   	dec    %eax
  802887:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	6a 00                	push   $0x0
  802891:	ff 75 d0             	pushl  -0x30(%ebp)
  802894:	ff 75 cc             	pushl  -0x34(%ebp)
  802897:	e8 e0 f6 ff ff       	call   801f7c <set_block_data>
  80289c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	e9 a3 01 00 00       	jmp    802a4a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028a7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028ab:	0f 85 9d 00 00 00    	jne    80294e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	6a 01                	push   $0x1
  8028b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8028b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8028bc:	e8 bb f6 ff ff       	call   801f7c <set_block_data>
  8028c1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c8:	75 17                	jne    8028e1 <alloc_block_BF+0x47a>
  8028ca:	83 ec 04             	sub    $0x4,%esp
  8028cd:	68 2b 42 80 00       	push   $0x80422b
  8028d2:	68 58 01 00 00       	push   $0x158
  8028d7:	68 49 42 80 00       	push   $0x804249
  8028dc:	e8 0a 0f 00 00       	call   8037eb <_panic>
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 10                	je     8028fa <alloc_block_BF+0x493>
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f2:	8b 52 04             	mov    0x4(%edx),%edx
  8028f5:	89 50 04             	mov    %edx,0x4(%eax)
  8028f8:	eb 0b                	jmp    802905 <alloc_block_BF+0x49e>
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	a3 30 50 80 00       	mov    %eax,0x805030
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	74 0f                	je     80291e <alloc_block_BF+0x4b7>
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802918:	8b 12                	mov    (%edx),%edx
  80291a:	89 10                	mov    %edx,(%eax)
  80291c:	eb 0a                	jmp    802928 <alloc_block_BF+0x4c1>
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293b:	a1 38 50 80 00       	mov    0x805038,%eax
  802940:	48                   	dec    %eax
  802941:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	e9 fc 00 00 00       	jmp    802a4a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	83 c0 08             	add    $0x8,%eax
  802954:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802957:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80295e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802961:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802964:	01 d0                	add    %edx,%eax
  802966:	48                   	dec    %eax
  802967:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80296a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	f7 75 c4             	divl   -0x3c(%ebp)
  802975:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802978:	29 d0                	sub    %edx,%eax
  80297a:	c1 e8 0c             	shr    $0xc,%eax
  80297d:	83 ec 0c             	sub    $0xc,%esp
  802980:	50                   	push   %eax
  802981:	e8 a4 e7 ff ff       	call   80112a <sbrk>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80298c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802990:	75 0a                	jne    80299c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	e9 ae 00 00 00       	jmp    802a4a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80299c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029a9:	01 d0                	add    %edx,%eax
  8029ab:	48                   	dec    %eax
  8029ac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b7:	f7 75 b8             	divl   -0x48(%ebp)
  8029ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029bd:	29 d0                	sub    %edx,%eax
  8029bf:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029c5:	01 d0                	add    %edx,%eax
  8029c7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029d7:	83 ec 0c             	sub    $0xc,%esp
  8029da:	68 f0 42 80 00       	push   $0x8042f0
  8029df:	e8 ac d9 ff ff       	call   800390 <cprintf>
  8029e4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029e7:	83 ec 08             	sub    $0x8,%esp
  8029ea:	ff 75 bc             	pushl  -0x44(%ebp)
  8029ed:	68 f5 42 80 00       	push   $0x8042f5
  8029f2:	e8 99 d9 ff ff       	call   800390 <cprintf>
  8029f7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029fa:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a01:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	48                   	dec    %eax
  802a0a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a0d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a10:	ba 00 00 00 00       	mov    $0x0,%edx
  802a15:	f7 75 b0             	divl   -0x50(%ebp)
  802a18:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a1b:	29 d0                	sub    %edx,%eax
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	6a 01                	push   $0x1
  802a22:	50                   	push   %eax
  802a23:	ff 75 bc             	pushl  -0x44(%ebp)
  802a26:	e8 51 f5 ff ff       	call   801f7c <set_block_data>
  802a2b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a2e:	83 ec 0c             	sub    $0xc,%esp
  802a31:	ff 75 bc             	pushl  -0x44(%ebp)
  802a34:	e8 36 04 00 00       	call   802e6f <free_block>
  802a39:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a3c:	83 ec 0c             	sub    $0xc,%esp
  802a3f:	ff 75 08             	pushl  0x8(%ebp)
  802a42:	e8 20 fa ff ff       	call   802467 <alloc_block_BF>
  802a47:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    

00802a4c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a4c:	55                   	push   %ebp
  802a4d:	89 e5                	mov    %esp,%ebp
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a65:	74 1e                	je     802a85 <merging+0x39>
  802a67:	ff 75 08             	pushl  0x8(%ebp)
  802a6a:	e8 bc f1 ff ff       	call   801c2b <get_block_size>
  802a6f:	83 c4 04             	add    $0x4,%esp
  802a72:	89 c2                	mov    %eax,%edx
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a7c:	75 07                	jne    802a85 <merging+0x39>
		prev_is_free = 1;
  802a7e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a89:	74 1e                	je     802aa9 <merging+0x5d>
  802a8b:	ff 75 10             	pushl  0x10(%ebp)
  802a8e:	e8 98 f1 ff ff       	call   801c2b <get_block_size>
  802a93:	83 c4 04             	add    $0x4,%esp
  802a96:	89 c2                	mov    %eax,%edx
  802a98:	8b 45 10             	mov    0x10(%ebp),%eax
  802a9b:	01 d0                	add    %edx,%eax
  802a9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aa0:	75 07                	jne    802aa9 <merging+0x5d>
		next_is_free = 1;
  802aa2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802aa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aad:	0f 84 cc 00 00 00    	je     802b7f <merging+0x133>
  802ab3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab7:	0f 84 c2 00 00 00    	je     802b7f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802abd:	ff 75 08             	pushl  0x8(%ebp)
  802ac0:	e8 66 f1 ff ff       	call   801c2b <get_block_size>
  802ac5:	83 c4 04             	add    $0x4,%esp
  802ac8:	89 c3                	mov    %eax,%ebx
  802aca:	ff 75 10             	pushl  0x10(%ebp)
  802acd:	e8 59 f1 ff ff       	call   801c2b <get_block_size>
  802ad2:	83 c4 04             	add    $0x4,%esp
  802ad5:	01 c3                	add    %eax,%ebx
  802ad7:	ff 75 0c             	pushl  0xc(%ebp)
  802ada:	e8 4c f1 ff ff       	call   801c2b <get_block_size>
  802adf:	83 c4 04             	add    $0x4,%esp
  802ae2:	01 d8                	add    %ebx,%eax
  802ae4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ae7:	6a 00                	push   $0x0
  802ae9:	ff 75 ec             	pushl  -0x14(%ebp)
  802aec:	ff 75 08             	pushl  0x8(%ebp)
  802aef:	e8 88 f4 ff ff       	call   801f7c <set_block_data>
  802af4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802af7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802afb:	75 17                	jne    802b14 <merging+0xc8>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 2b 42 80 00       	push   $0x80422b
  802b05:	68 7d 01 00 00       	push   $0x17d
  802b0a:	68 49 42 80 00       	push   $0x804249
  802b0f:	e8 d7 0c 00 00       	call   8037eb <_panic>
  802b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 10                	je     802b2d <merging+0xe1>
  802b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b25:	8b 52 04             	mov    0x4(%edx),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 0b                	jmp    802b38 <merging+0xec>
  802b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	a3 30 50 80 00       	mov    %eax,0x805030
  802b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 0f                	je     802b51 <merging+0x105>
  802b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4b:	8b 12                	mov    (%edx),%edx
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	eb 0a                	jmp    802b5b <merging+0x10f>
  802b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b73:	48                   	dec    %eax
  802b74:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b79:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b7a:	e9 ea 02 00 00       	jmp    802e69 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b83:	74 3b                	je     802bc0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b85:	83 ec 0c             	sub    $0xc,%esp
  802b88:	ff 75 08             	pushl  0x8(%ebp)
  802b8b:	e8 9b f0 ff ff       	call   801c2b <get_block_size>
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	89 c3                	mov    %eax,%ebx
  802b95:	83 ec 0c             	sub    $0xc,%esp
  802b98:	ff 75 10             	pushl  0x10(%ebp)
  802b9b:	e8 8b f0 ff ff       	call   801c2b <get_block_size>
  802ba0:	83 c4 10             	add    $0x10,%esp
  802ba3:	01 d8                	add    %ebx,%eax
  802ba5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ba8:	83 ec 04             	sub    $0x4,%esp
  802bab:	6a 00                	push   $0x0
  802bad:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb0:	ff 75 08             	pushl  0x8(%ebp)
  802bb3:	e8 c4 f3 ff ff       	call   801f7c <set_block_data>
  802bb8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bbb:	e9 a9 02 00 00       	jmp    802e69 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc4:	0f 84 2d 01 00 00    	je     802cf7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bca:	83 ec 0c             	sub    $0xc,%esp
  802bcd:	ff 75 10             	pushl  0x10(%ebp)
  802bd0:	e8 56 f0 ff ff       	call   801c2b <get_block_size>
  802bd5:	83 c4 10             	add    $0x10,%esp
  802bd8:	89 c3                	mov    %eax,%ebx
  802bda:	83 ec 0c             	sub    $0xc,%esp
  802bdd:	ff 75 0c             	pushl  0xc(%ebp)
  802be0:	e8 46 f0 ff ff       	call   801c2b <get_block_size>
  802be5:	83 c4 10             	add    $0x10,%esp
  802be8:	01 d8                	add    %ebx,%eax
  802bea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802bed:	83 ec 04             	sub    $0x4,%esp
  802bf0:	6a 00                	push   $0x0
  802bf2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bf5:	ff 75 10             	pushl  0x10(%ebp)
  802bf8:	e8 7f f3 ff ff       	call   801f7c <set_block_data>
  802bfd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c00:	8b 45 10             	mov    0x10(%ebp),%eax
  802c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0a:	74 06                	je     802c12 <merging+0x1c6>
  802c0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c10:	75 17                	jne    802c29 <merging+0x1dd>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 04 43 80 00       	push   $0x804304
  802c1a:	68 8d 01 00 00       	push   $0x18d
  802c1f:	68 49 42 80 00       	push   $0x804249
  802c24:	e8 c2 0b 00 00       	call   8037eb <_panic>
  802c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2c:	8b 50 04             	mov    0x4(%eax),%edx
  802c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c32:	89 50 04             	mov    %edx,0x4(%eax)
  802c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 0d                	je     802c54 <merging+0x208>
  802c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	eb 08                	jmp    802c5c <merging+0x210>
  802c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	a1 38 50 80 00       	mov    0x805038,%eax
  802c6a:	40                   	inc    %eax
  802c6b:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c74:	75 17                	jne    802c8d <merging+0x241>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 2b 42 80 00       	push   $0x80422b
  802c7e:	68 8e 01 00 00       	push   $0x18e
  802c83:	68 49 42 80 00       	push   $0x804249
  802c88:	e8 5e 0b 00 00       	call   8037eb <_panic>
  802c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 10                	je     802ca6 <merging+0x25a>
  802c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	eb 0b                	jmp    802cb1 <merging+0x265>
  802ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0f                	je     802cca <merging+0x27e>
  802cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc4:	8b 12                	mov    (%edx),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	eb 0a                	jmp    802cd4 <merging+0x288>
  802cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 38 50 80 00       	mov    0x805038,%eax
  802cec:	48                   	dec    %eax
  802ced:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cf2:	e9 72 01 00 00       	jmp    802e69 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  802cfa:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802cfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d01:	74 79                	je     802d7c <merging+0x330>
  802d03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d07:	74 73                	je     802d7c <merging+0x330>
  802d09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0d:	74 06                	je     802d15 <merging+0x2c9>
  802d0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d13:	75 17                	jne    802d2c <merging+0x2e0>
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	68 bc 42 80 00       	push   $0x8042bc
  802d1d:	68 94 01 00 00       	push   $0x194
  802d22:	68 49 42 80 00       	push   $0x804249
  802d27:	e8 bf 0a 00 00       	call   8037eb <_panic>
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 10                	mov    (%eax),%edx
  802d31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d34:	89 10                	mov    %edx,(%eax)
  802d36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 0b                	je     802d4a <merging+0x2fe>
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d47:	89 50 04             	mov    %edx,0x4(%eax)
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d50:	89 10                	mov    %edx,(%eax)
  802d52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d55:	8b 55 08             	mov    0x8(%ebp),%edx
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
  802d5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	75 08                	jne    802d6c <merging+0x320>
  802d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d67:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6c:	a1 38 50 80 00       	mov    0x805038,%eax
  802d71:	40                   	inc    %eax
  802d72:	a3 38 50 80 00       	mov    %eax,0x805038
  802d77:	e9 ce 00 00 00       	jmp    802e4a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d80:	74 65                	je     802de7 <merging+0x39b>
  802d82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d86:	75 17                	jne    802d9f <merging+0x353>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 98 42 80 00       	push   $0x804298
  802d90:	68 95 01 00 00       	push   $0x195
  802d95:	68 49 42 80 00       	push   $0x804249
  802d9a:	e8 4c 0a 00 00       	call   8037eb <_panic>
  802d9f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802da5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 0c                	je     802dc1 <merging+0x375>
  802db5:	a1 30 50 80 00       	mov    0x805030,%eax
  802dba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dbd:	89 10                	mov    %edx,(%eax)
  802dbf:	eb 08                	jmp    802dc9 <merging+0x37d>
  802dc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcc:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dda:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddf:	40                   	inc    %eax
  802de0:	a3 38 50 80 00       	mov    %eax,0x805038
  802de5:	eb 63                	jmp    802e4a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802de7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802deb:	75 17                	jne    802e04 <merging+0x3b8>
  802ded:	83 ec 04             	sub    $0x4,%esp
  802df0:	68 64 42 80 00       	push   $0x804264
  802df5:	68 98 01 00 00       	push   $0x198
  802dfa:	68 49 42 80 00       	push   $0x804249
  802dff:	e8 e7 09 00 00       	call   8037eb <_panic>
  802e04:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0d                	je     802e25 <merging+0x3d9>
  802e18:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 08                	jmp    802e2d <merging+0x3e1>
  802e25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e28:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e30:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e4a:	83 ec 0c             	sub    $0xc,%esp
  802e4d:	ff 75 10             	pushl  0x10(%ebp)
  802e50:	e8 d6 ed ff ff       	call   801c2b <get_block_size>
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	6a 00                	push   $0x0
  802e5d:	50                   	push   %eax
  802e5e:	ff 75 10             	pushl  0x10(%ebp)
  802e61:	e8 16 f1 ff ff       	call   801f7c <set_block_data>
  802e66:	83 c4 10             	add    $0x10,%esp
	}
}
  802e69:	90                   	nop
  802e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e75:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e7d:	a1 30 50 80 00       	mov    0x805030,%eax
  802e82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e85:	73 1b                	jae    802ea2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e87:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	ff 75 08             	pushl  0x8(%ebp)
  802e92:	6a 00                	push   $0x0
  802e94:	50                   	push   %eax
  802e95:	e8 b2 fb ff ff       	call   802a4c <merging>
  802e9a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e9d:	e9 8b 00 00 00       	jmp    802f2d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802ea2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eaa:	76 18                	jbe    802ec4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802eac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb1:	83 ec 04             	sub    $0x4,%esp
  802eb4:	ff 75 08             	pushl  0x8(%ebp)
  802eb7:	50                   	push   %eax
  802eb8:	6a 00                	push   $0x0
  802eba:	e8 8d fb ff ff       	call   802a4c <merging>
  802ebf:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ec2:	eb 69                	jmp    802f2d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ec4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ecc:	eb 39                	jmp    802f07 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed4:	73 29                	jae    802eff <free_block+0x90>
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ede:	76 1f                	jbe    802eff <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 00                	mov    (%eax),%eax
  802ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	ff 75 08             	pushl  0x8(%ebp)
  802eee:	ff 75 f0             	pushl  -0x10(%ebp)
  802ef1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ef4:	e8 53 fb ff ff       	call   802a4c <merging>
  802ef9:	83 c4 10             	add    $0x10,%esp
			break;
  802efc:	90                   	nop
		}
	}
}
  802efd:	eb 2e                	jmp    802f2d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eff:	a1 34 50 80 00       	mov    0x805034,%eax
  802f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0b:	74 07                	je     802f14 <free_block+0xa5>
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	eb 05                	jmp    802f19 <free_block+0xaa>
  802f14:	b8 00 00 00 00       	mov    $0x0,%eax
  802f19:	a3 34 50 80 00       	mov    %eax,0x805034
  802f1e:	a1 34 50 80 00       	mov    0x805034,%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	75 a7                	jne    802ece <free_block+0x5f>
  802f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2b:	75 a1                	jne    802ece <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f2d:	90                   	nop
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f36:	ff 75 08             	pushl  0x8(%ebp)
  802f39:	e8 ed ec ff ff       	call   801c2b <get_block_size>
  802f3e:	83 c4 04             	add    $0x4,%esp
  802f41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f4b:	eb 17                	jmp    802f64 <copy_data+0x34>
  802f4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f53:	01 c2                	add    %eax,%edx
  802f55:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	01 c8                	add    %ecx,%eax
  802f5d:	8a 00                	mov    (%eax),%al
  802f5f:	88 02                	mov    %al,(%edx)
  802f61:	ff 45 fc             	incl   -0x4(%ebp)
  802f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f6a:	72 e1                	jb     802f4d <copy_data+0x1d>
}
  802f6c:	90                   	nop
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
  802f72:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f79:	75 23                	jne    802f9e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f7f:	74 13                	je     802f94 <realloc_block_FF+0x25>
  802f81:	83 ec 0c             	sub    $0xc,%esp
  802f84:	ff 75 0c             	pushl  0xc(%ebp)
  802f87:	e8 1f f0 ff ff       	call   801fab <alloc_block_FF>
  802f8c:	83 c4 10             	add    $0x10,%esp
  802f8f:	e9 f4 06 00 00       	jmp    803688 <realloc_block_FF+0x719>
		return NULL;
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	e9 ea 06 00 00       	jmp    803688 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa2:	75 18                	jne    802fbc <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fa4:	83 ec 0c             	sub    $0xc,%esp
  802fa7:	ff 75 08             	pushl  0x8(%ebp)
  802faa:	e8 c0 fe ff ff       	call   802e6f <free_block>
  802faf:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb7:	e9 cc 06 00 00       	jmp    803688 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fbc:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fc0:	77 07                	ja     802fc9 <realloc_block_FF+0x5a>
  802fc2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	83 e0 01             	and    $0x1,%eax
  802fcf:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd5:	83 c0 08             	add    $0x8,%eax
  802fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fdb:	83 ec 0c             	sub    $0xc,%esp
  802fde:	ff 75 08             	pushl  0x8(%ebp)
  802fe1:	e8 45 ec ff ff       	call   801c2b <get_block_size>
  802fe6:	83 c4 10             	add    $0x10,%esp
  802fe9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fef:	83 e8 08             	sub    $0x8,%eax
  802ff2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	83 e8 04             	sub    $0x4,%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	83 e0 fe             	and    $0xfffffffe,%eax
  803000:	89 c2                	mov    %eax,%edx
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	01 d0                	add    %edx,%eax
  803007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803010:	e8 16 ec ff ff       	call   801c2b <get_block_size>
  803015:	83 c4 10             	add    $0x10,%esp
  803018:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80301b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301e:	83 e8 08             	sub    $0x8,%eax
  803021:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80302a:	75 08                	jne    803034 <realloc_block_FF+0xc5>
	{
		 return va;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	e9 54 06 00 00       	jmp    803688 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803034:	8b 45 0c             	mov    0xc(%ebp),%eax
  803037:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80303a:	0f 83 e5 03 00 00    	jae    803425 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	2b 45 0c             	sub    0xc(%ebp),%eax
  803046:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803049:	83 ec 0c             	sub    $0xc,%esp
  80304c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80304f:	e8 f0 eb ff ff       	call   801c44 <is_free_block>
  803054:	83 c4 10             	add    $0x10,%esp
  803057:	84 c0                	test   %al,%al
  803059:	0f 84 3b 01 00 00    	je     80319a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80305f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803062:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803065:	01 d0                	add    %edx,%eax
  803067:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	6a 01                	push   $0x1
  80306f:	ff 75 f0             	pushl  -0x10(%ebp)
  803072:	ff 75 08             	pushl  0x8(%ebp)
  803075:	e8 02 ef ff ff       	call   801f7c <set_block_data>
  80307a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	83 e8 04             	sub    $0x4,%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	83 e0 fe             	and    $0xfffffffe,%eax
  803088:	89 c2                	mov    %eax,%edx
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	01 d0                	add    %edx,%eax
  80308f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	6a 00                	push   $0x0
  803097:	ff 75 cc             	pushl  -0x34(%ebp)
  80309a:	ff 75 c8             	pushl  -0x38(%ebp)
  80309d:	e8 da ee ff ff       	call   801f7c <set_block_data>
  8030a2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030a9:	74 06                	je     8030b1 <realloc_block_FF+0x142>
  8030ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030af:	75 17                	jne    8030c8 <realloc_block_FF+0x159>
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	68 bc 42 80 00       	push   $0x8042bc
  8030b9:	68 f6 01 00 00       	push   $0x1f6
  8030be:	68 49 42 80 00       	push   $0x804249
  8030c3:	e8 23 07 00 00       	call   8037eb <_panic>
  8030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cb:	8b 10                	mov    (%eax),%edx
  8030cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	74 0b                	je     8030e6 <realloc_block_FF+0x177>
  8030db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ec:	89 10                	mov    %edx,(%eax)
  8030ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f4:	89 50 04             	mov    %edx,0x4(%eax)
  8030f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	75 08                	jne    803108 <realloc_block_FF+0x199>
  803100:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803103:	a3 30 50 80 00       	mov    %eax,0x805030
  803108:	a1 38 50 80 00       	mov    0x805038,%eax
  80310d:	40                   	inc    %eax
  80310e:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803113:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803117:	75 17                	jne    803130 <realloc_block_FF+0x1c1>
  803119:	83 ec 04             	sub    $0x4,%esp
  80311c:	68 2b 42 80 00       	push   $0x80422b
  803121:	68 f7 01 00 00       	push   $0x1f7
  803126:	68 49 42 80 00       	push   $0x804249
  80312b:	e8 bb 06 00 00       	call   8037eb <_panic>
  803130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	74 10                	je     803149 <realloc_block_FF+0x1da>
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803141:	8b 52 04             	mov    0x4(%edx),%edx
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	eb 0b                	jmp    803154 <realloc_block_FF+0x1e5>
  803149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314c:	8b 40 04             	mov    0x4(%eax),%eax
  80314f:	a3 30 50 80 00       	mov    %eax,0x805030
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 0f                	je     80316d <realloc_block_FF+0x1fe>
  80315e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803161:	8b 40 04             	mov    0x4(%eax),%eax
  803164:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803167:	8b 12                	mov    (%edx),%edx
  803169:	89 10                	mov    %edx,(%eax)
  80316b:	eb 0a                	jmp    803177 <realloc_block_FF+0x208>
  80316d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803183:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318a:	a1 38 50 80 00       	mov    0x805038,%eax
  80318f:	48                   	dec    %eax
  803190:	a3 38 50 80 00       	mov    %eax,0x805038
  803195:	e9 83 02 00 00       	jmp    80341d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80319a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80319e:	0f 86 69 02 00 00    	jbe    80340d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031a4:	83 ec 04             	sub    $0x4,%esp
  8031a7:	6a 01                	push   $0x1
  8031a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ac:	ff 75 08             	pushl  0x8(%ebp)
  8031af:	e8 c8 ed ff ff       	call   801f7c <set_block_data>
  8031b4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	83 e8 04             	sub    $0x4,%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	83 e0 fe             	and    $0xfffffffe,%eax
  8031c2:	89 c2                	mov    %eax,%edx
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	01 d0                	add    %edx,%eax
  8031c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031d4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031d8:	75 68                	jne    803242 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031de:	75 17                	jne    8031f7 <realloc_block_FF+0x288>
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	68 64 42 80 00       	push   $0x804264
  8031e8:	68 06 02 00 00       	push   $0x206
  8031ed:	68 49 42 80 00       	push   $0x804249
  8031f2:	e8 f4 05 00 00       	call   8037eb <_panic>
  8031f7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803200:	89 10                	mov    %edx,(%eax)
  803202:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	85 c0                	test   %eax,%eax
  803209:	74 0d                	je     803218 <realloc_block_FF+0x2a9>
  80320b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803210:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803213:	89 50 04             	mov    %edx,0x4(%eax)
  803216:	eb 08                	jmp    803220 <realloc_block_FF+0x2b1>
  803218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321b:	a3 30 50 80 00       	mov    %eax,0x805030
  803220:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803223:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803232:	a1 38 50 80 00       	mov    0x805038,%eax
  803237:	40                   	inc    %eax
  803238:	a3 38 50 80 00       	mov    %eax,0x805038
  80323d:	e9 b0 01 00 00       	jmp    8033f2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803242:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803247:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80324a:	76 68                	jbe    8032b4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80324c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803250:	75 17                	jne    803269 <realloc_block_FF+0x2fa>
  803252:	83 ec 04             	sub    $0x4,%esp
  803255:	68 64 42 80 00       	push   $0x804264
  80325a:	68 0b 02 00 00       	push   $0x20b
  80325f:	68 49 42 80 00       	push   $0x804249
  803264:	e8 82 05 00 00       	call   8037eb <_panic>
  803269:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80326f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803272:	89 10                	mov    %edx,(%eax)
  803274:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	85 c0                	test   %eax,%eax
  80327b:	74 0d                	je     80328a <realloc_block_FF+0x31b>
  80327d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803282:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	eb 08                	jmp    803292 <realloc_block_FF+0x323>
  80328a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328d:	a3 30 50 80 00       	mov    %eax,0x805030
  803292:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803295:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a9:	40                   	inc    %eax
  8032aa:	a3 38 50 80 00       	mov    %eax,0x805038
  8032af:	e9 3e 01 00 00       	jmp    8033f2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032bc:	73 68                	jae    803326 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032be:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032c2:	75 17                	jne    8032db <realloc_block_FF+0x36c>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 98 42 80 00       	push   $0x804298
  8032cc:	68 10 02 00 00       	push   $0x210
  8032d1:	68 49 42 80 00       	push   $0x804249
  8032d6:	e8 10 05 00 00       	call   8037eb <_panic>
  8032db:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e4:	89 50 04             	mov    %edx,0x4(%eax)
  8032e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ea:	8b 40 04             	mov    0x4(%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0c                	je     8032fd <realloc_block_FF+0x38e>
  8032f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	eb 08                	jmp    803305 <realloc_block_FF+0x396>
  8032fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803300:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803308:	a3 30 50 80 00       	mov    %eax,0x805030
  80330d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803316:	a1 38 50 80 00       	mov    0x805038,%eax
  80331b:	40                   	inc    %eax
  80331c:	a3 38 50 80 00       	mov    %eax,0x805038
  803321:	e9 cc 00 00 00       	jmp    8033f2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80332d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803335:	e9 8a 00 00 00       	jmp    8033c4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803340:	73 7a                	jae    8033bc <realloc_block_FF+0x44d>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334a:	73 70                	jae    8033bc <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80334c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803350:	74 06                	je     803358 <realloc_block_FF+0x3e9>
  803352:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803356:	75 17                	jne    80336f <realloc_block_FF+0x400>
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 bc 42 80 00       	push   $0x8042bc
  803360:	68 1a 02 00 00       	push   $0x21a
  803365:	68 49 42 80 00       	push   $0x804249
  80336a:	e8 7c 04 00 00       	call   8037eb <_panic>
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 10                	mov    (%eax),%edx
  803374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803377:	89 10                	mov    %edx,(%eax)
  803379:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	74 0b                	je     80338d <realloc_block_FF+0x41e>
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803393:	89 10                	mov    %edx,(%eax)
  803395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80339b:	89 50 04             	mov    %edx,0x4(%eax)
  80339e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	75 08                	jne    8033af <realloc_block_FF+0x440>
  8033a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8033af:	a1 38 50 80 00       	mov    0x805038,%eax
  8033b4:	40                   	inc    %eax
  8033b5:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033ba:	eb 36                	jmp    8033f2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c8:	74 07                	je     8033d1 <realloc_block_FF+0x462>
  8033ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cd:	8b 00                	mov    (%eax),%eax
  8033cf:	eb 05                	jmp    8033d6 <realloc_block_FF+0x467>
  8033d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d6:	a3 34 50 80 00       	mov    %eax,0x805034
  8033db:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e0:	85 c0                	test   %eax,%eax
  8033e2:	0f 85 52 ff ff ff    	jne    80333a <realloc_block_FF+0x3cb>
  8033e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ec:	0f 85 48 ff ff ff    	jne    80333a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	6a 00                	push   $0x0
  8033f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8033fa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033fd:	e8 7a eb ff ff       	call   801f7c <set_block_data>
  803402:	83 c4 10             	add    $0x10,%esp
				return va;
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	e9 7b 02 00 00       	jmp    803688 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80340d:	83 ec 0c             	sub    $0xc,%esp
  803410:	68 39 43 80 00       	push   $0x804339
  803415:	e8 76 cf ff ff       	call   800390 <cprintf>
  80341a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	e9 63 02 00 00       	jmp    803688 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803425:	8b 45 0c             	mov    0xc(%ebp),%eax
  803428:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80342b:	0f 86 4d 02 00 00    	jbe    80367e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803431:	83 ec 0c             	sub    $0xc,%esp
  803434:	ff 75 e4             	pushl  -0x1c(%ebp)
  803437:	e8 08 e8 ff ff       	call   801c44 <is_free_block>
  80343c:	83 c4 10             	add    $0x10,%esp
  80343f:	84 c0                	test   %al,%al
  803441:	0f 84 37 02 00 00    	je     80367e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80344d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803450:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803453:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803456:	76 38                	jbe    803490 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803458:	83 ec 0c             	sub    $0xc,%esp
  80345b:	ff 75 08             	pushl  0x8(%ebp)
  80345e:	e8 0c fa ff ff       	call   802e6f <free_block>
  803463:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803466:	83 ec 0c             	sub    $0xc,%esp
  803469:	ff 75 0c             	pushl  0xc(%ebp)
  80346c:	e8 3a eb ff ff       	call   801fab <alloc_block_FF>
  803471:	83 c4 10             	add    $0x10,%esp
  803474:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803477:	83 ec 08             	sub    $0x8,%esp
  80347a:	ff 75 c0             	pushl  -0x40(%ebp)
  80347d:	ff 75 08             	pushl  0x8(%ebp)
  803480:	e8 ab fa ff ff       	call   802f30 <copy_data>
  803485:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803488:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80348b:	e9 f8 01 00 00       	jmp    803688 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803490:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803493:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803496:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803499:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80349d:	0f 87 a0 00 00 00    	ja     803543 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a7:	75 17                	jne    8034c0 <realloc_block_FF+0x551>
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	68 2b 42 80 00       	push   $0x80422b
  8034b1:	68 38 02 00 00       	push   $0x238
  8034b6:	68 49 42 80 00       	push   $0x804249
  8034bb:	e8 2b 03 00 00       	call   8037eb <_panic>
  8034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 10                	je     8034d9 <realloc_block_FF+0x56a>
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d1:	8b 52 04             	mov    0x4(%edx),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	eb 0b                	jmp    8034e4 <realloc_block_FF+0x575>
  8034d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dc:	8b 40 04             	mov    0x4(%eax),%eax
  8034df:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 0f                	je     8034fd <realloc_block_FF+0x58e>
  8034ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f1:	8b 40 04             	mov    0x4(%eax),%eax
  8034f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f7:	8b 12                	mov    (%edx),%edx
  8034f9:	89 10                	mov    %edx,(%eax)
  8034fb:	eb 0a                	jmp    803507 <realloc_block_FF+0x598>
  8034fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351a:	a1 38 50 80 00       	mov    0x805038,%eax
  80351f:	48                   	dec    %eax
  803520:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803525:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352b:	01 d0                	add    %edx,%eax
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	6a 01                	push   $0x1
  803532:	50                   	push   %eax
  803533:	ff 75 08             	pushl  0x8(%ebp)
  803536:	e8 41 ea ff ff       	call   801f7c <set_block_data>
  80353b:	83 c4 10             	add    $0x10,%esp
  80353e:	e9 36 01 00 00       	jmp    803679 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803543:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803546:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803549:	01 d0                	add    %edx,%eax
  80354b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	6a 01                	push   $0x1
  803553:	ff 75 f0             	pushl  -0x10(%ebp)
  803556:	ff 75 08             	pushl  0x8(%ebp)
  803559:	e8 1e ea ff ff       	call   801f7c <set_block_data>
  80355e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	83 e8 04             	sub    $0x4,%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	83 e0 fe             	and    $0xfffffffe,%eax
  80356c:	89 c2                	mov    %eax,%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	01 d0                	add    %edx,%eax
  803573:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357a:	74 06                	je     803582 <realloc_block_FF+0x613>
  80357c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803580:	75 17                	jne    803599 <realloc_block_FF+0x62a>
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	68 bc 42 80 00       	push   $0x8042bc
  80358a:	68 44 02 00 00       	push   $0x244
  80358f:	68 49 42 80 00       	push   $0x804249
  803594:	e8 52 02 00 00       	call   8037eb <_panic>
  803599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359c:	8b 10                	mov    (%eax),%edx
  80359e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a1:	89 10                	mov    %edx,(%eax)
  8035a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 0b                	je     8035b7 <realloc_block_FF+0x648>
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035b4:	89 50 04             	mov    %edx,0x4(%eax)
  8035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ba:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	75 08                	jne    8035d9 <realloc_block_FF+0x66a>
  8035d1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035de:	40                   	inc    %eax
  8035df:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035e8:	75 17                	jne    803601 <realloc_block_FF+0x692>
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	68 2b 42 80 00       	push   $0x80422b
  8035f2:	68 45 02 00 00       	push   $0x245
  8035f7:	68 49 42 80 00       	push   $0x804249
  8035fc:	e8 ea 01 00 00       	call   8037eb <_panic>
  803601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803604:	8b 00                	mov    (%eax),%eax
  803606:	85 c0                	test   %eax,%eax
  803608:	74 10                	je     80361a <realloc_block_FF+0x6ab>
  80360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803612:	8b 52 04             	mov    0x4(%edx),%edx
  803615:	89 50 04             	mov    %edx,0x4(%eax)
  803618:	eb 0b                	jmp    803625 <realloc_block_FF+0x6b6>
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 40 04             	mov    0x4(%eax),%eax
  803620:	a3 30 50 80 00       	mov    %eax,0x805030
  803625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	85 c0                	test   %eax,%eax
  80362d:	74 0f                	je     80363e <realloc_block_FF+0x6cf>
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	8b 40 04             	mov    0x4(%eax),%eax
  803635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803638:	8b 12                	mov    (%edx),%edx
  80363a:	89 10                	mov    %edx,(%eax)
  80363c:	eb 0a                	jmp    803648 <realloc_block_FF+0x6d9>
  80363e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803641:	8b 00                	mov    (%eax),%eax
  803643:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365b:	a1 38 50 80 00       	mov    0x805038,%eax
  803660:	48                   	dec    %eax
  803661:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	6a 00                	push   $0x0
  80366b:	ff 75 bc             	pushl  -0x44(%ebp)
  80366e:	ff 75 b8             	pushl  -0x48(%ebp)
  803671:	e8 06 e9 ff ff       	call   801f7c <set_block_data>
  803676:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	eb 0a                	jmp    803688 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80367e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803688:	c9                   	leave  
  803689:	c3                   	ret    

0080368a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80368a:	55                   	push   %ebp
  80368b:	89 e5                	mov    %esp,%ebp
  80368d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 40 43 80 00       	push   $0x804340
  803698:	68 58 02 00 00       	push   $0x258
  80369d:	68 49 42 80 00       	push   $0x804249
  8036a2:	e8 44 01 00 00       	call   8037eb <_panic>

008036a7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036a7:	55                   	push   %ebp
  8036a8:	89 e5                	mov    %esp,%ebp
  8036aa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036ad:	83 ec 04             	sub    $0x4,%esp
  8036b0:	68 68 43 80 00       	push   $0x804368
  8036b5:	68 61 02 00 00       	push   $0x261
  8036ba:	68 49 42 80 00       	push   $0x804249
  8036bf:	e8 27 01 00 00       	call   8037eb <_panic>

008036c4 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036c4:	55                   	push   %ebp
  8036c5:	89 e5                	mov    %esp,%ebp
  8036c7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	68 90 43 80 00       	push   $0x804390
  8036d2:	6a 09                	push   $0x9
  8036d4:	68 b8 43 80 00       	push   $0x8043b8
  8036d9:	e8 0d 01 00 00       	call   8037eb <_panic>

008036de <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8036de:	55                   	push   %ebp
  8036df:	89 e5                	mov    %esp,%ebp
  8036e1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8036e4:	83 ec 04             	sub    $0x4,%esp
  8036e7:	68 c8 43 80 00       	push   $0x8043c8
  8036ec:	6a 10                	push   $0x10
  8036ee:	68 b8 43 80 00       	push   $0x8043b8
  8036f3:	e8 f3 00 00 00       	call   8037eb <_panic>

008036f8 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8036f8:	55                   	push   %ebp
  8036f9:	89 e5                	mov    %esp,%ebp
  8036fb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 f0 43 80 00       	push   $0x8043f0
  803706:	6a 18                	push   $0x18
  803708:	68 b8 43 80 00       	push   $0x8043b8
  80370d:	e8 d9 00 00 00       	call   8037eb <_panic>

00803712 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803712:	55                   	push   %ebp
  803713:	89 e5                	mov    %esp,%ebp
  803715:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 18 44 80 00       	push   $0x804418
  803720:	6a 20                	push   $0x20
  803722:	68 b8 43 80 00       	push   $0x8043b8
  803727:	e8 bf 00 00 00       	call   8037eb <_panic>

0080372c <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80372c:	55                   	push   %ebp
  80372d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	8b 40 10             	mov    0x10(%eax),%eax
}
  803735:	5d                   	pop    %ebp
  803736:	c3                   	ret    

00803737 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
  80373a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80373d:	8b 55 08             	mov    0x8(%ebp),%edx
  803740:	89 d0                	mov    %edx,%eax
  803742:	c1 e0 02             	shl    $0x2,%eax
  803745:	01 d0                	add    %edx,%eax
  803747:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80374e:	01 d0                	add    %edx,%eax
  803750:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803757:	01 d0                	add    %edx,%eax
  803759:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803760:	01 d0                	add    %edx,%eax
  803762:	c1 e0 04             	shl    $0x4,%eax
  803765:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80376f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803772:	83 ec 0c             	sub    $0xc,%esp
  803775:	50                   	push   %eax
  803776:	e8 bc e1 ff ff       	call   801937 <sys_get_virtual_time>
  80377b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80377e:	eb 41                	jmp    8037c1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803780:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803783:	83 ec 0c             	sub    $0xc,%esp
  803786:	50                   	push   %eax
  803787:	e8 ab e1 ff ff       	call   801937 <sys_get_virtual_time>
  80378c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80378f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	29 c2                	sub    %eax,%edx
  803797:	89 d0                	mov    %edx,%eax
  803799:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80379c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80379f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a2:	89 d1                	mov    %edx,%ecx
  8037a4:	29 c1                	sub    %eax,%ecx
  8037a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ac:	39 c2                	cmp    %eax,%edx
  8037ae:	0f 97 c0             	seta   %al
  8037b1:	0f b6 c0             	movzbl %al,%eax
  8037b4:	29 c1                	sub    %eax,%ecx
  8037b6:	89 c8                	mov    %ecx,%eax
  8037b8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037be:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037c7:	72 b7                	jb     803780 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037c9:	90                   	nop
  8037ca:	c9                   	leave  
  8037cb:	c3                   	ret    

008037cc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037cc:	55                   	push   %ebp
  8037cd:	89 e5                	mov    %esp,%ebp
  8037cf:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037d9:	eb 03                	jmp    8037de <busy_wait+0x12>
  8037db:	ff 45 fc             	incl   -0x4(%ebp)
  8037de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e4:	72 f5                	jb     8037db <busy_wait+0xf>
	return i;
  8037e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037e9:	c9                   	leave  
  8037ea:	c3                   	ret    

008037eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037eb:	55                   	push   %ebp
  8037ec:	89 e5                	mov    %esp,%ebp
  8037ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8037f4:	83 c0 04             	add    $0x4,%eax
  8037f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037fa:	a1 60 50 90 00       	mov    0x905060,%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 16                	je     803819 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803803:	a1 60 50 90 00       	mov    0x905060,%eax
  803808:	83 ec 08             	sub    $0x8,%esp
  80380b:	50                   	push   %eax
  80380c:	68 40 44 80 00       	push   $0x804440
  803811:	e8 7a cb ff ff       	call   800390 <cprintf>
  803816:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803819:	a1 00 50 80 00       	mov    0x805000,%eax
  80381e:	ff 75 0c             	pushl  0xc(%ebp)
  803821:	ff 75 08             	pushl  0x8(%ebp)
  803824:	50                   	push   %eax
  803825:	68 45 44 80 00       	push   $0x804445
  80382a:	e8 61 cb ff ff       	call   800390 <cprintf>
  80382f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803832:	8b 45 10             	mov    0x10(%ebp),%eax
  803835:	83 ec 08             	sub    $0x8,%esp
  803838:	ff 75 f4             	pushl  -0xc(%ebp)
  80383b:	50                   	push   %eax
  80383c:	e8 e4 ca ff ff       	call   800325 <vcprintf>
  803841:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803844:	83 ec 08             	sub    $0x8,%esp
  803847:	6a 00                	push   $0x0
  803849:	68 61 44 80 00       	push   $0x804461
  80384e:	e8 d2 ca ff ff       	call   800325 <vcprintf>
  803853:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803856:	e8 53 ca ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  80385b:	eb fe                	jmp    80385b <_panic+0x70>

0080385d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80385d:	55                   	push   %ebp
  80385e:	89 e5                	mov    %esp,%ebp
  803860:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803863:	a1 20 50 80 00       	mov    0x805020,%eax
  803868:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80386e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803871:	39 c2                	cmp    %eax,%edx
  803873:	74 14                	je     803889 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	68 64 44 80 00       	push   $0x804464
  80387d:	6a 26                	push   $0x26
  80387f:	68 b0 44 80 00       	push   $0x8044b0
  803884:	e8 62 ff ff ff       	call   8037eb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803890:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803897:	e9 c5 00 00 00       	jmp    803961 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80389c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	01 d0                	add    %edx,%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	75 08                	jne    8038b9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038b1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038b4:	e9 a5 00 00 00       	jmp    80395e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038c7:	eb 69                	jmp    803932 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ce:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038d7:	89 d0                	mov    %edx,%eax
  8038d9:	01 c0                	add    %eax,%eax
  8038db:	01 d0                	add    %edx,%eax
  8038dd:	c1 e0 03             	shl    $0x3,%eax
  8038e0:	01 c8                	add    %ecx,%eax
  8038e2:	8a 40 04             	mov    0x4(%eax),%al
  8038e5:	84 c0                	test   %al,%al
  8038e7:	75 46                	jne    80392f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ee:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038f7:	89 d0                	mov    %edx,%eax
  8038f9:	01 c0                	add    %eax,%eax
  8038fb:	01 d0                	add    %edx,%eax
  8038fd:	c1 e0 03             	shl    $0x3,%eax
  803900:	01 c8                	add    %ecx,%eax
  803902:	8b 00                	mov    (%eax),%eax
  803904:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80390f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803914:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	01 c8                	add    %ecx,%eax
  803920:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803922:	39 c2                	cmp    %eax,%edx
  803924:	75 09                	jne    80392f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803926:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80392d:	eb 15                	jmp    803944 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80392f:	ff 45 e8             	incl   -0x18(%ebp)
  803932:	a1 20 50 80 00       	mov    0x805020,%eax
  803937:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80393d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803940:	39 c2                	cmp    %eax,%edx
  803942:	77 85                	ja     8038c9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803944:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803948:	75 14                	jne    80395e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 bc 44 80 00       	push   $0x8044bc
  803952:	6a 3a                	push   $0x3a
  803954:	68 b0 44 80 00       	push   $0x8044b0
  803959:	e8 8d fe ff ff       	call   8037eb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80395e:	ff 45 f0             	incl   -0x10(%ebp)
  803961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803964:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803967:	0f 8c 2f ff ff ff    	jl     80389c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80396d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803974:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80397b:	eb 26                	jmp    8039a3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80397d:	a1 20 50 80 00       	mov    0x805020,%eax
  803982:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803988:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80398b:	89 d0                	mov    %edx,%eax
  80398d:	01 c0                	add    %eax,%eax
  80398f:	01 d0                	add    %edx,%eax
  803991:	c1 e0 03             	shl    $0x3,%eax
  803994:	01 c8                	add    %ecx,%eax
  803996:	8a 40 04             	mov    0x4(%eax),%al
  803999:	3c 01                	cmp    $0x1,%al
  80399b:	75 03                	jne    8039a0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80399d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039a0:	ff 45 e0             	incl   -0x20(%ebp)
  8039a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b1:	39 c2                	cmp    %eax,%edx
  8039b3:	77 c8                	ja     80397d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039bb:	74 14                	je     8039d1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039bd:	83 ec 04             	sub    $0x4,%esp
  8039c0:	68 10 45 80 00       	push   $0x804510
  8039c5:	6a 44                	push   $0x44
  8039c7:	68 b0 44 80 00       	push   $0x8044b0
  8039cc:	e8 1a fe ff ff       	call   8037eb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039d1:	90                   	nop
  8039d2:	c9                   	leave  
  8039d3:	c3                   	ret    

008039d4 <__udivdi3>:
  8039d4:	55                   	push   %ebp
  8039d5:	57                   	push   %edi
  8039d6:	56                   	push   %esi
  8039d7:	53                   	push   %ebx
  8039d8:	83 ec 1c             	sub    $0x1c,%esp
  8039db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039eb:	89 ca                	mov    %ecx,%edx
  8039ed:	89 f8                	mov    %edi,%eax
  8039ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f3:	85 f6                	test   %esi,%esi
  8039f5:	75 2d                	jne    803a24 <__udivdi3+0x50>
  8039f7:	39 cf                	cmp    %ecx,%edi
  8039f9:	77 65                	ja     803a60 <__udivdi3+0x8c>
  8039fb:	89 fd                	mov    %edi,%ebp
  8039fd:	85 ff                	test   %edi,%edi
  8039ff:	75 0b                	jne    803a0c <__udivdi3+0x38>
  803a01:	b8 01 00 00 00       	mov    $0x1,%eax
  803a06:	31 d2                	xor    %edx,%edx
  803a08:	f7 f7                	div    %edi
  803a0a:	89 c5                	mov    %eax,%ebp
  803a0c:	31 d2                	xor    %edx,%edx
  803a0e:	89 c8                	mov    %ecx,%eax
  803a10:	f7 f5                	div    %ebp
  803a12:	89 c1                	mov    %eax,%ecx
  803a14:	89 d8                	mov    %ebx,%eax
  803a16:	f7 f5                	div    %ebp
  803a18:	89 cf                	mov    %ecx,%edi
  803a1a:	89 fa                	mov    %edi,%edx
  803a1c:	83 c4 1c             	add    $0x1c,%esp
  803a1f:	5b                   	pop    %ebx
  803a20:	5e                   	pop    %esi
  803a21:	5f                   	pop    %edi
  803a22:	5d                   	pop    %ebp
  803a23:	c3                   	ret    
  803a24:	39 ce                	cmp    %ecx,%esi
  803a26:	77 28                	ja     803a50 <__udivdi3+0x7c>
  803a28:	0f bd fe             	bsr    %esi,%edi
  803a2b:	83 f7 1f             	xor    $0x1f,%edi
  803a2e:	75 40                	jne    803a70 <__udivdi3+0x9c>
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	72 0a                	jb     803a3e <__udivdi3+0x6a>
  803a34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a38:	0f 87 9e 00 00 00    	ja     803adc <__udivdi3+0x108>
  803a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a43:	89 fa                	mov    %edi,%edx
  803a45:	83 c4 1c             	add    $0x1c,%esp
  803a48:	5b                   	pop    %ebx
  803a49:	5e                   	pop    %esi
  803a4a:	5f                   	pop    %edi
  803a4b:	5d                   	pop    %ebp
  803a4c:	c3                   	ret    
  803a4d:	8d 76 00             	lea    0x0(%esi),%esi
  803a50:	31 ff                	xor    %edi,%edi
  803a52:	31 c0                	xor    %eax,%eax
  803a54:	89 fa                	mov    %edi,%edx
  803a56:	83 c4 1c             	add    $0x1c,%esp
  803a59:	5b                   	pop    %ebx
  803a5a:	5e                   	pop    %esi
  803a5b:	5f                   	pop    %edi
  803a5c:	5d                   	pop    %ebp
  803a5d:	c3                   	ret    
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f7                	div    %edi
  803a64:	31 ff                	xor    %edi,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a75:	89 eb                	mov    %ebp,%ebx
  803a77:	29 fb                	sub    %edi,%ebx
  803a79:	89 f9                	mov    %edi,%ecx
  803a7b:	d3 e6                	shl    %cl,%esi
  803a7d:	89 c5                	mov    %eax,%ebp
  803a7f:	88 d9                	mov    %bl,%cl
  803a81:	d3 ed                	shr    %cl,%ebp
  803a83:	89 e9                	mov    %ebp,%ecx
  803a85:	09 f1                	or     %esi,%ecx
  803a87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8b:	89 f9                	mov    %edi,%ecx
  803a8d:	d3 e0                	shl    %cl,%eax
  803a8f:	89 c5                	mov    %eax,%ebp
  803a91:	89 d6                	mov    %edx,%esi
  803a93:	88 d9                	mov    %bl,%cl
  803a95:	d3 ee                	shr    %cl,%esi
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e2                	shl    %cl,%edx
  803a9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 e8                	shr    %cl,%eax
  803aa3:	09 c2                	or     %eax,%edx
  803aa5:	89 d0                	mov    %edx,%eax
  803aa7:	89 f2                	mov    %esi,%edx
  803aa9:	f7 74 24 0c          	divl   0xc(%esp)
  803aad:	89 d6                	mov    %edx,%esi
  803aaf:	89 c3                	mov    %eax,%ebx
  803ab1:	f7 e5                	mul    %ebp
  803ab3:	39 d6                	cmp    %edx,%esi
  803ab5:	72 19                	jb     803ad0 <__udivdi3+0xfc>
  803ab7:	74 0b                	je     803ac4 <__udivdi3+0xf0>
  803ab9:	89 d8                	mov    %ebx,%eax
  803abb:	31 ff                	xor    %edi,%edi
  803abd:	e9 58 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ac2:	66 90                	xchg   %ax,%ax
  803ac4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ac8:	89 f9                	mov    %edi,%ecx
  803aca:	d3 e2                	shl    %cl,%edx
  803acc:	39 c2                	cmp    %eax,%edx
  803ace:	73 e9                	jae    803ab9 <__udivdi3+0xe5>
  803ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad3:	31 ff                	xor    %edi,%edi
  803ad5:	e9 40 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	31 c0                	xor    %eax,%eax
  803ade:	e9 37 ff ff ff       	jmp    803a1a <__udivdi3+0x46>
  803ae3:	90                   	nop

00803ae4 <__umoddi3>:
  803ae4:	55                   	push   %ebp
  803ae5:	57                   	push   %edi
  803ae6:	56                   	push   %esi
  803ae7:	53                   	push   %ebx
  803ae8:	83 ec 1c             	sub    $0x1c,%esp
  803aeb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b03:	89 f3                	mov    %esi,%ebx
  803b05:	89 fa                	mov    %edi,%edx
  803b07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0b:	89 34 24             	mov    %esi,(%esp)
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	75 1a                	jne    803b2c <__umoddi3+0x48>
  803b12:	39 f7                	cmp    %esi,%edi
  803b14:	0f 86 a2 00 00 00    	jbe    803bbc <__umoddi3+0xd8>
  803b1a:	89 c8                	mov    %ecx,%eax
  803b1c:	89 f2                	mov    %esi,%edx
  803b1e:	f7 f7                	div    %edi
  803b20:	89 d0                	mov    %edx,%eax
  803b22:	31 d2                	xor    %edx,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 f0                	cmp    %esi,%eax
  803b2e:	0f 87 ac 00 00 00    	ja     803be0 <__umoddi3+0xfc>
  803b34:	0f bd e8             	bsr    %eax,%ebp
  803b37:	83 f5 1f             	xor    $0x1f,%ebp
  803b3a:	0f 84 ac 00 00 00    	je     803bec <__umoddi3+0x108>
  803b40:	bf 20 00 00 00       	mov    $0x20,%edi
  803b45:	29 ef                	sub    %ebp,%edi
  803b47:	89 fe                	mov    %edi,%esi
  803b49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 e0                	shl    %cl,%eax
  803b51:	89 d7                	mov    %edx,%edi
  803b53:	89 f1                	mov    %esi,%ecx
  803b55:	d3 ef                	shr    %cl,%edi
  803b57:	09 c7                	or     %eax,%edi
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e2                	shl    %cl,%edx
  803b5d:	89 14 24             	mov    %edx,(%esp)
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	d3 e0                	shl    %cl,%eax
  803b64:	89 c2                	mov    %eax,%edx
  803b66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6a:	d3 e0                	shl    %cl,%eax
  803b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b74:	89 f1                	mov    %esi,%ecx
  803b76:	d3 e8                	shr    %cl,%eax
  803b78:	09 d0                	or     %edx,%eax
  803b7a:	d3 eb                	shr    %cl,%ebx
  803b7c:	89 da                	mov    %ebx,%edx
  803b7e:	f7 f7                	div    %edi
  803b80:	89 d3                	mov    %edx,%ebx
  803b82:	f7 24 24             	mull   (%esp)
  803b85:	89 c6                	mov    %eax,%esi
  803b87:	89 d1                	mov    %edx,%ecx
  803b89:	39 d3                	cmp    %edx,%ebx
  803b8b:	0f 82 87 00 00 00    	jb     803c18 <__umoddi3+0x134>
  803b91:	0f 84 91 00 00 00    	je     803c28 <__umoddi3+0x144>
  803b97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9b:	29 f2                	sub    %esi,%edx
  803b9d:	19 cb                	sbb    %ecx,%ebx
  803b9f:	89 d8                	mov    %ebx,%eax
  803ba1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba5:	d3 e0                	shl    %cl,%eax
  803ba7:	89 e9                	mov    %ebp,%ecx
  803ba9:	d3 ea                	shr    %cl,%edx
  803bab:	09 d0                	or     %edx,%eax
  803bad:	89 e9                	mov    %ebp,%ecx
  803baf:	d3 eb                	shr    %cl,%ebx
  803bb1:	89 da                	mov    %ebx,%edx
  803bb3:	83 c4 1c             	add    $0x1c,%esp
  803bb6:	5b                   	pop    %ebx
  803bb7:	5e                   	pop    %esi
  803bb8:	5f                   	pop    %edi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    
  803bbb:	90                   	nop
  803bbc:	89 fd                	mov    %edi,%ebp
  803bbe:	85 ff                	test   %edi,%edi
  803bc0:	75 0b                	jne    803bcd <__umoddi3+0xe9>
  803bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc7:	31 d2                	xor    %edx,%edx
  803bc9:	f7 f7                	div    %edi
  803bcb:	89 c5                	mov    %eax,%ebp
  803bcd:	89 f0                	mov    %esi,%eax
  803bcf:	31 d2                	xor    %edx,%edx
  803bd1:	f7 f5                	div    %ebp
  803bd3:	89 c8                	mov    %ecx,%eax
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 d0                	mov    %edx,%eax
  803bd9:	e9 44 ff ff ff       	jmp    803b22 <__umoddi3+0x3e>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	89 c8                	mov    %ecx,%eax
  803be2:	89 f2                	mov    %esi,%edx
  803be4:	83 c4 1c             	add    $0x1c,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5f                   	pop    %edi
  803bea:	5d                   	pop    %ebp
  803beb:	c3                   	ret    
  803bec:	3b 04 24             	cmp    (%esp),%eax
  803bef:	72 06                	jb     803bf7 <__umoddi3+0x113>
  803bf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf5:	77 0f                	ja     803c06 <__umoddi3+0x122>
  803bf7:	89 f2                	mov    %esi,%edx
  803bf9:	29 f9                	sub    %edi,%ecx
  803bfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bff:	89 14 24             	mov    %edx,(%esp)
  803c02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0a:	8b 14 24             	mov    (%esp),%edx
  803c0d:	83 c4 1c             	add    $0x1c,%esp
  803c10:	5b                   	pop    %ebx
  803c11:	5e                   	pop    %esi
  803c12:	5f                   	pop    %edi
  803c13:	5d                   	pop    %ebp
  803c14:	c3                   	ret    
  803c15:	8d 76 00             	lea    0x0(%esi),%esi
  803c18:	2b 04 24             	sub    (%esp),%eax
  803c1b:	19 fa                	sbb    %edi,%edx
  803c1d:	89 d1                	mov    %edx,%ecx
  803c1f:	89 c6                	mov    %eax,%esi
  803c21:	e9 71 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c2c:	72 ea                	jb     803c18 <__umoddi3+0x134>
  803c2e:	89 d9                	mov    %ebx,%ecx
  803c30:	e9 62 ff ff ff       	jmp    803b97 <__umoddi3+0xb3>
