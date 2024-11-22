
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
  80003e:	e8 c2 18 00 00       	call   801905 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 3c 80 00       	push   $0x803c40
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 97 14 00 00       	call   8014ed <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 3c 80 00       	push   $0x803c42
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 81 14 00 00       	call   8014ed <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 3c 80 00       	push   $0x803c49
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 6b 14 00 00       	call   8014ed <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 a4 18 00 00       	call   801938 <sys_get_virtual_time>
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
  8000b7:	e8 7c 36 00 00       	call   803738 <env_sleep>
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
  8000d0:	e8 63 18 00 00       	call   801938 <sys_get_virtual_time>
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
  8000f8:	e8 3b 36 00 00       	call   803738 <env_sleep>
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
  80010f:	e8 24 18 00 00       	call   801938 <sys_get_virtual_time>
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
  800137:	e8 fc 35 00 00       	call   803738 <env_sleep>
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
  800158:	e8 82 35 00 00       	call   8036df <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 a8 35 00 00       	call   803713 <signal_semaphore>
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
  800184:	e8 63 17 00 00       	call   8018ec <sys_getenvindex>
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
  8001f2:	e8 79 14 00 00       	call   801670 <sys_lock_cons>
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
  80028c:	e8 f9 13 00 00       	call   80168a <sys_unlock_cons>
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
  8002a4:	e8 0f 16 00 00       	call   8018b8 <sys_destroy_env>
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
  8002b5:	e8 64 16 00 00       	call   80191e <sys_exit_env>
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
  800303:	e8 26 13 00 00       	call   80162e <sys_cputs>
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
  80037a:	e8 af 12 00 00       	call   80162e <sys_cputs>
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
  8003c4:	e8 a7 12 00 00       	call   801670 <sys_lock_cons>
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
  8003e4:	e8 a1 12 00 00       	call   80168a <sys_unlock_cons>
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
  80042e:	e8 a5 35 00 00       	call   8039d8 <__udivdi3>
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
  80047e:	e8 65 36 00 00       	call   803ae8 <__umoddi3>
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
  801126:	e8 c1 26 00 00       	call   8037ec <_panic>

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
  801137:	e8 9d 0a 00 00       	call   801bd9 <sys_sbrk>
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
  8011b2:	e8 a6 08 00 00       	call   801a5d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 e6 0d 00 00       	call   801fac <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 b8 08 00 00       	call   801a8e <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 7f 12 00 00       	call   802468 <alloc_block_BF>
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
  80134a:	e8 c1 08 00 00       	call   801c10 <sys_allocate_user_mem>
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
  801392:	e8 95 08 00 00       	call   801c2c <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 c8 1a 00 00       	call   802e70 <free_block>
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
  80143a:	e8 b5 07 00 00       	call   801bf4 <sys_free_user_mem>
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
  801457:	e8 90 23 00 00       	call   8037ec <_panic>
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
  801475:	eb 74                	jmp    8014eb <smalloc+0x8d>
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
  8014aa:	eb 3f                	jmp    8014eb <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014ac:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	e8 3c 03 00 00       	call   8017fb <sys_createSharedObject>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014c9:	74 06                	je     8014d1 <smalloc+0x73>
  8014cb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014cf:	75 07                	jne    8014d8 <smalloc+0x7a>
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d6:	eb 13                	jmp    8014eb <smalloc+0x8d>
	 cprintf("153\n");
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	68 4e 41 80 00       	push   $0x80414e
  8014e0:	e8 ac ee ff ff       	call   800391 <cprintf>
  8014e5:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8014e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	ff 75 08             	pushl  0x8(%ebp)
  8014fc:	e8 24 03 00 00       	call   801825 <sys_getSizeOfSharedObject>
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801507:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80150b:	75 07                	jne    801514 <sget+0x27>
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
  801512:	eb 5c                	jmp    801570 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80151a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801521:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	39 d0                	cmp    %edx,%eax
  801529:	7d 02                	jge    80152d <sget+0x40>
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	50                   	push   %eax
  801531:	e8 0b fc ff ff       	call   801141 <malloc>
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80153c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801540:	75 07                	jne    801549 <sget+0x5c>
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
  801547:	eb 27                	jmp    801570 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	ff 75 e8             	pushl  -0x18(%ebp)
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	ff 75 08             	pushl  0x8(%ebp)
  801555:	e8 e8 02 00 00       	call   801842 <sys_getSharedObject>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801560:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801564:	75 07                	jne    80156d <sget+0x80>
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	eb 03                	jmp    801570 <sget+0x83>
	return ptr;
  80156d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	68 54 41 80 00       	push   $0x804154
  801580:	68 c2 00 00 00       	push   $0xc2
  801585:	68 42 41 80 00       	push   $0x804142
  80158a:	e8 5d 22 00 00       	call   8037ec <_panic>

0080158f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	68 78 41 80 00       	push   $0x804178
  80159d:	68 d9 00 00 00       	push   $0xd9
  8015a2:	68 42 41 80 00       	push   $0x804142
  8015a7:	e8 40 22 00 00       	call   8037ec <_panic>

008015ac <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 9e 41 80 00       	push   $0x80419e
  8015ba:	68 e5 00 00 00       	push   $0xe5
  8015bf:	68 42 41 80 00       	push   $0x804142
  8015c4:	e8 23 22 00 00       	call   8037ec <_panic>

008015c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 9e 41 80 00       	push   $0x80419e
  8015d7:	68 ea 00 00 00       	push   $0xea
  8015dc:	68 42 41 80 00       	push   $0x804142
  8015e1:	e8 06 22 00 00       	call   8037ec <_panic>

008015e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 9e 41 80 00       	push   $0x80419e
  8015f4:	68 ef 00 00 00       	push   $0xef
  8015f9:	68 42 41 80 00       	push   $0x804142
  8015fe:	e8 e9 21 00 00       	call   8037ec <_panic>

00801603 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801612:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801615:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801618:	8b 7d 18             	mov    0x18(%ebp),%edi
  80161b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161e:	cd 30                	int    $0x30
  801620:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5f                   	pop    %edi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80163a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	52                   	push   %edx
  801646:	ff 75 0c             	pushl  0xc(%ebp)
  801649:	50                   	push   %eax
  80164a:	6a 00                	push   $0x0
  80164c:	e8 b2 ff ff ff       	call   801603 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_cgetc>:

int
sys_cgetc(void)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 02                	push   $0x2
  801666:	e8 98 ff ff ff       	call   801603 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 03                	push   $0x3
  80167f:	e8 7f ff ff ff       	call   801603 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	90                   	nop
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 04                	push   $0x4
  801699:	e8 65 ff ff ff       	call   801603 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	90                   	nop
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 08                	push   $0x8
  8016b7:	e8 47 ff ff ff       	call   801603 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
  8016d7:	51                   	push   %ecx
  8016d8:	52                   	push   %edx
  8016d9:	50                   	push   %eax
  8016da:	6a 09                	push   $0x9
  8016dc:	e8 22 ff ff ff       	call   801603 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5e                   	pop    %esi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	6a 0a                	push   $0xa
  8016fe:	e8 00 ff ff ff       	call   801603 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	6a 0b                	push   $0xb
  801719:	e8 e5 fe ff ff       	call   801603 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 0c                	push   $0xc
  801732:	e8 cc fe ff ff       	call   801603 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 0d                	push   $0xd
  80174b:	e8 b3 fe ff ff       	call   801603 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 0e                	push   $0xe
  801764:	e8 9a fe ff ff       	call   801603 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 0f                	push   $0xf
  80177d:	e8 81 fe ff ff       	call   801603 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 10                	push   $0x10
  801797:	e8 67 fe ff ff       	call   801603 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 11                	push   $0x11
  8017b0:	e8 4e fe ff ff       	call   801603 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	90                   	nop
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_cputc>:

void
sys_cputc(const char c)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	50                   	push   %eax
  8017d4:	6a 01                	push   $0x1
  8017d6:	e8 28 fe ff ff       	call   801603 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	90                   	nop
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 14                	push   $0x14
  8017f0:	e8 0e fe ff ff       	call   801603 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	90                   	nop
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801807:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80180a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	51                   	push   %ecx
  801814:	52                   	push   %edx
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	50                   	push   %eax
  801819:	6a 15                	push   $0x15
  80181b:	e8 e3 fd ff ff       	call   801603 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	52                   	push   %edx
  801835:	50                   	push   %eax
  801836:	6a 16                	push   $0x16
  801838:	e8 c6 fd ff ff       	call   801603 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801845:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	51                   	push   %ecx
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 17                	push   $0x17
  801857:	e8 a7 fd ff ff       	call   801603 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 18                	push   $0x18
  801874:	e8 8a fd ff ff       	call   801603 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	ff 75 14             	pushl  0x14(%ebp)
  801889:	ff 75 10             	pushl  0x10(%ebp)
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	50                   	push   %eax
  801890:	6a 19                	push   $0x19
  801892:	e8 6c fd ff ff       	call   801603 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	50                   	push   %eax
  8018ab:	6a 1a                	push   $0x1a
  8018ad:	e8 51 fd ff ff       	call   801603 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	50                   	push   %eax
  8018c7:	6a 1b                	push   $0x1b
  8018c9:	e8 35 fd ff ff       	call   801603 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 05                	push   $0x5
  8018e2:	e8 1c fd ff ff       	call   801603 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 06                	push   $0x6
  8018fb:	e8 03 fd ff ff       	call   801603 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 07                	push   $0x7
  801914:	e8 ea fc ff ff       	call   801603 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_exit_env>:


void sys_exit_env(void)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 1c                	push   $0x1c
  80192d:	e8 d1 fc ff ff       	call   801603 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	90                   	nop
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80193e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801941:	8d 50 04             	lea    0x4(%eax),%edx
  801944:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 1d                	push   $0x1d
  801951:	e8 ad fc ff ff       	call   801603 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return result;
  801959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80195c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801962:	89 01                	mov    %eax,(%ecx)
  801964:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	c9                   	leave  
  80196b:	c2 04 00             	ret    $0x4

0080196e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	ff 75 08             	pushl  0x8(%ebp)
  80197e:	6a 13                	push   $0x13
  801980:	e8 7e fc ff ff       	call   801603 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
	return ;
  801988:	90                   	nop
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_rcr2>:
uint32 sys_rcr2()
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 1e                	push   $0x1e
  80199a:	e8 64 fc ff ff       	call   801603 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019b0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	50                   	push   %eax
  8019bd:	6a 1f                	push   $0x1f
  8019bf:	e8 3f fc ff ff       	call   801603 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <rsttst>:
void rsttst()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 21                	push   $0x21
  8019d9:	e8 25 fc ff ff       	call   801603 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e1:	90                   	nop
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019f0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f7:	52                   	push   %edx
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 10             	pushl  0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	6a 20                	push   $0x20
  801a04:	e8 fa fb ff ff       	call   801603 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0c:	90                   	nop
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <chktst>:
void chktst(uint32 n)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	6a 22                	push   $0x22
  801a1f:	e8 df fb ff ff       	call   801603 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
	return ;
  801a27:	90                   	nop
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <inctst>:

void inctst()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 23                	push   $0x23
  801a39:	e8 c5 fb ff ff       	call   801603 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a41:	90                   	nop
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <gettst>:
uint32 gettst()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 24                	push   $0x24
  801a53:	e8 ab fb ff ff       	call   801603 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 25                	push   $0x25
  801a6f:	e8 8f fb ff ff       	call   801603 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
  801a77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a7a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a7e:	75 07                	jne    801a87 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a80:	b8 01 00 00 00       	mov    $0x1,%eax
  801a85:	eb 05                	jmp    801a8c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 25                	push   $0x25
  801aa0:	e8 5e fb ff ff       	call   801603 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
  801aa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aaf:	75 07                	jne    801ab8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ab1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab6:	eb 05                	jmp    801abd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 25                	push   $0x25
  801ad1:	e8 2d fb ff ff       	call   801603 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
  801ad9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801adc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ae0:	75 07                	jne    801ae9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ae2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae7:	eb 05                	jmp    801aee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 25                	push   $0x25
  801b02:	e8 fc fa ff ff       	call   801603 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
  801b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b0d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b11:	75 07                	jne    801b1a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b13:	b8 01 00 00 00       	mov    $0x1,%eax
  801b18:	eb 05                	jmp    801b1f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 08             	pushl  0x8(%ebp)
  801b2f:	6a 26                	push   $0x26
  801b31:	e8 cd fa ff ff       	call   801603 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
	return ;
  801b39:	90                   	nop
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	53                   	push   %ebx
  801b4f:	51                   	push   %ecx
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 27                	push   $0x27
  801b54:	e8 aa fa ff ff       	call   801603 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 28                	push   $0x28
  801b74:	e8 8a fa ff ff       	call   801603 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b81:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	51                   	push   %ecx
  801b8d:	ff 75 10             	pushl  0x10(%ebp)
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 29                	push   $0x29
  801b94:	e8 6a fa ff ff       	call   801603 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	6a 12                	push   $0x12
  801bb0:	e8 4e fa ff ff       	call   801603 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 2a                	push   $0x2a
  801bce:	e8 30 fa ff ff       	call   801603 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
	return;
  801bd6:	90                   	nop
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	50                   	push   %eax
  801be8:	6a 2b                	push   $0x2b
  801bea:	e8 14 fa ff ff       	call   801603 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	6a 2c                	push   $0x2c
  801c05:	e8 f9 f9 ff ff       	call   801603 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return;
  801c0d:	90                   	nop
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 2d                	push   $0x2d
  801c21:	e8 dd f9 ff ff       	call   801603 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	83 e8 04             	sub    $0x4,%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c3e:	8b 00                	mov    (%eax),%eax
  801c40:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	83 e8 04             	sub    $0x4,%eax
  801c51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	83 e0 01             	and    $0x1,%eax
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	0f 94 c0             	sete   %al
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	83 f8 02             	cmp    $0x2,%eax
  801c76:	74 2b                	je     801ca3 <alloc_block+0x40>
  801c78:	83 f8 02             	cmp    $0x2,%eax
  801c7b:	7f 07                	jg     801c84 <alloc_block+0x21>
  801c7d:	83 f8 01             	cmp    $0x1,%eax
  801c80:	74 0e                	je     801c90 <alloc_block+0x2d>
  801c82:	eb 58                	jmp    801cdc <alloc_block+0x79>
  801c84:	83 f8 03             	cmp    $0x3,%eax
  801c87:	74 2d                	je     801cb6 <alloc_block+0x53>
  801c89:	83 f8 04             	cmp    $0x4,%eax
  801c8c:	74 3b                	je     801cc9 <alloc_block+0x66>
  801c8e:	eb 4c                	jmp    801cdc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	ff 75 08             	pushl  0x8(%ebp)
  801c96:	e8 11 03 00 00       	call   801fac <alloc_block_FF>
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ca1:	eb 4a                	jmp    801ced <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	e8 fa 19 00 00       	call   8036a8 <alloc_block_NF>
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cb4:	eb 37                	jmp    801ced <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	ff 75 08             	pushl  0x8(%ebp)
  801cbc:	e8 a7 07 00 00       	call   802468 <alloc_block_BF>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cc7:	eb 24                	jmp    801ced <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cc9:	83 ec 0c             	sub    $0xc,%esp
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	e8 b7 19 00 00       	call   80368b <alloc_block_WF>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cda:	eb 11                	jmp    801ced <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	68 b0 41 80 00       	push   $0x8041b0
  801ce4:	e8 a8 e6 ff ff       	call   800391 <cprintf>
  801ce9:	83 c4 10             	add    $0x10,%esp
		break;
  801cec:	90                   	nop
	}
	return va;
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	68 d0 41 80 00       	push   $0x8041d0
  801d01:	e8 8b e6 ff ff       	call   800391 <cprintf>
  801d06:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d09:	83 ec 0c             	sub    $0xc,%esp
  801d0c:	68 fb 41 80 00       	push   $0x8041fb
  801d11:	e8 7b e6 ff ff       	call   800391 <cprintf>
  801d16:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1f:	eb 37                	jmp    801d58 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	ff 75 f4             	pushl  -0xc(%ebp)
  801d27:	e8 19 ff ff ff       	call   801c45 <is_free_block>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	0f be d8             	movsbl %al,%ebx
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	e8 ef fe ff ff       	call   801c2c <get_block_size>
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	53                   	push   %ebx
  801d44:	50                   	push   %eax
  801d45:	68 13 42 80 00       	push   $0x804213
  801d4a:	e8 42 e6 ff ff       	call   800391 <cprintf>
  801d4f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5c:	74 07                	je     801d65 <print_blocks_list+0x73>
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	8b 00                	mov    (%eax),%eax
  801d63:	eb 05                	jmp    801d6a <print_blocks_list+0x78>
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6a:	89 45 10             	mov    %eax,0x10(%ebp)
  801d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d70:	85 c0                	test   %eax,%eax
  801d72:	75 ad                	jne    801d21 <print_blocks_list+0x2f>
  801d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d78:	75 a7                	jne    801d21 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 d0 41 80 00       	push   $0x8041d0
  801d82:	e8 0a e6 ff ff       	call   800391 <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp

}
  801d8a:	90                   	nop
  801d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d99:	83 e0 01             	and    $0x1,%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 03                	je     801da3 <initialize_dynamic_allocator+0x13>
  801da0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801da3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da7:	0f 84 c7 01 00 00    	je     801f74 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801dad:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801db4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801db7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbd:	01 d0                	add    %edx,%eax
  801dbf:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801dc4:	0f 87 ad 01 00 00    	ja     801f77 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	0f 89 a5 01 00 00    	jns    801f7a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddb:	01 d0                	add    %edx,%eax
  801ddd:	83 e8 04             	sub    $0x4,%eax
  801de0:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801de5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801dec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df4:	e9 87 00 00 00       	jmp    801e80 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfd:	75 14                	jne    801e13 <initialize_dynamic_allocator+0x83>
  801dff:	83 ec 04             	sub    $0x4,%esp
  801e02:	68 2b 42 80 00       	push   $0x80422b
  801e07:	6a 79                	push   $0x79
  801e09:	68 49 42 80 00       	push   $0x804249
  801e0e:	e8 d9 19 00 00       	call   8037ec <_panic>
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	74 10                	je     801e2c <initialize_dynamic_allocator+0x9c>
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	8b 52 04             	mov    0x4(%edx),%edx
  801e27:	89 50 04             	mov    %edx,0x4(%eax)
  801e2a:	eb 0b                	jmp    801e37 <initialize_dynamic_allocator+0xa7>
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 40 04             	mov    0x4(%eax),%eax
  801e32:	a3 30 50 80 00       	mov    %eax,0x805030
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	8b 40 04             	mov    0x4(%eax),%eax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	74 0f                	je     801e50 <initialize_dynamic_allocator+0xc0>
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 40 04             	mov    0x4(%eax),%eax
  801e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4a:	8b 12                	mov    (%edx),%edx
  801e4c:	89 10                	mov    %edx,(%eax)
  801e4e:	eb 0a                	jmp    801e5a <initialize_dynamic_allocator+0xca>
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	8b 00                	mov    (%eax),%eax
  801e55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6d:	a1 38 50 80 00       	mov    0x805038,%eax
  801e72:	48                   	dec    %eax
  801e73:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e78:	a1 34 50 80 00       	mov    0x805034,%eax
  801e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e84:	74 07                	je     801e8d <initialize_dynamic_allocator+0xfd>
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 00                	mov    (%eax),%eax
  801e8b:	eb 05                	jmp    801e92 <initialize_dynamic_allocator+0x102>
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	a3 34 50 80 00       	mov    %eax,0x805034
  801e97:	a1 34 50 80 00       	mov    0x805034,%eax
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	0f 85 55 ff ff ff    	jne    801df9 <initialize_dynamic_allocator+0x69>
  801ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea8:	0f 85 4b ff ff ff    	jne    801df9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ebd:	a1 44 50 80 00       	mov    0x805044,%eax
  801ec2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801ec7:	a1 40 50 80 00       	mov    0x805040,%eax
  801ecc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	83 c0 08             	add    $0x8,%eax
  801ed8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	83 c0 04             	add    $0x4,%eax
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	83 ea 08             	sub    $0x8,%edx
  801ee7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	01 d0                	add    %edx,%eax
  801ef1:	83 e8 08             	sub    $0x8,%eax
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	83 ea 08             	sub    $0x8,%edx
  801efa:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f13:	75 17                	jne    801f2c <initialize_dynamic_allocator+0x19c>
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	68 64 42 80 00       	push   $0x804264
  801f1d:	68 90 00 00 00       	push   $0x90
  801f22:	68 49 42 80 00       	push   $0x804249
  801f27:	e8 c0 18 00 00       	call   8037ec <_panic>
  801f2c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f35:	89 10                	mov    %edx,(%eax)
  801f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3a:	8b 00                	mov    (%eax),%eax
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	74 0d                	je     801f4d <initialize_dynamic_allocator+0x1bd>
  801f40:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f48:	89 50 04             	mov    %edx,0x4(%eax)
  801f4b:	eb 08                	jmp    801f55 <initialize_dynamic_allocator+0x1c5>
  801f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f50:	a3 30 50 80 00       	mov    %eax,0x805030
  801f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f67:	a1 38 50 80 00       	mov    0x805038,%eax
  801f6c:	40                   	inc    %eax
  801f6d:	a3 38 50 80 00       	mov    %eax,0x805038
  801f72:	eb 07                	jmp    801f7b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f74:	90                   	nop
  801f75:	eb 04                	jmp    801f7b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f77:	90                   	nop
  801f78:	eb 01                	jmp    801f7b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f7a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f80:	8b 45 10             	mov    0x10(%ebp),%eax
  801f83:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	83 e8 04             	sub    $0x4,%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	83 e0 fe             	and    $0xfffffffe,%eax
  801f9c:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	01 c2                	add    %eax,%edx
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	89 02                	mov    %eax,(%edx)
}
  801fa9:	90                   	nop
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	83 e0 01             	and    $0x1,%eax
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	74 03                	je     801fbf <alloc_block_FF+0x13>
  801fbc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fbf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fc3:	77 07                	ja     801fcc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fc5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fcc:	a1 24 50 80 00       	mov    0x805024,%eax
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	75 73                	jne    802048 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	83 c0 10             	add    $0x10,%eax
  801fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801fde:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	01 d0                	add    %edx,%eax
  801fed:	48                   	dec    %eax
  801fee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff9:	f7 75 ec             	divl   -0x14(%ebp)
  801ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fff:	29 d0                	sub    %edx,%eax
  802001:	c1 e8 0c             	shr    $0xc,%eax
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	50                   	push   %eax
  802008:	e8 1e f1 ff ff       	call   80112b <sbrk>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	6a 00                	push   $0x0
  802018:	e8 0e f1 ff ff       	call   80112b <sbrk>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802023:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802026:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802029:	83 ec 08             	sub    $0x8,%esp
  80202c:	50                   	push   %eax
  80202d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802030:	e8 5b fd ff ff       	call   801d90 <initialize_dynamic_allocator>
  802035:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	68 87 42 80 00       	push   $0x804287
  802040:	e8 4c e3 ff ff       	call   800391 <cprintf>
  802045:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802048:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204c:	75 0a                	jne    802058 <alloc_block_FF+0xac>
	        return NULL;
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	e9 0e 04 00 00       	jmp    802466 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80205f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802064:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802067:	e9 f3 02 00 00       	jmp    80235f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	ff 75 bc             	pushl  -0x44(%ebp)
  802078:	e8 af fb ff ff       	call   801c2c <get_block_size>
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	83 c0 08             	add    $0x8,%eax
  802089:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80208c:	0f 87 c5 02 00 00    	ja     802357 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	83 c0 18             	add    $0x18,%eax
  802098:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80209b:	0f 87 19 02 00 00    	ja     8022ba <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8020a7:	83 e8 08             	sub    $0x8,%eax
  8020aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8d 50 08             	lea    0x8(%eax),%edx
  8020b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	83 c0 08             	add    $0x8,%eax
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	6a 01                	push   $0x1
  8020c6:	50                   	push   %eax
  8020c7:	ff 75 bc             	pushl  -0x44(%ebp)
  8020ca:	e8 ae fe ff ff       	call   801f7d <set_block_data>
  8020cf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 40 04             	mov    0x4(%eax),%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 68                	jne    802144 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020dc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020e0:	75 17                	jne    8020f9 <alloc_block_FF+0x14d>
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	68 64 42 80 00       	push   $0x804264
  8020ea:	68 d7 00 00 00       	push   $0xd7
  8020ef:	68 49 42 80 00       	push   $0x804249
  8020f4:	e8 f3 16 00 00       	call   8037ec <_panic>
  8020f9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802102:	89 10                	mov    %edx,(%eax)
  802104:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 0d                	je     80211a <alloc_block_FF+0x16e>
  80210d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802112:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802115:	89 50 04             	mov    %edx,0x4(%eax)
  802118:	eb 08                	jmp    802122 <alloc_block_FF+0x176>
  80211a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211d:	a3 30 50 80 00       	mov    %eax,0x805030
  802122:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802125:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80212a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802134:	a1 38 50 80 00       	mov    0x805038,%eax
  802139:	40                   	inc    %eax
  80213a:	a3 38 50 80 00       	mov    %eax,0x805038
  80213f:	e9 dc 00 00 00       	jmp    802220 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 00                	mov    (%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	75 65                	jne    8021b2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80214d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802151:	75 17                	jne    80216a <alloc_block_FF+0x1be>
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	68 98 42 80 00       	push   $0x804298
  80215b:	68 db 00 00 00       	push   $0xdb
  802160:	68 49 42 80 00       	push   $0x804249
  802165:	e8 82 16 00 00       	call   8037ec <_panic>
  80216a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802170:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802173:	89 50 04             	mov    %edx,0x4(%eax)
  802176:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802179:	8b 40 04             	mov    0x4(%eax),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 0c                	je     80218c <alloc_block_FF+0x1e0>
  802180:	a1 30 50 80 00       	mov    0x805030,%eax
  802185:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802188:	89 10                	mov    %edx,(%eax)
  80218a:	eb 08                	jmp    802194 <alloc_block_FF+0x1e8>
  80218c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802194:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802197:	a3 30 50 80 00       	mov    %eax,0x805030
  80219c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021aa:	40                   	inc    %eax
  8021ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8021b0:	eb 6e                	jmp    802220 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b6:	74 06                	je     8021be <alloc_block_FF+0x212>
  8021b8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021bc:	75 17                	jne    8021d5 <alloc_block_FF+0x229>
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 bc 42 80 00       	push   $0x8042bc
  8021c6:	68 df 00 00 00       	push   $0xdf
  8021cb:	68 49 42 80 00       	push   $0x804249
  8021d0:	e8 17 16 00 00       	call   8037ec <_panic>
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	8b 10                	mov    (%eax),%edx
  8021da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021dd:	89 10                	mov    %edx,(%eax)
  8021df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 0b                	je     8021f3 <alloc_block_FF+0x247>
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	89 50 04             	mov    %edx,0x4(%eax)
  802204:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802207:	8b 00                	mov    (%eax),%eax
  802209:	85 c0                	test   %eax,%eax
  80220b:	75 08                	jne    802215 <alloc_block_FF+0x269>
  80220d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802210:	a3 30 50 80 00       	mov    %eax,0x805030
  802215:	a1 38 50 80 00       	mov    0x805038,%eax
  80221a:	40                   	inc    %eax
  80221b:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802224:	75 17                	jne    80223d <alloc_block_FF+0x291>
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	68 2b 42 80 00       	push   $0x80422b
  80222e:	68 e1 00 00 00       	push   $0xe1
  802233:	68 49 42 80 00       	push   $0x804249
  802238:	e8 af 15 00 00       	call   8037ec <_panic>
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 00                	mov    (%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	74 10                	je     802256 <alloc_block_FF+0x2aa>
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224e:	8b 52 04             	mov    0x4(%edx),%edx
  802251:	89 50 04             	mov    %edx,0x4(%eax)
  802254:	eb 0b                	jmp    802261 <alloc_block_FF+0x2b5>
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 40 04             	mov    0x4(%eax),%eax
  80225c:	a3 30 50 80 00       	mov    %eax,0x805030
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 40 04             	mov    0x4(%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 0f                	je     80227a <alloc_block_FF+0x2ce>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802274:	8b 12                	mov    (%edx),%edx
  802276:	89 10                	mov    %edx,(%eax)
  802278:	eb 0a                	jmp    802284 <alloc_block_FF+0x2d8>
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802297:	a1 38 50 80 00       	mov    0x805038,%eax
  80229c:	48                   	dec    %eax
  80229d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	6a 00                	push   $0x0
  8022a7:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022aa:	ff 75 b0             	pushl  -0x50(%ebp)
  8022ad:	e8 cb fc ff ff       	call   801f7d <set_block_data>
  8022b2:	83 c4 10             	add    $0x10,%esp
  8022b5:	e9 95 00 00 00       	jmp    80234f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	6a 01                	push   $0x1
  8022bf:	ff 75 b8             	pushl  -0x48(%ebp)
  8022c2:	ff 75 bc             	pushl  -0x44(%ebp)
  8022c5:	e8 b3 fc ff ff       	call   801f7d <set_block_data>
  8022ca:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d1:	75 17                	jne    8022ea <alloc_block_FF+0x33e>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 2b 42 80 00       	push   $0x80422b
  8022db:	68 e8 00 00 00       	push   $0xe8
  8022e0:	68 49 42 80 00       	push   $0x804249
  8022e5:	e8 02 15 00 00       	call   8037ec <_panic>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 10                	je     802303 <alloc_block_FF+0x357>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fb:	8b 52 04             	mov    0x4(%edx),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	eb 0b                	jmp    80230e <alloc_block_FF+0x362>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 04             	mov    0x4(%eax),%eax
  802309:	a3 30 50 80 00       	mov    %eax,0x805030
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 04             	mov    0x4(%eax),%eax
  802314:	85 c0                	test   %eax,%eax
  802316:	74 0f                	je     802327 <alloc_block_FF+0x37b>
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 04             	mov    0x4(%eax),%eax
  80231e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802321:	8b 12                	mov    (%edx),%edx
  802323:	89 10                	mov    %edx,(%eax)
  802325:	eb 0a                	jmp    802331 <alloc_block_FF+0x385>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 00                	mov    (%eax),%eax
  80232c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802344:	a1 38 50 80 00       	mov    0x805038,%eax
  802349:	48                   	dec    %eax
  80234a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80234f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802352:	e9 0f 01 00 00       	jmp    802466 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802357:	a1 34 50 80 00       	mov    0x805034,%eax
  80235c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802363:	74 07                	je     80236c <alloc_block_FF+0x3c0>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	eb 05                	jmp    802371 <alloc_block_FF+0x3c5>
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	a3 34 50 80 00       	mov    %eax,0x805034
  802376:	a1 34 50 80 00       	mov    0x805034,%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	0f 85 e9 fc ff ff    	jne    80206c <alloc_block_FF+0xc0>
  802383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802387:	0f 85 df fc ff ff    	jne    80206c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	83 c0 08             	add    $0x8,%eax
  802393:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802396:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80239d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	48                   	dec    %eax
  8023a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b1:	f7 75 d8             	divl   -0x28(%ebp)
  8023b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b7:	29 d0                	sub    %edx,%eax
  8023b9:	c1 e8 0c             	shr    $0xc,%eax
  8023bc:	83 ec 0c             	sub    $0xc,%esp
  8023bf:	50                   	push   %eax
  8023c0:	e8 66 ed ff ff       	call   80112b <sbrk>
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023cb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023cf:	75 0a                	jne    8023db <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	e9 8b 00 00 00       	jmp    802466 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023db:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023e8:	01 d0                	add    %edx,%eax
  8023ea:	48                   	dec    %eax
  8023eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f6:	f7 75 cc             	divl   -0x34(%ebp)
  8023f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023fc:	29 d0                	sub    %edx,%eax
  8023fe:	8d 50 fc             	lea    -0x4(%eax),%edx
  802401:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802404:	01 d0                	add    %edx,%eax
  802406:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80240b:	a1 40 50 80 00       	mov    0x805040,%eax
  802410:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802416:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80241d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802420:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802423:	01 d0                	add    %edx,%eax
  802425:	48                   	dec    %eax
  802426:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802429:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80242c:	ba 00 00 00 00       	mov    $0x0,%edx
  802431:	f7 75 c4             	divl   -0x3c(%ebp)
  802434:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802437:	29 d0                	sub    %edx,%eax
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	6a 01                	push   $0x1
  80243e:	50                   	push   %eax
  80243f:	ff 75 d0             	pushl  -0x30(%ebp)
  802442:	e8 36 fb ff ff       	call   801f7d <set_block_data>
  802447:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80244a:	83 ec 0c             	sub    $0xc,%esp
  80244d:	ff 75 d0             	pushl  -0x30(%ebp)
  802450:	e8 1b 0a 00 00       	call   802e70 <free_block>
  802455:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	ff 75 08             	pushl  0x8(%ebp)
  80245e:	e8 49 fb ff ff       	call   801fac <alloc_block_FF>
  802463:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	83 e0 01             	and    $0x1,%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 03                	je     80247b <alloc_block_BF+0x13>
  802478:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80247b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80247f:	77 07                	ja     802488 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802481:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802488:	a1 24 50 80 00       	mov    0x805024,%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	75 73                	jne    802504 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	83 c0 10             	add    $0x10,%eax
  802497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80249a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	48                   	dec    %eax
  8024aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b5:	f7 75 e0             	divl   -0x20(%ebp)
  8024b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024bb:	29 d0                	sub    %edx,%eax
  8024bd:	c1 e8 0c             	shr    $0xc,%eax
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	50                   	push   %eax
  8024c4:	e8 62 ec ff ff       	call   80112b <sbrk>
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	6a 00                	push   $0x0
  8024d4:	e8 52 ec ff ff       	call   80112b <sbrk>
  8024d9:	83 c4 10             	add    $0x10,%esp
  8024dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024e5:	83 ec 08             	sub    $0x8,%esp
  8024e8:	50                   	push   %eax
  8024e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8024ec:	e8 9f f8 ff ff       	call   801d90 <initialize_dynamic_allocator>
  8024f1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024f4:	83 ec 0c             	sub    $0xc,%esp
  8024f7:	68 87 42 80 00       	push   $0x804287
  8024fc:	e8 90 de ff ff       	call   800391 <cprintf>
  802501:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80250b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802512:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802519:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802520:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802528:	e9 1d 01 00 00       	jmp    80264a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802533:	83 ec 0c             	sub    $0xc,%esp
  802536:	ff 75 a8             	pushl  -0x58(%ebp)
  802539:	e8 ee f6 ff ff       	call   801c2c <get_block_size>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	83 c0 08             	add    $0x8,%eax
  80254a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80254d:	0f 87 ef 00 00 00    	ja     802642 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	83 c0 18             	add    $0x18,%eax
  802559:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80255c:	77 1d                	ja     80257b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80255e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802561:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802564:	0f 86 d8 00 00 00    	jbe    802642 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80256a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80256d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802570:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802573:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802576:	e9 c7 00 00 00       	jmp    802642 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	83 c0 08             	add    $0x8,%eax
  802581:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802584:	0f 85 9d 00 00 00    	jne    802627 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	6a 01                	push   $0x1
  80258f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802592:	ff 75 a8             	pushl  -0x58(%ebp)
  802595:	e8 e3 f9 ff ff       	call   801f7d <set_block_data>
  80259a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80259d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a1:	75 17                	jne    8025ba <alloc_block_BF+0x152>
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 2b 42 80 00       	push   $0x80422b
  8025ab:	68 2c 01 00 00       	push   $0x12c
  8025b0:	68 49 42 80 00       	push   $0x804249
  8025b5:	e8 32 12 00 00       	call   8037ec <_panic>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 10                	je     8025d3 <alloc_block_BF+0x16b>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ce:	89 50 04             	mov    %edx,0x4(%eax)
  8025d1:	eb 0b                	jmp    8025de <alloc_block_BF+0x176>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0f                	je     8025f7 <alloc_block_BF+0x18f>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f1:	8b 12                	mov    (%edx),%edx
  8025f3:	89 10                	mov    %edx,(%eax)
  8025f5:	eb 0a                	jmp    802601 <alloc_block_BF+0x199>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802614:	a1 38 50 80 00       	mov    0x805038,%eax
  802619:	48                   	dec    %eax
  80261a:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80261f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802622:	e9 24 04 00 00       	jmp    802a4b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80262d:	76 13                	jbe    802642 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80262f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802636:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802639:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80263c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80263f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802642:	a1 34 50 80 00       	mov    0x805034,%eax
  802647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	74 07                	je     802657 <alloc_block_BF+0x1ef>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	eb 05                	jmp    80265c <alloc_block_BF+0x1f4>
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	a3 34 50 80 00       	mov    %eax,0x805034
  802661:	a1 34 50 80 00       	mov    0x805034,%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	0f 85 bf fe ff ff    	jne    80252d <alloc_block_BF+0xc5>
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	0f 85 b5 fe ff ff    	jne    80252d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802678:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80267c:	0f 84 26 02 00 00    	je     8028a8 <alloc_block_BF+0x440>
  802682:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802686:	0f 85 1c 02 00 00    	jne    8028a8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80268c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268f:	2b 45 08             	sub    0x8(%ebp),%eax
  802692:	83 e8 08             	sub    $0x8,%eax
  802695:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	8d 50 08             	lea    0x8(%eax),%edx
  80269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	83 c0 08             	add    $0x8,%eax
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	6a 01                	push   $0x1
  8026b1:	50                   	push   %eax
  8026b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b5:	e8 c3 f8 ff ff       	call   801f7d <set_block_data>
  8026ba:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	75 68                	jne    80272f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026cb:	75 17                	jne    8026e4 <alloc_block_BF+0x27c>
  8026cd:	83 ec 04             	sub    $0x4,%esp
  8026d0:	68 64 42 80 00       	push   $0x804264
  8026d5:	68 45 01 00 00       	push   $0x145
  8026da:	68 49 42 80 00       	push   $0x804249
  8026df:	e8 08 11 00 00       	call   8037ec <_panic>
  8026e4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 0d                	je     802705 <alloc_block_BF+0x29d>
  8026f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802700:	89 50 04             	mov    %edx,0x4(%eax)
  802703:	eb 08                	jmp    80270d <alloc_block_BF+0x2a5>
  802705:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802708:	a3 30 50 80 00       	mov    %eax,0x805030
  80270d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802710:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802715:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271f:	a1 38 50 80 00       	mov    0x805038,%eax
  802724:	40                   	inc    %eax
  802725:	a3 38 50 80 00       	mov    %eax,0x805038
  80272a:	e9 dc 00 00 00       	jmp    80280b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 65                	jne    80279d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802738:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80273c:	75 17                	jne    802755 <alloc_block_BF+0x2ed>
  80273e:	83 ec 04             	sub    $0x4,%esp
  802741:	68 98 42 80 00       	push   $0x804298
  802746:	68 4a 01 00 00       	push   $0x14a
  80274b:	68 49 42 80 00       	push   $0x804249
  802750:	e8 97 10 00 00       	call   8037ec <_panic>
  802755:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80275b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275e:	89 50 04             	mov    %edx,0x4(%eax)
  802761:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 0c                	je     802777 <alloc_block_BF+0x30f>
  80276b:	a1 30 50 80 00       	mov    0x805030,%eax
  802770:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802773:	89 10                	mov    %edx,(%eax)
  802775:	eb 08                	jmp    80277f <alloc_block_BF+0x317>
  802777:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80277f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802782:	a3 30 50 80 00       	mov    %eax,0x805030
  802787:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802790:	a1 38 50 80 00       	mov    0x805038,%eax
  802795:	40                   	inc    %eax
  802796:	a3 38 50 80 00       	mov    %eax,0x805038
  80279b:	eb 6e                	jmp    80280b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80279d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a1:	74 06                	je     8027a9 <alloc_block_BF+0x341>
  8027a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027a7:	75 17                	jne    8027c0 <alloc_block_BF+0x358>
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 bc 42 80 00       	push   $0x8042bc
  8027b1:	68 4f 01 00 00       	push   $0x14f
  8027b6:	68 49 42 80 00       	push   $0x804249
  8027bb:	e8 2c 10 00 00       	call   8037ec <_panic>
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	8b 10                	mov    (%eax),%edx
  8027c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 0b                	je     8027de <alloc_block_BF+0x376>
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e4:	89 10                	mov    %edx,(%eax)
  8027e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ec:	89 50 04             	mov    %edx,0x4(%eax)
  8027ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	75 08                	jne    802800 <alloc_block_BF+0x398>
  8027f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fb:	a3 30 50 80 00       	mov    %eax,0x805030
  802800:	a1 38 50 80 00       	mov    0x805038,%eax
  802805:	40                   	inc    %eax
  802806:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80280b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280f:	75 17                	jne    802828 <alloc_block_BF+0x3c0>
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 2b 42 80 00       	push   $0x80422b
  802819:	68 51 01 00 00       	push   $0x151
  80281e:	68 49 42 80 00       	push   $0x804249
  802823:	e8 c4 0f 00 00       	call   8037ec <_panic>
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 10                	je     802841 <alloc_block_BF+0x3d9>
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802839:	8b 52 04             	mov    0x4(%edx),%edx
  80283c:	89 50 04             	mov    %edx,0x4(%eax)
  80283f:	eb 0b                	jmp    80284c <alloc_block_BF+0x3e4>
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	a3 30 50 80 00       	mov    %eax,0x805030
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	74 0f                	je     802865 <alloc_block_BF+0x3fd>
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285f:	8b 12                	mov    (%edx),%edx
  802861:	89 10                	mov    %edx,(%eax)
  802863:	eb 0a                	jmp    80286f <alloc_block_BF+0x407>
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802882:	a1 38 50 80 00       	mov    0x805038,%eax
  802887:	48                   	dec    %eax
  802888:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80288d:	83 ec 04             	sub    $0x4,%esp
  802890:	6a 00                	push   $0x0
  802892:	ff 75 d0             	pushl  -0x30(%ebp)
  802895:	ff 75 cc             	pushl  -0x34(%ebp)
  802898:	e8 e0 f6 ff ff       	call   801f7d <set_block_data>
  80289d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	e9 a3 01 00 00       	jmp    802a4b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028a8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028ac:	0f 85 9d 00 00 00    	jne    80294f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028b2:	83 ec 04             	sub    $0x4,%esp
  8028b5:	6a 01                	push   $0x1
  8028b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8028ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8028bd:	e8 bb f6 ff ff       	call   801f7d <set_block_data>
  8028c2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c9:	75 17                	jne    8028e2 <alloc_block_BF+0x47a>
  8028cb:	83 ec 04             	sub    $0x4,%esp
  8028ce:	68 2b 42 80 00       	push   $0x80422b
  8028d3:	68 58 01 00 00       	push   $0x158
  8028d8:	68 49 42 80 00       	push   $0x804249
  8028dd:	e8 0a 0f 00 00       	call   8037ec <_panic>
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 10                	je     8028fb <alloc_block_BF+0x493>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f3:	8b 52 04             	mov    0x4(%edx),%edx
  8028f6:	89 50 04             	mov    %edx,0x4(%eax)
  8028f9:	eb 0b                	jmp    802906 <alloc_block_BF+0x49e>
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	a3 30 50 80 00       	mov    %eax,0x805030
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 0f                	je     80291f <alloc_block_BF+0x4b7>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802919:	8b 12                	mov    (%edx),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	eb 0a                	jmp    802929 <alloc_block_BF+0x4c1>
  80291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293c:	a1 38 50 80 00       	mov    0x805038,%eax
  802941:	48                   	dec    %eax
  802942:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	e9 fc 00 00 00       	jmp    802a4b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	83 c0 08             	add    $0x8,%eax
  802955:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802958:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80295f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802962:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802965:	01 d0                	add    %edx,%eax
  802967:	48                   	dec    %eax
  802968:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80296b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80296e:	ba 00 00 00 00       	mov    $0x0,%edx
  802973:	f7 75 c4             	divl   -0x3c(%ebp)
  802976:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802979:	29 d0                	sub    %edx,%eax
  80297b:	c1 e8 0c             	shr    $0xc,%eax
  80297e:	83 ec 0c             	sub    $0xc,%esp
  802981:	50                   	push   %eax
  802982:	e8 a4 e7 ff ff       	call   80112b <sbrk>
  802987:	83 c4 10             	add    $0x10,%esp
  80298a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80298d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802991:	75 0a                	jne    80299d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	e9 ae 00 00 00       	jmp    802a4b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80299d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029a4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029aa:	01 d0                	add    %edx,%eax
  8029ac:	48                   	dec    %eax
  8029ad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b8:	f7 75 b8             	divl   -0x48(%ebp)
  8029bb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029be:	29 d0                	sub    %edx,%eax
  8029c0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029c6:	01 d0                	add    %edx,%eax
  8029c8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029d8:	83 ec 0c             	sub    $0xc,%esp
  8029db:	68 f0 42 80 00       	push   $0x8042f0
  8029e0:	e8 ac d9 ff ff       	call   800391 <cprintf>
  8029e5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029e8:	83 ec 08             	sub    $0x8,%esp
  8029eb:	ff 75 bc             	pushl  -0x44(%ebp)
  8029ee:	68 f5 42 80 00       	push   $0x8042f5
  8029f3:	e8 99 d9 ff ff       	call   800391 <cprintf>
  8029f8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029fb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a02:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a08:	01 d0                	add    %edx,%eax
  802a0a:	48                   	dec    %eax
  802a0b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a0e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a11:	ba 00 00 00 00       	mov    $0x0,%edx
  802a16:	f7 75 b0             	divl   -0x50(%ebp)
  802a19:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a1c:	29 d0                	sub    %edx,%eax
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	6a 01                	push   $0x1
  802a23:	50                   	push   %eax
  802a24:	ff 75 bc             	pushl  -0x44(%ebp)
  802a27:	e8 51 f5 ff ff       	call   801f7d <set_block_data>
  802a2c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a2f:	83 ec 0c             	sub    $0xc,%esp
  802a32:	ff 75 bc             	pushl  -0x44(%ebp)
  802a35:	e8 36 04 00 00       	call   802e70 <free_block>
  802a3a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a3d:	83 ec 0c             	sub    $0xc,%esp
  802a40:	ff 75 08             	pushl  0x8(%ebp)
  802a43:	e8 20 fa ff ff       	call   802468 <alloc_block_BF>
  802a48:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
  802a50:	53                   	push   %ebx
  802a51:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a66:	74 1e                	je     802a86 <merging+0x39>
  802a68:	ff 75 08             	pushl  0x8(%ebp)
  802a6b:	e8 bc f1 ff ff       	call   801c2c <get_block_size>
  802a70:	83 c4 04             	add    $0x4,%esp
  802a73:	89 c2                	mov    %eax,%edx
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	01 d0                	add    %edx,%eax
  802a7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a7d:	75 07                	jne    802a86 <merging+0x39>
		prev_is_free = 1;
  802a7f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a8a:	74 1e                	je     802aaa <merging+0x5d>
  802a8c:	ff 75 10             	pushl  0x10(%ebp)
  802a8f:	e8 98 f1 ff ff       	call   801c2c <get_block_size>
  802a94:	83 c4 04             	add    $0x4,%esp
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	8b 45 10             	mov    0x10(%ebp),%eax
  802a9c:	01 d0                	add    %edx,%eax
  802a9e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aa1:	75 07                	jne    802aaa <merging+0x5d>
		next_is_free = 1;
  802aa3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aae:	0f 84 cc 00 00 00    	je     802b80 <merging+0x133>
  802ab4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab8:	0f 84 c2 00 00 00    	je     802b80 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802abe:	ff 75 08             	pushl  0x8(%ebp)
  802ac1:	e8 66 f1 ff ff       	call   801c2c <get_block_size>
  802ac6:	83 c4 04             	add    $0x4,%esp
  802ac9:	89 c3                	mov    %eax,%ebx
  802acb:	ff 75 10             	pushl  0x10(%ebp)
  802ace:	e8 59 f1 ff ff       	call   801c2c <get_block_size>
  802ad3:	83 c4 04             	add    $0x4,%esp
  802ad6:	01 c3                	add    %eax,%ebx
  802ad8:	ff 75 0c             	pushl  0xc(%ebp)
  802adb:	e8 4c f1 ff ff       	call   801c2c <get_block_size>
  802ae0:	83 c4 04             	add    $0x4,%esp
  802ae3:	01 d8                	add    %ebx,%eax
  802ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ae8:	6a 00                	push   $0x0
  802aea:	ff 75 ec             	pushl  -0x14(%ebp)
  802aed:	ff 75 08             	pushl  0x8(%ebp)
  802af0:	e8 88 f4 ff ff       	call   801f7d <set_block_data>
  802af5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802af8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802afc:	75 17                	jne    802b15 <merging+0xc8>
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	68 2b 42 80 00       	push   $0x80422b
  802b06:	68 7d 01 00 00       	push   $0x17d
  802b0b:	68 49 42 80 00       	push   $0x804249
  802b10:	e8 d7 0c 00 00       	call   8037ec <_panic>
  802b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	74 10                	je     802b2e <merging+0xe1>
  802b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b26:	8b 52 04             	mov    0x4(%edx),%edx
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
  802b2c:	eb 0b                	jmp    802b39 <merging+0xec>
  802b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	a3 30 50 80 00       	mov    %eax,0x805030
  802b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 0f                	je     802b52 <merging+0x105>
  802b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b46:	8b 40 04             	mov    0x4(%eax),%eax
  802b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4c:	8b 12                	mov    (%edx),%edx
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	eb 0a                	jmp    802b5c <merging+0x10f>
  802b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b74:	48                   	dec    %eax
  802b75:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b7a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b7b:	e9 ea 02 00 00       	jmp    802e6a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b84:	74 3b                	je     802bc1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	ff 75 08             	pushl  0x8(%ebp)
  802b8c:	e8 9b f0 ff ff       	call   801c2c <get_block_size>
  802b91:	83 c4 10             	add    $0x10,%esp
  802b94:	89 c3                	mov    %eax,%ebx
  802b96:	83 ec 0c             	sub    $0xc,%esp
  802b99:	ff 75 10             	pushl  0x10(%ebp)
  802b9c:	e8 8b f0 ff ff       	call   801c2c <get_block_size>
  802ba1:	83 c4 10             	add    $0x10,%esp
  802ba4:	01 d8                	add    %ebx,%eax
  802ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	6a 00                	push   $0x0
  802bae:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb1:	ff 75 08             	pushl  0x8(%ebp)
  802bb4:	e8 c4 f3 ff ff       	call   801f7d <set_block_data>
  802bb9:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bbc:	e9 a9 02 00 00       	jmp    802e6a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc5:	0f 84 2d 01 00 00    	je     802cf8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bcb:	83 ec 0c             	sub    $0xc,%esp
  802bce:	ff 75 10             	pushl  0x10(%ebp)
  802bd1:	e8 56 f0 ff ff       	call   801c2c <get_block_size>
  802bd6:	83 c4 10             	add    $0x10,%esp
  802bd9:	89 c3                	mov    %eax,%ebx
  802bdb:	83 ec 0c             	sub    $0xc,%esp
  802bde:	ff 75 0c             	pushl  0xc(%ebp)
  802be1:	e8 46 f0 ff ff       	call   801c2c <get_block_size>
  802be6:	83 c4 10             	add    $0x10,%esp
  802be9:	01 d8                	add    %ebx,%eax
  802beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802bee:	83 ec 04             	sub    $0x4,%esp
  802bf1:	6a 00                	push   $0x0
  802bf3:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bf6:	ff 75 10             	pushl  0x10(%ebp)
  802bf9:	e8 7f f3 ff ff       	call   801f7d <set_block_data>
  802bfe:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c01:	8b 45 10             	mov    0x10(%ebp),%eax
  802c04:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0b:	74 06                	je     802c13 <merging+0x1c6>
  802c0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c11:	75 17                	jne    802c2a <merging+0x1dd>
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 04 43 80 00       	push   $0x804304
  802c1b:	68 8d 01 00 00       	push   $0x18d
  802c20:	68 49 42 80 00       	push   $0x804249
  802c25:	e8 c2 0b 00 00       	call   8037ec <_panic>
  802c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2d:	8b 50 04             	mov    0x4(%eax),%edx
  802c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 0d                	je     802c55 <merging+0x208>
  802c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c51:	89 10                	mov    %edx,(%eax)
  802c53:	eb 08                	jmp    802c5d <merging+0x210>
  802c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	a1 38 50 80 00       	mov    0x805038,%eax
  802c6b:	40                   	inc    %eax
  802c6c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c75:	75 17                	jne    802c8e <merging+0x241>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 2b 42 80 00       	push   $0x80422b
  802c7f:	68 8e 01 00 00       	push   $0x18e
  802c84:	68 49 42 80 00       	push   $0x804249
  802c89:	e8 5e 0b 00 00       	call   8037ec <_panic>
  802c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 10                	je     802ca7 <merging+0x25a>
  802c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ca2:	89 50 04             	mov    %edx,0x4(%eax)
  802ca5:	eb 0b                	jmp    802cb2 <merging+0x265>
  802ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0f                	je     802ccb <merging+0x27e>
  802cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc5:	8b 12                	mov    (%edx),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	eb 0a                	jmp    802cd5 <merging+0x288>
  802ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ced:	48                   	dec    %eax
  802cee:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cf3:	e9 72 01 00 00       	jmp    802e6a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  802cfb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d02:	74 79                	je     802d7d <merging+0x330>
  802d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d08:	74 73                	je     802d7d <merging+0x330>
  802d0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0e:	74 06                	je     802d16 <merging+0x2c9>
  802d10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d14:	75 17                	jne    802d2d <merging+0x2e0>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 bc 42 80 00       	push   $0x8042bc
  802d1e:	68 94 01 00 00       	push   $0x194
  802d23:	68 49 42 80 00       	push   $0x804249
  802d28:	e8 bf 0a 00 00       	call   8037ec <_panic>
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 10                	mov    (%eax),%edx
  802d32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d35:	89 10                	mov    %edx,(%eax)
  802d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	74 0b                	je     802d4b <merging+0x2fe>
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d48:	89 50 04             	mov    %edx,0x4(%eax)
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d51:	89 10                	mov    %edx,(%eax)
  802d53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d56:	8b 55 08             	mov    0x8(%ebp),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	75 08                	jne    802d6d <merging+0x320>
  802d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d68:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d72:	40                   	inc    %eax
  802d73:	a3 38 50 80 00       	mov    %eax,0x805038
  802d78:	e9 ce 00 00 00       	jmp    802e4b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d81:	74 65                	je     802de8 <merging+0x39b>
  802d83:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d87:	75 17                	jne    802da0 <merging+0x353>
  802d89:	83 ec 04             	sub    $0x4,%esp
  802d8c:	68 98 42 80 00       	push   $0x804298
  802d91:	68 95 01 00 00       	push   $0x195
  802d96:	68 49 42 80 00       	push   $0x804249
  802d9b:	e8 4c 0a 00 00       	call   8037ec <_panic>
  802da0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da9:	89 50 04             	mov    %edx,0x4(%eax)
  802dac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 0c                	je     802dc2 <merging+0x375>
  802db6:	a1 30 50 80 00       	mov    0x805030,%eax
  802dbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	eb 08                	jmp    802dca <merging+0x37d>
  802dc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcd:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddb:	a1 38 50 80 00       	mov    0x805038,%eax
  802de0:	40                   	inc    %eax
  802de1:	a3 38 50 80 00       	mov    %eax,0x805038
  802de6:	eb 63                	jmp    802e4b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802de8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dec:	75 17                	jne    802e05 <merging+0x3b8>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 64 42 80 00       	push   $0x804264
  802df6:	68 98 01 00 00       	push   $0x198
  802dfb:	68 49 42 80 00       	push   $0x804249
  802e00:	e8 e7 09 00 00       	call   8037ec <_panic>
  802e05:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0e:	89 10                	mov    %edx,(%eax)
  802e10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 0d                	je     802e26 <merging+0x3d9>
  802e19:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e21:	89 50 04             	mov    %edx,0x4(%eax)
  802e24:	eb 08                	jmp    802e2e <merging+0x3e1>
  802e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e29:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e40:	a1 38 50 80 00       	mov    0x805038,%eax
  802e45:	40                   	inc    %eax
  802e46:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 10             	pushl  0x10(%ebp)
  802e51:	e8 d6 ed ff ff       	call   801c2c <get_block_size>
  802e56:	83 c4 10             	add    $0x10,%esp
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	6a 00                	push   $0x0
  802e5e:	50                   	push   %eax
  802e5f:	ff 75 10             	pushl  0x10(%ebp)
  802e62:	e8 16 f1 ff ff       	call   801f7d <set_block_data>
  802e67:	83 c4 10             	add    $0x10,%esp
	}
}
  802e6a:	90                   	nop
  802e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e6e:	c9                   	leave  
  802e6f:	c3                   	ret    

00802e70 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
  802e73:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e76:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e7e:	a1 30 50 80 00       	mov    0x805030,%eax
  802e83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e86:	73 1b                	jae    802ea3 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e88:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8d:	83 ec 04             	sub    $0x4,%esp
  802e90:	ff 75 08             	pushl  0x8(%ebp)
  802e93:	6a 00                	push   $0x0
  802e95:	50                   	push   %eax
  802e96:	e8 b2 fb ff ff       	call   802a4d <merging>
  802e9b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e9e:	e9 8b 00 00 00       	jmp    802f2e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802ea3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eab:	76 18                	jbe    802ec5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ead:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	ff 75 08             	pushl  0x8(%ebp)
  802eb8:	50                   	push   %eax
  802eb9:	6a 00                	push   $0x0
  802ebb:	e8 8d fb ff ff       	call   802a4d <merging>
  802ec0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ec3:	eb 69                	jmp    802f2e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ec5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ecd:	eb 39                	jmp    802f08 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed5:	73 29                	jae    802f00 <free_block+0x90>
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edf:	76 1f                	jbe    802f00 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	ff 75 08             	pushl  0x8(%ebp)
  802eef:	ff 75 f0             	pushl  -0x10(%ebp)
  802ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  802ef5:	e8 53 fb ff ff       	call   802a4d <merging>
  802efa:	83 c4 10             	add    $0x10,%esp
			break;
  802efd:	90                   	nop
		}
	}
}
  802efe:	eb 2e                	jmp    802f2e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f00:	a1 34 50 80 00       	mov    0x805034,%eax
  802f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0c:	74 07                	je     802f15 <free_block+0xa5>
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	eb 05                	jmp    802f1a <free_block+0xaa>
  802f15:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1a:	a3 34 50 80 00       	mov    %eax,0x805034
  802f1f:	a1 34 50 80 00       	mov    0x805034,%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	75 a7                	jne    802ecf <free_block+0x5f>
  802f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2c:	75 a1                	jne    802ecf <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f2e:	90                   	nop
  802f2f:	c9                   	leave  
  802f30:	c3                   	ret    

