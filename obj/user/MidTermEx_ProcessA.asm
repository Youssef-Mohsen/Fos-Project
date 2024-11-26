
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
  80003e:	e8 2f 19 00 00       	call   801972 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 c0 3c 80 00       	push   $0x803cc0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 c0 14 00 00       	call   801516 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c2 3c 80 00       	push   $0x803cc2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 aa 14 00 00       	call   801516 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c9 3c 80 00       	push   $0x803cc9
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
  80008f:	e8 11 19 00 00       	call   8019a5 <sys_get_virtual_time>
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
  8000b7:	e8 e9 36 00 00       	call   8037a5 <env_sleep>
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
  8000d0:	e8 d0 18 00 00       	call   8019a5 <sys_get_virtual_time>
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
  8000f8:	e8 a8 36 00 00       	call   8037a5 <env_sleep>
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
  80010f:	e8 91 18 00 00       	call   8019a5 <sys_get_virtual_time>
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
  800137:	e8 69 36 00 00       	call   8037a5 <env_sleep>
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
  80014f:	68 d7 3c 80 00       	push   $0x803cd7
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 ef 35 00 00       	call   80374c <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 15 36 00 00       	call   803780 <signal_semaphore>
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
  800184:	e8 d0 17 00 00       	call   801959 <sys_getenvindex>
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
  8001f2:	e8 e6 14 00 00       	call   8016dd <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 f4 3c 80 00       	push   $0x803cf4
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
  800222:	68 1c 3d 80 00       	push   $0x803d1c
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
  800253:	68 44 3d 80 00       	push   $0x803d44
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 9c 3d 80 00       	push   $0x803d9c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 f4 3c 80 00       	push   $0x803cf4
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 66 14 00 00       	call   8016f7 <sys_unlock_cons>
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
  8002a4:	e8 7c 16 00 00       	call   801925 <sys_destroy_env>
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
  8002b5:	e8 d1 16 00 00       	call   80198b <sys_exit_env>
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
  800303:	e8 93 13 00 00       	call   80169b <sys_cputs>
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
  80037a:	e8 1c 13 00 00       	call   80169b <sys_cputs>
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
  8003c4:	e8 14 13 00 00       	call   8016dd <sys_lock_cons>
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
  8003e4:	e8 0e 13 00 00       	call   8016f7 <sys_unlock_cons>
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
  80042e:	e8 11 36 00 00       	call   803a44 <__udivdi3>
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
  80047e:	e8 d1 36 00 00       	call   803b54 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  8005d9:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  8006ba:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 e5 3f 80 00       	push   $0x803fe5
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
  8006df:	68 ee 3f 80 00       	push   $0x803fee
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
  80070c:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  801117:	68 68 41 80 00       	push   $0x804168
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 8a 41 80 00       	push   $0x80418a
  801126:	e8 2e 27 00 00       	call   803859 <_panic>

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
  801137:	e8 0a 0b 00 00       	call   801c46 <sys_sbrk>
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
  8011b2:	e8 13 09 00 00       	call   801aca <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 53 0e 00 00       	call   802019 <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 25 09 00 00       	call   801afb <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 ec 12 00 00       	call   8024d5 <alloc_block_BF>
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
  80134a:	e8 2e 09 00 00       	call   801c7d <sys_allocate_user_mem>
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
  801392:	e8 02 09 00 00       	call   801c99 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 35 1b 00 00       	call   802edd <free_block>
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
  80143a:	e8 22 08 00 00       	call   801c61 <sys_free_user_mem>
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
  801448:	68 98 41 80 00       	push   $0x804198
  80144d:	68 85 00 00 00       	push   $0x85
  801452:	68 c2 41 80 00       	push   $0x8041c2
  801457:	e8 fd 23 00 00       	call   803859 <_panic>
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
  8014bd:	e8 a6 03 00 00       	call   801868 <sys_createSharedObject>
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
  8014e1:	68 ce 41 80 00       	push   $0x8041ce
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
  801525:	e8 68 03 00 00       	call   801892 <sys_getSizeOfSharedObject>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801530:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801534:	75 07                	jne    80153d <sget+0x27>
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 7f                	jmp    8015bc <sget+0xa6>
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
  801570:	eb 4a                	jmp    8015bc <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	ff 75 e8             	pushl  -0x18(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 2c 03 00 00       	call   8018af <sys_getSharedObject>
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801589:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80158c:	a1 20 50 80 00       	mov    0x805020,%eax
  801591:	8b 40 78             	mov    0x78(%eax),%eax
  801594:	29 c2                	sub    %eax,%edx
  801596:	89 d0                	mov    %edx,%eax
  801598:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159d:	c1 e8 0c             	shr    $0xc,%eax
  8015a0:	89 c2                	mov    %eax,%edx
  8015a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a5:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8015ac:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8015b0:	75 07                	jne    8015b9 <sget+0xa3>
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 03                	jmp    8015bc <sget+0xa6>
	return ptr;
  8015b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8015c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8015cc:	8b 40 78             	mov    0x78(%eax),%eax
  8015cf:	29 c2                	sub    %eax,%edx
  8015d1:	89 d0                	mov    %edx,%eax
  8015d3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d8:	c1 e8 0c             	shr    $0xc,%eax
  8015db:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ee:	e8 db 02 00 00       	call   8018ce <sys_freeSharedObject>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	68 e0 41 80 00       	push   $0x8041e0
  80160a:	68 de 00 00 00       	push   $0xde
  80160f:	68 c2 41 80 00       	push   $0x8041c2
  801614:	e8 40 22 00 00       	call   803859 <_panic>

00801619 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161f:	83 ec 04             	sub    $0x4,%esp
  801622:	68 06 42 80 00       	push   $0x804206
  801627:	68 ea 00 00 00       	push   $0xea
  80162c:	68 c2 41 80 00       	push   $0x8041c2
  801631:	e8 23 22 00 00       	call   803859 <_panic>

00801636 <shrink>:

}
void shrink(uint32 newSize)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 06 42 80 00       	push   $0x804206
  801644:	68 ef 00 00 00       	push   $0xef
  801649:	68 c2 41 80 00       	push   $0x8041c2
  80164e:	e8 06 22 00 00       	call   803859 <_panic>

00801653 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 06 42 80 00       	push   $0x804206
  801661:	68 f4 00 00 00       	push   $0xf4
  801666:	68 c2 41 80 00       	push   $0x8041c2
  80166b:	e8 e9 21 00 00       	call   803859 <_panic>

00801670 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	57                   	push   %edi
  801674:	56                   	push   %esi
  801675:	53                   	push   %ebx
  801676:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801682:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801685:	8b 7d 18             	mov    0x18(%ebp),%edi
  801688:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80168b:	cd 30                	int    $0x30
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	5b                   	pop    %ebx
  801697:	5e                   	pop    %esi
  801698:	5f                   	pop    %edi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016a7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	52                   	push   %edx
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	50                   	push   %eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	e8 b2 ff ff ff       	call   801670 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 02                	push   $0x2
  8016d3:	e8 98 ff ff ff       	call   801670 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 03                	push   $0x3
  8016ec:	e8 7f ff ff ff       	call   801670 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 04                	push   $0x4
  801706:	e8 65 ff ff ff       	call   801670 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 08                	push   $0x8
  801724:	e8 47 ff ff ff       	call   801670 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801733:	8b 75 18             	mov    0x18(%ebp),%esi
  801736:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801739:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 09                	push   $0x9
  801749:	e8 22 ff ff ff       	call   801670 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 0a                	push   $0xa
  80176b:	e8 00 ff ff ff       	call   801670 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 0b                	push   $0xb
  801786:	e8 e5 fe ff ff       	call   801670 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 0c                	push   $0xc
  80179f:	e8 cc fe ff ff       	call   801670 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 0d                	push   $0xd
  8017b8:	e8 b3 fe ff ff       	call   801670 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 0e                	push   $0xe
  8017d1:	e8 9a fe ff ff       	call   801670 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 0f                	push   $0xf
  8017ea:	e8 81 fe ff ff       	call   801670 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	6a 10                	push   $0x10
  801804:	e8 67 fe ff ff       	call   801670 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 11                	push   $0x11
  80181d:	e8 4e fe ff ff       	call   801670 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_cputc>:

void
sys_cputc(const char c)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801834:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	50                   	push   %eax
  801841:	6a 01                	push   $0x1
  801843:	e8 28 fe ff ff       	call   801670 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 14                	push   $0x14
  80185d:	e8 0e fe ff ff       	call   801670 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	90                   	nop
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	8b 45 10             	mov    0x10(%ebp),%eax
  801871:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801874:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801877:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	51                   	push   %ecx
  801881:	52                   	push   %edx
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	50                   	push   %eax
  801886:	6a 15                	push   $0x15
  801888:	e8 e3 fd ff ff       	call   801670 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801895:	8b 55 0c             	mov    0xc(%ebp),%edx
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	6a 16                	push   $0x16
  8018a5:	e8 c6 fd ff ff       	call   801670 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 17                	push   $0x17
  8018c4:	e8 a7 fd ff ff       	call   801670 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 18                	push   $0x18
  8018e1:	e8 8a fd ff ff       	call   801670 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	ff 75 14             	pushl  0x14(%ebp)
  8018f6:	ff 75 10             	pushl  0x10(%ebp)
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	50                   	push   %eax
  8018fd:	6a 19                	push   $0x19
  8018ff:	e8 6c fd ff ff       	call   801670 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	50                   	push   %eax
  801918:	6a 1a                	push   $0x1a
  80191a:	e8 51 fd ff ff       	call   801670 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	90                   	nop
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	50                   	push   %eax
  801934:	6a 1b                	push   $0x1b
  801936:	e8 35 fd ff ff       	call   801670 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 05                	push   $0x5
  80194f:	e8 1c fd ff ff       	call   801670 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 06                	push   $0x6
  801968:	e8 03 fd ff ff       	call   801670 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 07                	push   $0x7
  801981:	e8 ea fc ff ff       	call   801670 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_exit_env>:


void sys_exit_env(void)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 1c                	push   $0x1c
  80199a:	e8 d1 fc ff ff       	call   801670 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ae:	8d 50 04             	lea    0x4(%eax),%edx
  8019b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	52                   	push   %edx
  8019bb:	50                   	push   %eax
  8019bc:	6a 1d                	push   $0x1d
  8019be:	e8 ad fc ff ff       	call   801670 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return result;
  8019c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019cf:	89 01                	mov    %eax,(%ecx)
  8019d1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	c9                   	leave  
  8019d8:	c2 04 00             	ret    $0x4

008019db <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 10             	pushl  0x10(%ebp)
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	6a 13                	push   $0x13
  8019ed:	e8 7e fc ff ff       	call   801670 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f5:	90                   	nop
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 1e                	push   $0x1e
  801a07:	e8 64 fc ff ff       	call   801670 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	50                   	push   %eax
  801a2a:	6a 1f                	push   $0x1f
  801a2c:	e8 3f fc ff ff       	call   801670 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <rsttst>:
void rsttst()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 21                	push   $0x21
  801a46:	e8 25 fc ff ff       	call   801670 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4e:	90                   	nop
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a5d:	8b 55 18             	mov    0x18(%ebp),%edx
  801a60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	ff 75 10             	pushl  0x10(%ebp)
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	ff 75 08             	pushl  0x8(%ebp)
  801a6f:	6a 20                	push   $0x20
  801a71:	e8 fa fb ff ff       	call   801670 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
	return ;
  801a79:	90                   	nop
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <chktst>:
void chktst(uint32 n)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	6a 22                	push   $0x22
  801a8c:	e8 df fb ff ff       	call   801670 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
	return ;
  801a94:	90                   	nop
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <inctst>:

void inctst()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 23                	push   $0x23
  801aa6:	e8 c5 fb ff ff       	call   801670 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
	return ;
  801aae:	90                   	nop
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <gettst>:
uint32 gettst()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 24                	push   $0x24
  801ac0:	e8 ab fb ff ff       	call   801670 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 25                	push   $0x25
  801adc:	e8 8f fb ff ff       	call   801670 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
  801ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ae7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aeb:	75 07                	jne    801af4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aed:	b8 01 00 00 00       	mov    $0x1,%eax
  801af2:	eb 05                	jmp    801af9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 25                	push   $0x25
  801b0d:	e8 5e fb ff ff       	call   801670 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
  801b15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b18:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b1c:	75 07                	jne    801b25 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b23:	eb 05                	jmp    801b2a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 25                	push   $0x25
  801b3e:	e8 2d fb ff ff       	call   801670 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
  801b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b49:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b4d:	75 07                	jne    801b56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b54:	eb 05                	jmp    801b5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 25                	push   $0x25
  801b6f:	e8 fc fa ff ff       	call   801670 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
  801b77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b7e:	75 07                	jne    801b87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b80:	b8 01 00 00 00       	mov    $0x1,%eax
  801b85:	eb 05                	jmp    801b8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 26                	push   $0x26
  801b9e:	e8 cd fa ff ff       	call   801670 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	53                   	push   %ebx
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 27                	push   $0x27
  801bc1:	e8 aa fa ff ff       	call   801670 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 28                	push   $0x28
  801be1:	e8 8a fa ff ff       	call   801670 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	51                   	push   %ecx
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	52                   	push   %edx
  801bfe:	50                   	push   %eax
  801bff:	6a 29                	push   $0x29
  801c01:	e8 6a fa ff ff       	call   801670 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 12                	push   $0x12
  801c1d:	e8 4e fa ff ff       	call   801670 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 2a                	push   $0x2a
  801c3b:	e8 30 fa ff ff       	call   801670 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	50                   	push   %eax
  801c55:	6a 2b                	push   $0x2b
  801c57:	e8 14 fa ff ff       	call   801670 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	6a 2c                	push   $0x2c
  801c72:	e8 f9 f9 ff ff       	call   801670 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return;
  801c7a:	90                   	nop
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 2d                	push   $0x2d
  801c8e:	e8 dd f9 ff ff       	call   801670 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	83 e8 04             	sub    $0x4,%eax
  801ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cab:	8b 00                	mov    (%eax),%eax
  801cad:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	83 e8 04             	sub    $0x4,%eax
  801cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc4:	8b 00                	mov    (%eax),%eax
  801cc6:	83 e0 01             	and    $0x1,%eax
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	0f 94 c0             	sete   %al
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce0:	83 f8 02             	cmp    $0x2,%eax
  801ce3:	74 2b                	je     801d10 <alloc_block+0x40>
  801ce5:	83 f8 02             	cmp    $0x2,%eax
  801ce8:	7f 07                	jg     801cf1 <alloc_block+0x21>
  801cea:	83 f8 01             	cmp    $0x1,%eax
  801ced:	74 0e                	je     801cfd <alloc_block+0x2d>
  801cef:	eb 58                	jmp    801d49 <alloc_block+0x79>
  801cf1:	83 f8 03             	cmp    $0x3,%eax
  801cf4:	74 2d                	je     801d23 <alloc_block+0x53>
  801cf6:	83 f8 04             	cmp    $0x4,%eax
  801cf9:	74 3b                	je     801d36 <alloc_block+0x66>
  801cfb:	eb 4c                	jmp    801d49 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	e8 11 03 00 00       	call   802019 <alloc_block_FF>
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d0e:	eb 4a                	jmp    801d5a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	e8 fa 19 00 00       	call   803715 <alloc_block_NF>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d21:	eb 37                	jmp    801d5a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d23:	83 ec 0c             	sub    $0xc,%esp
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 a7 07 00 00       	call   8024d5 <alloc_block_BF>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d34:	eb 24                	jmp    801d5a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 b7 19 00 00       	call   8036f8 <alloc_block_WF>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d47:	eb 11                	jmp    801d5a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	68 18 42 80 00       	push   $0x804218
  801d51:	e8 3b e6 ff ff       	call   800391 <cprintf>
  801d56:	83 c4 10             	add    $0x10,%esp
		break;
  801d59:	90                   	nop
	}
	return va;
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	53                   	push   %ebx
  801d63:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	68 38 42 80 00       	push   $0x804238
  801d6e:	e8 1e e6 ff ff       	call   800391 <cprintf>
  801d73:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	68 63 42 80 00       	push   $0x804263
  801d7e:	e8 0e e6 ff ff       	call   800391 <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8c:	eb 37                	jmp    801dc5 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d8e:	83 ec 0c             	sub    $0xc,%esp
  801d91:	ff 75 f4             	pushl  -0xc(%ebp)
  801d94:	e8 19 ff ff ff       	call   801cb2 <is_free_block>
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	0f be d8             	movsbl %al,%ebx
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	ff 75 f4             	pushl  -0xc(%ebp)
  801da5:	e8 ef fe ff ff       	call   801c99 <get_block_size>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	53                   	push   %ebx
  801db1:	50                   	push   %eax
  801db2:	68 7b 42 80 00       	push   $0x80427b
  801db7:	e8 d5 e5 ff ff       	call   800391 <cprintf>
  801dbc:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc9:	74 07                	je     801dd2 <print_blocks_list+0x73>
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	eb 05                	jmp    801dd7 <print_blocks_list+0x78>
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd7:	89 45 10             	mov    %eax,0x10(%ebp)
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	75 ad                	jne    801d8e <print_blocks_list+0x2f>
  801de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de5:	75 a7                	jne    801d8e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	68 38 42 80 00       	push   $0x804238
  801def:	e8 9d e5 ff ff       	call   800391 <cprintf>
  801df4:	83 c4 10             	add    $0x10,%esp

}
  801df7:	90                   	nop
  801df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e06:	83 e0 01             	and    $0x1,%eax
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 03                	je     801e10 <initialize_dynamic_allocator+0x13>
  801e0d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e14:	0f 84 c7 01 00 00    	je     801fe1 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e1a:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e21:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e24:	8b 55 08             	mov    0x8(%ebp),%edx
  801e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e31:	0f 87 ad 01 00 00    	ja     801fe4 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	0f 89 a5 01 00 00    	jns    801fe7 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e42:	8b 55 08             	mov    0x8(%ebp),%edx
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	83 e8 04             	sub    $0x4,%eax
  801e4d:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e59:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e61:	e9 87 00 00 00       	jmp    801eed <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6a:	75 14                	jne    801e80 <initialize_dynamic_allocator+0x83>
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 93 42 80 00       	push   $0x804293
  801e74:	6a 79                	push   $0x79
  801e76:	68 b1 42 80 00       	push   $0x8042b1
  801e7b:	e8 d9 19 00 00       	call   803859 <_panic>
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 00                	mov    (%eax),%eax
  801e85:	85 c0                	test   %eax,%eax
  801e87:	74 10                	je     801e99 <initialize_dynamic_allocator+0x9c>
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	8b 00                	mov    (%eax),%eax
  801e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e91:	8b 52 04             	mov    0x4(%edx),%edx
  801e94:	89 50 04             	mov    %edx,0x4(%eax)
  801e97:	eb 0b                	jmp    801ea4 <initialize_dynamic_allocator+0xa7>
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 40 04             	mov    0x4(%eax),%eax
  801e9f:	a3 30 50 80 00       	mov    %eax,0x805030
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 40 04             	mov    0x4(%eax),%eax
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	74 0f                	je     801ebd <initialize_dynamic_allocator+0xc0>
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 40 04             	mov    0x4(%eax),%eax
  801eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb7:	8b 12                	mov    (%edx),%edx
  801eb9:	89 10                	mov    %edx,(%eax)
  801ebb:	eb 0a                	jmp    801ec7 <initialize_dynamic_allocator+0xca>
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 00                	mov    (%eax),%eax
  801ec2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eda:	a1 38 50 80 00       	mov    0x805038,%eax
  801edf:	48                   	dec    %eax
  801ee0:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801ee5:	a1 34 50 80 00       	mov    0x805034,%eax
  801eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef1:	74 07                	je     801efa <initialize_dynamic_allocator+0xfd>
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	eb 05                	jmp    801eff <initialize_dynamic_allocator+0x102>
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	a3 34 50 80 00       	mov    %eax,0x805034
  801f04:	a1 34 50 80 00       	mov    0x805034,%eax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	0f 85 55 ff ff ff    	jne    801e66 <initialize_dynamic_allocator+0x69>
  801f11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f15:	0f 85 4b ff ff ff    	jne    801e66 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f2a:	a1 44 50 80 00       	mov    0x805044,%eax
  801f2f:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f34:	a1 40 50 80 00       	mov    0x805040,%eax
  801f39:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	83 c0 08             	add    $0x8,%eax
  801f45:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	83 c0 04             	add    $0x4,%eax
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	83 ea 08             	sub    $0x8,%edx
  801f54:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	83 e8 08             	sub    $0x8,%eax
  801f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f64:	83 ea 08             	sub    $0x8,%edx
  801f67:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f80:	75 17                	jne    801f99 <initialize_dynamic_allocator+0x19c>
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 cc 42 80 00       	push   $0x8042cc
  801f8a:	68 90 00 00 00       	push   $0x90
  801f8f:	68 b1 42 80 00       	push   $0x8042b1
  801f94:	e8 c0 18 00 00       	call   803859 <_panic>
  801f99:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa2:	89 10                	mov    %edx,(%eax)
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	74 0d                	je     801fba <initialize_dynamic_allocator+0x1bd>
  801fad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb5:	89 50 04             	mov    %edx,0x4(%eax)
  801fb8:	eb 08                	jmp    801fc2 <initialize_dynamic_allocator+0x1c5>
  801fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbd:	a3 30 50 80 00       	mov    %eax,0x805030
  801fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd4:	a1 38 50 80 00       	mov    0x805038,%eax
  801fd9:	40                   	inc    %eax
  801fda:	a3 38 50 80 00       	mov    %eax,0x805038
  801fdf:	eb 07                	jmp    801fe8 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fe1:	90                   	nop
  801fe2:	eb 04                	jmp    801fe8 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fe4:	90                   	nop
  801fe5:	eb 01                	jmp    801fe8 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fe7:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff0:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8d 50 fc             	lea    -0x4(%eax),%edx
  801ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffc:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	83 e8 04             	sub    $0x4,%eax
  802004:	8b 00                	mov    (%eax),%eax
  802006:	83 e0 fe             	and    $0xfffffffe,%eax
  802009:	8d 50 f8             	lea    -0x8(%eax),%edx
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	01 c2                	add    %eax,%edx
  802011:	8b 45 0c             	mov    0xc(%ebp),%eax
  802014:	89 02                	mov    %eax,(%edx)
}
  802016:	90                   	nop
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	83 e0 01             	and    $0x1,%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	74 03                	je     80202c <alloc_block_FF+0x13>
  802029:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80202c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802030:	77 07                	ja     802039 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802032:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802039:	a1 24 50 80 00       	mov    0x805024,%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 73                	jne    8020b5 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	83 c0 10             	add    $0x10,%eax
  802048:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80204b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	48                   	dec    %eax
  80205b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80205e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802061:	ba 00 00 00 00       	mov    $0x0,%edx
  802066:	f7 75 ec             	divl   -0x14(%ebp)
  802069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206c:	29 d0                	sub    %edx,%eax
  80206e:	c1 e8 0c             	shr    $0xc,%eax
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	50                   	push   %eax
  802075:	e8 b1 f0 ff ff       	call   80112b <sbrk>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	6a 00                	push   $0x0
  802085:	e8 a1 f0 ff ff       	call   80112b <sbrk>
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802093:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802096:	83 ec 08             	sub    $0x8,%esp
  802099:	50                   	push   %eax
  80209a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80209d:	e8 5b fd ff ff       	call   801dfd <initialize_dynamic_allocator>
  8020a2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	68 ef 42 80 00       	push   $0x8042ef
  8020ad:	e8 df e2 ff ff       	call   800391 <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b9:	75 0a                	jne    8020c5 <alloc_block_FF+0xac>
	        return NULL;
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c0:	e9 0e 04 00 00       	jmp    8024d3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d4:	e9 f3 02 00 00       	jmp    8023cc <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	ff 75 bc             	pushl  -0x44(%ebp)
  8020e5:	e8 af fb ff ff       	call   801c99 <get_block_size>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	83 c0 08             	add    $0x8,%eax
  8020f6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020f9:	0f 87 c5 02 00 00    	ja     8023c4 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	83 c0 18             	add    $0x18,%eax
  802105:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802108:	0f 87 19 02 00 00    	ja     802327 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80210e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802111:	2b 45 08             	sub    0x8(%ebp),%eax
  802114:	83 e8 08             	sub    $0x8,%eax
  802117:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8d 50 08             	lea    0x8(%eax),%edx
  802120:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802123:	01 d0                	add    %edx,%eax
  802125:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	83 c0 08             	add    $0x8,%eax
  80212e:	83 ec 04             	sub    $0x4,%esp
  802131:	6a 01                	push   $0x1
  802133:	50                   	push   %eax
  802134:	ff 75 bc             	pushl  -0x44(%ebp)
  802137:	e8 ae fe ff ff       	call   801fea <set_block_data>
  80213c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 40 04             	mov    0x4(%eax),%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	75 68                	jne    8021b1 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802149:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80214d:	75 17                	jne    802166 <alloc_block_FF+0x14d>
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	68 cc 42 80 00       	push   $0x8042cc
  802157:	68 d7 00 00 00       	push   $0xd7
  80215c:	68 b1 42 80 00       	push   $0x8042b1
  802161:	e8 f3 16 00 00       	call   803859 <_panic>
  802166:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80216c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80216f:	89 10                	mov    %edx,(%eax)
  802171:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	85 c0                	test   %eax,%eax
  802178:	74 0d                	je     802187 <alloc_block_FF+0x16e>
  80217a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80217f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802182:	89 50 04             	mov    %edx,0x4(%eax)
  802185:	eb 08                	jmp    80218f <alloc_block_FF+0x176>
  802187:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218a:	a3 30 50 80 00       	mov    %eax,0x805030
  80218f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802192:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802197:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a6:	40                   	inc    %eax
  8021a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ac:	e9 dc 00 00 00       	jmp    80228d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	75 65                	jne    80221f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021ba:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021be:	75 17                	jne    8021d7 <alloc_block_FF+0x1be>
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 00 43 80 00       	push   $0x804300
  8021c8:	68 db 00 00 00       	push   $0xdb
  8021cd:	68 b1 42 80 00       	push   $0x8042b1
  8021d2:	e8 82 16 00 00       	call   803859 <_panic>
  8021d7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e0:	89 50 04             	mov    %edx,0x4(%eax)
  8021e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e6:	8b 40 04             	mov    0x4(%eax),%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	74 0c                	je     8021f9 <alloc_block_FF+0x1e0>
  8021ed:	a1 30 50 80 00       	mov    0x805030,%eax
  8021f2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f5:	89 10                	mov    %edx,(%eax)
  8021f7:	eb 08                	jmp    802201 <alloc_block_FF+0x1e8>
  8021f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802201:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802204:	a3 30 50 80 00       	mov    %eax,0x805030
  802209:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80220c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802212:	a1 38 50 80 00       	mov    0x805038,%eax
  802217:	40                   	inc    %eax
  802218:	a3 38 50 80 00       	mov    %eax,0x805038
  80221d:	eb 6e                	jmp    80228d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80221f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802223:	74 06                	je     80222b <alloc_block_FF+0x212>
  802225:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802229:	75 17                	jne    802242 <alloc_block_FF+0x229>
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 24 43 80 00       	push   $0x804324
  802233:	68 df 00 00 00       	push   $0xdf
  802238:	68 b1 42 80 00       	push   $0x8042b1
  80223d:	e8 17 16 00 00       	call   803859 <_panic>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 10                	mov    (%eax),%edx
  802247:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0b                	je     802260 <alloc_block_FF+0x247>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 00                	mov    (%eax),%eax
  80225a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225d:	89 50 04             	mov    %edx,0x4(%eax)
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802266:	89 10                	mov    %edx,(%eax)
  802268:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226e:	89 50 04             	mov    %edx,0x4(%eax)
  802271:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802274:	8b 00                	mov    (%eax),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	75 08                	jne    802282 <alloc_block_FF+0x269>
  80227a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227d:	a3 30 50 80 00       	mov    %eax,0x805030
  802282:	a1 38 50 80 00       	mov    0x805038,%eax
  802287:	40                   	inc    %eax
  802288:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	75 17                	jne    8022aa <alloc_block_FF+0x291>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 93 42 80 00       	push   $0x804293
  80229b:	68 e1 00 00 00       	push   $0xe1
  8022a0:	68 b1 42 80 00       	push   $0x8042b1
  8022a5:	e8 af 15 00 00       	call   803859 <_panic>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 10                	je     8022c3 <alloc_block_FF+0x2aa>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	8b 52 04             	mov    0x4(%edx),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	eb 0b                	jmp    8022ce <alloc_block_FF+0x2b5>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 40 04             	mov    0x4(%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0f                	je     8022e7 <alloc_block_FF+0x2ce>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	8b 12                	mov    (%edx),%edx
  8022e3:	89 10                	mov    %edx,(%eax)
  8022e5:	eb 0a                	jmp    8022f1 <alloc_block_FF+0x2d8>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802304:	a1 38 50 80 00       	mov    0x805038,%eax
  802309:	48                   	dec    %eax
  80230a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	6a 00                	push   $0x0
  802314:	ff 75 b4             	pushl  -0x4c(%ebp)
  802317:	ff 75 b0             	pushl  -0x50(%ebp)
  80231a:	e8 cb fc ff ff       	call   801fea <set_block_data>
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	e9 95 00 00 00       	jmp    8023bc <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	6a 01                	push   $0x1
  80232c:	ff 75 b8             	pushl  -0x48(%ebp)
  80232f:	ff 75 bc             	pushl  -0x44(%ebp)
  802332:	e8 b3 fc ff ff       	call   801fea <set_block_data>
  802337:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	75 17                	jne    802357 <alloc_block_FF+0x33e>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 93 42 80 00       	push   $0x804293
  802348:	68 e8 00 00 00       	push   $0xe8
  80234d:	68 b1 42 80 00       	push   $0x8042b1
  802352:	e8 02 15 00 00       	call   803859 <_panic>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 10                	je     802370 <alloc_block_FF+0x357>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	8b 52 04             	mov    0x4(%edx),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	eb 0b                	jmp    80237b <alloc_block_FF+0x362>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	a3 30 50 80 00       	mov    %eax,0x805030
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 04             	mov    0x4(%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0f                	je     802394 <alloc_block_FF+0x37b>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238e:	8b 12                	mov    (%edx),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	eb 0a                	jmp    80239e <alloc_block_FF+0x385>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b6:	48                   	dec    %eax
  8023b7:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8023bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023bf:	e9 0f 01 00 00       	jmp    8024d3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c4:	a1 34 50 80 00       	mov    0x805034,%eax
  8023c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	74 07                	je     8023d9 <alloc_block_FF+0x3c0>
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	eb 05                	jmp    8023de <alloc_block_FF+0x3c5>
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023de:	a3 34 50 80 00       	mov    %eax,0x805034
  8023e3:	a1 34 50 80 00       	mov    0x805034,%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	0f 85 e9 fc ff ff    	jne    8020d9 <alloc_block_FF+0xc0>
  8023f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f4:	0f 85 df fc ff ff    	jne    8020d9 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	83 c0 08             	add    $0x8,%eax
  802400:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802403:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80240a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80240d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802410:	01 d0                	add    %edx,%eax
  802412:	48                   	dec    %eax
  802413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802419:	ba 00 00 00 00       	mov    $0x0,%edx
  80241e:	f7 75 d8             	divl   -0x28(%ebp)
  802421:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802424:	29 d0                	sub    %edx,%eax
  802426:	c1 e8 0c             	shr    $0xc,%eax
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	50                   	push   %eax
  80242d:	e8 f9 ec ff ff       	call   80112b <sbrk>
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802438:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80243c:	75 0a                	jne    802448 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	e9 8b 00 00 00       	jmp    8024d3 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802448:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80244f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802452:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802455:	01 d0                	add    %edx,%eax
  802457:	48                   	dec    %eax
  802458:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80245b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80245e:	ba 00 00 00 00       	mov    $0x0,%edx
  802463:	f7 75 cc             	divl   -0x34(%ebp)
  802466:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802469:	29 d0                	sub    %edx,%eax
  80246b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80246e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802471:	01 d0                	add    %edx,%eax
  802473:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802478:	a1 40 50 80 00       	mov    0x805040,%eax
  80247d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802483:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80248a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80248d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802490:	01 d0                	add    %edx,%eax
  802492:	48                   	dec    %eax
  802493:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802496:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802499:	ba 00 00 00 00       	mov    $0x0,%edx
  80249e:	f7 75 c4             	divl   -0x3c(%ebp)
  8024a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024a4:	29 d0                	sub    %edx,%eax
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	6a 01                	push   $0x1
  8024ab:	50                   	push   %eax
  8024ac:	ff 75 d0             	pushl  -0x30(%ebp)
  8024af:	e8 36 fb ff ff       	call   801fea <set_block_data>
  8024b4:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	ff 75 d0             	pushl  -0x30(%ebp)
  8024bd:	e8 1b 0a 00 00       	call   802edd <free_block>
  8024c2:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024c5:	83 ec 0c             	sub    $0xc,%esp
  8024c8:	ff 75 08             	pushl  0x8(%ebp)
  8024cb:	e8 49 fb ff ff       	call   802019 <alloc_block_FF>
  8024d0:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	83 e0 01             	and    $0x1,%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 03                	je     8024e8 <alloc_block_BF+0x13>
  8024e5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024e8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024ec:	77 07                	ja     8024f5 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024ee:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024f5:	a1 24 50 80 00       	mov    0x805024,%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	75 73                	jne    802571 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	83 c0 10             	add    $0x10,%eax
  802504:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802507:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80250e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802514:	01 d0                	add    %edx,%eax
  802516:	48                   	dec    %eax
  802517:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80251a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80251d:	ba 00 00 00 00       	mov    $0x0,%edx
  802522:	f7 75 e0             	divl   -0x20(%ebp)
  802525:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802528:	29 d0                	sub    %edx,%eax
  80252a:	c1 e8 0c             	shr    $0xc,%eax
  80252d:	83 ec 0c             	sub    $0xc,%esp
  802530:	50                   	push   %eax
  802531:	e8 f5 eb ff ff       	call   80112b <sbrk>
  802536:	83 c4 10             	add    $0x10,%esp
  802539:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	6a 00                	push   $0x0
  802541:	e8 e5 eb ff ff       	call   80112b <sbrk>
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80254c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80254f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802552:	83 ec 08             	sub    $0x8,%esp
  802555:	50                   	push   %eax
  802556:	ff 75 d8             	pushl  -0x28(%ebp)
  802559:	e8 9f f8 ff ff       	call   801dfd <initialize_dynamic_allocator>
  80255e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	68 ef 42 80 00       	push   $0x8042ef
  802569:	e8 23 de ff ff       	call   800391 <cprintf>
  80256e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80257f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802586:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80258d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802595:	e9 1d 01 00 00       	jmp    8026b7 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	ff 75 a8             	pushl  -0x58(%ebp)
  8025a6:	e8 ee f6 ff ff       	call   801c99 <get_block_size>
  8025ab:	83 c4 10             	add    $0x10,%esp
  8025ae:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	83 c0 08             	add    $0x8,%eax
  8025b7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ba:	0f 87 ef 00 00 00    	ja     8026af <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	83 c0 18             	add    $0x18,%eax
  8025c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025c9:	77 1d                	ja     8025e8 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025d1:	0f 86 d8 00 00 00    	jbe    8026af <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025d7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025da:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025dd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025e3:	e9 c7 00 00 00       	jmp    8026af <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	83 c0 08             	add    $0x8,%eax
  8025ee:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025f1:	0f 85 9d 00 00 00    	jne    802694 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025f7:	83 ec 04             	sub    $0x4,%esp
  8025fa:	6a 01                	push   $0x1
  8025fc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025ff:	ff 75 a8             	pushl  -0x58(%ebp)
  802602:	e8 e3 f9 ff ff       	call   801fea <set_block_data>
  802607:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	75 17                	jne    802627 <alloc_block_BF+0x152>
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	68 93 42 80 00       	push   $0x804293
  802618:	68 2c 01 00 00       	push   $0x12c
  80261d:	68 b1 42 80 00       	push   $0x8042b1
  802622:	e8 32 12 00 00       	call   803859 <_panic>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 10                	je     802640 <alloc_block_BF+0x16b>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	8b 52 04             	mov    0x4(%edx),%edx
  80263b:	89 50 04             	mov    %edx,0x4(%eax)
  80263e:	eb 0b                	jmp    80264b <alloc_block_BF+0x176>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	a3 30 50 80 00       	mov    %eax,0x805030
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 0f                	je     802664 <alloc_block_BF+0x18f>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265e:	8b 12                	mov    (%edx),%edx
  802660:	89 10                	mov    %edx,(%eax)
  802662:	eb 0a                	jmp    80266e <alloc_block_BF+0x199>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802681:	a1 38 50 80 00       	mov    0x805038,%eax
  802686:	48                   	dec    %eax
  802687:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80268c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80268f:	e9 24 04 00 00       	jmp    802ab8 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80269a:	76 13                	jbe    8026af <alloc_block_BF+0x1da>
					{
						internal = 1;
  80269c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8026a3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8026a9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026ac:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026af:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	74 07                	je     8026c4 <alloc_block_BF+0x1ef>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <alloc_block_BF+0x1f4>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	0f 85 bf fe ff ff    	jne    80259a <alloc_block_BF+0xc5>
  8026db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026df:	0f 85 b5 fe ff ff    	jne    80259a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e9:	0f 84 26 02 00 00    	je     802915 <alloc_block_BF+0x440>
  8026ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f3:	0f 85 1c 02 00 00    	jne    802915 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ff:	83 e8 08             	sub    $0x8,%eax
  802702:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	8d 50 08             	lea    0x8(%eax),%edx
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	01 d0                	add    %edx,%eax
  802710:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	83 c0 08             	add    $0x8,%eax
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	6a 01                	push   $0x1
  80271e:	50                   	push   %eax
  80271f:	ff 75 f0             	pushl  -0x10(%ebp)
  802722:	e8 c3 f8 ff ff       	call   801fea <set_block_data>
  802727:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	75 68                	jne    80279c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802734:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802738:	75 17                	jne    802751 <alloc_block_BF+0x27c>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 cc 42 80 00       	push   $0x8042cc
  802742:	68 45 01 00 00       	push   $0x145
  802747:	68 b1 42 80 00       	push   $0x8042b1
  80274c:	e8 08 11 00 00       	call   803859 <_panic>
  802751:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802757:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275a:	89 10                	mov    %edx,(%eax)
  80275c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 0d                	je     802772 <alloc_block_BF+0x29d>
  802765:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80276a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80276d:	89 50 04             	mov    %edx,0x4(%eax)
  802770:	eb 08                	jmp    80277a <alloc_block_BF+0x2a5>
  802772:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802775:	a3 30 50 80 00       	mov    %eax,0x805030
  80277a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802785:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278c:	a1 38 50 80 00       	mov    0x805038,%eax
  802791:	40                   	inc    %eax
  802792:	a3 38 50 80 00       	mov    %eax,0x805038
  802797:	e9 dc 00 00 00       	jmp    802878 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	75 65                	jne    80280a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027a9:	75 17                	jne    8027c2 <alloc_block_BF+0x2ed>
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	68 00 43 80 00       	push   $0x804300
  8027b3:	68 4a 01 00 00       	push   $0x14a
  8027b8:	68 b1 42 80 00       	push   $0x8042b1
  8027bd:	e8 97 10 00 00       	call   803859 <_panic>
  8027c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 0c                	je     8027e4 <alloc_block_BF+0x30f>
  8027d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8027dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	eb 08                	jmp    8027ec <alloc_block_BF+0x317>
  8027e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802802:	40                   	inc    %eax
  802803:	a3 38 50 80 00       	mov    %eax,0x805038
  802808:	eb 6e                	jmp    802878 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80280a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280e:	74 06                	je     802816 <alloc_block_BF+0x341>
  802810:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802814:	75 17                	jne    80282d <alloc_block_BF+0x358>
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	68 24 43 80 00       	push   $0x804324
  80281e:	68 4f 01 00 00       	push   $0x14f
  802823:	68 b1 42 80 00       	push   $0x8042b1
  802828:	e8 2c 10 00 00       	call   803859 <_panic>
  80282d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802830:	8b 10                	mov    (%eax),%edx
  802832:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802835:	89 10                	mov    %edx,(%eax)
  802837:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0b                	je     80284b <alloc_block_BF+0x376>
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802848:	89 50 04             	mov    %edx,0x4(%eax)
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802851:	89 10                	mov    %edx,(%eax)
  802853:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	75 08                	jne    80286d <alloc_block_BF+0x398>
  802865:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802868:	a3 30 50 80 00       	mov    %eax,0x805030
  80286d:	a1 38 50 80 00       	mov    0x805038,%eax
  802872:	40                   	inc    %eax
  802873:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287c:	75 17                	jne    802895 <alloc_block_BF+0x3c0>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 93 42 80 00       	push   $0x804293
  802886:	68 51 01 00 00       	push   $0x151
  80288b:	68 b1 42 80 00       	push   $0x8042b1
  802890:	e8 c4 0f 00 00       	call   803859 <_panic>
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 10                	je     8028ae <alloc_block_BF+0x3d9>
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a6:	8b 52 04             	mov    0x4(%edx),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	eb 0b                	jmp    8028b9 <alloc_block_BF+0x3e4>
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 0f                	je     8028d2 <alloc_block_BF+0x3fd>
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cc:	8b 12                	mov    (%edx),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 0a                	jmp    8028dc <alloc_block_BF+0x407>
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8028f4:	48                   	dec    %eax
  8028f5:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	6a 00                	push   $0x0
  8028ff:	ff 75 d0             	pushl  -0x30(%ebp)
  802902:	ff 75 cc             	pushl  -0x34(%ebp)
  802905:	e8 e0 f6 ff ff       	call   801fea <set_block_data>
  80290a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	e9 a3 01 00 00       	jmp    802ab8 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802915:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802919:	0f 85 9d 00 00 00    	jne    8029bc <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	6a 01                	push   $0x1
  802924:	ff 75 ec             	pushl  -0x14(%ebp)
  802927:	ff 75 f0             	pushl  -0x10(%ebp)
  80292a:	e8 bb f6 ff ff       	call   801fea <set_block_data>
  80292f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802932:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802936:	75 17                	jne    80294f <alloc_block_BF+0x47a>
  802938:	83 ec 04             	sub    $0x4,%esp
  80293b:	68 93 42 80 00       	push   $0x804293
  802940:	68 58 01 00 00       	push   $0x158
  802945:	68 b1 42 80 00       	push   $0x8042b1
  80294a:	e8 0a 0f 00 00       	call   803859 <_panic>
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 10                	je     802968 <alloc_block_BF+0x493>
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	8b 00                	mov    (%eax),%eax
  80295d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802960:	8b 52 04             	mov    0x4(%edx),%edx
  802963:	89 50 04             	mov    %edx,0x4(%eax)
  802966:	eb 0b                	jmp    802973 <alloc_block_BF+0x49e>
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	a3 30 50 80 00       	mov    %eax,0x805030
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 0f                	je     80298c <alloc_block_BF+0x4b7>
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802986:	8b 12                	mov    (%edx),%edx
  802988:	89 10                	mov    %edx,(%eax)
  80298a:	eb 0a                	jmp    802996 <alloc_block_BF+0x4c1>
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ae:	48                   	dec    %eax
  8029af:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	e9 fc 00 00 00       	jmp    802ab8 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	83 c0 08             	add    $0x8,%eax
  8029c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029c5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029d2:	01 d0                	add    %edx,%eax
  8029d4:	48                   	dec    %eax
  8029d5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029db:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e0:	f7 75 c4             	divl   -0x3c(%ebp)
  8029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029e6:	29 d0                	sub    %edx,%eax
  8029e8:	c1 e8 0c             	shr    $0xc,%eax
  8029eb:	83 ec 0c             	sub    $0xc,%esp
  8029ee:	50                   	push   %eax
  8029ef:	e8 37 e7 ff ff       	call   80112b <sbrk>
  8029f4:	83 c4 10             	add    $0x10,%esp
  8029f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029fa:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029fe:	75 0a                	jne    802a0a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	e9 ae 00 00 00       	jmp    802ab8 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a0a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a11:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a14:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a17:	01 d0                	add    %edx,%eax
  802a19:	48                   	dec    %eax
  802a1a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a20:	ba 00 00 00 00       	mov    $0x0,%edx
  802a25:	f7 75 b8             	divl   -0x48(%ebp)
  802a28:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a2b:	29 d0                	sub    %edx,%eax
  802a2d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a30:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a3a:	a1 40 50 80 00       	mov    0x805040,%eax
  802a3f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a45:	83 ec 0c             	sub    $0xc,%esp
  802a48:	68 58 43 80 00       	push   $0x804358
  802a4d:	e8 3f d9 ff ff       	call   800391 <cprintf>
  802a52:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a55:	83 ec 08             	sub    $0x8,%esp
  802a58:	ff 75 bc             	pushl  -0x44(%ebp)
  802a5b:	68 5d 43 80 00       	push   $0x80435d
  802a60:	e8 2c d9 ff ff       	call   800391 <cprintf>
  802a65:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a68:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a6f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a72:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	48                   	dec    %eax
  802a78:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a7b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a83:	f7 75 b0             	divl   -0x50(%ebp)
  802a86:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a89:	29 d0                	sub    %edx,%eax
  802a8b:	83 ec 04             	sub    $0x4,%esp
  802a8e:	6a 01                	push   $0x1
  802a90:	50                   	push   %eax
  802a91:	ff 75 bc             	pushl  -0x44(%ebp)
  802a94:	e8 51 f5 ff ff       	call   801fea <set_block_data>
  802a99:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a9c:	83 ec 0c             	sub    $0xc,%esp
  802a9f:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa2:	e8 36 04 00 00       	call   802edd <free_block>
  802aa7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802aaa:	83 ec 0c             	sub    $0xc,%esp
  802aad:	ff 75 08             	pushl  0x8(%ebp)
  802ab0:	e8 20 fa ff ff       	call   8024d5 <alloc_block_BF>
  802ab5:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    

00802aba <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
  802abd:	53                   	push   %ebx
  802abe:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ac1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802acf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad3:	74 1e                	je     802af3 <merging+0x39>
  802ad5:	ff 75 08             	pushl  0x8(%ebp)
  802ad8:	e8 bc f1 ff ff       	call   801c99 <get_block_size>
  802add:	83 c4 04             	add    $0x4,%esp
  802ae0:	89 c2                	mov    %eax,%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	01 d0                	add    %edx,%eax
  802ae7:	3b 45 10             	cmp    0x10(%ebp),%eax
  802aea:	75 07                	jne    802af3 <merging+0x39>
		prev_is_free = 1;
  802aec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802af3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802af7:	74 1e                	je     802b17 <merging+0x5d>
  802af9:	ff 75 10             	pushl  0x10(%ebp)
  802afc:	e8 98 f1 ff ff       	call   801c99 <get_block_size>
  802b01:	83 c4 04             	add    $0x4,%esp
  802b04:	89 c2                	mov    %eax,%edx
  802b06:	8b 45 10             	mov    0x10(%ebp),%eax
  802b09:	01 d0                	add    %edx,%eax
  802b0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b0e:	75 07                	jne    802b17 <merging+0x5d>
		next_is_free = 1;
  802b10:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1b:	0f 84 cc 00 00 00    	je     802bed <merging+0x133>
  802b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b25:	0f 84 c2 00 00 00    	je     802bed <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b2b:	ff 75 08             	pushl  0x8(%ebp)
  802b2e:	e8 66 f1 ff ff       	call   801c99 <get_block_size>
  802b33:	83 c4 04             	add    $0x4,%esp
  802b36:	89 c3                	mov    %eax,%ebx
  802b38:	ff 75 10             	pushl  0x10(%ebp)
  802b3b:	e8 59 f1 ff ff       	call   801c99 <get_block_size>
  802b40:	83 c4 04             	add    $0x4,%esp
  802b43:	01 c3                	add    %eax,%ebx
  802b45:	ff 75 0c             	pushl  0xc(%ebp)
  802b48:	e8 4c f1 ff ff       	call   801c99 <get_block_size>
  802b4d:	83 c4 04             	add    $0x4,%esp
  802b50:	01 d8                	add    %ebx,%eax
  802b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b55:	6a 00                	push   $0x0
  802b57:	ff 75 ec             	pushl  -0x14(%ebp)
  802b5a:	ff 75 08             	pushl  0x8(%ebp)
  802b5d:	e8 88 f4 ff ff       	call   801fea <set_block_data>
  802b62:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b69:	75 17                	jne    802b82 <merging+0xc8>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 93 42 80 00       	push   $0x804293
  802b73:	68 7d 01 00 00       	push   $0x17d
  802b78:	68 b1 42 80 00       	push   $0x8042b1
  802b7d:	e8 d7 0c 00 00       	call   803859 <_panic>
  802b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 10                	je     802b9b <merging+0xe1>
  802b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b93:	8b 52 04             	mov    0x4(%edx),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 0b                	jmp    802ba6 <merging+0xec>
  802b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0f                	je     802bbf <merging+0x105>
  802bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb9:	8b 12                	mov    (%edx),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 0a                	jmp    802bc9 <merging+0x10f>
  802bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 38 50 80 00       	mov    0x805038,%eax
  802be1:	48                   	dec    %eax
  802be2:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802be7:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802be8:	e9 ea 02 00 00       	jmp    802ed7 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf1:	74 3b                	je     802c2e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bf3:	83 ec 0c             	sub    $0xc,%esp
  802bf6:	ff 75 08             	pushl  0x8(%ebp)
  802bf9:	e8 9b f0 ff ff       	call   801c99 <get_block_size>
  802bfe:	83 c4 10             	add    $0x10,%esp
  802c01:	89 c3                	mov    %eax,%ebx
  802c03:	83 ec 0c             	sub    $0xc,%esp
  802c06:	ff 75 10             	pushl  0x10(%ebp)
  802c09:	e8 8b f0 ff ff       	call   801c99 <get_block_size>
  802c0e:	83 c4 10             	add    $0x10,%esp
  802c11:	01 d8                	add    %ebx,%eax
  802c13:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	6a 00                	push   $0x0
  802c1b:	ff 75 e8             	pushl  -0x18(%ebp)
  802c1e:	ff 75 08             	pushl  0x8(%ebp)
  802c21:	e8 c4 f3 ff ff       	call   801fea <set_block_data>
  802c26:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c29:	e9 a9 02 00 00       	jmp    802ed7 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c32:	0f 84 2d 01 00 00    	je     802d65 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c38:	83 ec 0c             	sub    $0xc,%esp
  802c3b:	ff 75 10             	pushl  0x10(%ebp)
  802c3e:	e8 56 f0 ff ff       	call   801c99 <get_block_size>
  802c43:	83 c4 10             	add    $0x10,%esp
  802c46:	89 c3                	mov    %eax,%ebx
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	ff 75 0c             	pushl  0xc(%ebp)
  802c4e:	e8 46 f0 ff ff       	call   801c99 <get_block_size>
  802c53:	83 c4 10             	add    $0x10,%esp
  802c56:	01 d8                	add    %ebx,%eax
  802c58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	6a 00                	push   $0x0
  802c60:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c63:	ff 75 10             	pushl  0x10(%ebp)
  802c66:	e8 7f f3 ff ff       	call   801fea <set_block_data>
  802c6b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  802c71:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c78:	74 06                	je     802c80 <merging+0x1c6>
  802c7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c7e:	75 17                	jne    802c97 <merging+0x1dd>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 6c 43 80 00       	push   $0x80436c
  802c88:	68 8d 01 00 00       	push   $0x18d
  802c8d:	68 b1 42 80 00       	push   $0x8042b1
  802c92:	e8 c2 0b 00 00       	call   803859 <_panic>
  802c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9a:	8b 50 04             	mov    0x4(%eax),%edx
  802c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca0:	89 50 04             	mov    %edx,0x4(%eax)
  802ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca9:	89 10                	mov    %edx,(%eax)
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 0d                	je     802cc2 <merging+0x208>
  802cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cbe:	89 10                	mov    %edx,(%eax)
  802cc0:	eb 08                	jmp    802cca <merging+0x210>
  802cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd0:	89 50 04             	mov    %edx,0x4(%eax)
  802cd3:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd8:	40                   	inc    %eax
  802cd9:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce2:	75 17                	jne    802cfb <merging+0x241>
  802ce4:	83 ec 04             	sub    $0x4,%esp
  802ce7:	68 93 42 80 00       	push   $0x804293
  802cec:	68 8e 01 00 00       	push   $0x18e
  802cf1:	68 b1 42 80 00       	push   $0x8042b1
  802cf6:	e8 5e 0b 00 00       	call   803859 <_panic>
  802cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 10                	je     802d14 <merging+0x25a>
  802d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0c:	8b 52 04             	mov    0x4(%edx),%edx
  802d0f:	89 50 04             	mov    %edx,0x4(%eax)
  802d12:	eb 0b                	jmp    802d1f <merging+0x265>
  802d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	74 0f                	je     802d38 <merging+0x27e>
  802d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d32:	8b 12                	mov    (%edx),%edx
  802d34:	89 10                	mov    %edx,(%eax)
  802d36:	eb 0a                	jmp    802d42 <merging+0x288>
  802d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5a:	48                   	dec    %eax
  802d5b:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d60:	e9 72 01 00 00       	jmp    802ed7 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d65:	8b 45 10             	mov    0x10(%ebp),%eax
  802d68:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6f:	74 79                	je     802dea <merging+0x330>
  802d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d75:	74 73                	je     802dea <merging+0x330>
  802d77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7b:	74 06                	je     802d83 <merging+0x2c9>
  802d7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d81:	75 17                	jne    802d9a <merging+0x2e0>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 24 43 80 00       	push   $0x804324
  802d8b:	68 94 01 00 00       	push   $0x194
  802d90:	68 b1 42 80 00       	push   $0x8042b1
  802d95:	e8 bf 0a 00 00       	call   803859 <_panic>
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 10                	mov    (%eax),%edx
  802d9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da2:	89 10                	mov    %edx,(%eax)
  802da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 0b                	je     802db8 <merging+0x2fe>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dbe:	89 10                	mov    %edx,(%eax)
  802dc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc6:	89 50 04             	mov    %edx,0x4(%eax)
  802dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	75 08                	jne    802dda <merging+0x320>
  802dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd5:	a3 30 50 80 00       	mov    %eax,0x805030
  802dda:	a1 38 50 80 00       	mov    0x805038,%eax
  802ddf:	40                   	inc    %eax
  802de0:	a3 38 50 80 00       	mov    %eax,0x805038
  802de5:	e9 ce 00 00 00       	jmp    802eb8 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802dea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dee:	74 65                	je     802e55 <merging+0x39b>
  802df0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df4:	75 17                	jne    802e0d <merging+0x353>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 00 43 80 00       	push   $0x804300
  802dfe:	68 95 01 00 00       	push   $0x195
  802e03:	68 b1 42 80 00       	push   $0x8042b1
  802e08:	e8 4c 0a 00 00       	call   803859 <_panic>
  802e0d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e16:	89 50 04             	mov    %edx,0x4(%eax)
  802e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0c                	je     802e2f <merging+0x375>
  802e23:	a1 30 50 80 00       	mov    0x805030,%eax
  802e28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	eb 08                	jmp    802e37 <merging+0x37d>
  802e2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e32:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e48:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 38 50 80 00       	mov    %eax,0x805038
  802e53:	eb 63                	jmp    802eb8 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e59:	75 17                	jne    802e72 <merging+0x3b8>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 cc 42 80 00       	push   $0x8042cc
  802e63:	68 98 01 00 00       	push   $0x198
  802e68:	68 b1 42 80 00       	push   $0x8042b1
  802e6d:	e8 e7 09 00 00       	call   803859 <_panic>
  802e72:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0d                	je     802e93 <merging+0x3d9>
  802e86:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	eb 08                	jmp    802e9b <merging+0x3e1>
  802e93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e96:	a3 30 50 80 00       	mov    %eax,0x805030
  802e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ead:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb2:	40                   	inc    %eax
  802eb3:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802eb8:	83 ec 0c             	sub    $0xc,%esp
  802ebb:	ff 75 10             	pushl  0x10(%ebp)
  802ebe:	e8 d6 ed ff ff       	call   801c99 <get_block_size>
  802ec3:	83 c4 10             	add    $0x10,%esp
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	6a 00                	push   $0x0
  802ecb:	50                   	push   %eax
  802ecc:	ff 75 10             	pushl  0x10(%ebp)
  802ecf:	e8 16 f1 ff ff       	call   801fea <set_block_data>
  802ed4:	83 c4 10             	add    $0x10,%esp
	}
}
  802ed7:	90                   	nop
  802ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802edb:	c9                   	leave  
  802edc:	c3                   	ret    

00802edd <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ee3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802eeb:	a1 30 50 80 00       	mov    0x805030,%eax
  802ef0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef3:	73 1b                	jae    802f10 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802ef5:	a1 30 50 80 00       	mov    0x805030,%eax
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	ff 75 08             	pushl  0x8(%ebp)
  802f00:	6a 00                	push   $0x0
  802f02:	50                   	push   %eax
  802f03:	e8 b2 fb ff ff       	call   802aba <merging>
  802f08:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f0b:	e9 8b 00 00 00       	jmp    802f9b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f10:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f18:	76 18                	jbe    802f32 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f1a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f1f:	83 ec 04             	sub    $0x4,%esp
  802f22:	ff 75 08             	pushl  0x8(%ebp)
  802f25:	50                   	push   %eax
  802f26:	6a 00                	push   $0x0
  802f28:	e8 8d fb ff ff       	call   802aba <merging>
  802f2d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f30:	eb 69                	jmp    802f9b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f32:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3a:	eb 39                	jmp    802f75 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f42:	73 29                	jae    802f6d <free_block+0x90>
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4c:	76 1f                	jbe    802f6d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	ff 75 08             	pushl  0x8(%ebp)
  802f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  802f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f62:	e8 53 fb ff ff       	call   802aba <merging>
  802f67:	83 c4 10             	add    $0x10,%esp
			break;
  802f6a:	90                   	nop
		}
	}
}
  802f6b:	eb 2e                	jmp    802f9b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f6d:	a1 34 50 80 00       	mov    0x805034,%eax
  802f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f79:	74 07                	je     802f82 <free_block+0xa5>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	eb 05                	jmp    802f87 <free_block+0xaa>
  802f82:	b8 00 00 00 00       	mov    $0x0,%eax
  802f87:	a3 34 50 80 00       	mov    %eax,0x805034
  802f8c:	a1 34 50 80 00       	mov    0x805034,%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	75 a7                	jne    802f3c <free_block+0x5f>
  802f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f99:	75 a1                	jne    802f3c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f9b:	90                   	nop
  802f9c:	c9                   	leave  
  802f9d:	c3                   	ret    

