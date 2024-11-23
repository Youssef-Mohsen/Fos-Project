
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
  80003e:	e8 b1 18 00 00       	call   8018f4 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 3c 80 00       	push   $0x803c40
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 86 14 00 00       	call   8014dc <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 3c 80 00       	push   $0x803c42
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 70 14 00 00       	call   8014dc <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 3c 80 00       	push   $0x803c49
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 5a 14 00 00       	call   8014dc <sget>
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
  8000a1:	e8 28 36 00 00       	call   8036ce <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 34 36 00 00       	call   8036e8 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 64 18 00 00       	call   801927 <sys_get_virtual_time>
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
  8000e6:	e8 3c 36 00 00       	call   803727 <env_sleep>
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
  8000fe:	e8 24 18 00 00       	call   801927 <sys_get_virtual_time>
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
  800126:	e8 fc 35 00 00       	call   803727 <env_sleep>
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
  80013d:	e8 e5 17 00 00       	call   801927 <sys_get_virtual_time>
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
  800165:	e8 bd 35 00 00       	call   803727 <env_sleep>
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
  800183:	e8 53 17 00 00       	call   8018db <sys_getenvindex>
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
  8001f1:	e8 69 14 00 00       	call   80165f <sys_lock_cons>
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
  80028b:	e8 e9 13 00 00       	call   801679 <sys_unlock_cons>
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
  8002a3:	e8 ff 15 00 00       	call   8018a7 <sys_destroy_env>
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
  8002b4:	e8 54 16 00 00       	call   80190d <sys_exit_env>
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
  800302:	e8 16 13 00 00       	call   80161d <sys_cputs>
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
  800379:	e8 9f 12 00 00       	call   80161d <sys_cputs>
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
  8003c3:	e8 97 12 00 00       	call   80165f <sys_lock_cons>
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
  8003e3:	e8 91 12 00 00       	call   801679 <sys_unlock_cons>
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
  80042d:	e8 92 35 00 00       	call   8039c4 <__udivdi3>
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
  80047d:	e8 52 36 00 00       	call   803ad4 <__umoddi3>
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
  801125:	e8 b1 26 00 00       	call   8037db <_panic>

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
  801136:	e8 8d 0a 00 00       	call   801bc8 <sys_sbrk>
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
  8011b1:	e8 96 08 00 00       	call   801a4c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 d6 0d 00 00       	call   801f9b <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 a8 08 00 00       	call   801a7d <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 6f 12 00 00       	call   802457 <alloc_block_BF>
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
  801349:	e8 b1 08 00 00       	call   801bff <sys_allocate_user_mem>
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
  801391:	e8 85 08 00 00       	call   801c1b <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 b8 1a 00 00       	call   802e5f <free_block>
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
  801439:	e8 a5 07 00 00       	call   801be3 <sys_free_user_mem>
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
  801456:	e8 80 23 00 00       	call   8037db <_panic>
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
  801474:	eb 64                	jmp    8014da <smalloc+0x7d>
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
  8014a9:	eb 2f                	jmp    8014da <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014ab:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014af:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	ff 75 08             	pushl  0x8(%ebp)
  8014b9:	e8 2c 03 00 00       	call   8017ea <sys_createSharedObject>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014c8:	74 06                	je     8014d0 <smalloc+0x73>
  8014ca:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014ce:	75 07                	jne    8014d7 <smalloc+0x7a>
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 03                	jmp    8014da <smalloc+0x7d>
	 return ptr;
  8014d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	e8 24 03 00 00       	call   801814 <sys_getSizeOfSharedObject>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014f6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014fa:	75 07                	jne    801503 <sget+0x27>
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb 5c                	jmp    80155f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801509:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801510:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	39 d0                	cmp    %edx,%eax
  801518:	7d 02                	jge    80151c <sget+0x40>
  80151a:	89 d0                	mov    %edx,%eax
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	50                   	push   %eax
  801520:	e8 1b fc ff ff       	call   801140 <malloc>
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80152b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80152f:	75 07                	jne    801538 <sget+0x5c>
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
  801536:	eb 27                	jmp    80155f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	ff 75 e8             	pushl  -0x18(%ebp)
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	e8 e8 02 00 00       	call   801831 <sys_getSharedObject>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80154f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801553:	75 07                	jne    80155c <sget+0x80>
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	eb 03                	jmp    80155f <sget+0x83>
	return ptr;
  80155c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 50 41 80 00       	push   $0x804150
  80156f:	68 c1 00 00 00       	push   $0xc1
  801574:	68 42 41 80 00       	push   $0x804142
  801579:	e8 5d 22 00 00       	call   8037db <_panic>

0080157e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 74 41 80 00       	push   $0x804174
  80158c:	68 d8 00 00 00       	push   $0xd8
  801591:	68 42 41 80 00       	push   $0x804142
  801596:	e8 40 22 00 00       	call   8037db <_panic>

0080159b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 9a 41 80 00       	push   $0x80419a
  8015a9:	68 e4 00 00 00       	push   $0xe4
  8015ae:	68 42 41 80 00       	push   $0x804142
  8015b3:	e8 23 22 00 00       	call   8037db <_panic>

008015b8 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 9a 41 80 00       	push   $0x80419a
  8015c6:	68 e9 00 00 00       	push   $0xe9
  8015cb:	68 42 41 80 00       	push   $0x804142
  8015d0:	e8 06 22 00 00       	call   8037db <_panic>

008015d5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 9a 41 80 00       	push   $0x80419a
  8015e3:	68 ee 00 00 00       	push   $0xee
  8015e8:	68 42 41 80 00       	push   $0x804142
  8015ed:	e8 e9 21 00 00       	call   8037db <_panic>

008015f2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	57                   	push   %edi
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801601:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801604:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801607:	8b 7d 18             	mov    0x18(%ebp),%edi
  80160a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160d:	cd 30                	int    $0x30
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5f                   	pop    %edi
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801629:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	52                   	push   %edx
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	6a 00                	push   $0x0
  80163b:	e8 b2 ff ff ff       	call   8015f2 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_cgetc>:

int
sys_cgetc(void)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 02                	push   $0x2
  801655:	e8 98 ff ff ff       	call   8015f2 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 03                	push   $0x3
  80166e:	e8 7f ff ff ff       	call   8015f2 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 04                	push   $0x4
  801688:	e8 65 ff ff ff       	call   8015f2 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	6a 08                	push   $0x8
  8016a6:	e8 47 ff ff ff       	call   8015f2 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	51                   	push   %ecx
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	6a 09                	push   $0x9
  8016cb:	e8 22 ff ff ff       	call   8015f2 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	6a 0a                	push   $0xa
  8016ed:	e8 00 ff ff ff       	call   8015f2 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	6a 0b                	push   $0xb
  801708:	e8 e5 fe ff ff       	call   8015f2 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 0c                	push   $0xc
  801721:	e8 cc fe ff ff       	call   8015f2 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 0d                	push   $0xd
  80173a:	e8 b3 fe ff ff       	call   8015f2 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 0e                	push   $0xe
  801753:	e8 9a fe ff ff       	call   8015f2 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 0f                	push   $0xf
  80176c:	e8 81 fe ff ff       	call   8015f2 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 10                	push   $0x10
  801786:	e8 67 fe ff ff       	call   8015f2 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 11                	push   $0x11
  80179f:	e8 4e fe ff ff       	call   8015f2 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_cputc>:

void
sys_cputc(const char c)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	50                   	push   %eax
  8017c3:	6a 01                	push   $0x1
  8017c5:	e8 28 fe ff ff       	call   8015f2 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 14                	push   $0x14
  8017df:	e8 0e fe ff ff       	call   8015f2 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	51                   	push   %ecx
  801803:	52                   	push   %edx
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	50                   	push   %eax
  801808:	6a 15                	push   $0x15
  80180a:	e8 e3 fd ff ff       	call   8015f2 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 16                	push   $0x16
  801827:	e8 c6 fd ff ff       	call   8015f2 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	51                   	push   %ecx
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 17                	push   $0x17
  801846:	e8 a7 fd ff ff       	call   8015f2 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	52                   	push   %edx
  801860:	50                   	push   %eax
  801861:	6a 18                	push   $0x18
  801863:	e8 8a fd ff ff       	call   8015f2 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	ff 75 14             	pushl  0x14(%ebp)
  801878:	ff 75 10             	pushl  0x10(%ebp)
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	50                   	push   %eax
  80187f:	6a 19                	push   $0x19
  801881:	e8 6c fd ff ff       	call   8015f2 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	50                   	push   %eax
  80189a:	6a 1a                	push   $0x1a
  80189c:	e8 51 fd ff ff       	call   8015f2 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	50                   	push   %eax
  8018b6:	6a 1b                	push   $0x1b
  8018b8:	e8 35 fd ff ff       	call   8015f2 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 05                	push   $0x5
  8018d1:	e8 1c fd ff ff       	call   8015f2 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 06                	push   $0x6
  8018ea:	e8 03 fd ff ff       	call   8015f2 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 07                	push   $0x7
  801903:	e8 ea fc ff ff       	call   8015f2 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_exit_env>:


void sys_exit_env(void)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 1c                	push   $0x1c
  80191c:	e8 d1 fc ff ff       	call   8015f2 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80192d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801930:	8d 50 04             	lea    0x4(%eax),%edx
  801933:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 1d                	push   $0x1d
  801940:	e8 ad fc ff ff       	call   8015f2 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return result;
  801948:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801951:	89 01                	mov    %eax,(%ecx)
  801953:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	c9                   	leave  
  80195a:	c2 04 00             	ret    $0x4

0080195d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 10             	pushl  0x10(%ebp)
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	6a 13                	push   $0x13
  80196f:	e8 7e fc ff ff       	call   8015f2 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
	return ;
  801977:	90                   	nop
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_rcr2>:
uint32 sys_rcr2()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 1e                	push   $0x1e
  801989:	e8 64 fc ff ff       	call   8015f2 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80199f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	50                   	push   %eax
  8019ac:	6a 1f                	push   $0x1f
  8019ae:	e8 3f fc ff ff       	call   8015f2 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <rsttst>:
