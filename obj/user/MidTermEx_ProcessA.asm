
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
  80003e:	e8 1d 19 00 00       	call   801960 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 80 3c 80 00       	push   $0x803c80
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 ae 14 00 00       	call   801504 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 82 3c 80 00       	push   $0x803c82
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 98 14 00 00       	call   801504 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 89 3c 80 00       	push   $0x803c89
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 82 14 00 00       	call   801504 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 ff 18 00 00       	call   801993 <sys_get_virtual_time>
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
  8000b7:	e8 a4 36 00 00       	call   803760 <env_sleep>
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
  8000d0:	e8 be 18 00 00       	call   801993 <sys_get_virtual_time>
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
  8000f8:	e8 63 36 00 00       	call   803760 <env_sleep>
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
  80010f:	e8 7f 18 00 00       	call   801993 <sys_get_virtual_time>
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
  800137:	e8 24 36 00 00       	call   803760 <env_sleep>
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
  80014f:	68 97 3c 80 00       	push   $0x803c97
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 aa 35 00 00       	call   803707 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 d0 35 00 00       	call   80373b <signal_semaphore>
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
  800184:	e8 be 17 00 00       	call   801947 <sys_getenvindex>
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
  8001f2:	e8 d4 14 00 00       	call   8016cb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 b4 3c 80 00       	push   $0x803cb4
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
  800222:	68 dc 3c 80 00       	push   $0x803cdc
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
  800253:	68 04 3d 80 00       	push   $0x803d04
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 5c 3d 80 00       	push   $0x803d5c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 b4 3c 80 00       	push   $0x803cb4
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 54 14 00 00       	call   8016e5 <sys_unlock_cons>
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
  8002a4:	e8 6a 16 00 00       	call   801913 <sys_destroy_env>
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
  8002b5:	e8 bf 16 00 00       	call   801979 <sys_exit_env>
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
  800303:	e8 81 13 00 00       	call   801689 <sys_cputs>
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
  80037a:	e8 0a 13 00 00       	call   801689 <sys_cputs>
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
  8003c4:	e8 02 13 00 00       	call   8016cb <sys_lock_cons>
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
  8003e4:	e8 fc 12 00 00       	call   8016e5 <sys_unlock_cons>
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
  80042e:	e8 cd 35 00 00       	call   803a00 <__udivdi3>
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
  80047e:	e8 8d 36 00 00       	call   803b10 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 94 3f 80 00       	add    $0x803f94,%eax
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
  8005d9:	8b 04 85 b8 3f 80 00 	mov    0x803fb8(,%eax,4),%eax
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
  8006ba:	8b 34 9d 00 3e 80 00 	mov    0x803e00(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 a5 3f 80 00       	push   $0x803fa5
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
  8006df:	68 ae 3f 80 00       	push   $0x803fae
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
  80070c:	be b1 3f 80 00       	mov    $0x803fb1,%esi
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
  801117:	68 28 41 80 00       	push   $0x804128
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 4a 41 80 00       	push   $0x80414a
  801126:	e8 e9 26 00 00       	call   803814 <_panic>

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
  801137:	e8 f8 0a 00 00       	call   801c34 <sys_sbrk>
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
  8011b2:	e8 01 09 00 00       	call   801ab8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 41 0e 00 00       	call   802007 <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 13 09 00 00       	call   801ae9 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 da 12 00 00       	call   8024c3 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80121d:	a1 20 50 80 00       	mov    0x805020,%eax
  801222:	8b 40 78             	mov    0x78(%eax),%eax
  801225:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801228:	29 c2                	sub    %eax,%edx
  80122a:	89 d0                	mov    %edx,%eax
  80122c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801231:	c1 e8 0c             	shr    $0xc,%eax
  801234:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80123b:	85 c0                	test   %eax,%eax
  80123d:	0f 85 ab 00 00 00    	jne    8012ee <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	05 00 10 00 00       	add    $0x1000,%eax
  80124b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80124e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  801281:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	74 08                	je     801294 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  8012d8:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  8012ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012f2:	75 16                	jne    80130a <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012f4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012fb:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801302:	0f 86 15 ff ff ff    	jbe    80121d <malloc+0xdc>
  801308:	eb 01                	jmp    80130b <malloc+0x1ca>
				}
				

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
  80133a:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	ff 75 f0             	pushl  -0x10(%ebp)
  80134a:	e8 1c 09 00 00       	call   801c6b <sys_allocate_user_mem>
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	eb 07                	jmp    80135b <malloc+0x21a>
		
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
  801392:	e8 f0 08 00 00       	call   801c87 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 00 1b 00 00       	call   802ea8 <free_block>
  8013a8:	83 c4 10             	add    $0x10,%esp
		}

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
  8013dd:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8013e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8013e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ea:	c1 e0 0c             	shl    $0xc,%eax
  8013ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013f7:	eb 42                	jmp    80143b <free+0xdb>
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
  80141a:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801421:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	e8 1a 08 00 00       	call   801c4f <sys_free_user_mem>
  801435:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801438:	ff 45 f4             	incl   -0xc(%ebp)
  80143b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801441:	72 b6                	jb     8013f9 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801443:	eb 17                	jmp    80145c <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 58 41 80 00       	push   $0x804158
  80144d:	68 87 00 00 00       	push   $0x87
  801452:	68 82 41 80 00       	push   $0x804182
  801457:	e8 b8 23 00 00       	call   803814 <_panic>
	}
}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 28             	sub    $0x28,%esp
  801465:	8b 45 10             	mov    0x10(%ebp),%eax
  801468:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80146b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146f:	75 0a                	jne    80147b <smalloc+0x1c>
  801471:	b8 00 00 00 00       	mov    $0x0,%eax
  801476:	e9 87 00 00 00       	jmp    801502 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801481:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801488:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	39 d0                	cmp    %edx,%eax
  801490:	73 02                	jae    801494 <smalloc+0x35>
  801492:	89 d0                	mov    %edx,%eax
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	50                   	push   %eax
  801498:	e8 a4 fc ff ff       	call   801141 <malloc>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8014a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a7:	75 07                	jne    8014b0 <smalloc+0x51>
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	eb 52                	jmp    801502 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014b0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b7:	50                   	push   %eax
  8014b8:	ff 75 0c             	pushl  0xc(%ebp)
  8014bb:	ff 75 08             	pushl  0x8(%ebp)
  8014be:	e8 93 03 00 00       	call   801856 <sys_createSharedObject>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014cd:	74 06                	je     8014d5 <smalloc+0x76>
  8014cf:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d3:	75 07                	jne    8014dc <smalloc+0x7d>
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	eb 26                	jmp    801502 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8014dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014df:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e4:	8b 40 78             	mov    0x78(%eax),%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014f0:	c1 e8 0c             	shr    $0xc,%eax
  8014f3:	89 c2                	mov    %eax,%edx
  8014f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f8:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8014ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	ff 75 08             	pushl  0x8(%ebp)
  801513:	e8 68 03 00 00       	call   801880 <sys_getSizeOfSharedObject>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80151e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801522:	75 07                	jne    80152b <sget+0x27>
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
  801529:	eb 7f                	jmp    8015aa <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801531:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801538:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	39 d0                	cmp    %edx,%eax
  801540:	73 02                	jae    801544 <sget+0x40>
  801542:	89 d0                	mov    %edx,%eax
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	50                   	push   %eax
  801548:	e8 f4 fb ff ff       	call   801141 <malloc>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801553:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801557:	75 07                	jne    801560 <sget+0x5c>
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 4a                	jmp    8015aa <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	ff 75 e8             	pushl  -0x18(%ebp)
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	e8 2c 03 00 00       	call   80189d <sys_getSharedObject>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801577:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80157a:	a1 20 50 80 00       	mov    0x805020,%eax
  80157f:	8b 40 78             	mov    0x78(%eax),%eax
  801582:	29 c2                	sub    %eax,%edx
  801584:	89 d0                	mov    %edx,%eax
  801586:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158b:	c1 e8 0c             	shr    $0xc,%eax
  80158e:	89 c2                	mov    %eax,%edx
  801590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801593:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80159a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80159e:	75 07                	jne    8015a7 <sget+0xa3>
  8015a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a5:	eb 03                	jmp    8015aa <sget+0xa6>
	return ptr;
  8015a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ba:	8b 40 78             	mov    0x78(%eax),%eax
  8015bd:	29 c2                	sub    %eax,%edx
  8015bf:	89 d0                	mov    %edx,%eax
  8015c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c6:	c1 e8 0c             	shr    $0xc,%eax
  8015c9:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dc:	e8 db 02 00 00       	call   8018bc <sys_freeSharedObject>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015e7:	90                   	nop
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	68 90 41 80 00       	push   $0x804190
  8015f8:	68 e4 00 00 00       	push   $0xe4
  8015fd:	68 82 41 80 00       	push   $0x804182
  801602:	e8 0d 22 00 00       	call   803814 <_panic>

00801607 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 b6 41 80 00       	push   $0x8041b6
  801615:	68 f0 00 00 00       	push   $0xf0
  80161a:	68 82 41 80 00       	push   $0x804182
  80161f:	e8 f0 21 00 00       	call   803814 <_panic>

00801624 <shrink>:

}
void shrink(uint32 newSize)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 b6 41 80 00       	push   $0x8041b6
  801632:	68 f5 00 00 00       	push   $0xf5
  801637:	68 82 41 80 00       	push   $0x804182
  80163c:	e8 d3 21 00 00       	call   803814 <_panic>

00801641 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	68 b6 41 80 00       	push   $0x8041b6
  80164f:	68 fa 00 00 00       	push   $0xfa
  801654:	68 82 41 80 00       	push   $0x804182
  801659:	e8 b6 21 00 00       	call   803814 <_panic>

0080165e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801670:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801673:	8b 7d 18             	mov    0x18(%ebp),%edi
  801676:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801679:	cd 30                	int    $0x30
  80167b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	5b                   	pop    %ebx
  801685:	5e                   	pop    %esi
  801686:	5f                   	pop    %edi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    

00801689 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801695:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	52                   	push   %edx
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	50                   	push   %eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	e8 b2 ff ff ff       	call   80165e <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 02                	push   $0x2
  8016c1:	e8 98 ff ff ff       	call   80165e <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 03                	push   $0x3
  8016da:	e8 7f ff ff ff       	call   80165e <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	90                   	nop
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 04                	push   $0x4
  8016f4:	e8 65 ff ff ff       	call   80165e <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	90                   	nop
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	6a 08                	push   $0x8
  801712:	e8 47 ff ff ff       	call   80165e <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801721:	8b 75 18             	mov    0x18(%ebp),%esi
  801724:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801727:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	51                   	push   %ecx
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 09                	push   $0x9
  801737:	e8 22 ff ff ff       	call   80165e <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	52                   	push   %edx
  801756:	50                   	push   %eax
  801757:	6a 0a                	push   $0xa
  801759:	e8 00 ff ff ff       	call   80165e <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 0b                	push   $0xb
  801774:	e8 e5 fe ff ff       	call   80165e <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 0c                	push   $0xc
  80178d:	e8 cc fe ff ff       	call   80165e <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 0d                	push   $0xd
  8017a6:	e8 b3 fe ff ff       	call   80165e <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 0e                	push   $0xe
  8017bf:	e8 9a fe ff ff       	call   80165e <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 0f                	push   $0xf
  8017d8:	e8 81 fe ff ff       	call   80165e <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	ff 75 08             	pushl  0x8(%ebp)
  8017f0:	6a 10                	push   $0x10
  8017f2:	e8 67 fe ff ff       	call   80165e <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 11                	push   $0x11
  80180b:	e8 4e fe ff ff       	call   80165e <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	90                   	nop
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_cputc>:

void
sys_cputc(const char c)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801822:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	50                   	push   %eax
  80182f:	6a 01                	push   $0x1
  801831:	e8 28 fe ff ff       	call   80165e <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 14                	push   $0x14
  80184b:	e8 0e fe ff ff       	call   80165e <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801862:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801865:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	51                   	push   %ecx
  80186f:	52                   	push   %edx
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	50                   	push   %eax
  801874:	6a 15                	push   $0x15
  801876:	e8 e3 fd ff ff       	call   80165e <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801883:	8b 55 0c             	mov    0xc(%ebp),%edx
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	6a 16                	push   $0x16
  801893:	e8 c6 fd ff ff       	call   80165e <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	51                   	push   %ecx
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	6a 17                	push   $0x17
  8018b2:	e8 a7 fd ff ff       	call   80165e <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 18                	push   $0x18
  8018cf:	e8 8a fd ff ff       	call   80165e <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 14             	pushl  0x14(%ebp)
  8018e4:	ff 75 10             	pushl  0x10(%ebp)
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	50                   	push   %eax
  8018eb:	6a 19                	push   $0x19
  8018ed:	e8 6c fd ff ff       	call   80165e <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	50                   	push   %eax
  801906:	6a 1a                	push   $0x1a
  801908:	e8 51 fd ff ff       	call   80165e <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	90                   	nop
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	50                   	push   %eax
  801922:	6a 1b                	push   $0x1b
  801924:	e8 35 fd ff ff       	call   80165e <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 05                	push   $0x5
  80193d:	e8 1c fd ff ff       	call   80165e <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 06                	push   $0x6
  801956:	e8 03 fd ff ff       	call   80165e <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 07                	push   $0x7
  80196f:	e8 ea fc ff ff       	call   80165e <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_exit_env>:


void sys_exit_env(void)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 1c                	push   $0x1c
  801988:	e8 d1 fc ff ff       	call   80165e <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	90                   	nop
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801999:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199c:	8d 50 04             	lea    0x4(%eax),%edx
  80199f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 1d                	push   $0x1d
  8019ac:	e8 ad fc ff ff       	call   80165e <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019bd:	89 01                	mov    %eax,(%ecx)
  8019bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	c9                   	leave  
  8019c6:	c2 04 00             	ret    $0x4

008019c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	ff 75 10             	pushl  0x10(%ebp)
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 13                	push   $0x13
  8019db:	e8 7e fc ff ff       	call   80165e <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 1e                	push   $0x1e
  8019f5:	e8 64 fc ff ff       	call   80165e <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	50                   	push   %eax
  801a18:	6a 1f                	push   $0x1f
  801a1a:	e8 3f fc ff ff       	call   80165e <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <rsttst>:
void rsttst()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 21                	push   $0x21
  801a34:	e8 25 fc ff ff       	call   80165e <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4b:	8b 55 18             	mov    0x18(%ebp),%edx
  801a4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a52:	52                   	push   %edx
  801a53:	50                   	push   %eax
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 20                	push   $0x20
  801a5f:	e8 fa fb ff ff       	call   80165e <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return ;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <chktst>:
void chktst(uint32 n)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 08             	pushl  0x8(%ebp)
  801a78:	6a 22                	push   $0x22
  801a7a:	e8 df fb ff ff       	call   80165e <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <inctst>:

void inctst()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 23                	push   $0x23
  801a94:	e8 c5 fb ff ff       	call   80165e <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9c:	90                   	nop
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <gettst>:
uint32 gettst()
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 24                	push   $0x24
  801aae:	e8 ab fb ff ff       	call   80165e <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 25                	push   $0x25
  801aca:	e8 8f fb ff ff       	call   80165e <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
  801ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ad5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ad9:	75 07                	jne    801ae2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801adb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae0:	eb 05                	jmp    801ae7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 25                	push   $0x25
  801afb:	e8 5e fb ff ff       	call   80165e <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
  801b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b06:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b0a:	75 07                	jne    801b13 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b11:	eb 05                	jmp    801b18 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 25                	push   $0x25
  801b2c:	e8 2d fb ff ff       	call   80165e <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
  801b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b37:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b3b:	75 07                	jne    801b44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b42:	eb 05                	jmp    801b49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 25                	push   $0x25
  801b5d:	e8 fc fa ff ff       	call   80165e <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
  801b65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b68:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b6c:	75 07                	jne    801b75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	eb 05                	jmp    801b7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	6a 26                	push   $0x26
  801b8c:	e8 cd fa ff ff       	call   80165e <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	53                   	push   %ebx
  801baa:	51                   	push   %ecx
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 27                	push   $0x27
  801baf:	e8 aa fa ff ff       	call   80165e <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	6a 28                	push   $0x28
  801bcf:	e8 8a fa ff ff       	call   80165e <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bdc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	6a 00                	push   $0x0
  801be7:	51                   	push   %ecx
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	52                   	push   %edx
  801bec:	50                   	push   %eax
  801bed:	6a 29                	push   $0x29
  801bef:	e8 6a fa ff ff       	call   80165e <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	ff 75 10             	pushl  0x10(%ebp)
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 12                	push   $0x12
  801c0b:	e8 4e fa ff ff       	call   80165e <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 2a                	push   $0x2a
  801c29:	e8 30 fa ff ff       	call   80165e <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
	return;
  801c31:	90                   	nop
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	50                   	push   %eax
  801c43:	6a 2b                	push   $0x2b
  801c45:	e8 14 fa ff ff       	call   80165e <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 2c                	push   $0x2c
  801c60:	e8 f9 f9 ff ff       	call   80165e <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	6a 2d                	push   $0x2d
  801c7c:	e8 dd f9 ff ff       	call   80165e <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	83 e8 04             	sub    $0x4,%eax
  801c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c99:	8b 00                	mov    (%eax),%eax
  801c9b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	83 e8 04             	sub    $0x4,%eax
  801cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cb2:	8b 00                	mov    (%eax),%eax
  801cb4:	83 e0 01             	and    $0x1,%eax
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	0f 94 c0             	sete   %al
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	83 f8 02             	cmp    $0x2,%eax
  801cd1:	74 2b                	je     801cfe <alloc_block+0x40>
  801cd3:	83 f8 02             	cmp    $0x2,%eax
  801cd6:	7f 07                	jg     801cdf <alloc_block+0x21>
  801cd8:	83 f8 01             	cmp    $0x1,%eax
  801cdb:	74 0e                	je     801ceb <alloc_block+0x2d>
  801cdd:	eb 58                	jmp    801d37 <alloc_block+0x79>
  801cdf:	83 f8 03             	cmp    $0x3,%eax
  801ce2:	74 2d                	je     801d11 <alloc_block+0x53>
  801ce4:	83 f8 04             	cmp    $0x4,%eax
  801ce7:	74 3b                	je     801d24 <alloc_block+0x66>
  801ce9:	eb 4c                	jmp    801d37 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	e8 11 03 00 00       	call   802007 <alloc_block_FF>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cfc:	eb 4a                	jmp    801d48 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	e8 c7 19 00 00       	call   8036d0 <alloc_block_NF>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d0f:	eb 37                	jmp    801d48 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	e8 a7 07 00 00       	call   8024c3 <alloc_block_BF>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d22:	eb 24                	jmp    801d48 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	e8 84 19 00 00       	call   8036b3 <alloc_block_WF>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d35:	eb 11                	jmp    801d48 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d37:	83 ec 0c             	sub    $0xc,%esp
  801d3a:	68 c8 41 80 00       	push   $0x8041c8
  801d3f:	e8 4d e6 ff ff       	call   800391 <cprintf>
  801d44:	83 c4 10             	add    $0x10,%esp
		break;
  801d47:	90                   	nop
	}
	return va;
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	53                   	push   %ebx
  801d51:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	68 e8 41 80 00       	push   $0x8041e8
  801d5c:	e8 30 e6 ff ff       	call   800391 <cprintf>
  801d61:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	68 13 42 80 00       	push   $0x804213
  801d6c:	e8 20 e6 ff ff       	call   800391 <cprintf>
  801d71:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7a:	eb 37                	jmp    801db3 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d82:	e8 19 ff ff ff       	call   801ca0 <is_free_block>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	0f be d8             	movsbl %al,%ebx
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	ff 75 f4             	pushl  -0xc(%ebp)
  801d93:	e8 ef fe ff ff       	call   801c87 <get_block_size>
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	53                   	push   %ebx
  801d9f:	50                   	push   %eax
  801da0:	68 2b 42 80 00       	push   $0x80422b
  801da5:	e8 e7 e5 ff ff       	call   800391 <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801dad:	8b 45 10             	mov    0x10(%ebp),%eax
  801db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db7:	74 07                	je     801dc0 <print_blocks_list+0x73>
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 00                	mov    (%eax),%eax
  801dbe:	eb 05                	jmp    801dc5 <print_blocks_list+0x78>
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc5:	89 45 10             	mov    %eax,0x10(%ebp)
  801dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	75 ad                	jne    801d7c <print_blocks_list+0x2f>
  801dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd3:	75 a7                	jne    801d7c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	68 e8 41 80 00       	push   $0x8041e8
  801ddd:	e8 af e5 ff ff       	call   800391 <cprintf>
  801de2:	83 c4 10             	add    $0x10,%esp

}
  801de5:	90                   	nop
  801de6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	83 e0 01             	and    $0x1,%eax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	74 03                	je     801dfe <initialize_dynamic_allocator+0x13>
  801dfb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801dfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e02:	0f 84 c7 01 00 00    	je     801fcf <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e08:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e0f:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e12:	8b 55 08             	mov    0x8(%ebp),%edx
  801e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e18:	01 d0                	add    %edx,%eax
  801e1a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e1f:	0f 87 ad 01 00 00    	ja     801fd2 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	0f 89 a5 01 00 00    	jns    801fd5 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e30:	8b 55 08             	mov    0x8(%ebp),%edx
  801e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e36:	01 d0                	add    %edx,%eax
  801e38:	83 e8 04             	sub    $0x4,%eax
  801e3b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e47:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4f:	e9 87 00 00 00       	jmp    801edb <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e58:	75 14                	jne    801e6e <initialize_dynamic_allocator+0x83>
  801e5a:	83 ec 04             	sub    $0x4,%esp
  801e5d:	68 43 42 80 00       	push   $0x804243
  801e62:	6a 79                	push   $0x79
  801e64:	68 61 42 80 00       	push   $0x804261
  801e69:	e8 a6 19 00 00       	call   803814 <_panic>
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	8b 00                	mov    (%eax),%eax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	74 10                	je     801e87 <initialize_dynamic_allocator+0x9c>
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	8b 00                	mov    (%eax),%eax
  801e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7f:	8b 52 04             	mov    0x4(%edx),%edx
  801e82:	89 50 04             	mov    %edx,0x4(%eax)
  801e85:	eb 0b                	jmp    801e92 <initialize_dynamic_allocator+0xa7>
  801e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8a:	8b 40 04             	mov    0x4(%eax),%eax
  801e8d:	a3 30 50 80 00       	mov    %eax,0x805030
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 40 04             	mov    0x4(%eax),%eax
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	74 0f                	je     801eab <initialize_dynamic_allocator+0xc0>
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 40 04             	mov    0x4(%eax),%eax
  801ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea5:	8b 12                	mov    (%edx),%edx
  801ea7:	89 10                	mov    %edx,(%eax)
  801ea9:	eb 0a                	jmp    801eb5 <initialize_dynamic_allocator+0xca>
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 00                	mov    (%eax),%eax
  801eb0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ec8:	a1 38 50 80 00       	mov    0x805038,%eax
  801ecd:	48                   	dec    %eax
  801ece:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ed3:	a1 34 50 80 00       	mov    0x805034,%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edf:	74 07                	je     801ee8 <initialize_dynamic_allocator+0xfd>
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	eb 05                	jmp    801eed <initialize_dynamic_allocator+0x102>
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	a3 34 50 80 00       	mov    %eax,0x805034
  801ef2:	a1 34 50 80 00       	mov    0x805034,%eax
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	0f 85 55 ff ff ff    	jne    801e54 <initialize_dynamic_allocator+0x69>
  801eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f03:	0f 85 4b ff ff ff    	jne    801e54 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f12:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f18:	a1 44 50 80 00       	mov    0x805044,%eax
  801f1d:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f22:	a1 40 50 80 00       	mov    0x805040,%eax
  801f27:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	83 c0 08             	add    $0x8,%eax
  801f33:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	83 c0 04             	add    $0x4,%eax
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	83 ea 08             	sub    $0x8,%edx
  801f42:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	83 e8 08             	sub    $0x8,%eax
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	83 ea 08             	sub    $0x8,%edx
  801f55:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f6e:	75 17                	jne    801f87 <initialize_dynamic_allocator+0x19c>
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	68 7c 42 80 00       	push   $0x80427c
  801f78:	68 90 00 00 00       	push   $0x90
  801f7d:	68 61 42 80 00       	push   $0x804261
  801f82:	e8 8d 18 00 00       	call   803814 <_panic>
  801f87:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f90:	89 10                	mov    %edx,(%eax)
  801f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	74 0d                	je     801fa8 <initialize_dynamic_allocator+0x1bd>
  801f9b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fa3:	89 50 04             	mov    %edx,0x4(%eax)
  801fa6:	eb 08                	jmp    801fb0 <initialize_dynamic_allocator+0x1c5>
  801fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fab:	a3 30 50 80 00       	mov    %eax,0x805030
  801fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc2:	a1 38 50 80 00       	mov    0x805038,%eax
  801fc7:	40                   	inc    %eax
  801fc8:	a3 38 50 80 00       	mov    %eax,0x805038
  801fcd:	eb 07                	jmp    801fd6 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fcf:	90                   	nop
  801fd0:	eb 04                	jmp    801fd6 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fd2:	90                   	nop
  801fd3:	eb 01                	jmp    801fd6 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fd5:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	83 e8 04             	sub    $0x4,%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	83 e0 fe             	and    $0xfffffffe,%eax
  801ff7:	8d 50 f8             	lea    -0x8(%eax),%edx
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	01 c2                	add    %eax,%edx
  801fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802002:	89 02                	mov    %eax,(%edx)
}
  802004:	90                   	nop
  802005:	5d                   	pop    %ebp
  802006:	c3                   	ret    

