
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
  80003e:	e8 0b 19 00 00       	call   80194e <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 3c 80 00       	push   $0x803ca0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 bf 14 00 00       	call   801515 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 3c 80 00       	push   $0x803ca2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 a9 14 00 00       	call   801515 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 3c 80 00       	push   $0x803ca9
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
  800098:	68 b7 3c 80 00       	push   $0x803cb7
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 82 36 00 00       	call   803728 <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 8e 36 00 00       	call   803742 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 be 18 00 00       	call   801981 <sys_get_virtual_time>
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
  8000e6:	e8 96 36 00 00       	call   803781 <env_sleep>
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
  8000fe:	e8 7e 18 00 00       	call   801981 <sys_get_virtual_time>
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
  800126:	e8 56 36 00 00       	call   803781 <env_sleep>
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
  80013d:	e8 3f 18 00 00       	call   801981 <sys_get_virtual_time>
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
  800165:	e8 17 36 00 00       	call   803781 <env_sleep>
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
  800183:	e8 ad 17 00 00       	call   801935 <sys_getenvindex>
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
  8001f1:	e8 c3 14 00 00       	call   8016b9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 d4 3c 80 00       	push   $0x803cd4
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
  800221:	68 fc 3c 80 00       	push   $0x803cfc
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
  800252:	68 24 3d 80 00       	push   $0x803d24
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 7c 3d 80 00       	push   $0x803d7c
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 d4 3c 80 00       	push   $0x803cd4
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 43 14 00 00       	call   8016d3 <sys_unlock_cons>
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
  8002a3:	e8 59 16 00 00       	call   801901 <sys_destroy_env>
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
  8002b4:	e8 ae 16 00 00       	call   801967 <sys_exit_env>
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
  800302:	e8 70 13 00 00       	call   801677 <sys_cputs>
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
  800379:	e8 f9 12 00 00       	call   801677 <sys_cputs>
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
  8003c3:	e8 f1 12 00 00       	call   8016b9 <sys_lock_cons>
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
  8003e3:	e8 eb 12 00 00       	call   8016d3 <sys_unlock_cons>
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
  80042d:	e8 ee 35 00 00       	call   803a20 <__udivdi3>
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
  80047d:	e8 ae 36 00 00       	call   803b30 <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 b4 3f 80 00       	add    $0x803fb4,%eax
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
  8005d8:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
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
  8006b9:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 c5 3f 80 00       	push   $0x803fc5
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
  8006de:	68 ce 3f 80 00       	push   $0x803fce
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
  80070b:	be d1 3f 80 00       	mov    $0x803fd1,%esi
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
  801116:	68 48 41 80 00       	push   $0x804148
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 6a 41 80 00       	push   $0x80416a
  801125:	e8 0b 27 00 00       	call   803835 <_panic>

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
  801136:	e8 e7 0a 00 00       	call   801c22 <sys_sbrk>
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
  8011b1:	e8 f0 08 00 00       	call   801aa6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 30 0e 00 00       	call   801ff5 <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 02 09 00 00       	call   801ad7 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 c9 12 00 00       	call   8024b1 <alloc_block_BF>
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
  801349:	e8 0b 09 00 00       	call   801c59 <sys_allocate_user_mem>
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
  801391:	e8 df 08 00 00       	call   801c75 <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 12 1b 00 00       	call   802eb9 <free_block>
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
  801439:	e8 ff 07 00 00       	call   801c3d <sys_free_user_mem>
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
  801447:	68 78 41 80 00       	push   $0x804178
  80144c:	68 85 00 00 00       	push   $0x85
  801451:	68 a2 41 80 00       	push   $0x8041a2
  801456:	e8 da 23 00 00       	call   803835 <_panic>
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
  8014bc:	e8 83 03 00 00       	call   801844 <sys_createSharedObject>
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
  8014e0:	68 ae 41 80 00       	push   $0x8041ae
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
  801524:	e8 45 03 00 00       	call   80186e <sys_getSizeOfSharedObject>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80152f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801533:	75 07                	jne    80153c <sget+0x27>
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 5c                	jmp    801598 <sget+0x83>
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
  80156f:	eb 27                	jmp    801598 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	ff 75 e8             	pushl  -0x18(%ebp)
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 09 03 00 00       	call   80188b <sys_getSharedObject>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801588:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80158c:	75 07                	jne    801595 <sget+0x80>
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
  801593:	eb 03                	jmp    801598 <sget+0x83>
	return ptr;
  801595:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a8:	8b 40 78             	mov    0x78(%eax),%eax
  8015ab:	29 c2                	sub    %eax,%edx
  8015ad:	89 d0                	mov    %edx,%eax
  8015af:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b4:	c1 e8 0c             	shr    $0xc,%eax
  8015b7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ca:	e8 db 02 00 00       	call   8018aa <sys_freeSharedObject>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 c0 41 80 00       	push   $0x8041c0
  8015e6:	68 dd 00 00 00       	push   $0xdd
  8015eb:	68 a2 41 80 00       	push   $0x8041a2
  8015f0:	e8 40 22 00 00       	call   803835 <_panic>

008015f5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	68 e6 41 80 00       	push   $0x8041e6
  801603:	68 e9 00 00 00       	push   $0xe9
  801608:	68 a2 41 80 00       	push   $0x8041a2
  80160d:	e8 23 22 00 00       	call   803835 <_panic>

00801612 <shrink>:

}
void shrink(uint32 newSize)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	68 e6 41 80 00       	push   $0x8041e6
  801620:	68 ee 00 00 00       	push   $0xee
  801625:	68 a2 41 80 00       	push   $0x8041a2
  80162a:	e8 06 22 00 00       	call   803835 <_panic>

0080162f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	68 e6 41 80 00       	push   $0x8041e6
  80163d:	68 f3 00 00 00       	push   $0xf3
  801642:	68 a2 41 80 00       	push   $0x8041a2
  801647:	e8 e9 21 00 00       	call   803835 <_panic>

0080164c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	57                   	push   %edi
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801661:	8b 7d 18             	mov    0x18(%ebp),%edi
  801664:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801667:	cd 30                	int    $0x30
  801669:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80166c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	5b                   	pop    %ebx
  801673:	5e                   	pop    %esi
  801674:	5f                   	pop    %edi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801683:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	52                   	push   %edx
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	50                   	push   %eax
  801693:	6a 00                	push   $0x0
  801695:	e8 b2 ff ff ff       	call   80164c <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	90                   	nop
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 02                	push   $0x2
  8016af:	e8 98 ff ff ff       	call   80164c <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 03                	push   $0x3
  8016c8:	e8 7f ff ff ff       	call   80164c <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 04                	push   $0x4
  8016e2:	e8 65 ff ff ff       	call   80164c <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	52                   	push   %edx
  8016fd:	50                   	push   %eax
  8016fe:	6a 08                	push   $0x8
  801700:	e8 47 ff ff ff       	call   80164c <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170f:	8b 75 18             	mov    0x18(%ebp),%esi
  801712:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801715:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	51                   	push   %ecx
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 09                	push   $0x9
  801725:	e8 22 ff ff ff       	call   80164c <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	52                   	push   %edx
  801744:	50                   	push   %eax
  801745:	6a 0a                	push   $0xa
  801747:	e8 00 ff ff ff       	call   80164c <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	ff 75 08             	pushl  0x8(%ebp)
  801760:	6a 0b                	push   $0xb
  801762:	e8 e5 fe ff ff       	call   80164c <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 0c                	push   $0xc
  80177b:	e8 cc fe ff ff       	call   80164c <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 0d                	push   $0xd
  801794:	e8 b3 fe ff ff       	call   80164c <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 0e                	push   $0xe
  8017ad:	e8 9a fe ff ff       	call   80164c <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 0f                	push   $0xf
  8017c6:	e8 81 fe ff ff       	call   80164c <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 10                	push   $0x10
  8017e0:	e8 67 fe ff ff       	call   80164c <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 11                	push   $0x11
  8017f9:	e8 4e fe ff ff       	call   80164c <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	90                   	nop
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_cputc>:

void
sys_cputc(const char c)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801810:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	50                   	push   %eax
  80181d:	6a 01                	push   $0x1
  80181f:	e8 28 fe ff ff       	call   80164c <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	90                   	nop
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 14                	push   $0x14
  801839:	e8 0e fe ff ff       	call   80164c <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 45 10             	mov    0x10(%ebp),%eax
  80184d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801850:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801853:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	51                   	push   %ecx
  80185d:	52                   	push   %edx
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	50                   	push   %eax
  801862:	6a 15                	push   $0x15
  801864:	e8 e3 fd ff ff       	call   80164c <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 16                	push   $0x16
  801881:	e8 c6 fd ff ff       	call   80164c <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	51                   	push   %ecx
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 17                	push   $0x17
  8018a0:	e8 a7 fd ff ff       	call   80164c <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 18                	push   $0x18
  8018bd:	e8 8a fd ff ff       	call   80164c <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 14             	pushl  0x14(%ebp)
  8018d2:	ff 75 10             	pushl  0x10(%ebp)
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	50                   	push   %eax
  8018d9:	6a 19                	push   $0x19
  8018db:	e8 6c fd ff ff       	call   80164c <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	50                   	push   %eax
  8018f4:	6a 1a                	push   $0x1a
  8018f6:	e8 51 fd ff ff       	call   80164c <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	50                   	push   %eax
  801910:	6a 1b                	push   $0x1b
  801912:	e8 35 fd ff ff       	call   80164c <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 05                	push   $0x5
  80192b:	e8 1c fd ff ff       	call   80164c <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 06                	push   $0x6
  801944:	e8 03 fd ff ff       	call   80164c <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 07                	push   $0x7
  80195d:	e8 ea fc ff ff       	call   80164c <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_exit_env>:


void sys_exit_env(void)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 1c                	push   $0x1c
  801976:	e8 d1 fc ff ff       	call   80164c <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	90                   	nop
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801987:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80198a:	8d 50 04             	lea    0x4(%eax),%edx
  80198d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 1d                	push   $0x1d
  80199a:	e8 ad fc ff ff       	call   80164c <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ab:	89 01                	mov    %eax,(%ecx)
  8019ad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	c9                   	leave  
  8019b4:	c2 04 00             	ret    $0x4

008019b7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 13                	push   $0x13
  8019c9:	e8 7e fc ff ff       	call   80164c <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 1e                	push   $0x1e
  8019e3:	e8 64 fc ff ff       	call   80164c <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019f9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	50                   	push   %eax
  801a06:	6a 1f                	push   $0x1f
  801a08:	e8 3f fc ff ff       	call   80164c <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a10:	90                   	nop
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <rsttst>:
void rsttst()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 21                	push   $0x21
  801a22:	e8 25 fc ff ff       	call   80164c <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2a:	90                   	nop
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	8b 45 14             	mov    0x14(%ebp),%eax
  801a36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a39:	8b 55 18             	mov    0x18(%ebp),%edx
  801a3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	ff 75 10             	pushl  0x10(%ebp)
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	6a 20                	push   $0x20
  801a4d:	e8 fa fb ff ff       	call   80164c <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
	return ;
  801a55:	90                   	nop
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <chktst>:
void chktst(uint32 n)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	6a 22                	push   $0x22
  801a68:	e8 df fb ff ff       	call   80164c <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a70:	90                   	nop
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <inctst>:

void inctst()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 23                	push   $0x23
  801a82:	e8 c5 fb ff ff       	call   80164c <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <gettst>:
uint32 gettst()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 24                	push   $0x24
  801a9c:	e8 ab fb ff ff       	call   80164c <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 25                	push   $0x25
  801ab8:	e8 8f fb ff ff       	call   80164c <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
  801ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ac3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ac7:	75 07                	jne    801ad0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ace:	eb 05                	jmp    801ad5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 25                	push   $0x25
  801ae9:	e8 5e fb ff ff       	call   80164c <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
  801af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801af4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801af8:	75 07                	jne    801b01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801afa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aff:	eb 05                	jmp    801b06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 25                	push   $0x25
  801b1a:	e8 2d fb ff ff       	call   80164c <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b29:	75 07                	jne    801b32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b30:	eb 05                	jmp    801b37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 25                	push   $0x25
  801b4b:	e8 fc fa ff ff       	call   80164c <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
  801b53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b5a:	75 07                	jne    801b63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b61:	eb 05                	jmp    801b68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	6a 26                	push   $0x26
  801b7a:	e8 cd fa ff ff       	call   80164c <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	53                   	push   %ebx
  801b98:	51                   	push   %ecx
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 27                	push   $0x27
  801b9d:	e8 aa fa ff ff       	call   80164c <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 28                	push   $0x28
  801bbd:	e8 8a fa ff ff       	call   80164c <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	51                   	push   %ecx
  801bd6:	ff 75 10             	pushl  0x10(%ebp)
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 29                	push   $0x29
  801bdd:	e8 6a fa ff ff       	call   80164c <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 10             	pushl  0x10(%ebp)
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	6a 12                	push   $0x12
  801bf9:	e8 4e fa ff ff       	call   80164c <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801c01:	90                   	nop
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	52                   	push   %edx
  801c14:	50                   	push   %eax
  801c15:	6a 2a                	push   $0x2a
  801c17:	e8 30 fa ff ff       	call   80164c <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return;
  801c1f:	90                   	nop
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 2b                	push   $0x2b
  801c33:	e8 14 fa ff ff       	call   80164c <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	6a 2c                	push   $0x2c
  801c4e:	e8 f9 f9 ff ff       	call   80164c <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
	return;
  801c56:	90                   	nop
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 2d                	push   $0x2d
  801c6a:	e8 dd f9 ff ff       	call   80164c <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	83 e8 04             	sub    $0x4,%eax
  801c81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c87:	8b 00                	mov    (%eax),%eax
  801c89:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	83 e8 04             	sub    $0x4,%eax
  801c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	83 e0 01             	and    $0x1,%eax
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	0f 94 c0             	sete   %al
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	83 f8 02             	cmp    $0x2,%eax
  801cbf:	74 2b                	je     801cec <alloc_block+0x40>
  801cc1:	83 f8 02             	cmp    $0x2,%eax
  801cc4:	7f 07                	jg     801ccd <alloc_block+0x21>
  801cc6:	83 f8 01             	cmp    $0x1,%eax
  801cc9:	74 0e                	je     801cd9 <alloc_block+0x2d>
  801ccb:	eb 58                	jmp    801d25 <alloc_block+0x79>
  801ccd:	83 f8 03             	cmp    $0x3,%eax
  801cd0:	74 2d                	je     801cff <alloc_block+0x53>
  801cd2:	83 f8 04             	cmp    $0x4,%eax
  801cd5:	74 3b                	je     801d12 <alloc_block+0x66>
  801cd7:	eb 4c                	jmp    801d25 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	e8 11 03 00 00       	call   801ff5 <alloc_block_FF>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cea:	eb 4a                	jmp    801d36 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801cec:	83 ec 0c             	sub    $0xc,%esp
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	e8 fa 19 00 00       	call   8036f1 <alloc_block_NF>
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cfd:	eb 37                	jmp    801d36 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	e8 a7 07 00 00       	call   8024b1 <alloc_block_BF>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d10:	eb 24                	jmp    801d36 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	e8 b7 19 00 00       	call   8036d4 <alloc_block_WF>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d23:	eb 11                	jmp    801d36 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	68 f8 41 80 00       	push   $0x8041f8
  801d2d:	e8 5e e6 ff ff       	call   800390 <cprintf>
  801d32:	83 c4 10             	add    $0x10,%esp
		break;
  801d35:	90                   	nop
	}
	return va;
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	68 18 42 80 00       	push   $0x804218
  801d4a:	e8 41 e6 ff ff       	call   800390 <cprintf>
  801d4f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	68 43 42 80 00       	push   $0x804243
  801d5a:	e8 31 e6 ff ff       	call   800390 <cprintf>
  801d5f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d68:	eb 37                	jmp    801da1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d70:	e8 19 ff ff ff       	call   801c8e <is_free_block>
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	0f be d8             	movsbl %al,%ebx
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d81:	e8 ef fe ff ff       	call   801c75 <get_block_size>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	53                   	push   %ebx
  801d8d:	50                   	push   %eax
  801d8e:	68 5b 42 80 00       	push   $0x80425b
  801d93:	e8 f8 e5 ff ff       	call   800390 <cprintf>
  801d98:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da5:	74 07                	je     801dae <print_blocks_list+0x73>
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 00                	mov    (%eax),%eax
  801dac:	eb 05                	jmp    801db3 <print_blocks_list+0x78>
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
  801db3:	89 45 10             	mov    %eax,0x10(%ebp)
  801db6:	8b 45 10             	mov    0x10(%ebp),%eax
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	75 ad                	jne    801d6a <print_blocks_list+0x2f>
  801dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc1:	75 a7                	jne    801d6a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	68 18 42 80 00       	push   $0x804218
  801dcb:	e8 c0 e5 ff ff       	call   800390 <cprintf>
  801dd0:	83 c4 10             	add    $0x10,%esp

}
  801dd3:	90                   	nop
  801dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de2:	83 e0 01             	and    $0x1,%eax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	74 03                	je     801dec <initialize_dynamic_allocator+0x13>
  801de9:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801df0:	0f 84 c7 01 00 00    	je     801fbd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801df6:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801dfd:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e00:	8b 55 08             	mov    0x8(%ebp),%edx
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	01 d0                	add    %edx,%eax
  801e08:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e0d:	0f 87 ad 01 00 00    	ja     801fc0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	85 c0                	test   %eax,%eax
  801e18:	0f 89 a5 01 00 00    	jns    801fc3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	83 e8 04             	sub    $0x4,%eax
  801e29:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e35:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3d:	e9 87 00 00 00       	jmp    801ec9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e46:	75 14                	jne    801e5c <initialize_dynamic_allocator+0x83>
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	68 73 42 80 00       	push   $0x804273
  801e50:	6a 79                	push   $0x79
  801e52:	68 91 42 80 00       	push   $0x804291
  801e57:	e8 d9 19 00 00       	call   803835 <_panic>
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 10                	je     801e75 <initialize_dynamic_allocator+0x9c>
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	8b 00                	mov    (%eax),%eax
  801e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6d:	8b 52 04             	mov    0x4(%edx),%edx
  801e70:	89 50 04             	mov    %edx,0x4(%eax)
  801e73:	eb 0b                	jmp    801e80 <initialize_dynamic_allocator+0xa7>
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	8b 40 04             	mov    0x4(%eax),%eax
  801e7b:	a3 30 50 80 00       	mov    %eax,0x805030
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 40 04             	mov    0x4(%eax),%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	74 0f                	je     801e99 <initialize_dynamic_allocator+0xc0>
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 04             	mov    0x4(%eax),%eax
  801e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e93:	8b 12                	mov    (%edx),%edx
  801e95:	89 10                	mov    %edx,(%eax)
  801e97:	eb 0a                	jmp    801ea3 <initialize_dynamic_allocator+0xca>
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 00                	mov    (%eax),%eax
  801e9e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb6:	a1 38 50 80 00       	mov    0x805038,%eax
  801ebb:	48                   	dec    %eax
  801ebc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ec1:	a1 34 50 80 00       	mov    0x805034,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecd:	74 07                	je     801ed6 <initialize_dynamic_allocator+0xfd>
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	eb 05                	jmp    801edb <initialize_dynamic_allocator+0x102>
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	a3 34 50 80 00       	mov    %eax,0x805034
  801ee0:	a1 34 50 80 00       	mov    0x805034,%eax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	0f 85 55 ff ff ff    	jne    801e42 <initialize_dynamic_allocator+0x69>
  801eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef1:	0f 85 4b ff ff ff    	jne    801e42 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f06:	a1 44 50 80 00       	mov    0x805044,%eax
  801f0b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f10:	a1 40 50 80 00       	mov    0x805040,%eax
  801f15:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	83 c0 08             	add    $0x8,%eax
  801f21:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	83 c0 04             	add    $0x4,%eax
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	83 ea 08             	sub    $0x8,%edx
  801f30:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	01 d0                	add    %edx,%eax
  801f3a:	83 e8 08             	sub    $0x8,%eax
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	83 ea 08             	sub    $0x8,%edx
  801f43:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5c:	75 17                	jne    801f75 <initialize_dynamic_allocator+0x19c>
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	68 ac 42 80 00       	push   $0x8042ac
  801f66:	68 90 00 00 00       	push   $0x90
  801f6b:	68 91 42 80 00       	push   $0x804291
  801f70:	e8 c0 18 00 00       	call   803835 <_panic>
  801f75:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7e:	89 10                	mov    %edx,(%eax)
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	85 c0                	test   %eax,%eax
  801f87:	74 0d                	je     801f96 <initialize_dynamic_allocator+0x1bd>
  801f89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f91:	89 50 04             	mov    %edx,0x4(%eax)
  801f94:	eb 08                	jmp    801f9e <initialize_dynamic_allocator+0x1c5>
  801f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f99:	a3 30 50 80 00       	mov    %eax,0x805030
  801f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb0:	a1 38 50 80 00       	mov    0x805038,%eax
  801fb5:	40                   	inc    %eax
  801fb6:	a3 38 50 80 00       	mov    %eax,0x805038
  801fbb:	eb 07                	jmp    801fc4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fbd:	90                   	nop
  801fbe:	eb 04                	jmp    801fc4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fc0:	90                   	nop
  801fc1:	eb 01                	jmp    801fc4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fc3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	83 e8 04             	sub    $0x4,%eax
  801fe0:	8b 00                	mov    (%eax),%eax
  801fe2:	83 e0 fe             	and    $0xfffffffe,%eax
  801fe5:	8d 50 f8             	lea    -0x8(%eax),%edx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	01 c2                	add    %eax,%edx
  801fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff0:	89 02                	mov    %eax,(%edx)
}
  801ff2:	90                   	nop
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	83 e0 01             	and    $0x1,%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	74 03                	je     802008 <alloc_block_FF+0x13>
  802005:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802008:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80200c:	77 07                	ja     802015 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80200e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802015:	a1 24 50 80 00       	mov    0x805024,%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 73                	jne    802091 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	83 c0 10             	add    $0x10,%eax
  802024:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802027:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80202e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802034:	01 d0                	add    %edx,%eax
  802036:	48                   	dec    %eax
  802037:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80203a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203d:	ba 00 00 00 00       	mov    $0x0,%edx
  802042:	f7 75 ec             	divl   -0x14(%ebp)
  802045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802048:	29 d0                	sub    %edx,%eax
  80204a:	c1 e8 0c             	shr    $0xc,%eax
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	50                   	push   %eax
  802051:	e8 d4 f0 ff ff       	call   80112a <sbrk>
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	6a 00                	push   $0x0
  802061:	e8 c4 f0 ff ff       	call   80112a <sbrk>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80206c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80206f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802072:	83 ec 08             	sub    $0x8,%esp
  802075:	50                   	push   %eax
  802076:	ff 75 e4             	pushl  -0x1c(%ebp)
  802079:	e8 5b fd ff ff       	call   801dd9 <initialize_dynamic_allocator>
  80207e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	68 cf 42 80 00       	push   $0x8042cf
  802089:	e8 02 e3 ff ff       	call   800390 <cprintf>
  80208e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802095:	75 0a                	jne    8020a1 <alloc_block_FF+0xac>
	        return NULL;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	e9 0e 04 00 00       	jmp    8024af <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020a8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b0:	e9 f3 02 00 00       	jmp    8023a8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020bb:	83 ec 0c             	sub    $0xc,%esp
  8020be:	ff 75 bc             	pushl  -0x44(%ebp)
  8020c1:	e8 af fb ff ff       	call   801c75 <get_block_size>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	83 c0 08             	add    $0x8,%eax
  8020d2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020d5:	0f 87 c5 02 00 00    	ja     8023a0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	83 c0 18             	add    $0x18,%eax
  8020e1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020e4:	0f 87 19 02 00 00    	ja     802303 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8020f0:	83 e8 08             	sub    $0x8,%eax
  8020f3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	8d 50 08             	lea    0x8(%eax),%edx
  8020fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020ff:	01 d0                	add    %edx,%eax
  802101:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	83 c0 08             	add    $0x8,%eax
  80210a:	83 ec 04             	sub    $0x4,%esp
  80210d:	6a 01                	push   $0x1
  80210f:	50                   	push   %eax
  802110:	ff 75 bc             	pushl  -0x44(%ebp)
  802113:	e8 ae fe ff ff       	call   801fc6 <set_block_data>
  802118:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	75 68                	jne    80218d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802125:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802129:	75 17                	jne    802142 <alloc_block_FF+0x14d>
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	68 ac 42 80 00       	push   $0x8042ac
  802133:	68 d7 00 00 00       	push   $0xd7
  802138:	68 91 42 80 00       	push   $0x804291
  80213d:	e8 f3 16 00 00       	call   803835 <_panic>
  802142:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802148:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802150:	8b 00                	mov    (%eax),%eax
  802152:	85 c0                	test   %eax,%eax
  802154:	74 0d                	je     802163 <alloc_block_FF+0x16e>
  802156:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80215b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80215e:	89 50 04             	mov    %edx,0x4(%eax)
  802161:	eb 08                	jmp    80216b <alloc_block_FF+0x176>
  802163:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802166:	a3 30 50 80 00       	mov    %eax,0x805030
  80216b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80216e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802173:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217d:	a1 38 50 80 00       	mov    0x805038,%eax
  802182:	40                   	inc    %eax
  802183:	a3 38 50 80 00       	mov    %eax,0x805038
  802188:	e9 dc 00 00 00       	jmp    802269 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 65                	jne    8021fb <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802196:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80219a:	75 17                	jne    8021b3 <alloc_block_FF+0x1be>
  80219c:	83 ec 04             	sub    $0x4,%esp
  80219f:	68 e0 42 80 00       	push   $0x8042e0
  8021a4:	68 db 00 00 00       	push   $0xdb
  8021a9:	68 91 42 80 00       	push   $0x804291
  8021ae:	e8 82 16 00 00       	call   803835 <_panic>
  8021b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021bc:	89 50 04             	mov    %edx,0x4(%eax)
  8021bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 0c                	je     8021d5 <alloc_block_FF+0x1e0>
  8021c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8021ce:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	eb 08                	jmp    8021dd <alloc_block_FF+0x1e8>
  8021d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8021e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8021f3:	40                   	inc    %eax
  8021f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8021f9:	eb 6e                	jmp    802269 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ff:	74 06                	je     802207 <alloc_block_FF+0x212>
  802201:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802205:	75 17                	jne    80221e <alloc_block_FF+0x229>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 04 43 80 00       	push   $0x804304
  80220f:	68 df 00 00 00       	push   $0xdf
  802214:	68 91 42 80 00       	push   $0x804291
  802219:	e8 17 16 00 00       	call   803835 <_panic>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 10                	mov    (%eax),%edx
  802223:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802226:	89 10                	mov    %edx,(%eax)
  802228:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0b                	je     80223c <alloc_block_FF+0x247>
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802239:	89 50 04             	mov    %edx,0x4(%eax)
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802242:	89 10                	mov    %edx,(%eax)
  802244:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224a:	89 50 04             	mov    %edx,0x4(%eax)
  80224d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	85 c0                	test   %eax,%eax
  802254:	75 08                	jne    80225e <alloc_block_FF+0x269>
  802256:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802259:	a3 30 50 80 00       	mov    %eax,0x805030
  80225e:	a1 38 50 80 00       	mov    0x805038,%eax
  802263:	40                   	inc    %eax
  802264:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226d:	75 17                	jne    802286 <alloc_block_FF+0x291>
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 73 42 80 00       	push   $0x804273
  802277:	68 e1 00 00 00       	push   $0xe1
  80227c:	68 91 42 80 00       	push   $0x804291
  802281:	e8 af 15 00 00       	call   803835 <_panic>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	74 10                	je     80229f <alloc_block_FF+0x2aa>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802297:	8b 52 04             	mov    0x4(%edx),%edx
  80229a:	89 50 04             	mov    %edx,0x4(%eax)
  80229d:	eb 0b                	jmp    8022aa <alloc_block_FF+0x2b5>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 40 04             	mov    0x4(%eax),%eax
  8022a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 0f                	je     8022c3 <alloc_block_FF+0x2ce>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	8b 12                	mov    (%edx),%edx
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	eb 0a                	jmp    8022cd <alloc_block_FF+0x2d8>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e5:	48                   	dec    %eax
  8022e6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	6a 00                	push   $0x0
  8022f0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022f3:	ff 75 b0             	pushl  -0x50(%ebp)
  8022f6:	e8 cb fc ff ff       	call   801fc6 <set_block_data>
  8022fb:	83 c4 10             	add    $0x10,%esp
  8022fe:	e9 95 00 00 00       	jmp    802398 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802303:	83 ec 04             	sub    $0x4,%esp
  802306:	6a 01                	push   $0x1
  802308:	ff 75 b8             	pushl  -0x48(%ebp)
  80230b:	ff 75 bc             	pushl  -0x44(%ebp)
  80230e:	e8 b3 fc ff ff       	call   801fc6 <set_block_data>
  802313:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	75 17                	jne    802333 <alloc_block_FF+0x33e>
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	68 73 42 80 00       	push   $0x804273
  802324:	68 e8 00 00 00       	push   $0xe8
  802329:	68 91 42 80 00       	push   $0x804291
  80232e:	e8 02 15 00 00       	call   803835 <_panic>
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 10                	je     80234c <alloc_block_FF+0x357>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802344:	8b 52 04             	mov    0x4(%edx),%edx
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	eb 0b                	jmp    802357 <alloc_block_FF+0x362>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	a3 30 50 80 00       	mov    %eax,0x805030
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 0f                	je     802370 <alloc_block_FF+0x37b>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 04             	mov    0x4(%eax),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	8b 12                	mov    (%edx),%edx
  80236c:	89 10                	mov    %edx,(%eax)
  80236e:	eb 0a                	jmp    80237a <alloc_block_FF+0x385>
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
	            }
	            return va;
  802398:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80239b:	e9 0f 01 00 00       	jmp    8024af <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ac:	74 07                	je     8023b5 <alloc_block_FF+0x3c0>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	eb 05                	jmp    8023ba <alloc_block_FF+0x3c5>
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ba:	a3 34 50 80 00       	mov    %eax,0x805034
  8023bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	0f 85 e9 fc ff ff    	jne    8020b5 <alloc_block_FF+0xc0>
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	0f 85 df fc ff ff    	jne    8020b5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	83 c0 08             	add    $0x8,%eax
  8023dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023df:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ec:	01 d0                	add    %edx,%eax
  8023ee:	48                   	dec    %eax
  8023ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fa:	f7 75 d8             	divl   -0x28(%ebp)
  8023fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802400:	29 d0                	sub    %edx,%eax
  802402:	c1 e8 0c             	shr    $0xc,%eax
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	50                   	push   %eax
  802409:	e8 1c ed ff ff       	call   80112a <sbrk>
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802414:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802418:	75 0a                	jne    802424 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	e9 8b 00 00 00       	jmp    8024af <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802424:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80242b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80242e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802431:	01 d0                	add    %edx,%eax
  802433:	48                   	dec    %eax
  802434:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802437:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80243a:	ba 00 00 00 00       	mov    $0x0,%edx
  80243f:	f7 75 cc             	divl   -0x34(%ebp)
  802442:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802445:	29 d0                	sub    %edx,%eax
  802447:	8d 50 fc             	lea    -0x4(%eax),%edx
  80244a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80244d:	01 d0                	add    %edx,%eax
  80244f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802454:	a1 40 50 80 00       	mov    0x805040,%eax
  802459:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80245f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802466:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802469:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80246c:	01 d0                	add    %edx,%eax
  80246e:	48                   	dec    %eax
  80246f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802472:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802475:	ba 00 00 00 00       	mov    $0x0,%edx
  80247a:	f7 75 c4             	divl   -0x3c(%ebp)
  80247d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802480:	29 d0                	sub    %edx,%eax
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	6a 01                	push   $0x1
  802487:	50                   	push   %eax
  802488:	ff 75 d0             	pushl  -0x30(%ebp)
  80248b:	e8 36 fb ff ff       	call   801fc6 <set_block_data>
  802490:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	ff 75 d0             	pushl  -0x30(%ebp)
  802499:	e8 1b 0a 00 00       	call   802eb9 <free_block>
  80249e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024a1:	83 ec 0c             	sub    $0xc,%esp
  8024a4:	ff 75 08             	pushl  0x8(%ebp)
  8024a7:	e8 49 fb ff ff       	call   801ff5 <alloc_block_FF>
  8024ac:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	83 e0 01             	and    $0x1,%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 03                	je     8024c4 <alloc_block_BF+0x13>
  8024c1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024c4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024c8:	77 07                	ja     8024d1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024ca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024d1:	a1 24 50 80 00       	mov    0x805024,%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	75 73                	jne    80254d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	83 c0 10             	add    $0x10,%eax
  8024e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024e3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f0:	01 d0                	add    %edx,%eax
  8024f2:	48                   	dec    %eax
  8024f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fe:	f7 75 e0             	divl   -0x20(%ebp)
  802501:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802504:	29 d0                	sub    %edx,%eax
  802506:	c1 e8 0c             	shr    $0xc,%eax
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	50                   	push   %eax
  80250d:	e8 18 ec ff ff       	call   80112a <sbrk>
  802512:	83 c4 10             	add    $0x10,%esp
  802515:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	6a 00                	push   $0x0
  80251d:	e8 08 ec ff ff       	call   80112a <sbrk>
  802522:	83 c4 10             	add    $0x10,%esp
  802525:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80252e:	83 ec 08             	sub    $0x8,%esp
  802531:	50                   	push   %eax
  802532:	ff 75 d8             	pushl  -0x28(%ebp)
  802535:	e8 9f f8 ff ff       	call   801dd9 <initialize_dynamic_allocator>
  80253a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	68 cf 42 80 00       	push   $0x8042cf
  802545:	e8 46 de ff ff       	call   800390 <cprintf>
  80254a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80254d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802554:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80255b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802562:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802569:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80256e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802571:	e9 1d 01 00 00       	jmp    802693 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	ff 75 a8             	pushl  -0x58(%ebp)
  802582:	e8 ee f6 ff ff       	call   801c75 <get_block_size>
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	83 c0 08             	add    $0x8,%eax
  802593:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802596:	0f 87 ef 00 00 00    	ja     80268b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	83 c0 18             	add    $0x18,%eax
  8025a2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025a5:	77 1d                	ja     8025c4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ad:	0f 86 d8 00 00 00    	jbe    80268b <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025b9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025bf:	e9 c7 00 00 00       	jmp    80268b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	83 c0 08             	add    $0x8,%eax
  8025ca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025cd:	0f 85 9d 00 00 00    	jne    802670 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	6a 01                	push   $0x1
  8025d8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025db:	ff 75 a8             	pushl  -0x58(%ebp)
  8025de:	e8 e3 f9 ff ff       	call   801fc6 <set_block_data>
  8025e3:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	75 17                	jne    802603 <alloc_block_BF+0x152>
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	68 73 42 80 00       	push   $0x804273
  8025f4:	68 2c 01 00 00       	push   $0x12c
  8025f9:	68 91 42 80 00       	push   $0x804291
  8025fe:	e8 32 12 00 00       	call   803835 <_panic>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 10                	je     80261c <alloc_block_BF+0x16b>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802614:	8b 52 04             	mov    0x4(%edx),%edx
  802617:	89 50 04             	mov    %edx,0x4(%eax)
  80261a:	eb 0b                	jmp    802627 <alloc_block_BF+0x176>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	a3 30 50 80 00       	mov    %eax,0x805030
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 40 04             	mov    0x4(%eax),%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	74 0f                	je     802640 <alloc_block_BF+0x18f>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263a:	8b 12                	mov    (%edx),%edx
  80263c:	89 10                	mov    %edx,(%eax)
  80263e:	eb 0a                	jmp    80264a <alloc_block_BF+0x199>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265d:	a1 38 50 80 00       	mov    0x805038,%eax
  802662:	48                   	dec    %eax
  802663:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802668:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80266b:	e9 24 04 00 00       	jmp    802a94 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802676:	76 13                	jbe    80268b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802678:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80267f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802682:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802685:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802688:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80268b:	a1 34 50 80 00       	mov    0x805034,%eax
  802690:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802697:	74 07                	je     8026a0 <alloc_block_BF+0x1ef>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	eb 05                	jmp    8026a5 <alloc_block_BF+0x1f4>
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8026aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	0f 85 bf fe ff ff    	jne    802576 <alloc_block_BF+0xc5>
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	0f 85 b5 fe ff ff    	jne    802576 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c5:	0f 84 26 02 00 00    	je     8028f1 <alloc_block_BF+0x440>
  8026cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026cf:	0f 85 1c 02 00 00    	jne    8028f1 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026db:	83 e8 08             	sub    $0x8,%eax
  8026de:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	8d 50 08             	lea    0x8(%eax),%edx
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	83 c0 08             	add    $0x8,%eax
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	6a 01                	push   $0x1
  8026fa:	50                   	push   %eax
  8026fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fe:	e8 c3 f8 ff ff       	call   801fc6 <set_block_data>
  802703:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	75 68                	jne    802778 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802710:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802714:	75 17                	jne    80272d <alloc_block_BF+0x27c>
  802716:	83 ec 04             	sub    $0x4,%esp
  802719:	68 ac 42 80 00       	push   $0x8042ac
  80271e:	68 45 01 00 00       	push   $0x145
  802723:	68 91 42 80 00       	push   $0x804291
  802728:	e8 08 11 00 00       	call   803835 <_panic>
  80272d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802733:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802736:	89 10                	mov    %edx,(%eax)
  802738:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	74 0d                	je     80274e <alloc_block_BF+0x29d>
  802741:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802746:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802749:	89 50 04             	mov    %edx,0x4(%eax)
  80274c:	eb 08                	jmp    802756 <alloc_block_BF+0x2a5>
  80274e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802751:	a3 30 50 80 00       	mov    %eax,0x805030
  802756:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802759:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80275e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802761:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802768:	a1 38 50 80 00       	mov    0x805038,%eax
  80276d:	40                   	inc    %eax
  80276e:	a3 38 50 80 00       	mov    %eax,0x805038
  802773:	e9 dc 00 00 00       	jmp    802854 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	75 65                	jne    8027e6 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802781:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802785:	75 17                	jne    80279e <alloc_block_BF+0x2ed>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 e0 42 80 00       	push   $0x8042e0
  80278f:	68 4a 01 00 00       	push   $0x14a
  802794:	68 91 42 80 00       	push   $0x804291
  802799:	e8 97 10 00 00       	call   803835 <_panic>
  80279e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ad:	8b 40 04             	mov    0x4(%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	74 0c                	je     8027c0 <alloc_block_BF+0x30f>
  8027b4:	a1 30 50 80 00       	mov    0x805030,%eax
  8027b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027bc:	89 10                	mov    %edx,(%eax)
  8027be:	eb 08                	jmp    8027c8 <alloc_block_BF+0x317>
  8027c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8027de:	40                   	inc    %eax
  8027df:	a3 38 50 80 00       	mov    %eax,0x805038
  8027e4:	eb 6e                	jmp    802854 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ea:	74 06                	je     8027f2 <alloc_block_BF+0x341>
  8027ec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027f0:	75 17                	jne    802809 <alloc_block_BF+0x358>
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 04 43 80 00       	push   $0x804304
  8027fa:	68 4f 01 00 00       	push   $0x14f
  8027ff:	68 91 42 80 00       	push   $0x804291
  802804:	e8 2c 10 00 00       	call   803835 <_panic>
  802809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280c:	8b 10                	mov    (%eax),%edx
  80280e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802811:	89 10                	mov    %edx,(%eax)
  802813:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0b                	je     802827 <alloc_block_BF+0x376>
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802824:	89 50 04             	mov    %edx,0x4(%eax)
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80282d:	89 10                	mov    %edx,(%eax)
  80282f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802832:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	75 08                	jne    802849 <alloc_block_BF+0x398>
  802841:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802844:	a3 30 50 80 00       	mov    %eax,0x805030
  802849:	a1 38 50 80 00       	mov    0x805038,%eax
  80284e:	40                   	inc    %eax
  80284f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802854:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802858:	75 17                	jne    802871 <alloc_block_BF+0x3c0>
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 73 42 80 00       	push   $0x804273
  802862:	68 51 01 00 00       	push   $0x151
  802867:	68 91 42 80 00       	push   $0x804291
  80286c:	e8 c4 0f 00 00       	call   803835 <_panic>
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 10                	je     80288a <alloc_block_BF+0x3d9>
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802882:	8b 52 04             	mov    0x4(%edx),%edx
  802885:	89 50 04             	mov    %edx,0x4(%eax)
  802888:	eb 0b                	jmp    802895 <alloc_block_BF+0x3e4>
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	a3 30 50 80 00       	mov    %eax,0x805030
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 0f                	je     8028ae <alloc_block_BF+0x3fd>
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a8:	8b 12                	mov    (%edx),%edx
  8028aa:	89 10                	mov    %edx,(%eax)
  8028ac:	eb 0a                	jmp    8028b8 <alloc_block_BF+0x407>
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d0:	48                   	dec    %eax
  8028d1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	6a 00                	push   $0x0
  8028db:	ff 75 d0             	pushl  -0x30(%ebp)
  8028de:	ff 75 cc             	pushl  -0x34(%ebp)
  8028e1:	e8 e0 f6 ff ff       	call   801fc6 <set_block_data>
  8028e6:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	e9 a3 01 00 00       	jmp    802a94 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028f1:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028f5:	0f 85 9d 00 00 00    	jne    802998 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	6a 01                	push   $0x1
  802900:	ff 75 ec             	pushl  -0x14(%ebp)
  802903:	ff 75 f0             	pushl  -0x10(%ebp)
  802906:	e8 bb f6 ff ff       	call   801fc6 <set_block_data>
  80290b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80290e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802912:	75 17                	jne    80292b <alloc_block_BF+0x47a>
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	68 73 42 80 00       	push   $0x804273
  80291c:	68 58 01 00 00       	push   $0x158
  802921:	68 91 42 80 00       	push   $0x804291
  802926:	e8 0a 0f 00 00       	call   803835 <_panic>
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 10                	je     802944 <alloc_block_BF+0x493>
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293c:	8b 52 04             	mov    0x4(%edx),%edx
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
  802942:	eb 0b                	jmp    80294f <alloc_block_BF+0x49e>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	a3 30 50 80 00       	mov    %eax,0x805030
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	74 0f                	je     802968 <alloc_block_BF+0x4b7>
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	8b 40 04             	mov    0x4(%eax),%eax
  80295f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802962:	8b 12                	mov    (%edx),%edx
  802964:	89 10                	mov    %edx,(%eax)
  802966:	eb 0a                	jmp    802972 <alloc_block_BF+0x4c1>
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802985:	a1 38 50 80 00       	mov    0x805038,%eax
  80298a:	48                   	dec    %eax
  80298b:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802993:	e9 fc 00 00 00       	jmp    802a94 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	83 c0 08             	add    $0x8,%eax
  80299e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029a1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029a8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bc:	f7 75 c4             	divl   -0x3c(%ebp)
  8029bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029c2:	29 d0                	sub    %edx,%eax
  8029c4:	c1 e8 0c             	shr    $0xc,%eax
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	50                   	push   %eax
  8029cb:	e8 5a e7 ff ff       	call   80112a <sbrk>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029d6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029da:	75 0a                	jne    8029e6 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	e9 ae 00 00 00       	jmp    802a94 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029e6:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029ed:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	48                   	dec    %eax
  8029f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802a01:	f7 75 b8             	divl   -0x48(%ebp)
  802a04:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a07:	29 d0                	sub    %edx,%eax
  802a09:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a0c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a16:	a1 40 50 80 00       	mov    0x805040,%eax
  802a1b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a21:	83 ec 0c             	sub    $0xc,%esp
  802a24:	68 38 43 80 00       	push   $0x804338
  802a29:	e8 62 d9 ff ff       	call   800390 <cprintf>
  802a2e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a31:	83 ec 08             	sub    $0x8,%esp
  802a34:	ff 75 bc             	pushl  -0x44(%ebp)
  802a37:	68 3d 43 80 00       	push   $0x80433d
  802a3c:	e8 4f d9 ff ff       	call   800390 <cprintf>
  802a41:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a44:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a4b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a51:	01 d0                	add    %edx,%eax
  802a53:	48                   	dec    %eax
  802a54:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a57:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5f:	f7 75 b0             	divl   -0x50(%ebp)
  802a62:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a65:	29 d0                	sub    %edx,%eax
  802a67:	83 ec 04             	sub    $0x4,%esp
  802a6a:	6a 01                	push   $0x1
  802a6c:	50                   	push   %eax
  802a6d:	ff 75 bc             	pushl  -0x44(%ebp)
  802a70:	e8 51 f5 ff ff       	call   801fc6 <set_block_data>
  802a75:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a78:	83 ec 0c             	sub    $0xc,%esp
  802a7b:	ff 75 bc             	pushl  -0x44(%ebp)
  802a7e:	e8 36 04 00 00       	call   802eb9 <free_block>
  802a83:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a86:	83 ec 0c             	sub    $0xc,%esp
  802a89:	ff 75 08             	pushl  0x8(%ebp)
  802a8c:	e8 20 fa ff ff       	call   8024b1 <alloc_block_BF>
  802a91:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	53                   	push   %ebx
  802a9a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aa4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	74 1e                	je     802acf <merging+0x39>
  802ab1:	ff 75 08             	pushl  0x8(%ebp)
  802ab4:	e8 bc f1 ff ff       	call   801c75 <get_block_size>
  802ab9:	83 c4 04             	add    $0x4,%esp
  802abc:	89 c2                	mov    %eax,%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	01 d0                	add    %edx,%eax
  802ac3:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ac6:	75 07                	jne    802acf <merging+0x39>
		prev_is_free = 1;
  802ac8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ad3:	74 1e                	je     802af3 <merging+0x5d>
  802ad5:	ff 75 10             	pushl  0x10(%ebp)
  802ad8:	e8 98 f1 ff ff       	call   801c75 <get_block_size>
  802add:	83 c4 04             	add    $0x4,%esp
  802ae0:	89 c2                	mov    %eax,%edx
  802ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae5:	01 d0                	add    %edx,%eax
  802ae7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aea:	75 07                	jne    802af3 <merging+0x5d>
		next_is_free = 1;
  802aec:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	0f 84 cc 00 00 00    	je     802bc9 <merging+0x133>
  802afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b01:	0f 84 c2 00 00 00    	je     802bc9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b07:	ff 75 08             	pushl  0x8(%ebp)
  802b0a:	e8 66 f1 ff ff       	call   801c75 <get_block_size>
  802b0f:	83 c4 04             	add    $0x4,%esp
  802b12:	89 c3                	mov    %eax,%ebx
  802b14:	ff 75 10             	pushl  0x10(%ebp)
  802b17:	e8 59 f1 ff ff       	call   801c75 <get_block_size>
  802b1c:	83 c4 04             	add    $0x4,%esp
  802b1f:	01 c3                	add    %eax,%ebx
  802b21:	ff 75 0c             	pushl  0xc(%ebp)
  802b24:	e8 4c f1 ff ff       	call   801c75 <get_block_size>
  802b29:	83 c4 04             	add    $0x4,%esp
  802b2c:	01 d8                	add    %ebx,%eax
  802b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b31:	6a 00                	push   $0x0
  802b33:	ff 75 ec             	pushl  -0x14(%ebp)
  802b36:	ff 75 08             	pushl  0x8(%ebp)
  802b39:	e8 88 f4 ff ff       	call   801fc6 <set_block_data>
  802b3e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b45:	75 17                	jne    802b5e <merging+0xc8>
  802b47:	83 ec 04             	sub    $0x4,%esp
  802b4a:	68 73 42 80 00       	push   $0x804273
  802b4f:	68 7d 01 00 00       	push   $0x17d
  802b54:	68 91 42 80 00       	push   $0x804291
  802b59:	e8 d7 0c 00 00       	call   803835 <_panic>
  802b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	74 10                	je     802b77 <merging+0xe1>
  802b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6f:	8b 52 04             	mov    0x4(%edx),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 0b                	jmp    802b82 <merging+0xec>
  802b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	74 0f                	je     802b9b <merging+0x105>
  802b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b95:	8b 12                	mov    (%edx),%edx
  802b97:	89 10                	mov    %edx,(%eax)
  802b99:	eb 0a                	jmp    802ba5 <merging+0x10f>
  802b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbd:	48                   	dec    %eax
  802bbe:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802bc3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bc4:	e9 ea 02 00 00       	jmp    802eb3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	74 3b                	je     802c0a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bcf:	83 ec 0c             	sub    $0xc,%esp
  802bd2:	ff 75 08             	pushl  0x8(%ebp)
  802bd5:	e8 9b f0 ff ff       	call   801c75 <get_block_size>
  802bda:	83 c4 10             	add    $0x10,%esp
  802bdd:	89 c3                	mov    %eax,%ebx
  802bdf:	83 ec 0c             	sub    $0xc,%esp
  802be2:	ff 75 10             	pushl  0x10(%ebp)
  802be5:	e8 8b f0 ff ff       	call   801c75 <get_block_size>
  802bea:	83 c4 10             	add    $0x10,%esp
  802bed:	01 d8                	add    %ebx,%eax
  802bef:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	6a 00                	push   $0x0
  802bf7:	ff 75 e8             	pushl  -0x18(%ebp)
  802bfa:	ff 75 08             	pushl  0x8(%ebp)
  802bfd:	e8 c4 f3 ff ff       	call   801fc6 <set_block_data>
  802c02:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c05:	e9 a9 02 00 00       	jmp    802eb3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0e:	0f 84 2d 01 00 00    	je     802d41 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c14:	83 ec 0c             	sub    $0xc,%esp
  802c17:	ff 75 10             	pushl  0x10(%ebp)
  802c1a:	e8 56 f0 ff ff       	call   801c75 <get_block_size>
  802c1f:	83 c4 10             	add    $0x10,%esp
  802c22:	89 c3                	mov    %eax,%ebx
  802c24:	83 ec 0c             	sub    $0xc,%esp
  802c27:	ff 75 0c             	pushl  0xc(%ebp)
  802c2a:	e8 46 f0 ff ff       	call   801c75 <get_block_size>
  802c2f:	83 c4 10             	add    $0x10,%esp
  802c32:	01 d8                	add    %ebx,%eax
  802c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	6a 00                	push   $0x0
  802c3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c3f:	ff 75 10             	pushl  0x10(%ebp)
  802c42:	e8 7f f3 ff ff       	call   801fc6 <set_block_data>
  802c47:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c54:	74 06                	je     802c5c <merging+0x1c6>
  802c56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c5a:	75 17                	jne    802c73 <merging+0x1dd>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 4c 43 80 00       	push   $0x80434c
  802c64:	68 8d 01 00 00       	push   $0x18d
  802c69:	68 91 42 80 00       	push   $0x804291
  802c6e:	e8 c2 0b 00 00       	call   803835 <_panic>
  802c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c76:	8b 50 04             	mov    0x4(%eax),%edx
  802c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8a:	8b 40 04             	mov    0x4(%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	74 0d                	je     802c9e <merging+0x208>
  802c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9a:	89 10                	mov    %edx,(%eax)
  802c9c:	eb 08                	jmp    802ca6 <merging+0x210>
  802c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb4:	40                   	inc    %eax
  802cb5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cbe:	75 17                	jne    802cd7 <merging+0x241>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 73 42 80 00       	push   $0x804273
  802cc8:	68 8e 01 00 00       	push   $0x18e
  802ccd:	68 91 42 80 00       	push   $0x804291
  802cd2:	e8 5e 0b 00 00       	call   803835 <_panic>
  802cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 10                	je     802cf0 <merging+0x25a>
  802ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce8:	8b 52 04             	mov    0x4(%edx),%edx
  802ceb:	89 50 04             	mov    %edx,0x4(%eax)
  802cee:	eb 0b                	jmp    802cfb <merging+0x265>
  802cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	a3 30 50 80 00       	mov    %eax,0x805030
  802cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0f                	je     802d14 <merging+0x27e>
  802d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0e:	8b 12                	mov    (%edx),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	eb 0a                	jmp    802d1e <merging+0x288>
  802d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d31:	a1 38 50 80 00       	mov    0x805038,%eax
  802d36:	48                   	dec    %eax
  802d37:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d3c:	e9 72 01 00 00       	jmp    802eb3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d41:	8b 45 10             	mov    0x10(%ebp),%eax
  802d44:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4b:	74 79                	je     802dc6 <merging+0x330>
  802d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d51:	74 73                	je     802dc6 <merging+0x330>
  802d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d57:	74 06                	je     802d5f <merging+0x2c9>
  802d59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d5d:	75 17                	jne    802d76 <merging+0x2e0>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 04 43 80 00       	push   $0x804304
  802d67:	68 94 01 00 00       	push   $0x194
  802d6c:	68 91 42 80 00       	push   $0x804291
  802d71:	e8 bf 0a 00 00       	call   803835 <_panic>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 10                	mov    (%eax),%edx
  802d7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0b                	je     802d94 <merging+0x2fe>
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	75 08                	jne    802db6 <merging+0x320>
  802dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db1:	a3 30 50 80 00       	mov    %eax,0x805030
  802db6:	a1 38 50 80 00       	mov    0x805038,%eax
  802dbb:	40                   	inc    %eax
  802dbc:	a3 38 50 80 00       	mov    %eax,0x805038
  802dc1:	e9 ce 00 00 00       	jmp    802e94 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dca:	74 65                	je     802e31 <merging+0x39b>
  802dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dd0:	75 17                	jne    802de9 <merging+0x353>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 e0 42 80 00       	push   $0x8042e0
  802dda:	68 95 01 00 00       	push   $0x195
  802ddf:	68 91 42 80 00       	push   $0x804291
  802de4:	e8 4c 0a 00 00       	call   803835 <_panic>
  802de9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802def:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 0c                	je     802e0b <merging+0x375>
  802dff:	a1 30 50 80 00       	mov    0x805030,%eax
  802e04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 08                	jmp    802e13 <merging+0x37d>
  802e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e16:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e24:	a1 38 50 80 00       	mov    0x805038,%eax
  802e29:	40                   	inc    %eax
  802e2a:	a3 38 50 80 00       	mov    %eax,0x805038
  802e2f:	eb 63                	jmp    802e94 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e35:	75 17                	jne    802e4e <merging+0x3b8>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 ac 42 80 00       	push   $0x8042ac
  802e3f:	68 98 01 00 00       	push   $0x198
  802e44:	68 91 42 80 00       	push   $0x804291
  802e49:	e8 e7 09 00 00       	call   803835 <_panic>
  802e4e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 0d                	je     802e6f <merging+0x3d9>
  802e62:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	eb 08                	jmp    802e77 <merging+0x3e1>
  802e6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e72:	a3 30 50 80 00       	mov    %eax,0x805030
  802e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e89:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8e:	40                   	inc    %eax
  802e8f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	ff 75 10             	pushl  0x10(%ebp)
  802e9a:	e8 d6 ed ff ff       	call   801c75 <get_block_size>
  802e9f:	83 c4 10             	add    $0x10,%esp
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	6a 00                	push   $0x0
  802ea7:	50                   	push   %eax
  802ea8:	ff 75 10             	pushl  0x10(%ebp)
  802eab:	e8 16 f1 ff ff       	call   801fc6 <set_block_data>
  802eb0:	83 c4 10             	add    $0x10,%esp
	}
}
  802eb3:	90                   	nop
  802eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ebf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802ec7:	a1 30 50 80 00       	mov    0x805030,%eax
  802ecc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecf:	73 1b                	jae    802eec <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ed1:	a1 30 50 80 00       	mov    0x805030,%eax
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	ff 75 08             	pushl  0x8(%ebp)
  802edc:	6a 00                	push   $0x0
  802ede:	50                   	push   %eax
  802edf:	e8 b2 fb ff ff       	call   802a96 <merging>
  802ee4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ee7:	e9 8b 00 00 00       	jmp    802f77 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802eec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef4:	76 18                	jbe    802f0e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ef6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	ff 75 08             	pushl  0x8(%ebp)
  802f01:	50                   	push   %eax
  802f02:	6a 00                	push   $0x0
  802f04:	e8 8d fb ff ff       	call   802a96 <merging>
  802f09:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f0c:	eb 69                	jmp    802f77 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f0e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f16:	eb 39                	jmp    802f51 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1e:	73 29                	jae    802f49 <free_block+0x90>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f28:	76 1f                	jbe    802f49 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	ff 75 08             	pushl  0x8(%ebp)
  802f38:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3b:	ff 75 f4             	pushl  -0xc(%ebp)
  802f3e:	e8 53 fb ff ff       	call   802a96 <merging>
  802f43:	83 c4 10             	add    $0x10,%esp
			break;
  802f46:	90                   	nop
		}
	}
}
  802f47:	eb 2e                	jmp    802f77 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f49:	a1 34 50 80 00       	mov    0x805034,%eax
  802f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f55:	74 07                	je     802f5e <free_block+0xa5>
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	eb 05                	jmp    802f63 <free_block+0xaa>
  802f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f63:	a3 34 50 80 00       	mov    %eax,0x805034
  802f68:	a1 34 50 80 00       	mov    0x805034,%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	75 a7                	jne    802f18 <free_block+0x5f>
  802f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f75:	75 a1                	jne    802f18 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f77:	90                   	nop
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f80:	ff 75 08             	pushl  0x8(%ebp)
  802f83:	e8 ed ec ff ff       	call   801c75 <get_block_size>
  802f88:	83 c4 04             	add    $0x4,%esp
  802f8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f95:	eb 17                	jmp    802fae <copy_data+0x34>
  802f97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9d:	01 c2                	add    %eax,%edx
  802f9f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	01 c8                	add    %ecx,%eax
  802fa7:	8a 00                	mov    (%eax),%al
  802fa9:	88 02                	mov    %al,(%edx)
  802fab:	ff 45 fc             	incl   -0x4(%ebp)
  802fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fb4:	72 e1                	jb     802f97 <copy_data+0x1d>
}
  802fb6:	90                   	nop
  802fb7:	c9                   	leave  
  802fb8:	c3                   	ret    

