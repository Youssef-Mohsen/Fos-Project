
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
  80003e:	e8 1c 19 00 00       	call   80195f <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 3e 80 00       	push   $0x803e60
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 ad 14 00 00       	call   801503 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 3e 80 00       	push   $0x803e62
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 97 14 00 00       	call   801503 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 3e 80 00       	push   $0x803e69
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 81 14 00 00       	call   801503 <sget>
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
  800098:	68 77 3e 80 00       	push   $0x803e77
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 56 37 00 00       	call   8037fc <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 93 37 00 00       	call   803847 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 cf 18 00 00       	call   801992 <sys_get_virtual_time>
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
  8000e6:	e8 5b 38 00 00       	call   803946 <env_sleep>
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
  8000fe:	e8 8f 18 00 00       	call   801992 <sys_get_virtual_time>
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
  800126:	e8 1b 38 00 00       	call   803946 <env_sleep>
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
  80013d:	e8 50 18 00 00       	call   801992 <sys_get_virtual_time>
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
  800165:	e8 dc 37 00 00       	call   803946 <env_sleep>
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
  800183:	e8 be 17 00 00       	call   801946 <sys_getenvindex>
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
  8001f1:	e8 d4 14 00 00       	call   8016ca <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 94 3e 80 00       	push   $0x803e94
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
  800221:	68 bc 3e 80 00       	push   $0x803ebc
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
  800252:	68 e4 3e 80 00       	push   $0x803ee4
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 3c 3f 80 00       	push   $0x803f3c
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 94 3e 80 00       	push   $0x803e94
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 54 14 00 00       	call   8016e4 <sys_unlock_cons>
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
  8002a3:	e8 6a 16 00 00       	call   801912 <sys_destroy_env>
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
  8002b4:	e8 bf 16 00 00       	call   801978 <sys_exit_env>
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
  800302:	e8 81 13 00 00       	call   801688 <sys_cputs>
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
  800379:	e8 0a 13 00 00       	call   801688 <sys_cputs>
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
  8003c3:	e8 02 13 00 00       	call   8016ca <sys_lock_cons>
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
  8003e3:	e8 fc 12 00 00       	call   8016e4 <sys_unlock_cons>
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
  80042d:	e8 b2 37 00 00       	call   803be4 <__udivdi3>
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
  80047d:	e8 72 38 00 00       	call   803cf4 <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 74 41 80 00       	add    $0x804174,%eax
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
  8005d8:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  8006b9:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 85 41 80 00       	push   $0x804185
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
  8006de:	68 8e 41 80 00       	push   $0x80418e
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
  80070b:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801116:	68 08 43 80 00       	push   $0x804308
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 2a 43 80 00       	push   $0x80432a
  801125:	e8 d0 28 00 00       	call   8039fa <_panic>

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
  801136:	e8 f8 0a 00 00       	call   801c33 <sys_sbrk>
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
  8011b1:	e8 01 09 00 00       	call   801ab7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 dd 0e 00 00       	call   8020a2 <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 13 09 00 00       	call   801ae8 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 76 13 00 00       	call   80255e <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 40 78             	mov    0x78(%eax),%eax
  801224:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801227:	29 c2                	sub    %eax,%edx
  801229:	89 d0                	mov    %edx,%eax
  80122b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801230:	c1 e8 0c             	shr    $0xc,%eax
  801233:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80123a:	85 c0                	test   %eax,%eax
  80123c:	0f 85 ab 00 00 00    	jne    8012ed <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801245:	05 00 10 00 00       	add    $0x1000,%eax
  80124a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80124d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  801280:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801287:	85 c0                	test   %eax,%eax
  801289:	74 08                	je     801293 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  8012d7:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  8012ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f1:	75 16                	jne    801309 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012f3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012fa:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801301:	0f 86 15 ff ff ff    	jbe    80121c <malloc+0xdc>
  801307:	eb 01                	jmp    80130a <malloc+0x1ca>
				}
				

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
  801339:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	ff 75 f0             	pushl  -0x10(%ebp)
  801349:	e8 1c 09 00 00       	call   801c6a <sys_allocate_user_mem>
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	eb 07                	jmp    80135a <malloc+0x21a>
		
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
  801391:	e8 8c 09 00 00       	call   801d22 <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 9c 1b 00 00       	call   802f43 <free_block>
  8013a7:	83 c4 10             	add    $0x10,%esp
		}

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
  8013dc:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8013e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8013e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e9:	c1 e0 0c             	shl    $0xc,%eax
  8013ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8013ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f6:	eb 42                	jmp    80143a <free+0xdb>
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
  801419:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801420:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	52                   	push   %edx
  80142e:	50                   	push   %eax
  80142f:	e8 1a 08 00 00       	call   801c4e <sys_free_user_mem>
  801434:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801437:	ff 45 f4             	incl   -0xc(%ebp)
  80143a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801440:	72 b6                	jb     8013f8 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801442:	eb 17                	jmp    80145b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	68 38 43 80 00       	push   $0x804338
  80144c:	68 87 00 00 00       	push   $0x87
  801451:	68 62 43 80 00       	push   $0x804362
  801456:	e8 9f 25 00 00       	call   8039fa <_panic>
	}
}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 28             	sub    $0x28,%esp
  801464:	8b 45 10             	mov    0x10(%ebp),%eax
  801467:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80146a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146e:	75 0a                	jne    80147a <smalloc+0x1c>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	e9 87 00 00 00       	jmp    801501 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801480:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801487:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148d:	39 d0                	cmp    %edx,%eax
  80148f:	73 02                	jae    801493 <smalloc+0x35>
  801491:	89 d0                	mov    %edx,%eax
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	50                   	push   %eax
  801497:	e8 a4 fc ff ff       	call   801140 <malloc>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8014a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a6:	75 07                	jne    8014af <smalloc+0x51>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	eb 52                	jmp    801501 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014af:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	ff 75 08             	pushl  0x8(%ebp)
  8014bd:	e8 93 03 00 00       	call   801855 <sys_createSharedObject>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014cc:	74 06                	je     8014d4 <smalloc+0x76>
  8014ce:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d2:	75 07                	jne    8014db <smalloc+0x7d>
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	eb 26                	jmp    801501 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8014db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014de:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e3:	8b 40 78             	mov    0x78(%eax),%eax
  8014e6:	29 c2                	sub    %eax,%edx
  8014e8:	89 d0                	mov    %edx,%eax
  8014ea:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ef:	c1 e8 0c             	shr    $0xc,%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f7:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8014fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 68 03 00 00       	call   80187f <sys_getSizeOfSharedObject>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80151d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801521:	75 07                	jne    80152a <sget+0x27>
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	eb 7f                	jmp    8015a9 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80152a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801530:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801537:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153d:	39 d0                	cmp    %edx,%eax
  80153f:	73 02                	jae    801543 <sget+0x40>
  801541:	89 d0                	mov    %edx,%eax
  801543:	83 ec 0c             	sub    $0xc,%esp
  801546:	50                   	push   %eax
  801547:	e8 f4 fb ff ff       	call   801140 <malloc>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801552:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801556:	75 07                	jne    80155f <sget+0x5c>
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	eb 4a                	jmp    8015a9 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	ff 75 e8             	pushl  -0x18(%ebp)
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	ff 75 08             	pushl  0x8(%ebp)
  80156b:	e8 2c 03 00 00       	call   80189c <sys_getSharedObject>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801576:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801579:	a1 20 50 80 00       	mov    0x805020,%eax
  80157e:	8b 40 78             	mov    0x78(%eax),%eax
  801581:	29 c2                	sub    %eax,%edx
  801583:	89 d0                	mov    %edx,%eax
  801585:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158a:	c1 e8 0c             	shr    $0xc,%eax
  80158d:	89 c2                	mov    %eax,%edx
  80158f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801592:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801599:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80159d:	75 07                	jne    8015a6 <sget+0xa3>
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	eb 03                	jmp    8015a9 <sget+0xa6>
	return ptr;
  8015a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8015b9:	8b 40 78             	mov    0x78(%eax),%eax
  8015bc:	29 c2                	sub    %eax,%edx
  8015be:	89 d0                	mov    %edx,%eax
  8015c0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c5:	c1 e8 0c             	shr    $0xc,%eax
  8015c8:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	ff 75 08             	pushl  0x8(%ebp)
  8015d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015db:	e8 db 02 00 00       	call   8018bb <sys_freeSharedObject>
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 70 43 80 00       	push   $0x804370
  8015f7:	68 e4 00 00 00       	push   $0xe4
  8015fc:	68 62 43 80 00       	push   $0x804362
  801601:	e8 f4 23 00 00       	call   8039fa <_panic>

00801606 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 96 43 80 00       	push   $0x804396
  801614:	68 f0 00 00 00       	push   $0xf0
  801619:	68 62 43 80 00       	push   $0x804362
  80161e:	e8 d7 23 00 00       	call   8039fa <_panic>

00801623 <shrink>:

}
void shrink(uint32 newSize)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 96 43 80 00       	push   $0x804396
  801631:	68 f5 00 00 00       	push   $0xf5
  801636:	68 62 43 80 00       	push   $0x804362
  80163b:	e8 ba 23 00 00       	call   8039fa <_panic>

00801640 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 96 43 80 00       	push   $0x804396
  80164e:	68 fa 00 00 00       	push   $0xfa
  801653:	68 62 43 80 00       	push   $0x804362
  801658:	e8 9d 23 00 00       	call   8039fa <_panic>

0080165d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	57                   	push   %edi
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801672:	8b 7d 18             	mov    0x18(%ebp),%edi
  801675:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801678:	cd 30                	int    $0x30
  80167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5f                   	pop    %edi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801694:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	52                   	push   %edx
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	50                   	push   %eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	e8 b2 ff ff ff       	call   80165d <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 02                	push   $0x2
  8016c0:	e8 98 ff ff ff       	call   80165d <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 03                	push   $0x3
  8016d9:	e8 7f ff ff ff       	call   80165d <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	90                   	nop
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 04                	push   $0x4
  8016f3:	e8 65 ff ff ff       	call   80165d <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	90                   	nop
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801701:	8b 55 0c             	mov    0xc(%ebp),%edx
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	52                   	push   %edx
  80170e:	50                   	push   %eax
  80170f:	6a 08                	push   $0x8
  801711:	e8 47 ff ff ff       	call   80165d <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801720:	8b 75 18             	mov    0x18(%ebp),%esi
  801723:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801726:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	56                   	push   %esi
  801730:	53                   	push   %ebx
  801731:	51                   	push   %ecx
  801732:	52                   	push   %edx
  801733:	50                   	push   %eax
  801734:	6a 09                	push   $0x9
  801736:	e8 22 ff ff ff       	call   80165d <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	6a 0a                	push   $0xa
  801758:	e8 00 ff ff ff       	call   80165d <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	6a 0b                	push   $0xb
  801773:	e8 e5 fe ff ff       	call   80165d <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 0c                	push   $0xc
  80178c:	e8 cc fe ff ff       	call   80165d <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 0d                	push   $0xd
  8017a5:	e8 b3 fe ff ff       	call   80165d <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 0e                	push   $0xe
  8017be:	e8 9a fe ff ff       	call   80165d <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 0f                	push   $0xf
  8017d7:	e8 81 fe ff ff       	call   80165d <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	6a 10                	push   $0x10
  8017f1:	e8 67 fe ff ff       	call   80165d <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 11                	push   $0x11
  80180a:	e8 4e fe ff ff       	call   80165d <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_cputc>:

void
sys_cputc(const char c)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801821:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	50                   	push   %eax
  80182e:	6a 01                	push   $0x1
  801830:	e8 28 fe ff ff       	call   80165d <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 14                	push   $0x14
  80184a:	e8 0e fe ff ff       	call   80165d <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801861:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801864:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	6a 00                	push   $0x0
  80186d:	51                   	push   %ecx
  80186e:	52                   	push   %edx
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	50                   	push   %eax
  801873:	6a 15                	push   $0x15
  801875:	e8 e3 fd ff ff       	call   80165d <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	52                   	push   %edx
  80188f:	50                   	push   %eax
  801890:	6a 16                	push   $0x16
  801892:	e8 c6 fd ff ff       	call   80165d <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80189f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	51                   	push   %ecx
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 17                	push   $0x17
  8018b1:	e8 a7 fd ff ff       	call   80165d <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	6a 18                	push   $0x18
  8018ce:	e8 8a fd ff ff       	call   80165d <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	ff 75 14             	pushl  0x14(%ebp)
  8018e3:	ff 75 10             	pushl  0x10(%ebp)
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	50                   	push   %eax
  8018ea:	6a 19                	push   $0x19
  8018ec:	e8 6c fd ff ff       	call   80165d <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	50                   	push   %eax
  801905:	6a 1a                	push   $0x1a
  801907:	e8 51 fd ff ff       	call   80165d <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	50                   	push   %eax
  801921:	6a 1b                	push   $0x1b
  801923:	e8 35 fd ff ff       	call   80165d <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 05                	push   $0x5
  80193c:	e8 1c fd ff ff       	call   80165d <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 06                	push   $0x6
  801955:	e8 03 fd ff ff       	call   80165d <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 07                	push   $0x7
  80196e:	e8 ea fc ff ff       	call   80165d <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_exit_env>:


void sys_exit_env(void)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 1c                	push   $0x1c
  801987:	e8 d1 fc ff ff       	call   80165d <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801998:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199b:	8d 50 04             	lea    0x4(%eax),%edx
  80199e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 1d                	push   $0x1d
  8019ab:	e8 ad fc ff ff       	call   80165d <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019bc:	89 01                	mov    %eax,(%ecx)
  8019be:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	c9                   	leave  
  8019c5:	c2 04 00             	ret    $0x4

