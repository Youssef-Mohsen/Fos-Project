
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
  80003e:	e8 59 18 00 00       	call   80189c <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 3b 80 00       	push   $0x803be0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 96 14 00 00       	call   8014ec <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 3b 80 00       	push   $0x803be2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 80 14 00 00       	call   8014ec <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 3b 80 00       	push   $0x803be9
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
  800098:	68 f7 3b 80 00       	push   $0x803bf7
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 d0 35 00 00       	call   803676 <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 dc 35 00 00       	call   803690 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 0c 18 00 00       	call   8018cf <sys_get_virtual_time>
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
  8000e6:	e8 e4 35 00 00       	call   8036cf <env_sleep>
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
  8000fe:	e8 cc 17 00 00       	call   8018cf <sys_get_virtual_time>
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
  800126:	e8 a4 35 00 00       	call   8036cf <env_sleep>
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
  80013d:	e8 8d 17 00 00       	call   8018cf <sys_get_virtual_time>
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
  800165:	e8 65 35 00 00       	call   8036cf <env_sleep>
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
  800183:	e8 fb 16 00 00       	call   801883 <sys_getenvindex>
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
  8001f1:	e8 11 14 00 00       	call   801607 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 14 3c 80 00       	push   $0x803c14
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
  800221:	68 3c 3c 80 00       	push   $0x803c3c
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
  800252:	68 64 3c 80 00       	push   $0x803c64
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 bc 3c 80 00       	push   $0x803cbc
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 14 3c 80 00       	push   $0x803c14
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 91 13 00 00       	call   801621 <sys_unlock_cons>
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
  8002a3:	e8 a7 15 00 00       	call   80184f <sys_destroy_env>
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
  8002b4:	e8 fc 15 00 00       	call   8018b5 <sys_exit_env>
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
  800302:	e8 be 12 00 00       	call   8015c5 <sys_cputs>
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
  800379:	e8 47 12 00 00       	call   8015c5 <sys_cputs>
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
  8003c3:	e8 3f 12 00 00       	call   801607 <sys_lock_cons>
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
  8003e3:	e8 39 12 00 00       	call   801621 <sys_unlock_cons>
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
  80042d:	e8 3a 35 00 00       	call   80396c <__udivdi3>
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
  80047d:	e8 fa 35 00 00       	call   803a7c <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 f4 3e 80 00       	add    $0x803ef4,%eax
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
  8005d8:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
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
  8006b9:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 05 3f 80 00       	push   $0x803f05
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
  8006de:	68 0e 3f 80 00       	push   $0x803f0e
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
  80070b:	be 11 3f 80 00       	mov    $0x803f11,%esi
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
  801116:	68 88 40 80 00       	push   $0x804088
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 aa 40 80 00       	push   $0x8040aa
  801125:	e8 59 26 00 00       	call   803783 <_panic>

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
  801136:	e8 35 0a 00 00       	call   801b70 <sys_sbrk>
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
  8011b1:	e8 3e 08 00 00       	call   8019f4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 7e 0d 00 00       	call   801f43 <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 50 08 00 00       	call   801a25 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 17 12 00 00       	call   8023ff <alloc_block_BF>
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
  801349:	e8 59 08 00 00       	call   801ba7 <sys_allocate_user_mem>
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
  801391:	e8 2d 08 00 00       	call   801bc3 <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 60 1a 00 00       	call   802e07 <free_block>
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
  801439:	e8 4d 07 00 00       	call   801b8b <sys_free_user_mem>
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
  801447:	68 b8 40 80 00       	push   $0x8040b8
  80144c:	68 84 00 00 00       	push   $0x84
  801451:	68 e2 40 80 00       	push   $0x8040e2
  801456:	e8 28 23 00 00       	call   803783 <_panic>
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
  8014b9:	e8 d4 02 00 00       	call   801792 <sys_createSharedObject>
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
  8014da:	68 ee 40 80 00       	push   $0x8040ee
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
  8014ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	68 f4 40 80 00       	push   $0x8040f4
  8014fa:	68 a4 00 00 00       	push   $0xa4
  8014ff:	68 e2 40 80 00       	push   $0x8040e2
  801504:	e8 7a 22 00 00       	call   803783 <_panic>

00801509 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	68 18 41 80 00       	push   $0x804118
  801517:	68 bc 00 00 00       	push   $0xbc
  80151c:	68 e2 40 80 00       	push   $0x8040e2
  801521:	e8 5d 22 00 00       	call   803783 <_panic>

00801526 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	68 3c 41 80 00       	push   $0x80413c
  801534:	68 d3 00 00 00       	push   $0xd3
  801539:	68 e2 40 80 00       	push   $0x8040e2
  80153e:	e8 40 22 00 00       	call   803783 <_panic>

00801543 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 62 41 80 00       	push   $0x804162
  801551:	68 df 00 00 00       	push   $0xdf
  801556:	68 e2 40 80 00       	push   $0x8040e2
  80155b:	e8 23 22 00 00       	call   803783 <_panic>

00801560 <shrink>:

}
void shrink(uint32 newSize)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	68 62 41 80 00       	push   $0x804162
  80156e:	68 e4 00 00 00       	push   $0xe4
  801573:	68 e2 40 80 00       	push   $0x8040e2
  801578:	e8 06 22 00 00       	call   803783 <_panic>

0080157d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	68 62 41 80 00       	push   $0x804162
  80158b:	68 e9 00 00 00       	push   $0xe9
  801590:	68 e2 40 80 00       	push   $0x8040e2
  801595:	e8 e9 21 00 00       	call   803783 <_panic>

0080159a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	57                   	push   %edi
  80159e:	56                   	push   %esi
  80159f:	53                   	push   %ebx
  8015a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b5:	cd 30                	int    $0x30
  8015b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5f                   	pop    %edi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	52                   	push   %edx
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	50                   	push   %eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	e8 b2 ff ff ff       	call   80159a <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	90                   	nop
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 02                	push   $0x2
  8015fd:	e8 98 ff ff ff       	call   80159a <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 03                	push   $0x3
  801616:	e8 7f ff ff ff       	call   80159a <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 04                	push   $0x4
  801630:	e8 65 ff ff ff       	call   80159a <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	52                   	push   %edx
  80164b:	50                   	push   %eax
  80164c:	6a 08                	push   $0x8
  80164e:	e8 47 ff ff ff       	call   80159a <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165d:	8b 75 18             	mov    0x18(%ebp),%esi
  801660:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801663:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	51                   	push   %ecx
  80166f:	52                   	push   %edx
  801670:	50                   	push   %eax
  801671:	6a 09                	push   $0x9
  801673:	e8 22 ff ff ff       	call   80159a <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 0a                	push   $0xa
  801695:	e8 00 ff ff ff       	call   80159a <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	6a 0b                	push   $0xb
  8016b0:	e8 e5 fe ff ff       	call   80159a <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 0c                	push   $0xc
  8016c9:	e8 cc fe ff ff       	call   80159a <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 0d                	push   $0xd
  8016e2:	e8 b3 fe ff ff       	call   80159a <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 0e                	push   $0xe
  8016fb:	e8 9a fe ff ff       	call   80159a <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 0f                	push   $0xf
  801714:	e8 81 fe ff ff       	call   80159a <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 10                	push   $0x10
  80172e:	e8 67 fe ff ff       	call   80159a <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 11                	push   $0x11
  801747:	e8 4e fe ff ff       	call   80159a <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	90                   	nop
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_cputc>:

void
sys_cputc(const char c)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	50                   	push   %eax
  80176b:	6a 01                	push   $0x1
  80176d:	e8 28 fe ff ff       	call   80159a <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	90                   	nop
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 14                	push   $0x14
  801787:	e8 0e fe ff ff       	call   80159a <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	90                   	nop
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	8b 45 10             	mov    0x10(%ebp),%eax
  80179b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80179e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	51                   	push   %ecx
  8017ab:	52                   	push   %edx
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	6a 15                	push   $0x15
  8017b2:	e8 e3 fd ff ff       	call   80159a <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	52                   	push   %edx
  8017cc:	50                   	push   %eax
  8017cd:	6a 16                	push   $0x16
  8017cf:	e8 c6 fd ff ff       	call   80159a <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	51                   	push   %ecx
  8017ea:	52                   	push   %edx
  8017eb:	50                   	push   %eax
  8017ec:	6a 17                	push   $0x17
  8017ee:	e8 a7 fd ff ff       	call   80159a <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	52                   	push   %edx
  801808:	50                   	push   %eax
  801809:	6a 18                	push   $0x18
  80180b:	e8 8a fd ff ff       	call   80159a <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 14             	pushl  0x14(%ebp)
  801820:	ff 75 10             	pushl  0x10(%ebp)
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	50                   	push   %eax
  801827:	6a 19                	push   $0x19
  801829:	e8 6c fd ff ff       	call   80159a <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	50                   	push   %eax
  801842:	6a 1a                	push   $0x1a
  801844:	e8 51 fd ff ff       	call   80159a <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	50                   	push   %eax
  80185e:	6a 1b                	push   $0x1b
  801860:	e8 35 fd ff ff       	call   80159a <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 05                	push   $0x5
  801879:	e8 1c fd ff ff       	call   80159a <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 06                	push   $0x6
  801892:	e8 03 fd ff ff       	call   80159a <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 07                	push   $0x7
  8018ab:	e8 ea fc ff ff       	call   80159a <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 1c                	push   $0x1c
  8018c4:	e8 d1 fc ff ff       	call   80159a <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d8:	8d 50 04             	lea    0x4(%eax),%edx
  8018db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 1d                	push   $0x1d
  8018e8:	e8 ad fc ff ff       	call   80159a <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f9:	89 01                	mov    %eax,(%ecx)
  8018fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	c9                   	leave  
  801902:	c2 04 00             	ret    $0x4

00801905 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 13                	push   $0x13
  801917:	e8 7e fc ff ff       	call   80159a <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
	return ;
  80191f:	90                   	nop
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_rcr2>:
uint32 sys_rcr2()
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 1e                	push   $0x1e
  801931:	e8 64 fc ff ff       	call   80159a <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801947:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	50                   	push   %eax
  801954:	6a 1f                	push   $0x1f
  801956:	e8 3f fc ff ff       	call   80159a <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <rsttst>:
void rsttst()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 21                	push   $0x21
  801970:	e8 25 fc ff ff       	call   80159a <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801987:	8b 55 18             	mov    0x18(%ebp),%edx
  80198a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	ff 75 10             	pushl  0x10(%ebp)
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 20                	push   $0x20
  80199b:	e8 fa fb ff ff       	call   80159a <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <chktst>:
void chktst(uint32 n)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 22                	push   $0x22
  8019b6:	e8 df fb ff ff       	call   80159a <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019be:	90                   	nop
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <inctst>:

void inctst()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 23                	push   $0x23
  8019d0:	e8 c5 fb ff ff       	call   80159a <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <gettst>:
uint32 gettst()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 24                	push   $0x24
  8019ea:	e8 ab fb ff ff       	call   80159a <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 25                	push   $0x25
  801a06:	e8 8f fb ff ff       	call   80159a <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
  801a0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a11:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a15:	75 07                	jne    801a1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a17:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1c:	eb 05                	jmp    801a23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 25                	push   $0x25
  801a37:	e8 5e fb ff ff       	call   80159a <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
  801a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a42:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a46:	75 07                	jne    801a4f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a48:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4d:	eb 05                	jmp    801a54 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 25                	push   $0x25
  801a68:	e8 2d fb ff ff       	call   80159a <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
  801a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a73:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a77:	75 07                	jne    801a80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	eb 05                	jmp    801a85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 25                	push   $0x25
  801a99:	e8 fc fa ff ff       	call   80159a <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
  801aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa8:	75 07                	jne    801ab1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	eb 05                	jmp    801ab6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 26                	push   $0x26
  801ac8:	e8 cd fa ff ff       	call   80159a <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad0:	90                   	nop
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ada:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	53                   	push   %ebx
  801ae6:	51                   	push   %ecx
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 27                	push   $0x27
  801aeb:	e8 aa fa ff ff       	call   80159a <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 28                	push   $0x28
  801b0b:	e8 8a fa ff ff       	call   80159a <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b18:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	51                   	push   %ecx
  801b24:	ff 75 10             	pushl  0x10(%ebp)
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	6a 29                	push   $0x29
  801b2b:	e8 6a fa ff ff       	call   80159a <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 12                	push   $0x12
  801b47:	e8 4e fa ff ff       	call   80159a <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 2a                	push   $0x2a
  801b65:	e8 30 fa ff ff       	call   80159a <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 2b                	push   $0x2b
  801b81:	e8 14 fa ff ff       	call   80159a <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	ff 75 08             	pushl  0x8(%ebp)
  801b9a:	6a 2c                	push   $0x2c
  801b9c:	e8 f9 f9 ff ff       	call   80159a <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return;
  801ba4:	90                   	nop
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 2d                	push   $0x2d
  801bb8:	e8 dd f9 ff ff       	call   80159a <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	83 e8 04             	sub    $0x4,%eax
  801bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd5:	8b 00                	mov    (%eax),%eax
  801bd7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	83 e8 04             	sub    $0x4,%eax
  801be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bee:	8b 00                	mov    (%eax),%eax
  801bf0:	83 e0 01             	and    $0x1,%eax
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	0f 94 c0             	sete   %al
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0a:	83 f8 02             	cmp    $0x2,%eax
  801c0d:	74 2b                	je     801c3a <alloc_block+0x40>
  801c0f:	83 f8 02             	cmp    $0x2,%eax
  801c12:	7f 07                	jg     801c1b <alloc_block+0x21>
  801c14:	83 f8 01             	cmp    $0x1,%eax
  801c17:	74 0e                	je     801c27 <alloc_block+0x2d>
  801c19:	eb 58                	jmp    801c73 <alloc_block+0x79>
  801c1b:	83 f8 03             	cmp    $0x3,%eax
  801c1e:	74 2d                	je     801c4d <alloc_block+0x53>
  801c20:	83 f8 04             	cmp    $0x4,%eax
  801c23:	74 3b                	je     801c60 <alloc_block+0x66>
  801c25:	eb 4c                	jmp    801c73 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c27:	83 ec 0c             	sub    $0xc,%esp
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	e8 11 03 00 00       	call   801f43 <alloc_block_FF>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c38:	eb 4a                	jmp    801c84 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	e8 fa 19 00 00       	call   80363f <alloc_block_NF>
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c4b:	eb 37                	jmp    801c84 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	e8 a7 07 00 00       	call   8023ff <alloc_block_BF>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c5e:	eb 24                	jmp    801c84 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 b7 19 00 00       	call   803622 <alloc_block_WF>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c71:	eb 11                	jmp    801c84 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	68 74 41 80 00       	push   $0x804174
  801c7b:	e8 10 e7 ff ff       	call   800390 <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp
		break;
  801c83:	90                   	nop
	}
	return va;
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	53                   	push   %ebx
  801c8d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	68 94 41 80 00       	push   $0x804194
  801c98:	e8 f3 e6 ff ff       	call   800390 <cprintf>
  801c9d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	68 bf 41 80 00       	push   $0x8041bf
  801ca8:	e8 e3 e6 ff ff       	call   800390 <cprintf>
  801cad:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cb6:	eb 37                	jmp    801cef <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbe:	e8 19 ff ff ff       	call   801bdc <is_free_block>
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	0f be d8             	movsbl %al,%ebx
  801cc9:	83 ec 0c             	sub    $0xc,%esp
  801ccc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccf:	e8 ef fe ff ff       	call   801bc3 <get_block_size>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	53                   	push   %ebx
  801cdb:	50                   	push   %eax
  801cdc:	68 d7 41 80 00       	push   $0x8041d7
  801ce1:	e8 aa e6 ff ff       	call   800390 <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf3:	74 07                	je     801cfc <print_blocks_list+0x73>
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	8b 00                	mov    (%eax),%eax
  801cfa:	eb 05                	jmp    801d01 <print_blocks_list+0x78>
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	89 45 10             	mov    %eax,0x10(%ebp)
  801d04:	8b 45 10             	mov    0x10(%ebp),%eax
  801d07:	85 c0                	test   %eax,%eax
  801d09:	75 ad                	jne    801cb8 <print_blocks_list+0x2f>
  801d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d0f:	75 a7                	jne    801cb8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	68 94 41 80 00       	push   $0x804194
  801d19:	e8 72 e6 ff ff       	call   800390 <cprintf>
  801d1e:	83 c4 10             	add    $0x10,%esp

}
  801d21:	90                   	nop
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d30:	83 e0 01             	and    $0x1,%eax
  801d33:	85 c0                	test   %eax,%eax
  801d35:	74 03                	je     801d3a <initialize_dynamic_allocator+0x13>
  801d37:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3e:	0f 84 c7 01 00 00    	je     801f0b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d44:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801d4b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	01 d0                	add    %edx,%eax
  801d56:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801d5b:	0f 87 ad 01 00 00    	ja     801f0e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	85 c0                	test   %eax,%eax
  801d66:	0f 89 a5 01 00 00    	jns    801f11 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	83 e8 04             	sub    $0x4,%eax
  801d77:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801d7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801d83:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8b:	e9 87 00 00 00       	jmp    801e17 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801d90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d94:	75 14                	jne    801daa <initialize_dynamic_allocator+0x83>
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	68 ef 41 80 00       	push   $0x8041ef
  801d9e:	6a 79                	push   $0x79
  801da0:	68 0d 42 80 00       	push   $0x80420d
  801da5:	e8 d9 19 00 00       	call   803783 <_panic>
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	8b 00                	mov    (%eax),%eax
  801daf:	85 c0                	test   %eax,%eax
  801db1:	74 10                	je     801dc3 <initialize_dynamic_allocator+0x9c>
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbb:	8b 52 04             	mov    0x4(%edx),%edx
  801dbe:	89 50 04             	mov    %edx,0x4(%eax)
  801dc1:	eb 0b                	jmp    801dce <initialize_dynamic_allocator+0xa7>
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	8b 40 04             	mov    0x4(%eax),%eax
  801dc9:	a3 30 50 80 00       	mov    %eax,0x805030
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	8b 40 04             	mov    0x4(%eax),%eax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	74 0f                	je     801de7 <initialize_dynamic_allocator+0xc0>
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 40 04             	mov    0x4(%eax),%eax
  801dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de1:	8b 12                	mov    (%edx),%edx
  801de3:	89 10                	mov    %edx,(%eax)
  801de5:	eb 0a                	jmp    801df1 <initialize_dynamic_allocator+0xca>
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 00                	mov    (%eax),%eax
  801dec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e04:	a1 38 50 80 00       	mov    0x805038,%eax
  801e09:	48                   	dec    %eax
  801e0a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e0f:	a1 34 50 80 00       	mov    0x805034,%eax
  801e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1b:	74 07                	je     801e24 <initialize_dynamic_allocator+0xfd>
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	eb 05                	jmp    801e29 <initialize_dynamic_allocator+0x102>
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	a3 34 50 80 00       	mov    %eax,0x805034
  801e2e:	a1 34 50 80 00       	mov    0x805034,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 85 55 ff ff ff    	jne    801d90 <initialize_dynamic_allocator+0x69>
  801e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3f:	0f 85 4b ff ff ff    	jne    801d90 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801e54:	a1 44 50 80 00       	mov    0x805044,%eax
  801e59:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801e5e:	a1 40 50 80 00       	mov    0x805040,%eax
  801e63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	83 c0 08             	add    $0x8,%eax
  801e6f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	83 c0 04             	add    $0x4,%eax
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	83 ea 08             	sub    $0x8,%edx
  801e7e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	01 d0                	add    %edx,%eax
  801e88:	83 e8 08             	sub    $0x8,%eax
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	83 ea 08             	sub    $0x8,%edx
  801e91:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801ea6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaa:	75 17                	jne    801ec3 <initialize_dynamic_allocator+0x19c>
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 28 42 80 00       	push   $0x804228
  801eb4:	68 90 00 00 00       	push   $0x90
  801eb9:	68 0d 42 80 00       	push   $0x80420d
  801ebe:	e8 c0 18 00 00       	call   803783 <_panic>
  801ec3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecc:	89 10                	mov    %edx,(%eax)
  801ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed1:	8b 00                	mov    (%eax),%eax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	74 0d                	je     801ee4 <initialize_dynamic_allocator+0x1bd>
  801ed7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801edc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801edf:	89 50 04             	mov    %edx,0x4(%eax)
  801ee2:	eb 08                	jmp    801eec <initialize_dynamic_allocator+0x1c5>
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	a3 30 50 80 00       	mov    %eax,0x805030
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801efe:	a1 38 50 80 00       	mov    0x805038,%eax
  801f03:	40                   	inc    %eax
  801f04:	a3 38 50 80 00       	mov    %eax,0x805038
  801f09:	eb 07                	jmp    801f12 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f0b:	90                   	nop
  801f0c:	eb 04                	jmp    801f12 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f0e:	90                   	nop
  801f0f:	eb 01                	jmp    801f12 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f11:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	83 e8 04             	sub    $0x4,%eax
  801f2e:	8b 00                	mov    (%eax),%eax
  801f30:	83 e0 fe             	and    $0xfffffffe,%eax
  801f33:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	01 c2                	add    %eax,%edx
  801f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3e:	89 02                	mov    %eax,(%edx)
}
  801f40:	90                   	nop
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	83 e0 01             	and    $0x1,%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 03                	je     801f56 <alloc_block_FF+0x13>
  801f53:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801f56:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801f5a:	77 07                	ja     801f63 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801f5c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801f63:	a1 24 50 80 00       	mov    0x805024,%eax
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	75 73                	jne    801fdf <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	83 c0 10             	add    $0x10,%eax
  801f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801f75:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f82:	01 d0                	add    %edx,%eax
  801f84:	48                   	dec    %eax
  801f85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f90:	f7 75 ec             	divl   -0x14(%ebp)
  801f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f96:	29 d0                	sub    %edx,%eax
  801f98:	c1 e8 0c             	shr    $0xc,%eax
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	50                   	push   %eax
  801f9f:	e8 86 f1 ff ff       	call   80112a <sbrk>
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	6a 00                	push   $0x0
  801faf:	e8 76 f1 ff ff       	call   80112a <sbrk>
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  801fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fbd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	50                   	push   %eax
  801fc4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc7:	e8 5b fd ff ff       	call   801d27 <initialize_dynamic_allocator>
  801fcc:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	68 4b 42 80 00       	push   $0x80424b
  801fd7:	e8 b4 e3 ff ff       	call   800390 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  801fdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe3:	75 0a                	jne    801fef <alloc_block_FF+0xac>
	        return NULL;
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	e9 0e 04 00 00       	jmp    8023fd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  801fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  801ff6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffe:	e9 f3 02 00 00       	jmp    8022f6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	ff 75 bc             	pushl  -0x44(%ebp)
  80200f:	e8 af fb ff ff       	call   801bc3 <get_block_size>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	83 c0 08             	add    $0x8,%eax
  802020:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802023:	0f 87 c5 02 00 00    	ja     8022ee <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	83 c0 18             	add    $0x18,%eax
  80202f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802032:	0f 87 19 02 00 00    	ja     802251 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802038:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80203b:	2b 45 08             	sub    0x8(%ebp),%eax
  80203e:	83 e8 08             	sub    $0x8,%eax
  802041:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8d 50 08             	lea    0x8(%eax),%edx
  80204a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80204d:	01 d0                	add    %edx,%eax
  80204f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	83 c0 08             	add    $0x8,%eax
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	6a 01                	push   $0x1
  80205d:	50                   	push   %eax
  80205e:	ff 75 bc             	pushl  -0x44(%ebp)
  802061:	e8 ae fe ff ff       	call   801f14 <set_block_data>
  802066:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	8b 40 04             	mov    0x4(%eax),%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	75 68                	jne    8020db <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802073:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802077:	75 17                	jne    802090 <alloc_block_FF+0x14d>
  802079:	83 ec 04             	sub    $0x4,%esp
  80207c:	68 28 42 80 00       	push   $0x804228
  802081:	68 d7 00 00 00       	push   $0xd7
  802086:	68 0d 42 80 00       	push   $0x80420d
  80208b:	e8 f3 16 00 00       	call   803783 <_panic>
  802090:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802096:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802099:	89 10                	mov    %edx,(%eax)
  80209b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	74 0d                	je     8020b1 <alloc_block_FF+0x16e>
  8020a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020a9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020ac:	89 50 04             	mov    %edx,0x4(%eax)
  8020af:	eb 08                	jmp    8020b9 <alloc_block_FF+0x176>
  8020b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8020b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8020d0:	40                   	inc    %eax
  8020d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8020d6:	e9 dc 00 00 00       	jmp    8021b7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 65                	jne    802149 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020e4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020e8:	75 17                	jne    802101 <alloc_block_FF+0x1be>
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	68 5c 42 80 00       	push   $0x80425c
  8020f2:	68 db 00 00 00       	push   $0xdb
  8020f7:	68 0d 42 80 00       	push   $0x80420d
  8020fc:	e8 82 16 00 00       	call   803783 <_panic>
  802101:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802107:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80210a:	89 50 04             	mov    %edx,0x4(%eax)
  80210d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802110:	8b 40 04             	mov    0x4(%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0c                	je     802123 <alloc_block_FF+0x1e0>
  802117:	a1 30 50 80 00       	mov    0x805030,%eax
  80211c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80211f:	89 10                	mov    %edx,(%eax)
  802121:	eb 08                	jmp    80212b <alloc_block_FF+0x1e8>
  802123:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802126:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80212b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212e:	a3 30 50 80 00       	mov    %eax,0x805030
  802133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80213c:	a1 38 50 80 00       	mov    0x805038,%eax
  802141:	40                   	inc    %eax
  802142:	a3 38 50 80 00       	mov    %eax,0x805038
  802147:	eb 6e                	jmp    8021b7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802149:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214d:	74 06                	je     802155 <alloc_block_FF+0x212>
  80214f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802153:	75 17                	jne    80216c <alloc_block_FF+0x229>
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 80 42 80 00       	push   $0x804280
  80215d:	68 df 00 00 00       	push   $0xdf
  802162:	68 0d 42 80 00       	push   $0x80420d
  802167:	e8 17 16 00 00       	call   803783 <_panic>
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 10                	mov    (%eax),%edx
  802171:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0b                	je     80218a <alloc_block_FF+0x247>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802190:	89 10                	mov    %edx,(%eax)
  802192:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	75 08                	jne    8021ac <alloc_block_FF+0x269>
  8021a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8021ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b1:	40                   	inc    %eax
  8021b2:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8021b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bb:	75 17                	jne    8021d4 <alloc_block_FF+0x291>
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	68 ef 41 80 00       	push   $0x8041ef
  8021c5:	68 e1 00 00 00       	push   $0xe1
  8021ca:	68 0d 42 80 00       	push   $0x80420d
  8021cf:	e8 af 15 00 00       	call   803783 <_panic>
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 10                	je     8021ed <alloc_block_FF+0x2aa>
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e5:	8b 52 04             	mov    0x4(%edx),%edx
  8021e8:	89 50 04             	mov    %edx,0x4(%eax)
  8021eb:	eb 0b                	jmp    8021f8 <alloc_block_FF+0x2b5>
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	8b 40 04             	mov    0x4(%eax),%eax
  8021f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 40 04             	mov    0x4(%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0f                	je     802211 <alloc_block_FF+0x2ce>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220b:	8b 12                	mov    (%edx),%edx
  80220d:	89 10                	mov    %edx,(%eax)
  80220f:	eb 0a                	jmp    80221b <alloc_block_FF+0x2d8>
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222e:	a1 38 50 80 00       	mov    0x805038,%eax
  802233:	48                   	dec    %eax
  802234:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	6a 00                	push   $0x0
  80223e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802241:	ff 75 b0             	pushl  -0x50(%ebp)
  802244:	e8 cb fc ff ff       	call   801f14 <set_block_data>
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	e9 95 00 00 00       	jmp    8022e6 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	6a 01                	push   $0x1
  802256:	ff 75 b8             	pushl  -0x48(%ebp)
  802259:	ff 75 bc             	pushl  -0x44(%ebp)
  80225c:	e8 b3 fc ff ff       	call   801f14 <set_block_data>
  802261:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802268:	75 17                	jne    802281 <alloc_block_FF+0x33e>
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 ef 41 80 00       	push   $0x8041ef
  802272:	68 e8 00 00 00       	push   $0xe8
  802277:	68 0d 42 80 00       	push   $0x80420d
  80227c:	e8 02 15 00 00       	call   803783 <_panic>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 10                	je     80229a <alloc_block_FF+0x357>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802292:	8b 52 04             	mov    0x4(%edx),%edx
  802295:	89 50 04             	mov    %edx,0x4(%eax)
  802298:	eb 0b                	jmp    8022a5 <alloc_block_FF+0x362>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 04             	mov    0x4(%eax),%eax
  8022a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 04             	mov    0x4(%eax),%eax
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	74 0f                	je     8022be <alloc_block_FF+0x37b>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 04             	mov    0x4(%eax),%eax
  8022b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b8:	8b 12                	mov    (%edx),%edx
  8022ba:	89 10                	mov    %edx,(%eax)
  8022bc:	eb 0a                	jmp    8022c8 <alloc_block_FF+0x385>
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022db:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e0:	48                   	dec    %eax
  8022e1:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8022e6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022e9:	e9 0f 01 00 00       	jmp    8023fd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022ee:	a1 34 50 80 00       	mov    0x805034,%eax
  8022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fa:	74 07                	je     802303 <alloc_block_FF+0x3c0>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	eb 05                	jmp    802308 <alloc_block_FF+0x3c5>
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	a3 34 50 80 00       	mov    %eax,0x805034
  80230d:	a1 34 50 80 00       	mov    0x805034,%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	0f 85 e9 fc ff ff    	jne    802003 <alloc_block_FF+0xc0>
  80231a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231e:	0f 85 df fc ff ff    	jne    802003 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	83 c0 08             	add    $0x8,%eax
  80232a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80232d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802334:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802337:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80233a:	01 d0                	add    %edx,%eax
  80233c:	48                   	dec    %eax
  80233d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802340:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802343:	ba 00 00 00 00       	mov    $0x0,%edx
  802348:	f7 75 d8             	divl   -0x28(%ebp)
  80234b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234e:	29 d0                	sub    %edx,%eax
  802350:	c1 e8 0c             	shr    $0xc,%eax
  802353:	83 ec 0c             	sub    $0xc,%esp
  802356:	50                   	push   %eax
  802357:	e8 ce ed ff ff       	call   80112a <sbrk>
  80235c:	83 c4 10             	add    $0x10,%esp
  80235f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802362:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802366:	75 0a                	jne    802372 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
  80236d:	e9 8b 00 00 00       	jmp    8023fd <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802372:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802379:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80237c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80237f:	01 d0                	add    %edx,%eax
  802381:	48                   	dec    %eax
  802382:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802385:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802388:	ba 00 00 00 00       	mov    $0x0,%edx
  80238d:	f7 75 cc             	divl   -0x34(%ebp)
  802390:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802393:	29 d0                	sub    %edx,%eax
  802395:	8d 50 fc             	lea    -0x4(%eax),%edx
  802398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80239b:	01 d0                	add    %edx,%eax
  80239d:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8023ad:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8023b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023ba:	01 d0                	add    %edx,%eax
  8023bc:	48                   	dec    %eax
  8023bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8023c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c8:	f7 75 c4             	divl   -0x3c(%ebp)
  8023cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023ce:	29 d0                	sub    %edx,%eax
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	6a 01                	push   $0x1
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8023d9:	e8 36 fb ff ff       	call   801f14 <set_block_data>
  8023de:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8023e1:	83 ec 0c             	sub    $0xc,%esp
  8023e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8023e7:	e8 1b 0a 00 00       	call   802e07 <free_block>
  8023ec:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	e8 49 fb ff ff       	call   801f43 <alloc_block_FF>
  8023fa:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	83 e0 01             	and    $0x1,%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 03                	je     802412 <alloc_block_BF+0x13>
  80240f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802412:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802416:	77 07                	ja     80241f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802418:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80241f:	a1 24 50 80 00       	mov    0x805024,%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	75 73                	jne    80249b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	83 c0 10             	add    $0x10,%eax
  80242e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802431:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802438:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80243b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243e:	01 d0                	add    %edx,%eax
  802440:	48                   	dec    %eax
  802441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802447:	ba 00 00 00 00       	mov    $0x0,%edx
  80244c:	f7 75 e0             	divl   -0x20(%ebp)
  80244f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802452:	29 d0                	sub    %edx,%eax
  802454:	c1 e8 0c             	shr    $0xc,%eax
  802457:	83 ec 0c             	sub    $0xc,%esp
  80245a:	50                   	push   %eax
  80245b:	e8 ca ec ff ff       	call   80112a <sbrk>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802466:	83 ec 0c             	sub    $0xc,%esp
  802469:	6a 00                	push   $0x0
  80246b:	e8 ba ec ff ff       	call   80112a <sbrk>
  802470:	83 c4 10             	add    $0x10,%esp
  802473:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802476:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802479:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80247c:	83 ec 08             	sub    $0x8,%esp
  80247f:	50                   	push   %eax
  802480:	ff 75 d8             	pushl  -0x28(%ebp)
  802483:	e8 9f f8 ff ff       	call   801d27 <initialize_dynamic_allocator>
  802488:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80248b:	83 ec 0c             	sub    $0xc,%esp
  80248e:	68 4b 42 80 00       	push   $0x80424b
  802493:	e8 f8 de ff ff       	call   800390 <cprintf>
  802498:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80249b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8024a9:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8024b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8024b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bf:	e9 1d 01 00 00       	jmp    8025e1 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	ff 75 a8             	pushl  -0x58(%ebp)
  8024d0:	e8 ee f6 ff ff       	call   801bc3 <get_block_size>
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	83 c0 08             	add    $0x8,%eax
  8024e1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024e4:	0f 87 ef 00 00 00    	ja     8025d9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	83 c0 18             	add    $0x18,%eax
  8024f0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024f3:	77 1d                	ja     802512 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8024f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024fb:	0f 86 d8 00 00 00    	jbe    8025d9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802501:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802504:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802507:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80250a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80250d:	e9 c7 00 00 00       	jmp    8025d9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	83 c0 08             	add    $0x8,%eax
  802518:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80251b:	0f 85 9d 00 00 00    	jne    8025be <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802521:	83 ec 04             	sub    $0x4,%esp
  802524:	6a 01                	push   $0x1
  802526:	ff 75 a4             	pushl  -0x5c(%ebp)
  802529:	ff 75 a8             	pushl  -0x58(%ebp)
  80252c:	e8 e3 f9 ff ff       	call   801f14 <set_block_data>
  802531:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802538:	75 17                	jne    802551 <alloc_block_BF+0x152>
  80253a:	83 ec 04             	sub    $0x4,%esp
  80253d:	68 ef 41 80 00       	push   $0x8041ef
  802542:	68 2c 01 00 00       	push   $0x12c
  802547:	68 0d 42 80 00       	push   $0x80420d
  80254c:	e8 32 12 00 00       	call   803783 <_panic>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 10                	je     80256a <alloc_block_BF+0x16b>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802562:	8b 52 04             	mov    0x4(%edx),%edx
  802565:	89 50 04             	mov    %edx,0x4(%eax)
  802568:	eb 0b                	jmp    802575 <alloc_block_BF+0x176>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	a3 30 50 80 00       	mov    %eax,0x805030
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	74 0f                	je     80258e <alloc_block_BF+0x18f>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	8b 12                	mov    (%edx),%edx
  80258a:	89 10                	mov    %edx,(%eax)
  80258c:	eb 0a                	jmp    802598 <alloc_block_BF+0x199>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b0:	48                   	dec    %eax
  8025b1:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8025b6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025b9:	e9 24 04 00 00       	jmp    8029e2 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025c4:	76 13                	jbe    8025d9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8025c6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8025cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8025d3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8025d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	74 07                	je     8025ee <alloc_block_BF+0x1ef>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	eb 05                	jmp    8025f3 <alloc_block_BF+0x1f4>
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025f8:	a1 34 50 80 00       	mov    0x805034,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 85 bf fe ff ff    	jne    8024c4 <alloc_block_BF+0xc5>
  802605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802609:	0f 85 b5 fe ff ff    	jne    8024c4 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80260f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802613:	0f 84 26 02 00 00    	je     80283f <alloc_block_BF+0x440>
  802619:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80261d:	0f 85 1c 02 00 00    	jne    80283f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	2b 45 08             	sub    0x8(%ebp),%eax
  802629:	83 e8 08             	sub    $0x8,%eax
  80262c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	8d 50 08             	lea    0x8(%eax),%edx
  802635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802638:	01 d0                	add    %edx,%eax
  80263a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	83 c0 08             	add    $0x8,%eax
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	6a 01                	push   $0x1
  802648:	50                   	push   %eax
  802649:	ff 75 f0             	pushl  -0x10(%ebp)
  80264c:	e8 c3 f8 ff ff       	call   801f14 <set_block_data>
  802651:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	75 68                	jne    8026c6 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80265e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802662:	75 17                	jne    80267b <alloc_block_BF+0x27c>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 28 42 80 00       	push   $0x804228
  80266c:	68 45 01 00 00       	push   $0x145
  802671:	68 0d 42 80 00       	push   $0x80420d
  802676:	e8 08 11 00 00       	call   803783 <_panic>
  80267b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802681:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802684:	89 10                	mov    %edx,(%eax)
  802686:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0d                	je     80269c <alloc_block_BF+0x29d>
  80268f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802694:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802697:	89 50 04             	mov    %edx,0x4(%eax)
  80269a:	eb 08                	jmp    8026a4 <alloc_block_BF+0x2a5>
  80269c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269f:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026a7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8026bb:	40                   	inc    %eax
  8026bc:	a3 38 50 80 00       	mov    %eax,0x805038
  8026c1:	e9 dc 00 00 00       	jmp    8027a2 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8026c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 65                	jne    802734 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026d3:	75 17                	jne    8026ec <alloc_block_BF+0x2ed>
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	68 5c 42 80 00       	push   $0x80425c
  8026dd:	68 4a 01 00 00       	push   $0x14a
  8026e2:	68 0d 42 80 00       	push   $0x80420d
  8026e7:	e8 97 10 00 00       	call   803783 <_panic>
  8026ec:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f5:	89 50 04             	mov    %edx,0x4(%eax)
  8026f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 0c                	je     80270e <alloc_block_BF+0x30f>
  802702:	a1 30 50 80 00       	mov    0x805030,%eax
  802707:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80270a:	89 10                	mov    %edx,(%eax)
  80270c:	eb 08                	jmp    802716 <alloc_block_BF+0x317>
  80270e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802711:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802716:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802719:	a3 30 50 80 00       	mov    %eax,0x805030
  80271e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802727:	a1 38 50 80 00       	mov    0x805038,%eax
  80272c:	40                   	inc    %eax
  80272d:	a3 38 50 80 00       	mov    %eax,0x805038
  802732:	eb 6e                	jmp    8027a2 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802738:	74 06                	je     802740 <alloc_block_BF+0x341>
  80273a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80273e:	75 17                	jne    802757 <alloc_block_BF+0x358>
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 80 42 80 00       	push   $0x804280
  802748:	68 4f 01 00 00       	push   $0x14f
  80274d:	68 0d 42 80 00       	push   $0x80420d
  802752:	e8 2c 10 00 00       	call   803783 <_panic>
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 10                	mov    (%eax),%edx
  80275c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 0b                	je     802775 <alloc_block_BF+0x376>
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802772:	89 50 04             	mov    %edx,0x4(%eax)
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80277b:	89 10                	mov    %edx,(%eax)
  80277d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802783:	89 50 04             	mov    %edx,0x4(%eax)
  802786:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	75 08                	jne    802797 <alloc_block_BF+0x398>
  80278f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802792:	a3 30 50 80 00       	mov    %eax,0x805030
  802797:	a1 38 50 80 00       	mov    0x805038,%eax
  80279c:	40                   	inc    %eax
  80279d:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a6:	75 17                	jne    8027bf <alloc_block_BF+0x3c0>
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	68 ef 41 80 00       	push   $0x8041ef
  8027b0:	68 51 01 00 00       	push   $0x151
  8027b5:	68 0d 42 80 00       	push   $0x80420d
  8027ba:	e8 c4 0f 00 00       	call   803783 <_panic>
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 10                	je     8027d8 <alloc_block_BF+0x3d9>
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d0:	8b 52 04             	mov    0x4(%edx),%edx
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	eb 0b                	jmp    8027e3 <alloc_block_BF+0x3e4>
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	a3 30 50 80 00       	mov    %eax,0x805030
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0f                	je     8027fc <alloc_block_BF+0x3fd>
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f6:	8b 12                	mov    (%edx),%edx
  8027f8:	89 10                	mov    %edx,(%eax)
  8027fa:	eb 0a                	jmp    802806 <alloc_block_BF+0x407>
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802819:	a1 38 50 80 00       	mov    0x805038,%eax
  80281e:	48                   	dec    %eax
  80281f:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	6a 00                	push   $0x0
  802829:	ff 75 d0             	pushl  -0x30(%ebp)
  80282c:	ff 75 cc             	pushl  -0x34(%ebp)
  80282f:	e8 e0 f6 ff ff       	call   801f14 <set_block_data>
  802834:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	e9 a3 01 00 00       	jmp    8029e2 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80283f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802843:	0f 85 9d 00 00 00    	jne    8028e6 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802849:	83 ec 04             	sub    $0x4,%esp
  80284c:	6a 01                	push   $0x1
  80284e:	ff 75 ec             	pushl  -0x14(%ebp)
  802851:	ff 75 f0             	pushl  -0x10(%ebp)
  802854:	e8 bb f6 ff ff       	call   801f14 <set_block_data>
  802859:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80285c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802860:	75 17                	jne    802879 <alloc_block_BF+0x47a>
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 ef 41 80 00       	push   $0x8041ef
  80286a:	68 58 01 00 00       	push   $0x158
  80286f:	68 0d 42 80 00       	push   $0x80420d
  802874:	e8 0a 0f 00 00       	call   803783 <_panic>
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 10                	je     802892 <alloc_block_BF+0x493>
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288a:	8b 52 04             	mov    0x4(%edx),%edx
  80288d:	89 50 04             	mov    %edx,0x4(%eax)
  802890:	eb 0b                	jmp    80289d <alloc_block_BF+0x49e>
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	a3 30 50 80 00       	mov    %eax,0x805030
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 0f                	je     8028b6 <alloc_block_BF+0x4b7>
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b0:	8b 12                	mov    (%edx),%edx
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	eb 0a                	jmp    8028c0 <alloc_block_BF+0x4c1>
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d8:	48                   	dec    %eax
  8028d9:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	e9 fc 00 00 00       	jmp    8029e2 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	83 c0 08             	add    $0x8,%eax
  8028ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8028ef:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802902:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802905:	ba 00 00 00 00       	mov    $0x0,%edx
  80290a:	f7 75 c4             	divl   -0x3c(%ebp)
  80290d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802910:	29 d0                	sub    %edx,%eax
  802912:	c1 e8 0c             	shr    $0xc,%eax
  802915:	83 ec 0c             	sub    $0xc,%esp
  802918:	50                   	push   %eax
  802919:	e8 0c e8 ff ff       	call   80112a <sbrk>
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802924:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802928:	75 0a                	jne    802934 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80292a:	b8 00 00 00 00       	mov    $0x0,%eax
  80292f:	e9 ae 00 00 00       	jmp    8029e2 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802934:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80293b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80293e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802941:	01 d0                	add    %edx,%eax
  802943:	48                   	dec    %eax
  802944:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802947:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80294a:	ba 00 00 00 00       	mov    $0x0,%edx
  80294f:	f7 75 b8             	divl   -0x48(%ebp)
  802952:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802955:	29 d0                	sub    %edx,%eax
  802957:	8d 50 fc             	lea    -0x4(%eax),%edx
  80295a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80295d:	01 d0                	add    %edx,%eax
  80295f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802964:	a1 40 50 80 00       	mov    0x805040,%eax
  802969:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80296f:	83 ec 0c             	sub    $0xc,%esp
  802972:	68 b4 42 80 00       	push   $0x8042b4
  802977:	e8 14 da ff ff       	call   800390 <cprintf>
  80297c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80297f:	83 ec 08             	sub    $0x8,%esp
  802982:	ff 75 bc             	pushl  -0x44(%ebp)
  802985:	68 b9 42 80 00       	push   $0x8042b9
  80298a:	e8 01 da ff ff       	call   800390 <cprintf>
  80298f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802992:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802999:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80299c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299f:	01 d0                	add    %edx,%eax
  8029a1:	48                   	dec    %eax
  8029a2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029a5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ad:	f7 75 b0             	divl   -0x50(%ebp)
  8029b0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029b3:	29 d0                	sub    %edx,%eax
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	6a 01                	push   $0x1
  8029ba:	50                   	push   %eax
  8029bb:	ff 75 bc             	pushl  -0x44(%ebp)
  8029be:	e8 51 f5 ff ff       	call   801f14 <set_block_data>
  8029c3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8029c6:	83 ec 0c             	sub    $0xc,%esp
  8029c9:	ff 75 bc             	pushl  -0x44(%ebp)
  8029cc:	e8 36 04 00 00       	call   802e07 <free_block>
  8029d1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8029d4:	83 ec 0c             	sub    $0xc,%esp
  8029d7:	ff 75 08             	pushl  0x8(%ebp)
  8029da:	e8 20 fa ff ff       	call   8023ff <alloc_block_BF>
  8029df:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8029e2:	c9                   	leave  
  8029e3:	c3                   	ret    

008029e4 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
  8029e7:	53                   	push   %ebx
  8029e8:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8029eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8029f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fd:	74 1e                	je     802a1d <merging+0x39>
  8029ff:	ff 75 08             	pushl  0x8(%ebp)
  802a02:	e8 bc f1 ff ff       	call   801bc3 <get_block_size>
  802a07:	83 c4 04             	add    $0x4,%esp
  802a0a:	89 c2                	mov    %eax,%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a14:	75 07                	jne    802a1d <merging+0x39>
		prev_is_free = 1;
  802a16:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a21:	74 1e                	je     802a41 <merging+0x5d>
  802a23:	ff 75 10             	pushl  0x10(%ebp)
  802a26:	e8 98 f1 ff ff       	call   801bc3 <get_block_size>
  802a2b:	83 c4 04             	add    $0x4,%esp
  802a2e:	89 c2                	mov    %eax,%edx
  802a30:	8b 45 10             	mov    0x10(%ebp),%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a38:	75 07                	jne    802a41 <merging+0x5d>
		next_is_free = 1;
  802a3a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a45:	0f 84 cc 00 00 00    	je     802b17 <merging+0x133>
  802a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4f:	0f 84 c2 00 00 00    	je     802b17 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802a55:	ff 75 08             	pushl  0x8(%ebp)
  802a58:	e8 66 f1 ff ff       	call   801bc3 <get_block_size>
  802a5d:	83 c4 04             	add    $0x4,%esp
  802a60:	89 c3                	mov    %eax,%ebx
  802a62:	ff 75 10             	pushl  0x10(%ebp)
  802a65:	e8 59 f1 ff ff       	call   801bc3 <get_block_size>
  802a6a:	83 c4 04             	add    $0x4,%esp
  802a6d:	01 c3                	add    %eax,%ebx
  802a6f:	ff 75 0c             	pushl  0xc(%ebp)
  802a72:	e8 4c f1 ff ff       	call   801bc3 <get_block_size>
  802a77:	83 c4 04             	add    $0x4,%esp
  802a7a:	01 d8                	add    %ebx,%eax
  802a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802a7f:	6a 00                	push   $0x0
  802a81:	ff 75 ec             	pushl  -0x14(%ebp)
  802a84:	ff 75 08             	pushl  0x8(%ebp)
  802a87:	e8 88 f4 ff ff       	call   801f14 <set_block_data>
  802a8c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802a8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a93:	75 17                	jne    802aac <merging+0xc8>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 ef 41 80 00       	push   $0x8041ef
  802a9d:	68 7d 01 00 00       	push   $0x17d
  802aa2:	68 0d 42 80 00       	push   $0x80420d
  802aa7:	e8 d7 0c 00 00       	call   803783 <_panic>
  802aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 10                	je     802ac5 <merging+0xe1>
  802ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abd:	8b 52 04             	mov    0x4(%edx),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 0b                	jmp    802ad0 <merging+0xec>
  802ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0f                	je     802ae9 <merging+0x105>
  802ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae3:	8b 12                	mov    (%edx),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 0a                	jmp    802af3 <merging+0x10f>
  802ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b06:	a1 38 50 80 00       	mov    0x805038,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b11:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b12:	e9 ea 02 00 00       	jmp    802e01 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1b:	74 3b                	je     802b58 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b1d:	83 ec 0c             	sub    $0xc,%esp
  802b20:	ff 75 08             	pushl  0x8(%ebp)
  802b23:	e8 9b f0 ff ff       	call   801bc3 <get_block_size>
  802b28:	83 c4 10             	add    $0x10,%esp
  802b2b:	89 c3                	mov    %eax,%ebx
  802b2d:	83 ec 0c             	sub    $0xc,%esp
  802b30:	ff 75 10             	pushl  0x10(%ebp)
  802b33:	e8 8b f0 ff ff       	call   801bc3 <get_block_size>
  802b38:	83 c4 10             	add    $0x10,%esp
  802b3b:	01 d8                	add    %ebx,%eax
  802b3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b40:	83 ec 04             	sub    $0x4,%esp
  802b43:	6a 00                	push   $0x0
  802b45:	ff 75 e8             	pushl  -0x18(%ebp)
  802b48:	ff 75 08             	pushl  0x8(%ebp)
  802b4b:	e8 c4 f3 ff ff       	call   801f14 <set_block_data>
  802b50:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b53:	e9 a9 02 00 00       	jmp    802e01 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802b58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5c:	0f 84 2d 01 00 00    	je     802c8f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802b62:	83 ec 0c             	sub    $0xc,%esp
  802b65:	ff 75 10             	pushl  0x10(%ebp)
  802b68:	e8 56 f0 ff ff       	call   801bc3 <get_block_size>
  802b6d:	83 c4 10             	add    $0x10,%esp
  802b70:	89 c3                	mov    %eax,%ebx
  802b72:	83 ec 0c             	sub    $0xc,%esp
  802b75:	ff 75 0c             	pushl  0xc(%ebp)
  802b78:	e8 46 f0 ff ff       	call   801bc3 <get_block_size>
  802b7d:	83 c4 10             	add    $0x10,%esp
  802b80:	01 d8                	add    %ebx,%eax
  802b82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	6a 00                	push   $0x0
  802b8a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b8d:	ff 75 10             	pushl  0x10(%ebp)
  802b90:	e8 7f f3 ff ff       	call   801f14 <set_block_data>
  802b95:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802b98:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802b9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ba2:	74 06                	je     802baa <merging+0x1c6>
  802ba4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ba8:	75 17                	jne    802bc1 <merging+0x1dd>
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	68 c8 42 80 00       	push   $0x8042c8
  802bb2:	68 8d 01 00 00       	push   $0x18d
  802bb7:	68 0d 42 80 00       	push   $0x80420d
  802bbc:	e8 c2 0b 00 00       	call   803783 <_panic>
  802bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc4:	8b 50 04             	mov    0x4(%eax),%edx
  802bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
  802bcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0d                	je     802bec <merging+0x208>
  802bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802be8:	89 10                	mov    %edx,(%eax)
  802bea:	eb 08                	jmp    802bf4 <merging+0x210>
  802bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	a1 38 50 80 00       	mov    0x805038,%eax
  802c02:	40                   	inc    %eax
  802c03:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0c:	75 17                	jne    802c25 <merging+0x241>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 ef 41 80 00       	push   $0x8041ef
  802c16:	68 8e 01 00 00       	push   $0x18e
  802c1b:	68 0d 42 80 00       	push   $0x80420d
  802c20:	e8 5e 0b 00 00       	call   803783 <_panic>
  802c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 10                	je     802c3e <merging+0x25a>
  802c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c36:	8b 52 04             	mov    0x4(%edx),%edx
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	eb 0b                	jmp    802c49 <merging+0x265>
  802c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	a3 30 50 80 00       	mov    %eax,0x805030
  802c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	74 0f                	je     802c62 <merging+0x27e>
  802c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5c:	8b 12                	mov    (%edx),%edx
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	eb 0a                	jmp    802c6c <merging+0x288>
  802c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c84:	48                   	dec    %eax
  802c85:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c8a:	e9 72 01 00 00       	jmp    802e01 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  802c92:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802c95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c99:	74 79                	je     802d14 <merging+0x330>
  802c9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c9f:	74 73                	je     802d14 <merging+0x330>
  802ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca5:	74 06                	je     802cad <merging+0x2c9>
  802ca7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cab:	75 17                	jne    802cc4 <merging+0x2e0>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 80 42 80 00       	push   $0x804280
  802cb5:	68 94 01 00 00       	push   $0x194
  802cba:	68 0d 42 80 00       	push   $0x80420d
  802cbf:	e8 bf 0a 00 00       	call   803783 <_panic>
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	8b 10                	mov    (%eax),%edx
  802cc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ccc:	89 10                	mov    %edx,(%eax)
  802cce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 0b                	je     802ce2 <merging+0x2fe>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cdf:	89 50 04             	mov    %edx,0x4(%eax)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ced:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	75 08                	jne    802d04 <merging+0x320>
  802cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cff:	a3 30 50 80 00       	mov    %eax,0x805030
  802d04:	a1 38 50 80 00       	mov    0x805038,%eax
  802d09:	40                   	inc    %eax
  802d0a:	a3 38 50 80 00       	mov    %eax,0x805038
  802d0f:	e9 ce 00 00 00       	jmp    802de2 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d18:	74 65                	je     802d7f <merging+0x39b>
  802d1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d1e:	75 17                	jne    802d37 <merging+0x353>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 5c 42 80 00       	push   $0x80425c
  802d28:	68 95 01 00 00       	push   $0x195
  802d2d:	68 0d 42 80 00       	push   $0x80420d
  802d32:	e8 4c 0a 00 00       	call   803783 <_panic>
  802d37:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d40:	89 50 04             	mov    %edx,0x4(%eax)
  802d43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 0c                	je     802d59 <merging+0x375>
  802d4d:	a1 30 50 80 00       	mov    0x805030,%eax
  802d52:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	eb 08                	jmp    802d61 <merging+0x37d>
  802d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d64:	a3 30 50 80 00       	mov    %eax,0x805030
  802d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d72:	a1 38 50 80 00       	mov    0x805038,%eax
  802d77:	40                   	inc    %eax
  802d78:	a3 38 50 80 00       	mov    %eax,0x805038
  802d7d:	eb 63                	jmp    802de2 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802d7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d83:	75 17                	jne    802d9c <merging+0x3b8>
  802d85:	83 ec 04             	sub    $0x4,%esp
  802d88:	68 28 42 80 00       	push   $0x804228
  802d8d:	68 98 01 00 00       	push   $0x198
  802d92:	68 0d 42 80 00       	push   $0x80420d
  802d97:	e8 e7 09 00 00       	call   803783 <_panic>
  802d9c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802da2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da5:	89 10                	mov    %edx,(%eax)
  802da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 0d                	je     802dbd <merging+0x3d9>
  802db0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802db5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	eb 08                	jmp    802dc5 <merging+0x3e1>
  802dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc0:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddc:	40                   	inc    %eax
  802ddd:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802de2:	83 ec 0c             	sub    $0xc,%esp
  802de5:	ff 75 10             	pushl  0x10(%ebp)
  802de8:	e8 d6 ed ff ff       	call   801bc3 <get_block_size>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	6a 00                	push   $0x0
  802df5:	50                   	push   %eax
  802df6:	ff 75 10             	pushl  0x10(%ebp)
  802df9:	e8 16 f1 ff ff       	call   801f14 <set_block_data>
  802dfe:	83 c4 10             	add    $0x10,%esp
	}
}
  802e01:	90                   	nop
  802e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e05:	c9                   	leave  
  802e06:	c3                   	ret    

