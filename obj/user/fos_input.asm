
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 a0 1e 80 00       	push   $0x801ea0
  80005e:	e8 1e 0a 00 00       	call   800a81 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 71 0e 00 00       	call   800eea <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 c9 18 00 00       	call   801955 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 bc 1e 80 00       	push   $0x801ebc
  80009e:	e8 de 09 00 00       	call   800a81 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 31 0e 00 00       	call   800eea <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 d9 1e 80 00       	push   $0x801ed9
  8000d0:	e8 46 02 00 00       	call   80031b <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 93 14 00 00       	call   801579 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 03             	shl    $0x3,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000fa:	01 c8                	add    %ecx,%eax
  8000fc:	01 c0                	add    %eax,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800107:	01 c8                	add    %ecx,%eax
  800109:	01 d0                	add    %edx,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800115:	a1 04 30 80 00       	mov    0x803004,%eax
  80011a:	8a 40 20             	mov    0x20(%eax),%al
  80011d:	84 c0                	test   %al,%al
  80011f:	74 0d                	je     80012e <libmain+0x53>
		binaryname = myEnv->prog_name;
  800121:	a1 04 30 80 00       	mov    0x803004,%eax
  800126:	83 c0 20             	add    $0x20,%eax
  800129:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800132:	7e 0a                	jle    80013e <libmain+0x63>
		binaryname = argv[0];
  800134:	8b 45 0c             	mov    0xc(%ebp),%eax
  800137:	8b 00                	mov    (%eax),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	e8 ec fe ff ff       	call   800038 <_main>
  80014c:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80014f:	e8 a9 11 00 00       	call   8012fd <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	68 0c 1f 80 00       	push   $0x801f0c
  80015c:	e8 8d 01 00 00       	call   8002ee <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800164:	a1 04 30 80 00       	mov    0x803004,%eax
  800169:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80016f:	a1 04 30 80 00       	mov    0x803004,%eax
  800174:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80017a:	83 ec 04             	sub    $0x4,%esp
  80017d:	52                   	push   %edx
  80017e:	50                   	push   %eax
  80017f:	68 34 1f 80 00       	push   $0x801f34
  800184:	e8 65 01 00 00       	call   8002ee <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018c:	a1 04 30 80 00       	mov    0x803004,%eax
  800191:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800197:	a1 04 30 80 00       	mov    0x803004,%eax
  80019c:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a7:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001ad:	51                   	push   %ecx
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	68 5c 1f 80 00       	push   $0x801f5c
  8001b5:	e8 34 01 00 00       	call   8002ee <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c2:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	50                   	push   %eax
  8001cc:	68 b4 1f 80 00       	push   $0x801fb4
  8001d1:	e8 18 01 00 00       	call   8002ee <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	68 0c 1f 80 00       	push   $0x801f0c
  8001e1:	e8 08 01 00 00       	call   8002ee <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001e9:	e8 29 11 00 00       	call   801317 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001ee:	e8 19 00 00 00       	call   80020c <exit>
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	6a 00                	push   $0x0
  800201:	e8 3f 13 00 00       	call   801545 <sys_destroy_env>
  800206:	83 c4 10             	add    $0x10,%esp
}
  800209:	90                   	nop
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <exit>:

void
exit(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800212:	e8 94 13 00 00       	call   8015ab <sys_exit_env>
}
  800217:	90                   	nop
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800220:	8b 45 0c             	mov    0xc(%ebp),%eax
  800223:	8b 00                	mov    (%eax),%eax
  800225:	8d 48 01             	lea    0x1(%eax),%ecx
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	89 0a                	mov    %ecx,(%edx)
  80022d:	8b 55 08             	mov    0x8(%ebp),%edx
  800230:	88 d1                	mov    %dl,%cl
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	8b 00                	mov    (%eax),%eax
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 2c                	jne    800271 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800245:	a0 08 30 80 00       	mov    0x803008,%al
  80024a:	0f b6 c0             	movzbl %al,%eax
  80024d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800250:	8b 12                	mov    (%edx),%edx
  800252:	89 d1                	mov    %edx,%ecx
  800254:	8b 55 0c             	mov    0xc(%ebp),%edx
  800257:	83 c2 08             	add    $0x8,%edx
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	50                   	push   %eax
  80025e:	51                   	push   %ecx
  80025f:	52                   	push   %edx
  800260:	e8 56 10 00 00       	call   8012bb <sys_cputs>
  800265:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800271:	8b 45 0c             	mov    0xc(%ebp),%eax
  800274:	8b 40 04             	mov    0x4(%eax),%eax
  800277:	8d 50 01             	lea    0x1(%eax),%edx
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80028c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800293:	00 00 00 
	b.cnt = 0;
  800296:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a0:	ff 75 0c             	pushl  0xc(%ebp)
  8002a3:	ff 75 08             	pushl  0x8(%ebp)
  8002a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ac:	50                   	push   %eax
  8002ad:	68 1a 02 80 00       	push   $0x80021a
  8002b2:	e8 11 02 00 00       	call   8004c8 <vprintfmt>
  8002b7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002ba:	a0 08 30 80 00       	mov    0x803008,%al
  8002bf:	0f b6 c0             	movzbl %al,%eax
  8002c2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	50                   	push   %eax
  8002cc:	52                   	push   %edx
  8002cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d3:	83 c0 08             	add    $0x8,%eax
  8002d6:	50                   	push   %eax
  8002d7:	e8 df 0f 00 00       	call   8012bb <sys_cputs>
  8002dc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002df:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f4:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 75 f4             	pushl  -0xc(%ebp)
  80030a:	50                   	push   %eax
  80030b:	e8 73 ff ff ff       	call   800283 <vcprintf>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800321:	e8 d7 0f 00 00       	call   8012fd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800326:	8d 45 0c             	lea    0xc(%ebp),%eax
  800329:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80032c:	8b 45 08             	mov    0x8(%ebp),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 f4             	pushl  -0xc(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 48 ff ff ff       	call   800283 <vcprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800341:	e8 d1 0f 00 00       	call   801317 <sys_unlock_cons>
	return cnt;
  800346:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	53                   	push   %ebx
  80034f:	83 ec 14             	sub    $0x14,%esp
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035e:	8b 45 18             	mov    0x18(%ebp),%eax
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800369:	77 55                	ja     8003c0 <printnum+0x75>
  80036b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036e:	72 05                	jb     800375 <printnum+0x2a>
  800370:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800373:	77 4b                	ja     8003c0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800375:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800378:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037b:	8b 45 18             	mov    0x18(%ebp),%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	52                   	push   %edx
  800384:	50                   	push   %eax
  800385:	ff 75 f4             	pushl  -0xc(%ebp)
  800388:	ff 75 f0             	pushl  -0x10(%ebp)
  80038b:	e8 a0 18 00 00       	call   801c30 <__udivdi3>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	83 ec 04             	sub    $0x4,%esp
  800396:	ff 75 20             	pushl  0x20(%ebp)
  800399:	53                   	push   %ebx
  80039a:	ff 75 18             	pushl  0x18(%ebp)
  80039d:	52                   	push   %edx
  80039e:	50                   	push   %eax
  80039f:	ff 75 0c             	pushl  0xc(%ebp)
  8003a2:	ff 75 08             	pushl  0x8(%ebp)
  8003a5:	e8 a1 ff ff ff       	call   80034b <printnum>
  8003aa:	83 c4 20             	add    $0x20,%esp
  8003ad:	eb 1a                	jmp    8003c9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	ff 75 0c             	pushl  0xc(%ebp)
  8003b5:	ff 75 20             	pushl  0x20(%ebp)
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	ff d0                	call   *%eax
  8003bd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c0:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c7:	7f e6                	jg     8003af <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d7:	53                   	push   %ebx
  8003d8:	51                   	push   %ecx
  8003d9:	52                   	push   %edx
  8003da:	50                   	push   %eax
  8003db:	e8 60 19 00 00       	call   801d40 <__umoddi3>
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	05 f4 21 80 00       	add    $0x8021f4,%eax
  8003e8:	8a 00                	mov    (%eax),%al
  8003ea:	0f be c0             	movsbl %al,%eax
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	ff 75 0c             	pushl  0xc(%ebp)
  8003f3:	50                   	push   %eax
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	ff d0                	call   *%eax
  8003f9:	83 c4 10             	add    $0x10,%esp
}
  8003fc:	90                   	nop
  8003fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800405:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800409:	7e 1c                	jle    800427 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 50 08             	lea    0x8(%eax),%edx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	89 10                	mov    %edx,(%eax)
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	83 e8 08             	sub    $0x8,%eax
  800420:	8b 50 04             	mov    0x4(%eax),%edx
  800423:	8b 00                	mov    (%eax),%eax
  800425:	eb 40                	jmp    800467 <getuint+0x65>
	else if (lflag)
  800427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042b:	74 1e                	je     80044b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 04             	lea    0x4(%eax),%edx
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	83 e8 04             	sub    $0x4,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	eb 1c                	jmp    800467 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	8d 50 04             	lea    0x4(%eax),%edx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	89 10                	mov    %edx,(%eax)
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	83 e8 04             	sub    $0x4,%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800470:	7e 1c                	jle    80048e <getint+0x25>
		return va_arg(*ap, long long);
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	8d 50 08             	lea    0x8(%eax),%edx
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 10                	mov    %edx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	83 e8 08             	sub    $0x8,%eax
  800487:	8b 50 04             	mov    0x4(%eax),%edx
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	eb 38                	jmp    8004c6 <getint+0x5d>
	else if (lflag)
  80048e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800492:	74 1a                	je     8004ae <getint+0x45>
		return va_arg(*ap, long);
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	8d 50 04             	lea    0x4(%eax),%edx
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	89 10                	mov    %edx,(%eax)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	83 e8 04             	sub    $0x4,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	99                   	cltd   
  8004ac:	eb 18                	jmp    8004c6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 50 04             	lea    0x4(%eax),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	83 e8 04             	sub    $0x4,%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	99                   	cltd   
}
  8004c6:	5d                   	pop    %ebp
  8004c7:	c3                   	ret    