00802007 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	83 e0 01             	and    $0x1,%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	74 03                	je     80201a <alloc_block_FF+0x13>
  802017:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80201a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80201e:	77 07                	ja     802027 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802020:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802027:	a1 24 50 80 00       	mov    0x805024,%eax
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 73                	jne    8020a3 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	83 c0 10             	add    $0x10,%eax
  802036:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802039:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802040:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802046:	01 d0                	add    %edx,%eax
  802048:	48                   	dec    %eax
  802049:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80204c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204f:	ba 00 00 00 00       	mov    $0x0,%edx
  802054:	f7 75 ec             	divl   -0x14(%ebp)
  802057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205a:	29 d0                	sub    %edx,%eax
  80205c:	c1 e8 0c             	shr    $0xc,%eax
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	50                   	push   %eax
  802063:	e8 c3 f0 ff ff       	call   80112b <sbrk>
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80206e:	83 ec 0c             	sub    $0xc,%esp
  802071:	6a 00                	push   $0x0
  802073:	e8 b3 f0 ff ff       	call   80112b <sbrk>
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80207e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802081:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802084:	83 ec 08             	sub    $0x8,%esp
  802087:	50                   	push   %eax
  802088:	ff 75 e4             	pushl  -0x1c(%ebp)
  80208b:	e8 5b fd ff ff       	call   801deb <initialize_dynamic_allocator>
  802090:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	68 9f 42 80 00       	push   $0x80429f
  80209b:	e8 f1 e2 ff ff       	call   800391 <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a7:	75 0a                	jne    8020b3 <alloc_block_FF+0xac>
	        return NULL;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	e9 0e 04 00 00       	jmp    8024c1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c2:	e9 f3 02 00 00       	jmp    8023ba <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8020d3:	e8 af fb ff ff       	call   801c87 <get_block_size>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	83 c0 08             	add    $0x8,%eax
  8020e4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020e7:	0f 87 c5 02 00 00    	ja     8023b2 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	83 c0 18             	add    $0x18,%eax
  8020f3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020f6:	0f 87 19 02 00 00    	ja     802315 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020fc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802102:	83 e8 08             	sub    $0x8,%eax
  802105:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	8d 50 08             	lea    0x8(%eax),%edx
  80210e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802111:	01 d0                	add    %edx,%eax
  802113:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	83 c0 08             	add    $0x8,%eax
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	6a 01                	push   $0x1
  802121:	50                   	push   %eax
  802122:	ff 75 bc             	pushl  -0x44(%ebp)
  802125:	e8 ae fe ff ff       	call   801fd8 <set_block_data>
  80212a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 40 04             	mov    0x4(%eax),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	75 68                	jne    80219f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802137:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80213b:	75 17                	jne    802154 <alloc_block_FF+0x14d>
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	68 7c 42 80 00       	push   $0x80427c
  802145:	68 d7 00 00 00       	push   $0xd7
  80214a:	68 61 42 80 00       	push   $0x804261
  80214f:	e8 c0 16 00 00       	call   803814 <_panic>
  802154:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80215a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80215d:	89 10                	mov    %edx,(%eax)
  80215f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	74 0d                	je     802175 <alloc_block_FF+0x16e>
  802168:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80216d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 08                	jmp    80217d <alloc_block_FF+0x176>
  802175:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802178:	a3 30 50 80 00       	mov    %eax,0x805030
  80217d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802180:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802185:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218f:	a1 38 50 80 00       	mov    0x805038,%eax
  802194:	40                   	inc    %eax
  802195:	a3 38 50 80 00       	mov    %eax,0x805038
  80219a:	e9 dc 00 00 00       	jmp    80227b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	8b 00                	mov    (%eax),%eax
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	75 65                	jne    80220d <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021a8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021ac:	75 17                	jne    8021c5 <alloc_block_FF+0x1be>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 b0 42 80 00       	push   $0x8042b0
  8021b6:	68 db 00 00 00       	push   $0xdb
  8021bb:	68 61 42 80 00       	push   $0x804261
  8021c0:	e8 4f 16 00 00       	call   803814 <_panic>
  8021c5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d4:	8b 40 04             	mov    0x4(%eax),%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	74 0c                	je     8021e7 <alloc_block_FF+0x1e0>
  8021db:	a1 30 50 80 00       	mov    0x805030,%eax
  8021e0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021e3:	89 10                	mov    %edx,(%eax)
  8021e5:	eb 08                	jmp    8021ef <alloc_block_FF+0x1e8>
  8021e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8021f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802200:	a1 38 50 80 00       	mov    0x805038,%eax
  802205:	40                   	inc    %eax
  802206:	a3 38 50 80 00       	mov    %eax,0x805038
  80220b:	eb 6e                	jmp    80227b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80220d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802211:	74 06                	je     802219 <alloc_block_FF+0x212>
  802213:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802217:	75 17                	jne    802230 <alloc_block_FF+0x229>
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	68 d4 42 80 00       	push   $0x8042d4
  802221:	68 df 00 00 00       	push   $0xdf
  802226:	68 61 42 80 00       	push   $0x804261
  80222b:	e8 e4 15 00 00       	call   803814 <_panic>
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 10                	mov    (%eax),%edx
  802235:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802238:	89 10                	mov    %edx,(%eax)
  80223a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 0b                	je     80224e <alloc_block_FF+0x247>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80224b:	89 50 04             	mov    %edx,0x4(%eax)
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802254:	89 10                	mov    %edx,(%eax)
  802256:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	75 08                	jne    802270 <alloc_block_FF+0x269>
  802268:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226b:	a3 30 50 80 00       	mov    %eax,0x805030
  802270:	a1 38 50 80 00       	mov    0x805038,%eax
  802275:	40                   	inc    %eax
  802276:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80227b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227f:	75 17                	jne    802298 <alloc_block_FF+0x291>
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	68 43 42 80 00       	push   $0x804243
  802289:	68 e1 00 00 00       	push   $0xe1
  80228e:	68 61 42 80 00       	push   $0x804261
  802293:	e8 7c 15 00 00       	call   803814 <_panic>
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 00                	mov    (%eax),%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 10                	je     8022b1 <alloc_block_FF+0x2aa>
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a9:	8b 52 04             	mov    0x4(%edx),%edx
  8022ac:	89 50 04             	mov    %edx,0x4(%eax)
  8022af:	eb 0b                	jmp    8022bc <alloc_block_FF+0x2b5>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 40 04             	mov    0x4(%eax),%eax
  8022b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 40 04             	mov    0x4(%eax),%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	74 0f                	je     8022d5 <alloc_block_FF+0x2ce>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 40 04             	mov    0x4(%eax),%eax
  8022cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cf:	8b 12                	mov    (%edx),%edx
  8022d1:	89 10                	mov    %edx,(%eax)
  8022d3:	eb 0a                	jmp    8022df <alloc_block_FF+0x2d8>
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f7:	48                   	dec    %eax
  8022f8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	6a 00                	push   $0x0
  802302:	ff 75 b4             	pushl  -0x4c(%ebp)
  802305:	ff 75 b0             	pushl  -0x50(%ebp)
  802308:	e8 cb fc ff ff       	call   801fd8 <set_block_data>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	e9 95 00 00 00       	jmp    8023aa <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	6a 01                	push   $0x1
  80231a:	ff 75 b8             	pushl  -0x48(%ebp)
  80231d:	ff 75 bc             	pushl  -0x44(%ebp)
  802320:	e8 b3 fc ff ff       	call   801fd8 <set_block_data>
  802325:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232c:	75 17                	jne    802345 <alloc_block_FF+0x33e>
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 43 42 80 00       	push   $0x804243
  802336:	68 e8 00 00 00       	push   $0xe8
  80233b:	68 61 42 80 00       	push   $0x804261
  802340:	e8 cf 14 00 00       	call   803814 <_panic>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	74 10                	je     80235e <alloc_block_FF+0x357>
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	8b 52 04             	mov    0x4(%edx),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	eb 0b                	jmp    802369 <alloc_block_FF+0x362>
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 04             	mov    0x4(%eax),%eax
  802364:	a3 30 50 80 00       	mov    %eax,0x805030
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 0f                	je     802382 <alloc_block_FF+0x37b>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 04             	mov    0x4(%eax),%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	8b 12                	mov    (%edx),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 0a                	jmp    80238c <alloc_block_FF+0x385>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239f:	a1 38 50 80 00       	mov    0x805038,%eax
  8023a4:	48                   	dec    %eax
  8023a5:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8023aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ad:	e9 0f 01 00 00       	jmp    8024c1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8023b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023be:	74 07                	je     8023c7 <alloc_block_FF+0x3c0>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	eb 05                	jmp    8023cc <alloc_block_FF+0x3c5>
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cc:	a3 34 50 80 00       	mov    %eax,0x805034
  8023d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	0f 85 e9 fc ff ff    	jne    8020c7 <alloc_block_FF+0xc0>
  8023de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e2:	0f 85 df fc ff ff    	jne    8020c7 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	83 c0 08             	add    $0x8,%eax
  8023ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023f1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023fe:	01 d0                	add    %edx,%eax
  802400:	48                   	dec    %eax
  802401:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802404:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802407:	ba 00 00 00 00       	mov    $0x0,%edx
  80240c:	f7 75 d8             	divl   -0x28(%ebp)
  80240f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802412:	29 d0                	sub    %edx,%eax
  802414:	c1 e8 0c             	shr    $0xc,%eax
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	50                   	push   %eax
  80241b:	e8 0b ed ff ff       	call   80112b <sbrk>
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802426:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80242a:	75 0a                	jne    802436 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80242c:	b8 00 00 00 00       	mov    $0x0,%eax
  802431:	e9 8b 00 00 00       	jmp    8024c1 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802436:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80243d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802440:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802443:	01 d0                	add    %edx,%eax
  802445:	48                   	dec    %eax
  802446:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80244c:	ba 00 00 00 00       	mov    $0x0,%edx
  802451:	f7 75 cc             	divl   -0x34(%ebp)
  802454:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802457:	29 d0                	sub    %edx,%eax
  802459:	8d 50 fc             	lea    -0x4(%eax),%edx
  80245c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80245f:	01 d0                	add    %edx,%eax
  802461:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802466:	a1 40 50 80 00       	mov    0x805040,%eax
  80246b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802471:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802478:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80247b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80247e:	01 d0                	add    %edx,%eax
  802480:	48                   	dec    %eax
  802481:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802484:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802487:	ba 00 00 00 00       	mov    $0x0,%edx
  80248c:	f7 75 c4             	divl   -0x3c(%ebp)
  80248f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802492:	29 d0                	sub    %edx,%eax
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	6a 01                	push   $0x1
  802499:	50                   	push   %eax
  80249a:	ff 75 d0             	pushl  -0x30(%ebp)
  80249d:	e8 36 fb ff ff       	call   801fd8 <set_block_data>
  8024a2:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024a5:	83 ec 0c             	sub    $0xc,%esp
  8024a8:	ff 75 d0             	pushl  -0x30(%ebp)
  8024ab:	e8 f8 09 00 00       	call   802ea8 <free_block>
  8024b0:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	e8 49 fb ff ff       	call   802007 <alloc_block_FF>
  8024be:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	83 e0 01             	and    $0x1,%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 03                	je     8024d6 <alloc_block_BF+0x13>
  8024d3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024d6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024da:	77 07                	ja     8024e3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024dc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024e3:	a1 24 50 80 00       	mov    0x805024,%eax
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	75 73                	jne    80255f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	83 c0 10             	add    $0x10,%eax
  8024f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024f5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802502:	01 d0                	add    %edx,%eax
  802504:	48                   	dec    %eax
  802505:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802508:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80250b:	ba 00 00 00 00       	mov    $0x0,%edx
  802510:	f7 75 e0             	divl   -0x20(%ebp)
  802513:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802516:	29 d0                	sub    %edx,%eax
  802518:	c1 e8 0c             	shr    $0xc,%eax
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	50                   	push   %eax
  80251f:	e8 07 ec ff ff       	call   80112b <sbrk>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	6a 00                	push   $0x0
  80252f:	e8 f7 eb ff ff       	call   80112b <sbrk>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80253a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80253d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802540:	83 ec 08             	sub    $0x8,%esp
  802543:	50                   	push   %eax
  802544:	ff 75 d8             	pushl  -0x28(%ebp)
  802547:	e8 9f f8 ff ff       	call   801deb <initialize_dynamic_allocator>
  80254c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	68 9f 42 80 00       	push   $0x80429f
  802557:	e8 35 de ff ff       	call   800391 <cprintf>
  80255c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80255f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80256d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802574:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80257b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802583:	e9 1d 01 00 00       	jmp    8026a5 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80258e:	83 ec 0c             	sub    $0xc,%esp
  802591:	ff 75 a8             	pushl  -0x58(%ebp)
  802594:	e8 ee f6 ff ff       	call   801c87 <get_block_size>
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	83 c0 08             	add    $0x8,%eax
  8025a5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025a8:	0f 87 ef 00 00 00    	ja     80269d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	83 c0 18             	add    $0x18,%eax
  8025b4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025b7:	77 1d                	ja     8025d6 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025bf:	0f 86 d8 00 00 00    	jbe    80269d <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025cb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025d1:	e9 c7 00 00 00       	jmp    80269d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	83 c0 08             	add    $0x8,%eax
  8025dc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025df:	0f 85 9d 00 00 00    	jne    802682 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	6a 01                	push   $0x1
  8025ea:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025ed:	ff 75 a8             	pushl  -0x58(%ebp)
  8025f0:	e8 e3 f9 ff ff       	call   801fd8 <set_block_data>
  8025f5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fc:	75 17                	jne    802615 <alloc_block_BF+0x152>
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 43 42 80 00       	push   $0x804243
  802606:	68 2c 01 00 00       	push   $0x12c
  80260b:	68 61 42 80 00       	push   $0x804261
  802610:	e8 ff 11 00 00       	call   803814 <_panic>
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 10                	je     80262e <alloc_block_BF+0x16b>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802626:	8b 52 04             	mov    0x4(%edx),%edx
  802629:	89 50 04             	mov    %edx,0x4(%eax)
  80262c:	eb 0b                	jmp    802639 <alloc_block_BF+0x176>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	a3 30 50 80 00       	mov    %eax,0x805030
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 0f                	je     802652 <alloc_block_BF+0x18f>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264c:	8b 12                	mov    (%edx),%edx
  80264e:	89 10                	mov    %edx,(%eax)
  802650:	eb 0a                	jmp    80265c <alloc_block_BF+0x199>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266f:	a1 38 50 80 00       	mov    0x805038,%eax
  802674:	48                   	dec    %eax
  802675:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80267a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80267d:	e9 01 04 00 00       	jmp    802a83 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802685:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802688:	76 13                	jbe    80269d <alloc_block_BF+0x1da>
					{
						internal = 1;
  80268a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802691:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802694:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802697:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80269a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80269d:	a1 34 50 80 00       	mov    0x805034,%eax
  8026a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a9:	74 07                	je     8026b2 <alloc_block_BF+0x1ef>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	eb 05                	jmp    8026b7 <alloc_block_BF+0x1f4>
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8026bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	0f 85 bf fe ff ff    	jne    802588 <alloc_block_BF+0xc5>
  8026c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cd:	0f 85 b5 fe ff ff    	jne    802588 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d7:	0f 84 26 02 00 00    	je     802903 <alloc_block_BF+0x440>
  8026dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026e1:	0f 85 1c 02 00 00    	jne    802903 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ed:	83 e8 08             	sub    $0x8,%eax
  8026f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	8d 50 08             	lea    0x8(%eax),%edx
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	83 c0 08             	add    $0x8,%eax
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	6a 01                	push   $0x1
  80270c:	50                   	push   %eax
  80270d:	ff 75 f0             	pushl  -0x10(%ebp)
  802710:	e8 c3 f8 ff ff       	call   801fd8 <set_block_data>
  802715:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	75 68                	jne    80278a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802722:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802726:	75 17                	jne    80273f <alloc_block_BF+0x27c>
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 7c 42 80 00       	push   $0x80427c
  802730:	68 45 01 00 00       	push   $0x145
  802735:	68 61 42 80 00       	push   $0x804261
  80273a:	e8 d5 10 00 00       	call   803814 <_panic>
  80273f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802745:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 0d                	je     802760 <alloc_block_BF+0x29d>
  802753:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802758:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80275b:	89 50 04             	mov    %edx,0x4(%eax)
  80275e:	eb 08                	jmp    802768 <alloc_block_BF+0x2a5>
  802760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802763:	a3 30 50 80 00       	mov    %eax,0x805030
  802768:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802770:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	a1 38 50 80 00       	mov    0x805038,%eax
  80277f:	40                   	inc    %eax
  802780:	a3 38 50 80 00       	mov    %eax,0x805038
  802785:	e9 dc 00 00 00       	jmp    802866 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	75 65                	jne    8027f8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802793:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802797:	75 17                	jne    8027b0 <alloc_block_BF+0x2ed>
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	68 b0 42 80 00       	push   $0x8042b0
  8027a1:	68 4a 01 00 00       	push   $0x14a
  8027a6:	68 61 42 80 00       	push   $0x804261
  8027ab:	e8 64 10 00 00       	call   803814 <_panic>
  8027b0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b9:	89 50 04             	mov    %edx,0x4(%eax)
  8027bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0c                	je     8027d2 <alloc_block_BF+0x30f>
  8027c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8027cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
  8027d0:	eb 08                	jmp    8027da <alloc_block_BF+0x317>
  8027d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8027e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f0:	40                   	inc    %eax
  8027f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8027f6:	eb 6e                	jmp    802866 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fc:	74 06                	je     802804 <alloc_block_BF+0x341>
  8027fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802802:	75 17                	jne    80281b <alloc_block_BF+0x358>
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 d4 42 80 00       	push   $0x8042d4
  80280c:	68 4f 01 00 00       	push   $0x14f
  802811:	68 61 42 80 00       	push   $0x804261
  802816:	e8 f9 0f 00 00       	call   803814 <_panic>
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	8b 10                	mov    (%eax),%edx
  802820:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802823:	89 10                	mov    %edx,(%eax)
  802825:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 0b                	je     802839 <alloc_block_BF+0x376>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802836:	89 50 04             	mov    %edx,0x4(%eax)
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80283f:	89 10                	mov    %edx,(%eax)
  802841:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	75 08                	jne    80285b <alloc_block_BF+0x398>
  802853:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802856:	a3 30 50 80 00       	mov    %eax,0x805030
  80285b:	a1 38 50 80 00       	mov    0x805038,%eax
  802860:	40                   	inc    %eax
  802861:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802866:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_BF+0x3c0>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 43 42 80 00       	push   $0x804243
  802874:	68 51 01 00 00       	push   $0x151
  802879:	68 61 42 80 00       	push   $0x804261
  80287e:	e8 91 0f 00 00       	call   803814 <_panic>
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_BF+0x3d9>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_BF+0x3e4>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_BF+0x3fd>
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_BF+0x407>
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	6a 00                	push   $0x0
  8028ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f0:	ff 75 cc             	pushl  -0x34(%ebp)
  8028f3:	e8 e0 f6 ff ff       	call   801fd8 <set_block_data>
  8028f8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	e9 80 01 00 00       	jmp    802a83 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802903:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802907:	0f 85 9d 00 00 00    	jne    8029aa <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	6a 01                	push   $0x1
  802912:	ff 75 ec             	pushl  -0x14(%ebp)
  802915:	ff 75 f0             	pushl  -0x10(%ebp)
  802918:	e8 bb f6 ff ff       	call   801fd8 <set_block_data>
  80291d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802920:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802924:	75 17                	jne    80293d <alloc_block_BF+0x47a>
  802926:	83 ec 04             	sub    $0x4,%esp
  802929:	68 43 42 80 00       	push   $0x804243
  80292e:	68 58 01 00 00       	push   $0x158
  802933:	68 61 42 80 00       	push   $0x804261
  802938:	e8 d7 0e 00 00       	call   803814 <_panic>
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 10                	je     802956 <alloc_block_BF+0x493>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294e:	8b 52 04             	mov    0x4(%edx),%edx
  802951:	89 50 04             	mov    %edx,0x4(%eax)
  802954:	eb 0b                	jmp    802961 <alloc_block_BF+0x49e>
  802956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	a3 30 50 80 00       	mov    %eax,0x805030
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 0f                	je     80297a <alloc_block_BF+0x4b7>
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802974:	8b 12                	mov    (%edx),%edx
  802976:	89 10                	mov    %edx,(%eax)
  802978:	eb 0a                	jmp    802984 <alloc_block_BF+0x4c1>
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802997:	a1 38 50 80 00       	mov    0x805038,%eax
  80299c:	48                   	dec    %eax
  80299d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	e9 d9 00 00 00       	jmp    802a83 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	83 c0 08             	add    $0x8,%eax
  8029b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029b3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029ba:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	48                   	dec    %eax
  8029c3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ce:	f7 75 c4             	divl   -0x3c(%ebp)
  8029d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029d4:	29 d0                	sub    %edx,%eax
  8029d6:	c1 e8 0c             	shr    $0xc,%eax
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	50                   	push   %eax
  8029dd:	e8 49 e7 ff ff       	call   80112b <sbrk>
  8029e2:	83 c4 10             	add    $0x10,%esp
  8029e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029e8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029ec:	75 0a                	jne    8029f8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f3:	e9 8b 00 00 00       	jmp    802a83 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029f8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a02:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a05:	01 d0                	add    %edx,%eax
  802a07:	48                   	dec    %eax
  802a08:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a0b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a13:	f7 75 b8             	divl   -0x48(%ebp)
  802a16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a19:	29 d0                	sub    %edx,%eax
  802a1b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a1e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a21:	01 d0                	add    %edx,%eax
  802a23:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a28:	a1 40 50 80 00       	mov    0x805040,%eax
  802a2d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a33:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a3a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a40:	01 d0                	add    %edx,%eax
  802a42:	48                   	dec    %eax
  802a43:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a46:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a49:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4e:	f7 75 b0             	divl   -0x50(%ebp)
  802a51:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a54:	29 d0                	sub    %edx,%eax
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	6a 01                	push   $0x1
  802a5b:	50                   	push   %eax
  802a5c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a5f:	e8 74 f5 ff ff       	call   801fd8 <set_block_data>
  802a64:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a67:	83 ec 0c             	sub    $0xc,%esp
  802a6a:	ff 75 bc             	pushl  -0x44(%ebp)
  802a6d:	e8 36 04 00 00       	call   802ea8 <free_block>
  802a72:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a75:	83 ec 0c             	sub    $0xc,%esp
  802a78:	ff 75 08             	pushl  0x8(%ebp)
  802a7b:	e8 43 fa ff ff       	call   8024c3 <alloc_block_BF>
  802a80:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
  802a88:	53                   	push   %ebx
  802a89:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9e:	74 1e                	je     802abe <merging+0x39>
  802aa0:	ff 75 08             	pushl  0x8(%ebp)
  802aa3:	e8 df f1 ff ff       	call   801c87 <get_block_size>
  802aa8:	83 c4 04             	add    $0x4,%esp
  802aab:	89 c2                	mov    %eax,%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	01 d0                	add    %edx,%eax
  802ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ab5:	75 07                	jne    802abe <merging+0x39>
		prev_is_free = 1;
  802ab7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802abe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ac2:	74 1e                	je     802ae2 <merging+0x5d>
  802ac4:	ff 75 10             	pushl  0x10(%ebp)
  802ac7:	e8 bb f1 ff ff       	call   801c87 <get_block_size>
  802acc:	83 c4 04             	add    $0x4,%esp
  802acf:	89 c2                	mov    %eax,%edx
  802ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad4:	01 d0                	add    %edx,%eax
  802ad6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ad9:	75 07                	jne    802ae2 <merging+0x5d>
		next_is_free = 1;
  802adb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae6:	0f 84 cc 00 00 00    	je     802bb8 <merging+0x133>
  802aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af0:	0f 84 c2 00 00 00    	je     802bb8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802af6:	ff 75 08             	pushl  0x8(%ebp)
  802af9:	e8 89 f1 ff ff       	call   801c87 <get_block_size>
  802afe:	83 c4 04             	add    $0x4,%esp
  802b01:	89 c3                	mov    %eax,%ebx
  802b03:	ff 75 10             	pushl  0x10(%ebp)
  802b06:	e8 7c f1 ff ff       	call   801c87 <get_block_size>
  802b0b:	83 c4 04             	add    $0x4,%esp
  802b0e:	01 c3                	add    %eax,%ebx
  802b10:	ff 75 0c             	pushl  0xc(%ebp)
  802b13:	e8 6f f1 ff ff       	call   801c87 <get_block_size>
  802b18:	83 c4 04             	add    $0x4,%esp
  802b1b:	01 d8                	add    %ebx,%eax
  802b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b20:	6a 00                	push   $0x0
  802b22:	ff 75 ec             	pushl  -0x14(%ebp)
  802b25:	ff 75 08             	pushl  0x8(%ebp)
  802b28:	e8 ab f4 ff ff       	call   801fd8 <set_block_data>
  802b2d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b34:	75 17                	jne    802b4d <merging+0xc8>
  802b36:	83 ec 04             	sub    $0x4,%esp
  802b39:	68 43 42 80 00       	push   $0x804243
  802b3e:	68 7d 01 00 00       	push   $0x17d
  802b43:	68 61 42 80 00       	push   $0x804261
  802b48:	e8 c7 0c 00 00       	call   803814 <_panic>
  802b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 10                	je     802b66 <merging+0xe1>
  802b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5e:	8b 52 04             	mov    0x4(%edx),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 0b                	jmp    802b71 <merging+0xec>
  802b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0f                	je     802b8a <merging+0x105>
  802b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b84:	8b 12                	mov    (%edx),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	eb 0a                	jmp    802b94 <merging+0x10f>
  802b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba7:	a1 38 50 80 00       	mov    0x805038,%eax
  802bac:	48                   	dec    %eax
  802bad:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802bb2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bb3:	e9 ea 02 00 00       	jmp    802ea2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbc:	74 3b                	je     802bf9 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bbe:	83 ec 0c             	sub    $0xc,%esp
  802bc1:	ff 75 08             	pushl  0x8(%ebp)
  802bc4:	e8 be f0 ff ff       	call   801c87 <get_block_size>
  802bc9:	83 c4 10             	add    $0x10,%esp
  802bcc:	89 c3                	mov    %eax,%ebx
  802bce:	83 ec 0c             	sub    $0xc,%esp
  802bd1:	ff 75 10             	pushl  0x10(%ebp)
  802bd4:	e8 ae f0 ff ff       	call   801c87 <get_block_size>
  802bd9:	83 c4 10             	add    $0x10,%esp
  802bdc:	01 d8                	add    %ebx,%eax
  802bde:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	6a 00                	push   $0x0
  802be6:	ff 75 e8             	pushl  -0x18(%ebp)
  802be9:	ff 75 08             	pushl  0x8(%ebp)
  802bec:	e8 e7 f3 ff ff       	call   801fd8 <set_block_data>
  802bf1:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bf4:	e9 a9 02 00 00       	jmp    802ea2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfd:	0f 84 2d 01 00 00    	je     802d30 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c03:	83 ec 0c             	sub    $0xc,%esp
  802c06:	ff 75 10             	pushl  0x10(%ebp)
  802c09:	e8 79 f0 ff ff       	call   801c87 <get_block_size>
  802c0e:	83 c4 10             	add    $0x10,%esp
  802c11:	89 c3                	mov    %eax,%ebx
  802c13:	83 ec 0c             	sub    $0xc,%esp
  802c16:	ff 75 0c             	pushl  0xc(%ebp)
  802c19:	e8 69 f0 ff ff       	call   801c87 <get_block_size>
  802c1e:	83 c4 10             	add    $0x10,%esp
  802c21:	01 d8                	add    %ebx,%eax
  802c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	6a 00                	push   $0x0
  802c2b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c2e:	ff 75 10             	pushl  0x10(%ebp)
  802c31:	e8 a2 f3 ff ff       	call   801fd8 <set_block_data>
  802c36:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c39:	8b 45 10             	mov    0x10(%ebp),%eax
  802c3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c43:	74 06                	je     802c4b <merging+0x1c6>
  802c45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c49:	75 17                	jne    802c62 <merging+0x1dd>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 08 43 80 00       	push   $0x804308
  802c53:	68 8d 01 00 00       	push   $0x18d
  802c58:	68 61 42 80 00       	push   $0x804261
  802c5d:	e8 b2 0b 00 00       	call   803814 <_panic>
  802c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c65:	8b 50 04             	mov    0x4(%eax),%edx
  802c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6b:	89 50 04             	mov    %edx,0x4(%eax)
  802c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0d                	je     802c8d <merging+0x208>
  802c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	eb 08                	jmp    802c95 <merging+0x210>
  802c8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c90:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ca9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cad:	75 17                	jne    802cc6 <merging+0x241>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 43 42 80 00       	push   $0x804243
  802cb7:	68 8e 01 00 00       	push   $0x18e
  802cbc:	68 61 42 80 00       	push   $0x804261
  802cc1:	e8 4e 0b 00 00       	call   803814 <_panic>
  802cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 10                	je     802cdf <merging+0x25a>
  802ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd7:	8b 52 04             	mov    0x4(%edx),%edx
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
  802cdd:	eb 0b                	jmp    802cea <merging+0x265>
  802cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	a3 30 50 80 00       	mov    %eax,0x805030
  802cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 0f                	je     802d03 <merging+0x27e>
  802cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfd:	8b 12                	mov    (%edx),%edx
  802cff:	89 10                	mov    %edx,(%eax)
  802d01:	eb 0a                	jmp    802d0d <merging+0x288>
  802d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d20:	a1 38 50 80 00       	mov    0x805038,%eax
  802d25:	48                   	dec    %eax
  802d26:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d2b:	e9 72 01 00 00       	jmp    802ea2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d30:	8b 45 10             	mov    0x10(%ebp),%eax
  802d33:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3a:	74 79                	je     802db5 <merging+0x330>
  802d3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d40:	74 73                	je     802db5 <merging+0x330>
  802d42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d46:	74 06                	je     802d4e <merging+0x2c9>
  802d48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d4c:	75 17                	jne    802d65 <merging+0x2e0>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 d4 42 80 00       	push   $0x8042d4
  802d56:	68 94 01 00 00       	push   $0x194
  802d5b:	68 61 42 80 00       	push   $0x804261
  802d60:	e8 af 0a 00 00       	call   803814 <_panic>
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 10                	mov    (%eax),%edx
  802d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6d:	89 10                	mov    %edx,(%eax)
  802d6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0b                	je     802d83 <merging+0x2fe>
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d89:	89 10                	mov    %edx,(%eax)
  802d8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	75 08                	jne    802da5 <merging+0x320>
  802d9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da0:	a3 30 50 80 00       	mov    %eax,0x805030
  802da5:	a1 38 50 80 00       	mov    0x805038,%eax
  802daa:	40                   	inc    %eax
  802dab:	a3 38 50 80 00       	mov    %eax,0x805038
  802db0:	e9 ce 00 00 00       	jmp    802e83 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db9:	74 65                	je     802e20 <merging+0x39b>
  802dbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dbf:	75 17                	jne    802dd8 <merging+0x353>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 b0 42 80 00       	push   $0x8042b0
  802dc9:	68 95 01 00 00       	push   $0x195
  802dce:	68 61 42 80 00       	push   $0x804261
  802dd3:	e8 3c 0a 00 00       	call   803814 <_panic>
  802dd8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 0c                	je     802dfa <merging+0x375>
  802dee:	a1 30 50 80 00       	mov    0x805030,%eax
  802df3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	eb 08                	jmp    802e02 <merging+0x37d>
  802dfa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e05:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	a1 38 50 80 00       	mov    0x805038,%eax
  802e18:	40                   	inc    %eax
  802e19:	a3 38 50 80 00       	mov    %eax,0x805038
  802e1e:	eb 63                	jmp    802e83 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e24:	75 17                	jne    802e3d <merging+0x3b8>
  802e26:	83 ec 04             	sub    $0x4,%esp
  802e29:	68 7c 42 80 00       	push   $0x80427c
  802e2e:	68 98 01 00 00       	push   $0x198
  802e33:	68 61 42 80 00       	push   $0x804261
  802e38:	e8 d7 09 00 00       	call   803814 <_panic>
  802e3d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e46:	89 10                	mov    %edx,(%eax)
  802e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0d                	je     802e5e <merging+0x3d9>
  802e51:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	eb 08                	jmp    802e66 <merging+0x3e1>
  802e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e61:	a3 30 50 80 00       	mov    %eax,0x805030
  802e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e78:	a1 38 50 80 00       	mov    0x805038,%eax
  802e7d:	40                   	inc    %eax
  802e7e:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	ff 75 10             	pushl  0x10(%ebp)
  802e89:	e8 f9 ed ff ff       	call   801c87 <get_block_size>
  802e8e:	83 c4 10             	add    $0x10,%esp
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	6a 00                	push   $0x0
  802e96:	50                   	push   %eax
  802e97:	ff 75 10             	pushl  0x10(%ebp)
  802e9a:	e8 39 f1 ff ff       	call   801fd8 <set_block_data>
  802e9f:	83 c4 10             	add    $0x10,%esp
	}
}
  802ea2:	90                   	nop
  802ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ea6:	c9                   	leave  
  802ea7:	c3                   	ret    