00802e07 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
  802e0a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e0d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e12:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e15:	a1 30 50 80 00       	mov    0x805030,%eax
  802e1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1d:	73 1b                	jae    802e3a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e1f:	a1 30 50 80 00       	mov    0x805030,%eax
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	ff 75 08             	pushl  0x8(%ebp)
  802e2a:	6a 00                	push   $0x0
  802e2c:	50                   	push   %eax
  802e2d:	e8 b2 fb ff ff       	call   8029e4 <merging>
  802e32:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e35:	e9 8b 00 00 00       	jmp    802ec5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e3a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e42:	76 18                	jbe    802e5c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e44:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	ff 75 08             	pushl  0x8(%ebp)
  802e4f:	50                   	push   %eax
  802e50:	6a 00                	push   $0x0
  802e52:	e8 8d fb ff ff       	call   8029e4 <merging>
  802e57:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e5a:	eb 69                	jmp    802ec5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e5c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e64:	eb 39                	jmp    802e9f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6c:	73 29                	jae    802e97 <free_block+0x90>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e76:	76 1f                	jbe    802e97 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	ff 75 08             	pushl  0x8(%ebp)
  802e86:	ff 75 f0             	pushl  -0x10(%ebp)
  802e89:	ff 75 f4             	pushl  -0xc(%ebp)
  802e8c:	e8 53 fb ff ff       	call   8029e4 <merging>
  802e91:	83 c4 10             	add    $0x10,%esp
			break;
  802e94:	90                   	nop
		}
	}
}
  802e95:	eb 2e                	jmp    802ec5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e97:	a1 34 50 80 00       	mov    0x805034,%eax
  802e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	74 07                	je     802eac <free_block+0xa5>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	eb 05                	jmp    802eb1 <free_block+0xaa>
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb6:	a1 34 50 80 00       	mov    0x805034,%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	75 a7                	jne    802e66 <free_block+0x5f>
  802ebf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec3:	75 a1                	jne    802e66 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ec5:	90                   	nop
  802ec6:	c9                   	leave  
  802ec7:	c3                   	ret    

