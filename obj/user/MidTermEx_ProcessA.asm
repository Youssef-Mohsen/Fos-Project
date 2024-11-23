
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
  80003e:	e8 b2 18 00 00       	call   8018f5 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 3c 80 00       	push   $0x803c40
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 87 14 00 00       	call   8014dd <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 3c 80 00       	push   $0x803c42
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 71 14 00 00       	call   8014dd <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 3c 80 00       	push   $0x803c49
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 5b 14 00 00       	call   8014dd <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 94 18 00 00       	call   801928 <sys_get_virtual_time>
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
  8000b7:	e8 6c 36 00 00       	call   803728 <env_sleep>
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
  8000d0:	e8 53 18 00 00       	call   801928 <sys_get_virtual_time>
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
  8000f8:	e8 2b 36 00 00       	call   803728 <env_sleep>
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
  80010f:	e8 14 18 00 00       	call   801928 <sys_get_virtual_time>
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
  800137:	e8 ec 35 00 00       	call   803728 <env_sleep>
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
  80014f:	68 57 3c 80 00       	push   $0x803c57
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 72 35 00 00       	call   8036cf <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 98 35 00 00       	call   803703 <signal_semaphore>
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
  800184:	e8 53 17 00 00       	call   8018dc <sys_getenvindex>
  800189:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018f:	89 d0                	mov    %edx,%eax
  800191:	c1 e0 03             	shl    $0x3,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80019d:	01 c8                	add    %ecx,%eax
  80019f:	01 c0                	add    %eax,%eax
  8001a1:	01 d0                	add    %edx,%eax
  8001a3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001aa:	01 c8                	add    %ecx,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001bd:	8a 40 20             	mov    0x20(%eax),%al
  8001c0:	84 c0                	test   %al,%al
  8001c2:	74 0d                	je     8001d1 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8001c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c9:	83 c0 20             	add    $0x20,%eax
  8001cc:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x63>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001f2:	e8 69 14 00 00       	call   801660 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 74 3c 80 00       	push   $0x803c74
  8001ff:	e8 8d 01 00 00       	call   800391 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 50 80 00       	mov    0x805020,%eax
  80020c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800212:	a1 20 50 80 00       	mov    0x805020,%eax
  800217:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 9c 3c 80 00       	push   $0x803c9c
  800227:	e8 65 01 00 00       	call   800391 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 50 80 00       	mov    0x805020,%eax
  800234:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80023a:	a1 20 50 80 00       	mov    0x805020,%eax
  80023f:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800245:	a1 20 50 80 00       	mov    0x805020,%eax
  80024a:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 c4 3c 80 00       	push   $0x803cc4
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 1c 3d 80 00       	push   $0x803d1c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 74 3c 80 00       	push   $0x803c74
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 e9 13 00 00       	call   80167a <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 ff 15 00 00       	call   8018a8 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 54 16 00 00       	call   80190e <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c6:	8b 00                	mov    (%eax),%eax
  8002c8:	8d 48 01             	lea    0x1(%eax),%ecx
  8002cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ce:	89 0a                	mov    %ecx,(%edx)
  8002d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d3:	88 d1                	mov    %dl,%cl
  8002d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e6:	75 2c                	jne    800314 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002e8:	a0 28 50 80 00       	mov    0x805028,%al
  8002ed:	0f b6 c0             	movzbl %al,%eax
  8002f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f3:	8b 12                	mov    (%edx),%edx
  8002f5:	89 d1                	mov    %edx,%ecx
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	83 c2 08             	add    $0x8,%edx
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	50                   	push   %eax
  800301:	51                   	push   %ecx
  800302:	52                   	push   %edx
  800303:	e8 16 13 00 00       	call   80161e <sys_cputs>
  800308:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	8b 40 04             	mov    0x4(%eax),%eax
  80031a:	8d 50 01             	lea    0x1(%eax),%edx
  80031d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800320:	89 50 04             	mov    %edx,0x4(%eax)
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800336:	00 00 00 
	b.cnt = 0;
  800339:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800340:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800343:	ff 75 0c             	pushl  0xc(%ebp)
  800346:	ff 75 08             	pushl  0x8(%ebp)
  800349:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034f:	50                   	push   %eax
  800350:	68 bd 02 80 00       	push   $0x8002bd
  800355:	e8 11 02 00 00       	call   80056b <vprintfmt>
  80035a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80035d:	a0 28 50 80 00       	mov    0x805028,%al
  800362:	0f b6 c0             	movzbl %al,%eax
  800365:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	50                   	push   %eax
  80036f:	52                   	push   %edx
  800370:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800376:	83 c0 08             	add    $0x8,%eax
  800379:	50                   	push   %eax
  80037a:	e8 9f 12 00 00       	call   80161e <sys_cputs>
  80037f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800382:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800389:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800397:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80039e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ad:	50                   	push   %eax
  8003ae:	e8 73 ff ff ff       	call   800326 <vcprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003c4:	e8 97 12 00 00       	call   801660 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d8:	50                   	push   %eax
  8003d9:	e8 48 ff ff ff       	call   800326 <vcprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003e4:	e8 91 12 00 00       	call   80167a <sys_unlock_cons>
	return cnt;
  8003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	53                   	push   %ebx
  8003f2:	83 ec 14             	sub    $0x14,%esp
  8003f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800401:	8b 45 18             	mov    0x18(%ebp),%eax
  800404:	ba 00 00 00 00       	mov    $0x0,%edx
  800409:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80040c:	77 55                	ja     800463 <printnum+0x75>
  80040e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800411:	72 05                	jb     800418 <printnum+0x2a>
  800413:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800416:	77 4b                	ja     800463 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800418:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80041e:	8b 45 18             	mov    0x18(%ebp),%eax
  800421:	ba 00 00 00 00       	mov    $0x0,%edx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	ff 75 f4             	pushl  -0xc(%ebp)
  80042b:	ff 75 f0             	pushl  -0x10(%ebp)
  80042e:	e8 95 35 00 00       	call   8039c8 <__udivdi3>
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	ff 75 20             	pushl  0x20(%ebp)
  80043c:	53                   	push   %ebx
  80043d:	ff 75 18             	pushl  0x18(%ebp)
  800440:	52                   	push   %edx
  800441:	50                   	push   %eax
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	e8 a1 ff ff ff       	call   8003ee <printnum>
  80044d:	83 c4 20             	add    $0x20,%esp
  800450:	eb 1a                	jmp    80046c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 20             	pushl  0x20(%ebp)
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	ff d0                	call   *%eax
  800460:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800463:	ff 4d 1c             	decl   0x1c(%ebp)
  800466:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80046a:	7f e6                	jg     800452 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80046f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047a:	53                   	push   %ebx
  80047b:	51                   	push   %ecx
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	e8 55 36 00 00       	call   803ad8 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 54 3f 80 00       	add    $0x803f54,%eax
  80048b:	8a 00                	mov    (%eax),%al
  80048d:	0f be c0             	movsbl %al,%eax
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	ff 75 0c             	pushl  0xc(%ebp)
  800496:	50                   	push   %eax
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	ff d0                	call   *%eax
  80049c:	83 c4 10             	add    $0x10,%esp
}
  80049f:	90                   	nop
  8004a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a3:	c9                   	leave  
  8004a4:	c3                   	ret    

008004a5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a5:	55                   	push   %ebp
  8004a6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ac:	7e 1c                	jle    8004ca <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 08             	lea    0x8(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 08             	sub    $0x8,%eax
  8004c3:	8b 50 04             	mov    0x4(%eax),%edx
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	eb 40                	jmp    80050a <getuint+0x65>
	else if (lflag)
  8004ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ce:	74 1e                	je     8004ee <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	8d 50 04             	lea    0x4(%eax),%edx
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	89 10                	mov    %edx,(%eax)
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	83 e8 04             	sub    $0x4,%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	eb 1c                	jmp    80050a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80050f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800513:	7e 1c                	jle    800531 <getint+0x25>
		return va_arg(*ap, long long);
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	8d 50 08             	lea    0x8(%eax),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	89 10                	mov    %edx,(%eax)
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	83 e8 08             	sub    $0x8,%eax
  80052a:	8b 50 04             	mov    0x4(%eax),%edx
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	eb 38                	jmp    800569 <getint+0x5d>
	else if (lflag)
  800531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800535:	74 1a                	je     800551 <getint+0x45>
		return va_arg(*ap, long);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	8d 50 04             	lea    0x4(%eax),%edx
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	89 10                	mov    %edx,(%eax)
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	83 e8 04             	sub    $0x4,%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	99                   	cltd   
  80054f:	eb 18                	jmp    800569 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	8d 50 04             	lea    0x4(%eax),%edx
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	89 10                	mov    %edx,(%eax)
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 e8 04             	sub    $0x4,%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	99                   	cltd   
}
  800569:	5d                   	pop    %ebp
  80056a:	c3                   	ret    

0080056b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	56                   	push   %esi
  80056f:	53                   	push   %ebx
  800570:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800573:	eb 17                	jmp    80058c <vprintfmt+0x21>
			if (ch == '\0')
  800575:	85 db                	test   %ebx,%ebx
  800577:	0f 84 c1 03 00 00    	je     80093e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80057d:	83 ec 08             	sub    $0x8,%esp
  800580:	ff 75 0c             	pushl  0xc(%ebp)
  800583:	53                   	push   %ebx
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	ff d0                	call   *%eax
  800589:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80058c:	8b 45 10             	mov    0x10(%ebp),%eax
  80058f:	8d 50 01             	lea    0x1(%eax),%edx
  800592:	89 55 10             	mov    %edx,0x10(%ebp)
  800595:	8a 00                	mov    (%eax),%al
  800597:	0f b6 d8             	movzbl %al,%ebx
  80059a:	83 fb 25             	cmp    $0x25,%ebx
  80059d:	75 d6                	jne    800575 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80059f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c2:	8d 50 01             	lea    0x1(%eax),%edx
  8005c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c8:	8a 00                	mov    (%eax),%al
  8005ca:	0f b6 d8             	movzbl %al,%ebx
  8005cd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005d0:	83 f8 5b             	cmp    $0x5b,%eax
  8005d3:	0f 87 3d 03 00 00    	ja     800916 <vprintfmt+0x3ab>
  8005d9:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  8005e0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005e6:	eb d7                	jmp    8005bf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ec:	eb d1                	jmp    8005bf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f8:	89 d0                	mov    %edx,%eax
  8005fa:	c1 e0 02             	shl    $0x2,%eax
  8005fd:	01 d0                	add    %edx,%eax
  8005ff:	01 c0                	add    %eax,%eax
  800601:	01 d8                	add    %ebx,%eax
  800603:	83 e8 30             	sub    $0x30,%eax
  800606:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800609:	8b 45 10             	mov    0x10(%ebp),%eax
  80060c:	8a 00                	mov    (%eax),%al
  80060e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800611:	83 fb 2f             	cmp    $0x2f,%ebx
  800614:	7e 3e                	jle    800654 <vprintfmt+0xe9>
  800616:	83 fb 39             	cmp    $0x39,%ebx
  800619:	7f 39                	jg     800654 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80061e:	eb d5                	jmp    8005f5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 c0 04             	add    $0x4,%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800634:	eb 1f                	jmp    800655 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800636:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063a:	79 83                	jns    8005bf <vprintfmt+0x54>
				width = 0;
  80063c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800643:	e9 77 ff ff ff       	jmp    8005bf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800648:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80064f:	e9 6b ff ff ff       	jmp    8005bf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800654:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800655:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800659:	0f 89 60 ff ff ff    	jns    8005bf <vprintfmt+0x54>
				width = precision, precision = -1;
  80065f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800665:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80066c:	e9 4e ff ff ff       	jmp    8005bf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800671:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800674:	e9 46 ff ff ff       	jmp    8005bf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	83 c0 04             	add    $0x4,%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	83 e8 04             	sub    $0x4,%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	50                   	push   %eax
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	ff d0                	call   *%eax
  800696:	83 c4 10             	add    $0x10,%esp
			break;
  800699:	e9 9b 02 00 00       	jmp    800939 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	83 c0 04             	add    $0x4,%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	83 e8 04             	sub    $0x4,%eax
  8006ad:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006af:	85 db                	test   %ebx,%ebx
  8006b1:	79 02                	jns    8006b5 <vprintfmt+0x14a>
				err = -err;
  8006b3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006b5:	83 fb 64             	cmp    $0x64,%ebx
  8006b8:	7f 0b                	jg     8006c5 <vprintfmt+0x15a>
  8006ba:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 65 3f 80 00       	push   $0x803f65
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	ff 75 08             	pushl  0x8(%ebp)
  8006d1:	e8 70 02 00 00       	call   800946 <printfmt>
  8006d6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d9:	e9 5b 02 00 00       	jmp    800939 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006de:	56                   	push   %esi
  8006df:	68 6e 3f 80 00       	push   $0x803f6e
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	ff 75 08             	pushl  0x8(%ebp)
  8006ea:	e8 57 02 00 00       	call   800946 <printfmt>
  8006ef:	83 c4 10             	add    $0x10,%esp
			break;
  8006f2:	e9 42 02 00 00       	jmp    800939 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 c0 04             	add    $0x4,%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 30                	mov    (%eax),%esi
  800708:	85 f6                	test   %esi,%esi
  80070a:	75 05                	jne    800711 <vprintfmt+0x1a6>
				p = "(null)";
  80070c:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800711:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800715:	7e 6d                	jle    800784 <vprintfmt+0x219>
  800717:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80071b:	74 67                	je     800784 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80071d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	50                   	push   %eax
  800724:	56                   	push   %esi
  800725:	e8 1e 03 00 00       	call   800a48 <strnlen>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800730:	eb 16                	jmp    800748 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800732:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	50                   	push   %eax
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800745:	ff 4d e4             	decl   -0x1c(%ebp)
  800748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074c:	7f e4                	jg     800732 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074e:	eb 34                	jmp    800784 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800750:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800754:	74 1c                	je     800772 <vprintfmt+0x207>
  800756:	83 fb 1f             	cmp    $0x1f,%ebx
  800759:	7e 05                	jle    800760 <vprintfmt+0x1f5>
  80075b:	83 fb 7e             	cmp    $0x7e,%ebx
  80075e:	7e 12                	jle    800772 <vprintfmt+0x207>
					putch('?', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	6a 3f                	push   $0x3f
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	eb 0f                	jmp    800781 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	53                   	push   %ebx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	ff d0                	call   *%eax
  80077e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800781:	ff 4d e4             	decl   -0x1c(%ebp)
  800784:	89 f0                	mov    %esi,%eax
  800786:	8d 70 01             	lea    0x1(%eax),%esi
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f be d8             	movsbl %al,%ebx
  80078e:	85 db                	test   %ebx,%ebx
  800790:	74 24                	je     8007b6 <vprintfmt+0x24b>
  800792:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800796:	78 b8                	js     800750 <vprintfmt+0x1e5>
  800798:	ff 4d e0             	decl   -0x20(%ebp)
  80079b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079f:	79 af                	jns    800750 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a1:	eb 13                	jmp    8007b6 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 20                	push   $0x20
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b3:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ba:	7f e7                	jg     8007a3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007bc:	e9 78 01 00 00       	jmp    800939 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ca:	50                   	push   %eax
  8007cb:	e8 3c fd ff ff       	call   80050c <getint>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007df:	85 d2                	test   %edx,%edx
  8007e1:	79 23                	jns    800806 <vprintfmt+0x29b>
				putch('-', putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	6a 2d                	push   $0x2d
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	ff d0                	call   *%eax
  8007f0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f9:	f7 d8                	neg    %eax
  8007fb:	83 d2 00             	adc    $0x0,%edx
  8007fe:	f7 da                	neg    %edx
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800803:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800806:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80080d:	e9 bc 00 00 00       	jmp    8008ce <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 e8             	pushl  -0x18(%ebp)
  800818:	8d 45 14             	lea    0x14(%ebp),%eax
  80081b:	50                   	push   %eax
  80081c:	e8 84 fc ff ff       	call   8004a5 <getuint>
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800827:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80082a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800831:	e9 98 00 00 00       	jmp    8008ce <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	6a 58                	push   $0x58
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	6a 58                	push   $0x58
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	ff d0                	call   *%eax
  800853:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 58                	push   $0x58
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			break;
  800866:	e9 ce 00 00 00       	jmp    800939 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	6a 30                	push   $0x30
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	ff d0                	call   *%eax
  800878:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	6a 78                	push   $0x78
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008a6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ad:	eb 1f                	jmp    8008ce <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b8:	50                   	push   %eax
  8008b9:	e8 e7 fb ff ff       	call   8004a5 <getuint>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008c7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008ce:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d5:	83 ec 04             	sub    $0x4,%esp
  8008d8:	52                   	push   %edx
  8008d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	ff 75 08             	pushl  0x8(%ebp)
  8008e9:	e8 00 fb ff ff       	call   8003ee <printnum>
  8008ee:	83 c4 20             	add    $0x20,%esp
			break;
  8008f1:	eb 46                	jmp    800939 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	53                   	push   %ebx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	ff d0                	call   *%eax
  8008ff:	83 c4 10             	add    $0x10,%esp
			break;
  800902:	eb 35                	jmp    800939 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800904:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80090b:	eb 2c                	jmp    800939 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80090d:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800914:	eb 23                	jmp    800939 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	6a 25                	push   $0x25
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800926:	ff 4d 10             	decl   0x10(%ebp)
  800929:	eb 03                	jmp    80092e <vprintfmt+0x3c3>
  80092b:	ff 4d 10             	decl   0x10(%ebp)
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	48                   	dec    %eax
  800932:	8a 00                	mov    (%eax),%al
  800934:	3c 25                	cmp    $0x25,%al
  800936:	75 f3                	jne    80092b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800938:	90                   	nop
		}
	}
  800939:	e9 35 fc ff ff       	jmp    800573 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80093e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80093f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80094c:	8d 45 10             	lea    0x10(%ebp),%eax
  80094f:	83 c0 04             	add    $0x4,%eax
  800952:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800955:	8b 45 10             	mov    0x10(%ebp),%eax
  800958:	ff 75 f4             	pushl  -0xc(%ebp)
  80095b:	50                   	push   %eax
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 04 fc ff ff       	call   80056b <vprintfmt>
  800967:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80096a:	90                   	nop
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8b 40 08             	mov    0x8(%eax),%eax
  800976:	8d 50 01             	lea    0x1(%eax),%edx
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 10                	mov    (%eax),%edx
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	8b 40 04             	mov    0x4(%eax),%eax
  80098a:	39 c2                	cmp    %eax,%edx
  80098c:	73 12                	jae    8009a0 <sprintputch+0x33>
		*b->buf++ = ch;
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	8d 48 01             	lea    0x1(%eax),%ecx
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	89 0a                	mov    %ecx,(%edx)
  80099b:	8b 55 08             	mov    0x8(%ebp),%edx
  80099e:	88 10                	mov    %dl,(%eax)
}
  8009a0:	90                   	nop
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c8:	74 06                	je     8009d0 <vsnprintf+0x2d>
  8009ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ce:	7f 07                	jg     8009d7 <vsnprintf+0x34>
		return -E_INVAL;
  8009d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8009d5:	eb 20                	jmp    8009f7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d7:	ff 75 14             	pushl  0x14(%ebp)
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e0:	50                   	push   %eax
  8009e1:	68 6d 09 80 00       	push   $0x80096d
  8009e6:	e8 80 fb ff ff       	call   80056b <vprintfmt>
  8009eb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ff:	8d 45 10             	lea    0x10(%ebp),%eax
  800a02:	83 c0 04             	add    $0x4,%eax
  800a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0e:	50                   	push   %eax
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	ff 75 08             	pushl  0x8(%ebp)
  800a15:	e8 89 ff ff ff       	call   8009a3 <vsnprintf>
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a23:	c9                   	leave  
  800a24:	c3                   	ret    

