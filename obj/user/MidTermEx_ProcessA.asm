
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
  80003e:	e8 0a 1a 00 00       	call   801a4d <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 3d 80 00       	push   $0x803da0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 13 15 00 00       	call   801569 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 3d 80 00       	push   $0x803da2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 fd 14 00 00       	call   801569 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 3d 80 00       	push   $0x803da9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 e7 14 00 00       	call   801569 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 ec 19 00 00       	call   801a80 <sys_get_virtual_time>
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
  8000b7:	e8 c4 37 00 00       	call   803880 <env_sleep>
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
  8000d0:	e8 ab 19 00 00       	call   801a80 <sys_get_virtual_time>
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
  8000f8:	e8 83 37 00 00       	call   803880 <env_sleep>
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
  80010f:	e8 6c 19 00 00       	call   801a80 <sys_get_virtual_time>
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
  800137:	e8 44 37 00 00       	call   803880 <env_sleep>
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
  80014f:	68 b7 3d 80 00       	push   $0x803db7
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 ca 36 00 00       	call   803827 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 f0 36 00 00       	call   80385b <signal_semaphore>
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
  800184:	e8 ab 18 00 00       	call   801a34 <sys_getenvindex>
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
  8001f2:	e8 c1 15 00 00       	call   8017b8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 d4 3d 80 00       	push   $0x803dd4
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
  800222:	68 fc 3d 80 00       	push   $0x803dfc
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
  800253:	68 24 3e 80 00       	push   $0x803e24
  800258:	e8 34 01 00 00       	call   800391 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 7c 3e 80 00       	push   $0x803e7c
  800274:	e8 18 01 00 00       	call   800391 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 d4 3d 80 00       	push   $0x803dd4
  800284:	e8 08 01 00 00       	call   800391 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80028c:	e8 41 15 00 00       	call   8017d2 <sys_unlock_cons>
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
  8002a4:	e8 57 17 00 00       	call   801a00 <sys_destroy_env>
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
  8002b5:	e8 ac 17 00 00       	call   801a66 <sys_exit_env>
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
  8002e8:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800303:	e8 6e 14 00 00       	call   801776 <sys_cputs>
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
  80035d:	a0 2c 50 80 00       	mov    0x80502c,%al
  800362:	0f b6 c0             	movzbl %al,%eax
  800365:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	50                   	push   %eax
  80036f:	52                   	push   %edx
  800370:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800376:	83 c0 08             	add    $0x8,%eax
  800379:	50                   	push   %eax
  80037a:	e8 f7 13 00 00       	call   801776 <sys_cputs>
  80037f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800382:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800397:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8003c4:	e8 ef 13 00 00       	call   8017b8 <sys_lock_cons>
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
  8003e4:	e8 e9 13 00 00       	call   8017d2 <sys_unlock_cons>
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
  80042e:	e8 ed 36 00 00       	call   803b20 <__udivdi3>
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
  80047e:	e8 ad 37 00 00       	call   803c30 <__umoddi3>
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  8005d9:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  8006ba:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  8006c1:	85 f6                	test   %esi,%esi
  8006c3:	75 19                	jne    8006de <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006c5:	53                   	push   %ebx
  8006c6:	68 c5 40 80 00       	push   $0x8040c5
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
  8006df:	68 ce 40 80 00       	push   $0x8040ce
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
  80070c:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  800904:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  80090b:	eb 2c                	jmp    800939 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80090d:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801117:	68 48 42 80 00       	push   $0x804248
  80111c:	68 3f 01 00 00       	push   $0x13f
  801121:	68 6a 42 80 00       	push   $0x80426a
  801126:	e8 09 28 00 00       	call   803934 <_panic>

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
  801137:	e8 e5 0b 00 00       	call   801d21 <sys_sbrk>
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
  8011b2:	e8 ee 09 00 00       	call   801ba5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	74 16                	je     8011d1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 2e 0f 00 00       	call   8020f4 <alloc_block_FF>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cc:	e9 8a 01 00 00       	jmp    80135b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8011d1:	e8 00 0a 00 00       	call   801bd6 <sys_isUHeapPlacementStrategyBESTFIT>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	0f 84 7d 01 00 00    	je     80135b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 c7 13 00 00       	call   8025b0 <alloc_block_BF>
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
  801234:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801281:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8012d8:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  80133a:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	ff 75 f0             	pushl  -0x10(%ebp)
  80134a:	e8 09 0a 00 00       	call   801d58 <sys_allocate_user_mem>
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
  801392:	e8 dd 09 00 00       	call   801d74 <get_block_size>
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 10 1c 00 00       	call   802fb8 <free_block>
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
  8013dd:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  80141a:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801421:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	52                   	push   %edx
  80142f:	50                   	push   %eax
  801430:	e8 07 09 00 00       	call   801d3c <sys_free_user_mem>
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
  801448:	68 78 42 80 00       	push   $0x804278
  80144d:	68 88 00 00 00       	push   $0x88
  801452:	68 a2 42 80 00       	push   $0x8042a2
  801457:	e8 d8 24 00 00       	call   803934 <_panic>
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
  801476:	e9 ec 00 00 00       	jmp    801567 <smalloc+0x108>
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
  8014a7:	75 0a                	jne    8014b3 <smalloc+0x54>
  8014a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ae:	e9 b4 00 00 00       	jmp    801567 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8014b3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ba:	50                   	push   %eax
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	ff 75 08             	pushl  0x8(%ebp)
  8014c1:	e8 7d 04 00 00       	call   801943 <sys_createSharedObject>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8014cc:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014d0:	74 06                	je     8014d8 <smalloc+0x79>
  8014d2:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014d6:	75 0a                	jne    8014e2 <smalloc+0x83>
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014dd:	e9 85 00 00 00       	jmp    801567 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e8:	68 ae 42 80 00       	push   $0x8042ae
  8014ed:	e8 9f ee ff ff       	call   800391 <cprintf>
  8014f2:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8014f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8014fd:	8b 40 78             	mov    0x78(%eax),%eax
  801500:	29 c2                	sub    %eax,%edx
  801502:	89 d0                	mov    %edx,%eax
  801504:	2d 00 10 00 00       	sub    $0x1000,%eax
  801509:	c1 e8 0c             	shr    $0xc,%eax
  80150c:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801512:	42                   	inc    %edx
  801513:	89 15 24 50 80 00    	mov    %edx,0x805024
  801519:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80151f:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801529:	a1 20 50 80 00       	mov    0x805020,%eax
  80152e:	8b 40 78             	mov    0x78(%eax),%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	2d 00 10 00 00       	sub    $0x1000,%eax
  80153a:	c1 e8 0c             	shr    $0xc,%eax
  80153d:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801544:	a1 20 50 80 00       	mov    0x805020,%eax
  801549:	8b 50 10             	mov    0x10(%eax),%edx
  80154c:	89 c8                	mov    %ecx,%eax
  80154e:	c1 e0 02             	shl    $0x2,%eax
  801551:	89 c1                	mov    %eax,%ecx
  801553:	c1 e1 09             	shl    $0x9,%ecx
  801556:	01 c8                	add    %ecx,%eax
  801558:	01 c2                	add    %eax,%edx
  80155a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80155d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801564:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	ff 75 08             	pushl  0x8(%ebp)
  801578:	e8 f0 03 00 00       	call   80196d <sys_getSizeOfSharedObject>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801583:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801587:	75 0a                	jne    801593 <sget+0x2a>
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	e9 e7 00 00 00       	jmp    80167a <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801599:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	39 d0                	cmp    %edx,%eax
  8015a8:	73 02                	jae    8015ac <sget+0x43>
  8015aa:	89 d0                	mov    %edx,%eax
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	50                   	push   %eax
  8015b0:	e8 8c fb ff ff       	call   801141 <malloc>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8015bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015bf:	75 0a                	jne    8015cb <sget+0x62>
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	e9 af 00 00 00       	jmp    80167a <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	e8 ae 03 00 00       	call   80198a <sys_getSharedObject>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8015e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ea:	8b 40 78             	mov    0x78(%eax),%eax
  8015ed:	29 c2                	sub    %eax,%edx
  8015ef:	89 d0                	mov    %edx,%eax
  8015f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f6:	c1 e8 0c             	shr    $0xc,%eax
  8015f9:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015ff:	42                   	inc    %edx
  801600:	89 15 24 50 80 00    	mov    %edx,0x805024
  801606:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80160c:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801613:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801616:	a1 20 50 80 00       	mov    0x805020,%eax
  80161b:	8b 40 78             	mov    0x78(%eax),%eax
  80161e:	29 c2                	sub    %eax,%edx
  801620:	89 d0                	mov    %edx,%eax
  801622:	2d 00 10 00 00       	sub    $0x1000,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801631:	a1 20 50 80 00       	mov    0x805020,%eax
  801636:	8b 50 10             	mov    0x10(%eax),%edx
  801639:	89 c8                	mov    %ecx,%eax
  80163b:	c1 e0 02             	shl    $0x2,%eax
  80163e:	89 c1                	mov    %eax,%ecx
  801640:	c1 e1 09             	shl    $0x9,%ecx
  801643:	01 c8                	add    %ecx,%eax
  801645:	01 c2                	add    %eax,%edx
  801647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801651:	a1 20 50 80 00       	mov    0x805020,%eax
  801656:	8b 40 10             	mov    0x10(%eax),%eax
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	50                   	push   %eax
  80165d:	68 bd 42 80 00       	push   $0x8042bd
  801662:	e8 2a ed ff ff       	call   800391 <cprintf>
  801667:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80166a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80166e:	75 07                	jne    801677 <sget+0x10e>
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	eb 03                	jmp    80167a <sget+0x111>
	return ptr;
  801677:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801682:	8b 55 08             	mov    0x8(%ebp),%edx
  801685:	a1 20 50 80 00       	mov    0x805020,%eax
  80168a:	8b 40 78             	mov    0x78(%eax),%eax
  80168d:	29 c2                	sub    %eax,%edx
  80168f:	89 d0                	mov    %edx,%eax
  801691:	2d 00 10 00 00       	sub    $0x1000,%eax
  801696:	c1 e8 0c             	shr    $0xc,%eax
  801699:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8016a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8016a5:	8b 50 10             	mov    0x10(%eax),%edx
  8016a8:	89 c8                	mov    %ecx,%eax
  8016aa:	c1 e0 02             	shl    $0x2,%eax
  8016ad:	89 c1                	mov    %eax,%ecx
  8016af:	c1 e1 09             	shl    $0x9,%ecx
  8016b2:	01 c8                	add    %ecx,%eax
  8016b4:	01 d0                	add    %edx,%eax
  8016b6:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8016bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c9:	e8 db 02 00 00       	call   8019a9 <sys_freeSharedObject>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8016d4:	90                   	nop
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 cc 42 80 00       	push   $0x8042cc
  8016e5:	68 e5 00 00 00       	push   $0xe5
  8016ea:	68 a2 42 80 00       	push   $0x8042a2
  8016ef:	e8 40 22 00 00       	call   803934 <_panic>

008016f4 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 f2 42 80 00       	push   $0x8042f2
  801702:	68 f1 00 00 00       	push   $0xf1
  801707:	68 a2 42 80 00       	push   $0x8042a2
  80170c:	e8 23 22 00 00       	call   803934 <_panic>

00801711 <shrink>:

}
void shrink(uint32 newSize)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 f2 42 80 00       	push   $0x8042f2
  80171f:	68 f6 00 00 00       	push   $0xf6
  801724:	68 a2 42 80 00       	push   $0x8042a2
  801729:	e8 06 22 00 00       	call   803934 <_panic>

0080172e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 f2 42 80 00       	push   $0x8042f2
  80173c:	68 fb 00 00 00       	push   $0xfb
  801741:	68 a2 42 80 00       	push   $0x8042a2
  801746:	e8 e9 21 00 00       	call   803934 <_panic>

0080174b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801760:	8b 7d 18             	mov    0x18(%ebp),%edi
  801763:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801766:	cd 30                	int    $0x30
  801768:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801782:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	52                   	push   %edx
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	50                   	push   %eax
  801792:	6a 00                	push   $0x0
  801794:	e8 b2 ff ff ff       	call   80174b <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	90                   	nop
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_cgetc>:

int
sys_cgetc(void)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 02                	push   $0x2
  8017ae:	e8 98 ff ff ff       	call   80174b <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 03                	push   $0x3
  8017c7:	e8 7f ff ff ff       	call   80174b <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	90                   	nop
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 04                	push   $0x4
  8017e1:	e8 65 ff ff ff       	call   80174b <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	90                   	nop
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	52                   	push   %edx
  8017fc:	50                   	push   %eax
  8017fd:	6a 08                	push   $0x8
  8017ff:	e8 47 ff ff ff       	call   80174b <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	56                   	push   %esi
  80180d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80180e:	8b 75 18             	mov    0x18(%ebp),%esi
  801811:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801814:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	51                   	push   %ecx
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 09                	push   $0x9
  801824:	e8 22 ff ff ff       	call   80174b <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 0a                	push   $0xa
  801846:	e8 00 ff ff ff       	call   80174b <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	6a 0b                	push   $0xb
  801861:	e8 e5 fe ff ff       	call   80174b <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 0c                	push   $0xc
  80187a:	e8 cc fe ff ff       	call   80174b <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 0d                	push   $0xd
  801893:	e8 b3 fe ff ff       	call   80174b <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 0e                	push   $0xe
  8018ac:	e8 9a fe ff ff       	call   80174b <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 0f                	push   $0xf
  8018c5:	e8 81 fe ff ff       	call   80174b <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	6a 10                	push   $0x10
  8018df:	e8 67 fe ff ff       	call   80174b <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 11                	push   $0x11
  8018f8:	e8 4e fe ff ff       	call   80174b <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_cputc>:

void
sys_cputc(const char c)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80190f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	50                   	push   %eax
  80191c:	6a 01                	push   $0x1
  80191e:	e8 28 fe ff ff       	call   80174b <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	90                   	nop
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 14                	push   $0x14
  801938:	e8 0e fe ff ff       	call   80174b <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	90                   	nop
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	8b 45 10             	mov    0x10(%ebp),%eax
  80194c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801952:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	51                   	push   %ecx
  80195c:	52                   	push   %edx
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	50                   	push   %eax
  801961:	6a 15                	push   $0x15
  801963:	e8 e3 fd ff ff       	call   80174b <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801970:	8b 55 0c             	mov    0xc(%ebp),%edx
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	52                   	push   %edx
  80197d:	50                   	push   %eax
  80197e:	6a 16                	push   $0x16
  801980:	e8 c6 fd ff ff       	call   80174b <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801990:	8b 55 0c             	mov    0xc(%ebp),%edx
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	51                   	push   %ecx
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 17                	push   $0x17
  80199f:	e8 a7 fd ff ff       	call   80174b <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 18                	push   $0x18
  8019bc:	e8 8a fd ff ff       	call   80174b <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 14             	pushl  0x14(%ebp)
  8019d1:	ff 75 10             	pushl  0x10(%ebp)
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	50                   	push   %eax
  8019d8:	6a 19                	push   $0x19
  8019da:	e8 6c fd ff ff       	call   80174b <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	50                   	push   %eax
  8019f3:	6a 1a                	push   $0x1a
  8019f5:	e8 51 fd ff ff       	call   80174b <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	50                   	push   %eax
  801a0f:	6a 1b                	push   $0x1b
  801a11:	e8 35 fd ff ff       	call   80174b <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 05                	push   $0x5
  801a2a:	e8 1c fd ff ff       	call   80174b <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 06                	push   $0x6
  801a43:	e8 03 fd ff ff       	call   80174b <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 07                	push   $0x7
  801a5c:	e8 ea fc ff ff       	call   80174b <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_exit_env>:


void sys_exit_env(void)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 1c                	push   $0x1c
  801a75:	e8 d1 fc ff ff       	call   80174b <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a86:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a89:	8d 50 04             	lea    0x4(%eax),%edx
  801a8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 1d                	push   $0x1d
  801a99:	e8 ad fc ff ff       	call   80174b <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return result;
  801aa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aaa:	89 01                	mov    %eax,(%ecx)
  801aac:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	c9                   	leave  
  801ab3:	c2 04 00             	ret    $0x4

00801ab6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 13                	push   $0x13
  801ac8:	e8 7e fc ff ff       	call   80174b <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad0:	90                   	nop
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 1e                	push   $0x1e
  801ae2:	e8 64 fc ff ff       	call   80174b <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801af8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	50                   	push   %eax
  801b05:	6a 1f                	push   $0x1f
  801b07:	e8 3f fc ff ff       	call   80174b <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0f:	90                   	nop
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <rsttst>:
void rsttst()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 21                	push   $0x21
  801b21:	e8 25 fc ff ff       	call   80174b <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	8b 45 14             	mov    0x14(%ebp),%eax
  801b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b38:	8b 55 18             	mov    0x18(%ebp),%edx
  801b3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	ff 75 08             	pushl  0x8(%ebp)
  801b4a:	6a 20                	push   $0x20
  801b4c:	e8 fa fb ff ff       	call   80174b <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
	return ;
  801b54:	90                   	nop
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <chktst>:
void chktst(uint32 n)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 22                	push   $0x22
  801b67:	e8 df fb ff ff       	call   80174b <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <inctst>:

void inctst()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 23                	push   $0x23
  801b81:	e8 c5 fb ff ff       	call   80174b <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <gettst>:
uint32 gettst()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 24                	push   $0x24
  801b9b:	e8 ab fb ff ff       	call   80174b <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 25                	push   $0x25
  801bb7:	e8 8f fb ff ff       	call   80174b <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
  801bbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bc2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bc6:	75 07                	jne    801bcf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcd:	eb 05                	jmp    801bd4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 25                	push   $0x25
  801be8:	e8 5e fb ff ff       	call   80174b <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
  801bf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bf3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bf7:	75 07                	jne    801c00 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfe:	eb 05                	jmp    801c05 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 25                	push   $0x25
  801c19:	e8 2d fb ff ff       	call   80174b <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
  801c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c24:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c28:	75 07                	jne    801c31 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2f:	eb 05                	jmp    801c36 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 25                	push   $0x25
  801c4a:	e8 fc fa ff ff       	call   80174b <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
  801c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c55:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c59:	75 07                	jne    801c62 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c60:	eb 05                	jmp    801c67 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 26                	push   $0x26
  801c79:	e8 cd fa ff ff       	call   80174b <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c88:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	53                   	push   %ebx
  801c97:	51                   	push   %ecx
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 27                	push   $0x27
  801c9c:	e8 aa fa ff ff       	call   80174b <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 28                	push   $0x28
  801cbc:	e8 8a fa ff ff       	call   80174b <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cc9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	51                   	push   %ecx
  801cd5:	ff 75 10             	pushl  0x10(%ebp)
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	6a 29                	push   $0x29
  801cdc:	e8 6a fa ff ff       	call   80174b <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 10             	pushl  0x10(%ebp)
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 12                	push   $0x12
  801cf8:	e8 4e fa ff ff       	call   80174b <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 2a                	push   $0x2a
  801d16:	e8 30 fa ff ff       	call   80174b <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	50                   	push   %eax
  801d30:	6a 2b                	push   $0x2b
  801d32:	e8 14 fa ff ff       	call   80174b <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 2c                	push   $0x2c
  801d4d:	e8 f9 f9 ff ff       	call   80174b <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	ff 75 08             	pushl  0x8(%ebp)
  801d67:	6a 2d                	push   $0x2d
  801d69:	e8 dd f9 ff ff       	call   80174b <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
	return;
  801d71:	90                   	nop
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	83 e8 04             	sub    $0x4,%eax
  801d80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d86:	8b 00                	mov    (%eax),%eax
  801d88:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9f:	8b 00                	mov    (%eax),%eax
  801da1:	83 e0 01             	and    $0x1,%eax
  801da4:	85 c0                	test   %eax,%eax
  801da6:	0f 94 c0             	sete   %al
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801db1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbb:	83 f8 02             	cmp    $0x2,%eax
  801dbe:	74 2b                	je     801deb <alloc_block+0x40>
  801dc0:	83 f8 02             	cmp    $0x2,%eax
  801dc3:	7f 07                	jg     801dcc <alloc_block+0x21>
  801dc5:	83 f8 01             	cmp    $0x1,%eax
  801dc8:	74 0e                	je     801dd8 <alloc_block+0x2d>
  801dca:	eb 58                	jmp    801e24 <alloc_block+0x79>
  801dcc:	83 f8 03             	cmp    $0x3,%eax
  801dcf:	74 2d                	je     801dfe <alloc_block+0x53>
  801dd1:	83 f8 04             	cmp    $0x4,%eax
  801dd4:	74 3b                	je     801e11 <alloc_block+0x66>
  801dd6:	eb 4c                	jmp    801e24 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 08             	pushl  0x8(%ebp)
  801dde:	e8 11 03 00 00       	call   8020f4 <alloc_block_FF>
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801de9:	eb 4a                	jmp    801e35 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801deb:	83 ec 0c             	sub    $0xc,%esp
  801dee:	ff 75 08             	pushl  0x8(%ebp)
  801df1:	e8 fa 19 00 00       	call   8037f0 <alloc_block_NF>
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dfc:	eb 37                	jmp    801e35 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	ff 75 08             	pushl  0x8(%ebp)
  801e04:	e8 a7 07 00 00       	call   8025b0 <alloc_block_BF>
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0f:	eb 24                	jmp    801e35 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	e8 b7 19 00 00       	call   8037d3 <alloc_block_WF>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e22:	eb 11                	jmp    801e35 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	68 04 43 80 00       	push   $0x804304
  801e2c:	e8 60 e5 ff ff       	call   800391 <cprintf>
  801e31:	83 c4 10             	add    $0x10,%esp
		break;
  801e34:	90                   	nop
	}
	return va;
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	53                   	push   %ebx
  801e3e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	68 24 43 80 00       	push   $0x804324
  801e49:	e8 43 e5 ff ff       	call   800391 <cprintf>
  801e4e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	68 4f 43 80 00       	push   $0x80434f
  801e59:	e8 33 e5 ff ff       	call   800391 <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e67:	eb 37                	jmp    801ea0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e69:	83 ec 0c             	sub    $0xc,%esp
  801e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6f:	e8 19 ff ff ff       	call   801d8d <is_free_block>
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	0f be d8             	movsbl %al,%ebx
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	e8 ef fe ff ff       	call   801d74 <get_block_size>
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	53                   	push   %ebx
  801e8c:	50                   	push   %eax
  801e8d:	68 67 43 80 00       	push   $0x804367
  801e92:	e8 fa e4 ff ff       	call   800391 <cprintf>
  801e97:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea4:	74 07                	je     801ead <print_blocks_list+0x73>
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	eb 05                	jmp    801eb2 <print_blocks_list+0x78>
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb2:	89 45 10             	mov    %eax,0x10(%ebp)
  801eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	75 ad                	jne    801e69 <print_blocks_list+0x2f>
  801ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec0:	75 a7                	jne    801e69 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	68 24 43 80 00       	push   $0x804324
  801eca:	e8 c2 e4 ff ff       	call   800391 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp

}
  801ed2:	90                   	nop
  801ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	83 e0 01             	and    $0x1,%eax
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	74 03                	je     801eeb <initialize_dynamic_allocator+0x13>
  801ee8:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801eeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eef:	0f 84 c7 01 00 00    	je     8020bc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ef5:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  801efc:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801eff:	8b 55 08             	mov    0x8(%ebp),%edx
  801f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f0c:	0f 87 ad 01 00 00    	ja     8020bf <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	85 c0                	test   %eax,%eax
  801f17:	0f 89 a5 01 00 00    	jns    8020c2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	01 d0                	add    %edx,%eax
  801f25:	83 e8 04             	sub    $0x4,%eax
  801f28:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  801f2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f34:	a1 30 50 80 00       	mov    0x805030,%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3c:	e9 87 00 00 00       	jmp    801fc8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	75 14                	jne    801f5b <initialize_dynamic_allocator+0x83>
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	68 7f 43 80 00       	push   $0x80437f
  801f4f:	6a 79                	push   $0x79
  801f51:	68 9d 43 80 00       	push   $0x80439d
  801f56:	e8 d9 19 00 00       	call   803934 <_panic>
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 00                	mov    (%eax),%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	74 10                	je     801f74 <initialize_dynamic_allocator+0x9c>
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	8b 00                	mov    (%eax),%eax
  801f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6c:	8b 52 04             	mov    0x4(%edx),%edx
  801f6f:	89 50 04             	mov    %edx,0x4(%eax)
  801f72:	eb 0b                	jmp    801f7f <initialize_dynamic_allocator+0xa7>
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 40 04             	mov    0x4(%eax),%eax
  801f7a:	a3 34 50 80 00       	mov    %eax,0x805034
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 40 04             	mov    0x4(%eax),%eax
  801f85:	85 c0                	test   %eax,%eax
  801f87:	74 0f                	je     801f98 <initialize_dynamic_allocator+0xc0>
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 40 04             	mov    0x4(%eax),%eax
  801f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f92:	8b 12                	mov    (%edx),%edx
  801f94:	89 10                	mov    %edx,(%eax)
  801f96:	eb 0a                	jmp    801fa2 <initialize_dynamic_allocator+0xca>
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 00                	mov    (%eax),%eax
  801f9d:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  801fba:	48                   	dec    %eax
  801fbb:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fc0:	a1 38 50 80 00       	mov    0x805038,%eax
  801fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcc:	74 07                	je     801fd5 <initialize_dynamic_allocator+0xfd>
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 00                	mov    (%eax),%eax
  801fd3:	eb 05                	jmp    801fda <initialize_dynamic_allocator+0x102>
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fda:	a3 38 50 80 00       	mov    %eax,0x805038
  801fdf:	a1 38 50 80 00       	mov    0x805038,%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	0f 85 55 ff ff ff    	jne    801f41 <initialize_dynamic_allocator+0x69>
  801fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff0:	0f 85 4b ff ff ff    	jne    801f41 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802005:	a1 48 50 80 00       	mov    0x805048,%eax
  80200a:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80200f:	a1 44 50 80 00       	mov    0x805044,%eax
  802014:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	83 c0 08             	add    $0x8,%eax
  802020:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	83 c0 04             	add    $0x4,%eax
  802029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202c:	83 ea 08             	sub    $0x8,%edx
  80202f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	01 d0                	add    %edx,%eax
  802039:	83 e8 08             	sub    $0x8,%eax
  80203c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203f:	83 ea 08             	sub    $0x8,%edx
  802042:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802047:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80204d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802050:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802057:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80205b:	75 17                	jne    802074 <initialize_dynamic_allocator+0x19c>
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	68 b8 43 80 00       	push   $0x8043b8
  802065:	68 90 00 00 00       	push   $0x90
  80206a:	68 9d 43 80 00       	push   $0x80439d
  80206f:	e8 c0 18 00 00       	call   803934 <_panic>
  802074:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80207a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207d:	89 10                	mov    %edx,(%eax)
  80207f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	74 0d                	je     802095 <initialize_dynamic_allocator+0x1bd>
  802088:	a1 30 50 80 00       	mov    0x805030,%eax
  80208d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802090:	89 50 04             	mov    %edx,0x4(%eax)
  802093:	eb 08                	jmp    80209d <initialize_dynamic_allocator+0x1c5>
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802098:	a3 34 50 80 00       	mov    %eax,0x805034
  80209d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020af:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8020b4:	40                   	inc    %eax
  8020b5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8020ba:	eb 07                	jmp    8020c3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020bc:	90                   	nop
  8020bd:	eb 04                	jmp    8020c3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020bf:	90                   	nop
  8020c0:	eb 01                	jmp    8020c3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020c2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cb:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	83 e8 04             	sub    $0x4,%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8020e4:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	01 c2                	add    %eax,%edx
  8020ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ef:	89 02                	mov    %eax,(%edx)
}
  8020f1:	90                   	nop
  8020f2:	5d                   	pop    %ebp
  8020f3:	c3                   	ret    