00802ec8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802ec8:	55                   	push   %ebp
  802ec9:	89 e5                	mov    %esp,%ebp
  802ecb:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	e8 ed ec ff ff       	call   801bc3 <get_block_size>
  802ed6:	83 c4 04             	add    $0x4,%esp
  802ed9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802edc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802ee3:	eb 17                	jmp    802efc <copy_data+0x34>
  802ee5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eeb:	01 c2                	add    %eax,%edx
  802eed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	01 c8                	add    %ecx,%eax
  802ef5:	8a 00                	mov    (%eax),%al
  802ef7:	88 02                	mov    %al,(%edx)
  802ef9:	ff 45 fc             	incl   -0x4(%ebp)
  802efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802eff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f02:	72 e1                	jb     802ee5 <copy_data+0x1d>
}
  802f04:	90                   	nop
  802f05:	c9                   	leave  
  802f06:	c3                   	ret    

00802f07 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f07:	55                   	push   %ebp
  802f08:	89 e5                	mov    %esp,%ebp
  802f0a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f11:	75 23                	jne    802f36 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f17:	74 13                	je     802f2c <realloc_block_FF+0x25>
  802f19:	83 ec 0c             	sub    $0xc,%esp
  802f1c:	ff 75 0c             	pushl  0xc(%ebp)
  802f1f:	e8 1f f0 ff ff       	call   801f43 <alloc_block_FF>
  802f24:	83 c4 10             	add    $0x10,%esp
  802f27:	e9 f4 06 00 00       	jmp    803620 <realloc_block_FF+0x719>
		return NULL;
  802f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f31:	e9 ea 06 00 00       	jmp    803620 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3a:	75 18                	jne    802f54 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f3c:	83 ec 0c             	sub    $0xc,%esp
  802f3f:	ff 75 08             	pushl  0x8(%ebp)
  802f42:	e8 c0 fe ff ff       	call   802e07 <free_block>
  802f47:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4f:	e9 cc 06 00 00       	jmp    803620 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802f54:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f58:	77 07                	ja     802f61 <realloc_block_FF+0x5a>
  802f5a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f64:	83 e0 01             	and    $0x1,%eax
  802f67:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6d:	83 c0 08             	add    $0x8,%eax
  802f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802f73:	83 ec 0c             	sub    $0xc,%esp
  802f76:	ff 75 08             	pushl  0x8(%ebp)
  802f79:	e8 45 ec ff ff       	call   801bc3 <get_block_size>
  802f7e:	83 c4 10             	add    $0x10,%esp
  802f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	83 e8 08             	sub    $0x8,%eax
  802f8a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	83 e8 04             	sub    $0x4,%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	83 e0 fe             	and    $0xfffffffe,%eax
  802f98:	89 c2                	mov    %eax,%edx
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	01 d0                	add    %edx,%eax
  802f9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802fa2:	83 ec 0c             	sub    $0xc,%esp
  802fa5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa8:	e8 16 ec ff ff       	call   801bc3 <get_block_size>
  802fad:	83 c4 10             	add    $0x10,%esp
  802fb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb6:	83 e8 08             	sub    $0x8,%eax
  802fb9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  802fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fc2:	75 08                	jne    802fcc <realloc_block_FF+0xc5>
	{
		 return va;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	e9 54 06 00 00       	jmp    803620 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  802fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fd2:	0f 83 e5 03 00 00    	jae    8033bd <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fe7:	e8 f0 eb ff ff       	call   801bdc <is_free_block>
  802fec:	83 c4 10             	add    $0x10,%esp
  802fef:	84 c0                	test   %al,%al
  802ff1:	0f 84 3b 01 00 00    	je     803132 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  802ff7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ffa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ffd:	01 d0                	add    %edx,%eax
  802fff:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	6a 01                	push   $0x1
  803007:	ff 75 f0             	pushl  -0x10(%ebp)
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	e8 02 ef ff ff       	call   801f14 <set_block_data>
  803012:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	83 e8 04             	sub    $0x4,%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	83 e0 fe             	and    $0xfffffffe,%eax
  803020:	89 c2                	mov    %eax,%edx
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	01 d0                	add    %edx,%eax
  803027:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	6a 00                	push   $0x0
  80302f:	ff 75 cc             	pushl  -0x34(%ebp)
  803032:	ff 75 c8             	pushl  -0x38(%ebp)
  803035:	e8 da ee ff ff       	call   801f14 <set_block_data>
  80303a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80303d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803041:	74 06                	je     803049 <realloc_block_FF+0x142>
  803043:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803047:	75 17                	jne    803060 <realloc_block_FF+0x159>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 80 42 80 00       	push   $0x804280
  803051:	68 f6 01 00 00       	push   $0x1f6
  803056:	68 0d 42 80 00       	push   $0x80420d
  80305b:	e8 23 07 00 00       	call   803783 <_panic>
  803060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803063:	8b 10                	mov    (%eax),%edx
  803065:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0b                	je     80307e <realloc_block_FF+0x177>
  803073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80307b:	89 50 04             	mov    %edx,0x4(%eax)
  80307e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803081:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803084:	89 10                	mov    %edx,(%eax)
  803086:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803089:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80308c:	89 50 04             	mov    %edx,0x4(%eax)
  80308f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	75 08                	jne    8030a0 <realloc_block_FF+0x199>
  803098:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80309b:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a5:	40                   	inc    %eax
  8030a6:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8030ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030af:	75 17                	jne    8030c8 <realloc_block_FF+0x1c1>
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	68 ef 41 80 00       	push   $0x8041ef
  8030b9:	68 f7 01 00 00       	push   $0x1f7
  8030be:	68 0d 42 80 00       	push   $0x80420d
  8030c3:	e8 bb 06 00 00       	call   803783 <_panic>
  8030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 10                	je     8030e1 <realloc_block_FF+0x1da>
  8030d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d9:	8b 52 04             	mov    0x4(%edx),%edx
  8030dc:	89 50 04             	mov    %edx,0x4(%eax)
  8030df:	eb 0b                	jmp    8030ec <realloc_block_FF+0x1e5>
  8030e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	74 0f                	je     803105 <realloc_block_FF+0x1fe>
  8030f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f9:	8b 40 04             	mov    0x4(%eax),%eax
  8030fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ff:	8b 12                	mov    (%edx),%edx
  803101:	89 10                	mov    %edx,(%eax)
  803103:	eb 0a                	jmp    80310f <realloc_block_FF+0x208>
  803105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803122:	a1 38 50 80 00       	mov    0x805038,%eax
  803127:	48                   	dec    %eax
  803128:	a3 38 50 80 00       	mov    %eax,0x805038
  80312d:	e9 83 02 00 00       	jmp    8033b5 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803132:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803136:	0f 86 69 02 00 00    	jbe    8033a5 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	6a 01                	push   $0x1
  803141:	ff 75 f0             	pushl  -0x10(%ebp)
  803144:	ff 75 08             	pushl  0x8(%ebp)
  803147:	e8 c8 ed ff ff       	call   801f14 <set_block_data>
  80314c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	83 e8 04             	sub    $0x4,%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	83 e0 fe             	and    $0xfffffffe,%eax
  80315a:	89 c2                	mov    %eax,%edx
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	01 d0                	add    %edx,%eax
  803161:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803164:	a1 38 50 80 00       	mov    0x805038,%eax
  803169:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80316c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803170:	75 68                	jne    8031da <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803172:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803176:	75 17                	jne    80318f <realloc_block_FF+0x288>
  803178:	83 ec 04             	sub    $0x4,%esp
  80317b:	68 28 42 80 00       	push   $0x804228
  803180:	68 06 02 00 00       	push   $0x206
  803185:	68 0d 42 80 00       	push   $0x80420d
  80318a:	e8 f4 05 00 00       	call   803783 <_panic>
  80318f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803195:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803198:	89 10                	mov    %edx,(%eax)
  80319a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0d                	je     8031b0 <realloc_block_FF+0x2a9>
  8031a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031ab:	89 50 04             	mov    %edx,0x4(%eax)
  8031ae:	eb 08                	jmp    8031b8 <realloc_block_FF+0x2b1>
  8031b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8031cf:	40                   	inc    %eax
  8031d0:	a3 38 50 80 00       	mov    %eax,0x805038
  8031d5:	e9 b0 01 00 00       	jmp    80338a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8031da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031df:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8031e2:	76 68                	jbe    80324c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031e8:	75 17                	jne    803201 <realloc_block_FF+0x2fa>
  8031ea:	83 ec 04             	sub    $0x4,%esp
  8031ed:	68 28 42 80 00       	push   $0x804228
  8031f2:	68 0b 02 00 00       	push   $0x20b
  8031f7:	68 0d 42 80 00       	push   $0x80420d
  8031fc:	e8 82 05 00 00       	call   803783 <_panic>
  803201:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320a:	89 10                	mov    %edx,(%eax)
  80320c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	74 0d                	je     803222 <realloc_block_FF+0x31b>
  803215:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80321d:	89 50 04             	mov    %edx,0x4(%eax)
  803220:	eb 08                	jmp    80322a <realloc_block_FF+0x323>
  803222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803225:	a3 30 50 80 00       	mov    %eax,0x805030
  80322a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803232:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323c:	a1 38 50 80 00       	mov    0x805038,%eax
  803241:	40                   	inc    %eax
  803242:	a3 38 50 80 00       	mov    %eax,0x805038
  803247:	e9 3e 01 00 00       	jmp    80338a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80324c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803251:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803254:	73 68                	jae    8032be <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803256:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80325a:	75 17                	jne    803273 <realloc_block_FF+0x36c>
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	68 5c 42 80 00       	push   $0x80425c
  803264:	68 10 02 00 00       	push   $0x210
  803269:	68 0d 42 80 00       	push   $0x80420d
  80326e:	e8 10 05 00 00       	call   803783 <_panic>
  803273:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0c                	je     803295 <realloc_block_FF+0x38e>
  803289:	a1 30 50 80 00       	mov    0x805030,%eax
  80328e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803291:	89 10                	mov    %edx,(%eax)
  803293:	eb 08                	jmp    80329d <realloc_block_FF+0x396>
  803295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803298:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 38 50 80 00       	mov    %eax,0x805038
  8032b9:	e9 cc 00 00 00       	jmp    80338a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8032be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8032c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032cd:	e9 8a 00 00 00       	jmp    80335c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032d8:	73 7a                	jae    803354 <realloc_block_FF+0x44d>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032e2:	73 70                	jae    803354 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8032e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e8:	74 06                	je     8032f0 <realloc_block_FF+0x3e9>
  8032ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032ee:	75 17                	jne    803307 <realloc_block_FF+0x400>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 80 42 80 00       	push   $0x804280
  8032f8:	68 1a 02 00 00       	push   $0x21a
  8032fd:	68 0d 42 80 00       	push   $0x80420d
  803302:	e8 7c 04 00 00       	call   803783 <_panic>
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 10                	mov    (%eax),%edx
  80330c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0b                	je     803325 <realloc_block_FF+0x41e>
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	75 08                	jne    803347 <realloc_block_FF+0x440>
  80333f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803342:	a3 30 50 80 00       	mov    %eax,0x805030
  803347:	a1 38 50 80 00       	mov    0x805038,%eax
  80334c:	40                   	inc    %eax
  80334d:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803352:	eb 36                	jmp    80338a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803354:	a1 34 50 80 00       	mov    0x805034,%eax
  803359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803360:	74 07                	je     803369 <realloc_block_FF+0x462>
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	eb 05                	jmp    80336e <realloc_block_FF+0x467>
  803369:	b8 00 00 00 00       	mov    $0x0,%eax
  80336e:	a3 34 50 80 00       	mov    %eax,0x805034
  803373:	a1 34 50 80 00       	mov    0x805034,%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	0f 85 52 ff ff ff    	jne    8032d2 <realloc_block_FF+0x3cb>
  803380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803384:	0f 85 48 ff ff ff    	jne    8032d2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80338a:	83 ec 04             	sub    $0x4,%esp
  80338d:	6a 00                	push   $0x0
  80338f:	ff 75 d8             	pushl  -0x28(%ebp)
  803392:	ff 75 d4             	pushl  -0x2c(%ebp)
  803395:	e8 7a eb ff ff       	call   801f14 <set_block_data>
  80339a:	83 c4 10             	add    $0x10,%esp
				return va;
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	e9 7b 02 00 00       	jmp    803620 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033a5:	83 ec 0c             	sub    $0xc,%esp
  8033a8:	68 fd 42 80 00       	push   $0x8042fd
  8033ad:	e8 de cf ff ff       	call   800390 <cprintf>
  8033b2:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	e9 63 02 00 00       	jmp    803620 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8033bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c3:	0f 86 4d 02 00 00    	jbe    803616 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8033c9:	83 ec 0c             	sub    $0xc,%esp
  8033cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033cf:	e8 08 e8 ff ff       	call   801bdc <is_free_block>
  8033d4:	83 c4 10             	add    $0x10,%esp
  8033d7:	84 c0                	test   %al,%al
  8033d9:	0f 84 37 02 00 00    	je     803616 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8033df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8033e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033eb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033ee:	76 38                	jbe    803428 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8033f0:	83 ec 0c             	sub    $0xc,%esp
  8033f3:	ff 75 08             	pushl  0x8(%ebp)
  8033f6:	e8 0c fa ff ff       	call   802e07 <free_block>
  8033fb:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8033fe:	83 ec 0c             	sub    $0xc,%esp
  803401:	ff 75 0c             	pushl  0xc(%ebp)
  803404:	e8 3a eb ff ff       	call   801f43 <alloc_block_FF>
  803409:	83 c4 10             	add    $0x10,%esp
  80340c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80340f:	83 ec 08             	sub    $0x8,%esp
  803412:	ff 75 c0             	pushl  -0x40(%ebp)
  803415:	ff 75 08             	pushl  0x8(%ebp)
  803418:	e8 ab fa ff ff       	call   802ec8 <copy_data>
  80341d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803420:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803423:	e9 f8 01 00 00       	jmp    803620 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80342e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803431:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803435:	0f 87 a0 00 00 00    	ja     8034db <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80343b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80343f:	75 17                	jne    803458 <realloc_block_FF+0x551>
  803441:	83 ec 04             	sub    $0x4,%esp
  803444:	68 ef 41 80 00       	push   $0x8041ef
  803449:	68 38 02 00 00       	push   $0x238
  80344e:	68 0d 42 80 00       	push   $0x80420d
  803453:	e8 2b 03 00 00       	call   803783 <_panic>
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 10                	je     803471 <realloc_block_FF+0x56a>
  803461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803469:	8b 52 04             	mov    0x4(%edx),%edx
  80346c:	89 50 04             	mov    %edx,0x4(%eax)
  80346f:	eb 0b                	jmp    80347c <realloc_block_FF+0x575>
  803471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	a3 30 50 80 00       	mov    %eax,0x805030
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0f                	je     803495 <realloc_block_FF+0x58e>
  803486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348f:	8b 12                	mov    (%edx),%edx
  803491:	89 10                	mov    %edx,(%eax)
  803493:	eb 0a                	jmp    80349f <realloc_block_FF+0x598>
  803495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b7:	48                   	dec    %eax
  8034b8:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8034bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c3:	01 d0                	add    %edx,%eax
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	6a 01                	push   $0x1
  8034ca:	50                   	push   %eax
  8034cb:	ff 75 08             	pushl  0x8(%ebp)
  8034ce:	e8 41 ea ff ff       	call   801f14 <set_block_data>
  8034d3:	83 c4 10             	add    $0x10,%esp
  8034d6:	e9 36 01 00 00       	jmp    803611 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8034db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034e1:	01 d0                	add    %edx,%eax
  8034e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	6a 01                	push   $0x1
  8034eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ee:	ff 75 08             	pushl  0x8(%ebp)
  8034f1:	e8 1e ea ff ff       	call   801f14 <set_block_data>
  8034f6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	83 e8 04             	sub    $0x4,%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	83 e0 fe             	and    $0xfffffffe,%eax
  803504:	89 c2                	mov    %eax,%edx
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	01 d0                	add    %edx,%eax
  80350b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80350e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803512:	74 06                	je     80351a <realloc_block_FF+0x613>
  803514:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803518:	75 17                	jne    803531 <realloc_block_FF+0x62a>
  80351a:	83 ec 04             	sub    $0x4,%esp
  80351d:	68 80 42 80 00       	push   $0x804280
  803522:	68 44 02 00 00       	push   $0x244
  803527:	68 0d 42 80 00       	push   $0x80420d
  80352c:	e8 52 02 00 00       	call   803783 <_panic>
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	8b 10                	mov    (%eax),%edx
  803536:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	85 c0                	test   %eax,%eax
  803542:	74 0b                	je     80354f <realloc_block_FF+0x648>
  803544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80354c:	89 50 04             	mov    %edx,0x4(%eax)
  80354f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803552:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803555:	89 10                	mov    %edx,(%eax)
  803557:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80355a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	75 08                	jne    803571 <realloc_block_FF+0x66a>
  803569:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80356c:	a3 30 50 80 00       	mov    %eax,0x805030
  803571:	a1 38 50 80 00       	mov    0x805038,%eax
  803576:	40                   	inc    %eax
  803577:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80357c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803580:	75 17                	jne    803599 <realloc_block_FF+0x692>
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	68 ef 41 80 00       	push   $0x8041ef
  80358a:	68 45 02 00 00       	push   $0x245
  80358f:	68 0d 42 80 00       	push   $0x80420d
  803594:	e8 ea 01 00 00       	call   803783 <_panic>
  803599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359c:	8b 00                	mov    (%eax),%eax
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	74 10                	je     8035b2 <realloc_block_FF+0x6ab>
  8035a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035aa:	8b 52 04             	mov    0x4(%edx),%edx
  8035ad:	89 50 04             	mov    %edx,0x4(%eax)
  8035b0:	eb 0b                	jmp    8035bd <realloc_block_FF+0x6b6>
  8035b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b5:	8b 40 04             	mov    0x4(%eax),%eax
  8035b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c0:	8b 40 04             	mov    0x4(%eax),%eax
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	74 0f                	je     8035d6 <realloc_block_FF+0x6cf>
  8035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ca:	8b 40 04             	mov    0x4(%eax),%eax
  8035cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d0:	8b 12                	mov    (%edx),%edx
  8035d2:	89 10                	mov    %edx,(%eax)
  8035d4:	eb 0a                	jmp    8035e0 <realloc_block_FF+0x6d9>
  8035d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f8:	48                   	dec    %eax
  8035f9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8035fe:	83 ec 04             	sub    $0x4,%esp
  803601:	6a 00                	push   $0x0
  803603:	ff 75 bc             	pushl  -0x44(%ebp)
  803606:	ff 75 b8             	pushl  -0x48(%ebp)
  803609:	e8 06 e9 ff ff       	call   801f14 <set_block_data>
  80360e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	eb 0a                	jmp    803620 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803616:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803620:	c9                   	leave  
  803621:	c3                   	ret    

00803622 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803622:	55                   	push   %ebp
  803623:	89 e5                	mov    %esp,%ebp
  803625:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 04 43 80 00       	push   $0x804304
  803630:	68 58 02 00 00       	push   $0x258
  803635:	68 0d 42 80 00       	push   $0x80420d
  80363a:	e8 44 01 00 00       	call   803783 <_panic>

0080363f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80363f:	55                   	push   %ebp
  803640:	89 e5                	mov    %esp,%ebp
  803642:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803645:	83 ec 04             	sub    $0x4,%esp
  803648:	68 2c 43 80 00       	push   $0x80432c
  80364d:	68 61 02 00 00       	push   $0x261
  803652:	68 0d 42 80 00       	push   $0x80420d
  803657:	e8 27 01 00 00       	call   803783 <_panic>

0080365c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80365c:	55                   	push   %ebp
  80365d:	89 e5                	mov    %esp,%ebp
  80365f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	68 54 43 80 00       	push   $0x804354
  80366a:	6a 09                	push   $0x9
  80366c:	68 7c 43 80 00       	push   $0x80437c
  803671:	e8 0d 01 00 00       	call   803783 <_panic>

00803676 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803676:	55                   	push   %ebp
  803677:	89 e5                	mov    %esp,%ebp
  803679:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80367c:	83 ec 04             	sub    $0x4,%esp
  80367f:	68 8c 43 80 00       	push   $0x80438c
  803684:	6a 10                	push   $0x10
  803686:	68 7c 43 80 00       	push   $0x80437c
  80368b:	e8 f3 00 00 00       	call   803783 <_panic>

00803690 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803690:	55                   	push   %ebp
  803691:	89 e5                	mov    %esp,%ebp
  803693:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	68 b4 43 80 00       	push   $0x8043b4
  80369e:	6a 18                	push   $0x18
  8036a0:	68 7c 43 80 00       	push   $0x80437c
  8036a5:	e8 d9 00 00 00       	call   803783 <_panic>

008036aa <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
  8036ad:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8036b0:	83 ec 04             	sub    $0x4,%esp
  8036b3:	68 dc 43 80 00       	push   $0x8043dc
  8036b8:	6a 20                	push   $0x20
  8036ba:	68 7c 43 80 00       	push   $0x80437c
  8036bf:	e8 bf 00 00 00       	call   803783 <_panic>

008036c4 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8036c4:	55                   	push   %ebp
  8036c5:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 40 10             	mov    0x10(%eax),%eax
}
  8036cd:	5d                   	pop    %ebp
  8036ce:	c3                   	ret    

