
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
  800049:	68 60 3e 80 00       	push   $0x803e60
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 ae 14 00 00       	call   801504 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 3e 80 00       	push   $0x803e62
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 98 14 00 00       	call   801504 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 3e 80 00       	push   $0x803e69
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
  8000b7:	e8 8b 38 00 00       	call   803947 <env_sleep>
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
  8000f8:	e8 4a 38 00 00       	call   803947 <env_sleep>
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
  800137:	e8 0b 38 00 00       	call   803947 <env_sleep>
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
  80014f:	68 77 3e 80 00       	push   $0x803e77
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 a0 36 00 00       	call   8037fd <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 5f 37 00 00       	call   8038ca <signal_semaphore>
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
  8001fa:	68 94 3e 80 00       	push   $0x803e94
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
  800222:	68 bc 3e 80 00       	push   $0x803ebc
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
  800253:	68 e4 3e 80 00       	push   $0x803ee4
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 3c 3f 80 00       	push   $0x803f3c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 94 3e 80 00       	push   $0x803e94
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
  80042e:	e8 b1 37 00 00       	call   803be4 <__udivdi3>
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
  80047e:	e8 71 38 00 00       	call   803cf4 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 74 41 80 00       	add    $0x804174,%eax
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
  8005d9:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  8006ba:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 85 41 80 00       	push   $0x804185
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
  8006df:	68 8e 41 80 00       	push   $0x80418e
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
  80070c:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801117:	68 08 43 80 00       	push   $0x804308
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 2a 43 80 00       	push   $0x80432a
  801126:	e8 d0 28 00 00       	call   8039fb <_panic>

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
  8011c1:	e8 dd 0e 00 00       	call   8020a3 <alloc_block_FF>
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
  8011e4:	e8 76 13 00 00       	call   80255f <alloc_block_BF>
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
  801392:	e8 8c 09 00 00       	call   801d23 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 9c 1b 00 00       	call   802f44 <free_block>
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
  801448:	68 38 43 80 00       	push   $0x804338
  80144d:	68 87 00 00 00       	push   $0x87
  801452:	68 62 43 80 00       	push   $0x804362
  801457:	e8 9f 25 00 00       	call   8039fb <_panic>
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
  8015f3:	68 70 43 80 00       	push   $0x804370
  8015f8:	68 e4 00 00 00       	push   $0xe4
  8015fd:	68 62 43 80 00       	push   $0x804362
  801602:	e8 f4 23 00 00       	call   8039fb <_panic>

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
  801610:	68 96 43 80 00       	push   $0x804396
  801615:	68 f0 00 00 00       	push   $0xf0
  80161a:	68 62 43 80 00       	push   $0x804362
  80161f:	e8 d7 23 00 00       	call   8039fb <_panic>

00801624 <shrink>:

}
void shrink(uint32 newSize)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 96 43 80 00       	push   $0x804396
  801632:	68 f5 00 00 00       	push   $0xf5
  801637:	68 62 43 80 00       	push   $0x804362
  80163c:	e8 ba 23 00 00       	call   8039fb <_panic>

00801641 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	68 96 43 80 00       	push   $0x804396
  80164f:	68 fa 00 00 00       	push   $0xfa
  801654:	68 62 43 80 00       	push   $0x804362
  801659:	e8 9d 23 00 00       	call   8039fb <_panic>

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

00801c87 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 2e                	push   $0x2e
  801c99:	e8 c0 f9 ff ff       	call   80165e <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	50                   	push   %eax
  801cb8:	6a 2f                	push   $0x2f
  801cba:	e8 9f f9 ff ff       	call   80165e <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
	return;
  801cc2:	90                   	nop
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 30                	push   $0x30
  801cd8:	e8 81 f9 ff ff       	call   80165e <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	50                   	push   %eax
  801cf5:	6a 31                	push   $0x31
  801cf7:	e8 62 f9 ff ff       	call   80165e <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
  801cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	50                   	push   %eax
  801d16:	6a 32                	push   $0x32
  801d18:	e8 41 f9 ff ff       	call   80165e <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	83 e8 04             	sub    $0x4,%eax
  801d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d35:	8b 00                	mov    (%eax),%eax
  801d37:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	83 e8 04             	sub    $0x4,%eax
  801d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	83 e0 01             	and    $0x1,%eax
  801d53:	85 c0                	test   %eax,%eax
  801d55:	0f 94 c0             	sete   %al
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6a:	83 f8 02             	cmp    $0x2,%eax
  801d6d:	74 2b                	je     801d9a <alloc_block+0x40>
  801d6f:	83 f8 02             	cmp    $0x2,%eax
  801d72:	7f 07                	jg     801d7b <alloc_block+0x21>
  801d74:	83 f8 01             	cmp    $0x1,%eax
  801d77:	74 0e                	je     801d87 <alloc_block+0x2d>
  801d79:	eb 58                	jmp    801dd3 <alloc_block+0x79>
  801d7b:	83 f8 03             	cmp    $0x3,%eax
  801d7e:	74 2d                	je     801dad <alloc_block+0x53>
  801d80:	83 f8 04             	cmp    $0x4,%eax
  801d83:	74 3b                	je     801dc0 <alloc_block+0x66>
  801d85:	eb 4c                	jmp    801dd3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	e8 11 03 00 00       	call   8020a3 <alloc_block_FF>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d98:	eb 4a                	jmp    801de4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	ff 75 08             	pushl  0x8(%ebp)
  801da0:	e8 c7 19 00 00       	call   80376c <alloc_block_NF>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dab:	eb 37                	jmp    801de4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	ff 75 08             	pushl  0x8(%ebp)
  801db3:	e8 a7 07 00 00       	call   80255f <alloc_block_BF>
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dbe:	eb 24                	jmp    801de4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	e8 84 19 00 00       	call   80374f <alloc_block_WF>
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dd1:	eb 11                	jmp    801de4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	68 a8 43 80 00       	push   $0x8043a8
  801ddb:	e8 b1 e5 ff ff       	call   800391 <cprintf>
  801de0:	83 c4 10             	add    $0x10,%esp
		break;
  801de3:	90                   	nop
	}
	return va;
  801de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	53                   	push   %ebx
  801ded:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801df0:	83 ec 0c             	sub    $0xc,%esp
  801df3:	68 c8 43 80 00       	push   $0x8043c8
  801df8:	e8 94 e5 ff ff       	call   800391 <cprintf>
  801dfd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	68 f3 43 80 00       	push   $0x8043f3
  801e08:	e8 84 e5 ff ff       	call   800391 <cprintf>
  801e0d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e16:	eb 37                	jmp    801e4f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1e:	e8 19 ff ff ff       	call   801d3c <is_free_block>
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	0f be d8             	movsbl %al,%ebx
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2f:	e8 ef fe ff ff       	call   801d23 <get_block_size>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	53                   	push   %ebx
  801e3b:	50                   	push   %eax
  801e3c:	68 0b 44 80 00       	push   $0x80440b
  801e41:	e8 4b e5 ff ff       	call   800391 <cprintf>
  801e46:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e49:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e53:	74 07                	je     801e5c <print_blocks_list+0x73>
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	eb 05                	jmp    801e61 <print_blocks_list+0x78>
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	89 45 10             	mov    %eax,0x10(%ebp)
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	85 c0                	test   %eax,%eax
  801e69:	75 ad                	jne    801e18 <print_blocks_list+0x2f>
  801e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6f:	75 a7                	jne    801e18 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	68 c8 43 80 00       	push   $0x8043c8
  801e79:	e8 13 e5 ff ff       	call   800391 <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp

}
  801e81:	90                   	nop
  801e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e90:	83 e0 01             	and    $0x1,%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	74 03                	je     801e9a <initialize_dynamic_allocator+0x13>
  801e97:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9e:	0f 84 c7 01 00 00    	je     80206b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ea4:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801eab:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801eae:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801ebb:	0f 87 ad 01 00 00    	ja     80206e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	0f 89 a5 01 00 00    	jns    802071 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  801ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed2:	01 d0                	add    %edx,%eax
  801ed4:	83 e8 04             	sub    $0x4,%eax
  801ed7:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ee3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eeb:	e9 87 00 00 00       	jmp    801f77 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef4:	75 14                	jne    801f0a <initialize_dynamic_allocator+0x83>
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	68 23 44 80 00       	push   $0x804423
  801efe:	6a 79                	push   $0x79
  801f00:	68 41 44 80 00       	push   $0x804441
  801f05:	e8 f1 1a 00 00       	call   8039fb <_panic>
  801f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0d:	8b 00                	mov    (%eax),%eax
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	74 10                	je     801f23 <initialize_dynamic_allocator+0x9c>
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 00                	mov    (%eax),%eax
  801f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1b:	8b 52 04             	mov    0x4(%edx),%edx
  801f1e:	89 50 04             	mov    %edx,0x4(%eax)
  801f21:	eb 0b                	jmp    801f2e <initialize_dynamic_allocator+0xa7>
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 40 04             	mov    0x4(%eax),%eax
  801f29:	a3 30 50 80 00       	mov    %eax,0x805030
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 40 04             	mov    0x4(%eax),%eax
  801f34:	85 c0                	test   %eax,%eax
  801f36:	74 0f                	je     801f47 <initialize_dynamic_allocator+0xc0>
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	8b 40 04             	mov    0x4(%eax),%eax
  801f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f41:	8b 12                	mov    (%edx),%edx
  801f43:	89 10                	mov    %edx,(%eax)
  801f45:	eb 0a                	jmp    801f51 <initialize_dynamic_allocator+0xca>
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 00                	mov    (%eax),%eax
  801f4c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f64:	a1 38 50 80 00       	mov    0x805038,%eax
  801f69:	48                   	dec    %eax
  801f6a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f6f:	a1 34 50 80 00       	mov    0x805034,%eax
  801f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7b:	74 07                	je     801f84 <initialize_dynamic_allocator+0xfd>
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 00                	mov    (%eax),%eax
  801f82:	eb 05                	jmp    801f89 <initialize_dynamic_allocator+0x102>
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	a3 34 50 80 00       	mov    %eax,0x805034
  801f8e:	a1 34 50 80 00       	mov    0x805034,%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	0f 85 55 ff ff ff    	jne    801ef0 <initialize_dynamic_allocator+0x69>
  801f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9f:	0f 85 4b ff ff ff    	jne    801ef0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801fb4:	a1 44 50 80 00       	mov    0x805044,%eax
  801fb9:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801fbe:	a1 40 50 80 00       	mov    0x805040,%eax
  801fc3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	83 c0 08             	add    $0x8,%eax
  801fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	83 c0 04             	add    $0x4,%eax
  801fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdb:	83 ea 08             	sub    $0x8,%edx
  801fde:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	83 e8 08             	sub    $0x8,%eax
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	83 ea 08             	sub    $0x8,%edx
  801ff1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802006:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80200a:	75 17                	jne    802023 <initialize_dynamic_allocator+0x19c>
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	68 5c 44 80 00       	push   $0x80445c
  802014:	68 90 00 00 00       	push   $0x90
  802019:	68 41 44 80 00       	push   $0x804441
  80201e:	e8 d8 19 00 00       	call   8039fb <_panic>
  802023:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202c:	89 10                	mov    %edx,(%eax)
  80202e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	74 0d                	je     802044 <initialize_dynamic_allocator+0x1bd>
  802037:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80203c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80203f:	89 50 04             	mov    %edx,0x4(%eax)
  802042:	eb 08                	jmp    80204c <initialize_dynamic_allocator+0x1c5>
  802044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802047:	a3 30 50 80 00       	mov    %eax,0x805030
  80204c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205e:	a1 38 50 80 00       	mov    0x805038,%eax
  802063:	40                   	inc    %eax
  802064:	a3 38 50 80 00       	mov    %eax,0x805038
  802069:	eb 07                	jmp    802072 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80206b:	90                   	nop
  80206c:	eb 04                	jmp    802072 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80206e:	90                   	nop
  80206f:	eb 01                	jmp    802072 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802071:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802077:	8b 45 10             	mov    0x10(%ebp),%eax
  80207a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8d 50 fc             	lea    -0x4(%eax),%edx
  802083:	8b 45 0c             	mov    0xc(%ebp),%eax
  802086:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	83 e8 04             	sub    $0x4,%eax
  80208e:	8b 00                	mov    (%eax),%eax
  802090:	83 e0 fe             	and    $0xfffffffe,%eax
  802093:	8d 50 f8             	lea    -0x8(%eax),%edx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	01 c2                	add    %eax,%edx
  80209b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209e:	89 02                	mov    %eax,(%edx)
}
  8020a0:	90                   	nop
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    