008020f4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	83 e0 01             	and    $0x1,%eax
  802100:	85 c0                	test   %eax,%eax
  802102:	74 03                	je     802107 <alloc_block_FF+0x13>
  802104:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802107:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80210b:	77 07                	ja     802114 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80210d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802114:	a1 28 50 80 00       	mov    0x805028,%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	75 73                	jne    802190 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	83 c0 10             	add    $0x10,%eax
  802123:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802126:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80212d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802133:	01 d0                	add    %edx,%eax
  802135:	48                   	dec    %eax
  802136:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213c:	ba 00 00 00 00       	mov    $0x0,%edx
  802141:	f7 75 ec             	divl   -0x14(%ebp)
  802144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802147:	29 d0                	sub    %edx,%eax
  802149:	c1 e8 0c             	shr    $0xc,%eax
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	50                   	push   %eax
  802150:	e8 d6 ef ff ff       	call   80112b <sbrk>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	6a 00                	push   $0x0
  802160:	e8 c6 ef ff ff       	call   80112b <sbrk>
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80216b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80216e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802171:	83 ec 08             	sub    $0x8,%esp
  802174:	50                   	push   %eax
  802175:	ff 75 e4             	pushl  -0x1c(%ebp)
  802178:	e8 5b fd ff ff       	call   801ed8 <initialize_dynamic_allocator>
  80217d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	68 db 43 80 00       	push   $0x8043db
  802188:	e8 04 e2 ff ff       	call   800391 <cprintf>
  80218d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802194:	75 0a                	jne    8021a0 <alloc_block_FF+0xac>
	        return NULL;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	e9 0e 04 00 00       	jmp    8025ae <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	e9 f3 02 00 00       	jmp    8024a7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021ba:	83 ec 0c             	sub    $0xc,%esp
  8021bd:	ff 75 bc             	pushl  -0x44(%ebp)
  8021c0:	e8 af fb ff ff       	call   801d74 <get_block_size>
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	83 c0 08             	add    $0x8,%eax
  8021d1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021d4:	0f 87 c5 02 00 00    	ja     80249f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	83 c0 18             	add    $0x18,%eax
  8021e0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021e3:	0f 87 19 02 00 00    	ja     802402 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ef:	83 e8 08             	sub    $0x8,%eax
  8021f2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	8d 50 08             	lea    0x8(%eax),%edx
  8021fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021fe:	01 d0                	add    %edx,%eax
  802200:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	83 c0 08             	add    $0x8,%eax
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	6a 01                	push   $0x1
  80220e:	50                   	push   %eax
  80220f:	ff 75 bc             	pushl  -0x44(%ebp)
  802212:	e8 ae fe ff ff       	call   8020c5 <set_block_data>
  802217:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 40 04             	mov    0x4(%eax),%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	75 68                	jne    80228c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802224:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802228:	75 17                	jne    802241 <alloc_block_FF+0x14d>
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 b8 43 80 00       	push   $0x8043b8
  802232:	68 d7 00 00 00       	push   $0xd7
  802237:	68 9d 43 80 00       	push   $0x80439d
  80223c:	e8 f3 16 00 00       	call   803934 <_panic>
  802241:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802247:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0d                	je     802262 <alloc_block_FF+0x16e>
  802255:	a1 30 50 80 00       	mov    0x805030,%eax
  80225a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225d:	89 50 04             	mov    %edx,0x4(%eax)
  802260:	eb 08                	jmp    80226a <alloc_block_FF+0x176>
  802262:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802265:	a3 34 50 80 00       	mov    %eax,0x805034
  80226a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226d:	a3 30 50 80 00       	mov    %eax,0x805030
  802272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802281:	40                   	inc    %eax
  802282:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802287:	e9 dc 00 00 00       	jmp    802368 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 00                	mov    (%eax),%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	75 65                	jne    8022fa <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802295:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802299:	75 17                	jne    8022b2 <alloc_block_FF+0x1be>
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	68 ec 43 80 00       	push   $0x8043ec
  8022a3:	68 db 00 00 00       	push   $0xdb
  8022a8:	68 9d 43 80 00       	push   $0x80439d
  8022ad:	e8 82 16 00 00       	call   803934 <_panic>
  8022b2:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8022b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022bb:	89 50 04             	mov    %edx,0x4(%eax)
  8022be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c1:	8b 40 04             	mov    0x4(%eax),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 0c                	je     8022d4 <alloc_block_FF+0x1e0>
  8022c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8022cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022d0:	89 10                	mov    %edx,(%eax)
  8022d2:	eb 08                	jmp    8022dc <alloc_block_FF+0x1e8>
  8022d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8022dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022df:	a3 34 50 80 00       	mov    %eax,0x805034
  8022e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022f2:	40                   	inc    %eax
  8022f3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022f8:	eb 6e                	jmp    802368 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fe:	74 06                	je     802306 <alloc_block_FF+0x212>
  802300:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802304:	75 17                	jne    80231d <alloc_block_FF+0x229>
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 10 44 80 00       	push   $0x804410
  80230e:	68 df 00 00 00       	push   $0xdf
  802313:	68 9d 43 80 00       	push   $0x80439d
  802318:	e8 17 16 00 00       	call   803934 <_panic>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 10                	mov    (%eax),%edx
  802322:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802325:	89 10                	mov    %edx,(%eax)
  802327:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232a:	8b 00                	mov    (%eax),%eax
  80232c:	85 c0                	test   %eax,%eax
  80232e:	74 0b                	je     80233b <alloc_block_FF+0x247>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802349:	89 50 04             	mov    %edx,0x4(%eax)
  80234c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	75 08                	jne    80235d <alloc_block_FF+0x269>
  802355:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802358:	a3 34 50 80 00       	mov    %eax,0x805034
  80235d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802362:	40                   	inc    %eax
  802363:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236c:	75 17                	jne    802385 <alloc_block_FF+0x291>
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 7f 43 80 00       	push   $0x80437f
  802376:	68 e1 00 00 00       	push   $0xe1
  80237b:	68 9d 43 80 00       	push   $0x80439d
  802380:	e8 af 15 00 00       	call   803934 <_panic>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 10                	je     80239e <alloc_block_FF+0x2aa>
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802396:	8b 52 04             	mov    0x4(%edx),%edx
  802399:	89 50 04             	mov    %edx,0x4(%eax)
  80239c:	eb 0b                	jmp    8023a9 <alloc_block_FF+0x2b5>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 40 04             	mov    0x4(%eax),%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 0f                	je     8023c2 <alloc_block_FF+0x2ce>
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 40 04             	mov    0x4(%eax),%eax
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	8b 12                	mov    (%edx),%edx
  8023be:	89 10                	mov    %edx,(%eax)
  8023c0:	eb 0a                	jmp    8023cc <alloc_block_FF+0x2d8>
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023df:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023e4:	48                   	dec    %eax
  8023e5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	6a 00                	push   $0x0
  8023ef:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023f2:	ff 75 b0             	pushl  -0x50(%ebp)
  8023f5:	e8 cb fc ff ff       	call   8020c5 <set_block_data>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	e9 95 00 00 00       	jmp    802497 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	6a 01                	push   $0x1
  802407:	ff 75 b8             	pushl  -0x48(%ebp)
  80240a:	ff 75 bc             	pushl  -0x44(%ebp)
  80240d:	e8 b3 fc ff ff       	call   8020c5 <set_block_data>
  802412:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	75 17                	jne    802432 <alloc_block_FF+0x33e>
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 7f 43 80 00       	push   $0x80437f
  802423:	68 e8 00 00 00       	push   $0xe8
  802428:	68 9d 43 80 00       	push   $0x80439d
  80242d:	e8 02 15 00 00       	call   803934 <_panic>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	74 10                	je     80244b <alloc_block_FF+0x357>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802443:	8b 52 04             	mov    0x4(%edx),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	eb 0b                	jmp    802456 <alloc_block_FF+0x362>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	a3 34 50 80 00       	mov    %eax,0x805034
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0f                	je     80246f <alloc_block_FF+0x37b>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	8b 12                	mov    (%edx),%edx
  80246b:	89 10                	mov    %edx,(%eax)
  80246d:	eb 0a                	jmp    802479 <alloc_block_FF+0x385>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	a3 30 50 80 00       	mov    %eax,0x805030
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802491:	48                   	dec    %eax
  802492:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802497:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80249a:	e9 0f 01 00 00       	jmp    8025ae <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80249f:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ab:	74 07                	je     8024b4 <alloc_block_FF+0x3c0>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	eb 05                	jmp    8024b9 <alloc_block_FF+0x3c5>
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b9:	a3 38 50 80 00       	mov    %eax,0x805038
  8024be:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	0f 85 e9 fc ff ff    	jne    8021b4 <alloc_block_FF+0xc0>
  8024cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cf:	0f 85 df fc ff ff    	jne    8021b4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	83 c0 08             	add    $0x8,%eax
  8024db:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024de:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8024e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	48                   	dec    %eax
  8024ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f9:	f7 75 d8             	divl   -0x28(%ebp)
  8024fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ff:	29 d0                	sub    %edx,%eax
  802501:	c1 e8 0c             	shr    $0xc,%eax
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	50                   	push   %eax
  802508:	e8 1e ec ff ff       	call   80112b <sbrk>
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802513:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802517:	75 0a                	jne    802523 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	e9 8b 00 00 00       	jmp    8025ae <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802523:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80252a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80252d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802530:	01 d0                	add    %edx,%eax
  802532:	48                   	dec    %eax
  802533:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802536:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802539:	ba 00 00 00 00       	mov    $0x0,%edx
  80253e:	f7 75 cc             	divl   -0x34(%ebp)
  802541:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802544:	29 d0                	sub    %edx,%eax
  802546:	8d 50 fc             	lea    -0x4(%eax),%edx
  802549:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80254c:	01 d0                	add    %edx,%eax
  80254e:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802553:	a1 44 50 80 00       	mov    0x805044,%eax
  802558:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80255e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802565:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802568:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80256b:	01 d0                	add    %edx,%eax
  80256d:	48                   	dec    %eax
  80256e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802571:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802574:	ba 00 00 00 00       	mov    $0x0,%edx
  802579:	f7 75 c4             	divl   -0x3c(%ebp)
  80257c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80257f:	29 d0                	sub    %edx,%eax
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	6a 01                	push   $0x1
  802586:	50                   	push   %eax
  802587:	ff 75 d0             	pushl  -0x30(%ebp)
  80258a:	e8 36 fb ff ff       	call   8020c5 <set_block_data>
  80258f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 d0             	pushl  -0x30(%ebp)
  802598:	e8 1b 0a 00 00       	call   802fb8 <free_block>
  80259d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	ff 75 08             	pushl  0x8(%ebp)
  8025a6:	e8 49 fb ff ff       	call   8020f4 <alloc_block_FF>
  8025ab:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	83 e0 01             	and    $0x1,%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 03                	je     8025c3 <alloc_block_BF+0x13>
  8025c0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025c3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025c7:	77 07                	ja     8025d0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025c9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025d0:	a1 28 50 80 00       	mov    0x805028,%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	75 73                	jne    80264c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	83 c0 10             	add    $0x10,%eax
  8025df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8025e2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fd:	f7 75 e0             	divl   -0x20(%ebp)
  802600:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802603:	29 d0                	sub    %edx,%eax
  802605:	c1 e8 0c             	shr    $0xc,%eax
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	50                   	push   %eax
  80260c:	e8 1a eb ff ff       	call   80112b <sbrk>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802617:	83 ec 0c             	sub    $0xc,%esp
  80261a:	6a 00                	push   $0x0
  80261c:	e8 0a eb ff ff       	call   80112b <sbrk>
  802621:	83 c4 10             	add    $0x10,%esp
  802624:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802627:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80262a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80262d:	83 ec 08             	sub    $0x8,%esp
  802630:	50                   	push   %eax
  802631:	ff 75 d8             	pushl  -0x28(%ebp)
  802634:	e8 9f f8 ff ff       	call   801ed8 <initialize_dynamic_allocator>
  802639:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80263c:	83 ec 0c             	sub    $0xc,%esp
  80263f:	68 db 43 80 00       	push   $0x8043db
  802644:	e8 48 dd ff ff       	call   800391 <cprintf>
  802649:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80264c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802653:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80265a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802668:	a1 30 50 80 00       	mov    0x805030,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	e9 1d 01 00 00       	jmp    802792 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80267b:	83 ec 0c             	sub    $0xc,%esp
  80267e:	ff 75 a8             	pushl  -0x58(%ebp)
  802681:	e8 ee f6 ff ff       	call   801d74 <get_block_size>
  802686:	83 c4 10             	add    $0x10,%esp
  802689:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	83 c0 08             	add    $0x8,%eax
  802692:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802695:	0f 87 ef 00 00 00    	ja     80278a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	83 c0 18             	add    $0x18,%eax
  8026a1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026a4:	77 1d                	ja     8026c3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ac:	0f 86 d8 00 00 00    	jbe    80278a <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026b2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026b8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026be:	e9 c7 00 00 00       	jmp    80278a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	83 c0 08             	add    $0x8,%eax
  8026c9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026cc:	0f 85 9d 00 00 00    	jne    80276f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	6a 01                	push   $0x1
  8026d7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026da:	ff 75 a8             	pushl  -0x58(%ebp)
  8026dd:	e8 e3 f9 ff ff       	call   8020c5 <set_block_data>
  8026e2:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	75 17                	jne    802702 <alloc_block_BF+0x152>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 7f 43 80 00       	push   $0x80437f
  8026f3:	68 2c 01 00 00       	push   $0x12c
  8026f8:	68 9d 43 80 00       	push   $0x80439d
  8026fd:	e8 32 12 00 00       	call   803934 <_panic>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 10                	je     80271b <alloc_block_BF+0x16b>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	8b 52 04             	mov    0x4(%edx),%edx
  802716:	89 50 04             	mov    %edx,0x4(%eax)
  802719:	eb 0b                	jmp    802726 <alloc_block_BF+0x176>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	a3 34 50 80 00       	mov    %eax,0x805034
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 0f                	je     80273f <alloc_block_BF+0x18f>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	8b 12                	mov    (%edx),%edx
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	eb 0a                	jmp    802749 <alloc_block_BF+0x199>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	a3 30 50 80 00       	mov    %eax,0x805030
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802761:	48                   	dec    %eax
  802762:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802767:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80276a:	e9 24 04 00 00       	jmp    802b93 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802772:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802775:	76 13                	jbe    80278a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802777:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80277e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802781:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802784:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802787:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80278a:	a1 38 50 80 00       	mov    0x805038,%eax
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802796:	74 07                	je     80279f <alloc_block_BF+0x1ef>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	eb 05                	jmp    8027a4 <alloc_block_BF+0x1f4>
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8027a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	0f 85 bf fe ff ff    	jne    802675 <alloc_block_BF+0xc5>
  8027b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ba:	0f 85 b5 fe ff ff    	jne    802675 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c4:	0f 84 26 02 00 00    	je     8029f0 <alloc_block_BF+0x440>
  8027ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ce:	0f 85 1c 02 00 00    	jne    8029f0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027da:	83 e8 08             	sub    $0x8,%eax
  8027dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	8d 50 08             	lea    0x8(%eax),%edx
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	83 c0 08             	add    $0x8,%eax
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	6a 01                	push   $0x1
  8027f9:	50                   	push   %eax
  8027fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8027fd:	e8 c3 f8 ff ff       	call   8020c5 <set_block_data>
  802802:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	75 68                	jne    802877 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80280f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802813:	75 17                	jne    80282c <alloc_block_BF+0x27c>
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 b8 43 80 00       	push   $0x8043b8
  80281d:	68 45 01 00 00       	push   $0x145
  802822:	68 9d 43 80 00       	push   $0x80439d
  802827:	e8 08 11 00 00       	call   803934 <_panic>
  80282c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802832:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802835:	89 10                	mov    %edx,(%eax)
  802837:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0d                	je     80284d <alloc_block_BF+0x29d>
  802840:	a1 30 50 80 00       	mov    0x805030,%eax
  802845:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802848:	89 50 04             	mov    %edx,0x4(%eax)
  80284b:	eb 08                	jmp    802855 <alloc_block_BF+0x2a5>
  80284d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802850:	a3 34 50 80 00       	mov    %eax,0x805034
  802855:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802858:	a3 30 50 80 00       	mov    %eax,0x805030
  80285d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802860:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802867:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80286c:	40                   	inc    %eax
  80286d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802872:	e9 dc 00 00 00       	jmp    802953 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	75 65                	jne    8028e5 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802880:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802884:	75 17                	jne    80289d <alloc_block_BF+0x2ed>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 ec 43 80 00       	push   $0x8043ec
  80288e:	68 4a 01 00 00       	push   $0x14a
  802893:	68 9d 43 80 00       	push   $0x80439d
  802898:	e8 97 10 00 00       	call   803934 <_panic>
  80289d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8028a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 0c                	je     8028bf <alloc_block_BF+0x30f>
  8028b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8028b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028bb:	89 10                	mov    %edx,(%eax)
  8028bd:	eb 08                	jmp    8028c7 <alloc_block_BF+0x317>
  8028bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8028cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028dd:	40                   	inc    %eax
  8028de:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028e3:	eb 6e                	jmp    802953 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8028e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028e9:	74 06                	je     8028f1 <alloc_block_BF+0x341>
  8028eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028ef:	75 17                	jne    802908 <alloc_block_BF+0x358>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 10 44 80 00       	push   $0x804410
  8028f9:	68 4f 01 00 00       	push   $0x14f
  8028fe:	68 9d 43 80 00       	push   $0x80439d
  802903:	e8 2c 10 00 00       	call   803934 <_panic>
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 10                	mov    (%eax),%edx
  80290d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802910:	89 10                	mov    %edx,(%eax)
  802912:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0b                	je     802926 <alloc_block_BF+0x376>
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802931:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802934:	89 50 04             	mov    %edx,0x4(%eax)
  802937:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	75 08                	jne    802948 <alloc_block_BF+0x398>
  802940:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802943:	a3 34 50 80 00       	mov    %eax,0x805034
  802948:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80294d:	40                   	inc    %eax
  80294e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802957:	75 17                	jne    802970 <alloc_block_BF+0x3c0>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 7f 43 80 00       	push   $0x80437f
  802961:	68 51 01 00 00       	push   $0x151
  802966:	68 9d 43 80 00       	push   $0x80439d
  80296b:	e8 c4 0f 00 00       	call   803934 <_panic>
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 10                	je     802989 <alloc_block_BF+0x3d9>
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802981:	8b 52 04             	mov    0x4(%edx),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 0b                	jmp    802994 <alloc_block_BF+0x3e4>
  802989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	a3 34 50 80 00       	mov    %eax,0x805034
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 0f                	je     8029ad <alloc_block_BF+0x3fd>
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a7:	8b 12                	mov    (%edx),%edx
  8029a9:	89 10                	mov    %edx,(%eax)
  8029ab:	eb 0a                	jmp    8029b7 <alloc_block_BF+0x407>
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029cf:	48                   	dec    %eax
  8029d0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8029d5:	83 ec 04             	sub    $0x4,%esp
  8029d8:	6a 00                	push   $0x0
  8029da:	ff 75 d0             	pushl  -0x30(%ebp)
  8029dd:	ff 75 cc             	pushl  -0x34(%ebp)
  8029e0:	e8 e0 f6 ff ff       	call   8020c5 <set_block_data>
  8029e5:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	e9 a3 01 00 00       	jmp    802b93 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029f0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029f4:	0f 85 9d 00 00 00    	jne    802a97 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	6a 01                	push   $0x1
  8029ff:	ff 75 ec             	pushl  -0x14(%ebp)
  802a02:	ff 75 f0             	pushl  -0x10(%ebp)
  802a05:	e8 bb f6 ff ff       	call   8020c5 <set_block_data>
  802a0a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a11:	75 17                	jne    802a2a <alloc_block_BF+0x47a>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 7f 43 80 00       	push   $0x80437f
  802a1b:	68 58 01 00 00       	push   $0x158
  802a20:	68 9d 43 80 00       	push   $0x80439d
  802a25:	e8 0a 0f 00 00       	call   803934 <_panic>
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 10                	je     802a43 <alloc_block_BF+0x493>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3b:	8b 52 04             	mov    0x4(%edx),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 0b                	jmp    802a4e <alloc_block_BF+0x49e>
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	a3 34 50 80 00       	mov    %eax,0x805034
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0f                	je     802a67 <alloc_block_BF+0x4b7>
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a61:	8b 12                	mov    (%edx),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 0a                	jmp    802a71 <alloc_block_BF+0x4c1>
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a89:	48                   	dec    %eax
  802a8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	e9 fc 00 00 00       	jmp    802b93 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	83 c0 08             	add    $0x8,%eax
  802a9d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802aa0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802aa7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aaa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802aad:	01 d0                	add    %edx,%eax
  802aaf:	48                   	dec    %eax
  802ab0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ab3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ab6:	ba 00 00 00 00       	mov    $0x0,%edx
  802abb:	f7 75 c4             	divl   -0x3c(%ebp)
  802abe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ac1:	29 d0                	sub    %edx,%eax
  802ac3:	c1 e8 0c             	shr    $0xc,%eax
  802ac6:	83 ec 0c             	sub    $0xc,%esp
  802ac9:	50                   	push   %eax
  802aca:	e8 5c e6 ff ff       	call   80112b <sbrk>
  802acf:	83 c4 10             	add    $0x10,%esp
  802ad2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802ad5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802ad9:	75 0a                	jne    802ae5 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae0:	e9 ae 00 00 00       	jmp    802b93 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ae5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802aec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802af2:	01 d0                	add    %edx,%eax
  802af4:	48                   	dec    %eax
  802af5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802af8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802afb:	ba 00 00 00 00       	mov    $0x0,%edx
  802b00:	f7 75 b8             	divl   -0x48(%ebp)
  802b03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b06:	29 d0                	sub    %edx,%eax
  802b08:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b0b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b0e:	01 d0                	add    %edx,%eax
  802b10:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802b15:	a1 44 50 80 00       	mov    0x805044,%eax
  802b1a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b20:	83 ec 0c             	sub    $0xc,%esp
  802b23:	68 44 44 80 00       	push   $0x804444
  802b28:	e8 64 d8 ff ff       	call   800391 <cprintf>
  802b2d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b30:	83 ec 08             	sub    $0x8,%esp
  802b33:	ff 75 bc             	pushl  -0x44(%ebp)
  802b36:	68 49 44 80 00       	push   $0x804449
  802b3b:	e8 51 d8 ff ff       	call   800391 <cprintf>
  802b40:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b43:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b4a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b50:	01 d0                	add    %edx,%eax
  802b52:	48                   	dec    %eax
  802b53:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b59:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5e:	f7 75 b0             	divl   -0x50(%ebp)
  802b61:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b64:	29 d0                	sub    %edx,%eax
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	6a 01                	push   $0x1
  802b6b:	50                   	push   %eax
  802b6c:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6f:	e8 51 f5 ff ff       	call   8020c5 <set_block_data>
  802b74:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b77:	83 ec 0c             	sub    $0xc,%esp
  802b7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802b7d:	e8 36 04 00 00       	call   802fb8 <free_block>
  802b82:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b85:	83 ec 0c             	sub    $0xc,%esp
  802b88:	ff 75 08             	pushl  0x8(%ebp)
  802b8b:	e8 20 fa ff ff       	call   8025b0 <alloc_block_BF>
  802b90:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	53                   	push   %ebx
  802b99:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ba3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802baa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bae:	74 1e                	je     802bce <merging+0x39>
  802bb0:	ff 75 08             	pushl  0x8(%ebp)
  802bb3:	e8 bc f1 ff ff       	call   801d74 <get_block_size>
  802bb8:	83 c4 04             	add    $0x4,%esp
  802bbb:	89 c2                	mov    %eax,%edx
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	01 d0                	add    %edx,%eax
  802bc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bc5:	75 07                	jne    802bce <merging+0x39>
		prev_is_free = 1;
  802bc7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd2:	74 1e                	je     802bf2 <merging+0x5d>
  802bd4:	ff 75 10             	pushl  0x10(%ebp)
  802bd7:	e8 98 f1 ff ff       	call   801d74 <get_block_size>
  802bdc:	83 c4 04             	add    $0x4,%esp
  802bdf:	89 c2                	mov    %eax,%edx
  802be1:	8b 45 10             	mov    0x10(%ebp),%eax
  802be4:	01 d0                	add    %edx,%eax
  802be6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802be9:	75 07                	jne    802bf2 <merging+0x5d>
		next_is_free = 1;
  802beb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	0f 84 cc 00 00 00    	je     802cc8 <merging+0x133>
  802bfc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c00:	0f 84 c2 00 00 00    	je     802cc8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c06:	ff 75 08             	pushl  0x8(%ebp)
  802c09:	e8 66 f1 ff ff       	call   801d74 <get_block_size>
  802c0e:	83 c4 04             	add    $0x4,%esp
  802c11:	89 c3                	mov    %eax,%ebx
  802c13:	ff 75 10             	pushl  0x10(%ebp)
  802c16:	e8 59 f1 ff ff       	call   801d74 <get_block_size>
  802c1b:	83 c4 04             	add    $0x4,%esp
  802c1e:	01 c3                	add    %eax,%ebx
  802c20:	ff 75 0c             	pushl  0xc(%ebp)
  802c23:	e8 4c f1 ff ff       	call   801d74 <get_block_size>
  802c28:	83 c4 04             	add    $0x4,%esp
  802c2b:	01 d8                	add    %ebx,%eax
  802c2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c30:	6a 00                	push   $0x0
  802c32:	ff 75 ec             	pushl  -0x14(%ebp)
  802c35:	ff 75 08             	pushl  0x8(%ebp)
  802c38:	e8 88 f4 ff ff       	call   8020c5 <set_block_data>
  802c3d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c44:	75 17                	jne    802c5d <merging+0xc8>
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 7f 43 80 00       	push   $0x80437f
  802c4e:	68 7d 01 00 00       	push   $0x17d
  802c53:	68 9d 43 80 00       	push   $0x80439d
  802c58:	e8 d7 0c 00 00       	call   803934 <_panic>
  802c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 10                	je     802c76 <merging+0xe1>
  802c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6e:	8b 52 04             	mov    0x4(%edx),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	eb 0b                	jmp    802c81 <merging+0xec>
  802c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	a3 34 50 80 00       	mov    %eax,0x805034
  802c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0f                	je     802c9a <merging+0x105>
  802c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c94:	8b 12                	mov    (%edx),%edx
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	eb 0a                	jmp    802ca4 <merging+0x10f>
  802c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cbc:	48                   	dec    %eax
  802cbd:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cc2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cc3:	e9 ea 02 00 00       	jmp    802fb2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccc:	74 3b                	je     802d09 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802cce:	83 ec 0c             	sub    $0xc,%esp
  802cd1:	ff 75 08             	pushl  0x8(%ebp)
  802cd4:	e8 9b f0 ff ff       	call   801d74 <get_block_size>
  802cd9:	83 c4 10             	add    $0x10,%esp
  802cdc:	89 c3                	mov    %eax,%ebx
  802cde:	83 ec 0c             	sub    $0xc,%esp
  802ce1:	ff 75 10             	pushl  0x10(%ebp)
  802ce4:	e8 8b f0 ff ff       	call   801d74 <get_block_size>
  802ce9:	83 c4 10             	add    $0x10,%esp
  802cec:	01 d8                	add    %ebx,%eax
  802cee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	6a 00                	push   $0x0
  802cf6:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf9:	ff 75 08             	pushl  0x8(%ebp)
  802cfc:	e8 c4 f3 ff ff       	call   8020c5 <set_block_data>
  802d01:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d04:	e9 a9 02 00 00       	jmp    802fb2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0d:	0f 84 2d 01 00 00    	je     802e40 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 10             	pushl  0x10(%ebp)
  802d19:	e8 56 f0 ff ff       	call   801d74 <get_block_size>
  802d1e:	83 c4 10             	add    $0x10,%esp
  802d21:	89 c3                	mov    %eax,%ebx
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	ff 75 0c             	pushl  0xc(%ebp)
  802d29:	e8 46 f0 ff ff       	call   801d74 <get_block_size>
  802d2e:	83 c4 10             	add    $0x10,%esp
  802d31:	01 d8                	add    %ebx,%eax
  802d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	6a 00                	push   $0x0
  802d3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d3e:	ff 75 10             	pushl  0x10(%ebp)
  802d41:	e8 7f f3 ff ff       	call   8020c5 <set_block_data>
  802d46:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d49:	8b 45 10             	mov    0x10(%ebp),%eax
  802d4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d53:	74 06                	je     802d5b <merging+0x1c6>
  802d55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d59:	75 17                	jne    802d72 <merging+0x1dd>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 58 44 80 00       	push   $0x804458
  802d63:	68 8d 01 00 00       	push   $0x18d
  802d68:	68 9d 43 80 00       	push   $0x80439d
  802d6d:	e8 c2 0b 00 00       	call   803934 <_panic>
  802d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d75:	8b 50 04             	mov    0x4(%eax),%edx
  802d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d84:	89 10                	mov    %edx,(%eax)
  802d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 0d                	je     802d9d <merging+0x208>
  802d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d99:	89 10                	mov    %edx,(%eax)
  802d9b:	eb 08                	jmp    802da5 <merging+0x210>
  802d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da0:	a3 30 50 80 00       	mov    %eax,0x805030
  802da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dab:	89 50 04             	mov    %edx,0x4(%eax)
  802dae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802db3:	40                   	inc    %eax
  802db4:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbd:	75 17                	jne    802dd6 <merging+0x241>
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	68 7f 43 80 00       	push   $0x80437f
  802dc7:	68 8e 01 00 00       	push   $0x18e
  802dcc:	68 9d 43 80 00       	push   $0x80439d
  802dd1:	e8 5e 0b 00 00       	call   803934 <_panic>
  802dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 10                	je     802def <merging+0x25a>
  802ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de7:	8b 52 04             	mov    0x4(%edx),%edx
  802dea:	89 50 04             	mov    %edx,0x4(%eax)
  802ded:	eb 0b                	jmp    802dfa <merging+0x265>
  802def:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	a3 34 50 80 00       	mov    %eax,0x805034
  802dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0f                	je     802e13 <merging+0x27e>
  802e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0d:	8b 12                	mov    (%edx),%edx
  802e0f:	89 10                	mov    %edx,(%eax)
  802e11:	eb 0a                	jmp    802e1d <merging+0x288>
  802e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	a3 30 50 80 00       	mov    %eax,0x805030
  802e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e30:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e35:	48                   	dec    %eax
  802e36:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e3b:	e9 72 01 00 00       	jmp    802fb2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e40:	8b 45 10             	mov    0x10(%ebp),%eax
  802e43:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4a:	74 79                	je     802ec5 <merging+0x330>
  802e4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e50:	74 73                	je     802ec5 <merging+0x330>
  802e52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e56:	74 06                	je     802e5e <merging+0x2c9>
  802e58:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5c:	75 17                	jne    802e75 <merging+0x2e0>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 10 44 80 00       	push   $0x804410
  802e66:	68 94 01 00 00       	push   $0x194
  802e6b:	68 9d 43 80 00       	push   $0x80439d
  802e70:	e8 bf 0a 00 00       	call   803934 <_panic>
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 10                	mov    (%eax),%edx
  802e7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 0b                	je     802e93 <merging+0x2fe>
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e99:	89 10                	mov    %edx,(%eax)
  802e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	75 08                	jne    802eb5 <merging+0x320>
  802ead:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb0:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802eba:	40                   	inc    %eax
  802ebb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ec0:	e9 ce 00 00 00       	jmp    802f93 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	74 65                	je     802f30 <merging+0x39b>
  802ecb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ecf:	75 17                	jne    802ee8 <merging+0x353>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 ec 43 80 00       	push   $0x8043ec
  802ed9:	68 95 01 00 00       	push   $0x195
  802ede:	68 9d 43 80 00       	push   $0x80439d
  802ee3:	e8 4c 0a 00 00       	call   803934 <_panic>
  802ee8:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802eee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef1:	89 50 04             	mov    %edx,0x4(%eax)
  802ef4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	74 0c                	je     802f0a <merging+0x375>
  802efe:	a1 34 50 80 00       	mov    0x805034,%eax
  802f03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	eb 08                	jmp    802f12 <merging+0x37d>
  802f0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f15:	a3 34 50 80 00       	mov    %eax,0x805034
  802f1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f23:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f28:	40                   	inc    %eax
  802f29:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f2e:	eb 63                	jmp    802f93 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f34:	75 17                	jne    802f4d <merging+0x3b8>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 b8 43 80 00       	push   $0x8043b8
  802f3e:	68 98 01 00 00       	push   $0x198
  802f43:	68 9d 43 80 00       	push   $0x80439d
  802f48:	e8 e7 09 00 00       	call   803934 <_panic>
  802f4d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f56:	89 10                	mov    %edx,(%eax)
  802f58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 0d                	je     802f6e <merging+0x3d9>
  802f61:	a1 30 50 80 00       	mov    0x805030,%eax
  802f66:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	eb 08                	jmp    802f76 <merging+0x3e1>
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	a3 34 50 80 00       	mov    %eax,0x805034
  802f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f79:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f8d:	40                   	inc    %eax
  802f8e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  802f93:	83 ec 0c             	sub    $0xc,%esp
  802f96:	ff 75 10             	pushl  0x10(%ebp)
  802f99:	e8 d6 ed ff ff       	call   801d74 <get_block_size>
  802f9e:	83 c4 10             	add    $0x10,%esp
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	6a 00                	push   $0x0
  802fa6:	50                   	push   %eax
  802fa7:	ff 75 10             	pushl  0x10(%ebp)
  802faa:	e8 16 f1 ff ff       	call   8020c5 <set_block_data>
  802faf:	83 c4 10             	add    $0x10,%esp
	}
}
  802fb2:	90                   	nop
  802fb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb6:	c9                   	leave  
  802fb7:	c3                   	ret    