void rsttst()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 21                	push   $0x21
  8019c8:	e8 25 fc ff ff       	call   8015f2 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d0:	90                   	nop
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019df:	8b 55 18             	mov    0x18(%ebp),%edx
  8019e2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	ff 75 10             	pushl  0x10(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 20                	push   $0x20
  8019f3:	e8 fa fb ff ff       	call   8015f2 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <chktst>:
void chktst(uint32 n)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	6a 22                	push   $0x22
  801a0e:	e8 df fb ff ff       	call   8015f2 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return ;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <inctst>:

void inctst()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 23                	push   $0x23
  801a28:	e8 c5 fb ff ff       	call   8015f2 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <gettst>:
uint32 gettst()
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 24                	push   $0x24
  801a42:	e8 ab fb ff ff       	call   8015f2 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 25                	push   $0x25
  801a5e:	e8 8f fb ff ff       	call   8015f2 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
  801a66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a69:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a6d:	75 07                	jne    801a76 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a74:	eb 05                	jmp    801a7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 25                	push   $0x25
  801a8f:	e8 5e fb ff ff       	call   8015f2 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
  801a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a9a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a9e:	75 07                	jne    801aa7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aa0:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa5:	eb 05                	jmp    801aac <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 25                	push   $0x25
  801ac0:	e8 2d fb ff ff       	call   8015f2 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
  801ac8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801acb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801acf:	75 07                	jne    801ad8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad6:	eb 05                	jmp    801add <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 25                	push   $0x25
  801af1:	e8 fc fa ff ff       	call   8015f2 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
  801af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801afc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b00:	75 07                	jne    801b09 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b02:	b8 01 00 00 00       	mov    $0x1,%eax
  801b07:	eb 05                	jmp    801b0e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 08             	pushl  0x8(%ebp)
  801b1e:	6a 26                	push   $0x26
  801b20:	e8 cd fa ff ff       	call   8015f2 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return ;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	53                   	push   %ebx
  801b3e:	51                   	push   %ecx
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 27                	push   $0x27
  801b43:	e8 aa fa ff ff       	call   8015f2 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 28                	push   $0x28
  801b63:	e8 8a fa ff ff       	call   8015f2 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	51                   	push   %ecx
  801b7c:	ff 75 10             	pushl  0x10(%ebp)
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 29                	push   $0x29
  801b83:	e8 6a fa ff ff       	call   8015f2 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	6a 12                	push   $0x12
  801b9f:	e8 4e fa ff ff       	call   8015f2 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 2a                	push   $0x2a
  801bbd:	e8 30 fa ff ff       	call   8015f2 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	50                   	push   %eax
  801bd7:	6a 2b                	push   $0x2b
  801bd9:	e8 14 fa ff ff       	call   8015f2 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 0c             	pushl  0xc(%ebp)
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	6a 2c                	push   $0x2c
  801bf4:	e8 f9 f9 ff ff       	call   8015f2 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
	return;
  801bfc:	90                   	nop
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 2d                	push   $0x2d
  801c10:	e8 dd f9 ff ff       	call   8015f2 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	83 e8 04             	sub    $0x4,%eax
  801c27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c2d:	8b 00                	mov    (%eax),%eax
  801c2f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	83 e8 04             	sub    $0x4,%eax
  801c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	83 e0 01             	and    $0x1,%eax
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	0f 94 c0             	sete   %al
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c62:	83 f8 02             	cmp    $0x2,%eax
  801c65:	74 2b                	je     801c92 <alloc_block+0x40>
  801c67:	83 f8 02             	cmp    $0x2,%eax
  801c6a:	7f 07                	jg     801c73 <alloc_block+0x21>
  801c6c:	83 f8 01             	cmp    $0x1,%eax
  801c6f:	74 0e                	je     801c7f <alloc_block+0x2d>
  801c71:	eb 58                	jmp    801ccb <alloc_block+0x79>
  801c73:	83 f8 03             	cmp    $0x3,%eax
  801c76:	74 2d                	je     801ca5 <alloc_block+0x53>
  801c78:	83 f8 04             	cmp    $0x4,%eax
  801c7b:	74 3b                	je     801cb8 <alloc_block+0x66>
  801c7d:	eb 4c                	jmp    801ccb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c7f:	83 ec 0c             	sub    $0xc,%esp
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	e8 11 03 00 00       	call   801f9b <alloc_block_FF>
  801c8a:	83 c4 10             	add    $0x10,%esp
  801c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c90:	eb 4a                	jmp    801cdc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	ff 75 08             	pushl  0x8(%ebp)
  801c98:	e8 fa 19 00 00       	call   803697 <alloc_block_NF>
  801c9d:	83 c4 10             	add    $0x10,%esp
  801ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ca3:	eb 37                	jmp    801cdc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	e8 a7 07 00 00       	call   802457 <alloc_block_BF>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cb6:	eb 24                	jmp    801cdc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	e8 b7 19 00 00       	call   80367a <alloc_block_WF>
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cc9:	eb 11                	jmp    801cdc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	68 ac 41 80 00       	push   $0x8041ac
  801cd3:	e8 b8 e6 ff ff       	call   800390 <cprintf>
  801cd8:	83 c4 10             	add    $0x10,%esp
		break;
  801cdb:	90                   	nop
	}
	return va;
  801cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	53                   	push   %ebx
  801ce5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	68 cc 41 80 00       	push   $0x8041cc
  801cf0:	e8 9b e6 ff ff       	call   800390 <cprintf>
  801cf5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801cf8:	83 ec 0c             	sub    $0xc,%esp
  801cfb:	68 f7 41 80 00       	push   $0x8041f7
  801d00:	e8 8b e6 ff ff       	call   800390 <cprintf>
  801d05:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0e:	eb 37                	jmp    801d47 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	ff 75 f4             	pushl  -0xc(%ebp)
  801d16:	e8 19 ff ff ff       	call   801c34 <is_free_block>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	0f be d8             	movsbl %al,%ebx
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	ff 75 f4             	pushl  -0xc(%ebp)
  801d27:	e8 ef fe ff ff       	call   801c1b <get_block_size>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	83 ec 04             	sub    $0x4,%esp
  801d32:	53                   	push   %ebx
  801d33:	50                   	push   %eax
  801d34:	68 0f 42 80 00       	push   $0x80420f
  801d39:	e8 52 e6 ff ff       	call   800390 <cprintf>
  801d3e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d41:	8b 45 10             	mov    0x10(%ebp),%eax
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4b:	74 07                	je     801d54 <print_blocks_list+0x73>
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	eb 05                	jmp    801d59 <print_blocks_list+0x78>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	89 45 10             	mov    %eax,0x10(%ebp)
  801d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	75 ad                	jne    801d10 <print_blocks_list+0x2f>
  801d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d67:	75 a7                	jne    801d10 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	68 cc 41 80 00       	push   $0x8041cc
  801d71:	e8 1a e6 ff ff       	call   800390 <cprintf>
  801d76:	83 c4 10             	add    $0x10,%esp

}
  801d79:	90                   	nop
  801d7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	83 e0 01             	and    $0x1,%eax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	74 03                	je     801d92 <initialize_dynamic_allocator+0x13>
  801d8f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d96:	0f 84 c7 01 00 00    	je     801f63 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d9c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801da3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801da6:	8b 55 08             	mov    0x8(%ebp),%edx
  801da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801db3:	0f 87 ad 01 00 00    	ja     801f66 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 89 a5 01 00 00    	jns    801f69 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	83 e8 04             	sub    $0x4,%eax
  801dcf:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801dd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ddb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de3:	e9 87 00 00 00       	jmp    801e6f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801de8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dec:	75 14                	jne    801e02 <initialize_dynamic_allocator+0x83>
  801dee:	83 ec 04             	sub    $0x4,%esp
  801df1:	68 27 42 80 00       	push   $0x804227
  801df6:	6a 79                	push   $0x79
  801df8:	68 45 42 80 00       	push   $0x804245
  801dfd:	e8 d9 19 00 00       	call   8037db <_panic>
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 00                	mov    (%eax),%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	74 10                	je     801e1b <initialize_dynamic_allocator+0x9c>
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 00                	mov    (%eax),%eax
  801e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e13:	8b 52 04             	mov    0x4(%edx),%edx
  801e16:	89 50 04             	mov    %edx,0x4(%eax)
  801e19:	eb 0b                	jmp    801e26 <initialize_dynamic_allocator+0xa7>
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 40 04             	mov    0x4(%eax),%eax
  801e21:	a3 30 50 80 00       	mov    %eax,0x805030
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 40 04             	mov    0x4(%eax),%eax
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	74 0f                	je     801e3f <initialize_dynamic_allocator+0xc0>
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 40 04             	mov    0x4(%eax),%eax
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	8b 12                	mov    (%edx),%edx
  801e3b:	89 10                	mov    %edx,(%eax)
  801e3d:	eb 0a                	jmp    801e49 <initialize_dynamic_allocator+0xca>
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	8b 00                	mov    (%eax),%eax
  801e44:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e5c:	a1 38 50 80 00       	mov    0x805038,%eax
  801e61:	48                   	dec    %eax
  801e62:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e67:	a1 34 50 80 00       	mov    0x805034,%eax
  801e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e73:	74 07                	je     801e7c <initialize_dynamic_allocator+0xfd>
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	8b 00                	mov    (%eax),%eax
  801e7a:	eb 05                	jmp    801e81 <initialize_dynamic_allocator+0x102>
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e81:	a3 34 50 80 00       	mov    %eax,0x805034
  801e86:	a1 34 50 80 00       	mov    0x805034,%eax
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 85 55 ff ff ff    	jne    801de8 <initialize_dynamic_allocator+0x69>
  801e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e97:	0f 85 4b ff ff ff    	jne    801de8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801eac:	a1 44 50 80 00       	mov    0x805044,%eax
  801eb1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801eb6:	a1 40 50 80 00       	mov    0x805040,%eax
  801ebb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	83 c0 08             	add    $0x8,%eax
  801ec7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	83 c0 04             	add    $0x4,%eax
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	83 ea 08             	sub    $0x8,%edx
  801ed6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	01 d0                	add    %edx,%eax
  801ee0:	83 e8 08             	sub    $0x8,%eax
  801ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee6:	83 ea 08             	sub    $0x8,%edx
  801ee9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801efe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f02:	75 17                	jne    801f1b <initialize_dynamic_allocator+0x19c>
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	68 60 42 80 00       	push   $0x804260
  801f0c:	68 90 00 00 00       	push   $0x90
  801f11:	68 45 42 80 00       	push   $0x804245
  801f16:	e8 c0 18 00 00       	call   8037db <_panic>
  801f1b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	89 10                	mov    %edx,(%eax)
  801f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	74 0d                	je     801f3c <initialize_dynamic_allocator+0x1bd>
  801f2f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f37:	89 50 04             	mov    %edx,0x4(%eax)
  801f3a:	eb 08                	jmp    801f44 <initialize_dynamic_allocator+0x1c5>
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	a3 30 50 80 00       	mov    %eax,0x805030
  801f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f56:	a1 38 50 80 00       	mov    0x805038,%eax
  801f5b:	40                   	inc    %eax
  801f5c:	a3 38 50 80 00       	mov    %eax,0x805038
  801f61:	eb 07                	jmp    801f6a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f63:	90                   	nop
  801f64:	eb 04                	jmp    801f6a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f66:	90                   	nop
  801f67:	eb 01                	jmp    801f6a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f69:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f72:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	83 e8 04             	sub    $0x4,%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	83 e0 fe             	and    $0xfffffffe,%eax
  801f8b:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	01 c2                	add    %eax,%edx
  801f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f96:	89 02                	mov    %eax,(%edx)
}
  801f98:	90                   	nop
  801f99:	5d                   	pop    %ebp
  801f9a:	c3                   	ret    

