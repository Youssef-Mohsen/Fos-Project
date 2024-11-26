
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
  80003e:	e8 2e 19 00 00       	call   801971 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 c0 3c 80 00       	push   $0x803cc0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 bf 14 00 00       	call   801515 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c2 3c 80 00       	push   $0x803cc2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 a9 14 00 00       	call   801515 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c9 3c 80 00       	push   $0x803cc9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 93 14 00 00       	call   801515 <sget>
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
  800098:	68 d7 3c 80 00       	push   $0x803cd7
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 a5 36 00 00       	call   80374b <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 b1 36 00 00       	call   803765 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 e1 18 00 00       	call   8019a4 <sys_get_virtual_time>
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
  8000e6:	e8 b9 36 00 00       	call   8037a4 <env_sleep>
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
  8000fe:	e8 a1 18 00 00       	call   8019a4 <sys_get_virtual_time>
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
  800126:	e8 79 36 00 00       	call   8037a4 <env_sleep>
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
  80013d:	e8 62 18 00 00       	call   8019a4 <sys_get_virtual_time>
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
  800165:	e8 3a 36 00 00       	call   8037a4 <env_sleep>
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
  800183:	e8 d0 17 00 00       	call   801958 <sys_getenvindex>
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
  8001f1:	e8 e6 14 00 00       	call   8016dc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 f4 3c 80 00       	push   $0x803cf4
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
  800221:	68 1c 3d 80 00       	push   $0x803d1c
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
  800252:	68 44 3d 80 00       	push   $0x803d44
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 9c 3d 80 00       	push   $0x803d9c
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 f4 3c 80 00       	push   $0x803cf4
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 66 14 00 00       	call   8016f6 <sys_unlock_cons>
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
  8002a3:	e8 7c 16 00 00       	call   801924 <sys_destroy_env>
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
  8002b4:	e8 d1 16 00 00       	call   80198a <sys_exit_env>
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
  800302:	e8 93 13 00 00       	call   80169a <sys_cputs>
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
  800379:	e8 1c 13 00 00       	call   80169a <sys_cputs>
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
  8003c3:	e8 14 13 00 00       	call   8016dc <sys_lock_cons>
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
  8003e3:	e8 0e 13 00 00       	call   8016f6 <sys_unlock_cons>
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
  80042d:	e8 12 36 00 00       	call   803a44 <__udivdi3>
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
  80047d:	e8 d2 36 00 00       	call   803b54 <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  8005d8:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  8006b9:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 e5 3f 80 00       	push   $0x803fe5
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
  8006de:	68 ee 3f 80 00       	push   $0x803fee
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
  80070b:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  801116:	68 68 41 80 00       	push   $0x804168
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 8a 41 80 00       	push   $0x80418a
  801125:	e8 2e 27 00 00       	call   803858 <_panic>

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
  801136:	e8 0a 0b 00 00       	call   801c45 <sys_sbrk>
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
  8011b1:	e8 13 09 00 00       	call   801ac9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 53 0e 00 00       	call   802018 <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 25 09 00 00       	call   801afa <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 ec 12 00 00       	call   8024d4 <alloc_block_BF>
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
  801233:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801280:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801339:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	ff 75 f0             	pushl  -0x10(%ebp)
  801349:	e8 2e 09 00 00       	call   801c7c <sys_allocate_user_mem>
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
  801391:	e8 02 09 00 00       	call   801c98 <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 35 1b 00 00       	call   802edc <free_block>
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
  8013dc:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801419:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801439:	e8 22 08 00 00       	call   801c60 <sys_free_user_mem>
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
  801447:	68 98 41 80 00       	push   $0x804198
  80144c:	68 85 00 00 00       	push   $0x85
  801451:	68 c2 41 80 00       	push   $0x8041c2
  801456:	e8 fd 23 00 00       	call   803858 <_panic>
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
  80146d:	75 0a                	jne    801479 <smalloc+0x1c>
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
  801474:	e9 9a 00 00 00       	jmp    801513 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801486:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	39 d0                	cmp    %edx,%eax
  80148e:	73 02                	jae    801492 <smalloc+0x35>
  801490:	89 d0                	mov    %edx,%eax
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	50                   	push   %eax
  801496:	e8 a5 fc ff ff       	call   801140 <malloc>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8014a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a5:	75 07                	jne    8014ae <smalloc+0x51>
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb 65                	jmp    801513 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014ae:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b5:	50                   	push   %eax
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 a6 03 00 00       	call   801867 <sys_createSharedObject>
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c7:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014cb:	74 06                	je     8014d3 <smalloc+0x76>
  8014cd:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d1:	75 07                	jne    8014da <smalloc+0x7d>
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d8:	eb 39                	jmp    801513 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e0:	68 ce 41 80 00       	push   $0x8041ce
  8014e5:	e8 a6 ee ff ff       	call   800390 <cprintf>
  8014ea:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8014ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8014f5:	8b 40 78             	mov    0x78(%eax),%eax
  8014f8:	29 c2                	sub    %eax,%edx
  8014fa:	89 d0                	mov    %edx,%eax
  8014fc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801501:	c1 e8 0c             	shr    $0xc,%eax
  801504:	89 c2                	mov    %eax,%edx
  801506:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801509:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801510:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	e8 68 03 00 00       	call   801891 <sys_getSizeOfSharedObject>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80152f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801533:	75 07                	jne    80153c <sget+0x27>
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 7f                	jmp    8015bb <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801542:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801549:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	39 d0                	cmp    %edx,%eax
  801551:	7d 02                	jge    801555 <sget+0x40>
  801553:	89 d0                	mov    %edx,%eax
  801555:	83 ec 0c             	sub    $0xc,%esp
  801558:	50                   	push   %eax
  801559:	e8 e2 fb ff ff       	call   801140 <malloc>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801564:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801568:	75 07                	jne    801571 <sget+0x5c>
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
  80156f:	eb 4a                	jmp    8015bb <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	ff 75 e8             	pushl  -0x18(%ebp)
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 2c 03 00 00       	call   8018ae <sys_getSharedObject>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801588:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80158b:	a1 20 50 80 00       	mov    0x805020,%eax
  801590:	8b 40 78             	mov    0x78(%eax),%eax
  801593:	29 c2                	sub    %eax,%edx
  801595:	89 d0                	mov    %edx,%eax
  801597:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159c:	c1 e8 0c             	shr    $0xc,%eax
  80159f:	89 c2                	mov    %eax,%edx
  8015a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8015ab:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8015af:	75 07                	jne    8015b8 <sget+0xa3>
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b6:	eb 03                	jmp    8015bb <sget+0xa6>
	return ptr;
  8015b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8015cb:	8b 40 78             	mov    0x78(%eax),%eax
  8015ce:	29 c2                	sub    %eax,%edx
  8015d0:	89 d0                	mov    %edx,%eax
  8015d2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d7:	c1 e8 0c             	shr    $0xc,%eax
  8015da:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015e4:	83 ec 08             	sub    $0x8,%esp
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ed:	e8 db 02 00 00       	call   8018cd <sys_freeSharedObject>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015f8:	90                   	nop
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 e0 41 80 00       	push   $0x8041e0
  801609:	68 de 00 00 00       	push   $0xde
  80160e:	68 c2 41 80 00       	push   $0x8041c2
  801613:	e8 40 22 00 00       	call   803858 <_panic>

00801618 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 06 42 80 00       	push   $0x804206
  801626:	68 ea 00 00 00       	push   $0xea
  80162b:	68 c2 41 80 00       	push   $0x8041c2
  801630:	e8 23 22 00 00       	call   803858 <_panic>

00801635 <shrink>:

}
void shrink(uint32 newSize)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	68 06 42 80 00       	push   $0x804206
  801643:	68 ef 00 00 00       	push   $0xef
  801648:	68 c2 41 80 00       	push   $0x8041c2
  80164d:	e8 06 22 00 00       	call   803858 <_panic>

00801652 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 06 42 80 00       	push   $0x804206
  801660:	68 f4 00 00 00       	push   $0xf4
  801665:	68 c2 41 80 00       	push   $0x8041c2
  80166a:	e8 e9 21 00 00       	call   803858 <_panic>

0080166f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801681:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801684:	8b 7d 18             	mov    0x18(%ebp),%edi
  801687:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80168a:	cd 30                	int    $0x30
  80168c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	50                   	push   %eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	e8 b2 ff ff ff       	call   80166f <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 02                	push   $0x2
  8016d2:	e8 98 ff ff ff       	call   80166f <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 03                	push   $0x3
  8016eb:	e8 7f ff ff ff       	call   80166f <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	90                   	nop
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 04                	push   $0x4
  801705:	e8 65 ff ff ff       	call   80166f <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	90                   	nop
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	6a 08                	push   $0x8
  801723:	e8 47 ff ff ff       	call   80166f <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801732:	8b 75 18             	mov    0x18(%ebp),%esi
  801735:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801738:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	56                   	push   %esi
  801742:	53                   	push   %ebx
  801743:	51                   	push   %ecx
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	6a 09                	push   $0x9
  801748:	e8 22 ff ff ff       	call   80166f <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	52                   	push   %edx
  801767:	50                   	push   %eax
  801768:	6a 0a                	push   $0xa
  80176a:	e8 00 ff ff ff       	call   80166f <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	6a 0b                	push   $0xb
  801785:	e8 e5 fe ff ff       	call   80166f <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 0c                	push   $0xc
  80179e:	e8 cc fe ff ff       	call   80166f <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 0d                	push   $0xd
  8017b7:	e8 b3 fe ff ff       	call   80166f <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 0e                	push   $0xe
  8017d0:	e8 9a fe ff ff       	call   80166f <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 0f                	push   $0xf
  8017e9:	e8 81 fe ff ff       	call   80166f <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 08             	pushl  0x8(%ebp)
  801801:	6a 10                	push   $0x10
  801803:	e8 67 fe ff ff       	call   80166f <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 11                	push   $0x11
  80181c:	e8 4e fe ff ff       	call   80166f <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	90                   	nop
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_cputc>:

void
sys_cputc(const char c)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801833:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	50                   	push   %eax
  801840:	6a 01                	push   $0x1
  801842:	e8 28 fe ff ff       	call   80166f <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 14                	push   $0x14
  80185c:	e8 0e fe ff ff       	call   80166f <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	8b 45 10             	mov    0x10(%ebp),%eax
  801870:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801873:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801876:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	51                   	push   %ecx
  801880:	52                   	push   %edx
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	6a 15                	push   $0x15
  801887:	e8 e3 fd ff ff       	call   80166f <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 16                	push   $0x16
  8018a4:	e8 c6 fd ff ff       	call   80166f <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	51                   	push   %ecx
  8018bf:	52                   	push   %edx
  8018c0:	50                   	push   %eax
  8018c1:	6a 17                	push   $0x17
  8018c3:	e8 a7 fd ff ff       	call   80166f <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 18                	push   $0x18
  8018e0:	e8 8a fd ff ff       	call   80166f <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 14             	pushl  0x14(%ebp)
  8018f5:	ff 75 10             	pushl  0x10(%ebp)
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	50                   	push   %eax
  8018fc:	6a 19                	push   $0x19
  8018fe:	e8 6c fd ff ff       	call   80166f <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	50                   	push   %eax
  801917:	6a 1a                	push   $0x1a
  801919:	e8 51 fd ff ff       	call   80166f <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	50                   	push   %eax
  801933:	6a 1b                	push   $0x1b
  801935:	e8 35 fd ff ff       	call   80166f <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 05                	push   $0x5
  80194e:	e8 1c fd ff ff       	call   80166f <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 06                	push   $0x6
  801967:	e8 03 fd ff ff       	call   80166f <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 07                	push   $0x7
  801980:	e8 ea fc ff ff       	call   80166f <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_exit_env>:


void sys_exit_env(void)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 1c                	push   $0x1c
  801999:	e8 d1 fc ff ff       	call   80166f <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ad:	8d 50 04             	lea    0x4(%eax),%edx
  8019b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	52                   	push   %edx
  8019ba:	50                   	push   %eax
  8019bb:	6a 1d                	push   $0x1d
  8019bd:	e8 ad fc ff ff       	call   80166f <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8019c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ce:	89 01                	mov    %eax,(%ecx)
  8019d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	c9                   	leave  
  8019d7:	c2 04 00             	ret    $0x4