008020a3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	83 e0 01             	and    $0x1,%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 03                	je     8020b6 <alloc_block_FF+0x13>
  8020b3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8020b6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020ba:	77 07                	ja     8020c3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020bc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020c3:	a1 24 50 80 00       	mov    0x805024,%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 73                	jne    80213f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	83 c0 10             	add    $0x10,%eax
  8020d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8020d5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e2:	01 d0                	add    %edx,%eax
  8020e4:	48                   	dec    %eax
  8020e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f0:	f7 75 ec             	divl   -0x14(%ebp)
  8020f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f6:	29 d0                	sub    %edx,%eax
  8020f8:	c1 e8 0c             	shr    $0xc,%eax
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	50                   	push   %eax
  8020ff:	e8 27 f0 ff ff       	call   80112b <sbrk>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	6a 00                	push   $0x0
  80210f:	e8 17 f0 ff ff       	call   80112b <sbrk>
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80211a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	50                   	push   %eax
  802124:	ff 75 e4             	pushl  -0x1c(%ebp)
  802127:	e8 5b fd ff ff       	call   801e87 <initialize_dynamic_allocator>
  80212c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	68 7f 44 80 00       	push   $0x80447f
  802137:	e8 55 e2 ff ff       	call   800391 <cprintf>
  80213c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80213f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802143:	75 0a                	jne    80214f <alloc_block_FF+0xac>
	        return NULL;
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	e9 0e 04 00 00       	jmp    80255d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80214f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802156:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80215b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215e:	e9 f3 02 00 00       	jmp    802456 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 bc             	pushl  -0x44(%ebp)
  80216f:	e8 af fb ff ff       	call   801d23 <get_block_size>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	83 c0 08             	add    $0x8,%eax
  802180:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802183:	0f 87 c5 02 00 00    	ja     80244e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	83 c0 18             	add    $0x18,%eax
  80218f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802192:	0f 87 19 02 00 00    	ja     8023b1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802198:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80219b:	2b 45 08             	sub    0x8(%ebp),%eax
  80219e:	83 e8 08             	sub    $0x8,%eax
  8021a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	8d 50 08             	lea    0x8(%eax),%edx
  8021aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	83 c0 08             	add    $0x8,%eax
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	6a 01                	push   $0x1
  8021bd:	50                   	push   %eax
  8021be:	ff 75 bc             	pushl  -0x44(%ebp)
  8021c1:	e8 ae fe ff ff       	call   802074 <set_block_data>
  8021c6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	8b 40 04             	mov    0x4(%eax),%eax
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	75 68                	jne    80223b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021d3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021d7:	75 17                	jne    8021f0 <alloc_block_FF+0x14d>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 5c 44 80 00       	push   $0x80445c
  8021e1:	68 d7 00 00 00       	push   $0xd7
  8021e6:	68 41 44 80 00       	push   $0x804441
  8021eb:	e8 0b 18 00 00       	call   8039fb <_panic>
  8021f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 0d                	je     802211 <alloc_block_FF+0x16e>
  802204:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802209:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80220c:	89 50 04             	mov    %edx,0x4(%eax)
  80220f:	eb 08                	jmp    802219 <alloc_block_FF+0x176>
  802211:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802214:	a3 30 50 80 00       	mov    %eax,0x805030
  802219:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802221:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222b:	a1 38 50 80 00       	mov    0x805038,%eax
  802230:	40                   	inc    %eax
  802231:	a3 38 50 80 00       	mov    %eax,0x805038
  802236:	e9 dc 00 00 00       	jmp    802317 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 00                	mov    (%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	75 65                	jne    8022a9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802244:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802248:	75 17                	jne    802261 <alloc_block_FF+0x1be>
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	68 90 44 80 00       	push   $0x804490
  802252:	68 db 00 00 00       	push   $0xdb
  802257:	68 41 44 80 00       	push   $0x804441
  80225c:	e8 9a 17 00 00       	call   8039fb <_panic>
  802261:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802267:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226a:	89 50 04             	mov    %edx,0x4(%eax)
  80226d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802270:	8b 40 04             	mov    0x4(%eax),%eax
  802273:	85 c0                	test   %eax,%eax
  802275:	74 0c                	je     802283 <alloc_block_FF+0x1e0>
  802277:	a1 30 50 80 00       	mov    0x805030,%eax
  80227c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	eb 08                	jmp    80228b <alloc_block_FF+0x1e8>
  802283:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802286:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228e:	a3 30 50 80 00       	mov    %eax,0x805030
  802293:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229c:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a1:	40                   	inc    %eax
  8022a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a7:	eb 6e                	jmp    802317 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ad:	74 06                	je     8022b5 <alloc_block_FF+0x212>
  8022af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022b3:	75 17                	jne    8022cc <alloc_block_FF+0x229>
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 b4 44 80 00       	push   $0x8044b4
  8022bd:	68 df 00 00 00       	push   $0xdf
  8022c2:	68 41 44 80 00       	push   $0x804441
  8022c7:	e8 2f 17 00 00       	call   8039fb <_panic>
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 10                	mov    (%eax),%edx
  8022d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 0b                	je     8022ea <alloc_block_FF+0x247>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f0:	89 10                	mov    %edx,(%eax)
  8022f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f8:	89 50 04             	mov    %edx,0x4(%eax)
  8022fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	75 08                	jne    80230c <alloc_block_FF+0x269>
  802304:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802307:	a3 30 50 80 00       	mov    %eax,0x805030
  80230c:	a1 38 50 80 00       	mov    0x805038,%eax
  802311:	40                   	inc    %eax
  802312:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	75 17                	jne    802334 <alloc_block_FF+0x291>
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 23 44 80 00       	push   $0x804423
  802325:	68 e1 00 00 00       	push   $0xe1
  80232a:	68 41 44 80 00       	push   $0x804441
  80232f:	e8 c7 16 00 00       	call   8039fb <_panic>
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 10                	je     80234d <alloc_block_FF+0x2aa>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 00                	mov    (%eax),%eax
  802342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802345:	8b 52 04             	mov    0x4(%edx),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	eb 0b                	jmp    802358 <alloc_block_FF+0x2b5>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	a3 30 50 80 00       	mov    %eax,0x805030
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 04             	mov    0x4(%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0f                	je     802371 <alloc_block_FF+0x2ce>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236b:	8b 12                	mov    (%edx),%edx
  80236d:	89 10                	mov    %edx,(%eax)
  80236f:	eb 0a                	jmp    80237b <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  802399:	83 ec 04             	sub    $0x4,%esp
  80239c:	6a 00                	push   $0x0
  80239e:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023a1:	ff 75 b0             	pushl  -0x50(%ebp)
  8023a4:	e8 cb fc ff ff       	call   802074 <set_block_data>
  8023a9:	83 c4 10             	add    $0x10,%esp
  8023ac:	e9 95 00 00 00       	jmp    802446 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	6a 01                	push   $0x1
  8023b6:	ff 75 b8             	pushl  -0x48(%ebp)
  8023b9:	ff 75 bc             	pushl  -0x44(%ebp)
  8023bc:	e8 b3 fc ff ff       	call   802074 <set_block_data>
  8023c1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c8:	75 17                	jne    8023e1 <alloc_block_FF+0x33e>
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 23 44 80 00       	push   $0x804423
  8023d2:	68 e8 00 00 00       	push   $0xe8
  8023d7:	68 41 44 80 00       	push   $0x804441
  8023dc:	e8 1a 16 00 00       	call   8039fb <_panic>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	74 10                	je     8023fa <alloc_block_FF+0x357>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f2:	8b 52 04             	mov    0x4(%edx),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	eb 0b                	jmp    802405 <alloc_block_FF+0x362>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 04             	mov    0x4(%eax),%eax
  802400:	a3 30 50 80 00       	mov    %eax,0x805030
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 04             	mov    0x4(%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 0f                	je     80241e <alloc_block_FF+0x37b>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 04             	mov    0x4(%eax),%eax
  802415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802418:	8b 12                	mov    (%edx),%edx
  80241a:	89 10                	mov    %edx,(%eax)
  80241c:	eb 0a                	jmp    802428 <alloc_block_FF+0x385>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243b:	a1 38 50 80 00       	mov    0x805038,%eax
  802440:	48                   	dec    %eax
  802441:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802446:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802449:	e9 0f 01 00 00       	jmp    80255d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80244e:	a1 34 50 80 00       	mov    0x805034,%eax
  802453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245a:	74 07                	je     802463 <alloc_block_FF+0x3c0>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	eb 05                	jmp    802468 <alloc_block_FF+0x3c5>
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	a3 34 50 80 00       	mov    %eax,0x805034
  80246d:	a1 34 50 80 00       	mov    0x805034,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	0f 85 e9 fc ff ff    	jne    802163 <alloc_block_FF+0xc0>
  80247a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247e:	0f 85 df fc ff ff    	jne    802163 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	83 c0 08             	add    $0x8,%eax
  80248a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80248d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802494:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249a:	01 d0                	add    %edx,%eax
  80249c:	48                   	dec    %eax
  80249d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a8:	f7 75 d8             	divl   -0x28(%ebp)
  8024ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ae:	29 d0                	sub    %edx,%eax
  8024b0:	c1 e8 0c             	shr    $0xc,%eax
  8024b3:	83 ec 0c             	sub    $0xc,%esp
  8024b6:	50                   	push   %eax
  8024b7:	e8 6f ec ff ff       	call   80112b <sbrk>
  8024bc:	83 c4 10             	add    $0x10,%esp
  8024bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024c2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024c6:	75 0a                	jne    8024d2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	e9 8b 00 00 00       	jmp    80255d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8024d2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	48                   	dec    %eax
  8024e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ed:	f7 75 cc             	divl   -0x34(%ebp)
  8024f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024f3:	29 d0                	sub    %edx,%eax
  8024f5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802502:	a1 40 50 80 00       	mov    0x805040,%eax
  802507:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80250d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802514:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802517:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80251a:	01 d0                	add    %edx,%eax
  80251c:	48                   	dec    %eax
  80251d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802520:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
  802528:	f7 75 c4             	divl   -0x3c(%ebp)
  80252b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80252e:	29 d0                	sub    %edx,%eax
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	6a 01                	push   $0x1
  802535:	50                   	push   %eax
  802536:	ff 75 d0             	pushl  -0x30(%ebp)
  802539:	e8 36 fb ff ff       	call   802074 <set_block_data>
  80253e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	ff 75 d0             	pushl  -0x30(%ebp)
  802547:	e8 f8 09 00 00       	call   802f44 <free_block>
  80254c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	ff 75 08             	pushl  0x8(%ebp)
  802555:	e8 49 fb ff ff       	call   8020a3 <alloc_block_FF>
  80255a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	83 e0 01             	and    $0x1,%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 03                	je     802572 <alloc_block_BF+0x13>
  80256f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802572:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802576:	77 07                	ja     80257f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802578:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80257f:	a1 24 50 80 00       	mov    0x805024,%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	75 73                	jne    8025fb <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	83 c0 10             	add    $0x10,%eax
  80258e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802591:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802598:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80259b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259e:	01 d0                	add    %edx,%eax
  8025a0:	48                   	dec    %eax
  8025a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ac:	f7 75 e0             	divl   -0x20(%ebp)
  8025af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b2:	29 d0                	sub    %edx,%eax
  8025b4:	c1 e8 0c             	shr    $0xc,%eax
  8025b7:	83 ec 0c             	sub    $0xc,%esp
  8025ba:	50                   	push   %eax
  8025bb:	e8 6b eb ff ff       	call   80112b <sbrk>
  8025c0:	83 c4 10             	add    $0x10,%esp
  8025c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025c6:	83 ec 0c             	sub    $0xc,%esp
  8025c9:	6a 00                	push   $0x0
  8025cb:	e8 5b eb ff ff       	call   80112b <sbrk>
  8025d0:	83 c4 10             	add    $0x10,%esp
  8025d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025d9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025dc:	83 ec 08             	sub    $0x8,%esp
  8025df:	50                   	push   %eax
  8025e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8025e3:	e8 9f f8 ff ff       	call   801e87 <initialize_dynamic_allocator>
  8025e8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	68 7f 44 80 00       	push   $0x80447f
  8025f3:	e8 99 dd ff ff       	call   800391 <cprintf>
  8025f8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8025fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802602:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802609:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802610:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802617:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80261c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261f:	e9 1d 01 00 00       	jmp    802741 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	ff 75 a8             	pushl  -0x58(%ebp)
  802630:	e8 ee f6 ff ff       	call   801d23 <get_block_size>
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	83 c0 08             	add    $0x8,%eax
  802641:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802644:	0f 87 ef 00 00 00    	ja     802739 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	83 c0 18             	add    $0x18,%eax
  802650:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802653:	77 1d                	ja     802672 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802658:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80265b:	0f 86 d8 00 00 00    	jbe    802739 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802661:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802664:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802667:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80266a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80266d:	e9 c7 00 00 00       	jmp    802739 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	83 c0 08             	add    $0x8,%eax
  802678:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80267b:	0f 85 9d 00 00 00    	jne    80271e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	6a 01                	push   $0x1
  802686:	ff 75 a4             	pushl  -0x5c(%ebp)
  802689:	ff 75 a8             	pushl  -0x58(%ebp)
  80268c:	e8 e3 f9 ff ff       	call   802074 <set_block_data>
  802691:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	75 17                	jne    8026b1 <alloc_block_BF+0x152>
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 23 44 80 00       	push   $0x804423
  8026a2:	68 2c 01 00 00       	push   $0x12c
  8026a7:	68 41 44 80 00       	push   $0x804441
  8026ac:	e8 4a 13 00 00       	call   8039fb <_panic>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 10                	je     8026ca <alloc_block_BF+0x16b>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	8b 52 04             	mov    0x4(%edx),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 0b                	jmp    8026d5 <alloc_block_BF+0x176>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0f                	je     8026ee <alloc_block_BF+0x18f>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e8:	8b 12                	mov    (%edx),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	eb 0a                	jmp    8026f8 <alloc_block_BF+0x199>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270b:	a1 38 50 80 00       	mov    0x805038,%eax
  802710:	48                   	dec    %eax
  802711:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802716:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802719:	e9 01 04 00 00       	jmp    802b1f <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80271e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802721:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802724:	76 13                	jbe    802739 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802726:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80272d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802730:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802733:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802736:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802739:	a1 34 50 80 00       	mov    0x805034,%eax
  80273e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802745:	74 07                	je     80274e <alloc_block_BF+0x1ef>
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	eb 05                	jmp    802753 <alloc_block_BF+0x1f4>
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
  802753:	a3 34 50 80 00       	mov    %eax,0x805034
  802758:	a1 34 50 80 00       	mov    0x805034,%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	0f 85 bf fe ff ff    	jne    802624 <alloc_block_BF+0xc5>
  802765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802769:	0f 85 b5 fe ff ff    	jne    802624 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80276f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802773:	0f 84 26 02 00 00    	je     80299f <alloc_block_BF+0x440>
  802779:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80277d:	0f 85 1c 02 00 00    	jne    80299f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802786:	2b 45 08             	sub    0x8(%ebp),%eax
  802789:	83 e8 08             	sub    $0x8,%eax
  80278c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8d 50 08             	lea    0x8(%eax),%edx
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	01 d0                	add    %edx,%eax
  80279a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	83 c0 08             	add    $0x8,%eax
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	6a 01                	push   $0x1
  8027a8:	50                   	push   %eax
  8027a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ac:	e8 c3 f8 ff ff       	call   802074 <set_block_data>
  8027b1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	75 68                	jne    802826 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027be:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027c2:	75 17                	jne    8027db <alloc_block_BF+0x27c>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 5c 44 80 00       	push   $0x80445c
  8027cc:	68 45 01 00 00       	push   $0x145
  8027d1:	68 41 44 80 00       	push   $0x804441
  8027d6:	e8 20 12 00 00       	call   8039fb <_panic>
  8027db:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e4:	89 10                	mov    %edx,(%eax)
  8027e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 0d                	je     8027fc <alloc_block_BF+0x29d>
  8027ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027f4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f7:	89 50 04             	mov    %edx,0x4(%eax)
  8027fa:	eb 08                	jmp    802804 <alloc_block_BF+0x2a5>
  8027fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802804:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802807:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80280c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802816:	a1 38 50 80 00       	mov    0x805038,%eax
  80281b:	40                   	inc    %eax
  80281c:	a3 38 50 80 00       	mov    %eax,0x805038
  802821:	e9 dc 00 00 00       	jmp    802902 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	75 65                	jne    802894 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80282f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802833:	75 17                	jne    80284c <alloc_block_BF+0x2ed>
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	68 90 44 80 00       	push   $0x804490
  80283d:	68 4a 01 00 00       	push   $0x14a
  802842:	68 41 44 80 00       	push   $0x804441
  802847:	e8 af 11 00 00       	call   8039fb <_panic>
  80284c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802852:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802855:	89 50 04             	mov    %edx,0x4(%eax)
  802858:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 0c                	je     80286e <alloc_block_BF+0x30f>
  802862:	a1 30 50 80 00       	mov    0x805030,%eax
  802867:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80286a:	89 10                	mov    %edx,(%eax)
  80286c:	eb 08                	jmp    802876 <alloc_block_BF+0x317>
  80286e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802871:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802876:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802879:	a3 30 50 80 00       	mov    %eax,0x805030
  80287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802887:	a1 38 50 80 00       	mov    0x805038,%eax
  80288c:	40                   	inc    %eax
  80288d:	a3 38 50 80 00       	mov    %eax,0x805038
  802892:	eb 6e                	jmp    802902 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802898:	74 06                	je     8028a0 <alloc_block_BF+0x341>
  80289a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80289e:	75 17                	jne    8028b7 <alloc_block_BF+0x358>
  8028a0:	83 ec 04             	sub    $0x4,%esp
  8028a3:	68 b4 44 80 00       	push   $0x8044b4
  8028a8:	68 4f 01 00 00       	push   $0x14f
  8028ad:	68 41 44 80 00       	push   $0x804441
  8028b2:	e8 44 11 00 00       	call   8039fb <_panic>
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 10                	mov    (%eax),%edx
  8028bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028bf:	89 10                	mov    %edx,(%eax)
  8028c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 0b                	je     8028d5 <alloc_block_BF+0x376>
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028d2:	89 50 04             	mov    %edx,0x4(%eax)
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028db:	89 10                	mov    %edx,(%eax)
  8028dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	75 08                	jne    8028f7 <alloc_block_BF+0x398>
  8028ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fc:	40                   	inc    %eax
  8028fd:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802902:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802906:	75 17                	jne    80291f <alloc_block_BF+0x3c0>
  802908:	83 ec 04             	sub    $0x4,%esp
  80290b:	68 23 44 80 00       	push   $0x804423
  802910:	68 51 01 00 00       	push   $0x151
  802915:	68 41 44 80 00       	push   $0x804441
  80291a:	e8 dc 10 00 00       	call   8039fb <_panic>
  80291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 10                	je     802938 <alloc_block_BF+0x3d9>
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802930:	8b 52 04             	mov    0x4(%edx),%edx
  802933:	89 50 04             	mov    %edx,0x4(%eax)
  802936:	eb 0b                	jmp    802943 <alloc_block_BF+0x3e4>
  802938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	a3 30 50 80 00       	mov    %eax,0x805030
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 0f                	je     80295c <alloc_block_BF+0x3fd>
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 40 04             	mov    0x4(%eax),%eax
  802953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802956:	8b 12                	mov    (%edx),%edx
  802958:	89 10                	mov    %edx,(%eax)
  80295a:	eb 0a                	jmp    802966 <alloc_block_BF+0x407>
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802979:	a1 38 50 80 00       	mov    0x805038,%eax
  80297e:	48                   	dec    %eax
  80297f:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802984:	83 ec 04             	sub    $0x4,%esp
  802987:	6a 00                	push   $0x0
  802989:	ff 75 d0             	pushl  -0x30(%ebp)
  80298c:	ff 75 cc             	pushl  -0x34(%ebp)
  80298f:	e8 e0 f6 ff ff       	call   802074 <set_block_data>
  802994:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	e9 80 01 00 00       	jmp    802b1f <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80299f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029a3:	0f 85 9d 00 00 00    	jne    802a46 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	6a 01                	push   $0x1
  8029ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8029b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8029b4:	e8 bb f6 ff ff       	call   802074 <set_block_data>
  8029b9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_BF+0x47a>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 23 44 80 00       	push   $0x804423
  8029ca:	68 58 01 00 00       	push   $0x158
  8029cf:	68 41 44 80 00       	push   $0x804441
  8029d4:	e8 22 10 00 00       	call   8039fb <_panic>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 10                	je     8029f2 <alloc_block_BF+0x493>
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ea:	8b 52 04             	mov    0x4(%edx),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	eb 0b                	jmp    8029fd <alloc_block_BF+0x49e>
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0f                	je     802a16 <alloc_block_BF+0x4b7>
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a10:	8b 12                	mov    (%edx),%edx
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	eb 0a                	jmp    802a20 <alloc_block_BF+0x4c1>
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a33:	a1 38 50 80 00       	mov    0x805038,%eax
  802a38:	48                   	dec    %eax
  802a39:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	e9 d9 00 00 00       	jmp    802b1f <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	83 c0 08             	add    $0x8,%eax
  802a4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a4f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a56:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a65:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6a:	f7 75 c4             	divl   -0x3c(%ebp)
  802a6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a70:	29 d0                	sub    %edx,%eax
  802a72:	c1 e8 0c             	shr    $0xc,%eax
  802a75:	83 ec 0c             	sub    $0xc,%esp
  802a78:	50                   	push   %eax
  802a79:	e8 ad e6 ff ff       	call   80112b <sbrk>
  802a7e:	83 c4 10             	add    $0x10,%esp
  802a81:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a84:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a88:	75 0a                	jne    802a94 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	e9 8b 00 00 00       	jmp    802b1f <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a94:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a9b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a9e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	48                   	dec    %eax
  802aa4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802aa7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aaf:	f7 75 b8             	divl   -0x48(%ebp)
  802ab2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ab5:	29 d0                	sub    %edx,%eax
  802ab7:	8d 50 fc             	lea    -0x4(%eax),%edx
  802aba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802abd:	01 d0                	add    %edx,%eax
  802abf:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ac4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802acf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ad6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ad9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adc:	01 d0                	add    %edx,%eax
  802ade:	48                   	dec    %eax
  802adf:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ae2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aea:	f7 75 b0             	divl   -0x50(%ebp)
  802aed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802af0:	29 d0                	sub    %edx,%eax
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	6a 01                	push   $0x1
  802af7:	50                   	push   %eax
  802af8:	ff 75 bc             	pushl  -0x44(%ebp)
  802afb:	e8 74 f5 ff ff       	call   802074 <set_block_data>
  802b00:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	ff 75 bc             	pushl  -0x44(%ebp)
  802b09:	e8 36 04 00 00       	call   802f44 <free_block>
  802b0e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b11:	83 ec 0c             	sub    $0xc,%esp
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	e8 43 fa ff ff       	call   80255f <alloc_block_BF>
  802b1c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
  802b24:	53                   	push   %ebx
  802b25:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3a:	74 1e                	je     802b5a <merging+0x39>
  802b3c:	ff 75 08             	pushl  0x8(%ebp)
  802b3f:	e8 df f1 ff ff       	call   801d23 <get_block_size>
  802b44:	83 c4 04             	add    $0x4,%esp
  802b47:	89 c2                	mov    %eax,%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	01 d0                	add    %edx,%eax
  802b4e:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b51:	75 07                	jne    802b5a <merging+0x39>
		prev_is_free = 1;
  802b53:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b5e:	74 1e                	je     802b7e <merging+0x5d>
  802b60:	ff 75 10             	pushl  0x10(%ebp)
  802b63:	e8 bb f1 ff ff       	call   801d23 <get_block_size>
  802b68:	83 c4 04             	add    $0x4,%esp
  802b6b:	89 c2                	mov    %eax,%edx
  802b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802b70:	01 d0                	add    %edx,%eax
  802b72:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b75:	75 07                	jne    802b7e <merging+0x5d>
		next_is_free = 1;
  802b77:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b82:	0f 84 cc 00 00 00    	je     802c54 <merging+0x133>
  802b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8c:	0f 84 c2 00 00 00    	je     802c54 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b92:	ff 75 08             	pushl  0x8(%ebp)
  802b95:	e8 89 f1 ff ff       	call   801d23 <get_block_size>
  802b9a:	83 c4 04             	add    $0x4,%esp
  802b9d:	89 c3                	mov    %eax,%ebx
  802b9f:	ff 75 10             	pushl  0x10(%ebp)
  802ba2:	e8 7c f1 ff ff       	call   801d23 <get_block_size>
  802ba7:	83 c4 04             	add    $0x4,%esp
  802baa:	01 c3                	add    %eax,%ebx
  802bac:	ff 75 0c             	pushl  0xc(%ebp)
  802baf:	e8 6f f1 ff ff       	call   801d23 <get_block_size>
  802bb4:	83 c4 04             	add    $0x4,%esp
  802bb7:	01 d8                	add    %ebx,%eax
  802bb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc1:	ff 75 08             	pushl  0x8(%ebp)
  802bc4:	e8 ab f4 ff ff       	call   802074 <set_block_data>
  802bc9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd0:	75 17                	jne    802be9 <merging+0xc8>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 23 44 80 00       	push   $0x804423
  802bda:	68 7d 01 00 00       	push   $0x17d
  802bdf:	68 41 44 80 00       	push   $0x804441
  802be4:	e8 12 0e 00 00       	call   8039fb <_panic>
  802be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 10                	je     802c02 <merging+0xe1>
  802bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfa:	8b 52 04             	mov    0x4(%edx),%edx
  802bfd:	89 50 04             	mov    %edx,0x4(%eax)
  802c00:	eb 0b                	jmp    802c0d <merging+0xec>
  802c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0f                	je     802c26 <merging+0x105>
  802c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c20:	8b 12                	mov    (%edx),%edx
  802c22:	89 10                	mov    %edx,(%eax)
  802c24:	eb 0a                	jmp    802c30 <merging+0x10f>
  802c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c43:	a1 38 50 80 00       	mov    0x805038,%eax
  802c48:	48                   	dec    %eax
  802c49:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c4e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c4f:	e9 ea 02 00 00       	jmp    802f3e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c58:	74 3b                	je     802c95 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c5a:	83 ec 0c             	sub    $0xc,%esp
  802c5d:	ff 75 08             	pushl  0x8(%ebp)
  802c60:	e8 be f0 ff ff       	call   801d23 <get_block_size>
  802c65:	83 c4 10             	add    $0x10,%esp
  802c68:	89 c3                	mov    %eax,%ebx
  802c6a:	83 ec 0c             	sub    $0xc,%esp
  802c6d:	ff 75 10             	pushl  0x10(%ebp)
  802c70:	e8 ae f0 ff ff       	call   801d23 <get_block_size>
  802c75:	83 c4 10             	add    $0x10,%esp
  802c78:	01 d8                	add    %ebx,%eax
  802c7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	6a 00                	push   $0x0
  802c82:	ff 75 e8             	pushl  -0x18(%ebp)
  802c85:	ff 75 08             	pushl  0x8(%ebp)
  802c88:	e8 e7 f3 ff ff       	call   802074 <set_block_data>
  802c8d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c90:	e9 a9 02 00 00       	jmp    802f3e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c99:	0f 84 2d 01 00 00    	je     802dcc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c9f:	83 ec 0c             	sub    $0xc,%esp
  802ca2:	ff 75 10             	pushl  0x10(%ebp)
  802ca5:	e8 79 f0 ff ff       	call   801d23 <get_block_size>
  802caa:	83 c4 10             	add    $0x10,%esp
  802cad:	89 c3                	mov    %eax,%ebx
  802caf:	83 ec 0c             	sub    $0xc,%esp
  802cb2:	ff 75 0c             	pushl  0xc(%ebp)
  802cb5:	e8 69 f0 ff ff       	call   801d23 <get_block_size>
  802cba:	83 c4 10             	add    $0x10,%esp
  802cbd:	01 d8                	add    %ebx,%eax
  802cbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802cc2:	83 ec 04             	sub    $0x4,%esp
  802cc5:	6a 00                	push   $0x0
  802cc7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cca:	ff 75 10             	pushl  0x10(%ebp)
  802ccd:	e8 a2 f3 ff ff       	call   802074 <set_block_data>
  802cd2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  802cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cdf:	74 06                	je     802ce7 <merging+0x1c6>
  802ce1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ce5:	75 17                	jne    802cfe <merging+0x1dd>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 e8 44 80 00       	push   $0x8044e8
  802cef:	68 8d 01 00 00       	push   $0x18d
  802cf4:	68 41 44 80 00       	push   $0x804441
  802cf9:	e8 fd 0c 00 00       	call   8039fb <_panic>
  802cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d01:	8b 50 04             	mov    0x4(%eax),%edx
  802d04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d07:	89 50 04             	mov    %edx,0x4(%eax)
  802d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <merging+0x208>
  802d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 08                	jmp    802d31 <merging+0x210>
  802d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d37:	89 50 04             	mov    %edx,0x4(%eax)
  802d3a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3f:	40                   	inc    %eax
  802d40:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d49:	75 17                	jne    802d62 <merging+0x241>
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	68 23 44 80 00       	push   $0x804423
  802d53:	68 8e 01 00 00       	push   $0x18e
  802d58:	68 41 44 80 00       	push   $0x804441
  802d5d:	e8 99 0c 00 00       	call   8039fb <_panic>
  802d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 10                	je     802d7b <merging+0x25a>
  802d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d73:	8b 52 04             	mov    0x4(%edx),%edx
  802d76:	89 50 04             	mov    %edx,0x4(%eax)
  802d79:	eb 0b                	jmp    802d86 <merging+0x265>
  802d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	a3 30 50 80 00       	mov    %eax,0x805030
  802d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 0f                	je     802d9f <merging+0x27e>
  802d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d99:	8b 12                	mov    (%edx),%edx
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	eb 0a                	jmp    802da9 <merging+0x288>
  802d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc1:	48                   	dec    %eax
  802dc2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dc7:	e9 72 01 00 00       	jmp    802f3e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  802dcf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802dd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd6:	74 79                	je     802e51 <merging+0x330>
  802dd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ddc:	74 73                	je     802e51 <merging+0x330>
  802dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de2:	74 06                	je     802dea <merging+0x2c9>
  802de4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802de8:	75 17                	jne    802e01 <merging+0x2e0>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 b4 44 80 00       	push   $0x8044b4
  802df2:	68 94 01 00 00       	push   $0x194
  802df7:	68 41 44 80 00       	push   $0x804441
  802dfc:	e8 fa 0b 00 00       	call   8039fb <_panic>
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 10                	mov    (%eax),%edx
  802e06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 0b                	je     802e1f <merging+0x2fe>
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2d:	89 50 04             	mov    %edx,0x4(%eax)
  802e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	75 08                	jne    802e41 <merging+0x320>
  802e39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3c:	a3 30 50 80 00       	mov    %eax,0x805030
  802e41:	a1 38 50 80 00       	mov    0x805038,%eax
  802e46:	40                   	inc    %eax
  802e47:	a3 38 50 80 00       	mov    %eax,0x805038
  802e4c:	e9 ce 00 00 00       	jmp    802f1f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e55:	74 65                	je     802ebc <merging+0x39b>
  802e57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5b:	75 17                	jne    802e74 <merging+0x353>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 90 44 80 00       	push   $0x804490
  802e65:	68 95 01 00 00       	push   $0x195
  802e6a:	68 41 44 80 00       	push   $0x804441
  802e6f:	e8 87 0b 00 00       	call   8039fb <_panic>
  802e74:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 0c                	je     802e96 <merging+0x375>
  802e8a:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 08                	jmp    802e9e <merging+0x37d>
  802e96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e99:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eaf:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb4:	40                   	inc    %eax
  802eb5:	a3 38 50 80 00       	mov    %eax,0x805038
  802eba:	eb 63                	jmp    802f1f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802ebc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ec0:	75 17                	jne    802ed9 <merging+0x3b8>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 5c 44 80 00       	push   $0x80445c
  802eca:	68 98 01 00 00       	push   $0x198
  802ecf:	68 41 44 80 00       	push   $0x804441
  802ed4:	e8 22 0b 00 00       	call   8039fb <_panic>
  802ed9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee2:	89 10                	mov    %edx,(%eax)
  802ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 0d                	je     802efa <merging+0x3d9>
  802eed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 08                	jmp    802f02 <merging+0x3e1>
  802efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802efd:	a3 30 50 80 00       	mov    %eax,0x805030
  802f02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f05:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f14:	a1 38 50 80 00       	mov    0x805038,%eax
  802f19:	40                   	inc    %eax
  802f1a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 10             	pushl  0x10(%ebp)
  802f25:	e8 f9 ed ff ff       	call   801d23 <get_block_size>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	83 ec 04             	sub    $0x4,%esp
  802f30:	6a 00                	push   $0x0
  802f32:	50                   	push   %eax
  802f33:	ff 75 10             	pushl  0x10(%ebp)
  802f36:	e8 39 f1 ff ff       	call   802074 <set_block_data>
  802f3b:	83 c4 10             	add    $0x10,%esp
	}
}
  802f3e:	90                   	nop
  802f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f4a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f52:	a1 30 50 80 00       	mov    0x805030,%eax
  802f57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5a:	73 1b                	jae    802f77 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f5c:	a1 30 50 80 00       	mov    0x805030,%eax
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	ff 75 08             	pushl  0x8(%ebp)
  802f67:	6a 00                	push   $0x0
  802f69:	50                   	push   %eax
  802f6a:	e8 b2 fb ff ff       	call   802b21 <merging>
  802f6f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f72:	e9 8b 00 00 00       	jmp    803002 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f77:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7f:	76 18                	jbe    802f99 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f81:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	ff 75 08             	pushl  0x8(%ebp)
  802f8c:	50                   	push   %eax
  802f8d:	6a 00                	push   $0x0
  802f8f:	e8 8d fb ff ff       	call   802b21 <merging>
  802f94:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f97:	eb 69                	jmp    803002 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f99:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa1:	eb 39                	jmp    802fdc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fa9:	73 29                	jae    802fd4 <free_block+0x90>
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb3:	76 1f                	jbe    802fd4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802fbd:	83 ec 04             	sub    $0x4,%esp
  802fc0:	ff 75 08             	pushl  0x8(%ebp)
  802fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc9:	e8 53 fb ff ff       	call   802b21 <merging>
  802fce:	83 c4 10             	add    $0x10,%esp
			break;
  802fd1:	90                   	nop
		}
	}
}
  802fd2:	eb 2e                	jmp    803002 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fd4:	a1 34 50 80 00       	mov    0x805034,%eax
  802fd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe0:	74 07                	je     802fe9 <free_block+0xa5>
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	eb 05                	jmp    802fee <free_block+0xaa>
  802fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fee:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff3:	a1 34 50 80 00       	mov    0x805034,%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	75 a7                	jne    802fa3 <free_block+0x5f>
  802ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803000:	75 a1                	jne    802fa3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803002:	90                   	nop
  803003:	c9                   	leave  
  803004:	c3                   	ret    