00802f31 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f31:	55                   	push   %ebp
  802f32:	89 e5                	mov    %esp,%ebp
  802f34:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f37:	ff 75 08             	pushl  0x8(%ebp)
  802f3a:	e8 ed ec ff ff       	call   801c2c <get_block_size>
  802f3f:	83 c4 04             	add    $0x4,%esp
  802f42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f4c:	eb 17                	jmp    802f65 <copy_data+0x34>
  802f4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	01 c8                	add    %ecx,%eax
  802f5e:	8a 00                	mov    (%eax),%al
  802f60:	88 02                	mov    %al,(%edx)
  802f62:	ff 45 fc             	incl   -0x4(%ebp)
  802f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f6b:	72 e1                	jb     802f4e <copy_data+0x1d>
}
  802f6d:	90                   	nop
  802f6e:	c9                   	leave  
  802f6f:	c3                   	ret    

00802f70 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f70:	55                   	push   %ebp
  802f71:	89 e5                	mov    %esp,%ebp
  802f73:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7a:	75 23                	jne    802f9f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f80:	74 13                	je     802f95 <realloc_block_FF+0x25>
  802f82:	83 ec 0c             	sub    $0xc,%esp
  802f85:	ff 75 0c             	pushl  0xc(%ebp)
  802f88:	e8 1f f0 ff ff       	call   801fac <alloc_block_FF>
  802f8d:	83 c4 10             	add    $0x10,%esp
  802f90:	e9 f4 06 00 00       	jmp    803689 <realloc_block_FF+0x719>
		return NULL;
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9a:	e9 ea 06 00 00       	jmp    803689 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa3:	75 18                	jne    802fbd <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fa5:	83 ec 0c             	sub    $0xc,%esp
  802fa8:	ff 75 08             	pushl  0x8(%ebp)
  802fab:	e8 c0 fe ff ff       	call   802e70 <free_block>
  802fb0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	e9 cc 06 00 00       	jmp    803689 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fbd:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fc1:	77 07                	ja     802fca <realloc_block_FF+0x5a>
  802fc3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcd:	83 e0 01             	and    $0x1,%eax
  802fd0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd6:	83 c0 08             	add    $0x8,%eax
  802fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fdc:	83 ec 0c             	sub    $0xc,%esp
  802fdf:	ff 75 08             	pushl  0x8(%ebp)
  802fe2:	e8 45 ec ff ff       	call   801c2c <get_block_size>
  802fe7:	83 c4 10             	add    $0x10,%esp
  802fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	83 e8 08             	sub    $0x8,%eax
  802ff3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	83 e8 04             	sub    $0x4,%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	83 e0 fe             	and    $0xfffffffe,%eax
  803001:	89 c2                	mov    %eax,%edx
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	01 d0                	add    %edx,%eax
  803008:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80300b:	83 ec 0c             	sub    $0xc,%esp
  80300e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803011:	e8 16 ec ff ff       	call   801c2c <get_block_size>
  803016:	83 c4 10             	add    $0x10,%esp
  803019:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80301c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301f:	83 e8 08             	sub    $0x8,%eax
  803022:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803025:	8b 45 0c             	mov    0xc(%ebp),%eax
  803028:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80302b:	75 08                	jne    803035 <realloc_block_FF+0xc5>
	{
		 return va;
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	e9 54 06 00 00       	jmp    803689 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803035:	8b 45 0c             	mov    0xc(%ebp),%eax
  803038:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80303b:	0f 83 e5 03 00 00    	jae    803426 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	2b 45 0c             	sub    0xc(%ebp),%eax
  803047:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80304a:	83 ec 0c             	sub    $0xc,%esp
  80304d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803050:	e8 f0 eb ff ff       	call   801c45 <is_free_block>
  803055:	83 c4 10             	add    $0x10,%esp
  803058:	84 c0                	test   %al,%al
  80305a:	0f 84 3b 01 00 00    	je     80319b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803060:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803063:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803066:	01 d0                	add    %edx,%eax
  803068:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	6a 01                	push   $0x1
  803070:	ff 75 f0             	pushl  -0x10(%ebp)
  803073:	ff 75 08             	pushl  0x8(%ebp)
  803076:	e8 02 ef ff ff       	call   801f7d <set_block_data>
  80307b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	83 e8 04             	sub    $0x4,%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	83 e0 fe             	and    $0xfffffffe,%eax
  803089:	89 c2                	mov    %eax,%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	01 d0                	add    %edx,%eax
  803090:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803093:	83 ec 04             	sub    $0x4,%esp
  803096:	6a 00                	push   $0x0
  803098:	ff 75 cc             	pushl  -0x34(%ebp)
  80309b:	ff 75 c8             	pushl  -0x38(%ebp)
  80309e:	e8 da ee ff ff       	call   801f7d <set_block_data>
  8030a3:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030aa:	74 06                	je     8030b2 <realloc_block_FF+0x142>
  8030ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030b0:	75 17                	jne    8030c9 <realloc_block_FF+0x159>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 bc 42 80 00       	push   $0x8042bc
  8030ba:	68 f6 01 00 00       	push   $0x1f6
  8030bf:	68 49 42 80 00       	push   $0x804249
  8030c4:	e8 23 07 00 00       	call   8037ec <_panic>
  8030c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cc:	8b 10                	mov    (%eax),%edx
  8030ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 0b                	je     8030e7 <realloc_block_FF+0x177>
  8030dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030e4:	89 50 04             	mov    %edx,0x4(%eax)
  8030e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ed:	89 10                	mov    %edx,(%eax)
  8030ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f5:	89 50 04             	mov    %edx,0x4(%eax)
  8030f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	75 08                	jne    803109 <realloc_block_FF+0x199>
  803101:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803104:	a3 30 50 80 00       	mov    %eax,0x805030
  803109:	a1 38 50 80 00       	mov    0x805038,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803118:	75 17                	jne    803131 <realloc_block_FF+0x1c1>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 2b 42 80 00       	push   $0x80422b
  803122:	68 f7 01 00 00       	push   $0x1f7
  803127:	68 49 42 80 00       	push   $0x804249
  80312c:	e8 bb 06 00 00       	call   8037ec <_panic>
  803131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 10                	je     80314a <realloc_block_FF+0x1da>
  80313a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313d:	8b 00                	mov    (%eax),%eax
  80313f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803142:	8b 52 04             	mov    0x4(%edx),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	eb 0b                	jmp    803155 <realloc_block_FF+0x1e5>
  80314a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	a3 30 50 80 00       	mov    %eax,0x805030
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 0f                	je     80316e <realloc_block_FF+0x1fe>
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803168:	8b 12                	mov    (%edx),%edx
  80316a:	89 10                	mov    %edx,(%eax)
  80316c:	eb 0a                	jmp    803178 <realloc_block_FF+0x208>
  80316e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803184:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318b:	a1 38 50 80 00       	mov    0x805038,%eax
  803190:	48                   	dec    %eax
  803191:	a3 38 50 80 00       	mov    %eax,0x805038
  803196:	e9 83 02 00 00       	jmp    80341e <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80319b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80319f:	0f 86 69 02 00 00    	jbe    80340e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	6a 01                	push   $0x1
  8031aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ad:	ff 75 08             	pushl  0x8(%ebp)
  8031b0:	e8 c8 ed ff ff       	call   801f7d <set_block_data>
  8031b5:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	83 e8 04             	sub    $0x4,%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8031c3:	89 c2                	mov    %eax,%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	01 d0                	add    %edx,%eax
  8031ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031d9:	75 68                	jne    803243 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031df:	75 17                	jne    8031f8 <realloc_block_FF+0x288>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 64 42 80 00       	push   $0x804264
  8031e9:	68 06 02 00 00       	push   $0x206
  8031ee:	68 49 42 80 00       	push   $0x804249
  8031f3:	e8 f4 05 00 00       	call   8037ec <_panic>
  8031f8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803201:	89 10                	mov    %edx,(%eax)
  803203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <realloc_block_FF+0x2a9>
  80320c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803211:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	eb 08                	jmp    803221 <realloc_block_FF+0x2b1>
  803219:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321c:	a3 30 50 80 00       	mov    %eax,0x805030
  803221:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803224:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 38 50 80 00       	mov    0x805038,%eax
  803238:	40                   	inc    %eax
  803239:	a3 38 50 80 00       	mov    %eax,0x805038
  80323e:	e9 b0 01 00 00       	jmp    8033f3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803243:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803248:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80324b:	76 68                	jbe    8032b5 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80324d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803251:	75 17                	jne    80326a <realloc_block_FF+0x2fa>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 64 42 80 00       	push   $0x804264
  80325b:	68 0b 02 00 00       	push   $0x20b
  803260:	68 49 42 80 00       	push   $0x804249
  803265:	e8 82 05 00 00       	call   8037ec <_panic>
  80326a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <realloc_block_FF+0x31b>
  80327e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803283:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <realloc_block_FF+0x323>
  80328b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328e:	a3 30 50 80 00       	mov    %eax,0x805030
  803293:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803296:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8032b0:	e9 3e 01 00 00       	jmp    8033f3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032bd:	73 68                	jae    803327 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032c3:	75 17                	jne    8032dc <realloc_block_FF+0x36c>
  8032c5:	83 ec 04             	sub    $0x4,%esp
  8032c8:	68 98 42 80 00       	push   $0x804298
  8032cd:	68 10 02 00 00       	push   $0x210
  8032d2:	68 49 42 80 00       	push   $0x804249
  8032d7:	e8 10 05 00 00       	call   8037ec <_panic>
  8032dc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0c                	je     8032fe <realloc_block_FF+0x38e>
  8032f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8032f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	eb 08                	jmp    803306 <realloc_block_FF+0x396>
  8032fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803301:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803306:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803309:	a3 30 50 80 00       	mov    %eax,0x805030
  80330e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803317:	a1 38 50 80 00       	mov    0x805038,%eax
  80331c:	40                   	inc    %eax
  80331d:	a3 38 50 80 00       	mov    %eax,0x805038
  803322:	e9 cc 00 00 00       	jmp    8033f3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80332e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803336:	e9 8a 00 00 00       	jmp    8033c5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803341:	73 7a                	jae    8033bd <realloc_block_FF+0x44d>
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334b:	73 70                	jae    8033bd <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80334d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803351:	74 06                	je     803359 <realloc_block_FF+0x3e9>
  803353:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803357:	75 17                	jne    803370 <realloc_block_FF+0x400>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 bc 42 80 00       	push   $0x8042bc
  803361:	68 1a 02 00 00       	push   $0x21a
  803366:	68 49 42 80 00       	push   $0x804249
  80336b:	e8 7c 04 00 00       	call   8037ec <_panic>
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 10                	mov    (%eax),%edx
  803375:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0b                	je     80338e <realloc_block_FF+0x41e>
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	75 08                	jne    8033b0 <realloc_block_FF+0x440>
  8033a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8033b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8033b5:	40                   	inc    %eax
  8033b6:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033bb:	eb 36                	jmp    8033f3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c9:	74 07                	je     8033d2 <realloc_block_FF+0x462>
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	eb 05                	jmp    8033d7 <realloc_block_FF+0x467>
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8033dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	0f 85 52 ff ff ff    	jne    80333b <realloc_block_FF+0x3cb>
  8033e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ed:	0f 85 48 ff ff ff    	jne    80333b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	6a 00                	push   $0x0
  8033f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8033fb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033fe:	e8 7a eb ff ff       	call   801f7d <set_block_data>
  803403:	83 c4 10             	add    $0x10,%esp
				return va;
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	e9 7b 02 00 00       	jmp    803689 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80340e:	83 ec 0c             	sub    $0xc,%esp
  803411:	68 39 43 80 00       	push   $0x804339
  803416:	e8 76 cf ff ff       	call   800391 <cprintf>
  80341b:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	e9 63 02 00 00       	jmp    803689 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80342c:	0f 86 4d 02 00 00    	jbe    80367f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803432:	83 ec 0c             	sub    $0xc,%esp
  803435:	ff 75 e4             	pushl  -0x1c(%ebp)
  803438:	e8 08 e8 ff ff       	call   801c45 <is_free_block>
  80343d:	83 c4 10             	add    $0x10,%esp
  803440:	84 c0                	test   %al,%al
  803442:	0f 84 37 02 00 00    	je     80367f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80344e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803451:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803454:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803457:	76 38                	jbe    803491 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803459:	83 ec 0c             	sub    $0xc,%esp
  80345c:	ff 75 08             	pushl  0x8(%ebp)
  80345f:	e8 0c fa ff ff       	call   802e70 <free_block>
  803464:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	ff 75 0c             	pushl  0xc(%ebp)
  80346d:	e8 3a eb ff ff       	call   801fac <alloc_block_FF>
  803472:	83 c4 10             	add    $0x10,%esp
  803475:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803478:	83 ec 08             	sub    $0x8,%esp
  80347b:	ff 75 c0             	pushl  -0x40(%ebp)
  80347e:	ff 75 08             	pushl  0x8(%ebp)
  803481:	e8 ab fa ff ff       	call   802f31 <copy_data>
  803486:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803489:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80348c:	e9 f8 01 00 00       	jmp    803689 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803494:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803497:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80349a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80349e:	0f 87 a0 00 00 00    	ja     803544 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a8:	75 17                	jne    8034c1 <realloc_block_FF+0x551>
  8034aa:	83 ec 04             	sub    $0x4,%esp
  8034ad:	68 2b 42 80 00       	push   $0x80422b
  8034b2:	68 38 02 00 00       	push   $0x238
  8034b7:	68 49 42 80 00       	push   $0x804249
  8034bc:	e8 2b 03 00 00       	call   8037ec <_panic>
  8034c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	74 10                	je     8034da <realloc_block_FF+0x56a>
  8034ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034d2:	8b 52 04             	mov    0x4(%edx),%edx
  8034d5:	89 50 04             	mov    %edx,0x4(%eax)
  8034d8:	eb 0b                	jmp    8034e5 <realloc_block_FF+0x575>
  8034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034dd:	8b 40 04             	mov    0x4(%eax),%eax
  8034e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	85 c0                	test   %eax,%eax
  8034ed:	74 0f                	je     8034fe <realloc_block_FF+0x58e>
  8034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f8:	8b 12                	mov    (%edx),%edx
  8034fa:	89 10                	mov    %edx,(%eax)
  8034fc:	eb 0a                	jmp    803508 <realloc_block_FF+0x598>
  8034fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803514:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351b:	a1 38 50 80 00       	mov    0x805038,%eax
  803520:	48                   	dec    %eax
  803521:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352c:	01 d0                	add    %edx,%eax
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	6a 01                	push   $0x1
  803533:	50                   	push   %eax
  803534:	ff 75 08             	pushl  0x8(%ebp)
  803537:	e8 41 ea ff ff       	call   801f7d <set_block_data>
  80353c:	83 c4 10             	add    $0x10,%esp
  80353f:	e9 36 01 00 00       	jmp    80367a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803544:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803547:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80354a:	01 d0                	add    %edx,%eax
  80354c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80354f:	83 ec 04             	sub    $0x4,%esp
  803552:	6a 01                	push   $0x1
  803554:	ff 75 f0             	pushl  -0x10(%ebp)
  803557:	ff 75 08             	pushl  0x8(%ebp)
  80355a:	e8 1e ea ff ff       	call   801f7d <set_block_data>
  80355f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	83 e8 04             	sub    $0x4,%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	83 e0 fe             	and    $0xfffffffe,%eax
  80356d:	89 c2                	mov    %eax,%edx
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	01 d0                	add    %edx,%eax
  803574:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357b:	74 06                	je     803583 <realloc_block_FF+0x613>
  80357d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803581:	75 17                	jne    80359a <realloc_block_FF+0x62a>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 bc 42 80 00       	push   $0x8042bc
  80358b:	68 44 02 00 00       	push   $0x244
  803590:	68 49 42 80 00       	push   $0x804249
  803595:	e8 52 02 00 00       	call   8037ec <_panic>
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 10                	mov    (%eax),%edx
  80359f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a2:	89 10                	mov    %edx,(%eax)
  8035a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	74 0b                	je     8035b8 <realloc_block_FF+0x648>
  8035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b0:	8b 00                	mov    (%eax),%eax
  8035b2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035b5:	89 50 04             	mov    %edx,0x4(%eax)
  8035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035c6:	89 50 04             	mov    %edx,0x4(%eax)
  8035c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	75 08                	jne    8035da <realloc_block_FF+0x66a>
  8035d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035da:	a1 38 50 80 00       	mov    0x805038,%eax
  8035df:	40                   	inc    %eax
  8035e0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035e9:	75 17                	jne    803602 <realloc_block_FF+0x692>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 2b 42 80 00       	push   $0x80422b
  8035f3:	68 45 02 00 00       	push   $0x245
  8035f8:	68 49 42 80 00       	push   $0x804249
  8035fd:	e8 ea 01 00 00       	call   8037ec <_panic>
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	85 c0                	test   %eax,%eax
  803609:	74 10                	je     80361b <realloc_block_FF+0x6ab>
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360e:	8b 00                	mov    (%eax),%eax
  803610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803613:	8b 52 04             	mov    0x4(%edx),%edx
  803616:	89 50 04             	mov    %edx,0x4(%eax)
  803619:	eb 0b                	jmp    803626 <realloc_block_FF+0x6b6>
  80361b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	a3 30 50 80 00       	mov    %eax,0x805030
  803626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803629:	8b 40 04             	mov    0x4(%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0f                	je     80363f <realloc_block_FF+0x6cf>
  803630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803639:	8b 12                	mov    (%edx),%edx
  80363b:	89 10                	mov    %edx,(%eax)
  80363d:	eb 0a                	jmp    803649 <realloc_block_FF+0x6d9>
  80363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365c:	a1 38 50 80 00       	mov    0x805038,%eax
  803661:	48                   	dec    %eax
  803662:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	6a 00                	push   $0x0
  80366c:	ff 75 bc             	pushl  -0x44(%ebp)
  80366f:	ff 75 b8             	pushl  -0x48(%ebp)
  803672:	e8 06 e9 ff ff       	call   801f7d <set_block_data>
  803677:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	eb 0a                	jmp    803689 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80367f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803686:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803689:	c9                   	leave  
  80368a:	c3                   	ret    

0080368b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80368b:	55                   	push   %ebp
  80368c:	89 e5                	mov    %esp,%ebp
  80368e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803691:	83 ec 04             	sub    $0x4,%esp
  803694:	68 40 43 80 00       	push   $0x804340
  803699:	68 58 02 00 00       	push   $0x258
  80369e:	68 49 42 80 00       	push   $0x804249
  8036a3:	e8 44 01 00 00       	call   8037ec <_panic>

008036a8 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036a8:	55                   	push   %ebp
  8036a9:	89 e5                	mov    %esp,%ebp
  8036ab:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 68 43 80 00       	push   $0x804368
  8036b6:	68 61 02 00 00       	push   $0x261
  8036bb:	68 49 42 80 00       	push   $0x804249
  8036c0:	e8 27 01 00 00       	call   8037ec <_panic>

008036c5 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
  8036c8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036cb:	83 ec 04             	sub    $0x4,%esp
  8036ce:	68 90 43 80 00       	push   $0x804390
  8036d3:	6a 09                	push   $0x9
  8036d5:	68 b8 43 80 00       	push   $0x8043b8
  8036da:	e8 0d 01 00 00       	call   8037ec <_panic>

008036df <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8036df:	55                   	push   %ebp
  8036e0:	89 e5                	mov    %esp,%ebp
  8036e2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8036e5:	83 ec 04             	sub    $0x4,%esp
  8036e8:	68 c8 43 80 00       	push   $0x8043c8
  8036ed:	6a 10                	push   $0x10
  8036ef:	68 b8 43 80 00       	push   $0x8043b8
  8036f4:	e8 f3 00 00 00       	call   8037ec <_panic>

008036f9 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8036f9:	55                   	push   %ebp
  8036fa:	89 e5                	mov    %esp,%ebp
  8036fc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	68 f0 43 80 00       	push   $0x8043f0
  803707:	6a 18                	push   $0x18
  803709:	68 b8 43 80 00       	push   $0x8043b8
  80370e:	e8 d9 00 00 00       	call   8037ec <_panic>

00803713 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803713:	55                   	push   %ebp
  803714:	89 e5                	mov    %esp,%ebp
  803716:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803719:	83 ec 04             	sub    $0x4,%esp
  80371c:	68 18 44 80 00       	push   $0x804418
  803721:	6a 20                	push   $0x20
  803723:	68 b8 43 80 00       	push   $0x8043b8
  803728:	e8 bf 00 00 00       	call   8037ec <_panic>

0080372d <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	8b 40 10             	mov    0x10(%eax),%eax
}
  803736:	5d                   	pop    %ebp
  803737:	c3                   	ret    

00803738 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803738:	55                   	push   %ebp
  803739:	89 e5                	mov    %esp,%ebp
  80373b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80373e:	8b 55 08             	mov    0x8(%ebp),%edx
  803741:	89 d0                	mov    %edx,%eax
  803743:	c1 e0 02             	shl    $0x2,%eax
  803746:	01 d0                	add    %edx,%eax
  803748:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80374f:	01 d0                	add    %edx,%eax
  803751:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803758:	01 d0                	add    %edx,%eax
  80375a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803761:	01 d0                	add    %edx,%eax
  803763:	c1 e0 04             	shl    $0x4,%eax
  803766:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803769:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803770:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803773:	83 ec 0c             	sub    $0xc,%esp
  803776:	50                   	push   %eax
  803777:	e8 bc e1 ff ff       	call   801938 <sys_get_virtual_time>
  80377c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80377f:	eb 41                	jmp    8037c2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803781:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803784:	83 ec 0c             	sub    $0xc,%esp
  803787:	50                   	push   %eax
  803788:	e8 ab e1 ff ff       	call   801938 <sys_get_virtual_time>
  80378d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803790:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803796:	29 c2                	sub    %eax,%edx
  803798:	89 d0                	mov    %edx,%eax
  80379a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80379d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a3:	89 d1                	mov    %edx,%ecx
  8037a5:	29 c1                	sub    %eax,%ecx
  8037a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ad:	39 c2                	cmp    %eax,%edx
  8037af:	0f 97 c0             	seta   %al
  8037b2:	0f b6 c0             	movzbl %al,%eax
  8037b5:	29 c1                	sub    %eax,%ecx
  8037b7:	89 c8                	mov    %ecx,%eax
  8037b9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037c8:	72 b7                	jb     803781 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037ca:	90                   	nop
  8037cb:	c9                   	leave  
  8037cc:	c3                   	ret    

008037cd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037cd:	55                   	push   %ebp
  8037ce:	89 e5                	mov    %esp,%ebp
  8037d0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037da:	eb 03                	jmp    8037df <busy_wait+0x12>
  8037dc:	ff 45 fc             	incl   -0x4(%ebp)
  8037df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e5:	72 f5                	jb     8037dc <busy_wait+0xf>
	return i;
  8037e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037ea:	c9                   	leave  
  8037eb:	c3                   	ret    

008037ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037ec:	55                   	push   %ebp
  8037ed:	89 e5                	mov    %esp,%ebp
  8037ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8037f5:	83 c0 04             	add    $0x4,%eax
  8037f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037fb:	a1 60 50 90 00       	mov    0x905060,%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 16                	je     80381a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803804:	a1 60 50 90 00       	mov    0x905060,%eax
  803809:	83 ec 08             	sub    $0x8,%esp
  80380c:	50                   	push   %eax
  80380d:	68 40 44 80 00       	push   $0x804440
  803812:	e8 7a cb ff ff       	call   800391 <cprintf>
  803817:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80381a:	a1 00 50 80 00       	mov    0x805000,%eax
  80381f:	ff 75 0c             	pushl  0xc(%ebp)
  803822:	ff 75 08             	pushl  0x8(%ebp)
  803825:	50                   	push   %eax
  803826:	68 45 44 80 00       	push   $0x804445
  80382b:	e8 61 cb ff ff       	call   800391 <cprintf>
  803830:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803833:	8b 45 10             	mov    0x10(%ebp),%eax
  803836:	83 ec 08             	sub    $0x8,%esp
  803839:	ff 75 f4             	pushl  -0xc(%ebp)
  80383c:	50                   	push   %eax
  80383d:	e8 e4 ca ff ff       	call   800326 <vcprintf>
  803842:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803845:	83 ec 08             	sub    $0x8,%esp
  803848:	6a 00                	push   $0x0
  80384a:	68 61 44 80 00       	push   $0x804461
  80384f:	e8 d2 ca ff ff       	call   800326 <vcprintf>
  803854:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803857:	e8 53 ca ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80385c:	eb fe                	jmp    80385c <_panic+0x70>

0080385e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803864:	a1 20 50 80 00       	mov    0x805020,%eax
  803869:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80386f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803872:	39 c2                	cmp    %eax,%edx
  803874:	74 14                	je     80388a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803876:	83 ec 04             	sub    $0x4,%esp
  803879:	68 64 44 80 00       	push   $0x804464
  80387e:	6a 26                	push   $0x26
  803880:	68 b0 44 80 00       	push   $0x8044b0
  803885:	e8 62 ff ff ff       	call   8037ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80388a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803891:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803898:	e9 c5 00 00 00       	jmp    803962 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80389d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038aa:	01 d0                	add    %edx,%eax
  8038ac:	8b 00                	mov    (%eax),%eax
  8038ae:	85 c0                	test   %eax,%eax
  8038b0:	75 08                	jne    8038ba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038b5:	e9 a5 00 00 00       	jmp    80395f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038c8:	eb 69                	jmp    803933 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8038cf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	01 c0                	add    %eax,%eax
  8038dc:	01 d0                	add    %edx,%eax
  8038de:	c1 e0 03             	shl    $0x3,%eax
  8038e1:	01 c8                	add    %ecx,%eax
  8038e3:	8a 40 04             	mov    0x4(%eax),%al
  8038e6:	84 c0                	test   %al,%al
  8038e8:	75 46                	jne    803930 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038f8:	89 d0                	mov    %edx,%eax
  8038fa:	01 c0                	add    %eax,%eax
  8038fc:	01 d0                	add    %edx,%eax
  8038fe:	c1 e0 03             	shl    $0x3,%eax
  803901:	01 c8                	add    %ecx,%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803908:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803910:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803915:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80391c:	8b 45 08             	mov    0x8(%ebp),%eax
  80391f:	01 c8                	add    %ecx,%eax
  803921:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803923:	39 c2                	cmp    %eax,%edx
  803925:	75 09                	jne    803930 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803927:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80392e:	eb 15                	jmp    803945 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803930:	ff 45 e8             	incl   -0x18(%ebp)
  803933:	a1 20 50 80 00       	mov    0x805020,%eax
  803938:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803941:	39 c2                	cmp    %eax,%edx
  803943:	77 85                	ja     8038ca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803945:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803949:	75 14                	jne    80395f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80394b:	83 ec 04             	sub    $0x4,%esp
  80394e:	68 bc 44 80 00       	push   $0x8044bc
  803953:	6a 3a                	push   $0x3a
  803955:	68 b0 44 80 00       	push   $0x8044b0
  80395a:	e8 8d fe ff ff       	call   8037ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80395f:	ff 45 f0             	incl   -0x10(%ebp)
  803962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803965:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803968:	0f 8c 2f ff ff ff    	jl     80389d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80396e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80397c:	eb 26                	jmp    8039a4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80397e:	a1 20 50 80 00       	mov    0x805020,%eax
  803983:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803989:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80398c:	89 d0                	mov    %edx,%eax
  80398e:	01 c0                	add    %eax,%eax
  803990:	01 d0                	add    %edx,%eax
  803992:	c1 e0 03             	shl    $0x3,%eax
  803995:	01 c8                	add    %ecx,%eax
  803997:	8a 40 04             	mov    0x4(%eax),%al
  80399a:	3c 01                	cmp    $0x1,%al
  80399c:	75 03                	jne    8039a1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80399e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039a1:	ff 45 e0             	incl   -0x20(%ebp)
  8039a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b2:	39 c2                	cmp    %eax,%edx
  8039b4:	77 c8                	ja     80397e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039bc:	74 14                	je     8039d2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	68 10 45 80 00       	push   $0x804510
  8039c6:	6a 44                	push   $0x44
  8039c8:	68 b0 44 80 00       	push   $0x8044b0
  8039cd:	e8 1a fe ff ff       	call   8037ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039d2:	90                   	nop
  8039d3:	c9                   	leave  
  8039d4:	c3                   	ret    
  8039d5:	66 90                	xchg   %ax,%ax
  8039d7:	90                   	nop

008039d8 <__udivdi3>:
  8039d8:	55                   	push   %ebp
  8039d9:	57                   	push   %edi
  8039da:	56                   	push   %esi
  8039db:	53                   	push   %ebx
  8039dc:	83 ec 1c             	sub    $0x1c,%esp
  8039df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039ef:	89 ca                	mov    %ecx,%edx
  8039f1:	89 f8                	mov    %edi,%eax
  8039f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f7:	85 f6                	test   %esi,%esi
  8039f9:	75 2d                	jne    803a28 <__udivdi3+0x50>
  8039fb:	39 cf                	cmp    %ecx,%edi
  8039fd:	77 65                	ja     803a64 <__udivdi3+0x8c>
  8039ff:	89 fd                	mov    %edi,%ebp
  803a01:	85 ff                	test   %edi,%edi
  803a03:	75 0b                	jne    803a10 <__udivdi3+0x38>
  803a05:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0a:	31 d2                	xor    %edx,%edx
  803a0c:	f7 f7                	div    %edi
  803a0e:	89 c5                	mov    %eax,%ebp
  803a10:	31 d2                	xor    %edx,%edx
  803a12:	89 c8                	mov    %ecx,%eax
  803a14:	f7 f5                	div    %ebp
  803a16:	89 c1                	mov    %eax,%ecx
  803a18:	89 d8                	mov    %ebx,%eax
  803a1a:	f7 f5                	div    %ebp
  803a1c:	89 cf                	mov    %ecx,%edi
  803a1e:	89 fa                	mov    %edi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	39 ce                	cmp    %ecx,%esi
  803a2a:	77 28                	ja     803a54 <__udivdi3+0x7c>
  803a2c:	0f bd fe             	bsr    %esi,%edi
  803a2f:	83 f7 1f             	xor    $0x1f,%edi
  803a32:	75 40                	jne    803a74 <__udivdi3+0x9c>
  803a34:	39 ce                	cmp    %ecx,%esi
  803a36:	72 0a                	jb     803a42 <__udivdi3+0x6a>
  803a38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a3c:	0f 87 9e 00 00 00    	ja     803ae0 <__udivdi3+0x108>
  803a42:	b8 01 00 00 00       	mov    $0x1,%eax
  803a47:	89 fa                	mov    %edi,%edx
  803a49:	83 c4 1c             	add    $0x1c,%esp
  803a4c:	5b                   	pop    %ebx
  803a4d:	5e                   	pop    %esi
  803a4e:	5f                   	pop    %edi
  803a4f:	5d                   	pop    %ebp
  803a50:	c3                   	ret    
  803a51:	8d 76 00             	lea    0x0(%esi),%esi
  803a54:	31 ff                	xor    %edi,%edi
  803a56:	31 c0                	xor    %eax,%eax
  803a58:	89 fa                	mov    %edi,%edx
  803a5a:	83 c4 1c             	add    $0x1c,%esp
  803a5d:	5b                   	pop    %ebx
  803a5e:	5e                   	pop    %esi
  803a5f:	5f                   	pop    %edi
  803a60:	5d                   	pop    %ebp
  803a61:	c3                   	ret    
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	89 d8                	mov    %ebx,%eax
  803a66:	f7 f7                	div    %edi
  803a68:	31 ff                	xor    %edi,%edi
  803a6a:	89 fa                	mov    %edi,%edx
  803a6c:	83 c4 1c             	add    $0x1c,%esp
  803a6f:	5b                   	pop    %ebx
  803a70:	5e                   	pop    %esi
  803a71:	5f                   	pop    %edi
  803a72:	5d                   	pop    %ebp
  803a73:	c3                   	ret    
  803a74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a79:	89 eb                	mov    %ebp,%ebx
  803a7b:	29 fb                	sub    %edi,%ebx
  803a7d:	89 f9                	mov    %edi,%ecx
  803a7f:	d3 e6                	shl    %cl,%esi
  803a81:	89 c5                	mov    %eax,%ebp
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 ed                	shr    %cl,%ebp
  803a87:	89 e9                	mov    %ebp,%ecx
  803a89:	09 f1                	or     %esi,%ecx
  803a8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8f:	89 f9                	mov    %edi,%ecx
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 c5                	mov    %eax,%ebp
  803a95:	89 d6                	mov    %edx,%esi
  803a97:	88 d9                	mov    %bl,%cl
  803a99:	d3 ee                	shr    %cl,%esi
  803a9b:	89 f9                	mov    %edi,%ecx
  803a9d:	d3 e2                	shl    %cl,%edx
  803a9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 e8                	shr    %cl,%eax
  803aa7:	09 c2                	or     %eax,%edx
  803aa9:	89 d0                	mov    %edx,%eax
  803aab:	89 f2                	mov    %esi,%edx
  803aad:	f7 74 24 0c          	divl   0xc(%esp)
  803ab1:	89 d6                	mov    %edx,%esi
  803ab3:	89 c3                	mov    %eax,%ebx
  803ab5:	f7 e5                	mul    %ebp
  803ab7:	39 d6                	cmp    %edx,%esi
  803ab9:	72 19                	jb     803ad4 <__udivdi3+0xfc>
  803abb:	74 0b                	je     803ac8 <__udivdi3+0xf0>
  803abd:	89 d8                	mov    %ebx,%eax
  803abf:	31 ff                	xor    %edi,%edi
  803ac1:	e9 58 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ac6:	66 90                	xchg   %ax,%ax
  803ac8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803acc:	89 f9                	mov    %edi,%ecx
  803ace:	d3 e2                	shl    %cl,%edx
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	73 e9                	jae    803abd <__udivdi3+0xe5>
  803ad4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad7:	31 ff                	xor    %edi,%edi
  803ad9:	e9 40 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	31 c0                	xor    %eax,%eax
  803ae2:	e9 37 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ae7:	90                   	nop

00803ae8 <__umoddi3>:
  803ae8:	55                   	push   %ebp
  803ae9:	57                   	push   %edi
  803aea:	56                   	push   %esi
  803aeb:	53                   	push   %ebx
  803aec:	83 ec 1c             	sub    $0x1c,%esp
  803aef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803af3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b07:	89 f3                	mov    %esi,%ebx
  803b09:	89 fa                	mov    %edi,%edx
  803b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0f:	89 34 24             	mov    %esi,(%esp)
  803b12:	85 c0                	test   %eax,%eax
  803b14:	75 1a                	jne    803b30 <__umoddi3+0x48>
  803b16:	39 f7                	cmp    %esi,%edi
  803b18:	0f 86 a2 00 00 00    	jbe    803bc0 <__umoddi3+0xd8>
  803b1e:	89 c8                	mov    %ecx,%eax
  803b20:	89 f2                	mov    %esi,%edx
  803b22:	f7 f7                	div    %edi
  803b24:	89 d0                	mov    %edx,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	39 f0                	cmp    %esi,%eax
  803b32:	0f 87 ac 00 00 00    	ja     803be4 <__umoddi3+0xfc>
  803b38:	0f bd e8             	bsr    %eax,%ebp
  803b3b:	83 f5 1f             	xor    $0x1f,%ebp
  803b3e:	0f 84 ac 00 00 00    	je     803bf0 <__umoddi3+0x108>
  803b44:	bf 20 00 00 00       	mov    $0x20,%edi
  803b49:	29 ef                	sub    %ebp,%edi
  803b4b:	89 fe                	mov    %edi,%esi
  803b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b51:	89 e9                	mov    %ebp,%ecx
  803b53:	d3 e0                	shl    %cl,%eax
  803b55:	89 d7                	mov    %edx,%edi
  803b57:	89 f1                	mov    %esi,%ecx
  803b59:	d3 ef                	shr    %cl,%edi
  803b5b:	09 c7                	or     %eax,%edi
  803b5d:	89 e9                	mov    %ebp,%ecx
  803b5f:	d3 e2                	shl    %cl,%edx
  803b61:	89 14 24             	mov    %edx,(%esp)
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	d3 e0                	shl    %cl,%eax
  803b68:	89 c2                	mov    %eax,%edx
  803b6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b78:	89 f1                	mov    %esi,%ecx
  803b7a:	d3 e8                	shr    %cl,%eax
  803b7c:	09 d0                	or     %edx,%eax
  803b7e:	d3 eb                	shr    %cl,%ebx
  803b80:	89 da                	mov    %ebx,%edx
  803b82:	f7 f7                	div    %edi
  803b84:	89 d3                	mov    %edx,%ebx
  803b86:	f7 24 24             	mull   (%esp)
  803b89:	89 c6                	mov    %eax,%esi
  803b8b:	89 d1                	mov    %edx,%ecx
  803b8d:	39 d3                	cmp    %edx,%ebx
  803b8f:	0f 82 87 00 00 00    	jb     803c1c <__umoddi3+0x134>
  803b95:	0f 84 91 00 00 00    	je     803c2c <__umoddi3+0x144>
  803b9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9f:	29 f2                	sub    %esi,%edx
  803ba1:	19 cb                	sbb    %ecx,%ebx
  803ba3:	89 d8                	mov    %ebx,%eax
  803ba5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba9:	d3 e0                	shl    %cl,%eax
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	d3 ea                	shr    %cl,%edx
  803baf:	09 d0                	or     %edx,%eax
  803bb1:	89 e9                	mov    %ebp,%ecx
  803bb3:	d3 eb                	shr    %cl,%ebx
  803bb5:	89 da                	mov    %ebx,%edx
  803bb7:	83 c4 1c             	add    $0x1c,%esp
  803bba:	5b                   	pop    %ebx
  803bbb:	5e                   	pop    %esi
  803bbc:	5f                   	pop    %edi
  803bbd:	5d                   	pop    %ebp
  803bbe:	c3                   	ret    
  803bbf:	90                   	nop
  803bc0:	89 fd                	mov    %edi,%ebp
  803bc2:	85 ff                	test   %edi,%edi
  803bc4:	75 0b                	jne    803bd1 <__umoddi3+0xe9>
  803bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcb:	31 d2                	xor    %edx,%edx
  803bcd:	f7 f7                	div    %edi
  803bcf:	89 c5                	mov    %eax,%ebp
  803bd1:	89 f0                	mov    %esi,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 c8                	mov    %ecx,%eax
  803bd9:	f7 f5                	div    %ebp
  803bdb:	89 d0                	mov    %edx,%eax
  803bdd:	e9 44 ff ff ff       	jmp    803b26 <__umoddi3+0x3e>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	89 c8                	mov    %ecx,%eax
  803be6:	89 f2                	mov    %esi,%edx
  803be8:	83 c4 1c             	add    $0x1c,%esp
  803beb:	5b                   	pop    %ebx
  803bec:	5e                   	pop    %esi
  803bed:	5f                   	pop    %edi
  803bee:	5d                   	pop    %ebp
  803bef:	c3                   	ret    
  803bf0:	3b 04 24             	cmp    (%esp),%eax
  803bf3:	72 06                	jb     803bfb <__umoddi3+0x113>
  803bf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf9:	77 0f                	ja     803c0a <__umoddi3+0x122>
  803bfb:	89 f2                	mov    %esi,%edx
  803bfd:	29 f9                	sub    %edi,%ecx
  803bff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c03:	89 14 24             	mov    %edx,(%esp)
  803c06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0e:	8b 14 24             	mov    (%esp),%edx
  803c11:	83 c4 1c             	add    $0x1c,%esp
  803c14:	5b                   	pop    %ebx
  803c15:	5e                   	pop    %esi
  803c16:	5f                   	pop    %edi
  803c17:	5d                   	pop    %ebp
  803c18:	c3                   	ret    
  803c19:	8d 76 00             	lea    0x0(%esi),%esi
  803c1c:	2b 04 24             	sub    (%esp),%eax
  803c1f:	19 fa                	sbb    %edi,%edx
  803c21:	89 d1                	mov    %edx,%ecx
  803c23:	89 c6                	mov    %eax,%esi
  803c25:	e9 71 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c30:	72 ea                	jb     803c1c <__umoddi3+0x134>
  803c32:	89 d9                	mov    %ebx,%ecx
  803c34:	e9 62 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