00800a25 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a32:	eb 06                	jmp    800a3a <strlen+0x15>
		n++;
  800a34:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a37:	ff 45 08             	incl   0x8(%ebp)
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8a 00                	mov    (%eax),%al
  800a3f:	84 c0                	test   %al,%al
  800a41:	75 f1                	jne    800a34 <strlen+0xf>
		n++;
	return n;
  800a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a46:	c9                   	leave  
  800a47:	c3                   	ret    

00800a48 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a55:	eb 09                	jmp    800a60 <strnlen+0x18>
		n++;
  800a57:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5a:	ff 45 08             	incl   0x8(%ebp)
  800a5d:	ff 4d 0c             	decl   0xc(%ebp)
  800a60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a64:	74 09                	je     800a6f <strnlen+0x27>
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8a 00                	mov    (%eax),%al
  800a6b:	84 c0                	test   %al,%al
  800a6d:	75 e8                	jne    800a57 <strnlen+0xf>
		n++;
	return n;
  800a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a80:	90                   	nop
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8d 50 01             	lea    0x1(%eax),%edx
  800a87:	89 55 08             	mov    %edx,0x8(%ebp)
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a90:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a93:	8a 12                	mov    (%edx),%dl
  800a95:	88 10                	mov    %dl,(%eax)
  800a97:	8a 00                	mov    (%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 e4                	jne    800a81 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800aae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab5:	eb 1f                	jmp    800ad6 <strncpy+0x34>
		*dst++ = *src;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8d 50 01             	lea    0x1(%eax),%edx
  800abd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	8a 12                	mov    (%edx),%dl
  800ac5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	8a 00                	mov    (%eax),%al
  800acc:	84 c0                	test   %al,%al
  800ace:	74 03                	je     800ad3 <strncpy+0x31>
			src++;
  800ad0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad3:	ff 45 fc             	incl   -0x4(%ebp)
  800ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800adc:	72 d9                	jb     800ab7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ade:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af3:	74 30                	je     800b25 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800af5:	eb 16                	jmp    800b0d <strlcpy+0x2a>
			*dst++ = *src++;
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8d 50 01             	lea    0x1(%eax),%edx
  800afd:	89 55 08             	mov    %edx,0x8(%ebp)
  800b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b06:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b09:	8a 12                	mov    (%edx),%dl
  800b0b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b14:	74 09                	je     800b1f <strlcpy+0x3c>
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8a 00                	mov    (%eax),%al
  800b1b:	84 c0                	test   %al,%al
  800b1d:	75 d8                	jne    800af7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b25:	8b 55 08             	mov    0x8(%ebp),%edx
  800b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2b:	29 c2                	sub    %eax,%edx
  800b2d:	89 d0                	mov    %edx,%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b34:	eb 06                	jmp    800b3c <strcmp+0xb>
		p++, q++;
  800b36:	ff 45 08             	incl   0x8(%ebp)
  800b39:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	84 c0                	test   %al,%al
  800b43:	74 0e                	je     800b53 <strcmp+0x22>
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8a 10                	mov    (%eax),%dl
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	38 c2                	cmp    %al,%dl
  800b51:	74 e3                	je     800b36 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	0f b6 d0             	movzbl %al,%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f b6 c0             	movzbl %al,%eax
  800b63:	29 c2                	sub    %eax,%edx
  800b65:	89 d0                	mov    %edx,%eax
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b6c:	eb 09                	jmp    800b77 <strncmp+0xe>
		n--, p++, q++;
  800b6e:	ff 4d 10             	decl   0x10(%ebp)
  800b71:	ff 45 08             	incl   0x8(%ebp)
  800b74:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7b:	74 17                	je     800b94 <strncmp+0x2b>
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8a 00                	mov    (%eax),%al
  800b82:	84 c0                	test   %al,%al
  800b84:	74 0e                	je     800b94 <strncmp+0x2b>
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8a 10                	mov    (%eax),%dl
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	38 c2                	cmp    %al,%dl
  800b92:	74 da                	je     800b6e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b98:	75 07                	jne    800ba1 <strncmp+0x38>
		return 0;
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	eb 14                	jmp    800bb5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	0f b6 d0             	movzbl %al,%edx
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	0f b6 c0             	movzbl %al,%eax
  800bb1:	29 c2                	sub    %eax,%edx
  800bb3:	89 d0                	mov    %edx,%eax
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 04             	sub    $0x4,%esp
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc3:	eb 12                	jmp    800bd7 <strchr+0x20>
		if (*s == c)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bcd:	75 05                	jne    800bd4 <strchr+0x1d>
			return (char *) s;
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	eb 11                	jmp    800be5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bd4:	ff 45 08             	incl   0x8(%ebp)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	84 c0                	test   %al,%al
  800bde:	75 e5                	jne    800bc5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf3:	eb 0d                	jmp    800c02 <strfind+0x1b>
		if (*s == c)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bfd:	74 0e                	je     800c0d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bff:	ff 45 08             	incl   0x8(%ebp)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	84 c0                	test   %al,%al
  800c09:	75 ea                	jne    800bf5 <strfind+0xe>
  800c0b:	eb 01                	jmp    800c0e <strfind+0x27>
		if (*s == c)
			break;
  800c0d:	90                   	nop
	return (char *) s;
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c25:	eb 0e                	jmp    800c35 <memset+0x22>
		*p++ = c;
  800c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2a:	8d 50 01             	lea    0x1(%eax),%edx
  800c2d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c33:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c35:	ff 4d f8             	decl   -0x8(%ebp)
  800c38:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c3c:	79 e9                	jns    800c27 <memset+0x14>
		*p++ = c;

	return v;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c55:	eb 16                	jmp    800c6d <memcpy+0x2a>
		*d++ = *s++;
  800c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c5a:	8d 50 01             	lea    0x1(%eax),%edx
  800c5d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c63:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c66:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c69:	8a 12                	mov    (%edx),%dl
  800c6b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c73:	89 55 10             	mov    %edx,0x10(%ebp)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	75 dd                	jne    800c57 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c94:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c97:	73 50                	jae    800ce9 <memmove+0x6a>
  800c99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	01 d0                	add    %edx,%eax
  800ca1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ca4:	76 43                	jbe    800ce9 <memmove+0x6a>
		s += n;
  800ca6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cb2:	eb 10                	jmp    800cc4 <memmove+0x45>
			*--d = *--s;
  800cb4:	ff 4d f8             	decl   -0x8(%ebp)
  800cb7:	ff 4d fc             	decl   -0x4(%ebp)
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbd:	8a 10                	mov    (%eax),%dl
  800cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cca:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	75 e3                	jne    800cb4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd1:	eb 23                	jmp    800cf6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd6:	8d 50 01             	lea    0x1(%eax),%edx
  800cd9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cdf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ce5:	8a 12                	mov    (%edx),%dl
  800ce7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cef:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	75 dd                	jne    800cd3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d0d:	eb 2a                	jmp    800d39 <memcmp+0x3e>
		if (*s1 != *s2)
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d12:	8a 10                	mov    (%eax),%dl
  800d14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	38 c2                	cmp    %al,%dl
  800d1b:	74 16                	je     800d33 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	0f b6 d0             	movzbl %al,%edx
  800d25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	0f b6 c0             	movzbl %al,%eax
  800d2d:	29 c2                	sub    %eax,%edx
  800d2f:	89 d0                	mov    %edx,%eax
  800d31:	eb 18                	jmp    800d4b <memcmp+0x50>
		s1++, s2++;
  800d33:	ff 45 fc             	incl   -0x4(%ebp)
  800d36:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	75 c9                	jne    800d0f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
  800d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d5e:	eb 15                	jmp    800d75 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	0f b6 d0             	movzbl %al,%edx
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	0f b6 c0             	movzbl %al,%eax
  800d6e:	39 c2                	cmp    %eax,%edx
  800d70:	74 0d                	je     800d7f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d7b:	72 e3                	jb     800d60 <memfind+0x13>
  800d7d:	eb 01                	jmp    800d80 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d7f:	90                   	nop
	return (void *) s;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d83:	c9                   	leave  
  800d84:	c3                   	ret    

00800d85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d92:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d99:	eb 03                	jmp    800d9e <strtol+0x19>
		s++;
  800d9b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3c 20                	cmp    $0x20,%al
  800da5:	74 f4                	je     800d9b <strtol+0x16>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3c 09                	cmp    $0x9,%al
  800dae:	74 eb                	je     800d9b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	3c 2b                	cmp    $0x2b,%al
  800db7:	75 05                	jne    800dbe <strtol+0x39>
		s++;
  800db9:	ff 45 08             	incl   0x8(%ebp)
  800dbc:	eb 13                	jmp    800dd1 <strtol+0x4c>
	else if (*s == '-')
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3c 2d                	cmp    $0x2d,%al
  800dc5:	75 0a                	jne    800dd1 <strtol+0x4c>
		s++, neg = 1;
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd5:	74 06                	je     800ddd <strtol+0x58>
  800dd7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ddb:	75 20                	jne    800dfd <strtol+0x78>
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	3c 30                	cmp    $0x30,%al
  800de4:	75 17                	jne    800dfd <strtol+0x78>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	40                   	inc    %eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	3c 78                	cmp    $0x78,%al
  800dee:	75 0d                	jne    800dfd <strtol+0x78>
		s += 2, base = 16;
  800df0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800df4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dfb:	eb 28                	jmp    800e25 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e01:	75 15                	jne    800e18 <strtol+0x93>
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	3c 30                	cmp    $0x30,%al
  800e0a:	75 0c                	jne    800e18 <strtol+0x93>
		s++, base = 8;
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e16:	eb 0d                	jmp    800e25 <strtol+0xa0>
	else if (base == 0)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	75 07                	jne    800e25 <strtol+0xa0>
		base = 10;
  800e1e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	3c 2f                	cmp    $0x2f,%al
  800e2c:	7e 19                	jle    800e47 <strtol+0xc2>
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	3c 39                	cmp    $0x39,%al
  800e35:	7f 10                	jg     800e47 <strtol+0xc2>
			dig = *s - '0';
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	0f be c0             	movsbl %al,%eax
  800e3f:	83 e8 30             	sub    $0x30,%eax
  800e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e45:	eb 42                	jmp    800e89 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3c 60                	cmp    $0x60,%al
  800e4e:	7e 19                	jle    800e69 <strtol+0xe4>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	3c 7a                	cmp    $0x7a,%al
  800e57:	7f 10                	jg     800e69 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	0f be c0             	movsbl %al,%eax
  800e61:	83 e8 57             	sub    $0x57,%eax
  800e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e67:	eb 20                	jmp    800e89 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 40                	cmp    $0x40,%al
  800e70:	7e 39                	jle    800eab <strtol+0x126>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 5a                	cmp    $0x5a,%al
  800e79:	7f 30                	jg     800eab <strtol+0x126>
			dig = *s - 'A' + 10;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	0f be c0             	movsbl %al,%eax
  800e83:	83 e8 37             	sub    $0x37,%eax
  800e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e8f:	7d 19                	jge    800eaa <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e91:	ff 45 08             	incl   0x8(%ebp)
  800e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea0:	01 d0                	add    %edx,%eax
  800ea2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ea5:	e9 7b ff ff ff       	jmp    800e25 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eaa:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eaf:	74 08                	je     800eb9 <strtol+0x134>
		*endptr = (char *) s;
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ebd:	74 07                	je     800ec6 <strtol+0x141>
  800ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec2:	f7 d8                	neg    %eax
  800ec4:	eb 03                	jmp    800ec9 <strtol+0x144>
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <ltostr>:

void
ltostr(long value, char *str)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ed1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ed8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee3:	79 13                	jns    800ef8 <ltostr+0x2d>
	{
		neg = 1;
  800ee5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ef2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ef5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f00:	99                   	cltd   
  800f01:	f7 f9                	idiv   %ecx
  800f03:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	8d 50 01             	lea    0x1(%eax),%edx
  800f0c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0f:	89 c2                	mov    %eax,%edx
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	01 d0                	add    %edx,%eax
  800f16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f19:	83 c2 30             	add    $0x30,%edx
  800f1c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f21:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f26:	f7 e9                	imul   %ecx
  800f28:	c1 fa 02             	sar    $0x2,%edx
  800f2b:	89 c8                	mov    %ecx,%eax
  800f2d:	c1 f8 1f             	sar    $0x1f,%eax
  800f30:	29 c2                	sub    %eax,%edx
  800f32:	89 d0                	mov    %edx,%eax
  800f34:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3b:	75 bb                	jne    800ef8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f47:	48                   	dec    %eax
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f4f:	74 3d                	je     800f8e <ltostr+0xc3>
		start = 1 ;
  800f51:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f58:	eb 34                	jmp    800f8e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c2                	add    %eax,%edx
  800f6f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	01 c8                	add    %ecx,%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	01 c2                	add    %eax,%edx
  800f83:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f86:	88 02                	mov    %al,(%edx)
		start++ ;
  800f88:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f8b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f94:	7c c4                	jl     800f5a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f96:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	01 d0                	add    %edx,%eax
  800f9e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 73 fa ff ff       	call   800a25 <strlen>
  800fb2:	83 c4 04             	add    $0x4,%esp
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 65 fa ff ff       	call   800a25 <strlen>
  800fc0:	83 c4 04             	add    $0x4,%esp
  800fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd4:	eb 17                	jmp    800fed <strcconcat+0x49>
		final[s] = str1[s] ;
  800fd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	01 c2                	add    %eax,%edx
  800fde:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	01 c8                	add    %ecx,%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fea:	ff 45 fc             	incl   -0x4(%ebp)
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff3:	7c e1                	jl     800fd6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ff5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ffc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801003:	eb 1f                	jmp    801024 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801008:	8d 50 01             	lea    0x1(%eax),%edx
  80100b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80100e:	89 c2                	mov    %eax,%edx
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	01 c2                	add    %eax,%edx
  801015:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	01 c8                	add    %ecx,%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801021:	ff 45 f8             	incl   -0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102a:	7c d9                	jl     801005 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	01 d0                	add    %edx,%eax
  801034:	c6 00 00             	movb   $0x0,(%eax)
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	8b 00                	mov    (%eax),%eax
  80104b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80105d:	eb 0c                	jmp    80106b <strsplit+0x31>
			*string++ = 0;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8d 50 01             	lea    0x1(%eax),%edx
  801065:	89 55 08             	mov    %edx,0x8(%ebp)
  801068:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	84 c0                	test   %al,%al
  801072:	74 18                	je     80108c <strsplit+0x52>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	50                   	push   %eax
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	e8 32 fb ff ff       	call   800bb7 <strchr>
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	75 d3                	jne    80105f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	84 c0                	test   %al,%al
  801093:	74 5a                	je     8010ef <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	8b 00                	mov    (%eax),%eax
  80109a:	83 f8 0f             	cmp    $0xf,%eax
  80109d:	75 07                	jne    8010a6 <strsplit+0x6c>
		{
			return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a4:	eb 66                	jmp    80110c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a9:	8b 00                	mov    (%eax),%eax
  8010ab:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ae:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b1:	89 0a                	mov    %ecx,(%edx)
  8010b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c4:	eb 03                	jmp    8010c9 <strsplit+0x8f>
			string++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	84 c0                	test   %al,%al
  8010d0:	74 8b                	je     80105d <strsplit+0x23>
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f be c0             	movsbl %al,%eax
  8010da:	50                   	push   %eax
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	e8 d4 fa ff ff       	call   800bb7 <strchr>
  8010e3:	83 c4 08             	add    $0x8,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	74 dc                	je     8010c6 <strsplit+0x8c>
			string++;
	}
  8010ea:	e9 6e ff ff ff       	jmp    80105d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010ef:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	8b 00                	mov    (%eax),%eax
  8010f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801107:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	68 e8 40 80 00       	push   $0x8040e8
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 0a 41 80 00       	push   $0x80410a
  801126:	e8 b1 26 00 00       	call   8037dc <_panic>

0080112b <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 08             	pushl  0x8(%ebp)
  801137:	e8 8d 0a 00 00       	call   801bc9 <sys_sbrk>
  80113c:	83 c4 10             	add    $0x10,%esp
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114b:	75 0a                	jne    801157 <malloc+0x16>
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	e9 07 02 00 00       	jmp    80135e <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801157:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	48                   	dec    %eax
  801167:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80116a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80116d:	ba 00 00 00 00       	mov    $0x0,%edx
  801172:	f7 75 dc             	divl   -0x24(%ebp)
  801175:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801178:	29 d0                	sub    %edx,%eax
  80117a:	c1 e8 0c             	shr    $0xc,%eax
  80117d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801180:	a1 20 50 80 00       	mov    0x805020,%eax
  801185:	8b 40 78             	mov    0x78(%eax),%eax
  801188:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80118d:	29 c2                	sub    %eax,%edx
  80118f:	89 d0                	mov    %edx,%eax
  801191:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801194:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119c:	c1 e8 0c             	shr    $0xc,%eax
  80119f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8011a9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8011b0:	77 42                	ja     8011f4 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8011b2:	e8 96 08 00 00       	call   801a4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 d6 0d 00 00       	call   801f9c <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 a8 08 00 00       	call   801a7e <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 6f 12 00 00       	call   802458 <alloc_block_BF>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	e9 67 01 00 00       	jmp    80135b <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8011f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011f7:	48                   	dec    %eax
  8011f8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8011fb:	0f 86 53 01 00 00    	jbe    801354 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801201:	a1 20 50 80 00       	mov    0x805020,%eax
  801206:	8b 40 78             	mov    0x78(%eax),%eax
  801209:	05 00 10 00 00       	add    $0x1000,%eax
  80120e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801211:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801218:	e9 de 00 00 00       	jmp    8012fb <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80121d:	a1 20 50 80 00       	mov    0x805020,%eax
  801222:	8b 40 78             	mov    0x78(%eax),%eax
  801225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801228:	29 c2                	sub    %eax,%edx
  80122a:	89 d0                	mov    %edx,%eax
  80122c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801231:	c1 e8 0c             	shr    $0xc,%eax
  801234:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80123b:	85 c0                	test   %eax,%eax
  80123d:	0f 85 ab 00 00 00    	jne    8012ee <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	05 00 10 00 00       	add    $0x1000,%eax
  80124b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80124e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801255:	eb 47                	jmp    80129e <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801257:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80125e:	76 0a                	jbe    80126a <malloc+0x129>
  801260:	b8 00 00 00 00       	mov    $0x0,%eax
  801265:	e9 f4 00 00 00       	jmp    80135e <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80126a:	a1 20 50 80 00       	mov    0x805020,%eax
  80126f:	8b 40 78             	mov    0x78(%eax),%eax
  801272:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801275:	29 c2                	sub    %eax,%edx
  801277:	89 d0                	mov    %edx,%eax
  801279:	2d 00 10 00 00       	sub    $0x1000,%eax
  80127e:	c1 e8 0c             	shr    $0xc,%eax
  801281:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	74 08                	je     801294 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80128c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80128f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801292:	eb 5a                	jmp    8012ee <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801294:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80129b:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80129e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012a1:	48                   	dec    %eax
  8012a2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8012a5:	77 b0                	ja     801257 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8012a7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8012ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8012b5:	eb 2f                	jmp    8012e6 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8012b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ba:	c1 e0 0c             	shl    $0xc,%eax
  8012bd:	89 c2                	mov    %eax,%edx
  8012bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c2:	01 c2                	add    %eax,%edx
  8012c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8012c9:	8b 40 78             	mov    0x78(%eax),%eax
  8012cc:	29 c2                	sub    %eax,%edx
  8012ce:	89 d0                	mov    %edx,%eax
  8012d0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012d5:	c1 e8 0c             	shr    $0xc,%eax
  8012d8:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8012df:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8012e3:	ff 45 e0             	incl   -0x20(%ebp)
  8012e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8012ec:	72 c9                	jb     8012b7 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8012ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f2:	75 16                	jne    80130a <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012f4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012fb:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801302:	0f 86 15 ff ff ff    	jbe    80121d <malloc+0xdc>
  801308:	eb 01                	jmp    80130b <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80130a:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80130b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130f:	75 07                	jne    801318 <malloc+0x1d7>
  801311:	b8 00 00 00 00       	mov    $0x0,%eax
  801316:	eb 46                	jmp    80135e <malloc+0x21d>
		ptr = (void*)i;
  801318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80131e:	a1 20 50 80 00       	mov    0x805020,%eax
  801323:	8b 40 78             	mov    0x78(%eax),%eax
  801326:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801329:	29 c2                	sub    %eax,%edx
  80132b:	89 d0                	mov    %edx,%eax
  80132d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801332:	c1 e8 0c             	shr    $0xc,%eax
  801335:	89 c2                	mov    %eax,%edx
  801337:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80133a:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	ff 75 f0             	pushl  -0x10(%ebp)
  80134a:	e8 b1 08 00 00       	call   801c00 <sys_allocate_user_mem>
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	eb 07                	jmp    80135b <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
  801359:	eb 03                	jmp    80135e <malloc+0x21d>
	}
	return ptr;
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801366:	a1 20 50 80 00       	mov    0x805020,%eax
  80136b:	8b 40 78             	mov    0x78(%eax),%eax
  80136e:	05 00 10 00 00       	add    $0x1000,%eax
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801376:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80137d:	a1 20 50 80 00       	mov    0x805020,%eax
  801382:	8b 50 78             	mov    0x78(%eax),%edx
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	39 c2                	cmp    %eax,%edx
  80138a:	76 24                	jbe    8013b0 <free+0x50>
		size = get_block_size(va);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 85 08 00 00       	call   801c1c <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 b8 1a 00 00       	call   802e60 <free_block>
  8013a8:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8013ab:	e9 ac 00 00 00       	jmp    80145c <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	0f 82 89 00 00 00    	jb     801445 <free+0xe5>
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8013c4:	77 7f                	ja     801445 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8013c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8013ce:	8b 40 78             	mov    0x78(%eax),%eax
  8013d1:	29 c2                	sub    %eax,%edx
  8013d3:	89 d0                	mov    %edx,%eax
  8013d5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013da:	c1 e8 0c             	shr    $0xc,%eax
  8013dd:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8013e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8013e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ea:	c1 e0 0c             	shl    $0xc,%eax
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f7:	eb 2f                	jmp    801428 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fc:	c1 e0 0c             	shl    $0xc,%eax
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	01 c2                	add    %eax,%edx
  801406:	a1 20 50 80 00       	mov    0x805020,%eax
  80140b:	8b 40 78             	mov    0x78(%eax),%eax
  80140e:	29 c2                	sub    %eax,%edx
  801410:	89 d0                	mov    %edx,%eax
  801412:	2d 00 10 00 00       	sub    $0x1000,%eax
  801417:	c1 e8 0c             	shr    $0xc,%eax
  80141a:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801421:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801425:	ff 45 f4             	incl   -0xc(%ebp)
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80142e:	72 c9                	jb     8013f9 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	ff 75 ec             	pushl  -0x14(%ebp)
  801439:	50                   	push   %eax
  80143a:	e8 a5 07 00 00       	call   801be4 <sys_free_user_mem>
  80143f:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801442:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801443:	eb 17                	jmp    80145c <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 18 41 80 00       	push   $0x804118
  80144d:	68 84 00 00 00       	push   $0x84
  801452:	68 42 41 80 00       	push   $0x804142
  801457:	e8 80 23 00 00       	call   8037dc <_panic>
	}
}
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
  80146e:	75 07                	jne    801477 <smalloc+0x19>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 64                	jmp    8014db <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801484:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	39 d0                	cmp    %edx,%eax
  80148c:	73 02                	jae    801490 <smalloc+0x32>
  80148e:	89 d0                	mov    %edx,%eax
  801490:	83 ec 0c             	sub    $0xc,%esp
  801493:	50                   	push   %eax
  801494:	e8 a8 fc ff ff       	call   801141 <malloc>
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80149f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a3:	75 07                	jne    8014ac <smalloc+0x4e>
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 2f                	jmp    8014db <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014ac:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	e8 2c 03 00 00       	call   8017eb <sys_createSharedObject>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014c9:	74 06                	je     8014d1 <smalloc+0x73>
  8014cb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014cf:	75 07                	jne    8014d8 <smalloc+0x7a>
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	eb 03                	jmp    8014db <smalloc+0x7d>
	 return ptr;
  8014d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 24 03 00 00       	call   801815 <sys_getSizeOfSharedObject>
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014f7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014fb:	75 07                	jne    801504 <sget+0x27>
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	eb 5c                	jmp    801560 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801507:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801511:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	39 d0                	cmp    %edx,%eax
  801519:	7d 02                	jge    80151d <sget+0x40>
  80151b:	89 d0                	mov    %edx,%eax
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	50                   	push   %eax
  801521:	e8 1b fc ff ff       	call   801141 <malloc>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80152c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801530:	75 07                	jne    801539 <sget+0x5c>
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
  801537:	eb 27                	jmp    801560 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	ff 75 e8             	pushl  -0x18(%ebp)
  80153f:	ff 75 0c             	pushl  0xc(%ebp)
  801542:	ff 75 08             	pushl  0x8(%ebp)
  801545:	e8 e8 02 00 00       	call   801832 <sys_getSharedObject>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801550:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801554:	75 07                	jne    80155d <sget+0x80>
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	eb 03                	jmp    801560 <sget+0x83>
	return ptr;
  80155d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	68 50 41 80 00       	push   $0x804150
  801570:	68 c1 00 00 00       	push   $0xc1
  801575:	68 42 41 80 00       	push   $0x804142
  80157a:	e8 5d 22 00 00       	call   8037dc <_panic>