008036cf <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8036d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d8:	89 d0                	mov    %edx,%eax
  8036da:	c1 e0 02             	shl    $0x2,%eax
  8036dd:	01 d0                	add    %edx,%eax
  8036df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036e6:	01 d0                	add    %edx,%eax
  8036e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036ef:	01 d0                	add    %edx,%eax
  8036f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036f8:	01 d0                	add    %edx,%eax
  8036fa:	c1 e0 04             	shl    $0x4,%eax
  8036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803707:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80370a:	83 ec 0c             	sub    $0xc,%esp
  80370d:	50                   	push   %eax
  80370e:	e8 bc e1 ff ff       	call   8018cf <sys_get_virtual_time>
  803713:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803716:	eb 41                	jmp    803759 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803718:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80371b:	83 ec 0c             	sub    $0xc,%esp
  80371e:	50                   	push   %eax
  80371f:	e8 ab e1 ff ff       	call   8018cf <sys_get_virtual_time>
  803724:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803727:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80372a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372d:	29 c2                	sub    %eax,%edx
  80372f:	89 d0                	mov    %edx,%eax
  803731:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373a:	89 d1                	mov    %edx,%ecx
  80373c:	29 c1                	sub    %eax,%ecx
  80373e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803744:	39 c2                	cmp    %eax,%edx
  803746:	0f 97 c0             	seta   %al
  803749:	0f b6 c0             	movzbl %al,%eax
  80374c:	29 c1                	sub    %eax,%ecx
  80374e:	89 c8                	mov    %ecx,%eax
  803750:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803753:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803756:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80375f:	72 b7                	jb     803718 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803761:	90                   	nop
  803762:	c9                   	leave  
  803763:	c3                   	ret    