00803005 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803005:	55                   	push   %ebp
  803006:	89 e5                	mov    %esp,%ebp
  803008:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	e8 10 ed ff ff       	call   801d23 <get_block_size>
  803013:	83 c4 04             	add    $0x4,%esp
  803016:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803019:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803020:	eb 17                	jmp    803039 <copy_data+0x34>
  803022:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803025:	8b 45 0c             	mov    0xc(%ebp),%eax
  803028:	01 c2                	add    %eax,%edx
  80302a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	01 c8                	add    %ecx,%eax
  803032:	8a 00                	mov    (%eax),%al
  803034:	88 02                	mov    %al,(%edx)
  803036:	ff 45 fc             	incl   -0x4(%ebp)
  803039:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80303c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80303f:	72 e1                	jb     803022 <copy_data+0x1d>
}
  803041:	90                   	nop
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
  803047:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80304a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304e:	75 23                	jne    803073 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803050:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803054:	74 13                	je     803069 <realloc_block_FF+0x25>
  803056:	83 ec 0c             	sub    $0xc,%esp
  803059:	ff 75 0c             	pushl  0xc(%ebp)
  80305c:	e8 42 f0 ff ff       	call   8020a3 <alloc_block_FF>
  803061:	83 c4 10             	add    $0x10,%esp
  803064:	e9 e4 06 00 00       	jmp    80374d <realloc_block_FF+0x709>
		return NULL;
  803069:	b8 00 00 00 00       	mov    $0x0,%eax
  80306e:	e9 da 06 00 00       	jmp    80374d <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803073:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803077:	75 18                	jne    803091 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803079:	83 ec 0c             	sub    $0xc,%esp
  80307c:	ff 75 08             	pushl  0x8(%ebp)
  80307f:	e8 c0 fe ff ff       	call   802f44 <free_block>
  803084:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803087:	b8 00 00 00 00       	mov    $0x0,%eax
  80308c:	e9 bc 06 00 00       	jmp    80374d <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803091:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803095:	77 07                	ja     80309e <realloc_block_FF+0x5a>
  803097:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a1:	83 e0 01             	and    $0x1,%eax
  8030a4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030aa:	83 c0 08             	add    $0x8,%eax
  8030ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	ff 75 08             	pushl  0x8(%ebp)
  8030b6:	e8 68 ec ff ff       	call   801d23 <get_block_size>
  8030bb:	83 c4 10             	add    $0x10,%esp
  8030be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c4:	83 e8 08             	sub    $0x8,%eax
  8030c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	83 e8 04             	sub    $0x4,%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8030d5:	89 c2                	mov    %eax,%edx
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	01 d0                	add    %edx,%eax
  8030dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8030df:	83 ec 0c             	sub    $0xc,%esp
  8030e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030e5:	e8 39 ec ff ff       	call   801d23 <get_block_size>
  8030ea:	83 c4 10             	add    $0x10,%esp
  8030ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f3:	83 e8 08             	sub    $0x8,%eax
  8030f6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030ff:	75 08                	jne    803109 <realloc_block_FF+0xc5>
	{
		 return va;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	e9 44 06 00 00       	jmp    80374d <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80310f:	0f 83 d5 03 00 00    	jae    8034ea <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	2b 45 0c             	sub    0xc(%ebp),%eax
  80311b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80311e:	83 ec 0c             	sub    $0xc,%esp
  803121:	ff 75 e4             	pushl  -0x1c(%ebp)
  803124:	e8 13 ec ff ff       	call   801d3c <is_free_block>
  803129:	83 c4 10             	add    $0x10,%esp
  80312c:	84 c0                	test   %al,%al
  80312e:	0f 84 3b 01 00 00    	je     80326f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803134:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803137:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80313a:	01 d0                	add    %edx,%eax
  80313c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	6a 01                	push   $0x1
  803144:	ff 75 f0             	pushl  -0x10(%ebp)
  803147:	ff 75 08             	pushl  0x8(%ebp)
  80314a:	e8 25 ef ff ff       	call   802074 <set_block_data>
  80314f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	83 e8 04             	sub    $0x4,%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	83 e0 fe             	and    $0xfffffffe,%eax
  80315d:	89 c2                	mov    %eax,%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	01 d0                	add    %edx,%eax
  803164:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	6a 00                	push   $0x0
  80316c:	ff 75 cc             	pushl  -0x34(%ebp)
  80316f:	ff 75 c8             	pushl  -0x38(%ebp)
  803172:	e8 fd ee ff ff       	call   802074 <set_block_data>
  803177:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80317a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317e:	74 06                	je     803186 <realloc_block_FF+0x142>
  803180:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803184:	75 17                	jne    80319d <realloc_block_FF+0x159>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 b4 44 80 00       	push   $0x8044b4
  80318e:	68 f6 01 00 00       	push   $0x1f6
  803193:	68 41 44 80 00       	push   $0x804441
  803198:	e8 5e 08 00 00       	call   8039fb <_panic>
  80319d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a0:	8b 10                	mov    (%eax),%edx
  8031a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031a5:	89 10                	mov    %edx,(%eax)
  8031a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	74 0b                	je     8031bb <realloc_block_FF+0x177>
  8031b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031b8:	89 50 04             	mov    %edx,0x4(%eax)
  8031bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031c1:	89 10                	mov    %edx,(%eax)
  8031c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031c9:	89 50 04             	mov    %edx,0x4(%eax)
  8031cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	75 08                	jne    8031dd <realloc_block_FF+0x199>
  8031d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e2:	40                   	inc    %eax
  8031e3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8031e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031ec:	75 17                	jne    803205 <realloc_block_FF+0x1c1>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 23 44 80 00       	push   $0x804423
  8031f6:	68 f7 01 00 00       	push   $0x1f7
  8031fb:	68 41 44 80 00       	push   $0x804441
  803200:	e8 f6 07 00 00       	call   8039fb <_panic>
  803205:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 10                	je     80321e <realloc_block_FF+0x1da>
  80320e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803216:	8b 52 04             	mov    0x4(%edx),%edx
  803219:	89 50 04             	mov    %edx,0x4(%eax)
  80321c:	eb 0b                	jmp    803229 <realloc_block_FF+0x1e5>
  80321e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803221:	8b 40 04             	mov    0x4(%eax),%eax
  803224:	a3 30 50 80 00       	mov    %eax,0x805030
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 0f                	je     803242 <realloc_block_FF+0x1fe>
  803233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323c:	8b 12                	mov    (%edx),%edx
  80323e:	89 10                	mov    %edx,(%eax)
  803240:	eb 0a                	jmp    80324c <realloc_block_FF+0x208>
  803242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325f:	a1 38 50 80 00       	mov    0x805038,%eax
  803264:	48                   	dec    %eax
  803265:	a3 38 50 80 00       	mov    %eax,0x805038
  80326a:	e9 73 02 00 00       	jmp    8034e2 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80326f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803273:	0f 86 69 02 00 00    	jbe    8034e2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803279:	83 ec 04             	sub    $0x4,%esp
  80327c:	6a 01                	push   $0x1
  80327e:	ff 75 f0             	pushl  -0x10(%ebp)
  803281:	ff 75 08             	pushl  0x8(%ebp)
  803284:	e8 eb ed ff ff       	call   802074 <set_block_data>
  803289:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	83 e8 04             	sub    $0x4,%eax
  803292:	8b 00                	mov    (%eax),%eax
  803294:	83 e0 fe             	and    $0xfffffffe,%eax
  803297:	89 c2                	mov    %eax,%edx
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	01 d0                	add    %edx,%eax
  80329e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8032a9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032ad:	75 68                	jne    803317 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b3:	75 17                	jne    8032cc <realloc_block_FF+0x288>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 5c 44 80 00       	push   $0x80445c
  8032bd:	68 06 02 00 00       	push   $0x206
  8032c2:	68 41 44 80 00       	push   $0x804441
  8032c7:	e8 2f 07 00 00       	call   8039fb <_panic>
  8032cc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0d                	je     8032ed <realloc_block_FF+0x2a9>
  8032e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 08                	jmp    8032f5 <realloc_block_FF+0x2b1>
  8032ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803307:	a1 38 50 80 00       	mov    0x805038,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 38 50 80 00       	mov    %eax,0x805038
  803312:	e9 b0 01 00 00       	jmp    8034c7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803317:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80331c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80331f:	76 68                	jbe    803389 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803325:	75 17                	jne    80333e <realloc_block_FF+0x2fa>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 5c 44 80 00       	push   $0x80445c
  80332f:	68 0b 02 00 00       	push   $0x20b
  803334:	68 41 44 80 00       	push   $0x804441
  803339:	e8 bd 06 00 00       	call   8039fb <_panic>
  80333e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803347:	89 10                	mov    %edx,(%eax)
  803349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0d                	je     80335f <realloc_block_FF+0x31b>
  803352:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 08                	jmp    803367 <realloc_block_FF+0x323>
  80335f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803362:	a3 30 50 80 00       	mov    %eax,0x805030
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803379:	a1 38 50 80 00       	mov    0x805038,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 38 50 80 00       	mov    %eax,0x805038
  803384:	e9 3e 01 00 00       	jmp    8034c7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803389:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803391:	73 68                	jae    8033fb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803393:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803397:	75 17                	jne    8033b0 <realloc_block_FF+0x36c>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 90 44 80 00       	push   $0x804490
  8033a1:	68 10 02 00 00       	push   $0x210
  8033a6:	68 41 44 80 00       	push   $0x804441
  8033ab:	e8 4b 06 00 00       	call   8039fb <_panic>
  8033b0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	74 0c                	je     8033d2 <realloc_block_FF+0x38e>
  8033c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8033cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ce:	89 10                	mov    %edx,(%eax)
  8033d0:	eb 08                	jmp    8033da <realloc_block_FF+0x396>
  8033d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f6:	e9 cc 00 00 00       	jmp    8034c7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8033fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803402:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340a:	e9 8a 00 00 00       	jmp    803499 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803415:	73 7a                	jae    803491 <realloc_block_FF+0x44d>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 00                	mov    (%eax),%eax
  80341c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80341f:	73 70                	jae    803491 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803425:	74 06                	je     80342d <realloc_block_FF+0x3e9>
  803427:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342b:	75 17                	jne    803444 <realloc_block_FF+0x400>
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 b4 44 80 00       	push   $0x8044b4
  803435:	68 1a 02 00 00       	push   $0x21a
  80343a:	68 41 44 80 00       	push   $0x804441
  80343f:	e8 b7 05 00 00       	call   8039fb <_panic>
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	8b 10                	mov    (%eax),%edx
  803449:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0b                	je     803462 <realloc_block_FF+0x41e>
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345f:	89 50 04             	mov    %edx,0x4(%eax)
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	75 08                	jne    803484 <realloc_block_FF+0x440>
  80347c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347f:	a3 30 50 80 00       	mov    %eax,0x805030
  803484:	a1 38 50 80 00       	mov    0x805038,%eax
  803489:	40                   	inc    %eax
  80348a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80348f:	eb 36                	jmp    8034c7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803491:	a1 34 50 80 00       	mov    0x805034,%eax
  803496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349d:	74 07                	je     8034a6 <realloc_block_FF+0x462>
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	eb 05                	jmp    8034ab <realloc_block_FF+0x467>
  8034a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ab:	a3 34 50 80 00       	mov    %eax,0x805034
  8034b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	0f 85 52 ff ff ff    	jne    80340f <realloc_block_FF+0x3cb>
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	0f 85 48 ff ff ff    	jne    80340f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034c7:	83 ec 04             	sub    $0x4,%esp
  8034ca:	6a 00                	push   $0x0
  8034cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8034cf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034d2:	e8 9d eb ff ff       	call   802074 <set_block_data>
  8034d7:	83 c4 10             	add    $0x10,%esp
				return va;
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	e9 6b 02 00 00       	jmp    80374d <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	e9 63 02 00 00       	jmp    80374d <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8034ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034f0:	0f 86 4d 02 00 00    	jbe    803743 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8034f6:	83 ec 0c             	sub    $0xc,%esp
  8034f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034fc:	e8 3b e8 ff ff       	call   801d3c <is_free_block>
  803501:	83 c4 10             	add    $0x10,%esp
  803504:	84 c0                	test   %al,%al
  803506:	0f 84 37 02 00 00    	je     803743 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80350c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803512:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803515:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803518:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80351b:	76 38                	jbe    803555 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80351d:	83 ec 0c             	sub    $0xc,%esp
  803520:	ff 75 0c             	pushl  0xc(%ebp)
  803523:	e8 7b eb ff ff       	call   8020a3 <alloc_block_FF>
  803528:	83 c4 10             	add    $0x10,%esp
  80352b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80352e:	83 ec 08             	sub    $0x8,%esp
  803531:	ff 75 c0             	pushl  -0x40(%ebp)
  803534:	ff 75 08             	pushl  0x8(%ebp)
  803537:	e8 c9 fa ff ff       	call   803005 <copy_data>
  80353c:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80353f:	83 ec 0c             	sub    $0xc,%esp
  803542:	ff 75 08             	pushl  0x8(%ebp)
  803545:	e8 fa f9 ff ff       	call   802f44 <free_block>
  80354a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80354d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803550:	e9 f8 01 00 00       	jmp    80374d <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803558:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80355b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80355e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803562:	0f 87 a0 00 00 00    	ja     803608 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356c:	75 17                	jne    803585 <realloc_block_FF+0x541>
  80356e:	83 ec 04             	sub    $0x4,%esp
  803571:	68 23 44 80 00       	push   $0x804423
  803576:	68 38 02 00 00       	push   $0x238
  80357b:	68 41 44 80 00       	push   $0x804441
  803580:	e8 76 04 00 00       	call   8039fb <_panic>
  803585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803588:	8b 00                	mov    (%eax),%eax
  80358a:	85 c0                	test   %eax,%eax
  80358c:	74 10                	je     80359e <realloc_block_FF+0x55a>
  80358e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803596:	8b 52 04             	mov    0x4(%edx),%edx
  803599:	89 50 04             	mov    %edx,0x4(%eax)
  80359c:	eb 0b                	jmp    8035a9 <realloc_block_FF+0x565>
  80359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a1:	8b 40 04             	mov    0x4(%eax),%eax
  8035a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ac:	8b 40 04             	mov    0x4(%eax),%eax
  8035af:	85 c0                	test   %eax,%eax
  8035b1:	74 0f                	je     8035c2 <realloc_block_FF+0x57e>
  8035b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b6:	8b 40 04             	mov    0x4(%eax),%eax
  8035b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035bc:	8b 12                	mov    (%edx),%edx
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	eb 0a                	jmp    8035cc <realloc_block_FF+0x588>
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035df:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e4:	48                   	dec    %eax
  8035e5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8035ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	6a 01                	push   $0x1
  8035f7:	50                   	push   %eax
  8035f8:	ff 75 08             	pushl  0x8(%ebp)
  8035fb:	e8 74 ea ff ff       	call   802074 <set_block_data>
  803600:	83 c4 10             	add    $0x10,%esp
  803603:	e9 36 01 00 00       	jmp    80373e <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803608:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80360b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80360e:	01 d0                	add    %edx,%eax
  803610:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	6a 01                	push   $0x1
  803618:	ff 75 f0             	pushl  -0x10(%ebp)
  80361b:	ff 75 08             	pushl  0x8(%ebp)
  80361e:	e8 51 ea ff ff       	call   802074 <set_block_data>
  803623:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	83 e8 04             	sub    $0x4,%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	83 e0 fe             	and    $0xfffffffe,%eax
  803631:	89 c2                	mov    %eax,%edx
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	01 d0                	add    %edx,%eax
  803638:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80363b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80363f:	74 06                	je     803647 <realloc_block_FF+0x603>
  803641:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803645:	75 17                	jne    80365e <realloc_block_FF+0x61a>
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	68 b4 44 80 00       	push   $0x8044b4
  80364f:	68 44 02 00 00       	push   $0x244
  803654:	68 41 44 80 00       	push   $0x804441
  803659:	e8 9d 03 00 00       	call   8039fb <_panic>
  80365e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803661:	8b 10                	mov    (%eax),%edx
  803663:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803666:	89 10                	mov    %edx,(%eax)
  803668:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	74 0b                	je     80367c <realloc_block_FF+0x638>
  803671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803679:	89 50 04             	mov    %edx,0x4(%eax)
  80367c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803682:	89 10                	mov    %edx,(%eax)
  803684:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803687:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80368a:	89 50 04             	mov    %edx,0x4(%eax)
  80368d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	75 08                	jne    80369e <realloc_block_FF+0x65a>
  803696:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803699:	a3 30 50 80 00       	mov    %eax,0x805030
  80369e:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a3:	40                   	inc    %eax
  8036a4:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036ad:	75 17                	jne    8036c6 <realloc_block_FF+0x682>
  8036af:	83 ec 04             	sub    $0x4,%esp
  8036b2:	68 23 44 80 00       	push   $0x804423
  8036b7:	68 45 02 00 00       	push   $0x245
  8036bc:	68 41 44 80 00       	push   $0x804441
  8036c1:	e8 35 03 00 00       	call   8039fb <_panic>
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	85 c0                	test   %eax,%eax
  8036cd:	74 10                	je     8036df <realloc_block_FF+0x69b>
  8036cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d2:	8b 00                	mov    (%eax),%eax
  8036d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d7:	8b 52 04             	mov    0x4(%edx),%edx
  8036da:	89 50 04             	mov    %edx,0x4(%eax)
  8036dd:	eb 0b                	jmp    8036ea <realloc_block_FF+0x6a6>
  8036df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e2:	8b 40 04             	mov    0x4(%eax),%eax
  8036e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	8b 40 04             	mov    0x4(%eax),%eax
  8036f0:	85 c0                	test   %eax,%eax
  8036f2:	74 0f                	je     803703 <realloc_block_FF+0x6bf>
  8036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f7:	8b 40 04             	mov    0x4(%eax),%eax
  8036fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fd:	8b 12                	mov    (%edx),%edx
  8036ff:	89 10                	mov    %edx,(%eax)
  803701:	eb 0a                	jmp    80370d <realloc_block_FF+0x6c9>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803720:	a1 38 50 80 00       	mov    0x805038,%eax
  803725:	48                   	dec    %eax
  803726:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80372b:	83 ec 04             	sub    $0x4,%esp
  80372e:	6a 00                	push   $0x0
  803730:	ff 75 bc             	pushl  -0x44(%ebp)
  803733:	ff 75 b8             	pushl  -0x48(%ebp)
  803736:	e8 39 e9 ff ff       	call   802074 <set_block_data>
  80373b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	eb 0a                	jmp    80374d <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803743:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80374d:	c9                   	leave  
  80374e:	c3                   	ret    

0080374f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80374f:	55                   	push   %ebp
  803750:	89 e5                	mov    %esp,%ebp
  803752:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803755:	83 ec 04             	sub    $0x4,%esp
  803758:	68 20 45 80 00       	push   $0x804520
  80375d:	68 58 02 00 00       	push   $0x258
  803762:	68 41 44 80 00       	push   $0x804441
  803767:	e8 8f 02 00 00       	call   8039fb <_panic>

0080376c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80376c:	55                   	push   %ebp
  80376d:	89 e5                	mov    %esp,%ebp
  80376f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803772:	83 ec 04             	sub    $0x4,%esp
  803775:	68 48 45 80 00       	push   $0x804548
  80377a:	68 61 02 00 00       	push   $0x261
  80377f:	68 41 44 80 00       	push   $0x804441
  803784:	e8 72 02 00 00       	call   8039fb <_panic>

00803789 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803789:	55                   	push   %ebp
  80378a:	89 e5                	mov    %esp,%ebp
  80378c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  80378f:	83 ec 04             	sub    $0x4,%esp
  803792:	6a 01                	push   $0x1
  803794:	6a 04                	push   $0x4
  803796:	ff 75 0c             	pushl  0xc(%ebp)
  803799:	e8 c1 dc ff ff       	call   80145f <smalloc>
  80379e:	83 c4 10             	add    $0x10,%esp
  8037a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  8037a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a8:	75 14                	jne    8037be <create_semaphore+0x35>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 6e 45 80 00       	push   $0x80456e
  8037b2:	6a 0d                	push   $0xd
  8037b4:	68 8b 45 80 00       	push   $0x80458b
  8037b9:	e8 3d 02 00 00       	call   8039fb <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8037c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8037cc:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8037cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	83 ec 0c             	sub    $0xc,%esp
  8037d7:	50                   	push   %eax
  8037d8:	e8 cc e4 ff ff       	call   801ca9 <sys_init_queue>
  8037dd:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8037e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f2:	8b 12                	mov    (%edx),%edx
  8037f4:	89 10                	mov    %edx,(%eax)
}
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	c9                   	leave  
  8037fa:	c2 04 00             	ret    $0x4