0080157f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	68 74 41 80 00       	push   $0x804174
  80158d:	68 d8 00 00 00       	push   $0xd8
  801592:	68 42 41 80 00       	push   $0x804142
  801597:	e8 40 22 00 00       	call   8037dc <_panic>

0080159c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	68 9a 41 80 00       	push   $0x80419a
  8015aa:	68 e4 00 00 00       	push   $0xe4
  8015af:	68 42 41 80 00       	push   $0x804142
  8015b4:	e8 23 22 00 00       	call   8037dc <_panic>

008015b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 9a 41 80 00       	push   $0x80419a
  8015c7:	68 e9 00 00 00       	push   $0xe9
  8015cc:	68 42 41 80 00       	push   $0x804142
  8015d1:	e8 06 22 00 00       	call   8037dc <_panic>

008015d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	68 9a 41 80 00       	push   $0x80419a
  8015e4:	68 ee 00 00 00       	push   $0xee
  8015e9:	68 42 41 80 00       	push   $0x804142
  8015ee:	e8 e9 21 00 00       	call   8037dc <_panic>

008015f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	57                   	push   %edi
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801605:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801608:	8b 7d 18             	mov    0x18(%ebp),%edi
  80160b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160e:	cd 30                	int    $0x30
  801610:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801613:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	5b                   	pop    %ebx
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80162a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	52                   	push   %edx
  801636:	ff 75 0c             	pushl  0xc(%ebp)
  801639:	50                   	push   %eax
  80163a:	6a 00                	push   $0x0
  80163c:	e8 b2 ff ff ff       	call   8015f3 <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
}
  801644:	90                   	nop
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_cgetc>:

int
sys_cgetc(void)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 02                	push   $0x2
  801656:	e8 98 ff ff ff       	call   8015f3 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 03                	push   $0x3
  80166f:	e8 7f ff ff ff       	call   8015f3 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	90                   	nop
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 04                	push   $0x4
  801689:	e8 65 ff ff ff       	call   8015f3 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	52                   	push   %edx
  8016a4:	50                   	push   %eax
  8016a5:	6a 08                	push   $0x8
  8016a7:	e8 47 ff ff ff       	call   8015f3 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	51                   	push   %ecx
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 09                	push   $0x9
  8016cc:	e8 22 ff ff ff       	call   8015f3 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d7:	5b                   	pop    %ebx
  8016d8:	5e                   	pop    %esi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 0a                	push   $0xa
  8016ee:	e8 00 ff ff ff       	call   8015f3 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	6a 0b                	push   $0xb
  801709:	e8 e5 fe ff ff       	call   8015f3 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 0c                	push   $0xc
  801722:	e8 cc fe ff ff       	call   8015f3 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 0d                	push   $0xd
  80173b:	e8 b3 fe ff ff       	call   8015f3 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 0e                	push   $0xe
  801754:	e8 9a fe ff ff       	call   8015f3 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 0f                	push   $0xf
  80176d:	e8 81 fe ff ff       	call   8015f3 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	6a 10                	push   $0x10
  801787:	e8 67 fe ff ff       	call   8015f3 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 11                	push   $0x11
  8017a0:	e8 4e fe ff ff       	call   8015f3 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	90                   	nop
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_cputc>:

void
sys_cputc(const char c)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017b7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	50                   	push   %eax
  8017c4:	6a 01                	push   $0x1
  8017c6:	e8 28 fe ff ff       	call   8015f3 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 14                	push   $0x14
  8017e0:	e8 0e fe ff ff       	call   8015f3 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	51                   	push   %ecx
  801804:	52                   	push   %edx
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	6a 15                	push   $0x15
  80180b:	e8 e3 fd ff ff       	call   8015f3 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	52                   	push   %edx
  801825:	50                   	push   %eax
  801826:	6a 16                	push   $0x16
  801828:	e8 c6 fd ff ff       	call   8015f3 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801835:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	51                   	push   %ecx
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	6a 17                	push   $0x17
  801847:	e8 a7 fd ff ff       	call   8015f3 <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 18                	push   $0x18
  801864:	e8 8a fd ff ff       	call   8015f3 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	ff 75 14             	pushl  0x14(%ebp)
  801879:	ff 75 10             	pushl  0x10(%ebp)
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	50                   	push   %eax
  801880:	6a 19                	push   $0x19
  801882:	e8 6c fd ff ff       	call   8015f3 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	50                   	push   %eax
  80189b:	6a 1a                	push   $0x1a
  80189d:	e8 51 fd ff ff       	call   8015f3 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	50                   	push   %eax
  8018b7:	6a 1b                	push   $0x1b
  8018b9:	e8 35 fd ff ff       	call   8015f3 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 05                	push   $0x5
  8018d2:	e8 1c fd ff ff       	call   8015f3 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 06                	push   $0x6
  8018eb:	e8 03 fd ff ff       	call   8015f3 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 07                	push   $0x7
  801904:	e8 ea fc ff ff       	call   8015f3 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_exit_env>:


void sys_exit_env(void)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 1c                	push   $0x1c
  80191d:	e8 d1 fc ff ff       	call   8015f3 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80192e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801931:	8d 50 04             	lea    0x4(%eax),%edx
  801934:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 1d                	push   $0x1d
  801941:	e8 ad fc ff ff       	call   8015f3 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return result;
  801949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801952:	89 01                	mov    %eax,(%ecx)
  801954:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	c9                   	leave  
  80195b:	c2 04 00             	ret    $0x4

0080195e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 13                	push   $0x13
  801970:	e8 7e fc ff ff       	call   8015f3 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_rcr2>:
uint32 sys_rcr2()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 1e                	push   $0x1e
  80198a:	e8 64 fc ff ff       	call   8015f3 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	50                   	push   %eax
  8019ad:	6a 1f                	push   $0x1f
  8019af:	e8 3f fc ff ff       	call   8015f3 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b7:	90                   	nop
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <rsttst>:
void rsttst()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 21                	push   $0x21
  8019c9:	e8 25 fc ff ff       	call   8015f3 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 14             	mov    0x14(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	6a 20                	push   $0x20
  8019f4:	e8 fa fb ff ff       	call   8015f3 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fc:	90                   	nop
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <chktst>:
void chktst(uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	6a 22                	push   $0x22
  801a0f:	e8 df fb ff ff       	call   8015f3 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
	return ;
  801a17:	90                   	nop
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <inctst>:

void inctst()
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 23                	push   $0x23
  801a29:	e8 c5 fb ff ff       	call   8015f3 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a31:	90                   	nop
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <gettst>:
uint32 gettst()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 24                	push   $0x24
  801a43:	e8 ab fb ff ff       	call   8015f3 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 25                	push   $0x25
  801a5f:	e8 8f fb ff ff       	call   8015f3 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
  801a67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a6e:	75 07                	jne    801a77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a70:	b8 01 00 00 00       	mov    $0x1,%eax
  801a75:	eb 05                	jmp    801a7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 25                	push   $0x25
  801a90:	e8 5e fb ff ff       	call   8015f3 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
  801a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a9f:	75 07                	jne    801aa8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aa1:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa6:	eb 05                	jmp    801aad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 25                	push   $0x25
  801ac1:	e8 2d fb ff ff       	call   8015f3 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
  801ac9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801acc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ad0:	75 07                	jne    801ad9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	eb 05                	jmp    801ade <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 25                	push   $0x25
  801af2:	e8 fc fa ff ff       	call   8015f3 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
  801afa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801afd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b01:	75 07                	jne    801b0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	eb 05                	jmp    801b0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 26                	push   $0x26
  801b21:	e8 cd fa ff ff       	call   8015f3 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	53                   	push   %ebx
  801b3f:	51                   	push   %ecx
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 27                	push   $0x27
  801b44:	e8 aa fa ff ff       	call   8015f3 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 28                	push   $0x28
  801b64:	e8 8a fa ff ff       	call   8015f3 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	51                   	push   %ecx
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	52                   	push   %edx
  801b81:	50                   	push   %eax
  801b82:	6a 29                	push   $0x29
  801b84:	e8 6a fa ff ff       	call   8015f3 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	6a 12                	push   $0x12
  801ba0:	e8 4e fa ff ff       	call   8015f3 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 2a                	push   $0x2a
  801bbe:	e8 30 fa ff ff       	call   8015f3 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return;
  801bc6:	90                   	nop
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	50                   	push   %eax
  801bd8:	6a 2b                	push   $0x2b
  801bda:	e8 14 fa ff ff       	call   8015f3 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 0c             	pushl  0xc(%ebp)
  801bf0:	ff 75 08             	pushl  0x8(%ebp)
  801bf3:	6a 2c                	push   $0x2c
  801bf5:	e8 f9 f9 ff ff       	call   8015f3 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 2d                	push   $0x2d
  801c11:	e8 dd f9 ff ff       	call   8015f3 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	83 e8 04             	sub    $0x4,%eax
  801c28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c2e:	8b 00                	mov    (%eax),%eax
  801c30:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	83 e8 04             	sub    $0x4,%eax
  801c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c47:	8b 00                	mov    (%eax),%eax
  801c49:	83 e0 01             	and    $0x1,%eax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	0f 94 c0             	sete   %al
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	83 f8 02             	cmp    $0x2,%eax
  801c66:	74 2b                	je     801c93 <alloc_block+0x40>
  801c68:	83 f8 02             	cmp    $0x2,%eax
  801c6b:	7f 07                	jg     801c74 <alloc_block+0x21>
  801c6d:	83 f8 01             	cmp    $0x1,%eax
  801c70:	74 0e                	je     801c80 <alloc_block+0x2d>
  801c72:	eb 58                	jmp    801ccc <alloc_block+0x79>
  801c74:	83 f8 03             	cmp    $0x3,%eax
  801c77:	74 2d                	je     801ca6 <alloc_block+0x53>
  801c79:	83 f8 04             	cmp    $0x4,%eax
  801c7c:	74 3b                	je     801cb9 <alloc_block+0x66>
  801c7e:	eb 4c                	jmp    801ccc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	ff 75 08             	pushl  0x8(%ebp)
  801c86:	e8 11 03 00 00       	call   801f9c <alloc_block_FF>
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c91:	eb 4a                	jmp    801cdd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c93:	83 ec 0c             	sub    $0xc,%esp
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	e8 fa 19 00 00       	call   803698 <alloc_block_NF>
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ca4:	eb 37                	jmp    801cdd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	ff 75 08             	pushl  0x8(%ebp)
  801cac:	e8 a7 07 00 00       	call   802458 <alloc_block_BF>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cb7:	eb 24                	jmp    801cdd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	e8 b7 19 00 00       	call   80367b <alloc_block_WF>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cca:	eb 11                	jmp    801cdd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	68 ac 41 80 00       	push   $0x8041ac
  801cd4:	e8 b8 e6 ff ff       	call   800391 <cprintf>
  801cd9:	83 c4 10             	add    $0x10,%esp
		break;
  801cdc:	90                   	nop
	}
	return va;
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	53                   	push   %ebx
  801ce6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	68 cc 41 80 00       	push   $0x8041cc
  801cf1:	e8 9b e6 ff ff       	call   800391 <cprintf>
  801cf6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	68 f7 41 80 00       	push   $0x8041f7
  801d01:	e8 8b e6 ff ff       	call   800391 <cprintf>
  801d06:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0f:	eb 37                	jmp    801d48 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 75 f4             	pushl  -0xc(%ebp)
  801d17:	e8 19 ff ff ff       	call   801c35 <is_free_block>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	0f be d8             	movsbl %al,%ebx
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 f4             	pushl  -0xc(%ebp)
  801d28:	e8 ef fe ff ff       	call   801c1c <get_block_size>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	53                   	push   %ebx
  801d34:	50                   	push   %eax
  801d35:	68 0f 42 80 00       	push   $0x80420f
  801d3a:	e8 52 e6 ff ff       	call   800391 <cprintf>
  801d3f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4c:	74 07                	je     801d55 <print_blocks_list+0x73>
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 00                	mov    (%eax),%eax
  801d53:	eb 05                	jmp    801d5a <print_blocks_list+0x78>
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	89 45 10             	mov    %eax,0x10(%ebp)
  801d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d60:	85 c0                	test   %eax,%eax
  801d62:	75 ad                	jne    801d11 <print_blocks_list+0x2f>
  801d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d68:	75 a7                	jne    801d11 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	68 cc 41 80 00       	push   $0x8041cc
  801d72:	e8 1a e6 ff ff       	call   800391 <cprintf>
  801d77:	83 c4 10             	add    $0x10,%esp

}
  801d7a:	90                   	nop
  801d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	83 e0 01             	and    $0x1,%eax
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	74 03                	je     801d93 <initialize_dynamic_allocator+0x13>
  801d90:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d97:	0f 84 c7 01 00 00    	je     801f64 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d9d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801da4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801da7:	8b 55 08             	mov    0x8(%ebp),%edx
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	01 d0                	add    %edx,%eax
  801daf:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801db4:	0f 87 ad 01 00 00    	ja     801f67 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	0f 89 a5 01 00 00    	jns    801f6a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	83 e8 04             	sub    $0x4,%eax
  801dd0:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ddc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de4:	e9 87 00 00 00       	jmp    801e70 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ded:	75 14                	jne    801e03 <initialize_dynamic_allocator+0x83>
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 27 42 80 00       	push   $0x804227
  801df7:	6a 79                	push   $0x79
  801df9:	68 45 42 80 00       	push   $0x804245
  801dfe:	e8 d9 19 00 00       	call   8037dc <_panic>
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	74 10                	je     801e1c <initialize_dynamic_allocator+0x9c>
  801e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0f:	8b 00                	mov    (%eax),%eax
  801e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e14:	8b 52 04             	mov    0x4(%edx),%edx
  801e17:	89 50 04             	mov    %edx,0x4(%eax)
  801e1a:	eb 0b                	jmp    801e27 <initialize_dynamic_allocator+0xa7>
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 40 04             	mov    0x4(%eax),%eax
  801e22:	a3 30 50 80 00       	mov    %eax,0x805030
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 40 04             	mov    0x4(%eax),%eax
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 0f                	je     801e40 <initialize_dynamic_allocator+0xc0>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 40 04             	mov    0x4(%eax),%eax
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	8b 12                	mov    (%edx),%edx
  801e3c:	89 10                	mov    %edx,(%eax)
  801e3e:	eb 0a                	jmp    801e4a <initialize_dynamic_allocator+0xca>
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 00                	mov    (%eax),%eax
  801e45:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e5d:	a1 38 50 80 00       	mov    0x805038,%eax
  801e62:	48                   	dec    %eax
  801e63:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e68:	a1 34 50 80 00       	mov    0x805034,%eax
  801e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e74:	74 07                	je     801e7d <initialize_dynamic_allocator+0xfd>
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 00                	mov    (%eax),%eax
  801e7b:	eb 05                	jmp    801e82 <initialize_dynamic_allocator+0x102>
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e82:	a3 34 50 80 00       	mov    %eax,0x805034
  801e87:	a1 34 50 80 00       	mov    0x805034,%eax
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	0f 85 55 ff ff ff    	jne    801de9 <initialize_dynamic_allocator+0x69>
  801e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e98:	0f 85 4b ff ff ff    	jne    801de9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ead:	a1 44 50 80 00       	mov    0x805044,%eax
  801eb2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801eb7:	a1 40 50 80 00       	mov    0x805040,%eax
  801ebc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	83 c0 08             	add    $0x8,%eax
  801ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	83 c0 04             	add    $0x4,%eax
  801ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed4:	83 ea 08             	sub    $0x8,%edx
  801ed7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	83 e8 08             	sub    $0x8,%eax
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	83 ea 08             	sub    $0x8,%edx
  801eea:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801eff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f03:	75 17                	jne    801f1c <initialize_dynamic_allocator+0x19c>
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	68 60 42 80 00       	push   $0x804260
  801f0d:	68 90 00 00 00       	push   $0x90
  801f12:	68 45 42 80 00       	push   $0x804245
  801f17:	e8 c0 18 00 00       	call   8037dc <_panic>
  801f1c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f25:	89 10                	mov    %edx,(%eax)
  801f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	74 0d                	je     801f3d <initialize_dynamic_allocator+0x1bd>
  801f30:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f38:	89 50 04             	mov    %edx,0x4(%eax)
  801f3b:	eb 08                	jmp    801f45 <initialize_dynamic_allocator+0x1c5>
  801f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f40:	a3 30 50 80 00       	mov    %eax,0x805030
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f57:	a1 38 50 80 00       	mov    0x805038,%eax
  801f5c:	40                   	inc    %eax
  801f5d:	a3 38 50 80 00       	mov    %eax,0x805038
  801f62:	eb 07                	jmp    801f6b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f64:	90                   	nop
  801f65:	eb 04                	jmp    801f6b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f67:	90                   	nop
  801f68:	eb 01                	jmp    801f6b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f6a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f70:	8b 45 10             	mov    0x10(%ebp),%eax
  801f73:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	83 e8 04             	sub    $0x4,%eax
  801f87:	8b 00                	mov    (%eax),%eax
  801f89:	83 e0 fe             	and    $0xfffffffe,%eax
  801f8c:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	01 c2                	add    %eax,%edx
  801f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f97:	89 02                	mov    %eax,(%edx)
}
  801f99:	90                   	nop
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	83 e0 01             	and    $0x1,%eax
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	74 03                	je     801faf <alloc_block_FF+0x13>
  801fac:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801faf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fb3:	77 07                	ja     801fbc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fb5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fbc:	a1 24 50 80 00       	mov    0x805024,%eax
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	75 73                	jne    802038 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	83 c0 10             	add    $0x10,%eax
  801fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801fce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdb:	01 d0                	add    %edx,%eax
  801fdd:	48                   	dec    %eax
  801fde:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe9:	f7 75 ec             	divl   -0x14(%ebp)
  801fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fef:	29 d0                	sub    %edx,%eax
  801ff1:	c1 e8 0c             	shr    $0xc,%eax
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	50                   	push   %eax
  801ff8:	e8 2e f1 ff ff       	call   80112b <sbrk>
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	6a 00                	push   $0x0
  802008:	e8 1e f1 ff ff       	call   80112b <sbrk>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802013:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802016:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802019:	83 ec 08             	sub    $0x8,%esp
  80201c:	50                   	push   %eax
  80201d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802020:	e8 5b fd ff ff       	call   801d80 <initialize_dynamic_allocator>
  802025:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	68 83 42 80 00       	push   $0x804283
  802030:	e8 5c e3 ff ff       	call   800391 <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802038:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203c:	75 0a                	jne    802048 <alloc_block_FF+0xac>
	        return NULL;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	e9 0e 04 00 00       	jmp    802456 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80204f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802057:	e9 f3 02 00 00       	jmp    80234f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	ff 75 bc             	pushl  -0x44(%ebp)
  802068:	e8 af fb ff ff       	call   801c1c <get_block_size>
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	83 c0 08             	add    $0x8,%eax
  802079:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80207c:	0f 87 c5 02 00 00    	ja     802347 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	83 c0 18             	add    $0x18,%eax
  802088:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80208b:	0f 87 19 02 00 00    	ja     8022aa <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802091:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802094:	2b 45 08             	sub    0x8(%ebp),%eax
  802097:	83 e8 08             	sub    $0x8,%eax
  80209a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8d 50 08             	lea    0x8(%eax),%edx
  8020a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	83 c0 08             	add    $0x8,%eax
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	6a 01                	push   $0x1
  8020b6:	50                   	push   %eax
  8020b7:	ff 75 bc             	pushl  -0x44(%ebp)
  8020ba:	e8 ae fe ff ff       	call   801f6d <set_block_data>
  8020bf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 40 04             	mov    0x4(%eax),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 68                	jne    802134 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020cc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020d0:	75 17                	jne    8020e9 <alloc_block_FF+0x14d>
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 60 42 80 00       	push   $0x804260
  8020da:	68 d7 00 00 00       	push   $0xd7
  8020df:	68 45 42 80 00       	push   $0x804245
  8020e4:	e8 f3 16 00 00       	call   8037dc <_panic>
  8020e9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020f7:	8b 00                	mov    (%eax),%eax
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	74 0d                	je     80210a <alloc_block_FF+0x16e>
  8020fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802102:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802105:	89 50 04             	mov    %edx,0x4(%eax)
  802108:	eb 08                	jmp    802112 <alloc_block_FF+0x176>
  80210a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80210d:	a3 30 50 80 00       	mov    %eax,0x805030
  802112:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802115:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80211a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802124:	a1 38 50 80 00       	mov    0x805038,%eax
  802129:	40                   	inc    %eax
  80212a:	a3 38 50 80 00       	mov    %eax,0x805038
  80212f:	e9 dc 00 00 00       	jmp    802210 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 00                	mov    (%eax),%eax
  802139:	85 c0                	test   %eax,%eax
  80213b:	75 65                	jne    8021a2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80213d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802141:	75 17                	jne    80215a <alloc_block_FF+0x1be>
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	68 94 42 80 00       	push   $0x804294
  80214b:	68 db 00 00 00       	push   $0xdb
  802150:	68 45 42 80 00       	push   $0x804245
  802155:	e8 82 16 00 00       	call   8037dc <_panic>
  80215a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802160:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802163:	89 50 04             	mov    %edx,0x4(%eax)
  802166:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802169:	8b 40 04             	mov    0x4(%eax),%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	74 0c                	je     80217c <alloc_block_FF+0x1e0>
  802170:	a1 30 50 80 00       	mov    0x805030,%eax
  802175:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802178:	89 10                	mov    %edx,(%eax)
  80217a:	eb 08                	jmp    802184 <alloc_block_FF+0x1e8>
  80217c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802184:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802187:	a3 30 50 80 00       	mov    %eax,0x805030
  80218c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802195:	a1 38 50 80 00       	mov    0x805038,%eax
  80219a:	40                   	inc    %eax
  80219b:	a3 38 50 80 00       	mov    %eax,0x805038
  8021a0:	eb 6e                	jmp    802210 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a6:	74 06                	je     8021ae <alloc_block_FF+0x212>
  8021a8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021ac:	75 17                	jne    8021c5 <alloc_block_FF+0x229>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 b8 42 80 00       	push   $0x8042b8
  8021b6:	68 df 00 00 00       	push   $0xdf
  8021bb:	68 45 42 80 00       	push   $0x804245
  8021c0:	e8 17 16 00 00       	call   8037dc <_panic>
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	8b 10                	mov    (%eax),%edx
  8021ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021cd:	89 10                	mov    %edx,(%eax)
  8021cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	74 0b                	je     8021e3 <alloc_block_FF+0x247>
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021e0:	89 50 04             	mov    %edx,0x4(%eax)
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f1:	89 50 04             	mov    %edx,0x4(%eax)
  8021f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 08                	jne    802205 <alloc_block_FF+0x269>
  8021fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802200:	a3 30 50 80 00       	mov    %eax,0x805030
  802205:	a1 38 50 80 00       	mov    0x805038,%eax
  80220a:	40                   	inc    %eax
  80220b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802214:	75 17                	jne    80222d <alloc_block_FF+0x291>
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 27 42 80 00       	push   $0x804227
  80221e:	68 e1 00 00 00       	push   $0xe1
  802223:	68 45 42 80 00       	push   $0x804245
  802228:	e8 af 15 00 00       	call   8037dc <_panic>
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 10                	je     802246 <alloc_block_FF+0x2aa>
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 00                	mov    (%eax),%eax
  80223b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223e:	8b 52 04             	mov    0x4(%edx),%edx
  802241:	89 50 04             	mov    %edx,0x4(%eax)
  802244:	eb 0b                	jmp    802251 <alloc_block_FF+0x2b5>
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 40 04             	mov    0x4(%eax),%eax
  80224c:	a3 30 50 80 00       	mov    %eax,0x805030
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 40 04             	mov    0x4(%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 0f                	je     80226a <alloc_block_FF+0x2ce>
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 04             	mov    0x4(%eax),%eax
  802261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802264:	8b 12                	mov    (%edx),%edx
  802266:	89 10                	mov    %edx,(%eax)
  802268:	eb 0a                	jmp    802274 <alloc_block_FF+0x2d8>
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802287:	a1 38 50 80 00       	mov    0x805038,%eax
  80228c:	48                   	dec    %eax
  80228d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	6a 00                	push   $0x0
  802297:	ff 75 b4             	pushl  -0x4c(%ebp)
  80229a:	ff 75 b0             	pushl  -0x50(%ebp)
  80229d:	e8 cb fc ff ff       	call   801f6d <set_block_data>
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	e9 95 00 00 00       	jmp    80233f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	6a 01                	push   $0x1
  8022af:	ff 75 b8             	pushl  -0x48(%ebp)
  8022b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8022b5:	e8 b3 fc ff ff       	call   801f6d <set_block_data>
  8022ba:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	75 17                	jne    8022da <alloc_block_FF+0x33e>
  8022c3:	83 ec 04             	sub    $0x4,%esp
  8022c6:	68 27 42 80 00       	push   $0x804227
  8022cb:	68 e8 00 00 00       	push   $0xe8
  8022d0:	68 45 42 80 00       	push   $0x804245
  8022d5:	e8 02 15 00 00       	call   8037dc <_panic>
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 00                	mov    (%eax),%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	74 10                	je     8022f3 <alloc_block_FF+0x357>
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022eb:	8b 52 04             	mov    0x4(%edx),%edx
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
  8022f1:	eb 0b                	jmp    8022fe <alloc_block_FF+0x362>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 40 04             	mov    0x4(%eax),%eax
  8022f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	74 0f                	je     802317 <alloc_block_FF+0x37b>
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 04             	mov    0x4(%eax),%eax
  80230e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802311:	8b 12                	mov    (%edx),%edx
  802313:	89 10                	mov    %edx,(%eax)
  802315:	eb 0a                	jmp    802321 <alloc_block_FF+0x385>
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802334:	a1 38 50 80 00       	mov    0x805038,%eax
  802339:	48                   	dec    %eax
  80233a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80233f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802342:	e9 0f 01 00 00       	jmp    802456 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802347:	a1 34 50 80 00       	mov    0x805034,%eax
  80234c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802353:	74 07                	je     80235c <alloc_block_FF+0x3c0>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	eb 05                	jmp    802361 <alloc_block_FF+0x3c5>
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	a3 34 50 80 00       	mov    %eax,0x805034
  802366:	a1 34 50 80 00       	mov    0x805034,%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	0f 85 e9 fc ff ff    	jne    80205c <alloc_block_FF+0xc0>
  802373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802377:	0f 85 df fc ff ff    	jne    80205c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	83 c0 08             	add    $0x8,%eax
  802383:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802386:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80238d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802390:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802393:	01 d0                	add    %edx,%eax
  802395:	48                   	dec    %eax
  802396:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802399:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80239c:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a1:	f7 75 d8             	divl   -0x28(%ebp)
  8023a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a7:	29 d0                	sub    %edx,%eax
  8023a9:	c1 e8 0c             	shr    $0xc,%eax
  8023ac:	83 ec 0c             	sub    $0xc,%esp
  8023af:	50                   	push   %eax
  8023b0:	e8 76 ed ff ff       	call   80112b <sbrk>
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023bb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023bf:	75 0a                	jne    8023cb <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c6:	e9 8b 00 00 00       	jmp    802456 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023cb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023d8:	01 d0                	add    %edx,%eax
  8023da:	48                   	dec    %eax
  8023db:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e6:	f7 75 cc             	divl   -0x34(%ebp)
  8023e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023ec:	29 d0                	sub    %edx,%eax
  8023ee:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023f4:	01 d0                	add    %edx,%eax
  8023f6:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802400:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802406:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80240d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802410:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	48                   	dec    %eax
  802416:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802419:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80241c:	ba 00 00 00 00       	mov    $0x0,%edx
  802421:	f7 75 c4             	divl   -0x3c(%ebp)
  802424:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802427:	29 d0                	sub    %edx,%eax
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	6a 01                	push   $0x1
  80242e:	50                   	push   %eax
  80242f:	ff 75 d0             	pushl  -0x30(%ebp)
  802432:	e8 36 fb ff ff       	call   801f6d <set_block_data>
  802437:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80243a:	83 ec 0c             	sub    $0xc,%esp
  80243d:	ff 75 d0             	pushl  -0x30(%ebp)
  802440:	e8 1b 0a 00 00       	call   802e60 <free_block>
  802445:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802448:	83 ec 0c             	sub    $0xc,%esp
  80244b:	ff 75 08             	pushl  0x8(%ebp)
  80244e:	e8 49 fb ff ff       	call   801f9c <alloc_block_FF>
  802453:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	83 e0 01             	and    $0x1,%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 03                	je     80246b <alloc_block_BF+0x13>
  802468:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80246b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80246f:	77 07                	ja     802478 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802471:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802478:	a1 24 50 80 00       	mov    0x805024,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 73                	jne    8024f4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	83 c0 10             	add    $0x10,%eax
  802487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80248a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802491:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802497:	01 d0                	add    %edx,%eax
  802499:	48                   	dec    %eax
  80249a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80249d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a5:	f7 75 e0             	divl   -0x20(%ebp)
  8024a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024ab:	29 d0                	sub    %edx,%eax
  8024ad:	c1 e8 0c             	shr    $0xc,%eax
  8024b0:	83 ec 0c             	sub    $0xc,%esp
  8024b3:	50                   	push   %eax
  8024b4:	e8 72 ec ff ff       	call   80112b <sbrk>
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024bf:	83 ec 0c             	sub    $0xc,%esp
  8024c2:	6a 00                	push   $0x0
  8024c4:	e8 62 ec ff ff       	call   80112b <sbrk>
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024d5:	83 ec 08             	sub    $0x8,%esp
  8024d8:	50                   	push   %eax
  8024d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8024dc:	e8 9f f8 ff ff       	call   801d80 <initialize_dynamic_allocator>
  8024e1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	68 83 42 80 00       	push   $0x804283
  8024ec:	e8 a0 de ff ff       	call   800391 <cprintf>
  8024f1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8024f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802502:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802509:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802510:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802518:	e9 1d 01 00 00       	jmp    80263a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	ff 75 a8             	pushl  -0x58(%ebp)
  802529:	e8 ee f6 ff ff       	call   801c1c <get_block_size>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	83 c0 08             	add    $0x8,%eax
  80253a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80253d:	0f 87 ef 00 00 00    	ja     802632 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	83 c0 18             	add    $0x18,%eax
  802549:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80254c:	77 1d                	ja     80256b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80254e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802551:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802554:	0f 86 d8 00 00 00    	jbe    802632 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80255a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80255d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802560:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802563:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802566:	e9 c7 00 00 00       	jmp    802632 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	83 c0 08             	add    $0x8,%eax
  802571:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802574:	0f 85 9d 00 00 00    	jne    802617 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	6a 01                	push   $0x1
  80257f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802582:	ff 75 a8             	pushl  -0x58(%ebp)
  802585:	e8 e3 f9 ff ff       	call   801f6d <set_block_data>
  80258a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80258d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802591:	75 17                	jne    8025aa <alloc_block_BF+0x152>
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 27 42 80 00       	push   $0x804227
  80259b:	68 2c 01 00 00       	push   $0x12c
  8025a0:	68 45 42 80 00       	push   $0x804245
  8025a5:	e8 32 12 00 00       	call   8037dc <_panic>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 10                	je     8025c3 <alloc_block_BF+0x16b>
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bb:	8b 52 04             	mov    0x4(%edx),%edx
  8025be:	89 50 04             	mov    %edx,0x4(%eax)
  8025c1:	eb 0b                	jmp    8025ce <alloc_block_BF+0x176>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 04             	mov    0x4(%eax),%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 0f                	je     8025e7 <alloc_block_BF+0x18f>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e1:	8b 12                	mov    (%edx),%edx
  8025e3:	89 10                	mov    %edx,(%eax)
  8025e5:	eb 0a                	jmp    8025f1 <alloc_block_BF+0x199>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802604:	a1 38 50 80 00       	mov    0x805038,%eax
  802609:	48                   	dec    %eax
  80260a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80260f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802612:	e9 24 04 00 00       	jmp    802a3b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80261d:	76 13                	jbe    802632 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80261f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802626:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802629:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80262c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80262f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802632:	a1 34 50 80 00       	mov    0x805034,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263e:	74 07                	je     802647 <alloc_block_BF+0x1ef>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	eb 05                	jmp    80264c <alloc_block_BF+0x1f4>
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	a3 34 50 80 00       	mov    %eax,0x805034
  802651:	a1 34 50 80 00       	mov    0x805034,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 85 bf fe ff ff    	jne    80251d <alloc_block_BF+0xc5>
  80265e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802662:	0f 85 b5 fe ff ff    	jne    80251d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802668:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80266c:	0f 84 26 02 00 00    	je     802898 <alloc_block_BF+0x440>
  802672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802676:	0f 85 1c 02 00 00    	jne    802898 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	2b 45 08             	sub    0x8(%ebp),%eax
  802682:	83 e8 08             	sub    $0x8,%eax
  802685:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	8d 50 08             	lea    0x8(%eax),%edx
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	01 d0                	add    %edx,%eax
  802693:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	83 c0 08             	add    $0x8,%eax
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	6a 01                	push   $0x1
  8026a1:	50                   	push   %eax
  8026a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a5:	e8 c3 f8 ff ff       	call   801f6d <set_block_data>
  8026aa:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	75 68                	jne    80271f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026bb:	75 17                	jne    8026d4 <alloc_block_BF+0x27c>
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	68 60 42 80 00       	push   $0x804260
  8026c5:	68 45 01 00 00       	push   $0x145
  8026ca:	68 45 42 80 00       	push   $0x804245
  8026cf:	e8 08 11 00 00       	call   8037dc <_panic>
  8026d4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026dd:	89 10                	mov    %edx,(%eax)
  8026df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	74 0d                	je     8026f5 <alloc_block_BF+0x29d>
  8026e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026f0:	89 50 04             	mov    %edx,0x4(%eax)
  8026f3:	eb 08                	jmp    8026fd <alloc_block_BF+0x2a5>
  8026f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8026fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802700:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802705:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270f:	a1 38 50 80 00       	mov    0x805038,%eax
  802714:	40                   	inc    %eax
  802715:	a3 38 50 80 00       	mov    %eax,0x805038
  80271a:	e9 dc 00 00 00       	jmp    8027fb <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 65                	jne    80278d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802728:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80272c:	75 17                	jne    802745 <alloc_block_BF+0x2ed>
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	68 94 42 80 00       	push   $0x804294
  802736:	68 4a 01 00 00       	push   $0x14a
  80273b:	68 45 42 80 00       	push   $0x804245
  802740:	e8 97 10 00 00       	call   8037dc <_panic>
  802745:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80274b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274e:	89 50 04             	mov    %edx,0x4(%eax)
  802751:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802754:	8b 40 04             	mov    0x4(%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	74 0c                	je     802767 <alloc_block_BF+0x30f>
  80275b:	a1 30 50 80 00       	mov    0x805030,%eax
  802760:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 08                	jmp    80276f <alloc_block_BF+0x317>
  802767:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802772:	a3 30 50 80 00       	mov    %eax,0x805030
  802777:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802780:	a1 38 50 80 00       	mov    0x805038,%eax
  802785:	40                   	inc    %eax
  802786:	a3 38 50 80 00       	mov    %eax,0x805038
  80278b:	eb 6e                	jmp    8027fb <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80278d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802791:	74 06                	je     802799 <alloc_block_BF+0x341>
  802793:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802797:	75 17                	jne    8027b0 <alloc_block_BF+0x358>
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 b8 42 80 00       	push   $0x8042b8
  8027a1:	68 4f 01 00 00       	push   $0x14f
  8027a6:	68 45 42 80 00       	push   $0x804245
  8027ab:	e8 2c 10 00 00       	call   8037dc <_panic>
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	8b 10                	mov    (%eax),%edx
  8027b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 0b                	je     8027ce <alloc_block_BF+0x376>
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027cb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027d4:	89 10                	mov    %edx,(%eax)
  8027d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027dc:	89 50 04             	mov    %edx,0x4(%eax)
  8027df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	75 08                	jne    8027f0 <alloc_block_BF+0x398>
  8027e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f5:	40                   	inc    %eax
  8027f6:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ff:	75 17                	jne    802818 <alloc_block_BF+0x3c0>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 27 42 80 00       	push   $0x804227
  802809:	68 51 01 00 00       	push   $0x151
  80280e:	68 45 42 80 00       	push   $0x804245
  802813:	e8 c4 0f 00 00       	call   8037dc <_panic>
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 10                	je     802831 <alloc_block_BF+0x3d9>
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802829:	8b 52 04             	mov    0x4(%edx),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 0b                	jmp    80283c <alloc_block_BF+0x3e4>
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	a3 30 50 80 00       	mov    %eax,0x805030
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 0f                	je     802855 <alloc_block_BF+0x3fd>
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284f:	8b 12                	mov    (%edx),%edx
  802851:	89 10                	mov    %edx,(%eax)
  802853:	eb 0a                	jmp    80285f <alloc_block_BF+0x407>
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802872:	a1 38 50 80 00       	mov    0x805038,%eax
  802877:	48                   	dec    %eax
  802878:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	6a 00                	push   $0x0
  802882:	ff 75 d0             	pushl  -0x30(%ebp)
  802885:	ff 75 cc             	pushl  -0x34(%ebp)
  802888:	e8 e0 f6 ff ff       	call   801f6d <set_block_data>
  80288d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	e9 a3 01 00 00       	jmp    802a3b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802898:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80289c:	0f 85 9d 00 00 00    	jne    80293f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	6a 01                	push   $0x1
  8028a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8028aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ad:	e8 bb f6 ff ff       	call   801f6d <set_block_data>
  8028b2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b9:	75 17                	jne    8028d2 <alloc_block_BF+0x47a>
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 27 42 80 00       	push   $0x804227
  8028c3:	68 58 01 00 00       	push   $0x158
  8028c8:	68 45 42 80 00       	push   $0x804245
  8028cd:	e8 0a 0f 00 00       	call   8037dc <_panic>
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 10                	je     8028eb <alloc_block_BF+0x493>
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e3:	8b 52 04             	mov    0x4(%edx),%edx
  8028e6:	89 50 04             	mov    %edx,0x4(%eax)
  8028e9:	eb 0b                	jmp    8028f6 <alloc_block_BF+0x49e>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0f                	je     80290f <alloc_block_BF+0x4b7>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802909:	8b 12                	mov    (%edx),%edx
  80290b:	89 10                	mov    %edx,(%eax)
  80290d:	eb 0a                	jmp    802919 <alloc_block_BF+0x4c1>
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292c:	a1 38 50 80 00       	mov    0x805038,%eax
  802931:	48                   	dec    %eax
  802932:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	e9 fc 00 00 00       	jmp    802a3b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	83 c0 08             	add    $0x8,%eax
  802945:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802948:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80294f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802952:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802955:	01 d0                	add    %edx,%eax
  802957:	48                   	dec    %eax
  802958:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80295b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80295e:	ba 00 00 00 00       	mov    $0x0,%edx
  802963:	f7 75 c4             	divl   -0x3c(%ebp)
  802966:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802969:	29 d0                	sub    %edx,%eax
  80296b:	c1 e8 0c             	shr    $0xc,%eax
  80296e:	83 ec 0c             	sub    $0xc,%esp
  802971:	50                   	push   %eax
  802972:	e8 b4 e7 ff ff       	call   80112b <sbrk>
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80297d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802981:	75 0a                	jne    80298d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
  802988:	e9 ae 00 00 00       	jmp    802a3b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80298d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802994:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802997:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80299a:	01 d0                	add    %edx,%eax
  80299c:	48                   	dec    %eax
  80299d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a8:	f7 75 b8             	divl   -0x48(%ebp)
  8029ab:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029ae:	29 d0                	sub    %edx,%eax
  8029b0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029b6:	01 d0                	add    %edx,%eax
  8029b8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029c8:	83 ec 0c             	sub    $0xc,%esp
  8029cb:	68 ec 42 80 00       	push   $0x8042ec
  8029d0:	e8 bc d9 ff ff       	call   800391 <cprintf>
  8029d5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029d8:	83 ec 08             	sub    $0x8,%esp
  8029db:	ff 75 bc             	pushl  -0x44(%ebp)
  8029de:	68 f1 42 80 00       	push   $0x8042f1
  8029e3:	e8 a9 d9 ff ff       	call   800391 <cprintf>
  8029e8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029eb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f8:	01 d0                	add    %edx,%eax
  8029fa:	48                   	dec    %eax
  8029fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029fe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a01:	ba 00 00 00 00       	mov    $0x0,%edx
  802a06:	f7 75 b0             	divl   -0x50(%ebp)
  802a09:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a0c:	29 d0                	sub    %edx,%eax
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	6a 01                	push   $0x1
  802a13:	50                   	push   %eax
  802a14:	ff 75 bc             	pushl  -0x44(%ebp)
  802a17:	e8 51 f5 ff ff       	call   801f6d <set_block_data>
  802a1c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a1f:	83 ec 0c             	sub    $0xc,%esp
  802a22:	ff 75 bc             	pushl  -0x44(%ebp)
  802a25:	e8 36 04 00 00       	call   802e60 <free_block>
  802a2a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a2d:	83 ec 0c             	sub    $0xc,%esp
  802a30:	ff 75 08             	pushl  0x8(%ebp)
  802a33:	e8 20 fa ff ff       	call   802458 <alloc_block_BF>
  802a38:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a3b:	c9                   	leave  
  802a3c:	c3                   	ret    

00802a3d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
  802a40:	53                   	push   %ebx
  802a41:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a56:	74 1e                	je     802a76 <merging+0x39>
  802a58:	ff 75 08             	pushl  0x8(%ebp)
  802a5b:	e8 bc f1 ff ff       	call   801c1c <get_block_size>
  802a60:	83 c4 04             	add    $0x4,%esp
  802a63:	89 c2                	mov    %eax,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	01 d0                	add    %edx,%eax
  802a6a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a6d:	75 07                	jne    802a76 <merging+0x39>
		prev_is_free = 1;
  802a6f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a7a:	74 1e                	je     802a9a <merging+0x5d>
  802a7c:	ff 75 10             	pushl  0x10(%ebp)
  802a7f:	e8 98 f1 ff ff       	call   801c1c <get_block_size>
  802a84:	83 c4 04             	add    $0x4,%esp
  802a87:	89 c2                	mov    %eax,%edx
  802a89:	8b 45 10             	mov    0x10(%ebp),%eax
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a91:	75 07                	jne    802a9a <merging+0x5d>
		next_is_free = 1;
  802a93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	0f 84 cc 00 00 00    	je     802b70 <merging+0x133>
  802aa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa8:	0f 84 c2 00 00 00    	je     802b70 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802aae:	ff 75 08             	pushl  0x8(%ebp)
  802ab1:	e8 66 f1 ff ff       	call   801c1c <get_block_size>
  802ab6:	83 c4 04             	add    $0x4,%esp
  802ab9:	89 c3                	mov    %eax,%ebx
  802abb:	ff 75 10             	pushl  0x10(%ebp)
  802abe:	e8 59 f1 ff ff       	call   801c1c <get_block_size>
  802ac3:	83 c4 04             	add    $0x4,%esp
  802ac6:	01 c3                	add    %eax,%ebx
  802ac8:	ff 75 0c             	pushl  0xc(%ebp)
  802acb:	e8 4c f1 ff ff       	call   801c1c <get_block_size>
  802ad0:	83 c4 04             	add    $0x4,%esp
  802ad3:	01 d8                	add    %ebx,%eax
  802ad5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ad8:	6a 00                	push   $0x0
  802ada:	ff 75 ec             	pushl  -0x14(%ebp)
  802add:	ff 75 08             	pushl  0x8(%ebp)
  802ae0:	e8 88 f4 ff ff       	call   801f6d <set_block_data>
  802ae5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aec:	75 17                	jne    802b05 <merging+0xc8>
  802aee:	83 ec 04             	sub    $0x4,%esp
  802af1:	68 27 42 80 00       	push   $0x804227
  802af6:	68 7d 01 00 00       	push   $0x17d
  802afb:	68 45 42 80 00       	push   $0x804245
  802b00:	e8 d7 0c 00 00       	call   8037dc <_panic>
  802b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 10                	je     802b1e <merging+0xe1>
  802b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b16:	8b 52 04             	mov    0x4(%edx),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	eb 0b                	jmp    802b29 <merging+0xec>
  802b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	a3 30 50 80 00       	mov    %eax,0x805030
  802b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	74 0f                	je     802b42 <merging+0x105>
  802b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3c:	8b 12                	mov    (%edx),%edx
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	eb 0a                	jmp    802b4c <merging+0x10f>
  802b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b64:	48                   	dec    %eax
  802b65:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b6a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b6b:	e9 ea 02 00 00       	jmp    802e5a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b74:	74 3b                	je     802bb1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b76:	83 ec 0c             	sub    $0xc,%esp
  802b79:	ff 75 08             	pushl  0x8(%ebp)
  802b7c:	e8 9b f0 ff ff       	call   801c1c <get_block_size>
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	89 c3                	mov    %eax,%ebx
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	ff 75 10             	pushl  0x10(%ebp)
  802b8c:	e8 8b f0 ff ff       	call   801c1c <get_block_size>
  802b91:	83 c4 10             	add    $0x10,%esp
  802b94:	01 d8                	add    %ebx,%eax
  802b96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	6a 00                	push   $0x0
  802b9e:	ff 75 e8             	pushl  -0x18(%ebp)
  802ba1:	ff 75 08             	pushl  0x8(%ebp)
  802ba4:	e8 c4 f3 ff ff       	call   801f6d <set_block_data>
  802ba9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bac:	e9 a9 02 00 00       	jmp    802e5a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb5:	0f 84 2d 01 00 00    	je     802ce8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bbb:	83 ec 0c             	sub    $0xc,%esp
  802bbe:	ff 75 10             	pushl  0x10(%ebp)
  802bc1:	e8 56 f0 ff ff       	call   801c1c <get_block_size>
  802bc6:	83 c4 10             	add    $0x10,%esp
  802bc9:	89 c3                	mov    %eax,%ebx
  802bcb:	83 ec 0c             	sub    $0xc,%esp
  802bce:	ff 75 0c             	pushl  0xc(%ebp)
  802bd1:	e8 46 f0 ff ff       	call   801c1c <get_block_size>
  802bd6:	83 c4 10             	add    $0x10,%esp
  802bd9:	01 d8                	add    %ebx,%eax
  802bdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	6a 00                	push   $0x0
  802be3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802be6:	ff 75 10             	pushl  0x10(%ebp)
  802be9:	e8 7f f3 ff ff       	call   801f6d <set_block_data>
  802bee:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfb:	74 06                	je     802c03 <merging+0x1c6>
  802bfd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c01:	75 17                	jne    802c1a <merging+0x1dd>
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	68 00 43 80 00       	push   $0x804300
  802c0b:	68 8d 01 00 00       	push   $0x18d
  802c10:	68 45 42 80 00       	push   $0x804245
  802c15:	e8 c2 0b 00 00       	call   8037dc <_panic>
  802c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1d:	8b 50 04             	mov    0x4(%eax),%edx
  802c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c23:	89 50 04             	mov    %edx,0x4(%eax)
  802c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2c:	89 10                	mov    %edx,(%eax)
  802c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 0d                	je     802c45 <merging+0x208>
  802c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	eb 08                	jmp    802c4d <merging+0x210>
  802c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5b:	40                   	inc    %eax
  802c5c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c65:	75 17                	jne    802c7e <merging+0x241>
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	68 27 42 80 00       	push   $0x804227
  802c6f:	68 8e 01 00 00       	push   $0x18e
  802c74:	68 45 42 80 00       	push   $0x804245
  802c79:	e8 5e 0b 00 00       	call   8037dc <_panic>
  802c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 10                	je     802c97 <merging+0x25a>
  802c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c8f:	8b 52 04             	mov    0x4(%edx),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	eb 0b                	jmp    802ca2 <merging+0x265>
  802c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0f                	je     802cbb <merging+0x27e>
  802cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb5:	8b 12                	mov    (%edx),%edx
  802cb7:	89 10                	mov    %edx,(%eax)
  802cb9:	eb 0a                	jmp    802cc5 <merging+0x288>
  802cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdd:	48                   	dec    %eax
  802cde:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ce3:	e9 72 01 00 00       	jmp    802e5a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ceb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802cee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf2:	74 79                	je     802d6d <merging+0x330>
  802cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cf8:	74 73                	je     802d6d <merging+0x330>
  802cfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfe:	74 06                	je     802d06 <merging+0x2c9>
  802d00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d04:	75 17                	jne    802d1d <merging+0x2e0>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 b8 42 80 00       	push   $0x8042b8
  802d0e:	68 94 01 00 00       	push   $0x194
  802d13:	68 45 42 80 00       	push   $0x804245
  802d18:	e8 bf 0a 00 00       	call   8037dc <_panic>
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 10                	mov    (%eax),%edx
  802d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	74 0b                	je     802d3b <merging+0x2fe>
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d38:	89 50 04             	mov    %edx,0x4(%eax)
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d46:	8b 55 08             	mov    0x8(%ebp),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	75 08                	jne    802d5d <merging+0x320>
  802d55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d58:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d62:	40                   	inc    %eax
  802d63:	a3 38 50 80 00       	mov    %eax,0x805038
  802d68:	e9 ce 00 00 00       	jmp    802e3b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d71:	74 65                	je     802dd8 <merging+0x39b>
  802d73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d77:	75 17                	jne    802d90 <merging+0x353>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 94 42 80 00       	push   $0x804294
  802d81:	68 95 01 00 00       	push   $0x195
  802d86:	68 45 42 80 00       	push   $0x804245
  802d8b:	e8 4c 0a 00 00       	call   8037dc <_panic>
  802d90:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d99:	89 50 04             	mov    %edx,0x4(%eax)
  802d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 0c                	je     802db2 <merging+0x375>
  802da6:	a1 30 50 80 00       	mov    0x805030,%eax
  802dab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dae:	89 10                	mov    %edx,(%eax)
  802db0:	eb 08                	jmp    802dba <merging+0x37d>
  802db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbd:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcb:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd0:	40                   	inc    %eax
  802dd1:	a3 38 50 80 00       	mov    %eax,0x805038
  802dd6:	eb 63                	jmp    802e3b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802dd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ddc:	75 17                	jne    802df5 <merging+0x3b8>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 60 42 80 00       	push   $0x804260
  802de6:	68 98 01 00 00       	push   $0x198
  802deb:	68 45 42 80 00       	push   $0x804245
  802df0:	e8 e7 09 00 00       	call   8037dc <_panic>
  802df5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802dfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfe:	89 10                	mov    %edx,(%eax)
  802e00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 0d                	je     802e16 <merging+0x3d9>
  802e09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	eb 08                	jmp    802e1e <merging+0x3e1>
  802e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e19:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 38 50 80 00       	mov    0x805038,%eax
  802e35:	40                   	inc    %eax
  802e36:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e3b:	83 ec 0c             	sub    $0xc,%esp
  802e3e:	ff 75 10             	pushl  0x10(%ebp)
  802e41:	e8 d6 ed ff ff       	call   801c1c <get_block_size>
  802e46:	83 c4 10             	add    $0x10,%esp
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	6a 00                	push   $0x0
  802e4e:	50                   	push   %eax
  802e4f:	ff 75 10             	pushl  0x10(%ebp)
  802e52:	e8 16 f1 ff ff       	call   801f6d <set_block_data>
  802e57:	83 c4 10             	add    $0x10,%esp
	}
}
  802e5a:	90                   	nop
  802e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e5e:	c9                   	leave  
  802e5f:	c3                   	ret    

