
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
  80003e:	e8 09 1a 00 00       	call   801a4c <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 80 3d 80 00       	push   $0x803d80
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 12 15 00 00       	call   801568 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 82 3d 80 00       	push   $0x803d82
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 fc 14 00 00       	call   801568 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 89 3d 80 00       	push   $0x803d89
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 e6 14 00 00       	call   801568 <sget>
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
  800098:	68 97 3d 80 00       	push   $0x803d97
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 80 37 00 00       	call   803826 <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 8c 37 00 00       	call   803840 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 bc 19 00 00       	call   801a7f <sys_get_virtual_time>
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
  8000e6:	e8 94 37 00 00       	call   80387f <env_sleep>
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
  8000fe:	e8 7c 19 00 00       	call   801a7f <sys_get_virtual_time>
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
  800126:	e8 54 37 00 00       	call   80387f <env_sleep>
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
  80013d:	e8 3d 19 00 00       	call   801a7f <sys_get_virtual_time>
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
  800165:	e8 15 37 00 00       	call   80387f <env_sleep>
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
  800183:	e8 ab 18 00 00       	call   801a33 <sys_getenvindex>
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
  8001f1:	e8 c1 15 00 00       	call   8017b7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	68 b4 3d 80 00       	push   $0x803db4
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
  800221:	68 dc 3d 80 00       	push   $0x803ddc
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
  800252:	68 04 3e 80 00       	push   $0x803e04
  800257:	e8 34 01 00 00       	call   800390 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 5c 3e 80 00       	push   $0x803e5c
  800273:	e8 18 01 00 00       	call   800390 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 b4 3d 80 00       	push   $0x803db4
  800283:	e8 08 01 00 00       	call   800390 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028b:	e8 41 15 00 00       	call   8017d1 <sys_unlock_cons>
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
  8002a3:	e8 57 17 00 00       	call   8019ff <sys_destroy_env>
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
  8002b4:	e8 ac 17 00 00       	call   801a65 <sys_exit_env>
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
  8002e7:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800302:	e8 6e 14 00 00       	call   801775 <sys_cputs>
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
  80035c:	a0 2c 50 80 00       	mov    0x80502c,%al
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	50                   	push   %eax
  80036e:	52                   	push   %edx
  80036f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800375:	83 c0 08             	add    $0x8,%eax
  800378:	50                   	push   %eax
  800379:	e8 f7 13 00 00       	call   801775 <sys_cputs>
  80037e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800381:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800396:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8003c3:	e8 ef 13 00 00       	call   8017b7 <sys_lock_cons>
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
  8003e3:	e8 e9 13 00 00       	call   8017d1 <sys_unlock_cons>
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
  80042d:	e8 ea 36 00 00       	call   803b1c <__udivdi3>
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
  80047d:	e8 aa 37 00 00       	call   803c2c <__umoddi3>
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	05 94 40 80 00       	add    $0x804094,%eax
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
  8005d8:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  8006b9:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  8006c0:	85 f6                	test   %esi,%esi
  8006c2:	75 19                	jne    8006dd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c4:	53                   	push   %ebx
  8006c5:	68 a5 40 80 00       	push   $0x8040a5
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
  8006de:	68 ae 40 80 00       	push   $0x8040ae
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
  80070b:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  800903:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  80090a:	eb 2c                	jmp    800938 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80090c:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801116:	68 28 42 80 00       	push   $0x804228
  80111b:	68 3f 01 00 00       	push   $0x13f
  801120:	68 4a 42 80 00       	push   $0x80424a
  801125:	e8 09 28 00 00       	call   803933 <_panic>

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
  801136:	e8 e5 0b 00 00       	call   801d20 <sys_sbrk>
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
  8011b1:	e8 ee 09 00 00       	call   801ba4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	74 16                	je     8011d0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011ba:	83 ec 0c             	sub    $0xc,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	e8 2e 0f 00 00       	call   8020f3 <alloc_block_FF>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	e9 8a 01 00 00       	jmp    80135a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d0:	e8 00 0a 00 00       	call   801bd5 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 84 7d 01 00 00    	je     80135a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 c7 13 00 00       	call   8025af <alloc_block_BF>
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
  801233:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801280:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8012d7:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801339:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	ff 75 f0             	pushl  -0x10(%ebp)
  801349:	e8 09 0a 00 00       	call   801d57 <sys_allocate_user_mem>
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
  801391:	e8 dd 09 00 00       	call   801d73 <get_block_size>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 10 1c 00 00       	call   802fb7 <free_block>
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
  8013dc:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801419:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801420:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	52                   	push   %edx
  80142e:	50                   	push   %eax
  80142f:	e8 07 09 00 00       	call   801d3b <sys_free_user_mem>
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
  801447:	68 58 42 80 00       	push   $0x804258
  80144c:	68 88 00 00 00       	push   $0x88
  801451:	68 82 42 80 00       	push   $0x804282
  801456:	e8 d8 24 00 00       	call   803933 <_panic>
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
  801475:	e9 ec 00 00 00       	jmp    801566 <smalloc+0x108>
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
  8014a6:	75 0a                	jne    8014b2 <smalloc+0x54>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	e9 b4 00 00 00       	jmp    801566 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014b2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b9:	50                   	push   %eax
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	ff 75 08             	pushl  0x8(%ebp)
  8014c0:	e8 7d 04 00 00       	call   801942 <sys_createSharedObject>
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014cb:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014cf:	74 06                	je     8014d7 <smalloc+0x79>
  8014d1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d5:	75 0a                	jne    8014e1 <smalloc+0x83>
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dc:	e9 85 00 00 00       	jmp    801566 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e7:	68 8e 42 80 00       	push   $0x80428e
  8014ec:	e8 9f ee ff ff       	call   800390 <cprintf>
  8014f1:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8014f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fc:	8b 40 78             	mov    0x78(%eax),%eax
  8014ff:	29 c2                	sub    %eax,%edx
  801501:	89 d0                	mov    %edx,%eax
  801503:	2d 00 10 00 00       	sub    $0x1000,%eax
  801508:	c1 e8 0c             	shr    $0xc,%eax
  80150b:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801511:	42                   	inc    %edx
  801512:	89 15 24 50 80 00    	mov    %edx,0x805024
  801518:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80151e:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801525:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801528:	a1 20 50 80 00       	mov    0x805020,%eax
  80152d:	8b 40 78             	mov    0x78(%eax),%eax
  801530:	29 c2                	sub    %eax,%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	2d 00 10 00 00       	sub    $0x1000,%eax
  801539:	c1 e8 0c             	shr    $0xc,%eax
  80153c:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801543:	a1 20 50 80 00       	mov    0x805020,%eax
  801548:	8b 50 10             	mov    0x10(%eax),%edx
  80154b:	89 c8                	mov    %ecx,%eax
  80154d:	c1 e0 02             	shl    $0x2,%eax
  801550:	89 c1                	mov    %eax,%ecx
  801552:	c1 e1 09             	shl    $0x9,%ecx
  801555:	01 c8                	add    %ecx,%eax
  801557:	01 c2                	add    %eax,%edx
  801559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80155c:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801563:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 f0 03 00 00       	call   80196c <sys_getSizeOfSharedObject>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801582:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801586:	75 0a                	jne    801592 <sget+0x2a>
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	e9 e7 00 00 00       	jmp    801679 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801598:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80159f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	39 d0                	cmp    %edx,%eax
  8015a7:	73 02                	jae    8015ab <sget+0x43>
  8015a9:	89 d0                	mov    %edx,%eax
  8015ab:	83 ec 0c             	sub    $0xc,%esp
  8015ae:	50                   	push   %eax
  8015af:	e8 8c fb ff ff       	call   801140 <malloc>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8015ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015be:	75 0a                	jne    8015ca <sget+0x62>
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	e9 af 00 00 00       	jmp    801679 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	ff 75 08             	pushl  0x8(%ebp)
  8015d6:	e8 ae 03 00 00       	call   801989 <sys_getSharedObject>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8015e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e9:	8b 40 78             	mov    0x78(%eax),%eax
  8015ec:	29 c2                	sub    %eax,%edx
  8015ee:	89 d0                	mov    %edx,%eax
  8015f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f5:	c1 e8 0c             	shr    $0xc,%eax
  8015f8:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015fe:	42                   	inc    %edx
  8015ff:	89 15 24 50 80 00    	mov    %edx,0x805024
  801605:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80160b:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801612:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801615:	a1 20 50 80 00       	mov    0x805020,%eax
  80161a:	8b 40 78             	mov    0x78(%eax),%eax
  80161d:	29 c2                	sub    %eax,%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	2d 00 10 00 00       	sub    $0x1000,%eax
  801626:	c1 e8 0c             	shr    $0xc,%eax
  801629:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801630:	a1 20 50 80 00       	mov    0x805020,%eax
  801635:	8b 50 10             	mov    0x10(%eax),%edx
  801638:	89 c8                	mov    %ecx,%eax
  80163a:	c1 e0 02             	shl    $0x2,%eax
  80163d:	89 c1                	mov    %eax,%ecx
  80163f:	c1 e1 09             	shl    $0x9,%ecx
  801642:	01 c8                	add    %ecx,%eax
  801644:	01 c2                	add    %eax,%edx
  801646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801649:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801650:	a1 20 50 80 00       	mov    0x805020,%eax
  801655:	8b 40 10             	mov    0x10(%eax),%eax
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	50                   	push   %eax
  80165c:	68 9d 42 80 00       	push   $0x80429d
  801661:	e8 2a ed ff ff       	call   800390 <cprintf>
  801666:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801669:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80166d:	75 07                	jne    801676 <sget+0x10e>
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
  801674:	eb 03                	jmp    801679 <sget+0x111>
	return ptr;
  801676:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801681:	8b 55 08             	mov    0x8(%ebp),%edx
  801684:	a1 20 50 80 00       	mov    0x805020,%eax
  801689:	8b 40 78             	mov    0x78(%eax),%eax
  80168c:	29 c2                	sub    %eax,%edx
  80168e:	89 d0                	mov    %edx,%eax
  801690:	2d 00 10 00 00       	sub    $0x1000,%eax
  801695:	c1 e8 0c             	shr    $0xc,%eax
  801698:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80169f:	a1 20 50 80 00       	mov    0x805020,%eax
  8016a4:	8b 50 10             	mov    0x10(%eax),%edx
  8016a7:	89 c8                	mov    %ecx,%eax
  8016a9:	c1 e0 02             	shl    $0x2,%eax
  8016ac:	89 c1                	mov    %eax,%ecx
  8016ae:	c1 e1 09             	shl    $0x9,%ecx
  8016b1:	01 c8                	add    %ecx,%eax
  8016b3:	01 d0                	add    %edx,%eax
  8016b5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8016bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c8:	e8 db 02 00 00       	call   8019a8 <sys_freeSharedObject>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8016d3:	90                   	nop
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 ac 42 80 00       	push   $0x8042ac
  8016e4:	68 e5 00 00 00       	push   $0xe5
  8016e9:	68 82 42 80 00       	push   $0x804282
  8016ee:	e8 40 22 00 00       	call   803933 <_panic>

008016f3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	68 d2 42 80 00       	push   $0x8042d2
  801701:	68 f1 00 00 00       	push   $0xf1
  801706:	68 82 42 80 00       	push   $0x804282
  80170b:	e8 23 22 00 00       	call   803933 <_panic>

00801710 <shrink>:

}
void shrink(uint32 newSize)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 d2 42 80 00       	push   $0x8042d2
  80171e:	68 f6 00 00 00       	push   $0xf6
  801723:	68 82 42 80 00       	push   $0x804282
  801728:	e8 06 22 00 00       	call   803933 <_panic>

0080172d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 d2 42 80 00       	push   $0x8042d2
  80173b:	68 fb 00 00 00       	push   $0xfb
  801740:	68 82 42 80 00       	push   $0x804282
  801745:	e8 e9 21 00 00       	call   803933 <_panic>

0080174a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	57                   	push   %edi
  80174e:	56                   	push   %esi
  80174f:	53                   	push   %ebx
  801750:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801762:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801765:	cd 30                	int    $0x30
  801767:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80176a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5f                   	pop    %edi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801781:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	52                   	push   %edx
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	50                   	push   %eax
  801791:	6a 00                	push   $0x0
  801793:	e8 b2 ff ff ff       	call   80174a <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	90                   	nop
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_cgetc>:

int
sys_cgetc(void)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 02                	push   $0x2
  8017ad:	e8 98 ff ff ff       	call   80174a <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 03                	push   $0x3
  8017c6:	e8 7f ff ff ff       	call   80174a <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 04                	push   $0x4
  8017e0:	e8 65 ff ff ff       	call   80174a <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	6a 08                	push   $0x8
  8017fe:	e8 47 ff ff ff       	call   80174a <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80180d:	8b 75 18             	mov    0x18(%ebp),%esi
  801810:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801813:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801816:	8b 55 0c             	mov    0xc(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	51                   	push   %ecx
  80181f:	52                   	push   %edx
  801820:	50                   	push   %eax
  801821:	6a 09                	push   $0x9
  801823:	e8 22 ff ff ff       	call   80174a <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801835:	8b 55 0c             	mov    0xc(%ebp),%edx
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 0a                	push   $0xa
  801845:	e8 00 ff ff ff       	call   80174a <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	ff 75 08             	pushl  0x8(%ebp)
  80185e:	6a 0b                	push   $0xb
  801860:	e8 e5 fe ff ff       	call   80174a <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 0c                	push   $0xc
  801879:	e8 cc fe ff ff       	call   80174a <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 0d                	push   $0xd
  801892:	e8 b3 fe ff ff       	call   80174a <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 0e                	push   $0xe
  8018ab:	e8 9a fe ff ff       	call   80174a <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 0f                	push   $0xf
  8018c4:	e8 81 fe ff ff       	call   80174a <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 08             	pushl  0x8(%ebp)
  8018dc:	6a 10                	push   $0x10
  8018de:	e8 67 fe ff ff       	call   80174a <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 11                	push   $0x11
  8018f7:	e8 4e fe ff ff       	call   80174a <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	90                   	nop
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_cputc>:

void
sys_cputc(const char c)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80190e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	50                   	push   %eax
  80191b:	6a 01                	push   $0x1
  80191d:	e8 28 fe ff ff       	call   80174a <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 14                	push   $0x14
  801937:	e8 0e fe ff ff       	call   80174a <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801951:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	6a 15                	push   $0x15
  801962:	e8 e3 fd ff ff       	call   80174a <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 16                	push   $0x16
  80197f:	e8 c6 fd ff ff       	call   80174a <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	51                   	push   %ecx
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 17                	push   $0x17
  80199e:	e8 a7 fd ff ff       	call   80174a <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 18                	push   $0x18
  8019bb:	e8 8a fd ff ff       	call   80174a <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 14             	pushl  0x14(%ebp)
  8019d0:	ff 75 10             	pushl  0x10(%ebp)
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	6a 19                	push   $0x19
  8019d9:	e8 6c fd ff ff       	call   80174a <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	50                   	push   %eax
  8019f2:	6a 1a                	push   $0x1a
  8019f4:	e8 51 fd ff ff       	call   80174a <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	50                   	push   %eax
  801a0e:	6a 1b                	push   $0x1b
  801a10:	e8 35 fd ff ff       	call   80174a <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 05                	push   $0x5
  801a29:	e8 1c fd ff ff       	call   80174a <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 06                	push   $0x6
  801a42:	e8 03 fd ff ff       	call   80174a <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 07                	push   $0x7
  801a5b:	e8 ea fc ff ff       	call   80174a <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_exit_env>:


void sys_exit_env(void)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 1c                	push   $0x1c
  801a74:	e8 d1 fc ff ff       	call   80174a <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a88:	8d 50 04             	lea    0x4(%eax),%edx
  801a8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	52                   	push   %edx
  801a95:	50                   	push   %eax
  801a96:	6a 1d                	push   $0x1d
  801a98:	e8 ad fc ff ff       	call   80174a <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return result;
  801aa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa9:	89 01                	mov    %eax,(%ecx)
  801aab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	c9                   	leave  
  801ab2:	c2 04 00             	ret    $0x4

00801ab5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	ff 75 10             	pushl  0x10(%ebp)
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	ff 75 08             	pushl  0x8(%ebp)
  801ac5:	6a 13                	push   $0x13
  801ac7:	e8 7e fc ff ff       	call   80174a <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return ;
  801acf:	90                   	nop
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 1e                	push   $0x1e
  801ae1:	e8 64 fc ff ff       	call   80174a <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	50                   	push   %eax
  801b04:	6a 1f                	push   $0x1f
  801b06:	e8 3f fc ff ff       	call   80174a <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <rsttst>:
void rsttst()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 21                	push   $0x21
  801b20:	e8 25 fc ff ff       	call   80174a <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return ;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 45 14             	mov    0x14(%ebp),%eax
  801b34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b37:	8b 55 18             	mov    0x18(%ebp),%edx
  801b3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3e:	52                   	push   %edx
  801b3f:	50                   	push   %eax
  801b40:	ff 75 10             	pushl  0x10(%ebp)
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	ff 75 08             	pushl  0x8(%ebp)
  801b49:	6a 20                	push   $0x20
  801b4b:	e8 fa fb ff ff       	call   80174a <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
	return ;
  801b53:	90                   	nop
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <chktst>:
void chktst(uint32 n)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	6a 22                	push   $0x22
  801b66:	e8 df fb ff ff       	call   80174a <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6e:	90                   	nop
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <inctst>:

void inctst()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 23                	push   $0x23
  801b80:	e8 c5 fb ff ff       	call   80174a <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return ;
  801b88:	90                   	nop
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <gettst>:
uint32 gettst()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 24                	push   $0x24
  801b9a:	e8 ab fb ff ff       	call   80174a <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 25                	push   $0x25
  801bb6:	e8 8f fb ff ff       	call   80174a <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
  801bbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bc1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bc5:	75 07                	jne    801bce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcc:	eb 05                	jmp    801bd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 25                	push   $0x25
  801be7:	e8 5e fb ff ff       	call   80174a <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
  801bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bf2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bf6:	75 07                	jne    801bff <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfd:	eb 05                	jmp    801c04 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 25                	push   $0x25
  801c18:	e8 2d fb ff ff       	call   80174a <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
  801c20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c23:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c27:	75 07                	jne    801c30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c29:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2e:	eb 05                	jmp    801c35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 25                	push   $0x25
  801c49:	e8 fc fa ff ff       	call   80174a <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
  801c51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c54:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c58:	75 07                	jne    801c61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5f:	eb 05                	jmp    801c66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 26                	push   $0x26
  801c78:	e8 cd fa ff ff       	call   80174a <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	53                   	push   %ebx
  801c96:	51                   	push   %ecx
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 27                	push   $0x27
  801c9b:	e8 aa fa ff ff       	call   80174a <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 28                	push   $0x28
  801cbb:	e8 8a fa ff ff       	call   80174a <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	51                   	push   %ecx
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 29                	push   $0x29
  801cdb:	e8 6a fa ff ff       	call   80174a <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	6a 12                	push   $0x12
  801cf7:	e8 4e fa ff ff       	call   80174a <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 2a                	push   $0x2a
  801d15:	e8 30 fa ff ff       	call   80174a <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return;
  801d1d:	90                   	nop
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	50                   	push   %eax
  801d2f:	6a 2b                	push   $0x2b
  801d31:	e8 14 fa ff ff       	call   80174a <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 2c                	push   $0x2c
  801d4c:	e8 f9 f9 ff ff       	call   80174a <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	6a 2d                	push   $0x2d
  801d68:	e8 dd f9 ff ff       	call   80174a <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	83 e8 04             	sub    $0x4,%eax
  801d7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d85:	8b 00                	mov    (%eax),%eax
  801d87:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	83 e8 04             	sub    $0x4,%eax
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	83 e0 01             	and    $0x1,%eax
  801da3:	85 c0                	test   %eax,%eax
  801da5:	0f 94 c0             	sete   %al
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801db0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	83 f8 02             	cmp    $0x2,%eax
  801dbd:	74 2b                	je     801dea <alloc_block+0x40>
  801dbf:	83 f8 02             	cmp    $0x2,%eax
  801dc2:	7f 07                	jg     801dcb <alloc_block+0x21>
  801dc4:	83 f8 01             	cmp    $0x1,%eax
  801dc7:	74 0e                	je     801dd7 <alloc_block+0x2d>
  801dc9:	eb 58                	jmp    801e23 <alloc_block+0x79>
  801dcb:	83 f8 03             	cmp    $0x3,%eax
  801dce:	74 2d                	je     801dfd <alloc_block+0x53>
  801dd0:	83 f8 04             	cmp    $0x4,%eax
  801dd3:	74 3b                	je     801e10 <alloc_block+0x66>
  801dd5:	eb 4c                	jmp    801e23 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	e8 11 03 00 00       	call   8020f3 <alloc_block_FF>
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801de8:	eb 4a                	jmp    801e34 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801dea:	83 ec 0c             	sub    $0xc,%esp
  801ded:	ff 75 08             	pushl  0x8(%ebp)
  801df0:	e8 fa 19 00 00       	call   8037ef <alloc_block_NF>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dfb:	eb 37                	jmp    801e34 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	e8 a7 07 00 00       	call   8025af <alloc_block_BF>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0e:	eb 24                	jmp    801e34 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	e8 b7 19 00 00       	call   8037d2 <alloc_block_WF>
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e21:	eb 11                	jmp    801e34 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	68 e4 42 80 00       	push   $0x8042e4
  801e2b:	e8 60 e5 ff ff       	call   800390 <cprintf>
  801e30:	83 c4 10             	add    $0x10,%esp
		break;
  801e33:	90                   	nop
	}
	return va;
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	53                   	push   %ebx
  801e3d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	68 04 43 80 00       	push   $0x804304
  801e48:	e8 43 e5 ff ff       	call   800390 <cprintf>
  801e4d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	68 2f 43 80 00       	push   $0x80432f
  801e58:	e8 33 e5 ff ff       	call   800390 <cprintf>
  801e5d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e66:	eb 37                	jmp    801e9f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6e:	e8 19 ff ff ff       	call   801d8c <is_free_block>
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	0f be d8             	movsbl %al,%ebx
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7f:	e8 ef fe ff ff       	call   801d73 <get_block_size>
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	53                   	push   %ebx
  801e8b:	50                   	push   %eax
  801e8c:	68 47 43 80 00       	push   $0x804347
  801e91:	e8 fa e4 ff ff       	call   800390 <cprintf>
  801e96:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e99:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea3:	74 07                	je     801eac <print_blocks_list+0x73>
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	8b 00                	mov    (%eax),%eax
  801eaa:	eb 05                	jmp    801eb1 <print_blocks_list+0x78>
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	89 45 10             	mov    %eax,0x10(%ebp)
  801eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	75 ad                	jne    801e68 <print_blocks_list+0x2f>
  801ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebf:	75 a7                	jne    801e68 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	68 04 43 80 00       	push   $0x804304
  801ec9:	e8 c2 e4 ff ff       	call   800390 <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp

}
  801ed1:	90                   	nop
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee0:	83 e0 01             	and    $0x1,%eax
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	74 03                	je     801eea <initialize_dynamic_allocator+0x13>
  801ee7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801eea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eee:	0f 84 c7 01 00 00    	je     8020bb <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ef4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  801efb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801efe:	8b 55 08             	mov    0x8(%ebp),%edx
  801f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f0b:	0f 87 ad 01 00 00    	ja     8020be <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	85 c0                	test   %eax,%eax
  801f16:	0f 89 a5 01 00 00    	jns    8020c1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f22:	01 d0                	add    %edx,%eax
  801f24:	83 e8 04             	sub    $0x4,%eax
  801f27:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  801f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f33:	a1 30 50 80 00       	mov    0x805030,%eax
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3b:	e9 87 00 00 00       	jmp    801fc7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f44:	75 14                	jne    801f5a <initialize_dynamic_allocator+0x83>
  801f46:	83 ec 04             	sub    $0x4,%esp
  801f49:	68 5f 43 80 00       	push   $0x80435f
  801f4e:	6a 79                	push   $0x79
  801f50:	68 7d 43 80 00       	push   $0x80437d
  801f55:	e8 d9 19 00 00       	call   803933 <_panic>
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	74 10                	je     801f73 <initialize_dynamic_allocator+0x9c>
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 00                	mov    (%eax),%eax
  801f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6b:	8b 52 04             	mov    0x4(%edx),%edx
  801f6e:	89 50 04             	mov    %edx,0x4(%eax)
  801f71:	eb 0b                	jmp    801f7e <initialize_dynamic_allocator+0xa7>
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 04             	mov    0x4(%eax),%eax
  801f79:	a3 34 50 80 00       	mov    %eax,0x805034
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	8b 40 04             	mov    0x4(%eax),%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	74 0f                	je     801f97 <initialize_dynamic_allocator+0xc0>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 40 04             	mov    0x4(%eax),%eax
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	8b 12                	mov    (%edx),%edx
  801f93:	89 10                	mov    %edx,(%eax)
  801f95:	eb 0a                	jmp    801fa1 <initialize_dynamic_allocator+0xca>
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  801fb9:	48                   	dec    %eax
  801fba:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fbf:	a1 38 50 80 00       	mov    0x805038,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	74 07                	je     801fd4 <initialize_dynamic_allocator+0xfd>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 00                	mov    (%eax),%eax
  801fd2:	eb 05                	jmp    801fd9 <initialize_dynamic_allocator+0x102>
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	a3 38 50 80 00       	mov    %eax,0x805038
  801fde:	a1 38 50 80 00       	mov    0x805038,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 85 55 ff ff ff    	jne    801f40 <initialize_dynamic_allocator+0x69>
  801feb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fef:	0f 85 4b ff ff ff    	jne    801f40 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802004:	a1 48 50 80 00       	mov    0x805048,%eax
  802009:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80200e:	a1 44 50 80 00       	mov    0x805044,%eax
  802013:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	83 c0 08             	add    $0x8,%eax
  80201f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	83 c0 04             	add    $0x4,%eax
  802028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202b:	83 ea 08             	sub    $0x8,%edx
  80202e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	83 e8 08             	sub    $0x8,%eax
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	83 ea 08             	sub    $0x8,%edx
  802041:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80204c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802056:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80205a:	75 17                	jne    802073 <initialize_dynamic_allocator+0x19c>
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	68 98 43 80 00       	push   $0x804398
  802064:	68 90 00 00 00       	push   $0x90
  802069:	68 7d 43 80 00       	push   $0x80437d
  80206e:	e8 c0 18 00 00       	call   803933 <_panic>
  802073:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207c:	89 10                	mov    %edx,(%eax)
  80207e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	85 c0                	test   %eax,%eax
  802085:	74 0d                	je     802094 <initialize_dynamic_allocator+0x1bd>
  802087:	a1 30 50 80 00       	mov    0x805030,%eax
  80208c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208f:	89 50 04             	mov    %edx,0x4(%eax)
  802092:	eb 08                	jmp    80209c <initialize_dynamic_allocator+0x1c5>
  802094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802097:	a3 34 50 80 00       	mov    %eax,0x805034
  80209c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209f:	a3 30 50 80 00       	mov    %eax,0x805030
  8020a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8020b3:	40                   	inc    %eax
  8020b4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8020b9:	eb 07                	jmp    8020c2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020bb:	90                   	nop
  8020bc:	eb 04                	jmp    8020c2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020be:	90                   	nop
  8020bf:	eb 01                	jmp    8020c2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020c1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ca:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	83 e8 04             	sub    $0x4,%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	83 e0 fe             	and    $0xfffffffe,%eax
  8020e3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	01 c2                	add    %eax,%edx
  8020eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ee:	89 02                	mov    %eax,(%edx)
}
  8020f0:	90                   	nop
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    