008019da <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	ff 75 10             	pushl  0x10(%ebp)
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 13                	push   $0x13
  8019ec:	e8 7e fc ff ff       	call   80166f <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 1e                	push   $0x1e
  801a06:	e8 64 fc ff ff       	call   80166f <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a1c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	50                   	push   %eax
  801a29:	6a 1f                	push   $0x1f
  801a2b:	e8 3f fc ff ff       	call   80166f <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return ;
  801a33:	90                   	nop
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <rsttst>:
void rsttst()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 21                	push   $0x21
  801a45:	e8 25 fc ff ff       	call   80166f <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4d:	90                   	nop
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a5c:	8b 55 18             	mov    0x18(%ebp),%edx
  801a5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 20                	push   $0x20
  801a70:	e8 fa fb ff ff       	call   80166f <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
	return ;
  801a78:	90                   	nop
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <chktst>:
void chktst(uint32 n)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	6a 22                	push   $0x22
  801a8b:	e8 df fb ff ff       	call   80166f <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return ;
  801a93:	90                   	nop
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <inctst>:

void inctst()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 23                	push   $0x23
  801aa5:	e8 c5 fb ff ff       	call   80166f <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
	return ;
  801aad:	90                   	nop
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <gettst>:
uint32 gettst()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 24                	push   $0x24
  801abf:	e8 ab fb ff ff       	call   80166f <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 25                	push   $0x25
  801adb:	e8 8f fb ff ff       	call   80166f <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
  801ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ae6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aea:	75 07                	jne    801af3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
  801af1:	eb 05                	jmp    801af8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 25                	push   $0x25
  801b0c:	e8 5e fb ff ff       	call   80166f <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
  801b14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b17:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b1b:	75 07                	jne    801b24 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b22:	eb 05                	jmp    801b29 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 25                	push   $0x25
  801b3d:	e8 2d fb ff ff       	call   80166f <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
  801b45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b48:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b4c:	75 07                	jne    801b55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	eb 05                	jmp    801b5a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 25                	push   $0x25
  801b6e:	e8 fc fa ff ff       	call   80166f <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
  801b76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b79:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b7d:	75 07                	jne    801b86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b84:	eb 05                	jmp    801b8b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 26                	push   $0x26
  801b9d:	e8 cd fa ff ff       	call   80166f <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801baf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	53                   	push   %ebx
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 27                	push   $0x27
  801bc0:	e8 aa fa ff ff       	call   80166f <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 28                	push   $0x28
  801be0:	e8 8a fa ff ff       	call   80166f <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	51                   	push   %ecx
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	52                   	push   %edx
  801bfd:	50                   	push   %eax
  801bfe:	6a 29                	push   $0x29
  801c00:	e8 6a fa ff ff       	call   80166f <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 10             	pushl  0x10(%ebp)
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 12                	push   $0x12
  801c1c:	e8 4e fa ff ff       	call   80166f <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	52                   	push   %edx
  801c37:	50                   	push   %eax
  801c38:	6a 2a                	push   $0x2a
  801c3a:	e8 30 fa ff ff       	call   80166f <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	50                   	push   %eax
  801c54:	6a 2b                	push   $0x2b
  801c56:	e8 14 fa ff ff       	call   80166f <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	ff 75 08             	pushl  0x8(%ebp)
  801c6f:	6a 2c                	push   $0x2c
  801c71:	e8 f9 f9 ff ff       	call   80166f <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
	return;
  801c79:	90                   	nop
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 2d                	push   $0x2d
  801c8d:	e8 dd f9 ff ff       	call   80166f <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	83 e8 04             	sub    $0x4,%eax
  801ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	83 e8 04             	sub    $0x4,%eax
  801cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc3:	8b 00                	mov    (%eax),%eax
  801cc5:	83 e0 01             	and    $0x1,%eax
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	0f 94 c0             	sete   %al
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdf:	83 f8 02             	cmp    $0x2,%eax
  801ce2:	74 2b                	je     801d0f <alloc_block+0x40>
  801ce4:	83 f8 02             	cmp    $0x2,%eax
  801ce7:	7f 07                	jg     801cf0 <alloc_block+0x21>
  801ce9:	83 f8 01             	cmp    $0x1,%eax
  801cec:	74 0e                	je     801cfc <alloc_block+0x2d>
  801cee:	eb 58                	jmp    801d48 <alloc_block+0x79>
  801cf0:	83 f8 03             	cmp    $0x3,%eax
  801cf3:	74 2d                	je     801d22 <alloc_block+0x53>
  801cf5:	83 f8 04             	cmp    $0x4,%eax
  801cf8:	74 3b                	je     801d35 <alloc_block+0x66>
  801cfa:	eb 4c                	jmp    801d48 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	e8 11 03 00 00       	call   802018 <alloc_block_FF>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d0d:	eb 4a                	jmp    801d59 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 fa 19 00 00       	call   803714 <alloc_block_NF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d20:	eb 37                	jmp    801d59 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	e8 a7 07 00 00       	call   8024d4 <alloc_block_BF>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d33:	eb 24                	jmp    801d59 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	ff 75 08             	pushl  0x8(%ebp)
  801d3b:	e8 b7 19 00 00       	call   8036f7 <alloc_block_WF>
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d46:	eb 11                	jmp    801d59 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	68 18 42 80 00       	push   $0x804218
  801d50:	e8 3b e6 ff ff       	call   800390 <cprintf>
  801d55:	83 c4 10             	add    $0x10,%esp
		break;
  801d58:	90                   	nop
	}
	return va;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	53                   	push   %ebx
  801d62:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	68 38 42 80 00       	push   $0x804238
  801d6d:	e8 1e e6 ff ff       	call   800390 <cprintf>
  801d72:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	68 63 42 80 00       	push   $0x804263
  801d7d:	e8 0e e6 ff ff       	call   800390 <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8b:	eb 37                	jmp    801dc4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	ff 75 f4             	pushl  -0xc(%ebp)
  801d93:	e8 19 ff ff ff       	call   801cb1 <is_free_block>
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	0f be d8             	movsbl %al,%ebx
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	ff 75 f4             	pushl  -0xc(%ebp)
  801da4:	e8 ef fe ff ff       	call   801c98 <get_block_size>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	53                   	push   %ebx
  801db0:	50                   	push   %eax
  801db1:	68 7b 42 80 00       	push   $0x80427b
  801db6:	e8 d5 e5 ff ff       	call   800390 <cprintf>
  801dbb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc8:	74 07                	je     801dd1 <print_blocks_list+0x73>
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	8b 00                	mov    (%eax),%eax
  801dcf:	eb 05                	jmp    801dd6 <print_blocks_list+0x78>
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	89 45 10             	mov    %eax,0x10(%ebp)
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	75 ad                	jne    801d8d <print_blocks_list+0x2f>
  801de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de4:	75 a7                	jne    801d8d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	68 38 42 80 00       	push   $0x804238
  801dee:	e8 9d e5 ff ff       	call   800390 <cprintf>
  801df3:	83 c4 10             	add    $0x10,%esp

}
  801df6:	90                   	nop
  801df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	83 e0 01             	and    $0x1,%eax
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	74 03                	je     801e0f <initialize_dynamic_allocator+0x13>
  801e0c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e13:	0f 84 c7 01 00 00    	je     801fe0 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e19:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e20:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e23:	8b 55 08             	mov    0x8(%ebp),%edx
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e30:	0f 87 ad 01 00 00    	ja     801fe3 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	0f 89 a5 01 00 00    	jns    801fe6 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e41:	8b 55 08             	mov    0x8(%ebp),%edx
  801e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	83 e8 04             	sub    $0x4,%eax
  801e4c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e58:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e60:	e9 87 00 00 00       	jmp    801eec <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e69:	75 14                	jne    801e7f <initialize_dynamic_allocator+0x83>
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	68 93 42 80 00       	push   $0x804293
  801e73:	6a 79                	push   $0x79
  801e75:	68 b1 42 80 00       	push   $0x8042b1
  801e7a:	e8 d9 19 00 00       	call   803858 <_panic>
  801e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	85 c0                	test   %eax,%eax
  801e86:	74 10                	je     801e98 <initialize_dynamic_allocator+0x9c>
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e90:	8b 52 04             	mov    0x4(%edx),%edx
  801e93:	89 50 04             	mov    %edx,0x4(%eax)
  801e96:	eb 0b                	jmp    801ea3 <initialize_dynamic_allocator+0xa7>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 40 04             	mov    0x4(%eax),%eax
  801e9e:	a3 30 50 80 00       	mov    %eax,0x805030
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	8b 40 04             	mov    0x4(%eax),%eax
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	74 0f                	je     801ebc <initialize_dynamic_allocator+0xc0>
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 40 04             	mov    0x4(%eax),%eax
  801eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb6:	8b 12                	mov    (%edx),%edx
  801eb8:	89 10                	mov    %edx,(%eax)
  801eba:	eb 0a                	jmp    801ec6 <initialize_dynamic_allocator+0xca>
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	8b 00                	mov    (%eax),%eax
  801ec1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ed9:	a1 38 50 80 00       	mov    0x805038,%eax
  801ede:	48                   	dec    %eax
  801edf:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ee4:	a1 34 50 80 00       	mov    0x805034,%eax
  801ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef0:	74 07                	je     801ef9 <initialize_dynamic_allocator+0xfd>
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	eb 05                	jmp    801efe <initialize_dynamic_allocator+0x102>
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	a3 34 50 80 00       	mov    %eax,0x805034
  801f03:	a1 34 50 80 00       	mov    0x805034,%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	0f 85 55 ff ff ff    	jne    801e65 <initialize_dynamic_allocator+0x69>
  801f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f14:	0f 85 4b ff ff ff    	jne    801e65 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f23:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f29:	a1 44 50 80 00       	mov    0x805044,%eax
  801f2e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f33:	a1 40 50 80 00       	mov    0x805040,%eax
  801f38:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	83 c0 08             	add    $0x8,%eax
  801f44:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	83 c0 04             	add    $0x4,%eax
  801f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f50:	83 ea 08             	sub    $0x8,%edx
  801f53:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	83 e8 08             	sub    $0x8,%eax
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	83 ea 08             	sub    $0x8,%edx
  801f66:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f7f:	75 17                	jne    801f98 <initialize_dynamic_allocator+0x19c>
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	68 cc 42 80 00       	push   $0x8042cc
  801f89:	68 90 00 00 00       	push   $0x90
  801f8e:	68 b1 42 80 00       	push   $0x8042b1
  801f93:	e8 c0 18 00 00       	call   803858 <_panic>
  801f98:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa1:	89 10                	mov    %edx,(%eax)
  801fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	74 0d                	je     801fb9 <initialize_dynamic_allocator+0x1bd>
  801fac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb4:	89 50 04             	mov    %edx,0x4(%eax)
  801fb7:	eb 08                	jmp    801fc1 <initialize_dynamic_allocator+0x1c5>
  801fb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbc:	a3 30 50 80 00       	mov    %eax,0x805030
  801fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd3:	a1 38 50 80 00       	mov    0x805038,%eax
  801fd8:	40                   	inc    %eax
  801fd9:	a3 38 50 80 00       	mov    %eax,0x805038
  801fde:	eb 07                	jmp    801fe7 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fe0:	90                   	nop
  801fe1:	eb 04                	jmp    801fe7 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fe3:	90                   	nop
  801fe4:	eb 01                	jmp    801fe7 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fe6:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fec:	8b 45 10             	mov    0x10(%ebp),%eax
  801fef:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8d 50 fc             	lea    -0x4(%eax),%edx
  801ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffb:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	83 e8 04             	sub    $0x4,%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	83 e0 fe             	and    $0xfffffffe,%eax
  802008:	8d 50 f8             	lea    -0x8(%eax),%edx
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	01 c2                	add    %eax,%edx
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	89 02                	mov    %eax,(%edx)
}
  802015:	90                   	nop
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    