00802e60 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e60:	55                   	push   %ebp
  802e61:	89 e5                	mov    %esp,%ebp
  802e63:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e66:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e6e:	a1 30 50 80 00       	mov    0x805030,%eax
  802e73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e76:	73 1b                	jae    802e93 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e78:	a1 30 50 80 00       	mov    0x805030,%eax
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	ff 75 08             	pushl  0x8(%ebp)
  802e83:	6a 00                	push   $0x0
  802e85:	50                   	push   %eax
  802e86:	e8 b2 fb ff ff       	call   802a3d <merging>
  802e8b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e8e:	e9 8b 00 00 00       	jmp    802f1e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e93:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9b:	76 18                	jbe    802eb5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e9d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	ff 75 08             	pushl  0x8(%ebp)
  802ea8:	50                   	push   %eax
  802ea9:	6a 00                	push   $0x0
  802eab:	e8 8d fb ff ff       	call   802a3d <merging>
  802eb0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802eb3:	eb 69                	jmp    802f1e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eb5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	eb 39                	jmp    802ef8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec5:	73 29                	jae    802ef0 <free_block+0x90>
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecf:	76 1f                	jbe    802ef0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	ff 75 08             	pushl  0x8(%ebp)
  802edf:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee5:	e8 53 fb ff ff       	call   802a3d <merging>
  802eea:	83 c4 10             	add    $0x10,%esp
			break;
  802eed:	90                   	nop
		}
	}
}
  802eee:	eb 2e                	jmp    802f1e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ef0:	a1 34 50 80 00       	mov    0x805034,%eax
  802ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efc:	74 07                	je     802f05 <free_block+0xa5>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	eb 05                	jmp    802f0a <free_block+0xaa>
  802f05:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0a:	a3 34 50 80 00       	mov    %eax,0x805034
  802f0f:	a1 34 50 80 00       	mov    0x805034,%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	75 a7                	jne    802ebf <free_block+0x5f>
  802f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1c:	75 a1                	jne    802ebf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f1e:	90                   	nop
  802f1f:	c9                   	leave  
  802f20:	c3                   	ret    