00802ea8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
  802eab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802eae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802eb6:	a1 30 50 80 00       	mov    0x805030,%eax
  802ebb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebe:	73 1b                	jae    802edb <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ec0:	a1 30 50 80 00       	mov    0x805030,%eax
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	ff 75 08             	pushl  0x8(%ebp)
  802ecb:	6a 00                	push   $0x0
  802ecd:	50                   	push   %eax
  802ece:	e8 b2 fb ff ff       	call   802a85 <merging>
  802ed3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ed6:	e9 8b 00 00 00       	jmp    802f66 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802edb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ee0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee3:	76 18                	jbe    802efd <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ee5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eea:	83 ec 04             	sub    $0x4,%esp
  802eed:	ff 75 08             	pushl  0x8(%ebp)
  802ef0:	50                   	push   %eax
  802ef1:	6a 00                	push   $0x0
  802ef3:	e8 8d fb ff ff       	call   802a85 <merging>
  802ef8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802efb:	eb 69                	jmp    802f66 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802efd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	eb 39                	jmp    802f40 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0d:	73 29                	jae    802f38 <free_block+0x90>
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f17:	76 1f                	jbe    802f38 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	ff 75 08             	pushl  0x8(%ebp)
  802f27:	ff 75 f0             	pushl  -0x10(%ebp)
  802f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f2d:	e8 53 fb ff ff       	call   802a85 <merging>
  802f32:	83 c4 10             	add    $0x10,%esp
			break;
  802f35:	90                   	nop
		}
	}
}
  802f36:	eb 2e                	jmp    802f66 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f38:	a1 34 50 80 00       	mov    0x805034,%eax
  802f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f44:	74 07                	je     802f4d <free_block+0xa5>
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	eb 05                	jmp    802f52 <free_block+0xaa>
  802f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f52:	a3 34 50 80 00       	mov    %eax,0x805034
  802f57:	a1 34 50 80 00       	mov    0x805034,%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	75 a7                	jne    802f07 <free_block+0x5f>
  802f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f64:	75 a1                	jne    802f07 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f66:	90                   	nop
  802f67:	c9                   	leave  
  802f68:	c3                   	ret    