00802018 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	83 e0 01             	and    $0x1,%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	74 03                	je     80202b <alloc_block_FF+0x13>
  802028:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80202b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80202f:	77 07                	ja     802038 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802031:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802038:	a1 24 50 80 00       	mov    0x805024,%eax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	75 73                	jne    8020b4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	83 c0 10             	add    $0x10,%eax
  802047:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80204a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802057:	01 d0                	add    %edx,%eax
  802059:	48                   	dec    %eax
  80205a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80205d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802060:	ba 00 00 00 00       	mov    $0x0,%edx
  802065:	f7 75 ec             	divl   -0x14(%ebp)
  802068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206b:	29 d0                	sub    %edx,%eax
  80206d:	c1 e8 0c             	shr    $0xc,%eax
  802070:	83 ec 0c             	sub    $0xc,%esp
  802073:	50                   	push   %eax
  802074:	e8 b1 f0 ff ff       	call   80112a <sbrk>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80207f:	83 ec 0c             	sub    $0xc,%esp
  802082:	6a 00                	push   $0x0
  802084:	e8 a1 f0 ff ff       	call   80112a <sbrk>
  802089:	83 c4 10             	add    $0x10,%esp
  80208c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80208f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	50                   	push   %eax
  802099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80209c:	e8 5b fd ff ff       	call   801dfc <initialize_dynamic_allocator>
  8020a1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	68 ef 42 80 00       	push   $0x8042ef
  8020ac:	e8 df e2 ff ff       	call   800390 <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b8:	75 0a                	jne    8020c4 <alloc_block_FF+0xac>
	        return NULL;
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	e9 0e 04 00 00       	jmp    8024d2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d3:	e9 f3 02 00 00       	jmp    8023cb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	ff 75 bc             	pushl  -0x44(%ebp)
  8020e4:	e8 af fb ff ff       	call   801c98 <get_block_size>
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	83 c0 08             	add    $0x8,%eax
  8020f5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020f8:	0f 87 c5 02 00 00    	ja     8023c3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	83 c0 18             	add    $0x18,%eax
  802104:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802107:	0f 87 19 02 00 00    	ja     802326 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80210d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802110:	2b 45 08             	sub    0x8(%ebp),%eax
  802113:	83 e8 08             	sub    $0x8,%eax
  802116:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8d 50 08             	lea    0x8(%eax),%edx
  80211f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802122:	01 d0                	add    %edx,%eax
  802124:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	83 c0 08             	add    $0x8,%eax
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	6a 01                	push   $0x1
  802132:	50                   	push   %eax
  802133:	ff 75 bc             	pushl  -0x44(%ebp)
  802136:	e8 ae fe ff ff       	call   801fe9 <set_block_data>
  80213b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 40 04             	mov    0x4(%eax),%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	75 68                	jne    8021b0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802148:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80214c:	75 17                	jne    802165 <alloc_block_FF+0x14d>
  80214e:	83 ec 04             	sub    $0x4,%esp
  802151:	68 cc 42 80 00       	push   $0x8042cc
  802156:	68 d7 00 00 00       	push   $0xd7
  80215b:	68 b1 42 80 00       	push   $0x8042b1
  802160:	e8 f3 16 00 00       	call   803858 <_panic>
  802165:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80216b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80216e:	89 10                	mov    %edx,(%eax)
  802170:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	85 c0                	test   %eax,%eax
  802177:	74 0d                	je     802186 <alloc_block_FF+0x16e>
  802179:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80217e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802181:	89 50 04             	mov    %edx,0x4(%eax)
  802184:	eb 08                	jmp    80218e <alloc_block_FF+0x176>
  802186:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802189:	a3 30 50 80 00       	mov    %eax,0x805030
  80218e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802191:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802196:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802199:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a5:	40                   	inc    %eax
  8021a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ab:	e9 dc 00 00 00       	jmp    80228c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8021b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b3:	8b 00                	mov    (%eax),%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	75 65                	jne    80221e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021bd:	75 17                	jne    8021d6 <alloc_block_FF+0x1be>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 00 43 80 00       	push   $0x804300
  8021c7:	68 db 00 00 00       	push   $0xdb
  8021cc:	68 b1 42 80 00       	push   $0x8042b1
  8021d1:	e8 82 16 00 00       	call   803858 <_panic>
  8021d6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e5:	8b 40 04             	mov    0x4(%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 0c                	je     8021f8 <alloc_block_FF+0x1e0>
  8021ec:	a1 30 50 80 00       	mov    0x805030,%eax
  8021f1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f4:	89 10                	mov    %edx,(%eax)
  8021f6:	eb 08                	jmp    802200 <alloc_block_FF+0x1e8>
  8021f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802200:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802203:	a3 30 50 80 00       	mov    %eax,0x805030
  802208:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80220b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802211:	a1 38 50 80 00       	mov    0x805038,%eax
  802216:	40                   	inc    %eax
  802217:	a3 38 50 80 00       	mov    %eax,0x805038
  80221c:	eb 6e                	jmp    80228c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80221e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802222:	74 06                	je     80222a <alloc_block_FF+0x212>
  802224:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802228:	75 17                	jne    802241 <alloc_block_FF+0x229>
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 24 43 80 00       	push   $0x804324
  802232:	68 df 00 00 00       	push   $0xdf
  802237:	68 b1 42 80 00       	push   $0x8042b1
  80223c:	e8 17 16 00 00       	call   803858 <_panic>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 10                	mov    (%eax),%edx
  802246:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	74 0b                	je     80225f <alloc_block_FF+0x247>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802265:	89 10                	mov    %edx,(%eax)
  802267:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	89 50 04             	mov    %edx,0x4(%eax)
  802270:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	75 08                	jne    802281 <alloc_block_FF+0x269>
  802279:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227c:	a3 30 50 80 00       	mov    %eax,0x805030
  802281:	a1 38 50 80 00       	mov    0x805038,%eax
  802286:	40                   	inc    %eax
  802287:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802290:	75 17                	jne    8022a9 <alloc_block_FF+0x291>
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	68 93 42 80 00       	push   $0x804293
  80229a:	68 e1 00 00 00       	push   $0xe1
  80229f:	68 b1 42 80 00       	push   $0x8042b1
  8022a4:	e8 af 15 00 00       	call   803858 <_panic>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 10                	je     8022c2 <alloc_block_FF+0x2aa>
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ba:	8b 52 04             	mov    0x4(%edx),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	eb 0b                	jmp    8022cd <alloc_block_FF+0x2b5>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 0f                	je     8022e6 <alloc_block_FF+0x2ce>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 04             	mov    0x4(%eax),%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	8b 12                	mov    (%edx),%edx
  8022e2:	89 10                	mov    %edx,(%eax)
  8022e4:	eb 0a                	jmp    8022f0 <alloc_block_FF+0x2d8>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802303:	a1 38 50 80 00       	mov    0x805038,%eax
  802308:	48                   	dec    %eax
  802309:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	6a 00                	push   $0x0
  802313:	ff 75 b4             	pushl  -0x4c(%ebp)
  802316:	ff 75 b0             	pushl  -0x50(%ebp)
  802319:	e8 cb fc ff ff       	call   801fe9 <set_block_data>
  80231e:	83 c4 10             	add    $0x10,%esp
  802321:	e9 95 00 00 00       	jmp    8023bb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802326:	83 ec 04             	sub    $0x4,%esp
  802329:	6a 01                	push   $0x1
  80232b:	ff 75 b8             	pushl  -0x48(%ebp)
  80232e:	ff 75 bc             	pushl  -0x44(%ebp)
  802331:	e8 b3 fc ff ff       	call   801fe9 <set_block_data>
  802336:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233d:	75 17                	jne    802356 <alloc_block_FF+0x33e>
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 93 42 80 00       	push   $0x804293
  802347:	68 e8 00 00 00       	push   $0xe8
  80234c:	68 b1 42 80 00       	push   $0x8042b1
  802351:	e8 02 15 00 00       	call   803858 <_panic>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	74 10                	je     80236f <alloc_block_FF+0x357>
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802367:	8b 52 04             	mov    0x4(%edx),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	eb 0b                	jmp    80237a <alloc_block_FF+0x362>
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 40 04             	mov    0x4(%eax),%eax
  802375:	a3 30 50 80 00       	mov    %eax,0x805030
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	74 0f                	je     802393 <alloc_block_FF+0x37b>
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238d:	8b 12                	mov    (%edx),%edx
  80238f:	89 10                	mov    %edx,(%eax)
  802391:	eb 0a                	jmp    80239d <alloc_block_FF+0x385>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b5:	48                   	dec    %eax
  8023b6:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8023bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023be:	e9 0f 01 00 00       	jmp    8024d2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8023c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cf:	74 07                	je     8023d8 <alloc_block_FF+0x3c0>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	eb 05                	jmp    8023dd <alloc_block_FF+0x3c5>
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	a3 34 50 80 00       	mov    %eax,0x805034
  8023e2:	a1 34 50 80 00       	mov    0x805034,%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 85 e9 fc ff ff    	jne    8020d8 <alloc_block_FF+0xc0>
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	0f 85 df fc ff ff    	jne    8020d8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	83 c0 08             	add    $0x8,%eax
  8023ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802402:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802409:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80240c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80240f:	01 d0                	add    %edx,%eax
  802411:	48                   	dec    %eax
  802412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802415:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802418:	ba 00 00 00 00       	mov    $0x0,%edx
  80241d:	f7 75 d8             	divl   -0x28(%ebp)
  802420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802423:	29 d0                	sub    %edx,%eax
  802425:	c1 e8 0c             	shr    $0xc,%eax
  802428:	83 ec 0c             	sub    $0xc,%esp
  80242b:	50                   	push   %eax
  80242c:	e8 f9 ec ff ff       	call   80112a <sbrk>
  802431:	83 c4 10             	add    $0x10,%esp
  802434:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802437:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80243b:	75 0a                	jne    802447 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	e9 8b 00 00 00       	jmp    8024d2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802447:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80244e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802451:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802454:	01 d0                	add    %edx,%eax
  802456:	48                   	dec    %eax
  802457:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80245a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80245d:	ba 00 00 00 00       	mov    $0x0,%edx
  802462:	f7 75 cc             	divl   -0x34(%ebp)
  802465:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802468:	29 d0                	sub    %edx,%eax
  80246a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80246d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802470:	01 d0                	add    %edx,%eax
  802472:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802477:	a1 40 50 80 00       	mov    0x805040,%eax
  80247c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802482:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802489:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80248c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80248f:	01 d0                	add    %edx,%eax
  802491:	48                   	dec    %eax
  802492:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802495:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802498:	ba 00 00 00 00       	mov    $0x0,%edx
  80249d:	f7 75 c4             	divl   -0x3c(%ebp)
  8024a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024a3:	29 d0                	sub    %edx,%eax
  8024a5:	83 ec 04             	sub    $0x4,%esp
  8024a8:	6a 01                	push   $0x1
  8024aa:	50                   	push   %eax
  8024ab:	ff 75 d0             	pushl  -0x30(%ebp)
  8024ae:	e8 36 fb ff ff       	call   801fe9 <set_block_data>
  8024b3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024b6:	83 ec 0c             	sub    $0xc,%esp
  8024b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8024bc:	e8 1b 0a 00 00       	call   802edc <free_block>
  8024c1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024c4:	83 ec 0c             	sub    $0xc,%esp
  8024c7:	ff 75 08             	pushl  0x8(%ebp)
  8024ca:	e8 49 fb ff ff       	call   802018 <alloc_block_FF>
  8024cf:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	83 e0 01             	and    $0x1,%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 03                	je     8024e7 <alloc_block_BF+0x13>
  8024e4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024e7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024eb:	77 07                	ja     8024f4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024ed:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024f4:	a1 24 50 80 00       	mov    0x805024,%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	75 73                	jne    802570 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	83 c0 10             	add    $0x10,%eax
  802503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802506:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80250d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802513:	01 d0                	add    %edx,%eax
  802515:	48                   	dec    %eax
  802516:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802519:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80251c:	ba 00 00 00 00       	mov    $0x0,%edx
  802521:	f7 75 e0             	divl   -0x20(%ebp)
  802524:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802527:	29 d0                	sub    %edx,%eax
  802529:	c1 e8 0c             	shr    $0xc,%eax
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	50                   	push   %eax
  802530:	e8 f5 eb ff ff       	call   80112a <sbrk>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	6a 00                	push   $0x0
  802540:	e8 e5 eb ff ff       	call   80112a <sbrk>
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80254b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802551:	83 ec 08             	sub    $0x8,%esp
  802554:	50                   	push   %eax
  802555:	ff 75 d8             	pushl  -0x28(%ebp)
  802558:	e8 9f f8 ff ff       	call   801dfc <initialize_dynamic_allocator>
  80255d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	68 ef 42 80 00       	push   $0x8042ef
  802568:	e8 23 de ff ff       	call   800390 <cprintf>
  80256d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80257e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802585:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80258c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802591:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802594:	e9 1d 01 00 00       	jmp    8026b6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80259f:	83 ec 0c             	sub    $0xc,%esp
  8025a2:	ff 75 a8             	pushl  -0x58(%ebp)
  8025a5:	e8 ee f6 ff ff       	call   801c98 <get_block_size>
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	83 c0 08             	add    $0x8,%eax
  8025b6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025b9:	0f 87 ef 00 00 00    	ja     8026ae <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	83 c0 18             	add    $0x18,%eax
  8025c5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025c8:	77 1d                	ja     8025e7 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025d0:	0f 86 d8 00 00 00    	jbe    8026ae <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025d6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025e2:	e9 c7 00 00 00       	jmp    8026ae <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	83 c0 08             	add    $0x8,%eax
  8025ed:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025f0:	0f 85 9d 00 00 00    	jne    802693 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	6a 01                	push   $0x1
  8025fb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025fe:	ff 75 a8             	pushl  -0x58(%ebp)
  802601:	e8 e3 f9 ff ff       	call   801fe9 <set_block_data>
  802606:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	75 17                	jne    802626 <alloc_block_BF+0x152>
  80260f:	83 ec 04             	sub    $0x4,%esp
  802612:	68 93 42 80 00       	push   $0x804293
  802617:	68 2c 01 00 00       	push   $0x12c
  80261c:	68 b1 42 80 00       	push   $0x8042b1
  802621:	e8 32 12 00 00       	call   803858 <_panic>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 10                	je     80263f <alloc_block_BF+0x16b>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802637:	8b 52 04             	mov    0x4(%edx),%edx
  80263a:	89 50 04             	mov    %edx,0x4(%eax)
  80263d:	eb 0b                	jmp    80264a <alloc_block_BF+0x176>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	a3 30 50 80 00       	mov    %eax,0x805030
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	74 0f                	je     802663 <alloc_block_BF+0x18f>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265d:	8b 12                	mov    (%edx),%edx
  80265f:	89 10                	mov    %edx,(%eax)
  802661:	eb 0a                	jmp    80266d <alloc_block_BF+0x199>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802680:	a1 38 50 80 00       	mov    0x805038,%eax
  802685:	48                   	dec    %eax
  802686:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80268b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80268e:	e9 24 04 00 00       	jmp    802ab7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802696:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802699:	76 13                	jbe    8026ae <alloc_block_BF+0x1da>
					{
						internal = 1;
  80269b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8026a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8026a8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026ab:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ba:	74 07                	je     8026c3 <alloc_block_BF+0x1ef>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	eb 05                	jmp    8026c8 <alloc_block_BF+0x1f4>
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8026cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	0f 85 bf fe ff ff    	jne    802599 <alloc_block_BF+0xc5>
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	0f 85 b5 fe ff ff    	jne    802599 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e8:	0f 84 26 02 00 00    	je     802914 <alloc_block_BF+0x440>
  8026ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f2:	0f 85 1c 02 00 00    	jne    802914 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fb:	2b 45 08             	sub    0x8(%ebp),%eax
  8026fe:	83 e8 08             	sub    $0x8,%eax
  802701:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	8d 50 08             	lea    0x8(%eax),%edx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	83 c0 08             	add    $0x8,%eax
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	6a 01                	push   $0x1
  80271d:	50                   	push   %eax
  80271e:	ff 75 f0             	pushl  -0x10(%ebp)
  802721:	e8 c3 f8 ff ff       	call   801fe9 <set_block_data>
  802726:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	75 68                	jne    80279b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802733:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802737:	75 17                	jne    802750 <alloc_block_BF+0x27c>
  802739:	83 ec 04             	sub    $0x4,%esp
  80273c:	68 cc 42 80 00       	push   $0x8042cc
  802741:	68 45 01 00 00       	push   $0x145
  802746:	68 b1 42 80 00       	push   $0x8042b1
  80274b:	e8 08 11 00 00       	call   803858 <_panic>
  802750:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802756:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 0d                	je     802771 <alloc_block_BF+0x29d>
  802764:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802769:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	eb 08                	jmp    802779 <alloc_block_BF+0x2a5>
  802771:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802774:	a3 30 50 80 00       	mov    %eax,0x805030
  802779:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802781:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278b:	a1 38 50 80 00       	mov    0x805038,%eax
  802790:	40                   	inc    %eax
  802791:	a3 38 50 80 00       	mov    %eax,0x805038
  802796:	e9 dc 00 00 00       	jmp    802877 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	75 65                	jne    802809 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027a8:	75 17                	jne    8027c1 <alloc_block_BF+0x2ed>
  8027aa:	83 ec 04             	sub    $0x4,%esp
  8027ad:	68 00 43 80 00       	push   $0x804300
  8027b2:	68 4a 01 00 00       	push   $0x14a
  8027b7:	68 b1 42 80 00       	push   $0x8042b1
  8027bc:	e8 97 10 00 00       	call   803858 <_panic>
  8027c1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d0:	8b 40 04             	mov    0x4(%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 0c                	je     8027e3 <alloc_block_BF+0x30f>
  8027d7:	a1 30 50 80 00       	mov    0x805030,%eax
  8027dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027df:	89 10                	mov    %edx,(%eax)
  8027e1:	eb 08                	jmp    8027eb <alloc_block_BF+0x317>
  8027e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fc:	a1 38 50 80 00       	mov    0x805038,%eax
  802801:	40                   	inc    %eax
  802802:	a3 38 50 80 00       	mov    %eax,0x805038
  802807:	eb 6e                	jmp    802877 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802809:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280d:	74 06                	je     802815 <alloc_block_BF+0x341>
  80280f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802813:	75 17                	jne    80282c <alloc_block_BF+0x358>
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 24 43 80 00       	push   $0x804324
  80281d:	68 4f 01 00 00       	push   $0x14f
  802822:	68 b1 42 80 00       	push   $0x8042b1
  802827:	e8 2c 10 00 00       	call   803858 <_panic>
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 10                	mov    (%eax),%edx
  802831:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802834:	89 10                	mov    %edx,(%eax)
  802836:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0b                	je     80284a <alloc_block_BF+0x376>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802850:	89 10                	mov    %edx,(%eax)
  802852:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802855:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802858:	89 50 04             	mov    %edx,0x4(%eax)
  80285b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	75 08                	jne    80286c <alloc_block_BF+0x398>
  802864:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802867:	a3 30 50 80 00       	mov    %eax,0x805030
  80286c:	a1 38 50 80 00       	mov    0x805038,%eax
  802871:	40                   	inc    %eax
  802872:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802877:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_BF+0x3c0>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 93 42 80 00       	push   $0x804293
  802885:	68 51 01 00 00       	push   $0x151
  80288a:	68 b1 42 80 00       	push   $0x8042b1
  80288f:	e8 c4 0f 00 00       	call   803858 <_panic>
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_BF+0x3d9>
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_BF+0x3e4>
  8028ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_BF+0x3fd>
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_BF+0x407>
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	6a 00                	push   $0x0
  8028fe:	ff 75 d0             	pushl  -0x30(%ebp)
  802901:	ff 75 cc             	pushl  -0x34(%ebp)
  802904:	e8 e0 f6 ff ff       	call   801fe9 <set_block_data>
  802909:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	e9 a3 01 00 00       	jmp    802ab7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802914:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802918:	0f 85 9d 00 00 00    	jne    8029bb <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	6a 01                	push   $0x1
  802923:	ff 75 ec             	pushl  -0x14(%ebp)
  802926:	ff 75 f0             	pushl  -0x10(%ebp)
  802929:	e8 bb f6 ff ff       	call   801fe9 <set_block_data>
  80292e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802931:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802935:	75 17                	jne    80294e <alloc_block_BF+0x47a>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 93 42 80 00       	push   $0x804293
  80293f:	68 58 01 00 00       	push   $0x158
  802944:	68 b1 42 80 00       	push   $0x8042b1
  802949:	e8 0a 0f 00 00       	call   803858 <_panic>
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block_BF+0x493>
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block_BF+0x49e>
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 30 50 80 00       	mov    %eax,0x805030
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block_BF+0x4b7>
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block_BF+0x4c1>
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	e9 fc 00 00 00       	jmp    802ab7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	83 c0 08             	add    $0x8,%eax
  8029c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029c4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	48                   	dec    %eax
  8029d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029da:	ba 00 00 00 00       	mov    $0x0,%edx
  8029df:	f7 75 c4             	divl   -0x3c(%ebp)
  8029e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029e5:	29 d0                	sub    %edx,%eax
  8029e7:	c1 e8 0c             	shr    $0xc,%eax
  8029ea:	83 ec 0c             	sub    $0xc,%esp
  8029ed:	50                   	push   %eax
  8029ee:	e8 37 e7 ff ff       	call   80112a <sbrk>
  8029f3:	83 c4 10             	add    $0x10,%esp
  8029f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029f9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029fd:	75 0a                	jne    802a09 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802a04:	e9 ae 00 00 00       	jmp    802ab7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a09:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a10:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a13:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a16:	01 d0                	add    %edx,%eax
  802a18:	48                   	dec    %eax
  802a19:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a1c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	f7 75 b8             	divl   -0x48(%ebp)
  802a27:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a2a:	29 d0                	sub    %edx,%eax
  802a2c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a32:	01 d0                	add    %edx,%eax
  802a34:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a39:	a1 40 50 80 00       	mov    0x805040,%eax
  802a3e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a44:	83 ec 0c             	sub    $0xc,%esp
  802a47:	68 58 43 80 00       	push   $0x804358
  802a4c:	e8 3f d9 ff ff       	call   800390 <cprintf>
  802a51:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a54:	83 ec 08             	sub    $0x8,%esp
  802a57:	ff 75 bc             	pushl  -0x44(%ebp)
  802a5a:	68 5d 43 80 00       	push   $0x80435d
  802a5f:	e8 2c d9 ff ff       	call   800390 <cprintf>
  802a64:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a67:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a6e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a71:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a74:	01 d0                	add    %edx,%eax
  802a76:	48                   	dec    %eax
  802a77:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a7a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a82:	f7 75 b0             	divl   -0x50(%ebp)
  802a85:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a88:	29 d0                	sub    %edx,%eax
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	6a 01                	push   $0x1
  802a8f:	50                   	push   %eax
  802a90:	ff 75 bc             	pushl  -0x44(%ebp)
  802a93:	e8 51 f5 ff ff       	call   801fe9 <set_block_data>
  802a98:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a9b:	83 ec 0c             	sub    $0xc,%esp
  802a9e:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa1:	e8 36 04 00 00       	call   802edc <free_block>
  802aa6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802aa9:	83 ec 0c             	sub    $0xc,%esp
  802aac:	ff 75 08             	pushl  0x8(%ebp)
  802aaf:	e8 20 fa ff ff       	call   8024d4 <alloc_block_BF>
  802ab4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	53                   	push   %ebx
  802abd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ac7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ace:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad2:	74 1e                	je     802af2 <merging+0x39>
  802ad4:	ff 75 08             	pushl  0x8(%ebp)
  802ad7:	e8 bc f1 ff ff       	call   801c98 <get_block_size>
  802adc:	83 c4 04             	add    $0x4,%esp
  802adf:	89 c2                	mov    %eax,%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	01 d0                	add    %edx,%eax
  802ae6:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ae9:	75 07                	jne    802af2 <merging+0x39>
		prev_is_free = 1;
  802aeb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802af2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802af6:	74 1e                	je     802b16 <merging+0x5d>
  802af8:	ff 75 10             	pushl  0x10(%ebp)
  802afb:	e8 98 f1 ff ff       	call   801c98 <get_block_size>
  802b00:	83 c4 04             	add    $0x4,%esp
  802b03:	89 c2                	mov    %eax,%edx
  802b05:	8b 45 10             	mov    0x10(%ebp),%eax
  802b08:	01 d0                	add    %edx,%eax
  802b0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b0d:	75 07                	jne    802b16 <merging+0x5d>
		next_is_free = 1;
  802b0f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1a:	0f 84 cc 00 00 00    	je     802bec <merging+0x133>
  802b20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b24:	0f 84 c2 00 00 00    	je     802bec <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b2a:	ff 75 08             	pushl  0x8(%ebp)
  802b2d:	e8 66 f1 ff ff       	call   801c98 <get_block_size>
  802b32:	83 c4 04             	add    $0x4,%esp
  802b35:	89 c3                	mov    %eax,%ebx
  802b37:	ff 75 10             	pushl  0x10(%ebp)
  802b3a:	e8 59 f1 ff ff       	call   801c98 <get_block_size>
  802b3f:	83 c4 04             	add    $0x4,%esp
  802b42:	01 c3                	add    %eax,%ebx
  802b44:	ff 75 0c             	pushl  0xc(%ebp)
  802b47:	e8 4c f1 ff ff       	call   801c98 <get_block_size>
  802b4c:	83 c4 04             	add    $0x4,%esp
  802b4f:	01 d8                	add    %ebx,%eax
  802b51:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b54:	6a 00                	push   $0x0
  802b56:	ff 75 ec             	pushl  -0x14(%ebp)
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	e8 88 f4 ff ff       	call   801fe9 <set_block_data>
  802b61:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b68:	75 17                	jne    802b81 <merging+0xc8>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 93 42 80 00       	push   $0x804293
  802b72:	68 7d 01 00 00       	push   $0x17d
  802b77:	68 b1 42 80 00       	push   $0x8042b1
  802b7c:	e8 d7 0c 00 00       	call   803858 <_panic>
  802b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 10                	je     802b9a <merging+0xe1>
  802b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b92:	8b 52 04             	mov    0x4(%edx),%edx
  802b95:	89 50 04             	mov    %edx,0x4(%eax)
  802b98:	eb 0b                	jmp    802ba5 <merging+0xec>
  802b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 0f                	je     802bbe <merging+0x105>
  802baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb8:	8b 12                	mov    (%edx),%edx
  802bba:	89 10                	mov    %edx,(%eax)
  802bbc:	eb 0a                	jmp    802bc8 <merging+0x10f>
  802bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdb:	a1 38 50 80 00       	mov    0x805038,%eax
  802be0:	48                   	dec    %eax
  802be1:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802be6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802be7:	e9 ea 02 00 00       	jmp    802ed6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	74 3b                	je     802c2d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bf2:	83 ec 0c             	sub    $0xc,%esp
  802bf5:	ff 75 08             	pushl  0x8(%ebp)
  802bf8:	e8 9b f0 ff ff       	call   801c98 <get_block_size>
  802bfd:	83 c4 10             	add    $0x10,%esp
  802c00:	89 c3                	mov    %eax,%ebx
  802c02:	83 ec 0c             	sub    $0xc,%esp
  802c05:	ff 75 10             	pushl  0x10(%ebp)
  802c08:	e8 8b f0 ff ff       	call   801c98 <get_block_size>
  802c0d:	83 c4 10             	add    $0x10,%esp
  802c10:	01 d8                	add    %ebx,%eax
  802c12:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	6a 00                	push   $0x0
  802c1a:	ff 75 e8             	pushl  -0x18(%ebp)
  802c1d:	ff 75 08             	pushl  0x8(%ebp)
  802c20:	e8 c4 f3 ff ff       	call   801fe9 <set_block_data>
  802c25:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c28:	e9 a9 02 00 00       	jmp    802ed6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c31:	0f 84 2d 01 00 00    	je     802d64 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c37:	83 ec 0c             	sub    $0xc,%esp
  802c3a:	ff 75 10             	pushl  0x10(%ebp)
  802c3d:	e8 56 f0 ff ff       	call   801c98 <get_block_size>
  802c42:	83 c4 10             	add    $0x10,%esp
  802c45:	89 c3                	mov    %eax,%ebx
  802c47:	83 ec 0c             	sub    $0xc,%esp
  802c4a:	ff 75 0c             	pushl  0xc(%ebp)
  802c4d:	e8 46 f0 ff ff       	call   801c98 <get_block_size>
  802c52:	83 c4 10             	add    $0x10,%esp
  802c55:	01 d8                	add    %ebx,%eax
  802c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	6a 00                	push   $0x0
  802c5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c62:	ff 75 10             	pushl  0x10(%ebp)
  802c65:	e8 7f f3 ff ff       	call   801fe9 <set_block_data>
  802c6a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802c70:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c77:	74 06                	je     802c7f <merging+0x1c6>
  802c79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c7d:	75 17                	jne    802c96 <merging+0x1dd>
  802c7f:	83 ec 04             	sub    $0x4,%esp
  802c82:	68 6c 43 80 00       	push   $0x80436c
  802c87:	68 8d 01 00 00       	push   $0x18d
  802c8c:	68 b1 42 80 00       	push   $0x8042b1
  802c91:	e8 c2 0b 00 00       	call   803858 <_panic>
  802c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c99:	8b 50 04             	mov    0x4(%eax),%edx
  802c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 0d                	je     802cc1 <merging+0x208>
  802cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cbd:	89 10                	mov    %edx,(%eax)
  802cbf:	eb 08                	jmp    802cc9 <merging+0x210>
  802cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd7:	40                   	inc    %eax
  802cd8:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce1:	75 17                	jne    802cfa <merging+0x241>
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	68 93 42 80 00       	push   $0x804293
  802ceb:	68 8e 01 00 00       	push   $0x18e
  802cf0:	68 b1 42 80 00       	push   $0x8042b1
  802cf5:	e8 5e 0b 00 00       	call   803858 <_panic>
  802cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 10                	je     802d13 <merging+0x25a>
  802d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0b:	8b 52 04             	mov    0x4(%edx),%edx
  802d0e:	89 50 04             	mov    %edx,0x4(%eax)
  802d11:	eb 0b                	jmp    802d1e <merging+0x265>
  802d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	a3 30 50 80 00       	mov    %eax,0x805030
  802d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	85 c0                	test   %eax,%eax
  802d26:	74 0f                	je     802d37 <merging+0x27e>
  802d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2b:	8b 40 04             	mov    0x4(%eax),%eax
  802d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d31:	8b 12                	mov    (%edx),%edx
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	eb 0a                	jmp    802d41 <merging+0x288>
  802d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d54:	a1 38 50 80 00       	mov    0x805038,%eax
  802d59:	48                   	dec    %eax
  802d5a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d5f:	e9 72 01 00 00       	jmp    802ed6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d64:	8b 45 10             	mov    0x10(%ebp),%eax
  802d67:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6e:	74 79                	je     802de9 <merging+0x330>
  802d70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d74:	74 73                	je     802de9 <merging+0x330>
  802d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7a:	74 06                	je     802d82 <merging+0x2c9>
  802d7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d80:	75 17                	jne    802d99 <merging+0x2e0>
  802d82:	83 ec 04             	sub    $0x4,%esp
  802d85:	68 24 43 80 00       	push   $0x804324
  802d8a:	68 94 01 00 00       	push   $0x194
  802d8f:	68 b1 42 80 00       	push   $0x8042b1
  802d94:	e8 bf 0a 00 00       	call   803858 <_panic>
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 10                	mov    (%eax),%edx
  802d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 0b                	je     802db7 <merging+0x2fe>
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db4:	89 50 04             	mov    %edx,0x4(%eax)
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dbd:	89 10                	mov    %edx,(%eax)
  802dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc5:	89 50 04             	mov    %edx,0x4(%eax)
  802dc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcb:	8b 00                	mov    (%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	75 08                	jne    802dd9 <merging+0x320>
  802dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd4:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd9:	a1 38 50 80 00       	mov    0x805038,%eax
  802dde:	40                   	inc    %eax
  802ddf:	a3 38 50 80 00       	mov    %eax,0x805038
  802de4:	e9 ce 00 00 00       	jmp    802eb7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ded:	74 65                	je     802e54 <merging+0x39b>
  802def:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df3:	75 17                	jne    802e0c <merging+0x353>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 00 43 80 00       	push   $0x804300
  802dfd:	68 95 01 00 00       	push   $0x195
  802e02:	68 b1 42 80 00       	push   $0x8042b1
  802e07:	e8 4c 0a 00 00       	call   803858 <_panic>
  802e0c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 0c                	je     802e2e <merging+0x375>
  802e22:	a1 30 50 80 00       	mov    0x805030,%eax
  802e27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	eb 08                	jmp    802e36 <merging+0x37d>
  802e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e39:	a3 30 50 80 00       	mov    %eax,0x805030
  802e3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e47:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4c:	40                   	inc    %eax
  802e4d:	a3 38 50 80 00       	mov    %eax,0x805038
  802e52:	eb 63                	jmp    802eb7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e58:	75 17                	jne    802e71 <merging+0x3b8>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 cc 42 80 00       	push   $0x8042cc
  802e62:	68 98 01 00 00       	push   $0x198
  802e67:	68 b1 42 80 00       	push   $0x8042b1
  802e6c:	e8 e7 09 00 00       	call   803858 <_panic>
  802e71:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 0d                	je     802e92 <merging+0x3d9>
  802e85:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8d:	89 50 04             	mov    %edx,0x4(%eax)
  802e90:	eb 08                	jmp    802e9a <merging+0x3e1>
  802e92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e95:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eac:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb1:	40                   	inc    %eax
  802eb2:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 10             	pushl  0x10(%ebp)
  802ebd:	e8 d6 ed ff ff       	call   801c98 <get_block_size>
  802ec2:	83 c4 10             	add    $0x10,%esp
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	6a 00                	push   $0x0
  802eca:	50                   	push   %eax
  802ecb:	ff 75 10             	pushl  0x10(%ebp)
  802ece:	e8 16 f1 ff ff       	call   801fe9 <set_block_data>
  802ed3:	83 c4 10             	add    $0x10,%esp
	}
}
  802ed6:	90                   	nop
  802ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eda:	c9                   	leave  
  802edb:	c3                   	ret    

00802edc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
  802edf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ee2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802eea:	a1 30 50 80 00       	mov    0x805030,%eax
  802eef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef2:	73 1b                	jae    802f0f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ef4:	a1 30 50 80 00       	mov    0x805030,%eax
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	ff 75 08             	pushl  0x8(%ebp)
  802eff:	6a 00                	push   $0x0
  802f01:	50                   	push   %eax
  802f02:	e8 b2 fb ff ff       	call   802ab9 <merging>
  802f07:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f0a:	e9 8b 00 00 00       	jmp    802f9a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f0f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f17:	76 18                	jbe    802f31 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f19:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	50                   	push   %eax
  802f25:	6a 00                	push   $0x0
  802f27:	e8 8d fb ff ff       	call   802ab9 <merging>
  802f2c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f2f:	eb 69                	jmp    802f9a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f31:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f39:	eb 39                	jmp    802f74 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f41:	73 29                	jae    802f6c <free_block+0x90>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4b:	76 1f                	jbe    802f6c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	ff 75 08             	pushl  0x8(%ebp)
  802f5b:	ff 75 f0             	pushl  -0x10(%ebp)
  802f5e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f61:	e8 53 fb ff ff       	call   802ab9 <merging>
  802f66:	83 c4 10             	add    $0x10,%esp
			break;
  802f69:	90                   	nop
		}
	}
}
  802f6a:	eb 2e                	jmp    802f9a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f6c:	a1 34 50 80 00       	mov    0x805034,%eax
  802f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f78:	74 07                	je     802f81 <free_block+0xa5>
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	eb 05                	jmp    802f86 <free_block+0xaa>
  802f81:	b8 00 00 00 00       	mov    $0x0,%eax
  802f86:	a3 34 50 80 00       	mov    %eax,0x805034
  802f8b:	a1 34 50 80 00       	mov    0x805034,%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	75 a7                	jne    802f3b <free_block+0x5f>
  802f94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f98:	75 a1                	jne    802f3b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f9a:	90                   	nop
  802f9b:	c9                   	leave  
  802f9c:	c3                   	ret    