00802fb9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
  802fbc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc3:	75 23                	jne    802fe8 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fc9:	74 13                	je     802fde <realloc_block_FF+0x25>
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	ff 75 0c             	pushl  0xc(%ebp)
  802fd1:	e8 1f f0 ff ff       	call   801ff5 <alloc_block_FF>
  802fd6:	83 c4 10             	add    $0x10,%esp
  802fd9:	e9 f4 06 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
		return NULL;
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe3:	e9 ea 06 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802fe8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fec:	75 18                	jne    803006 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	ff 75 08             	pushl  0x8(%ebp)
  802ff4:	e8 c0 fe ff ff       	call   802eb9 <free_block>
  802ff9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  803001:	e9 cc 06 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803006:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80300a:	77 07                	ja     803013 <realloc_block_FF+0x5a>
  80300c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	83 e0 01             	and    $0x1,%eax
  803019:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80301c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301f:	83 c0 08             	add    $0x8,%eax
  803022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	ff 75 08             	pushl  0x8(%ebp)
  80302b:	e8 45 ec ff ff       	call   801c75 <get_block_size>
  803030:	83 c4 10             	add    $0x10,%esp
  803033:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803036:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803039:	83 e8 08             	sub    $0x8,%eax
  80303c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	83 e8 04             	sub    $0x4,%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	83 e0 fe             	and    $0xfffffffe,%eax
  80304a:	89 c2                	mov    %eax,%edx
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	01 d0                	add    %edx,%eax
  803051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803054:	83 ec 0c             	sub    $0xc,%esp
  803057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305a:	e8 16 ec ff ff       	call   801c75 <get_block_size>
  80305f:	83 c4 10             	add    $0x10,%esp
  803062:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803068:	83 e8 08             	sub    $0x8,%eax
  80306b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80306e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803071:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803074:	75 08                	jne    80307e <realloc_block_FF+0xc5>
	{
		 return va;
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	e9 54 06 00 00       	jmp    8036d2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80307e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803081:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803084:	0f 83 e5 03 00 00    	jae    80346f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803090:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803093:	83 ec 0c             	sub    $0xc,%esp
  803096:	ff 75 e4             	pushl  -0x1c(%ebp)
  803099:	e8 f0 eb ff ff       	call   801c8e <is_free_block>
  80309e:	83 c4 10             	add    $0x10,%esp
  8030a1:	84 c0                	test   %al,%al
  8030a3:	0f 84 3b 01 00 00    	je     8031e4 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	6a 01                	push   $0x1
  8030b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8030bc:	ff 75 08             	pushl  0x8(%ebp)
  8030bf:	e8 02 ef ff ff       	call   801fc6 <set_block_data>
  8030c4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	83 e8 04             	sub    $0x4,%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8030d2:	89 c2                	mov    %eax,%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	01 d0                	add    %edx,%eax
  8030d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	6a 00                	push   $0x0
  8030e1:	ff 75 cc             	pushl  -0x34(%ebp)
  8030e4:	ff 75 c8             	pushl  -0x38(%ebp)
  8030e7:	e8 da ee ff ff       	call   801fc6 <set_block_data>
  8030ec:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030f3:	74 06                	je     8030fb <realloc_block_FF+0x142>
  8030f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030f9:	75 17                	jne    803112 <realloc_block_FF+0x159>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 04 43 80 00       	push   $0x804304
  803103:	68 f6 01 00 00       	push   $0x1f6
  803108:	68 91 42 80 00       	push   $0x804291
  80310d:	e8 23 07 00 00       	call   803835 <_panic>
  803112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803115:	8b 10                	mov    (%eax),%edx
  803117:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0b                	je     803130 <realloc_block_FF+0x177>
  803125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803133:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803136:	89 10                	mov    %edx,(%eax)
  803138:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80313b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 08                	jne    803152 <realloc_block_FF+0x199>
  80314a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80314d:	a3 30 50 80 00       	mov    %eax,0x805030
  803152:	a1 38 50 80 00       	mov    0x805038,%eax
  803157:	40                   	inc    %eax
  803158:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80315d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803161:	75 17                	jne    80317a <realloc_block_FF+0x1c1>
  803163:	83 ec 04             	sub    $0x4,%esp
  803166:	68 73 42 80 00       	push   $0x804273
  80316b:	68 f7 01 00 00       	push   $0x1f7
  803170:	68 91 42 80 00       	push   $0x804291
  803175:	e8 bb 06 00 00       	call   803835 <_panic>
  80317a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 10                	je     803193 <realloc_block_FF+0x1da>
  803183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80318b:	8b 52 04             	mov    0x4(%edx),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	eb 0b                	jmp    80319e <realloc_block_FF+0x1e5>
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	a3 30 50 80 00       	mov    %eax,0x805030
  80319e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a1:	8b 40 04             	mov    0x4(%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0f                	je     8031b7 <realloc_block_FF+0x1fe>
  8031a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b1:	8b 12                	mov    (%edx),%edx
  8031b3:	89 10                	mov    %edx,(%eax)
  8031b5:	eb 0a                	jmp    8031c1 <realloc_block_FF+0x208>
  8031b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d9:	48                   	dec    %eax
  8031da:	a3 38 50 80 00       	mov    %eax,0x805038
  8031df:	e9 83 02 00 00       	jmp    803467 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8031e4:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8031e8:	0f 86 69 02 00 00    	jbe    803457 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	6a 01                	push   $0x1
  8031f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031f6:	ff 75 08             	pushl  0x8(%ebp)
  8031f9:	e8 c8 ed ff ff       	call   801fc6 <set_block_data>
  8031fe:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	83 e8 04             	sub    $0x4,%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	83 e0 fe             	and    $0xfffffffe,%eax
  80320c:	89 c2                	mov    %eax,%edx
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	01 d0                	add    %edx,%eax
  803213:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803216:	a1 38 50 80 00       	mov    0x805038,%eax
  80321b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80321e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803222:	75 68                	jne    80328c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803224:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803228:	75 17                	jne    803241 <realloc_block_FF+0x288>
  80322a:	83 ec 04             	sub    $0x4,%esp
  80322d:	68 ac 42 80 00       	push   $0x8042ac
  803232:	68 06 02 00 00       	push   $0x206
  803237:	68 91 42 80 00       	push   $0x804291
  80323c:	e8 f4 05 00 00       	call   803835 <_panic>
  803241:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803247:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80324a:	89 10                	mov    %edx,(%eax)
  80324c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 0d                	je     803262 <realloc_block_FF+0x2a9>
  803255:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80325a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
  803260:	eb 08                	jmp    80326a <realloc_block_FF+0x2b1>
  803262:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803265:	a3 30 50 80 00       	mov    %eax,0x805030
  80326a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80326d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803272:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327c:	a1 38 50 80 00       	mov    0x805038,%eax
  803281:	40                   	inc    %eax
  803282:	a3 38 50 80 00       	mov    %eax,0x805038
  803287:	e9 b0 01 00 00       	jmp    80343c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80328c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803291:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803294:	76 68                	jbe    8032fe <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803296:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80329a:	75 17                	jne    8032b3 <realloc_block_FF+0x2fa>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 ac 42 80 00       	push   $0x8042ac
  8032a4:	68 0b 02 00 00       	push   $0x20b
  8032a9:	68 91 42 80 00       	push   $0x804291
  8032ae:	e8 82 05 00 00       	call   803835 <_panic>
  8032b3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 0d                	je     8032d4 <realloc_block_FF+0x31b>
  8032c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	eb 08                	jmp    8032dc <realloc_block_FF+0x323>
  8032d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f3:	40                   	inc    %eax
  8032f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8032f9:	e9 3e 01 00 00       	jmp    80343c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803303:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803306:	73 68                	jae    803370 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803308:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80330c:	75 17                	jne    803325 <realloc_block_FF+0x36c>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 e0 42 80 00       	push   $0x8042e0
  803316:	68 10 02 00 00       	push   $0x210
  80331b:	68 91 42 80 00       	push   $0x804291
  803320:	e8 10 05 00 00       	call   803835 <_panic>
  803325:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80332b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803334:	8b 40 04             	mov    0x4(%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	74 0c                	je     803347 <realloc_block_FF+0x38e>
  80333b:	a1 30 50 80 00       	mov    0x805030,%eax
  803340:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803343:	89 10                	mov    %edx,(%eax)
  803345:	eb 08                	jmp    80334f <realloc_block_FF+0x396>
  803347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80334f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803352:	a3 30 50 80 00       	mov    %eax,0x805030
  803357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803360:	a1 38 50 80 00       	mov    0x805038,%eax
  803365:	40                   	inc    %eax
  803366:	a3 38 50 80 00       	mov    %eax,0x805038
  80336b:	e9 cc 00 00 00       	jmp    80343c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803377:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80337c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337f:	e9 8a 00 00 00       	jmp    80340e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80338a:	73 7a                	jae    803406 <realloc_block_FF+0x44d>
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803394:	73 70                	jae    803406 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339a:	74 06                	je     8033a2 <realloc_block_FF+0x3e9>
  80339c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a0:	75 17                	jne    8033b9 <realloc_block_FF+0x400>
  8033a2:	83 ec 04             	sub    $0x4,%esp
  8033a5:	68 04 43 80 00       	push   $0x804304
  8033aa:	68 1a 02 00 00       	push   $0x21a
  8033af:	68 91 42 80 00       	push   $0x804291
  8033b4:	e8 7c 04 00 00       	call   803835 <_panic>
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	8b 10                	mov    (%eax),%edx
  8033be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c1:	89 10                	mov    %edx,(%eax)
  8033c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 0b                	je     8033d7 <realloc_block_FF+0x41e>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033dd:	89 10                	mov    %edx,(%eax)
  8033df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	75 08                	jne    8033f9 <realloc_block_FF+0x440>
  8033f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fe:	40                   	inc    %eax
  8033ff:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803404:	eb 36                	jmp    80343c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803406:	a1 34 50 80 00       	mov    0x805034,%eax
  80340b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803412:	74 07                	je     80341b <realloc_block_FF+0x462>
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	eb 05                	jmp    803420 <realloc_block_FF+0x467>
  80341b:	b8 00 00 00 00       	mov    $0x0,%eax
  803420:	a3 34 50 80 00       	mov    %eax,0x805034
  803425:	a1 34 50 80 00       	mov    0x805034,%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	0f 85 52 ff ff ff    	jne    803384 <realloc_block_FF+0x3cb>
  803432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803436:	0f 85 48 ff ff ff    	jne    803384 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	6a 00                	push   $0x0
  803441:	ff 75 d8             	pushl  -0x28(%ebp)
  803444:	ff 75 d4             	pushl  -0x2c(%ebp)
  803447:	e8 7a eb ff ff       	call   801fc6 <set_block_data>
  80344c:	83 c4 10             	add    $0x10,%esp
				return va;
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	e9 7b 02 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803457:	83 ec 0c             	sub    $0xc,%esp
  80345a:	68 81 43 80 00       	push   $0x804381
  80345f:	e8 2c cf ff ff       	call   800390 <cprintf>
  803464:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	e9 63 02 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80346f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803472:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803475:	0f 86 4d 02 00 00    	jbe    8036c8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80347b:	83 ec 0c             	sub    $0xc,%esp
  80347e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803481:	e8 08 e8 ff ff       	call   801c8e <is_free_block>
  803486:	83 c4 10             	add    $0x10,%esp
  803489:	84 c0                	test   %al,%al
  80348b:	0f 84 37 02 00 00    	je     8036c8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803491:	8b 45 0c             	mov    0xc(%ebp),%eax
  803494:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803497:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80349a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80349d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034a0:	76 38                	jbe    8034da <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034a2:	83 ec 0c             	sub    $0xc,%esp
  8034a5:	ff 75 08             	pushl  0x8(%ebp)
  8034a8:	e8 0c fa ff ff       	call   802eb9 <free_block>
  8034ad:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034b0:	83 ec 0c             	sub    $0xc,%esp
  8034b3:	ff 75 0c             	pushl  0xc(%ebp)
  8034b6:	e8 3a eb ff ff       	call   801ff5 <alloc_block_FF>
  8034bb:	83 c4 10             	add    $0x10,%esp
  8034be:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034c1:	83 ec 08             	sub    $0x8,%esp
  8034c4:	ff 75 c0             	pushl  -0x40(%ebp)
  8034c7:	ff 75 08             	pushl  0x8(%ebp)
  8034ca:	e8 ab fa ff ff       	call   802f7a <copy_data>
  8034cf:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034d5:	e9 f8 01 00 00       	jmp    8036d2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034e3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8034e7:	0f 87 a0 00 00 00    	ja     80358d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034f1:	75 17                	jne    80350a <realloc_block_FF+0x551>
  8034f3:	83 ec 04             	sub    $0x4,%esp
  8034f6:	68 73 42 80 00       	push   $0x804273
  8034fb:	68 38 02 00 00       	push   $0x238
  803500:	68 91 42 80 00       	push   $0x804291
  803505:	e8 2b 03 00 00       	call   803835 <_panic>
  80350a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	85 c0                	test   %eax,%eax
  803511:	74 10                	je     803523 <realloc_block_FF+0x56a>
  803513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80351b:	8b 52 04             	mov    0x4(%edx),%edx
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	eb 0b                	jmp    80352e <realloc_block_FF+0x575>
  803523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803526:	8b 40 04             	mov    0x4(%eax),%eax
  803529:	a3 30 50 80 00       	mov    %eax,0x805030
  80352e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803531:	8b 40 04             	mov    0x4(%eax),%eax
  803534:	85 c0                	test   %eax,%eax
  803536:	74 0f                	je     803547 <realloc_block_FF+0x58e>
  803538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353b:	8b 40 04             	mov    0x4(%eax),%eax
  80353e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803541:	8b 12                	mov    (%edx),%edx
  803543:	89 10                	mov    %edx,(%eax)
  803545:	eb 0a                	jmp    803551 <realloc_block_FF+0x598>
  803547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803564:	a1 38 50 80 00       	mov    0x805038,%eax
  803569:	48                   	dec    %eax
  80356a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80356f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803575:	01 d0                	add    %edx,%eax
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	6a 01                	push   $0x1
  80357c:	50                   	push   %eax
  80357d:	ff 75 08             	pushl  0x8(%ebp)
  803580:	e8 41 ea ff ff       	call   801fc6 <set_block_data>
  803585:	83 c4 10             	add    $0x10,%esp
  803588:	e9 36 01 00 00       	jmp    8036c3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80358d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803590:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803593:	01 d0                	add    %edx,%eax
  803595:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803598:	83 ec 04             	sub    $0x4,%esp
  80359b:	6a 01                	push   $0x1
  80359d:	ff 75 f0             	pushl  -0x10(%ebp)
  8035a0:	ff 75 08             	pushl  0x8(%ebp)
  8035a3:	e8 1e ea ff ff       	call   801fc6 <set_block_data>
  8035a8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	83 e8 04             	sub    $0x4,%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	83 e0 fe             	and    $0xfffffffe,%eax
  8035b6:	89 c2                	mov    %eax,%edx
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	01 d0                	add    %edx,%eax
  8035bd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035c4:	74 06                	je     8035cc <realloc_block_FF+0x613>
  8035c6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035ca:	75 17                	jne    8035e3 <realloc_block_FF+0x62a>
  8035cc:	83 ec 04             	sub    $0x4,%esp
  8035cf:	68 04 43 80 00       	push   $0x804304
  8035d4:	68 44 02 00 00       	push   $0x244
  8035d9:	68 91 42 80 00       	push   $0x804291
  8035de:	e8 52 02 00 00       	call   803835 <_panic>
  8035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e6:	8b 10                	mov    (%eax),%edx
  8035e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 0b                	je     803601 <realloc_block_FF+0x648>
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803604:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803607:	89 10                	mov    %edx,(%eax)
  803609:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80360c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	75 08                	jne    803623 <realloc_block_FF+0x66a>
  80361b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80361e:	a3 30 50 80 00       	mov    %eax,0x805030
  803623:	a1 38 50 80 00       	mov    0x805038,%eax
  803628:	40                   	inc    %eax
  803629:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80362e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803632:	75 17                	jne    80364b <realloc_block_FF+0x692>
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 73 42 80 00       	push   $0x804273
  80363c:	68 45 02 00 00       	push   $0x245
  803641:	68 91 42 80 00       	push   $0x804291
  803646:	e8 ea 01 00 00       	call   803835 <_panic>
  80364b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	74 10                	je     803664 <realloc_block_FF+0x6ab>
  803654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365c:	8b 52 04             	mov    0x4(%edx),%edx
  80365f:	89 50 04             	mov    %edx,0x4(%eax)
  803662:	eb 0b                	jmp    80366f <realloc_block_FF+0x6b6>
  803664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803667:	8b 40 04             	mov    0x4(%eax),%eax
  80366a:	a3 30 50 80 00       	mov    %eax,0x805030
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	8b 40 04             	mov    0x4(%eax),%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	74 0f                	je     803688 <realloc_block_FF+0x6cf>
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803682:	8b 12                	mov    (%edx),%edx
  803684:	89 10                	mov    %edx,(%eax)
  803686:	eb 0a                	jmp    803692 <realloc_block_FF+0x6d9>
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8036aa:	48                   	dec    %eax
  8036ab:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036b0:	83 ec 04             	sub    $0x4,%esp
  8036b3:	6a 00                	push   $0x0
  8036b5:	ff 75 bc             	pushl  -0x44(%ebp)
  8036b8:	ff 75 b8             	pushl  -0x48(%ebp)
  8036bb:	e8 06 e9 ff ff       	call   801fc6 <set_block_data>
  8036c0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	eb 0a                	jmp    8036d2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036c8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036d2:	c9                   	leave  
  8036d3:	c3                   	ret    

008036d4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036d4:	55                   	push   %ebp
  8036d5:	89 e5                	mov    %esp,%ebp
  8036d7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036da:	83 ec 04             	sub    $0x4,%esp
  8036dd:	68 88 43 80 00       	push   $0x804388
  8036e2:	68 58 02 00 00       	push   $0x258
  8036e7:	68 91 42 80 00       	push   $0x804291
  8036ec:	e8 44 01 00 00       	call   803835 <_panic>

008036f1 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036f1:	55                   	push   %ebp
  8036f2:	89 e5                	mov    %esp,%ebp
  8036f4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036f7:	83 ec 04             	sub    $0x4,%esp
  8036fa:	68 b0 43 80 00       	push   $0x8043b0
  8036ff:	68 61 02 00 00       	push   $0x261
  803704:	68 91 42 80 00       	push   $0x804291
  803709:	e8 27 01 00 00       	call   803835 <_panic>

0080370e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80370e:	55                   	push   %ebp
  80370f:	89 e5                	mov    %esp,%ebp
  803711:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803714:	83 ec 04             	sub    $0x4,%esp
  803717:	68 d8 43 80 00       	push   $0x8043d8
  80371c:	6a 09                	push   $0x9
  80371e:	68 00 44 80 00       	push   $0x804400
  803723:	e8 0d 01 00 00       	call   803835 <_panic>

00803728 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803728:	55                   	push   %ebp
  803729:	89 e5                	mov    %esp,%ebp
  80372b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80372e:	83 ec 04             	sub    $0x4,%esp
  803731:	68 10 44 80 00       	push   $0x804410
  803736:	6a 10                	push   $0x10
  803738:	68 00 44 80 00       	push   $0x804400
  80373d:	e8 f3 00 00 00       	call   803835 <_panic>

00803742 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803742:	55                   	push   %ebp
  803743:	89 e5                	mov    %esp,%ebp
  803745:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803748:	83 ec 04             	sub    $0x4,%esp
  80374b:	68 38 44 80 00       	push   $0x804438
  803750:	6a 18                	push   $0x18
  803752:	68 00 44 80 00       	push   $0x804400
  803757:	e8 d9 00 00 00       	call   803835 <_panic>

0080375c <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80375c:	55                   	push   %ebp
  80375d:	89 e5                	mov    %esp,%ebp
  80375f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803762:	83 ec 04             	sub    $0x4,%esp
  803765:	68 60 44 80 00       	push   $0x804460
  80376a:	6a 20                	push   $0x20
  80376c:	68 00 44 80 00       	push   $0x804400
  803771:	e8 bf 00 00 00       	call   803835 <_panic>

00803776 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803776:	55                   	push   %ebp
  803777:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 40 10             	mov    0x10(%eax),%eax
}
  80377f:	5d                   	pop    %ebp
  803780:	c3                   	ret    

00803781 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803781:	55                   	push   %ebp
  803782:	89 e5                	mov    %esp,%ebp
  803784:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803787:	8b 55 08             	mov    0x8(%ebp),%edx
  80378a:	89 d0                	mov    %edx,%eax
  80378c:	c1 e0 02             	shl    $0x2,%eax
  80378f:	01 d0                	add    %edx,%eax
  803791:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803798:	01 d0                	add    %edx,%eax
  80379a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037a1:	01 d0                	add    %edx,%eax
  8037a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037aa:	01 d0                	add    %edx,%eax
  8037ac:	c1 e0 04             	shl    $0x4,%eax
  8037af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8037b9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037bc:	83 ec 0c             	sub    $0xc,%esp
  8037bf:	50                   	push   %eax
  8037c0:	e8 bc e1 ff ff       	call   801981 <sys_get_virtual_time>
  8037c5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037c8:	eb 41                	jmp    80380b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037cd:	83 ec 0c             	sub    $0xc,%esp
  8037d0:	50                   	push   %eax
  8037d1:	e8 ab e1 ff ff       	call   801981 <sys_get_virtual_time>
  8037d6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037df:	29 c2                	sub    %eax,%edx
  8037e1:	89 d0                	mov    %edx,%eax
  8037e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ec:	89 d1                	mov    %edx,%ecx
  8037ee:	29 c1                	sub    %eax,%ecx
  8037f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f6:	39 c2                	cmp    %eax,%edx
  8037f8:	0f 97 c0             	seta   %al
  8037fb:	0f b6 c0             	movzbl %al,%eax
  8037fe:	29 c1                	sub    %eax,%ecx
  803800:	89 c8                	mov    %ecx,%eax
  803802:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803808:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80380b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803811:	72 b7                	jb     8037ca <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803813:	90                   	nop
  803814:	c9                   	leave  
  803815:	c3                   	ret    

00803816 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803816:	55                   	push   %ebp
  803817:	89 e5                	mov    %esp,%ebp
  803819:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80381c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803823:	eb 03                	jmp    803828 <busy_wait+0x12>
  803825:	ff 45 fc             	incl   -0x4(%ebp)
  803828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80382b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80382e:	72 f5                	jb     803825 <busy_wait+0xf>
	return i;
  803830:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803833:	c9                   	leave  
  803834:	c3                   	ret    

00803835 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
  803838:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80383b:	8d 45 10             	lea    0x10(%ebp),%eax
  80383e:	83 c0 04             	add    $0x4,%eax
  803841:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803844:	a1 60 50 98 00       	mov    0x985060,%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	74 16                	je     803863 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80384d:	a1 60 50 98 00       	mov    0x985060,%eax
  803852:	83 ec 08             	sub    $0x8,%esp
  803855:	50                   	push   %eax
  803856:	68 88 44 80 00       	push   $0x804488
  80385b:	e8 30 cb ff ff       	call   800390 <cprintf>
  803860:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803863:	a1 00 50 80 00       	mov    0x805000,%eax
  803868:	ff 75 0c             	pushl  0xc(%ebp)
  80386b:	ff 75 08             	pushl  0x8(%ebp)
  80386e:	50                   	push   %eax
  80386f:	68 8d 44 80 00       	push   $0x80448d
  803874:	e8 17 cb ff ff       	call   800390 <cprintf>
  803879:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80387c:	8b 45 10             	mov    0x10(%ebp),%eax
  80387f:	83 ec 08             	sub    $0x8,%esp
  803882:	ff 75 f4             	pushl  -0xc(%ebp)
  803885:	50                   	push   %eax
  803886:	e8 9a ca ff ff       	call   800325 <vcprintf>
  80388b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80388e:	83 ec 08             	sub    $0x8,%esp
  803891:	6a 00                	push   $0x0
  803893:	68 a9 44 80 00       	push   $0x8044a9
  803898:	e8 88 ca ff ff       	call   800325 <vcprintf>
  80389d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038a0:	e8 09 ca ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  8038a5:	eb fe                	jmp    8038a5 <_panic+0x70>

008038a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8038ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8038b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	74 14                	je     8038d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038bf:	83 ec 04             	sub    $0x4,%esp
  8038c2:	68 ac 44 80 00       	push   $0x8044ac
  8038c7:	6a 26                	push   $0x26
  8038c9:	68 f8 44 80 00       	push   $0x8044f8
  8038ce:	e8 62 ff ff ff       	call   803835 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038e1:	e9 c5 00 00 00       	jmp    8039ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f3:	01 d0                	add    %edx,%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	85 c0                	test   %eax,%eax
  8038f9:	75 08                	jne    803903 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038fe:	e9 a5 00 00 00       	jmp    8039a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803911:	eb 69                	jmp    80397c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803913:	a1 20 50 80 00       	mov    0x805020,%eax
  803918:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80391e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803921:	89 d0                	mov    %edx,%eax
  803923:	01 c0                	add    %eax,%eax
  803925:	01 d0                	add    %edx,%eax
  803927:	c1 e0 03             	shl    $0x3,%eax
  80392a:	01 c8                	add    %ecx,%eax
  80392c:	8a 40 04             	mov    0x4(%eax),%al
  80392f:	84 c0                	test   %al,%al
  803931:	75 46                	jne    803979 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803933:	a1 20 50 80 00       	mov    0x805020,%eax
  803938:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80393e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803941:	89 d0                	mov    %edx,%eax
  803943:	01 c0                	add    %eax,%eax
  803945:	01 d0                	add    %edx,%eax
  803947:	c1 e0 03             	shl    $0x3,%eax
  80394a:	01 c8                	add    %ecx,%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803951:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803959:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	01 c8                	add    %ecx,%eax
  80396a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80396c:	39 c2                	cmp    %eax,%edx
  80396e:	75 09                	jne    803979 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803970:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803977:	eb 15                	jmp    80398e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803979:	ff 45 e8             	incl   -0x18(%ebp)
  80397c:	a1 20 50 80 00       	mov    0x805020,%eax
  803981:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	39 c2                	cmp    %eax,%edx
  80398c:	77 85                	ja     803913 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80398e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803992:	75 14                	jne    8039a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 04 45 80 00       	push   $0x804504
  80399c:	6a 3a                	push   $0x3a
  80399e:	68 f8 44 80 00       	push   $0x8044f8
  8039a3:	e8 8d fe ff ff       	call   803835 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8039a8:	ff 45 f0             	incl   -0x10(%ebp)
  8039ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039b1:	0f 8c 2f ff ff ff    	jl     8038e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8039b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039c5:	eb 26                	jmp    8039ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8039cc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039d5:	89 d0                	mov    %edx,%eax
  8039d7:	01 c0                	add    %eax,%eax
  8039d9:	01 d0                	add    %edx,%eax
  8039db:	c1 e0 03             	shl    $0x3,%eax
  8039de:	01 c8                	add    %ecx,%eax
  8039e0:	8a 40 04             	mov    0x4(%eax),%al
  8039e3:	3c 01                	cmp    $0x1,%al
  8039e5:	75 03                	jne    8039ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039ea:	ff 45 e0             	incl   -0x20(%ebp)
  8039ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fb:	39 c2                	cmp    %eax,%edx
  8039fd:	77 c8                	ja     8039c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a05:	74 14                	je     803a1b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a07:	83 ec 04             	sub    $0x4,%esp
  803a0a:	68 58 45 80 00       	push   $0x804558
  803a0f:	6a 44                	push   $0x44
  803a11:	68 f8 44 80 00       	push   $0x8044f8
  803a16:	e8 1a fe ff ff       	call   803835 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a1b:	90                   	nop
  803a1c:	c9                   	leave  
  803a1d:	c3                   	ret    
  803a1e:	66 90                	xchg   %ax,%ax

00803a20 <__udivdi3>:
  803a20:	55                   	push   %ebp
  803a21:	57                   	push   %edi
  803a22:	56                   	push   %esi
  803a23:	53                   	push   %ebx
  803a24:	83 ec 1c             	sub    $0x1c,%esp
  803a27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a37:	89 ca                	mov    %ecx,%edx
  803a39:	89 f8                	mov    %edi,%eax
  803a3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a3f:	85 f6                	test   %esi,%esi
  803a41:	75 2d                	jne    803a70 <__udivdi3+0x50>
  803a43:	39 cf                	cmp    %ecx,%edi
  803a45:	77 65                	ja     803aac <__udivdi3+0x8c>
  803a47:	89 fd                	mov    %edi,%ebp
  803a49:	85 ff                	test   %edi,%edi
  803a4b:	75 0b                	jne    803a58 <__udivdi3+0x38>
  803a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a52:	31 d2                	xor    %edx,%edx
  803a54:	f7 f7                	div    %edi
  803a56:	89 c5                	mov    %eax,%ebp
  803a58:	31 d2                	xor    %edx,%edx
  803a5a:	89 c8                	mov    %ecx,%eax
  803a5c:	f7 f5                	div    %ebp
  803a5e:	89 c1                	mov    %eax,%ecx
  803a60:	89 d8                	mov    %ebx,%eax
  803a62:	f7 f5                	div    %ebp
  803a64:	89 cf                	mov    %ecx,%edi
  803a66:	89 fa                	mov    %edi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	39 ce                	cmp    %ecx,%esi
  803a72:	77 28                	ja     803a9c <__udivdi3+0x7c>
  803a74:	0f bd fe             	bsr    %esi,%edi
  803a77:	83 f7 1f             	xor    $0x1f,%edi
  803a7a:	75 40                	jne    803abc <__udivdi3+0x9c>
  803a7c:	39 ce                	cmp    %ecx,%esi
  803a7e:	72 0a                	jb     803a8a <__udivdi3+0x6a>
  803a80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a84:	0f 87 9e 00 00 00    	ja     803b28 <__udivdi3+0x108>
  803a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8f:	89 fa                	mov    %edi,%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	31 ff                	xor    %edi,%edi
  803a9e:	31 c0                	xor    %eax,%eax
  803aa0:	89 fa                	mov    %edi,%edx
  803aa2:	83 c4 1c             	add    $0x1c,%esp
  803aa5:	5b                   	pop    %ebx
  803aa6:	5e                   	pop    %esi
  803aa7:	5f                   	pop    %edi
  803aa8:	5d                   	pop    %ebp
  803aa9:	c3                   	ret    
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	89 d8                	mov    %ebx,%eax
  803aae:	f7 f7                	div    %edi
  803ab0:	31 ff                	xor    %edi,%edi
  803ab2:	89 fa                	mov    %edi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ac1:	89 eb                	mov    %ebp,%ebx
  803ac3:	29 fb                	sub    %edi,%ebx
  803ac5:	89 f9                	mov    %edi,%ecx
  803ac7:	d3 e6                	shl    %cl,%esi
  803ac9:	89 c5                	mov    %eax,%ebp
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 ed                	shr    %cl,%ebp
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	09 f1                	or     %esi,%ecx
  803ad3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ad7:	89 f9                	mov    %edi,%ecx
  803ad9:	d3 e0                	shl    %cl,%eax
  803adb:	89 c5                	mov    %eax,%ebp
  803add:	89 d6                	mov    %edx,%esi
  803adf:	88 d9                	mov    %bl,%cl
  803ae1:	d3 ee                	shr    %cl,%esi
  803ae3:	89 f9                	mov    %edi,%ecx
  803ae5:	d3 e2                	shl    %cl,%edx
  803ae7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aeb:	88 d9                	mov    %bl,%cl
  803aed:	d3 e8                	shr    %cl,%eax
  803aef:	09 c2                	or     %eax,%edx
  803af1:	89 d0                	mov    %edx,%eax
  803af3:	89 f2                	mov    %esi,%edx
  803af5:	f7 74 24 0c          	divl   0xc(%esp)
  803af9:	89 d6                	mov    %edx,%esi
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	f7 e5                	mul    %ebp
  803aff:	39 d6                	cmp    %edx,%esi
  803b01:	72 19                	jb     803b1c <__udivdi3+0xfc>
  803b03:	74 0b                	je     803b10 <__udivdi3+0xf0>
  803b05:	89 d8                	mov    %ebx,%eax
  803b07:	31 ff                	xor    %edi,%edi
  803b09:	e9 58 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b14:	89 f9                	mov    %edi,%ecx
  803b16:	d3 e2                	shl    %cl,%edx
  803b18:	39 c2                	cmp    %eax,%edx
  803b1a:	73 e9                	jae    803b05 <__udivdi3+0xe5>
  803b1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b1f:	31 ff                	xor    %edi,%edi
  803b21:	e9 40 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	31 c0                	xor    %eax,%eax
  803b2a:	e9 37 ff ff ff       	jmp    803a66 <__udivdi3+0x46>
  803b2f:	90                   	nop

00803b30 <__umoddi3>:
  803b30:	55                   	push   %ebp
  803b31:	57                   	push   %edi
  803b32:	56                   	push   %esi
  803b33:	53                   	push   %ebx
  803b34:	83 ec 1c             	sub    $0x1c,%esp
  803b37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b4f:	89 f3                	mov    %esi,%ebx
  803b51:	89 fa                	mov    %edi,%edx
  803b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b57:	89 34 24             	mov    %esi,(%esp)
  803b5a:	85 c0                	test   %eax,%eax
  803b5c:	75 1a                	jne    803b78 <__umoddi3+0x48>
  803b5e:	39 f7                	cmp    %esi,%edi
  803b60:	0f 86 a2 00 00 00    	jbe    803c08 <__umoddi3+0xd8>
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	89 f2                	mov    %esi,%edx
  803b6a:	f7 f7                	div    %edi
  803b6c:	89 d0                	mov    %edx,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	39 f0                	cmp    %esi,%eax
  803b7a:	0f 87 ac 00 00 00    	ja     803c2c <__umoddi3+0xfc>
  803b80:	0f bd e8             	bsr    %eax,%ebp
  803b83:	83 f5 1f             	xor    $0x1f,%ebp
  803b86:	0f 84 ac 00 00 00    	je     803c38 <__umoddi3+0x108>
  803b8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b91:	29 ef                	sub    %ebp,%edi
  803b93:	89 fe                	mov    %edi,%esi
  803b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b99:	89 e9                	mov    %ebp,%ecx
  803b9b:	d3 e0                	shl    %cl,%eax
  803b9d:	89 d7                	mov    %edx,%edi
  803b9f:	89 f1                	mov    %esi,%ecx
  803ba1:	d3 ef                	shr    %cl,%edi
  803ba3:	09 c7                	or     %eax,%edi
  803ba5:	89 e9                	mov    %ebp,%ecx
  803ba7:	d3 e2                	shl    %cl,%edx
  803ba9:	89 14 24             	mov    %edx,(%esp)
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	d3 e0                	shl    %cl,%eax
  803bb0:	89 c2                	mov    %eax,%edx
  803bb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb6:	d3 e0                	shl    %cl,%eax
  803bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc0:	89 f1                	mov    %esi,%ecx
  803bc2:	d3 e8                	shr    %cl,%eax
  803bc4:	09 d0                	or     %edx,%eax
  803bc6:	d3 eb                	shr    %cl,%ebx
  803bc8:	89 da                	mov    %ebx,%edx
  803bca:	f7 f7                	div    %edi
  803bcc:	89 d3                	mov    %edx,%ebx
  803bce:	f7 24 24             	mull   (%esp)
  803bd1:	89 c6                	mov    %eax,%esi
  803bd3:	89 d1                	mov    %edx,%ecx
  803bd5:	39 d3                	cmp    %edx,%ebx
  803bd7:	0f 82 87 00 00 00    	jb     803c64 <__umoddi3+0x134>
  803bdd:	0f 84 91 00 00 00    	je     803c74 <__umoddi3+0x144>
  803be3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803be7:	29 f2                	sub    %esi,%edx
  803be9:	19 cb                	sbb    %ecx,%ebx
  803beb:	89 d8                	mov    %ebx,%eax
  803bed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	d3 ea                	shr    %cl,%edx
  803bf7:	09 d0                	or     %edx,%eax
  803bf9:	89 e9                	mov    %ebp,%ecx
  803bfb:	d3 eb                	shr    %cl,%ebx
  803bfd:	89 da                	mov    %ebx,%edx
  803bff:	83 c4 1c             	add    $0x1c,%esp
  803c02:	5b                   	pop    %ebx
  803c03:	5e                   	pop    %esi
  803c04:	5f                   	pop    %edi
  803c05:	5d                   	pop    %ebp
  803c06:	c3                   	ret    
  803c07:	90                   	nop
  803c08:	89 fd                	mov    %edi,%ebp
  803c0a:	85 ff                	test   %edi,%edi
  803c0c:	75 0b                	jne    803c19 <__umoddi3+0xe9>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	31 d2                	xor    %edx,%edx
  803c15:	f7 f7                	div    %edi
  803c17:	89 c5                	mov    %eax,%ebp
  803c19:	89 f0                	mov    %esi,%eax
  803c1b:	31 d2                	xor    %edx,%edx
  803c1d:	f7 f5                	div    %ebp
  803c1f:	89 c8                	mov    %ecx,%eax
  803c21:	f7 f5                	div    %ebp
  803c23:	89 d0                	mov    %edx,%eax
  803c25:	e9 44 ff ff ff       	jmp    803b6e <__umoddi3+0x3e>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	89 c8                	mov    %ecx,%eax
  803c2e:	89 f2                	mov    %esi,%edx
  803c30:	83 c4 1c             	add    $0x1c,%esp
  803c33:	5b                   	pop    %ebx
  803c34:	5e                   	pop    %esi
  803c35:	5f                   	pop    %edi
  803c36:	5d                   	pop    %ebp
  803c37:	c3                   	ret    
  803c38:	3b 04 24             	cmp    (%esp),%eax
  803c3b:	72 06                	jb     803c43 <__umoddi3+0x113>
  803c3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c41:	77 0f                	ja     803c52 <__umoddi3+0x122>
  803c43:	89 f2                	mov    %esi,%edx
  803c45:	29 f9                	sub    %edi,%ecx
  803c47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c4b:	89 14 24             	mov    %edx,(%esp)
  803c4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c56:	8b 14 24             	mov    (%esp),%edx
  803c59:	83 c4 1c             	add    $0x1c,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5e                   	pop    %esi
  803c5e:	5f                   	pop    %edi
  803c5f:	5d                   	pop    %ebp
  803c60:	c3                   	ret    
  803c61:	8d 76 00             	lea    0x0(%esi),%esi
  803c64:	2b 04 24             	sub    (%esp),%eax
  803c67:	19 fa                	sbb    %edi,%edx
  803c69:	89 d1                	mov    %edx,%ecx
  803c6b:	89 c6                	mov    %eax,%esi
  803c6d:	e9 71 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c78:	72 ea                	jb     803c64 <__umoddi3+0x134>
  803c7a:	89 d9                	mov    %ebx,%ecx
  803c7c:	e9 62 ff ff ff       	jmp    803be3 <__umoddi3+0xb3>