00802f21 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f21:	55                   	push   %ebp
  802f22:	89 e5                	mov    %esp,%ebp
  802f24:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f27:	ff 75 08             	pushl  0x8(%ebp)
  802f2a:	e8 ed ec ff ff       	call   801c1c <get_block_size>
  802f2f:	83 c4 04             	add    $0x4,%esp
  802f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f3c:	eb 17                	jmp    802f55 <copy_data+0x34>
  802f3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f44:	01 c2                	add    %eax,%edx
  802f46:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	01 c8                	add    %ecx,%eax
  802f4e:	8a 00                	mov    (%eax),%al
  802f50:	88 02                	mov    %al,(%edx)
  802f52:	ff 45 fc             	incl   -0x4(%ebp)
  802f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f5b:	72 e1                	jb     802f3e <copy_data+0x1d>
}
  802f5d:	90                   	nop
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
  802f63:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	75 23                	jne    802f8f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f70:	74 13                	je     802f85 <realloc_block_FF+0x25>
  802f72:	83 ec 0c             	sub    $0xc,%esp
  802f75:	ff 75 0c             	pushl  0xc(%ebp)
  802f78:	e8 1f f0 ff ff       	call   801f9c <alloc_block_FF>
  802f7d:	83 c4 10             	add    $0x10,%esp
  802f80:	e9 f4 06 00 00       	jmp    803679 <realloc_block_FF+0x719>
		return NULL;
  802f85:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8a:	e9 ea 06 00 00       	jmp    803679 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f93:	75 18                	jne    802fad <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f95:	83 ec 0c             	sub    $0xc,%esp
  802f98:	ff 75 08             	pushl  0x8(%ebp)
  802f9b:	e8 c0 fe ff ff       	call   802e60 <free_block>
  802fa0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa8:	e9 cc 06 00 00       	jmp    803679 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fad:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fb1:	77 07                	ja     802fba <realloc_block_FF+0x5a>
  802fb3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	83 e0 01             	and    $0x1,%eax
  802fc0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	83 c0 08             	add    $0x8,%eax
  802fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	ff 75 08             	pushl  0x8(%ebp)
  802fd2:	e8 45 ec ff ff       	call   801c1c <get_block_size>
  802fd7:	83 c4 10             	add    $0x10,%esp
  802fda:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	83 e8 08             	sub    $0x8,%eax
  802fe3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	83 e8 04             	sub    $0x4,%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	83 e0 fe             	and    $0xfffffffe,%eax
  802ff1:	89 c2                	mov    %eax,%edx
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	01 d0                	add    %edx,%eax
  802ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802ffb:	83 ec 0c             	sub    $0xc,%esp
  802ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803001:	e8 16 ec ff ff       	call   801c1c <get_block_size>
  803006:	83 c4 10             	add    $0x10,%esp
  803009:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80300c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300f:	83 e8 08             	sub    $0x8,%eax
  803012:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803015:	8b 45 0c             	mov    0xc(%ebp),%eax
  803018:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80301b:	75 08                	jne    803025 <realloc_block_FF+0xc5>
	{
		 return va;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	e9 54 06 00 00       	jmp    803679 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803025:	8b 45 0c             	mov    0xc(%ebp),%eax
  803028:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80302b:	0f 83 e5 03 00 00    	jae    803416 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	2b 45 0c             	sub    0xc(%ebp),%eax
  803037:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80303a:	83 ec 0c             	sub    $0xc,%esp
  80303d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803040:	e8 f0 eb ff ff       	call   801c35 <is_free_block>
  803045:	83 c4 10             	add    $0x10,%esp
  803048:	84 c0                	test   %al,%al
  80304a:	0f 84 3b 01 00 00    	je     80318b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803050:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803053:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803056:	01 d0                	add    %edx,%eax
  803058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	6a 01                	push   $0x1
  803060:	ff 75 f0             	pushl  -0x10(%ebp)
  803063:	ff 75 08             	pushl  0x8(%ebp)
  803066:	e8 02 ef ff ff       	call   801f6d <set_block_data>
  80306b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	83 e8 04             	sub    $0x4,%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	83 e0 fe             	and    $0xfffffffe,%eax
  803079:	89 c2                	mov    %eax,%edx
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	01 d0                	add    %edx,%eax
  803080:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	6a 00                	push   $0x0
  803088:	ff 75 cc             	pushl  -0x34(%ebp)
  80308b:	ff 75 c8             	pushl  -0x38(%ebp)
  80308e:	e8 da ee ff ff       	call   801f6d <set_block_data>
  803093:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803096:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80309a:	74 06                	je     8030a2 <realloc_block_FF+0x142>
  80309c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030a0:	75 17                	jne    8030b9 <realloc_block_FF+0x159>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 b8 42 80 00       	push   $0x8042b8
  8030aa:	68 f6 01 00 00       	push   $0x1f6
  8030af:	68 45 42 80 00       	push   $0x804245
  8030b4:	e8 23 07 00 00       	call   8037dc <_panic>
  8030b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bc:	8b 10                	mov    (%eax),%edx
  8030be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c1:	89 10                	mov    %edx,(%eax)
  8030c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	74 0b                	je     8030d7 <realloc_block_FF+0x177>
  8030cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030da:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030dd:	89 10                	mov    %edx,(%eax)
  8030df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	75 08                	jne    8030f9 <realloc_block_FF+0x199>
  8030f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803104:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803108:	75 17                	jne    803121 <realloc_block_FF+0x1c1>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 27 42 80 00       	push   $0x804227
  803112:	68 f7 01 00 00       	push   $0x1f7
  803117:	68 45 42 80 00       	push   $0x804245
  80311c:	e8 bb 06 00 00       	call   8037dc <_panic>
  803121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 10                	je     80313a <realloc_block_FF+0x1da>
  80312a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803132:	8b 52 04             	mov    0x4(%edx),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 0b                	jmp    803145 <realloc_block_FF+0x1e5>
  80313a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	a3 30 50 80 00       	mov    %eax,0x805030
  803145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	74 0f                	je     80315e <realloc_block_FF+0x1fe>
  80314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803152:	8b 40 04             	mov    0x4(%eax),%eax
  803155:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803158:	8b 12                	mov    (%edx),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	eb 0a                	jmp    803168 <realloc_block_FF+0x208>
  80315e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 38 50 80 00       	mov    0x805038,%eax
  803180:	48                   	dec    %eax
  803181:	a3 38 50 80 00       	mov    %eax,0x805038
  803186:	e9 83 02 00 00       	jmp    80340e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80318b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80318f:	0f 86 69 02 00 00    	jbe    8033fe <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	6a 01                	push   $0x1
  80319a:	ff 75 f0             	pushl  -0x10(%ebp)
  80319d:	ff 75 08             	pushl  0x8(%ebp)
  8031a0:	e8 c8 ed ff ff       	call   801f6d <set_block_data>
  8031a5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	83 e8 04             	sub    $0x4,%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b3:	89 c2                	mov    %eax,%edx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	01 d0                	add    %edx,%eax
  8031ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031c5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031c9:	75 68                	jne    803233 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031cf:	75 17                	jne    8031e8 <realloc_block_FF+0x288>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 60 42 80 00       	push   $0x804260
  8031d9:	68 06 02 00 00       	push   $0x206
  8031de:	68 45 42 80 00       	push   $0x804245
  8031e3:	e8 f4 05 00 00       	call   8037dc <_panic>
  8031e8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0d                	je     803209 <realloc_block_FF+0x2a9>
  8031fc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803201:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803204:	89 50 04             	mov    %edx,0x4(%eax)
  803207:	eb 08                	jmp    803211 <realloc_block_FF+0x2b1>
  803209:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320c:	a3 30 50 80 00       	mov    %eax,0x805030
  803211:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803214:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803219:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803223:	a1 38 50 80 00       	mov    0x805038,%eax
  803228:	40                   	inc    %eax
  803229:	a3 38 50 80 00       	mov    %eax,0x805038
  80322e:	e9 b0 01 00 00       	jmp    8033e3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803233:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803238:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80323b:	76 68                	jbe    8032a5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80323d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803241:	75 17                	jne    80325a <realloc_block_FF+0x2fa>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 60 42 80 00       	push   $0x804260
  80324b:	68 0b 02 00 00       	push   $0x20b
  803250:	68 45 42 80 00       	push   $0x804245
  803255:	e8 82 05 00 00       	call   8037dc <_panic>
  80325a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803263:	89 10                	mov    %edx,(%eax)
  803265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0d                	je     80327b <realloc_block_FF+0x31b>
  80326e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803273:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	eb 08                	jmp    803283 <realloc_block_FF+0x323>
  80327b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327e:	a3 30 50 80 00       	mov    %eax,0x805030
  803283:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803286:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803295:	a1 38 50 80 00       	mov    0x805038,%eax
  80329a:	40                   	inc    %eax
  80329b:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a0:	e9 3e 01 00 00       	jmp    8033e3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032ad:	73 68                	jae    803317 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b3:	75 17                	jne    8032cc <realloc_block_FF+0x36c>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 94 42 80 00       	push   $0x804294
  8032bd:	68 10 02 00 00       	push   $0x210
  8032c2:	68 45 42 80 00       	push   $0x804245
  8032c7:	e8 10 05 00 00       	call   8037dc <_panic>
  8032cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0c                	je     8032ee <realloc_block_FF+0x38e>
  8032e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032ea:	89 10                	mov    %edx,(%eax)
  8032ec:	eb 08                	jmp    8032f6 <realloc_block_FF+0x396>
  8032ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8032fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803307:	a1 38 50 80 00       	mov    0x805038,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 38 50 80 00       	mov    %eax,0x805038
  803312:	e9 cc 00 00 00       	jmp    8033e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803317:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80331e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803326:	e9 8a 00 00 00       	jmp    8033b5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803331:	73 7a                	jae    8033ad <realloc_block_FF+0x44d>
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80333b:	73 70                	jae    8033ad <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80333d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803341:	74 06                	je     803349 <realloc_block_FF+0x3e9>
  803343:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803347:	75 17                	jne    803360 <realloc_block_FF+0x400>
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	68 b8 42 80 00       	push   $0x8042b8
  803351:	68 1a 02 00 00       	push   $0x21a
  803356:	68 45 42 80 00       	push   $0x804245
  80335b:	e8 7c 04 00 00       	call   8037dc <_panic>
  803360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803363:	8b 10                	mov    (%eax),%edx
  803365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803368:	89 10                	mov    %edx,(%eax)
  80336a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	74 0b                	je     80337e <realloc_block_FF+0x41e>
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337b:	89 50 04             	mov    %edx,0x4(%eax)
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803384:	89 10                	mov    %edx,(%eax)
  803386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338c:	89 50 04             	mov    %edx,0x4(%eax)
  80338f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	75 08                	jne    8033a0 <realloc_block_FF+0x440>
  803398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339b:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a5:	40                   	inc    %eax
  8033a6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033ab:	eb 36                	jmp    8033e3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b9:	74 07                	je     8033c2 <realloc_block_FF+0x462>
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	eb 05                	jmp    8033c7 <realloc_block_FF+0x467>
  8033c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8033cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8033d1:	85 c0                	test   %eax,%eax
  8033d3:	0f 85 52 ff ff ff    	jne    80332b <realloc_block_FF+0x3cb>
  8033d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dd:	0f 85 48 ff ff ff    	jne    80332b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	6a 00                	push   $0x0
  8033e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8033eb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033ee:	e8 7a eb ff ff       	call   801f6d <set_block_data>
  8033f3:	83 c4 10             	add    $0x10,%esp
				return va;
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	e9 7b 02 00 00       	jmp    803679 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033fe:	83 ec 0c             	sub    $0xc,%esp
  803401:	68 35 43 80 00       	push   $0x804335
  803406:	e8 86 cf ff ff       	call   800391 <cprintf>
  80340b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	e9 63 02 00 00       	jmp    803679 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803416:	8b 45 0c             	mov    0xc(%ebp),%eax
  803419:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80341c:	0f 86 4d 02 00 00    	jbe    80366f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803422:	83 ec 0c             	sub    $0xc,%esp
  803425:	ff 75 e4             	pushl  -0x1c(%ebp)
  803428:	e8 08 e8 ff ff       	call   801c35 <is_free_block>
  80342d:	83 c4 10             	add    $0x10,%esp
  803430:	84 c0                	test   %al,%al
  803432:	0f 84 37 02 00 00    	je     80366f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80343e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803441:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803444:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803447:	76 38                	jbe    803481 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803449:	83 ec 0c             	sub    $0xc,%esp
  80344c:	ff 75 08             	pushl  0x8(%ebp)
  80344f:	e8 0c fa ff ff       	call   802e60 <free_block>
  803454:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803457:	83 ec 0c             	sub    $0xc,%esp
  80345a:	ff 75 0c             	pushl  0xc(%ebp)
  80345d:	e8 3a eb ff ff       	call   801f9c <alloc_block_FF>
  803462:	83 c4 10             	add    $0x10,%esp
  803465:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803468:	83 ec 08             	sub    $0x8,%esp
  80346b:	ff 75 c0             	pushl  -0x40(%ebp)
  80346e:	ff 75 08             	pushl  0x8(%ebp)
  803471:	e8 ab fa ff ff       	call   802f21 <copy_data>
  803476:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803479:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80347c:	e9 f8 01 00 00       	jmp    803679 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803484:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803487:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80348a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80348e:	0f 87 a0 00 00 00    	ja     803534 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803494:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803498:	75 17                	jne    8034b1 <realloc_block_FF+0x551>
  80349a:	83 ec 04             	sub    $0x4,%esp
  80349d:	68 27 42 80 00       	push   $0x804227
  8034a2:	68 38 02 00 00       	push   $0x238
  8034a7:	68 45 42 80 00       	push   $0x804245
  8034ac:	e8 2b 03 00 00       	call   8037dc <_panic>
  8034b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 10                	je     8034ca <realloc_block_FF+0x56a>
  8034ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c2:	8b 52 04             	mov    0x4(%edx),%edx
  8034c5:	89 50 04             	mov    %edx,0x4(%eax)
  8034c8:	eb 0b                	jmp    8034d5 <realloc_block_FF+0x575>
  8034ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cd:	8b 40 04             	mov    0x4(%eax),%eax
  8034d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d8:	8b 40 04             	mov    0x4(%eax),%eax
  8034db:	85 c0                	test   %eax,%eax
  8034dd:	74 0f                	je     8034ee <realloc_block_FF+0x58e>
  8034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e2:	8b 40 04             	mov    0x4(%eax),%eax
  8034e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e8:	8b 12                	mov    (%edx),%edx
  8034ea:	89 10                	mov    %edx,(%eax)
  8034ec:	eb 0a                	jmp    8034f8 <realloc_block_FF+0x598>
  8034ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350b:	a1 38 50 80 00       	mov    0x805038,%eax
  803510:	48                   	dec    %eax
  803511:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803516:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351c:	01 d0                	add    %edx,%eax
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	6a 01                	push   $0x1
  803523:	50                   	push   %eax
  803524:	ff 75 08             	pushl  0x8(%ebp)
  803527:	e8 41 ea ff ff       	call   801f6d <set_block_data>
  80352c:	83 c4 10             	add    $0x10,%esp
  80352f:	e9 36 01 00 00       	jmp    80366a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803534:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803537:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80353a:	01 d0                	add    %edx,%eax
  80353c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80353f:	83 ec 04             	sub    $0x4,%esp
  803542:	6a 01                	push   $0x1
  803544:	ff 75 f0             	pushl  -0x10(%ebp)
  803547:	ff 75 08             	pushl  0x8(%ebp)
  80354a:	e8 1e ea ff ff       	call   801f6d <set_block_data>
  80354f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	83 e8 04             	sub    $0x4,%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	83 e0 fe             	and    $0xfffffffe,%eax
  80355d:	89 c2                	mov    %eax,%edx
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356b:	74 06                	je     803573 <realloc_block_FF+0x613>
  80356d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803571:	75 17                	jne    80358a <realloc_block_FF+0x62a>
  803573:	83 ec 04             	sub    $0x4,%esp
  803576:	68 b8 42 80 00       	push   $0x8042b8
  80357b:	68 44 02 00 00       	push   $0x244
  803580:	68 45 42 80 00       	push   $0x804245
  803585:	e8 52 02 00 00       	call   8037dc <_panic>
  80358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358d:	8b 10                	mov    (%eax),%edx
  80358f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803592:	89 10                	mov    %edx,(%eax)
  803594:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 0b                	je     8035a8 <realloc_block_FF+0x648>
  80359d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035a5:	89 50 04             	mov    %edx,0x4(%eax)
  8035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ab:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	75 08                	jne    8035ca <realloc_block_FF+0x66a>
  8035c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8035cf:	40                   	inc    %eax
  8035d0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d9:	75 17                	jne    8035f2 <realloc_block_FF+0x692>
  8035db:	83 ec 04             	sub    $0x4,%esp
  8035de:	68 27 42 80 00       	push   $0x804227
  8035e3:	68 45 02 00 00       	push   $0x245
  8035e8:	68 45 42 80 00       	push   $0x804245
  8035ed:	e8 ea 01 00 00       	call   8037dc <_panic>
  8035f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 10                	je     80360b <realloc_block_FF+0x6ab>
  8035fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803603:	8b 52 04             	mov    0x4(%edx),%edx
  803606:	89 50 04             	mov    %edx,0x4(%eax)
  803609:	eb 0b                	jmp    803616 <realloc_block_FF+0x6b6>
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360e:	8b 40 04             	mov    0x4(%eax),%eax
  803611:	a3 30 50 80 00       	mov    %eax,0x805030
  803616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803619:	8b 40 04             	mov    0x4(%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	74 0f                	je     80362f <realloc_block_FF+0x6cf>
  803620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803629:	8b 12                	mov    (%edx),%edx
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	eb 0a                	jmp    803639 <realloc_block_FF+0x6d9>
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364c:	a1 38 50 80 00       	mov    0x805038,%eax
  803651:	48                   	dec    %eax
  803652:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	6a 00                	push   $0x0
  80365c:	ff 75 bc             	pushl  -0x44(%ebp)
  80365f:	ff 75 b8             	pushl  -0x48(%ebp)
  803662:	e8 06 e9 ff ff       	call   801f6d <set_block_data>
  803667:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	eb 0a                	jmp    803679 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80366f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803679:	c9                   	leave  
  80367a:	c3                   	ret    

0080367b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80367b:	55                   	push   %ebp
  80367c:	89 e5                	mov    %esp,%ebp
  80367e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803681:	83 ec 04             	sub    $0x4,%esp
  803684:	68 3c 43 80 00       	push   $0x80433c
  803689:	68 58 02 00 00       	push   $0x258
  80368e:	68 45 42 80 00       	push   $0x804245
  803693:	e8 44 01 00 00       	call   8037dc <_panic>

00803698 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803698:	55                   	push   %ebp
  803699:	89 e5                	mov    %esp,%ebp
  80369b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	68 64 43 80 00       	push   $0x804364
  8036a6:	68 61 02 00 00       	push   $0x261
  8036ab:	68 45 42 80 00       	push   $0x804245
  8036b0:	e8 27 01 00 00       	call   8037dc <_panic>

008036b5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036b5:	55                   	push   %ebp
  8036b6:	89 e5                	mov    %esp,%ebp
  8036b8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 8c 43 80 00       	push   $0x80438c
  8036c3:	6a 09                	push   $0x9
  8036c5:	68 b4 43 80 00       	push   $0x8043b4
  8036ca:	e8 0d 01 00 00       	call   8037dc <_panic>

008036cf <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 c4 43 80 00       	push   $0x8043c4
  8036dd:	6a 10                	push   $0x10
  8036df:	68 b4 43 80 00       	push   $0x8043b4
  8036e4:	e8 f3 00 00 00       	call   8037dc <_panic>

008036e9 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 ec 43 80 00       	push   $0x8043ec
  8036f7:	6a 18                	push   $0x18
  8036f9:	68 b4 43 80 00       	push   $0x8043b4
  8036fe:	e8 d9 00 00 00       	call   8037dc <_panic>

00803703 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803703:	55                   	push   %ebp
  803704:	89 e5                	mov    %esp,%ebp
  803706:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803709:	83 ec 04             	sub    $0x4,%esp
  80370c:	68 14 44 80 00       	push   $0x804414
  803711:	6a 20                	push   $0x20
  803713:	68 b4 43 80 00       	push   $0x8043b4
  803718:	e8 bf 00 00 00       	call   8037dc <_panic>

0080371d <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80371d:	55                   	push   %ebp
  80371e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	8b 40 10             	mov    0x10(%eax),%eax
}
  803726:	5d                   	pop    %ebp
  803727:	c3                   	ret    

00803728 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803728:	55                   	push   %ebp
  803729:	89 e5                	mov    %esp,%ebp
  80372b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80372e:	8b 55 08             	mov    0x8(%ebp),%edx
  803731:	89 d0                	mov    %edx,%eax
  803733:	c1 e0 02             	shl    $0x2,%eax
  803736:	01 d0                	add    %edx,%eax
  803738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80373f:	01 d0                	add    %edx,%eax
  803741:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803748:	01 d0                	add    %edx,%eax
  80374a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803751:	01 d0                	add    %edx,%eax
  803753:	c1 e0 04             	shl    $0x4,%eax
  803756:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803760:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803763:	83 ec 0c             	sub    $0xc,%esp
  803766:	50                   	push   %eax
  803767:	e8 bc e1 ff ff       	call   801928 <sys_get_virtual_time>
  80376c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80376f:	eb 41                	jmp    8037b2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803771:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803774:	83 ec 0c             	sub    $0xc,%esp
  803777:	50                   	push   %eax
  803778:	e8 ab e1 ff ff       	call   801928 <sys_get_virtual_time>
  80377d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803780:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803786:	29 c2                	sub    %eax,%edx
  803788:	89 d0                	mov    %edx,%eax
  80378a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80378d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803793:	89 d1                	mov    %edx,%ecx
  803795:	29 c1                	sub    %eax,%ecx
  803797:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80379a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379d:	39 c2                	cmp    %eax,%edx
  80379f:	0f 97 c0             	seta   %al
  8037a2:	0f b6 c0             	movzbl %al,%eax
  8037a5:	29 c1                	sub    %eax,%ecx
  8037a7:	89 c8                	mov    %ecx,%eax
  8037a9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037af:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037b8:	72 b7                	jb     803771 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037ba:	90                   	nop
  8037bb:	c9                   	leave  
  8037bc:	c3                   	ret    

008037bd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037bd:	55                   	push   %ebp
  8037be:	89 e5                	mov    %esp,%ebp
  8037c0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037ca:	eb 03                	jmp    8037cf <busy_wait+0x12>
  8037cc:	ff 45 fc             	incl   -0x4(%ebp)
  8037cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d5:	72 f5                	jb     8037cc <busy_wait+0xf>
	return i;
  8037d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037da:	c9                   	leave  
  8037db:	c3                   	ret    

008037dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037dc:	55                   	push   %ebp
  8037dd:	89 e5                	mov    %esp,%ebp
  8037df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037e2:	8d 45 10             	lea    0x10(%ebp),%eax
  8037e5:	83 c0 04             	add    $0x4,%eax
  8037e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037eb:	a1 60 50 90 00       	mov    0x905060,%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 16                	je     80380a <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037f4:	a1 60 50 90 00       	mov    0x905060,%eax
  8037f9:	83 ec 08             	sub    $0x8,%esp
  8037fc:	50                   	push   %eax
  8037fd:	68 3c 44 80 00       	push   $0x80443c
  803802:	e8 8a cb ff ff       	call   800391 <cprintf>
  803807:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80380a:	a1 00 50 80 00       	mov    0x805000,%eax
  80380f:	ff 75 0c             	pushl  0xc(%ebp)
  803812:	ff 75 08             	pushl  0x8(%ebp)
  803815:	50                   	push   %eax
  803816:	68 41 44 80 00       	push   $0x804441
  80381b:	e8 71 cb ff ff       	call   800391 <cprintf>
  803820:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803823:	8b 45 10             	mov    0x10(%ebp),%eax
  803826:	83 ec 08             	sub    $0x8,%esp
  803829:	ff 75 f4             	pushl  -0xc(%ebp)
  80382c:	50                   	push   %eax
  80382d:	e8 f4 ca ff ff       	call   800326 <vcprintf>
  803832:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803835:	83 ec 08             	sub    $0x8,%esp
  803838:	6a 00                	push   $0x0
  80383a:	68 5d 44 80 00       	push   $0x80445d
  80383f:	e8 e2 ca ff ff       	call   800326 <vcprintf>
  803844:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803847:	e8 63 ca ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80384c:	eb fe                	jmp    80384c <_panic+0x70>

0080384e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80384e:	55                   	push   %ebp
  80384f:	89 e5                	mov    %esp,%ebp
  803851:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803854:	a1 20 50 80 00       	mov    0x805020,%eax
  803859:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80385f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803862:	39 c2                	cmp    %eax,%edx
  803864:	74 14                	je     80387a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803866:	83 ec 04             	sub    $0x4,%esp
  803869:	68 60 44 80 00       	push   $0x804460
  80386e:	6a 26                	push   $0x26
  803870:	68 ac 44 80 00       	push   $0x8044ac
  803875:	e8 62 ff ff ff       	call   8037dc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80387a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803881:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803888:	e9 c5 00 00 00       	jmp    803952 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803890:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803897:	8b 45 08             	mov    0x8(%ebp),%eax
  80389a:	01 d0                	add    %edx,%eax
  80389c:	8b 00                	mov    (%eax),%eax
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	75 08                	jne    8038aa <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038a2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038a5:	e9 a5 00 00 00       	jmp    80394f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038b8:	eb 69                	jmp    803923 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8038bf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c8:	89 d0                	mov    %edx,%eax
  8038ca:	01 c0                	add    %eax,%eax
  8038cc:	01 d0                	add    %edx,%eax
  8038ce:	c1 e0 03             	shl    $0x3,%eax
  8038d1:	01 c8                	add    %ecx,%eax
  8038d3:	8a 40 04             	mov    0x4(%eax),%al
  8038d6:	84 c0                	test   %al,%al
  8038d8:	75 46                	jne    803920 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038da:	a1 20 50 80 00       	mov    0x805020,%eax
  8038df:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e8:	89 d0                	mov    %edx,%eax
  8038ea:	01 c0                	add    %eax,%eax
  8038ec:	01 d0                	add    %edx,%eax
  8038ee:	c1 e0 03             	shl    $0x3,%eax
  8038f1:	01 c8                	add    %ecx,%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803900:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	01 c8                	add    %ecx,%eax
  803911:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803913:	39 c2                	cmp    %eax,%edx
  803915:	75 09                	jne    803920 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803917:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80391e:	eb 15                	jmp    803935 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803920:	ff 45 e8             	incl   -0x18(%ebp)
  803923:	a1 20 50 80 00       	mov    0x805020,%eax
  803928:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80392e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803931:	39 c2                	cmp    %eax,%edx
  803933:	77 85                	ja     8038ba <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803935:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803939:	75 14                	jne    80394f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80393b:	83 ec 04             	sub    $0x4,%esp
  80393e:	68 b8 44 80 00       	push   $0x8044b8
  803943:	6a 3a                	push   $0x3a
  803945:	68 ac 44 80 00       	push   $0x8044ac
  80394a:	e8 8d fe ff ff       	call   8037dc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80394f:	ff 45 f0             	incl   -0x10(%ebp)
  803952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803955:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803958:	0f 8c 2f ff ff ff    	jl     80388d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80395e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803965:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80396c:	eb 26                	jmp    803994 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80396e:	a1 20 50 80 00       	mov    0x805020,%eax
  803973:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80397c:	89 d0                	mov    %edx,%eax
  80397e:	01 c0                	add    %eax,%eax
  803980:	01 d0                	add    %edx,%eax
  803982:	c1 e0 03             	shl    $0x3,%eax
  803985:	01 c8                	add    %ecx,%eax
  803987:	8a 40 04             	mov    0x4(%eax),%al
  80398a:	3c 01                	cmp    $0x1,%al
  80398c:	75 03                	jne    803991 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80398e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803991:	ff 45 e0             	incl   -0x20(%ebp)
  803994:	a1 20 50 80 00       	mov    0x805020,%eax
  803999:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80399f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a2:	39 c2                	cmp    %eax,%edx
  8039a4:	77 c8                	ja     80396e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039ac:	74 14                	je     8039c2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	68 0c 45 80 00       	push   $0x80450c
  8039b6:	6a 44                	push   $0x44
  8039b8:	68 ac 44 80 00       	push   $0x8044ac
  8039bd:	e8 1a fe ff ff       	call   8037dc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039c2:	90                   	nop
  8039c3:	c9                   	leave  
  8039c4:	c3                   	ret    
  8039c5:	66 90                	xchg   %ax,%ax
  8039c7:	90                   	nop

008039c8 <__udivdi3>:
  8039c8:	55                   	push   %ebp
  8039c9:	57                   	push   %edi
  8039ca:	56                   	push   %esi
  8039cb:	53                   	push   %ebx
  8039cc:	83 ec 1c             	sub    $0x1c,%esp
  8039cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039df:	89 ca                	mov    %ecx,%edx
  8039e1:	89 f8                	mov    %edi,%eax
  8039e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039e7:	85 f6                	test   %esi,%esi
  8039e9:	75 2d                	jne    803a18 <__udivdi3+0x50>
  8039eb:	39 cf                	cmp    %ecx,%edi
  8039ed:	77 65                	ja     803a54 <__udivdi3+0x8c>
  8039ef:	89 fd                	mov    %edi,%ebp
  8039f1:	85 ff                	test   %edi,%edi
  8039f3:	75 0b                	jne    803a00 <__udivdi3+0x38>
  8039f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8039fa:	31 d2                	xor    %edx,%edx
  8039fc:	f7 f7                	div    %edi
  8039fe:	89 c5                	mov    %eax,%ebp
  803a00:	31 d2                	xor    %edx,%edx
  803a02:	89 c8                	mov    %ecx,%eax
  803a04:	f7 f5                	div    %ebp
  803a06:	89 c1                	mov    %eax,%ecx
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f5                	div    %ebp
  803a0c:	89 cf                	mov    %ecx,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	39 ce                	cmp    %ecx,%esi
  803a1a:	77 28                	ja     803a44 <__udivdi3+0x7c>
  803a1c:	0f bd fe             	bsr    %esi,%edi
  803a1f:	83 f7 1f             	xor    $0x1f,%edi
  803a22:	75 40                	jne    803a64 <__udivdi3+0x9c>
  803a24:	39 ce                	cmp    %ecx,%esi
  803a26:	72 0a                	jb     803a32 <__udivdi3+0x6a>
  803a28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a2c:	0f 87 9e 00 00 00    	ja     803ad0 <__udivdi3+0x108>
  803a32:	b8 01 00 00 00       	mov    $0x1,%eax
  803a37:	89 fa                	mov    %edi,%edx
  803a39:	83 c4 1c             	add    $0x1c,%esp
  803a3c:	5b                   	pop    %ebx
  803a3d:	5e                   	pop    %esi
  803a3e:	5f                   	pop    %edi
  803a3f:	5d                   	pop    %ebp
  803a40:	c3                   	ret    
  803a41:	8d 76 00             	lea    0x0(%esi),%esi
  803a44:	31 ff                	xor    %edi,%edi
  803a46:	31 c0                	xor    %eax,%eax
  803a48:	89 fa                	mov    %edi,%edx
  803a4a:	83 c4 1c             	add    $0x1c,%esp
  803a4d:	5b                   	pop    %ebx
  803a4e:	5e                   	pop    %esi
  803a4f:	5f                   	pop    %edi
  803a50:	5d                   	pop    %ebp
  803a51:	c3                   	ret    
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	89 d8                	mov    %ebx,%eax
  803a56:	f7 f7                	div    %edi
  803a58:	31 ff                	xor    %edi,%edi
  803a5a:	89 fa                	mov    %edi,%edx
  803a5c:	83 c4 1c             	add    $0x1c,%esp
  803a5f:	5b                   	pop    %ebx
  803a60:	5e                   	pop    %esi
  803a61:	5f                   	pop    %edi
  803a62:	5d                   	pop    %ebp
  803a63:	c3                   	ret    
  803a64:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a69:	89 eb                	mov    %ebp,%ebx
  803a6b:	29 fb                	sub    %edi,%ebx
  803a6d:	89 f9                	mov    %edi,%ecx
  803a6f:	d3 e6                	shl    %cl,%esi
  803a71:	89 c5                	mov    %eax,%ebp
  803a73:	88 d9                	mov    %bl,%cl
  803a75:	d3 ed                	shr    %cl,%ebp
  803a77:	89 e9                	mov    %ebp,%ecx
  803a79:	09 f1                	or     %esi,%ecx
  803a7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a7f:	89 f9                	mov    %edi,%ecx
  803a81:	d3 e0                	shl    %cl,%eax
  803a83:	89 c5                	mov    %eax,%ebp
  803a85:	89 d6                	mov    %edx,%esi
  803a87:	88 d9                	mov    %bl,%cl
  803a89:	d3 ee                	shr    %cl,%esi
  803a8b:	89 f9                	mov    %edi,%ecx
  803a8d:	d3 e2                	shl    %cl,%edx
  803a8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a93:	88 d9                	mov    %bl,%cl
  803a95:	d3 e8                	shr    %cl,%eax
  803a97:	09 c2                	or     %eax,%edx
  803a99:	89 d0                	mov    %edx,%eax
  803a9b:	89 f2                	mov    %esi,%edx
  803a9d:	f7 74 24 0c          	divl   0xc(%esp)
  803aa1:	89 d6                	mov    %edx,%esi
  803aa3:	89 c3                	mov    %eax,%ebx
  803aa5:	f7 e5                	mul    %ebp
  803aa7:	39 d6                	cmp    %edx,%esi
  803aa9:	72 19                	jb     803ac4 <__udivdi3+0xfc>
  803aab:	74 0b                	je     803ab8 <__udivdi3+0xf0>
  803aad:	89 d8                	mov    %ebx,%eax
  803aaf:	31 ff                	xor    %edi,%edi
  803ab1:	e9 58 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803abc:	89 f9                	mov    %edi,%ecx
  803abe:	d3 e2                	shl    %cl,%edx
  803ac0:	39 c2                	cmp    %eax,%edx
  803ac2:	73 e9                	jae    803aad <__udivdi3+0xe5>
  803ac4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 40 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	31 c0                	xor    %eax,%eax
  803ad2:	e9 37 ff ff ff       	jmp    803a0e <__udivdi3+0x46>
  803ad7:	90                   	nop

00803ad8 <__umoddi3>:
  803ad8:	55                   	push   %ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ae3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803af3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803af7:	89 f3                	mov    %esi,%ebx
  803af9:	89 fa                	mov    %edi,%edx
  803afb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aff:	89 34 24             	mov    %esi,(%esp)
  803b02:	85 c0                	test   %eax,%eax
  803b04:	75 1a                	jne    803b20 <__umoddi3+0x48>
  803b06:	39 f7                	cmp    %esi,%edi
  803b08:	0f 86 a2 00 00 00    	jbe    803bb0 <__umoddi3+0xd8>
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	89 f2                	mov    %esi,%edx
  803b12:	f7 f7                	div    %edi
  803b14:	89 d0                	mov    %edx,%eax
  803b16:	31 d2                	xor    %edx,%edx
  803b18:	83 c4 1c             	add    $0x1c,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5e                   	pop    %esi
  803b1d:	5f                   	pop    %edi
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    
  803b20:	39 f0                	cmp    %esi,%eax
  803b22:	0f 87 ac 00 00 00    	ja     803bd4 <__umoddi3+0xfc>
  803b28:	0f bd e8             	bsr    %eax,%ebp
  803b2b:	83 f5 1f             	xor    $0x1f,%ebp
  803b2e:	0f 84 ac 00 00 00    	je     803be0 <__umoddi3+0x108>
  803b34:	bf 20 00 00 00       	mov    $0x20,%edi
  803b39:	29 ef                	sub    %ebp,%edi
  803b3b:	89 fe                	mov    %edi,%esi
  803b3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b41:	89 e9                	mov    %ebp,%ecx
  803b43:	d3 e0                	shl    %cl,%eax
  803b45:	89 d7                	mov    %edx,%edi
  803b47:	89 f1                	mov    %esi,%ecx
  803b49:	d3 ef                	shr    %cl,%edi
  803b4b:	09 c7                	or     %eax,%edi
  803b4d:	89 e9                	mov    %ebp,%ecx
  803b4f:	d3 e2                	shl    %cl,%edx
  803b51:	89 14 24             	mov    %edx,(%esp)
  803b54:	89 d8                	mov    %ebx,%eax
  803b56:	d3 e0                	shl    %cl,%eax
  803b58:	89 c2                	mov    %eax,%edx
  803b5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b5e:	d3 e0                	shl    %cl,%eax
  803b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b64:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b68:	89 f1                	mov    %esi,%ecx
  803b6a:	d3 e8                	shr    %cl,%eax
  803b6c:	09 d0                	or     %edx,%eax
  803b6e:	d3 eb                	shr    %cl,%ebx
  803b70:	89 da                	mov    %ebx,%edx
  803b72:	f7 f7                	div    %edi
  803b74:	89 d3                	mov    %edx,%ebx
  803b76:	f7 24 24             	mull   (%esp)
  803b79:	89 c6                	mov    %eax,%esi
  803b7b:	89 d1                	mov    %edx,%ecx
  803b7d:	39 d3                	cmp    %edx,%ebx
  803b7f:	0f 82 87 00 00 00    	jb     803c0c <__umoddi3+0x134>
  803b85:	0f 84 91 00 00 00    	je     803c1c <__umoddi3+0x144>
  803b8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b8f:	29 f2                	sub    %esi,%edx
  803b91:	19 cb                	sbb    %ecx,%ebx
  803b93:	89 d8                	mov    %ebx,%eax
  803b95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b99:	d3 e0                	shl    %cl,%eax
  803b9b:	89 e9                	mov    %ebp,%ecx
  803b9d:	d3 ea                	shr    %cl,%edx
  803b9f:	09 d0                	or     %edx,%eax
  803ba1:	89 e9                	mov    %ebp,%ecx
  803ba3:	d3 eb                	shr    %cl,%ebx
  803ba5:	89 da                	mov    %ebx,%edx
  803ba7:	83 c4 1c             	add    $0x1c,%esp
  803baa:	5b                   	pop    %ebx
  803bab:	5e                   	pop    %esi
  803bac:	5f                   	pop    %edi
  803bad:	5d                   	pop    %ebp
  803bae:	c3                   	ret    
  803baf:	90                   	nop
  803bb0:	89 fd                	mov    %edi,%ebp
  803bb2:	85 ff                	test   %edi,%edi
  803bb4:	75 0b                	jne    803bc1 <__umoddi3+0xe9>
  803bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bbb:	31 d2                	xor    %edx,%edx
  803bbd:	f7 f7                	div    %edi
  803bbf:	89 c5                	mov    %eax,%ebp
  803bc1:	89 f0                	mov    %esi,%eax
  803bc3:	31 d2                	xor    %edx,%edx
  803bc5:	f7 f5                	div    %ebp
  803bc7:	89 c8                	mov    %ecx,%eax
  803bc9:	f7 f5                	div    %ebp
  803bcb:	89 d0                	mov    %edx,%eax
  803bcd:	e9 44 ff ff ff       	jmp    803b16 <__umoddi3+0x3e>
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	89 c8                	mov    %ecx,%eax
  803bd6:	89 f2                	mov    %esi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	3b 04 24             	cmp    (%esp),%eax
  803be3:	72 06                	jb     803beb <__umoddi3+0x113>
  803be5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803be9:	77 0f                	ja     803bfa <__umoddi3+0x122>
  803beb:	89 f2                	mov    %esi,%edx
  803bed:	29 f9                	sub    %edi,%ecx
  803bef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bf3:	89 14 24             	mov    %edx,(%esp)
  803bf6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bfe:	8b 14 24             	mov    (%esp),%edx
  803c01:	83 c4 1c             	add    $0x1c,%esp
  803c04:	5b                   	pop    %ebx
  803c05:	5e                   	pop    %esi
  803c06:	5f                   	pop    %edi
  803c07:	5d                   	pop    %ebp
  803c08:	c3                   	ret    
  803c09:	8d 76 00             	lea    0x0(%esi),%esi
  803c0c:	2b 04 24             	sub    (%esp),%eax
  803c0f:	19 fa                	sbb    %edi,%edx
  803c11:	89 d1                	mov    %edx,%ecx
  803c13:	89 c6                	mov    %eax,%esi
  803c15:	e9 71 ff ff ff       	jmp    803b8b <__umoddi3+0xb3>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c20:	72 ea                	jb     803c0c <__umoddi3+0x134>
  803c22:	89 d9                	mov    %ebx,%ecx
  803c24:	e9 62 ff ff ff       	jmp    803b8b <__umoddi3+0xb3>