008019c8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 13                	push   $0x13
  8019da:	e8 7e fc ff ff       	call   80165d <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 1e                	push   $0x1e
  8019f4:	e8 64 fc ff ff       	call   80165d <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	50                   	push   %eax
  801a17:	6a 1f                	push   $0x1f
  801a19:	e8 3f fc ff ff       	call   80165d <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <rsttst>:
void rsttst()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 21                	push   $0x21
  801a33:	e8 25 fc ff ff       	call   80165d <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3b:	90                   	nop
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	8b 45 14             	mov    0x14(%ebp),%eax
  801a47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4a:	8b 55 18             	mov    0x18(%ebp),%edx
  801a4d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a51:	52                   	push   %edx
  801a52:	50                   	push   %eax
  801a53:	ff 75 10             	pushl  0x10(%ebp)
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 20                	push   $0x20
  801a5e:	e8 fa fb ff ff       	call   80165d <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
	return ;
  801a66:	90                   	nop
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <chktst>:
void chktst(uint32 n)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	ff 75 08             	pushl  0x8(%ebp)
  801a77:	6a 22                	push   $0x22
  801a79:	e8 df fb ff ff       	call   80165d <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a81:	90                   	nop
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <inctst>:

void inctst()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 23                	push   $0x23
  801a93:	e8 c5 fb ff ff       	call   80165d <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9b:	90                   	nop
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <gettst>:
uint32 gettst()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 24                	push   $0x24
  801aad:	e8 ab fb ff ff       	call   80165d <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 25                	push   $0x25
  801ac9:	e8 8f fb ff ff       	call   80165d <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
  801ad1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ad4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ad8:	75 07                	jne    801ae1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
  801adf:	eb 05                	jmp    801ae6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 25                	push   $0x25
  801afa:	e8 5e fb ff ff       	call   80165d <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
  801b02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b05:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b09:	75 07                	jne    801b12 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b10:	eb 05                	jmp    801b17 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 25                	push   $0x25
  801b2b:	e8 2d fb ff ff       	call   80165d <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
  801b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b36:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b3a:	75 07                	jne    801b43 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b41:	eb 05                	jmp    801b48 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 25                	push   $0x25
  801b5c:	e8 fc fa ff ff       	call   80165d <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
  801b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b67:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b6b:	75 07                	jne    801b74 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	eb 05                	jmp    801b79 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	ff 75 08             	pushl  0x8(%ebp)
  801b89:	6a 26                	push   $0x26
  801b8b:	e8 cd fa ff ff       	call   80165d <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
	return ;
  801b93:	90                   	nop
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b9a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	53                   	push   %ebx
  801ba9:	51                   	push   %ecx
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	6a 27                	push   $0x27
  801bae:	e8 aa fa ff ff       	call   80165d <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 28                	push   $0x28
  801bce:	e8 8a fa ff ff       	call   80165d <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bdb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	51                   	push   %ecx
  801be7:	ff 75 10             	pushl  0x10(%ebp)
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 29                	push   $0x29
  801bee:	e8 6a fa ff ff       	call   80165d <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	6a 12                	push   $0x12
  801c0a:	e8 4e fa ff ff       	call   80165d <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	52                   	push   %edx
  801c25:	50                   	push   %eax
  801c26:	6a 2a                	push   $0x2a
  801c28:	e8 30 fa ff ff       	call   80165d <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	50                   	push   %eax
  801c42:	6a 2b                	push   $0x2b
  801c44:	e8 14 fa ff ff       	call   80165d <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	6a 2c                	push   $0x2c
  801c5f:	e8 f9 f9 ff ff       	call   80165d <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return;
  801c67:	90                   	nop
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	ff 75 08             	pushl  0x8(%ebp)
  801c79:	6a 2d                	push   $0x2d
  801c7b:	e8 dd f9 ff ff       	call   80165d <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
	return;
  801c83:	90                   	nop
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 2e                	push   $0x2e
  801c98:	e8 c0 f9 ff ff       	call   80165d <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
  801ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 2f                	push   $0x2f
  801cb9:	e8 9f f9 ff ff       	call   80165d <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 30                	push   $0x30
  801cd7:	e8 81 f9 ff ff       	call   80165d <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	50                   	push   %eax
  801cf4:	6a 31                	push   $0x31
  801cf6:	e8 62 f9 ff ff       	call   80165d <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
  801cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	50                   	push   %eax
  801d15:	6a 32                	push   $0x32
  801d17:	e8 41 f9 ff ff       	call   80165d <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	83 e8 04             	sub    $0x4,%eax
  801d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d34:	8b 00                	mov    (%eax),%eax
  801d36:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	83 e8 04             	sub    $0x4,%eax
  801d47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	83 e0 01             	and    $0x1,%eax
  801d52:	85 c0                	test   %eax,%eax
  801d54:	0f 94 c0             	sete   %al
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	83 f8 02             	cmp    $0x2,%eax
  801d6c:	74 2b                	je     801d99 <alloc_block+0x40>
  801d6e:	83 f8 02             	cmp    $0x2,%eax
  801d71:	7f 07                	jg     801d7a <alloc_block+0x21>
  801d73:	83 f8 01             	cmp    $0x1,%eax
  801d76:	74 0e                	je     801d86 <alloc_block+0x2d>
  801d78:	eb 58                	jmp    801dd2 <alloc_block+0x79>
  801d7a:	83 f8 03             	cmp    $0x3,%eax
  801d7d:	74 2d                	je     801dac <alloc_block+0x53>
  801d7f:	83 f8 04             	cmp    $0x4,%eax
  801d82:	74 3b                	je     801dbf <alloc_block+0x66>
  801d84:	eb 4c                	jmp    801dd2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d86:	83 ec 0c             	sub    $0xc,%esp
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	e8 11 03 00 00       	call   8020a2 <alloc_block_FF>
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d97:	eb 4a                	jmp    801de3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d99:	83 ec 0c             	sub    $0xc,%esp
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 c7 19 00 00       	call   80376b <alloc_block_NF>
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801daa:	eb 37                	jmp    801de3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	e8 a7 07 00 00       	call   80255e <alloc_block_BF>
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dbd:	eb 24                	jmp    801de3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	ff 75 08             	pushl  0x8(%ebp)
  801dc5:	e8 84 19 00 00       	call   80374e <alloc_block_WF>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dd0:	eb 11                	jmp    801de3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	68 a8 43 80 00       	push   $0x8043a8
  801dda:	e8 b1 e5 ff ff       	call   800390 <cprintf>
  801ddf:	83 c4 10             	add    $0x10,%esp
		break;
  801de2:	90                   	nop
	}
	return va;
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	53                   	push   %ebx
  801dec:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	68 c8 43 80 00       	push   $0x8043c8
  801df7:	e8 94 e5 ff ff       	call   800390 <cprintf>
  801dfc:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	68 f3 43 80 00       	push   $0x8043f3
  801e07:	e8 84 e5 ff ff       	call   800390 <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e15:	eb 37                	jmp    801e4e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e17:	83 ec 0c             	sub    $0xc,%esp
  801e1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1d:	e8 19 ff ff ff       	call   801d3b <is_free_block>
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	0f be d8             	movsbl %al,%ebx
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2e:	e8 ef fe ff ff       	call   801d22 <get_block_size>
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	53                   	push   %ebx
  801e3a:	50                   	push   %eax
  801e3b:	68 0b 44 80 00       	push   $0x80440b
  801e40:	e8 4b e5 ff ff       	call   800390 <cprintf>
  801e45:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e48:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e52:	74 07                	je     801e5b <print_blocks_list+0x73>
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 00                	mov    (%eax),%eax
  801e59:	eb 05                	jmp    801e60 <print_blocks_list+0x78>
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	89 45 10             	mov    %eax,0x10(%ebp)
  801e63:	8b 45 10             	mov    0x10(%ebp),%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 ad                	jne    801e17 <print_blocks_list+0x2f>
  801e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6e:	75 a7                	jne    801e17 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	68 c8 43 80 00       	push   $0x8043c8
  801e78:	e8 13 e5 ff ff       	call   800390 <cprintf>
  801e7d:	83 c4 10             	add    $0x10,%esp

}
  801e80:	90                   	nop
  801e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	83 e0 01             	and    $0x1,%eax
  801e92:	85 c0                	test   %eax,%eax
  801e94:	74 03                	je     801e99 <initialize_dynamic_allocator+0x13>
  801e96:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9d:	0f 84 c7 01 00 00    	je     80206a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ea3:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801eaa:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801ead:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 d0                	add    %edx,%eax
  801eb5:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801eba:	0f 87 ad 01 00 00    	ja     80206d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 89 a5 01 00 00    	jns    802070 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	83 e8 04             	sub    $0x4,%eax
  801ed6:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ee2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eea:	e9 87 00 00 00       	jmp    801f76 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801eef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef3:	75 14                	jne    801f09 <initialize_dynamic_allocator+0x83>
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	68 23 44 80 00       	push   $0x804423
  801efd:	6a 79                	push   $0x79
  801eff:	68 41 44 80 00       	push   $0x804441
  801f04:	e8 f1 1a 00 00       	call   8039fa <_panic>
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	8b 00                	mov    (%eax),%eax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	74 10                	je     801f22 <initialize_dynamic_allocator+0x9c>
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 00                	mov    (%eax),%eax
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	8b 52 04             	mov    0x4(%edx),%edx
  801f1d:	89 50 04             	mov    %edx,0x4(%eax)
  801f20:	eb 0b                	jmp    801f2d <initialize_dynamic_allocator+0xa7>
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	8b 40 04             	mov    0x4(%eax),%eax
  801f28:	a3 30 50 80 00       	mov    %eax,0x805030
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	8b 40 04             	mov    0x4(%eax),%eax
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 0f                	je     801f46 <initialize_dynamic_allocator+0xc0>
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 40 04             	mov    0x4(%eax),%eax
  801f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f40:	8b 12                	mov    (%edx),%edx
  801f42:	89 10                	mov    %edx,(%eax)
  801f44:	eb 0a                	jmp    801f50 <initialize_dynamic_allocator+0xca>
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 00                	mov    (%eax),%eax
  801f4b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f63:	a1 38 50 80 00       	mov    0x805038,%eax
  801f68:	48                   	dec    %eax
  801f69:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f6e:	a1 34 50 80 00       	mov    0x805034,%eax
  801f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7a:	74 07                	je     801f83 <initialize_dynamic_allocator+0xfd>
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	eb 05                	jmp    801f88 <initialize_dynamic_allocator+0x102>
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	a3 34 50 80 00       	mov    %eax,0x805034
  801f8d:	a1 34 50 80 00       	mov    0x805034,%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 85 55 ff ff ff    	jne    801eef <initialize_dynamic_allocator+0x69>
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	0f 85 4b ff ff ff    	jne    801eef <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801fb3:	a1 44 50 80 00       	mov    0x805044,%eax
  801fb8:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801fbd:	a1 40 50 80 00       	mov    0x805040,%eax
  801fc2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	83 c0 08             	add    $0x8,%eax
  801fce:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	83 c0 04             	add    $0x4,%eax
  801fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fda:	83 ea 08             	sub    $0x8,%edx
  801fdd:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	83 e8 08             	sub    $0x8,%eax
  801fea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fed:	83 ea 08             	sub    $0x8,%edx
  801ff0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802005:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802009:	75 17                	jne    802022 <initialize_dynamic_allocator+0x19c>
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	68 5c 44 80 00       	push   $0x80445c
  802013:	68 90 00 00 00       	push   $0x90
  802018:	68 41 44 80 00       	push   $0x804441
  80201d:	e8 d8 19 00 00       	call   8039fa <_panic>
  802022:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202b:	89 10                	mov    %edx,(%eax)
  80202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802030:	8b 00                	mov    (%eax),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	74 0d                	je     802043 <initialize_dynamic_allocator+0x1bd>
  802036:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80203b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80203e:	89 50 04             	mov    %edx,0x4(%eax)
  802041:	eb 08                	jmp    80204b <initialize_dynamic_allocator+0x1c5>
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	a3 30 50 80 00       	mov    %eax,0x805030
  80204b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205d:	a1 38 50 80 00       	mov    0x805038,%eax
  802062:	40                   	inc    %eax
  802063:	a3 38 50 80 00       	mov    %eax,0x805038
  802068:	eb 07                	jmp    802071 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80206a:	90                   	nop
  80206b:	eb 04                	jmp    802071 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80206d:	90                   	nop
  80206e:	eb 01                	jmp    802071 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802070:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802076:	8b 45 10             	mov    0x10(%ebp),%eax
  802079:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802082:	8b 45 0c             	mov    0xc(%ebp),%eax
  802085:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	83 e8 04             	sub    $0x4,%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	83 e0 fe             	and    $0xfffffffe,%eax
  802092:	8d 50 f8             	lea    -0x8(%eax),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	01 c2                	add    %eax,%edx
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	89 02                	mov    %eax,(%edx)
}
  80209f:	90                   	nop
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    

