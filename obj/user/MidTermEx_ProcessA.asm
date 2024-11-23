
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
  80003e:	e8 0c 19 00 00       	call   80194f <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 3c 80 00       	push   $0x803ca0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 c0 14 00 00       	call   801516 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 3c 80 00       	push   $0x803ca2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 aa 14 00 00       	call   801516 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 3c 80 00       	push   $0x803ca9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 94 14 00 00       	call   801516 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 ee 18 00 00       	call   801982 <sys_get_virtual_time>
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
  8000b7:	e8 c6 36 00 00       	call   803782 <env_sleep>
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
  8000d0:	e8 ad 18 00 00       	call   801982 <sys_get_virtual_time>
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
  8000f8:	e8 85 36 00 00       	call   803782 <env_sleep>
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
  80010f:	e8 6e 18 00 00       	call   801982 <sys_get_virtual_time>
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
  800137:	e8 46 36 00 00       	call   803782 <env_sleep>
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
  80014f:	68 b7 3c 80 00       	push   $0x803cb7
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 cc 35 00 00       	call   803729 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 f2 35 00 00       	call   80375d <signal_semaphore>
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
  800184:	e8 ad 17 00 00       	call   801936 <sys_getenvindex>
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
  8001f2:	e8 c3 14 00 00       	call   8016ba <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 d4 3c 80 00       	push   $0x803cd4
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
  800222:	68 fc 3c 80 00       	push   $0x803cfc
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
  800253:	68 24 3d 80 00       	push   $0x803d24
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 7c 3d 80 00       	push   $0x803d7c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 d4 3c 80 00       	push   $0x803cd4
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 43 14 00 00       	call   8016d4 <sys_unlock_cons>
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
  8002a4:	e8 59 16 00 00       	call   801902 <sys_destroy_env>
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
  8002b5:	e8 ae 16 00 00       	call   801968 <sys_exit_env>
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
  800303:	e8 70 13 00 00       	call   801678 <sys_cputs>
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
  80037a:	e8 f9 12 00 00       	call   801678 <sys_cputs>
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
  8003c4:	e8 f1 12 00 00       	call   8016ba <sys_lock_cons>
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
  8003e4:	e8 eb 12 00 00       	call   8016d4 <sys_unlock_cons>
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
  80042e:	e8 ed 35 00 00       	call   803a20 <__udivdi3>
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
  80047e:	e8 ad 36 00 00       	call   803b30 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 b4 3f 80 00       	add    $0x803fb4,%eax
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
  8005d9:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
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
  8006ba:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 c5 3f 80 00       	push   $0x803fc5
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
  8006df:	68 ce 3f 80 00       	push   $0x803fce
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
  80070c:	be d1 3f 80 00       	mov    $0x803fd1,%esi
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
  801117:	68 48 41 80 00       	push   $0x804148
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 6a 41 80 00       	push   $0x80416a
  801126:	e8 0b 27 00 00       	call   803836 <_panic>

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
  801137:	e8 e7 0a 00 00       	call   801c23 <sys_sbrk>
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
  8011b2:	e8 f0 08 00 00       	call   801aa7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 30 0e 00 00       	call   801ff6 <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 02 09 00 00       	call   801ad8 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 c9 12 00 00       	call   8024b2 <alloc_block_BF>
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
  801234:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801281:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80133a:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	ff 75 f0             	pushl  -0x10(%ebp)
  80134a:	e8 0b 09 00 00       	call   801c5a <sys_allocate_user_mem>
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
  801392:	e8 df 08 00 00       	call   801c76 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 12 1b 00 00       	call   802eba <free_block>
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
  8013dd:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  80141a:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  80143a:	e8 ff 07 00 00       	call   801c3e <sys_free_user_mem>
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
  801448:	68 78 41 80 00       	push   $0x804178
  80144d:	68 85 00 00 00       	push   $0x85
  801452:	68 a2 41 80 00       	push   $0x8041a2
  801457:	e8 da 23 00 00       	call   803836 <_panic>
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
  80146e:	75 0a                	jne    80147a <smalloc+0x1c>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	e9 9a 00 00 00       	jmp    801514 <smalloc+0xb6>
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
  801497:	e8 a5 fc ff ff       	call   801141 <malloc>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8014a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a6:	75 07                	jne    8014af <smalloc+0x51>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	eb 65                	jmp    801514 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014af:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	ff 75 08             	pushl  0x8(%ebp)
  8014bd:	e8 83 03 00 00       	call   801845 <sys_createSharedObject>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014c8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014cc:	74 06                	je     8014d4 <smalloc+0x76>
  8014ce:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d2:	75 07                	jne    8014db <smalloc+0x7d>
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d9:	eb 39                	jmp    801514 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e1:	68 ae 41 80 00       	push   $0x8041ae
  8014e6:	e8 a6 ee ff ff       	call   800391 <cprintf>
  8014eb:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8014ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8014f6:	8b 40 78             	mov    0x78(%eax),%eax
  8014f9:	29 c2                	sub    %eax,%edx
  8014fb:	89 d0                	mov    %edx,%eax
  8014fd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801502:	c1 e8 0c             	shr    $0xc,%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801511:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80151c:	83 ec 08             	sub    $0x8,%esp
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	e8 45 03 00 00       	call   80186f <sys_getSizeOfSharedObject>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801530:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801534:	75 07                	jne    80153d <sget+0x27>
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 5c                	jmp    801599 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801540:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801543:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80154a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	39 d0                	cmp    %edx,%eax
  801552:	7d 02                	jge    801556 <sget+0x40>
  801554:	89 d0                	mov    %edx,%eax
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	50                   	push   %eax
  80155a:	e8 e2 fb ff ff       	call   801141 <malloc>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801565:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801569:	75 07                	jne    801572 <sget+0x5c>
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
  801570:	eb 27                	jmp    801599 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	ff 75 e8             	pushl  -0x18(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 09 03 00 00       	call   80188c <sys_getSharedObject>
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801589:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80158d:	75 07                	jne    801596 <sget+0x80>
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
  801594:	eb 03                	jmp    801599 <sget+0x83>
	return ptr;
  801596:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a9:	8b 40 78             	mov    0x78(%eax),%eax
  8015ac:	29 c2                	sub    %eax,%edx
  8015ae:	89 d0                	mov    %edx,%eax
  8015b0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b5:	c1 e8 0c             	shr    $0xc,%eax
  8015b8:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cb:	e8 db 02 00 00       	call   8018ab <sys_freeSharedObject>
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015d6:	90                   	nop
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 c0 41 80 00       	push   $0x8041c0
  8015e7:	68 dd 00 00 00       	push   $0xdd
  8015ec:	68 a2 41 80 00       	push   $0x8041a2
  8015f1:	e8 40 22 00 00       	call   803836 <_panic>

008015f6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	68 e6 41 80 00       	push   $0x8041e6
  801604:	68 e9 00 00 00       	push   $0xe9
  801609:	68 a2 41 80 00       	push   $0x8041a2
  80160e:	e8 23 22 00 00       	call   803836 <_panic>

00801613 <shrink>:

}
void shrink(uint32 newSize)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	68 e6 41 80 00       	push   $0x8041e6
  801621:	68 ee 00 00 00       	push   $0xee
  801626:	68 a2 41 80 00       	push   $0x8041a2
  80162b:	e8 06 22 00 00       	call   803836 <_panic>

00801630 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 e6 41 80 00       	push   $0x8041e6
  80163e:	68 f3 00 00 00       	push   $0xf3
  801643:	68 a2 41 80 00       	push   $0x8041a2
  801648:	e8 e9 21 00 00       	call   803836 <_panic>

0080164d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801662:	8b 7d 18             	mov    0x18(%ebp),%edi
  801665:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801668:	cd 30                	int    $0x30
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5f                   	pop    %edi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801684:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	52                   	push   %edx
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	6a 00                	push   $0x0
  801696:	e8 b2 ff ff ff       	call   80164d <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	90                   	nop
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 02                	push   $0x2
  8016b0:	e8 98 ff ff ff       	call   80164d <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 03                	push   $0x3
  8016c9:	e8 7f ff ff ff       	call   80164d <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 04                	push   $0x4
  8016e3:	e8 65 ff ff ff       	call   80164d <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	90                   	nop
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	52                   	push   %edx
  8016fe:	50                   	push   %eax
  8016ff:	6a 08                	push   $0x8
  801701:	e8 47 ff ff ff       	call   80164d <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801710:	8b 75 18             	mov    0x18(%ebp),%esi
  801713:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801716:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	51                   	push   %ecx
  801722:	52                   	push   %edx
  801723:	50                   	push   %eax
  801724:	6a 09                	push   $0x9
  801726:	e8 22 ff ff ff       	call   80164d <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	6a 0a                	push   $0xa
  801748:	e8 00 ff ff ff       	call   80164d <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	ff 75 08             	pushl  0x8(%ebp)
  801761:	6a 0b                	push   $0xb
  801763:	e8 e5 fe ff ff       	call   80164d <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 0c                	push   $0xc
  80177c:	e8 cc fe ff ff       	call   80164d <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 0d                	push   $0xd
  801795:	e8 b3 fe ff ff       	call   80164d <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 0e                	push   $0xe
  8017ae:	e8 9a fe ff ff       	call   80164d <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 0f                	push   $0xf
  8017c7:	e8 81 fe ff ff       	call   80164d <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 10                	push   $0x10
  8017e1:	e8 67 fe ff ff       	call   80164d <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 11                	push   $0x11
  8017fa:	e8 4e fe ff ff       	call   80164d <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_cputc>:

void
sys_cputc(const char c)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801811:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	50                   	push   %eax
  80181e:	6a 01                	push   $0x1
  801820:	e8 28 fe ff ff       	call   80164d <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 14                	push   $0x14
  80183a:	e8 0e fe ff ff       	call   80164d <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	90                   	nop
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	8b 45 10             	mov    0x10(%ebp),%eax
  80184e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801851:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801854:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	51                   	push   %ecx
  80185e:	52                   	push   %edx
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	50                   	push   %eax
  801863:	6a 15                	push   $0x15
  801865:	e8 e3 fd ff ff       	call   80164d <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 16                	push   $0x16
  801882:	e8 c6 fd ff ff       	call   80164d <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	51                   	push   %ecx
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 17                	push   $0x17
  8018a1:	e8 a7 fd ff ff       	call   80164d <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 18                	push   $0x18
  8018be:	e8 8a fd ff ff       	call   80164d <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 14             	pushl  0x14(%ebp)
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	6a 19                	push   $0x19
  8018dc:	e8 6c fd ff ff       	call   80164d <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	50                   	push   %eax
  8018f5:	6a 1a                	push   $0x1a
  8018f7:	e8 51 fd ff ff       	call   80164d <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	90                   	nop
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	50                   	push   %eax
  801911:	6a 1b                	push   $0x1b
  801913:	e8 35 fd ff ff       	call   80164d <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 05                	push   $0x5
  80192c:	e8 1c fd ff ff       	call   80164d <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 06                	push   $0x6
  801945:	e8 03 fd ff ff       	call   80164d <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 07                	push   $0x7
  80195e:	e8 ea fc ff ff       	call   80164d <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_exit_env>:


void sys_exit_env(void)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 1c                	push   $0x1c
  801977:	e8 d1 fc ff ff       	call   80164d <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801988:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80198b:	8d 50 04             	lea    0x4(%eax),%edx
  80198e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 1d                	push   $0x1d
  80199b:	e8 ad fc ff ff       	call   80164d <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8019a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	89 01                	mov    %eax,(%ecx)
  8019ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	c9                   	leave  
  8019b5:	c2 04 00             	ret    $0x4

008019b8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 10             	pushl  0x10(%ebp)
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	6a 13                	push   $0x13
  8019ca:	e8 7e fc ff ff       	call   80164d <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d2:	90                   	nop
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 1e                	push   $0x1e
  8019e4:	e8 64 fc ff ff       	call   80164d <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	50                   	push   %eax
  801a07:	6a 1f                	push   $0x1f
  801a09:	e8 3f fc ff ff       	call   80164d <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a11:	90                   	nop
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <rsttst>:
void rsttst()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 21                	push   $0x21
  801a23:	e8 25 fc ff ff       	call   80164d <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 14             	mov    0x14(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a3a:	8b 55 18             	mov    0x18(%ebp),%edx
  801a3d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	ff 75 10             	pushl  0x10(%ebp)
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	6a 20                	push   $0x20
  801a4e:	e8 fa fb ff ff       	call   80164d <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
	return ;
  801a56:	90                   	nop
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <chktst>:
void chktst(uint32 n)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 08             	pushl  0x8(%ebp)
  801a67:	6a 22                	push   $0x22
  801a69:	e8 df fb ff ff       	call   80164d <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a71:	90                   	nop
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <inctst>:

void inctst()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 23                	push   $0x23
  801a83:	e8 c5 fb ff ff       	call   80164d <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8b:	90                   	nop
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <gettst>:
uint32 gettst()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 24                	push   $0x24
  801a9d:	e8 ab fb ff ff       	call   80164d <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 25                	push   $0x25
  801ab9:	e8 8f fb ff ff       	call   80164d <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
  801ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ac4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ac8:	75 07                	jne    801ad1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	eb 05                	jmp    801ad6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 25                	push   $0x25
  801aea:	e8 5e fb ff ff       	call   80164d <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
  801af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801af5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801af9:	75 07                	jne    801b02 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801afb:	b8 01 00 00 00       	mov    $0x1,%eax
  801b00:	eb 05                	jmp    801b07 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 25                	push   $0x25
  801b1b:	e8 2d fb ff ff       	call   80164d <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
  801b23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b26:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b2a:	75 07                	jne    801b33 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b31:	eb 05                	jmp    801b38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 25                	push   $0x25
  801b4c:	e8 fc fa ff ff       	call   80164d <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
  801b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b57:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b5b:	75 07                	jne    801b64 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b62:	eb 05                	jmp    801b69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	6a 26                	push   $0x26
  801b7b:	e8 cd fa ff ff       	call   80164d <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
	return ;
  801b83:	90                   	nop
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	53                   	push   %ebx
  801b99:	51                   	push   %ecx
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 27                	push   $0x27
  801b9e:	e8 aa fa ff ff       	call   80164d <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 28                	push   $0x28
  801bbe:	e8 8a fa ff ff       	call   80164d <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bcb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	51                   	push   %ecx
  801bd7:	ff 75 10             	pushl  0x10(%ebp)
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 29                	push   $0x29
  801bde:	e8 6a fa ff ff       	call   80164d <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 10             	pushl  0x10(%ebp)
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	6a 12                	push   $0x12
  801bfa:	e8 4e fa ff ff       	call   80164d <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
	return ;
  801c02:	90                   	nop
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 2a                	push   $0x2a
  801c18:	e8 30 fa ff ff       	call   80164d <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	50                   	push   %eax
  801c32:	6a 2b                	push   $0x2b
  801c34:	e8 14 fa ff ff       	call   80164d <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 2c                	push   $0x2c
  801c4f:	e8 f9 f9 ff ff       	call   80164d <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	6a 2d                	push   $0x2d
  801c6b:	e8 dd f9 ff ff       	call   80164d <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	83 e8 04             	sub    $0x4,%eax
  801c82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c88:	8b 00                	mov    (%eax),%eax
  801c8a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	83 e8 04             	sub    $0x4,%eax
  801c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	83 e0 01             	and    $0x1,%eax
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	0f 94 c0             	sete   %al
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbd:	83 f8 02             	cmp    $0x2,%eax
  801cc0:	74 2b                	je     801ced <alloc_block+0x40>
  801cc2:	83 f8 02             	cmp    $0x2,%eax
  801cc5:	7f 07                	jg     801cce <alloc_block+0x21>
  801cc7:	83 f8 01             	cmp    $0x1,%eax
  801cca:	74 0e                	je     801cda <alloc_block+0x2d>
  801ccc:	eb 58                	jmp    801d26 <alloc_block+0x79>
  801cce:	83 f8 03             	cmp    $0x3,%eax
  801cd1:	74 2d                	je     801d00 <alloc_block+0x53>
  801cd3:	83 f8 04             	cmp    $0x4,%eax
  801cd6:	74 3b                	je     801d13 <alloc_block+0x66>
  801cd8:	eb 4c                	jmp    801d26 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cda:	83 ec 0c             	sub    $0xc,%esp
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	e8 11 03 00 00       	call   801ff6 <alloc_block_FF>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ceb:	eb 4a                	jmp    801d37 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ced:	83 ec 0c             	sub    $0xc,%esp
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	e8 fa 19 00 00       	call   8036f2 <alloc_block_NF>
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cfe:	eb 37                	jmp    801d37 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	e8 a7 07 00 00       	call   8024b2 <alloc_block_BF>
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d11:	eb 24                	jmp    801d37 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	e8 b7 19 00 00       	call   8036d5 <alloc_block_WF>
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d24:	eb 11                	jmp    801d37 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	68 f8 41 80 00       	push   $0x8041f8
  801d2e:	e8 5e e6 ff ff       	call   800391 <cprintf>
  801d33:	83 c4 10             	add    $0x10,%esp
		break;
  801d36:	90                   	nop
	}
	return va;
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	68 18 42 80 00       	push   $0x804218
  801d4b:	e8 41 e6 ff ff       	call   800391 <cprintf>
  801d50:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	68 43 42 80 00       	push   $0x804243
  801d5b:	e8 31 e6 ff ff       	call   800391 <cprintf>
  801d60:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d69:	eb 37                	jmp    801da2 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d71:	e8 19 ff ff ff       	call   801c8f <is_free_block>
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	0f be d8             	movsbl %al,%ebx
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d82:	e8 ef fe ff ff       	call   801c76 <get_block_size>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	53                   	push   %ebx
  801d8e:	50                   	push   %eax
  801d8f:	68 5b 42 80 00       	push   $0x80425b
  801d94:	e8 f8 e5 ff ff       	call   800391 <cprintf>
  801d99:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da6:	74 07                	je     801daf <print_blocks_list+0x73>
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	8b 00                	mov    (%eax),%eax
  801dad:	eb 05                	jmp    801db4 <print_blocks_list+0x78>
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	89 45 10             	mov    %eax,0x10(%ebp)
  801db7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	75 ad                	jne    801d6b <print_blocks_list+0x2f>
  801dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc2:	75 a7                	jne    801d6b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	68 18 42 80 00       	push   $0x804218
  801dcc:	e8 c0 e5 ff ff       	call   800391 <cprintf>
  801dd1:	83 c4 10             	add    $0x10,%esp

}
  801dd4:	90                   	nop
  801dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	83 e0 01             	and    $0x1,%eax
  801de6:	85 c0                	test   %eax,%eax
  801de8:	74 03                	je     801ded <initialize_dynamic_allocator+0x13>
  801dea:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ded:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801df1:	0f 84 c7 01 00 00    	je     801fbe <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801df7:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801dfe:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e01:	8b 55 08             	mov    0x8(%ebp),%edx
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	01 d0                	add    %edx,%eax
  801e09:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e0e:	0f 87 ad 01 00 00    	ja     801fc1 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 89 a5 01 00 00    	jns    801fc4 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e25:	01 d0                	add    %edx,%eax
  801e27:	83 e8 04             	sub    $0x4,%eax
  801e2a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e36:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3e:	e9 87 00 00 00       	jmp    801eca <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e47:	75 14                	jne    801e5d <initialize_dynamic_allocator+0x83>
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 73 42 80 00       	push   $0x804273
  801e51:	6a 79                	push   $0x79
  801e53:	68 91 42 80 00       	push   $0x804291
  801e58:	e8 d9 19 00 00       	call   803836 <_panic>
  801e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	74 10                	je     801e76 <initialize_dynamic_allocator+0x9c>
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	8b 00                	mov    (%eax),%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	8b 52 04             	mov    0x4(%edx),%edx
  801e71:	89 50 04             	mov    %edx,0x4(%eax)
  801e74:	eb 0b                	jmp    801e81 <initialize_dynamic_allocator+0xa7>
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 40 04             	mov    0x4(%eax),%eax
  801e7c:	a3 30 50 80 00       	mov    %eax,0x805030
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	8b 40 04             	mov    0x4(%eax),%eax
  801e87:	85 c0                	test   %eax,%eax
  801e89:	74 0f                	je     801e9a <initialize_dynamic_allocator+0xc0>
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 40 04             	mov    0x4(%eax),%eax
  801e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e94:	8b 12                	mov    (%edx),%edx
  801e96:	89 10                	mov    %edx,(%eax)
  801e98:	eb 0a                	jmp    801ea4 <initialize_dynamic_allocator+0xca>
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 00                	mov    (%eax),%eax
  801e9f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb7:	a1 38 50 80 00       	mov    0x805038,%eax
  801ebc:	48                   	dec    %eax
  801ebd:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ec2:	a1 34 50 80 00       	mov    0x805034,%eax
  801ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ece:	74 07                	je     801ed7 <initialize_dynamic_allocator+0xfd>
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	eb 05                	jmp    801edc <initialize_dynamic_allocator+0x102>
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	a3 34 50 80 00       	mov    %eax,0x805034
  801ee1:	a1 34 50 80 00       	mov    0x805034,%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	0f 85 55 ff ff ff    	jne    801e43 <initialize_dynamic_allocator+0x69>
  801eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef2:	0f 85 4b ff ff ff    	jne    801e43 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f01:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f07:	a1 44 50 80 00       	mov    0x805044,%eax
  801f0c:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f11:	a1 40 50 80 00       	mov    0x805040,%eax
  801f16:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	83 c0 08             	add    $0x8,%eax
  801f22:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	83 c0 04             	add    $0x4,%eax
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	83 ea 08             	sub    $0x8,%edx
  801f31:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	01 d0                	add    %edx,%eax
  801f3b:	83 e8 08             	sub    $0x8,%eax
  801f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f41:	83 ea 08             	sub    $0x8,%edx
  801f44:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5d:	75 17                	jne    801f76 <initialize_dynamic_allocator+0x19c>
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 ac 42 80 00       	push   $0x8042ac
  801f67:	68 90 00 00 00       	push   $0x90
  801f6c:	68 91 42 80 00       	push   $0x804291
  801f71:	e8 c0 18 00 00       	call   803836 <_panic>
  801f76:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7f:	89 10                	mov    %edx,(%eax)
  801f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	74 0d                	je     801f97 <initialize_dynamic_allocator+0x1bd>
  801f8a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f92:	89 50 04             	mov    %edx,0x4(%eax)
  801f95:	eb 08                	jmp    801f9f <initialize_dynamic_allocator+0x1c5>
  801f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9a:	a3 30 50 80 00       	mov    %eax,0x805030
  801f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801faa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb1:	a1 38 50 80 00       	mov    0x805038,%eax
  801fb6:	40                   	inc    %eax
  801fb7:	a3 38 50 80 00       	mov    %eax,0x805038
  801fbc:	eb 07                	jmp    801fc5 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fbe:	90                   	nop
  801fbf:	eb 04                	jmp    801fc5 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fc1:	90                   	nop
  801fc2:	eb 01                	jmp    801fc5 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fc4:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fca:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcd:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd9:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	83 e8 04             	sub    $0x4,%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	83 e0 fe             	and    $0xfffffffe,%eax
  801fe6:	8d 50 f8             	lea    -0x8(%eax),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	01 c2                	add    %eax,%edx
  801fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff1:	89 02                	mov    %eax,(%edx)
}
  801ff3:	90                   	nop
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    