00802fb8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fb8:	55                   	push   %ebp
  802fb9:	89 e5                	mov    %esp,%ebp
  802fbb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fbe:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fc6:	a1 34 50 80 00       	mov    0x805034,%eax
  802fcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fce:	73 1b                	jae    802feb <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fd0:	a1 34 50 80 00       	mov    0x805034,%eax
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	ff 75 08             	pushl  0x8(%ebp)
  802fdb:	6a 00                	push   $0x0
  802fdd:	50                   	push   %eax
  802fde:	e8 b2 fb ff ff       	call   802b95 <merging>
  802fe3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fe6:	e9 8b 00 00 00       	jmp    803076 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802feb:	a1 30 50 80 00       	mov    0x805030,%eax
  802ff0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff3:	76 18                	jbe    80300d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ff5:	a1 30 50 80 00       	mov    0x805030,%eax
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	ff 75 08             	pushl  0x8(%ebp)
  803000:	50                   	push   %eax
  803001:	6a 00                	push   $0x0
  803003:	e8 8d fb ff ff       	call   802b95 <merging>
  803008:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80300b:	eb 69                	jmp    803076 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80300d:	a1 30 50 80 00       	mov    0x805030,%eax
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803015:	eb 39                	jmp    803050 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301d:	73 29                	jae    803048 <free_block+0x90>
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	3b 45 08             	cmp    0x8(%ebp),%eax
  803027:	76 1f                	jbe    803048 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	ff 75 08             	pushl  0x8(%ebp)
  803037:	ff 75 f0             	pushl  -0x10(%ebp)
  80303a:	ff 75 f4             	pushl  -0xc(%ebp)
  80303d:	e8 53 fb ff ff       	call   802b95 <merging>
  803042:	83 c4 10             	add    $0x10,%esp
			break;
  803045:	90                   	nop
		}
	}
}
  803046:	eb 2e                	jmp    803076 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803048:	a1 38 50 80 00       	mov    0x805038,%eax
  80304d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803050:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803054:	74 07                	je     80305d <free_block+0xa5>
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	eb 05                	jmp    803062 <free_block+0xaa>
  80305d:	b8 00 00 00 00       	mov    $0x0,%eax
  803062:	a3 38 50 80 00       	mov    %eax,0x805038
  803067:	a1 38 50 80 00       	mov    0x805038,%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	75 a7                	jne    803017 <free_block+0x5f>
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	75 a1                	jne    803017 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803076:	90                   	nop
  803077:	c9                   	leave  
  803078:	c3                   	ret    