008020a2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	83 e0 01             	and    $0x1,%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 03                	je     8020b5 <alloc_block_FF+0x13>
  8020b2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8020b5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020b9:	77 07                	ja     8020c2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020bb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020c2:	a1 24 50 80 00       	mov    0x805024,%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	75 73                	jne    80213e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	83 c0 10             	add    $0x10,%eax
  8020d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8020d4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	48                   	dec    %eax
  8020e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ef:	f7 75 ec             	divl   -0x14(%ebp)
  8020f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f5:	29 d0                	sub    %edx,%eax
  8020f7:	c1 e8 0c             	shr    $0xc,%eax
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  8020fd:	50                   	push   %eax
  8020fe:	e8 27 f0 ff ff       	call   80112a <sbrk>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	6a 00                	push   $0x0
  80210e:	e8 17 f0 ff ff       	call   80112a <sbrk>
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802119:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80211f:	83 ec 08             	sub    $0x8,%esp
  802122:	50                   	push   %eax
  802123:	ff 75 e4             	pushl  -0x1c(%ebp)
  802126:	e8 5b fd ff ff       	call   801e86 <initialize_dynamic_allocator>
  80212b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	68 7f 44 80 00       	push   $0x80447f
  802136:	e8 55 e2 ff ff       	call   800390 <cprintf>
  80213b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80213e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802142:	75 0a                	jne    80214e <alloc_block_FF+0xac>
	        return NULL;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
  802149:	e9 0e 04 00 00       	jmp    80255c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80214e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802155:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215d:	e9 f3 02 00 00       	jmp    802455 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802168:	83 ec 0c             	sub    $0xc,%esp
  80216b:	ff 75 bc             	pushl  -0x44(%ebp)
  80216e:	e8 af fb ff ff       	call   801d22 <get_block_size>
  802173:	83 c4 10             	add    $0x10,%esp
  802176:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	83 c0 08             	add    $0x8,%eax
  80217f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802182:	0f 87 c5 02 00 00    	ja     80244d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	83 c0 18             	add    $0x18,%eax
  80218e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802191:	0f 87 19 02 00 00    	ja     8023b0 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802197:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80219a:	2b 45 08             	sub    0x8(%ebp),%eax
  80219d:	83 e8 08             	sub    $0x8,%eax
  8021a0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8d 50 08             	lea    0x8(%eax),%edx
  8021a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021ac:	01 d0                	add    %edx,%eax
  8021ae:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	83 c0 08             	add    $0x8,%eax
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	6a 01                	push   $0x1
  8021bc:	50                   	push   %eax
  8021bd:	ff 75 bc             	pushl  -0x44(%ebp)
  8021c0:	e8 ae fe ff ff       	call   802073 <set_block_data>
  8021c5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 40 04             	mov    0x4(%eax),%eax
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	75 68                	jne    80223a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021d2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021d6:	75 17                	jne    8021ef <alloc_block_FF+0x14d>
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	68 5c 44 80 00       	push   $0x80445c
  8021e0:	68 d7 00 00 00       	push   $0xd7
  8021e5:	68 41 44 80 00       	push   $0x804441
  8021ea:	e8 0b 18 00 00       	call   8039fa <_panic>
  8021ef:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f8:	89 10                	mov    %edx,(%eax)
  8021fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fd:	8b 00                	mov    (%eax),%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 0d                	je     802210 <alloc_block_FF+0x16e>
  802203:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802208:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80220b:	89 50 04             	mov    %edx,0x4(%eax)
  80220e:	eb 08                	jmp    802218 <alloc_block_FF+0x176>
  802210:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802213:	a3 30 50 80 00       	mov    %eax,0x805030
  802218:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802220:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802223:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222a:	a1 38 50 80 00       	mov    0x805038,%eax
  80222f:	40                   	inc    %eax
  802230:	a3 38 50 80 00       	mov    %eax,0x805038
  802235:	e9 dc 00 00 00       	jmp    802316 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	75 65                	jne    8022a8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802243:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802247:	75 17                	jne    802260 <alloc_block_FF+0x1be>
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 90 44 80 00       	push   $0x804490
  802251:	68 db 00 00 00       	push   $0xdb
  802256:	68 41 44 80 00       	push   $0x804441
  80225b:	e8 9a 17 00 00       	call   8039fa <_panic>
  802260:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802266:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802269:	89 50 04             	mov    %edx,0x4(%eax)
  80226c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226f:	8b 40 04             	mov    0x4(%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0c                	je     802282 <alloc_block_FF+0x1e0>
  802276:	a1 30 50 80 00       	mov    0x805030,%eax
  80227b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	eb 08                	jmp    80228a <alloc_block_FF+0x1e8>
  802282:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802285:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228d:	a3 30 50 80 00       	mov    %eax,0x805030
  802292:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802295:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229b:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a0:	40                   	inc    %eax
  8022a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a6:	eb 6e                	jmp    802316 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ac:	74 06                	je     8022b4 <alloc_block_FF+0x212>
  8022ae:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022b2:	75 17                	jne    8022cb <alloc_block_FF+0x229>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 b4 44 80 00       	push   $0x8044b4
  8022bc:	68 df 00 00 00       	push   $0xdf
  8022c1:	68 41 44 80 00       	push   $0x804441
  8022c6:	e8 2f 17 00 00       	call   8039fa <_panic>
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 10                	mov    (%eax),%edx
  8022d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d3:	89 10                	mov    %edx,(%eax)
  8022d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 0b                	je     8022e9 <alloc_block_FF+0x247>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ef:	89 10                	mov    %edx,(%eax)
  8022f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	89 50 04             	mov    %edx,0x4(%eax)
  8022fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	75 08                	jne    80230b <alloc_block_FF+0x269>
  802303:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802306:	a3 30 50 80 00       	mov    %eax,0x805030
  80230b:	a1 38 50 80 00       	mov    0x805038,%eax
  802310:	40                   	inc    %eax
  802311:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	75 17                	jne    802333 <alloc_block_FF+0x291>
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 23 44 80 00       	push   $0x804423
  802324:	68 e1 00 00 00       	push   $0xe1
  802329:	68 41 44 80 00       	push   $0x804441
  80232e:	e8 c7 16 00 00       	call   8039fa <_panic>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 10                	je     80234c <alloc_block_FF+0x2aa>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802344:	8b 52 04             	mov    0x4(%edx),%edx
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	eb 0b                	jmp    802357 <alloc_block_FF+0x2b5>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	a3 30 50 80 00       	mov    %eax,0x805030
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0f                	je     802370 <alloc_block_FF+0x2ce>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	8b 12                	mov    (%edx),%edx
  80236c:	89 10                	mov    %edx,(%eax)
  80236e:	eb 0a                	jmp    80237a <alloc_block_FF+0x2d8>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238d:	a1 38 50 80 00       	mov    0x805038,%eax
  802392:	48                   	dec    %eax
  802393:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	6a 00                	push   $0x0
  80239d:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023a0:	ff 75 b0             	pushl  -0x50(%ebp)
  8023a3:	e8 cb fc ff ff       	call   802073 <set_block_data>
  8023a8:	83 c4 10             	add    $0x10,%esp
  8023ab:	e9 95 00 00 00       	jmp    802445 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	6a 01                	push   $0x1
  8023b5:	ff 75 b8             	pushl  -0x48(%ebp)
  8023b8:	ff 75 bc             	pushl  -0x44(%ebp)
  8023bb:	e8 b3 fc ff ff       	call   802073 <set_block_data>
  8023c0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c7:	75 17                	jne    8023e0 <alloc_block_FF+0x33e>
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	68 23 44 80 00       	push   $0x804423
  8023d1:	68 e8 00 00 00       	push   $0xe8
  8023d6:	68 41 44 80 00       	push   $0x804441
  8023db:	e8 1a 16 00 00       	call   8039fa <_panic>
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 10                	je     8023f9 <alloc_block_FF+0x357>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f1:	8b 52 04             	mov    0x4(%edx),%edx
  8023f4:	89 50 04             	mov    %edx,0x4(%eax)
  8023f7:	eb 0b                	jmp    802404 <alloc_block_FF+0x362>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 04             	mov    0x4(%eax),%eax
  8023ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 04             	mov    0x4(%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	74 0f                	je     80241d <alloc_block_FF+0x37b>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 40 04             	mov    0x4(%eax),%eax
  802414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802417:	8b 12                	mov    (%edx),%edx
  802419:	89 10                	mov    %edx,(%eax)
  80241b:	eb 0a                	jmp    802427 <alloc_block_FF+0x385>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243a:	a1 38 50 80 00       	mov    0x805038,%eax
  80243f:	48                   	dec    %eax
  802440:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802448:	e9 0f 01 00 00       	jmp    80255c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80244d:	a1 34 50 80 00       	mov    0x805034,%eax
  802452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	74 07                	je     802462 <alloc_block_FF+0x3c0>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	eb 05                	jmp    802467 <alloc_block_FF+0x3c5>
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	a3 34 50 80 00       	mov    %eax,0x805034
  80246c:	a1 34 50 80 00       	mov    0x805034,%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	0f 85 e9 fc ff ff    	jne    802162 <alloc_block_FF+0xc0>
  802479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247d:	0f 85 df fc ff ff    	jne    802162 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	83 c0 08             	add    $0x8,%eax
  802489:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80248c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802493:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802499:	01 d0                	add    %edx,%eax
  80249b:	48                   	dec    %eax
  80249c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80249f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a7:	f7 75 d8             	divl   -0x28(%ebp)
  8024aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ad:	29 d0                	sub    %edx,%eax
  8024af:	c1 e8 0c             	shr    $0xc,%eax
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	50                   	push   %eax
  8024b6:	e8 6f ec ff ff       	call   80112a <sbrk>
  8024bb:	83 c4 10             	add    $0x10,%esp
  8024be:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024c1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024c5:	75 0a                	jne    8024d1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	e9 8b 00 00 00       	jmp    80255c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8024d1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024de:	01 d0                	add    %edx,%eax
  8024e0:	48                   	dec    %eax
  8024e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ec:	f7 75 cc             	divl   -0x34(%ebp)
  8024ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024f2:	29 d0                	sub    %edx,%eax
  8024f4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024fa:	01 d0                	add    %edx,%eax
  8024fc:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802501:	a1 40 50 80 00       	mov    0x805040,%eax
  802506:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80250c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802513:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802516:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802519:	01 d0                	add    %edx,%eax
  80251b:	48                   	dec    %eax
  80251c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80251f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802522:	ba 00 00 00 00       	mov    $0x0,%edx
  802527:	f7 75 c4             	divl   -0x3c(%ebp)
  80252a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80252d:	29 d0                	sub    %edx,%eax
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	6a 01                	push   $0x1
  802534:	50                   	push   %eax
  802535:	ff 75 d0             	pushl  -0x30(%ebp)
  802538:	e8 36 fb ff ff       	call   802073 <set_block_data>
  80253d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	ff 75 d0             	pushl  -0x30(%ebp)
  802546:	e8 f8 09 00 00       	call   802f43 <free_block>
  80254b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80254e:	83 ec 0c             	sub    $0xc,%esp
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	e8 49 fb ff ff       	call   8020a2 <alloc_block_FF>
  802559:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	83 e0 01             	and    $0x1,%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	74 03                	je     802571 <alloc_block_BF+0x13>
  80256e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802571:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802575:	77 07                	ja     80257e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802577:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80257e:	a1 24 50 80 00       	mov    0x805024,%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	75 73                	jne    8025fa <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	83 c0 10             	add    $0x10,%eax
  80258d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802590:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802597:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80259a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259d:	01 d0                	add    %edx,%eax
  80259f:	48                   	dec    %eax
  8025a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ab:	f7 75 e0             	divl   -0x20(%ebp)
  8025ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b1:	29 d0                	sub    %edx,%eax
  8025b3:	c1 e8 0c             	shr    $0xc,%eax
  8025b6:	83 ec 0c             	sub    $0xc,%esp
  8025b9:	50                   	push   %eax
  8025ba:	e8 6b eb ff ff       	call   80112a <sbrk>
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025c5:	83 ec 0c             	sub    $0xc,%esp
  8025c8:	6a 00                	push   $0x0
  8025ca:	e8 5b eb ff ff       	call   80112a <sbrk>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025db:	83 ec 08             	sub    $0x8,%esp
  8025de:	50                   	push   %eax
  8025df:	ff 75 d8             	pushl  -0x28(%ebp)
  8025e2:	e8 9f f8 ff ff       	call   801e86 <initialize_dynamic_allocator>
  8025e7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025ea:	83 ec 0c             	sub    $0xc,%esp
  8025ed:	68 7f 44 80 00       	push   $0x80447f
  8025f2:	e8 99 dd ff ff       	call   800390 <cprintf>
  8025f7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8025fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802601:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802608:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80260f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802616:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80261b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261e:	e9 1d 01 00 00       	jmp    802740 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	ff 75 a8             	pushl  -0x58(%ebp)
  80262f:	e8 ee f6 ff ff       	call   801d22 <get_block_size>
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	83 c0 08             	add    $0x8,%eax
  802640:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802643:	0f 87 ef 00 00 00    	ja     802738 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	83 c0 18             	add    $0x18,%eax
  80264f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802652:	77 1d                	ja     802671 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802657:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80265a:	0f 86 d8 00 00 00    	jbe    802738 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802660:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802663:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802666:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802669:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80266c:	e9 c7 00 00 00       	jmp    802738 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	83 c0 08             	add    $0x8,%eax
  802677:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80267a:	0f 85 9d 00 00 00    	jne    80271d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	6a 01                	push   $0x1
  802685:	ff 75 a4             	pushl  -0x5c(%ebp)
  802688:	ff 75 a8             	pushl  -0x58(%ebp)
  80268b:	e8 e3 f9 ff ff       	call   802073 <set_block_data>
  802690:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802697:	75 17                	jne    8026b0 <alloc_block_BF+0x152>
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	68 23 44 80 00       	push   $0x804423
  8026a1:	68 2c 01 00 00       	push   $0x12c
  8026a6:	68 41 44 80 00       	push   $0x804441
  8026ab:	e8 4a 13 00 00       	call   8039fa <_panic>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 10                	je     8026c9 <alloc_block_BF+0x16b>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c1:	8b 52 04             	mov    0x4(%edx),%edx
  8026c4:	89 50 04             	mov    %edx,0x4(%eax)
  8026c7:	eb 0b                	jmp    8026d4 <alloc_block_BF+0x176>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 0f                	je     8026ed <alloc_block_BF+0x18f>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 04             	mov    0x4(%eax),%eax
  8026e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e7:	8b 12                	mov    (%edx),%edx
  8026e9:	89 10                	mov    %edx,(%eax)
  8026eb:	eb 0a                	jmp    8026f7 <alloc_block_BF+0x199>
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270a:	a1 38 50 80 00       	mov    0x805038,%eax
  80270f:	48                   	dec    %eax
  802710:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802715:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802718:	e9 01 04 00 00       	jmp    802b1e <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80271d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802720:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802723:	76 13                	jbe    802738 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802725:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80272c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80272f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802732:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802735:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802738:	a1 34 50 80 00       	mov    0x805034,%eax
  80273d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	74 07                	je     80274d <alloc_block_BF+0x1ef>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	eb 05                	jmp    802752 <alloc_block_BF+0x1f4>
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	a3 34 50 80 00       	mov    %eax,0x805034
  802757:	a1 34 50 80 00       	mov    0x805034,%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	0f 85 bf fe ff ff    	jne    802623 <alloc_block_BF+0xc5>
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	0f 85 b5 fe ff ff    	jne    802623 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80276e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802772:	0f 84 26 02 00 00    	je     80299e <alloc_block_BF+0x440>
  802778:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80277c:	0f 85 1c 02 00 00    	jne    80299e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	2b 45 08             	sub    0x8(%ebp),%eax
  802788:	83 e8 08             	sub    $0x8,%eax
  80278b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	8d 50 08             	lea    0x8(%eax),%edx
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	83 c0 08             	add    $0x8,%eax
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	6a 01                	push   $0x1
  8027a7:	50                   	push   %eax
  8027a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ab:	e8 c3 f8 ff ff       	call   802073 <set_block_data>
  8027b0:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	75 68                	jne    802825 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027c1:	75 17                	jne    8027da <alloc_block_BF+0x27c>
  8027c3:	83 ec 04             	sub    $0x4,%esp
  8027c6:	68 5c 44 80 00       	push   $0x80445c
  8027cb:	68 45 01 00 00       	push   $0x145
  8027d0:	68 41 44 80 00       	push   $0x804441
  8027d5:	e8 20 12 00 00       	call   8039fa <_panic>
  8027da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 0d                	je     8027fb <alloc_block_BF+0x29d>
  8027ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 08                	jmp    802803 <alloc_block_BF+0x2a5>
  8027fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802803:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802806:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80280b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802815:	a1 38 50 80 00       	mov    0x805038,%eax
  80281a:	40                   	inc    %eax
  80281b:	a3 38 50 80 00       	mov    %eax,0x805038
  802820:	e9 dc 00 00 00       	jmp    802901 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	75 65                	jne    802893 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80282e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802832:	75 17                	jne    80284b <alloc_block_BF+0x2ed>
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	68 90 44 80 00       	push   $0x804490
  80283c:	68 4a 01 00 00       	push   $0x14a
  802841:	68 41 44 80 00       	push   $0x804441
  802846:	e8 af 11 00 00       	call   8039fa <_panic>
  80284b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802851:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802854:	89 50 04             	mov    %edx,0x4(%eax)
  802857:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285a:	8b 40 04             	mov    0x4(%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 0c                	je     80286d <alloc_block_BF+0x30f>
  802861:	a1 30 50 80 00       	mov    0x805030,%eax
  802866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802869:	89 10                	mov    %edx,(%eax)
  80286b:	eb 08                	jmp    802875 <alloc_block_BF+0x317>
  80286d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802870:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802875:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802878:	a3 30 50 80 00       	mov    %eax,0x805030
  80287d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802886:	a1 38 50 80 00       	mov    0x805038,%eax
  80288b:	40                   	inc    %eax
  80288c:	a3 38 50 80 00       	mov    %eax,0x805038
  802891:	eb 6e                	jmp    802901 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802897:	74 06                	je     80289f <alloc_block_BF+0x341>
  802899:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80289d:	75 17                	jne    8028b6 <alloc_block_BF+0x358>
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 b4 44 80 00       	push   $0x8044b4
  8028a7:	68 4f 01 00 00       	push   $0x14f
  8028ac:	68 41 44 80 00       	push   $0x804441
  8028b1:	e8 44 11 00 00       	call   8039fa <_panic>
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 10                	mov    (%eax),%edx
  8028bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 0b                	je     8028d4 <alloc_block_BF+0x376>
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028d1:	89 50 04             	mov    %edx,0x4(%eax)
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028da:	89 10                	mov    %edx,(%eax)
  8028dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e2:	89 50 04             	mov    %edx,0x4(%eax)
  8028e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	75 08                	jne    8028f6 <alloc_block_BF+0x398>
  8028ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fb:	40                   	inc    %eax
  8028fc:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802901:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802905:	75 17                	jne    80291e <alloc_block_BF+0x3c0>
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 23 44 80 00       	push   $0x804423
  80290f:	68 51 01 00 00       	push   $0x151
  802914:	68 41 44 80 00       	push   $0x804441
  802919:	e8 dc 10 00 00       	call   8039fa <_panic>
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 10                	je     802937 <alloc_block_BF+0x3d9>
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292f:	8b 52 04             	mov    0x4(%edx),%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	eb 0b                	jmp    802942 <alloc_block_BF+0x3e4>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	a3 30 50 80 00       	mov    %eax,0x805030
  802942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802945:	8b 40 04             	mov    0x4(%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0f                	je     80295b <alloc_block_BF+0x3fd>
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	8b 12                	mov    (%edx),%edx
  802957:	89 10                	mov    %edx,(%eax)
  802959:	eb 0a                	jmp    802965 <alloc_block_BF+0x407>
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802978:	a1 38 50 80 00       	mov    0x805038,%eax
  80297d:	48                   	dec    %eax
  80297e:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	6a 00                	push   $0x0
  802988:	ff 75 d0             	pushl  -0x30(%ebp)
  80298b:	ff 75 cc             	pushl  -0x34(%ebp)
  80298e:	e8 e0 f6 ff ff       	call   802073 <set_block_data>
  802993:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	e9 80 01 00 00       	jmp    802b1e <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80299e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029a2:	0f 85 9d 00 00 00    	jne    802a45 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	6a 01                	push   $0x1
  8029ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8029b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8029b3:	e8 bb f6 ff ff       	call   802073 <set_block_data>
  8029b8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bf:	75 17                	jne    8029d8 <alloc_block_BF+0x47a>
  8029c1:	83 ec 04             	sub    $0x4,%esp
  8029c4:	68 23 44 80 00       	push   $0x804423
  8029c9:	68 58 01 00 00       	push   $0x158
  8029ce:	68 41 44 80 00       	push   $0x804441
  8029d3:	e8 22 10 00 00       	call   8039fa <_panic>
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 10                	je     8029f1 <alloc_block_BF+0x493>
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e9:	8b 52 04             	mov    0x4(%edx),%edx
  8029ec:	89 50 04             	mov    %edx,0x4(%eax)
  8029ef:	eb 0b                	jmp    8029fc <alloc_block_BF+0x49e>
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 0f                	je     802a15 <alloc_block_BF+0x4b7>
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0f:	8b 12                	mov    (%edx),%edx
  802a11:	89 10                	mov    %edx,(%eax)
  802a13:	eb 0a                	jmp    802a1f <alloc_block_BF+0x4c1>
  802a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a32:	a1 38 50 80 00       	mov    0x805038,%eax
  802a37:	48                   	dec    %eax
  802a38:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	e9 d9 00 00 00       	jmp    802b1e <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	83 c0 08             	add    $0x8,%eax
  802a4b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a4e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a55:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a5b:	01 d0                	add    %edx,%eax
  802a5d:	48                   	dec    %eax
  802a5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a61:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a64:	ba 00 00 00 00       	mov    $0x0,%edx
  802a69:	f7 75 c4             	divl   -0x3c(%ebp)
  802a6c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a6f:	29 d0                	sub    %edx,%eax
  802a71:	c1 e8 0c             	shr    $0xc,%eax
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	50                   	push   %eax
  802a78:	e8 ad e6 ff ff       	call   80112a <sbrk>
  802a7d:	83 c4 10             	add    $0x10,%esp
  802a80:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a83:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a87:	75 0a                	jne    802a93 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8e:	e9 8b 00 00 00       	jmp    802b1e <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a93:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a9a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	48                   	dec    %eax
  802aa3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802aa6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802aa9:	ba 00 00 00 00       	mov    $0x0,%edx
  802aae:	f7 75 b8             	divl   -0x48(%ebp)
  802ab1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ab4:	29 d0                	sub    %edx,%eax
  802ab6:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ab9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802abc:	01 d0                	add    %edx,%eax
  802abe:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ac3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ace:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ad5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ad8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adb:	01 d0                	add    %edx,%eax
  802add:	48                   	dec    %eax
  802ade:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ae1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae9:	f7 75 b0             	divl   -0x50(%ebp)
  802aec:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802aef:	29 d0                	sub    %edx,%eax
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	6a 01                	push   $0x1
  802af6:	50                   	push   %eax
  802af7:	ff 75 bc             	pushl  -0x44(%ebp)
  802afa:	e8 74 f5 ff ff       	call   802073 <set_block_data>
  802aff:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b02:	83 ec 0c             	sub    $0xc,%esp
  802b05:	ff 75 bc             	pushl  -0x44(%ebp)
  802b08:	e8 36 04 00 00       	call   802f43 <free_block>
  802b0d:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b10:	83 ec 0c             	sub    $0xc,%esp
  802b13:	ff 75 08             	pushl  0x8(%ebp)
  802b16:	e8 43 fa ff ff       	call   80255e <alloc_block_BF>
  802b1b:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b1e:	c9                   	leave  
  802b1f:	c3                   	ret    

00802b20 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
  802b23:	53                   	push   %ebx
  802b24:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b39:	74 1e                	je     802b59 <merging+0x39>
  802b3b:	ff 75 08             	pushl  0x8(%ebp)
  802b3e:	e8 df f1 ff ff       	call   801d22 <get_block_size>
  802b43:	83 c4 04             	add    $0x4,%esp
  802b46:	89 c2                	mov    %eax,%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	01 d0                	add    %edx,%eax
  802b4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b50:	75 07                	jne    802b59 <merging+0x39>
		prev_is_free = 1;
  802b52:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b5d:	74 1e                	je     802b7d <merging+0x5d>
  802b5f:	ff 75 10             	pushl  0x10(%ebp)
  802b62:	e8 bb f1 ff ff       	call   801d22 <get_block_size>
  802b67:	83 c4 04             	add    $0x4,%esp
  802b6a:	89 c2                	mov    %eax,%edx
  802b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b6f:	01 d0                	add    %edx,%eax
  802b71:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b74:	75 07                	jne    802b7d <merging+0x5d>
		next_is_free = 1;
  802b76:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b81:	0f 84 cc 00 00 00    	je     802c53 <merging+0x133>
  802b87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8b:	0f 84 c2 00 00 00    	je     802c53 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b91:	ff 75 08             	pushl  0x8(%ebp)
  802b94:	e8 89 f1 ff ff       	call   801d22 <get_block_size>
  802b99:	83 c4 04             	add    $0x4,%esp
  802b9c:	89 c3                	mov    %eax,%ebx
  802b9e:	ff 75 10             	pushl  0x10(%ebp)
  802ba1:	e8 7c f1 ff ff       	call   801d22 <get_block_size>
  802ba6:	83 c4 04             	add    $0x4,%esp
  802ba9:	01 c3                	add    %eax,%ebx
  802bab:	ff 75 0c             	pushl  0xc(%ebp)
  802bae:	e8 6f f1 ff ff       	call   801d22 <get_block_size>
  802bb3:	83 c4 04             	add    $0x4,%esp
  802bb6:	01 d8                	add    %ebx,%eax
  802bb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bbb:	6a 00                	push   $0x0
  802bbd:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc0:	ff 75 08             	pushl  0x8(%ebp)
  802bc3:	e8 ab f4 ff ff       	call   802073 <set_block_data>
  802bc8:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bcf:	75 17                	jne    802be8 <merging+0xc8>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 23 44 80 00       	push   $0x804423
  802bd9:	68 7d 01 00 00       	push   $0x17d
  802bde:	68 41 44 80 00       	push   $0x804441
  802be3:	e8 12 0e 00 00       	call   8039fa <_panic>
  802be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 10                	je     802c01 <merging+0xe1>
  802bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf9:	8b 52 04             	mov    0x4(%edx),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	eb 0b                	jmp    802c0c <merging+0xec>
  802c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	85 c0                	test   %eax,%eax
  802c14:	74 0f                	je     802c25 <merging+0x105>
  802c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c1f:	8b 12                	mov    (%edx),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	eb 0a                	jmp    802c2f <merging+0x10f>
  802c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c42:	a1 38 50 80 00       	mov    0x805038,%eax
  802c47:	48                   	dec    %eax
  802c48:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c4d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c4e:	e9 ea 02 00 00       	jmp    802f3d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c57:	74 3b                	je     802c94 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c59:	83 ec 0c             	sub    $0xc,%esp
  802c5c:	ff 75 08             	pushl  0x8(%ebp)
  802c5f:	e8 be f0 ff ff       	call   801d22 <get_block_size>
  802c64:	83 c4 10             	add    $0x10,%esp
  802c67:	89 c3                	mov    %eax,%ebx
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	ff 75 10             	pushl  0x10(%ebp)
  802c6f:	e8 ae f0 ff ff       	call   801d22 <get_block_size>
  802c74:	83 c4 10             	add    $0x10,%esp
  802c77:	01 d8                	add    %ebx,%eax
  802c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	6a 00                	push   $0x0
  802c81:	ff 75 e8             	pushl  -0x18(%ebp)
  802c84:	ff 75 08             	pushl  0x8(%ebp)
  802c87:	e8 e7 f3 ff ff       	call   802073 <set_block_data>
  802c8c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c8f:	e9 a9 02 00 00       	jmp    802f3d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c98:	0f 84 2d 01 00 00    	je     802dcb <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	ff 75 10             	pushl  0x10(%ebp)
  802ca4:	e8 79 f0 ff ff       	call   801d22 <get_block_size>
  802ca9:	83 c4 10             	add    $0x10,%esp
  802cac:	89 c3                	mov    %eax,%ebx
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	ff 75 0c             	pushl  0xc(%ebp)
  802cb4:	e8 69 f0 ff ff       	call   801d22 <get_block_size>
  802cb9:	83 c4 10             	add    $0x10,%esp
  802cbc:	01 d8                	add    %ebx,%eax
  802cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	6a 00                	push   $0x0
  802cc6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cc9:	ff 75 10             	pushl  0x10(%ebp)
  802ccc:	e8 a2 f3 ff ff       	call   802073 <set_block_data>
  802cd1:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  802cd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802cda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cde:	74 06                	je     802ce6 <merging+0x1c6>
  802ce0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ce4:	75 17                	jne    802cfd <merging+0x1dd>
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	68 e8 44 80 00       	push   $0x8044e8
  802cee:	68 8d 01 00 00       	push   $0x18d
  802cf3:	68 41 44 80 00       	push   $0x804441
  802cf8:	e8 fd 0c 00 00       	call   8039fa <_panic>
  802cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d00:	8b 50 04             	mov    0x4(%eax),%edx
  802d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0d                	je     802d28 <merging+0x208>
  802d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	eb 08                	jmp    802d30 <merging+0x210>
  802d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d36:	89 50 04             	mov    %edx,0x4(%eax)
  802d39:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3e:	40                   	inc    %eax
  802d3f:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d48:	75 17                	jne    802d61 <merging+0x241>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 23 44 80 00       	push   $0x804423
  802d52:	68 8e 01 00 00       	push   $0x18e
  802d57:	68 41 44 80 00       	push   $0x804441
  802d5c:	e8 99 0c 00 00       	call   8039fa <_panic>
  802d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 10                	je     802d7a <merging+0x25a>
  802d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d72:	8b 52 04             	mov    0x4(%edx),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 0b                	jmp    802d85 <merging+0x265>
  802d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	a3 30 50 80 00       	mov    %eax,0x805030
  802d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0f                	je     802d9e <merging+0x27e>
  802d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d98:	8b 12                	mov    (%edx),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	eb 0a                	jmp    802da8 <merging+0x288>
  802d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbb:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc0:	48                   	dec    %eax
  802dc1:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dc6:	e9 72 01 00 00       	jmp    802f3d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dce:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	74 79                	je     802e50 <merging+0x330>
  802dd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ddb:	74 73                	je     802e50 <merging+0x330>
  802ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de1:	74 06                	je     802de9 <merging+0x2c9>
  802de3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802de7:	75 17                	jne    802e00 <merging+0x2e0>
  802de9:	83 ec 04             	sub    $0x4,%esp
  802dec:	68 b4 44 80 00       	push   $0x8044b4
  802df1:	68 94 01 00 00       	push   $0x194
  802df6:	68 41 44 80 00       	push   $0x804441
  802dfb:	e8 fa 0b 00 00       	call   8039fa <_panic>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 10                	mov    (%eax),%edx
  802e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0b                	je     802e1e <merging+0x2fe>
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e29:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2c:	89 50 04             	mov    %edx,0x4(%eax)
  802e2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	75 08                	jne    802e40 <merging+0x320>
  802e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e40:	a1 38 50 80 00       	mov    0x805038,%eax
  802e45:	40                   	inc    %eax
  802e46:	a3 38 50 80 00       	mov    %eax,0x805038
  802e4b:	e9 ce 00 00 00       	jmp    802f1e <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e54:	74 65                	je     802ebb <merging+0x39b>
  802e56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5a:	75 17                	jne    802e73 <merging+0x353>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 90 44 80 00       	push   $0x804490
  802e64:	68 95 01 00 00       	push   $0x195
  802e69:	68 41 44 80 00       	push   $0x804441
  802e6e:	e8 87 0b 00 00       	call   8039fa <_panic>
  802e73:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0c                	je     802e95 <merging+0x375>
  802e89:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	eb 08                	jmp    802e9d <merging+0x37d>
  802e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e98:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eae:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb3:	40                   	inc    %eax
  802eb4:	a3 38 50 80 00       	mov    %eax,0x805038
  802eb9:	eb 63                	jmp    802f1e <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802ebb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ebf:	75 17                	jne    802ed8 <merging+0x3b8>
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 5c 44 80 00       	push   $0x80445c
  802ec9:	68 98 01 00 00       	push   $0x198
  802ece:	68 41 44 80 00       	push   $0x804441
  802ed3:	e8 22 0b 00 00       	call   8039fa <_panic>
  802ed8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ede:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee1:	89 10                	mov    %edx,(%eax)
  802ee3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 0d                	je     802ef9 <merging+0x3d9>
  802eec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef4:	89 50 04             	mov    %edx,0x4(%eax)
  802ef7:	eb 08                	jmp    802f01 <merging+0x3e1>
  802ef9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efc:	a3 30 50 80 00       	mov    %eax,0x805030
  802f01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f13:	a1 38 50 80 00       	mov    0x805038,%eax
  802f18:	40                   	inc    %eax
  802f19:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	ff 75 10             	pushl  0x10(%ebp)
  802f24:	e8 f9 ed ff ff       	call   801d22 <get_block_size>
  802f29:	83 c4 10             	add    $0x10,%esp
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	6a 00                	push   $0x0
  802f31:	50                   	push   %eax
  802f32:	ff 75 10             	pushl  0x10(%ebp)
  802f35:	e8 39 f1 ff ff       	call   802073 <set_block_data>
  802f3a:	83 c4 10             	add    $0x10,%esp
	}
}
  802f3d:	90                   	nop
  802f3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f49:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f51:	a1 30 50 80 00       	mov    0x805030,%eax
  802f56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f59:	73 1b                	jae    802f76 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f5b:	a1 30 50 80 00       	mov    0x805030,%eax
  802f60:	83 ec 04             	sub    $0x4,%esp
  802f63:	ff 75 08             	pushl  0x8(%ebp)
  802f66:	6a 00                	push   $0x0
  802f68:	50                   	push   %eax
  802f69:	e8 b2 fb ff ff       	call   802b20 <merging>
  802f6e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f71:	e9 8b 00 00 00       	jmp    803001 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f76:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7e:	76 18                	jbe    802f98 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f80:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	ff 75 08             	pushl  0x8(%ebp)
  802f8b:	50                   	push   %eax
  802f8c:	6a 00                	push   $0x0
  802f8e:	e8 8d fb ff ff       	call   802b20 <merging>
  802f93:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f96:	eb 69                	jmp    803001 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f98:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa0:	eb 39                	jmp    802fdb <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fa8:	73 29                	jae    802fd3 <free_block+0x90>
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb2:	76 1f                	jbe    802fd3 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	ff 75 08             	pushl  0x8(%ebp)
  802fc2:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc8:	e8 53 fb ff ff       	call   802b20 <merging>
  802fcd:	83 c4 10             	add    $0x10,%esp
			break;
  802fd0:	90                   	nop
		}
	}
}
  802fd1:	eb 2e                	jmp    803001 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fd3:	a1 34 50 80 00       	mov    0x805034,%eax
  802fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdf:	74 07                	je     802fe8 <free_block+0xa5>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	eb 05                	jmp    802fed <free_block+0xaa>
  802fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fed:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff2:	a1 34 50 80 00       	mov    0x805034,%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	75 a7                	jne    802fa2 <free_block+0x5f>
  802ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fff:	75 a1                	jne    802fa2 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803001:	90                   	nop
  803002:	c9                   	leave  
  803003:	c3                   	ret    