00801ff6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	83 e0 01             	and    $0x1,%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	74 03                	je     802009 <alloc_block_FF+0x13>
  802006:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802009:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80200d:	77 07                	ja     802016 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80200f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802016:	a1 24 50 80 00       	mov    0x805024,%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 73                	jne    802092 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	83 c0 10             	add    $0x10,%eax
  802025:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802028:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80202f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802035:	01 d0                	add    %edx,%eax
  802037:	48                   	dec    %eax
  802038:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80203b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80203e:	ba 00 00 00 00       	mov    $0x0,%edx
  802043:	f7 75 ec             	divl   -0x14(%ebp)
  802046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802049:	29 d0                	sub    %edx,%eax
  80204b:	c1 e8 0c             	shr    $0xc,%eax
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	50                   	push   %eax
  802052:	e8 d4 f0 ff ff       	call   80112b <sbrk>
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	6a 00                	push   $0x0
  802062:	e8 c4 f0 ff ff       	call   80112b <sbrk>
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80206d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802070:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802073:	83 ec 08             	sub    $0x8,%esp
  802076:	50                   	push   %eax
  802077:	ff 75 e4             	pushl  -0x1c(%ebp)
  80207a:	e8 5b fd ff ff       	call   801dda <initialize_dynamic_allocator>
  80207f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	68 cf 42 80 00       	push   $0x8042cf
  80208a:	e8 02 e3 ff ff       	call   800391 <cprintf>
  80208f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802096:	75 0a                	jne    8020a2 <alloc_block_FF+0xac>
	        return NULL;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	e9 0e 04 00 00       	jmp    8024b0 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b1:	e9 f3 02 00 00       	jmp    8023a9 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 bc             	pushl  -0x44(%ebp)
  8020c2:	e8 af fb ff ff       	call   801c76 <get_block_size>
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	83 c0 08             	add    $0x8,%eax
  8020d3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020d6:	0f 87 c5 02 00 00    	ja     8023a1 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	83 c0 18             	add    $0x18,%eax
  8020e2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020e5:	0f 87 19 02 00 00    	ja     802304 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8020f1:	83 e8 08             	sub    $0x8,%eax
  8020f4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	8d 50 08             	lea    0x8(%eax),%edx
  8020fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802100:	01 d0                	add    %edx,%eax
  802102:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	83 c0 08             	add    $0x8,%eax
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	6a 01                	push   $0x1
  802110:	50                   	push   %eax
  802111:	ff 75 bc             	pushl  -0x44(%ebp)
  802114:	e8 ae fe ff ff       	call   801fc7 <set_block_data>
  802119:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 40 04             	mov    0x4(%eax),%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	75 68                	jne    80218e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802126:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80212a:	75 17                	jne    802143 <alloc_block_FF+0x14d>
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	68 ac 42 80 00       	push   $0x8042ac
  802134:	68 d7 00 00 00       	push   $0xd7
  802139:	68 91 42 80 00       	push   $0x804291
  80213e:	e8 f3 16 00 00       	call   803836 <_panic>
  802143:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802149:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80214c:	89 10                	mov    %edx,(%eax)
  80214e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	74 0d                	je     802164 <alloc_block_FF+0x16e>
  802157:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80215c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80215f:	89 50 04             	mov    %edx,0x4(%eax)
  802162:	eb 08                	jmp    80216c <alloc_block_FF+0x176>
  802164:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802167:	a3 30 50 80 00       	mov    %eax,0x805030
  80216c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80216f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802174:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802177:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217e:	a1 38 50 80 00       	mov    0x805038,%eax
  802183:	40                   	inc    %eax
  802184:	a3 38 50 80 00       	mov    %eax,0x805038
  802189:	e9 dc 00 00 00       	jmp    80226a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 00                	mov    (%eax),%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	75 65                	jne    8021fc <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802197:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80219b:	75 17                	jne    8021b4 <alloc_block_FF+0x1be>
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 e0 42 80 00       	push   $0x8042e0
  8021a5:	68 db 00 00 00       	push   $0xdb
  8021aa:	68 91 42 80 00       	push   $0x804291
  8021af:	e8 82 16 00 00       	call   803836 <_panic>
  8021b4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021bd:	89 50 04             	mov    %edx,0x4(%eax)
  8021c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021c3:	8b 40 04             	mov    0x4(%eax),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 0c                	je     8021d6 <alloc_block_FF+0x1e0>
  8021ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8021cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021d2:	89 10                	mov    %edx,(%eax)
  8021d4:	eb 08                	jmp    8021de <alloc_block_FF+0x1e8>
  8021d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8021e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8021f4:	40                   	inc    %eax
  8021f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8021fa:	eb 6e                	jmp    80226a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	74 06                	je     802208 <alloc_block_FF+0x212>
  802202:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802206:	75 17                	jne    80221f <alloc_block_FF+0x229>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 04 43 80 00       	push   $0x804304
  802210:	68 df 00 00 00       	push   $0xdf
  802215:	68 91 42 80 00       	push   $0x804291
  80221a:	e8 17 16 00 00       	call   803836 <_panic>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 10                	mov    (%eax),%edx
  802224:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802227:	89 10                	mov    %edx,(%eax)
  802229:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	74 0b                	je     80223d <alloc_block_FF+0x247>
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80223a:	89 50 04             	mov    %edx,0x4(%eax)
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	89 50 04             	mov    %edx,0x4(%eax)
  80224e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	85 c0                	test   %eax,%eax
  802255:	75 08                	jne    80225f <alloc_block_FF+0x269>
  802257:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80225a:	a3 30 50 80 00       	mov    %eax,0x805030
  80225f:	a1 38 50 80 00       	mov    0x805038,%eax
  802264:	40                   	inc    %eax
  802265:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80226a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226e:	75 17                	jne    802287 <alloc_block_FF+0x291>
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 73 42 80 00       	push   $0x804273
  802278:	68 e1 00 00 00       	push   $0xe1
  80227d:	68 91 42 80 00       	push   $0x804291
  802282:	e8 af 15 00 00       	call   803836 <_panic>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 10                	je     8022a0 <alloc_block_FF+0x2aa>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802298:	8b 52 04             	mov    0x4(%edx),%edx
  80229b:	89 50 04             	mov    %edx,0x4(%eax)
  80229e:	eb 0b                	jmp    8022ab <alloc_block_FF+0x2b5>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 40 04             	mov    0x4(%eax),%eax
  8022a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 0f                	je     8022c4 <alloc_block_FF+0x2ce>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 40 04             	mov    0x4(%eax),%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	8b 12                	mov    (%edx),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 0a                	jmp    8022ce <alloc_block_FF+0x2d8>
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e6:	48                   	dec    %eax
  8022e7:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022f4:	ff 75 b0             	pushl  -0x50(%ebp)
  8022f7:	e8 cb fc ff ff       	call   801fc7 <set_block_data>
  8022fc:	83 c4 10             	add    $0x10,%esp
  8022ff:	e9 95 00 00 00       	jmp    802399 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	6a 01                	push   $0x1
  802309:	ff 75 b8             	pushl  -0x48(%ebp)
  80230c:	ff 75 bc             	pushl  -0x44(%ebp)
  80230f:	e8 b3 fc ff ff       	call   801fc7 <set_block_data>
  802314:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	75 17                	jne    802334 <alloc_block_FF+0x33e>
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 73 42 80 00       	push   $0x804273
  802325:	68 e8 00 00 00       	push   $0xe8
  80232a:	68 91 42 80 00       	push   $0x804291
  80232f:	e8 02 15 00 00       	call   803836 <_panic>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 10                	je     80234d <alloc_block_FF+0x357>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802345:	8b 52 04             	mov    0x4(%edx),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	eb 0b                	jmp    802358 <alloc_block_FF+0x362>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	a3 30 50 80 00       	mov    %eax,0x805030
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 04             	mov    0x4(%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0f                	je     802371 <alloc_block_FF+0x37b>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236b:	8b 12                	mov    (%edx),%edx
  80236d:	89 10                	mov    %edx,(%eax)
  80236f:	eb 0a                	jmp    80237b <alloc_block_FF+0x385>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238e:	a1 38 50 80 00       	mov    0x805038,%eax
  802393:	48                   	dec    %eax
  802394:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802399:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80239c:	e9 0f 01 00 00       	jmp    8024b0 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a1:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ad:	74 07                	je     8023b6 <alloc_block_FF+0x3c0>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	eb 05                	jmp    8023bb <alloc_block_FF+0x3c5>
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	a3 34 50 80 00       	mov    %eax,0x805034
  8023c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	0f 85 e9 fc ff ff    	jne    8020b6 <alloc_block_FF+0xc0>
  8023cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d1:	0f 85 df fc ff ff    	jne    8020b6 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	83 c0 08             	add    $0x8,%eax
  8023dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023e0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ed:	01 d0                	add    %edx,%eax
  8023ef:	48                   	dec    %eax
  8023f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fb:	f7 75 d8             	divl   -0x28(%ebp)
  8023fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802401:	29 d0                	sub    %edx,%eax
  802403:	c1 e8 0c             	shr    $0xc,%eax
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	50                   	push   %eax
  80240a:	e8 1c ed ff ff       	call   80112b <sbrk>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802415:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802419:	75 0a                	jne    802425 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	e9 8b 00 00 00       	jmp    8024b0 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802425:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80242c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80242f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802432:	01 d0                	add    %edx,%eax
  802434:	48                   	dec    %eax
  802435:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802438:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80243b:	ba 00 00 00 00       	mov    $0x0,%edx
  802440:	f7 75 cc             	divl   -0x34(%ebp)
  802443:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802446:	29 d0                	sub    %edx,%eax
  802448:	8d 50 fc             	lea    -0x4(%eax),%edx
  80244b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80244e:	01 d0                	add    %edx,%eax
  802450:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802455:	a1 40 50 80 00       	mov    0x805040,%eax
  80245a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802460:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802467:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80246a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80246d:	01 d0                	add    %edx,%eax
  80246f:	48                   	dec    %eax
  802470:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802473:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802476:	ba 00 00 00 00       	mov    $0x0,%edx
  80247b:	f7 75 c4             	divl   -0x3c(%ebp)
  80247e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802481:	29 d0                	sub    %edx,%eax
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	6a 01                	push   $0x1
  802488:	50                   	push   %eax
  802489:	ff 75 d0             	pushl  -0x30(%ebp)
  80248c:	e8 36 fb ff ff       	call   801fc7 <set_block_data>
  802491:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	ff 75 d0             	pushl  -0x30(%ebp)
  80249a:	e8 1b 0a 00 00       	call   802eba <free_block>
  80249f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024a2:	83 ec 0c             	sub    $0xc,%esp
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	e8 49 fb ff ff       	call   801ff6 <alloc_block_FF>
  8024ad:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	83 e0 01             	and    $0x1,%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	74 03                	je     8024c5 <alloc_block_BF+0x13>
  8024c2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024c5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024c9:	77 07                	ja     8024d2 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024cb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	75 73                	jne    80254e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	83 c0 10             	add    $0x10,%eax
  8024e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024e4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	48                   	dec    %eax
  8024f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ff:	f7 75 e0             	divl   -0x20(%ebp)
  802502:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802505:	29 d0                	sub    %edx,%eax
  802507:	c1 e8 0c             	shr    $0xc,%eax
  80250a:	83 ec 0c             	sub    $0xc,%esp
  80250d:	50                   	push   %eax
  80250e:	e8 18 ec ff ff       	call   80112b <sbrk>
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802519:	83 ec 0c             	sub    $0xc,%esp
  80251c:	6a 00                	push   $0x0
  80251e:	e8 08 ec ff ff       	call   80112b <sbrk>
  802523:	83 c4 10             	add    $0x10,%esp
  802526:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80252f:	83 ec 08             	sub    $0x8,%esp
  802532:	50                   	push   %eax
  802533:	ff 75 d8             	pushl  -0x28(%ebp)
  802536:	e8 9f f8 ff ff       	call   801dda <initialize_dynamic_allocator>
  80253b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	68 cf 42 80 00       	push   $0x8042cf
  802546:	e8 46 de ff ff       	call   800391 <cprintf>
  80254b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80254e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80255c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802563:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80256a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802572:	e9 1d 01 00 00       	jmp    802694 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	ff 75 a8             	pushl  -0x58(%ebp)
  802583:	e8 ee f6 ff ff       	call   801c76 <get_block_size>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	83 c0 08             	add    $0x8,%eax
  802594:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802597:	0f 87 ef 00 00 00    	ja     80268c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	83 c0 18             	add    $0x18,%eax
  8025a3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025a6:	77 1d                	ja     8025c5 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ae:	0f 86 d8 00 00 00    	jbe    80268c <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025b4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025c0:	e9 c7 00 00 00       	jmp    80268c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	83 c0 08             	add    $0x8,%eax
  8025cb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ce:	0f 85 9d 00 00 00    	jne    802671 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	6a 01                	push   $0x1
  8025d9:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025dc:	ff 75 a8             	pushl  -0x58(%ebp)
  8025df:	e8 e3 f9 ff ff       	call   801fc7 <set_block_data>
  8025e4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025eb:	75 17                	jne    802604 <alloc_block_BF+0x152>
  8025ed:	83 ec 04             	sub    $0x4,%esp
  8025f0:	68 73 42 80 00       	push   $0x804273
  8025f5:	68 2c 01 00 00       	push   $0x12c
  8025fa:	68 91 42 80 00       	push   $0x804291
  8025ff:	e8 32 12 00 00       	call   803836 <_panic>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 10                	je     80261d <alloc_block_BF+0x16b>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802615:	8b 52 04             	mov    0x4(%edx),%edx
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	eb 0b                	jmp    802628 <alloc_block_BF+0x176>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 40 04             	mov    0x4(%eax),%eax
  802623:	a3 30 50 80 00       	mov    %eax,0x805030
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 0f                	je     802641 <alloc_block_BF+0x18f>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263b:	8b 12                	mov    (%edx),%edx
  80263d:	89 10                	mov    %edx,(%eax)
  80263f:	eb 0a                	jmp    80264b <alloc_block_BF+0x199>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265e:	a1 38 50 80 00       	mov    0x805038,%eax
  802663:	48                   	dec    %eax
  802664:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802669:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80266c:	e9 24 04 00 00       	jmp    802a95 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802674:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802677:	76 13                	jbe    80268c <alloc_block_BF+0x1da>
					{
						internal = 1;
  802679:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802680:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802683:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802686:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802689:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80268c:	a1 34 50 80 00       	mov    0x805034,%eax
  802691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	74 07                	je     8026a1 <alloc_block_BF+0x1ef>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	eb 05                	jmp    8026a6 <alloc_block_BF+0x1f4>
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a6:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ab:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	0f 85 bf fe ff ff    	jne    802577 <alloc_block_BF+0xc5>
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	0f 85 b5 fe ff ff    	jne    802577 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c6:	0f 84 26 02 00 00    	je     8028f2 <alloc_block_BF+0x440>
  8026cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d0:	0f 85 1c 02 00 00    	jne    8028f2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026dc:	83 e8 08             	sub    $0x8,%eax
  8026df:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	8d 50 08             	lea    0x8(%eax),%edx
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	01 d0                	add    %edx,%eax
  8026ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f3:	83 c0 08             	add    $0x8,%eax
  8026f6:	83 ec 04             	sub    $0x4,%esp
  8026f9:	6a 01                	push   $0x1
  8026fb:	50                   	push   %eax
  8026fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ff:	e8 c3 f8 ff ff       	call   801fc7 <set_block_data>
  802704:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	75 68                	jne    802779 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802711:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802715:	75 17                	jne    80272e <alloc_block_BF+0x27c>
  802717:	83 ec 04             	sub    $0x4,%esp
  80271a:	68 ac 42 80 00       	push   $0x8042ac
  80271f:	68 45 01 00 00       	push   $0x145
  802724:	68 91 42 80 00       	push   $0x804291
  802729:	e8 08 11 00 00       	call   803836 <_panic>
  80272e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802734:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802737:	89 10                	mov    %edx,(%eax)
  802739:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 0d                	je     80274f <alloc_block_BF+0x29d>
  802742:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802747:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80274a:	89 50 04             	mov    %edx,0x4(%eax)
  80274d:	eb 08                	jmp    802757 <alloc_block_BF+0x2a5>
  80274f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802752:	a3 30 50 80 00       	mov    %eax,0x805030
  802757:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80275f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802762:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802769:	a1 38 50 80 00       	mov    0x805038,%eax
  80276e:	40                   	inc    %eax
  80276f:	a3 38 50 80 00       	mov    %eax,0x805038
  802774:	e9 dc 00 00 00       	jmp    802855 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	75 65                	jne    8027e7 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802782:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802786:	75 17                	jne    80279f <alloc_block_BF+0x2ed>
  802788:	83 ec 04             	sub    $0x4,%esp
  80278b:	68 e0 42 80 00       	push   $0x8042e0
  802790:	68 4a 01 00 00       	push   $0x14a
  802795:	68 91 42 80 00       	push   $0x804291
  80279a:	e8 97 10 00 00       	call   803836 <_panic>
  80279f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a8:	89 50 04             	mov    %edx,0x4(%eax)
  8027ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 0c                	je     8027c1 <alloc_block_BF+0x30f>
  8027b5:	a1 30 50 80 00       	mov    0x805030,%eax
  8027ba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027bd:	89 10                	mov    %edx,(%eax)
  8027bf:	eb 08                	jmp    8027c9 <alloc_block_BF+0x317>
  8027c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027da:	a1 38 50 80 00       	mov    0x805038,%eax
  8027df:	40                   	inc    %eax
  8027e0:	a3 38 50 80 00       	mov    %eax,0x805038
  8027e5:	eb 6e                	jmp    802855 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027eb:	74 06                	je     8027f3 <alloc_block_BF+0x341>
  8027ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027f1:	75 17                	jne    80280a <alloc_block_BF+0x358>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 04 43 80 00       	push   $0x804304
  8027fb:	68 4f 01 00 00       	push   $0x14f
  802800:	68 91 42 80 00       	push   $0x804291
  802805:	e8 2c 10 00 00       	call   803836 <_panic>
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	8b 10                	mov    (%eax),%edx
  80280f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802812:	89 10                	mov    %edx,(%eax)
  802814:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	74 0b                	je     802828 <alloc_block_BF+0x376>
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802825:	89 50 04             	mov    %edx,0x4(%eax)
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80282e:	89 10                	mov    %edx,(%eax)
  802830:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802833:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802836:	89 50 04             	mov    %edx,0x4(%eax)
  802839:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	75 08                	jne    80284a <alloc_block_BF+0x398>
  802842:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802845:	a3 30 50 80 00       	mov    %eax,0x805030
  80284a:	a1 38 50 80 00       	mov    0x805038,%eax
  80284f:	40                   	inc    %eax
  802850:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802855:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802859:	75 17                	jne    802872 <alloc_block_BF+0x3c0>
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	68 73 42 80 00       	push   $0x804273
  802863:	68 51 01 00 00       	push   $0x151
  802868:	68 91 42 80 00       	push   $0x804291
  80286d:	e8 c4 0f 00 00       	call   803836 <_panic>
  802872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 10                	je     80288b <alloc_block_BF+0x3d9>
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802883:	8b 52 04             	mov    0x4(%edx),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 0b                	jmp    802896 <alloc_block_BF+0x3e4>
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	a3 30 50 80 00       	mov    %eax,0x805030
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0f                	je     8028af <alloc_block_BF+0x3fd>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a9:	8b 12                	mov    (%edx),%edx
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	eb 0a                	jmp    8028b9 <alloc_block_BF+0x407>
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d1:	48                   	dec    %eax
  8028d2:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	6a 00                	push   $0x0
  8028dc:	ff 75 d0             	pushl  -0x30(%ebp)
  8028df:	ff 75 cc             	pushl  -0x34(%ebp)
  8028e2:	e8 e0 f6 ff ff       	call   801fc7 <set_block_data>
  8028e7:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	e9 a3 01 00 00       	jmp    802a95 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028f2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028f6:	0f 85 9d 00 00 00    	jne    802999 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	6a 01                	push   $0x1
  802901:	ff 75 ec             	pushl  -0x14(%ebp)
  802904:	ff 75 f0             	pushl  -0x10(%ebp)
  802907:	e8 bb f6 ff ff       	call   801fc7 <set_block_data>
  80290c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80290f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_BF+0x47a>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 73 42 80 00       	push   $0x804273
  80291d:	68 58 01 00 00       	push   $0x158
  802922:	68 91 42 80 00       	push   $0x804291
  802927:	e8 0a 0f 00 00       	call   803836 <_panic>
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 10                	je     802945 <alloc_block_BF+0x493>
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293d:	8b 52 04             	mov    0x4(%edx),%edx
  802940:	89 50 04             	mov    %edx,0x4(%eax)
  802943:	eb 0b                	jmp    802950 <alloc_block_BF+0x49e>
  802945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	a3 30 50 80 00       	mov    %eax,0x805030
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0f                	je     802969 <alloc_block_BF+0x4b7>
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802963:	8b 12                	mov    (%edx),%edx
  802965:	89 10                	mov    %edx,(%eax)
  802967:	eb 0a                	jmp    802973 <alloc_block_BF+0x4c1>
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802986:	a1 38 50 80 00       	mov    0x805038,%eax
  80298b:	48                   	dec    %eax
  80298c:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	e9 fc 00 00 00       	jmp    802a95 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	83 c0 08             	add    $0x8,%eax
  80299f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029a2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029af:	01 d0                	add    %edx,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bd:	f7 75 c4             	divl   -0x3c(%ebp)
  8029c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029c3:	29 d0                	sub    %edx,%eax
  8029c5:	c1 e8 0c             	shr    $0xc,%eax
  8029c8:	83 ec 0c             	sub    $0xc,%esp
  8029cb:	50                   	push   %eax
  8029cc:	e8 5a e7 ff ff       	call   80112b <sbrk>
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029d7:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029db:	75 0a                	jne    8029e7 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e2:	e9 ae 00 00 00       	jmp    802a95 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029e7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029ee:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029f4:	01 d0                	add    %edx,%eax
  8029f6:	48                   	dec    %eax
  8029f7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802a02:	f7 75 b8             	divl   -0x48(%ebp)
  802a05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a08:	29 d0                	sub    %edx,%eax
  802a0a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a17:	a1 40 50 80 00       	mov    0x805040,%eax
  802a1c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a22:	83 ec 0c             	sub    $0xc,%esp
  802a25:	68 38 43 80 00       	push   $0x804338
  802a2a:	e8 62 d9 ff ff       	call   800391 <cprintf>
  802a2f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a32:	83 ec 08             	sub    $0x8,%esp
  802a35:	ff 75 bc             	pushl  -0x44(%ebp)
  802a38:	68 3d 43 80 00       	push   $0x80433d
  802a3d:	e8 4f d9 ff ff       	call   800391 <cprintf>
  802a42:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a45:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a4c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a52:	01 d0                	add    %edx,%eax
  802a54:	48                   	dec    %eax
  802a55:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a58:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a60:	f7 75 b0             	divl   -0x50(%ebp)
  802a63:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a66:	29 d0                	sub    %edx,%eax
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	6a 01                	push   $0x1
  802a6d:	50                   	push   %eax
  802a6e:	ff 75 bc             	pushl  -0x44(%ebp)
  802a71:	e8 51 f5 ff ff       	call   801fc7 <set_block_data>
  802a76:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a79:	83 ec 0c             	sub    $0xc,%esp
  802a7c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a7f:	e8 36 04 00 00       	call   802eba <free_block>
  802a84:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a87:	83 ec 0c             	sub    $0xc,%esp
  802a8a:	ff 75 08             	pushl  0x8(%ebp)
  802a8d:	e8 20 fa ff ff       	call   8024b2 <alloc_block_BF>
  802a92:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a95:	c9                   	leave  
  802a96:	c3                   	ret    

00802a97 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a97:	55                   	push   %ebp
  802a98:	89 e5                	mov    %esp,%ebp
  802a9a:	53                   	push   %ebx
  802a9b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aa5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802aac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab0:	74 1e                	je     802ad0 <merging+0x39>
  802ab2:	ff 75 08             	pushl  0x8(%ebp)
  802ab5:	e8 bc f1 ff ff       	call   801c76 <get_block_size>
  802aba:	83 c4 04             	add    $0x4,%esp
  802abd:	89 c2                	mov    %eax,%edx
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	01 d0                	add    %edx,%eax
  802ac4:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ac7:	75 07                	jne    802ad0 <merging+0x39>
		prev_is_free = 1;
  802ac9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ad0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ad4:	74 1e                	je     802af4 <merging+0x5d>
  802ad6:	ff 75 10             	pushl  0x10(%ebp)
  802ad9:	e8 98 f1 ff ff       	call   801c76 <get_block_size>
  802ade:	83 c4 04             	add    $0x4,%esp
  802ae1:	89 c2                	mov    %eax,%edx
  802ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae6:	01 d0                	add    %edx,%eax
  802ae8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aeb:	75 07                	jne    802af4 <merging+0x5d>
		next_is_free = 1;
  802aed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af8:	0f 84 cc 00 00 00    	je     802bca <merging+0x133>
  802afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b02:	0f 84 c2 00 00 00    	je     802bca <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b08:	ff 75 08             	pushl  0x8(%ebp)
  802b0b:	e8 66 f1 ff ff       	call   801c76 <get_block_size>
  802b10:	83 c4 04             	add    $0x4,%esp
  802b13:	89 c3                	mov    %eax,%ebx
  802b15:	ff 75 10             	pushl  0x10(%ebp)
  802b18:	e8 59 f1 ff ff       	call   801c76 <get_block_size>
  802b1d:	83 c4 04             	add    $0x4,%esp
  802b20:	01 c3                	add    %eax,%ebx
  802b22:	ff 75 0c             	pushl  0xc(%ebp)
  802b25:	e8 4c f1 ff ff       	call   801c76 <get_block_size>
  802b2a:	83 c4 04             	add    $0x4,%esp
  802b2d:	01 d8                	add    %ebx,%eax
  802b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b32:	6a 00                	push   $0x0
  802b34:	ff 75 ec             	pushl  -0x14(%ebp)
  802b37:	ff 75 08             	pushl  0x8(%ebp)
  802b3a:	e8 88 f4 ff ff       	call   801fc7 <set_block_data>
  802b3f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b46:	75 17                	jne    802b5f <merging+0xc8>
  802b48:	83 ec 04             	sub    $0x4,%esp
  802b4b:	68 73 42 80 00       	push   $0x804273
  802b50:	68 7d 01 00 00       	push   $0x17d
  802b55:	68 91 42 80 00       	push   $0x804291
  802b5a:	e8 d7 0c 00 00       	call   803836 <_panic>
  802b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 10                	je     802b78 <merging+0xe1>
  802b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b70:	8b 52 04             	mov    0x4(%edx),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 0b                	jmp    802b83 <merging+0xec>
  802b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 0f                	je     802b9c <merging+0x105>
  802b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b96:	8b 12                	mov    (%edx),%edx
  802b98:	89 10                	mov    %edx,(%eax)
  802b9a:	eb 0a                	jmp    802ba6 <merging+0x10f>
  802b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbe:	48                   	dec    %eax
  802bbf:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802bc4:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bc5:	e9 ea 02 00 00       	jmp    802eb4 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	74 3b                	je     802c0b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	ff 75 08             	pushl  0x8(%ebp)
  802bd6:	e8 9b f0 ff ff       	call   801c76 <get_block_size>
  802bdb:	83 c4 10             	add    $0x10,%esp
  802bde:	89 c3                	mov    %eax,%ebx
  802be0:	83 ec 0c             	sub    $0xc,%esp
  802be3:	ff 75 10             	pushl  0x10(%ebp)
  802be6:	e8 8b f0 ff ff       	call   801c76 <get_block_size>
  802beb:	83 c4 10             	add    $0x10,%esp
  802bee:	01 d8                	add    %ebx,%eax
  802bf0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	6a 00                	push   $0x0
  802bf8:	ff 75 e8             	pushl  -0x18(%ebp)
  802bfb:	ff 75 08             	pushl  0x8(%ebp)
  802bfe:	e8 c4 f3 ff ff       	call   801fc7 <set_block_data>
  802c03:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c06:	e9 a9 02 00 00       	jmp    802eb4 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0f:	0f 84 2d 01 00 00    	je     802d42 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c15:	83 ec 0c             	sub    $0xc,%esp
  802c18:	ff 75 10             	pushl  0x10(%ebp)
  802c1b:	e8 56 f0 ff ff       	call   801c76 <get_block_size>
  802c20:	83 c4 10             	add    $0x10,%esp
  802c23:	89 c3                	mov    %eax,%ebx
  802c25:	83 ec 0c             	sub    $0xc,%esp
  802c28:	ff 75 0c             	pushl  0xc(%ebp)
  802c2b:	e8 46 f0 ff ff       	call   801c76 <get_block_size>
  802c30:	83 c4 10             	add    $0x10,%esp
  802c33:	01 d8                	add    %ebx,%eax
  802c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	6a 00                	push   $0x0
  802c3d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c40:	ff 75 10             	pushl  0x10(%ebp)
  802c43:	e8 7f f3 ff ff       	call   801fc7 <set_block_data>
  802c48:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c55:	74 06                	je     802c5d <merging+0x1c6>
  802c57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c5b:	75 17                	jne    802c74 <merging+0x1dd>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 4c 43 80 00       	push   $0x80434c
  802c65:	68 8d 01 00 00       	push   $0x18d
  802c6a:	68 91 42 80 00       	push   $0x804291
  802c6f:	e8 c2 0b 00 00       	call   803836 <_panic>
  802c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c77:	8b 50 04             	mov    0x4(%eax),%edx
  802c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c86:	89 10                	mov    %edx,(%eax)
  802c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 0d                	je     802c9f <merging+0x208>
  802c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c95:	8b 40 04             	mov    0x4(%eax),%eax
  802c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	eb 08                	jmp    802ca7 <merging+0x210>
  802c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802caa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb5:	40                   	inc    %eax
  802cb6:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cbf:	75 17                	jne    802cd8 <merging+0x241>
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 73 42 80 00       	push   $0x804273
  802cc9:	68 8e 01 00 00       	push   $0x18e
  802cce:	68 91 42 80 00       	push   $0x804291
  802cd3:	e8 5e 0b 00 00       	call   803836 <_panic>
  802cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 10                	je     802cf1 <merging+0x25a>
  802ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce9:	8b 52 04             	mov    0x4(%edx),%edx
  802cec:	89 50 04             	mov    %edx,0x4(%eax)
  802cef:	eb 0b                	jmp    802cfc <merging+0x265>
  802cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	a3 30 50 80 00       	mov    %eax,0x805030
  802cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0f                	je     802d15 <merging+0x27e>
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0f:	8b 12                	mov    (%edx),%edx
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	eb 0a                	jmp    802d1f <merging+0x288>
  802d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 38 50 80 00       	mov    0x805038,%eax
  802d37:	48                   	dec    %eax
  802d38:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d3d:	e9 72 01 00 00       	jmp    802eb4 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d42:	8b 45 10             	mov    0x10(%ebp),%eax
  802d45:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4c:	74 79                	je     802dc7 <merging+0x330>
  802d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d52:	74 73                	je     802dc7 <merging+0x330>
  802d54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d58:	74 06                	je     802d60 <merging+0x2c9>
  802d5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d5e:	75 17                	jne    802d77 <merging+0x2e0>
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	68 04 43 80 00       	push   $0x804304
  802d68:	68 94 01 00 00       	push   $0x194
  802d6d:	68 91 42 80 00       	push   $0x804291
  802d72:	e8 bf 0a 00 00       	call   803836 <_panic>
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 10                	mov    (%eax),%edx
  802d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0b                	je     802d95 <merging+0x2fe>
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d92:	89 50 04             	mov    %edx,0x4(%eax)
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da0:	8b 55 08             	mov    0x8(%ebp),%edx
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	75 08                	jne    802db7 <merging+0x320>
  802daf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db2:	a3 30 50 80 00       	mov    %eax,0x805030
  802db7:	a1 38 50 80 00       	mov    0x805038,%eax
  802dbc:	40                   	inc    %eax
  802dbd:	a3 38 50 80 00       	mov    %eax,0x805038
  802dc2:	e9 ce 00 00 00       	jmp    802e95 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcb:	74 65                	je     802e32 <merging+0x39b>
  802dcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dd1:	75 17                	jne    802dea <merging+0x353>
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	68 e0 42 80 00       	push   $0x8042e0
  802ddb:	68 95 01 00 00       	push   $0x195
  802de0:	68 91 42 80 00       	push   $0x804291
  802de5:	e8 4c 0a 00 00       	call   803836 <_panic>
  802dea:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802df0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
  802df6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 0c                	je     802e0c <merging+0x375>
  802e00:	a1 30 50 80 00       	mov    0x805030,%eax
  802e05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	eb 08                	jmp    802e14 <merging+0x37d>
  802e0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e17:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e25:	a1 38 50 80 00       	mov    0x805038,%eax
  802e2a:	40                   	inc    %eax
  802e2b:	a3 38 50 80 00       	mov    %eax,0x805038
  802e30:	eb 63                	jmp    802e95 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e32:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e36:	75 17                	jne    802e4f <merging+0x3b8>
  802e38:	83 ec 04             	sub    $0x4,%esp
  802e3b:	68 ac 42 80 00       	push   $0x8042ac
  802e40:	68 98 01 00 00       	push   $0x198
  802e45:	68 91 42 80 00       	push   $0x804291
  802e4a:	e8 e7 09 00 00       	call   803836 <_panic>
  802e4f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	74 0d                	je     802e70 <merging+0x3d9>
  802e63:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e6b:	89 50 04             	mov    %edx,0x4(%eax)
  802e6e:	eb 08                	jmp    802e78 <merging+0x3e1>
  802e70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e73:	a3 30 50 80 00       	mov    %eax,0x805030
  802e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8f:	40                   	inc    %eax
  802e90:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	ff 75 10             	pushl  0x10(%ebp)
  802e9b:	e8 d6 ed ff ff       	call   801c76 <get_block_size>
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	83 ec 04             	sub    $0x4,%esp
  802ea6:	6a 00                	push   $0x0
  802ea8:	50                   	push   %eax
  802ea9:	ff 75 10             	pushl  0x10(%ebp)
  802eac:	e8 16 f1 ff ff       	call   801fc7 <set_block_data>
  802eb1:	83 c4 10             	add    $0x10,%esp
	}
}
  802eb4:	90                   	nop
  802eb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eb8:	c9                   	leave  
  802eb9:	c3                   	ret    