008037fd <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8037fd:	55                   	push   %ebp
  8037fe:	89 e5                	mov    %esp,%ebp
  803800:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803803:	83 ec 08             	sub    $0x8,%esp
  803806:	ff 75 10             	pushl  0x10(%ebp)
  803809:	ff 75 0c             	pushl  0xc(%ebp)
  80380c:	e8 f3 dc ff ff       	call   801504 <sget>
  803811:	83 c4 10             	add    $0x10,%esp
  803814:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381b:	75 14                	jne    803831 <get_semaphore+0x34>
  80381d:	83 ec 04             	sub    $0x4,%esp
  803820:	68 9b 45 80 00       	push   $0x80459b
  803825:	6a 1f                	push   $0x1f
  803827:	68 8b 45 80 00       	push   $0x80458b
  80382c:	e8 ca 01 00 00       	call   8039fb <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  803837:	8b 45 08             	mov    0x8(%ebp),%eax
  80383a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80383d:	8b 12                	mov    (%edx),%edx
  80383f:	89 10                	mov    %edx,(%eax)
}
  803841:	8b 45 08             	mov    0x8(%ebp),%eax
  803844:	c9                   	leave  
  803845:	c2 04 00             	ret    $0x4

00803848 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  803848:	55                   	push   %ebp
  803849:	89 e5                	mov    %esp,%ebp
  80384b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  80384e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	83 c0 14             	add    $0x14,%eax
  80385b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803864:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80386d:	f0 87 02             	lock xchg %eax,(%edx)
  803870:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803877:	75 dc                	jne    803855 <wait_semaphore+0xd>

		    sem.semdata->count--;
  803879:	8b 45 08             	mov    0x8(%ebp),%eax
  80387c:	8b 50 10             	mov    0x10(%eax),%edx
  80387f:	4a                   	dec    %edx
  803880:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  803883:	8b 45 08             	mov    0x8(%ebp),%eax
  803886:	8b 40 10             	mov    0x10(%eax),%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	79 30                	jns    8038bd <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  80388d:	e8 f5 e3 ff ff       	call   801c87 <sys_get_cpu_process>
  803892:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	83 ec 08             	sub    $0x8,%esp
  80389b:	ff 75 f0             	pushl  -0x10(%ebp)
  80389e:	50                   	push   %eax
  80389f:	e8 21 e4 ff ff       	call   801cc5 <sys_enqueue>
  8038a4:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  8038a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038aa:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  8038bb:	eb 0a                	jmp    8038c7 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  8038c7:	90                   	nop
  8038c8:	c9                   	leave  
  8038c9:	c3                   	ret    

