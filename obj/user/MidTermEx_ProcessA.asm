
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
  80003e:	e8 5a 18 00 00       	call   80189d <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 3b 80 00       	push   $0x803be0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 97 14 00 00       	call   8014ed <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 3b 80 00       	push   $0x803be2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 81 14 00 00       	call   8014ed <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 3b 80 00       	push   $0x803be9
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
  80008f:	e8 3c 18 00 00       	call   8018d0 <sys_get_virtual_time>
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
  8000b7:	e8 14 36 00 00       	call   8036d0 <env_sleep>
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
  8000d0:	e8 fb 17 00 00       	call   8018d0 <sys_get_virtual_time>
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
  8000f8:	e8 d3 35 00 00       	call   8036d0 <env_sleep>
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
  80010f:	e8 bc 17 00 00       	call   8018d0 <sys_get_virtual_time>
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
  800137:	e8 94 35 00 00       	call   8036d0 <env_sleep>
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
  80014f:	68 f7 3b 80 00       	push   $0x803bf7
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 1a 35 00 00       	call   803677 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 40 35 00 00       	call   8036ab <signal_semaphore>
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
  800184:	e8 fb 16 00 00       	call   801884 <sys_getenvindex>
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
  8001f2:	e8 11 14 00 00       	call   801608 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 14 3c 80 00       	push   $0x803c14
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
  800222:	68 3c 3c 80 00       	push   $0x803c3c
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
  800253:	68 64 3c 80 00       	push   $0x803c64
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 bc 3c 80 00       	push   $0x803cbc
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 14 3c 80 00       	push   $0x803c14
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 91 13 00 00       	call   801622 <sys_unlock_cons>
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
  8002a4:	e8 a7 15 00 00       	call   801850 <sys_destroy_env>
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
  8002b5:	e8 fc 15 00 00       	call   8018b6 <sys_exit_env>
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
  800303:	e8 be 12 00 00       	call   8015c6 <sys_cputs>
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
  80037a:	e8 47 12 00 00       	call   8015c6 <sys_cputs>
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
  8003c4:	e8 3f 12 00 00       	call   801608 <sys_lock_cons>
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
  8003e4:	e8 39 12 00 00       	call   801622 <sys_unlock_cons>
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
  80042e:	e8 3d 35 00 00       	call   803970 <__udivdi3>
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
  80047e:	e8 fd 35 00 00       	call   803a80 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 f4 3e 80 00       	add    $0x803ef4,%eax
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
  8005d9:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
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
  8006ba:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 05 3f 80 00       	push   $0x803f05
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
  8006df:	68 0e 3f 80 00       	push   $0x803f0e
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
  80070c:	be 11 3f 80 00       	mov    $0x803f11,%esi
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
  801117:	68 88 40 80 00       	push   $0x804088
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 aa 40 80 00       	push   $0x8040aa
  801126:	e8 59 26 00 00       	call   803784 <_panic>

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
  801137:	e8 35 0a 00 00       	call   801b71 <sys_sbrk>
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
  8011b2:	e8 3e 08 00 00       	call   8019f5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 7e 0d 00 00       	call   801f44 <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 50 08 00 00       	call   801a26 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 17 12 00 00       	call   802400 <alloc_block_BF>
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
  80134a:	e8 59 08 00 00       	call   801ba8 <sys_allocate_user_mem>
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
  801392:	e8 2d 08 00 00       	call   801bc4 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 60 1a 00 00       	call   802e08 <free_block>
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
  80143a:	e8 4d 07 00 00       	call   801b8c <sys_free_user_mem>
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
  801448:	68 b8 40 80 00       	push   $0x8040b8
  80144d:	68 84 00 00 00       	push   $0x84
  801452:	68 e2 40 80 00       	push   $0x8040e2
  801457:	e8 28 23 00 00       	call   803784 <_panic>
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
  8014ba:	e8 d4 02 00 00       	call   801793 <sys_createSharedObject>
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
  8014db:	68 ee 40 80 00       	push   $0x8040ee
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
  8014f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 f4 40 80 00       	push   $0x8040f4
  8014fb:	68 a4 00 00 00       	push   $0xa4
  801500:	68 e2 40 80 00       	push   $0x8040e2
  801505:	e8 7a 22 00 00       	call   803784 <_panic>

0080150a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 18 41 80 00       	push   $0x804118
  801518:	68 bc 00 00 00       	push   $0xbc
  80151d:	68 e2 40 80 00       	push   $0x8040e2
  801522:	e8 5d 22 00 00       	call   803784 <_panic>

00801527 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 3c 41 80 00       	push   $0x80413c
  801535:	68 d3 00 00 00       	push   $0xd3
  80153a:	68 e2 40 80 00       	push   $0x8040e2
  80153f:	e8 40 22 00 00       	call   803784 <_panic>

00801544 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 62 41 80 00       	push   $0x804162
  801552:	68 df 00 00 00       	push   $0xdf
  801557:	68 e2 40 80 00       	push   $0x8040e2
  80155c:	e8 23 22 00 00       	call   803784 <_panic>

00801561 <shrink>:

}
void shrink(uint32 newSize)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 62 41 80 00       	push   $0x804162
  80156f:	68 e4 00 00 00       	push   $0xe4
  801574:	68 e2 40 80 00       	push   $0x8040e2
  801579:	e8 06 22 00 00       	call   803784 <_panic>

0080157e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 62 41 80 00       	push   $0x804162
  80158c:	68 e9 00 00 00       	push   $0xe9
  801591:	68 e2 40 80 00       	push   $0x8040e2
  801596:	e8 e9 21 00 00       	call   803784 <_panic>

0080159b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	57                   	push   %edi
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b6:	cd 30                	int    $0x30
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	52                   	push   %edx
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 b2 ff ff ff       	call   80159b <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	90                   	nop
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 02                	push   $0x2
  8015fe:	e8 98 ff ff ff       	call   80159b <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 03                	push   $0x3
  801617:	e8 7f ff ff ff       	call   80159b <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 04                	push   $0x4
  801631:	e8 65 ff ff ff       	call   80159b <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	90                   	nop
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 08                	push   $0x8
  80164f:	e8 47 ff ff ff       	call   80159b <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165e:	8b 75 18             	mov    0x18(%ebp),%esi
  801661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	56                   	push   %esi
  80166e:	53                   	push   %ebx
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	6a 09                	push   $0x9
  801674:	e8 22 ff ff ff       	call   80159b <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 0a                	push   $0xa
  801696:	e8 00 ff ff ff       	call   80159b <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	6a 0b                	push   $0xb
  8016b1:	e8 e5 fe ff ff       	call   80159b <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 0c                	push   $0xc
  8016ca:	e8 cc fe ff ff       	call   80159b <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 0d                	push   $0xd
  8016e3:	e8 b3 fe ff ff       	call   80159b <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 0e                	push   $0xe
  8016fc:	e8 9a fe ff ff       	call   80159b <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 0f                	push   $0xf
  801715:	e8 81 fe ff ff       	call   80159b <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 10                	push   $0x10
  80172f:	e8 67 fe ff ff       	call   80159b <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 11                	push   $0x11
  801748:	e8 4e fe ff ff       	call   80159b <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_cputc>:

void
sys_cputc(const char c)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	50                   	push   %eax
  80176c:	6a 01                	push   $0x1
  80176e:	e8 28 fe ff ff       	call   80159b <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	90                   	nop
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 14                	push   $0x14
  801788:	e8 0e fe ff ff       	call   80159b <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	90                   	nop
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	8b 45 10             	mov    0x10(%ebp),%eax
  80179c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80179f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	51                   	push   %ecx
  8017ac:	52                   	push   %edx
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	50                   	push   %eax
  8017b1:	6a 15                	push   $0x15
  8017b3:	e8 e3 fd ff ff       	call   80159b <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	52                   	push   %edx
  8017cd:	50                   	push   %eax
  8017ce:	6a 16                	push   $0x16
  8017d0:	e8 c6 fd ff ff       	call   80159b <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	51                   	push   %ecx
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 17                	push   $0x17
  8017ef:	e8 a7 fd ff ff       	call   80159b <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	52                   	push   %edx
  801809:	50                   	push   %eax
  80180a:	6a 18                	push   $0x18
  80180c:	e8 8a fd ff ff       	call   80159b <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 14             	pushl  0x14(%ebp)
  801821:	ff 75 10             	pushl  0x10(%ebp)
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	50                   	push   %eax
  801828:	6a 19                	push   $0x19
  80182a:	e8 6c fd ff ff       	call   80159b <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	50                   	push   %eax
  801843:	6a 1a                	push   $0x1a
  801845:	e8 51 fd ff ff       	call   80159b <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	50                   	push   %eax
  80185f:	6a 1b                	push   $0x1b
  801861:	e8 35 fd ff ff       	call   80159b <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 05                	push   $0x5
  80187a:	e8 1c fd ff ff       	call   80159b <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 06                	push   $0x6
  801893:	e8 03 fd ff ff       	call   80159b <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 07                	push   $0x7
  8018ac:	e8 ea fc ff ff       	call   80159b <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 1c                	push   $0x1c
  8018c5:	e8 d1 fc ff ff       	call   80159b <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d9:	8d 50 04             	lea    0x4(%eax),%edx
  8018dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 1d                	push   $0x1d
  8018e9:	e8 ad fc ff ff       	call   80159b <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018fa:	89 01                	mov    %eax,(%ecx)
  8018fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	c9                   	leave  
  801903:	c2 04 00             	ret    $0x4

00801906 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 10             	pushl  0x10(%ebp)
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	6a 13                	push   $0x13
  801918:	e8 7e fc ff ff       	call   80159b <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
	return ;
  801920:	90                   	nop
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_rcr2>:
uint32 sys_rcr2()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 1e                	push   $0x1e
  801932:	e8 64 fc ff ff       	call   80159b <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801948:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	50                   	push   %eax
  801955:	6a 1f                	push   $0x1f
  801957:	e8 3f fc ff ff       	call   80159b <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <rsttst>:
void rsttst()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 21                	push   $0x21
  801971:	e8 25 fc ff ff       	call   80159b <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
	return ;
  801979:	90                   	nop
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 45 14             	mov    0x14(%ebp),%eax
  801985:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801988:	8b 55 18             	mov    0x18(%ebp),%edx
  80198b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	6a 20                	push   $0x20
  80199c:	e8 fa fb ff ff       	call   80159b <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a4:	90                   	nop
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <chktst>:
void chktst(uint32 n)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	6a 22                	push   $0x22
  8019b7:	e8 df fb ff ff       	call   80159b <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bf:	90                   	nop
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <inctst>:

void inctst()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 23                	push   $0x23
  8019d1:	e8 c5 fb ff ff       	call   80159b <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d9:	90                   	nop
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <gettst>:
uint32 gettst()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 24                	push   $0x24
  8019eb:	e8 ab fb ff ff       	call   80159b <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 25                	push   $0x25
  801a07:	e8 8f fb ff ff       	call   80159b <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
  801a0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a16:	75 07                	jne    801a1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a18:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1d:	eb 05                	jmp    801a24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 25                	push   $0x25
  801a38:	e8 5e fb ff ff       	call   80159b <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
  801a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a47:	75 07                	jne    801a50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	eb 05                	jmp    801a55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 25                	push   $0x25
  801a69:	e8 2d fb ff ff       	call   80159b <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
  801a71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a78:	75 07                	jne    801a81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	eb 05                	jmp    801a86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 25                	push   $0x25
  801a9a:	e8 fc fa ff ff       	call   80159b <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
  801aa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa9:	75 07                	jne    801ab2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aab:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab0:	eb 05                	jmp    801ab7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	ff 75 08             	pushl  0x8(%ebp)
  801ac7:	6a 26                	push   $0x26
  801ac9:	e8 cd fa ff ff       	call   80159b <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad1:	90                   	nop
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	53                   	push   %ebx
  801ae7:	51                   	push   %ecx
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 27                	push   $0x27
  801aec:	e8 aa fa ff ff       	call   80159b <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 28                	push   $0x28
  801b0c:	e8 8a fa ff ff       	call   80159b <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	51                   	push   %ecx
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 29                	push   $0x29
  801b2c:	e8 6a fa ff ff       	call   80159b <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 12                	push   $0x12
  801b48:	e8 4e fa ff ff       	call   80159b <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 2a                	push   $0x2a
  801b66:	e8 30 fa ff ff       	call   80159b <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
	return;
  801b6e:	90                   	nop
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	50                   	push   %eax
  801b80:	6a 2b                	push   $0x2b
  801b82:	e8 14 fa ff ff       	call   80159b <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 2c                	push   $0x2c
  801b9d:	e8 f9 f9 ff ff       	call   80159b <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	6a 2d                	push   $0x2d
  801bb9:	e8 dd f9 ff ff       	call   80159b <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	83 e8 04             	sub    $0x4,%eax
  801bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd6:	8b 00                	mov    (%eax),%eax
  801bd8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	83 e8 04             	sub    $0x4,%eax
  801be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bef:	8b 00                	mov    (%eax),%eax
  801bf1:	83 e0 01             	and    $0x1,%eax
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	0f 94 c0             	sete   %al
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0b:	83 f8 02             	cmp    $0x2,%eax
  801c0e:	74 2b                	je     801c3b <alloc_block+0x40>
  801c10:	83 f8 02             	cmp    $0x2,%eax
  801c13:	7f 07                	jg     801c1c <alloc_block+0x21>
  801c15:	83 f8 01             	cmp    $0x1,%eax
  801c18:	74 0e                	je     801c28 <alloc_block+0x2d>
  801c1a:	eb 58                	jmp    801c74 <alloc_block+0x79>
  801c1c:	83 f8 03             	cmp    $0x3,%eax
  801c1f:	74 2d                	je     801c4e <alloc_block+0x53>
  801c21:	83 f8 04             	cmp    $0x4,%eax
  801c24:	74 3b                	je     801c61 <alloc_block+0x66>
  801c26:	eb 4c                	jmp    801c74 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 11 03 00 00       	call   801f44 <alloc_block_FF>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c39:	eb 4a                	jmp    801c85 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	e8 fa 19 00 00       	call   803640 <alloc_block_NF>
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c4c:	eb 37                	jmp    801c85 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	e8 a7 07 00 00       	call   802400 <alloc_block_BF>
  801c59:	83 c4 10             	add    $0x10,%esp
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c5f:	eb 24                	jmp    801c85 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801c61:	83 ec 0c             	sub    $0xc,%esp
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	e8 b7 19 00 00       	call   803623 <alloc_block_WF>
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c72:	eb 11                	jmp    801c85 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c74:	83 ec 0c             	sub    $0xc,%esp
  801c77:	68 74 41 80 00       	push   $0x804174
  801c7c:	e8 10 e7 ff ff       	call   800391 <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp
		break;
  801c84:	90                   	nop
	}
	return va;
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801c91:	83 ec 0c             	sub    $0xc,%esp
  801c94:	68 94 41 80 00       	push   $0x804194
  801c99:	e8 f3 e6 ff ff       	call   800391 <cprintf>
  801c9e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	68 bf 41 80 00       	push   $0x8041bf
  801ca9:	e8 e3 e6 ff ff       	call   800391 <cprintf>
  801cae:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cb7:	eb 37                	jmp    801cf0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbf:	e8 19 ff ff ff       	call   801bdd <is_free_block>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	0f be d8             	movsbl %al,%ebx
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd0:	e8 ef fe ff ff       	call   801bc4 <get_block_size>
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	53                   	push   %ebx
  801cdc:	50                   	push   %eax
  801cdd:	68 d7 41 80 00       	push   $0x8041d7
  801ce2:	e8 aa e6 ff ff       	call   800391 <cprintf>
  801ce7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf4:	74 07                	je     801cfd <print_blocks_list+0x73>
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	eb 05                	jmp    801d02 <print_blocks_list+0x78>
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	89 45 10             	mov    %eax,0x10(%ebp)
  801d05:	8b 45 10             	mov    0x10(%ebp),%eax
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	75 ad                	jne    801cb9 <print_blocks_list+0x2f>
  801d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d10:	75 a7                	jne    801cb9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	68 94 41 80 00       	push   $0x804194
  801d1a:	e8 72 e6 ff ff       	call   800391 <cprintf>
  801d1f:	83 c4 10             	add    $0x10,%esp

}
  801d22:	90                   	nop
  801d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	83 e0 01             	and    $0x1,%eax
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 03                	je     801d3b <initialize_dynamic_allocator+0x13>
  801d38:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3f:	0f 84 c7 01 00 00    	je     801f0c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d45:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801d4c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801d5c:	0f 87 ad 01 00 00    	ja     801f0f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	85 c0                	test   %eax,%eax
  801d67:	0f 89 a5 01 00 00    	jns    801f12 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 d0                	add    %edx,%eax
  801d75:	83 e8 04             	sub    $0x4,%eax
  801d78:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801d7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801d84:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8c:	e9 87 00 00 00       	jmp    801e18 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d95:	75 14                	jne    801dab <initialize_dynamic_allocator+0x83>
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	68 ef 41 80 00       	push   $0x8041ef
  801d9f:	6a 79                	push   $0x79
  801da1:	68 0d 42 80 00       	push   $0x80420d
  801da6:	e8 d9 19 00 00       	call   803784 <_panic>
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	74 10                	je     801dc4 <initialize_dynamic_allocator+0x9c>
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	8b 00                	mov    (%eax),%eax
  801db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbc:	8b 52 04             	mov    0x4(%edx),%edx
  801dbf:	89 50 04             	mov    %edx,0x4(%eax)
  801dc2:	eb 0b                	jmp    801dcf <initialize_dynamic_allocator+0xa7>
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	8b 40 04             	mov    0x4(%eax),%eax
  801dca:	a3 30 50 80 00       	mov    %eax,0x805030
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 40 04             	mov    0x4(%eax),%eax
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 0f                	je     801de8 <initialize_dynamic_allocator+0xc0>
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 40 04             	mov    0x4(%eax),%eax
  801ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de2:	8b 12                	mov    (%edx),%edx
  801de4:	89 10                	mov    %edx,(%eax)
  801de6:	eb 0a                	jmp    801df2 <initialize_dynamic_allocator+0xca>
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	8b 00                	mov    (%eax),%eax
  801ded:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e05:	a1 38 50 80 00       	mov    0x805038,%eax
  801e0a:	48                   	dec    %eax
  801e0b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e10:	a1 34 50 80 00       	mov    0x805034,%eax
  801e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1c:	74 07                	je     801e25 <initialize_dynamic_allocator+0xfd>
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	eb 05                	jmp    801e2a <initialize_dynamic_allocator+0x102>
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2a:	a3 34 50 80 00       	mov    %eax,0x805034
  801e2f:	a1 34 50 80 00       	mov    0x805034,%eax
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 85 55 ff ff ff    	jne    801d91 <initialize_dynamic_allocator+0x69>
  801e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e40:	0f 85 4b ff ff ff    	jne    801d91 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801e55:	a1 44 50 80 00       	mov    0x805044,%eax
  801e5a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801e5f:	a1 40 50 80 00       	mov    0x805040,%eax
  801e64:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	83 c0 08             	add    $0x8,%eax
  801e70:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	83 c0 04             	add    $0x4,%eax
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	83 ea 08             	sub    $0x8,%edx
  801e7f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	01 d0                	add    %edx,%eax
  801e89:	83 e8 08             	sub    $0x8,%eax
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	83 ea 08             	sub    $0x8,%edx
  801e92:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801ea7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eab:	75 17                	jne    801ec4 <initialize_dynamic_allocator+0x19c>
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	68 28 42 80 00       	push   $0x804228
  801eb5:	68 90 00 00 00       	push   $0x90
  801eba:	68 0d 42 80 00       	push   $0x80420d
  801ebf:	e8 c0 18 00 00       	call   803784 <_panic>
  801ec4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecd:	89 10                	mov    %edx,(%eax)
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	74 0d                	je     801ee5 <initialize_dynamic_allocator+0x1bd>
  801ed8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801edd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ee0:	89 50 04             	mov    %edx,0x4(%eax)
  801ee3:	eb 08                	jmp    801eed <initialize_dynamic_allocator+0x1c5>
  801ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee8:	a3 30 50 80 00       	mov    %eax,0x805030
  801eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eff:	a1 38 50 80 00       	mov    0x805038,%eax
  801f04:	40                   	inc    %eax
  801f05:	a3 38 50 80 00       	mov    %eax,0x805038
  801f0a:	eb 07                	jmp    801f13 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f0c:	90                   	nop
  801f0d:	eb 04                	jmp    801f13 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f0f:	90                   	nop
  801f10:	eb 01                	jmp    801f13 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f12:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f18:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	83 e8 04             	sub    $0x4,%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	83 e0 fe             	and    $0xfffffffe,%eax
  801f34:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	01 c2                	add    %eax,%edx
  801f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3f:	89 02                	mov    %eax,(%edx)
}
  801f41:	90                   	nop
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	83 e0 01             	and    $0x1,%eax
  801f50:	85 c0                	test   %eax,%eax
  801f52:	74 03                	je     801f57 <alloc_block_FF+0x13>
  801f54:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801f57:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801f5b:	77 07                	ja     801f64 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801f5d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801f64:	a1 24 50 80 00       	mov    0x805024,%eax
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	75 73                	jne    801fe0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	83 c0 10             	add    $0x10,%eax
  801f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801f76:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	48                   	dec    %eax
  801f86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	f7 75 ec             	divl   -0x14(%ebp)
  801f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f97:	29 d0                	sub    %edx,%eax
  801f99:	c1 e8 0c             	shr    $0xc,%eax
  801f9c:	83 ec 0c             	sub    $0xc,%esp
  801f9f:	50                   	push   %eax
  801fa0:	e8 86 f1 ff ff       	call   80112b <sbrk>
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	6a 00                	push   $0x0
  801fb0:	e8 76 f1 ff ff       	call   80112b <sbrk>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  801fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fbe:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	50                   	push   %eax
  801fc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc8:	e8 5b fd ff ff       	call   801d28 <initialize_dynamic_allocator>
  801fcd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	68 4b 42 80 00       	push   $0x80424b
  801fd8:	e8 b4 e3 ff ff       	call   800391 <cprintf>
  801fdd:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  801fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe4:	75 0a                	jne    801ff0 <alloc_block_FF+0xac>
	        return NULL;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	e9 0e 04 00 00       	jmp    8023fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  801ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  801ff7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fff:	e9 f3 02 00 00       	jmp    8022f7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 bc             	pushl  -0x44(%ebp)
  802010:	e8 af fb ff ff       	call   801bc4 <get_block_size>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	83 c0 08             	add    $0x8,%eax
  802021:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802024:	0f 87 c5 02 00 00    	ja     8022ef <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	83 c0 18             	add    $0x18,%eax
  802030:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802033:	0f 87 19 02 00 00    	ja     802252 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802039:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80203c:	2b 45 08             	sub    0x8(%ebp),%eax
  80203f:	83 e8 08             	sub    $0x8,%eax
  802042:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8d 50 08             	lea    0x8(%eax),%edx
  80204b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80204e:	01 d0                	add    %edx,%eax
  802050:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	83 c0 08             	add    $0x8,%eax
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	6a 01                	push   $0x1
  80205e:	50                   	push   %eax
  80205f:	ff 75 bc             	pushl  -0x44(%ebp)
  802062:	e8 ae fe ff ff       	call   801f15 <set_block_data>
  802067:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 04             	mov    0x4(%eax),%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	75 68                	jne    8020dc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802074:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802078:	75 17                	jne    802091 <alloc_block_FF+0x14d>
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	68 28 42 80 00       	push   $0x804228
  802082:	68 d7 00 00 00       	push   $0xd7
  802087:	68 0d 42 80 00       	push   $0x80420d
  80208c:	e8 f3 16 00 00       	call   803784 <_panic>
  802091:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802097:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80209a:	89 10                	mov    %edx,(%eax)
  80209c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80209f:	8b 00                	mov    (%eax),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	74 0d                	je     8020b2 <alloc_block_FF+0x16e>
  8020a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020ad:	89 50 04             	mov    %edx,0x4(%eax)
  8020b0:	eb 08                	jmp    8020ba <alloc_block_FF+0x176>
  8020b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8020ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8020d1:	40                   	inc    %eax
  8020d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8020d7:	e9 dc 00 00 00       	jmp    8021b8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	75 65                	jne    80214a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020e5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020e9:	75 17                	jne    802102 <alloc_block_FF+0x1be>
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	68 5c 42 80 00       	push   $0x80425c
  8020f3:	68 db 00 00 00       	push   $0xdb
  8020f8:	68 0d 42 80 00       	push   $0x80420d
  8020fd:	e8 82 16 00 00       	call   803784 <_panic>
  802102:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802108:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80210b:	89 50 04             	mov    %edx,0x4(%eax)
  80210e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802111:	8b 40 04             	mov    0x4(%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 0c                	je     802124 <alloc_block_FF+0x1e0>
  802118:	a1 30 50 80 00       	mov    0x805030,%eax
  80211d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802120:	89 10                	mov    %edx,(%eax)
  802122:	eb 08                	jmp    80212c <alloc_block_FF+0x1e8>
  802124:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802127:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80212c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212f:	a3 30 50 80 00       	mov    %eax,0x805030
  802134:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80213d:	a1 38 50 80 00       	mov    0x805038,%eax
  802142:	40                   	inc    %eax
  802143:	a3 38 50 80 00       	mov    %eax,0x805038
  802148:	eb 6e                	jmp    8021b8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80214a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214e:	74 06                	je     802156 <alloc_block_FF+0x212>
  802150:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802154:	75 17                	jne    80216d <alloc_block_FF+0x229>
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	68 80 42 80 00       	push   $0x804280
  80215e:	68 df 00 00 00       	push   $0xdf
  802163:	68 0d 42 80 00       	push   $0x80420d
  802168:	e8 17 16 00 00       	call   803784 <_panic>
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 10                	mov    (%eax),%edx
  802172:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802175:	89 10                	mov    %edx,(%eax)
  802177:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217a:	8b 00                	mov    (%eax),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 0b                	je     80218b <alloc_block_FF+0x247>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802191:	89 10                	mov    %edx,(%eax)
  802193:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802199:	89 50 04             	mov    %edx,0x4(%eax)
  80219c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	75 08                	jne    8021ad <alloc_block_FF+0x269>
  8021a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8021ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b2:	40                   	inc    %eax
  8021b3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8021b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bc:	75 17                	jne    8021d5 <alloc_block_FF+0x291>
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 ef 41 80 00       	push   $0x8041ef
  8021c6:	68 e1 00 00 00       	push   $0xe1
  8021cb:	68 0d 42 80 00       	push   $0x80420d
  8021d0:	e8 af 15 00 00       	call   803784 <_panic>
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	8b 00                	mov    (%eax),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 10                	je     8021ee <alloc_block_FF+0x2aa>
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e6:	8b 52 04             	mov    0x4(%edx),%edx
  8021e9:	89 50 04             	mov    %edx,0x4(%eax)
  8021ec:	eb 0b                	jmp    8021f9 <alloc_block_FF+0x2b5>
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	8b 40 04             	mov    0x4(%eax),%eax
  8021f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 0f                	je     802212 <alloc_block_FF+0x2ce>
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	8b 40 04             	mov    0x4(%eax),%eax
  802209:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220c:	8b 12                	mov    (%edx),%edx
  80220e:	89 10                	mov    %edx,(%eax)
  802210:	eb 0a                	jmp    80221c <alloc_block_FF+0x2d8>
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222f:	a1 38 50 80 00       	mov    0x805038,%eax
  802234:	48                   	dec    %eax
  802235:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	6a 00                	push   $0x0
  80223f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802242:	ff 75 b0             	pushl  -0x50(%ebp)
  802245:	e8 cb fc ff ff       	call   801f15 <set_block_data>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	e9 95 00 00 00       	jmp    8022e7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802252:	83 ec 04             	sub    $0x4,%esp
  802255:	6a 01                	push   $0x1
  802257:	ff 75 b8             	pushl  -0x48(%ebp)
  80225a:	ff 75 bc             	pushl  -0x44(%ebp)
  80225d:	e8 b3 fc ff ff       	call   801f15 <set_block_data>
  802262:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802269:	75 17                	jne    802282 <alloc_block_FF+0x33e>
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	68 ef 41 80 00       	push   $0x8041ef
  802273:	68 e8 00 00 00       	push   $0xe8
  802278:	68 0d 42 80 00       	push   $0x80420d
  80227d:	e8 02 15 00 00       	call   803784 <_panic>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	85 c0                	test   %eax,%eax
  802289:	74 10                	je     80229b <alloc_block_FF+0x357>
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802293:	8b 52 04             	mov    0x4(%edx),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
  802299:	eb 0b                	jmp    8022a6 <alloc_block_FF+0x362>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 04             	mov    0x4(%eax),%eax
  8022a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	74 0f                	je     8022bf <alloc_block_FF+0x37b>
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 04             	mov    0x4(%eax),%eax
  8022b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b9:	8b 12                	mov    (%edx),%edx
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	eb 0a                	jmp    8022c9 <alloc_block_FF+0x385>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e1:	48                   	dec    %eax
  8022e2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8022e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022ea:	e9 0f 01 00 00       	jmp    8023fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fb:	74 07                	je     802304 <alloc_block_FF+0x3c0>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	eb 05                	jmp    802309 <alloc_block_FF+0x3c5>
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
  802309:	a3 34 50 80 00       	mov    %eax,0x805034
  80230e:	a1 34 50 80 00       	mov    0x805034,%eax
  802313:	85 c0                	test   %eax,%eax
  802315:	0f 85 e9 fc ff ff    	jne    802004 <alloc_block_FF+0xc0>
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	0f 85 df fc ff ff    	jne    802004 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	83 c0 08             	add    $0x8,%eax
  80232b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80232e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802335:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802338:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80233b:	01 d0                	add    %edx,%eax
  80233d:	48                   	dec    %eax
  80233e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802341:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802344:	ba 00 00 00 00       	mov    $0x0,%edx
  802349:	f7 75 d8             	divl   -0x28(%ebp)
  80234c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234f:	29 d0                	sub    %edx,%eax
  802351:	c1 e8 0c             	shr    $0xc,%eax
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	50                   	push   %eax
  802358:	e8 ce ed ff ff       	call   80112b <sbrk>
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802363:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802367:	75 0a                	jne    802373 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
  80236e:	e9 8b 00 00 00       	jmp    8023fe <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802373:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80237a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80237d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802380:	01 d0                	add    %edx,%eax
  802382:	48                   	dec    %eax
  802383:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802386:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802389:	ba 00 00 00 00       	mov    $0x0,%edx
  80238e:	f7 75 cc             	divl   -0x34(%ebp)
  802391:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802394:	29 d0                	sub    %edx,%eax
  802396:	8d 50 fc             	lea    -0x4(%eax),%edx
  802399:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80239c:	01 d0                	add    %edx,%eax
  80239e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8023ae:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8023b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023bb:	01 d0                	add    %edx,%eax
  8023bd:	48                   	dec    %eax
  8023be:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8023c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c9:	f7 75 c4             	divl   -0x3c(%ebp)
  8023cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023cf:	29 d0                	sub    %edx,%eax
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	6a 01                	push   $0x1
  8023d6:	50                   	push   %eax
  8023d7:	ff 75 d0             	pushl  -0x30(%ebp)
  8023da:	e8 36 fb ff ff       	call   801f15 <set_block_data>
  8023df:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8023e2:	83 ec 0c             	sub    $0xc,%esp
  8023e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8023e8:	e8 1b 0a 00 00       	call   802e08 <free_block>
  8023ed:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	ff 75 08             	pushl  0x8(%ebp)
  8023f6:	e8 49 fb ff ff       	call   801f44 <alloc_block_FF>
  8023fb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	83 e0 01             	and    $0x1,%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 03                	je     802413 <alloc_block_BF+0x13>
  802410:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802413:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802417:	77 07                	ja     802420 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802419:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802420:	a1 24 50 80 00       	mov    0x805024,%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	75 73                	jne    80249c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	83 c0 10             	add    $0x10,%eax
  80242f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802432:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802439:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80243c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243f:	01 d0                	add    %edx,%eax
  802441:	48                   	dec    %eax
  802442:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802445:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802448:	ba 00 00 00 00       	mov    $0x0,%edx
  80244d:	f7 75 e0             	divl   -0x20(%ebp)
  802450:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802453:	29 d0                	sub    %edx,%eax
  802455:	c1 e8 0c             	shr    $0xc,%eax
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	50                   	push   %eax
  80245c:	e8 ca ec ff ff       	call   80112b <sbrk>
  802461:	83 c4 10             	add    $0x10,%esp
  802464:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	6a 00                	push   $0x0
  80246c:	e8 ba ec ff ff       	call   80112b <sbrk>
  802471:	83 c4 10             	add    $0x10,%esp
  802474:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802477:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80247a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80247d:	83 ec 08             	sub    $0x8,%esp
  802480:	50                   	push   %eax
  802481:	ff 75 d8             	pushl  -0x28(%ebp)
  802484:	e8 9f f8 ff ff       	call   801d28 <initialize_dynamic_allocator>
  802489:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80248c:	83 ec 0c             	sub    $0xc,%esp
  80248f:	68 4b 42 80 00       	push   $0x80424b
  802494:	e8 f8 de ff ff       	call   800391 <cprintf>
  802499:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80249c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8024aa:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8024b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8024b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c0:	e9 1d 01 00 00       	jmp    8025e2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8024cb:	83 ec 0c             	sub    $0xc,%esp
  8024ce:	ff 75 a8             	pushl  -0x58(%ebp)
  8024d1:	e8 ee f6 ff ff       	call   801bc4 <get_block_size>
  8024d6:	83 c4 10             	add    $0x10,%esp
  8024d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	83 c0 08             	add    $0x8,%eax
  8024e2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024e5:	0f 87 ef 00 00 00    	ja     8025da <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	83 c0 18             	add    $0x18,%eax
  8024f1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024f4:	77 1d                	ja     802513 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024fc:	0f 86 d8 00 00 00    	jbe    8025da <alloc_block_BF+0x1da>
				{
					best_va = va;
  802502:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802505:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802508:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80250b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80250e:	e9 c7 00 00 00       	jmp    8025da <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	83 c0 08             	add    $0x8,%eax
  802519:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80251c:	0f 85 9d 00 00 00    	jne    8025bf <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802522:	83 ec 04             	sub    $0x4,%esp
  802525:	6a 01                	push   $0x1
  802527:	ff 75 a4             	pushl  -0x5c(%ebp)
  80252a:	ff 75 a8             	pushl  -0x58(%ebp)
  80252d:	e8 e3 f9 ff ff       	call   801f15 <set_block_data>
  802532:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	75 17                	jne    802552 <alloc_block_BF+0x152>
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	68 ef 41 80 00       	push   $0x8041ef
  802543:	68 2c 01 00 00       	push   $0x12c
  802548:	68 0d 42 80 00       	push   $0x80420d
  80254d:	e8 32 12 00 00       	call   803784 <_panic>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 10                	je     80256b <alloc_block_BF+0x16b>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	8b 52 04             	mov    0x4(%edx),%edx
  802566:	89 50 04             	mov    %edx,0x4(%eax)
  802569:	eb 0b                	jmp    802576 <alloc_block_BF+0x176>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	a3 30 50 80 00       	mov    %eax,0x805030
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 0f                	je     80258f <alloc_block_BF+0x18f>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802589:	8b 12                	mov    (%edx),%edx
  80258b:	89 10                	mov    %edx,(%eax)
  80258d:	eb 0a                	jmp    802599 <alloc_block_BF+0x199>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b1:	48                   	dec    %eax
  8025b2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8025b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025ba:	e9 24 04 00 00       	jmp    8029e3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8025bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025c5:	76 13                	jbe    8025da <alloc_block_BF+0x1da>
					{
						internal = 1;
  8025c7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8025ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8025d4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8025da:	a1 34 50 80 00       	mov    0x805034,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e6:	74 07                	je     8025ef <alloc_block_BF+0x1ef>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	eb 05                	jmp    8025f4 <alloc_block_BF+0x1f4>
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8025f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	0f 85 bf fe ff ff    	jne    8024c5 <alloc_block_BF+0xc5>
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	0f 85 b5 fe ff ff    	jne    8024c5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802610:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802614:	0f 84 26 02 00 00    	je     802840 <alloc_block_BF+0x440>
  80261a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80261e:	0f 85 1c 02 00 00    	jne    802840 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802627:	2b 45 08             	sub    0x8(%ebp),%eax
  80262a:	83 e8 08             	sub    $0x8,%eax
  80262d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	8d 50 08             	lea    0x8(%eax),%edx
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	01 d0                	add    %edx,%eax
  80263b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	83 c0 08             	add    $0x8,%eax
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	6a 01                	push   $0x1
  802649:	50                   	push   %eax
  80264a:	ff 75 f0             	pushl  -0x10(%ebp)
  80264d:	e8 c3 f8 ff ff       	call   801f15 <set_block_data>
  802652:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	75 68                	jne    8026c7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80265f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802663:	75 17                	jne    80267c <alloc_block_BF+0x27c>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 28 42 80 00       	push   $0x804228
  80266d:	68 45 01 00 00       	push   $0x145
  802672:	68 0d 42 80 00       	push   $0x80420d
  802677:	e8 08 11 00 00       	call   803784 <_panic>
  80267c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802682:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802685:	89 10                	mov    %edx,(%eax)
  802687:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 0d                	je     80269d <alloc_block_BF+0x29d>
  802690:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802695:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 08                	jmp    8026a5 <alloc_block_BF+0x2a5>
  80269d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8026a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8026bc:	40                   	inc    %eax
  8026bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8026c2:	e9 dc 00 00 00       	jmp    8027a3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	75 65                	jne    802735 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026d4:	75 17                	jne    8026ed <alloc_block_BF+0x2ed>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 5c 42 80 00       	push   $0x80425c
  8026de:	68 4a 01 00 00       	push   $0x14a
  8026e3:	68 0d 42 80 00       	push   $0x80420d
  8026e8:	e8 97 10 00 00       	call   803784 <_panic>
  8026ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f6:	89 50 04             	mov    %edx,0x4(%eax)
  8026f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0c                	je     80270f <alloc_block_BF+0x30f>
  802703:	a1 30 50 80 00       	mov    0x805030,%eax
  802708:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80270b:	89 10                	mov    %edx,(%eax)
  80270d:	eb 08                	jmp    802717 <alloc_block_BF+0x317>
  80270f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802712:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802717:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271a:	a3 30 50 80 00       	mov    %eax,0x805030
  80271f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802728:	a1 38 50 80 00       	mov    0x805038,%eax
  80272d:	40                   	inc    %eax
  80272e:	a3 38 50 80 00       	mov    %eax,0x805038
  802733:	eb 6e                	jmp    8027a3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802739:	74 06                	je     802741 <alloc_block_BF+0x341>
  80273b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80273f:	75 17                	jne    802758 <alloc_block_BF+0x358>
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 80 42 80 00       	push   $0x804280
  802749:	68 4f 01 00 00       	push   $0x14f
  80274e:	68 0d 42 80 00       	push   $0x80420d
  802753:	e8 2c 10 00 00       	call   803784 <_panic>
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	8b 10                	mov    (%eax),%edx
  80275d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802760:	89 10                	mov    %edx,(%eax)
  802762:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 0b                	je     802776 <alloc_block_BF+0x376>
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80277c:	89 10                	mov    %edx,(%eax)
  80277e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802781:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802784:	89 50 04             	mov    %edx,0x4(%eax)
  802787:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	75 08                	jne    802798 <alloc_block_BF+0x398>
  802790:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802793:	a3 30 50 80 00       	mov    %eax,0x805030
  802798:	a1 38 50 80 00       	mov    0x805038,%eax
  80279d:	40                   	inc    %eax
  80279e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a7:	75 17                	jne    8027c0 <alloc_block_BF+0x3c0>
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 ef 41 80 00       	push   $0x8041ef
  8027b1:	68 51 01 00 00       	push   $0x151
  8027b6:	68 0d 42 80 00       	push   $0x80420d
  8027bb:	e8 c4 0f 00 00       	call   803784 <_panic>
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 10                	je     8027d9 <alloc_block_BF+0x3d9>
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d1:	8b 52 04             	mov    0x4(%edx),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	eb 0b                	jmp    8027e4 <alloc_block_BF+0x3e4>
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	8b 40 04             	mov    0x4(%eax),%eax
  8027df:	a3 30 50 80 00       	mov    %eax,0x805030
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	74 0f                	je     8027fd <alloc_block_BF+0x3fd>
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	8b 40 04             	mov    0x4(%eax),%eax
  8027f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f7:	8b 12                	mov    (%edx),%edx
  8027f9:	89 10                	mov    %edx,(%eax)
  8027fb:	eb 0a                	jmp    802807 <alloc_block_BF+0x407>
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281a:	a1 38 50 80 00       	mov    0x805038,%eax
  80281f:	48                   	dec    %eax
  802820:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	6a 00                	push   $0x0
  80282a:	ff 75 d0             	pushl  -0x30(%ebp)
  80282d:	ff 75 cc             	pushl  -0x34(%ebp)
  802830:	e8 e0 f6 ff ff       	call   801f15 <set_block_data>
  802835:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283b:	e9 a3 01 00 00       	jmp    8029e3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802840:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802844:	0f 85 9d 00 00 00    	jne    8028e7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	6a 01                	push   $0x1
  80284f:	ff 75 ec             	pushl  -0x14(%ebp)
  802852:	ff 75 f0             	pushl  -0x10(%ebp)
  802855:	e8 bb f6 ff ff       	call   801f15 <set_block_data>
  80285a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80285d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802861:	75 17                	jne    80287a <alloc_block_BF+0x47a>
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	68 ef 41 80 00       	push   $0x8041ef
  80286b:	68 58 01 00 00       	push   $0x158
  802870:	68 0d 42 80 00       	push   $0x80420d
  802875:	e8 0a 0f 00 00       	call   803784 <_panic>
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	74 10                	je     802893 <alloc_block_BF+0x493>
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288b:	8b 52 04             	mov    0x4(%edx),%edx
  80288e:	89 50 04             	mov    %edx,0x4(%eax)
  802891:	eb 0b                	jmp    80289e <alloc_block_BF+0x49e>
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	8b 40 04             	mov    0x4(%eax),%eax
  802899:	a3 30 50 80 00       	mov    %eax,0x805030
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 0f                	je     8028b7 <alloc_block_BF+0x4b7>
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 40 04             	mov    0x4(%eax),%eax
  8028ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b1:	8b 12                	mov    (%edx),%edx
  8028b3:	89 10                	mov    %edx,(%eax)
  8028b5:	eb 0a                	jmp    8028c1 <alloc_block_BF+0x4c1>
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d9:	48                   	dec    %eax
  8028da:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	e9 fc 00 00 00       	jmp    8029e3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	83 c0 08             	add    $0x8,%eax
  8028ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8028f0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	48                   	dec    %eax
  802900:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802903:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802906:	ba 00 00 00 00       	mov    $0x0,%edx
  80290b:	f7 75 c4             	divl   -0x3c(%ebp)
  80290e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802911:	29 d0                	sub    %edx,%eax
  802913:	c1 e8 0c             	shr    $0xc,%eax
  802916:	83 ec 0c             	sub    $0xc,%esp
  802919:	50                   	push   %eax
  80291a:	e8 0c e8 ff ff       	call   80112b <sbrk>
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802925:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802929:	75 0a                	jne    802935 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
  802930:	e9 ae 00 00 00       	jmp    8029e3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802935:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80293c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80293f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802942:	01 d0                	add    %edx,%eax
  802944:	48                   	dec    %eax
  802945:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802948:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80294b:	ba 00 00 00 00       	mov    $0x0,%edx
  802950:	f7 75 b8             	divl   -0x48(%ebp)
  802953:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802956:	29 d0                	sub    %edx,%eax
  802958:	8d 50 fc             	lea    -0x4(%eax),%edx
  80295b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80295e:	01 d0                	add    %edx,%eax
  802960:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802965:	a1 40 50 80 00       	mov    0x805040,%eax
  80296a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802970:	83 ec 0c             	sub    $0xc,%esp
  802973:	68 b4 42 80 00       	push   $0x8042b4
  802978:	e8 14 da ff ff       	call   800391 <cprintf>
  80297d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802980:	83 ec 08             	sub    $0x8,%esp
  802983:	ff 75 bc             	pushl  -0x44(%ebp)
  802986:	68 b9 42 80 00       	push   $0x8042b9
  80298b:	e8 01 da ff ff       	call   800391 <cprintf>
  802990:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802993:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80299a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80299d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a0:	01 d0                	add    %edx,%eax
  8029a2:	48                   	dec    %eax
  8029a3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029a6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ae:	f7 75 b0             	divl   -0x50(%ebp)
  8029b1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029b4:	29 d0                	sub    %edx,%eax
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	6a 01                	push   $0x1
  8029bb:	50                   	push   %eax
  8029bc:	ff 75 bc             	pushl  -0x44(%ebp)
  8029bf:	e8 51 f5 ff ff       	call   801f15 <set_block_data>
  8029c4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	ff 75 bc             	pushl  -0x44(%ebp)
  8029cd:	e8 36 04 00 00       	call   802e08 <free_block>
  8029d2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8029d5:	83 ec 0c             	sub    $0xc,%esp
  8029d8:	ff 75 08             	pushl  0x8(%ebp)
  8029db:	e8 20 fa ff ff       	call   802400 <alloc_block_BF>
  8029e0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
  8029e8:	53                   	push   %ebx
  8029e9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8029ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fe:	74 1e                	je     802a1e <merging+0x39>
  802a00:	ff 75 08             	pushl  0x8(%ebp)
  802a03:	e8 bc f1 ff ff       	call   801bc4 <get_block_size>
  802a08:	83 c4 04             	add    $0x4,%esp
  802a0b:	89 c2                	mov    %eax,%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a15:	75 07                	jne    802a1e <merging+0x39>
		prev_is_free = 1;
  802a17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a22:	74 1e                	je     802a42 <merging+0x5d>
  802a24:	ff 75 10             	pushl  0x10(%ebp)
  802a27:	e8 98 f1 ff ff       	call   801bc4 <get_block_size>
  802a2c:	83 c4 04             	add    $0x4,%esp
  802a2f:	89 c2                	mov    %eax,%edx
  802a31:	8b 45 10             	mov    0x10(%ebp),%eax
  802a34:	01 d0                	add    %edx,%eax
  802a36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a39:	75 07                	jne    802a42 <merging+0x5d>
		next_is_free = 1;
  802a3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	0f 84 cc 00 00 00    	je     802b18 <merging+0x133>
  802a4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a50:	0f 84 c2 00 00 00    	je     802b18 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802a56:	ff 75 08             	pushl  0x8(%ebp)
  802a59:	e8 66 f1 ff ff       	call   801bc4 <get_block_size>
  802a5e:	83 c4 04             	add    $0x4,%esp
  802a61:	89 c3                	mov    %eax,%ebx
  802a63:	ff 75 10             	pushl  0x10(%ebp)
  802a66:	e8 59 f1 ff ff       	call   801bc4 <get_block_size>
  802a6b:	83 c4 04             	add    $0x4,%esp
  802a6e:	01 c3                	add    %eax,%ebx
  802a70:	ff 75 0c             	pushl  0xc(%ebp)
  802a73:	e8 4c f1 ff ff       	call   801bc4 <get_block_size>
  802a78:	83 c4 04             	add    $0x4,%esp
  802a7b:	01 d8                	add    %ebx,%eax
  802a7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802a80:	6a 00                	push   $0x0
  802a82:	ff 75 ec             	pushl  -0x14(%ebp)
  802a85:	ff 75 08             	pushl  0x8(%ebp)
  802a88:	e8 88 f4 ff ff       	call   801f15 <set_block_data>
  802a8d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802a90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a94:	75 17                	jne    802aad <merging+0xc8>
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	68 ef 41 80 00       	push   $0x8041ef
  802a9e:	68 7d 01 00 00       	push   $0x17d
  802aa3:	68 0d 42 80 00       	push   $0x80420d
  802aa8:	e8 d7 0c 00 00       	call   803784 <_panic>
  802aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	85 c0                	test   %eax,%eax
  802ab4:	74 10                	je     802ac6 <merging+0xe1>
  802ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abe:	8b 52 04             	mov    0x4(%edx),%edx
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	eb 0b                	jmp    802ad1 <merging+0xec>
  802ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad4:	8b 40 04             	mov    0x4(%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 0f                	je     802aea <merging+0x105>
  802adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae4:	8b 12                	mov    (%edx),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	eb 0a                	jmp    802af4 <merging+0x10f>
  802aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b07:	a1 38 50 80 00       	mov    0x805038,%eax
  802b0c:	48                   	dec    %eax
  802b0d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b12:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b13:	e9 ea 02 00 00       	jmp    802e02 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	74 3b                	je     802b59 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b1e:	83 ec 0c             	sub    $0xc,%esp
  802b21:	ff 75 08             	pushl  0x8(%ebp)
  802b24:	e8 9b f0 ff ff       	call   801bc4 <get_block_size>
  802b29:	83 c4 10             	add    $0x10,%esp
  802b2c:	89 c3                	mov    %eax,%ebx
  802b2e:	83 ec 0c             	sub    $0xc,%esp
  802b31:	ff 75 10             	pushl  0x10(%ebp)
  802b34:	e8 8b f0 ff ff       	call   801bc4 <get_block_size>
  802b39:	83 c4 10             	add    $0x10,%esp
  802b3c:	01 d8                	add    %ebx,%eax
  802b3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	6a 00                	push   $0x0
  802b46:	ff 75 e8             	pushl  -0x18(%ebp)
  802b49:	ff 75 08             	pushl  0x8(%ebp)
  802b4c:	e8 c4 f3 ff ff       	call   801f15 <set_block_data>
  802b51:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b54:	e9 a9 02 00 00       	jmp    802e02 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5d:	0f 84 2d 01 00 00    	je     802c90 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802b63:	83 ec 0c             	sub    $0xc,%esp
  802b66:	ff 75 10             	pushl  0x10(%ebp)
  802b69:	e8 56 f0 ff ff       	call   801bc4 <get_block_size>
  802b6e:	83 c4 10             	add    $0x10,%esp
  802b71:	89 c3                	mov    %eax,%ebx
  802b73:	83 ec 0c             	sub    $0xc,%esp
  802b76:	ff 75 0c             	pushl  0xc(%ebp)
  802b79:	e8 46 f0 ff ff       	call   801bc4 <get_block_size>
  802b7e:	83 c4 10             	add    $0x10,%esp
  802b81:	01 d8                	add    %ebx,%eax
  802b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	6a 00                	push   $0x0
  802b8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b8e:	ff 75 10             	pushl  0x10(%ebp)
  802b91:	e8 7f f3 ff ff       	call   801f15 <set_block_data>
  802b96:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802b99:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ba3:	74 06                	je     802bab <merging+0x1c6>
  802ba5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ba9:	75 17                	jne    802bc2 <merging+0x1dd>
  802bab:	83 ec 04             	sub    $0x4,%esp
  802bae:	68 c8 42 80 00       	push   $0x8042c8
  802bb3:	68 8d 01 00 00       	push   $0x18d
  802bb8:	68 0d 42 80 00       	push   $0x80420d
  802bbd:	e8 c2 0b 00 00       	call   803784 <_panic>
  802bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc5:	8b 50 04             	mov    0x4(%eax),%edx
  802bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 0d                	je     802bed <merging+0x208>
  802be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	eb 08                	jmp    802bf5 <merging+0x210>
  802bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	a1 38 50 80 00       	mov    0x805038,%eax
  802c03:	40                   	inc    %eax
  802c04:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c0d:	75 17                	jne    802c26 <merging+0x241>
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 ef 41 80 00       	push   $0x8041ef
  802c17:	68 8e 01 00 00       	push   $0x18e
  802c1c:	68 0d 42 80 00       	push   $0x80420d
  802c21:	e8 5e 0b 00 00       	call   803784 <_panic>
  802c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 10                	je     802c3f <merging+0x25a>
  802c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c37:	8b 52 04             	mov    0x4(%edx),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%eax)
  802c3d:	eb 0b                	jmp    802c4a <merging+0x265>
  802c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	a3 30 50 80 00       	mov    %eax,0x805030
  802c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 0f                	je     802c63 <merging+0x27e>
  802c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5d:	8b 12                	mov    (%edx),%edx
  802c5f:	89 10                	mov    %edx,(%eax)
  802c61:	eb 0a                	jmp    802c6d <merging+0x288>
  802c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c80:	a1 38 50 80 00       	mov    0x805038,%eax
  802c85:	48                   	dec    %eax
  802c86:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c8b:	e9 72 01 00 00       	jmp    802e02 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802c90:	8b 45 10             	mov    0x10(%ebp),%eax
  802c93:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802c96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9a:	74 79                	je     802d15 <merging+0x330>
  802c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ca0:	74 73                	je     802d15 <merging+0x330>
  802ca2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca6:	74 06                	je     802cae <merging+0x2c9>
  802ca8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cac:	75 17                	jne    802cc5 <merging+0x2e0>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 80 42 80 00       	push   $0x804280
  802cb6:	68 94 01 00 00       	push   $0x194
  802cbb:	68 0d 42 80 00       	push   $0x80420d
  802cc0:	e8 bf 0a 00 00       	call   803784 <_panic>
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 10                	mov    (%eax),%edx
  802cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0b                	je     802ce3 <merging+0x2fe>
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ce9:	89 10                	mov    %edx,(%eax)
  802ceb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cee:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	75 08                	jne    802d05 <merging+0x320>
  802cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d00:	a3 30 50 80 00       	mov    %eax,0x805030
  802d05:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0a:	40                   	inc    %eax
  802d0b:	a3 38 50 80 00       	mov    %eax,0x805038
  802d10:	e9 ce 00 00 00       	jmp    802de3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d19:	74 65                	je     802d80 <merging+0x39b>
  802d1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d1f:	75 17                	jne    802d38 <merging+0x353>
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 5c 42 80 00       	push   $0x80425c
  802d29:	68 95 01 00 00       	push   $0x195
  802d2e:	68 0d 42 80 00       	push   $0x80420d
  802d33:	e8 4c 0a 00 00       	call   803784 <_panic>
  802d38:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 0c                	je     802d5a <merging+0x375>
  802d4e:	a1 30 50 80 00       	mov    0x805030,%eax
  802d53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	eb 08                	jmp    802d62 <merging+0x37d>
  802d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d65:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d73:	a1 38 50 80 00       	mov    0x805038,%eax
  802d78:	40                   	inc    %eax
  802d79:	a3 38 50 80 00       	mov    %eax,0x805038
  802d7e:	eb 63                	jmp    802de3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802d80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d84:	75 17                	jne    802d9d <merging+0x3b8>
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	68 28 42 80 00       	push   $0x804228
  802d8e:	68 98 01 00 00       	push   $0x198
  802d93:	68 0d 42 80 00       	push   $0x80420d
  802d98:	e8 e7 09 00 00       	call   803784 <_panic>
  802d9d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802da3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0d                	je     802dbe <merging+0x3d9>
  802db1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802db6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	eb 08                	jmp    802dc6 <merging+0x3e1>
  802dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc1:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddd:	40                   	inc    %eax
  802dde:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802de3:	83 ec 0c             	sub    $0xc,%esp
  802de6:	ff 75 10             	pushl  0x10(%ebp)
  802de9:	e8 d6 ed ff ff       	call   801bc4 <get_block_size>
  802dee:	83 c4 10             	add    $0x10,%esp
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	6a 00                	push   $0x0
  802df6:	50                   	push   %eax
  802df7:	ff 75 10             	pushl  0x10(%ebp)
  802dfa:	e8 16 f1 ff ff       	call   801f15 <set_block_data>
  802dff:	83 c4 10             	add    $0x10,%esp
	}
}
  802e02:	90                   	nop
  802e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e06:	c9                   	leave  
  802e07:	c3                   	ret    

00802e08 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e08:	55                   	push   %ebp
  802e09:	89 e5                	mov    %esp,%ebp
  802e0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e0e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e13:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e16:	a1 30 50 80 00       	mov    0x805030,%eax
  802e1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1e:	73 1b                	jae    802e3b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e20:	a1 30 50 80 00       	mov    0x805030,%eax
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	ff 75 08             	pushl  0x8(%ebp)
  802e2b:	6a 00                	push   $0x0
  802e2d:	50                   	push   %eax
  802e2e:	e8 b2 fb ff ff       	call   8029e5 <merging>
  802e33:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e36:	e9 8b 00 00 00       	jmp    802ec6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e3b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e43:	76 18                	jbe    802e5d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e45:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	ff 75 08             	pushl  0x8(%ebp)
  802e50:	50                   	push   %eax
  802e51:	6a 00                	push   $0x0
  802e53:	e8 8d fb ff ff       	call   8029e5 <merging>
  802e58:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e5b:	eb 69                	jmp    802ec6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e5d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e65:	eb 39                	jmp    802ea0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6d:	73 29                	jae    802e98 <free_block+0x90>
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e77:	76 1f                	jbe    802e98 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	ff 75 08             	pushl  0x8(%ebp)
  802e87:	ff 75 f0             	pushl  -0x10(%ebp)
  802e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  802e8d:	e8 53 fb ff ff       	call   8029e5 <merging>
  802e92:	83 c4 10             	add    $0x10,%esp
			break;
  802e95:	90                   	nop
		}
	}
}
  802e96:	eb 2e                	jmp    802ec6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e98:	a1 34 50 80 00       	mov    0x805034,%eax
  802e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea4:	74 07                	je     802ead <free_block+0xa5>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	eb 05                	jmp    802eb2 <free_block+0xaa>
  802ead:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb2:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb7:	a1 34 50 80 00       	mov    0x805034,%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	75 a7                	jne    802e67 <free_block+0x5f>
  802ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec4:	75 a1                	jne    802e67 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ec6:	90                   	nop
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802ecf:	ff 75 08             	pushl  0x8(%ebp)
  802ed2:	e8 ed ec ff ff       	call   801bc4 <get_block_size>
  802ed7:	83 c4 04             	add    $0x4,%esp
  802eda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802ee4:	eb 17                	jmp    802efd <copy_data+0x34>
  802ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eec:	01 c2                	add    %eax,%edx
  802eee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	01 c8                	add    %ecx,%eax
  802ef6:	8a 00                	mov    (%eax),%al
  802ef8:	88 02                	mov    %al,(%edx)
  802efa:	ff 45 fc             	incl   -0x4(%ebp)
  802efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f03:	72 e1                	jb     802ee6 <copy_data+0x1d>
}
  802f05:	90                   	nop
  802f06:	c9                   	leave  
  802f07:	c3                   	ret    