008020f3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	83 e0 01             	and    $0x1,%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	74 03                	je     802106 <alloc_block_FF+0x13>
  802103:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802106:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80210a:	77 07                	ja     802113 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80210c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802113:	a1 28 50 80 00       	mov    0x805028,%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	75 73                	jne    80218f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	83 c0 10             	add    $0x10,%eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802125:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80212c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802132:	01 d0                	add    %edx,%eax
  802134:	48                   	dec    %eax
  802135:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213b:	ba 00 00 00 00       	mov    $0x0,%edx
  802140:	f7 75 ec             	divl   -0x14(%ebp)
  802143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802146:	29 d0                	sub    %edx,%eax
  802148:	c1 e8 0c             	shr    $0xc,%eax
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	50                   	push   %eax
  80214f:	e8 d6 ef ff ff       	call   80112a <sbrk>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	6a 00                	push   $0x0
  80215f:	e8 c6 ef ff ff       	call   80112a <sbrk>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80216a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802170:	83 ec 08             	sub    $0x8,%esp
  802173:	50                   	push   %eax
  802174:	ff 75 e4             	pushl  -0x1c(%ebp)
  802177:	e8 5b fd ff ff       	call   801ed7 <initialize_dynamic_allocator>
  80217c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	68 bb 43 80 00       	push   $0x8043bb
  802187:	e8 04 e2 ff ff       	call   800390 <cprintf>
  80218c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80218f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802193:	75 0a                	jne    80219f <alloc_block_FF+0xac>
	        return NULL;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	e9 0e 04 00 00       	jmp    8025ad <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80219f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021a6:	a1 30 50 80 00       	mov    0x805030,%eax
  8021ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ae:	e9 f3 02 00 00       	jmp    8024a6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8021bf:	e8 af fb ff ff       	call   801d73 <get_block_size>
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	83 c0 08             	add    $0x8,%eax
  8021d0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021d3:	0f 87 c5 02 00 00    	ja     80249e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	83 c0 18             	add    $0x18,%eax
  8021df:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021e2:	0f 87 19 02 00 00    	ja     802401 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ee:	83 e8 08             	sub    $0x8,%eax
  8021f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8d 50 08             	lea    0x8(%eax),%edx
  8021fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021fd:	01 d0                	add    %edx,%eax
  8021ff:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	83 c0 08             	add    $0x8,%eax
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	6a 01                	push   $0x1
  80220d:	50                   	push   %eax
  80220e:	ff 75 bc             	pushl  -0x44(%ebp)
  802211:	e8 ae fe ff ff       	call   8020c4 <set_block_data>
  802216:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 40 04             	mov    0x4(%eax),%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	75 68                	jne    80228b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802223:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802227:	75 17                	jne    802240 <alloc_block_FF+0x14d>
  802229:	83 ec 04             	sub    $0x4,%esp
  80222c:	68 98 43 80 00       	push   $0x804398
  802231:	68 d7 00 00 00       	push   $0xd7
  802236:	68 7d 43 80 00       	push   $0x80437d
  80223b:	e8 f3 16 00 00       	call   803933 <_panic>
  802240:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802246:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	74 0d                	je     802261 <alloc_block_FF+0x16e>
  802254:	a1 30 50 80 00       	mov    0x805030,%eax
  802259:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	eb 08                	jmp    802269 <alloc_block_FF+0x176>
  802261:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802264:	a3 34 50 80 00       	mov    %eax,0x805034
  802269:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226c:	a3 30 50 80 00       	mov    %eax,0x805030
  802271:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802280:	40                   	inc    %eax
  802281:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802286:	e9 dc 00 00 00       	jmp    802367 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	75 65                	jne    8022f9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802294:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802298:	75 17                	jne    8022b1 <alloc_block_FF+0x1be>
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	68 cc 43 80 00       	push   $0x8043cc
  8022a2:	68 db 00 00 00       	push   $0xdb
  8022a7:	68 7d 43 80 00       	push   $0x80437d
  8022ac:	e8 82 16 00 00       	call   803933 <_panic>
  8022b1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8022b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)
  8022bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c0:	8b 40 04             	mov    0x4(%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0c                	je     8022d3 <alloc_block_FF+0x1e0>
  8022c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8022cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022cf:	89 10                	mov    %edx,(%eax)
  8022d1:	eb 08                	jmp    8022db <alloc_block_FF+0x1e8>
  8022d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8022db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022de:	a3 34 50 80 00       	mov    %eax,0x805034
  8022e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022f1:	40                   	inc    %eax
  8022f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022f7:	eb 6e                	jmp    802367 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fd:	74 06                	je     802305 <alloc_block_FF+0x212>
  8022ff:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802303:	75 17                	jne    80231c <alloc_block_FF+0x229>
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 f0 43 80 00       	push   $0x8043f0
  80230d:	68 df 00 00 00       	push   $0xdf
  802312:	68 7d 43 80 00       	push   $0x80437d
  802317:	e8 17 16 00 00       	call   803933 <_panic>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 10                	mov    (%eax),%edx
  802321:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802324:	89 10                	mov    %edx,(%eax)
  802326:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 0b                	je     80233a <alloc_block_FF+0x247>
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802340:	89 10                	mov    %edx,(%eax)
  802342:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	75 08                	jne    80235c <alloc_block_FF+0x269>
  802354:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802357:	a3 34 50 80 00       	mov    %eax,0x805034
  80235c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802361:	40                   	inc    %eax
  802362:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236b:	75 17                	jne    802384 <alloc_block_FF+0x291>
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	68 5f 43 80 00       	push   $0x80435f
  802375:	68 e1 00 00 00       	push   $0xe1
  80237a:	68 7d 43 80 00       	push   $0x80437d
  80237f:	e8 af 15 00 00       	call   803933 <_panic>
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 00                	mov    (%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	74 10                	je     80239d <alloc_block_FF+0x2aa>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802395:	8b 52 04             	mov    0x4(%edx),%edx
  802398:	89 50 04             	mov    %edx,0x4(%eax)
  80239b:	eb 0b                	jmp    8023a8 <alloc_block_FF+0x2b5>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 40 04             	mov    0x4(%eax),%eax
  8023a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 0f                	je     8023c1 <alloc_block_FF+0x2ce>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 40 04             	mov    0x4(%eax),%eax
  8023b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bb:	8b 12                	mov    (%edx),%edx
  8023bd:	89 10                	mov    %edx,(%eax)
  8023bf:	eb 0a                	jmp    8023cb <alloc_block_FF+0x2d8>
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 00                	mov    (%eax),%eax
  8023c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023e3:	48                   	dec    %eax
  8023e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	6a 00                	push   $0x0
  8023ee:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023f1:	ff 75 b0             	pushl  -0x50(%ebp)
  8023f4:	e8 cb fc ff ff       	call   8020c4 <set_block_data>
  8023f9:	83 c4 10             	add    $0x10,%esp
  8023fc:	e9 95 00 00 00       	jmp    802496 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	6a 01                	push   $0x1
  802406:	ff 75 b8             	pushl  -0x48(%ebp)
  802409:	ff 75 bc             	pushl  -0x44(%ebp)
  80240c:	e8 b3 fc ff ff       	call   8020c4 <set_block_data>
  802411:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802418:	75 17                	jne    802431 <alloc_block_FF+0x33e>
  80241a:	83 ec 04             	sub    $0x4,%esp
  80241d:	68 5f 43 80 00       	push   $0x80435f
  802422:	68 e8 00 00 00       	push   $0xe8
  802427:	68 7d 43 80 00       	push   $0x80437d
  80242c:	e8 02 15 00 00       	call   803933 <_panic>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 10                	je     80244a <alloc_block_FF+0x357>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802442:	8b 52 04             	mov    0x4(%edx),%edx
  802445:	89 50 04             	mov    %edx,0x4(%eax)
  802448:	eb 0b                	jmp    802455 <alloc_block_FF+0x362>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	a3 34 50 80 00       	mov    %eax,0x805034
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	74 0f                	je     80246e <alloc_block_FF+0x37b>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802468:	8b 12                	mov    (%edx),%edx
  80246a:	89 10                	mov    %edx,(%eax)
  80246c:	eb 0a                	jmp    802478 <alloc_block_FF+0x385>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	a3 30 50 80 00       	mov    %eax,0x805030
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802490:	48                   	dec    %eax
  802491:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802496:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802499:	e9 0f 01 00 00       	jmp    8025ad <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80249e:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024aa:	74 07                	je     8024b3 <alloc_block_FF+0x3c0>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	eb 05                	jmp    8024b8 <alloc_block_FF+0x3c5>
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8024bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	0f 85 e9 fc ff ff    	jne    8021b3 <alloc_block_FF+0xc0>
  8024ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ce:	0f 85 df fc ff ff    	jne    8021b3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	83 c0 08             	add    $0x8,%eax
  8024da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024dd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ea:	01 d0                	add    %edx,%eax
  8024ec:	48                   	dec    %eax
  8024ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f8:	f7 75 d8             	divl   -0x28(%ebp)
  8024fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024fe:	29 d0                	sub    %edx,%eax
  802500:	c1 e8 0c             	shr    $0xc,%eax
  802503:	83 ec 0c             	sub    $0xc,%esp
  802506:	50                   	push   %eax
  802507:	e8 1e ec ff ff       	call   80112a <sbrk>
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802512:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802516:	75 0a                	jne    802522 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
  80251d:	e9 8b 00 00 00       	jmp    8025ad <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802522:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802529:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80252c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80252f:	01 d0                	add    %edx,%eax
  802531:	48                   	dec    %eax
  802532:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802535:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802538:	ba 00 00 00 00       	mov    $0x0,%edx
  80253d:	f7 75 cc             	divl   -0x34(%ebp)
  802540:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802543:	29 d0                	sub    %edx,%eax
  802545:	8d 50 fc             	lea    -0x4(%eax),%edx
  802548:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80254b:	01 d0                	add    %edx,%eax
  80254d:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802552:	a1 44 50 80 00       	mov    0x805044,%eax
  802557:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80255d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802564:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802567:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80256a:	01 d0                	add    %edx,%eax
  80256c:	48                   	dec    %eax
  80256d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802570:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802573:	ba 00 00 00 00       	mov    $0x0,%edx
  802578:	f7 75 c4             	divl   -0x3c(%ebp)
  80257b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80257e:	29 d0                	sub    %edx,%eax
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	6a 01                	push   $0x1
  802585:	50                   	push   %eax
  802586:	ff 75 d0             	pushl  -0x30(%ebp)
  802589:	e8 36 fb ff ff       	call   8020c4 <set_block_data>
  80258e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802591:	83 ec 0c             	sub    $0xc,%esp
  802594:	ff 75 d0             	pushl  -0x30(%ebp)
  802597:	e8 1b 0a 00 00       	call   802fb7 <free_block>
  80259c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80259f:	83 ec 0c             	sub    $0xc,%esp
  8025a2:	ff 75 08             	pushl  0x8(%ebp)
  8025a5:	e8 49 fb ff ff       	call   8020f3 <alloc_block_FF>
  8025aa:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	83 e0 01             	and    $0x1,%eax
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	74 03                	je     8025c2 <alloc_block_BF+0x13>
  8025bf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025c2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025c6:	77 07                	ja     8025cf <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025c8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025cf:	a1 28 50 80 00       	mov    0x805028,%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	75 73                	jne    80264b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	83 c0 10             	add    $0x10,%eax
  8025de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025e1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	48                   	dec    %eax
  8025f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fc:	f7 75 e0             	divl   -0x20(%ebp)
  8025ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802602:	29 d0                	sub    %edx,%eax
  802604:	c1 e8 0c             	shr    $0xc,%eax
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	50                   	push   %eax
  80260b:	e8 1a eb ff ff       	call   80112a <sbrk>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	6a 00                	push   $0x0
  80261b:	e8 0a eb ff ff       	call   80112a <sbrk>
  802620:	83 c4 10             	add    $0x10,%esp
  802623:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802629:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80262c:	83 ec 08             	sub    $0x8,%esp
  80262f:	50                   	push   %eax
  802630:	ff 75 d8             	pushl  -0x28(%ebp)
  802633:	e8 9f f8 ff ff       	call   801ed7 <initialize_dynamic_allocator>
  802638:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	68 bb 43 80 00       	push   $0x8043bb
  802643:	e8 48 dd ff ff       	call   800390 <cprintf>
  802648:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80264b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802652:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802659:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802660:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802667:	a1 30 50 80 00       	mov    0x805030,%eax
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266f:	e9 1d 01 00 00       	jmp    802791 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	ff 75 a8             	pushl  -0x58(%ebp)
  802680:	e8 ee f6 ff ff       	call   801d73 <get_block_size>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	83 c0 08             	add    $0x8,%eax
  802691:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802694:	0f 87 ef 00 00 00    	ja     802789 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	83 c0 18             	add    $0x18,%eax
  8026a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026a3:	77 1d                	ja     8026c2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ab:	0f 86 d8 00 00 00    	jbe    802789 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026b1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026bd:	e9 c7 00 00 00       	jmp    802789 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	83 c0 08             	add    $0x8,%eax
  8026c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026cb:	0f 85 9d 00 00 00    	jne    80276e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026d1:	83 ec 04             	sub    $0x4,%esp
  8026d4:	6a 01                	push   $0x1
  8026d6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026d9:	ff 75 a8             	pushl  -0x58(%ebp)
  8026dc:	e8 e3 f9 ff ff       	call   8020c4 <set_block_data>
  8026e1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8026e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e8:	75 17                	jne    802701 <alloc_block_BF+0x152>
  8026ea:	83 ec 04             	sub    $0x4,%esp
  8026ed:	68 5f 43 80 00       	push   $0x80435f
  8026f2:	68 2c 01 00 00       	push   $0x12c
  8026f7:	68 7d 43 80 00       	push   $0x80437d
  8026fc:	e8 32 12 00 00       	call   803933 <_panic>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	85 c0                	test   %eax,%eax
  802708:	74 10                	je     80271a <alloc_block_BF+0x16b>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802712:	8b 52 04             	mov    0x4(%edx),%edx
  802715:	89 50 04             	mov    %edx,0x4(%eax)
  802718:	eb 0b                	jmp    802725 <alloc_block_BF+0x176>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	a3 34 50 80 00       	mov    %eax,0x805034
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	85 c0                	test   %eax,%eax
  80272d:	74 0f                	je     80273e <alloc_block_BF+0x18f>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802738:	8b 12                	mov    (%edx),%edx
  80273a:	89 10                	mov    %edx,(%eax)
  80273c:	eb 0a                	jmp    802748 <alloc_block_BF+0x199>
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	a3 30 50 80 00       	mov    %eax,0x805030
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802760:	48                   	dec    %eax
  802761:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802766:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802769:	e9 24 04 00 00       	jmp    802b92 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80276e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802771:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802774:	76 13                	jbe    802789 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802776:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80277d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802780:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802783:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802786:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802789:	a1 38 50 80 00       	mov    0x805038,%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802795:	74 07                	je     80279e <alloc_block_BF+0x1ef>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	eb 05                	jmp    8027a3 <alloc_block_BF+0x1f4>
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8027a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	0f 85 bf fe ff ff    	jne    802674 <alloc_block_BF+0xc5>
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	0f 85 b5 fe ff ff    	jne    802674 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c3:	0f 84 26 02 00 00    	je     8029ef <alloc_block_BF+0x440>
  8027c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027cd:	0f 85 1c 02 00 00    	jne    8029ef <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d6:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d9:	83 e8 08             	sub    $0x8,%eax
  8027dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	8d 50 08             	lea    0x8(%eax),%edx
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	83 c0 08             	add    $0x8,%eax
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	6a 01                	push   $0x1
  8027f8:	50                   	push   %eax
  8027f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8027fc:	e8 c3 f8 ff ff       	call   8020c4 <set_block_data>
  802801:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	75 68                	jne    802876 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80280e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802812:	75 17                	jne    80282b <alloc_block_BF+0x27c>
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	68 98 43 80 00       	push   $0x804398
  80281c:	68 45 01 00 00       	push   $0x145
  802821:	68 7d 43 80 00       	push   $0x80437d
  802826:	e8 08 11 00 00       	call   803933 <_panic>
  80282b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802831:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802834:	89 10                	mov    %edx,(%eax)
  802836:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0d                	je     80284c <alloc_block_BF+0x29d>
  80283f:	a1 30 50 80 00       	mov    0x805030,%eax
  802844:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	eb 08                	jmp    802854 <alloc_block_BF+0x2a5>
  80284c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284f:	a3 34 50 80 00       	mov    %eax,0x805034
  802854:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802857:	a3 30 50 80 00       	mov    %eax,0x805030
  80285c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802866:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80286b:	40                   	inc    %eax
  80286c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802871:	e9 dc 00 00 00       	jmp    802952 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	75 65                	jne    8028e4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80287f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802883:	75 17                	jne    80289c <alloc_block_BF+0x2ed>
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	68 cc 43 80 00       	push   $0x8043cc
  80288d:	68 4a 01 00 00       	push   $0x14a
  802892:	68 7d 43 80 00       	push   $0x80437d
  802897:	e8 97 10 00 00       	call   803933 <_panic>
  80289c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8028a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a5:	89 50 04             	mov    %edx,0x4(%eax)
  8028a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ab:	8b 40 04             	mov    0x4(%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0c                	je     8028be <alloc_block_BF+0x30f>
  8028b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8028b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028ba:	89 10                	mov    %edx,(%eax)
  8028bc:	eb 08                	jmp    8028c6 <alloc_block_BF+0x317>
  8028be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028dc:	40                   	inc    %eax
  8028dd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028e2:	eb 6e                	jmp    802952 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8028e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028e8:	74 06                	je     8028f0 <alloc_block_BF+0x341>
  8028ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ee:	75 17                	jne    802907 <alloc_block_BF+0x358>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 f0 43 80 00       	push   $0x8043f0
  8028f8:	68 4f 01 00 00       	push   $0x14f
  8028fd:	68 7d 43 80 00       	push   $0x80437d
  802902:	e8 2c 10 00 00       	call   803933 <_panic>
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 10                	mov    (%eax),%edx
  80290c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 0b                	je     802925 <alloc_block_BF+0x376>
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802922:	89 50 04             	mov    %edx,0x4(%eax)
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292b:	89 10                	mov    %edx,(%eax)
  80292d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802933:	89 50 04             	mov    %edx,0x4(%eax)
  802936:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 08                	jne    802947 <alloc_block_BF+0x398>
  80293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802942:	a3 34 50 80 00       	mov    %eax,0x805034
  802947:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80294c:	40                   	inc    %eax
  80294d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802952:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802956:	75 17                	jne    80296f <alloc_block_BF+0x3c0>
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	68 5f 43 80 00       	push   $0x80435f
  802960:	68 51 01 00 00       	push   $0x151
  802965:	68 7d 43 80 00       	push   $0x80437d
  80296a:	e8 c4 0f 00 00       	call   803933 <_panic>
  80296f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 10                	je     802988 <alloc_block_BF+0x3d9>
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802980:	8b 52 04             	mov    0x4(%edx),%edx
  802983:	89 50 04             	mov    %edx,0x4(%eax)
  802986:	eb 0b                	jmp    802993 <alloc_block_BF+0x3e4>
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	a3 34 50 80 00       	mov    %eax,0x805034
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0f                	je     8029ac <alloc_block_BF+0x3fd>
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a6:	8b 12                	mov    (%edx),%edx
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	eb 0a                	jmp    8029b6 <alloc_block_BF+0x407>
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029ce:	48                   	dec    %eax
  8029cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8029d4:	83 ec 04             	sub    $0x4,%esp
  8029d7:	6a 00                	push   $0x0
  8029d9:	ff 75 d0             	pushl  -0x30(%ebp)
  8029dc:	ff 75 cc             	pushl  -0x34(%ebp)
  8029df:	e8 e0 f6 ff ff       	call   8020c4 <set_block_data>
  8029e4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	e9 a3 01 00 00       	jmp    802b92 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029ef:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029f3:	0f 85 9d 00 00 00    	jne    802a96 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	6a 01                	push   $0x1
  8029fe:	ff 75 ec             	pushl  -0x14(%ebp)
  802a01:	ff 75 f0             	pushl  -0x10(%ebp)
  802a04:	e8 bb f6 ff ff       	call   8020c4 <set_block_data>
  802a09:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a10:	75 17                	jne    802a29 <alloc_block_BF+0x47a>
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 5f 43 80 00       	push   $0x80435f
  802a1a:	68 58 01 00 00       	push   $0x158
  802a1f:	68 7d 43 80 00       	push   $0x80437d
  802a24:	e8 0a 0f 00 00       	call   803933 <_panic>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 10                	je     802a42 <alloc_block_BF+0x493>
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3a:	8b 52 04             	mov    0x4(%edx),%edx
  802a3d:	89 50 04             	mov    %edx,0x4(%eax)
  802a40:	eb 0b                	jmp    802a4d <alloc_block_BF+0x49e>
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	a3 34 50 80 00       	mov    %eax,0x805034
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0f                	je     802a66 <alloc_block_BF+0x4b7>
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a60:	8b 12                	mov    (%edx),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 0a                	jmp    802a70 <alloc_block_BF+0x4c1>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a88:	48                   	dec    %eax
  802a89:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	e9 fc 00 00 00       	jmp    802b92 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	83 c0 08             	add    $0x8,%eax
  802a9c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a9f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802aa6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	48                   	dec    %eax
  802aaf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ab2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aba:	f7 75 c4             	divl   -0x3c(%ebp)
  802abd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac0:	29 d0                	sub    %edx,%eax
  802ac2:	c1 e8 0c             	shr    $0xc,%eax
  802ac5:	83 ec 0c             	sub    $0xc,%esp
  802ac8:	50                   	push   %eax
  802ac9:	e8 5c e6 ff ff       	call   80112a <sbrk>
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ad4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ad8:	75 0a                	jne    802ae4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ada:	b8 00 00 00 00       	mov    $0x0,%eax
  802adf:	e9 ae 00 00 00       	jmp    802b92 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ae4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802aeb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802af1:	01 d0                	add    %edx,%eax
  802af3:	48                   	dec    %eax
  802af4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802af7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802afa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aff:	f7 75 b8             	divl   -0x48(%ebp)
  802b02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b05:	29 d0                	sub    %edx,%eax
  802b07:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b0d:	01 d0                	add    %edx,%eax
  802b0f:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802b14:	a1 44 50 80 00       	mov    0x805044,%eax
  802b19:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b1f:	83 ec 0c             	sub    $0xc,%esp
  802b22:	68 24 44 80 00       	push   $0x804424
  802b27:	e8 64 d8 ff ff       	call   800390 <cprintf>
  802b2c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b2f:	83 ec 08             	sub    $0x8,%esp
  802b32:	ff 75 bc             	pushl  -0x44(%ebp)
  802b35:	68 29 44 80 00       	push   $0x804429
  802b3a:	e8 51 d8 ff ff       	call   800390 <cprintf>
  802b3f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b42:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b49:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4f:	01 d0                	add    %edx,%eax
  802b51:	48                   	dec    %eax
  802b52:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b55:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b58:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5d:	f7 75 b0             	divl   -0x50(%ebp)
  802b60:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b63:	29 d0                	sub    %edx,%eax
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	6a 01                	push   $0x1
  802b6a:	50                   	push   %eax
  802b6b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6e:	e8 51 f5 ff ff       	call   8020c4 <set_block_data>
  802b73:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	ff 75 bc             	pushl  -0x44(%ebp)
  802b7c:	e8 36 04 00 00       	call   802fb7 <free_block>
  802b81:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b84:	83 ec 0c             	sub    $0xc,%esp
  802b87:	ff 75 08             	pushl  0x8(%ebp)
  802b8a:	e8 20 fa ff ff       	call   8025af <alloc_block_BF>
  802b8f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b92:	c9                   	leave  
  802b93:	c3                   	ret    

00802b94 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b94:	55                   	push   %ebp
  802b95:	89 e5                	mov    %esp,%ebp
  802b97:	53                   	push   %ebx
  802b98:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ba2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ba9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bad:	74 1e                	je     802bcd <merging+0x39>
  802baf:	ff 75 08             	pushl  0x8(%ebp)
  802bb2:	e8 bc f1 ff ff       	call   801d73 <get_block_size>
  802bb7:	83 c4 04             	add    $0x4,%esp
  802bba:	89 c2                	mov    %eax,%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	01 d0                	add    %edx,%eax
  802bc1:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bc4:	75 07                	jne    802bcd <merging+0x39>
		prev_is_free = 1;
  802bc6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd1:	74 1e                	je     802bf1 <merging+0x5d>
  802bd3:	ff 75 10             	pushl  0x10(%ebp)
  802bd6:	e8 98 f1 ff ff       	call   801d73 <get_block_size>
  802bdb:	83 c4 04             	add    $0x4,%esp
  802bde:	89 c2                	mov    %eax,%edx
  802be0:	8b 45 10             	mov    0x10(%ebp),%eax
  802be3:	01 d0                	add    %edx,%eax
  802be5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802be8:	75 07                	jne    802bf1 <merging+0x5d>
		next_is_free = 1;
  802bea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf5:	0f 84 cc 00 00 00    	je     802cc7 <merging+0x133>
  802bfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bff:	0f 84 c2 00 00 00    	je     802cc7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c05:	ff 75 08             	pushl  0x8(%ebp)
  802c08:	e8 66 f1 ff ff       	call   801d73 <get_block_size>
  802c0d:	83 c4 04             	add    $0x4,%esp
  802c10:	89 c3                	mov    %eax,%ebx
  802c12:	ff 75 10             	pushl  0x10(%ebp)
  802c15:	e8 59 f1 ff ff       	call   801d73 <get_block_size>
  802c1a:	83 c4 04             	add    $0x4,%esp
  802c1d:	01 c3                	add    %eax,%ebx
  802c1f:	ff 75 0c             	pushl  0xc(%ebp)
  802c22:	e8 4c f1 ff ff       	call   801d73 <get_block_size>
  802c27:	83 c4 04             	add    $0x4,%esp
  802c2a:	01 d8                	add    %ebx,%eax
  802c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c2f:	6a 00                	push   $0x0
  802c31:	ff 75 ec             	pushl  -0x14(%ebp)
  802c34:	ff 75 08             	pushl  0x8(%ebp)
  802c37:	e8 88 f4 ff ff       	call   8020c4 <set_block_data>
  802c3c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c43:	75 17                	jne    802c5c <merging+0xc8>
  802c45:	83 ec 04             	sub    $0x4,%esp
  802c48:	68 5f 43 80 00       	push   $0x80435f
  802c4d:	68 7d 01 00 00       	push   $0x17d
  802c52:	68 7d 43 80 00       	push   $0x80437d
  802c57:	e8 d7 0c 00 00       	call   803933 <_panic>
  802c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 10                	je     802c75 <merging+0xe1>
  802c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6d:	8b 52 04             	mov    0x4(%edx),%edx
  802c70:	89 50 04             	mov    %edx,0x4(%eax)
  802c73:	eb 0b                	jmp    802c80 <merging+0xec>
  802c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c78:	8b 40 04             	mov    0x4(%eax),%eax
  802c7b:	a3 34 50 80 00       	mov    %eax,0x805034
  802c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	74 0f                	je     802c99 <merging+0x105>
  802c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c93:	8b 12                	mov    (%edx),%edx
  802c95:	89 10                	mov    %edx,(%eax)
  802c97:	eb 0a                	jmp    802ca3 <merging+0x10f>
  802c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802caf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cbb:	48                   	dec    %eax
  802cbc:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cc1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cc2:	e9 ea 02 00 00       	jmp    802fb1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccb:	74 3b                	je     802d08 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	ff 75 08             	pushl  0x8(%ebp)
  802cd3:	e8 9b f0 ff ff       	call   801d73 <get_block_size>
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	89 c3                	mov    %eax,%ebx
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	ff 75 10             	pushl  0x10(%ebp)
  802ce3:	e8 8b f0 ff ff       	call   801d73 <get_block_size>
  802ce8:	83 c4 10             	add    $0x10,%esp
  802ceb:	01 d8                	add    %ebx,%eax
  802ced:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	6a 00                	push   $0x0
  802cf5:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf8:	ff 75 08             	pushl  0x8(%ebp)
  802cfb:	e8 c4 f3 ff ff       	call   8020c4 <set_block_data>
  802d00:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d03:	e9 a9 02 00 00       	jmp    802fb1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0c:	0f 84 2d 01 00 00    	je     802e3f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d12:	83 ec 0c             	sub    $0xc,%esp
  802d15:	ff 75 10             	pushl  0x10(%ebp)
  802d18:	e8 56 f0 ff ff       	call   801d73 <get_block_size>
  802d1d:	83 c4 10             	add    $0x10,%esp
  802d20:	89 c3                	mov    %eax,%ebx
  802d22:	83 ec 0c             	sub    $0xc,%esp
  802d25:	ff 75 0c             	pushl  0xc(%ebp)
  802d28:	e8 46 f0 ff ff       	call   801d73 <get_block_size>
  802d2d:	83 c4 10             	add    $0x10,%esp
  802d30:	01 d8                	add    %ebx,%eax
  802d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	6a 00                	push   $0x0
  802d3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d3d:	ff 75 10             	pushl  0x10(%ebp)
  802d40:	e8 7f f3 ff ff       	call   8020c4 <set_block_data>
  802d45:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d48:	8b 45 10             	mov    0x10(%ebp),%eax
  802d4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d52:	74 06                	je     802d5a <merging+0x1c6>
  802d54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d58:	75 17                	jne    802d71 <merging+0x1dd>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 38 44 80 00       	push   $0x804438
  802d62:	68 8d 01 00 00       	push   $0x18d
  802d67:	68 7d 43 80 00       	push   $0x80437d
  802d6c:	e8 c2 0b 00 00       	call   803933 <_panic>
  802d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d74:	8b 50 04             	mov    0x4(%eax),%edx
  802d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0d                	je     802d9c <merging+0x208>
  802d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	eb 08                	jmp    802da4 <merging+0x210>
  802d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802daa:	89 50 04             	mov    %edx,0x4(%eax)
  802dad:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802db2:	40                   	inc    %eax
  802db3:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbc:	75 17                	jne    802dd5 <merging+0x241>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 5f 43 80 00       	push   $0x80435f
  802dc6:	68 8e 01 00 00       	push   $0x18e
  802dcb:	68 7d 43 80 00       	push   $0x80437d
  802dd0:	e8 5e 0b 00 00       	call   803933 <_panic>
  802dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 10                	je     802dee <merging+0x25a>
  802dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de6:	8b 52 04             	mov    0x4(%edx),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
  802dec:	eb 0b                	jmp    802df9 <merging+0x265>
  802dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	a3 34 50 80 00       	mov    %eax,0x805034
  802df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 0f                	je     802e12 <merging+0x27e>
  802e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0c:	8b 12                	mov    (%edx),%edx
  802e0e:	89 10                	mov    %edx,(%eax)
  802e10:	eb 0a                	jmp    802e1c <merging+0x288>
  802e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e34:	48                   	dec    %eax
  802e35:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e3a:	e9 72 01 00 00       	jmp    802fb1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  802e42:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e49:	74 79                	je     802ec4 <merging+0x330>
  802e4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4f:	74 73                	je     802ec4 <merging+0x330>
  802e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e55:	74 06                	je     802e5d <merging+0x2c9>
  802e57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5b:	75 17                	jne    802e74 <merging+0x2e0>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 f0 43 80 00       	push   $0x8043f0
  802e65:	68 94 01 00 00       	push   $0x194
  802e6a:	68 7d 43 80 00       	push   $0x80437d
  802e6f:	e8 bf 0a 00 00       	call   803933 <_panic>
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 10                	mov    (%eax),%edx
  802e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0b                	je     802e92 <merging+0x2fe>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e98:	89 10                	mov    %edx,(%eax)
  802e9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea0:	89 50 04             	mov    %edx,0x4(%eax)
  802ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	75 08                	jne    802eb4 <merging+0x320>
  802eac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eaf:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802eb9:	40                   	inc    %eax
  802eba:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ebf:	e9 ce 00 00 00       	jmp    802f92 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec8:	74 65                	je     802f2f <merging+0x39b>
  802eca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ece:	75 17                	jne    802ee7 <merging+0x353>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 cc 43 80 00       	push   $0x8043cc
  802ed8:	68 95 01 00 00       	push   $0x195
  802edd:	68 7d 43 80 00       	push   $0x80437d
  802ee2:	e8 4c 0a 00 00       	call   803933 <_panic>
  802ee7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0c                	je     802f09 <merging+0x375>
  802efd:	a1 34 50 80 00       	mov    0x805034,%eax
  802f02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	eb 08                	jmp    802f11 <merging+0x37d>
  802f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f14:	a3 34 50 80 00       	mov    %eax,0x805034
  802f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f22:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f27:	40                   	inc    %eax
  802f28:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f2d:	eb 63                	jmp    802f92 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f33:	75 17                	jne    802f4c <merging+0x3b8>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 98 43 80 00       	push   $0x804398
  802f3d:	68 98 01 00 00       	push   $0x198
  802f42:	68 7d 43 80 00       	push   $0x80437d
  802f47:	e8 e7 09 00 00       	call   803933 <_panic>
  802f4c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0d                	je     802f6d <merging+0x3d9>
  802f60:	a1 30 50 80 00       	mov    0x805030,%eax
  802f65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	eb 08                	jmp    802f75 <merging+0x3e1>
  802f6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f70:	a3 34 50 80 00       	mov    %eax,0x805034
  802f75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f78:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f87:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f8c:	40                   	inc    %eax
  802f8d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  802f92:	83 ec 0c             	sub    $0xc,%esp
  802f95:	ff 75 10             	pushl  0x10(%ebp)
  802f98:	e8 d6 ed ff ff       	call   801d73 <get_block_size>
  802f9d:	83 c4 10             	add    $0x10,%esp
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	6a 00                	push   $0x0
  802fa5:	50                   	push   %eax
  802fa6:	ff 75 10             	pushl  0x10(%ebp)
  802fa9:	e8 16 f1 ff ff       	call   8020c4 <set_block_data>
  802fae:	83 c4 10             	add    $0x10,%esp
	}
}
  802fb1:	90                   	nop
  802fb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
  802fba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fbd:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fc5:	a1 34 50 80 00       	mov    0x805034,%eax
  802fca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fcd:	73 1b                	jae    802fea <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fcf:	a1 34 50 80 00       	mov    0x805034,%eax
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	ff 75 08             	pushl  0x8(%ebp)
  802fda:	6a 00                	push   $0x0
  802fdc:	50                   	push   %eax
  802fdd:	e8 b2 fb ff ff       	call   802b94 <merging>
  802fe2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fe5:	e9 8b 00 00 00       	jmp    803075 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fea:	a1 30 50 80 00       	mov    0x805030,%eax
  802fef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff2:	76 18                	jbe    80300c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ff4:	a1 30 50 80 00       	mov    0x805030,%eax
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	ff 75 08             	pushl  0x8(%ebp)
  802fff:	50                   	push   %eax
  803000:	6a 00                	push   $0x0
  803002:	e8 8d fb ff ff       	call   802b94 <merging>
  803007:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80300a:	eb 69                	jmp    803075 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80300c:	a1 30 50 80 00       	mov    0x805030,%eax
  803011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803014:	eb 39                	jmp    80304f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301c:	73 29                	jae    803047 <free_block+0x90>
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	3b 45 08             	cmp    0x8(%ebp),%eax
  803026:	76 1f                	jbe    803047 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	ff 75 08             	pushl  0x8(%ebp)
  803036:	ff 75 f0             	pushl  -0x10(%ebp)
  803039:	ff 75 f4             	pushl  -0xc(%ebp)
  80303c:	e8 53 fb ff ff       	call   802b94 <merging>
  803041:	83 c4 10             	add    $0x10,%esp
			break;
  803044:	90                   	nop
		}
	}
}
  803045:	eb 2e                	jmp    803075 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803047:	a1 38 50 80 00       	mov    0x805038,%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803053:	74 07                	je     80305c <free_block+0xa5>
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	eb 05                	jmp    803061 <free_block+0xaa>
  80305c:	b8 00 00 00 00       	mov    $0x0,%eax
  803061:	a3 38 50 80 00       	mov    %eax,0x805038
  803066:	a1 38 50 80 00       	mov    0x805038,%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	75 a7                	jne    803016 <free_block+0x5f>
  80306f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803073:	75 a1                	jne    803016 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803075:	90                   	nop
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
  80307b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80307e:	ff 75 08             	pushl  0x8(%ebp)
  803081:	e8 ed ec ff ff       	call   801d73 <get_block_size>
  803086:	83 c4 04             	add    $0x4,%esp
  803089:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80308c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803093:	eb 17                	jmp    8030ac <copy_data+0x34>
  803095:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	01 c8                	add    %ecx,%eax
  8030a5:	8a 00                	mov    (%eax),%al
  8030a7:	88 02                	mov    %al,(%edx)
  8030a9:	ff 45 fc             	incl   -0x4(%ebp)
  8030ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030b2:	72 e1                	jb     803095 <copy_data+0x1d>
}
  8030b4:	90                   	nop
  8030b5:	c9                   	leave  
  8030b6:	c3                   	ret    