008038ca <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8038ca:	55                   	push   %ebp
  8038cb:	89 e5                	mov    %esp,%ebp
  8038cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  8038d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	83 c0 14             	add    $0x14,%eax
  8038dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8038e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8038e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ec:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8038ef:	f0 87 02             	lock xchg %eax,(%edx)
  8038f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8038f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f9:	75 dc                	jne    8038d7 <signal_semaphore+0xd>
	    sem.semdata->count++;
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	8b 50 10             	mov    0x10(%eax),%edx
  803901:	42                   	inc    %edx
  803902:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	8b 40 10             	mov    0x10(%eax),%eax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	7f 20                	jg     80392f <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
  803912:	83 ec 0c             	sub    $0xc,%esp
  803915:	50                   	push   %eax
  803916:	e8 c8 e3 ff ff       	call   801ce3 <sys_dequeue>
  80391b:	83 c4 10             	add    $0x10,%esp
  80391e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803921:	83 ec 0c             	sub    $0xc,%esp
  803924:	ff 75 f0             	pushl  -0x10(%ebp)
  803927:	e8 db e3 ff ff       	call   801d07 <sys_sched_insert_ready>
  80392c:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  803939:	90                   	nop
  80393a:	c9                   	leave  
  80393b:	c3                   	ret    