00803764 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80376a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803771:	eb 03                	jmp    803776 <busy_wait+0x12>
  803773:	ff 45 fc             	incl   -0x4(%ebp)
  803776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803779:	3b 45 08             	cmp    0x8(%ebp),%eax
  80377c:	72 f5                	jb     803773 <busy_wait+0xf>
	return i;
  80377e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803781:	c9                   	leave  
  803782:	c3                   	ret    

00803783 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803783:	55                   	push   %ebp
  803784:	89 e5                	mov    %esp,%ebp
  803786:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803789:	8d 45 10             	lea    0x10(%ebp),%eax
  80378c:	83 c0 04             	add    $0x4,%eax
  80378f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803792:	a1 60 50 90 00       	mov    0x905060,%eax
  803797:	85 c0                	test   %eax,%eax
  803799:	74 16                	je     8037b1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80379b:	a1 60 50 90 00       	mov    0x905060,%eax
  8037a0:	83 ec 08             	sub    $0x8,%esp
  8037a3:	50                   	push   %eax
  8037a4:	68 04 44 80 00       	push   $0x804404
  8037a9:	e8 e2 cb ff ff       	call   800390 <cprintf>
  8037ae:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037b1:	a1 00 50 80 00       	mov    0x805000,%eax
  8037b6:	ff 75 0c             	pushl  0xc(%ebp)
  8037b9:	ff 75 08             	pushl  0x8(%ebp)
  8037bc:	50                   	push   %eax
  8037bd:	68 09 44 80 00       	push   $0x804409
  8037c2:	e8 c9 cb ff ff       	call   800390 <cprintf>
  8037c7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8037ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8037cd:	83 ec 08             	sub    $0x8,%esp
  8037d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8037d3:	50                   	push   %eax
  8037d4:	e8 4c cb ff ff       	call   800325 <vcprintf>
  8037d9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8037dc:	83 ec 08             	sub    $0x8,%esp
  8037df:	6a 00                	push   $0x0
  8037e1:	68 25 44 80 00       	push   $0x804425
  8037e6:	e8 3a cb ff ff       	call   800325 <vcprintf>
  8037eb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8037ee:	e8 bb ca ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  8037f3:	eb fe                	jmp    8037f3 <_panic+0x70>