00802f9e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f9e:	55                   	push   %ebp
  802f9f:	89 e5                	mov    %esp,%ebp
  802fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802fa4:	ff 75 08             	pushl  0x8(%ebp)
  802fa7:	e8 ed ec ff ff       	call   801c99 <get_block_size>
  802fac:	83 c4 04             	add    $0x4,%esp
  802faf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802fb9:	eb 17                	jmp    802fd2 <copy_data+0x34>
  802fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	01 c8                	add    %ecx,%eax
  802fcb:	8a 00                	mov    (%eax),%al
  802fcd:	88 02                	mov    %al,(%edx)
  802fcf:	ff 45 fc             	incl   -0x4(%ebp)
  802fd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fd5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fd8:	72 e1                	jb     802fbb <copy_data+0x1d>
}
  802fda:	90                   	nop
  802fdb:	c9                   	leave  
  802fdc:	c3                   	ret    

00802fdd <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fdd:	55                   	push   %ebp
  802fde:	89 e5                	mov    %esp,%ebp
  802fe0:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fe3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe7:	75 23                	jne    80300c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fed:	74 13                	je     803002 <realloc_block_FF+0x25>
  802fef:	83 ec 0c             	sub    $0xc,%esp
  802ff2:	ff 75 0c             	pushl  0xc(%ebp)
  802ff5:	e8 1f f0 ff ff       	call   802019 <alloc_block_FF>
  802ffa:	83 c4 10             	add    $0x10,%esp
  802ffd:	e9 f4 06 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
		return NULL;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
  803007:	e9 ea 06 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80300c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803010:	75 18                	jne    80302a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	ff 75 08             	pushl  0x8(%ebp)
  803018:	e8 c0 fe ff ff       	call   802edd <free_block>
  80301d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803020:	b8 00 00 00 00       	mov    $0x0,%eax
  803025:	e9 cc 06 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80302a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80302e:	77 07                	ja     803037 <realloc_block_FF+0x5a>
  803030:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303a:	83 e0 01             	and    $0x1,%eax
  80303d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803040:	8b 45 0c             	mov    0xc(%ebp),%eax
  803043:	83 c0 08             	add    $0x8,%eax
  803046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803049:	83 ec 0c             	sub    $0xc,%esp
  80304c:	ff 75 08             	pushl  0x8(%ebp)
  80304f:	e8 45 ec ff ff       	call   801c99 <get_block_size>
  803054:	83 c4 10             	add    $0x10,%esp
  803057:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80305a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305d:	83 e8 08             	sub    $0x8,%eax
  803060:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	83 e8 04             	sub    $0x4,%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	83 e0 fe             	and    $0xfffffffe,%eax
  80306e:	89 c2                	mov    %eax,%edx
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	01 d0                	add    %edx,%eax
  803075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803078:	83 ec 0c             	sub    $0xc,%esp
  80307b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80307e:	e8 16 ec ff ff       	call   801c99 <get_block_size>
  803083:	83 c4 10             	add    $0x10,%esp
  803086:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803089:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308c:	83 e8 08             	sub    $0x8,%eax
  80308f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803092:	8b 45 0c             	mov    0xc(%ebp),%eax
  803095:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803098:	75 08                	jne    8030a2 <realloc_block_FF+0xc5>
	{
		 return va;
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	e9 54 06 00 00       	jmp    8036f6 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030a8:	0f 83 e5 03 00 00    	jae    803493 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8030b7:	83 ec 0c             	sub    $0xc,%esp
  8030ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030bd:	e8 f0 eb ff ff       	call   801cb2 <is_free_block>
  8030c2:	83 c4 10             	add    $0x10,%esp
  8030c5:	84 c0                	test   %al,%al
  8030c7:	0f 84 3b 01 00 00    	je     803208 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d3:	01 d0                	add    %edx,%eax
  8030d5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	6a 01                	push   $0x1
  8030dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e0:	ff 75 08             	pushl  0x8(%ebp)
  8030e3:	e8 02 ef ff ff       	call   801fea <set_block_data>
  8030e8:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	83 e8 04             	sub    $0x4,%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	83 e0 fe             	and    $0xfffffffe,%eax
  8030f6:	89 c2                	mov    %eax,%edx
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	01 d0                	add    %edx,%eax
  8030fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	6a 00                	push   $0x0
  803105:	ff 75 cc             	pushl  -0x34(%ebp)
  803108:	ff 75 c8             	pushl  -0x38(%ebp)
  80310b:	e8 da ee ff ff       	call   801fea <set_block_data>
  803110:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803113:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803117:	74 06                	je     80311f <realloc_block_FF+0x142>
  803119:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80311d:	75 17                	jne    803136 <realloc_block_FF+0x159>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 24 43 80 00       	push   $0x804324
  803127:	68 f6 01 00 00       	push   $0x1f6
  80312c:	68 b1 42 80 00       	push   $0x8042b1
  803131:	e8 23 07 00 00       	call   803859 <_panic>
  803136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803139:	8b 10                	mov    (%eax),%edx
  80313b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0b                	je     803154 <realloc_block_FF+0x177>
  803149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80315f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803162:	89 50 04             	mov    %edx,0x4(%eax)
  803165:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	75 08                	jne    803176 <realloc_block_FF+0x199>
  80316e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803171:	a3 30 50 80 00       	mov    %eax,0x805030
  803176:	a1 38 50 80 00       	mov    0x805038,%eax
  80317b:	40                   	inc    %eax
  80317c:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803181:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803185:	75 17                	jne    80319e <realloc_block_FF+0x1c1>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 93 42 80 00       	push   $0x804293
  80318f:	68 f7 01 00 00       	push   $0x1f7
  803194:	68 b1 42 80 00       	push   $0x8042b1
  803199:	e8 bb 06 00 00       	call   803859 <_panic>
  80319e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 10                	je     8031b7 <realloc_block_FF+0x1da>
  8031a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031af:	8b 52 04             	mov    0x4(%edx),%edx
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
  8031b5:	eb 0b                	jmp    8031c2 <realloc_block_FF+0x1e5>
  8031b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0f                	je     8031db <realloc_block_FF+0x1fe>
  8031cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cf:	8b 40 04             	mov    0x4(%eax),%eax
  8031d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031d5:	8b 12                	mov    (%edx),%edx
  8031d7:	89 10                	mov    %edx,(%eax)
  8031d9:	eb 0a                	jmp    8031e5 <realloc_block_FF+0x208>
  8031db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fd:	48                   	dec    %eax
  8031fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803203:	e9 83 02 00 00       	jmp    80348b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803208:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80320c:	0f 86 69 02 00 00    	jbe    80347b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803212:	83 ec 04             	sub    $0x4,%esp
  803215:	6a 01                	push   $0x1
  803217:	ff 75 f0             	pushl  -0x10(%ebp)
  80321a:	ff 75 08             	pushl  0x8(%ebp)
  80321d:	e8 c8 ed ff ff       	call   801fea <set_block_data>
  803222:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	83 e8 04             	sub    $0x4,%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	83 e0 fe             	and    $0xfffffffe,%eax
  803230:	89 c2                	mov    %eax,%edx
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	01 d0                	add    %edx,%eax
  803237:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80323a:	a1 38 50 80 00       	mov    0x805038,%eax
  80323f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803242:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803246:	75 68                	jne    8032b0 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803248:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80324c:	75 17                	jne    803265 <realloc_block_FF+0x288>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 cc 42 80 00       	push   $0x8042cc
  803256:	68 06 02 00 00       	push   $0x206
  80325b:	68 b1 42 80 00       	push   $0x8042b1
  803260:	e8 f4 05 00 00       	call   803859 <_panic>
  803265:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80326b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0d                	je     803286 <realloc_block_FF+0x2a9>
  803279:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80327e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 08                	jmp    80328e <realloc_block_FF+0x2b1>
  803286:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803289:	a3 30 50 80 00       	mov    %eax,0x805030
  80328e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803291:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803296:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ab:	e9 b0 01 00 00       	jmp    803460 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032b8:	76 68                	jbe    803322 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032be:	75 17                	jne    8032d7 <realloc_block_FF+0x2fa>
  8032c0:	83 ec 04             	sub    $0x4,%esp
  8032c3:	68 cc 42 80 00       	push   $0x8042cc
  8032c8:	68 0b 02 00 00       	push   $0x20b
  8032cd:	68 b1 42 80 00       	push   $0x8042b1
  8032d2:	e8 82 05 00 00       	call   803859 <_panic>
  8032d7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 0d                	je     8032f8 <realloc_block_FF+0x31b>
  8032eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032f3:	89 50 04             	mov    %edx,0x4(%eax)
  8032f6:	eb 08                	jmp    803300 <realloc_block_FF+0x323>
  8032f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803300:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803303:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803312:	a1 38 50 80 00       	mov    0x805038,%eax
  803317:	40                   	inc    %eax
  803318:	a3 38 50 80 00       	mov    %eax,0x805038
  80331d:	e9 3e 01 00 00       	jmp    803460 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803322:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803327:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80332a:	73 68                	jae    803394 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80332c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803330:	75 17                	jne    803349 <realloc_block_FF+0x36c>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 00 43 80 00       	push   $0x804300
  80333a:	68 10 02 00 00       	push   $0x210
  80333f:	68 b1 42 80 00       	push   $0x8042b1
  803344:	e8 10 05 00 00       	call   803859 <_panic>
  803349:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80334f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 0c                	je     80336b <realloc_block_FF+0x38e>
  80335f:	a1 30 50 80 00       	mov    0x805030,%eax
  803364:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803367:	89 10                	mov    %edx,(%eax)
  803369:	eb 08                	jmp    803373 <realloc_block_FF+0x396>
  80336b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803373:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803376:	a3 30 50 80 00       	mov    %eax,0x805030
  80337b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803384:	a1 38 50 80 00       	mov    0x805038,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 38 50 80 00       	mov    %eax,0x805038
  80338f:	e9 cc 00 00 00       	jmp    803460 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80339b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a3:	e9 8a 00 00 00       	jmp    803432 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033ae:	73 7a                	jae    80342a <realloc_block_FF+0x44d>
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	8b 00                	mov    (%eax),%eax
  8033b5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033b8:	73 70                	jae    80342a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8033ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033be:	74 06                	je     8033c6 <realloc_block_FF+0x3e9>
  8033c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c4:	75 17                	jne    8033dd <realloc_block_FF+0x400>
  8033c6:	83 ec 04             	sub    $0x4,%esp
  8033c9:	68 24 43 80 00       	push   $0x804324
  8033ce:	68 1a 02 00 00       	push   $0x21a
  8033d3:	68 b1 42 80 00       	push   $0x8042b1
  8033d8:	e8 7c 04 00 00       	call   803859 <_panic>
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 10                	mov    (%eax),%edx
  8033e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e5:	89 10                	mov    %edx,(%eax)
  8033e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	74 0b                	je     8033fb <realloc_block_FF+0x41e>
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f8:	89 50 04             	mov    %edx,0x4(%eax)
  8033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803401:	89 10                	mov    %edx,(%eax)
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803409:	89 50 04             	mov    %edx,0x4(%eax)
  80340c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	75 08                	jne    80341d <realloc_block_FF+0x440>
  803415:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803418:	a3 30 50 80 00       	mov    %eax,0x805030
  80341d:	a1 38 50 80 00       	mov    0x805038,%eax
  803422:	40                   	inc    %eax
  803423:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803428:	eb 36                	jmp    803460 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80342a:	a1 34 50 80 00       	mov    0x805034,%eax
  80342f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803436:	74 07                	je     80343f <realloc_block_FF+0x462>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	eb 05                	jmp    803444 <realloc_block_FF+0x467>
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
  803444:	a3 34 50 80 00       	mov    %eax,0x805034
  803449:	a1 34 50 80 00       	mov    0x805034,%eax
  80344e:	85 c0                	test   %eax,%eax
  803450:	0f 85 52 ff ff ff    	jne    8033a8 <realloc_block_FF+0x3cb>
  803456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345a:	0f 85 48 ff ff ff    	jne    8033a8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803460:	83 ec 04             	sub    $0x4,%esp
  803463:	6a 00                	push   $0x0
  803465:	ff 75 d8             	pushl  -0x28(%ebp)
  803468:	ff 75 d4             	pushl  -0x2c(%ebp)
  80346b:	e8 7a eb ff ff       	call   801fea <set_block_data>
  803470:	83 c4 10             	add    $0x10,%esp
				return va;
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	e9 7b 02 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80347b:	83 ec 0c             	sub    $0xc,%esp
  80347e:	68 a1 43 80 00       	push   $0x8043a1
  803483:	e8 09 cf ff ff       	call   800391 <cprintf>
  803488:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	e9 63 02 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803493:	8b 45 0c             	mov    0xc(%ebp),%eax
  803496:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803499:	0f 86 4d 02 00 00    	jbe    8036ec <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80349f:	83 ec 0c             	sub    $0xc,%esp
  8034a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a5:	e8 08 e8 ff ff       	call   801cb2 <is_free_block>
  8034aa:	83 c4 10             	add    $0x10,%esp
  8034ad:	84 c0                	test   %al,%al
  8034af:	0f 84 37 02 00 00    	je     8036ec <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8034b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034bb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8034be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034c4:	76 38                	jbe    8034fe <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034c6:	83 ec 0c             	sub    $0xc,%esp
  8034c9:	ff 75 08             	pushl  0x8(%ebp)
  8034cc:	e8 0c fa ff ff       	call   802edd <free_block>
  8034d1:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034d4:	83 ec 0c             	sub    $0xc,%esp
  8034d7:	ff 75 0c             	pushl  0xc(%ebp)
  8034da:	e8 3a eb ff ff       	call   802019 <alloc_block_FF>
  8034df:	83 c4 10             	add    $0x10,%esp
  8034e2:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034e5:	83 ec 08             	sub    $0x8,%esp
  8034e8:	ff 75 c0             	pushl  -0x40(%ebp)
  8034eb:	ff 75 08             	pushl  0x8(%ebp)
  8034ee:	e8 ab fa ff ff       	call   802f9e <copy_data>
  8034f3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034f6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034f9:	e9 f8 01 00 00       	jmp    8036f6 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803501:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803504:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803507:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80350b:	0f 87 a0 00 00 00    	ja     8035b1 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803511:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803515:	75 17                	jne    80352e <realloc_block_FF+0x551>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 93 42 80 00       	push   $0x804293
  80351f:	68 38 02 00 00       	push   $0x238
  803524:	68 b1 42 80 00       	push   $0x8042b1
  803529:	e8 2b 03 00 00       	call   803859 <_panic>
  80352e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 10                	je     803547 <realloc_block_FF+0x56a>
  803537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80353f:	8b 52 04             	mov    0x4(%edx),%edx
  803542:	89 50 04             	mov    %edx,0x4(%eax)
  803545:	eb 0b                	jmp    803552 <realloc_block_FF+0x575>
  803547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354a:	8b 40 04             	mov    0x4(%eax),%eax
  80354d:	a3 30 50 80 00       	mov    %eax,0x805030
  803552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803555:	8b 40 04             	mov    0x4(%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 0f                	je     80356b <realloc_block_FF+0x58e>
  80355c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803565:	8b 12                	mov    (%edx),%edx
  803567:	89 10                	mov    %edx,(%eax)
  803569:	eb 0a                	jmp    803575 <realloc_block_FF+0x598>
  80356b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803588:	a1 38 50 80 00       	mov    0x805038,%eax
  80358d:	48                   	dec    %eax
  80358e:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803593:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803599:	01 d0                	add    %edx,%eax
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	6a 01                	push   $0x1
  8035a0:	50                   	push   %eax
  8035a1:	ff 75 08             	pushl  0x8(%ebp)
  8035a4:	e8 41 ea ff ff       	call   801fea <set_block_data>
  8035a9:	83 c4 10             	add    $0x10,%esp
  8035ac:	e9 36 01 00 00       	jmp    8036e7 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8035b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035b7:	01 d0                	add    %edx,%eax
  8035b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8035bc:	83 ec 04             	sub    $0x4,%esp
  8035bf:	6a 01                	push   $0x1
  8035c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8035c4:	ff 75 08             	pushl  0x8(%ebp)
  8035c7:	e8 1e ea ff ff       	call   801fea <set_block_data>
  8035cc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	83 e8 04             	sub    $0x4,%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8035da:	89 c2                	mov    %eax,%edx
  8035dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035df:	01 d0                	add    %edx,%eax
  8035e1:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035e8:	74 06                	je     8035f0 <realloc_block_FF+0x613>
  8035ea:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035ee:	75 17                	jne    803607 <realloc_block_FF+0x62a>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 24 43 80 00       	push   $0x804324
  8035f8:	68 44 02 00 00       	push   $0x244
  8035fd:	68 b1 42 80 00       	push   $0x8042b1
  803602:	e8 52 02 00 00       	call   803859 <_panic>
  803607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360a:	8b 10                	mov    (%eax),%edx
  80360c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80360f:	89 10                	mov    %edx,(%eax)
  803611:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	85 c0                	test   %eax,%eax
  803618:	74 0b                	je     803625 <realloc_block_FF+0x648>
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803622:	89 50 04             	mov    %edx,0x4(%eax)
  803625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803628:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803633:	89 50 04             	mov    %edx,0x4(%eax)
  803636:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803639:	8b 00                	mov    (%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	75 08                	jne    803647 <realloc_block_FF+0x66a>
  80363f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803642:	a3 30 50 80 00       	mov    %eax,0x805030
  803647:	a1 38 50 80 00       	mov    0x805038,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803652:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803656:	75 17                	jne    80366f <realloc_block_FF+0x692>
  803658:	83 ec 04             	sub    $0x4,%esp
  80365b:	68 93 42 80 00       	push   $0x804293
  803660:	68 45 02 00 00       	push   $0x245
  803665:	68 b1 42 80 00       	push   $0x8042b1
  80366a:	e8 ea 01 00 00       	call   803859 <_panic>
  80366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803672:	8b 00                	mov    (%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 10                	je     803688 <realloc_block_FF+0x6ab>
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803680:	8b 52 04             	mov    0x4(%edx),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	eb 0b                	jmp    803693 <realloc_block_FF+0x6b6>
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	a3 30 50 80 00       	mov    %eax,0x805030
  803693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803696:	8b 40 04             	mov    0x4(%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	74 0f                	je     8036ac <realloc_block_FF+0x6cf>
  80369d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a0:	8b 40 04             	mov    0x4(%eax),%eax
  8036a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a6:	8b 12                	mov    (%edx),%edx
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	eb 0a                	jmp    8036b6 <realloc_block_FF+0x6d9>
  8036ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8036ce:	48                   	dec    %eax
  8036cf:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036d4:	83 ec 04             	sub    $0x4,%esp
  8036d7:	6a 00                	push   $0x0
  8036d9:	ff 75 bc             	pushl  -0x44(%ebp)
  8036dc:	ff 75 b8             	pushl  -0x48(%ebp)
  8036df:	e8 06 e9 ff ff       	call   801fea <set_block_data>
  8036e4:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ea:	eb 0a                	jmp    8036f6 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036ec:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036f6:	c9                   	leave  
  8036f7:	c3                   	ret    

008036f8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036f8:	55                   	push   %ebp
  8036f9:	89 e5                	mov    %esp,%ebp
  8036fb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 a8 43 80 00       	push   $0x8043a8
  803706:	68 58 02 00 00       	push   $0x258
  80370b:	68 b1 42 80 00       	push   $0x8042b1
  803710:	e8 44 01 00 00       	call   803859 <_panic>

00803715 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803715:	55                   	push   %ebp
  803716:	89 e5                	mov    %esp,%ebp
  803718:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80371b:	83 ec 04             	sub    $0x4,%esp
  80371e:	68 d0 43 80 00       	push   $0x8043d0
  803723:	68 61 02 00 00       	push   $0x261
  803728:	68 b1 42 80 00       	push   $0x8042b1
  80372d:	e8 27 01 00 00       	call   803859 <_panic>

00803732 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803732:	55                   	push   %ebp
  803733:	89 e5                	mov    %esp,%ebp
  803735:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 f8 43 80 00       	push   $0x8043f8
  803740:	6a 09                	push   $0x9
  803742:	68 20 44 80 00       	push   $0x804420
  803747:	e8 0d 01 00 00       	call   803859 <_panic>

0080374c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80374c:	55                   	push   %ebp
  80374d:	89 e5                	mov    %esp,%ebp
  80374f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 30 44 80 00       	push   $0x804430
  80375a:	6a 10                	push   $0x10
  80375c:	68 20 44 80 00       	push   $0x804420
  803761:	e8 f3 00 00 00       	call   803859 <_panic>

00803766 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803766:	55                   	push   %ebp
  803767:	89 e5                	mov    %esp,%ebp
  803769:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80376c:	83 ec 04             	sub    $0x4,%esp
  80376f:	68 58 44 80 00       	push   $0x804458
  803774:	6a 18                	push   $0x18
  803776:	68 20 44 80 00       	push   $0x804420
  80377b:	e8 d9 00 00 00       	call   803859 <_panic>

00803780 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803780:	55                   	push   %ebp
  803781:	89 e5                	mov    %esp,%ebp
  803783:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803786:	83 ec 04             	sub    $0x4,%esp
  803789:	68 80 44 80 00       	push   $0x804480
  80378e:	6a 20                	push   $0x20
  803790:	68 20 44 80 00       	push   $0x804420
  803795:	e8 bf 00 00 00       	call   803859 <_panic>

0080379a <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80379a:	55                   	push   %ebp
  80379b:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037a3:	5d                   	pop    %ebp
  8037a4:	c3                   	ret    

008037a5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037a5:	55                   	push   %ebp
  8037a6:	89 e5                	mov    %esp,%ebp
  8037a8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ae:	89 d0                	mov    %edx,%eax
  8037b0:	c1 e0 02             	shl    $0x2,%eax
  8037b3:	01 d0                	add    %edx,%eax
  8037b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037bc:	01 d0                	add    %edx,%eax
  8037be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037c5:	01 d0                	add    %edx,%eax
  8037c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037ce:	01 d0                	add    %edx,%eax
  8037d0:	c1 e0 04             	shl    $0x4,%eax
  8037d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8037dd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	50                   	push   %eax
  8037e4:	e8 bc e1 ff ff       	call   8019a5 <sys_get_virtual_time>
  8037e9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037ec:	eb 41                	jmp    80382f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037f1:	83 ec 0c             	sub    $0xc,%esp
  8037f4:	50                   	push   %eax
  8037f5:	e8 ab e1 ff ff       	call   8019a5 <sys_get_virtual_time>
  8037fa:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	29 c2                	sub    %eax,%edx
  803805:	89 d0                	mov    %edx,%eax
  803807:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80380a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80380d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803810:	89 d1                	mov    %edx,%ecx
  803812:	29 c1                	sub    %eax,%ecx
  803814:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381a:	39 c2                	cmp    %eax,%edx
  80381c:	0f 97 c0             	seta   %al
  80381f:	0f b6 c0             	movzbl %al,%eax
  803822:	29 c1                	sub    %eax,%ecx
  803824:	89 c8                	mov    %ecx,%eax
  803826:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803829:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80382c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803835:	72 b7                	jb     8037ee <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803837:	90                   	nop
  803838:	c9                   	leave  
  803839:	c3                   	ret    

0080383a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80383a:	55                   	push   %ebp
  80383b:	89 e5                	mov    %esp,%ebp
  80383d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803840:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803847:	eb 03                	jmp    80384c <busy_wait+0x12>
  803849:	ff 45 fc             	incl   -0x4(%ebp)
  80384c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80384f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803852:	72 f5                	jb     803849 <busy_wait+0xf>
	return i;
  803854:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803857:	c9                   	leave  
  803858:	c3                   	ret    

00803859 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803859:	55                   	push   %ebp
  80385a:	89 e5                	mov    %esp,%ebp
  80385c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80385f:	8d 45 10             	lea    0x10(%ebp),%eax
  803862:	83 c0 04             	add    $0x4,%eax
  803865:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803868:	a1 60 50 98 00       	mov    0x985060,%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 16                	je     803887 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803871:	a1 60 50 98 00       	mov    0x985060,%eax
  803876:	83 ec 08             	sub    $0x8,%esp
  803879:	50                   	push   %eax
  80387a:	68 a8 44 80 00       	push   $0x8044a8
  80387f:	e8 0d cb ff ff       	call   800391 <cprintf>
  803884:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803887:	a1 00 50 80 00       	mov    0x805000,%eax
  80388c:	ff 75 0c             	pushl  0xc(%ebp)
  80388f:	ff 75 08             	pushl  0x8(%ebp)
  803892:	50                   	push   %eax
  803893:	68 ad 44 80 00       	push   $0x8044ad
  803898:	e8 f4 ca ff ff       	call   800391 <cprintf>
  80389d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8038a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8038a3:	83 ec 08             	sub    $0x8,%esp
  8038a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8038a9:	50                   	push   %eax
  8038aa:	e8 77 ca ff ff       	call   800326 <vcprintf>
  8038af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8038b2:	83 ec 08             	sub    $0x8,%esp
  8038b5:	6a 00                	push   $0x0
  8038b7:	68 c9 44 80 00       	push   $0x8044c9
  8038bc:	e8 65 ca ff ff       	call   800326 <vcprintf>
  8038c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8038c4:	e8 e6 c9 ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  8038c9:	eb fe                	jmp    8038c9 <_panic+0x70>

008038cb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8038cb:	55                   	push   %ebp
  8038cc:	89 e5                	mov    %esp,%ebp
  8038ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8038d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8038d6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	39 c2                	cmp    %eax,%edx
  8038e1:	74 14                	je     8038f7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038e3:	83 ec 04             	sub    $0x4,%esp
  8038e6:	68 cc 44 80 00       	push   $0x8044cc
  8038eb:	6a 26                	push   $0x26
  8038ed:	68 18 45 80 00       	push   $0x804518
  8038f2:	e8 62 ff ff ff       	call   803859 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803905:	e9 c5 00 00 00       	jmp    8039cf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80390a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	01 d0                	add    %edx,%eax
  803919:	8b 00                	mov    (%eax),%eax
  80391b:	85 c0                	test   %eax,%eax
  80391d:	75 08                	jne    803927 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80391f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803922:	e9 a5 00 00 00       	jmp    8039cc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803927:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80392e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803935:	eb 69                	jmp    8039a0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803937:	a1 20 50 80 00       	mov    0x805020,%eax
  80393c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803942:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803945:	89 d0                	mov    %edx,%eax
  803947:	01 c0                	add    %eax,%eax
  803949:	01 d0                	add    %edx,%eax
  80394b:	c1 e0 03             	shl    $0x3,%eax
  80394e:	01 c8                	add    %ecx,%eax
  803950:	8a 40 04             	mov    0x4(%eax),%al
  803953:	84 c0                	test   %al,%al
  803955:	75 46                	jne    80399d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803957:	a1 20 50 80 00       	mov    0x805020,%eax
  80395c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803962:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803965:	89 d0                	mov    %edx,%eax
  803967:	01 c0                	add    %eax,%eax
  803969:	01 d0                	add    %edx,%eax
  80396b:	c1 e0 03             	shl    $0x3,%eax
  80396e:	01 c8                	add    %ecx,%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803975:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803978:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80397d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80397f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803982:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	01 c8                	add    %ecx,%eax
  80398e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803990:	39 c2                	cmp    %eax,%edx
  803992:	75 09                	jne    80399d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803994:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80399b:	eb 15                	jmp    8039b2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80399d:	ff 45 e8             	incl   -0x18(%ebp)
  8039a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	39 c2                	cmp    %eax,%edx
  8039b0:	77 85                	ja     803937 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8039b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039b6:	75 14                	jne    8039cc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8039b8:	83 ec 04             	sub    $0x4,%esp
  8039bb:	68 24 45 80 00       	push   $0x804524
  8039c0:	6a 3a                	push   $0x3a
  8039c2:	68 18 45 80 00       	push   $0x804518
  8039c7:	e8 8d fe ff ff       	call   803859 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8039cc:	ff 45 f0             	incl   -0x10(%ebp)
  8039cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039d5:	0f 8c 2f ff ff ff    	jl     80390a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8039db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039e9:	eb 26                	jmp    803a11 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039f9:	89 d0                	mov    %edx,%eax
  8039fb:	01 c0                	add    %eax,%eax
  8039fd:	01 d0                	add    %edx,%eax
  8039ff:	c1 e0 03             	shl    $0x3,%eax
  803a02:	01 c8                	add    %ecx,%eax
  803a04:	8a 40 04             	mov    0x4(%eax),%al
  803a07:	3c 01                	cmp    $0x1,%al
  803a09:	75 03                	jne    803a0e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a0b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a0e:	ff 45 e0             	incl   -0x20(%ebp)
  803a11:	a1 20 50 80 00       	mov    0x805020,%eax
  803a16:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a1f:	39 c2                	cmp    %eax,%edx
  803a21:	77 c8                	ja     8039eb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a26:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a29:	74 14                	je     803a3f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a2b:	83 ec 04             	sub    $0x4,%esp
  803a2e:	68 78 45 80 00       	push   $0x804578
  803a33:	6a 44                	push   $0x44
  803a35:	68 18 45 80 00       	push   $0x804518
  803a3a:	e8 1a fe ff ff       	call   803859 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a3f:	90                   	nop
  803a40:	c9                   	leave  
  803a41:	c3                   	ret    
  803a42:	66 90                	xchg   %ax,%ax

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