0080393c <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  80393c:	55                   	push   %ebp
  80393d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	8b 40 10             	mov    0x10(%eax),%eax
}
  803945:	5d                   	pop    %ebp
  803946:	c3                   	ret    

00803947 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803947:	55                   	push   %ebp
  803948:	89 e5                	mov    %esp,%ebp
  80394a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80394d:	8b 55 08             	mov    0x8(%ebp),%edx
  803950:	89 d0                	mov    %edx,%eax
  803952:	c1 e0 02             	shl    $0x2,%eax
  803955:	01 d0                	add    %edx,%eax
  803957:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80395e:	01 d0                	add    %edx,%eax
  803960:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803967:	01 d0                	add    %edx,%eax
  803969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803970:	01 d0                	add    %edx,%eax
  803972:	c1 e0 04             	shl    $0x4,%eax
  803975:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803978:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80397f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803982:	83 ec 0c             	sub    $0xc,%esp
  803985:	50                   	push   %eax
  803986:	e8 08 e0 ff ff       	call   801993 <sys_get_virtual_time>
  80398b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80398e:	eb 41                	jmp    8039d1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803990:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803993:	83 ec 0c             	sub    $0xc,%esp
  803996:	50                   	push   %eax
  803997:	e8 f7 df ff ff       	call   801993 <sys_get_virtual_time>
  80399c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80399f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a5:	29 c2                	sub    %eax,%edx
  8039a7:	89 d0                	mov    %edx,%eax
  8039a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8039ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b2:	89 d1                	mov    %edx,%ecx
  8039b4:	29 c1                	sub    %eax,%ecx
  8039b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039bc:	39 c2                	cmp    %eax,%edx
  8039be:	0f 97 c0             	seta   %al
  8039c1:	0f b6 c0             	movzbl %al,%eax
  8039c4:	29 c1                	sub    %eax,%ecx
  8039c6:	89 c8                	mov    %ecx,%eax
  8039c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8039cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8039d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039d7:	72 b7                	jb     803990 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8039d9:	90                   	nop
  8039da:	c9                   	leave  
  8039db:	c3                   	ret    