008037f5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8037f5:	55                   	push   %ebp
  8037f6:	89 e5                	mov    %esp,%ebp
  8037f8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8037fb:	a1 20 50 80 00       	mov    0x805020,%eax
  803800:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803806:	8b 45 0c             	mov    0xc(%ebp),%eax
  803809:	39 c2                	cmp    %eax,%edx
  80380b:	74 14                	je     803821 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80380d:	83 ec 04             	sub    $0x4,%esp
  803810:	68 28 44 80 00       	push   $0x804428
  803815:	6a 26                	push   $0x26
  803817:	68 74 44 80 00       	push   $0x804474
  80381c:	e8 62 ff ff ff       	call   803783 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80382f:	e9 c5 00 00 00       	jmp    8038f9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803837:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80383e:	8b 45 08             	mov    0x8(%ebp),%eax
  803841:	01 d0                	add    %edx,%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	75 08                	jne    803851 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803849:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80384c:	e9 a5 00 00 00       	jmp    8038f6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803851:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803858:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80385f:	eb 69                	jmp    8038ca <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803861:	a1 20 50 80 00       	mov    0x805020,%eax
  803866:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80386c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80386f:	89 d0                	mov    %edx,%eax
  803871:	01 c0                	add    %eax,%eax
  803873:	01 d0                	add    %edx,%eax
  803875:	c1 e0 03             	shl    $0x3,%eax
  803878:	01 c8                	add    %ecx,%eax
  80387a:	8a 40 04             	mov    0x4(%eax),%al
  80387d:	84 c0                	test   %al,%al
  80387f:	75 46                	jne    8038c7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803881:	a1 20 50 80 00       	mov    0x805020,%eax
  803886:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80388c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388f:	89 d0                	mov    %edx,%eax
  803891:	01 c0                	add    %eax,%eax
  803893:	01 d0                	add    %edx,%eax
  803895:	c1 e0 03             	shl    $0x3,%eax
  803898:	01 c8                	add    %ecx,%eax
  80389a:	8b 00                	mov    (%eax),%eax
  80389c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80389f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038a7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ac:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	01 c8                	add    %ecx,%eax
  8038b8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038ba:	39 c2                	cmp    %eax,%edx
  8038bc:	75 09                	jne    8038c7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8038be:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8038c5:	eb 15                	jmp    8038dc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038c7:	ff 45 e8             	incl   -0x18(%ebp)
  8038ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8038cf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d8:	39 c2                	cmp    %eax,%edx
  8038da:	77 85                	ja     803861 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8038dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038e0:	75 14                	jne    8038f6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	68 80 44 80 00       	push   $0x804480
  8038ea:	6a 3a                	push   $0x3a
  8038ec:	68 74 44 80 00       	push   $0x804474
  8038f1:	e8 8d fe ff ff       	call   803783 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8038f6:	ff 45 f0             	incl   -0x10(%ebp)
  8038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038ff:	0f 8c 2f ff ff ff    	jl     803834 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803905:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803913:	eb 26                	jmp    80393b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803915:	a1 20 50 80 00       	mov    0x805020,%eax
  80391a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803923:	89 d0                	mov    %edx,%eax
  803925:	01 c0                	add    %eax,%eax
  803927:	01 d0                	add    %edx,%eax
  803929:	c1 e0 03             	shl    $0x3,%eax
  80392c:	01 c8                	add    %ecx,%eax
  80392e:	8a 40 04             	mov    0x4(%eax),%al
  803931:	3c 01                	cmp    $0x1,%al
  803933:	75 03                	jne    803938 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803935:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803938:	ff 45 e0             	incl   -0x20(%ebp)
  80393b:	a1 20 50 80 00       	mov    0x805020,%eax
  803940:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803946:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803949:	39 c2                	cmp    %eax,%edx
  80394b:	77 c8                	ja     803915 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80394d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803950:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803953:	74 14                	je     803969 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803955:	83 ec 04             	sub    $0x4,%esp
  803958:	68 d4 44 80 00       	push   $0x8044d4
  80395d:	6a 44                	push   $0x44
  80395f:	68 74 44 80 00       	push   $0x804474
  803964:	e8 1a fe ff ff       	call   803783 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803969:	90                   	nop
  80396a:	c9                   	leave  
  80396b:	c3                   	ret    