00802f69 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f69:	55                   	push   %ebp
  802f6a:	89 e5                	mov    %esp,%ebp
  802f6c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f6f:	ff 75 08             	pushl  0x8(%ebp)
  802f72:	e8 10 ed ff ff       	call   801c87 <get_block_size>
  802f77:	83 c4 04             	add    $0x4,%esp
  802f7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f84:	eb 17                	jmp    802f9d <copy_data+0x34>
  802f86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8c:	01 c2                	add    %eax,%edx
  802f8e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	01 c8                	add    %ecx,%eax
  802f96:	8a 00                	mov    (%eax),%al
  802f98:	88 02                	mov    %al,(%edx)
  802f9a:	ff 45 fc             	incl   -0x4(%ebp)
  802f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fa0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fa3:	72 e1                	jb     802f86 <copy_data+0x1d>
}
  802fa5:	90                   	nop
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
  802fab:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb2:	75 23                	jne    802fd7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb8:	74 13                	je     802fcd <realloc_block_FF+0x25>
  802fba:	83 ec 0c             	sub    $0xc,%esp
  802fbd:	ff 75 0c             	pushl  0xc(%ebp)
  802fc0:	e8 42 f0 ff ff       	call   802007 <alloc_block_FF>
  802fc5:	83 c4 10             	add    $0x10,%esp
  802fc8:	e9 e4 06 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
		return NULL;
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd2:	e9 da 06 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  802fd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdb:	75 18                	jne    802ff5 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fdd:	83 ec 0c             	sub    $0xc,%esp
  802fe0:	ff 75 08             	pushl  0x8(%ebp)
  802fe3:	e8 c0 fe ff ff       	call   802ea8 <free_block>
  802fe8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff0:	e9 bc 06 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  802ff5:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802ff9:	77 07                	ja     803002 <realloc_block_FF+0x5a>
  802ffb:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803002:	8b 45 0c             	mov    0xc(%ebp),%eax
  803005:	83 e0 01             	and    $0x1,%eax
  803008:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80300b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300e:	83 c0 08             	add    $0x8,%eax
  803011:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	ff 75 08             	pushl  0x8(%ebp)
  80301a:	e8 68 ec ff ff       	call   801c87 <get_block_size>
  80301f:	83 c4 10             	add    $0x10,%esp
  803022:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	83 e8 08             	sub    $0x8,%eax
  80302b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	83 e8 04             	sub    $0x4,%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	83 e0 fe             	and    $0xfffffffe,%eax
  803039:	89 c2                	mov    %eax,%edx
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	01 d0                	add    %edx,%eax
  803040:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803043:	83 ec 0c             	sub    $0xc,%esp
  803046:	ff 75 e4             	pushl  -0x1c(%ebp)
  803049:	e8 39 ec ff ff       	call   801c87 <get_block_size>
  80304e:	83 c4 10             	add    $0x10,%esp
  803051:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803057:	83 e8 08             	sub    $0x8,%eax
  80305a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80305d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803060:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803063:	75 08                	jne    80306d <realloc_block_FF+0xc5>
	{
		 return va;
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	e9 44 06 00 00       	jmp    8036b1 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803070:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803073:	0f 83 d5 03 00 00    	jae    80344e <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80307f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803082:	83 ec 0c             	sub    $0xc,%esp
  803085:	ff 75 e4             	pushl  -0x1c(%ebp)
  803088:	e8 13 ec ff ff       	call   801ca0 <is_free_block>
  80308d:	83 c4 10             	add    $0x10,%esp
  803090:	84 c0                	test   %al,%al
  803092:	0f 84 3b 01 00 00    	je     8031d3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803098:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80309b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80309e:	01 d0                	add    %edx,%eax
  8030a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	6a 01                	push   $0x1
  8030a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ab:	ff 75 08             	pushl  0x8(%ebp)
  8030ae:	e8 25 ef ff ff       	call   801fd8 <set_block_data>
  8030b3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	83 e8 04             	sub    $0x4,%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	83 e0 fe             	and    $0xfffffffe,%eax
  8030c1:	89 c2                	mov    %eax,%edx
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	01 d0                	add    %edx,%eax
  8030c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030cb:	83 ec 04             	sub    $0x4,%esp
  8030ce:	6a 00                	push   $0x0
  8030d0:	ff 75 cc             	pushl  -0x34(%ebp)
  8030d3:	ff 75 c8             	pushl  -0x38(%ebp)
  8030d6:	e8 fd ee ff ff       	call   801fd8 <set_block_data>
  8030db:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030e2:	74 06                	je     8030ea <realloc_block_FF+0x142>
  8030e4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030e8:	75 17                	jne    803101 <realloc_block_FF+0x159>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 d4 42 80 00       	push   $0x8042d4
  8030f2:	68 f6 01 00 00       	push   $0x1f6
  8030f7:	68 61 42 80 00       	push   $0x804261
  8030fc:	e8 13 07 00 00       	call   803814 <_panic>
  803101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803104:	8b 10                	mov    (%eax),%edx
  803106:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803109:	89 10                	mov    %edx,(%eax)
  80310b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 0b                	je     80311f <realloc_block_FF+0x177>
  803114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803122:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803125:	89 10                	mov    %edx,(%eax)
  803127:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80312a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	75 08                	jne    803141 <realloc_block_FF+0x199>
  803139:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80313c:	a3 30 50 80 00       	mov    %eax,0x805030
  803141:	a1 38 50 80 00       	mov    0x805038,%eax
  803146:	40                   	inc    %eax
  803147:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80314c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803150:	75 17                	jne    803169 <realloc_block_FF+0x1c1>
  803152:	83 ec 04             	sub    $0x4,%esp
  803155:	68 43 42 80 00       	push   $0x804243
  80315a:	68 f7 01 00 00       	push   $0x1f7
  80315f:	68 61 42 80 00       	push   $0x804261
  803164:	e8 ab 06 00 00       	call   803814 <_panic>
  803169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 10                	je     803182 <realloc_block_FF+0x1da>
  803172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80317a:	8b 52 04             	mov    0x4(%edx),%edx
  80317d:	89 50 04             	mov    %edx,0x4(%eax)
  803180:	eb 0b                	jmp    80318d <realloc_block_FF+0x1e5>
  803182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	a3 30 50 80 00       	mov    %eax,0x805030
  80318d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	85 c0                	test   %eax,%eax
  803195:	74 0f                	je     8031a6 <realloc_block_FF+0x1fe>
  803197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a0:	8b 12                	mov    (%edx),%edx
  8031a2:	89 10                	mov    %edx,(%eax)
  8031a4:	eb 0a                	jmp    8031b0 <realloc_block_FF+0x208>
  8031a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c8:	48                   	dec    %eax
  8031c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ce:	e9 73 02 00 00       	jmp    803446 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8031d3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8031d7:	0f 86 69 02 00 00    	jbe    803446 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031dd:	83 ec 04             	sub    $0x4,%esp
  8031e0:	6a 01                	push   $0x1
  8031e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8031e5:	ff 75 08             	pushl  0x8(%ebp)
  8031e8:	e8 eb ed ff ff       	call   801fd8 <set_block_data>
  8031ed:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	83 e8 04             	sub    $0x4,%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	83 e0 fe             	and    $0xfffffffe,%eax
  8031fb:	89 c2                	mov    %eax,%edx
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	01 d0                	add    %edx,%eax
  803202:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803205:	a1 38 50 80 00       	mov    0x805038,%eax
  80320a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80320d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803211:	75 68                	jne    80327b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803213:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803217:	75 17                	jne    803230 <realloc_block_FF+0x288>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 7c 42 80 00       	push   $0x80427c
  803221:	68 06 02 00 00       	push   $0x206
  803226:	68 61 42 80 00       	push   $0x804261
  80322b:	e8 e4 05 00 00       	call   803814 <_panic>
  803230:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803236:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803239:	89 10                	mov    %edx,(%eax)
  80323b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	74 0d                	je     803251 <realloc_block_FF+0x2a9>
  803244:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803249:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	eb 08                	jmp    803259 <realloc_block_FF+0x2b1>
  803251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803254:	a3 30 50 80 00       	mov    %eax,0x805030
  803259:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80325c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803261:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326b:	a1 38 50 80 00       	mov    0x805038,%eax
  803270:	40                   	inc    %eax
  803271:	a3 38 50 80 00       	mov    %eax,0x805038
  803276:	e9 b0 01 00 00       	jmp    80342b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80327b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803280:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803283:	76 68                	jbe    8032ed <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803285:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803289:	75 17                	jne    8032a2 <realloc_block_FF+0x2fa>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 7c 42 80 00       	push   $0x80427c
  803293:	68 0b 02 00 00       	push   $0x20b
  803298:	68 61 42 80 00       	push   $0x804261
  80329d:	e8 72 05 00 00       	call   803814 <_panic>
  8032a2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ab:	89 10                	mov    %edx,(%eax)
  8032ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0d                	je     8032c3 <realloc_block_FF+0x31b>
  8032b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 08                	jmp    8032cb <realloc_block_FF+0x323>
  8032c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e2:	40                   	inc    %eax
  8032e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8032e8:	e9 3e 01 00 00       	jmp    80342b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032f5:	73 68                	jae    80335f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032fb:	75 17                	jne    803314 <realloc_block_FF+0x36c>
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 b0 42 80 00       	push   $0x8042b0
  803305:	68 10 02 00 00       	push   $0x210
  80330a:	68 61 42 80 00       	push   $0x804261
  80330f:	e8 00 05 00 00       	call   803814 <_panic>
  803314:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80331a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	74 0c                	je     803336 <realloc_block_FF+0x38e>
  80332a:	a1 30 50 80 00       	mov    0x805030,%eax
  80332f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 08                	jmp    80333e <realloc_block_FF+0x396>
  803336:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803339:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80333e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803341:	a3 30 50 80 00       	mov    %eax,0x805030
  803346:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334f:	a1 38 50 80 00       	mov    0x805038,%eax
  803354:	40                   	inc    %eax
  803355:	a3 38 50 80 00       	mov    %eax,0x805038
  80335a:	e9 cc 00 00 00       	jmp    80342b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80335f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803366:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336e:	e9 8a 00 00 00       	jmp    8033fd <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803379:	73 7a                	jae    8033f5 <realloc_block_FF+0x44d>
  80337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337e:	8b 00                	mov    (%eax),%eax
  803380:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803383:	73 70                	jae    8033f5 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803389:	74 06                	je     803391 <realloc_block_FF+0x3e9>
  80338b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80338f:	75 17                	jne    8033a8 <realloc_block_FF+0x400>
  803391:	83 ec 04             	sub    $0x4,%esp
  803394:	68 d4 42 80 00       	push   $0x8042d4
  803399:	68 1a 02 00 00       	push   $0x21a
  80339e:	68 61 42 80 00       	push   $0x804261
  8033a3:	e8 6c 04 00 00       	call   803814 <_panic>
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 10                	mov    (%eax),%edx
  8033ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	85 c0                	test   %eax,%eax
  8033b9:	74 0b                	je     8033c6 <realloc_block_FF+0x41e>
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033c3:	89 50 04             	mov    %edx,0x4(%eax)
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033cc:	89 10                	mov    %edx,(%eax)
  8033ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	85 c0                	test   %eax,%eax
  8033de:	75 08                	jne    8033e8 <realloc_block_FF+0x440>
  8033e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ed:	40                   	inc    %eax
  8033ee:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033f3:	eb 36                	jmp    80342b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033f5:	a1 34 50 80 00       	mov    0x805034,%eax
  8033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803401:	74 07                	je     80340a <realloc_block_FF+0x462>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	eb 05                	jmp    80340f <realloc_block_FF+0x467>
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	a3 34 50 80 00       	mov    %eax,0x805034
  803414:	a1 34 50 80 00       	mov    0x805034,%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	0f 85 52 ff ff ff    	jne    803373 <realloc_block_FF+0x3cb>
  803421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803425:	0f 85 48 ff ff ff    	jne    803373 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 d8             	pushl  -0x28(%ebp)
  803433:	ff 75 d4             	pushl  -0x2c(%ebp)
  803436:	e8 9d eb ff ff       	call   801fd8 <set_block_data>
  80343b:	83 c4 10             	add    $0x10,%esp
				return va;
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	e9 6b 02 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	e9 63 02 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80344e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803451:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803454:	0f 86 4d 02 00 00    	jbe    8036a7 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80345a:	83 ec 0c             	sub    $0xc,%esp
  80345d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803460:	e8 3b e8 ff ff       	call   801ca0 <is_free_block>
  803465:	83 c4 10             	add    $0x10,%esp
  803468:	84 c0                	test   %al,%al
  80346a:	0f 84 37 02 00 00    	je     8036a7 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803470:	8b 45 0c             	mov    0xc(%ebp),%eax
  803473:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803476:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803479:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80347c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80347f:	76 38                	jbe    8034b9 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803481:	83 ec 0c             	sub    $0xc,%esp
  803484:	ff 75 0c             	pushl  0xc(%ebp)
  803487:	e8 7b eb ff ff       	call   802007 <alloc_block_FF>
  80348c:	83 c4 10             	add    $0x10,%esp
  80348f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803492:	83 ec 08             	sub    $0x8,%esp
  803495:	ff 75 c0             	pushl  -0x40(%ebp)
  803498:	ff 75 08             	pushl  0x8(%ebp)
  80349b:	e8 c9 fa ff ff       	call   802f69 <copy_data>
  8034a0:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8034a3:	83 ec 0c             	sub    $0xc,%esp
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 fa f9 ff ff       	call   802ea8 <free_block>
  8034ae:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034b4:	e9 f8 01 00 00       	jmp    8036b1 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bc:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034bf:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034c2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8034c6:	0f 87 a0 00 00 00    	ja     80356c <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034d0:	75 17                	jne    8034e9 <realloc_block_FF+0x541>
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	68 43 42 80 00       	push   $0x804243
  8034da:	68 38 02 00 00       	push   $0x238
  8034df:	68 61 42 80 00       	push   $0x804261
  8034e4:	e8 2b 03 00 00       	call   803814 <_panic>
  8034e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 10                	je     803502 <realloc_block_FF+0x55a>
  8034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034fa:	8b 52 04             	mov    0x4(%edx),%edx
  8034fd:	89 50 04             	mov    %edx,0x4(%eax)
  803500:	eb 0b                	jmp    80350d <realloc_block_FF+0x565>
  803502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803505:	8b 40 04             	mov    0x4(%eax),%eax
  803508:	a3 30 50 80 00       	mov    %eax,0x805030
  80350d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803510:	8b 40 04             	mov    0x4(%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	74 0f                	je     803526 <realloc_block_FF+0x57e>
  803517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351a:	8b 40 04             	mov    0x4(%eax),%eax
  80351d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803520:	8b 12                	mov    (%edx),%edx
  803522:	89 10                	mov    %edx,(%eax)
  803524:	eb 0a                	jmp    803530 <realloc_block_FF+0x588>
  803526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803543:	a1 38 50 80 00       	mov    0x805038,%eax
  803548:	48                   	dec    %eax
  803549:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80354e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803554:	01 d0                	add    %edx,%eax
  803556:	83 ec 04             	sub    $0x4,%esp
  803559:	6a 01                	push   $0x1
  80355b:	50                   	push   %eax
  80355c:	ff 75 08             	pushl  0x8(%ebp)
  80355f:	e8 74 ea ff ff       	call   801fd8 <set_block_data>
  803564:	83 c4 10             	add    $0x10,%esp
  803567:	e9 36 01 00 00       	jmp    8036a2 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80356c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803572:	01 d0                	add    %edx,%eax
  803574:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	6a 01                	push   $0x1
  80357c:	ff 75 f0             	pushl  -0x10(%ebp)
  80357f:	ff 75 08             	pushl  0x8(%ebp)
  803582:	e8 51 ea ff ff       	call   801fd8 <set_block_data>
  803587:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	83 e8 04             	sub    $0x4,%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	83 e0 fe             	and    $0xfffffffe,%eax
  803595:	89 c2                	mov    %eax,%edx
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	01 d0                	add    %edx,%eax
  80359c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80359f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a3:	74 06                	je     8035ab <realloc_block_FF+0x603>
  8035a5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035a9:	75 17                	jne    8035c2 <realloc_block_FF+0x61a>
  8035ab:	83 ec 04             	sub    $0x4,%esp
  8035ae:	68 d4 42 80 00       	push   $0x8042d4
  8035b3:	68 44 02 00 00       	push   $0x244
  8035b8:	68 61 42 80 00       	push   $0x804261
  8035bd:	e8 52 02 00 00       	call   803814 <_panic>
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 10                	mov    (%eax),%edx
  8035c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ca:	89 10                	mov    %edx,(%eax)
  8035cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035cf:	8b 00                	mov    (%eax),%eax
  8035d1:	85 c0                	test   %eax,%eax
  8035d3:	74 0b                	je     8035e0 <realloc_block_FF+0x638>
  8035d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d8:	8b 00                	mov    (%eax),%eax
  8035da:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035dd:	89 50 04             	mov    %edx,0x4(%eax)
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035e6:	89 10                	mov    %edx,(%eax)
  8035e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ee:	89 50 04             	mov    %edx,0x4(%eax)
  8035f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	75 08                	jne    803602 <realloc_block_FF+0x65a>
  8035fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803602:	a1 38 50 80 00       	mov    0x805038,%eax
  803607:	40                   	inc    %eax
  803608:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80360d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803611:	75 17                	jne    80362a <realloc_block_FF+0x682>
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	68 43 42 80 00       	push   $0x804243
  80361b:	68 45 02 00 00       	push   $0x245
  803620:	68 61 42 80 00       	push   $0x804261
  803625:	e8 ea 01 00 00       	call   803814 <_panic>
  80362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362d:	8b 00                	mov    (%eax),%eax
  80362f:	85 c0                	test   %eax,%eax
  803631:	74 10                	je     803643 <realloc_block_FF+0x69b>
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363b:	8b 52 04             	mov    0x4(%edx),%edx
  80363e:	89 50 04             	mov    %edx,0x4(%eax)
  803641:	eb 0b                	jmp    80364e <realloc_block_FF+0x6a6>
  803643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803646:	8b 40 04             	mov    0x4(%eax),%eax
  803649:	a3 30 50 80 00       	mov    %eax,0x805030
  80364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803651:	8b 40 04             	mov    0x4(%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 0f                	je     803667 <realloc_block_FF+0x6bf>
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	8b 40 04             	mov    0x4(%eax),%eax
  80365e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803661:	8b 12                	mov    (%edx),%edx
  803663:	89 10                	mov    %edx,(%eax)
  803665:	eb 0a                	jmp    803671 <realloc_block_FF+0x6c9>
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803684:	a1 38 50 80 00       	mov    0x805038,%eax
  803689:	48                   	dec    %eax
  80368a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	6a 00                	push   $0x0
  803694:	ff 75 bc             	pushl  -0x44(%ebp)
  803697:	ff 75 b8             	pushl  -0x48(%ebp)
  80369a:	e8 39 e9 ff ff       	call   801fd8 <set_block_data>
  80369f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	eb 0a                	jmp    8036b1 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036a7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036b1:	c9                   	leave  
  8036b2:	c3                   	ret    

008036b3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036b3:	55                   	push   %ebp
  8036b4:	89 e5                	mov    %esp,%ebp
  8036b6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036b9:	83 ec 04             	sub    $0x4,%esp
  8036bc:	68 40 43 80 00       	push   $0x804340
  8036c1:	68 58 02 00 00       	push   $0x258
  8036c6:	68 61 42 80 00       	push   $0x804261
  8036cb:	e8 44 01 00 00       	call   803814 <_panic>

008036d0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
  8036d3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036d6:	83 ec 04             	sub    $0x4,%esp
  8036d9:	68 68 43 80 00       	push   $0x804368
  8036de:	68 61 02 00 00       	push   $0x261
  8036e3:	68 61 42 80 00       	push   $0x804261
  8036e8:	e8 27 01 00 00       	call   803814 <_panic>

008036ed <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036ed:	55                   	push   %ebp
  8036ee:	89 e5                	mov    %esp,%ebp
  8036f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 90 43 80 00       	push   $0x804390
  8036fb:	6a 09                	push   $0x9
  8036fd:	68 b8 43 80 00       	push   $0x8043b8
  803702:	e8 0d 01 00 00       	call   803814 <_panic>

00803707 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803707:	55                   	push   %ebp
  803708:	89 e5                	mov    %esp,%ebp
  80370a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80370d:	83 ec 04             	sub    $0x4,%esp
  803710:	68 c8 43 80 00       	push   $0x8043c8
  803715:	6a 10                	push   $0x10
  803717:	68 b8 43 80 00       	push   $0x8043b8
  80371c:	e8 f3 00 00 00       	call   803814 <_panic>

00803721 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803721:	55                   	push   %ebp
  803722:	89 e5                	mov    %esp,%ebp
  803724:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	68 f0 43 80 00       	push   $0x8043f0
  80372f:	6a 18                	push   $0x18
  803731:	68 b8 43 80 00       	push   $0x8043b8
  803736:	e8 d9 00 00 00       	call   803814 <_panic>

0080373b <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80373b:	55                   	push   %ebp
  80373c:	89 e5                	mov    %esp,%ebp
  80373e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803741:	83 ec 04             	sub    $0x4,%esp
  803744:	68 18 44 80 00       	push   $0x804418
  803749:	6a 20                	push   $0x20
  80374b:	68 b8 43 80 00       	push   $0x8043b8
  803750:	e8 bf 00 00 00       	call   803814 <_panic>

00803755 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803755:	55                   	push   %ebp
  803756:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    

00803760 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803760:	55                   	push   %ebp
  803761:	89 e5                	mov    %esp,%ebp
  803763:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803766:	8b 55 08             	mov    0x8(%ebp),%edx
  803769:	89 d0                	mov    %edx,%eax
  80376b:	c1 e0 02             	shl    $0x2,%eax
  80376e:	01 d0                	add    %edx,%eax
  803770:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803777:	01 d0                	add    %edx,%eax
  803779:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803780:	01 d0                	add    %edx,%eax
  803782:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803789:	01 d0                	add    %edx,%eax
  80378b:	c1 e0 04             	shl    $0x4,%eax
  80378e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803798:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80379b:	83 ec 0c             	sub    $0xc,%esp
  80379e:	50                   	push   %eax
  80379f:	e8 ef e1 ff ff       	call   801993 <sys_get_virtual_time>
  8037a4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037a7:	eb 41                	jmp    8037ea <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037ac:	83 ec 0c             	sub    $0xc,%esp
  8037af:	50                   	push   %eax
  8037b0:	e8 de e1 ff ff       	call   801993 <sys_get_virtual_time>
  8037b5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037be:	29 c2                	sub    %eax,%edx
  8037c0:	89 d0                	mov    %edx,%eax
  8037c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cb:	89 d1                	mov    %edx,%ecx
  8037cd:	29 c1                	sub    %eax,%ecx
  8037cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d5:	39 c2                	cmp    %eax,%edx
  8037d7:	0f 97 c0             	seta   %al
  8037da:	0f b6 c0             	movzbl %al,%eax
  8037dd:	29 c1                	sub    %eax,%ecx
  8037df:	89 c8                	mov    %ecx,%eax
  8037e1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037f0:	72 b7                	jb     8037a9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037f2:	90                   	nop
  8037f3:	c9                   	leave  
  8037f4:	c3                   	ret    

008037f5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037f5:	55                   	push   %ebp
  8037f6:	89 e5                	mov    %esp,%ebp
  8037f8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803802:	eb 03                	jmp    803807 <busy_wait+0x12>
  803804:	ff 45 fc             	incl   -0x4(%ebp)
  803807:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80380a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380d:	72 f5                	jb     803804 <busy_wait+0xf>
	return i;
  80380f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803812:	c9                   	leave  
  803813:	c3                   	ret    

00803814 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803814:	55                   	push   %ebp
  803815:	89 e5                	mov    %esp,%ebp
  803817:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80381a:	8d 45 10             	lea    0x10(%ebp),%eax
  80381d:	83 c0 04             	add    $0x4,%eax
  803820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803823:	a1 60 50 98 00       	mov    0x985060,%eax
  803828:	85 c0                	test   %eax,%eax
  80382a:	74 16                	je     803842 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80382c:	a1 60 50 98 00       	mov    0x985060,%eax
  803831:	83 ec 08             	sub    $0x8,%esp
  803834:	50                   	push   %eax
  803835:	68 40 44 80 00       	push   $0x804440
  80383a:	e8 52 cb ff ff       	call   800391 <cprintf>
  80383f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803842:	a1 00 50 80 00       	mov    0x805000,%eax
  803847:	ff 75 0c             	pushl  0xc(%ebp)
  80384a:	ff 75 08             	pushl  0x8(%ebp)
  80384d:	50                   	push   %eax
  80384e:	68 45 44 80 00       	push   $0x804445
  803853:	e8 39 cb ff ff       	call   800391 <cprintf>
  803858:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80385b:	8b 45 10             	mov    0x10(%ebp),%eax
  80385e:	83 ec 08             	sub    $0x8,%esp
  803861:	ff 75 f4             	pushl  -0xc(%ebp)
  803864:	50                   	push   %eax
  803865:	e8 bc ca ff ff       	call   800326 <vcprintf>
  80386a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80386d:	83 ec 08             	sub    $0x8,%esp
  803870:	6a 00                	push   $0x0
  803872:	68 61 44 80 00       	push   $0x804461
  803877:	e8 aa ca ff ff       	call   800326 <vcprintf>
  80387c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80387f:	e8 2b ca ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  803884:	eb fe                	jmp    803884 <_panic+0x70>

00803886 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803886:	55                   	push   %ebp
  803887:	89 e5                	mov    %esp,%ebp
  803889:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80388c:	a1 20 50 80 00       	mov    0x805020,%eax
  803891:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389a:	39 c2                	cmp    %eax,%edx
  80389c:	74 14                	je     8038b2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80389e:	83 ec 04             	sub    $0x4,%esp
  8038a1:	68 64 44 80 00       	push   $0x804464
  8038a6:	6a 26                	push   $0x26
  8038a8:	68 b0 44 80 00       	push   $0x8044b0
  8038ad:	e8 62 ff ff ff       	call   803814 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038c0:	e9 c5 00 00 00       	jmp    80398a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d2:	01 d0                	add    %edx,%eax
  8038d4:	8b 00                	mov    (%eax),%eax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	75 08                	jne    8038e2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038da:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038dd:	e9 a5 00 00 00       	jmp    803987 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038f0:	eb 69                	jmp    80395b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8038f7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803900:	89 d0                	mov    %edx,%eax
  803902:	01 c0                	add    %eax,%eax
  803904:	01 d0                	add    %edx,%eax
  803906:	c1 e0 03             	shl    $0x3,%eax
  803909:	01 c8                	add    %ecx,%eax
  80390b:	8a 40 04             	mov    0x4(%eax),%al
  80390e:	84 c0                	test   %al,%al
  803910:	75 46                	jne    803958 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803912:	a1 20 50 80 00       	mov    0x805020,%eax
  803917:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80391d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803920:	89 d0                	mov    %edx,%eax
  803922:	01 c0                	add    %eax,%eax
  803924:	01 d0                	add    %edx,%eax
  803926:	c1 e0 03             	shl    $0x3,%eax
  803929:	01 c8                	add    %ecx,%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803930:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803933:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803938:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80393a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	01 c8                	add    %ecx,%eax
  803949:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80394b:	39 c2                	cmp    %eax,%edx
  80394d:	75 09                	jne    803958 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80394f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803956:	eb 15                	jmp    80396d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803958:	ff 45 e8             	incl   -0x18(%ebp)
  80395b:	a1 20 50 80 00       	mov    0x805020,%eax
  803960:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803969:	39 c2                	cmp    %eax,%edx
  80396b:	77 85                	ja     8038f2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80396d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803971:	75 14                	jne    803987 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	68 bc 44 80 00       	push   $0x8044bc
  80397b:	6a 3a                	push   $0x3a
  80397d:	68 b0 44 80 00       	push   $0x8044b0
  803982:	e8 8d fe ff ff       	call   803814 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803987:	ff 45 f0             	incl   -0x10(%ebp)
  80398a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803990:	0f 8c 2f ff ff ff    	jl     8038c5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803996:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80399d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039a4:	eb 26                	jmp    8039cc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ab:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b4:	89 d0                	mov    %edx,%eax
  8039b6:	01 c0                	add    %eax,%eax
  8039b8:	01 d0                	add    %edx,%eax
  8039ba:	c1 e0 03             	shl    $0x3,%eax
  8039bd:	01 c8                	add    %ecx,%eax
  8039bf:	8a 40 04             	mov    0x4(%eax),%al
  8039c2:	3c 01                	cmp    $0x1,%al
  8039c4:	75 03                	jne    8039c9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039c9:	ff 45 e0             	incl   -0x20(%ebp)
  8039cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039da:	39 c2                	cmp    %eax,%edx
  8039dc:	77 c8                	ja     8039a6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039e4:	74 14                	je     8039fa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	68 10 45 80 00       	push   $0x804510
  8039ee:	6a 44                	push   $0x44
  8039f0:	68 b0 44 80 00       	push   $0x8044b0
  8039f5:	e8 1a fe ff ff       	call   803814 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039fa:	90                   	nop
  8039fb:	c9                   	leave  
  8039fc:	c3                   	ret    
  8039fd:	66 90                	xchg   %ax,%ax
  8039ff:	90                   	nop

00803a00 <__udivdi3>:
  803a00:	55                   	push   %ebp
  803a01:	57                   	push   %edi
  803a02:	56                   	push   %esi
  803a03:	53                   	push   %ebx
  803a04:	83 ec 1c             	sub    $0x1c,%esp
  803a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a17:	89 ca                	mov    %ecx,%edx
  803a19:	89 f8                	mov    %edi,%eax
  803a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a1f:	85 f6                	test   %esi,%esi
  803a21:	75 2d                	jne    803a50 <__udivdi3+0x50>
  803a23:	39 cf                	cmp    %ecx,%edi
  803a25:	77 65                	ja     803a8c <__udivdi3+0x8c>
  803a27:	89 fd                	mov    %edi,%ebp
  803a29:	85 ff                	test   %edi,%edi
  803a2b:	75 0b                	jne    803a38 <__udivdi3+0x38>
  803a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a32:	31 d2                	xor    %edx,%edx
  803a34:	f7 f7                	div    %edi
  803a36:	89 c5                	mov    %eax,%ebp
  803a38:	31 d2                	xor    %edx,%edx
  803a3a:	89 c8                	mov    %ecx,%eax
  803a3c:	f7 f5                	div    %ebp
  803a3e:	89 c1                	mov    %eax,%ecx
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	f7 f5                	div    %ebp
  803a44:	89 cf                	mov    %ecx,%edi
  803a46:	89 fa                	mov    %edi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	39 ce                	cmp    %ecx,%esi
  803a52:	77 28                	ja     803a7c <__udivdi3+0x7c>
  803a54:	0f bd fe             	bsr    %esi,%edi
  803a57:	83 f7 1f             	xor    $0x1f,%edi
  803a5a:	75 40                	jne    803a9c <__udivdi3+0x9c>
  803a5c:	39 ce                	cmp    %ecx,%esi
  803a5e:	72 0a                	jb     803a6a <__udivdi3+0x6a>
  803a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a64:	0f 87 9e 00 00 00    	ja     803b08 <__udivdi3+0x108>
  803a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6f:	89 fa                	mov    %edi,%edx
  803a71:	83 c4 1c             	add    $0x1c,%esp
  803a74:	5b                   	pop    %ebx
  803a75:	5e                   	pop    %esi
  803a76:	5f                   	pop    %edi
  803a77:	5d                   	pop    %ebp
  803a78:	c3                   	ret    
  803a79:	8d 76 00             	lea    0x0(%esi),%esi
  803a7c:	31 ff                	xor    %edi,%edi
  803a7e:	31 c0                	xor    %eax,%eax
  803a80:	89 fa                	mov    %edi,%edx
  803a82:	83 c4 1c             	add    $0x1c,%esp
  803a85:	5b                   	pop    %ebx
  803a86:	5e                   	pop    %esi
  803a87:	5f                   	pop    %edi
  803a88:	5d                   	pop    %ebp
  803a89:	c3                   	ret    
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 d8                	mov    %ebx,%eax
  803a8e:	f7 f7                	div    %edi
  803a90:	31 ff                	xor    %edi,%edi
  803a92:	89 fa                	mov    %edi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aa1:	89 eb                	mov    %ebp,%ebx
  803aa3:	29 fb                	sub    %edi,%ebx
  803aa5:	89 f9                	mov    %edi,%ecx
  803aa7:	d3 e6                	shl    %cl,%esi
  803aa9:	89 c5                	mov    %eax,%ebp
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 ed                	shr    %cl,%ebp
  803aaf:	89 e9                	mov    %ebp,%ecx
  803ab1:	09 f1                	or     %esi,%ecx
  803ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ab7:	89 f9                	mov    %edi,%ecx
  803ab9:	d3 e0                	shl    %cl,%eax
  803abb:	89 c5                	mov    %eax,%ebp
  803abd:	89 d6                	mov    %edx,%esi
  803abf:	88 d9                	mov    %bl,%cl
  803ac1:	d3 ee                	shr    %cl,%esi
  803ac3:	89 f9                	mov    %edi,%ecx
  803ac5:	d3 e2                	shl    %cl,%edx
  803ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 e8                	shr    %cl,%eax
  803acf:	09 c2                	or     %eax,%edx
  803ad1:	89 d0                	mov    %edx,%eax
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	f7 74 24 0c          	divl   0xc(%esp)
  803ad9:	89 d6                	mov    %edx,%esi
  803adb:	89 c3                	mov    %eax,%ebx
  803add:	f7 e5                	mul    %ebp
  803adf:	39 d6                	cmp    %edx,%esi
  803ae1:	72 19                	jb     803afc <__udivdi3+0xfc>
  803ae3:	74 0b                	je     803af0 <__udivdi3+0xf0>
  803ae5:	89 d8                	mov    %ebx,%eax
  803ae7:	31 ff                	xor    %edi,%edi
  803ae9:	e9 58 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803aee:	66 90                	xchg   %ax,%ax
  803af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803af4:	89 f9                	mov    %edi,%ecx
  803af6:	d3 e2                	shl    %cl,%edx
  803af8:	39 c2                	cmp    %eax,%edx
  803afa:	73 e9                	jae    803ae5 <__udivdi3+0xe5>
  803afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aff:	31 ff                	xor    %edi,%edi
  803b01:	e9 40 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	31 c0                	xor    %eax,%eax
  803b0a:	e9 37 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b0f:	90                   	nop

00803b10 <__umoddi3>:
  803b10:	55                   	push   %ebp
  803b11:	57                   	push   %edi
  803b12:	56                   	push   %esi
  803b13:	53                   	push   %ebx
  803b14:	83 ec 1c             	sub    $0x1c,%esp
  803b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b2f:	89 f3                	mov    %esi,%ebx
  803b31:	89 fa                	mov    %edi,%edx
  803b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b37:	89 34 24             	mov    %esi,(%esp)
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	75 1a                	jne    803b58 <__umoddi3+0x48>
  803b3e:	39 f7                	cmp    %esi,%edi
  803b40:	0f 86 a2 00 00 00    	jbe    803be8 <__umoddi3+0xd8>
  803b46:	89 c8                	mov    %ecx,%eax
  803b48:	89 f2                	mov    %esi,%edx
  803b4a:	f7 f7                	div    %edi
  803b4c:	89 d0                	mov    %edx,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	83 c4 1c             	add    $0x1c,%esp
  803b53:	5b                   	pop    %ebx
  803b54:	5e                   	pop    %esi
  803b55:	5f                   	pop    %edi
  803b56:	5d                   	pop    %ebp
  803b57:	c3                   	ret    
  803b58:	39 f0                	cmp    %esi,%eax
  803b5a:	0f 87 ac 00 00 00    	ja     803c0c <__umoddi3+0xfc>
  803b60:	0f bd e8             	bsr    %eax,%ebp
  803b63:	83 f5 1f             	xor    $0x1f,%ebp
  803b66:	0f 84 ac 00 00 00    	je     803c18 <__umoddi3+0x108>
  803b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b71:	29 ef                	sub    %ebp,%edi
  803b73:	89 fe                	mov    %edi,%esi
  803b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b79:	89 e9                	mov    %ebp,%ecx
  803b7b:	d3 e0                	shl    %cl,%eax
  803b7d:	89 d7                	mov    %edx,%edi
  803b7f:	89 f1                	mov    %esi,%ecx
  803b81:	d3 ef                	shr    %cl,%edi
  803b83:	09 c7                	or     %eax,%edi
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 e2                	shl    %cl,%edx
  803b89:	89 14 24             	mov    %edx,(%esp)
  803b8c:	89 d8                	mov    %ebx,%eax
  803b8e:	d3 e0                	shl    %cl,%eax
  803b90:	89 c2                	mov    %eax,%edx
  803b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b96:	d3 e0                	shl    %cl,%eax
  803b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba0:	89 f1                	mov    %esi,%ecx
  803ba2:	d3 e8                	shr    %cl,%eax
  803ba4:	09 d0                	or     %edx,%eax
  803ba6:	d3 eb                	shr    %cl,%ebx
  803ba8:	89 da                	mov    %ebx,%edx
  803baa:	f7 f7                	div    %edi
  803bac:	89 d3                	mov    %edx,%ebx
  803bae:	f7 24 24             	mull   (%esp)
  803bb1:	89 c6                	mov    %eax,%esi
  803bb3:	89 d1                	mov    %edx,%ecx
  803bb5:	39 d3                	cmp    %edx,%ebx
  803bb7:	0f 82 87 00 00 00    	jb     803c44 <__umoddi3+0x134>
  803bbd:	0f 84 91 00 00 00    	je     803c54 <__umoddi3+0x144>
  803bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bc7:	29 f2                	sub    %esi,%edx
  803bc9:	19 cb                	sbb    %ecx,%ebx
  803bcb:	89 d8                	mov    %ebx,%eax
  803bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bd1:	d3 e0                	shl    %cl,%eax
  803bd3:	89 e9                	mov    %ebp,%ecx
  803bd5:	d3 ea                	shr    %cl,%edx
  803bd7:	09 d0                	or     %edx,%eax
  803bd9:	89 e9                	mov    %ebp,%ecx
  803bdb:	d3 eb                	shr    %cl,%ebx
  803bdd:	89 da                	mov    %ebx,%edx
  803bdf:	83 c4 1c             	add    $0x1c,%esp
  803be2:	5b                   	pop    %ebx
  803be3:	5e                   	pop    %esi
  803be4:	5f                   	pop    %edi
  803be5:	5d                   	pop    %ebp
  803be6:	c3                   	ret    
  803be7:	90                   	nop
  803be8:	89 fd                	mov    %edi,%ebp
  803bea:	85 ff                	test   %edi,%edi
  803bec:	75 0b                	jne    803bf9 <__umoddi3+0xe9>
  803bee:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf3:	31 d2                	xor    %edx,%edx
  803bf5:	f7 f7                	div    %edi
  803bf7:	89 c5                	mov    %eax,%ebp
  803bf9:	89 f0                	mov    %esi,%eax
  803bfb:	31 d2                	xor    %edx,%edx
  803bfd:	f7 f5                	div    %ebp
  803bff:	89 c8                	mov    %ecx,%eax
  803c01:	f7 f5                	div    %ebp
  803c03:	89 d0                	mov    %edx,%eax
  803c05:	e9 44 ff ff ff       	jmp    803b4e <__umoddi3+0x3e>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	89 c8                	mov    %ecx,%eax
  803c0e:	89 f2                	mov    %esi,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	3b 04 24             	cmp    (%esp),%eax
  803c1b:	72 06                	jb     803c23 <__umoddi3+0x113>
  803c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c21:	77 0f                	ja     803c32 <__umoddi3+0x122>
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	29 f9                	sub    %edi,%ecx
  803c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c2b:	89 14 24             	mov    %edx,(%esp)
  803c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c36:	8b 14 24             	mov    (%esp),%edx
  803c39:	83 c4 1c             	add    $0x1c,%esp
  803c3c:	5b                   	pop    %ebx
  803c3d:	5e                   	pop    %esi
  803c3e:	5f                   	pop    %edi
  803c3f:	5d                   	pop    %ebp
  803c40:	c3                   	ret    
  803c41:	8d 76 00             	lea    0x0(%esi),%esi
  803c44:	2b 04 24             	sub    (%esp),%eax
  803c47:	19 fa                	sbb    %edi,%edx
  803c49:	89 d1                	mov    %edx,%ecx
  803c4b:	89 c6                	mov    %eax,%esi
  803c4d:	e9 71 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c58:	72 ea                	jb     803c44 <__umoddi3+0x134>
  803c5a:	89 d9                	mov    %ebx,%ecx
  803c5c:	e9 62 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