008039dc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8039dc:	55                   	push   %ebp
  8039dd:	89 e5                	mov    %esp,%ebp
  8039df:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8039e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8039e9:	eb 03                	jmp    8039ee <busy_wait+0x12>
  8039eb:	ff 45 fc             	incl   -0x4(%ebp)
  8039ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8039f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039f4:	72 f5                	jb     8039eb <busy_wait+0xf>
	return i;
  8039f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8039f9:	c9                   	leave  
  8039fa:	c3                   	ret    

008039fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039fb:	55                   	push   %ebp
  8039fc:	89 e5                	mov    %esp,%ebp
  8039fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a01:	8d 45 10             	lea    0x10(%ebp),%eax
  803a04:	83 c0 04             	add    $0x4,%eax
  803a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a0a:	a1 60 50 98 00       	mov    0x985060,%eax
  803a0f:	85 c0                	test   %eax,%eax
  803a11:	74 16                	je     803a29 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a13:	a1 60 50 98 00       	mov    0x985060,%eax
  803a18:	83 ec 08             	sub    $0x8,%esp
  803a1b:	50                   	push   %eax
  803a1c:	68 bc 45 80 00       	push   $0x8045bc
  803a21:	e8 6b c9 ff ff       	call   800391 <cprintf>
  803a26:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a29:	a1 00 50 80 00       	mov    0x805000,%eax
  803a2e:	ff 75 0c             	pushl  0xc(%ebp)
  803a31:	ff 75 08             	pushl  0x8(%ebp)
  803a34:	50                   	push   %eax
  803a35:	68 c1 45 80 00       	push   $0x8045c1
  803a3a:	e8 52 c9 ff ff       	call   800391 <cprintf>
  803a3f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a42:	8b 45 10             	mov    0x10(%ebp),%eax
  803a45:	83 ec 08             	sub    $0x8,%esp
  803a48:	ff 75 f4             	pushl  -0xc(%ebp)
  803a4b:	50                   	push   %eax
  803a4c:	e8 d5 c8 ff ff       	call   800326 <vcprintf>
  803a51:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a54:	83 ec 08             	sub    $0x8,%esp
  803a57:	6a 00                	push   $0x0
  803a59:	68 dd 45 80 00       	push   $0x8045dd
  803a5e:	e8 c3 c8 ff ff       	call   800326 <vcprintf>
  803a63:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a66:	e8 44 c8 ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  803a6b:	eb fe                	jmp    803a6b <_panic+0x70>