00802f9d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
  802fa0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802fa3:	ff 75 08             	pushl  0x8(%ebp)
  802fa6:	e8 ed ec ff ff       	call   801c98 <get_block_size>
  802fab:	83 c4 04             	add    $0x4,%esp
  802fae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802fb8:	eb 17                	jmp    802fd1 <copy_data+0x34>
  802fba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc0:	01 c2                	add    %eax,%edx
  802fc2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	01 c8                	add    %ecx,%eax
  802fca:	8a 00                	mov    (%eax),%al
  802fcc:	88 02                	mov    %al,(%edx)
  802fce:	ff 45 fc             	incl   -0x4(%ebp)
  802fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fd7:	72 e1                	jb     802fba <copy_data+0x1d>
}
  802fd9:	90                   	nop
  802fda:	c9                   	leave  
  802fdb:	c3                   	ret    

00802fdc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fdc:	55                   	push   %ebp
  802fdd:	89 e5                	mov    %esp,%ebp
  802fdf:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fe2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe6:	75 23                	jne    80300b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fe8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fec:	74 13                	je     803001 <realloc_block_FF+0x25>
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	ff 75 0c             	pushl  0xc(%ebp)
  802ff4:	e8 1f f0 ff ff       	call   802018 <alloc_block_FF>
  802ff9:	83 c4 10             	add    $0x10,%esp
  802ffc:	e9 f4 06 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
		return NULL;
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
  803006:	e9 ea 06 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80300b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300f:	75 18                	jne    803029 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	ff 75 08             	pushl  0x8(%ebp)
  803017:	e8 c0 fe ff ff       	call   802edc <free_block>
  80301c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80301f:	b8 00 00 00 00       	mov    $0x0,%eax
  803024:	e9 cc 06 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803029:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80302d:	77 07                	ja     803036 <realloc_block_FF+0x5a>
  80302f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803036:	8b 45 0c             	mov    0xc(%ebp),%eax
  803039:	83 e0 01             	and    $0x1,%eax
  80303c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803042:	83 c0 08             	add    $0x8,%eax
  803045:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803048:	83 ec 0c             	sub    $0xc,%esp
  80304b:	ff 75 08             	pushl  0x8(%ebp)
  80304e:	e8 45 ec ff ff       	call   801c98 <get_block_size>
  803053:	83 c4 10             	add    $0x10,%esp
  803056:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803059:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305c:	83 e8 08             	sub    $0x8,%eax
  80305f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	83 e8 04             	sub    $0x4,%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	83 e0 fe             	and    $0xfffffffe,%eax
  80306d:	89 c2                	mov    %eax,%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	01 d0                	add    %edx,%eax
  803074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80307d:	e8 16 ec ff ff       	call   801c98 <get_block_size>
  803082:	83 c4 10             	add    $0x10,%esp
  803085:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308b:	83 e8 08             	sub    $0x8,%eax
  80308e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803091:	8b 45 0c             	mov    0xc(%ebp),%eax
  803094:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803097:	75 08                	jne    8030a1 <realloc_block_FF+0xc5>
	{
		 return va;
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	e9 54 06 00 00       	jmp    8036f5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8030a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030a7:	0f 83 e5 03 00 00    	jae    803492 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8030b6:	83 ec 0c             	sub    $0xc,%esp
  8030b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030bc:	e8 f0 eb ff ff       	call   801cb1 <is_free_block>
  8030c1:	83 c4 10             	add    $0x10,%esp
  8030c4:	84 c0                	test   %al,%al
  8030c6:	0f 84 3b 01 00 00    	je     803207 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d2:	01 d0                	add    %edx,%eax
  8030d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	6a 01                	push   $0x1
  8030dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8030df:	ff 75 08             	pushl  0x8(%ebp)
  8030e2:	e8 02 ef ff ff       	call   801fe9 <set_block_data>
  8030e7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	83 e8 04             	sub    $0x4,%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	83 e0 fe             	and    $0xfffffffe,%eax
  8030f5:	89 c2                	mov    %eax,%edx
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	01 d0                	add    %edx,%eax
  8030fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030ff:	83 ec 04             	sub    $0x4,%esp
  803102:	6a 00                	push   $0x0
  803104:	ff 75 cc             	pushl  -0x34(%ebp)
  803107:	ff 75 c8             	pushl  -0x38(%ebp)
  80310a:	e8 da ee ff ff       	call   801fe9 <set_block_data>
  80310f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803112:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803116:	74 06                	je     80311e <realloc_block_FF+0x142>
  803118:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80311c:	75 17                	jne    803135 <realloc_block_FF+0x159>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 24 43 80 00       	push   $0x804324
  803126:	68 f6 01 00 00       	push   $0x1f6
  80312b:	68 b1 42 80 00       	push   $0x8042b1
  803130:	e8 23 07 00 00       	call   803858 <_panic>
  803135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803138:	8b 10                	mov    (%eax),%edx
  80313a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80313d:	89 10                	mov    %edx,(%eax)
  80313f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	74 0b                	je     803153 <realloc_block_FF+0x177>
  803148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314b:	8b 00                	mov    (%eax),%eax
  80314d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803156:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803159:	89 10                	mov    %edx,(%eax)
  80315b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80315e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803161:	89 50 04             	mov    %edx,0x4(%eax)
  803164:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	75 08                	jne    803175 <realloc_block_FF+0x199>
  80316d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803170:	a3 30 50 80 00       	mov    %eax,0x805030
  803175:	a1 38 50 80 00       	mov    0x805038,%eax
  80317a:	40                   	inc    %eax
  80317b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803180:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803184:	75 17                	jne    80319d <realloc_block_FF+0x1c1>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 93 42 80 00       	push   $0x804293
  80318e:	68 f7 01 00 00       	push   $0x1f7
  803193:	68 b1 42 80 00       	push   $0x8042b1
  803198:	e8 bb 06 00 00       	call   803858 <_panic>
  80319d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 10                	je     8031b6 <realloc_block_FF+0x1da>
  8031a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031ae:	8b 52 04             	mov    0x4(%edx),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	eb 0b                	jmp    8031c1 <realloc_block_FF+0x1e5>
  8031b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	8b 40 04             	mov    0x4(%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0f                	je     8031da <realloc_block_FF+0x1fe>
  8031cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ce:	8b 40 04             	mov    0x4(%eax),%eax
  8031d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031d4:	8b 12                	mov    (%edx),%edx
  8031d6:	89 10                	mov    %edx,(%eax)
  8031d8:	eb 0a                	jmp    8031e4 <realloc_block_FF+0x208>
  8031da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fc:	48                   	dec    %eax
  8031fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803202:	e9 83 02 00 00       	jmp    80348a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803207:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80320b:	0f 86 69 02 00 00    	jbe    80347a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	6a 01                	push   $0x1
  803216:	ff 75 f0             	pushl  -0x10(%ebp)
  803219:	ff 75 08             	pushl  0x8(%ebp)
  80321c:	e8 c8 ed ff ff       	call   801fe9 <set_block_data>
  803221:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	83 e8 04             	sub    $0x4,%eax
  80322a:	8b 00                	mov    (%eax),%eax
  80322c:	83 e0 fe             	and    $0xfffffffe,%eax
  80322f:	89 c2                	mov    %eax,%edx
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	01 d0                	add    %edx,%eax
  803236:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803239:	a1 38 50 80 00       	mov    0x805038,%eax
  80323e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803241:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803245:	75 68                	jne    8032af <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803247:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80324b:	75 17                	jne    803264 <realloc_block_FF+0x288>
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	68 cc 42 80 00       	push   $0x8042cc
  803255:	68 06 02 00 00       	push   $0x206
  80325a:	68 b1 42 80 00       	push   $0x8042b1
  80325f:	e8 f4 05 00 00       	call   803858 <_panic>
  803264:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80326a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80326d:	89 10                	mov    %edx,(%eax)
  80326f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0d                	je     803285 <realloc_block_FF+0x2a9>
  803278:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80327d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803280:	89 50 04             	mov    %edx,0x4(%eax)
  803283:	eb 08                	jmp    80328d <realloc_block_FF+0x2b1>
  803285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803288:	a3 30 50 80 00       	mov    %eax,0x805030
  80328d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803290:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803298:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329f:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a4:	40                   	inc    %eax
  8032a5:	a3 38 50 80 00       	mov    %eax,0x805038
  8032aa:	e9 b0 01 00 00       	jmp    80345f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032b7:	76 68                	jbe    803321 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032b9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032bd:	75 17                	jne    8032d6 <realloc_block_FF+0x2fa>
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 cc 42 80 00       	push   $0x8042cc
  8032c7:	68 0b 02 00 00       	push   $0x20b
  8032cc:	68 b1 42 80 00       	push   $0x8042b1
  8032d1:	e8 82 05 00 00       	call   803858 <_panic>
  8032d6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032df:	89 10                	mov    %edx,(%eax)
  8032e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 0d                	je     8032f7 <realloc_block_FF+0x31b>
  8032ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032f2:	89 50 04             	mov    %edx,0x4(%eax)
  8032f5:	eb 08                	jmp    8032ff <realloc_block_FF+0x323>
  8032f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803302:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803307:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803311:	a1 38 50 80 00       	mov    0x805038,%eax
  803316:	40                   	inc    %eax
  803317:	a3 38 50 80 00       	mov    %eax,0x805038
  80331c:	e9 3e 01 00 00       	jmp    80345f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803321:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803326:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803329:	73 68                	jae    803393 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80332b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80332f:	75 17                	jne    803348 <realloc_block_FF+0x36c>
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 00 43 80 00       	push   $0x804300
  803339:	68 10 02 00 00       	push   $0x210
  80333e:	68 b1 42 80 00       	push   $0x8042b1
  803343:	e8 10 05 00 00       	call   803858 <_panic>
  803348:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80334e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	85 c0                	test   %eax,%eax
  80335c:	74 0c                	je     80336a <realloc_block_FF+0x38e>
  80335e:	a1 30 50 80 00       	mov    0x805030,%eax
  803363:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803366:	89 10                	mov    %edx,(%eax)
  803368:	eb 08                	jmp    803372 <realloc_block_FF+0x396>
  80336a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803375:	a3 30 50 80 00       	mov    %eax,0x805030
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803383:	a1 38 50 80 00       	mov    0x805038,%eax
  803388:	40                   	inc    %eax
  803389:	a3 38 50 80 00       	mov    %eax,0x805038
  80338e:	e9 cc 00 00 00       	jmp    80345f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80339a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80339f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a2:	e9 8a 00 00 00       	jmp    803431 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033ad:	73 7a                	jae    803429 <realloc_block_FF+0x44d>
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033b7:	73 70                	jae    803429 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8033b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bd:	74 06                	je     8033c5 <realloc_block_FF+0x3e9>
  8033bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c3:	75 17                	jne    8033dc <realloc_block_FF+0x400>
  8033c5:	83 ec 04             	sub    $0x4,%esp
  8033c8:	68 24 43 80 00       	push   $0x804324
  8033cd:	68 1a 02 00 00       	push   $0x21a
  8033d2:	68 b1 42 80 00       	push   $0x8042b1
  8033d7:	e8 7c 04 00 00       	call   803858 <_panic>
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 10                	mov    (%eax),%edx
  8033e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e4:	89 10                	mov    %edx,(%eax)
  8033e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 0b                	je     8033fa <realloc_block_FF+0x41e>
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	75 08                	jne    80341c <realloc_block_FF+0x440>
  803414:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803417:	a3 30 50 80 00       	mov    %eax,0x805030
  80341c:	a1 38 50 80 00       	mov    0x805038,%eax
  803421:	40                   	inc    %eax
  803422:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803427:	eb 36                	jmp    80345f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803429:	a1 34 50 80 00       	mov    0x805034,%eax
  80342e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803435:	74 07                	je     80343e <realloc_block_FF+0x462>
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	eb 05                	jmp    803443 <realloc_block_FF+0x467>
  80343e:	b8 00 00 00 00       	mov    $0x0,%eax
  803443:	a3 34 50 80 00       	mov    %eax,0x805034
  803448:	a1 34 50 80 00       	mov    0x805034,%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	0f 85 52 ff ff ff    	jne    8033a7 <realloc_block_FF+0x3cb>
  803455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803459:	0f 85 48 ff ff ff    	jne    8033a7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	6a 00                	push   $0x0
  803464:	ff 75 d8             	pushl  -0x28(%ebp)
  803467:	ff 75 d4             	pushl  -0x2c(%ebp)
  80346a:	e8 7a eb ff ff       	call   801fe9 <set_block_data>
  80346f:	83 c4 10             	add    $0x10,%esp
				return va;
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	e9 7b 02 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80347a:	83 ec 0c             	sub    $0xc,%esp
  80347d:	68 a1 43 80 00       	push   $0x8043a1
  803482:	e8 09 cf ff ff       	call   800390 <cprintf>
  803487:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	e9 63 02 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803492:	8b 45 0c             	mov    0xc(%ebp),%eax
  803495:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803498:	0f 86 4d 02 00 00    	jbe    8036eb <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80349e:	83 ec 0c             	sub    $0xc,%esp
  8034a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a4:	e8 08 e8 ff ff       	call   801cb1 <is_free_block>
  8034a9:	83 c4 10             	add    $0x10,%esp
  8034ac:	84 c0                	test   %al,%al
  8034ae:	0f 84 37 02 00 00    	je     8036eb <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8034b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8034bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034c0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034c3:	76 38                	jbe    8034fd <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034c5:	83 ec 0c             	sub    $0xc,%esp
  8034c8:	ff 75 08             	pushl  0x8(%ebp)
  8034cb:	e8 0c fa ff ff       	call   802edc <free_block>
  8034d0:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034d3:	83 ec 0c             	sub    $0xc,%esp
  8034d6:	ff 75 0c             	pushl  0xc(%ebp)
  8034d9:	e8 3a eb ff ff       	call   802018 <alloc_block_FF>
  8034de:	83 c4 10             	add    $0x10,%esp
  8034e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034e4:	83 ec 08             	sub    $0x8,%esp
  8034e7:	ff 75 c0             	pushl  -0x40(%ebp)
  8034ea:	ff 75 08             	pushl  0x8(%ebp)
  8034ed:	e8 ab fa ff ff       	call   802f9d <copy_data>
  8034f2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034f8:	e9 f8 01 00 00       	jmp    8036f5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803500:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803503:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803506:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80350a:	0f 87 a0 00 00 00    	ja     8035b0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803510:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803514:	75 17                	jne    80352d <realloc_block_FF+0x551>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 93 42 80 00       	push   $0x804293
  80351e:	68 38 02 00 00       	push   $0x238
  803523:	68 b1 42 80 00       	push   $0x8042b1
  803528:	e8 2b 03 00 00       	call   803858 <_panic>
  80352d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 10                	je     803546 <realloc_block_FF+0x56a>
  803536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80353e:	8b 52 04             	mov    0x4(%edx),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 0b                	jmp    803551 <realloc_block_FF+0x575>
  803546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	a3 30 50 80 00       	mov    %eax,0x805030
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0f                	je     80356a <realloc_block_FF+0x58e>
  80355b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803564:	8b 12                	mov    (%edx),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	eb 0a                	jmp    803574 <realloc_block_FF+0x598>
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 38 50 80 00       	mov    0x805038,%eax
  80358c:	48                   	dec    %eax
  80358d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803592:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803598:	01 d0                	add    %edx,%eax
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	6a 01                	push   $0x1
  80359f:	50                   	push   %eax
  8035a0:	ff 75 08             	pushl  0x8(%ebp)
  8035a3:	e8 41 ea ff ff       	call   801fe9 <set_block_data>
  8035a8:	83 c4 10             	add    $0x10,%esp
  8035ab:	e9 36 01 00 00       	jmp    8036e6 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8035b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035b6:	01 d0                	add    %edx,%eax
  8035b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8035bb:	83 ec 04             	sub    $0x4,%esp
  8035be:	6a 01                	push   $0x1
  8035c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8035c3:	ff 75 08             	pushl  0x8(%ebp)
  8035c6:	e8 1e ea ff ff       	call   801fe9 <set_block_data>
  8035cb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	83 e8 04             	sub    $0x4,%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	83 e0 fe             	and    $0xfffffffe,%eax
  8035d9:	89 c2                	mov    %eax,%edx
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	01 d0                	add    %edx,%eax
  8035e0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035e7:	74 06                	je     8035ef <realloc_block_FF+0x613>
  8035e9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035ed:	75 17                	jne    803606 <realloc_block_FF+0x62a>
  8035ef:	83 ec 04             	sub    $0x4,%esp
  8035f2:	68 24 43 80 00       	push   $0x804324
  8035f7:	68 44 02 00 00       	push   $0x244
  8035fc:	68 b1 42 80 00       	push   $0x8042b1
  803601:	e8 52 02 00 00       	call   803858 <_panic>
  803606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803609:	8b 10                	mov    (%eax),%edx
  80360b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80360e:	89 10                	mov    %edx,(%eax)
  803610:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 0b                	je     803624 <realloc_block_FF+0x648>
  803619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803621:	89 50 04             	mov    %edx,0x4(%eax)
  803624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803627:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80362f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	85 c0                	test   %eax,%eax
  80363c:	75 08                	jne    803646 <realloc_block_FF+0x66a>
  80363e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803641:	a3 30 50 80 00       	mov    %eax,0x805030
  803646:	a1 38 50 80 00       	mov    0x805038,%eax
  80364b:	40                   	inc    %eax
  80364c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803651:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803655:	75 17                	jne    80366e <realloc_block_FF+0x692>
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	68 93 42 80 00       	push   $0x804293
  80365f:	68 45 02 00 00       	push   $0x245
  803664:	68 b1 42 80 00       	push   $0x8042b1
  803669:	e8 ea 01 00 00       	call   803858 <_panic>
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 10                	je     803687 <realloc_block_FF+0x6ab>
  803677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367f:	8b 52 04             	mov    0x4(%edx),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	eb 0b                	jmp    803692 <realloc_block_FF+0x6b6>
  803687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	a3 30 50 80 00       	mov    %eax,0x805030
  803692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0f                	je     8036ab <realloc_block_FF+0x6cf>
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	8b 40 04             	mov    0x4(%eax),%eax
  8036a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a5:	8b 12                	mov    (%edx),%edx
  8036a7:	89 10                	mov    %edx,(%eax)
  8036a9:	eb 0a                	jmp    8036b5 <realloc_block_FF+0x6d9>
  8036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8036cd:	48                   	dec    %eax
  8036ce:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036d3:	83 ec 04             	sub    $0x4,%esp
  8036d6:	6a 00                	push   $0x0
  8036d8:	ff 75 bc             	pushl  -0x44(%ebp)
  8036db:	ff 75 b8             	pushl  -0x48(%ebp)
  8036de:	e8 06 e9 ff ff       	call   801fe9 <set_block_data>
  8036e3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	eb 0a                	jmp    8036f5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036eb:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036f5:	c9                   	leave  
  8036f6:	c3                   	ret    

008036f7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036f7:	55                   	push   %ebp
  8036f8:	89 e5                	mov    %esp,%ebp
  8036fa:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	68 a8 43 80 00       	push   $0x8043a8
  803705:	68 58 02 00 00       	push   $0x258
  80370a:	68 b1 42 80 00       	push   $0x8042b1
  80370f:	e8 44 01 00 00       	call   803858 <_panic>

00803714 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803714:	55                   	push   %ebp
  803715:	89 e5                	mov    %esp,%ebp
  803717:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80371a:	83 ec 04             	sub    $0x4,%esp
  80371d:	68 d0 43 80 00       	push   $0x8043d0
  803722:	68 61 02 00 00       	push   $0x261
  803727:	68 b1 42 80 00       	push   $0x8042b1
  80372c:	e8 27 01 00 00       	call   803858 <_panic>

00803731 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803731:	55                   	push   %ebp
  803732:	89 e5                	mov    %esp,%ebp
  803734:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	68 f8 43 80 00       	push   $0x8043f8
  80373f:	6a 09                	push   $0x9
  803741:	68 20 44 80 00       	push   $0x804420
  803746:	e8 0d 01 00 00       	call   803858 <_panic>

0080374b <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80374b:	55                   	push   %ebp
  80374c:	89 e5                	mov    %esp,%ebp
  80374e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803751:	83 ec 04             	sub    $0x4,%esp
  803754:	68 30 44 80 00       	push   $0x804430
  803759:	6a 10                	push   $0x10
  80375b:	68 20 44 80 00       	push   $0x804420
  803760:	e8 f3 00 00 00       	call   803858 <_panic>

00803765 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
  803768:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	68 58 44 80 00       	push   $0x804458
  803773:	6a 18                	push   $0x18
  803775:	68 20 44 80 00       	push   $0x804420
  80377a:	e8 d9 00 00 00       	call   803858 <_panic>

0080377f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80377f:	55                   	push   %ebp
  803780:	89 e5                	mov    %esp,%ebp
  803782:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803785:	83 ec 04             	sub    $0x4,%esp
  803788:	68 80 44 80 00       	push   $0x804480
  80378d:	6a 20                	push   $0x20
  80378f:	68 20 44 80 00       	push   $0x804420
  803794:	e8 bf 00 00 00       	call   803858 <_panic>

00803799 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803799:	55                   	push   %ebp
  80379a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037a2:	5d                   	pop    %ebp
  8037a3:	c3                   	ret    

008037a4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037a4:	55                   	push   %ebp
  8037a5:	89 e5                	mov    %esp,%ebp
  8037a7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ad:	89 d0                	mov    %edx,%eax
  8037af:	c1 e0 02             	shl    $0x2,%eax
  8037b2:	01 d0                	add    %edx,%eax
  8037b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037c4:	01 d0                	add    %edx,%eax
  8037c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037cd:	01 d0                	add    %edx,%eax
  8037cf:	c1 e0 04             	shl    $0x4,%eax
  8037d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8037dc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037df:	83 ec 0c             	sub    $0xc,%esp
  8037e2:	50                   	push   %eax
  8037e3:	e8 bc e1 ff ff       	call   8019a4 <sys_get_virtual_time>
  8037e8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037eb:	eb 41                	jmp    80382e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037f0:	83 ec 0c             	sub    $0xc,%esp
  8037f3:	50                   	push   %eax
  8037f4:	e8 ab e1 ff ff       	call   8019a4 <sys_get_virtual_time>
  8037f9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803802:	29 c2                	sub    %eax,%edx
  803804:	89 d0                	mov    %edx,%eax
  803806:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803809:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	89 d1                	mov    %edx,%ecx
  803811:	29 c1                	sub    %eax,%ecx
  803813:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803819:	39 c2                	cmp    %eax,%edx
  80381b:	0f 97 c0             	seta   %al
  80381e:	0f b6 c0             	movzbl %al,%eax
  803821:	29 c1                	sub    %eax,%ecx
  803823:	89 c8                	mov    %ecx,%eax
  803825:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803834:	72 b7                	jb     8037ed <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803836:	90                   	nop
  803837:	c9                   	leave  
  803838:	c3                   	ret    

00803839 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80383f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803846:	eb 03                	jmp    80384b <busy_wait+0x12>
  803848:	ff 45 fc             	incl   -0x4(%ebp)
  80384b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80384e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803851:	72 f5                	jb     803848 <busy_wait+0xf>
	return i;
  803853:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803856:	c9                   	leave  
  803857:	c3                   	ret    

00803858 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803858:	55                   	push   %ebp
  803859:	89 e5                	mov    %esp,%ebp
  80385b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80385e:	8d 45 10             	lea    0x10(%ebp),%eax
  803861:	83 c0 04             	add    $0x4,%eax
  803864:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803867:	a1 60 50 98 00       	mov    0x985060,%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 16                	je     803886 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803870:	a1 60 50 98 00       	mov    0x985060,%eax
  803875:	83 ec 08             	sub    $0x8,%esp
  803878:	50                   	push   %eax
  803879:	68 a8 44 80 00       	push   $0x8044a8
  80387e:	e8 0d cb ff ff       	call   800390 <cprintf>
  803883:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803886:	a1 00 50 80 00       	mov    0x805000,%eax
  80388b:	ff 75 0c             	pushl  0xc(%ebp)
  80388e:	ff 75 08             	pushl  0x8(%ebp)
  803891:	50                   	push   %eax
  803892:	68 ad 44 80 00       	push   $0x8044ad
  803897:	e8 f4 ca ff ff       	call   800390 <cprintf>
  80389c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80389f:	8b 45 10             	mov    0x10(%ebp),%eax
  8038a2:	83 ec 08             	sub    $0x8,%esp
  8038a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8038a8:	50                   	push   %eax
  8038a9:	e8 77 ca ff ff       	call   800325 <vcprintf>
  8038ae:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8038b1:	83 ec 08             	sub    $0x8,%esp
  8038b4:	6a 00                	push   $0x0
  8038b6:	68 c9 44 80 00       	push   $0x8044c9
  8038bb:	e8 65 ca ff ff       	call   800325 <vcprintf>
  8038c0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038c3:	e8 e6 c9 ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  8038c8:	eb fe                	jmp    8038c8 <_panic+0x70>

008038ca <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038ca:	55                   	push   %ebp
  8038cb:	89 e5                	mov    %esp,%ebp
  8038cd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8038d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8038d5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038de:	39 c2                	cmp    %eax,%edx
  8038e0:	74 14                	je     8038f6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	68 cc 44 80 00       	push   $0x8044cc
  8038ea:	6a 26                	push   $0x26
  8038ec:	68 18 45 80 00       	push   $0x804518
  8038f1:	e8 62 ff ff ff       	call   803858 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803904:	e9 c5 00 00 00       	jmp    8039ce <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	01 d0                	add    %edx,%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	85 c0                	test   %eax,%eax
  80391c:	75 08                	jne    803926 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80391e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803921:	e9 a5 00 00 00       	jmp    8039cb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803926:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80392d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803934:	eb 69                	jmp    80399f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803936:	a1 20 50 80 00       	mov    0x805020,%eax
  80393b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803941:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803944:	89 d0                	mov    %edx,%eax
  803946:	01 c0                	add    %eax,%eax
  803948:	01 d0                	add    %edx,%eax
  80394a:	c1 e0 03             	shl    $0x3,%eax
  80394d:	01 c8                	add    %ecx,%eax
  80394f:	8a 40 04             	mov    0x4(%eax),%al
  803952:	84 c0                	test   %al,%al
  803954:	75 46                	jne    80399c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803956:	a1 20 50 80 00       	mov    0x805020,%eax
  80395b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803961:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803964:	89 d0                	mov    %edx,%eax
  803966:	01 c0                	add    %eax,%eax
  803968:	01 d0                	add    %edx,%eax
  80396a:	c1 e0 03             	shl    $0x3,%eax
  80396d:	01 c8                	add    %ecx,%eax
  80396f:	8b 00                	mov    (%eax),%eax
  803971:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803974:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803977:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80397c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803981:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	01 c8                	add    %ecx,%eax
  80398d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80398f:	39 c2                	cmp    %eax,%edx
  803991:	75 09                	jne    80399c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803993:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80399a:	eb 15                	jmp    8039b1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80399c:	ff 45 e8             	incl   -0x18(%ebp)
  80399f:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	39 c2                	cmp    %eax,%edx
  8039af:	77 85                	ja     803936 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8039b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039b5:	75 14                	jne    8039cb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	68 24 45 80 00       	push   $0x804524
  8039bf:	6a 3a                	push   $0x3a
  8039c1:	68 18 45 80 00       	push   $0x804518
  8039c6:	e8 8d fe ff ff       	call   803858 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8039cb:	ff 45 f0             	incl   -0x10(%ebp)
  8039ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039d4:	0f 8c 2f ff ff ff    	jl     803909 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8039da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039e8:	eb 26                	jmp    803a10 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039f8:	89 d0                	mov    %edx,%eax
  8039fa:	01 c0                	add    %eax,%eax
  8039fc:	01 d0                	add    %edx,%eax
  8039fe:	c1 e0 03             	shl    $0x3,%eax
  803a01:	01 c8                	add    %ecx,%eax
  803a03:	8a 40 04             	mov    0x4(%eax),%al
  803a06:	3c 01                	cmp    $0x1,%al
  803a08:	75 03                	jne    803a0d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a0a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a0d:	ff 45 e0             	incl   -0x20(%ebp)
  803a10:	a1 20 50 80 00       	mov    0x805020,%eax
  803a15:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a1e:	39 c2                	cmp    %eax,%edx
  803a20:	77 c8                	ja     8039ea <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a25:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a28:	74 14                	je     803a3e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a2a:	83 ec 04             	sub    $0x4,%esp
  803a2d:	68 78 45 80 00       	push   $0x804578
  803a32:	6a 44                	push   $0x44
  803a34:	68 18 45 80 00       	push   $0x804518
  803a39:	e8 1a fe ff ff       	call   803858 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a3e:	90                   	nop
  803a3f:	c9                   	leave  
  803a40:	c3                   	ret    
  803a41:	66 90                	xchg   %ax,%ax
  803a43:	90                   	nop

00803a44 <__udivdi3>:
  803a44:	55                   	push   %ebp
  803a45:	57                   	push   %edi
  803a46:	56                   	push   %esi
  803a47:	53                   	push   %ebx
  803a48:	83 ec 1c             	sub    $0x1c,%esp
  803a4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a5b:	89 ca                	mov    %ecx,%edx
  803a5d:	89 f8                	mov    %edi,%eax
  803a5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a63:	85 f6                	test   %esi,%esi
  803a65:	75 2d                	jne    803a94 <__udivdi3+0x50>
  803a67:	39 cf                	cmp    %ecx,%edi
  803a69:	77 65                	ja     803ad0 <__udivdi3+0x8c>
  803a6b:	89 fd                	mov    %edi,%ebp
  803a6d:	85 ff                	test   %edi,%edi
  803a6f:	75 0b                	jne    803a7c <__udivdi3+0x38>
  803a71:	b8 01 00 00 00       	mov    $0x1,%eax
  803a76:	31 d2                	xor    %edx,%edx
  803a78:	f7 f7                	div    %edi
  803a7a:	89 c5                	mov    %eax,%ebp
  803a7c:	31 d2                	xor    %edx,%edx
  803a7e:	89 c8                	mov    %ecx,%eax
  803a80:	f7 f5                	div    %ebp
  803a82:	89 c1                	mov    %eax,%ecx
  803a84:	89 d8                	mov    %ebx,%eax
  803a86:	f7 f5                	div    %ebp
  803a88:	89 cf                	mov    %ecx,%edi
  803a8a:	89 fa                	mov    %edi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	39 ce                	cmp    %ecx,%esi
  803a96:	77 28                	ja     803ac0 <__udivdi3+0x7c>
  803a98:	0f bd fe             	bsr    %esi,%edi
  803a9b:	83 f7 1f             	xor    $0x1f,%edi
  803a9e:	75 40                	jne    803ae0 <__udivdi3+0x9c>
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	72 0a                	jb     803aae <__udivdi3+0x6a>
  803aa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aa8:	0f 87 9e 00 00 00    	ja     803b4c <__udivdi3+0x108>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	89 fa                	mov    %edi,%edx
  803ab5:	83 c4 1c             	add    $0x1c,%esp
  803ab8:	5b                   	pop    %ebx
  803ab9:	5e                   	pop    %esi
  803aba:	5f                   	pop    %edi
  803abb:	5d                   	pop    %ebp
  803abc:	c3                   	ret    
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	31 ff                	xor    %edi,%edi
  803ac2:	31 c0                	xor    %eax,%eax
  803ac4:	89 fa                	mov    %edi,%edx
  803ac6:	83 c4 1c             	add    $0x1c,%esp
  803ac9:	5b                   	pop    %ebx
  803aca:	5e                   	pop    %esi
  803acb:	5f                   	pop    %edi
  803acc:	5d                   	pop    %ebp
  803acd:	c3                   	ret    
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	f7 f7                	div    %edi
  803ad4:	31 ff                	xor    %edi,%edi
  803ad6:	89 fa                	mov    %edi,%edx
  803ad8:	83 c4 1c             	add    $0x1c,%esp
  803adb:	5b                   	pop    %ebx
  803adc:	5e                   	pop    %esi
  803add:	5f                   	pop    %edi
  803ade:	5d                   	pop    %ebp
  803adf:	c3                   	ret    
  803ae0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ae5:	89 eb                	mov    %ebp,%ebx
  803ae7:	29 fb                	sub    %edi,%ebx
  803ae9:	89 f9                	mov    %edi,%ecx
  803aeb:	d3 e6                	shl    %cl,%esi
  803aed:	89 c5                	mov    %eax,%ebp
  803aef:	88 d9                	mov    %bl,%cl
  803af1:	d3 ed                	shr    %cl,%ebp
  803af3:	89 e9                	mov    %ebp,%ecx
  803af5:	09 f1                	or     %esi,%ecx
  803af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803afb:	89 f9                	mov    %edi,%ecx
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 c5                	mov    %eax,%ebp
  803b01:	89 d6                	mov    %edx,%esi
  803b03:	88 d9                	mov    %bl,%cl
  803b05:	d3 ee                	shr    %cl,%esi
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e2                	shl    %cl,%edx
  803b0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 e8                	shr    %cl,%eax
  803b13:	09 c2                	or     %eax,%edx
  803b15:	89 d0                	mov    %edx,%eax
  803b17:	89 f2                	mov    %esi,%edx
  803b19:	f7 74 24 0c          	divl   0xc(%esp)
  803b1d:	89 d6                	mov    %edx,%esi
  803b1f:	89 c3                	mov    %eax,%ebx
  803b21:	f7 e5                	mul    %ebp
  803b23:	39 d6                	cmp    %edx,%esi
  803b25:	72 19                	jb     803b40 <__udivdi3+0xfc>
  803b27:	74 0b                	je     803b34 <__udivdi3+0xf0>
  803b29:	89 d8                	mov    %ebx,%eax
  803b2b:	31 ff                	xor    %edi,%edi
  803b2d:	e9 58 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b32:	66 90                	xchg   %ax,%ax
  803b34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b38:	89 f9                	mov    %edi,%ecx
  803b3a:	d3 e2                	shl    %cl,%edx
  803b3c:	39 c2                	cmp    %eax,%edx
  803b3e:	73 e9                	jae    803b29 <__udivdi3+0xe5>
  803b40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b43:	31 ff                	xor    %edi,%edi
  803b45:	e9 40 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	31 c0                	xor    %eax,%eax
  803b4e:	e9 37 ff ff ff       	jmp    803a8a <__udivdi3+0x46>
  803b53:	90                   	nop

00803b54 <__umoddi3>:
  803b54:	55                   	push   %ebp
  803b55:	57                   	push   %edi
  803b56:	56                   	push   %esi
  803b57:	53                   	push   %ebx
  803b58:	83 ec 1c             	sub    $0x1c,%esp
  803b5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b73:	89 f3                	mov    %esi,%ebx
  803b75:	89 fa                	mov    %edi,%edx
  803b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7b:	89 34 24             	mov    %esi,(%esp)
  803b7e:	85 c0                	test   %eax,%eax
  803b80:	75 1a                	jne    803b9c <__umoddi3+0x48>
  803b82:	39 f7                	cmp    %esi,%edi
  803b84:	0f 86 a2 00 00 00    	jbe    803c2c <__umoddi3+0xd8>
  803b8a:	89 c8                	mov    %ecx,%eax
  803b8c:	89 f2                	mov    %esi,%edx
  803b8e:	f7 f7                	div    %edi
  803b90:	89 d0                	mov    %edx,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	39 f0                	cmp    %esi,%eax
  803b9e:	0f 87 ac 00 00 00    	ja     803c50 <__umoddi3+0xfc>
  803ba4:	0f bd e8             	bsr    %eax,%ebp
  803ba7:	83 f5 1f             	xor    $0x1f,%ebp
  803baa:	0f 84 ac 00 00 00    	je     803c5c <__umoddi3+0x108>
  803bb0:	bf 20 00 00 00       	mov    $0x20,%edi
  803bb5:	29 ef                	sub    %ebp,%edi
  803bb7:	89 fe                	mov    %edi,%esi
  803bb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bbd:	89 e9                	mov    %ebp,%ecx
  803bbf:	d3 e0                	shl    %cl,%eax
  803bc1:	89 d7                	mov    %edx,%edi
  803bc3:	89 f1                	mov    %esi,%ecx
  803bc5:	d3 ef                	shr    %cl,%edi
  803bc7:	09 c7                	or     %eax,%edi
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e2                	shl    %cl,%edx
  803bcd:	89 14 24             	mov    %edx,(%esp)
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	d3 e0                	shl    %cl,%eax
  803bd4:	89 c2                	mov    %eax,%edx
  803bd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bda:	d3 e0                	shl    %cl,%eax
  803bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be4:	89 f1                	mov    %esi,%ecx
  803be6:	d3 e8                	shr    %cl,%eax
  803be8:	09 d0                	or     %edx,%eax
  803bea:	d3 eb                	shr    %cl,%ebx
  803bec:	89 da                	mov    %ebx,%edx
  803bee:	f7 f7                	div    %edi
  803bf0:	89 d3                	mov    %edx,%ebx
  803bf2:	f7 24 24             	mull   (%esp)
  803bf5:	89 c6                	mov    %eax,%esi
  803bf7:	89 d1                	mov    %edx,%ecx
  803bf9:	39 d3                	cmp    %edx,%ebx
  803bfb:	0f 82 87 00 00 00    	jb     803c88 <__umoddi3+0x134>
  803c01:	0f 84 91 00 00 00    	je     803c98 <__umoddi3+0x144>
  803c07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c0b:	29 f2                	sub    %esi,%edx
  803c0d:	19 cb                	sbb    %ecx,%ebx
  803c0f:	89 d8                	mov    %ebx,%eax
  803c11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c15:	d3 e0                	shl    %cl,%eax
  803c17:	89 e9                	mov    %ebp,%ecx
  803c19:	d3 ea                	shr    %cl,%edx
  803c1b:	09 d0                	or     %edx,%eax
  803c1d:	89 e9                	mov    %ebp,%ecx
  803c1f:	d3 eb                	shr    %cl,%ebx
  803c21:	89 da                	mov    %ebx,%edx
  803c23:	83 c4 1c             	add    $0x1c,%esp
  803c26:	5b                   	pop    %ebx
  803c27:	5e                   	pop    %esi
  803c28:	5f                   	pop    %edi
  803c29:	5d                   	pop    %ebp
  803c2a:	c3                   	ret    
  803c2b:	90                   	nop
  803c2c:	89 fd                	mov    %edi,%ebp
  803c2e:	85 ff                	test   %edi,%edi
  803c30:	75 0b                	jne    803c3d <__umoddi3+0xe9>
  803c32:	b8 01 00 00 00       	mov    $0x1,%eax
  803c37:	31 d2                	xor    %edx,%edx
  803c39:	f7 f7                	div    %edi
  803c3b:	89 c5                	mov    %eax,%ebp
  803c3d:	89 f0                	mov    %esi,%eax
  803c3f:	31 d2                	xor    %edx,%edx
  803c41:	f7 f5                	div    %ebp
  803c43:	89 c8                	mov    %ecx,%eax
  803c45:	f7 f5                	div    %ebp
  803c47:	89 d0                	mov    %edx,%eax
  803c49:	e9 44 ff ff ff       	jmp    803b92 <__umoddi3+0x3e>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	89 c8                	mov    %ecx,%eax
  803c52:	89 f2                	mov    %esi,%edx
  803c54:	83 c4 1c             	add    $0x1c,%esp
  803c57:	5b                   	pop    %ebx
  803c58:	5e                   	pop    %esi
  803c59:	5f                   	pop    %edi
  803c5a:	5d                   	pop    %ebp
  803c5b:	c3                   	ret    
  803c5c:	3b 04 24             	cmp    (%esp),%eax
  803c5f:	72 06                	jb     803c67 <__umoddi3+0x113>
  803c61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c65:	77 0f                	ja     803c76 <__umoddi3+0x122>
  803c67:	89 f2                	mov    %esi,%edx
  803c69:	29 f9                	sub    %edi,%ecx
  803c6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c6f:	89 14 24             	mov    %edx,(%esp)
  803c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c7a:	8b 14 24             	mov    (%esp),%edx
  803c7d:	83 c4 1c             	add    $0x1c,%esp
  803c80:	5b                   	pop    %ebx
  803c81:	5e                   	pop    %esi
  803c82:	5f                   	pop    %edi
  803c83:	5d                   	pop    %ebp
  803c84:	c3                   	ret    
  803c85:	8d 76 00             	lea    0x0(%esi),%esi
  803c88:	2b 04 24             	sub    (%esp),%eax
  803c8b:	19 fa                	sbb    %edi,%edx
  803c8d:	89 d1                	mov    %edx,%ecx
  803c8f:	89 c6                	mov    %eax,%esi
  803c91:	e9 71 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c9c:	72 ea                	jb     803c88 <__umoddi3+0x134>
  803c9e:	89 d9                	mov    %ebx,%ecx
  803ca0:	e9 62 ff ff ff       	jmp    803c07 <__umoddi3+0xb3>