008004c8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d0:	eb 17                	jmp    8004e9 <vprintfmt+0x21>
			if (ch == '\0')
  8004d2:	85 db                	test   %ebx,%ebx
  8004d4:	0f 84 c1 03 00 00    	je     80089b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	53                   	push   %ebx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	ff d0                	call   *%eax
  8004e6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ec:	8d 50 01             	lea    0x1(%eax),%edx
  8004ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f2:	8a 00                	mov    (%eax),%al
  8004f4:	0f b6 d8             	movzbl %al,%ebx
  8004f7:	83 fb 25             	cmp    $0x25,%ebx
  8004fa:	75 d6                	jne    8004d2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004fc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800500:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800507:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800515:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051c:	8b 45 10             	mov    0x10(%ebp),%eax
  80051f:	8d 50 01             	lea    0x1(%eax),%edx
  800522:	89 55 10             	mov    %edx,0x10(%ebp)
  800525:	8a 00                	mov    (%eax),%al
  800527:	0f b6 d8             	movzbl %al,%ebx
  80052a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80052d:	83 f8 5b             	cmp    $0x5b,%eax
  800530:	0f 87 3d 03 00 00    	ja     800873 <vprintfmt+0x3ab>
  800536:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  80053d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80053f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800543:	eb d7                	jmp    80051c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800545:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800549:	eb d1                	jmp    80051c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	89 d0                	mov    %edx,%eax
  800557:	c1 e0 02             	shl    $0x2,%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	01 c0                	add    %eax,%eax
  80055e:	01 d8                	add    %ebx,%eax
  800560:	83 e8 30             	sub    $0x30,%eax
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800566:	8b 45 10             	mov    0x10(%ebp),%eax
  800569:	8a 00                	mov    (%eax),%al
  80056b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80056e:	83 fb 2f             	cmp    $0x2f,%ebx
  800571:	7e 3e                	jle    8005b1 <vprintfmt+0xe9>
  800573:	83 fb 39             	cmp    $0x39,%ebx
  800576:	7f 39                	jg     8005b1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800578:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80057b:	eb d5                	jmp    800552 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	83 c0 04             	add    $0x4,%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	83 e8 04             	sub    $0x4,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800591:	eb 1f                	jmp    8005b2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800593:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800597:	79 83                	jns    80051c <vprintfmt+0x54>
				width = 0;
  800599:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a0:	e9 77 ff ff ff       	jmp    80051c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005ac:	e9 6b ff ff ff       	jmp    80051c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b6:	0f 89 60 ff ff ff    	jns    80051c <vprintfmt+0x54>
				width = precision, precision = -1;
  8005bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c9:	e9 4e ff ff ff       	jmp    80051c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ce:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d1:	e9 46 ff ff ff       	jmp    80051c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 c0 04             	add    $0x4,%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	83 e8 04             	sub    $0x4,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 0c             	pushl  0xc(%ebp)
  8005ed:	50                   	push   %eax
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	ff d0                	call   *%eax
  8005f3:	83 c4 10             	add    $0x10,%esp
			break;
  8005f6:	e9 9b 02 00 00       	jmp    800896 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	83 c0 04             	add    $0x4,%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	83 e8 04             	sub    $0x4,%eax
  80060a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80060c:	85 db                	test   %ebx,%ebx
  80060e:	79 02                	jns    800612 <vprintfmt+0x14a>
				err = -err;
  800610:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800612:	83 fb 64             	cmp    $0x64,%ebx
  800615:	7f 0b                	jg     800622 <vprintfmt+0x15a>
  800617:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  80061e:	85 f6                	test   %esi,%esi
  800620:	75 19                	jne    80063b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800622:	53                   	push   %ebx
  800623:	68 05 22 80 00       	push   $0x802205
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 08             	pushl  0x8(%ebp)
  80062e:	e8 70 02 00 00       	call   8008a3 <printfmt>
  800633:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800636:	e9 5b 02 00 00       	jmp    800896 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063b:	56                   	push   %esi
  80063c:	68 0e 22 80 00       	push   $0x80220e
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	ff 75 08             	pushl  0x8(%ebp)
  800647:	e8 57 02 00 00       	call   8008a3 <printfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
			break;
  80064f:	e9 42 02 00 00       	jmp    800896 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	83 c0 04             	add    $0x4,%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 30                	mov    (%eax),%esi
  800665:	85 f6                	test   %esi,%esi
  800667:	75 05                	jne    80066e <vprintfmt+0x1a6>
				p = "(null)";
  800669:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  80066e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800672:	7e 6d                	jle    8006e1 <vprintfmt+0x219>
  800674:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800678:	74 67                	je     8006e1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	56                   	push   %esi
  800682:	e8 26 05 00 00       	call   800bad <strnlen>
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80068d:	eb 16                	jmp    8006a5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80068f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	50                   	push   %eax
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a9:	7f e4                	jg     80068f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ab:	eb 34                	jmp    8006e1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b1:	74 1c                	je     8006cf <vprintfmt+0x207>
  8006b3:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b6:	7e 05                	jle    8006bd <vprintfmt+0x1f5>
  8006b8:	83 fb 7e             	cmp    $0x7e,%ebx
  8006bb:	7e 12                	jle    8006cf <vprintfmt+0x207>
					putch('?', putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	6a 3f                	push   $0x3f
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	eb 0f                	jmp    8006de <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	53                   	push   %ebx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	ff d0                	call   *%eax
  8006db:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006de:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e1:	89 f0                	mov    %esi,%eax
  8006e3:	8d 70 01             	lea    0x1(%eax),%esi
  8006e6:	8a 00                	mov    (%eax),%al
  8006e8:	0f be d8             	movsbl %al,%ebx
  8006eb:	85 db                	test   %ebx,%ebx
  8006ed:	74 24                	je     800713 <vprintfmt+0x24b>
  8006ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f3:	78 b8                	js     8006ad <vprintfmt+0x1e5>
  8006f5:	ff 4d e0             	decl   -0x20(%ebp)
  8006f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fc:	79 af                	jns    8006ad <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fe:	eb 13                	jmp    800713 <vprintfmt+0x24b>
				putch(' ', putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	6a 20                	push   $0x20
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800710:	ff 4d e4             	decl   -0x1c(%ebp)
  800713:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800717:	7f e7                	jg     800700 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800719:	e9 78 01 00 00       	jmp    800896 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 e8             	pushl  -0x18(%ebp)
  800724:	8d 45 14             	lea    0x14(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 3c fd ff ff       	call   800469 <getint>
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800733:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073c:	85 d2                	test   %edx,%edx
  80073e:	79 23                	jns    800763 <vprintfmt+0x29b>
				putch('-', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	ff 75 0c             	pushl  0xc(%ebp)
  800746:	6a 2d                	push   $0x2d
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800756:	f7 d8                	neg    %eax
  800758:	83 d2 00             	adc    $0x0,%edx
  80075b:	f7 da                	neg    %edx
  80075d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800760:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800763:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076a:	e9 bc 00 00 00       	jmp    80082b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 e8             	pushl  -0x18(%ebp)
  800775:	8d 45 14             	lea    0x14(%ebp),%eax
  800778:	50                   	push   %eax
  800779:	e8 84 fc ff ff       	call   800402 <getuint>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800784:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800787:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078e:	e9 98 00 00 00       	jmp    80082b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	6a 58                	push   $0x58
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	6a 58                	push   $0x58
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	ff d0                	call   *%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 58                	push   $0x58
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
			break;
  8007c3:	e9 ce 00 00 00       	jmp    800896 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	6a 30                	push   $0x30
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	ff d0                	call   *%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	6a 78                	push   $0x78
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	ff d0                	call   *%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	83 c0 04             	add    $0x4,%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800803:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80080a:	eb 1f                	jmp    80082b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 e8             	pushl  -0x18(%ebp)
  800812:	8d 45 14             	lea    0x14(%ebp),%eax
  800815:	50                   	push   %eax
  800816:	e8 e7 fb ff ff       	call   800402 <getuint>
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800821:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800824:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80082f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	52                   	push   %edx
  800836:	ff 75 e4             	pushl  -0x1c(%ebp)
  800839:	50                   	push   %eax
  80083a:	ff 75 f4             	pushl  -0xc(%ebp)
  80083d:	ff 75 f0             	pushl  -0x10(%ebp)
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	e8 00 fb ff ff       	call   80034b <printnum>
  80084b:	83 c4 20             	add    $0x20,%esp
			break;
  80084e:	eb 46                	jmp    800896 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	53                   	push   %ebx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
			break;
  80085f:	eb 35                	jmp    800896 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800861:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800868:	eb 2c                	jmp    800896 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80086a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800871:	eb 23                	jmp    800896 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	6a 25                	push   $0x25
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800883:	ff 4d 10             	decl   0x10(%ebp)
  800886:	eb 03                	jmp    80088b <vprintfmt+0x3c3>
  800888:	ff 4d 10             	decl   0x10(%ebp)
  80088b:	8b 45 10             	mov    0x10(%ebp),%eax
  80088e:	48                   	dec    %eax
  80088f:	8a 00                	mov    (%eax),%al
  800891:	3c 25                	cmp    $0x25,%al
  800893:	75 f3                	jne    800888 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800895:	90                   	nop
		}
	}
  800896:	e9 35 fc ff ff       	jmp    8004d0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80089b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80089c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80089f:	5b                   	pop    %ebx
  8008a0:	5e                   	pop    %esi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ac:	83 c0 04             	add    $0x4,%eax
  8008af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 04 fc ff ff       	call   8004c8 <vprintfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008c7:	90                   	nop
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	8b 40 08             	mov    0x8(%eax),%eax
  8008d3:	8d 50 01             	lea    0x1(%eax),%edx
  8008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	8b 10                	mov    (%eax),%edx
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	8b 40 04             	mov    0x4(%eax),%eax
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	73 12                	jae    8008fd <sprintputch+0x33>
		*b->buf++ = ch;
  8008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f6:	89 0a                	mov    %ecx,(%edx)
  8008f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8008fb:	88 10                	mov    %dl,(%eax)
}
  8008fd:	90                   	nop
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	01 d0                	add    %edx,%eax
  800917:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800921:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800925:	74 06                	je     80092d <vsnprintf+0x2d>
  800927:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092b:	7f 07                	jg     800934 <vsnprintf+0x34>
		return -E_INVAL;
  80092d:	b8 03 00 00 00       	mov    $0x3,%eax
  800932:	eb 20                	jmp    800954 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800934:	ff 75 14             	pushl  0x14(%ebp)
  800937:	ff 75 10             	pushl  0x10(%ebp)
  80093a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093d:	50                   	push   %eax
  80093e:	68 ca 08 80 00       	push   $0x8008ca
  800943:	e8 80 fb ff ff       	call   8004c8 <vprintfmt>
  800948:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800951:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80095c:	8d 45 10             	lea    0x10(%ebp),%eax
  80095f:	83 c0 04             	add    $0x4,%eax
  800962:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800965:	8b 45 10             	mov    0x10(%ebp),%eax
  800968:	ff 75 f4             	pushl  -0xc(%ebp)
  80096b:	50                   	push   %eax
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 89 ff ff ff       	call   800900 <vsnprintf>
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80097d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80098c:	74 13                	je     8009a1 <readline+0x1f>
		cprintf("%s", prompt);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 08             	pushl  0x8(%ebp)
  800994:	68 88 23 80 00       	push   $0x802388
  800999:	e8 50 f9 ff ff       	call   8002ee <cprintf>
  80099e:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	6a 00                	push   $0x0
  8009ad:	e8 89 10 00 00       	call   801a3b <iscons>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009b8:	e8 6b 10 00 00       	call   801a28 <getchar>
  8009bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009c4:	79 22                	jns    8009e8 <readline+0x66>
			if (c != -E_EOF)
  8009c6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009ca:	0f 84 ad 00 00 00    	je     800a7d <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8009d6:	68 8b 23 80 00       	push   $0x80238b
  8009db:	e8 0e f9 ff ff       	call   8002ee <cprintf>
  8009e0:	83 c4 10             	add    $0x10,%esp
			break;
  8009e3:	e9 95 00 00 00       	jmp    800a7d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009ec:	7e 34                	jle    800a22 <readline+0xa0>
  8009ee:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009f5:	7f 2b                	jg     800a22 <readline+0xa0>
			if (echoing)
  8009f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009fb:	74 0e                	je     800a0b <readline+0x89>
				cputchar(c);
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	ff 75 ec             	pushl  -0x14(%ebp)
  800a03:	e8 01 10 00 00       	call   801a09 <cputchar>
  800a08:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0e:	8d 50 01             	lea    0x1(%eax),%edx
  800a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a1e:	88 10                	mov    %dl,(%eax)
  800a20:	eb 56                	jmp    800a78 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a22:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a26:	75 1f                	jne    800a47 <readline+0xc5>
  800a28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a2c:	7e 19                	jle    800a47 <readline+0xc5>
			if (echoing)
  800a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a32:	74 0e                	je     800a42 <readline+0xc0>
				cputchar(c);
  800a34:	83 ec 0c             	sub    $0xc,%esp
  800a37:	ff 75 ec             	pushl  -0x14(%ebp)
  800a3a:	e8 ca 0f 00 00       	call   801a09 <cputchar>
  800a3f:	83 c4 10             	add    $0x10,%esp

			i--;
  800a42:	ff 4d f4             	decl   -0xc(%ebp)
  800a45:	eb 31                	jmp    800a78 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a47:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a4b:	74 0a                	je     800a57 <readline+0xd5>
  800a4d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a51:	0f 85 61 ff ff ff    	jne    8009b8 <readline+0x36>
			if (echoing)
  800a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a5b:	74 0e                	je     800a6b <readline+0xe9>
				cputchar(c);
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	ff 75 ec             	pushl  -0x14(%ebp)
  800a63:	e8 a1 0f 00 00       	call   801a09 <cputchar>
  800a68:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	01 d0                	add    %edx,%eax
  800a73:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a76:	eb 06                	jmp    800a7e <readline+0xfc>
		}
	}
  800a78:	e9 3b ff ff ff       	jmp    8009b8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a7d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a7e:	90                   	nop
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a87:	e8 71 08 00 00       	call   8012fd <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a90:	74 13                	je     800aa5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 08             	pushl  0x8(%ebp)
  800a98:	68 88 23 80 00       	push   $0x802388
  800a9d:	e8 4c f8 ff ff       	call   8002ee <cprintf>
  800aa2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800aac:	83 ec 0c             	sub    $0xc,%esp
  800aaf:	6a 00                	push   $0x0
  800ab1:	e8 85 0f 00 00       	call   801a3b <iscons>
  800ab6:	83 c4 10             	add    $0x10,%esp
  800ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800abc:	e8 67 0f 00 00       	call   801a28 <getchar>
  800ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ac8:	79 22                	jns    800aec <atomic_readline+0x6b>
				if (c != -E_EOF)
  800aca:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ace:	0f 84 ad 00 00 00    	je     800b81 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ad4:	83 ec 08             	sub    $0x8,%esp
  800ad7:	ff 75 ec             	pushl  -0x14(%ebp)
  800ada:	68 8b 23 80 00       	push   $0x80238b
  800adf:	e8 0a f8 ff ff       	call   8002ee <cprintf>
  800ae4:	83 c4 10             	add    $0x10,%esp
				break;
  800ae7:	e9 95 00 00 00       	jmp    800b81 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800aec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800af0:	7e 34                	jle    800b26 <atomic_readline+0xa5>
  800af2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800af9:	7f 2b                	jg     800b26 <atomic_readline+0xa5>
				if (echoing)
  800afb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aff:	74 0e                	je     800b0f <atomic_readline+0x8e>
					cputchar(c);
  800b01:	83 ec 0c             	sub    $0xc,%esp
  800b04:	ff 75 ec             	pushl  -0x14(%ebp)
  800b07:	e8 fd 0e 00 00       	call   801a09 <cputchar>
  800b0c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	01 d0                	add    %edx,%eax
  800b1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b22:	88 10                	mov    %dl,(%eax)
  800b24:	eb 56                	jmp    800b7c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b26:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b2a:	75 1f                	jne    800b4b <atomic_readline+0xca>
  800b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b30:	7e 19                	jle    800b4b <atomic_readline+0xca>
				if (echoing)
  800b32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b36:	74 0e                	je     800b46 <atomic_readline+0xc5>
					cputchar(c);
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3e:	e8 c6 0e 00 00       	call   801a09 <cputchar>
  800b43:	83 c4 10             	add    $0x10,%esp
				i--;
  800b46:	ff 4d f4             	decl   -0xc(%ebp)
  800b49:	eb 31                	jmp    800b7c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b4b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b4f:	74 0a                	je     800b5b <atomic_readline+0xda>
  800b51:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b55:	0f 85 61 ff ff ff    	jne    800abc <atomic_readline+0x3b>
				if (echoing)
  800b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b5f:	74 0e                	je     800b6f <atomic_readline+0xee>
					cputchar(c);
  800b61:	83 ec 0c             	sub    $0xc,%esp
  800b64:	ff 75 ec             	pushl  -0x14(%ebp)
  800b67:	e8 9d 0e 00 00       	call   801a09 <cputchar>
  800b6c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b7a:	eb 06                	jmp    800b82 <atomic_readline+0x101>
			}
		}
  800b7c:	e9 3b ff ff ff       	jmp    800abc <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b81:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b82:	e8 90 07 00 00       	call   801317 <sys_unlock_cons>
}
  800b87:	90                   	nop
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b97:	eb 06                	jmp    800b9f <strlen+0x15>
		n++;
  800b99:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9c:	ff 45 08             	incl   0x8(%ebp)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	75 f1                	jne    800b99 <strlen+0xf>
		n++;
	return n;
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 09                	jmp    800bc5 <strnlen+0x18>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	ff 4d 0c             	decl   0xc(%ebp)
  800bc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc9:	74 09                	je     800bd4 <strnlen+0x27>
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	84 c0                	test   %al,%al
  800bd2:	75 e8                	jne    800bbc <strnlen+0xf>
		n++;
	return n;
  800bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800be5:	90                   	nop
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8d 50 01             	lea    0x1(%eax),%edx
  800bec:	89 55 08             	mov    %edx,0x8(%ebp)
  800bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf8:	8a 12                	mov    (%edx),%dl
  800bfa:	88 10                	mov    %dl,(%eax)
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e4                	jne    800be6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1a:	eb 1f                	jmp    800c3b <strncpy+0x34>
		*dst++ = *src;
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8d 50 01             	lea    0x1(%eax),%edx
  800c22:	89 55 08             	mov    %edx,0x8(%ebp)
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	8a 12                	mov    (%edx),%dl
  800c2a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	84 c0                	test   %al,%al
  800c33:	74 03                	je     800c38 <strncpy+0x31>
			src++;
  800c35:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c38:	ff 45 fc             	incl   -0x4(%ebp)
  800c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c41:	72 d9                	jb     800c1c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c58:	74 30                	je     800c8a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c5a:	eb 16                	jmp    800c72 <strlcpy+0x2a>
			*dst++ = *src++;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8d 50 01             	lea    0x1(%eax),%edx
  800c62:	89 55 08             	mov    %edx,0x8(%ebp)
  800c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6e:	8a 12                	mov    (%edx),%dl
  800c70:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c72:	ff 4d 10             	decl   0x10(%ebp)
  800c75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c79:	74 09                	je     800c84 <strlcpy+0x3c>
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	84 c0                	test   %al,%al
  800c82:	75 d8                	jne    800c5c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c90:	29 c2                	sub    %eax,%edx
  800c92:	89 d0                	mov    %edx,%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c99:	eb 06                	jmp    800ca1 <strcmp+0xb>
		p++, q++;
  800c9b:	ff 45 08             	incl   0x8(%ebp)
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	84 c0                	test   %al,%al
  800ca8:	74 0e                	je     800cb8 <strcmp+0x22>
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 10                	mov    (%eax),%dl
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	38 c2                	cmp    %al,%dl
  800cb6:	74 e3                	je     800c9b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 d0             	movzbl %al,%edx
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	29 c2                	sub    %eax,%edx
  800cca:	89 d0                	mov    %edx,%eax
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd1:	eb 09                	jmp    800cdc <strncmp+0xe>
		n--, p++, q++;
  800cd3:	ff 4d 10             	decl   0x10(%ebp)
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce0:	74 17                	je     800cf9 <strncmp+0x2b>
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	74 0e                	je     800cf9 <strncmp+0x2b>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 10                	mov    (%eax),%dl
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	38 c2                	cmp    %al,%dl
  800cf7:	74 da                	je     800cd3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	75 07                	jne    800d06 <strncmp+0x38>
		return 0;
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
  800d04:	eb 14                	jmp    800d1a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 d0             	movzbl %al,%edx
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 c0             	movzbl %al,%eax
  800d16:	29 c2                	sub    %eax,%edx
  800d18:	89 d0                	mov    %edx,%eax
}
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 04             	sub    $0x4,%esp
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d28:	eb 12                	jmp    800d3c <strchr+0x20>
		if (*s == c)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d32:	75 05                	jne    800d39 <strchr+0x1d>
			return (char *) s;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	eb 11                	jmp    800d4a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d39:	ff 45 08             	incl   0x8(%ebp)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 e5                	jne    800d2a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 04             	sub    $0x4,%esp
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d58:	eb 0d                	jmp    800d67 <strfind+0x1b>
		if (*s == c)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d62:	74 0e                	je     800d72 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 ea                	jne    800d5a <strfind+0xe>
  800d70:	eb 01                	jmp    800d73 <strfind+0x27>
		if (*s == c)
			break;
  800d72:	90                   	nop
	return (char *) s;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d8a:	eb 0e                	jmp    800d9a <memset+0x22>
		*p++ = c;
  800d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8f:	8d 50 01             	lea    0x1(%eax),%edx
  800d92:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d98:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d9a:	ff 4d f8             	decl   -0x8(%ebp)
  800d9d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da1:	79 e9                	jns    800d8c <memset+0x14>
		*p++ = c;

	return v;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dba:	eb 16                	jmp    800dd2 <memcpy+0x2a>
		*d++ = *s++;
  800dbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dcb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dce:	8a 12                	mov    (%edx),%dl
  800dd0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	75 dd                	jne    800dbc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800df6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dfc:	73 50                	jae    800e4e <memmove+0x6a>
  800dfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	01 d0                	add    %edx,%eax
  800e06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e09:	76 43                	jbe    800e4e <memmove+0x6a>
		s += n;
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e17:	eb 10                	jmp    800e29 <memmove+0x45>
			*--d = *--s;
  800e19:	ff 4d f8             	decl   -0x8(%ebp)
  800e1c:	ff 4d fc             	decl   -0x4(%ebp)
  800e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e22:	8a 10                	mov    (%eax),%dl
  800e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e27:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	75 e3                	jne    800e19 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e36:	eb 23                	jmp    800e5b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3b:	8d 50 01             	lea    0x1(%eax),%edx
  800e3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e47:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4a:	8a 12                	mov    (%edx),%dl
  800e4c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e54:	89 55 10             	mov    %edx,0x10(%ebp)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	75 dd                	jne    800e38 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e72:	eb 2a                	jmp    800e9e <memcmp+0x3e>
		if (*s1 != *s2)
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	8a 10                	mov    (%eax),%dl
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	38 c2                	cmp    %al,%dl
  800e80:	74 16                	je     800e98 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f b6 d0             	movzbl %al,%edx
  800e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 c0             	movzbl %al,%eax
  800e92:	29 c2                	sub    %eax,%edx
  800e94:	89 d0                	mov    %edx,%eax
  800e96:	eb 18                	jmp    800eb0 <memcmp+0x50>
		s1++, s2++;
  800e98:	ff 45 fc             	incl   -0x4(%ebp)
  800e9b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	75 c9                	jne    800e74 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	01 d0                	add    %edx,%eax
  800ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec3:	eb 15                	jmp    800eda <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 d0             	movzbl %al,%edx
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	0f b6 c0             	movzbl %al,%eax
  800ed3:	39 c2                	cmp    %eax,%edx
  800ed5:	74 0d                	je     800ee4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed7:	ff 45 08             	incl   0x8(%ebp)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee0:	72 e3                	jb     800ec5 <memfind+0x13>
  800ee2:	eb 01                	jmp    800ee5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ee4:	90                   	nop
	return (void *) s;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ef7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efe:	eb 03                	jmp    800f03 <strtol+0x19>
		s++;
  800f00:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	3c 20                	cmp    $0x20,%al
  800f0a:	74 f4                	je     800f00 <strtol+0x16>
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	3c 09                	cmp    $0x9,%al
  800f13:	74 eb                	je     800f00 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 2b                	cmp    $0x2b,%al
  800f1c:	75 05                	jne    800f23 <strtol+0x39>
		s++;
  800f1e:	ff 45 08             	incl   0x8(%ebp)
  800f21:	eb 13                	jmp    800f36 <strtol+0x4c>
	else if (*s == '-')
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 2d                	cmp    $0x2d,%al
  800f2a:	75 0a                	jne    800f36 <strtol+0x4c>
		s++, neg = 1;
  800f2c:	ff 45 08             	incl   0x8(%ebp)
  800f2f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 06                	je     800f42 <strtol+0x58>
  800f3c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f40:	75 20                	jne    800f62 <strtol+0x78>
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 30                	cmp    $0x30,%al
  800f49:	75 17                	jne    800f62 <strtol+0x78>
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	40                   	inc    %eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 78                	cmp    $0x78,%al
  800f53:	75 0d                	jne    800f62 <strtol+0x78>
		s += 2, base = 16;
  800f55:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f59:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f60:	eb 28                	jmp    800f8a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f66:	75 15                	jne    800f7d <strtol+0x93>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 30                	cmp    $0x30,%al
  800f6f:	75 0c                	jne    800f7d <strtol+0x93>
		s++, base = 8;
  800f71:	ff 45 08             	incl   0x8(%ebp)
  800f74:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f7b:	eb 0d                	jmp    800f8a <strtol+0xa0>
	else if (base == 0)
  800f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f81:	75 07                	jne    800f8a <strtol+0xa0>
		base = 10;
  800f83:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	3c 2f                	cmp    $0x2f,%al
  800f91:	7e 19                	jle    800fac <strtol+0xc2>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 39                	cmp    $0x39,%al
  800f9a:	7f 10                	jg     800fac <strtol+0xc2>
			dig = *s - '0';
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be c0             	movsbl %al,%eax
  800fa4:	83 e8 30             	sub    $0x30,%eax
  800fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800faa:	eb 42                	jmp    800fee <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 60                	cmp    $0x60,%al
  800fb3:	7e 19                	jle    800fce <strtol+0xe4>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 7a                	cmp    $0x7a,%al
  800fbc:	7f 10                	jg     800fce <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f be c0             	movsbl %al,%eax
  800fc6:	83 e8 57             	sub    $0x57,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcc:	eb 20                	jmp    800fee <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 40                	cmp    $0x40,%al
  800fd5:	7e 39                	jle    801010 <strtol+0x126>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 5a                	cmp    $0x5a,%al
  800fde:	7f 30                	jg     801010 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f be c0             	movsbl %al,%eax
  800fe8:	83 e8 37             	sub    $0x37,%eax
  800feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ff4:	7d 19                	jge    80100f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffc:	0f af 45 10          	imul   0x10(%ebp),%eax
  801000:	89 c2                	mov    %eax,%edx
  801002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801005:	01 d0                	add    %edx,%eax
  801007:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80100a:	e9 7b ff ff ff       	jmp    800f8a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80100f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801010:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801014:	74 08                	je     80101e <strtol+0x134>
		*endptr = (char *) s;
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80101e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801022:	74 07                	je     80102b <strtol+0x141>
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	f7 d8                	neg    %eax
  801029:	eb 03                	jmp    80102e <strtol+0x144>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <ltostr>:

void
ltostr(long value, char *str)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801036:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80103d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801048:	79 13                	jns    80105d <ltostr+0x2d>
	{
		neg = 1;
  80104a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801057:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80105a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801065:	99                   	cltd   
  801066:	f7 f9                	idiv   %ecx
  801068:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106e:	8d 50 01             	lea    0x1(%eax),%edx
  801071:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801074:	89 c2                	mov    %eax,%edx
  801076:	8b 45 0c             	mov    0xc(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80107e:	83 c2 30             	add    $0x30,%edx
  801081:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801083:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801086:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108b:	f7 e9                	imul   %ecx
  80108d:	c1 fa 02             	sar    $0x2,%edx
  801090:	89 c8                	mov    %ecx,%eax
  801092:	c1 f8 1f             	sar    $0x1f,%eax
  801095:	29 c2                	sub    %eax,%edx
  801097:	89 d0                	mov    %edx,%eax
  801099:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80109c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a0:	75 bb                	jne    80105d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ac:	48                   	dec    %eax
  8010ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b4:	74 3d                	je     8010f3 <ltostr+0xc3>
		start = 1 ;
  8010b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010bd:	eb 34                	jmp    8010f3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	01 d0                	add    %edx,%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	01 c2                	add    %eax,%edx
  8010d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	01 c8                	add    %ecx,%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e6:	01 c2                	add    %eax,%edx
  8010e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8010ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f9:	7c c4                	jl     8010bf <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801106:	90                   	nop
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	e8 73 fa ff ff       	call   800b8a <strlen>
  801117:	83 c4 04             	add    $0x4,%esp
  80111a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	e8 65 fa ff ff       	call   800b8a <strlen>
  801125:	83 c4 04             	add    $0x4,%esp
  801128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80112b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801139:	eb 17                	jmp    801152 <strcconcat+0x49>
		final[s] = str1[s] ;
  80113b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	01 c8                	add    %ecx,%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80114f:	ff 45 fc             	incl   -0x4(%ebp)
  801152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801155:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801158:	7c e1                	jl     80113b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80115a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801168:	eb 1f                	jmp    801189 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8d 50 01             	lea    0x1(%eax),%edx
  801170:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801173:	89 c2                	mov    %eax,%edx
  801175:	8b 45 10             	mov    0x10(%ebp),%eax
  801178:	01 c2                	add    %eax,%edx
  80117a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	01 c8                	add    %ecx,%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801186:	ff 45 f8             	incl   -0x8(%ebp)
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118f:	7c d9                	jl     80116a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801191:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	c6 00 00             	movb   $0x0,(%eax)
}
  80119c:	90                   	nop
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c2:	eb 0c                	jmp    8011d0 <strsplit+0x31>
			*string++ = 0;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	84 c0                	test   %al,%al
  8011d7:	74 18                	je     8011f1 <strsplit+0x52>
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	0f be c0             	movsbl %al,%eax
  8011e1:	50                   	push   %eax
  8011e2:	ff 75 0c             	pushl  0xc(%ebp)
  8011e5:	e8 32 fb ff ff       	call   800d1c <strchr>
  8011ea:	83 c4 08             	add    $0x8,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	75 d3                	jne    8011c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	84 c0                	test   %al,%al
  8011f8:	74 5a                	je     801254 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fd:	8b 00                	mov    (%eax),%eax
  8011ff:	83 f8 0f             	cmp    $0xf,%eax
  801202:	75 07                	jne    80120b <strsplit+0x6c>
		{
			return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 66                	jmp    801271 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80120b:	8b 45 14             	mov    0x14(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	8d 48 01             	lea    0x1(%eax),%ecx
  801213:	8b 55 14             	mov    0x14(%ebp),%edx
  801216:	89 0a                	mov    %ecx,(%edx)
  801218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	01 c2                	add    %eax,%edx
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801229:	eb 03                	jmp    80122e <strsplit+0x8f>
			string++;
  80122b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	84 c0                	test   %al,%al
  801235:	74 8b                	je     8011c2 <strsplit+0x23>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	0f be c0             	movsbl %al,%eax
  80123f:	50                   	push   %eax
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	e8 d4 fa ff ff       	call   800d1c <strchr>
  801248:	83 c4 08             	add    $0x8,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	74 dc                	je     80122b <strsplit+0x8c>
			string++;
	}
  80124f:	e9 6e ff ff ff       	jmp    8011c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801254:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80126c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801271:	c9                   	leave  
  801272:	c3                   	ret    

00801273 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	68 9c 23 80 00       	push   $0x80239c
  801281:	68 3f 01 00 00       	push   $0x13f
  801286:	68 be 23 80 00       	push   $0x8023be
  80128b:	e8 b5 07 00 00       	call   801a45 <_panic>

00801290 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ab:	cd 30                	int    $0x30
  8012ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	52                   	push   %edx
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	50                   	push   %eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 b2 ff ff ff       	call   801290 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 02                	push   $0x2
  8012f3:	e8 98 ff ff ff       	call   801290 <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 03                	push   $0x3
  80130c:	e8 7f ff ff ff       	call   801290 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	90                   	nop
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 04                	push   $0x4
  801326:	e8 65 ff ff ff       	call   801290 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	90                   	nop
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801334:	8b 55 0c             	mov    0xc(%ebp),%edx
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	52                   	push   %edx
  801341:	50                   	push   %eax
  801342:	6a 08                	push   $0x8
  801344:	e8 47 ff ff ff       	call   801290 <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	56                   	push   %esi
  801352:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801353:	8b 75 18             	mov    0x18(%ebp),%esi
  801356:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801359:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	51                   	push   %ecx
  801365:	52                   	push   %edx
  801366:	50                   	push   %eax
  801367:	6a 09                	push   $0x9
  801369:	e8 22 ff ff ff       	call   801290 <syscall>
  80136e:	83 c4 18             	add    $0x18,%esp
}
  801371:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801374:	5b                   	pop    %ebx
  801375:	5e                   	pop    %esi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    

00801378 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80137b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	52                   	push   %edx
  801388:	50                   	push   %eax
  801389:	6a 0a                	push   $0xa
  80138b:	e8 00 ff ff ff       	call   801290 <syscall>
  801390:	83 c4 18             	add    $0x18,%esp
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	ff 75 0c             	pushl  0xc(%ebp)
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	6a 0b                	push   $0xb
  8013a6:	e8 e5 fe ff ff       	call   801290 <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 0c                	push   $0xc
  8013bf:	e8 cc fe ff ff       	call   801290 <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 0d                	push   $0xd
  8013d8:	e8 b3 fe ff ff       	call   801290 <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 0e                	push   $0xe
  8013f1:	e8 9a fe ff ff       	call   801290 <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 0f                	push   $0xf
  80140a:	e8 81 fe ff ff       	call   801290 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	ff 75 08             	pushl  0x8(%ebp)
  801422:	6a 10                	push   $0x10
  801424:	e8 67 fe ff ff       	call   801290 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 11                	push   $0x11
  80143d:	e8 4e fe ff ff       	call   801290 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	90                   	nop
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <sys_cputc>:

void
sys_cputc(const char c)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801454:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	50                   	push   %eax
  801461:	6a 01                	push   $0x1
  801463:	e8 28 fe ff ff       	call   801290 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	90                   	nop
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 14                	push   $0x14
  80147d:	e8 0e fe ff ff       	call   801290 <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	8b 45 10             	mov    0x10(%ebp),%eax
  801491:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801494:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801497:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	51                   	push   %ecx
  8014a1:	52                   	push   %edx
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	50                   	push   %eax
  8014a6:	6a 15                	push   $0x15
  8014a8:	e8 e3 fd ff ff       	call   801290 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	52                   	push   %edx
  8014c2:	50                   	push   %eax
  8014c3:	6a 16                	push   $0x16
  8014c5:	e8 c6 fd ff ff       	call   801290 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	51                   	push   %ecx
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	6a 17                	push   $0x17
  8014e4:	e8 a7 fd ff ff       	call   801290 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	52                   	push   %edx
  8014fe:	50                   	push   %eax
  8014ff:	6a 18                	push   $0x18
  801501:	e8 8a fd ff ff       	call   801290 <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	6a 00                	push   $0x0
  801513:	ff 75 14             	pushl  0x14(%ebp)
  801516:	ff 75 10             	pushl  0x10(%ebp)
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	50                   	push   %eax
  80151d:	6a 19                	push   $0x19
  80151f:	e8 6c fd ff ff       	call   801290 <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	50                   	push   %eax
  801538:	6a 1a                	push   $0x1a
  80153a:	e8 51 fd ff ff       	call   801290 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	50                   	push   %eax
  801554:	6a 1b                	push   $0x1b
  801556:	e8 35 fd ff ff       	call   801290 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 05                	push   $0x5
  80156f:	e8 1c fd ff ff       	call   801290 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 06                	push   $0x6
  801588:	e8 03 fd ff ff       	call   801290 <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 07                	push   $0x7
  8015a1:	e8 ea fc ff ff       	call   801290 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_exit_env>:


void sys_exit_env(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 1c                	push   $0x1c
  8015ba:	e8 d1 fc ff ff       	call   801290 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	90                   	nop
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ce:	8d 50 04             	lea    0x4(%eax),%edx
  8015d1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	52                   	push   %edx
  8015db:	50                   	push   %eax
  8015dc:	6a 1d                	push   $0x1d
  8015de:	e8 ad fc ff ff       	call   801290 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
	return result;
  8015e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ef:	89 01                	mov    %eax,(%ecx)
  8015f1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	c9                   	leave  
  8015f8:	c2 04 00             	ret    $0x4

008015fb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	ff 75 10             	pushl  0x10(%ebp)
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	6a 13                	push   $0x13
  80160d:	e8 7e fc ff ff       	call   801290 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
	return ;
  801615:	90                   	nop
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_rcr2>:
uint32 sys_rcr2()
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 1e                	push   $0x1e
  801627:	e8 64 fc ff ff       	call   801290 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80163d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	50                   	push   %eax
  80164a:	6a 1f                	push   $0x1f
  80164c:	e8 3f fc ff ff       	call   801290 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
	return ;
  801654:	90                   	nop
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <rsttst>:
void rsttst()
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 21                	push   $0x21
  801666:	e8 25 fc ff ff       	call   801290 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
	return ;
  80166e:	90                   	nop
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	8b 45 14             	mov    0x14(%ebp),%eax
  80167a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80167d:	8b 55 18             	mov    0x18(%ebp),%edx
  801680:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801684:	52                   	push   %edx
  801685:	50                   	push   %eax
  801686:	ff 75 10             	pushl  0x10(%ebp)
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	6a 20                	push   $0x20
  801691:	e8 fa fb ff ff       	call   801290 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
	return ;
  801699:	90                   	nop
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <chktst>:
void chktst(uint32 n)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	6a 22                	push   $0x22
  8016ac:	e8 df fb ff ff       	call   801290 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b4:	90                   	nop
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <inctst>:

void inctst()
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 23                	push   $0x23
  8016c6:	e8 c5 fb ff ff       	call   801290 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ce:	90                   	nop
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <gettst>:
uint32 gettst()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 24                	push   $0x24
  8016e0:	e8 ab fb ff ff       	call   801290 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 25                	push   $0x25
  8016fc:	e8 8f fb ff ff       	call   801290 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
  801704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801707:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80170b:	75 07                	jne    801714 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80170d:	b8 01 00 00 00       	mov    $0x1,%eax
  801712:	eb 05                	jmp    801719 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 25                	push   $0x25
  80172d:	e8 5e fb ff ff       	call   801290 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
  801735:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801738:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80173c:	75 07                	jne    801745 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80173e:	b8 01 00 00 00       	mov    $0x1,%eax
  801743:	eb 05                	jmp    80174a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 25                	push   $0x25
  80175e:	e8 2d fb ff ff       	call   801290 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
  801766:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801769:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80176d:	75 07                	jne    801776 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80176f:	b8 01 00 00 00       	mov    $0x1,%eax
  801774:	eb 05                	jmp    80177b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 25                	push   $0x25
  80178f:	e8 fc fa ff ff       	call   801290 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
  801797:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80179a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80179e:	75 07                	jne    8017a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a5:	eb 05                	jmp    8017ac <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 26                	push   $0x26
  8017be:	e8 cd fa ff ff       	call   801290 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c6:	90                   	nop
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	6a 00                	push   $0x0
  8017db:	53                   	push   %ebx
  8017dc:	51                   	push   %ecx
  8017dd:	52                   	push   %edx
  8017de:	50                   	push   %eax
  8017df:	6a 27                	push   $0x27
  8017e1:	e8 aa fa ff ff       	call   801290 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	6a 28                	push   $0x28
  801801:	e8 8a fa ff ff       	call   801290 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80180e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	51                   	push   %ecx
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	6a 29                	push   $0x29
  801821:	e8 6a fa ff ff       	call   801290 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	6a 12                	push   $0x12
  80183d:	e8 4e fa ff ff       	call   801290 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
	return ;
  801845:	90                   	nop
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 2a                	push   $0x2a
  80185b:	e8 30 fa ff ff       	call   801290 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	50                   	push   %eax
  801875:	6a 2b                	push   $0x2b
  801877:	e8 14 fa ff ff       	call   801290 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 2c                	push   $0x2c
  801892:	e8 f9 f9 ff ff       	call   801290 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	6a 2d                	push   $0x2d
  8018ae:	e8 dd f9 ff ff       	call   801290 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
	return;
  8018b6:	90                   	nop
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 2e                	push   $0x2e
  8018cb:	e8 c0 f9 ff ff       	call   801290 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
  8018d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8018d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	50                   	push   %eax
  8018ea:	6a 2f                	push   $0x2f
  8018ec:	e8 9f f9 ff ff       	call   801290 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	6a 30                	push   $0x30
  80190a:	e8 81 f9 ff ff       	call   801290 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
	return;
  801912:	90                   	nop
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	50                   	push   %eax
  801927:	6a 31                	push   $0x31
  801929:	e8 62 f9 ff ff       	call   801290 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
  801931:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801934:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	50                   	push   %eax
  801948:	6a 32                	push   $0x32
  80194a:	e8 41 f9 ff ff       	call   801290 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80195b:	8b 55 08             	mov    0x8(%ebp),%edx
  80195e:	89 d0                	mov    %edx,%eax
  801960:	c1 e0 02             	shl    $0x2,%eax
  801963:	01 d0                	add    %edx,%eax
  801965:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196c:	01 d0                	add    %edx,%eax
  80196e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801975:	01 d0                	add    %edx,%eax
  801977:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197e:	01 d0                	add    %edx,%eax
  801980:	c1 e0 04             	shl    $0x4,%eax
  801983:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801986:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80198d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	50                   	push   %eax
  801994:	e8 2c fc ff ff       	call   8015c5 <sys_get_virtual_time>
  801999:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80199c:	eb 41                	jmp    8019df <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80199e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	50                   	push   %eax
  8019a5:	e8 1b fc ff ff       	call   8015c5 <sys_get_virtual_time>
  8019aa:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8019ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b3:	29 c2                	sub    %eax,%edx
  8019b5:	89 d0                	mov    %edx,%eax
  8019b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8019ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c0:	89 d1                	mov    %edx,%ecx
  8019c2:	29 c1                	sub    %eax,%ecx
  8019c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ca:	39 c2                	cmp    %eax,%edx
  8019cc:	0f 97 c0             	seta   %al
  8019cf:	0f b6 c0             	movzbl %al,%eax
  8019d2:	29 c1                	sub    %eax,%ecx
  8019d4:	89 c8                	mov    %ecx,%eax
  8019d6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019e5:	72 b7                	jb     80199e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019f7:	eb 03                	jmp    8019fc <busy_wait+0x12>
  8019f9:	ff 45 fc             	incl   -0x4(%ebp)
  8019fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  801a02:	72 f5                	jb     8019f9 <busy_wait+0xf>
	return i;
  801a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a15:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	50                   	push   %eax
  801a1d:	e8 26 fa ff ff       	call   801448 <sys_cputc>
  801a22:	83 c4 10             	add    $0x10,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <getchar>:


int
getchar(void)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a2e:	e8 b1 f8 ff ff       	call   8012e4 <sys_cgetc>
  801a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <iscons>:

int iscons(int fdnum)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    

00801a45 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a4b:	8d 45 10             	lea    0x10(%ebp),%eax
  801a4e:	83 c0 04             	add    $0x4,%eax
  801a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a54:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	74 16                	je     801a73 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a5d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	50                   	push   %eax
  801a66:	68 cc 23 80 00       	push   $0x8023cc
  801a6b:	e8 7e e8 ff ff       	call   8002ee <cprintf>
  801a70:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a73:	a1 00 30 80 00       	mov    0x803000,%eax
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	50                   	push   %eax
  801a7f:	68 d1 23 80 00       	push   $0x8023d1
  801a84:	e8 65 e8 ff ff       	call   8002ee <cprintf>
  801a89:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 f4             	pushl  -0xc(%ebp)
  801a95:	50                   	push   %eax
  801a96:	e8 e8 e7 ff ff       	call   800283 <vcprintf>
  801a9b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a9e:	83 ec 08             	sub    $0x8,%esp
  801aa1:	6a 00                	push   $0x0
  801aa3:	68 ed 23 80 00       	push   $0x8023ed
  801aa8:	e8 d6 e7 ff ff       	call   800283 <vcprintf>
  801aad:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ab0:	e8 57 e7 ff ff       	call   80020c <exit>

	// should not return here
	while (1) ;
  801ab5:	eb fe                	jmp    801ab5 <_panic+0x70>

00801ab7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801abd:	a1 04 30 80 00       	mov    0x803004,%eax
  801ac2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acb:	39 c2                	cmp    %eax,%edx
  801acd:	74 14                	je     801ae3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	68 f0 23 80 00       	push   $0x8023f0
  801ad7:	6a 26                	push   $0x26
  801ad9:	68 3c 24 80 00       	push   $0x80243c
  801ade:	e8 62 ff ff ff       	call   801a45 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ae3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801aea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801af1:	e9 c5 00 00 00       	jmp    801bbb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	01 d0                	add    %edx,%eax
  801b05:	8b 00                	mov    (%eax),%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	75 08                	jne    801b13 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b0b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b0e:	e9 a5 00 00 00       	jmp    801bb8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b13:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b21:	eb 69                	jmp    801b8c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b23:	a1 04 30 80 00       	mov    0x803004,%eax
  801b28:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801b2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b31:	89 d0                	mov    %edx,%eax
  801b33:	01 c0                	add    %eax,%eax
  801b35:	01 d0                	add    %edx,%eax
  801b37:	c1 e0 03             	shl    $0x3,%eax
  801b3a:	01 c8                	add    %ecx,%eax
  801b3c:	8a 40 04             	mov    0x4(%eax),%al
  801b3f:	84 c0                	test   %al,%al
  801b41:	75 46                	jne    801b89 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b43:	a1 04 30 80 00       	mov    0x803004,%eax
  801b48:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801b4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b51:	89 d0                	mov    %edx,%eax
  801b53:	01 c0                	add    %eax,%eax
  801b55:	01 d0                	add    %edx,%eax
  801b57:	c1 e0 03             	shl    $0x3,%eax
  801b5a:	01 c8                	add    %ecx,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b69:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	01 c8                	add    %ecx,%eax
  801b7a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b7c:	39 c2                	cmp    %eax,%edx
  801b7e:	75 09                	jne    801b89 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b80:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b87:	eb 15                	jmp    801b9e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b89:	ff 45 e8             	incl   -0x18(%ebp)
  801b8c:	a1 04 30 80 00       	mov    0x803004,%eax
  801b91:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b9a:	39 c2                	cmp    %eax,%edx
  801b9c:	77 85                	ja     801b23 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ba2:	75 14                	jne    801bb8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	68 48 24 80 00       	push   $0x802448
  801bac:	6a 3a                	push   $0x3a
  801bae:	68 3c 24 80 00       	push   $0x80243c
  801bb3:	e8 8d fe ff ff       	call   801a45 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bb8:	ff 45 f0             	incl   -0x10(%ebp)
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bc1:	0f 8c 2f ff ff ff    	jl     801af6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bd5:	eb 26                	jmp    801bfd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bd7:	a1 04 30 80 00       	mov    0x803004,%eax
  801bdc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801be2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	01 c0                	add    %eax,%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c1 e0 03             	shl    $0x3,%eax
  801bee:	01 c8                	add    %ecx,%eax
  801bf0:	8a 40 04             	mov    0x4(%eax),%al
  801bf3:	3c 01                	cmp    $0x1,%al
  801bf5:	75 03                	jne    801bfa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bf7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bfa:	ff 45 e0             	incl   -0x20(%ebp)
  801bfd:	a1 04 30 80 00       	mov    0x803004,%eax
  801c02:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0b:	39 c2                	cmp    %eax,%edx
  801c0d:	77 c8                	ja     801bd7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c15:	74 14                	je     801c2b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	68 9c 24 80 00       	push   $0x80249c
  801c1f:	6a 44                	push   $0x44
  801c21:	68 3c 24 80 00       	push   $0x80243c
  801c26:	e8 1a fe ff ff       	call   801a45 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c2b:	90                   	nop
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <__udivdi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c47:	89 ca                	mov    %ecx,%edx
  801c49:	89 f8                	mov    %edi,%eax
  801c4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c4f:	85 f6                	test   %esi,%esi
  801c51:	75 2d                	jne    801c80 <__udivdi3+0x50>
  801c53:	39 cf                	cmp    %ecx,%edi
  801c55:	77 65                	ja     801cbc <__udivdi3+0x8c>
  801c57:	89 fd                	mov    %edi,%ebp
  801c59:	85 ff                	test   %edi,%edi
  801c5b:	75 0b                	jne    801c68 <__udivdi3+0x38>
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	31 d2                	xor    %edx,%edx
  801c64:	f7 f7                	div    %edi
  801c66:	89 c5                	mov    %eax,%ebp
  801c68:	31 d2                	xor    %edx,%edx
  801c6a:	89 c8                	mov    %ecx,%eax
  801c6c:	f7 f5                	div    %ebp
  801c6e:	89 c1                	mov    %eax,%ecx
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	f7 f5                	div    %ebp
  801c74:	89 cf                	mov    %ecx,%edi
  801c76:	89 fa                	mov    %edi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	39 ce                	cmp    %ecx,%esi
  801c82:	77 28                	ja     801cac <__udivdi3+0x7c>
  801c84:	0f bd fe             	bsr    %esi,%edi
  801c87:	83 f7 1f             	xor    $0x1f,%edi
  801c8a:	75 40                	jne    801ccc <__udivdi3+0x9c>
  801c8c:	39 ce                	cmp    %ecx,%esi
  801c8e:	72 0a                	jb     801c9a <__udivdi3+0x6a>
  801c90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c94:	0f 87 9e 00 00 00    	ja     801d38 <__udivdi3+0x108>
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	89 fa                	mov    %edi,%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d 76 00             	lea    0x0(%esi),%esi
  801cac:	31 ff                	xor    %edi,%edi
  801cae:	31 c0                	xor    %eax,%eax
  801cb0:	89 fa                	mov    %edi,%edx
  801cb2:	83 c4 1c             	add    $0x1c,%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	89 d8                	mov    %ebx,%eax
  801cbe:	f7 f7                	div    %edi
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	89 fa                	mov    %edi,%edx
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
  801ccc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cd1:	89 eb                	mov    %ebp,%ebx
  801cd3:	29 fb                	sub    %edi,%ebx
  801cd5:	89 f9                	mov    %edi,%ecx
  801cd7:	d3 e6                	shl    %cl,%esi
  801cd9:	89 c5                	mov    %eax,%ebp
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 ed                	shr    %cl,%ebp
  801cdf:	89 e9                	mov    %ebp,%ecx
  801ce1:	09 f1                	or     %esi,%ecx
  801ce3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ce7:	89 f9                	mov    %edi,%ecx
  801ce9:	d3 e0                	shl    %cl,%eax
  801ceb:	89 c5                	mov    %eax,%ebp
  801ced:	89 d6                	mov    %edx,%esi
  801cef:	88 d9                	mov    %bl,%cl
  801cf1:	d3 ee                	shr    %cl,%esi
  801cf3:	89 f9                	mov    %edi,%ecx
  801cf5:	d3 e2                	shl    %cl,%edx
  801cf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cfb:	88 d9                	mov    %bl,%cl
  801cfd:	d3 e8                	shr    %cl,%eax
  801cff:	09 c2                	or     %eax,%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	89 f2                	mov    %esi,%edx
  801d05:	f7 74 24 0c          	divl   0xc(%esp)
  801d09:	89 d6                	mov    %edx,%esi
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	f7 e5                	mul    %ebp
  801d0f:	39 d6                	cmp    %edx,%esi
  801d11:	72 19                	jb     801d2c <__udivdi3+0xfc>
  801d13:	74 0b                	je     801d20 <__udivdi3+0xf0>
  801d15:	89 d8                	mov    %ebx,%eax
  801d17:	31 ff                	xor    %edi,%edi
  801d19:	e9 58 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d24:	89 f9                	mov    %edi,%ecx
  801d26:	d3 e2                	shl    %cl,%edx
  801d28:	39 c2                	cmp    %eax,%edx
  801d2a:	73 e9                	jae    801d15 <__udivdi3+0xe5>
  801d2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d2f:	31 ff                	xor    %edi,%edi
  801d31:	e9 40 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	31 c0                	xor    %eax,%eax
  801d3a:	e9 37 ff ff ff       	jmp    801c76 <__udivdi3+0x46>
  801d3f:	90                   	nop

00801d40 <__umoddi3>:
  801d40:	55                   	push   %ebp
  801d41:	57                   	push   %edi
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
  801d47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d5f:	89 f3                	mov    %esi,%ebx
  801d61:	89 fa                	mov    %edi,%edx
  801d63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d67:	89 34 24             	mov    %esi,(%esp)
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	75 1a                	jne    801d88 <__umoddi3+0x48>
  801d6e:	39 f7                	cmp    %esi,%edi
  801d70:	0f 86 a2 00 00 00    	jbe    801e18 <__umoddi3+0xd8>
  801d76:	89 c8                	mov    %ecx,%eax
  801d78:	89 f2                	mov    %esi,%edx
  801d7a:	f7 f7                	div    %edi
  801d7c:	89 d0                	mov    %edx,%eax
  801d7e:	31 d2                	xor    %edx,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	39 f0                	cmp    %esi,%eax
  801d8a:	0f 87 ac 00 00 00    	ja     801e3c <__umoddi3+0xfc>
  801d90:	0f bd e8             	bsr    %eax,%ebp
  801d93:	83 f5 1f             	xor    $0x1f,%ebp
  801d96:	0f 84 ac 00 00 00    	je     801e48 <__umoddi3+0x108>
  801d9c:	bf 20 00 00 00       	mov    $0x20,%edi
  801da1:	29 ef                	sub    %ebp,%edi
  801da3:	89 fe                	mov    %edi,%esi
  801da5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801da9:	89 e9                	mov    %ebp,%ecx
  801dab:	d3 e0                	shl    %cl,%eax
  801dad:	89 d7                	mov    %edx,%edi
  801daf:	89 f1                	mov    %esi,%ecx
  801db1:	d3 ef                	shr    %cl,%edi
  801db3:	09 c7                	or     %eax,%edi
  801db5:	89 e9                	mov    %ebp,%ecx
  801db7:	d3 e2                	shl    %cl,%edx
  801db9:	89 14 24             	mov    %edx,(%esp)
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	d3 e0                	shl    %cl,%eax
  801dc0:	89 c2                	mov    %eax,%edx
  801dc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dc6:	d3 e0                	shl    %cl,%eax
  801dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd0:	89 f1                	mov    %esi,%ecx
  801dd2:	d3 e8                	shr    %cl,%eax
  801dd4:	09 d0                	or     %edx,%eax
  801dd6:	d3 eb                	shr    %cl,%ebx
  801dd8:	89 da                	mov    %ebx,%edx
  801dda:	f7 f7                	div    %edi
  801ddc:	89 d3                	mov    %edx,%ebx
  801dde:	f7 24 24             	mull   (%esp)
  801de1:	89 c6                	mov    %eax,%esi
  801de3:	89 d1                	mov    %edx,%ecx
  801de5:	39 d3                	cmp    %edx,%ebx
  801de7:	0f 82 87 00 00 00    	jb     801e74 <__umoddi3+0x134>
  801ded:	0f 84 91 00 00 00    	je     801e84 <__umoddi3+0x144>
  801df3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801df7:	29 f2                	sub    %esi,%edx
  801df9:	19 cb                	sbb    %ecx,%ebx
  801dfb:	89 d8                	mov    %ebx,%eax
  801dfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e01:	d3 e0                	shl    %cl,%eax
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 ea                	shr    %cl,%edx
  801e07:	09 d0                	or     %edx,%eax
  801e09:	89 e9                	mov    %ebp,%ecx
  801e0b:	d3 eb                	shr    %cl,%ebx
  801e0d:	89 da                	mov    %ebx,%edx
  801e0f:	83 c4 1c             	add    $0x1c,%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5f                   	pop    %edi
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    
  801e17:	90                   	nop
  801e18:	89 fd                	mov    %edi,%ebp
  801e1a:	85 ff                	test   %edi,%edi
  801e1c:	75 0b                	jne    801e29 <__umoddi3+0xe9>
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	31 d2                	xor    %edx,%edx
  801e25:	f7 f7                	div    %edi
  801e27:	89 c5                	mov    %eax,%ebp
  801e29:	89 f0                	mov    %esi,%eax
  801e2b:	31 d2                	xor    %edx,%edx
  801e2d:	f7 f5                	div    %ebp
  801e2f:	89 c8                	mov    %ecx,%eax
  801e31:	f7 f5                	div    %ebp
  801e33:	89 d0                	mov    %edx,%eax
  801e35:	e9 44 ff ff ff       	jmp    801d7e <__umoddi3+0x3e>
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	89 c8                	mov    %ecx,%eax
  801e3e:	89 f2                	mov    %esi,%edx
  801e40:	83 c4 1c             	add    $0x1c,%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
  801e48:	3b 04 24             	cmp    (%esp),%eax
  801e4b:	72 06                	jb     801e53 <__umoddi3+0x113>
  801e4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e51:	77 0f                	ja     801e62 <__umoddi3+0x122>
  801e53:	89 f2                	mov    %esi,%edx
  801e55:	29 f9                	sub    %edi,%ecx
  801e57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e5b:	89 14 24             	mov    %edx,(%esp)
  801e5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e62:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e66:	8b 14 24             	mov    (%esp),%edx
  801e69:	83 c4 1c             	add    $0x1c,%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    
  801e71:	8d 76 00             	lea    0x0(%esi),%esi
  801e74:	2b 04 24             	sub    (%esp),%eax
  801e77:	19 fa                	sbb    %edi,%edx
  801e79:	89 d1                	mov    %edx,%ecx
  801e7b:	89 c6                	mov    %eax,%esi
  801e7d:	e9 71 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e88:	72 ea                	jb     801e74 <__umoddi3+0x134>
  801e8a:	89 d9                	mov    %ebx,%ecx
  801e8c:	e9 62 ff ff ff       	jmp    801df3 <__umoddi3+0xb3>