008030b7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030b7:	55                   	push   %ebp
  8030b8:	89 e5                	mov    %esp,%ebp
  8030ba:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c1:	75 23                	jne    8030e6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c7:	74 13                	je     8030dc <realloc_block_FF+0x25>
  8030c9:	83 ec 0c             	sub    $0xc,%esp
  8030cc:	ff 75 0c             	pushl  0xc(%ebp)
  8030cf:	e8 1f f0 ff ff       	call   8020f3 <alloc_block_FF>
  8030d4:	83 c4 10             	add    $0x10,%esp
  8030d7:	e9 f4 06 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
		return NULL;
  8030dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e1:	e9 ea 06 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030ea:	75 18                	jne    803104 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030ec:	83 ec 0c             	sub    $0xc,%esp
  8030ef:	ff 75 08             	pushl  0x8(%ebp)
  8030f2:	e8 c0 fe ff ff       	call   802fb7 <free_block>
  8030f7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ff:	e9 cc 06 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803104:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803108:	77 07                	ja     803111 <realloc_block_FF+0x5a>
  80310a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803111:	8b 45 0c             	mov    0xc(%ebp),%eax
  803114:	83 e0 01             	and    $0x1,%eax
  803117:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80311a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311d:	83 c0 08             	add    $0x8,%eax
  803120:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803123:	83 ec 0c             	sub    $0xc,%esp
  803126:	ff 75 08             	pushl  0x8(%ebp)
  803129:	e8 45 ec ff ff       	call   801d73 <get_block_size>
  80312e:	83 c4 10             	add    $0x10,%esp
  803131:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803137:	83 e8 08             	sub    $0x8,%eax
  80313a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	83 e8 04             	sub    $0x4,%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	83 e0 fe             	and    $0xfffffffe,%eax
  803148:	89 c2                	mov    %eax,%edx
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	01 d0                	add    %edx,%eax
  80314f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803152:	83 ec 0c             	sub    $0xc,%esp
  803155:	ff 75 e4             	pushl  -0x1c(%ebp)
  803158:	e8 16 ec ff ff       	call   801d73 <get_block_size>
  80315d:	83 c4 10             	add    $0x10,%esp
  803160:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803166:	83 e8 08             	sub    $0x8,%eax
  803169:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803172:	75 08                	jne    80317c <realloc_block_FF+0xc5>
	{
		 return va;
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	e9 54 06 00 00       	jmp    8037d0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80317c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803182:	0f 83 e5 03 00 00    	jae    80356d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80318e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803191:	83 ec 0c             	sub    $0xc,%esp
  803194:	ff 75 e4             	pushl  -0x1c(%ebp)
  803197:	e8 f0 eb ff ff       	call   801d8c <is_free_block>
  80319c:	83 c4 10             	add    $0x10,%esp
  80319f:	84 c0                	test   %al,%al
  8031a1:	0f 84 3b 01 00 00    	je     8032e2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ad:	01 d0                	add    %edx,%eax
  8031af:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	6a 01                	push   $0x1
  8031b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ba:	ff 75 08             	pushl  0x8(%ebp)
  8031bd:	e8 02 ef ff ff       	call   8020c4 <set_block_data>
  8031c2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	83 e8 04             	sub    $0x4,%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	83 e0 fe             	and    $0xfffffffe,%eax
  8031d0:	89 c2                	mov    %eax,%edx
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	01 d0                	add    %edx,%eax
  8031d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	6a 00                	push   $0x0
  8031df:	ff 75 cc             	pushl  -0x34(%ebp)
  8031e2:	ff 75 c8             	pushl  -0x38(%ebp)
  8031e5:	e8 da ee ff ff       	call   8020c4 <set_block_data>
  8031ea:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f1:	74 06                	je     8031f9 <realloc_block_FF+0x142>
  8031f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031f7:	75 17                	jne    803210 <realloc_block_FF+0x159>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 f0 43 80 00       	push   $0x8043f0
  803201:	68 f6 01 00 00       	push   $0x1f6
  803206:	68 7d 43 80 00       	push   $0x80437d
  80320b:	e8 23 07 00 00       	call   803933 <_panic>
  803210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803213:	8b 10                	mov    (%eax),%edx
  803215:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	74 0b                	je     80322e <realloc_block_FF+0x177>
  803223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803231:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803239:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323c:	89 50 04             	mov    %edx,0x4(%eax)
  80323f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	75 08                	jne    803250 <realloc_block_FF+0x199>
  803248:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80324b:	a3 34 50 80 00       	mov    %eax,0x805034
  803250:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803255:	40                   	inc    %eax
  803256:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80325b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80325f:	75 17                	jne    803278 <realloc_block_FF+0x1c1>
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	68 5f 43 80 00       	push   $0x80435f
  803269:	68 f7 01 00 00       	push   $0x1f7
  80326e:	68 7d 43 80 00       	push   $0x80437d
  803273:	e8 bb 06 00 00       	call   803933 <_panic>
  803278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 10                	je     803291 <realloc_block_FF+0x1da>
  803281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803289:	8b 52 04             	mov    0x4(%edx),%edx
  80328c:	89 50 04             	mov    %edx,0x4(%eax)
  80328f:	eb 0b                	jmp    80329c <realloc_block_FF+0x1e5>
  803291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	a3 34 50 80 00       	mov    %eax,0x805034
  80329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329f:	8b 40 04             	mov    0x4(%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 0f                	je     8032b5 <realloc_block_FF+0x1fe>
  8032a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032af:	8b 12                	mov    (%edx),%edx
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	eb 0a                	jmp    8032bf <realloc_block_FF+0x208>
  8032b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8032bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032d7:	48                   	dec    %eax
  8032d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8032dd:	e9 83 02 00 00       	jmp    803565 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8032e2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032e6:	0f 86 69 02 00 00    	jbe    803555 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	6a 01                	push   $0x1
  8032f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f4:	ff 75 08             	pushl  0x8(%ebp)
  8032f7:	e8 c8 ed ff ff       	call   8020c4 <set_block_data>
  8032fc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	83 e8 04             	sub    $0x4,%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	83 e0 fe             	and    $0xfffffffe,%eax
  80330a:	89 c2                	mov    %eax,%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	01 d0                	add    %edx,%eax
  803311:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803314:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803319:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80331c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803320:	75 68                	jne    80338a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803322:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803326:	75 17                	jne    80333f <realloc_block_FF+0x288>
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	68 98 43 80 00       	push   $0x804398
  803330:	68 06 02 00 00       	push   $0x206
  803335:	68 7d 43 80 00       	push   $0x80437d
  80333a:	e8 f4 05 00 00       	call   803933 <_panic>
  80333f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803345:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803348:	89 10                	mov    %edx,(%eax)
  80334a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	85 c0                	test   %eax,%eax
  803351:	74 0d                	je     803360 <realloc_block_FF+0x2a9>
  803353:	a1 30 50 80 00       	mov    0x805030,%eax
  803358:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335b:	89 50 04             	mov    %edx,0x4(%eax)
  80335e:	eb 08                	jmp    803368 <realloc_block_FF+0x2b1>
  803360:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803363:	a3 34 50 80 00       	mov    %eax,0x805034
  803368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336b:	a3 30 50 80 00       	mov    %eax,0x805030
  803370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803373:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80337f:	40                   	inc    %eax
  803380:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803385:	e9 b0 01 00 00       	jmp    80353a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80338a:	a1 30 50 80 00       	mov    0x805030,%eax
  80338f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803392:	76 68                	jbe    8033fc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803394:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803398:	75 17                	jne    8033b1 <realloc_block_FF+0x2fa>
  80339a:	83 ec 04             	sub    $0x4,%esp
  80339d:	68 98 43 80 00       	push   $0x804398
  8033a2:	68 0b 02 00 00       	push   $0x20b
  8033a7:	68 7d 43 80 00       	push   $0x80437d
  8033ac:	e8 82 05 00 00       	call   803933 <_panic>
  8033b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	74 0d                	je     8033d2 <realloc_block_FF+0x31b>
  8033c5:	a1 30 50 80 00       	mov    0x805030,%eax
  8033ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033cd:	89 50 04             	mov    %edx,0x4(%eax)
  8033d0:	eb 08                	jmp    8033da <realloc_block_FF+0x323>
  8033d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d5:	a3 34 50 80 00       	mov    %eax,0x805034
  8033da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033f1:	40                   	inc    %eax
  8033f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033f7:	e9 3e 01 00 00       	jmp    80353a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033fc:	a1 30 50 80 00       	mov    0x805030,%eax
  803401:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803404:	73 68                	jae    80346e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803406:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80340a:	75 17                	jne    803423 <realloc_block_FF+0x36c>
  80340c:	83 ec 04             	sub    $0x4,%esp
  80340f:	68 cc 43 80 00       	push   $0x8043cc
  803414:	68 10 02 00 00       	push   $0x210
  803419:	68 7d 43 80 00       	push   $0x80437d
  80341e:	e8 10 05 00 00       	call   803933 <_panic>
  803423:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803429:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342c:	89 50 04             	mov    %edx,0x4(%eax)
  80342f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	85 c0                	test   %eax,%eax
  803437:	74 0c                	je     803445 <realloc_block_FF+0x38e>
  803439:	a1 34 50 80 00       	mov    0x805034,%eax
  80343e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803441:	89 10                	mov    %edx,(%eax)
  803443:	eb 08                	jmp    80344d <realloc_block_FF+0x396>
  803445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803448:	a3 30 50 80 00       	mov    %eax,0x805030
  80344d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803450:	a3 34 50 80 00       	mov    %eax,0x805034
  803455:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803463:	40                   	inc    %eax
  803464:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803469:	e9 cc 00 00 00       	jmp    80353a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80346e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803475:	a1 30 50 80 00       	mov    0x805030,%eax
  80347a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347d:	e9 8a 00 00 00       	jmp    80350c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803488:	73 7a                	jae    803504 <realloc_block_FF+0x44d>
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803492:	73 70                	jae    803504 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803498:	74 06                	je     8034a0 <realloc_block_FF+0x3e9>
  80349a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349e:	75 17                	jne    8034b7 <realloc_block_FF+0x400>
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 f0 43 80 00       	push   $0x8043f0
  8034a8:	68 1a 02 00 00       	push   $0x21a
  8034ad:	68 7d 43 80 00       	push   $0x80437d
  8034b2:	e8 7c 04 00 00       	call   803933 <_panic>
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 10                	mov    (%eax),%edx
  8034bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bf:	89 10                	mov    %edx,(%eax)
  8034c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 0b                	je     8034d5 <realloc_block_FF+0x41e>
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034db:	89 10                	mov    %edx,(%eax)
  8034dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%eax)
  8034e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e9:	8b 00                	mov    (%eax),%eax
  8034eb:	85 c0                	test   %eax,%eax
  8034ed:	75 08                	jne    8034f7 <realloc_block_FF+0x440>
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8034f7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034fc:	40                   	inc    %eax
  8034fd:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803502:	eb 36                	jmp    80353a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803504:	a1 38 50 80 00       	mov    0x805038,%eax
  803509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803510:	74 07                	je     803519 <realloc_block_FF+0x462>
  803512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	eb 05                	jmp    80351e <realloc_block_FF+0x467>
  803519:	b8 00 00 00 00       	mov    $0x0,%eax
  80351e:	a3 38 50 80 00       	mov    %eax,0x805038
  803523:	a1 38 50 80 00       	mov    0x805038,%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	0f 85 52 ff ff ff    	jne    803482 <realloc_block_FF+0x3cb>
  803530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803534:	0f 85 48 ff ff ff    	jne    803482 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80353a:	83 ec 04             	sub    $0x4,%esp
  80353d:	6a 00                	push   $0x0
  80353f:	ff 75 d8             	pushl  -0x28(%ebp)
  803542:	ff 75 d4             	pushl  -0x2c(%ebp)
  803545:	e8 7a eb ff ff       	call   8020c4 <set_block_data>
  80354a:	83 c4 10             	add    $0x10,%esp
				return va;
  80354d:	8b 45 08             	mov    0x8(%ebp),%eax
  803550:	e9 7b 02 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803555:	83 ec 0c             	sub    $0xc,%esp
  803558:	68 6d 44 80 00       	push   $0x80446d
  80355d:	e8 2e ce ff ff       	call   800390 <cprintf>
  803562:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	e9 63 02 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80356d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803570:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803573:	0f 86 4d 02 00 00    	jbe    8037c6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803579:	83 ec 0c             	sub    $0xc,%esp
  80357c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80357f:	e8 08 e8 ff ff       	call   801d8c <is_free_block>
  803584:	83 c4 10             	add    $0x10,%esp
  803587:	84 c0                	test   %al,%al
  803589:	0f 84 37 02 00 00    	je     8037c6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80358f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803592:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803595:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803598:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80359b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80359e:	76 38                	jbe    8035d8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035a0:	83 ec 0c             	sub    $0xc,%esp
  8035a3:	ff 75 08             	pushl  0x8(%ebp)
  8035a6:	e8 0c fa ff ff       	call   802fb7 <free_block>
  8035ab:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035ae:	83 ec 0c             	sub    $0xc,%esp
  8035b1:	ff 75 0c             	pushl  0xc(%ebp)
  8035b4:	e8 3a eb ff ff       	call   8020f3 <alloc_block_FF>
  8035b9:	83 c4 10             	add    $0x10,%esp
  8035bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035bf:	83 ec 08             	sub    $0x8,%esp
  8035c2:	ff 75 c0             	pushl  -0x40(%ebp)
  8035c5:	ff 75 08             	pushl  0x8(%ebp)
  8035c8:	e8 ab fa ff ff       	call   803078 <copy_data>
  8035cd:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035d3:	e9 f8 01 00 00       	jmp    8037d0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035db:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035de:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035e1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035e5:	0f 87 a0 00 00 00    	ja     80368b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ef:	75 17                	jne    803608 <realloc_block_FF+0x551>
  8035f1:	83 ec 04             	sub    $0x4,%esp
  8035f4:	68 5f 43 80 00       	push   $0x80435f
  8035f9:	68 38 02 00 00       	push   $0x238
  8035fe:	68 7d 43 80 00       	push   $0x80437d
  803603:	e8 2b 03 00 00       	call   803933 <_panic>
  803608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360b:	8b 00                	mov    (%eax),%eax
  80360d:	85 c0                	test   %eax,%eax
  80360f:	74 10                	je     803621 <realloc_block_FF+0x56a>
  803611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803619:	8b 52 04             	mov    0x4(%edx),%edx
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	eb 0b                	jmp    80362c <realloc_block_FF+0x575>
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	8b 40 04             	mov    0x4(%eax),%eax
  803627:	a3 34 50 80 00       	mov    %eax,0x805034
  80362c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362f:	8b 40 04             	mov    0x4(%eax),%eax
  803632:	85 c0                	test   %eax,%eax
  803634:	74 0f                	je     803645 <realloc_block_FF+0x58e>
  803636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803639:	8b 40 04             	mov    0x4(%eax),%eax
  80363c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363f:	8b 12                	mov    (%edx),%edx
  803641:	89 10                	mov    %edx,(%eax)
  803643:	eb 0a                	jmp    80364f <realloc_block_FF+0x598>
  803645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	a3 30 50 80 00       	mov    %eax,0x805030
  80364f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803662:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803667:	48                   	dec    %eax
  803668:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80366d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803673:	01 d0                	add    %edx,%eax
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	6a 01                	push   $0x1
  80367a:	50                   	push   %eax
  80367b:	ff 75 08             	pushl  0x8(%ebp)
  80367e:	e8 41 ea ff ff       	call   8020c4 <set_block_data>
  803683:	83 c4 10             	add    $0x10,%esp
  803686:	e9 36 01 00 00       	jmp    8037c1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80368b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803691:	01 d0                	add    %edx,%eax
  803693:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	6a 01                	push   $0x1
  80369b:	ff 75 f0             	pushl  -0x10(%ebp)
  80369e:	ff 75 08             	pushl  0x8(%ebp)
  8036a1:	e8 1e ea ff ff       	call   8020c4 <set_block_data>
  8036a6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	83 e8 04             	sub    $0x4,%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8036b4:	89 c2                	mov    %eax,%edx
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	01 d0                	add    %edx,%eax
  8036bb:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c2:	74 06                	je     8036ca <realloc_block_FF+0x613>
  8036c4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036c8:	75 17                	jne    8036e1 <realloc_block_FF+0x62a>
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	68 f0 43 80 00       	push   $0x8043f0
  8036d2:	68 44 02 00 00       	push   $0x244
  8036d7:	68 7d 43 80 00       	push   $0x80437d
  8036dc:	e8 52 02 00 00       	call   803933 <_panic>
  8036e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e4:	8b 10                	mov    (%eax),%edx
  8036e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036e9:	89 10                	mov    %edx,(%eax)
  8036eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	85 c0                	test   %eax,%eax
  8036f2:	74 0b                	je     8036ff <realloc_block_FF+0x648>
  8036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036fc:	89 50 04             	mov    %edx,0x4(%eax)
  8036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803702:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80370a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80370d:	89 50 04             	mov    %edx,0x4(%eax)
  803710:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	85 c0                	test   %eax,%eax
  803717:	75 08                	jne    803721 <realloc_block_FF+0x66a>
  803719:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80371c:	a3 34 50 80 00       	mov    %eax,0x805034
  803721:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803726:	40                   	inc    %eax
  803727:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80372c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803730:	75 17                	jne    803749 <realloc_block_FF+0x692>
  803732:	83 ec 04             	sub    $0x4,%esp
  803735:	68 5f 43 80 00       	push   $0x80435f
  80373a:	68 45 02 00 00       	push   $0x245
  80373f:	68 7d 43 80 00       	push   $0x80437d
  803744:	e8 ea 01 00 00       	call   803933 <_panic>
  803749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	85 c0                	test   %eax,%eax
  803750:	74 10                	je     803762 <realloc_block_FF+0x6ab>
  803752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375a:	8b 52 04             	mov    0x4(%edx),%edx
  80375d:	89 50 04             	mov    %edx,0x4(%eax)
  803760:	eb 0b                	jmp    80376d <realloc_block_FF+0x6b6>
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	8b 40 04             	mov    0x4(%eax),%eax
  803768:	a3 34 50 80 00       	mov    %eax,0x805034
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	85 c0                	test   %eax,%eax
  803775:	74 0f                	je     803786 <realloc_block_FF+0x6cf>
  803777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377a:	8b 40 04             	mov    0x4(%eax),%eax
  80377d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803780:	8b 12                	mov    (%edx),%edx
  803782:	89 10                	mov    %edx,(%eax)
  803784:	eb 0a                	jmp    803790 <realloc_block_FF+0x6d9>
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	a3 30 50 80 00       	mov    %eax,0x805030
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037a8:	48                   	dec    %eax
  8037a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  8037ae:	83 ec 04             	sub    $0x4,%esp
  8037b1:	6a 00                	push   $0x0
  8037b3:	ff 75 bc             	pushl  -0x44(%ebp)
  8037b6:	ff 75 b8             	pushl  -0x48(%ebp)
  8037b9:	e8 06 e9 ff ff       	call   8020c4 <set_block_data>
  8037be:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	eb 0a                	jmp    8037d0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037c6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037d0:	c9                   	leave  
  8037d1:	c3                   	ret    

008037d2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037d2:	55                   	push   %ebp
  8037d3:	89 e5                	mov    %esp,%ebp
  8037d5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037d8:	83 ec 04             	sub    $0x4,%esp
  8037db:	68 74 44 80 00       	push   $0x804474
  8037e0:	68 58 02 00 00       	push   $0x258
  8037e5:	68 7d 43 80 00       	push   $0x80437d
  8037ea:	e8 44 01 00 00       	call   803933 <_panic>

008037ef <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037ef:	55                   	push   %ebp
  8037f0:	89 e5                	mov    %esp,%ebp
  8037f2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037f5:	83 ec 04             	sub    $0x4,%esp
  8037f8:	68 9c 44 80 00       	push   $0x80449c
  8037fd:	68 61 02 00 00       	push   $0x261
  803802:	68 7d 43 80 00       	push   $0x80437d
  803807:	e8 27 01 00 00       	call   803933 <_panic>

0080380c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
  80380f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 c4 44 80 00       	push   $0x8044c4
  80381a:	6a 09                	push   $0x9
  80381c:	68 ec 44 80 00       	push   $0x8044ec
  803821:	e8 0d 01 00 00       	call   803933 <_panic>

00803826 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803826:	55                   	push   %ebp
  803827:	89 e5                	mov    %esp,%ebp
  803829:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80382c:	83 ec 04             	sub    $0x4,%esp
  80382f:	68 fc 44 80 00       	push   $0x8044fc
  803834:	6a 10                	push   $0x10
  803836:	68 ec 44 80 00       	push   $0x8044ec
  80383b:	e8 f3 00 00 00       	call   803933 <_panic>

00803840 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803840:	55                   	push   %ebp
  803841:	89 e5                	mov    %esp,%ebp
  803843:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803846:	83 ec 04             	sub    $0x4,%esp
  803849:	68 24 45 80 00       	push   $0x804524
  80384e:	6a 18                	push   $0x18
  803850:	68 ec 44 80 00       	push   $0x8044ec
  803855:	e8 d9 00 00 00       	call   803933 <_panic>

0080385a <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80385a:	55                   	push   %ebp
  80385b:	89 e5                	mov    %esp,%ebp
  80385d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 4c 45 80 00       	push   $0x80454c
  803868:	6a 20                	push   $0x20
  80386a:	68 ec 44 80 00       	push   $0x8044ec
  80386f:	e8 bf 00 00 00       	call   803933 <_panic>

00803874 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803874:	55                   	push   %ebp
  803875:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80387d:	5d                   	pop    %ebp
  80387e:	c3                   	ret    

0080387f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80387f:	55                   	push   %ebp
  803880:	89 e5                	mov    %esp,%ebp
  803882:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803885:	8b 55 08             	mov    0x8(%ebp),%edx
  803888:	89 d0                	mov    %edx,%eax
  80388a:	c1 e0 02             	shl    $0x2,%eax
  80388d:	01 d0                	add    %edx,%eax
  80388f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803896:	01 d0                	add    %edx,%eax
  803898:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80389f:	01 d0                	add    %edx,%eax
  8038a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a8:	01 d0                	add    %edx,%eax
  8038aa:	c1 e0 04             	shl    $0x4,%eax
  8038ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038ba:	83 ec 0c             	sub    $0xc,%esp
  8038bd:	50                   	push   %eax
  8038be:	e8 bc e1 ff ff       	call   801a7f <sys_get_virtual_time>
  8038c3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038c6:	eb 41                	jmp    803909 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038cb:	83 ec 0c             	sub    $0xc,%esp
  8038ce:	50                   	push   %eax
  8038cf:	e8 ab e1 ff ff       	call   801a7f <sys_get_virtual_time>
  8038d4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dd:	29 c2                	sub    %eax,%edx
  8038df:	89 d0                	mov    %edx,%eax
  8038e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ea:	89 d1                	mov    %edx,%ecx
  8038ec:	29 c1                	sub    %eax,%ecx
  8038ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f4:	39 c2                	cmp    %eax,%edx
  8038f6:	0f 97 c0             	seta   %al
  8038f9:	0f b6 c0             	movzbl %al,%eax
  8038fc:	29 c1                	sub    %eax,%ecx
  8038fe:	89 c8                	mov    %ecx,%eax
  803900:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803906:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80390f:	72 b7                	jb     8038c8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803911:	90                   	nop
  803912:	c9                   	leave  
  803913:	c3                   	ret    

00803914 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803914:	55                   	push   %ebp
  803915:	89 e5                	mov    %esp,%ebp
  803917:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80391a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803921:	eb 03                	jmp    803926 <busy_wait+0x12>
  803923:	ff 45 fc             	incl   -0x4(%ebp)
  803926:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803929:	3b 45 08             	cmp    0x8(%ebp),%eax
  80392c:	72 f5                	jb     803923 <busy_wait+0xf>
	return i;
  80392e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803931:	c9                   	leave  
  803932:	c3                   	ret    

00803933 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
  803936:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803939:	8d 45 10             	lea    0x10(%ebp),%eax
  80393c:	83 c0 04             	add    $0x4,%eax
  80393f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803942:	a1 60 90 18 01       	mov    0x1189060,%eax
  803947:	85 c0                	test   %eax,%eax
  803949:	74 16                	je     803961 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80394b:	a1 60 90 18 01       	mov    0x1189060,%eax
  803950:	83 ec 08             	sub    $0x8,%esp
  803953:	50                   	push   %eax
  803954:	68 74 45 80 00       	push   $0x804574
  803959:	e8 32 ca ff ff       	call   800390 <cprintf>
  80395e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803961:	a1 00 50 80 00       	mov    0x805000,%eax
  803966:	ff 75 0c             	pushl  0xc(%ebp)
  803969:	ff 75 08             	pushl  0x8(%ebp)
  80396c:	50                   	push   %eax
  80396d:	68 79 45 80 00       	push   $0x804579
  803972:	e8 19 ca ff ff       	call   800390 <cprintf>
  803977:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80397a:	8b 45 10             	mov    0x10(%ebp),%eax
  80397d:	83 ec 08             	sub    $0x8,%esp
  803980:	ff 75 f4             	pushl  -0xc(%ebp)
  803983:	50                   	push   %eax
  803984:	e8 9c c9 ff ff       	call   800325 <vcprintf>
  803989:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80398c:	83 ec 08             	sub    $0x8,%esp
  80398f:	6a 00                	push   $0x0
  803991:	68 95 45 80 00       	push   $0x804595
  803996:	e8 8a c9 ff ff       	call   800325 <vcprintf>
  80399b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80399e:	e8 0b c9 ff ff       	call   8002ae <exit>

	// should not return here
	while (1) ;
  8039a3:	eb fe                	jmp    8039a3 <_panic+0x70>

008039a5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039a5:	55                   	push   %ebp
  8039a6:	89 e5                	mov    %esp,%ebp
  8039a8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8039b0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b9:	39 c2                	cmp    %eax,%edx
  8039bb:	74 14                	je     8039d1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039bd:	83 ec 04             	sub    $0x4,%esp
  8039c0:	68 98 45 80 00       	push   $0x804598
  8039c5:	6a 26                	push   $0x26
  8039c7:	68 e4 45 80 00       	push   $0x8045e4
  8039cc:	e8 62 ff ff ff       	call   803933 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039df:	e9 c5 00 00 00       	jmp    803aa9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	01 d0                	add    %edx,%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	85 c0                	test   %eax,%eax
  8039f7:	75 08                	jne    803a01 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039f9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039fc:	e9 a5 00 00 00       	jmp    803aa6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a08:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a0f:	eb 69                	jmp    803a7a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a11:	a1 20 50 80 00       	mov    0x805020,%eax
  803a16:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a1f:	89 d0                	mov    %edx,%eax
  803a21:	01 c0                	add    %eax,%eax
  803a23:	01 d0                	add    %edx,%eax
  803a25:	c1 e0 03             	shl    $0x3,%eax
  803a28:	01 c8                	add    %ecx,%eax
  803a2a:	8a 40 04             	mov    0x4(%eax),%al
  803a2d:	84 c0                	test   %al,%al
  803a2f:	75 46                	jne    803a77 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a31:	a1 20 50 80 00       	mov    0x805020,%eax
  803a36:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a3f:	89 d0                	mov    %edx,%eax
  803a41:	01 c0                	add    %eax,%eax
  803a43:	01 d0                	add    %edx,%eax
  803a45:	c1 e0 03             	shl    $0x3,%eax
  803a48:	01 c8                	add    %ecx,%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a57:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	01 c8                	add    %ecx,%eax
  803a68:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a6a:	39 c2                	cmp    %eax,%edx
  803a6c:	75 09                	jne    803a77 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a6e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a75:	eb 15                	jmp    803a8c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a77:	ff 45 e8             	incl   -0x18(%ebp)
  803a7a:	a1 20 50 80 00       	mov    0x805020,%eax
  803a7f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a88:	39 c2                	cmp    %eax,%edx
  803a8a:	77 85                	ja     803a11 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a90:	75 14                	jne    803aa6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a92:	83 ec 04             	sub    $0x4,%esp
  803a95:	68 f0 45 80 00       	push   $0x8045f0
  803a9a:	6a 3a                	push   $0x3a
  803a9c:	68 e4 45 80 00       	push   $0x8045e4
  803aa1:	e8 8d fe ff ff       	call   803933 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803aa6:	ff 45 f0             	incl   -0x10(%ebp)
  803aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803aaf:	0f 8c 2f ff ff ff    	jl     8039e4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ab5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803abc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ac3:	eb 26                	jmp    803aeb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ac5:	a1 20 50 80 00       	mov    0x805020,%eax
  803aca:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ad0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ad3:	89 d0                	mov    %edx,%eax
  803ad5:	01 c0                	add    %eax,%eax
  803ad7:	01 d0                	add    %edx,%eax
  803ad9:	c1 e0 03             	shl    $0x3,%eax
  803adc:	01 c8                	add    %ecx,%eax
  803ade:	8a 40 04             	mov    0x4(%eax),%al
  803ae1:	3c 01                	cmp    $0x1,%al
  803ae3:	75 03                	jne    803ae8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ae5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ae8:	ff 45 e0             	incl   -0x20(%ebp)
  803aeb:	a1 20 50 80 00       	mov    0x805020,%eax
  803af0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af9:	39 c2                	cmp    %eax,%edx
  803afb:	77 c8                	ja     803ac5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b00:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b03:	74 14                	je     803b19 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b05:	83 ec 04             	sub    $0x4,%esp
  803b08:	68 44 46 80 00       	push   $0x804644
  803b0d:	6a 44                	push   $0x44
  803b0f:	68 e4 45 80 00       	push   $0x8045e4
  803b14:	e8 1a fe ff ff       	call   803933 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b19:	90                   	nop
  803b1a:	c9                   	leave  
  803b1b:	c3                   	ret    

00803b1c <__udivdi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b33:	89 ca                	mov    %ecx,%edx
  803b35:	89 f8                	mov    %edi,%eax
  803b37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b3b:	85 f6                	test   %esi,%esi
  803b3d:	75 2d                	jne    803b6c <__udivdi3+0x50>
  803b3f:	39 cf                	cmp    %ecx,%edi
  803b41:	77 65                	ja     803ba8 <__udivdi3+0x8c>
  803b43:	89 fd                	mov    %edi,%ebp
  803b45:	85 ff                	test   %edi,%edi
  803b47:	75 0b                	jne    803b54 <__udivdi3+0x38>
  803b49:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	f7 f7                	div    %edi
  803b52:	89 c5                	mov    %eax,%ebp
  803b54:	31 d2                	xor    %edx,%edx
  803b56:	89 c8                	mov    %ecx,%eax
  803b58:	f7 f5                	div    %ebp
  803b5a:	89 c1                	mov    %eax,%ecx
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	f7 f5                	div    %ebp
  803b60:	89 cf                	mov    %ecx,%edi
  803b62:	89 fa                	mov    %edi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	77 28                	ja     803b98 <__udivdi3+0x7c>
  803b70:	0f bd fe             	bsr    %esi,%edi
  803b73:	83 f7 1f             	xor    $0x1f,%edi
  803b76:	75 40                	jne    803bb8 <__udivdi3+0x9c>
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	72 0a                	jb     803b86 <__udivdi3+0x6a>
  803b7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b80:	0f 87 9e 00 00 00    	ja     803c24 <__udivdi3+0x108>
  803b86:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8b:	89 fa                	mov    %edi,%edx
  803b8d:	83 c4 1c             	add    $0x1c,%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    
  803b95:	8d 76 00             	lea    0x0(%esi),%esi
  803b98:	31 ff                	xor    %edi,%edi
  803b9a:	31 c0                	xor    %eax,%eax
  803b9c:	89 fa                	mov    %edi,%edx
  803b9e:	83 c4 1c             	add    $0x1c,%esp
  803ba1:	5b                   	pop    %ebx
  803ba2:	5e                   	pop    %esi
  803ba3:	5f                   	pop    %edi
  803ba4:	5d                   	pop    %ebp
  803ba5:	c3                   	ret    
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f7                	div    %edi
  803bac:	31 ff                	xor    %edi,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bbd:	89 eb                	mov    %ebp,%ebx
  803bbf:	29 fb                	sub    %edi,%ebx
  803bc1:	89 f9                	mov    %edi,%ecx
  803bc3:	d3 e6                	shl    %cl,%esi
  803bc5:	89 c5                	mov    %eax,%ebp
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 ed                	shr    %cl,%ebp
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	09 f1                	or     %esi,%ecx
  803bcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e0                	shl    %cl,%eax
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 ee                	shr    %cl,%esi
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e2                	shl    %cl,%edx
  803be3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 e8                	shr    %cl,%eax
  803beb:	09 c2                	or     %eax,%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	89 f2                	mov    %esi,%edx
  803bf1:	f7 74 24 0c          	divl   0xc(%esp)
  803bf5:	89 d6                	mov    %edx,%esi
  803bf7:	89 c3                	mov    %eax,%ebx
  803bf9:	f7 e5                	mul    %ebp
  803bfb:	39 d6                	cmp    %edx,%esi
  803bfd:	72 19                	jb     803c18 <__udivdi3+0xfc>
  803bff:	74 0b                	je     803c0c <__udivdi3+0xf0>
  803c01:	89 d8                	mov    %ebx,%eax
  803c03:	31 ff                	xor    %edi,%edi
  803c05:	e9 58 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c10:	89 f9                	mov    %edi,%ecx
  803c12:	d3 e2                	shl    %cl,%edx
  803c14:	39 c2                	cmp    %eax,%edx
  803c16:	73 e9                	jae    803c01 <__udivdi3+0xe5>
  803c18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c1b:	31 ff                	xor    %edi,%edi
  803c1d:	e9 40 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	31 c0                	xor    %eax,%eax
  803c26:	e9 37 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c2b:	90                   	nop

00803c2c <__umoddi3>:
  803c2c:	55                   	push   %ebp
  803c2d:	57                   	push   %edi
  803c2e:	56                   	push   %esi
  803c2f:	53                   	push   %ebx
  803c30:	83 ec 1c             	sub    $0x1c,%esp
  803c33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c4b:	89 f3                	mov    %esi,%ebx
  803c4d:	89 fa                	mov    %edi,%edx
  803c4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c53:	89 34 24             	mov    %esi,(%esp)
  803c56:	85 c0                	test   %eax,%eax
  803c58:	75 1a                	jne    803c74 <__umoddi3+0x48>
  803c5a:	39 f7                	cmp    %esi,%edi
  803c5c:	0f 86 a2 00 00 00    	jbe    803d04 <__umoddi3+0xd8>
  803c62:	89 c8                	mov    %ecx,%eax
  803c64:	89 f2                	mov    %esi,%edx
  803c66:	f7 f7                	div    %edi
  803c68:	89 d0                	mov    %edx,%eax
  803c6a:	31 d2                	xor    %edx,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	39 f0                	cmp    %esi,%eax
  803c76:	0f 87 ac 00 00 00    	ja     803d28 <__umoddi3+0xfc>
  803c7c:	0f bd e8             	bsr    %eax,%ebp
  803c7f:	83 f5 1f             	xor    $0x1f,%ebp
  803c82:	0f 84 ac 00 00 00    	je     803d34 <__umoddi3+0x108>
  803c88:	bf 20 00 00 00       	mov    $0x20,%edi
  803c8d:	29 ef                	sub    %ebp,%edi
  803c8f:	89 fe                	mov    %edi,%esi
  803c91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e0                	shl    %cl,%eax
  803c99:	89 d7                	mov    %edx,%edi
  803c9b:	89 f1                	mov    %esi,%ecx
  803c9d:	d3 ef                	shr    %cl,%edi
  803c9f:	09 c7                	or     %eax,%edi
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e2                	shl    %cl,%edx
  803ca5:	89 14 24             	mov    %edx,(%esp)
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	d3 e0                	shl    %cl,%eax
  803cac:	89 c2                	mov    %eax,%edx
  803cae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb2:	d3 e0                	shl    %cl,%eax
  803cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbc:	89 f1                	mov    %esi,%ecx
  803cbe:	d3 e8                	shr    %cl,%eax
  803cc0:	09 d0                	or     %edx,%eax
  803cc2:	d3 eb                	shr    %cl,%ebx
  803cc4:	89 da                	mov    %ebx,%edx
  803cc6:	f7 f7                	div    %edi
  803cc8:	89 d3                	mov    %edx,%ebx
  803cca:	f7 24 24             	mull   (%esp)
  803ccd:	89 c6                	mov    %eax,%esi
  803ccf:	89 d1                	mov    %edx,%ecx
  803cd1:	39 d3                	cmp    %edx,%ebx
  803cd3:	0f 82 87 00 00 00    	jb     803d60 <__umoddi3+0x134>
  803cd9:	0f 84 91 00 00 00    	je     803d70 <__umoddi3+0x144>
  803cdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ce3:	29 f2                	sub    %esi,%edx
  803ce5:	19 cb                	sbb    %ecx,%ebx
  803ce7:	89 d8                	mov    %ebx,%eax
  803ce9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ced:	d3 e0                	shl    %cl,%eax
  803cef:	89 e9                	mov    %ebp,%ecx
  803cf1:	d3 ea                	shr    %cl,%edx
  803cf3:	09 d0                	or     %edx,%eax
  803cf5:	89 e9                	mov    %ebp,%ecx
  803cf7:	d3 eb                	shr    %cl,%ebx
  803cf9:	89 da                	mov    %ebx,%edx
  803cfb:	83 c4 1c             	add    $0x1c,%esp
  803cfe:	5b                   	pop    %ebx
  803cff:	5e                   	pop    %esi
  803d00:	5f                   	pop    %edi
  803d01:	5d                   	pop    %ebp
  803d02:	c3                   	ret    
  803d03:	90                   	nop
  803d04:	89 fd                	mov    %edi,%ebp
  803d06:	85 ff                	test   %edi,%edi
  803d08:	75 0b                	jne    803d15 <__umoddi3+0xe9>
  803d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0f:	31 d2                	xor    %edx,%edx
  803d11:	f7 f7                	div    %edi
  803d13:	89 c5                	mov    %eax,%ebp
  803d15:	89 f0                	mov    %esi,%eax
  803d17:	31 d2                	xor    %edx,%edx
  803d19:	f7 f5                	div    %ebp
  803d1b:	89 c8                	mov    %ecx,%eax
  803d1d:	f7 f5                	div    %ebp
  803d1f:	89 d0                	mov    %edx,%eax
  803d21:	e9 44 ff ff ff       	jmp    803c6a <__umoddi3+0x3e>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	89 c8                	mov    %ecx,%eax
  803d2a:	89 f2                	mov    %esi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	3b 04 24             	cmp    (%esp),%eax
  803d37:	72 06                	jb     803d3f <__umoddi3+0x113>
  803d39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d3d:	77 0f                	ja     803d4e <__umoddi3+0x122>
  803d3f:	89 f2                	mov    %esi,%edx
  803d41:	29 f9                	sub    %edi,%ecx
  803d43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d47:	89 14 24             	mov    %edx,(%esp)
  803d4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d52:	8b 14 24             	mov    (%esp),%edx
  803d55:	83 c4 1c             	add    $0x1c,%esp
  803d58:	5b                   	pop    %ebx
  803d59:	5e                   	pop    %esi
  803d5a:	5f                   	pop    %edi
  803d5b:	5d                   	pop    %ebp
  803d5c:	c3                   	ret    
  803d5d:	8d 76 00             	lea    0x0(%esi),%esi
  803d60:	2b 04 24             	sub    (%esp),%eax
  803d63:	19 fa                	sbb    %edi,%edx
  803d65:	89 d1                	mov    %edx,%ecx
  803d67:	89 c6                	mov    %eax,%esi
  803d69:	e9 71 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d74:	72 ea                	jb     803d60 <__umoddi3+0x134>
  803d76:	89 d9                	mov    %ebx,%ecx
  803d78:	e9 62 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