0080396c <__udivdi3>:
  80396c:	55                   	push   %ebp
  80396d:	57                   	push   %edi
  80396e:	56                   	push   %esi
  80396f:	53                   	push   %ebx
  803970:	83 ec 1c             	sub    $0x1c,%esp
  803973:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803977:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80397b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80397f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803983:	89 ca                	mov    %ecx,%edx
  803985:	89 f8                	mov    %edi,%eax
  803987:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80398b:	85 f6                	test   %esi,%esi
  80398d:	75 2d                	jne    8039bc <__udivdi3+0x50>
  80398f:	39 cf                	cmp    %ecx,%edi
  803991:	77 65                	ja     8039f8 <__udivdi3+0x8c>
  803993:	89 fd                	mov    %edi,%ebp
  803995:	85 ff                	test   %edi,%edi
  803997:	75 0b                	jne    8039a4 <__udivdi3+0x38>
  803999:	b8 01 00 00 00       	mov    $0x1,%eax
  80399e:	31 d2                	xor    %edx,%edx
  8039a0:	f7 f7                	div    %edi
  8039a2:	89 c5                	mov    %eax,%ebp
  8039a4:	31 d2                	xor    %edx,%edx
  8039a6:	89 c8                	mov    %ecx,%eax
  8039a8:	f7 f5                	div    %ebp
  8039aa:	89 c1                	mov    %eax,%ecx
  8039ac:	89 d8                	mov    %ebx,%eax
  8039ae:	f7 f5                	div    %ebp
  8039b0:	89 cf                	mov    %ecx,%edi
  8039b2:	89 fa                	mov    %edi,%edx
  8039b4:	83 c4 1c             	add    $0x1c,%esp
  8039b7:	5b                   	pop    %ebx
  8039b8:	5e                   	pop    %esi
  8039b9:	5f                   	pop    %edi
  8039ba:	5d                   	pop    %ebp
  8039bb:	c3                   	ret    
  8039bc:	39 ce                	cmp    %ecx,%esi
  8039be:	77 28                	ja     8039e8 <__udivdi3+0x7c>
  8039c0:	0f bd fe             	bsr    %esi,%edi
  8039c3:	83 f7 1f             	xor    $0x1f,%edi
  8039c6:	75 40                	jne    803a08 <__udivdi3+0x9c>
  8039c8:	39 ce                	cmp    %ecx,%esi
  8039ca:	72 0a                	jb     8039d6 <__udivdi3+0x6a>
  8039cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039d0:	0f 87 9e 00 00 00    	ja     803a74 <__udivdi3+0x108>
  8039d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039db:	89 fa                	mov    %edi,%edx
  8039dd:	83 c4 1c             	add    $0x1c,%esp
  8039e0:	5b                   	pop    %ebx
  8039e1:	5e                   	pop    %esi
  8039e2:	5f                   	pop    %edi
  8039e3:	5d                   	pop    %ebp
  8039e4:	c3                   	ret    
  8039e5:	8d 76 00             	lea    0x0(%esi),%esi
  8039e8:	31 ff                	xor    %edi,%edi
  8039ea:	31 c0                	xor    %eax,%eax
  8039ec:	89 fa                	mov    %edi,%edx
  8039ee:	83 c4 1c             	add    $0x1c,%esp
  8039f1:	5b                   	pop    %ebx
  8039f2:	5e                   	pop    %esi
  8039f3:	5f                   	pop    %edi
  8039f4:	5d                   	pop    %ebp
  8039f5:	c3                   	ret    
  8039f6:	66 90                	xchg   %ax,%ax
  8039f8:	89 d8                	mov    %ebx,%eax
  8039fa:	f7 f7                	div    %edi
  8039fc:	31 ff                	xor    %edi,%edi
  8039fe:	89 fa                	mov    %edi,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a0d:	89 eb                	mov    %ebp,%ebx
  803a0f:	29 fb                	sub    %edi,%ebx
  803a11:	89 f9                	mov    %edi,%ecx
  803a13:	d3 e6                	shl    %cl,%esi
  803a15:	89 c5                	mov    %eax,%ebp
  803a17:	88 d9                	mov    %bl,%cl
  803a19:	d3 ed                	shr    %cl,%ebp
  803a1b:	89 e9                	mov    %ebp,%ecx
  803a1d:	09 f1                	or     %esi,%ecx
  803a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a23:	89 f9                	mov    %edi,%ecx
  803a25:	d3 e0                	shl    %cl,%eax
  803a27:	89 c5                	mov    %eax,%ebp
  803a29:	89 d6                	mov    %edx,%esi
  803a2b:	88 d9                	mov    %bl,%cl
  803a2d:	d3 ee                	shr    %cl,%esi
  803a2f:	89 f9                	mov    %edi,%ecx
  803a31:	d3 e2                	shl    %cl,%edx
  803a33:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a37:	88 d9                	mov    %bl,%cl
  803a39:	d3 e8                	shr    %cl,%eax
  803a3b:	09 c2                	or     %eax,%edx
  803a3d:	89 d0                	mov    %edx,%eax
  803a3f:	89 f2                	mov    %esi,%edx
  803a41:	f7 74 24 0c          	divl   0xc(%esp)
  803a45:	89 d6                	mov    %edx,%esi
  803a47:	89 c3                	mov    %eax,%ebx
  803a49:	f7 e5                	mul    %ebp
  803a4b:	39 d6                	cmp    %edx,%esi
  803a4d:	72 19                	jb     803a68 <__udivdi3+0xfc>
  803a4f:	74 0b                	je     803a5c <__udivdi3+0xf0>
  803a51:	89 d8                	mov    %ebx,%eax
  803a53:	31 ff                	xor    %edi,%edi
  803a55:	e9 58 ff ff ff       	jmp    8039b2 <__udivdi3+0x46>
  803a5a:	66 90                	xchg   %ax,%ax
  803a5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a60:	89 f9                	mov    %edi,%ecx
  803a62:	d3 e2                	shl    %cl,%edx
  803a64:	39 c2                	cmp    %eax,%edx
  803a66:	73 e9                	jae    803a51 <__udivdi3+0xe5>
  803a68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a6b:	31 ff                	xor    %edi,%edi
  803a6d:	e9 40 ff ff ff       	jmp    8039b2 <__udivdi3+0x46>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	31 c0                	xor    %eax,%eax
  803a76:	e9 37 ff ff ff       	jmp    8039b2 <__udivdi3+0x46>
  803a7b:	90                   	nop

00803a7c <__umoddi3>:
  803a7c:	55                   	push   %ebp
  803a7d:	57                   	push   %edi
  803a7e:	56                   	push   %esi
  803a7f:	53                   	push   %ebx
  803a80:	83 ec 1c             	sub    $0x1c,%esp
  803a83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a87:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a9b:	89 f3                	mov    %esi,%ebx
  803a9d:	89 fa                	mov    %edi,%edx
  803a9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa3:	89 34 24             	mov    %esi,(%esp)
  803aa6:	85 c0                	test   %eax,%eax
  803aa8:	75 1a                	jne    803ac4 <__umoddi3+0x48>
  803aaa:	39 f7                	cmp    %esi,%edi
  803aac:	0f 86 a2 00 00 00    	jbe    803b54 <__umoddi3+0xd8>
  803ab2:	89 c8                	mov    %ecx,%eax
  803ab4:	89 f2                	mov    %esi,%edx
  803ab6:	f7 f7                	div    %edi
  803ab8:	89 d0                	mov    %edx,%eax
  803aba:	31 d2                	xor    %edx,%edx
  803abc:	83 c4 1c             	add    $0x1c,%esp
  803abf:	5b                   	pop    %ebx
  803ac0:	5e                   	pop    %esi
  803ac1:	5f                   	pop    %edi
  803ac2:	5d                   	pop    %ebp
  803ac3:	c3                   	ret    
  803ac4:	39 f0                	cmp    %esi,%eax
  803ac6:	0f 87 ac 00 00 00    	ja     803b78 <__umoddi3+0xfc>
  803acc:	0f bd e8             	bsr    %eax,%ebp
  803acf:	83 f5 1f             	xor    $0x1f,%ebp
  803ad2:	0f 84 ac 00 00 00    	je     803b84 <__umoddi3+0x108>
  803ad8:	bf 20 00 00 00       	mov    $0x20,%edi
  803add:	29 ef                	sub    %ebp,%edi
  803adf:	89 fe                	mov    %edi,%esi
  803ae1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ae5:	89 e9                	mov    %ebp,%ecx
  803ae7:	d3 e0                	shl    %cl,%eax
  803ae9:	89 d7                	mov    %edx,%edi
  803aeb:	89 f1                	mov    %esi,%ecx
  803aed:	d3 ef                	shr    %cl,%edi
  803aef:	09 c7                	or     %eax,%edi
  803af1:	89 e9                	mov    %ebp,%ecx
  803af3:	d3 e2                	shl    %cl,%edx
  803af5:	89 14 24             	mov    %edx,(%esp)
  803af8:	89 d8                	mov    %ebx,%eax
  803afa:	d3 e0                	shl    %cl,%eax
  803afc:	89 c2                	mov    %eax,%edx
  803afe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b02:	d3 e0                	shl    %cl,%eax
  803b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b0c:	89 f1                	mov    %esi,%ecx
  803b0e:	d3 e8                	shr    %cl,%eax
  803b10:	09 d0                	or     %edx,%eax
  803b12:	d3 eb                	shr    %cl,%ebx
  803b14:	89 da                	mov    %ebx,%edx
  803b16:	f7 f7                	div    %edi
  803b18:	89 d3                	mov    %edx,%ebx
  803b1a:	f7 24 24             	mull   (%esp)
  803b1d:	89 c6                	mov    %eax,%esi
  803b1f:	89 d1                	mov    %edx,%ecx
  803b21:	39 d3                	cmp    %edx,%ebx
  803b23:	0f 82 87 00 00 00    	jb     803bb0 <__umoddi3+0x134>
  803b29:	0f 84 91 00 00 00    	je     803bc0 <__umoddi3+0x144>
  803b2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b33:	29 f2                	sub    %esi,%edx
  803b35:	19 cb                	sbb    %ecx,%ebx
  803b37:	89 d8                	mov    %ebx,%eax
  803b39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b3d:	d3 e0                	shl    %cl,%eax
  803b3f:	89 e9                	mov    %ebp,%ecx
  803b41:	d3 ea                	shr    %cl,%edx
  803b43:	09 d0                	or     %edx,%eax
  803b45:	89 e9                	mov    %ebp,%ecx
  803b47:	d3 eb                	shr    %cl,%ebx
  803b49:	89 da                	mov    %ebx,%edx
  803b4b:	83 c4 1c             	add    $0x1c,%esp
  803b4e:	5b                   	pop    %ebx
  803b4f:	5e                   	pop    %esi
  803b50:	5f                   	pop    %edi
  803b51:	5d                   	pop    %ebp
  803b52:	c3                   	ret    
  803b53:	90                   	nop
  803b54:	89 fd                	mov    %edi,%ebp
  803b56:	85 ff                	test   %edi,%edi
  803b58:	75 0b                	jne    803b65 <__umoddi3+0xe9>
  803b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5f:	31 d2                	xor    %edx,%edx
  803b61:	f7 f7                	div    %edi
  803b63:	89 c5                	mov    %eax,%ebp
  803b65:	89 f0                	mov    %esi,%eax
  803b67:	31 d2                	xor    %edx,%edx
  803b69:	f7 f5                	div    %ebp
  803b6b:	89 c8                	mov    %ecx,%eax
  803b6d:	f7 f5                	div    %ebp
  803b6f:	89 d0                	mov    %edx,%eax
  803b71:	e9 44 ff ff ff       	jmp    803aba <__umoddi3+0x3e>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	89 c8                	mov    %ecx,%eax
  803b7a:	89 f2                	mov    %esi,%edx
  803b7c:	83 c4 1c             	add    $0x1c,%esp
  803b7f:	5b                   	pop    %ebx
  803b80:	5e                   	pop    %esi
  803b81:	5f                   	pop    %edi
  803b82:	5d                   	pop    %ebp
  803b83:	c3                   	ret    
  803b84:	3b 04 24             	cmp    (%esp),%eax
  803b87:	72 06                	jb     803b8f <__umoddi3+0x113>
  803b89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b8d:	77 0f                	ja     803b9e <__umoddi3+0x122>
  803b8f:	89 f2                	mov    %esi,%edx
  803b91:	29 f9                	sub    %edi,%ecx
  803b93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b97:	89 14 24             	mov    %edx,(%esp)
  803b9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ba2:	8b 14 24             	mov    (%esp),%edx
  803ba5:	83 c4 1c             	add    $0x1c,%esp
  803ba8:	5b                   	pop    %ebx
  803ba9:	5e                   	pop    %esi
  803baa:	5f                   	pop    %edi
  803bab:	5d                   	pop    %ebp
  803bac:	c3                   	ret    
  803bad:	8d 76 00             	lea    0x0(%esi),%esi
  803bb0:	2b 04 24             	sub    (%esp),%eax
  803bb3:	19 fa                	sbb    %edi,%edx
  803bb5:	89 d1                	mov    %edx,%ecx
  803bb7:	89 c6                	mov    %eax,%esi
  803bb9:	e9 71 ff ff ff       	jmp    803b2f <__umoddi3+0xb3>
  803bbe:	66 90                	xchg   %ax,%ax
  803bc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bc4:	72 ea                	jb     803bb0 <__umoddi3+0x134>
  803bc6:	89 d9                	mov    %ebx,%ecx
  803bc8:	e9 62 ff ff ff       	jmp    803b2f <__umoddi3+0xb3>