00803a6d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a6d:	55                   	push   %ebp
  803a6e:	89 e5                	mov    %esp,%ebp
  803a70:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a73:	a1 20 50 80 00       	mov    0x805020,%eax
  803a78:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a81:	39 c2                	cmp    %eax,%edx
  803a83:	74 14                	je     803a99 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a85:	83 ec 04             	sub    $0x4,%esp
  803a88:	68 e0 45 80 00       	push   $0x8045e0
  803a8d:	6a 26                	push   $0x26
  803a8f:	68 2c 46 80 00       	push   $0x80462c
  803a94:	e8 62 ff ff ff       	call   8039fb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803aa0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803aa7:	e9 c5 00 00 00       	jmp    803b71 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab9:	01 d0                	add    %edx,%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	85 c0                	test   %eax,%eax
  803abf:	75 08                	jne    803ac9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ac1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ac4:	e9 a5 00 00 00       	jmp    803b6e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ac9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ad0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ad7:	eb 69                	jmp    803b42 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ad9:	a1 20 50 80 00       	mov    0x805020,%eax
  803ade:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ae4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ae7:	89 d0                	mov    %edx,%eax
  803ae9:	01 c0                	add    %eax,%eax
  803aeb:	01 d0                	add    %edx,%eax
  803aed:	c1 e0 03             	shl    $0x3,%eax
  803af0:	01 c8                	add    %ecx,%eax
  803af2:	8a 40 04             	mov    0x4(%eax),%al
  803af5:	84 c0                	test   %al,%al
  803af7:	75 46                	jne    803b3f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803af9:	a1 20 50 80 00       	mov    0x805020,%eax
  803afe:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b07:	89 d0                	mov    %edx,%eax
  803b09:	01 c0                	add    %eax,%eax
  803b0b:	01 d0                	add    %edx,%eax
  803b0d:	c1 e0 03             	shl    $0x3,%eax
  803b10:	01 c8                	add    %ecx,%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b1f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b24:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2e:	01 c8                	add    %ecx,%eax
  803b30:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b32:	39 c2                	cmp    %eax,%edx
  803b34:	75 09                	jne    803b3f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b36:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b3d:	eb 15                	jmp    803b54 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b3f:	ff 45 e8             	incl   -0x18(%ebp)
  803b42:	a1 20 50 80 00       	mov    0x805020,%eax
  803b47:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b50:	39 c2                	cmp    %eax,%edx
  803b52:	77 85                	ja     803ad9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b58:	75 14                	jne    803b6e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b5a:	83 ec 04             	sub    $0x4,%esp
  803b5d:	68 38 46 80 00       	push   $0x804638
  803b62:	6a 3a                	push   $0x3a
  803b64:	68 2c 46 80 00       	push   $0x80462c
  803b69:	e8 8d fe ff ff       	call   8039fb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b6e:	ff 45 f0             	incl   -0x10(%ebp)
  803b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b77:	0f 8c 2f ff ff ff    	jl     803aac <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b8b:	eb 26                	jmp    803bb3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b8d:	a1 20 50 80 00       	mov    0x805020,%eax
  803b92:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b9b:	89 d0                	mov    %edx,%eax
  803b9d:	01 c0                	add    %eax,%eax
  803b9f:	01 d0                	add    %edx,%eax
  803ba1:	c1 e0 03             	shl    $0x3,%eax
  803ba4:	01 c8                	add    %ecx,%eax
  803ba6:	8a 40 04             	mov    0x4(%eax),%al
  803ba9:	3c 01                	cmp    $0x1,%al
  803bab:	75 03                	jne    803bb0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb0:	ff 45 e0             	incl   -0x20(%ebp)
  803bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  803bb8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc1:	39 c2                	cmp    %eax,%edx
  803bc3:	77 c8                	ja     803b8d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bcb:	74 14                	je     803be1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bcd:	83 ec 04             	sub    $0x4,%esp
  803bd0:	68 8c 46 80 00       	push   $0x80468c
  803bd5:	6a 44                	push   $0x44
  803bd7:	68 2c 46 80 00       	push   $0x80462c
  803bdc:	e8 1a fe ff ff       	call   8039fb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803be1:	90                   	nop
  803be2:	c9                   	leave  
  803be3:	c3                   	ret    

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