00801f9b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	83 e0 01             	and    $0x1,%eax
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	74 03                	je     801fae <alloc_block_FF+0x13>
  801fab:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fae:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fb2:	77 07                	ja     801fbb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fb4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fbb:	a1 24 50 80 00       	mov    0x805024,%eax
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	75 73                	jne    802037 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	83 c0 10             	add    $0x10,%eax
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801fcd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	48                   	dec    %eax
  801fdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	f7 75 ec             	divl   -0x14(%ebp)
  801feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fee:	29 d0                	sub    %edx,%eax
  801ff0:	c1 e8 0c             	shr    $0xc,%eax
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	50                   	push   %eax
  801ff7:	e8 2e f1 ff ff       	call   80112a <sbrk>
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	6a 00                	push   $0x0
  802007:	e8 1e f1 ff ff       	call   80112a <sbrk>
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802012:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802015:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	50                   	push   %eax
  80201c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80201f:	e8 5b fd ff ff       	call   801d7f <initialize_dynamic_allocator>
  802024:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	68 83 42 80 00       	push   $0x804283
  80202f:	e8 5c e3 ff ff       	call   800390 <cprintf>
  802034:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203b:	75 0a                	jne    802047 <alloc_block_FF+0xac>
	        return NULL;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	e9 0e 04 00 00       	jmp    802455 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80204e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802056:	e9 f3 02 00 00       	jmp    80234e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 bc             	pushl  -0x44(%ebp)
  802067:	e8 af fb ff ff       	call   801c1b <get_block_size>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	83 c0 08             	add    $0x8,%eax
  802078:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80207b:	0f 87 c5 02 00 00    	ja     802346 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	83 c0 18             	add    $0x18,%eax
  802087:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80208a:	0f 87 19 02 00 00    	ja     8022a9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802090:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802093:	2b 45 08             	sub    0x8(%ebp),%eax
  802096:	83 e8 08             	sub    $0x8,%eax
  802099:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8d 50 08             	lea    0x8(%eax),%edx
  8020a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	83 c0 08             	add    $0x8,%eax
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	6a 01                	push   $0x1
  8020b5:	50                   	push   %eax
  8020b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8020b9:	e8 ae fe ff ff       	call   801f6c <set_block_data>
  8020be:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 40 04             	mov    0x4(%eax),%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	75 68                	jne    802133 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020cb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020cf:	75 17                	jne    8020e8 <alloc_block_FF+0x14d>
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	68 60 42 80 00       	push   $0x804260
  8020d9:	68 d7 00 00 00       	push   $0xd7
  8020de:	68 45 42 80 00       	push   $0x804245
  8020e3:	e8 f3 16 00 00       	call   8037db <_panic>
  8020e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020f1:	89 10                	mov    %edx,(%eax)
  8020f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	74 0d                	je     802109 <alloc_block_FF+0x16e>
  8020fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802101:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802104:	89 50 04             	mov    %edx,0x4(%eax)
  802107:	eb 08                	jmp    802111 <alloc_block_FF+0x176>
  802109:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80210c:	a3 30 50 80 00       	mov    %eax,0x805030
  802111:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802114:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802119:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802123:	a1 38 50 80 00       	mov    0x805038,%eax
  802128:	40                   	inc    %eax
  802129:	a3 38 50 80 00       	mov    %eax,0x805038
  80212e:	e9 dc 00 00 00       	jmp    80220f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 65                	jne    8021a1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80213c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802140:	75 17                	jne    802159 <alloc_block_FF+0x1be>
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 94 42 80 00       	push   $0x804294
  80214a:	68 db 00 00 00       	push   $0xdb
  80214f:	68 45 42 80 00       	push   $0x804245
  802154:	e8 82 16 00 00       	call   8037db <_panic>
  802159:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80215f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802162:	89 50 04             	mov    %edx,0x4(%eax)
  802165:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802168:	8b 40 04             	mov    0x4(%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 0c                	je     80217b <alloc_block_FF+0x1e0>
  80216f:	a1 30 50 80 00       	mov    0x805030,%eax
  802174:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802177:	89 10                	mov    %edx,(%eax)
  802179:	eb 08                	jmp    802183 <alloc_block_FF+0x1e8>
  80217b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802183:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802186:	a3 30 50 80 00       	mov    %eax,0x805030
  80218b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802194:	a1 38 50 80 00       	mov    0x805038,%eax
  802199:	40                   	inc    %eax
  80219a:	a3 38 50 80 00       	mov    %eax,0x805038
  80219f:	eb 6e                	jmp    80220f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a5:	74 06                	je     8021ad <alloc_block_FF+0x212>
  8021a7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021ab:	75 17                	jne    8021c4 <alloc_block_FF+0x229>
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 b8 42 80 00       	push   $0x8042b8
  8021b5:	68 df 00 00 00       	push   $0xdf
  8021ba:	68 45 42 80 00       	push   $0x804245
  8021bf:	e8 17 16 00 00       	call   8037db <_panic>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 10                	mov    (%eax),%edx
  8021c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 0b                	je     8021e2 <alloc_block_FF+0x247>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021e8:	89 10                	mov    %edx,(%eax)
  8021ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 08                	jne    802204 <alloc_block_FF+0x269>
  8021fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802204:	a1 38 50 80 00       	mov    0x805038,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80220f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802213:	75 17                	jne    80222c <alloc_block_FF+0x291>
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 27 42 80 00       	push   $0x804227
  80221d:	68 e1 00 00 00       	push   $0xe1
  802222:	68 45 42 80 00       	push   $0x804245
  802227:	e8 af 15 00 00       	call   8037db <_panic>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	74 10                	je     802245 <alloc_block_FF+0x2aa>
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	8b 00                	mov    (%eax),%eax
  80223a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223d:	8b 52 04             	mov    0x4(%edx),%edx
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	eb 0b                	jmp    802250 <alloc_block_FF+0x2b5>
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	a3 30 50 80 00       	mov    %eax,0x805030
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 40 04             	mov    0x4(%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 0f                	je     802269 <alloc_block_FF+0x2ce>
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 40 04             	mov    0x4(%eax),%eax
  802260:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802263:	8b 12                	mov    (%edx),%edx
  802265:	89 10                	mov    %edx,(%eax)
  802267:	eb 0a                	jmp    802273 <alloc_block_FF+0x2d8>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 00                	mov    (%eax),%eax
  80226e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802286:	a1 38 50 80 00       	mov    0x805038,%eax
  80228b:	48                   	dec    %eax
  80228c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802291:	83 ec 04             	sub    $0x4,%esp
  802294:	6a 00                	push   $0x0
  802296:	ff 75 b4             	pushl  -0x4c(%ebp)
  802299:	ff 75 b0             	pushl  -0x50(%ebp)
  80229c:	e8 cb fc ff ff       	call   801f6c <set_block_data>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	e9 95 00 00 00       	jmp    80233e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	6a 01                	push   $0x1
  8022ae:	ff 75 b8             	pushl  -0x48(%ebp)
  8022b1:	ff 75 bc             	pushl  -0x44(%ebp)
  8022b4:	e8 b3 fc ff ff       	call   801f6c <set_block_data>
  8022b9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c0:	75 17                	jne    8022d9 <alloc_block_FF+0x33e>
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	68 27 42 80 00       	push   $0x804227
  8022ca:	68 e8 00 00 00       	push   $0xe8
  8022cf:	68 45 42 80 00       	push   $0x804245
  8022d4:	e8 02 15 00 00       	call   8037db <_panic>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 10                	je     8022f2 <alloc_block_FF+0x357>
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ea:	8b 52 04             	mov    0x4(%edx),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
  8022f0:	eb 0b                	jmp    8022fd <alloc_block_FF+0x362>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 04             	mov    0x4(%eax),%eax
  8022f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 04             	mov    0x4(%eax),%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	74 0f                	je     802316 <alloc_block_FF+0x37b>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802310:	8b 12                	mov    (%edx),%edx
  802312:	89 10                	mov    %edx,(%eax)
  802314:	eb 0a                	jmp    802320 <alloc_block_FF+0x385>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802333:	a1 38 50 80 00       	mov    0x805038,%eax
  802338:	48                   	dec    %eax
  802339:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80233e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802341:	e9 0f 01 00 00       	jmp    802455 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802346:	a1 34 50 80 00       	mov    0x805034,%eax
  80234b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802352:	74 07                	je     80235b <alloc_block_FF+0x3c0>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	eb 05                	jmp    802360 <alloc_block_FF+0x3c5>
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	a3 34 50 80 00       	mov    %eax,0x805034
  802365:	a1 34 50 80 00       	mov    0x805034,%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	0f 85 e9 fc ff ff    	jne    80205b <alloc_block_FF+0xc0>
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	0f 85 df fc ff ff    	jne    80205b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	83 c0 08             	add    $0x8,%eax
  802382:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802385:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80238c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80238f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	48                   	dec    %eax
  802395:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	f7 75 d8             	divl   -0x28(%ebp)
  8023a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a6:	29 d0                	sub    %edx,%eax
  8023a8:	c1 e8 0c             	shr    $0xc,%eax
  8023ab:	83 ec 0c             	sub    $0xc,%esp
  8023ae:	50                   	push   %eax
  8023af:	e8 76 ed ff ff       	call   80112a <sbrk>
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023ba:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023be:	75 0a                	jne    8023ca <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c5:	e9 8b 00 00 00       	jmp    802455 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023ca:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023d7:	01 d0                	add    %edx,%eax
  8023d9:	48                   	dec    %eax
  8023da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e5:	f7 75 cc             	divl   -0x34(%ebp)
  8023e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023eb:	29 d0                	sub    %edx,%eax
  8023ed:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f3:	01 d0                	add    %edx,%eax
  8023f5:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802405:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80240c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80240f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802412:	01 d0                	add    %edx,%eax
  802414:	48                   	dec    %eax
  802415:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802418:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80241b:	ba 00 00 00 00       	mov    $0x0,%edx
  802420:	f7 75 c4             	divl   -0x3c(%ebp)
  802423:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802426:	29 d0                	sub    %edx,%eax
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	6a 01                	push   $0x1
  80242d:	50                   	push   %eax
  80242e:	ff 75 d0             	pushl  -0x30(%ebp)
  802431:	e8 36 fb ff ff       	call   801f6c <set_block_data>
  802436:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802439:	83 ec 0c             	sub    $0xc,%esp
  80243c:	ff 75 d0             	pushl  -0x30(%ebp)
  80243f:	e8 1b 0a 00 00       	call   802e5f <free_block>
  802444:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802447:	83 ec 0c             	sub    $0xc,%esp
  80244a:	ff 75 08             	pushl  0x8(%ebp)
  80244d:	e8 49 fb ff ff       	call   801f9b <alloc_block_FF>
  802452:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	83 e0 01             	and    $0x1,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	74 03                	je     80246a <alloc_block_BF+0x13>
  802467:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80246a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80246e:	77 07                	ja     802477 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802470:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802477:	a1 24 50 80 00       	mov    0x805024,%eax
  80247c:	85 c0                	test   %eax,%eax
  80247e:	75 73                	jne    8024f3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	83 c0 10             	add    $0x10,%eax
  802486:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802489:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	48                   	dec    %eax
  802499:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80249c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249f:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a4:	f7 75 e0             	divl   -0x20(%ebp)
  8024a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024aa:	29 d0                	sub    %edx,%eax
  8024ac:	c1 e8 0c             	shr    $0xc,%eax
  8024af:	83 ec 0c             	sub    $0xc,%esp
  8024b2:	50                   	push   %eax
  8024b3:	e8 72 ec ff ff       	call   80112a <sbrk>
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	6a 00                	push   $0x0
  8024c3:	e8 62 ec ff ff       	call   80112a <sbrk>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024d4:	83 ec 08             	sub    $0x8,%esp
  8024d7:	50                   	push   %eax
  8024d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8024db:	e8 9f f8 ff ff       	call   801d7f <initialize_dynamic_allocator>
  8024e0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	68 83 42 80 00       	push   $0x804283
  8024eb:	e8 a0 de ff ff       	call   800390 <cprintf>
  8024f0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8024f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802501:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802508:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80250f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802517:	e9 1d 01 00 00       	jmp    802639 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	ff 75 a8             	pushl  -0x58(%ebp)
  802528:	e8 ee f6 ff ff       	call   801c1b <get_block_size>
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	83 c0 08             	add    $0x8,%eax
  802539:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80253c:	0f 87 ef 00 00 00    	ja     802631 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	83 c0 18             	add    $0x18,%eax
  802548:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80254b:	77 1d                	ja     80256a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802553:	0f 86 d8 00 00 00    	jbe    802631 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802559:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80255f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802562:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802565:	e9 c7 00 00 00       	jmp    802631 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	83 c0 08             	add    $0x8,%eax
  802570:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802573:	0f 85 9d 00 00 00    	jne    802616 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	6a 01                	push   $0x1
  80257e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802581:	ff 75 a8             	pushl  -0x58(%ebp)
  802584:	e8 e3 f9 ff ff       	call   801f6c <set_block_data>
  802589:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80258c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802590:	75 17                	jne    8025a9 <alloc_block_BF+0x152>
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	68 27 42 80 00       	push   $0x804227
  80259a:	68 2c 01 00 00       	push   $0x12c
  80259f:	68 45 42 80 00       	push   $0x804245
  8025a4:	e8 32 12 00 00       	call   8037db <_panic>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 10                	je     8025c2 <alloc_block_BF+0x16b>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ba:	8b 52 04             	mov    0x4(%edx),%edx
  8025bd:	89 50 04             	mov    %edx,0x4(%eax)
  8025c0:	eb 0b                	jmp    8025cd <alloc_block_BF+0x176>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 0f                	je     8025e6 <alloc_block_BF+0x18f>
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e0:	8b 12                	mov    (%edx),%edx
  8025e2:	89 10                	mov    %edx,(%eax)
  8025e4:	eb 0a                	jmp    8025f0 <alloc_block_BF+0x199>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802603:	a1 38 50 80 00       	mov    0x805038,%eax
  802608:	48                   	dec    %eax
  802609:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80260e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802611:	e9 24 04 00 00       	jmp    802a3a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80261c:	76 13                	jbe    802631 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80261e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802625:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802628:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80262b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80262e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802631:	a1 34 50 80 00       	mov    0x805034,%eax
  802636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	74 07                	je     802646 <alloc_block_BF+0x1ef>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	eb 05                	jmp    80264b <alloc_block_BF+0x1f4>
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
  80264b:	a3 34 50 80 00       	mov    %eax,0x805034
  802650:	a1 34 50 80 00       	mov    0x805034,%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	0f 85 bf fe ff ff    	jne    80251c <alloc_block_BF+0xc5>
  80265d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802661:	0f 85 b5 fe ff ff    	jne    80251c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802667:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80266b:	0f 84 26 02 00 00    	je     802897 <alloc_block_BF+0x440>
  802671:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802675:	0f 85 1c 02 00 00    	jne    802897 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80267b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267e:	2b 45 08             	sub    0x8(%ebp),%eax
  802681:	83 e8 08             	sub    $0x8,%eax
  802684:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8d 50 08             	lea    0x8(%eax),%edx
  80268d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802690:	01 d0                	add    %edx,%eax
  802692:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	83 c0 08             	add    $0x8,%eax
  80269b:	83 ec 04             	sub    $0x4,%esp
  80269e:	6a 01                	push   $0x1
  8026a0:	50                   	push   %eax
  8026a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a4:	e8 c3 f8 ff ff       	call   801f6c <set_block_data>
  8026a9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	75 68                	jne    80271e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026ba:	75 17                	jne    8026d3 <alloc_block_BF+0x27c>
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	68 60 42 80 00       	push   $0x804260
  8026c4:	68 45 01 00 00       	push   $0x145
  8026c9:	68 45 42 80 00       	push   $0x804245
  8026ce:	e8 08 11 00 00       	call   8037db <_panic>
  8026d3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 0d                	je     8026f4 <alloc_block_BF+0x29d>
  8026e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	eb 08                	jmp    8026fc <alloc_block_BF+0x2a5>
  8026f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8026fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802704:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270e:	a1 38 50 80 00       	mov    0x805038,%eax
  802713:	40                   	inc    %eax
  802714:	a3 38 50 80 00       	mov    %eax,0x805038
  802719:	e9 dc 00 00 00       	jmp    8027fa <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	85 c0                	test   %eax,%eax
  802725:	75 65                	jne    80278c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802727:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80272b:	75 17                	jne    802744 <alloc_block_BF+0x2ed>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 94 42 80 00       	push   $0x804294
  802735:	68 4a 01 00 00       	push   $0x14a
  80273a:	68 45 42 80 00       	push   $0x804245
  80273f:	e8 97 10 00 00       	call   8037db <_panic>
  802744:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80274a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0c                	je     802766 <alloc_block_BF+0x30f>
  80275a:	a1 30 50 80 00       	mov    0x805030,%eax
  80275f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802762:	89 10                	mov    %edx,(%eax)
  802764:	eb 08                	jmp    80276e <alloc_block_BF+0x317>
  802766:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802769:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802771:	a3 30 50 80 00       	mov    %eax,0x805030
  802776:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277f:	a1 38 50 80 00       	mov    0x805038,%eax
  802784:	40                   	inc    %eax
  802785:	a3 38 50 80 00       	mov    %eax,0x805038
  80278a:	eb 6e                	jmp    8027fa <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80278c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802790:	74 06                	je     802798 <alloc_block_BF+0x341>
  802792:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802796:	75 17                	jne    8027af <alloc_block_BF+0x358>
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 b8 42 80 00       	push   $0x8042b8
  8027a0:	68 4f 01 00 00       	push   $0x14f
  8027a5:	68 45 42 80 00       	push   $0x804245
  8027aa:	e8 2c 10 00 00       	call   8037db <_panic>
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 10                	mov    (%eax),%edx
  8027b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b7:	89 10                	mov    %edx,(%eax)
  8027b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	74 0b                	je     8027cd <alloc_block_BF+0x376>
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027d3:	89 10                	mov    %edx,(%eax)
  8027d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	75 08                	jne    8027ef <alloc_block_BF+0x398>
  8027e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f4:	40                   	inc    %eax
  8027f5:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fe:	75 17                	jne    802817 <alloc_block_BF+0x3c0>
  802800:	83 ec 04             	sub    $0x4,%esp
  802803:	68 27 42 80 00       	push   $0x804227
  802808:	68 51 01 00 00       	push   $0x151
  80280d:	68 45 42 80 00       	push   $0x804245
  802812:	e8 c4 0f 00 00       	call   8037db <_panic>
  802817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	74 10                	je     802830 <alloc_block_BF+0x3d9>
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802828:	8b 52 04             	mov    0x4(%edx),%edx
  80282b:	89 50 04             	mov    %edx,0x4(%eax)
  80282e:	eb 0b                	jmp    80283b <alloc_block_BF+0x3e4>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 40 04             	mov    0x4(%eax),%eax
  802836:	a3 30 50 80 00       	mov    %eax,0x805030
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	8b 40 04             	mov    0x4(%eax),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	74 0f                	je     802854 <alloc_block_BF+0x3fd>
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284e:	8b 12                	mov    (%edx),%edx
  802850:	89 10                	mov    %edx,(%eax)
  802852:	eb 0a                	jmp    80285e <alloc_block_BF+0x407>
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802871:	a1 38 50 80 00       	mov    0x805038,%eax
  802876:	48                   	dec    %eax
  802877:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	6a 00                	push   $0x0
  802881:	ff 75 d0             	pushl  -0x30(%ebp)
  802884:	ff 75 cc             	pushl  -0x34(%ebp)
  802887:	e8 e0 f6 ff ff       	call   801f6c <set_block_data>
  80288c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	e9 a3 01 00 00       	jmp    802a3a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802897:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80289b:	0f 85 9d 00 00 00    	jne    80293e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	6a 01                	push   $0x1
  8028a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8028a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ac:	e8 bb f6 ff ff       	call   801f6c <set_block_data>
  8028b1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b8:	75 17                	jne    8028d1 <alloc_block_BF+0x47a>
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 27 42 80 00       	push   $0x804227
  8028c2:	68 58 01 00 00       	push   $0x158
  8028c7:	68 45 42 80 00       	push   $0x804245
  8028cc:	e8 0a 0f 00 00       	call   8037db <_panic>
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 10                	je     8028ea <alloc_block_BF+0x493>
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e2:	8b 52 04             	mov    0x4(%edx),%edx
  8028e5:	89 50 04             	mov    %edx,0x4(%eax)
  8028e8:	eb 0b                	jmp    8028f5 <alloc_block_BF+0x49e>
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 0f                	je     80290e <alloc_block_BF+0x4b7>
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	8b 12                	mov    (%edx),%edx
  80290a:	89 10                	mov    %edx,(%eax)
  80290c:	eb 0a                	jmp    802918 <alloc_block_BF+0x4c1>
  80290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292b:	a1 38 50 80 00       	mov    0x805038,%eax
  802930:	48                   	dec    %eax
  802931:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	e9 fc 00 00 00       	jmp    802a3a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	83 c0 08             	add    $0x8,%eax
  802944:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802947:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80294e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802951:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	48                   	dec    %eax
  802957:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80295a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80295d:	ba 00 00 00 00       	mov    $0x0,%edx
  802962:	f7 75 c4             	divl   -0x3c(%ebp)
  802965:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802968:	29 d0                	sub    %edx,%eax
  80296a:	c1 e8 0c             	shr    $0xc,%eax
  80296d:	83 ec 0c             	sub    $0xc,%esp
  802970:	50                   	push   %eax
  802971:	e8 b4 e7 ff ff       	call   80112a <sbrk>
  802976:	83 c4 10             	add    $0x10,%esp
  802979:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80297c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802980:	75 0a                	jne    80298c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
  802987:	e9 ae 00 00 00       	jmp    802a3a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80298c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802993:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802996:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802999:	01 d0                	add    %edx,%eax
  80299b:	48                   	dec    %eax
  80299c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80299f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a7:	f7 75 b8             	divl   -0x48(%ebp)
  8029aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029ad:	29 d0                	sub    %edx,%eax
  8029af:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029b2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029b5:	01 d0                	add    %edx,%eax
  8029b7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	68 ec 42 80 00       	push   $0x8042ec
  8029cf:	e8 bc d9 ff ff       	call   800390 <cprintf>
  8029d4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029d7:	83 ec 08             	sub    $0x8,%esp
  8029da:	ff 75 bc             	pushl  -0x44(%ebp)
  8029dd:	68 f1 42 80 00       	push   $0x8042f1
  8029e2:	e8 a9 d9 ff ff       	call   800390 <cprintf>
  8029e7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029ea:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029f1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f7:	01 d0                	add    %edx,%eax
  8029f9:	48                   	dec    %eax
  8029fa:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a00:	ba 00 00 00 00       	mov    $0x0,%edx
  802a05:	f7 75 b0             	divl   -0x50(%ebp)
  802a08:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a0b:	29 d0                	sub    %edx,%eax
  802a0d:	83 ec 04             	sub    $0x4,%esp
  802a10:	6a 01                	push   $0x1
  802a12:	50                   	push   %eax
  802a13:	ff 75 bc             	pushl  -0x44(%ebp)
  802a16:	e8 51 f5 ff ff       	call   801f6c <set_block_data>
  802a1b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a1e:	83 ec 0c             	sub    $0xc,%esp
  802a21:	ff 75 bc             	pushl  -0x44(%ebp)
  802a24:	e8 36 04 00 00       	call   802e5f <free_block>
  802a29:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a2c:	83 ec 0c             	sub    $0xc,%esp
  802a2f:	ff 75 08             	pushl  0x8(%ebp)
  802a32:	e8 20 fa ff ff       	call   802457 <alloc_block_BF>
  802a37:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	53                   	push   %ebx
  802a40:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a55:	74 1e                	je     802a75 <merging+0x39>
  802a57:	ff 75 08             	pushl  0x8(%ebp)
  802a5a:	e8 bc f1 ff ff       	call   801c1b <get_block_size>
  802a5f:	83 c4 04             	add    $0x4,%esp
  802a62:	89 c2                	mov    %eax,%edx
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a6c:	75 07                	jne    802a75 <merging+0x39>
		prev_is_free = 1;
  802a6e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a79:	74 1e                	je     802a99 <merging+0x5d>
  802a7b:	ff 75 10             	pushl  0x10(%ebp)
  802a7e:	e8 98 f1 ff ff       	call   801c1b <get_block_size>
  802a83:	83 c4 04             	add    $0x4,%esp
  802a86:	89 c2                	mov    %eax,%edx
  802a88:	8b 45 10             	mov    0x10(%ebp),%eax
  802a8b:	01 d0                	add    %edx,%eax
  802a8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a90:	75 07                	jne    802a99 <merging+0x5d>
		next_is_free = 1;
  802a92:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9d:	0f 84 cc 00 00 00    	je     802b6f <merging+0x133>
  802aa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa7:	0f 84 c2 00 00 00    	je     802b6f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802aad:	ff 75 08             	pushl  0x8(%ebp)
  802ab0:	e8 66 f1 ff ff       	call   801c1b <get_block_size>
  802ab5:	83 c4 04             	add    $0x4,%esp
  802ab8:	89 c3                	mov    %eax,%ebx
  802aba:	ff 75 10             	pushl  0x10(%ebp)
  802abd:	e8 59 f1 ff ff       	call   801c1b <get_block_size>
  802ac2:	83 c4 04             	add    $0x4,%esp
  802ac5:	01 c3                	add    %eax,%ebx
  802ac7:	ff 75 0c             	pushl  0xc(%ebp)
  802aca:	e8 4c f1 ff ff       	call   801c1b <get_block_size>
  802acf:	83 c4 04             	add    $0x4,%esp
  802ad2:	01 d8                	add    %ebx,%eax
  802ad4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ad7:	6a 00                	push   $0x0
  802ad9:	ff 75 ec             	pushl  -0x14(%ebp)
  802adc:	ff 75 08             	pushl  0x8(%ebp)
  802adf:	e8 88 f4 ff ff       	call   801f6c <set_block_data>
  802ae4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ae7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aeb:	75 17                	jne    802b04 <merging+0xc8>
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	68 27 42 80 00       	push   $0x804227
  802af5:	68 7d 01 00 00       	push   $0x17d
  802afa:	68 45 42 80 00       	push   $0x804245
  802aff:	e8 d7 0c 00 00       	call   8037db <_panic>
  802b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b07:	8b 00                	mov    (%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 10                	je     802b1d <merging+0xe1>
  802b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b15:	8b 52 04             	mov    0x4(%edx),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 0b                	jmp    802b28 <merging+0xec>
  802b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	a3 30 50 80 00       	mov    %eax,0x805030
  802b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 0f                	je     802b41 <merging+0x105>
  802b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3b:	8b 12                	mov    (%edx),%edx
  802b3d:	89 10                	mov    %edx,(%eax)
  802b3f:	eb 0a                	jmp    802b4b <merging+0x10f>
  802b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b63:	48                   	dec    %eax
  802b64:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b69:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b6a:	e9 ea 02 00 00       	jmp    802e59 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b73:	74 3b                	je     802bb0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 08             	pushl  0x8(%ebp)
  802b7b:	e8 9b f0 ff ff       	call   801c1b <get_block_size>
  802b80:	83 c4 10             	add    $0x10,%esp
  802b83:	89 c3                	mov    %eax,%ebx
  802b85:	83 ec 0c             	sub    $0xc,%esp
  802b88:	ff 75 10             	pushl  0x10(%ebp)
  802b8b:	e8 8b f0 ff ff       	call   801c1b <get_block_size>
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	01 d8                	add    %ebx,%eax
  802b95:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	6a 00                	push   $0x0
  802b9d:	ff 75 e8             	pushl  -0x18(%ebp)
  802ba0:	ff 75 08             	pushl  0x8(%ebp)
  802ba3:	e8 c4 f3 ff ff       	call   801f6c <set_block_data>
  802ba8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bab:	e9 a9 02 00 00       	jmp    802e59 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb4:	0f 84 2d 01 00 00    	je     802ce7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bba:	83 ec 0c             	sub    $0xc,%esp
  802bbd:	ff 75 10             	pushl  0x10(%ebp)
  802bc0:	e8 56 f0 ff ff       	call   801c1b <get_block_size>
  802bc5:	83 c4 10             	add    $0x10,%esp
  802bc8:	89 c3                	mov    %eax,%ebx
  802bca:	83 ec 0c             	sub    $0xc,%esp
  802bcd:	ff 75 0c             	pushl  0xc(%ebp)
  802bd0:	e8 46 f0 ff ff       	call   801c1b <get_block_size>
  802bd5:	83 c4 10             	add    $0x10,%esp
  802bd8:	01 d8                	add    %ebx,%eax
  802bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	6a 00                	push   $0x0
  802be2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802be5:	ff 75 10             	pushl  0x10(%ebp)
  802be8:	e8 7f f3 ff ff       	call   801f6c <set_block_data>
  802bed:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802bf0:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802bf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfa:	74 06                	je     802c02 <merging+0x1c6>
  802bfc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c00:	75 17                	jne    802c19 <merging+0x1dd>
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	68 00 43 80 00       	push   $0x804300
  802c0a:	68 8d 01 00 00       	push   $0x18d
  802c0f:	68 45 42 80 00       	push   $0x804245
  802c14:	e8 c2 0b 00 00       	call   8037db <_panic>
  802c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1c:	8b 50 04             	mov    0x4(%eax),%edx
  802c1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c22:	89 50 04             	mov    %edx,0x4(%eax)
  802c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 0d                	je     802c44 <merging+0x208>
  802c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	eb 08                	jmp    802c4c <merging+0x210>
  802c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5a:	40                   	inc    %eax
  802c5b:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c64:	75 17                	jne    802c7d <merging+0x241>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 27 42 80 00       	push   $0x804227
  802c6e:	68 8e 01 00 00       	push   $0x18e
  802c73:	68 45 42 80 00       	push   $0x804245
  802c78:	e8 5e 0b 00 00       	call   8037db <_panic>
  802c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 10                	je     802c96 <merging+0x25a>
  802c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c8e:	8b 52 04             	mov    0x4(%edx),%edx
  802c91:	89 50 04             	mov    %edx,0x4(%eax)
  802c94:	eb 0b                	jmp    802ca1 <merging+0x265>
  802c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 0f                	je     802cba <merging+0x27e>
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb4:	8b 12                	mov    (%edx),%edx
  802cb6:	89 10                	mov    %edx,(%eax)
  802cb8:	eb 0a                	jmp    802cc4 <merging+0x288>
  802cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdc:	48                   	dec    %eax
  802cdd:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ce2:	e9 72 01 00 00       	jmp    802e59 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  802cea:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ced:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf1:	74 79                	je     802d6c <merging+0x330>
  802cf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cf7:	74 73                	je     802d6c <merging+0x330>
  802cf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfd:	74 06                	je     802d05 <merging+0x2c9>
  802cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d03:	75 17                	jne    802d1c <merging+0x2e0>
  802d05:	83 ec 04             	sub    $0x4,%esp
  802d08:	68 b8 42 80 00       	push   $0x8042b8
  802d0d:	68 94 01 00 00       	push   $0x194
  802d12:	68 45 42 80 00       	push   $0x804245
  802d17:	e8 bf 0a 00 00       	call   8037db <_panic>
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 10                	mov    (%eax),%edx
  802d21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0b                	je     802d3a <merging+0x2fe>
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d40:	89 10                	mov    %edx,(%eax)
  802d42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d45:	8b 55 08             	mov    0x8(%ebp),%edx
  802d48:	89 50 04             	mov    %edx,0x4(%eax)
  802d4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	75 08                	jne    802d5c <merging+0x320>
  802d54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d57:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5c:	a1 38 50 80 00       	mov    0x805038,%eax
  802d61:	40                   	inc    %eax
  802d62:	a3 38 50 80 00       	mov    %eax,0x805038
  802d67:	e9 ce 00 00 00       	jmp    802e3a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d70:	74 65                	je     802dd7 <merging+0x39b>
  802d72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d76:	75 17                	jne    802d8f <merging+0x353>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 94 42 80 00       	push   $0x804294
  802d80:	68 95 01 00 00       	push   $0x195
  802d85:	68 45 42 80 00       	push   $0x804245
  802d8a:	e8 4c 0a 00 00       	call   8037db <_panic>
  802d8f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d98:	89 50 04             	mov    %edx,0x4(%eax)
  802d9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0c                	je     802db1 <merging+0x375>
  802da5:	a1 30 50 80 00       	mov    0x805030,%eax
  802daa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dad:	89 10                	mov    %edx,(%eax)
  802daf:	eb 08                	jmp    802db9 <merging+0x37d>
  802db1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dca:	a1 38 50 80 00       	mov    0x805038,%eax
  802dcf:	40                   	inc    %eax
  802dd0:	a3 38 50 80 00       	mov    %eax,0x805038
  802dd5:	eb 63                	jmp    802e3a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802dd7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ddb:	75 17                	jne    802df4 <merging+0x3b8>
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 60 42 80 00       	push   $0x804260
  802de5:	68 98 01 00 00       	push   $0x198
  802dea:	68 45 42 80 00       	push   $0x804245
  802def:	e8 e7 09 00 00       	call   8037db <_panic>
  802df4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802dfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfd:	89 10                	mov    %edx,(%eax)
  802dff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 0d                	je     802e15 <merging+0x3d9>
  802e08:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e10:	89 50 04             	mov    %edx,0x4(%eax)
  802e13:	eb 08                	jmp    802e1d <merging+0x3e1>
  802e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e18:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e20:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2f:	a1 38 50 80 00       	mov    0x805038,%eax
  802e34:	40                   	inc    %eax
  802e35:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 10             	pushl  0x10(%ebp)
  802e40:	e8 d6 ed ff ff       	call   801c1b <get_block_size>
  802e45:	83 c4 10             	add    $0x10,%esp
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	6a 00                	push   $0x0
  802e4d:	50                   	push   %eax
  802e4e:	ff 75 10             	pushl  0x10(%ebp)
  802e51:	e8 16 f1 ff ff       	call   801f6c <set_block_data>
  802e56:	83 c4 10             	add    $0x10,%esp
	}
}
  802e59:	90                   	nop
  802e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
  802e62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e65:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e6d:	a1 30 50 80 00       	mov    0x805030,%eax
  802e72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e75:	73 1b                	jae    802e92 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e77:	a1 30 50 80 00       	mov    0x805030,%eax
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	ff 75 08             	pushl  0x8(%ebp)
  802e82:	6a 00                	push   $0x0
  802e84:	50                   	push   %eax
  802e85:	e8 b2 fb ff ff       	call   802a3c <merging>
  802e8a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e8d:	e9 8b 00 00 00       	jmp    802f1d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e92:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e97:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9a:	76 18                	jbe    802eb4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e9c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	ff 75 08             	pushl  0x8(%ebp)
  802ea7:	50                   	push   %eax
  802ea8:	6a 00                	push   $0x0
  802eaa:	e8 8d fb ff ff       	call   802a3c <merging>
  802eaf:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802eb2:	eb 69                	jmp    802f1d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eb4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebc:	eb 39                	jmp    802ef7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec4:	73 29                	jae    802eef <free_block+0x90>
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ece:	76 1f                	jbe    802eef <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ed8:	83 ec 04             	sub    $0x4,%esp
  802edb:	ff 75 08             	pushl  0x8(%ebp)
  802ede:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee4:	e8 53 fb ff ff       	call   802a3c <merging>
  802ee9:	83 c4 10             	add    $0x10,%esp
			break;
  802eec:	90                   	nop
		}
	}
}
  802eed:	eb 2e                	jmp    802f1d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eef:	a1 34 50 80 00       	mov    0x805034,%eax
  802ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efb:	74 07                	je     802f04 <free_block+0xa5>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	eb 05                	jmp    802f09 <free_block+0xaa>
  802f04:	b8 00 00 00 00       	mov    $0x0,%eax
  802f09:	a3 34 50 80 00       	mov    %eax,0x805034
  802f0e:	a1 34 50 80 00       	mov    0x805034,%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	75 a7                	jne    802ebe <free_block+0x5f>
  802f17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1b:	75 a1                	jne    802ebe <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f1d:	90                   	nop
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	e8 ed ec ff ff       	call   801c1b <get_block_size>
  802f2e:	83 c4 04             	add    $0x4,%esp
  802f31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f3b:	eb 17                	jmp    802f54 <copy_data+0x34>
  802f3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f43:	01 c2                	add    %eax,%edx
  802f45:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	01 c8                	add    %ecx,%eax
  802f4d:	8a 00                	mov    (%eax),%al
  802f4f:	88 02                	mov    %al,(%edx)
  802f51:	ff 45 fc             	incl   -0x4(%ebp)
  802f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f5a:	72 e1                	jb     802f3d <copy_data+0x1d>
}
  802f5c:	90                   	nop
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
  802f62:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 23                	jne    802f8e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6f:	74 13                	je     802f84 <realloc_block_FF+0x25>
  802f71:	83 ec 0c             	sub    $0xc,%esp
  802f74:	ff 75 0c             	pushl  0xc(%ebp)
  802f77:	e8 1f f0 ff ff       	call   801f9b <alloc_block_FF>
  802f7c:	83 c4 10             	add    $0x10,%esp
  802f7f:	e9 f4 06 00 00       	jmp    803678 <realloc_block_FF+0x719>
		return NULL;
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	e9 ea 06 00 00       	jmp    803678 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	75 18                	jne    802fac <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f94:	83 ec 0c             	sub    $0xc,%esp
  802f97:	ff 75 08             	pushl  0x8(%ebp)
  802f9a:	e8 c0 fe ff ff       	call   802e5f <free_block>
  802f9f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa7:	e9 cc 06 00 00       	jmp    803678 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fac:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fb0:	77 07                	ja     802fb9 <realloc_block_FF+0x5a>
  802fb2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbc:	83 e0 01             	and    $0x1,%eax
  802fbf:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc5:	83 c0 08             	add    $0x8,%eax
  802fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	ff 75 08             	pushl  0x8(%ebp)
  802fd1:	e8 45 ec ff ff       	call   801c1b <get_block_size>
  802fd6:	83 c4 10             	add    $0x10,%esp
  802fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdf:	83 e8 08             	sub    $0x8,%eax
  802fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	83 e8 04             	sub    $0x4,%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	83 e0 fe             	and    $0xfffffffe,%eax
  802ff0:	89 c2                	mov    %eax,%edx
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	01 d0                	add    %edx,%eax
  802ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802ffa:	83 ec 0c             	sub    $0xc,%esp
  802ffd:	ff 75 e4             	pushl  -0x1c(%ebp)
  803000:	e8 16 ec ff ff       	call   801c1b <get_block_size>
  803005:	83 c4 10             	add    $0x10,%esp
  803008:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80300b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300e:	83 e8 08             	sub    $0x8,%eax
  803011:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80301a:	75 08                	jne    803024 <realloc_block_FF+0xc5>
	{
		 return va;
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	e9 54 06 00 00       	jmp    803678 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80302a:	0f 83 e5 03 00 00    	jae    803415 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	2b 45 0c             	sub    0xc(%ebp),%eax
  803036:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803039:	83 ec 0c             	sub    $0xc,%esp
  80303c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80303f:	e8 f0 eb ff ff       	call   801c34 <is_free_block>
  803044:	83 c4 10             	add    $0x10,%esp
  803047:	84 c0                	test   %al,%al
  803049:	0f 84 3b 01 00 00    	je     80318a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80304f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803052:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803055:	01 d0                	add    %edx,%eax
  803057:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	6a 01                	push   $0x1
  80305f:	ff 75 f0             	pushl  -0x10(%ebp)
  803062:	ff 75 08             	pushl  0x8(%ebp)
  803065:	e8 02 ef ff ff       	call   801f6c <set_block_data>
  80306a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	83 e8 04             	sub    $0x4,%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	83 e0 fe             	and    $0xfffffffe,%eax
  803078:	89 c2                	mov    %eax,%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	01 d0                	add    %edx,%eax
  80307f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	6a 00                	push   $0x0
  803087:	ff 75 cc             	pushl  -0x34(%ebp)
  80308a:	ff 75 c8             	pushl  -0x38(%ebp)
  80308d:	e8 da ee ff ff       	call   801f6c <set_block_data>
  803092:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803095:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803099:	74 06                	je     8030a1 <realloc_block_FF+0x142>
  80309b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80309f:	75 17                	jne    8030b8 <realloc_block_FF+0x159>
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 b8 42 80 00       	push   $0x8042b8
  8030a9:	68 f6 01 00 00       	push   $0x1f6
  8030ae:	68 45 42 80 00       	push   $0x804245
  8030b3:	e8 23 07 00 00       	call   8037db <_panic>
  8030b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bb:	8b 10                	mov    (%eax),%edx
  8030bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c0:	89 10                	mov    %edx,(%eax)
  8030c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	74 0b                	je     8030d6 <realloc_block_FF+0x177>
  8030cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e4:	89 50 04             	mov    %edx,0x4(%eax)
  8030e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030ea:	8b 00                	mov    (%eax),%eax
  8030ec:	85 c0                	test   %eax,%eax
  8030ee:	75 08                	jne    8030f8 <realloc_block_FF+0x199>
  8030f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fd:	40                   	inc    %eax
  8030fe:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803103:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803107:	75 17                	jne    803120 <realloc_block_FF+0x1c1>
  803109:	83 ec 04             	sub    $0x4,%esp
  80310c:	68 27 42 80 00       	push   $0x804227
  803111:	68 f7 01 00 00       	push   $0x1f7
  803116:	68 45 42 80 00       	push   $0x804245
  80311b:	e8 bb 06 00 00       	call   8037db <_panic>
  803120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 10                	je     803139 <realloc_block_FF+0x1da>
  803129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803131:	8b 52 04             	mov    0x4(%edx),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 0b                	jmp    803144 <realloc_block_FF+0x1e5>
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	a3 30 50 80 00       	mov    %eax,0x805030
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0f                	je     80315d <realloc_block_FF+0x1fe>
  80314e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803151:	8b 40 04             	mov    0x4(%eax),%eax
  803154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803157:	8b 12                	mov    (%edx),%edx
  803159:	89 10                	mov    %edx,(%eax)
  80315b:	eb 0a                	jmp    803167 <realloc_block_FF+0x208>
  80315d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317a:	a1 38 50 80 00       	mov    0x805038,%eax
  80317f:	48                   	dec    %eax
  803180:	a3 38 50 80 00       	mov    %eax,0x805038
  803185:	e9 83 02 00 00       	jmp    80340d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80318a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80318e:	0f 86 69 02 00 00    	jbe    8033fd <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	6a 01                	push   $0x1
  803199:	ff 75 f0             	pushl  -0x10(%ebp)
  80319c:	ff 75 08             	pushl  0x8(%ebp)
  80319f:	e8 c8 ed ff ff       	call   801f6c <set_block_data>
  8031a4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	83 e8 04             	sub    $0x4,%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b2:	89 c2                	mov    %eax,%edx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	01 d0                	add    %edx,%eax
  8031b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031c4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031c8:	75 68                	jne    803232 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031ce:	75 17                	jne    8031e7 <realloc_block_FF+0x288>
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	68 60 42 80 00       	push   $0x804260
  8031d8:	68 06 02 00 00       	push   $0x206
  8031dd:	68 45 42 80 00       	push   $0x804245
  8031e2:	e8 f4 05 00 00       	call   8037db <_panic>
  8031e7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 0d                	je     803208 <realloc_block_FF+0x2a9>
  8031fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803200:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 08                	jmp    803210 <realloc_block_FF+0x2b1>
  803208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320b:	a3 30 50 80 00       	mov    %eax,0x805030
  803210:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803213:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803222:	a1 38 50 80 00       	mov    0x805038,%eax
  803227:	40                   	inc    %eax
  803228:	a3 38 50 80 00       	mov    %eax,0x805038
  80322d:	e9 b0 01 00 00       	jmp    8033e2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803232:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803237:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80323a:	76 68                	jbe    8032a4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80323c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803240:	75 17                	jne    803259 <realloc_block_FF+0x2fa>
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	68 60 42 80 00       	push   $0x804260
  80324a:	68 0b 02 00 00       	push   $0x20b
  80324f:	68 45 42 80 00       	push   $0x804245
  803254:	e8 82 05 00 00       	call   8037db <_panic>
  803259:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80325f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803262:	89 10                	mov    %edx,(%eax)
  803264:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0d                	je     80327a <realloc_block_FF+0x31b>
  80326d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803272:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803275:	89 50 04             	mov    %edx,0x4(%eax)
  803278:	eb 08                	jmp    803282 <realloc_block_FF+0x323>
  80327a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327d:	a3 30 50 80 00       	mov    %eax,0x805030
  803282:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803285:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803294:	a1 38 50 80 00       	mov    0x805038,%eax
  803299:	40                   	inc    %eax
  80329a:	a3 38 50 80 00       	mov    %eax,0x805038
  80329f:	e9 3e 01 00 00       	jmp    8033e2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032ac:	73 68                	jae    803316 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b2:	75 17                	jne    8032cb <realloc_block_FF+0x36c>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 94 42 80 00       	push   $0x804294
  8032bc:	68 10 02 00 00       	push   $0x210
  8032c1:	68 45 42 80 00       	push   $0x804245
  8032c6:	e8 10 05 00 00       	call   8037db <_panic>
  8032cb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d4:	89 50 04             	mov    %edx,0x4(%eax)
  8032d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0c                	je     8032ed <realloc_block_FF+0x38e>
  8032e1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	eb 08                	jmp    8032f5 <realloc_block_FF+0x396>
  8032ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8032fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803306:	a1 38 50 80 00       	mov    0x805038,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 38 50 80 00       	mov    %eax,0x805038
  803311:	e9 cc 00 00 00       	jmp    8033e2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803316:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80331d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803325:	e9 8a 00 00 00       	jmp    8033b4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803330:	73 7a                	jae    8033ac <realloc_block_FF+0x44d>
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80333a:	73 70                	jae    8033ac <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80333c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803340:	74 06                	je     803348 <realloc_block_FF+0x3e9>
  803342:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803346:	75 17                	jne    80335f <realloc_block_FF+0x400>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 b8 42 80 00       	push   $0x8042b8
  803350:	68 1a 02 00 00       	push   $0x21a
  803355:	68 45 42 80 00       	push   $0x804245
  80335a:	e8 7c 04 00 00       	call   8037db <_panic>
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 10                	mov    (%eax),%edx
  803364:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803367:	89 10                	mov    %edx,(%eax)
  803369:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0b                	je     80337d <realloc_block_FF+0x41e>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 00                	mov    (%eax),%eax
  803377:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	75 08                	jne    80339f <realloc_block_FF+0x440>
  803397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339a:	a3 30 50 80 00       	mov    %eax,0x805030
  80339f:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a4:	40                   	inc    %eax
  8033a5:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033aa:	eb 36                	jmp    8033e2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b8:	74 07                	je     8033c1 <realloc_block_FF+0x462>
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	eb 05                	jmp    8033c6 <realloc_block_FF+0x467>
  8033c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c6:	a3 34 50 80 00       	mov    %eax,0x805034
  8033cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	0f 85 52 ff ff ff    	jne    80332a <realloc_block_FF+0x3cb>
  8033d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dc:	0f 85 48 ff ff ff    	jne    80332a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	6a 00                	push   $0x0
  8033e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8033ea:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033ed:	e8 7a eb ff ff       	call   801f6c <set_block_data>
  8033f2:	83 c4 10             	add    $0x10,%esp
				return va;
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	e9 7b 02 00 00       	jmp    803678 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033fd:	83 ec 0c             	sub    $0xc,%esp
  803400:	68 35 43 80 00       	push   $0x804335
  803405:	e8 86 cf ff ff       	call   800390 <cprintf>
  80340a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	e9 63 02 00 00       	jmp    803678 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803415:	8b 45 0c             	mov    0xc(%ebp),%eax
  803418:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80341b:	0f 86 4d 02 00 00    	jbe    80366e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803421:	83 ec 0c             	sub    $0xc,%esp
  803424:	ff 75 e4             	pushl  -0x1c(%ebp)
  803427:	e8 08 e8 ff ff       	call   801c34 <is_free_block>
  80342c:	83 c4 10             	add    $0x10,%esp
  80342f:	84 c0                	test   %al,%al
  803431:	0f 84 37 02 00 00    	je     80366e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80343d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803440:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803443:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803446:	76 38                	jbe    803480 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803448:	83 ec 0c             	sub    $0xc,%esp
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	e8 0c fa ff ff       	call   802e5f <free_block>
  803453:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803456:	83 ec 0c             	sub    $0xc,%esp
  803459:	ff 75 0c             	pushl  0xc(%ebp)
  80345c:	e8 3a eb ff ff       	call   801f9b <alloc_block_FF>
  803461:	83 c4 10             	add    $0x10,%esp
  803464:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803467:	83 ec 08             	sub    $0x8,%esp
  80346a:	ff 75 c0             	pushl  -0x40(%ebp)
  80346d:	ff 75 08             	pushl  0x8(%ebp)
  803470:	e8 ab fa ff ff       	call   802f20 <copy_data>
  803475:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803478:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80347b:	e9 f8 01 00 00       	jmp    803678 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803483:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803486:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803489:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80348d:	0f 87 a0 00 00 00    	ja     803533 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803493:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803497:	75 17                	jne    8034b0 <realloc_block_FF+0x551>
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 27 42 80 00       	push   $0x804227
  8034a1:	68 38 02 00 00       	push   $0x238
  8034a6:	68 45 42 80 00       	push   $0x804245
  8034ab:	e8 2b 03 00 00       	call   8037db <_panic>
  8034b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 10                	je     8034c9 <realloc_block_FF+0x56a>
  8034b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c1:	8b 52 04             	mov    0x4(%edx),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	eb 0b                	jmp    8034d4 <realloc_block_FF+0x575>
  8034c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cc:	8b 40 04             	mov    0x4(%eax),%eax
  8034cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	8b 40 04             	mov    0x4(%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	74 0f                	je     8034ed <realloc_block_FF+0x58e>
  8034de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e7:	8b 12                	mov    (%edx),%edx
  8034e9:	89 10                	mov    %edx,(%eax)
  8034eb:	eb 0a                	jmp    8034f7 <realloc_block_FF+0x598>
  8034ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350a:	a1 38 50 80 00       	mov    0x805038,%eax
  80350f:	48                   	dec    %eax
  803510:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803515:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351b:	01 d0                	add    %edx,%eax
  80351d:	83 ec 04             	sub    $0x4,%esp
  803520:	6a 01                	push   $0x1
  803522:	50                   	push   %eax
  803523:	ff 75 08             	pushl  0x8(%ebp)
  803526:	e8 41 ea ff ff       	call   801f6c <set_block_data>
  80352b:	83 c4 10             	add    $0x10,%esp
  80352e:	e9 36 01 00 00       	jmp    803669 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803533:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803536:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80353e:	83 ec 04             	sub    $0x4,%esp
  803541:	6a 01                	push   $0x1
  803543:	ff 75 f0             	pushl  -0x10(%ebp)
  803546:	ff 75 08             	pushl  0x8(%ebp)
  803549:	e8 1e ea ff ff       	call   801f6c <set_block_data>
  80354e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	83 e8 04             	sub    $0x4,%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	83 e0 fe             	and    $0xfffffffe,%eax
  80355c:	89 c2                	mov    %eax,%edx
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	01 d0                	add    %edx,%eax
  803563:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803566:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356a:	74 06                	je     803572 <realloc_block_FF+0x613>
  80356c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803570:	75 17                	jne    803589 <realloc_block_FF+0x62a>
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	68 b8 42 80 00       	push   $0x8042b8
  80357a:	68 44 02 00 00       	push   $0x244
  80357f:	68 45 42 80 00       	push   $0x804245
  803584:	e8 52 02 00 00       	call   8037db <_panic>
  803589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358c:	8b 10                	mov    (%eax),%edx
  80358e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803591:	89 10                	mov    %edx,(%eax)
  803593:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 0b                	je     8035a7 <realloc_block_FF+0x648>
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035a4:	89 50 04             	mov    %edx,0x4(%eax)
  8035a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035ad:	89 10                	mov    %edx,(%eax)
  8035af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b5:	89 50 04             	mov    %edx,0x4(%eax)
  8035b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	75 08                	jne    8035c9 <realloc_block_FF+0x66a>
  8035c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ce:	40                   	inc    %eax
  8035cf:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d8:	75 17                	jne    8035f1 <realloc_block_FF+0x692>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 27 42 80 00       	push   $0x804227
  8035e2:	68 45 02 00 00       	push   $0x245
  8035e7:	68 45 42 80 00       	push   $0x804245
  8035ec:	e8 ea 01 00 00       	call   8037db <_panic>
  8035f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 10                	je     80360a <realloc_block_FF+0x6ab>
  8035fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803602:	8b 52 04             	mov    0x4(%edx),%edx
  803605:	89 50 04             	mov    %edx,0x4(%eax)
  803608:	eb 0b                	jmp    803615 <realloc_block_FF+0x6b6>
  80360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360d:	8b 40 04             	mov    0x4(%eax),%eax
  803610:	a3 30 50 80 00       	mov    %eax,0x805030
  803615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803618:	8b 40 04             	mov    0x4(%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0f                	je     80362e <realloc_block_FF+0x6cf>
  80361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803628:	8b 12                	mov    (%edx),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 0a                	jmp    803638 <realloc_block_FF+0x6d9>
  80362e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364b:	a1 38 50 80 00       	mov    0x805038,%eax
  803650:	48                   	dec    %eax
  803651:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	6a 00                	push   $0x0
  80365b:	ff 75 bc             	pushl  -0x44(%ebp)
  80365e:	ff 75 b8             	pushl  -0x48(%ebp)
  803661:	e8 06 e9 ff ff       	call   801f6c <set_block_data>
  803666:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	eb 0a                	jmp    803678 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80366e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803678:	c9                   	leave  
  803679:	c3                   	ret    

0080367a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80367a:	55                   	push   %ebp
  80367b:	89 e5                	mov    %esp,%ebp
  80367d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803680:	83 ec 04             	sub    $0x4,%esp
  803683:	68 3c 43 80 00       	push   $0x80433c
  803688:	68 58 02 00 00       	push   $0x258
  80368d:	68 45 42 80 00       	push   $0x804245
  803692:	e8 44 01 00 00       	call   8037db <_panic>

00803697 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803697:	55                   	push   %ebp
  803698:	89 e5                	mov    %esp,%ebp
  80369a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80369d:	83 ec 04             	sub    $0x4,%esp
  8036a0:	68 64 43 80 00       	push   $0x804364
  8036a5:	68 61 02 00 00       	push   $0x261
  8036aa:	68 45 42 80 00       	push   $0x804245
  8036af:	e8 27 01 00 00       	call   8037db <_panic>

008036b4 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036b4:	55                   	push   %ebp
  8036b5:	89 e5                	mov    %esp,%ebp
  8036b7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	68 8c 43 80 00       	push   $0x80438c
  8036c2:	6a 09                	push   $0x9
  8036c4:	68 b4 43 80 00       	push   $0x8043b4
  8036c9:	e8 0d 01 00 00       	call   8037db <_panic>

008036ce <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8036ce:	55                   	push   %ebp
  8036cf:	89 e5                	mov    %esp,%ebp
  8036d1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8036d4:	83 ec 04             	sub    $0x4,%esp
  8036d7:	68 c4 43 80 00       	push   $0x8043c4
  8036dc:	6a 10                	push   $0x10
  8036de:	68 b4 43 80 00       	push   $0x8043b4
  8036e3:	e8 f3 00 00 00       	call   8037db <_panic>

008036e8 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8036e8:	55                   	push   %ebp
  8036e9:	89 e5                	mov    %esp,%ebp
  8036eb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8036ee:	83 ec 04             	sub    $0x4,%esp
  8036f1:	68 ec 43 80 00       	push   $0x8043ec
  8036f6:	6a 18                	push   $0x18
  8036f8:	68 b4 43 80 00       	push   $0x8043b4
  8036fd:	e8 d9 00 00 00       	call   8037db <_panic>

00803702 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803702:	55                   	push   %ebp
  803703:	89 e5                	mov    %esp,%ebp
  803705:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803708:	83 ec 04             	sub    $0x4,%esp
  80370b:	68 14 44 80 00       	push   $0x804414
  803710:	6a 20                	push   $0x20
  803712:	68 b4 43 80 00       	push   $0x8043b4
  803717:	e8 bf 00 00 00       	call   8037db <_panic>

0080371c <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80371c:	55                   	push   %ebp
  80371d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	8b 40 10             	mov    0x10(%eax),%eax
}
  803725:	5d                   	pop    %ebp
  803726:	c3                   	ret    

00803727 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
  80372a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80372d:	8b 55 08             	mov    0x8(%ebp),%edx
  803730:	89 d0                	mov    %edx,%eax
  803732:	c1 e0 02             	shl    $0x2,%eax
  803735:	01 d0                	add    %edx,%eax
  803737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80373e:	01 d0                	add    %edx,%eax
  803740:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803747:	01 d0                	add    %edx,%eax
  803749:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803750:	01 d0                	add    %edx,%eax
  803752:	c1 e0 04             	shl    $0x4,%eax
  803755:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80375f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803762:	83 ec 0c             	sub    $0xc,%esp
  803765:	50                   	push   %eax
  803766:	e8 bc e1 ff ff       	call   801927 <sys_get_virtual_time>
  80376b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80376e:	eb 41                	jmp    8037b1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803770:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803773:	83 ec 0c             	sub    $0xc,%esp
  803776:	50                   	push   %eax
  803777:	e8 ab e1 ff ff       	call   801927 <sys_get_virtual_time>
  80377c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80377f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803785:	29 c2                	sub    %eax,%edx
  803787:	89 d0                	mov    %edx,%eax
  803789:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80378c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80378f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803792:	89 d1                	mov    %edx,%ecx
  803794:	29 c1                	sub    %eax,%ecx
  803796:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379c:	39 c2                	cmp    %eax,%edx
  80379e:	0f 97 c0             	seta   %al
  8037a1:	0f b6 c0             	movzbl %al,%eax
  8037a4:	29 c1                	sub    %eax,%ecx
  8037a6:	89 c8                	mov    %ecx,%eax
  8037a8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037b7:	72 b7                	jb     803770 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037b9:	90                   	nop
  8037ba:	c9                   	leave  
  8037bb:	c3                   	ret    

008037bc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037bc:	55                   	push   %ebp
  8037bd:	89 e5                	mov    %esp,%ebp
  8037bf:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037c9:	eb 03                	jmp    8037ce <busy_wait+0x12>
  8037cb:	ff 45 fc             	incl   -0x4(%ebp)
  8037ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d4:	72 f5                	jb     8037cb <busy_wait+0xf>
	return i;
  8037d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037d9:	c9                   	leave  
  8037da:	c3                   	ret    

008037db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037db:	55                   	push   %ebp
  8037dc:	89 e5                	mov    %esp,%ebp
  8037de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8037e4:	83 c0 04             	add    $0x4,%eax
  8037e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037ea:	a1 60 50 90 00       	mov    0x905060,%eax
  8037ef:	85 c0                	test   %eax,%eax
  8037f1:	74 16                	je     803809 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037f3:	a1 60 50 90 00       	mov    0x905060,%eax
  8037f8:	83 ec 08             	sub    $0x8,%esp
  8037fb:	50                   	push   %eax
  8037fc:	68 3c 44 80 00       	push   $0x80443c
  803801:	e8 8a cb ff ff       	call   800390 <cprintf>
  803806:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803809:	a1 00 50 80 00       	mov    0x805000,%eax
  80380e:	ff 75 0c             	pushl  0xc(%ebp)
  803811:	ff 75 08             	pushl  0x8(%ebp)
  803814:	50                   	push   %eax
  803815:	68 41 44 80 00       	push   $0x804441
  80381a:	e8 71 cb ff ff       	call   800390 <cprintf>
  80381f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803822:	8b 45 10             	mov    0x10(%ebp),%eax
  803825:	83 ec 08             	sub    $0x8,%esp
  803828:	ff 75 f4             	pushl  -0xc(%ebp)
  80382b:	50                   	push   %eax
  80382c:	e8 f4 ca ff ff       	call   800325 <vcprintf>
  803831:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803834:	83 ec 08             	sub    $0x8,%esp
  803837:	6a 00                	push   $0x0
  803839:	68 5d 44 80 00       	push   $0x80445d
  80383e:	e8 e2 ca ff ff       	call   800325 <vcprintf>
  803843:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803846:	e8 63 ca ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  80384b:	eb fe                	jmp    80384b <_panic+0x70>

0080384d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80384d:	55                   	push   %ebp
  80384e:	89 e5                	mov    %esp,%ebp
  803850:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803853:	a1 20 50 80 00       	mov    0x805020,%eax
  803858:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80385e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803861:	39 c2                	cmp    %eax,%edx
  803863:	74 14                	je     803879 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803865:	83 ec 04             	sub    $0x4,%esp
  803868:	68 60 44 80 00       	push   $0x804460
  80386d:	6a 26                	push   $0x26
  80386f:	68 ac 44 80 00       	push   $0x8044ac
  803874:	e8 62 ff ff ff       	call   8037db <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803880:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803887:	e9 c5 00 00 00       	jmp    803951 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80388c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	01 d0                	add    %edx,%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	85 c0                	test   %eax,%eax
  80389f:	75 08                	jne    8038a9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038a1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038a4:	e9 a5 00 00 00       	jmp    80394e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038b7:	eb 69                	jmp    803922 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8038be:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c7:	89 d0                	mov    %edx,%eax
  8038c9:	01 c0                	add    %eax,%eax
  8038cb:	01 d0                	add    %edx,%eax
  8038cd:	c1 e0 03             	shl    $0x3,%eax
  8038d0:	01 c8                	add    %ecx,%eax
  8038d2:	8a 40 04             	mov    0x4(%eax),%al
  8038d5:	84 c0                	test   %al,%al
  8038d7:	75 46                	jne    80391f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8038de:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e7:	89 d0                	mov    %edx,%eax
  8038e9:	01 c0                	add    %eax,%eax
  8038eb:	01 d0                	add    %edx,%eax
  8038ed:	c1 e0 03             	shl    $0x3,%eax
  8038f0:	01 c8                	add    %ecx,%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038ff:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803904:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	01 c8                	add    %ecx,%eax
  803910:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803912:	39 c2                	cmp    %eax,%edx
  803914:	75 09                	jne    80391f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803916:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80391d:	eb 15                	jmp    803934 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80391f:	ff 45 e8             	incl   -0x18(%ebp)
  803922:	a1 20 50 80 00       	mov    0x805020,%eax
  803927:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	39 c2                	cmp    %eax,%edx
  803932:	77 85                	ja     8038b9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803934:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803938:	75 14                	jne    80394e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80393a:	83 ec 04             	sub    $0x4,%esp
  80393d:	68 b8 44 80 00       	push   $0x8044b8
  803942:	6a 3a                	push   $0x3a
  803944:	68 ac 44 80 00       	push   $0x8044ac
  803949:	e8 8d fe ff ff       	call   8037db <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80394e:	ff 45 f0             	incl   -0x10(%ebp)
  803951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803954:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803957:	0f 8c 2f ff ff ff    	jl     80388c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80395d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803964:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80396b:	eb 26                	jmp    803993 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80396d:	a1 20 50 80 00       	mov    0x805020,%eax
  803972:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803978:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80397b:	89 d0                	mov    %edx,%eax
  80397d:	01 c0                	add    %eax,%eax
  80397f:	01 d0                	add    %edx,%eax
  803981:	c1 e0 03             	shl    $0x3,%eax
  803984:	01 c8                	add    %ecx,%eax
  803986:	8a 40 04             	mov    0x4(%eax),%al
  803989:	3c 01                	cmp    $0x1,%al
  80398b:	75 03                	jne    803990 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80398d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803990:	ff 45 e0             	incl   -0x20(%ebp)
  803993:	a1 20 50 80 00       	mov    0x805020,%eax
  803998:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80399e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a1:	39 c2                	cmp    %eax,%edx
  8039a3:	77 c8                	ja     80396d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039ab:	74 14                	je     8039c1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	68 0c 45 80 00       	push   $0x80450c
  8039b5:	6a 44                	push   $0x44
  8039b7:	68 ac 44 80 00       	push   $0x8044ac
  8039bc:	e8 1a fe ff ff       	call   8037db <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039c1:	90                   	nop
  8039c2:	c9                   	leave  
  8039c3:	c3                   	ret    

008039c4 <__udivdi3>:
  8039c4:	55                   	push   %ebp
  8039c5:	57                   	push   %edi
  8039c6:	56                   	push   %esi
  8039c7:	53                   	push   %ebx
  8039c8:	83 ec 1c             	sub    $0x1c,%esp
  8039cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039db:	89 ca                	mov    %ecx,%edx
  8039dd:	89 f8                	mov    %edi,%eax
  8039df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039e3:	85 f6                	test   %esi,%esi
  8039e5:	75 2d                	jne    803a14 <__udivdi3+0x50>
  8039e7:	39 cf                	cmp    %ecx,%edi
  8039e9:	77 65                	ja     803a50 <__udivdi3+0x8c>
  8039eb:	89 fd                	mov    %edi,%ebp
  8039ed:	85 ff                	test   %edi,%edi
  8039ef:	75 0b                	jne    8039fc <__udivdi3+0x38>
  8039f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f6:	31 d2                	xor    %edx,%edx
  8039f8:	f7 f7                	div    %edi
  8039fa:	89 c5                	mov    %eax,%ebp
  8039fc:	31 d2                	xor    %edx,%edx
  8039fe:	89 c8                	mov    %ecx,%eax
  803a00:	f7 f5                	div    %ebp
  803a02:	89 c1                	mov    %eax,%ecx
  803a04:	89 d8                	mov    %ebx,%eax
  803a06:	f7 f5                	div    %ebp
  803a08:	89 cf                	mov    %ecx,%edi
  803a0a:	89 fa                	mov    %edi,%edx
  803a0c:	83 c4 1c             	add    $0x1c,%esp
  803a0f:	5b                   	pop    %ebx
  803a10:	5e                   	pop    %esi
  803a11:	5f                   	pop    %edi
  803a12:	5d                   	pop    %ebp
  803a13:	c3                   	ret    
  803a14:	39 ce                	cmp    %ecx,%esi
  803a16:	77 28                	ja     803a40 <__udivdi3+0x7c>
  803a18:	0f bd fe             	bsr    %esi,%edi
  803a1b:	83 f7 1f             	xor    $0x1f,%edi
  803a1e:	75 40                	jne    803a60 <__udivdi3+0x9c>
  803a20:	39 ce                	cmp    %ecx,%esi
  803a22:	72 0a                	jb     803a2e <__udivdi3+0x6a>
  803a24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a28:	0f 87 9e 00 00 00    	ja     803acc <__udivdi3+0x108>
  803a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a33:	89 fa                	mov    %edi,%edx
  803a35:	83 c4 1c             	add    $0x1c,%esp
  803a38:	5b                   	pop    %ebx
  803a39:	5e                   	pop    %esi
  803a3a:	5f                   	pop    %edi
  803a3b:	5d                   	pop    %ebp
  803a3c:	c3                   	ret    
  803a3d:	8d 76 00             	lea    0x0(%esi),%esi
  803a40:	31 ff                	xor    %edi,%edi
  803a42:	31 c0                	xor    %eax,%eax
  803a44:	89 fa                	mov    %edi,%edx
  803a46:	83 c4 1c             	add    $0x1c,%esp
  803a49:	5b                   	pop    %ebx
  803a4a:	5e                   	pop    %esi
  803a4b:	5f                   	pop    %edi
  803a4c:	5d                   	pop    %ebp
  803a4d:	c3                   	ret    
  803a4e:	66 90                	xchg   %ax,%ax
  803a50:	89 d8                	mov    %ebx,%eax
  803a52:	f7 f7                	div    %edi
  803a54:	31 ff                	xor    %edi,%edi
  803a56:	89 fa                	mov    %edi,%edx
  803a58:	83 c4 1c             	add    $0x1c,%esp
  803a5b:	5b                   	pop    %ebx
  803a5c:	5e                   	pop    %esi
  803a5d:	5f                   	pop    %edi
  803a5e:	5d                   	pop    %ebp
  803a5f:	c3                   	ret    
  803a60:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a65:	89 eb                	mov    %ebp,%ebx
  803a67:	29 fb                	sub    %edi,%ebx
  803a69:	89 f9                	mov    %edi,%ecx
  803a6b:	d3 e6                	shl    %cl,%esi
  803a6d:	89 c5                	mov    %eax,%ebp
  803a6f:	88 d9                	mov    %bl,%cl
  803a71:	d3 ed                	shr    %cl,%ebp
  803a73:	89 e9                	mov    %ebp,%ecx
  803a75:	09 f1                	or     %esi,%ecx
  803a77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a7b:	89 f9                	mov    %edi,%ecx
  803a7d:	d3 e0                	shl    %cl,%eax
  803a7f:	89 c5                	mov    %eax,%ebp
  803a81:	89 d6                	mov    %edx,%esi
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 ee                	shr    %cl,%esi
  803a87:	89 f9                	mov    %edi,%ecx
  803a89:	d3 e2                	shl    %cl,%edx
  803a8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a8f:	88 d9                	mov    %bl,%cl
  803a91:	d3 e8                	shr    %cl,%eax
  803a93:	09 c2                	or     %eax,%edx
  803a95:	89 d0                	mov    %edx,%eax
  803a97:	89 f2                	mov    %esi,%edx
  803a99:	f7 74 24 0c          	divl   0xc(%esp)
  803a9d:	89 d6                	mov    %edx,%esi
  803a9f:	89 c3                	mov    %eax,%ebx
  803aa1:	f7 e5                	mul    %ebp
  803aa3:	39 d6                	cmp    %edx,%esi
  803aa5:	72 19                	jb     803ac0 <__udivdi3+0xfc>
  803aa7:	74 0b                	je     803ab4 <__udivdi3+0xf0>
  803aa9:	89 d8                	mov    %ebx,%eax
  803aab:	31 ff                	xor    %edi,%edi
  803aad:	e9 58 ff ff ff       	jmp    803a0a <__udivdi3+0x46>
  803ab2:	66 90                	xchg   %ax,%ax
  803ab4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ab8:	89 f9                	mov    %edi,%ecx
  803aba:	d3 e2                	shl    %cl,%edx
  803abc:	39 c2                	cmp    %eax,%edx
  803abe:	73 e9                	jae    803aa9 <__udivdi3+0xe5>
  803ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ac3:	31 ff                	xor    %edi,%edi
  803ac5:	e9 40 ff ff ff       	jmp    803a0a <__udivdi3+0x46>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	31 c0                	xor    %eax,%eax
  803ace:	e9 37 ff ff ff       	jmp    803a0a <__udivdi3+0x46>
  803ad3:	90                   	nop

00803ad4 <__umoddi3>:
  803ad4:	55                   	push   %ebp
  803ad5:	57                   	push   %edi
  803ad6:	56                   	push   %esi
  803ad7:	53                   	push   %ebx
  803ad8:	83 ec 1c             	sub    $0x1c,%esp
  803adb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803adf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803af3:	89 f3                	mov    %esi,%ebx
  803af5:	89 fa                	mov    %edi,%edx
  803af7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803afb:	89 34 24             	mov    %esi,(%esp)
  803afe:	85 c0                	test   %eax,%eax
  803b00:	75 1a                	jne    803b1c <__umoddi3+0x48>
  803b02:	39 f7                	cmp    %esi,%edi
  803b04:	0f 86 a2 00 00 00    	jbe    803bac <__umoddi3+0xd8>
  803b0a:	89 c8                	mov    %ecx,%eax
  803b0c:	89 f2                	mov    %esi,%edx
  803b0e:	f7 f7                	div    %edi
  803b10:	89 d0                	mov    %edx,%eax
  803b12:	31 d2                	xor    %edx,%edx
  803b14:	83 c4 1c             	add    $0x1c,%esp
  803b17:	5b                   	pop    %ebx
  803b18:	5e                   	pop    %esi
  803b19:	5f                   	pop    %edi
  803b1a:	5d                   	pop    %ebp
  803b1b:	c3                   	ret    
  803b1c:	39 f0                	cmp    %esi,%eax
  803b1e:	0f 87 ac 00 00 00    	ja     803bd0 <__umoddi3+0xfc>
  803b24:	0f bd e8             	bsr    %eax,%ebp
  803b27:	83 f5 1f             	xor    $0x1f,%ebp
  803b2a:	0f 84 ac 00 00 00    	je     803bdc <__umoddi3+0x108>
  803b30:	bf 20 00 00 00       	mov    $0x20,%edi
  803b35:	29 ef                	sub    %ebp,%edi
  803b37:	89 fe                	mov    %edi,%esi
  803b39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b3d:	89 e9                	mov    %ebp,%ecx
  803b3f:	d3 e0                	shl    %cl,%eax
  803b41:	89 d7                	mov    %edx,%edi
  803b43:	89 f1                	mov    %esi,%ecx
  803b45:	d3 ef                	shr    %cl,%edi
  803b47:	09 c7                	or     %eax,%edi
  803b49:	89 e9                	mov    %ebp,%ecx
  803b4b:	d3 e2                	shl    %cl,%edx
  803b4d:	89 14 24             	mov    %edx,(%esp)
  803b50:	89 d8                	mov    %ebx,%eax
  803b52:	d3 e0                	shl    %cl,%eax
  803b54:	89 c2                	mov    %eax,%edx
  803b56:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b5a:	d3 e0                	shl    %cl,%eax
  803b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b60:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b64:	89 f1                	mov    %esi,%ecx
  803b66:	d3 e8                	shr    %cl,%eax
  803b68:	09 d0                	or     %edx,%eax
  803b6a:	d3 eb                	shr    %cl,%ebx
  803b6c:	89 da                	mov    %ebx,%edx
  803b6e:	f7 f7                	div    %edi
  803b70:	89 d3                	mov    %edx,%ebx
  803b72:	f7 24 24             	mull   (%esp)
  803b75:	89 c6                	mov    %eax,%esi
  803b77:	89 d1                	mov    %edx,%ecx
  803b79:	39 d3                	cmp    %edx,%ebx
  803b7b:	0f 82 87 00 00 00    	jb     803c08 <__umoddi3+0x134>
  803b81:	0f 84 91 00 00 00    	je     803c18 <__umoddi3+0x144>
  803b87:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b8b:	29 f2                	sub    %esi,%edx
  803b8d:	19 cb                	sbb    %ecx,%ebx
  803b8f:	89 d8                	mov    %ebx,%eax
  803b91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b95:	d3 e0                	shl    %cl,%eax
  803b97:	89 e9                	mov    %ebp,%ecx
  803b99:	d3 ea                	shr    %cl,%edx
  803b9b:	09 d0                	or     %edx,%eax
  803b9d:	89 e9                	mov    %ebp,%ecx
  803b9f:	d3 eb                	shr    %cl,%ebx
  803ba1:	89 da                	mov    %ebx,%edx
  803ba3:	83 c4 1c             	add    $0x1c,%esp
  803ba6:	5b                   	pop    %ebx
  803ba7:	5e                   	pop    %esi
  803ba8:	5f                   	pop    %edi
  803ba9:	5d                   	pop    %ebp
  803baa:	c3                   	ret    
  803bab:	90                   	nop
  803bac:	89 fd                	mov    %edi,%ebp
  803bae:	85 ff                	test   %edi,%edi
  803bb0:	75 0b                	jne    803bbd <__umoddi3+0xe9>
  803bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb7:	31 d2                	xor    %edx,%edx
  803bb9:	f7 f7                	div    %edi
  803bbb:	89 c5                	mov    %eax,%ebp
  803bbd:	89 f0                	mov    %esi,%eax
  803bbf:	31 d2                	xor    %edx,%edx
  803bc1:	f7 f5                	div    %ebp
  803bc3:	89 c8                	mov    %ecx,%eax
  803bc5:	f7 f5                	div    %ebp
  803bc7:	89 d0                	mov    %edx,%eax
  803bc9:	e9 44 ff ff ff       	jmp    803b12 <__umoddi3+0x3e>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	89 c8                	mov    %ecx,%eax
  803bd2:	89 f2                	mov    %esi,%edx
  803bd4:	83 c4 1c             	add    $0x1c,%esp
  803bd7:	5b                   	pop    %ebx
  803bd8:	5e                   	pop    %esi
  803bd9:	5f                   	pop    %edi
  803bda:	5d                   	pop    %ebp
  803bdb:	c3                   	ret    
  803bdc:	3b 04 24             	cmp    (%esp),%eax
  803bdf:	72 06                	jb     803be7 <__umoddi3+0x113>
  803be1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803be5:	77 0f                	ja     803bf6 <__umoddi3+0x122>
  803be7:	89 f2                	mov    %esi,%edx
  803be9:	29 f9                	sub    %edi,%ecx
  803beb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bef:	89 14 24             	mov    %edx,(%esp)
  803bf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bf6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bfa:	8b 14 24             	mov    (%esp),%edx
  803bfd:	83 c4 1c             	add    $0x1c,%esp
  803c00:	5b                   	pop    %ebx
  803c01:	5e                   	pop    %esi
  803c02:	5f                   	pop    %edi
  803c03:	5d                   	pop    %ebp
  803c04:	c3                   	ret    
  803c05:	8d 76 00             	lea    0x0(%esi),%esi
  803c08:	2b 04 24             	sub    (%esp),%eax
  803c0b:	19 fa                	sbb    %edi,%edx
  803c0d:	89 d1                	mov    %edx,%ecx
  803c0f:	89 c6                	mov    %eax,%esi
  803c11:	e9 71 ff ff ff       	jmp    803b87 <__umoddi3+0xb3>
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c1c:	72 ea                	jb     803c08 <__umoddi3+0x134>
  803c1e:	89 d9                	mov    %ebx,%ecx
  803c20:	e9 62 ff ff ff       	jmp    803b87 <__umoddi3+0xb3>