00802f08 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f08:	55                   	push   %ebp
  802f09:	89 e5                	mov    %esp,%ebp
  802f0b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f12:	75 23                	jne    802f37 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f18:	74 13                	je     802f2d <realloc_block_FF+0x25>
  802f1a:	83 ec 0c             	sub    $0xc,%esp
  802f1d:	ff 75 0c             	pushl  0xc(%ebp)
  802f20:	e8 1f f0 ff ff       	call   801f44 <alloc_block_FF>
  802f25:	83 c4 10             	add    $0x10,%esp
  802f28:	e9 f4 06 00 00       	jmp    803621 <realloc_block_FF+0x719>
		return NULL;
  802f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f32:	e9 ea 06 00 00       	jmp    803621 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3b:	75 18                	jne    802f55 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f3d:	83 ec 0c             	sub    $0xc,%esp
  802f40:	ff 75 08             	pushl  0x8(%ebp)
  802f43:	e8 c0 fe ff ff       	call   802e08 <free_block>
  802f48:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f50:	e9 cc 06 00 00       	jmp    803621 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802f55:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f59:	77 07                	ja     802f62 <realloc_block_FF+0x5a>
  802f5b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f65:	83 e0 01             	and    $0x1,%eax
  802f68:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6e:	83 c0 08             	add    $0x8,%eax
  802f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802f74:	83 ec 0c             	sub    $0xc,%esp
  802f77:	ff 75 08             	pushl  0x8(%ebp)
  802f7a:	e8 45 ec ff ff       	call   801bc4 <get_block_size>
  802f7f:	83 c4 10             	add    $0x10,%esp
  802f82:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	83 e8 08             	sub    $0x8,%eax
  802f8b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	83 e8 04             	sub    $0x4,%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	83 e0 fe             	and    $0xfffffffe,%eax
  802f99:	89 c2                	mov    %eax,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	01 d0                	add    %edx,%eax
  802fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802fa3:	83 ec 0c             	sub    $0xc,%esp
  802fa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa9:	e8 16 ec ff ff       	call   801bc4 <get_block_size>
  802fae:	83 c4 10             	add    $0x10,%esp
  802fb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb7:	83 e8 08             	sub    $0x8,%eax
  802fba:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  802fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fc3:	75 08                	jne    802fcd <realloc_block_FF+0xc5>
	{
		 return va;
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	e9 54 06 00 00       	jmp    803621 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  802fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fd3:	0f 83 e5 03 00 00    	jae    8033be <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fdf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fe8:	e8 f0 eb ff ff       	call   801bdd <is_free_block>
  802fed:	83 c4 10             	add    $0x10,%esp
  802ff0:	84 c0                	test   %al,%al
  802ff2:	0f 84 3b 01 00 00    	je     803133 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  802ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ffb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ffe:	01 d0                	add    %edx,%eax
  803000:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803003:	83 ec 04             	sub    $0x4,%esp
  803006:	6a 01                	push   $0x1
  803008:	ff 75 f0             	pushl  -0x10(%ebp)
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	e8 02 ef ff ff       	call   801f15 <set_block_data>
  803013:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	83 e8 04             	sub    $0x4,%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	83 e0 fe             	and    $0xfffffffe,%eax
  803021:	89 c2                	mov    %eax,%edx
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	01 d0                	add    %edx,%eax
  803028:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	6a 00                	push   $0x0
  803030:	ff 75 cc             	pushl  -0x34(%ebp)
  803033:	ff 75 c8             	pushl  -0x38(%ebp)
  803036:	e8 da ee ff ff       	call   801f15 <set_block_data>
  80303b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80303e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803042:	74 06                	je     80304a <realloc_block_FF+0x142>
  803044:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803048:	75 17                	jne    803061 <realloc_block_FF+0x159>
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 80 42 80 00       	push   $0x804280
  803052:	68 f6 01 00 00       	push   $0x1f6
  803057:	68 0d 42 80 00       	push   $0x80420d
  80305c:	e8 23 07 00 00       	call   803784 <_panic>
  803061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803064:	8b 10                	mov    (%eax),%edx
  803066:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0b                	je     80307f <realloc_block_FF+0x177>
  803074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80307c:	89 50 04             	mov    %edx,0x4(%eax)
  80307f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803082:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80308a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80308d:	89 50 04             	mov    %edx,0x4(%eax)
  803090:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	75 08                	jne    8030a1 <realloc_block_FF+0x199>
  803099:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80309c:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a6:	40                   	inc    %eax
  8030a7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8030ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030b0:	75 17                	jne    8030c9 <realloc_block_FF+0x1c1>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 ef 41 80 00       	push   $0x8041ef
  8030ba:	68 f7 01 00 00       	push   $0x1f7
  8030bf:	68 0d 42 80 00       	push   $0x80420d
  8030c4:	e8 bb 06 00 00       	call   803784 <_panic>
  8030c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	74 10                	je     8030e2 <realloc_block_FF+0x1da>
  8030d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030da:	8b 52 04             	mov    0x4(%edx),%edx
  8030dd:	89 50 04             	mov    %edx,0x4(%eax)
  8030e0:	eb 0b                	jmp    8030ed <realloc_block_FF+0x1e5>
  8030e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e5:	8b 40 04             	mov    0x4(%eax),%eax
  8030e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	74 0f                	je     803106 <realloc_block_FF+0x1fe>
  8030f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fa:	8b 40 04             	mov    0x4(%eax),%eax
  8030fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803100:	8b 12                	mov    (%edx),%edx
  803102:	89 10                	mov    %edx,(%eax)
  803104:	eb 0a                	jmp    803110 <realloc_block_FF+0x208>
  803106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803113:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803123:	a1 38 50 80 00       	mov    0x805038,%eax
  803128:	48                   	dec    %eax
  803129:	a3 38 50 80 00       	mov    %eax,0x805038
  80312e:	e9 83 02 00 00       	jmp    8033b6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803133:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803137:	0f 86 69 02 00 00    	jbe    8033a6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	6a 01                	push   $0x1
  803142:	ff 75 f0             	pushl  -0x10(%ebp)
  803145:	ff 75 08             	pushl  0x8(%ebp)
  803148:	e8 c8 ed ff ff       	call   801f15 <set_block_data>
  80314d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	83 e8 04             	sub    $0x4,%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	83 e0 fe             	and    $0xfffffffe,%eax
  80315b:	89 c2                	mov    %eax,%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	01 d0                	add    %edx,%eax
  803162:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803165:	a1 38 50 80 00       	mov    0x805038,%eax
  80316a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80316d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803171:	75 68                	jne    8031db <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803173:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803177:	75 17                	jne    803190 <realloc_block_FF+0x288>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 28 42 80 00       	push   $0x804228
  803181:	68 06 02 00 00       	push   $0x206
  803186:	68 0d 42 80 00       	push   $0x80420d
  80318b:	e8 f4 05 00 00       	call   803784 <_panic>
  803190:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803196:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803199:	89 10                	mov    %edx,(%eax)
  80319b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	85 c0                	test   %eax,%eax
  8031a2:	74 0d                	je     8031b1 <realloc_block_FF+0x2a9>
  8031a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031ac:	89 50 04             	mov    %edx,0x4(%eax)
  8031af:	eb 08                	jmp    8031b9 <realloc_block_FF+0x2b1>
  8031b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d0:	40                   	inc    %eax
  8031d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8031d6:	e9 b0 01 00 00       	jmp    80338b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8031db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8031e3:	76 68                	jbe    80324d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031e9:	75 17                	jne    803202 <realloc_block_FF+0x2fa>
  8031eb:	83 ec 04             	sub    $0x4,%esp
  8031ee:	68 28 42 80 00       	push   $0x804228
  8031f3:	68 0b 02 00 00       	push   $0x20b
  8031f8:	68 0d 42 80 00       	push   $0x80420d
  8031fd:	e8 82 05 00 00       	call   803784 <_panic>
  803202:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	74 0d                	je     803223 <realloc_block_FF+0x31b>
  803216:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	eb 08                	jmp    80322b <realloc_block_FF+0x323>
  803223:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803226:	a3 30 50 80 00       	mov    %eax,0x805030
  80322b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803233:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323d:	a1 38 50 80 00       	mov    0x805038,%eax
  803242:	40                   	inc    %eax
  803243:	a3 38 50 80 00       	mov    %eax,0x805038
  803248:	e9 3e 01 00 00       	jmp    80338b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80324d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803252:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803255:	73 68                	jae    8032bf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803257:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80325b:	75 17                	jne    803274 <realloc_block_FF+0x36c>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 5c 42 80 00       	push   $0x80425c
  803265:	68 10 02 00 00       	push   $0x210
  80326a:	68 0d 42 80 00       	push   $0x80420d
  80326f:	e8 10 05 00 00       	call   803784 <_panic>
  803274:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80327a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327d:	89 50 04             	mov    %edx,0x4(%eax)
  803280:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0c                	je     803296 <realloc_block_FF+0x38e>
  80328a:	a1 30 50 80 00       	mov    0x805030,%eax
  80328f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803292:	89 10                	mov    %edx,(%eax)
  803294:	eb 08                	jmp    80329e <realloc_block_FF+0x396>
  803296:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803299:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	a1 38 50 80 00       	mov    0x805038,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ba:	e9 cc 00 00 00       	jmp    80338b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8032bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8032c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ce:	e9 8a 00 00 00       	jmp    80335d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032d9:	73 7a                	jae    803355 <realloc_block_FF+0x44d>
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032e3:	73 70                	jae    803355 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8032e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e9:	74 06                	je     8032f1 <realloc_block_FF+0x3e9>
  8032eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032ef:	75 17                	jne    803308 <realloc_block_FF+0x400>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 80 42 80 00       	push   $0x804280
  8032f9:	68 1a 02 00 00       	push   $0x21a
  8032fe:	68 0d 42 80 00       	push   $0x80420d
  803303:	e8 7c 04 00 00       	call   803784 <_panic>
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 10                	mov    (%eax),%edx
  80330d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803310:	89 10                	mov    %edx,(%eax)
  803312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0b                	je     803326 <realloc_block_FF+0x41e>
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	75 08                	jne    803348 <realloc_block_FF+0x440>
  803340:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803343:	a3 30 50 80 00       	mov    %eax,0x805030
  803348:	a1 38 50 80 00       	mov    0x805038,%eax
  80334d:	40                   	inc    %eax
  80334e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803353:	eb 36                	jmp    80338b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803355:	a1 34 50 80 00       	mov    0x805034,%eax
  80335a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803361:	74 07                	je     80336a <realloc_block_FF+0x462>
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	eb 05                	jmp    80336f <realloc_block_FF+0x467>
  80336a:	b8 00 00 00 00       	mov    $0x0,%eax
  80336f:	a3 34 50 80 00       	mov    %eax,0x805034
  803374:	a1 34 50 80 00       	mov    0x805034,%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	0f 85 52 ff ff ff    	jne    8032d3 <realloc_block_FF+0x3cb>
  803381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803385:	0f 85 48 ff ff ff    	jne    8032d3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80338b:	83 ec 04             	sub    $0x4,%esp
  80338e:	6a 00                	push   $0x0
  803390:	ff 75 d8             	pushl  -0x28(%ebp)
  803393:	ff 75 d4             	pushl  -0x2c(%ebp)
  803396:	e8 7a eb ff ff       	call   801f15 <set_block_data>
  80339b:	83 c4 10             	add    $0x10,%esp
				return va;
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	e9 7b 02 00 00       	jmp    803621 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033a6:	83 ec 0c             	sub    $0xc,%esp
  8033a9:	68 fd 42 80 00       	push   $0x8042fd
  8033ae:	e8 de cf ff ff       	call   800391 <cprintf>
  8033b3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	e9 63 02 00 00       	jmp    803621 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8033be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c4:	0f 86 4d 02 00 00    	jbe    803617 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8033ca:	83 ec 0c             	sub    $0xc,%esp
  8033cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033d0:	e8 08 e8 ff ff       	call   801bdd <is_free_block>
  8033d5:	83 c4 10             	add    $0x10,%esp
  8033d8:	84 c0                	test   %al,%al
  8033da:	0f 84 37 02 00 00    	je     803617 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8033e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8033e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033ef:	76 38                	jbe    803429 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8033f1:	83 ec 0c             	sub    $0xc,%esp
  8033f4:	ff 75 08             	pushl  0x8(%ebp)
  8033f7:	e8 0c fa ff ff       	call   802e08 <free_block>
  8033fc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8033ff:	83 ec 0c             	sub    $0xc,%esp
  803402:	ff 75 0c             	pushl  0xc(%ebp)
  803405:	e8 3a eb ff ff       	call   801f44 <alloc_block_FF>
  80340a:	83 c4 10             	add    $0x10,%esp
  80340d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803410:	83 ec 08             	sub    $0x8,%esp
  803413:	ff 75 c0             	pushl  -0x40(%ebp)
  803416:	ff 75 08             	pushl  0x8(%ebp)
  803419:	e8 ab fa ff ff       	call   802ec9 <copy_data>
  80341e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803421:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803424:	e9 f8 01 00 00       	jmp    803621 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80342f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803432:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803436:	0f 87 a0 00 00 00    	ja     8034dc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80343c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803440:	75 17                	jne    803459 <realloc_block_FF+0x551>
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	68 ef 41 80 00       	push   $0x8041ef
  80344a:	68 38 02 00 00       	push   $0x238
  80344f:	68 0d 42 80 00       	push   $0x80420d
  803454:	e8 2b 03 00 00       	call   803784 <_panic>
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 10                	je     803472 <realloc_block_FF+0x56a>
  803462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80346a:	8b 52 04             	mov    0x4(%edx),%edx
  80346d:	89 50 04             	mov    %edx,0x4(%eax)
  803470:	eb 0b                	jmp    80347d <realloc_block_FF+0x575>
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	8b 40 04             	mov    0x4(%eax),%eax
  803478:	a3 30 50 80 00       	mov    %eax,0x805030
  80347d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803480:	8b 40 04             	mov    0x4(%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	74 0f                	je     803496 <realloc_block_FF+0x58e>
  803487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348a:	8b 40 04             	mov    0x4(%eax),%eax
  80348d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803490:	8b 12                	mov    (%edx),%edx
  803492:	89 10                	mov    %edx,(%eax)
  803494:	eb 0a                	jmp    8034a0 <realloc_block_FF+0x598>
  803496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803499:	8b 00                	mov    (%eax),%eax
  80349b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b8:	48                   	dec    %eax
  8034b9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8034be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c4:	01 d0                	add    %edx,%eax
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	6a 01                	push   $0x1
  8034cb:	50                   	push   %eax
  8034cc:	ff 75 08             	pushl  0x8(%ebp)
  8034cf:	e8 41 ea ff ff       	call   801f15 <set_block_data>
  8034d4:	83 c4 10             	add    $0x10,%esp
  8034d7:	e9 36 01 00 00       	jmp    803612 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8034dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034e2:	01 d0                	add    %edx,%eax
  8034e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	6a 01                	push   $0x1
  8034ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ef:	ff 75 08             	pushl  0x8(%ebp)
  8034f2:	e8 1e ea ff ff       	call   801f15 <set_block_data>
  8034f7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	83 e8 04             	sub    $0x4,%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	83 e0 fe             	and    $0xfffffffe,%eax
  803505:	89 c2                	mov    %eax,%edx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	01 d0                	add    %edx,%eax
  80350c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80350f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803513:	74 06                	je     80351b <realloc_block_FF+0x613>
  803515:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803519:	75 17                	jne    803532 <realloc_block_FF+0x62a>
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	68 80 42 80 00       	push   $0x804280
  803523:	68 44 02 00 00       	push   $0x244
  803528:	68 0d 42 80 00       	push   $0x80420d
  80352d:	e8 52 02 00 00       	call   803784 <_panic>
  803532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803535:	8b 10                	mov    (%eax),%edx
  803537:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80353a:	89 10                	mov    %edx,(%eax)
  80353c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0b                	je     803550 <realloc_block_FF+0x648>
  803545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80354d:	89 50 04             	mov    %edx,0x4(%eax)
  803550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803553:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803556:	89 10                	mov    %edx,(%eax)
  803558:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80355b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355e:	89 50 04             	mov    %edx,0x4(%eax)
  803561:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	75 08                	jne    803572 <realloc_block_FF+0x66a>
  80356a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80356d:	a3 30 50 80 00       	mov    %eax,0x805030
  803572:	a1 38 50 80 00       	mov    0x805038,%eax
  803577:	40                   	inc    %eax
  803578:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80357d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803581:	75 17                	jne    80359a <realloc_block_FF+0x692>
  803583:	83 ec 04             	sub    $0x4,%esp
  803586:	68 ef 41 80 00       	push   $0x8041ef
  80358b:	68 45 02 00 00       	push   $0x245
  803590:	68 0d 42 80 00       	push   $0x80420d
  803595:	e8 ea 01 00 00       	call   803784 <_panic>
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	85 c0                	test   %eax,%eax
  8035a1:	74 10                	je     8035b3 <realloc_block_FF+0x6ab>
  8035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ab:	8b 52 04             	mov    0x4(%edx),%edx
  8035ae:	89 50 04             	mov    %edx,0x4(%eax)
  8035b1:	eb 0b                	jmp    8035be <realloc_block_FF+0x6b6>
  8035b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b6:	8b 40 04             	mov    0x4(%eax),%eax
  8035b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c1:	8b 40 04             	mov    0x4(%eax),%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 0f                	je     8035d7 <realloc_block_FF+0x6cf>
  8035c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d1:	8b 12                	mov    (%edx),%edx
  8035d3:	89 10                	mov    %edx,(%eax)
  8035d5:	eb 0a                	jmp    8035e1 <realloc_block_FF+0x6d9>
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f9:	48                   	dec    %eax
  8035fa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8035ff:	83 ec 04             	sub    $0x4,%esp
  803602:	6a 00                	push   $0x0
  803604:	ff 75 bc             	pushl  -0x44(%ebp)
  803607:	ff 75 b8             	pushl  -0x48(%ebp)
  80360a:	e8 06 e9 ff ff       	call   801f15 <set_block_data>
  80360f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	eb 0a                	jmp    803621 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803617:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803621:	c9                   	leave  
  803622:	c3                   	ret    

00803623 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803623:	55                   	push   %ebp
  803624:	89 e5                	mov    %esp,%ebp
  803626:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803629:	83 ec 04             	sub    $0x4,%esp
  80362c:	68 04 43 80 00       	push   $0x804304
  803631:	68 58 02 00 00       	push   $0x258
  803636:	68 0d 42 80 00       	push   $0x80420d
  80363b:	e8 44 01 00 00       	call   803784 <_panic>

00803640 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803640:	55                   	push   %ebp
  803641:	89 e5                	mov    %esp,%ebp
  803643:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	68 2c 43 80 00       	push   $0x80432c
  80364e:	68 61 02 00 00       	push   $0x261
  803653:	68 0d 42 80 00       	push   $0x80420d
  803658:	e8 27 01 00 00       	call   803784 <_panic>

0080365d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80365d:	55                   	push   %ebp
  80365e:	89 e5                	mov    %esp,%ebp
  803660:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803663:	83 ec 04             	sub    $0x4,%esp
  803666:	68 54 43 80 00       	push   $0x804354
  80366b:	6a 09                	push   $0x9
  80366d:	68 7c 43 80 00       	push   $0x80437c
  803672:	e8 0d 01 00 00       	call   803784 <_panic>

00803677 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803677:	55                   	push   %ebp
  803678:	89 e5                	mov    %esp,%ebp
  80367a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80367d:	83 ec 04             	sub    $0x4,%esp
  803680:	68 8c 43 80 00       	push   $0x80438c
  803685:	6a 10                	push   $0x10
  803687:	68 7c 43 80 00       	push   $0x80437c
  80368c:	e8 f3 00 00 00       	call   803784 <_panic>

00803691 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803691:	55                   	push   %ebp
  803692:	89 e5                	mov    %esp,%ebp
  803694:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 b4 43 80 00       	push   $0x8043b4
  80369f:	6a 18                	push   $0x18
  8036a1:	68 7c 43 80 00       	push   $0x80437c
  8036a6:	e8 d9 00 00 00       	call   803784 <_panic>

008036ab <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8036ab:	55                   	push   %ebp
  8036ac:	89 e5                	mov    %esp,%ebp
  8036ae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	68 dc 43 80 00       	push   $0x8043dc
  8036b9:	6a 20                	push   $0x20
  8036bb:	68 7c 43 80 00       	push   $0x80437c
  8036c0:	e8 bf 00 00 00       	call   803784 <_panic>

008036c5 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	8b 40 10             	mov    0x10(%eax),%eax
}
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    

008036d0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
  8036d3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8036d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d9:	89 d0                	mov    %edx,%eax
  8036db:	c1 e0 02             	shl    $0x2,%eax
  8036de:	01 d0                	add    %edx,%eax
  8036e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036e7:	01 d0                	add    %edx,%eax
  8036e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036f0:	01 d0                	add    %edx,%eax
  8036f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036f9:	01 d0                	add    %edx,%eax
  8036fb:	c1 e0 04             	shl    $0x4,%eax
  8036fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803708:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80370b:	83 ec 0c             	sub    $0xc,%esp
  80370e:	50                   	push   %eax
  80370f:	e8 bc e1 ff ff       	call   8018d0 <sys_get_virtual_time>
  803714:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803717:	eb 41                	jmp    80375a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803719:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80371c:	83 ec 0c             	sub    $0xc,%esp
  80371f:	50                   	push   %eax
  803720:	e8 ab e1 ff ff       	call   8018d0 <sys_get_virtual_time>
  803725:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803728:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80372b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372e:	29 c2                	sub    %eax,%edx
  803730:	89 d0                	mov    %edx,%eax
  803732:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373b:	89 d1                	mov    %edx,%ecx
  80373d:	29 c1                	sub    %eax,%ecx
  80373f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803742:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803745:	39 c2                	cmp    %eax,%edx
  803747:	0f 97 c0             	seta   %al
  80374a:	0f b6 c0             	movzbl %al,%eax
  80374d:	29 c1                	sub    %eax,%ecx
  80374f:	89 c8                	mov    %ecx,%eax
  803751:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803754:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803757:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803760:	72 b7                	jb     803719 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803762:	90                   	nop
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
  803768:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80376b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803772:	eb 03                	jmp    803777 <busy_wait+0x12>
  803774:	ff 45 fc             	incl   -0x4(%ebp)
  803777:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80377a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80377d:	72 f5                	jb     803774 <busy_wait+0xf>
	return i;
  80377f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803782:	c9                   	leave  
  803783:	c3                   	ret    

00803784 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803784:	55                   	push   %ebp
  803785:	89 e5                	mov    %esp,%ebp
  803787:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80378a:	8d 45 10             	lea    0x10(%ebp),%eax
  80378d:	83 c0 04             	add    $0x4,%eax
  803790:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803793:	a1 60 50 90 00       	mov    0x905060,%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 16                	je     8037b2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80379c:	a1 60 50 90 00       	mov    0x905060,%eax
  8037a1:	83 ec 08             	sub    $0x8,%esp
  8037a4:	50                   	push   %eax
  8037a5:	68 04 44 80 00       	push   $0x804404
  8037aa:	e8 e2 cb ff ff       	call   800391 <cprintf>
  8037af:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037b2:	a1 00 50 80 00       	mov    0x805000,%eax
  8037b7:	ff 75 0c             	pushl  0xc(%ebp)
  8037ba:	ff 75 08             	pushl  0x8(%ebp)
  8037bd:	50                   	push   %eax
  8037be:	68 09 44 80 00       	push   $0x804409
  8037c3:	e8 c9 cb ff ff       	call   800391 <cprintf>
  8037c8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8037cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8037ce:	83 ec 08             	sub    $0x8,%esp
  8037d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8037d4:	50                   	push   %eax
  8037d5:	e8 4c cb ff ff       	call   800326 <vcprintf>
  8037da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8037dd:	83 ec 08             	sub    $0x8,%esp
  8037e0:	6a 00                	push   $0x0
  8037e2:	68 25 44 80 00       	push   $0x804425
  8037e7:	e8 3a cb ff ff       	call   800326 <vcprintf>
  8037ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8037ef:	e8 bb ca ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  8037f4:	eb fe                	jmp    8037f4 <_panic+0x70>

008037f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
  8037f9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8037fc:	a1 20 50 80 00       	mov    0x805020,%eax
  803801:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380a:	39 c2                	cmp    %eax,%edx
  80380c:	74 14                	je     803822 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80380e:	83 ec 04             	sub    $0x4,%esp
  803811:	68 28 44 80 00       	push   $0x804428
  803816:	6a 26                	push   $0x26
  803818:	68 74 44 80 00       	push   $0x804474
  80381d:	e8 62 ff ff ff       	call   803784 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803829:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803830:	e9 c5 00 00 00       	jmp    8038fa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803838:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	01 d0                	add    %edx,%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	75 08                	jne    803852 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80384a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80384d:	e9 a5 00 00 00       	jmp    8038f7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803852:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803859:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803860:	eb 69                	jmp    8038cb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803862:	a1 20 50 80 00       	mov    0x805020,%eax
  803867:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80386d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803870:	89 d0                	mov    %edx,%eax
  803872:	01 c0                	add    %eax,%eax
  803874:	01 d0                	add    %edx,%eax
  803876:	c1 e0 03             	shl    $0x3,%eax
  803879:	01 c8                	add    %ecx,%eax
  80387b:	8a 40 04             	mov    0x4(%eax),%al
  80387e:	84 c0                	test   %al,%al
  803880:	75 46                	jne    8038c8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803882:	a1 20 50 80 00       	mov    0x805020,%eax
  803887:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80388d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803890:	89 d0                	mov    %edx,%eax
  803892:	01 c0                	add    %eax,%eax
  803894:	01 d0                	add    %edx,%eax
  803896:	c1 e0 03             	shl    $0x3,%eax
  803899:	01 c8                	add    %ecx,%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	01 c8                	add    %ecx,%eax
  8038b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	75 09                	jne    8038c8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8038bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8038c6:	eb 15                	jmp    8038dd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038c8:	ff 45 e8             	incl   -0x18(%ebp)
  8038cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8038d0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d9:	39 c2                	cmp    %eax,%edx
  8038db:	77 85                	ja     803862 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8038dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038e1:	75 14                	jne    8038f7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8038e3:	83 ec 04             	sub    $0x4,%esp
  8038e6:	68 80 44 80 00       	push   $0x804480
  8038eb:	6a 3a                	push   $0x3a
  8038ed:	68 74 44 80 00       	push   $0x804474
  8038f2:	e8 8d fe ff ff       	call   803784 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8038f7:	ff 45 f0             	incl   -0x10(%ebp)
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803900:	0f 8c 2f ff ff ff    	jl     803835 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803906:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803914:	eb 26                	jmp    80393c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803916:	a1 20 50 80 00       	mov    0x805020,%eax
  80391b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803921:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803924:	89 d0                	mov    %edx,%eax
  803926:	01 c0                	add    %eax,%eax
  803928:	01 d0                	add    %edx,%eax
  80392a:	c1 e0 03             	shl    $0x3,%eax
  80392d:	01 c8                	add    %ecx,%eax
  80392f:	8a 40 04             	mov    0x4(%eax),%al
  803932:	3c 01                	cmp    $0x1,%al
  803934:	75 03                	jne    803939 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803936:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803939:	ff 45 e0             	incl   -0x20(%ebp)
  80393c:	a1 20 50 80 00       	mov    0x805020,%eax
  803941:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394a:	39 c2                	cmp    %eax,%edx
  80394c:	77 c8                	ja     803916 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803954:	74 14                	je     80396a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803956:	83 ec 04             	sub    $0x4,%esp
  803959:	68 d4 44 80 00       	push   $0x8044d4
  80395e:	6a 44                	push   $0x44
  803960:	68 74 44 80 00       	push   $0x804474
  803965:	e8 1a fe ff ff       	call   803784 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80396a:	90                   	nop
  80396b:	c9                   	leave  
  80396c:	c3                   	ret    
  80396d:	66 90                	xchg   %ax,%ax
  80396f:	90                   	nop

00803970 <__udivdi3>:
  803970:	55                   	push   %ebp
  803971:	57                   	push   %edi
  803972:	56                   	push   %esi
  803973:	53                   	push   %ebx
  803974:	83 ec 1c             	sub    $0x1c,%esp
  803977:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80397b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80397f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803983:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803987:	89 ca                	mov    %ecx,%edx
  803989:	89 f8                	mov    %edi,%eax
  80398b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80398f:	85 f6                	test   %esi,%esi
  803991:	75 2d                	jne    8039c0 <__udivdi3+0x50>
  803993:	39 cf                	cmp    %ecx,%edi
  803995:	77 65                	ja     8039fc <__udivdi3+0x8c>
  803997:	89 fd                	mov    %edi,%ebp
  803999:	85 ff                	test   %edi,%edi
  80399b:	75 0b                	jne    8039a8 <__udivdi3+0x38>
  80399d:	b8 01 00 00 00       	mov    $0x1,%eax
  8039a2:	31 d2                	xor    %edx,%edx
  8039a4:	f7 f7                	div    %edi
  8039a6:	89 c5                	mov    %eax,%ebp
  8039a8:	31 d2                	xor    %edx,%edx
  8039aa:	89 c8                	mov    %ecx,%eax
  8039ac:	f7 f5                	div    %ebp
  8039ae:	89 c1                	mov    %eax,%ecx
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f5                	div    %ebp
  8039b4:	89 cf                	mov    %ecx,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	39 ce                	cmp    %ecx,%esi
  8039c2:	77 28                	ja     8039ec <__udivdi3+0x7c>
  8039c4:	0f bd fe             	bsr    %esi,%edi
  8039c7:	83 f7 1f             	xor    $0x1f,%edi
  8039ca:	75 40                	jne    803a0c <__udivdi3+0x9c>
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	72 0a                	jb     8039da <__udivdi3+0x6a>
  8039d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039d4:	0f 87 9e 00 00 00    	ja     803a78 <__udivdi3+0x108>
  8039da:	b8 01 00 00 00       	mov    $0x1,%eax
  8039df:	89 fa                	mov    %edi,%edx
  8039e1:	83 c4 1c             	add    $0x1c,%esp
  8039e4:	5b                   	pop    %ebx
  8039e5:	5e                   	pop    %esi
  8039e6:	5f                   	pop    %edi
  8039e7:	5d                   	pop    %ebp
  8039e8:	c3                   	ret    
  8039e9:	8d 76 00             	lea    0x0(%esi),%esi
  8039ec:	31 ff                	xor    %edi,%edi
  8039ee:	31 c0                	xor    %eax,%eax
  8039f0:	89 fa                	mov    %edi,%edx
  8039f2:	83 c4 1c             	add    $0x1c,%esp
  8039f5:	5b                   	pop    %ebx
  8039f6:	5e                   	pop    %esi
  8039f7:	5f                   	pop    %edi
  8039f8:	5d                   	pop    %ebp
  8039f9:	c3                   	ret    
  8039fa:	66 90                	xchg   %ax,%ax
  8039fc:	89 d8                	mov    %ebx,%eax
  8039fe:	f7 f7                	div    %edi
  803a00:	31 ff                	xor    %edi,%edi
  803a02:	89 fa                	mov    %edi,%edx
  803a04:	83 c4 1c             	add    $0x1c,%esp
  803a07:	5b                   	pop    %ebx
  803a08:	5e                   	pop    %esi
  803a09:	5f                   	pop    %edi
  803a0a:	5d                   	pop    %ebp
  803a0b:	c3                   	ret    
  803a0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a11:	89 eb                	mov    %ebp,%ebx
  803a13:	29 fb                	sub    %edi,%ebx
  803a15:	89 f9                	mov    %edi,%ecx
  803a17:	d3 e6                	shl    %cl,%esi
  803a19:	89 c5                	mov    %eax,%ebp
  803a1b:	88 d9                	mov    %bl,%cl
  803a1d:	d3 ed                	shr    %cl,%ebp
  803a1f:	89 e9                	mov    %ebp,%ecx
  803a21:	09 f1                	or     %esi,%ecx
  803a23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a27:	89 f9                	mov    %edi,%ecx
  803a29:	d3 e0                	shl    %cl,%eax
  803a2b:	89 c5                	mov    %eax,%ebp
  803a2d:	89 d6                	mov    %edx,%esi
  803a2f:	88 d9                	mov    %bl,%cl
  803a31:	d3 ee                	shr    %cl,%esi
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e2                	shl    %cl,%edx
  803a37:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 e8                	shr    %cl,%eax
  803a3f:	09 c2                	or     %eax,%edx
  803a41:	89 d0                	mov    %edx,%eax
  803a43:	89 f2                	mov    %esi,%edx
  803a45:	f7 74 24 0c          	divl   0xc(%esp)
  803a49:	89 d6                	mov    %edx,%esi
  803a4b:	89 c3                	mov    %eax,%ebx
  803a4d:	f7 e5                	mul    %ebp
  803a4f:	39 d6                	cmp    %edx,%esi
  803a51:	72 19                	jb     803a6c <__udivdi3+0xfc>
  803a53:	74 0b                	je     803a60 <__udivdi3+0xf0>
  803a55:	89 d8                	mov    %ebx,%eax
  803a57:	31 ff                	xor    %edi,%edi
  803a59:	e9 58 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a64:	89 f9                	mov    %edi,%ecx
  803a66:	d3 e2                	shl    %cl,%edx
  803a68:	39 c2                	cmp    %eax,%edx
  803a6a:	73 e9                	jae    803a55 <__udivdi3+0xe5>
  803a6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a6f:	31 ff                	xor    %edi,%edi
  803a71:	e9 40 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a76:	66 90                	xchg   %ax,%ax
  803a78:	31 c0                	xor    %eax,%eax
  803a7a:	e9 37 ff ff ff       	jmp    8039b6 <__udivdi3+0x46>
  803a7f:	90                   	nop

00803a80 <__umoddi3>:
  803a80:	55                   	push   %ebp
  803a81:	57                   	push   %edi
  803a82:	56                   	push   %esi
  803a83:	53                   	push   %ebx
  803a84:	83 ec 1c             	sub    $0x1c,%esp
  803a87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a9f:	89 f3                	mov    %esi,%ebx
  803aa1:	89 fa                	mov    %edi,%edx
  803aa3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa7:	89 34 24             	mov    %esi,(%esp)
  803aaa:	85 c0                	test   %eax,%eax
  803aac:	75 1a                	jne    803ac8 <__umoddi3+0x48>
  803aae:	39 f7                	cmp    %esi,%edi
  803ab0:	0f 86 a2 00 00 00    	jbe    803b58 <__umoddi3+0xd8>
  803ab6:	89 c8                	mov    %ecx,%eax
  803ab8:	89 f2                	mov    %esi,%edx
  803aba:	f7 f7                	div    %edi
  803abc:	89 d0                	mov    %edx,%eax
  803abe:	31 d2                	xor    %edx,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	39 f0                	cmp    %esi,%eax
  803aca:	0f 87 ac 00 00 00    	ja     803b7c <__umoddi3+0xfc>
  803ad0:	0f bd e8             	bsr    %eax,%ebp
  803ad3:	83 f5 1f             	xor    $0x1f,%ebp
  803ad6:	0f 84 ac 00 00 00    	je     803b88 <__umoddi3+0x108>
  803adc:	bf 20 00 00 00       	mov    $0x20,%edi
  803ae1:	29 ef                	sub    %ebp,%edi
  803ae3:	89 fe                	mov    %edi,%esi
  803ae5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ae9:	89 e9                	mov    %ebp,%ecx
  803aeb:	d3 e0                	shl    %cl,%eax
  803aed:	89 d7                	mov    %edx,%edi
  803aef:	89 f1                	mov    %esi,%ecx
  803af1:	d3 ef                	shr    %cl,%edi
  803af3:	09 c7                	or     %eax,%edi
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e2                	shl    %cl,%edx
  803af9:	89 14 24             	mov    %edx,(%esp)
  803afc:	89 d8                	mov    %ebx,%eax
  803afe:	d3 e0                	shl    %cl,%eax
  803b00:	89 c2                	mov    %eax,%edx
  803b02:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b06:	d3 e0                	shl    %cl,%eax
  803b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b10:	89 f1                	mov    %esi,%ecx
  803b12:	d3 e8                	shr    %cl,%eax
  803b14:	09 d0                	or     %edx,%eax
  803b16:	d3 eb                	shr    %cl,%ebx
  803b18:	89 da                	mov    %ebx,%edx
  803b1a:	f7 f7                	div    %edi
  803b1c:	89 d3                	mov    %edx,%ebx
  803b1e:	f7 24 24             	mull   (%esp)
  803b21:	89 c6                	mov    %eax,%esi
  803b23:	89 d1                	mov    %edx,%ecx
  803b25:	39 d3                	cmp    %edx,%ebx
  803b27:	0f 82 87 00 00 00    	jb     803bb4 <__umoddi3+0x134>
  803b2d:	0f 84 91 00 00 00    	je     803bc4 <__umoddi3+0x144>
  803b33:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b37:	29 f2                	sub    %esi,%edx
  803b39:	19 cb                	sbb    %ecx,%ebx
  803b3b:	89 d8                	mov    %ebx,%eax
  803b3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b41:	d3 e0                	shl    %cl,%eax
  803b43:	89 e9                	mov    %ebp,%ecx
  803b45:	d3 ea                	shr    %cl,%edx
  803b47:	09 d0                	or     %edx,%eax
  803b49:	89 e9                	mov    %ebp,%ecx
  803b4b:	d3 eb                	shr    %cl,%ebx
  803b4d:	89 da                	mov    %ebx,%edx
  803b4f:	83 c4 1c             	add    $0x1c,%esp
  803b52:	5b                   	pop    %ebx
  803b53:	5e                   	pop    %esi
  803b54:	5f                   	pop    %edi
  803b55:	5d                   	pop    %ebp
  803b56:	c3                   	ret    
  803b57:	90                   	nop
  803b58:	89 fd                	mov    %edi,%ebp
  803b5a:	85 ff                	test   %edi,%edi
  803b5c:	75 0b                	jne    803b69 <__umoddi3+0xe9>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	31 d2                	xor    %edx,%edx
  803b65:	f7 f7                	div    %edi
  803b67:	89 c5                	mov    %eax,%ebp
  803b69:	89 f0                	mov    %esi,%eax
  803b6b:	31 d2                	xor    %edx,%edx
  803b6d:	f7 f5                	div    %ebp
  803b6f:	89 c8                	mov    %ecx,%eax
  803b71:	f7 f5                	div    %ebp
  803b73:	89 d0                	mov    %edx,%eax
  803b75:	e9 44 ff ff ff       	jmp    803abe <__umoddi3+0x3e>
  803b7a:	66 90                	xchg   %ax,%ax
  803b7c:	89 c8                	mov    %ecx,%eax
  803b7e:	89 f2                	mov    %esi,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	3b 04 24             	cmp    (%esp),%eax
  803b8b:	72 06                	jb     803b93 <__umoddi3+0x113>
  803b8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b91:	77 0f                	ja     803ba2 <__umoddi3+0x122>
  803b93:	89 f2                	mov    %esi,%edx
  803b95:	29 f9                	sub    %edi,%ecx
  803b97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b9b:	89 14 24             	mov    %edx,(%esp)
  803b9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ba2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ba6:	8b 14 24             	mov    (%esp),%edx
  803ba9:	83 c4 1c             	add    $0x1c,%esp
  803bac:	5b                   	pop    %ebx
  803bad:	5e                   	pop    %esi
  803bae:	5f                   	pop    %edi
  803baf:	5d                   	pop    %ebp
  803bb0:	c3                   	ret    
  803bb1:	8d 76 00             	lea    0x0(%esi),%esi
  803bb4:	2b 04 24             	sub    (%esp),%eax
  803bb7:	19 fa                	sbb    %edi,%edx
  803bb9:	89 d1                	mov    %edx,%ecx
  803bbb:	89 c6                	mov    %eax,%esi
  803bbd:	e9 71 ff ff ff       	jmp    803b33 <__umoddi3+0xb3>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bc8:	72 ea                	jb     803bb4 <__umoddi3+0x134>
  803bca:	89 d9                	mov    %ebx,%ecx
  803bcc:	e9 62 ff ff ff       	jmp    803b33 <__umoddi3+0xb3>