00803004 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803004:	55                   	push   %ebp
  803005:	89 e5                	mov    %esp,%ebp
  803007:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	e8 10 ed ff ff       	call   801d22 <get_block_size>
  803012:	83 c4 04             	add    $0x4,%esp
  803015:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80301f:	eb 17                	jmp    803038 <copy_data+0x34>
  803021:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803024:	8b 45 0c             	mov    0xc(%ebp),%eax
  803027:	01 c2                	add    %eax,%edx
  803029:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	01 c8                	add    %ecx,%eax
  803031:	8a 00                	mov    (%eax),%al
  803033:	88 02                	mov    %al,(%edx)
  803035:	ff 45 fc             	incl   -0x4(%ebp)
  803038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80303b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80303e:	72 e1                	jb     803021 <copy_data+0x1d>
}
  803040:	90                   	nop
  803041:	c9                   	leave  
  803042:	c3                   	ret    

00803043 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803043:	55                   	push   %ebp
  803044:	89 e5                	mov    %esp,%ebp
  803046:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304d:	75 23                	jne    803072 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80304f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803053:	74 13                	je     803068 <realloc_block_FF+0x25>
  803055:	83 ec 0c             	sub    $0xc,%esp
  803058:	ff 75 0c             	pushl  0xc(%ebp)
  80305b:	e8 42 f0 ff ff       	call   8020a2 <alloc_block_FF>
  803060:	83 c4 10             	add    $0x10,%esp
  803063:	e9 e4 06 00 00       	jmp    80374c <realloc_block_FF+0x709>
		return NULL;
  803068:	b8 00 00 00 00       	mov    $0x0,%eax
  80306d:	e9 da 06 00 00       	jmp    80374c <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803076:	75 18                	jne    803090 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803078:	83 ec 0c             	sub    $0xc,%esp
  80307b:	ff 75 08             	pushl  0x8(%ebp)
  80307e:	e8 c0 fe ff ff       	call   802f43 <free_block>
  803083:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803086:	b8 00 00 00 00       	mov    $0x0,%eax
  80308b:	e9 bc 06 00 00       	jmp    80374c <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803090:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803094:	77 07                	ja     80309d <realloc_block_FF+0x5a>
  803096:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80309d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a0:	83 e0 01             	and    $0x1,%eax
  8030a3:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a9:	83 c0 08             	add    $0x8,%eax
  8030ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8030af:	83 ec 0c             	sub    $0xc,%esp
  8030b2:	ff 75 08             	pushl  0x8(%ebp)
  8030b5:	e8 68 ec ff ff       	call   801d22 <get_block_size>
  8030ba:	83 c4 10             	add    $0x10,%esp
  8030bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c3:	83 e8 08             	sub    $0x8,%eax
  8030c6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	83 e8 04             	sub    $0x4,%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8030d4:	89 c2                	mov    %eax,%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	01 d0                	add    %edx,%eax
  8030db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8030de:	83 ec 0c             	sub    $0xc,%esp
  8030e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030e4:	e8 39 ec ff ff       	call   801d22 <get_block_size>
  8030e9:	83 c4 10             	add    $0x10,%esp
  8030ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f2:	83 e8 08             	sub    $0x8,%eax
  8030f5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8030f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030fe:	75 08                	jne    803108 <realloc_block_FF+0xc5>
	{
		 return va;
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	e9 44 06 00 00       	jmp    80374c <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80310e:	0f 83 d5 03 00 00    	jae    8034e9 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	2b 45 0c             	sub    0xc(%ebp),%eax
  80311a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80311d:	83 ec 0c             	sub    $0xc,%esp
  803120:	ff 75 e4             	pushl  -0x1c(%ebp)
  803123:	e8 13 ec ff ff       	call   801d3b <is_free_block>
  803128:	83 c4 10             	add    $0x10,%esp
  80312b:	84 c0                	test   %al,%al
  80312d:	0f 84 3b 01 00 00    	je     80326e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803133:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803136:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803139:	01 d0                	add    %edx,%eax
  80313b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	6a 01                	push   $0x1
  803143:	ff 75 f0             	pushl  -0x10(%ebp)
  803146:	ff 75 08             	pushl  0x8(%ebp)
  803149:	e8 25 ef ff ff       	call   802073 <set_block_data>
  80314e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	83 e8 04             	sub    $0x4,%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	83 e0 fe             	and    $0xfffffffe,%eax
  80315c:	89 c2                	mov    %eax,%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	01 d0                	add    %edx,%eax
  803163:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	6a 00                	push   $0x0
  80316b:	ff 75 cc             	pushl  -0x34(%ebp)
  80316e:	ff 75 c8             	pushl  -0x38(%ebp)
  803171:	e8 fd ee ff ff       	call   802073 <set_block_data>
  803176:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317d:	74 06                	je     803185 <realloc_block_FF+0x142>
  80317f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803183:	75 17                	jne    80319c <realloc_block_FF+0x159>
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	68 b4 44 80 00       	push   $0x8044b4
  80318d:	68 f6 01 00 00       	push   $0x1f6
  803192:	68 41 44 80 00       	push   $0x804441
  803197:	e8 5e 08 00 00       	call   8039fa <_panic>
  80319c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319f:	8b 10                	mov    (%eax),%edx
  8031a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031a4:	89 10                	mov    %edx,(%eax)
  8031a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 0b                	je     8031ba <realloc_block_FF+0x177>
  8031af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031b7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031c8:	89 50 04             	mov    %edx,0x4(%eax)
  8031cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	75 08                	jne    8031dc <realloc_block_FF+0x199>
  8031d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8031dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e1:	40                   	inc    %eax
  8031e2:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8031e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031eb:	75 17                	jne    803204 <realloc_block_FF+0x1c1>
  8031ed:	83 ec 04             	sub    $0x4,%esp
  8031f0:	68 23 44 80 00       	push   $0x804423
  8031f5:	68 f7 01 00 00       	push   $0x1f7
  8031fa:	68 41 44 80 00       	push   $0x804441
  8031ff:	e8 f6 07 00 00       	call   8039fa <_panic>
  803204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	74 10                	je     80321d <realloc_block_FF+0x1da>
  80320d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803215:	8b 52 04             	mov    0x4(%edx),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	eb 0b                	jmp    803228 <realloc_block_FF+0x1e5>
  80321d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	a3 30 50 80 00       	mov    %eax,0x805030
  803228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	85 c0                	test   %eax,%eax
  803230:	74 0f                	je     803241 <realloc_block_FF+0x1fe>
  803232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323b:	8b 12                	mov    (%edx),%edx
  80323d:	89 10                	mov    %edx,(%eax)
  80323f:	eb 0a                	jmp    80324b <realloc_block_FF+0x208>
  803241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80324b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803257:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325e:	a1 38 50 80 00       	mov    0x805038,%eax
  803263:	48                   	dec    %eax
  803264:	a3 38 50 80 00       	mov    %eax,0x805038
  803269:	e9 73 02 00 00       	jmp    8034e1 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80326e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803272:	0f 86 69 02 00 00    	jbe    8034e1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803278:	83 ec 04             	sub    $0x4,%esp
  80327b:	6a 01                	push   $0x1
  80327d:	ff 75 f0             	pushl  -0x10(%ebp)
  803280:	ff 75 08             	pushl  0x8(%ebp)
  803283:	e8 eb ed ff ff       	call   802073 <set_block_data>
  803288:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	83 e8 04             	sub    $0x4,%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	83 e0 fe             	and    $0xfffffffe,%eax
  803296:	89 c2                	mov    %eax,%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	01 d0                	add    %edx,%eax
  80329d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8032a8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032ac:	75 68                	jne    803316 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b2:	75 17                	jne    8032cb <realloc_block_FF+0x288>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 5c 44 80 00       	push   $0x80445c
  8032bc:	68 06 02 00 00       	push   $0x206
  8032c1:	68 41 44 80 00       	push   $0x804441
  8032c6:	e8 2f 07 00 00       	call   8039fa <_panic>
  8032cb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d4:	89 10                	mov    %edx,(%eax)
  8032d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	74 0d                	je     8032ec <realloc_block_FF+0x2a9>
  8032df:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	eb 08                	jmp    8032f4 <realloc_block_FF+0x2b1>
  8032ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803306:	a1 38 50 80 00       	mov    0x805038,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 38 50 80 00       	mov    %eax,0x805038
  803311:	e9 b0 01 00 00       	jmp    8034c6 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803316:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80331b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80331e:	76 68                	jbe    803388 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803320:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803324:	75 17                	jne    80333d <realloc_block_FF+0x2fa>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 5c 44 80 00       	push   $0x80445c
  80332e:	68 0b 02 00 00       	push   $0x20b
  803333:	68 41 44 80 00       	push   $0x804441
  803338:	e8 bd 06 00 00       	call   8039fa <_panic>
  80333d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803346:	89 10                	mov    %edx,(%eax)
  803348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0d                	je     80335e <realloc_block_FF+0x31b>
  803351:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803356:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 08                	jmp    803366 <realloc_block_FF+0x323>
  80335e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803361:	a3 30 50 80 00       	mov    %eax,0x805030
  803366:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803369:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80336e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 38 50 80 00       	mov    0x805038,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 38 50 80 00       	mov    %eax,0x805038
  803383:	e9 3e 01 00 00       	jmp    8034c6 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803388:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803390:	73 68                	jae    8033fa <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803392:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803396:	75 17                	jne    8033af <realloc_block_FF+0x36c>
  803398:	83 ec 04             	sub    $0x4,%esp
  80339b:	68 90 44 80 00       	push   $0x804490
  8033a0:	68 10 02 00 00       	push   $0x210
  8033a5:	68 41 44 80 00       	push   $0x804441
  8033aa:	e8 4b 06 00 00       	call   8039fa <_panic>
  8033af:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b8:	89 50 04             	mov    %edx,0x4(%eax)
  8033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033be:	8b 40 04             	mov    0x4(%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	74 0c                	je     8033d1 <realloc_block_FF+0x38e>
  8033c5:	a1 30 50 80 00       	mov    0x805030,%eax
  8033ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 08                	jmp    8033d9 <realloc_block_FF+0x396>
  8033d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ef:	40                   	inc    %eax
  8033f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f5:	e9 cc 00 00 00       	jmp    8034c6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8033fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803401:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803409:	e9 8a 00 00 00       	jmp    803498 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803414:	73 7a                	jae    803490 <realloc_block_FF+0x44d>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80341e:	73 70                	jae    803490 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803424:	74 06                	je     80342c <realloc_block_FF+0x3e9>
  803426:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342a:	75 17                	jne    803443 <realloc_block_FF+0x400>
  80342c:	83 ec 04             	sub    $0x4,%esp
  80342f:	68 b4 44 80 00       	push   $0x8044b4
  803434:	68 1a 02 00 00       	push   $0x21a
  803439:	68 41 44 80 00       	push   $0x804441
  80343e:	e8 b7 05 00 00       	call   8039fa <_panic>
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 10                	mov    (%eax),%edx
  803448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	74 0b                	je     803461 <realloc_block_FF+0x41e>
  803456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803467:	89 10                	mov    %edx,(%eax)
  803469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346f:	89 50 04             	mov    %edx,0x4(%eax)
  803472:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803475:	8b 00                	mov    (%eax),%eax
  803477:	85 c0                	test   %eax,%eax
  803479:	75 08                	jne    803483 <realloc_block_FF+0x440>
  80347b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347e:	a3 30 50 80 00       	mov    %eax,0x805030
  803483:	a1 38 50 80 00       	mov    0x805038,%eax
  803488:	40                   	inc    %eax
  803489:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80348e:	eb 36                	jmp    8034c6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803490:	a1 34 50 80 00       	mov    0x805034,%eax
  803495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349c:	74 07                	je     8034a5 <realloc_block_FF+0x462>
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	8b 00                	mov    (%eax),%eax
  8034a3:	eb 05                	jmp    8034aa <realloc_block_FF+0x467>
  8034a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034aa:	a3 34 50 80 00       	mov    %eax,0x805034
  8034af:	a1 34 50 80 00       	mov    0x805034,%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	0f 85 52 ff ff ff    	jne    80340e <realloc_block_FF+0x3cb>
  8034bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c0:	0f 85 48 ff ff ff    	jne    80340e <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	6a 00                	push   $0x0
  8034cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8034ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034d1:	e8 9d eb ff ff       	call   802073 <set_block_data>
  8034d6:	83 c4 10             	add    $0x10,%esp
				return va;
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	e9 6b 02 00 00       	jmp    80374c <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	e9 63 02 00 00       	jmp    80374c <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8034e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034ef:	0f 86 4d 02 00 00    	jbe    803742 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8034f5:	83 ec 0c             	sub    $0xc,%esp
  8034f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034fb:	e8 3b e8 ff ff       	call   801d3b <is_free_block>
  803500:	83 c4 10             	add    $0x10,%esp
  803503:	84 c0                	test   %al,%al
  803505:	0f 84 37 02 00 00    	je     803742 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80350b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803511:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803514:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803517:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80351a:	76 38                	jbe    803554 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80351c:	83 ec 0c             	sub    $0xc,%esp
  80351f:	ff 75 0c             	pushl  0xc(%ebp)
  803522:	e8 7b eb ff ff       	call   8020a2 <alloc_block_FF>
  803527:	83 c4 10             	add    $0x10,%esp
  80352a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80352d:	83 ec 08             	sub    $0x8,%esp
  803530:	ff 75 c0             	pushl  -0x40(%ebp)
  803533:	ff 75 08             	pushl  0x8(%ebp)
  803536:	e8 c9 fa ff ff       	call   803004 <copy_data>
  80353b:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80353e:	83 ec 0c             	sub    $0xc,%esp
  803541:	ff 75 08             	pushl  0x8(%ebp)
  803544:	e8 fa f9 ff ff       	call   802f43 <free_block>
  803549:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80354c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80354f:	e9 f8 01 00 00       	jmp    80374c <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803554:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803557:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80355a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80355d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803561:	0f 87 a0 00 00 00    	ja     803607 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356b:	75 17                	jne    803584 <realloc_block_FF+0x541>
  80356d:	83 ec 04             	sub    $0x4,%esp
  803570:	68 23 44 80 00       	push   $0x804423
  803575:	68 38 02 00 00       	push   $0x238
  80357a:	68 41 44 80 00       	push   $0x804441
  80357f:	e8 76 04 00 00       	call   8039fa <_panic>
  803584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 10                	je     80359d <realloc_block_FF+0x55a>
  80358d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803595:	8b 52 04             	mov    0x4(%edx),%edx
  803598:	89 50 04             	mov    %edx,0x4(%eax)
  80359b:	eb 0b                	jmp    8035a8 <realloc_block_FF+0x565>
  80359d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a0:	8b 40 04             	mov    0x4(%eax),%eax
  8035a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ab:	8b 40 04             	mov    0x4(%eax),%eax
  8035ae:	85 c0                	test   %eax,%eax
  8035b0:	74 0f                	je     8035c1 <realloc_block_FF+0x57e>
  8035b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b5:	8b 40 04             	mov    0x4(%eax),%eax
  8035b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035bb:	8b 12                	mov    (%edx),%edx
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	eb 0a                	jmp    8035cb <realloc_block_FF+0x588>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035de:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e3:	48                   	dec    %eax
  8035e4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8035e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ef:	01 d0                	add    %edx,%eax
  8035f1:	83 ec 04             	sub    $0x4,%esp
  8035f4:	6a 01                	push   $0x1
  8035f6:	50                   	push   %eax
  8035f7:	ff 75 08             	pushl  0x8(%ebp)
  8035fa:	e8 74 ea ff ff       	call   802073 <set_block_data>
  8035ff:	83 c4 10             	add    $0x10,%esp
  803602:	e9 36 01 00 00       	jmp    80373d <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803607:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80360a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80360d:	01 d0                	add    %edx,%eax
  80360f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	6a 01                	push   $0x1
  803617:	ff 75 f0             	pushl  -0x10(%ebp)
  80361a:	ff 75 08             	pushl  0x8(%ebp)
  80361d:	e8 51 ea ff ff       	call   802073 <set_block_data>
  803622:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	83 e8 04             	sub    $0x4,%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	83 e0 fe             	and    $0xfffffffe,%eax
  803630:	89 c2                	mov    %eax,%edx
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	01 d0                	add    %edx,%eax
  803637:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80363a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80363e:	74 06                	je     803646 <realloc_block_FF+0x603>
  803640:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803644:	75 17                	jne    80365d <realloc_block_FF+0x61a>
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	68 b4 44 80 00       	push   $0x8044b4
  80364e:	68 44 02 00 00       	push   $0x244
  803653:	68 41 44 80 00       	push   $0x804441
  803658:	e8 9d 03 00 00       	call   8039fa <_panic>
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	8b 10                	mov    (%eax),%edx
  803662:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803665:	89 10                	mov    %edx,(%eax)
  803667:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	74 0b                	je     80367b <realloc_block_FF+0x638>
  803670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803678:	89 50 04             	mov    %edx,0x4(%eax)
  80367b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803681:	89 10                	mov    %edx,(%eax)
  803683:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803689:	89 50 04             	mov    %edx,0x4(%eax)
  80368c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	85 c0                	test   %eax,%eax
  803693:	75 08                	jne    80369d <realloc_block_FF+0x65a>
  803695:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803698:	a3 30 50 80 00       	mov    %eax,0x805030
  80369d:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a2:	40                   	inc    %eax
  8036a3:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ac:	75 17                	jne    8036c5 <realloc_block_FF+0x682>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 23 44 80 00       	push   $0x804423
  8036b6:	68 45 02 00 00       	push   $0x245
  8036bb:	68 41 44 80 00       	push   $0x804441
  8036c0:	e8 35 03 00 00       	call   8039fa <_panic>
  8036c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 10                	je     8036de <realloc_block_FF+0x69b>
  8036ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d1:	8b 00                	mov    (%eax),%eax
  8036d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d6:	8b 52 04             	mov    0x4(%edx),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 0b                	jmp    8036e9 <realloc_block_FF+0x6a6>
  8036de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e1:	8b 40 04             	mov    0x4(%eax),%eax
  8036e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ec:	8b 40 04             	mov    0x4(%eax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	74 0f                	je     803702 <realloc_block_FF+0x6bf>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fc:	8b 12                	mov    (%edx),%edx
  8036fe:	89 10                	mov    %edx,(%eax)
  803700:	eb 0a                	jmp    80370c <realloc_block_FF+0x6c9>
  803702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803705:	8b 00                	mov    (%eax),%eax
  803707:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371f:	a1 38 50 80 00       	mov    0x805038,%eax
  803724:	48                   	dec    %eax
  803725:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80372a:	83 ec 04             	sub    $0x4,%esp
  80372d:	6a 00                	push   $0x0
  80372f:	ff 75 bc             	pushl  -0x44(%ebp)
  803732:	ff 75 b8             	pushl  -0x48(%ebp)
  803735:	e8 39 e9 ff ff       	call   802073 <set_block_data>
  80373a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	eb 0a                	jmp    80374c <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803742:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80374c:	c9                   	leave  
  80374d:	c3                   	ret    

0080374e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80374e:	55                   	push   %ebp
  80374f:	89 e5                	mov    %esp,%ebp
  803751:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803754:	83 ec 04             	sub    $0x4,%esp
  803757:	68 20 45 80 00       	push   $0x804520
  80375c:	68 58 02 00 00       	push   $0x258
  803761:	68 41 44 80 00       	push   $0x804441
  803766:	e8 8f 02 00 00       	call   8039fa <_panic>

0080376b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80376b:	55                   	push   %ebp
  80376c:	89 e5                	mov    %esp,%ebp
  80376e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 48 45 80 00       	push   $0x804548
  803779:	68 61 02 00 00       	push   $0x261
  80377e:	68 41 44 80 00       	push   $0x804441
  803783:	e8 72 02 00 00       	call   8039fa <_panic>

00803788 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803788:	55                   	push   %ebp
  803789:	89 e5                	mov    %esp,%ebp
  80378b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  80378e:	83 ec 04             	sub    $0x4,%esp
  803791:	6a 01                	push   $0x1
  803793:	6a 04                	push   $0x4
  803795:	ff 75 0c             	pushl  0xc(%ebp)
  803798:	e8 c1 dc ff ff       	call   80145e <smalloc>
  80379d:	83 c4 10             	add    $0x10,%esp
  8037a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  8037a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a7:	75 14                	jne    8037bd <create_semaphore+0x35>
  8037a9:	83 ec 04             	sub    $0x4,%esp
  8037ac:	68 6e 45 80 00       	push   $0x80456e
  8037b1:	6a 0d                	push   $0xd
  8037b3:	68 8b 45 80 00       	push   $0x80458b
  8037b8:	e8 3d 02 00 00       	call   8039fa <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8037c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	8b 55 10             	mov    0x10(%ebp),%edx
  8037cb:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8037ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	83 ec 0c             	sub    $0xc,%esp
  8037d6:	50                   	push   %eax
  8037d7:	e8 cc e4 ff ff       	call   801ca8 <sys_init_queue>
  8037dc:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8037df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f1:	8b 12                	mov    (%edx),%edx
  8037f3:	89 10                	mov    %edx,(%eax)
}
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	c9                   	leave  
  8037f9:	c2 04 00             	ret    $0x4

008037fc <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8037fc:	55                   	push   %ebp
  8037fd:	89 e5                	mov    %esp,%ebp
  8037ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803802:	83 ec 08             	sub    $0x8,%esp
  803805:	ff 75 10             	pushl  0x10(%ebp)
  803808:	ff 75 0c             	pushl  0xc(%ebp)
  80380b:	e8 f3 dc ff ff       	call   801503 <sget>
  803810:	83 c4 10             	add    $0x10,%esp
  803813:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381a:	75 14                	jne    803830 <get_semaphore+0x34>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 9b 45 80 00       	push   $0x80459b
  803824:	6a 1f                	push   $0x1f
  803826:	68 8b 45 80 00       	push   $0x80458b
  80382b:	e8 ca 01 00 00       	call   8039fa <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803833:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803836:	8b 45 08             	mov    0x8(%ebp),%eax
  803839:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80383c:	8b 12                	mov    (%edx),%edx
  80383e:	89 10                	mov    %edx,(%eax)
}
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	c9                   	leave  
  803844:	c2 04 00             	ret    $0x4

00803847 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803847:	55                   	push   %ebp
  803848:	89 e5                	mov    %esp,%ebp
  80384a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  80384d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803854:	8b 45 08             	mov    0x8(%ebp),%eax
  803857:	83 c0 14             	add    $0x14,%eax
  80385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80385d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803860:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803863:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803869:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80386c:	f0 87 02             	lock xchg %eax,(%edx)
  80386f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803876:	75 dc                	jne    803854 <wait_semaphore+0xd>

		    sem.semdata->count--;
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 50 10             	mov    0x10(%eax),%edx
  80387e:	4a                   	dec    %edx
  80387f:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	8b 40 10             	mov    0x10(%eax),%eax
  803888:	85 c0                	test   %eax,%eax
  80388a:	79 30                	jns    8038bc <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  80388c:	e8 f5 e3 ff ff       	call   801c86 <sys_get_cpu_process>
  803891:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	83 ec 08             	sub    $0x8,%esp
  80389a:	ff 75 f0             	pushl  -0x10(%ebp)
  80389d:	50                   	push   %eax
  80389e:	e8 21 e4 ff ff       	call   801cc4 <sys_enqueue>
  8038a3:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  8038a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a9:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  8038b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  8038ba:	eb 0a                	jmp    8038c6 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  8038c6:	90                   	nop
  8038c7:	c9                   	leave  
  8038c8:	c3                   	ret    

008038c9 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8038c9:	55                   	push   %ebp
  8038ca:	89 e5                	mov    %esp,%ebp
  8038cc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  8038cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	83 c0 14             	add    $0x14,%eax
  8038dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8038df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8038e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038eb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8038ee:	f0 87 02             	lock xchg %eax,(%edx)
  8038f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8038f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f8:	75 dc                	jne    8038d6 <signal_semaphore+0xd>
	    sem.semdata->count++;
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	8b 50 10             	mov    0x10(%eax),%edx
  803900:	42                   	inc    %edx
  803901:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	8b 40 10             	mov    0x10(%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	7f 20                	jg     80392e <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  80390e:	8b 45 08             	mov    0x8(%ebp),%eax
  803911:	83 ec 0c             	sub    $0xc,%esp
  803914:	50                   	push   %eax
  803915:	e8 c8 e3 ff ff       	call   801ce2 <sys_dequeue>
  80391a:	83 c4 10             	add    $0x10,%esp
  80391d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803920:	83 ec 0c             	sub    $0xc,%esp
  803923:	ff 75 f0             	pushl  -0x10(%ebp)
  803926:	e8 db e3 ff ff       	call   801d06 <sys_sched_insert_ready>
  80392b:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803938:	90                   	nop
  803939:	c9                   	leave  
  80393a:	c3                   	ret    

0080393b <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  80393b:	55                   	push   %ebp
  80393c:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 40 10             	mov    0x10(%eax),%eax
}
  803944:	5d                   	pop    %ebp
  803945:	c3                   	ret    

00803946 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803946:	55                   	push   %ebp
  803947:	89 e5                	mov    %esp,%ebp
  803949:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80394c:	8b 55 08             	mov    0x8(%ebp),%edx
  80394f:	89 d0                	mov    %edx,%eax
  803951:	c1 e0 02             	shl    $0x2,%eax
  803954:	01 d0                	add    %edx,%eax
  803956:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80395d:	01 d0                	add    %edx,%eax
  80395f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803966:	01 d0                	add    %edx,%eax
  803968:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80396f:	01 d0                	add    %edx,%eax
  803971:	c1 e0 04             	shl    $0x4,%eax
  803974:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803977:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80397e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803981:	83 ec 0c             	sub    $0xc,%esp
  803984:	50                   	push   %eax
  803985:	e8 08 e0 ff ff       	call   801992 <sys_get_virtual_time>
  80398a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80398d:	eb 41                	jmp    8039d0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80398f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803992:	83 ec 0c             	sub    $0xc,%esp
  803995:	50                   	push   %eax
  803996:	e8 f7 df ff ff       	call   801992 <sys_get_virtual_time>
  80399b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80399e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a4:	29 c2                	sub    %eax,%edx
  8039a6:	89 d0                	mov    %edx,%eax
  8039a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8039ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b1:	89 d1                	mov    %edx,%ecx
  8039b3:	29 c1                	sub    %eax,%ecx
  8039b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039bb:	39 c2                	cmp    %eax,%edx
  8039bd:	0f 97 c0             	seta   %al
  8039c0:	0f b6 c0             	movzbl %al,%eax
  8039c3:	29 c1                	sub    %eax,%ecx
  8039c5:	89 c8                	mov    %ecx,%eax
  8039c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8039ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039d6:	72 b7                	jb     80398f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8039d8:	90                   	nop
  8039d9:	c9                   	leave  
  8039da:	c3                   	ret    

008039db <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8039db:	55                   	push   %ebp
  8039dc:	89 e5                	mov    %esp,%ebp
  8039de:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8039e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8039e8:	eb 03                	jmp    8039ed <busy_wait+0x12>
  8039ea:	ff 45 fc             	incl   -0x4(%ebp)
  8039ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039f3:	72 f5                	jb     8039ea <busy_wait+0xf>
	return i;
  8039f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
  8039fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a00:	8d 45 10             	lea    0x10(%ebp),%eax
  803a03:	83 c0 04             	add    $0x4,%eax
  803a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a09:	a1 60 50 98 00       	mov    0x985060,%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	74 16                	je     803a28 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a12:	a1 60 50 98 00       	mov    0x985060,%eax
  803a17:	83 ec 08             	sub    $0x8,%esp
  803a1a:	50                   	push   %eax
  803a1b:	68 bc 45 80 00       	push   $0x8045bc
  803a20:	e8 6b c9 ff ff       	call   800390 <cprintf>
  803a25:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a28:	a1 00 50 80 00       	mov    0x805000,%eax
  803a2d:	ff 75 0c             	pushl  0xc(%ebp)
  803a30:	ff 75 08             	pushl  0x8(%ebp)
  803a33:	50                   	push   %eax
  803a34:	68 c1 45 80 00       	push   $0x8045c1
  803a39:	e8 52 c9 ff ff       	call   800390 <cprintf>
  803a3e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a41:	8b 45 10             	mov    0x10(%ebp),%eax
  803a44:	83 ec 08             	sub    $0x8,%esp
  803a47:	ff 75 f4             	pushl  -0xc(%ebp)
  803a4a:	50                   	push   %eax
  803a4b:	e8 d5 c8 ff ff       	call   800325 <vcprintf>
  803a50:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a53:	83 ec 08             	sub    $0x8,%esp
  803a56:	6a 00                	push   $0x0
  803a58:	68 dd 45 80 00       	push   $0x8045dd
  803a5d:	e8 c3 c8 ff ff       	call   800325 <vcprintf>
  803a62:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a65:	e8 44 c8 ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  803a6a:	eb fe                	jmp    803a6a <_panic+0x70>

00803a6c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a6c:	55                   	push   %ebp
  803a6d:	89 e5                	mov    %esp,%ebp
  803a6f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a72:	a1 20 50 80 00       	mov    0x805020,%eax
  803a77:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a80:	39 c2                	cmp    %eax,%edx
  803a82:	74 14                	je     803a98 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a84:	83 ec 04             	sub    $0x4,%esp
  803a87:	68 e0 45 80 00       	push   $0x8045e0
  803a8c:	6a 26                	push   $0x26
  803a8e:	68 2c 46 80 00       	push   $0x80462c
  803a93:	e8 62 ff ff ff       	call   8039fa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803aa6:	e9 c5 00 00 00       	jmp    803b70 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab8:	01 d0                	add    %edx,%eax
  803aba:	8b 00                	mov    (%eax),%eax
  803abc:	85 c0                	test   %eax,%eax
  803abe:	75 08                	jne    803ac8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ac0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ac3:	e9 a5 00 00 00       	jmp    803b6d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ac8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803acf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ad6:	eb 69                	jmp    803b41 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ad8:	a1 20 50 80 00       	mov    0x805020,%eax
  803add:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ae3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ae6:	89 d0                	mov    %edx,%eax
  803ae8:	01 c0                	add    %eax,%eax
  803aea:	01 d0                	add    %edx,%eax
  803aec:	c1 e0 03             	shl    $0x3,%eax
  803aef:	01 c8                	add    %ecx,%eax
  803af1:	8a 40 04             	mov    0x4(%eax),%al
  803af4:	84 c0                	test   %al,%al
  803af6:	75 46                	jne    803b3e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803af8:	a1 20 50 80 00       	mov    0x805020,%eax
  803afd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b06:	89 d0                	mov    %edx,%eax
  803b08:	01 c0                	add    %eax,%eax
  803b0a:	01 d0                	add    %edx,%eax
  803b0c:	c1 e0 03             	shl    $0x3,%eax
  803b0f:	01 c8                	add    %ecx,%eax
  803b11:	8b 00                	mov    (%eax),%eax
  803b13:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b1e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b23:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	01 c8                	add    %ecx,%eax
  803b2f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b31:	39 c2                	cmp    %eax,%edx
  803b33:	75 09                	jne    803b3e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b35:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b3c:	eb 15                	jmp    803b53 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b3e:	ff 45 e8             	incl   -0x18(%ebp)
  803b41:	a1 20 50 80 00       	mov    0x805020,%eax
  803b46:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4f:	39 c2                	cmp    %eax,%edx
  803b51:	77 85                	ja     803ad8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b57:	75 14                	jne    803b6d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b59:	83 ec 04             	sub    $0x4,%esp
  803b5c:	68 38 46 80 00       	push   $0x804638
  803b61:	6a 3a                	push   $0x3a
  803b63:	68 2c 46 80 00       	push   $0x80462c
  803b68:	e8 8d fe ff ff       	call   8039fa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b6d:	ff 45 f0             	incl   -0x10(%ebp)
  803b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b73:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b76:	0f 8c 2f ff ff ff    	jl     803aab <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b7c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b8a:	eb 26                	jmp    803bb2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b91:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b9a:	89 d0                	mov    %edx,%eax
  803b9c:	01 c0                	add    %eax,%eax
  803b9e:	01 d0                	add    %edx,%eax
  803ba0:	c1 e0 03             	shl    $0x3,%eax
  803ba3:	01 c8                	add    %ecx,%eax
  803ba5:	8a 40 04             	mov    0x4(%eax),%al
  803ba8:	3c 01                	cmp    $0x1,%al
  803baa:	75 03                	jne    803baf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bac:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803baf:	ff 45 e0             	incl   -0x20(%ebp)
  803bb2:	a1 20 50 80 00       	mov    0x805020,%eax
  803bb7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc0:	39 c2                	cmp    %eax,%edx
  803bc2:	77 c8                	ja     803b8c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bca:	74 14                	je     803be0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bcc:	83 ec 04             	sub    $0x4,%esp
  803bcf:	68 8c 46 80 00       	push   $0x80468c
  803bd4:	6a 44                	push   $0x44
  803bd6:	68 2c 46 80 00       	push   $0x80462c
  803bdb:	e8 1a fe ff ff       	call   8039fa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803be0:	90                   	nop
  803be1:	c9                   	leave  
  803be2:	c3                   	ret    
  803be3:	90                   	nop

00803be4 <__udivdi3>:
  803be4:	55                   	push   %ebp
  803be5:	57                   	push   %edi
  803be6:	56                   	push   %esi
  803be7:	53                   	push   %ebx
  803be8:	83 ec 1c             	sub    $0x1c,%esp
  803beb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bfb:	89 ca                	mov    %ecx,%edx
  803bfd:	89 f8                	mov    %edi,%eax
  803bff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c03:	85 f6                	test   %esi,%esi
  803c05:	75 2d                	jne    803c34 <__udivdi3+0x50>
  803c07:	39 cf                	cmp    %ecx,%edi
  803c09:	77 65                	ja     803c70 <__udivdi3+0x8c>
  803c0b:	89 fd                	mov    %edi,%ebp
  803c0d:	85 ff                	test   %edi,%edi
  803c0f:	75 0b                	jne    803c1c <__udivdi3+0x38>
  803c11:	b8 01 00 00 00       	mov    $0x1,%eax
  803c16:	31 d2                	xor    %edx,%edx
  803c18:	f7 f7                	div    %edi
  803c1a:	89 c5                	mov    %eax,%ebp
  803c1c:	31 d2                	xor    %edx,%edx
  803c1e:	89 c8                	mov    %ecx,%eax
  803c20:	f7 f5                	div    %ebp
  803c22:	89 c1                	mov    %eax,%ecx
  803c24:	89 d8                	mov    %ebx,%eax
  803c26:	f7 f5                	div    %ebp
  803c28:	89 cf                	mov    %ecx,%edi
  803c2a:	89 fa                	mov    %edi,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	39 ce                	cmp    %ecx,%esi
  803c36:	77 28                	ja     803c60 <__udivdi3+0x7c>
  803c38:	0f bd fe             	bsr    %esi,%edi
  803c3b:	83 f7 1f             	xor    $0x1f,%edi
  803c3e:	75 40                	jne    803c80 <__udivdi3+0x9c>
  803c40:	39 ce                	cmp    %ecx,%esi
  803c42:	72 0a                	jb     803c4e <__udivdi3+0x6a>
  803c44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c48:	0f 87 9e 00 00 00    	ja     803cec <__udivdi3+0x108>
  803c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c53:	89 fa                	mov    %edi,%edx
  803c55:	83 c4 1c             	add    $0x1c,%esp
  803c58:	5b                   	pop    %ebx
  803c59:	5e                   	pop    %esi
  803c5a:	5f                   	pop    %edi
  803c5b:	5d                   	pop    %ebp
  803c5c:	c3                   	ret    
  803c5d:	8d 76 00             	lea    0x0(%esi),%esi
  803c60:	31 ff                	xor    %edi,%edi
  803c62:	31 c0                	xor    %eax,%eax
  803c64:	89 fa                	mov    %edi,%edx
  803c66:	83 c4 1c             	add    $0x1c,%esp
  803c69:	5b                   	pop    %ebx
  803c6a:	5e                   	pop    %esi
  803c6b:	5f                   	pop    %edi
  803c6c:	5d                   	pop    %ebp
  803c6d:	c3                   	ret    
  803c6e:	66 90                	xchg   %ax,%ax
  803c70:	89 d8                	mov    %ebx,%eax
  803c72:	f7 f7                	div    %edi
  803c74:	31 ff                	xor    %edi,%edi
  803c76:	89 fa                	mov    %edi,%edx
  803c78:	83 c4 1c             	add    $0x1c,%esp
  803c7b:	5b                   	pop    %ebx
  803c7c:	5e                   	pop    %esi
  803c7d:	5f                   	pop    %edi
  803c7e:	5d                   	pop    %ebp
  803c7f:	c3                   	ret    
  803c80:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c85:	89 eb                	mov    %ebp,%ebx
  803c87:	29 fb                	sub    %edi,%ebx
  803c89:	89 f9                	mov    %edi,%ecx
  803c8b:	d3 e6                	shl    %cl,%esi
  803c8d:	89 c5                	mov    %eax,%ebp
  803c8f:	88 d9                	mov    %bl,%cl
  803c91:	d3 ed                	shr    %cl,%ebp
  803c93:	89 e9                	mov    %ebp,%ecx
  803c95:	09 f1                	or     %esi,%ecx
  803c97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c9b:	89 f9                	mov    %edi,%ecx
  803c9d:	d3 e0                	shl    %cl,%eax
  803c9f:	89 c5                	mov    %eax,%ebp
  803ca1:	89 d6                	mov    %edx,%esi
  803ca3:	88 d9                	mov    %bl,%cl
  803ca5:	d3 ee                	shr    %cl,%esi
  803ca7:	89 f9                	mov    %edi,%ecx
  803ca9:	d3 e2                	shl    %cl,%edx
  803cab:	8b 44 24 08          	mov    0x8(%esp),%eax
  803caf:	88 d9                	mov    %bl,%cl
  803cb1:	d3 e8                	shr    %cl,%eax
  803cb3:	09 c2                	or     %eax,%edx
  803cb5:	89 d0                	mov    %edx,%eax
  803cb7:	89 f2                	mov    %esi,%edx
  803cb9:	f7 74 24 0c          	divl   0xc(%esp)
  803cbd:	89 d6                	mov    %edx,%esi
  803cbf:	89 c3                	mov    %eax,%ebx
  803cc1:	f7 e5                	mul    %ebp
  803cc3:	39 d6                	cmp    %edx,%esi
  803cc5:	72 19                	jb     803ce0 <__udivdi3+0xfc>
  803cc7:	74 0b                	je     803cd4 <__udivdi3+0xf0>
  803cc9:	89 d8                	mov    %ebx,%eax
  803ccb:	31 ff                	xor    %edi,%edi
  803ccd:	e9 58 ff ff ff       	jmp    803c2a <__udivdi3+0x46>
  803cd2:	66 90                	xchg   %ax,%ax
  803cd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cd8:	89 f9                	mov    %edi,%ecx
  803cda:	d3 e2                	shl    %cl,%edx
  803cdc:	39 c2                	cmp    %eax,%edx
  803cde:	73 e9                	jae    803cc9 <__udivdi3+0xe5>
  803ce0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ce3:	31 ff                	xor    %edi,%edi
  803ce5:	e9 40 ff ff ff       	jmp    803c2a <__udivdi3+0x46>
  803cea:	66 90                	xchg   %ax,%ax
  803cec:	31 c0                	xor    %eax,%eax
  803cee:	e9 37 ff ff ff       	jmp    803c2a <__udivdi3+0x46>
  803cf3:	90                   	nop

00803cf4 <__umoddi3>:
  803cf4:	55                   	push   %ebp
  803cf5:	57                   	push   %edi
  803cf6:	56                   	push   %esi
  803cf7:	53                   	push   %ebx
  803cf8:	83 ec 1c             	sub    $0x1c,%esp
  803cfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d13:	89 f3                	mov    %esi,%ebx
  803d15:	89 fa                	mov    %edi,%edx
  803d17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d1b:	89 34 24             	mov    %esi,(%esp)
  803d1e:	85 c0                	test   %eax,%eax
  803d20:	75 1a                	jne    803d3c <__umoddi3+0x48>
  803d22:	39 f7                	cmp    %esi,%edi
  803d24:	0f 86 a2 00 00 00    	jbe    803dcc <__umoddi3+0xd8>
  803d2a:	89 c8                	mov    %ecx,%eax
  803d2c:	89 f2                	mov    %esi,%edx
  803d2e:	f7 f7                	div    %edi
  803d30:	89 d0                	mov    %edx,%eax
  803d32:	31 d2                	xor    %edx,%edx
  803d34:	83 c4 1c             	add    $0x1c,%esp
  803d37:	5b                   	pop    %ebx
  803d38:	5e                   	pop    %esi
  803d39:	5f                   	pop    %edi
  803d3a:	5d                   	pop    %ebp
  803d3b:	c3                   	ret    
  803d3c:	39 f0                	cmp    %esi,%eax
  803d3e:	0f 87 ac 00 00 00    	ja     803df0 <__umoddi3+0xfc>
  803d44:	0f bd e8             	bsr    %eax,%ebp
  803d47:	83 f5 1f             	xor    $0x1f,%ebp
  803d4a:	0f 84 ac 00 00 00    	je     803dfc <__umoddi3+0x108>
  803d50:	bf 20 00 00 00       	mov    $0x20,%edi
  803d55:	29 ef                	sub    %ebp,%edi
  803d57:	89 fe                	mov    %edi,%esi
  803d59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d5d:	89 e9                	mov    %ebp,%ecx
  803d5f:	d3 e0                	shl    %cl,%eax
  803d61:	89 d7                	mov    %edx,%edi
  803d63:	89 f1                	mov    %esi,%ecx
  803d65:	d3 ef                	shr    %cl,%edi
  803d67:	09 c7                	or     %eax,%edi
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 e2                	shl    %cl,%edx
  803d6d:	89 14 24             	mov    %edx,(%esp)
  803d70:	89 d8                	mov    %ebx,%eax
  803d72:	d3 e0                	shl    %cl,%eax
  803d74:	89 c2                	mov    %eax,%edx
  803d76:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d7a:	d3 e0                	shl    %cl,%eax
  803d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d80:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d84:	89 f1                	mov    %esi,%ecx
  803d86:	d3 e8                	shr    %cl,%eax
  803d88:	09 d0                	or     %edx,%eax
  803d8a:	d3 eb                	shr    %cl,%ebx
  803d8c:	89 da                	mov    %ebx,%edx
  803d8e:	f7 f7                	div    %edi
  803d90:	89 d3                	mov    %edx,%ebx
  803d92:	f7 24 24             	mull   (%esp)
  803d95:	89 c6                	mov    %eax,%esi
  803d97:	89 d1                	mov    %edx,%ecx
  803d99:	39 d3                	cmp    %edx,%ebx
  803d9b:	0f 82 87 00 00 00    	jb     803e28 <__umoddi3+0x134>
  803da1:	0f 84 91 00 00 00    	je     803e38 <__umoddi3+0x144>
  803da7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dab:	29 f2                	sub    %esi,%edx
  803dad:	19 cb                	sbb    %ecx,%ebx
  803daf:	89 d8                	mov    %ebx,%eax
  803db1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803db5:	d3 e0                	shl    %cl,%eax
  803db7:	89 e9                	mov    %ebp,%ecx
  803db9:	d3 ea                	shr    %cl,%edx
  803dbb:	09 d0                	or     %edx,%eax
  803dbd:	89 e9                	mov    %ebp,%ecx
  803dbf:	d3 eb                	shr    %cl,%ebx
  803dc1:	89 da                	mov    %ebx,%edx
  803dc3:	83 c4 1c             	add    $0x1c,%esp
  803dc6:	5b                   	pop    %ebx
  803dc7:	5e                   	pop    %esi
  803dc8:	5f                   	pop    %edi
  803dc9:	5d                   	pop    %ebp
  803dca:	c3                   	ret    
  803dcb:	90                   	nop
  803dcc:	89 fd                	mov    %edi,%ebp
  803dce:	85 ff                	test   %edi,%edi
  803dd0:	75 0b                	jne    803ddd <__umoddi3+0xe9>
  803dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803dd7:	31 d2                	xor    %edx,%edx
  803dd9:	f7 f7                	div    %edi
  803ddb:	89 c5                	mov    %eax,%ebp
  803ddd:	89 f0                	mov    %esi,%eax
  803ddf:	31 d2                	xor    %edx,%edx
  803de1:	f7 f5                	div    %ebp
  803de3:	89 c8                	mov    %ecx,%eax
  803de5:	f7 f5                	div    %ebp
  803de7:	89 d0                	mov    %edx,%eax
  803de9:	e9 44 ff ff ff       	jmp    803d32 <__umoddi3+0x3e>
  803dee:	66 90                	xchg   %ax,%ax
  803df0:	89 c8                	mov    %ecx,%eax
  803df2:	89 f2                	mov    %esi,%edx
  803df4:	83 c4 1c             	add    $0x1c,%esp
  803df7:	5b                   	pop    %ebx
  803df8:	5e                   	pop    %esi
  803df9:	5f                   	pop    %edi
  803dfa:	5d                   	pop    %ebp
  803dfb:	c3                   	ret    
  803dfc:	3b 04 24             	cmp    (%esp),%eax
  803dff:	72 06                	jb     803e07 <__umoddi3+0x113>
  803e01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e05:	77 0f                	ja     803e16 <__umoddi3+0x122>
  803e07:	89 f2                	mov    %esi,%edx
  803e09:	29 f9                	sub    %edi,%ecx
  803e0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e0f:	89 14 24             	mov    %edx,(%esp)
  803e12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e1a:	8b 14 24             	mov    (%esp),%edx
  803e1d:	83 c4 1c             	add    $0x1c,%esp
  803e20:	5b                   	pop    %ebx
  803e21:	5e                   	pop    %esi
  803e22:	5f                   	pop    %edi
  803e23:	5d                   	pop    %ebp
  803e24:	c3                   	ret    
  803e25:	8d 76 00             	lea    0x0(%esi),%esi
  803e28:	2b 04 24             	sub    (%esp),%eax
  803e2b:	19 fa                	sbb    %edi,%edx
  803e2d:	89 d1                	mov    %edx,%ecx
  803e2f:	89 c6                	mov    %eax,%esi
  803e31:	e9 71 ff ff ff       	jmp    803da7 <__umoddi3+0xb3>
  803e36:	66 90                	xchg   %ax,%ax
  803e38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e3c:	72 ea                	jb     803e28 <__umoddi3+0x134>
  803e3e:	89 d9                	mov    %ebx,%ecx
  803e40:	e9 62 ff ff ff       	jmp    803da7 <__umoddi3+0xb3>