00803079 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
  80307c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80307f:	ff 75 08             	pushl  0x8(%ebp)
  803082:	e8 ed ec ff ff       	call   801d74 <get_block_size>
  803087:	83 c4 04             	add    $0x4,%esp
  80308a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80308d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803094:	eb 17                	jmp    8030ad <copy_data+0x34>
  803096:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309c:	01 c2                	add    %eax,%edx
  80309e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	01 c8                	add    %ecx,%eax
  8030a6:	8a 00                	mov    (%eax),%al
  8030a8:	88 02                	mov    %al,(%edx)
  8030aa:	ff 45 fc             	incl   -0x4(%ebp)
  8030ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030b3:	72 e1                	jb     803096 <copy_data+0x1d>
}
  8030b5:	90                   	nop
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
  8030bb:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c2:	75 23                	jne    8030e7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c8:	74 13                	je     8030dd <realloc_block_FF+0x25>
  8030ca:	83 ec 0c             	sub    $0xc,%esp
  8030cd:	ff 75 0c             	pushl  0xc(%ebp)
  8030d0:	e8 1f f0 ff ff       	call   8020f4 <alloc_block_FF>
  8030d5:	83 c4 10             	add    $0x10,%esp
  8030d8:	e9 f4 06 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
		return NULL;
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e2:	e9 ea 06 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030eb:	75 18                	jne    803105 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030ed:	83 ec 0c             	sub    $0xc,%esp
  8030f0:	ff 75 08             	pushl  0x8(%ebp)
  8030f3:	e8 c0 fe ff ff       	call   802fb8 <free_block>
  8030f8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803100:	e9 cc 06 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803105:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803109:	77 07                	ja     803112 <realloc_block_FF+0x5a>
  80310b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803112:	8b 45 0c             	mov    0xc(%ebp),%eax
  803115:	83 e0 01             	and    $0x1,%eax
  803118:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80311b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311e:	83 c0 08             	add    $0x8,%eax
  803121:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803124:	83 ec 0c             	sub    $0xc,%esp
  803127:	ff 75 08             	pushl  0x8(%ebp)
  80312a:	e8 45 ec ff ff       	call   801d74 <get_block_size>
  80312f:	83 c4 10             	add    $0x10,%esp
  803132:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803138:	83 e8 08             	sub    $0x8,%eax
  80313b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	83 e8 04             	sub    $0x4,%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	83 e0 fe             	and    $0xfffffffe,%eax
  803149:	89 c2                	mov    %eax,%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	01 d0                	add    %edx,%eax
  803150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803153:	83 ec 0c             	sub    $0xc,%esp
  803156:	ff 75 e4             	pushl  -0x1c(%ebp)
  803159:	e8 16 ec ff ff       	call   801d74 <get_block_size>
  80315e:	83 c4 10             	add    $0x10,%esp
  803161:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803164:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803167:	83 e8 08             	sub    $0x8,%eax
  80316a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80316d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803170:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803173:	75 08                	jne    80317d <realloc_block_FF+0xc5>
	{
		 return va;
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	e9 54 06 00 00       	jmp    8037d1 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80317d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803180:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803183:	0f 83 e5 03 00 00    	jae    80356e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	2b 45 0c             	sub    0xc(%ebp),%eax
  80318f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803192:	83 ec 0c             	sub    $0xc,%esp
  803195:	ff 75 e4             	pushl  -0x1c(%ebp)
  803198:	e8 f0 eb ff ff       	call   801d8d <is_free_block>
  80319d:	83 c4 10             	add    $0x10,%esp
  8031a0:	84 c0                	test   %al,%al
  8031a2:	0f 84 3b 01 00 00    	je     8032e3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ae:	01 d0                	add    %edx,%eax
  8031b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	6a 01                	push   $0x1
  8031b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8031bb:	ff 75 08             	pushl  0x8(%ebp)
  8031be:	e8 02 ef ff ff       	call   8020c5 <set_block_data>
  8031c3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	83 e8 04             	sub    $0x4,%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	83 e0 fe             	and    $0xfffffffe,%eax
  8031d1:	89 c2                	mov    %eax,%edx
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	01 d0                	add    %edx,%eax
  8031d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	6a 00                	push   $0x0
  8031e0:	ff 75 cc             	pushl  -0x34(%ebp)
  8031e3:	ff 75 c8             	pushl  -0x38(%ebp)
  8031e6:	e8 da ee ff ff       	call   8020c5 <set_block_data>
  8031eb:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f2:	74 06                	je     8031fa <realloc_block_FF+0x142>
  8031f4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031f8:	75 17                	jne    803211 <realloc_block_FF+0x159>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 10 44 80 00       	push   $0x804410
  803202:	68 f6 01 00 00       	push   $0x1f6
  803207:	68 9d 43 80 00       	push   $0x80439d
  80320c:	e8 23 07 00 00       	call   803934 <_panic>
  803211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803214:	8b 10                	mov    (%eax),%edx
  803216:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0b                	je     80322f <realloc_block_FF+0x177>
  803224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803232:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803235:	89 10                	mov    %edx,(%eax)
  803237:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80323a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	75 08                	jne    803251 <realloc_block_FF+0x199>
  803249:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80324c:	a3 34 50 80 00       	mov    %eax,0x805034
  803251:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803256:	40                   	inc    %eax
  803257:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80325c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803260:	75 17                	jne    803279 <realloc_block_FF+0x1c1>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 7f 43 80 00       	push   $0x80437f
  80326a:	68 f7 01 00 00       	push   $0x1f7
  80326f:	68 9d 43 80 00       	push   $0x80439d
  803274:	e8 bb 06 00 00       	call   803934 <_panic>
  803279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 10                	je     803292 <realloc_block_FF+0x1da>
  803282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80328a:	8b 52 04             	mov    0x4(%edx),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 0b                	jmp    80329d <realloc_block_FF+0x1e5>
  803292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	a3 34 50 80 00       	mov    %eax,0x805034
  80329d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	74 0f                	je     8032b6 <realloc_block_FF+0x1fe>
  8032a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032b0:	8b 12                	mov    (%edx),%edx
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	eb 0a                	jmp    8032c0 <realloc_block_FF+0x208>
  8032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032d8:	48                   	dec    %eax
  8032d9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8032de:	e9 83 02 00 00       	jmp    803566 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8032e3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032e7:	0f 86 69 02 00 00    	jbe    803556 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032ed:	83 ec 04             	sub    $0x4,%esp
  8032f0:	6a 01                	push   $0x1
  8032f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f5:	ff 75 08             	pushl  0x8(%ebp)
  8032f8:	e8 c8 ed ff ff       	call   8020c5 <set_block_data>
  8032fd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	83 e8 04             	sub    $0x4,%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	83 e0 fe             	and    $0xfffffffe,%eax
  80330b:	89 c2                	mov    %eax,%edx
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	01 d0                	add    %edx,%eax
  803312:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803315:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80331a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80331d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803321:	75 68                	jne    80338b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803323:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803327:	75 17                	jne    803340 <realloc_block_FF+0x288>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 b8 43 80 00       	push   $0x8043b8
  803331:	68 06 02 00 00       	push   $0x206
  803336:	68 9d 43 80 00       	push   $0x80439d
  80333b:	e8 f4 05 00 00       	call   803934 <_panic>
  803340:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803346:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0d                	je     803361 <realloc_block_FF+0x2a9>
  803354:	a1 30 50 80 00       	mov    0x805030,%eax
  803359:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335c:	89 50 04             	mov    %edx,0x4(%eax)
  80335f:	eb 08                	jmp    803369 <realloc_block_FF+0x2b1>
  803361:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803364:	a3 34 50 80 00       	mov    %eax,0x805034
  803369:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336c:	a3 30 50 80 00       	mov    %eax,0x805030
  803371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803380:	40                   	inc    %eax
  803381:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803386:	e9 b0 01 00 00       	jmp    80353b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80338b:	a1 30 50 80 00       	mov    0x805030,%eax
  803390:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803393:	76 68                	jbe    8033fd <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803395:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803399:	75 17                	jne    8033b2 <realloc_block_FF+0x2fa>
  80339b:	83 ec 04             	sub    $0x4,%esp
  80339e:	68 b8 43 80 00       	push   $0x8043b8
  8033a3:	68 0b 02 00 00       	push   $0x20b
  8033a8:	68 9d 43 80 00       	push   $0x80439d
  8033ad:	e8 82 05 00 00       	call   803934 <_panic>
  8033b2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bb:	89 10                	mov    %edx,(%eax)
  8033bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	74 0d                	je     8033d3 <realloc_block_FF+0x31b>
  8033c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8033cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	eb 08                	jmp    8033db <realloc_block_FF+0x323>
  8033d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d6:	a3 34 50 80 00       	mov    %eax,0x805034
  8033db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033de:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033f2:	40                   	inc    %eax
  8033f3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033f8:	e9 3e 01 00 00       	jmp    80353b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803402:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803405:	73 68                	jae    80346f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803407:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80340b:	75 17                	jne    803424 <realloc_block_FF+0x36c>
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	68 ec 43 80 00       	push   $0x8043ec
  803415:	68 10 02 00 00       	push   $0x210
  80341a:	68 9d 43 80 00       	push   $0x80439d
  80341f:	e8 10 05 00 00       	call   803934 <_panic>
  803424:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80342a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342d:	89 50 04             	mov    %edx,0x4(%eax)
  803430:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	74 0c                	je     803446 <realloc_block_FF+0x38e>
  80343a:	a1 34 50 80 00       	mov    0x805034,%eax
  80343f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	eb 08                	jmp    80344e <realloc_block_FF+0x396>
  803446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803449:	a3 30 50 80 00       	mov    %eax,0x805030
  80344e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803451:	a3 34 50 80 00       	mov    %eax,0x805034
  803456:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803464:	40                   	inc    %eax
  803465:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80346a:	e9 cc 00 00 00       	jmp    80353b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80346f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803476:	a1 30 50 80 00       	mov    0x805030,%eax
  80347b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347e:	e9 8a 00 00 00       	jmp    80350d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803489:	73 7a                	jae    803505 <realloc_block_FF+0x44d>
  80348b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803493:	73 70                	jae    803505 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	74 06                	je     8034a1 <realloc_block_FF+0x3e9>
  80349b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349f:	75 17                	jne    8034b8 <realloc_block_FF+0x400>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 10 44 80 00       	push   $0x804410
  8034a9:	68 1a 02 00 00       	push   $0x21a
  8034ae:	68 9d 43 80 00       	push   $0x80439d
  8034b3:	e8 7c 04 00 00       	call   803934 <_panic>
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	8b 10                	mov    (%eax),%edx
  8034bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0b                	je     8034d6 <realloc_block_FF+0x41e>
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	75 08                	jne    8034f8 <realloc_block_FF+0x440>
  8034f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8034f8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034fd:	40                   	inc    %eax
  8034fe:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803503:	eb 36                	jmp    80353b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803505:	a1 38 50 80 00       	mov    0x805038,%eax
  80350a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803511:	74 07                	je     80351a <realloc_block_FF+0x462>
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	eb 05                	jmp    80351f <realloc_block_FF+0x467>
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	a3 38 50 80 00       	mov    %eax,0x805038
  803524:	a1 38 50 80 00       	mov    0x805038,%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	0f 85 52 ff ff ff    	jne    803483 <realloc_block_FF+0x3cb>
  803531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803535:	0f 85 48 ff ff ff    	jne    803483 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80353b:	83 ec 04             	sub    $0x4,%esp
  80353e:	6a 00                	push   $0x0
  803540:	ff 75 d8             	pushl  -0x28(%ebp)
  803543:	ff 75 d4             	pushl  -0x2c(%ebp)
  803546:	e8 7a eb ff ff       	call   8020c5 <set_block_data>
  80354b:	83 c4 10             	add    $0x10,%esp
				return va;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	e9 7b 02 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803556:	83 ec 0c             	sub    $0xc,%esp
  803559:	68 8d 44 80 00       	push   $0x80448d
  80355e:	e8 2e ce ff ff       	call   800391 <cprintf>
  803563:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	e9 63 02 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80356e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803571:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803574:	0f 86 4d 02 00 00    	jbe    8037c7 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80357a:	83 ec 0c             	sub    $0xc,%esp
  80357d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803580:	e8 08 e8 ff ff       	call   801d8d <is_free_block>
  803585:	83 c4 10             	add    $0x10,%esp
  803588:	84 c0                	test   %al,%al
  80358a:	0f 84 37 02 00 00    	je     8037c7 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803590:	8b 45 0c             	mov    0xc(%ebp),%eax
  803593:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803596:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803599:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80359c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80359f:	76 38                	jbe    8035d9 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035a1:	83 ec 0c             	sub    $0xc,%esp
  8035a4:	ff 75 08             	pushl  0x8(%ebp)
  8035a7:	e8 0c fa ff ff       	call   802fb8 <free_block>
  8035ac:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8035af:	83 ec 0c             	sub    $0xc,%esp
  8035b2:	ff 75 0c             	pushl  0xc(%ebp)
  8035b5:	e8 3a eb ff ff       	call   8020f4 <alloc_block_FF>
  8035ba:	83 c4 10             	add    $0x10,%esp
  8035bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035c0:	83 ec 08             	sub    $0x8,%esp
  8035c3:	ff 75 c0             	pushl  -0x40(%ebp)
  8035c6:	ff 75 08             	pushl  0x8(%ebp)
  8035c9:	e8 ab fa ff ff       	call   803079 <copy_data>
  8035ce:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035d4:	e9 f8 01 00 00       	jmp    8037d1 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035dc:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035df:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035e2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035e6:	0f 87 a0 00 00 00    	ja     80368c <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f0:	75 17                	jne    803609 <realloc_block_FF+0x551>
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	68 7f 43 80 00       	push   $0x80437f
  8035fa:	68 38 02 00 00       	push   $0x238
  8035ff:	68 9d 43 80 00       	push   $0x80439d
  803604:	e8 2b 03 00 00       	call   803934 <_panic>
  803609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 10                	je     803622 <realloc_block_FF+0x56a>
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80361a:	8b 52 04             	mov    0x4(%edx),%edx
  80361d:	89 50 04             	mov    %edx,0x4(%eax)
  803620:	eb 0b                	jmp    80362d <realloc_block_FF+0x575>
  803622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803625:	8b 40 04             	mov    0x4(%eax),%eax
  803628:	a3 34 50 80 00       	mov    %eax,0x805034
  80362d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803630:	8b 40 04             	mov    0x4(%eax),%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	74 0f                	je     803646 <realloc_block_FF+0x58e>
  803637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363a:	8b 40 04             	mov    0x4(%eax),%eax
  80363d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803640:	8b 12                	mov    (%edx),%edx
  803642:	89 10                	mov    %edx,(%eax)
  803644:	eb 0a                	jmp    803650 <realloc_block_FF+0x598>
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	a3 30 50 80 00       	mov    %eax,0x805030
  803650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803653:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803663:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803668:	48                   	dec    %eax
  803669:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80366e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803674:	01 d0                	add    %edx,%eax
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	6a 01                	push   $0x1
  80367b:	50                   	push   %eax
  80367c:	ff 75 08             	pushl  0x8(%ebp)
  80367f:	e8 41 ea ff ff       	call   8020c5 <set_block_data>
  803684:	83 c4 10             	add    $0x10,%esp
  803687:	e9 36 01 00 00       	jmp    8037c2 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80368c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803692:	01 d0                	add    %edx,%eax
  803694:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	6a 01                	push   $0x1
  80369c:	ff 75 f0             	pushl  -0x10(%ebp)
  80369f:	ff 75 08             	pushl  0x8(%ebp)
  8036a2:	e8 1e ea ff ff       	call   8020c5 <set_block_data>
  8036a7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	83 e8 04             	sub    $0x4,%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8036b5:	89 c2                	mov    %eax,%edx
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	01 d0                	add    %edx,%eax
  8036bc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c3:	74 06                	je     8036cb <realloc_block_FF+0x613>
  8036c5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036c9:	75 17                	jne    8036e2 <realloc_block_FF+0x62a>
  8036cb:	83 ec 04             	sub    $0x4,%esp
  8036ce:	68 10 44 80 00       	push   $0x804410
  8036d3:	68 44 02 00 00       	push   $0x244
  8036d8:	68 9d 43 80 00       	push   $0x80439d
  8036dd:	e8 52 02 00 00       	call   803934 <_panic>
  8036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e5:	8b 10                	mov    (%eax),%edx
  8036e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ea:	89 10                	mov    %edx,(%eax)
  8036ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	85 c0                	test   %eax,%eax
  8036f3:	74 0b                	je     803700 <realloc_block_FF+0x648>
  8036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036fd:	89 50 04             	mov    %edx,0x4(%eax)
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803706:	89 10                	mov    %edx,(%eax)
  803708:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80370b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80370e:	89 50 04             	mov    %edx,0x4(%eax)
  803711:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	85 c0                	test   %eax,%eax
  803718:	75 08                	jne    803722 <realloc_block_FF+0x66a>
  80371a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80371d:	a3 34 50 80 00       	mov    %eax,0x805034
  803722:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803727:	40                   	inc    %eax
  803728:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80372d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803731:	75 17                	jne    80374a <realloc_block_FF+0x692>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 7f 43 80 00       	push   $0x80437f
  80373b:	68 45 02 00 00       	push   $0x245
  803740:	68 9d 43 80 00       	push   $0x80439d
  803745:	e8 ea 01 00 00       	call   803934 <_panic>
  80374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 10                	je     803763 <realloc_block_FF+0x6ab>
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375b:	8b 52 04             	mov    0x4(%edx),%edx
  80375e:	89 50 04             	mov    %edx,0x4(%eax)
  803761:	eb 0b                	jmp    80376e <realloc_block_FF+0x6b6>
  803763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	a3 34 50 80 00       	mov    %eax,0x805034
  80376e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 0f                	je     803787 <realloc_block_FF+0x6cf>
  803778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377b:	8b 40 04             	mov    0x4(%eax),%eax
  80377e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803781:	8b 12                	mov    (%edx),%edx
  803783:	89 10                	mov    %edx,(%eax)
  803785:	eb 0a                	jmp    803791 <realloc_block_FF+0x6d9>
  803787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	a3 30 50 80 00       	mov    %eax,0x805030
  803791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037a9:	48                   	dec    %eax
  8037aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  8037af:	83 ec 04             	sub    $0x4,%esp
  8037b2:	6a 00                	push   $0x0
  8037b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8037b7:	ff 75 b8             	pushl  -0x48(%ebp)
  8037ba:	e8 06 e9 ff ff       	call   8020c5 <set_block_data>
  8037bf:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	eb 0a                	jmp    8037d1 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037c7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037d1:	c9                   	leave  
  8037d2:	c3                   	ret    

008037d3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037d3:	55                   	push   %ebp
  8037d4:	89 e5                	mov    %esp,%ebp
  8037d6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 94 44 80 00       	push   $0x804494
  8037e1:	68 58 02 00 00       	push   $0x258
  8037e6:	68 9d 43 80 00       	push   $0x80439d
  8037eb:	e8 44 01 00 00       	call   803934 <_panic>

008037f0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037f6:	83 ec 04             	sub    $0x4,%esp
  8037f9:	68 bc 44 80 00       	push   $0x8044bc
  8037fe:	68 61 02 00 00       	push   $0x261
  803803:	68 9d 43 80 00       	push   $0x80439d
  803808:	e8 27 01 00 00       	call   803934 <_panic>

0080380d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80380d:	55                   	push   %ebp
  80380e:	89 e5                	mov    %esp,%ebp
  803810:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 e4 44 80 00       	push   $0x8044e4
  80381b:	6a 09                	push   $0x9
  80381d:	68 0c 45 80 00       	push   $0x80450c
  803822:	e8 0d 01 00 00       	call   803934 <_panic>

00803827 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803827:	55                   	push   %ebp
  803828:	89 e5                	mov    %esp,%ebp
  80382a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80382d:	83 ec 04             	sub    $0x4,%esp
  803830:	68 1c 45 80 00       	push   $0x80451c
  803835:	6a 10                	push   $0x10
  803837:	68 0c 45 80 00       	push   $0x80450c
  80383c:	e8 f3 00 00 00       	call   803934 <_panic>

00803841 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
  803844:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	68 44 45 80 00       	push   $0x804544
  80384f:	6a 18                	push   $0x18
  803851:	68 0c 45 80 00       	push   $0x80450c
  803856:	e8 d9 00 00 00       	call   803934 <_panic>

0080385b <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
  80385e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803861:	83 ec 04             	sub    $0x4,%esp
  803864:	68 6c 45 80 00       	push   $0x80456c
  803869:	6a 20                	push   $0x20
  80386b:	68 0c 45 80 00       	push   $0x80450c
  803870:	e8 bf 00 00 00       	call   803934 <_panic>

00803875 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803875:	55                   	push   %ebp
  803876:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80387e:	5d                   	pop    %ebp
  80387f:	c3                   	ret    

00803880 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803880:	55                   	push   %ebp
  803881:	89 e5                	mov    %esp,%ebp
  803883:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803886:	8b 55 08             	mov    0x8(%ebp),%edx
  803889:	89 d0                	mov    %edx,%eax
  80388b:	c1 e0 02             	shl    $0x2,%eax
  80388e:	01 d0                	add    %edx,%eax
  803890:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803897:	01 d0                	add    %edx,%eax
  803899:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a0:	01 d0                	add    %edx,%eax
  8038a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038a9:	01 d0                	add    %edx,%eax
  8038ab:	c1 e0 04             	shl    $0x4,%eax
  8038ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8038b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8038b8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8038bb:	83 ec 0c             	sub    $0xc,%esp
  8038be:	50                   	push   %eax
  8038bf:	e8 bc e1 ff ff       	call   801a80 <sys_get_virtual_time>
  8038c4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8038c7:	eb 41                	jmp    80390a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8038c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8038cc:	83 ec 0c             	sub    $0xc,%esp
  8038cf:	50                   	push   %eax
  8038d0:	e8 ab e1 ff ff       	call   801a80 <sys_get_virtual_time>
  8038d5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8038d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038de:	29 c2                	sub    %eax,%edx
  8038e0:	89 d0                	mov    %edx,%eax
  8038e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8038e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038eb:	89 d1                	mov    %edx,%ecx
  8038ed:	29 c1                	sub    %eax,%ecx
  8038ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f5:	39 c2                	cmp    %eax,%edx
  8038f7:	0f 97 c0             	seta   %al
  8038fa:	0f b6 c0             	movzbl %al,%eax
  8038fd:	29 c1                	sub    %eax,%ecx
  8038ff:	89 c8                	mov    %ecx,%eax
  803901:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803907:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80390a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803910:	72 b7                	jb     8038c9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803912:	90                   	nop
  803913:	c9                   	leave  
  803914:	c3                   	ret    

00803915 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803915:	55                   	push   %ebp
  803916:	89 e5                	mov    %esp,%ebp
  803918:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80391b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803922:	eb 03                	jmp    803927 <busy_wait+0x12>
  803924:	ff 45 fc             	incl   -0x4(%ebp)
  803927:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80392a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80392d:	72 f5                	jb     803924 <busy_wait+0xf>
	return i;
  80392f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803932:	c9                   	leave  
  803933:	c3                   	ret    

00803934 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803934:	55                   	push   %ebp
  803935:	89 e5                	mov    %esp,%ebp
  803937:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80393a:	8d 45 10             	lea    0x10(%ebp),%eax
  80393d:	83 c0 04             	add    $0x4,%eax
  803940:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803943:	a1 60 90 18 01       	mov    0x1189060,%eax
  803948:	85 c0                	test   %eax,%eax
  80394a:	74 16                	je     803962 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80394c:	a1 60 90 18 01       	mov    0x1189060,%eax
  803951:	83 ec 08             	sub    $0x8,%esp
  803954:	50                   	push   %eax
  803955:	68 94 45 80 00       	push   $0x804594
  80395a:	e8 32 ca ff ff       	call   800391 <cprintf>
  80395f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803962:	a1 00 50 80 00       	mov    0x805000,%eax
  803967:	ff 75 0c             	pushl  0xc(%ebp)
  80396a:	ff 75 08             	pushl  0x8(%ebp)
  80396d:	50                   	push   %eax
  80396e:	68 99 45 80 00       	push   $0x804599
  803973:	e8 19 ca ff ff       	call   800391 <cprintf>
  803978:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80397b:	8b 45 10             	mov    0x10(%ebp),%eax
  80397e:	83 ec 08             	sub    $0x8,%esp
  803981:	ff 75 f4             	pushl  -0xc(%ebp)
  803984:	50                   	push   %eax
  803985:	e8 9c c9 ff ff       	call   800326 <vcprintf>
  80398a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80398d:	83 ec 08             	sub    $0x8,%esp
  803990:	6a 00                	push   $0x0
  803992:	68 b5 45 80 00       	push   $0x8045b5
  803997:	e8 8a c9 ff ff       	call   800326 <vcprintf>
  80399c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80399f:	e8 0b c9 ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  8039a4:	eb fe                	jmp    8039a4 <_panic+0x70>

008039a6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039a6:	55                   	push   %ebp
  8039a7:	89 e5                	mov    %esp,%ebp
  8039a9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8039b1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ba:	39 c2                	cmp    %eax,%edx
  8039bc:	74 14                	je     8039d2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	68 b8 45 80 00       	push   $0x8045b8
  8039c6:	6a 26                	push   $0x26
  8039c8:	68 04 46 80 00       	push   $0x804604
  8039cd:	e8 62 ff ff ff       	call   803934 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039e0:	e9 c5 00 00 00       	jmp    803aaa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f2:	01 d0                	add    %edx,%eax
  8039f4:	8b 00                	mov    (%eax),%eax
  8039f6:	85 c0                	test   %eax,%eax
  8039f8:	75 08                	jne    803a02 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039fa:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039fd:	e9 a5 00 00 00       	jmp    803aa7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a10:	eb 69                	jmp    803a7b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a12:	a1 20 50 80 00       	mov    0x805020,%eax
  803a17:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a20:	89 d0                	mov    %edx,%eax
  803a22:	01 c0                	add    %eax,%eax
  803a24:	01 d0                	add    %edx,%eax
  803a26:	c1 e0 03             	shl    $0x3,%eax
  803a29:	01 c8                	add    %ecx,%eax
  803a2b:	8a 40 04             	mov    0x4(%eax),%al
  803a2e:	84 c0                	test   %al,%al
  803a30:	75 46                	jne    803a78 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a32:	a1 20 50 80 00       	mov    0x805020,%eax
  803a37:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a40:	89 d0                	mov    %edx,%eax
  803a42:	01 c0                	add    %eax,%eax
  803a44:	01 d0                	add    %edx,%eax
  803a46:	c1 e0 03             	shl    $0x3,%eax
  803a49:	01 c8                	add    %ecx,%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a58:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	01 c8                	add    %ecx,%eax
  803a69:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a6b:	39 c2                	cmp    %eax,%edx
  803a6d:	75 09                	jne    803a78 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a6f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a76:	eb 15                	jmp    803a8d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a78:	ff 45 e8             	incl   -0x18(%ebp)
  803a7b:	a1 20 50 80 00       	mov    0x805020,%eax
  803a80:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a89:	39 c2                	cmp    %eax,%edx
  803a8b:	77 85                	ja     803a12 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a91:	75 14                	jne    803aa7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a93:	83 ec 04             	sub    $0x4,%esp
  803a96:	68 10 46 80 00       	push   $0x804610
  803a9b:	6a 3a                	push   $0x3a
  803a9d:	68 04 46 80 00       	push   $0x804604
  803aa2:	e8 8d fe ff ff       	call   803934 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803aa7:	ff 45 f0             	incl   -0x10(%ebp)
  803aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ab0:	0f 8c 2f ff ff ff    	jl     8039e5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803abd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ac4:	eb 26                	jmp    803aec <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ac6:	a1 20 50 80 00       	mov    0x805020,%eax
  803acb:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ad1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ad4:	89 d0                	mov    %edx,%eax
  803ad6:	01 c0                	add    %eax,%eax
  803ad8:	01 d0                	add    %edx,%eax
  803ada:	c1 e0 03             	shl    $0x3,%eax
  803add:	01 c8                	add    %ecx,%eax
  803adf:	8a 40 04             	mov    0x4(%eax),%al
  803ae2:	3c 01                	cmp    $0x1,%al
  803ae4:	75 03                	jne    803ae9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ae6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ae9:	ff 45 e0             	incl   -0x20(%ebp)
  803aec:	a1 20 50 80 00       	mov    0x805020,%eax
  803af1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803afa:	39 c2                	cmp    %eax,%edx
  803afc:	77 c8                	ja     803ac6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b01:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b04:	74 14                	je     803b1a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b06:	83 ec 04             	sub    $0x4,%esp
  803b09:	68 64 46 80 00       	push   $0x804664
  803b0e:	6a 44                	push   $0x44
  803b10:	68 04 46 80 00       	push   $0x804604
  803b15:	e8 1a fe ff ff       	call   803934 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b1a:	90                   	nop
  803b1b:	c9                   	leave  
  803b1c:	c3                   	ret    
  803b1d:	66 90                	xchg   %ax,%ax
  803b1f:	90                   	nop

00803b20 <__udivdi3>:
  803b20:	55                   	push   %ebp
  803b21:	57                   	push   %edi
  803b22:	56                   	push   %esi
  803b23:	53                   	push   %ebx
  803b24:	83 ec 1c             	sub    $0x1c,%esp
  803b27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b37:	89 ca                	mov    %ecx,%edx
  803b39:	89 f8                	mov    %edi,%eax
  803b3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b3f:	85 f6                	test   %esi,%esi
  803b41:	75 2d                	jne    803b70 <__udivdi3+0x50>
  803b43:	39 cf                	cmp    %ecx,%edi
  803b45:	77 65                	ja     803bac <__udivdi3+0x8c>
  803b47:	89 fd                	mov    %edi,%ebp
  803b49:	85 ff                	test   %edi,%edi
  803b4b:	75 0b                	jne    803b58 <__udivdi3+0x38>
  803b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b52:	31 d2                	xor    %edx,%edx
  803b54:	f7 f7                	div    %edi
  803b56:	89 c5                	mov    %eax,%ebp
  803b58:	31 d2                	xor    %edx,%edx
  803b5a:	89 c8                	mov    %ecx,%eax
  803b5c:	f7 f5                	div    %ebp
  803b5e:	89 c1                	mov    %eax,%ecx
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	f7 f5                	div    %ebp
  803b64:	89 cf                	mov    %ecx,%edi
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	39 ce                	cmp    %ecx,%esi
  803b72:	77 28                	ja     803b9c <__udivdi3+0x7c>
  803b74:	0f bd fe             	bsr    %esi,%edi
  803b77:	83 f7 1f             	xor    $0x1f,%edi
  803b7a:	75 40                	jne    803bbc <__udivdi3+0x9c>
  803b7c:	39 ce                	cmp    %ecx,%esi
  803b7e:	72 0a                	jb     803b8a <__udivdi3+0x6a>
  803b80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b84:	0f 87 9e 00 00 00    	ja     803c28 <__udivdi3+0x108>
  803b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8f:	89 fa                	mov    %edi,%edx
  803b91:	83 c4 1c             	add    $0x1c,%esp
  803b94:	5b                   	pop    %ebx
  803b95:	5e                   	pop    %esi
  803b96:	5f                   	pop    %edi
  803b97:	5d                   	pop    %ebp
  803b98:	c3                   	ret    
  803b99:	8d 76 00             	lea    0x0(%esi),%esi
  803b9c:	31 ff                	xor    %edi,%edi
  803b9e:	31 c0                	xor    %eax,%eax
  803ba0:	89 fa                	mov    %edi,%edx
  803ba2:	83 c4 1c             	add    $0x1c,%esp
  803ba5:	5b                   	pop    %ebx
  803ba6:	5e                   	pop    %esi
  803ba7:	5f                   	pop    %edi
  803ba8:	5d                   	pop    %ebp
  803ba9:	c3                   	ret    
  803baa:	66 90                	xchg   %ax,%ax
  803bac:	89 d8                	mov    %ebx,%eax
  803bae:	f7 f7                	div    %edi
  803bb0:	31 ff                	xor    %edi,%edi
  803bb2:	89 fa                	mov    %edi,%edx
  803bb4:	83 c4 1c             	add    $0x1c,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5e                   	pop    %esi
  803bb9:	5f                   	pop    %edi
  803bba:	5d                   	pop    %ebp
  803bbb:	c3                   	ret    
  803bbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bc1:	89 eb                	mov    %ebp,%ebx
  803bc3:	29 fb                	sub    %edi,%ebx
  803bc5:	89 f9                	mov    %edi,%ecx
  803bc7:	d3 e6                	shl    %cl,%esi
  803bc9:	89 c5                	mov    %eax,%ebp
  803bcb:	88 d9                	mov    %bl,%cl
  803bcd:	d3 ed                	shr    %cl,%ebp
  803bcf:	89 e9                	mov    %ebp,%ecx
  803bd1:	09 f1                	or     %esi,%ecx
  803bd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bd7:	89 f9                	mov    %edi,%ecx
  803bd9:	d3 e0                	shl    %cl,%eax
  803bdb:	89 c5                	mov    %eax,%ebp
  803bdd:	89 d6                	mov    %edx,%esi
  803bdf:	88 d9                	mov    %bl,%cl
  803be1:	d3 ee                	shr    %cl,%esi
  803be3:	89 f9                	mov    %edi,%ecx
  803be5:	d3 e2                	shl    %cl,%edx
  803be7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803beb:	88 d9                	mov    %bl,%cl
  803bed:	d3 e8                	shr    %cl,%eax
  803bef:	09 c2                	or     %eax,%edx
  803bf1:	89 d0                	mov    %edx,%eax
  803bf3:	89 f2                	mov    %esi,%edx
  803bf5:	f7 74 24 0c          	divl   0xc(%esp)
  803bf9:	89 d6                	mov    %edx,%esi
  803bfb:	89 c3                	mov    %eax,%ebx
  803bfd:	f7 e5                	mul    %ebp
  803bff:	39 d6                	cmp    %edx,%esi
  803c01:	72 19                	jb     803c1c <__udivdi3+0xfc>
  803c03:	74 0b                	je     803c10 <__udivdi3+0xf0>
  803c05:	89 d8                	mov    %ebx,%eax
  803c07:	31 ff                	xor    %edi,%edi
  803c09:	e9 58 ff ff ff       	jmp    803b66 <__udivdi3+0x46>
  803c0e:	66 90                	xchg   %ax,%ax
  803c10:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c14:	89 f9                	mov    %edi,%ecx
  803c16:	d3 e2                	shl    %cl,%edx
  803c18:	39 c2                	cmp    %eax,%edx
  803c1a:	73 e9                	jae    803c05 <__udivdi3+0xe5>
  803c1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c1f:	31 ff                	xor    %edi,%edi
  803c21:	e9 40 ff ff ff       	jmp    803b66 <__udivdi3+0x46>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	31 c0                	xor    %eax,%eax
  803c2a:	e9 37 ff ff ff       	jmp    803b66 <__udivdi3+0x46>
  803c2f:	90                   	nop

00803c30 <__umoddi3>:
  803c30:	55                   	push   %ebp
  803c31:	57                   	push   %edi
  803c32:	56                   	push   %esi
  803c33:	53                   	push   %ebx
  803c34:	83 ec 1c             	sub    $0x1c,%esp
  803c37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c4f:	89 f3                	mov    %esi,%ebx
  803c51:	89 fa                	mov    %edi,%edx
  803c53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c57:	89 34 24             	mov    %esi,(%esp)
  803c5a:	85 c0                	test   %eax,%eax
  803c5c:	75 1a                	jne    803c78 <__umoddi3+0x48>
  803c5e:	39 f7                	cmp    %esi,%edi
  803c60:	0f 86 a2 00 00 00    	jbe    803d08 <__umoddi3+0xd8>
  803c66:	89 c8                	mov    %ecx,%eax
  803c68:	89 f2                	mov    %esi,%edx
  803c6a:	f7 f7                	div    %edi
  803c6c:	89 d0                	mov    %edx,%eax
  803c6e:	31 d2                	xor    %edx,%edx
  803c70:	83 c4 1c             	add    $0x1c,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
  803c78:	39 f0                	cmp    %esi,%eax
  803c7a:	0f 87 ac 00 00 00    	ja     803d2c <__umoddi3+0xfc>
  803c80:	0f bd e8             	bsr    %eax,%ebp
  803c83:	83 f5 1f             	xor    $0x1f,%ebp
  803c86:	0f 84 ac 00 00 00    	je     803d38 <__umoddi3+0x108>
  803c8c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c91:	29 ef                	sub    %ebp,%edi
  803c93:	89 fe                	mov    %edi,%esi
  803c95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c99:	89 e9                	mov    %ebp,%ecx
  803c9b:	d3 e0                	shl    %cl,%eax
  803c9d:	89 d7                	mov    %edx,%edi
  803c9f:	89 f1                	mov    %esi,%ecx
  803ca1:	d3 ef                	shr    %cl,%edi
  803ca3:	09 c7                	or     %eax,%edi
  803ca5:	89 e9                	mov    %ebp,%ecx
  803ca7:	d3 e2                	shl    %cl,%edx
  803ca9:	89 14 24             	mov    %edx,(%esp)
  803cac:	89 d8                	mov    %ebx,%eax
  803cae:	d3 e0                	shl    %cl,%eax
  803cb0:	89 c2                	mov    %eax,%edx
  803cb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb6:	d3 e0                	shl    %cl,%eax
  803cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cbc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc0:	89 f1                	mov    %esi,%ecx
  803cc2:	d3 e8                	shr    %cl,%eax
  803cc4:	09 d0                	or     %edx,%eax
  803cc6:	d3 eb                	shr    %cl,%ebx
  803cc8:	89 da                	mov    %ebx,%edx
  803cca:	f7 f7                	div    %edi
  803ccc:	89 d3                	mov    %edx,%ebx
  803cce:	f7 24 24             	mull   (%esp)
  803cd1:	89 c6                	mov    %eax,%esi
  803cd3:	89 d1                	mov    %edx,%ecx
  803cd5:	39 d3                	cmp    %edx,%ebx
  803cd7:	0f 82 87 00 00 00    	jb     803d64 <__umoddi3+0x134>
  803cdd:	0f 84 91 00 00 00    	je     803d74 <__umoddi3+0x144>
  803ce3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ce7:	29 f2                	sub    %esi,%edx
  803ce9:	19 cb                	sbb    %ecx,%ebx
  803ceb:	89 d8                	mov    %ebx,%eax
  803ced:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cf1:	d3 e0                	shl    %cl,%eax
  803cf3:	89 e9                	mov    %ebp,%ecx
  803cf5:	d3 ea                	shr    %cl,%edx
  803cf7:	09 d0                	or     %edx,%eax
  803cf9:	89 e9                	mov    %ebp,%ecx
  803cfb:	d3 eb                	shr    %cl,%ebx
  803cfd:	89 da                	mov    %ebx,%edx
  803cff:	83 c4 1c             	add    $0x1c,%esp
  803d02:	5b                   	pop    %ebx
  803d03:	5e                   	pop    %esi
  803d04:	5f                   	pop    %edi
  803d05:	5d                   	pop    %ebp
  803d06:	c3                   	ret    
  803d07:	90                   	nop
  803d08:	89 fd                	mov    %edi,%ebp
  803d0a:	85 ff                	test   %edi,%edi
  803d0c:	75 0b                	jne    803d19 <__umoddi3+0xe9>
  803d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d13:	31 d2                	xor    %edx,%edx
  803d15:	f7 f7                	div    %edi
  803d17:	89 c5                	mov    %eax,%ebp
  803d19:	89 f0                	mov    %esi,%eax
  803d1b:	31 d2                	xor    %edx,%edx
  803d1d:	f7 f5                	div    %ebp
  803d1f:	89 c8                	mov    %ecx,%eax
  803d21:	f7 f5                	div    %ebp
  803d23:	89 d0                	mov    %edx,%eax
  803d25:	e9 44 ff ff ff       	jmp    803c6e <__umoddi3+0x3e>
  803d2a:	66 90                	xchg   %ax,%ax
  803d2c:	89 c8                	mov    %ecx,%eax
  803d2e:	89 f2                	mov    %esi,%edx
  803d30:	83 c4 1c             	add    $0x1c,%esp
  803d33:	5b                   	pop    %ebx
  803d34:	5e                   	pop    %esi
  803d35:	5f                   	pop    %edi
  803d36:	5d                   	pop    %ebp
  803d37:	c3                   	ret    
  803d38:	3b 04 24             	cmp    (%esp),%eax
  803d3b:	72 06                	jb     803d43 <__umoddi3+0x113>
  803d3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d41:	77 0f                	ja     803d52 <__umoddi3+0x122>
  803d43:	89 f2                	mov    %esi,%edx
  803d45:	29 f9                	sub    %edi,%ecx
  803d47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d4b:	89 14 24             	mov    %edx,(%esp)
  803d4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d56:	8b 14 24             	mov    (%esp),%edx
  803d59:	83 c4 1c             	add    $0x1c,%esp
  803d5c:	5b                   	pop    %ebx
  803d5d:	5e                   	pop    %esi
  803d5e:	5f                   	pop    %edi
  803d5f:	5d                   	pop    %ebp
  803d60:	c3                   	ret    
  803d61:	8d 76 00             	lea    0x0(%esi),%esi
  803d64:	2b 04 24             	sub    (%esp),%eax
  803d67:	19 fa                	sbb    %edi,%edx
  803d69:	89 d1                	mov    %edx,%ecx
  803d6b:	89 c6                	mov    %eax,%esi
  803d6d:	e9 71 ff ff ff       	jmp    803ce3 <__umoddi3+0xb3>
  803d72:	66 90                	xchg   %ax,%ax
  803d74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d78:	72 ea                	jb     803d64 <__umoddi3+0x134>
  803d7a:	89 d9                	mov    %ebx,%ecx
  803d7c:	e9 62 ff ff ff       	jmp    803ce3 <__umoddi3+0xb3>