00802eba <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802eba:	55                   	push   %ebp
  802ebb:	89 e5                	mov    %esp,%ebp
  802ebd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ec0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802ec8:	a1 30 50 80 00       	mov    0x805030,%eax
  802ecd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed0:	73 1b                	jae    802eed <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ed2:	a1 30 50 80 00       	mov    0x805030,%eax
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	ff 75 08             	pushl  0x8(%ebp)
  802edd:	6a 00                	push   $0x0
  802edf:	50                   	push   %eax
  802ee0:	e8 b2 fb ff ff       	call   802a97 <merging>
  802ee5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ee8:	e9 8b 00 00 00       	jmp    802f78 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802eed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef5:	76 18                	jbe    802f0f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ef7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	ff 75 08             	pushl  0x8(%ebp)
  802f02:	50                   	push   %eax
  802f03:	6a 00                	push   $0x0
  802f05:	e8 8d fb ff ff       	call   802a97 <merging>
  802f0a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f0d:	eb 69                	jmp    802f78 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f0f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f17:	eb 39                	jmp    802f52 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1f:	73 29                	jae    802f4a <free_block+0x90>
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f29:	76 1f                	jbe    802f4a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	ff 75 08             	pushl  0x8(%ebp)
  802f39:	ff 75 f0             	pushl  -0x10(%ebp)
  802f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f3f:	e8 53 fb ff ff       	call   802a97 <merging>
  802f44:	83 c4 10             	add    $0x10,%esp
			break;
  802f47:	90                   	nop
		}
	}
}
  802f48:	eb 2e                	jmp    802f78 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f4a:	a1 34 50 80 00       	mov    0x805034,%eax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	74 07                	je     802f5f <free_block+0xa5>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	eb 05                	jmp    802f64 <free_block+0xaa>
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f64:	a3 34 50 80 00       	mov    %eax,0x805034
  802f69:	a1 34 50 80 00       	mov    0x805034,%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	75 a7                	jne    802f19 <free_block+0x5f>
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	75 a1                	jne    802f19 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f78:	90                   	nop
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
  802f7e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f81:	ff 75 08             	pushl  0x8(%ebp)
  802f84:	e8 ed ec ff ff       	call   801c76 <get_block_size>
  802f89:	83 c4 04             	add    $0x4,%esp
  802f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f96:	eb 17                	jmp    802faf <copy_data+0x34>
  802f98:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9e:	01 c2                	add    %eax,%edx
  802fa0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	01 c8                	add    %ecx,%eax
  802fa8:	8a 00                	mov    (%eax),%al
  802faa:	88 02                	mov    %al,(%edx)
  802fac:	ff 45 fc             	incl   -0x4(%ebp)
  802faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fb2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fb5:	72 e1                	jb     802f98 <copy_data+0x1d>
}
  802fb7:	90                   	nop
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc4:	75 23                	jne    802fe9 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fca:	74 13                	je     802fdf <realloc_block_FF+0x25>
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	ff 75 0c             	pushl  0xc(%ebp)
  802fd2:	e8 1f f0 ff ff       	call   801ff6 <alloc_block_FF>
  802fd7:	83 c4 10             	add    $0x10,%esp
  802fda:	e9 f4 06 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
		return NULL;
  802fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe4:	e9 ea 06 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fed:	75 18                	jne    803007 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fef:	83 ec 0c             	sub    $0xc,%esp
  802ff2:	ff 75 08             	pushl  0x8(%ebp)
  802ff5:	e8 c0 fe ff ff       	call   802eba <free_block>
  802ffa:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  803002:	e9 cc 06 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803007:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80300b:	77 07                	ja     803014 <realloc_block_FF+0x5a>
  80300d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	83 e0 01             	and    $0x1,%eax
  80301a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80301d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803020:	83 c0 08             	add    $0x8,%eax
  803023:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	ff 75 08             	pushl  0x8(%ebp)
  80302c:	e8 45 ec ff ff       	call   801c76 <get_block_size>
  803031:	83 c4 10             	add    $0x10,%esp
  803034:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	83 e8 08             	sub    $0x8,%eax
  80303d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	83 e8 04             	sub    $0x4,%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	83 e0 fe             	and    $0xfffffffe,%eax
  80304b:	89 c2                	mov    %eax,%edx
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	01 d0                	add    %edx,%eax
  803052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803055:	83 ec 0c             	sub    $0xc,%esp
  803058:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305b:	e8 16 ec ff ff       	call   801c76 <get_block_size>
  803060:	83 c4 10             	add    $0x10,%esp
  803063:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803066:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803069:	83 e8 08             	sub    $0x8,%eax
  80306c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80306f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803072:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803075:	75 08                	jne    80307f <realloc_block_FF+0xc5>
	{
		 return va;
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	e9 54 06 00 00       	jmp    8036d3 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80307f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803082:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803085:	0f 83 e5 03 00 00    	jae    803470 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803091:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803094:	83 ec 0c             	sub    $0xc,%esp
  803097:	ff 75 e4             	pushl  -0x1c(%ebp)
  80309a:	e8 f0 eb ff ff       	call   801c8f <is_free_block>
  80309f:	83 c4 10             	add    $0x10,%esp
  8030a2:	84 c0                	test   %al,%al
  8030a4:	0f 84 3b 01 00 00    	je     8031e5 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030b0:	01 d0                	add    %edx,%eax
  8030b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030b5:	83 ec 04             	sub    $0x4,%esp
  8030b8:	6a 01                	push   $0x1
  8030ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8030bd:	ff 75 08             	pushl  0x8(%ebp)
  8030c0:	e8 02 ef ff ff       	call   801fc7 <set_block_data>
  8030c5:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	83 e8 04             	sub    $0x4,%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	83 e0 fe             	and    $0xfffffffe,%eax
  8030d3:	89 c2                	mov    %eax,%edx
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	01 d0                	add    %edx,%eax
  8030da:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	6a 00                	push   $0x0
  8030e2:	ff 75 cc             	pushl  -0x34(%ebp)
  8030e5:	ff 75 c8             	pushl  -0x38(%ebp)
  8030e8:	e8 da ee ff ff       	call   801fc7 <set_block_data>
  8030ed:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030f4:	74 06                	je     8030fc <realloc_block_FF+0x142>
  8030f6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030fa:	75 17                	jne    803113 <realloc_block_FF+0x159>
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	68 04 43 80 00       	push   $0x804304
  803104:	68 f6 01 00 00       	push   $0x1f6
  803109:	68 91 42 80 00       	push   $0x804291
  80310e:	e8 23 07 00 00       	call   803836 <_panic>
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	8b 10                	mov    (%eax),%edx
  803118:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 0b                	je     803131 <realloc_block_FF+0x177>
  803126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803134:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803137:	89 10                	mov    %edx,(%eax)
  803139:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80313c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	75 08                	jne    803153 <realloc_block_FF+0x199>
  80314b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80314e:	a3 30 50 80 00       	mov    %eax,0x805030
  803153:	a1 38 50 80 00       	mov    0x805038,%eax
  803158:	40                   	inc    %eax
  803159:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80315e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803162:	75 17                	jne    80317b <realloc_block_FF+0x1c1>
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	68 73 42 80 00       	push   $0x804273
  80316c:	68 f7 01 00 00       	push   $0x1f7
  803171:	68 91 42 80 00       	push   $0x804291
  803176:	e8 bb 06 00 00       	call   803836 <_panic>
  80317b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 10                	je     803194 <realloc_block_FF+0x1da>
  803184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80318c:	8b 52 04             	mov    0x4(%edx),%edx
  80318f:	89 50 04             	mov    %edx,0x4(%eax)
  803192:	eb 0b                	jmp    80319f <realloc_block_FF+0x1e5>
  803194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	a3 30 50 80 00       	mov    %eax,0x805030
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0f                	je     8031b8 <realloc_block_FF+0x1fe>
  8031a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b2:	8b 12                	mov    (%edx),%edx
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	eb 0a                	jmp    8031c2 <realloc_block_FF+0x208>
  8031b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8031da:	48                   	dec    %eax
  8031db:	a3 38 50 80 00       	mov    %eax,0x805038
  8031e0:	e9 83 02 00 00       	jmp    803468 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8031e5:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8031e9:	0f 86 69 02 00 00    	jbe    803458 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	6a 01                	push   $0x1
  8031f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031f7:	ff 75 08             	pushl  0x8(%ebp)
  8031fa:	e8 c8 ed ff ff       	call   801fc7 <set_block_data>
  8031ff:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	83 e8 04             	sub    $0x4,%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	83 e0 fe             	and    $0xfffffffe,%eax
  80320d:	89 c2                	mov    %eax,%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	01 d0                	add    %edx,%eax
  803214:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803217:	a1 38 50 80 00       	mov    0x805038,%eax
  80321c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80321f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803223:	75 68                	jne    80328d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803225:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803229:	75 17                	jne    803242 <realloc_block_FF+0x288>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 ac 42 80 00       	push   $0x8042ac
  803233:	68 06 02 00 00       	push   $0x206
  803238:	68 91 42 80 00       	push   $0x804291
  80323d:	e8 f4 05 00 00       	call   803836 <_panic>
  803242:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <realloc_block_FF+0x2a9>
  803256:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80325b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 08                	jmp    80326b <realloc_block_FF+0x2b1>
  803263:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803266:	a3 30 50 80 00       	mov    %eax,0x805030
  80326b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80326e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327d:	a1 38 50 80 00       	mov    0x805038,%eax
  803282:	40                   	inc    %eax
  803283:	a3 38 50 80 00       	mov    %eax,0x805038
  803288:	e9 b0 01 00 00       	jmp    80343d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80328d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803292:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803295:	76 68                	jbe    8032ff <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803297:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80329b:	75 17                	jne    8032b4 <realloc_block_FF+0x2fa>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 ac 42 80 00       	push   $0x8042ac
  8032a5:	68 0b 02 00 00       	push   $0x20b
  8032aa:	68 91 42 80 00       	push   $0x804291
  8032af:	e8 82 05 00 00       	call   803836 <_panic>
  8032b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 0d                	je     8032d5 <realloc_block_FF+0x31b>
  8032c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	eb 08                	jmp    8032dd <realloc_block_FF+0x323>
  8032d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8032dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8032fa:	e9 3e 01 00 00       	jmp    80343d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803304:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803307:	73 68                	jae    803371 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803309:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80330d:	75 17                	jne    803326 <realloc_block_FF+0x36c>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 e0 42 80 00       	push   $0x8042e0
  803317:	68 10 02 00 00       	push   $0x210
  80331c:	68 91 42 80 00       	push   $0x804291
  803321:	e8 10 05 00 00       	call   803836 <_panic>
  803326:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80332c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 0c                	je     803348 <realloc_block_FF+0x38e>
  80333c:	a1 30 50 80 00       	mov    0x805030,%eax
  803341:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803344:	89 10                	mov    %edx,(%eax)
  803346:	eb 08                	jmp    803350 <realloc_block_FF+0x396>
  803348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803350:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803353:	a3 30 50 80 00       	mov    %eax,0x805030
  803358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803361:	a1 38 50 80 00       	mov    0x805038,%eax
  803366:	40                   	inc    %eax
  803367:	a3 38 50 80 00       	mov    %eax,0x805038
  80336c:	e9 cc 00 00 00       	jmp    80343d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803371:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803378:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80337d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803380:	e9 8a 00 00 00       	jmp    80340f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80338b:	73 7a                	jae    803407 <realloc_block_FF+0x44d>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803395:	73 70                	jae    803407 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339b:	74 06                	je     8033a3 <realloc_block_FF+0x3e9>
  80339d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a1:	75 17                	jne    8033ba <realloc_block_FF+0x400>
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 04 43 80 00       	push   $0x804304
  8033ab:	68 1a 02 00 00       	push   $0x21a
  8033b0:	68 91 42 80 00       	push   $0x804291
  8033b5:	e8 7c 04 00 00       	call   803836 <_panic>
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 10                	mov    (%eax),%edx
  8033bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c2:	89 10                	mov    %edx,(%eax)
  8033c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c7:	8b 00                	mov    (%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 0b                	je     8033d8 <realloc_block_FF+0x41e>
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033d5:	89 50 04             	mov    %edx,0x4(%eax)
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e6:	89 50 04             	mov    %edx,0x4(%eax)
  8033e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	75 08                	jne    8033fa <realloc_block_FF+0x440>
  8033f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ff:	40                   	inc    %eax
  803400:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803405:	eb 36                	jmp    80343d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803407:	a1 34 50 80 00       	mov    0x805034,%eax
  80340c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803413:	74 07                	je     80341c <realloc_block_FF+0x462>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	eb 05                	jmp    803421 <realloc_block_FF+0x467>
  80341c:	b8 00 00 00 00       	mov    $0x0,%eax
  803421:	a3 34 50 80 00       	mov    %eax,0x805034
  803426:	a1 34 50 80 00       	mov    0x805034,%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	0f 85 52 ff ff ff    	jne    803385 <realloc_block_FF+0x3cb>
  803433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803437:	0f 85 48 ff ff ff    	jne    803385 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80343d:	83 ec 04             	sub    $0x4,%esp
  803440:	6a 00                	push   $0x0
  803442:	ff 75 d8             	pushl  -0x28(%ebp)
  803445:	ff 75 d4             	pushl  -0x2c(%ebp)
  803448:	e8 7a eb ff ff       	call   801fc7 <set_block_data>
  80344d:	83 c4 10             	add    $0x10,%esp
				return va;
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	e9 7b 02 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803458:	83 ec 0c             	sub    $0xc,%esp
  80345b:	68 81 43 80 00       	push   $0x804381
  803460:	e8 2c cf ff ff       	call   800391 <cprintf>
  803465:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	e9 63 02 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803470:	8b 45 0c             	mov    0xc(%ebp),%eax
  803473:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803476:	0f 86 4d 02 00 00    	jbe    8036c9 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803482:	e8 08 e8 ff ff       	call   801c8f <is_free_block>
  803487:	83 c4 10             	add    $0x10,%esp
  80348a:	84 c0                	test   %al,%al
  80348c:	0f 84 37 02 00 00    	je     8036c9 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803492:	8b 45 0c             	mov    0xc(%ebp),%eax
  803495:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803498:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80349b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80349e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034a1:	76 38                	jbe    8034db <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034a3:	83 ec 0c             	sub    $0xc,%esp
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 0c fa ff ff       	call   802eba <free_block>
  8034ae:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034b1:	83 ec 0c             	sub    $0xc,%esp
  8034b4:	ff 75 0c             	pushl  0xc(%ebp)
  8034b7:	e8 3a eb ff ff       	call   801ff6 <alloc_block_FF>
  8034bc:	83 c4 10             	add    $0x10,%esp
  8034bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034c2:	83 ec 08             	sub    $0x8,%esp
  8034c5:	ff 75 c0             	pushl  -0x40(%ebp)
  8034c8:	ff 75 08             	pushl  0x8(%ebp)
  8034cb:	e8 ab fa ff ff       	call   802f7b <copy_data>
  8034d0:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034d6:	e9 f8 01 00 00       	jmp    8036d3 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034de:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034e4:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8034e8:	0f 87 a0 00 00 00    	ja     80358e <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034f2:	75 17                	jne    80350b <realloc_block_FF+0x551>
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	68 73 42 80 00       	push   $0x804273
  8034fc:	68 38 02 00 00       	push   $0x238
  803501:	68 91 42 80 00       	push   $0x804291
  803506:	e8 2b 03 00 00       	call   803836 <_panic>
  80350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 10                	je     803524 <realloc_block_FF+0x56a>
  803514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80351c:	8b 52 04             	mov    0x4(%edx),%edx
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	eb 0b                	jmp    80352f <realloc_block_FF+0x575>
  803524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	a3 30 50 80 00       	mov    %eax,0x805030
  80352f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803532:	8b 40 04             	mov    0x4(%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	74 0f                	je     803548 <realloc_block_FF+0x58e>
  803539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353c:	8b 40 04             	mov    0x4(%eax),%eax
  80353f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803542:	8b 12                	mov    (%edx),%edx
  803544:	89 10                	mov    %edx,(%eax)
  803546:	eb 0a                	jmp    803552 <realloc_block_FF+0x598>
  803548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354b:	8b 00                	mov    (%eax),%eax
  80354d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803565:	a1 38 50 80 00       	mov    0x805038,%eax
  80356a:	48                   	dec    %eax
  80356b:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803570:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803576:	01 d0                	add    %edx,%eax
  803578:	83 ec 04             	sub    $0x4,%esp
  80357b:	6a 01                	push   $0x1
  80357d:	50                   	push   %eax
  80357e:	ff 75 08             	pushl  0x8(%ebp)
  803581:	e8 41 ea ff ff       	call   801fc7 <set_block_data>
  803586:	83 c4 10             	add    $0x10,%esp
  803589:	e9 36 01 00 00       	jmp    8036c4 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80358e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803591:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803594:	01 d0                	add    %edx,%eax
  803596:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803599:	83 ec 04             	sub    $0x4,%esp
  80359c:	6a 01                	push   $0x1
  80359e:	ff 75 f0             	pushl  -0x10(%ebp)
  8035a1:	ff 75 08             	pushl  0x8(%ebp)
  8035a4:	e8 1e ea ff ff       	call   801fc7 <set_block_data>
  8035a9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	83 e8 04             	sub    $0x4,%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	83 e0 fe             	and    $0xfffffffe,%eax
  8035b7:	89 c2                	mov    %eax,%edx
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	01 d0                	add    %edx,%eax
  8035be:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035c5:	74 06                	je     8035cd <realloc_block_FF+0x613>
  8035c7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035cb:	75 17                	jne    8035e4 <realloc_block_FF+0x62a>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 04 43 80 00       	push   $0x804304
  8035d5:	68 44 02 00 00       	push   $0x244
  8035da:	68 91 42 80 00       	push   $0x804291
  8035df:	e8 52 02 00 00       	call   803836 <_panic>
  8035e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e7:	8b 10                	mov    (%eax),%edx
  8035e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 0b                	je     803602 <realloc_block_FF+0x648>
  8035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035ff:	89 50 04             	mov    %edx,0x4(%eax)
  803602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803605:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80360d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803610:	89 50 04             	mov    %edx,0x4(%eax)
  803613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	75 08                	jne    803624 <realloc_block_FF+0x66a>
  80361c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80361f:	a3 30 50 80 00       	mov    %eax,0x805030
  803624:	a1 38 50 80 00       	mov    0x805038,%eax
  803629:	40                   	inc    %eax
  80362a:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80362f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803633:	75 17                	jne    80364c <realloc_block_FF+0x692>
  803635:	83 ec 04             	sub    $0x4,%esp
  803638:	68 73 42 80 00       	push   $0x804273
  80363d:	68 45 02 00 00       	push   $0x245
  803642:	68 91 42 80 00       	push   $0x804291
  803647:	e8 ea 01 00 00       	call   803836 <_panic>
  80364c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 10                	je     803665 <realloc_block_FF+0x6ab>
  803655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365d:	8b 52 04             	mov    0x4(%edx),%edx
  803660:	89 50 04             	mov    %edx,0x4(%eax)
  803663:	eb 0b                	jmp    803670 <realloc_block_FF+0x6b6>
  803665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803668:	8b 40 04             	mov    0x4(%eax),%eax
  80366b:	a3 30 50 80 00       	mov    %eax,0x805030
  803670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803673:	8b 40 04             	mov    0x4(%eax),%eax
  803676:	85 c0                	test   %eax,%eax
  803678:	74 0f                	je     803689 <realloc_block_FF+0x6cf>
  80367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367d:	8b 40 04             	mov    0x4(%eax),%eax
  803680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803683:	8b 12                	mov    (%edx),%edx
  803685:	89 10                	mov    %edx,(%eax)
  803687:	eb 0a                	jmp    803693 <realloc_block_FF+0x6d9>
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803696:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036ab:	48                   	dec    %eax
  8036ac:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	6a 00                	push   $0x0
  8036b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8036b9:	ff 75 b8             	pushl  -0x48(%ebp)
  8036bc:	e8 06 e9 ff ff       	call   801fc7 <set_block_data>
  8036c1:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	eb 0a                	jmp    8036d3 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036c9:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036d3:	c9                   	leave  
  8036d4:	c3                   	ret    

008036d5 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036d5:	55                   	push   %ebp
  8036d6:	89 e5                	mov    %esp,%ebp
  8036d8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036db:	83 ec 04             	sub    $0x4,%esp
  8036de:	68 88 43 80 00       	push   $0x804388
  8036e3:	68 58 02 00 00       	push   $0x258
  8036e8:	68 91 42 80 00       	push   $0x804291
  8036ed:	e8 44 01 00 00       	call   803836 <_panic>

008036f2 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036f2:	55                   	push   %ebp
  8036f3:	89 e5                	mov    %esp,%ebp
  8036f5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 b0 43 80 00       	push   $0x8043b0
  803700:	68 61 02 00 00       	push   $0x261
  803705:	68 91 42 80 00       	push   $0x804291
  80370a:	e8 27 01 00 00       	call   803836 <_panic>

0080370f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80370f:	55                   	push   %ebp
  803710:	89 e5                	mov    %esp,%ebp
  803712:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803715:	83 ec 04             	sub    $0x4,%esp
  803718:	68 d8 43 80 00       	push   $0x8043d8
  80371d:	6a 09                	push   $0x9
  80371f:	68 00 44 80 00       	push   $0x804400
  803724:	e8 0d 01 00 00       	call   803836 <_panic>

00803729 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803729:	55                   	push   %ebp
  80372a:	89 e5                	mov    %esp,%ebp
  80372c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80372f:	83 ec 04             	sub    $0x4,%esp
  803732:	68 10 44 80 00       	push   $0x804410
  803737:	6a 10                	push   $0x10
  803739:	68 00 44 80 00       	push   $0x804400
  80373e:	e8 f3 00 00 00       	call   803836 <_panic>

00803743 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
  803746:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803749:	83 ec 04             	sub    $0x4,%esp
  80374c:	68 38 44 80 00       	push   $0x804438
  803751:	6a 18                	push   $0x18
  803753:	68 00 44 80 00       	push   $0x804400
  803758:	e8 d9 00 00 00       	call   803836 <_panic>

0080375d <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80375d:	55                   	push   %ebp
  80375e:	89 e5                	mov    %esp,%ebp
  803760:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803763:	83 ec 04             	sub    $0x4,%esp
  803766:	68 60 44 80 00       	push   $0x804460
  80376b:	6a 20                	push   $0x20
  80376d:	68 00 44 80 00       	push   $0x804400
  803772:	e8 bf 00 00 00       	call   803836 <_panic>

00803777 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803777:	55                   	push   %ebp
  803778:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 40 10             	mov    0x10(%eax),%eax
}
  803780:	5d                   	pop    %ebp
  803781:	c3                   	ret    

00803782 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803782:	55                   	push   %ebp
  803783:	89 e5                	mov    %esp,%ebp
  803785:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803788:	8b 55 08             	mov    0x8(%ebp),%edx
  80378b:	89 d0                	mov    %edx,%eax
  80378d:	c1 e0 02             	shl    $0x2,%eax
  803790:	01 d0                	add    %edx,%eax
  803792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803799:	01 d0                	add    %edx,%eax
  80379b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037a2:	01 d0                	add    %edx,%eax
  8037a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037ab:	01 d0                	add    %edx,%eax
  8037ad:	c1 e0 04             	shl    $0x4,%eax
  8037b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8037ba:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037bd:	83 ec 0c             	sub    $0xc,%esp
  8037c0:	50                   	push   %eax
  8037c1:	e8 bc e1 ff ff       	call   801982 <sys_get_virtual_time>
  8037c6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037c9:	eb 41                	jmp    80380c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037ce:	83 ec 0c             	sub    $0xc,%esp
  8037d1:	50                   	push   %eax
  8037d2:	e8 ab e1 ff ff       	call   801982 <sys_get_virtual_time>
  8037d7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e0:	29 c2                	sub    %eax,%edx
  8037e2:	89 d0                	mov    %edx,%eax
  8037e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ed:	89 d1                	mov    %edx,%ecx
  8037ef:	29 c1                	sub    %eax,%ecx
  8037f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f7:	39 c2                	cmp    %eax,%edx
  8037f9:	0f 97 c0             	seta   %al
  8037fc:	0f b6 c0             	movzbl %al,%eax
  8037ff:	29 c1                	sub    %eax,%ecx
  803801:	89 c8                	mov    %ecx,%eax
  803803:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803806:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803809:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803812:	72 b7                	jb     8037cb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803814:	90                   	nop
  803815:	c9                   	leave  
  803816:	c3                   	ret    

00803817 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803817:	55                   	push   %ebp
  803818:	89 e5                	mov    %esp,%ebp
  80381a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80381d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803824:	eb 03                	jmp    803829 <busy_wait+0x12>
  803826:	ff 45 fc             	incl   -0x4(%ebp)
  803829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80382c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80382f:	72 f5                	jb     803826 <busy_wait+0xf>
	return i;
  803831:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803834:	c9                   	leave  
  803835:	c3                   	ret    

00803836 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803836:	55                   	push   %ebp
  803837:	89 e5                	mov    %esp,%ebp
  803839:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80383c:	8d 45 10             	lea    0x10(%ebp),%eax
  80383f:	83 c0 04             	add    $0x4,%eax
  803842:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803845:	a1 60 50 98 00       	mov    0x985060,%eax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	74 16                	je     803864 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80384e:	a1 60 50 98 00       	mov    0x985060,%eax
  803853:	83 ec 08             	sub    $0x8,%esp
  803856:	50                   	push   %eax
  803857:	68 88 44 80 00       	push   $0x804488
  80385c:	e8 30 cb ff ff       	call   800391 <cprintf>
  803861:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803864:	a1 00 50 80 00       	mov    0x805000,%eax
  803869:	ff 75 0c             	pushl  0xc(%ebp)
  80386c:	ff 75 08             	pushl  0x8(%ebp)
  80386f:	50                   	push   %eax
  803870:	68 8d 44 80 00       	push   $0x80448d
  803875:	e8 17 cb ff ff       	call   800391 <cprintf>
  80387a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80387d:	8b 45 10             	mov    0x10(%ebp),%eax
  803880:	83 ec 08             	sub    $0x8,%esp
  803883:	ff 75 f4             	pushl  -0xc(%ebp)
  803886:	50                   	push   %eax
  803887:	e8 9a ca ff ff       	call   800326 <vcprintf>
  80388c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80388f:	83 ec 08             	sub    $0x8,%esp
  803892:	6a 00                	push   $0x0
  803894:	68 a9 44 80 00       	push   $0x8044a9
  803899:	e8 88 ca ff ff       	call   800326 <vcprintf>
  80389e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038a1:	e8 09 ca ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  8038a6:	eb fe                	jmp    8038a6 <_panic+0x70>

008038a8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038a8:	55                   	push   %ebp
  8038a9:	89 e5                	mov    %esp,%ebp
  8038ab:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8038ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8038b3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bc:	39 c2                	cmp    %eax,%edx
  8038be:	74 14                	je     8038d4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038c0:	83 ec 04             	sub    $0x4,%esp
  8038c3:	68 ac 44 80 00       	push   $0x8044ac
  8038c8:	6a 26                	push   $0x26
  8038ca:	68 f8 44 80 00       	push   $0x8044f8
  8038cf:	e8 62 ff ff ff       	call   803836 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038e2:	e9 c5 00 00 00       	jmp    8039ac <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f4:	01 d0                	add    %edx,%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	85 c0                	test   %eax,%eax
  8038fa:	75 08                	jne    803904 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038fc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038ff:	e9 a5 00 00 00       	jmp    8039a9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803904:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803912:	eb 69                	jmp    80397d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803914:	a1 20 50 80 00       	mov    0x805020,%eax
  803919:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80391f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803922:	89 d0                	mov    %edx,%eax
  803924:	01 c0                	add    %eax,%eax
  803926:	01 d0                	add    %edx,%eax
  803928:	c1 e0 03             	shl    $0x3,%eax
  80392b:	01 c8                	add    %ecx,%eax
  80392d:	8a 40 04             	mov    0x4(%eax),%al
  803930:	84 c0                	test   %al,%al
  803932:	75 46                	jne    80397a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803934:	a1 20 50 80 00       	mov    0x805020,%eax
  803939:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80393f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803942:	89 d0                	mov    %edx,%eax
  803944:	01 c0                	add    %eax,%eax
  803946:	01 d0                	add    %edx,%eax
  803948:	c1 e0 03             	shl    $0x3,%eax
  80394b:	01 c8                	add    %ecx,%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803955:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80395a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	01 c8                	add    %ecx,%eax
  80396b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80396d:	39 c2                	cmp    %eax,%edx
  80396f:	75 09                	jne    80397a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803971:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803978:	eb 15                	jmp    80398f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80397a:	ff 45 e8             	incl   -0x18(%ebp)
  80397d:	a1 20 50 80 00       	mov    0x805020,%eax
  803982:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398b:	39 c2                	cmp    %eax,%edx
  80398d:	77 85                	ja     803914 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80398f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803993:	75 14                	jne    8039a9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803995:	83 ec 04             	sub    $0x4,%esp
  803998:	68 04 45 80 00       	push   $0x804504
  80399d:	6a 3a                	push   $0x3a
  80399f:	68 f8 44 80 00       	push   $0x8044f8
  8039a4:	e8 8d fe ff ff       	call   803836 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8039a9:	ff 45 f0             	incl   -0x10(%ebp)
  8039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039b2:	0f 8c 2f ff ff ff    	jl     8038e7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8039b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039c6:	eb 26                	jmp    8039ee <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8039cd:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039d6:	89 d0                	mov    %edx,%eax
  8039d8:	01 c0                	add    %eax,%eax
  8039da:	01 d0                	add    %edx,%eax
  8039dc:	c1 e0 03             	shl    $0x3,%eax
  8039df:	01 c8                	add    %ecx,%eax
  8039e1:	8a 40 04             	mov    0x4(%eax),%al
  8039e4:	3c 01                	cmp    $0x1,%al
  8039e6:	75 03                	jne    8039eb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039e8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039eb:	ff 45 e0             	incl   -0x20(%ebp)
  8039ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fc:	39 c2                	cmp    %eax,%edx
  8039fe:	77 c8                	ja     8039c8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a06:	74 14                	je     803a1c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a08:	83 ec 04             	sub    $0x4,%esp
  803a0b:	68 58 45 80 00       	push   $0x804558
  803a10:	6a 44                	push   $0x44
  803a12:	68 f8 44 80 00       	push   $0x8044f8
  803a17:	e8 1a fe ff ff       	call   803836 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a1c:	90                   	nop
  803a1d:	c9                   	leave  
  803a1e:	c3                   	ret    
  803a1f:	90                   	nop

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
