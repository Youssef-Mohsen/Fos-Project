
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 be 00 00 00       	call   8000f4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 80 1d 80 00       	push   $0x801d80
  800057:	e8 4c 0a 00 00       	call   800aa8 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 9f 0e 00 00       	call   800f11 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("Factorial %d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 97 1d 80 00       	push   $0x801d97
  80009a:	e8 a3 02 00 00       	call   800342 <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <factorial>:


int64 factorial(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 0c             	sub    $0xc,%esp
	if (n <= 1)
  8000ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000b2:	7f 0c                	jg     8000c0 <factorial+0x1b>
		return 1 ;
  8000b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	eb 2c                	jmp    8000ec <factorial+0x47>
	return n * factorial(n-1) ;
  8000c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	c1 fe 1f             	sar    $0x1f,%esi
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cd:	48                   	dec    %eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 ce ff ff ff       	call   8000a5 <factorial>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 f7                	mov    %esi,%edi
  8000dc:	0f af f8             	imul   %eax,%edi
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	0f af cb             	imul   %ebx,%ecx
  8000e4:	01 f9                	add    %edi,%ecx
  8000e6:	f7 e3                	mul    %ebx
  8000e8:	01 d1                	add    %edx,%ecx
  8000ea:	89 ca                	mov    %ecx,%edx
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000fa:	e8 a1 14 00 00       	call   8015a0 <sys_getenvindex>
  8000ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	c1 e0 06             	shl    $0x6,%eax
  80010a:	29 d0                	sub    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800118:	01 c8                	add    %ecx,%eax
  80011a:	c1 e0 03             	shl    $0x3,%eax
  80011d:	01 d0                	add    %edx,%eax
  80011f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800126:	29 c2                	sub    %eax,%edx
  800128:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80012f:	89 c2                	mov    %eax,%edx
  800131:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800137:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80013c:	a1 04 30 80 00       	mov    0x803004,%eax
  800141:	8a 40 20             	mov    0x20(%eax),%al
  800144:	84 c0                	test   %al,%al
  800146:	74 0d                	je     800155 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800148:	a1 04 30 80 00       	mov    0x803004,%eax
  80014d:	83 c0 20             	add    $0x20,%eax
  800150:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800159:	7e 0a                	jle    800165 <libmain+0x71>
		binaryname = argv[0];
  80015b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	ff 75 0c             	pushl  0xc(%ebp)
  80016b:	ff 75 08             	pushl  0x8(%ebp)
  80016e:	e8 c5 fe ff ff       	call   800038 <_main>
  800173:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800176:	e8 a9 11 00 00       	call   801324 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	68 c4 1d 80 00       	push   $0x801dc4
  800183:	e8 8d 01 00 00       	call   800315 <cprintf>
  800188:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80018b:	a1 04 30 80 00       	mov    0x803004,%eax
  800190:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800196:	a1 04 30 80 00       	mov    0x803004,%eax
  80019b:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	52                   	push   %edx
  8001a5:	50                   	push   %eax
  8001a6:	68 ec 1d 80 00       	push   $0x801dec
  8001ab:	e8 65 01 00 00       	call   800315 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b8:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001be:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c3:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001c9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ce:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001d4:	51                   	push   %ecx
  8001d5:	52                   	push   %edx
  8001d6:	50                   	push   %eax
  8001d7:	68 14 1e 80 00       	push   $0x801e14
  8001dc:	e8 34 01 00 00       	call   800315 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e9:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	68 6c 1e 80 00       	push   $0x801e6c
  8001f8:	e8 18 01 00 00       	call   800315 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	68 c4 1d 80 00       	push   $0x801dc4
  800208:	e8 08 01 00 00       	call   800315 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800210:	e8 29 11 00 00       	call   80133e <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800215:	e8 19 00 00 00       	call   800233 <exit>
}
  80021a:	90                   	nop
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 3f 13 00 00       	call   80156c <sys_destroy_env>
  80022d:	83 c4 10             	add    $0x10,%esp
}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <exit>:

void
exit(void)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800239:	e8 94 13 00 00       	call   8015d2 <sys_exit_env>
}
  80023e:	90                   	nop
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	8d 48 01             	lea    0x1(%eax),%ecx
  80024f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800252:	89 0a                	mov    %ecx,(%edx)
  800254:	8b 55 08             	mov    0x8(%ebp),%edx
  800257:	88 d1                	mov    %dl,%cl
  800259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	8b 00                	mov    (%eax),%eax
  800265:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026a:	75 2c                	jne    800298 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80026c:	a0 08 30 80 00       	mov    0x803008,%al
  800271:	0f b6 c0             	movzbl %al,%eax
  800274:	8b 55 0c             	mov    0xc(%ebp),%edx
  800277:	8b 12                	mov    (%edx),%edx
  800279:	89 d1                	mov    %edx,%ecx
  80027b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027e:	83 c2 08             	add    $0x8,%edx
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	50                   	push   %eax
  800285:	51                   	push   %ecx
  800286:	52                   	push   %edx
  800287:	e8 56 10 00 00       	call   8012e2 <sys_cputs>
  80028c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80028f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800292:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 40 04             	mov    0x4(%eax),%eax
  80029e:	8d 50 01             	lea    0x1(%eax),%edx
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ba:	00 00 00 
	b.cnt = 0;
  8002bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002c7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ca:	ff 75 08             	pushl  0x8(%ebp)
  8002cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	68 41 02 80 00       	push   $0x800241
  8002d9:	e8 11 02 00 00       	call   8004ef <vprintfmt>
  8002de:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002e1:	a0 08 30 80 00       	mov    0x803008,%al
  8002e6:	0f b6 c0             	movzbl %al,%eax
  8002e9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002ef:	83 ec 04             	sub    $0x4,%esp
  8002f2:	50                   	push   %eax
  8002f3:	52                   	push   %edx
  8002f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fa:	83 c0 08             	add    $0x8,%eax
  8002fd:	50                   	push   %eax
  8002fe:	e8 df 0f 00 00       	call   8012e2 <sys_cputs>
  800303:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800306:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80030d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80031b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800322:	8d 45 0c             	lea    0xc(%ebp),%eax
  800325:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 75 f4             	pushl  -0xc(%ebp)
  800331:	50                   	push   %eax
  800332:	e8 73 ff ff ff       	call   8002aa <vcprintf>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80033d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800348:	e8 d7 0f 00 00       	call   801324 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80034d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800350:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	ff 75 f4             	pushl  -0xc(%ebp)
  80035c:	50                   	push   %eax
  80035d:	e8 48 ff ff ff       	call   8002aa <vcprintf>
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800368:	e8 d1 0f 00 00       	call   80133e <sys_unlock_cons>
	return cnt;
  80036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	53                   	push   %ebx
  800376:	83 ec 14             	sub    $0x14,%esp
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	ba 00 00 00 00       	mov    $0x0,%edx
  80038d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800390:	77 55                	ja     8003e7 <printnum+0x75>
  800392:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800395:	72 05                	jb     80039c <printnum+0x2a>
  800397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80039a:	77 4b                	ja     8003e7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80039c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80039f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	52                   	push   %edx
  8003ab:	50                   	push   %eax
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 f0             	pushl  -0x10(%ebp)
  8003b2:	e8 55 17 00 00       	call   801b0c <__udivdi3>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	ff 75 20             	pushl  0x20(%ebp)
  8003c0:	53                   	push   %ebx
  8003c1:	ff 75 18             	pushl  0x18(%ebp)
  8003c4:	52                   	push   %edx
  8003c5:	50                   	push   %eax
  8003c6:	ff 75 0c             	pushl  0xc(%ebp)
  8003c9:	ff 75 08             	pushl  0x8(%ebp)
  8003cc:	e8 a1 ff ff ff       	call   800372 <printnum>
  8003d1:	83 c4 20             	add    $0x20,%esp
  8003d4:	eb 1a                	jmp    8003f0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	ff 75 0c             	pushl  0xc(%ebp)
  8003dc:	ff 75 20             	pushl  0x20(%ebp)
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	ff d0                	call   *%eax
  8003e4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e7:	ff 4d 1c             	decl   0x1c(%ebp)
  8003ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003ee:	7f e6                	jg     8003d6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003f0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003fe:	53                   	push   %ebx
  8003ff:	51                   	push   %ecx
  800400:	52                   	push   %edx
  800401:	50                   	push   %eax
  800402:	e8 15 18 00 00       	call   801c1c <__umoddi3>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	05 94 20 80 00       	add    $0x802094,%eax
  80040f:	8a 00                	mov    (%eax),%al
  800411:	0f be c0             	movsbl %al,%eax
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 0c             	pushl  0xc(%ebp)
  80041a:	50                   	push   %eax
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
}
  800423:	90                   	nop
  800424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80042c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800430:	7e 1c                	jle    80044e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	8d 50 08             	lea    0x8(%eax),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	89 10                	mov    %edx,(%eax)
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	83 e8 08             	sub    $0x8,%eax
  800447:	8b 50 04             	mov    0x4(%eax),%edx
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	eb 40                	jmp    80048e <getuint+0x65>
	else if (lflag)
  80044e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800452:	74 1e                	je     800472 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	8d 50 04             	lea    0x4(%eax),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	89 10                	mov    %edx,(%eax)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	83 e8 04             	sub    $0x4,%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	ba 00 00 00 00       	mov    $0x0,%edx
  800470:	eb 1c                	jmp    80048e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	8d 50 04             	lea    0x4(%eax),%edx
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 10                	mov    %edx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	83 e8 04             	sub    $0x4,%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    

00800490 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getint+0x25>
		return va_arg(*ap, long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 38                	jmp    8004ed <getint+0x5d>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1a                	je     8004d5 <getint+0x45>
		return va_arg(*ap, long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	99                   	cltd   
  8004d3:	eb 18                	jmp    8004ed <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 04             	sub    $0x4,%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	99                   	cltd   
}
  8004ed:	5d                   	pop    %ebp
  8004ee:	c3                   	ret    

008004ef <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	56                   	push   %esi
  8004f3:	53                   	push   %ebx
  8004f4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f7:	eb 17                	jmp    800510 <vprintfmt+0x21>
			if (ch == '\0')
  8004f9:	85 db                	test   %ebx,%ebx
  8004fb:	0f 84 c1 03 00 00    	je     8008c2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	ff 75 0c             	pushl  0xc(%ebp)
  800507:	53                   	push   %ebx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	ff d0                	call   *%eax
  80050d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800510:	8b 45 10             	mov    0x10(%ebp),%eax
  800513:	8d 50 01             	lea    0x1(%eax),%edx
  800516:	89 55 10             	mov    %edx,0x10(%ebp)
  800519:	8a 00                	mov    (%eax),%al
  80051b:	0f b6 d8             	movzbl %al,%ebx
  80051e:	83 fb 25             	cmp    $0x25,%ebx
  800521:	75 d6                	jne    8004f9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800523:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800527:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80052e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800535:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80053c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800554:	83 f8 5b             	cmp    $0x5b,%eax
  800557:	0f 87 3d 03 00 00    	ja     80089a <vprintfmt+0x3ab>
  80055d:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  800564:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800566:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80056a:	eb d7                	jmp    800543 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80056c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800570:	eb d1                	jmp    800543 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800572:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800579:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80057c:	89 d0                	mov    %edx,%eax
  80057e:	c1 e0 02             	shl    $0x2,%eax
  800581:	01 d0                	add    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d8                	add    %ebx,%eax
  800587:	83 e8 30             	sub    $0x30,%eax
  80058a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80058d:	8b 45 10             	mov    0x10(%ebp),%eax
  800590:	8a 00                	mov    (%eax),%al
  800592:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800595:	83 fb 2f             	cmp    $0x2f,%ebx
  800598:	7e 3e                	jle    8005d8 <vprintfmt+0xe9>
  80059a:	83 fb 39             	cmp    $0x39,%ebx
  80059d:	7f 39                	jg     8005d8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80059f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005a2:	eb d5                	jmp    800579 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	83 c0 04             	add    $0x4,%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	83 e8 04             	sub    $0x4,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005b8:	eb 1f                	jmp    8005d9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005be:	79 83                	jns    800543 <vprintfmt+0x54>
				width = 0;
  8005c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005c7:	e9 77 ff ff ff       	jmp    800543 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005cc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005d3:	e9 6b ff ff ff       	jmp    800543 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005d8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005dd:	0f 89 60 ff ff ff    	jns    800543 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005f0:	e9 4e ff ff ff       	jmp    800543 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005f8:	e9 46 ff ff ff       	jmp    800543 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	83 c0 04             	add    $0x4,%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	83 e8 04             	sub    $0x4,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
			break;
  80061d:	e9 9b 02 00 00       	jmp    8008bd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 c0 04             	add    $0x4,%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 e8 04             	sub    $0x4,%eax
  800631:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800633:	85 db                	test   %ebx,%ebx
  800635:	79 02                	jns    800639 <vprintfmt+0x14a>
				err = -err;
  800637:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800639:	83 fb 64             	cmp    $0x64,%ebx
  80063c:	7f 0b                	jg     800649 <vprintfmt+0x15a>
  80063e:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  800645:	85 f6                	test   %esi,%esi
  800647:	75 19                	jne    800662 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800649:	53                   	push   %ebx
  80064a:	68 a5 20 80 00       	push   $0x8020a5
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	ff 75 08             	pushl  0x8(%ebp)
  800655:	e8 70 02 00 00       	call   8008ca <printfmt>
  80065a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80065d:	e9 5b 02 00 00       	jmp    8008bd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800662:	56                   	push   %esi
  800663:	68 ae 20 80 00       	push   $0x8020ae
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	ff 75 08             	pushl  0x8(%ebp)
  80066e:	e8 57 02 00 00       	call   8008ca <printfmt>
  800673:	83 c4 10             	add    $0x10,%esp
			break;
  800676:	e9 42 02 00 00       	jmp    8008bd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	83 c0 04             	add    $0x4,%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 30                	mov    (%eax),%esi
  80068c:	85 f6                	test   %esi,%esi
  80068e:	75 05                	jne    800695 <vprintfmt+0x1a6>
				p = "(null)";
  800690:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800695:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800699:	7e 6d                	jle    800708 <vprintfmt+0x219>
  80069b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80069f:	74 67                	je     800708 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	50                   	push   %eax
  8006a8:	56                   	push   %esi
  8006a9:	e8 26 05 00 00       	call   800bd4 <strnlen>
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006b4:	eb 16                	jmp    8006cc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006b6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	ff 75 0c             	pushl  0xc(%ebp)
  8006c0:	50                   	push   %eax
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	ff d0                	call   *%eax
  8006c6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8006cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d0:	7f e4                	jg     8006b6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d2:	eb 34                	jmp    800708 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d8:	74 1c                	je     8006f6 <vprintfmt+0x207>
  8006da:	83 fb 1f             	cmp    $0x1f,%ebx
  8006dd:	7e 05                	jle    8006e4 <vprintfmt+0x1f5>
  8006df:	83 fb 7e             	cmp    $0x7e,%ebx
  8006e2:	7e 12                	jle    8006f6 <vprintfmt+0x207>
					putch('?', putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ea:	6a 3f                	push   $0x3f
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb 0f                	jmp    800705 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	ff 4d e4             	decl   -0x1c(%ebp)
  800708:	89 f0                	mov    %esi,%eax
  80070a:	8d 70 01             	lea    0x1(%eax),%esi
  80070d:	8a 00                	mov    (%eax),%al
  80070f:	0f be d8             	movsbl %al,%ebx
  800712:	85 db                	test   %ebx,%ebx
  800714:	74 24                	je     80073a <vprintfmt+0x24b>
  800716:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071a:	78 b8                	js     8006d4 <vprintfmt+0x1e5>
  80071c:	ff 4d e0             	decl   -0x20(%ebp)
  80071f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800723:	79 af                	jns    8006d4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800725:	eb 13                	jmp    80073a <vprintfmt+0x24b>
				putch(' ', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	6a 20                	push   $0x20
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800737:	ff 4d e4             	decl   -0x1c(%ebp)
  80073a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073e:	7f e7                	jg     800727 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800740:	e9 78 01 00 00       	jmp    8008bd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 e8             	pushl  -0x18(%ebp)
  80074b:	8d 45 14             	lea    0x14(%ebp),%eax
  80074e:	50                   	push   %eax
  80074f:	e8 3c fd ff ff       	call   800490 <getint>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80075d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800763:	85 d2                	test   %edx,%edx
  800765:	79 23                	jns    80078a <vprintfmt+0x29b>
				putch('-', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	6a 2d                	push   $0x2d
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80077d:	f7 d8                	neg    %eax
  80077f:	83 d2 00             	adc    $0x0,%edx
  800782:	f7 da                	neg    %edx
  800784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800787:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80078a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800791:	e9 bc 00 00 00       	jmp    800852 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 e8             	pushl  -0x18(%ebp)
  80079c:	8d 45 14             	lea    0x14(%ebp),%eax
  80079f:	50                   	push   %eax
  8007a0:	e8 84 fc ff ff       	call   800429 <getuint>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b5:	e9 98 00 00 00       	jmp    800852 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	6a 58                	push   $0x58
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	6a 58                	push   $0x58
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 58                	push   $0x58
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ea:	e9 ce 00 00 00       	jmp    8008bd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	6a 30                	push   $0x30
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	6a 78                	push   $0x78
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	83 c0 04             	add    $0x4,%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	83 e8 04             	sub    $0x4,%eax
  80081e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800823:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80082a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800831:	eb 1f                	jmp    800852 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 e8             	pushl  -0x18(%ebp)
  800839:	8d 45 14             	lea    0x14(%ebp),%eax
  80083c:	50                   	push   %eax
  80083d:	e8 e7 fb ff ff       	call   800429 <getuint>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800848:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80084b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800852:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800859:	83 ec 04             	sub    $0x4,%esp
  80085c:	52                   	push   %edx
  80085d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800860:	50                   	push   %eax
  800861:	ff 75 f4             	pushl  -0xc(%ebp)
  800864:	ff 75 f0             	pushl  -0x10(%ebp)
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 00 fb ff ff       	call   800372 <printnum>
  800872:	83 c4 20             	add    $0x20,%esp
			break;
  800875:	eb 46                	jmp    8008bd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	53                   	push   %ebx
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	ff d0                	call   *%eax
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	eb 35                	jmp    8008bd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800888:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80088f:	eb 2c                	jmp    8008bd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800891:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800898:	eb 23                	jmp    8008bd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	6a 25                	push   $0x25
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008aa:	ff 4d 10             	decl   0x10(%ebp)
  8008ad:	eb 03                	jmp    8008b2 <vprintfmt+0x3c3>
  8008af:	ff 4d 10             	decl   0x10(%ebp)
  8008b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b5:	48                   	dec    %eax
  8008b6:	8a 00                	mov    (%eax),%al
  8008b8:	3c 25                	cmp    $0x25,%al
  8008ba:	75 f3                	jne    8008af <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008bc:	90                   	nop
		}
	}
  8008bd:	e9 35 fc ff ff       	jmp    8004f7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008c2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008c6:	5b                   	pop    %ebx
  8008c7:	5e                   	pop    %esi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008d0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 04 fc ff ff       	call   8004ef <vprintfmt>
  8008eb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008ee:	90                   	nop
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	8b 40 08             	mov    0x8(%eax),%eax
  8008fa:	8d 50 01             	lea    0x1(%eax),%edx
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800903:	8b 45 0c             	mov    0xc(%ebp),%eax
  800906:	8b 10                	mov    (%eax),%edx
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	8b 40 04             	mov    0x4(%eax),%eax
  80090e:	39 c2                	cmp    %eax,%edx
  800910:	73 12                	jae    800924 <sprintputch+0x33>
		*b->buf++ = ch;
  800912:	8b 45 0c             	mov    0xc(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	8d 48 01             	lea    0x1(%eax),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091d:	89 0a                	mov    %ecx,(%edx)
  80091f:	8b 55 08             	mov    0x8(%ebp),%edx
  800922:	88 10                	mov    %dl,(%eax)
}
  800924:	90                   	nop
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8d 50 ff             	lea    -0x1(%eax),%edx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	01 d0                	add    %edx,%eax
  80093e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800948:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80094c:	74 06                	je     800954 <vsnprintf+0x2d>
  80094e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800952:	7f 07                	jg     80095b <vsnprintf+0x34>
		return -E_INVAL;
  800954:	b8 03 00 00 00       	mov    $0x3,%eax
  800959:	eb 20                	jmp    80097b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095b:	ff 75 14             	pushl  0x14(%ebp)
  80095e:	ff 75 10             	pushl  0x10(%ebp)
  800961:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	68 f1 08 80 00       	push   $0x8008f1
  80096a:	e8 80 fb ff ff       	call   8004ef <vprintfmt>
  80096f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800975:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800978:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800983:	8d 45 10             	lea    0x10(%ebp),%eax
  800986:	83 c0 04             	add    $0x4,%eax
  800989:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80098c:	8b 45 10             	mov    0x10(%ebp),%eax
  80098f:	ff 75 f4             	pushl  -0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 89 ff ff ff       	call   800927 <vsnprintf>
  80099e:	83 c4 10             	add    $0x10,%esp
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8009af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b3:	74 13                	je     8009c8 <readline+0x1f>
		cprintf("%s", prompt);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	68 28 22 80 00       	push   $0x802228
  8009c0:	e8 50 f9 ff ff       	call   800315 <cprintf>
  8009c5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009cf:	83 ec 0c             	sub    $0xc,%esp
  8009d2:	6a 00                	push   $0x0
  8009d4:	e8 3d 0f 00 00       	call   801916 <iscons>
  8009d9:	83 c4 10             	add    $0x10,%esp
  8009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009df:	e8 1f 0f 00 00       	call   801903 <getchar>
  8009e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009eb:	79 22                	jns    800a0f <readline+0x66>
			if (c != -E_EOF)
  8009ed:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009f1:	0f 84 ad 00 00 00    	je     800aa4 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8009fd:	68 2b 22 80 00       	push   $0x80222b
  800a02:	e8 0e f9 ff ff       	call   800315 <cprintf>
  800a07:	83 c4 10             	add    $0x10,%esp
			break;
  800a0a:	e9 95 00 00 00       	jmp    800aa4 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a0f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a13:	7e 34                	jle    800a49 <readline+0xa0>
  800a15:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a1c:	7f 2b                	jg     800a49 <readline+0xa0>
			if (echoing)
  800a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a22:	74 0e                	je     800a32 <readline+0x89>
				cputchar(c);
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	ff 75 ec             	pushl  -0x14(%ebp)
  800a2a:	e8 b5 0e 00 00       	call   8018e4 <cputchar>
  800a2f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a35:	8d 50 01             	lea    0x1(%eax),%edx
  800a38:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	01 d0                	add    %edx,%eax
  800a42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a45:	88 10                	mov    %dl,(%eax)
  800a47:	eb 56                	jmp    800a9f <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a49:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a4d:	75 1f                	jne    800a6e <readline+0xc5>
  800a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a53:	7e 19                	jle    800a6e <readline+0xc5>
			if (echoing)
  800a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a59:	74 0e                	je     800a69 <readline+0xc0>
				cputchar(c);
  800a5b:	83 ec 0c             	sub    $0xc,%esp
  800a5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800a61:	e8 7e 0e 00 00       	call   8018e4 <cputchar>
  800a66:	83 c4 10             	add    $0x10,%esp

			i--;
  800a69:	ff 4d f4             	decl   -0xc(%ebp)
  800a6c:	eb 31                	jmp    800a9f <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a6e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a72:	74 0a                	je     800a7e <readline+0xd5>
  800a74:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a78:	0f 85 61 ff ff ff    	jne    8009df <readline+0x36>
			if (echoing)
  800a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a82:	74 0e                	je     800a92 <readline+0xe9>
				cputchar(c);
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	ff 75 ec             	pushl  -0x14(%ebp)
  800a8a:	e8 55 0e 00 00       	call   8018e4 <cputchar>
  800a8f:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	01 d0                	add    %edx,%eax
  800a9a:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a9d:	eb 06                	jmp    800aa5 <readline+0xfc>
		}
	}
  800a9f:	e9 3b ff ff ff       	jmp    8009df <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800aa4:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800aa5:	90                   	nop
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800aae:	e8 71 08 00 00       	call   801324 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800ab3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ab7:	74 13                	je     800acc <atomic_readline+0x24>
			cprintf("%s", prompt);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	68 28 22 80 00       	push   $0x802228
  800ac4:	e8 4c f8 ff ff       	call   800315 <cprintf>
  800ac9:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800acc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800ad3:	83 ec 0c             	sub    $0xc,%esp
  800ad6:	6a 00                	push   $0x0
  800ad8:	e8 39 0e 00 00       	call   801916 <iscons>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ae3:	e8 1b 0e 00 00       	call   801903 <getchar>
  800ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800aeb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aef:	79 22                	jns    800b13 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800af1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800af5:	0f 84 ad 00 00 00    	je     800ba8 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 ec             	pushl  -0x14(%ebp)
  800b01:	68 2b 22 80 00       	push   $0x80222b
  800b06:	e8 0a f8 ff ff       	call   800315 <cprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
				break;
  800b0e:	e9 95 00 00 00       	jmp    800ba8 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b13:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b17:	7e 34                	jle    800b4d <atomic_readline+0xa5>
  800b19:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b20:	7f 2b                	jg     800b4d <atomic_readline+0xa5>
				if (echoing)
  800b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b26:	74 0e                	je     800b36 <atomic_readline+0x8e>
					cputchar(c);
  800b28:	83 ec 0c             	sub    $0xc,%esp
  800b2b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2e:	e8 b1 0d 00 00       	call   8018e4 <cputchar>
  800b33:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	01 d0                	add    %edx,%eax
  800b46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b49:	88 10                	mov    %dl,(%eax)
  800b4b:	eb 56                	jmp    800ba3 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b4d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b51:	75 1f                	jne    800b72 <atomic_readline+0xca>
  800b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b57:	7e 19                	jle    800b72 <atomic_readline+0xca>
				if (echoing)
  800b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b5d:	74 0e                	je     800b6d <atomic_readline+0xc5>
					cputchar(c);
  800b5f:	83 ec 0c             	sub    $0xc,%esp
  800b62:	ff 75 ec             	pushl  -0x14(%ebp)
  800b65:	e8 7a 0d 00 00       	call   8018e4 <cputchar>
  800b6a:	83 c4 10             	add    $0x10,%esp
				i--;
  800b6d:	ff 4d f4             	decl   -0xc(%ebp)
  800b70:	eb 31                	jmp    800ba3 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b72:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b76:	74 0a                	je     800b82 <atomic_readline+0xda>
  800b78:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b7c:	0f 85 61 ff ff ff    	jne    800ae3 <atomic_readline+0x3b>
				if (echoing)
  800b82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b86:	74 0e                	je     800b96 <atomic_readline+0xee>
					cputchar(c);
  800b88:	83 ec 0c             	sub    $0xc,%esp
  800b8b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b8e:	e8 51 0d 00 00       	call   8018e4 <cputchar>
  800b93:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800ba1:	eb 06                	jmp    800ba9 <atomic_readline+0x101>
			}
		}
  800ba3:	e9 3b ff ff ff       	jmp    800ae3 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800ba8:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ba9:	e8 90 07 00 00       	call   80133e <sys_unlock_cons>
}
  800bae:	90                   	nop
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bbe:	eb 06                	jmp    800bc6 <strlen+0x15>
		n++;
  800bc0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc3:	ff 45 08             	incl   0x8(%ebp)
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	84 c0                	test   %al,%al
  800bcd:	75 f1                	jne    800bc0 <strlen+0xf>
		n++;
	return n;
  800bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be1:	eb 09                	jmp    800bec <strnlen+0x18>
		n++;
  800be3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be6:	ff 45 08             	incl   0x8(%ebp)
  800be9:	ff 4d 0c             	decl   0xc(%ebp)
  800bec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf0:	74 09                	je     800bfb <strnlen+0x27>
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8a 00                	mov    (%eax),%al
  800bf7:	84 c0                	test   %al,%al
  800bf9:	75 e8                	jne    800be3 <strnlen+0xf>
		n++;
	return n;
  800bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c0c:	90                   	nop
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	8d 50 01             	lea    0x1(%eax),%edx
  800c13:	89 55 08             	mov    %edx,0x8(%ebp)
  800c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c19:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1f:	8a 12                	mov    (%edx),%dl
  800c21:	88 10                	mov    %dl,(%eax)
  800c23:	8a 00                	mov    (%eax),%al
  800c25:	84 c0                	test   %al,%al
  800c27:	75 e4                	jne    800c0d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c41:	eb 1f                	jmp    800c62 <strncpy+0x34>
		*dst++ = *src;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8d 50 01             	lea    0x1(%eax),%edx
  800c49:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4f:	8a 12                	mov    (%edx),%dl
  800c51:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	84 c0                	test   %al,%al
  800c5a:	74 03                	je     800c5f <strncpy+0x31>
			src++;
  800c5c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5f:	ff 45 fc             	incl   -0x4(%ebp)
  800c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c68:	72 d9                	jb     800c43 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7f:	74 30                	je     800cb1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c81:	eb 16                	jmp    800c99 <strlcpy+0x2a>
			*dst++ = *src++;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8d 50 01             	lea    0x1(%eax),%edx
  800c89:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c95:	8a 12                	mov    (%edx),%dl
  800c97:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c99:	ff 4d 10             	decl   0x10(%ebp)
  800c9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca0:	74 09                	je     800cab <strlcpy+0x3c>
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	84 c0                	test   %al,%al
  800ca9:	75 d8                	jne    800c83 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	29 c2                	sub    %eax,%edx
  800cb9:	89 d0                	mov    %edx,%eax
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc0:	eb 06                	jmp    800cc8 <strcmp+0xb>
		p++, q++;
  800cc2:	ff 45 08             	incl   0x8(%ebp)
  800cc5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	74 0e                	je     800cdf <strcmp+0x22>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 10                	mov    (%eax),%dl
  800cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	38 c2                	cmp    %al,%dl
  800cdd:	74 e3                	je     800cc2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	0f b6 d0             	movzbl %al,%edx
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	0f b6 c0             	movzbl %al,%eax
  800cef:	29 c2                	sub    %eax,%edx
  800cf1:	89 d0                	mov    %edx,%eax
}
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf8:	eb 09                	jmp    800d03 <strncmp+0xe>
		n--, p++, q++;
  800cfa:	ff 4d 10             	decl   0x10(%ebp)
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d07:	74 17                	je     800d20 <strncmp+0x2b>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	84 c0                	test   %al,%al
  800d10:	74 0e                	je     800d20 <strncmp+0x2b>
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 10                	mov    (%eax),%dl
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	38 c2                	cmp    %al,%dl
  800d1e:	74 da                	je     800cfa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d24:	75 07                	jne    800d2d <strncmp+0x38>
		return 0;
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	eb 14                	jmp    800d41 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	0f b6 d0             	movzbl %al,%edx
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	29 c2                	sub    %eax,%edx
  800d3f:	89 d0                	mov    %edx,%eax
}
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 04             	sub    $0x4,%esp
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4f:	eb 12                	jmp    800d63 <strchr+0x20>
		if (*s == c)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d59:	75 05                	jne    800d60 <strchr+0x1d>
			return (char *) s;
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	eb 11                	jmp    800d71 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 e5                	jne    800d51 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 04             	sub    $0x4,%esp
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7f:	eb 0d                	jmp    800d8e <strfind+0x1b>
		if (*s == c)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d89:	74 0e                	je     800d99 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8b:	ff 45 08             	incl   0x8(%ebp)
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	84 c0                	test   %al,%al
  800d95:	75 ea                	jne    800d81 <strfind+0xe>
  800d97:	eb 01                	jmp    800d9a <strfind+0x27>
		if (*s == c)
			break;
  800d99:	90                   	nop
	return (char *) s;
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db1:	eb 0e                	jmp    800dc1 <memset+0x22>
		*p++ = c;
  800db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db6:	8d 50 01             	lea    0x1(%eax),%edx
  800db9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc1:	ff 4d f8             	decl   -0x8(%ebp)
  800dc4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc8:	79 e9                	jns    800db3 <memset+0x14>
		*p++ = c;

	return v;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de1:	eb 16                	jmp    800df9 <memcpy+0x2a>
		*d++ = *s++;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800def:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df5:	8a 12                	mov    (%edx),%dl
  800df7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dff:	89 55 10             	mov    %edx,0x10(%ebp)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	75 dd                	jne    800de3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e23:	73 50                	jae    800e75 <memmove+0x6a>
  800e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e30:	76 43                	jbe    800e75 <memmove+0x6a>
		s += n;
  800e32:	8b 45 10             	mov    0x10(%ebp),%eax
  800e35:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3e:	eb 10                	jmp    800e50 <memmove+0x45>
			*--d = *--s;
  800e40:	ff 4d f8             	decl   -0x8(%ebp)
  800e43:	ff 4d fc             	decl   -0x4(%ebp)
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e49:	8a 10                	mov    (%eax),%dl
  800e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e56:	89 55 10             	mov    %edx,0x10(%ebp)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	75 e3                	jne    800e40 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e5d:	eb 23                	jmp    800e82 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	8d 50 01             	lea    0x1(%eax),%edx
  800e65:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e68:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e71:	8a 12                	mov    (%edx),%dl
  800e73:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e75:	8b 45 10             	mov    0x10(%ebp),%eax
  800e78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	75 dd                	jne    800e5f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e99:	eb 2a                	jmp    800ec5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	8a 10                	mov    (%eax),%dl
  800ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	38 c2                	cmp    %al,%dl
  800ea7:	74 16                	je     800ebf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f b6 d0             	movzbl %al,%edx
  800eb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	0f b6 c0             	movzbl %al,%eax
  800eb9:	29 c2                	sub    %eax,%edx
  800ebb:	89 d0                	mov    %edx,%eax
  800ebd:	eb 18                	jmp    800ed7 <memcmp+0x50>
		s1++, s2++;
  800ebf:	ff 45 fc             	incl   -0x4(%ebp)
  800ec2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	75 c9                	jne    800e9b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eea:	eb 15                	jmp    800f01 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 d0             	movzbl %al,%edx
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	0f b6 c0             	movzbl %al,%eax
  800efa:	39 c2                	cmp    %eax,%edx
  800efc:	74 0d                	je     800f0b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efe:	ff 45 08             	incl   0x8(%ebp)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f07:	72 e3                	jb     800eec <memfind+0x13>
  800f09:	eb 01                	jmp    800f0c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0b:	90                   	nop
	return (void *) s;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f25:	eb 03                	jmp    800f2a <strtol+0x19>
		s++;
  800f27:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 20                	cmp    $0x20,%al
  800f31:	74 f4                	je     800f27 <strtol+0x16>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 09                	cmp    $0x9,%al
  800f3a:	74 eb                	je     800f27 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 2b                	cmp    $0x2b,%al
  800f43:	75 05                	jne    800f4a <strtol+0x39>
		s++;
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	eb 13                	jmp    800f5d <strtol+0x4c>
	else if (*s == '-')
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	3c 2d                	cmp    $0x2d,%al
  800f51:	75 0a                	jne    800f5d <strtol+0x4c>
		s++, neg = 1;
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f61:	74 06                	je     800f69 <strtol+0x58>
  800f63:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f67:	75 20                	jne    800f89 <strtol+0x78>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 30                	cmp    $0x30,%al
  800f70:	75 17                	jne    800f89 <strtol+0x78>
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	40                   	inc    %eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 78                	cmp    $0x78,%al
  800f7a:	75 0d                	jne    800f89 <strtol+0x78>
		s += 2, base = 16;
  800f7c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f80:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f87:	eb 28                	jmp    800fb1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8d:	75 15                	jne    800fa4 <strtol+0x93>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 30                	cmp    $0x30,%al
  800f96:	75 0c                	jne    800fa4 <strtol+0x93>
		s++, base = 8;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa2:	eb 0d                	jmp    800fb1 <strtol+0xa0>
	else if (base == 0)
  800fa4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa8:	75 07                	jne    800fb1 <strtol+0xa0>
		base = 10;
  800faa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 2f                	cmp    $0x2f,%al
  800fb8:	7e 19                	jle    800fd3 <strtol+0xc2>
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	3c 39                	cmp    $0x39,%al
  800fc1:	7f 10                	jg     800fd3 <strtol+0xc2>
			dig = *s - '0';
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f be c0             	movsbl %al,%eax
  800fcb:	83 e8 30             	sub    $0x30,%eax
  800fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd1:	eb 42                	jmp    801015 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 60                	cmp    $0x60,%al
  800fda:	7e 19                	jle    800ff5 <strtol+0xe4>
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3c 7a                	cmp    $0x7a,%al
  800fe3:	7f 10                	jg     800ff5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	0f be c0             	movsbl %al,%eax
  800fed:	83 e8 57             	sub    $0x57,%eax
  800ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff3:	eb 20                	jmp    801015 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 40                	cmp    $0x40,%al
  800ffc:	7e 39                	jle    801037 <strtol+0x126>
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3c 5a                	cmp    $0x5a,%al
  801005:	7f 30                	jg     801037 <strtol+0x126>
			dig = *s - 'A' + 10;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	0f be c0             	movsbl %al,%eax
  80100f:	83 e8 37             	sub    $0x37,%eax
  801012:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801018:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101b:	7d 19                	jge    801036 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80101d:	ff 45 08             	incl   0x8(%ebp)
  801020:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801023:	0f af 45 10          	imul   0x10(%ebp),%eax
  801027:	89 c2                	mov    %eax,%edx
  801029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801031:	e9 7b ff ff ff       	jmp    800fb1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801036:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801037:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103b:	74 08                	je     801045 <strtol+0x134>
		*endptr = (char *) s;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801045:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801049:	74 07                	je     801052 <strtol+0x141>
  80104b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104e:	f7 d8                	neg    %eax
  801050:	eb 03                	jmp    801055 <strtol+0x144>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <ltostr>:

void
ltostr(long value, char *str)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80105d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801064:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106f:	79 13                	jns    801084 <ltostr+0x2d>
	{
		neg = 1;
  801071:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801081:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80108c:	99                   	cltd   
  80108d:	f7 f9                	idiv   %ecx
  80108f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801095:	8d 50 01             	lea    0x1(%eax),%edx
  801098:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	01 d0                	add    %edx,%eax
  8010a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a5:	83 c2 30             	add    $0x30,%edx
  8010a8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ad:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b2:	f7 e9                	imul   %ecx
  8010b4:	c1 fa 02             	sar    $0x2,%edx
  8010b7:	89 c8                	mov    %ecx,%eax
  8010b9:	c1 f8 1f             	sar    $0x1f,%eax
  8010bc:	29 c2                	sub    %eax,%edx
  8010be:	89 d0                	mov    %edx,%eax
  8010c0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c7:	75 bb                	jne    801084 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d3:	48                   	dec    %eax
  8010d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010db:	74 3d                	je     80111a <ltostr+0xc3>
		start = 1 ;
  8010dd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e4:	eb 34                	jmp    80111a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	01 d0                	add    %edx,%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	01 c2                	add    %eax,%edx
  8010fb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 c8                	add    %ecx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801107:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801112:	88 02                	mov    %al,(%edx)
		start++ ;
  801114:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801117:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80111a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801120:	7c c4                	jl     8010e6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801122:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 d0                	add    %edx,%eax
  80112a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112d:	90                   	nop
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801136:	ff 75 08             	pushl  0x8(%ebp)
  801139:	e8 73 fa ff ff       	call   800bb1 <strlen>
  80113e:	83 c4 04             	add    $0x4,%esp
  801141:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	e8 65 fa ff ff       	call   800bb1 <strlen>
  80114c:	83 c4 04             	add    $0x4,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801160:	eb 17                	jmp    801179 <strcconcat+0x49>
		final[s] = str1[s] ;
  801162:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801165:	8b 45 10             	mov    0x10(%ebp),%eax
  801168:	01 c2                	add    %eax,%edx
  80116a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	01 c8                	add    %ecx,%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801176:	ff 45 fc             	incl   -0x4(%ebp)
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117f:	7c e1                	jl     801162 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801181:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801188:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118f:	eb 1f                	jmp    8011b0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801194:	8d 50 01             	lea    0x1(%eax),%edx
  801197:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80119a:	89 c2                	mov    %eax,%edx
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	01 c2                	add    %eax,%edx
  8011a1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	01 c8                	add    %ecx,%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ad:	ff 45 f8             	incl   -0x8(%ebp)
  8011b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b6:	7c d9                	jl     801191 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 d0                	add    %edx,%eax
  8011c0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c3:	90                   	nop
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d5:	8b 00                	mov    (%eax),%eax
  8011d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e9:	eb 0c                	jmp    8011f7 <strsplit+0x31>
			*string++ = 0;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 18                	je     801218 <strsplit+0x52>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	0f be c0             	movsbl %al,%eax
  801208:	50                   	push   %eax
  801209:	ff 75 0c             	pushl  0xc(%ebp)
  80120c:	e8 32 fb ff ff       	call   800d43 <strchr>
  801211:	83 c4 08             	add    $0x8,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	75 d3                	jne    8011eb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	84 c0                	test   %al,%al
  80121f:	74 5a                	je     80127b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801221:	8b 45 14             	mov    0x14(%ebp),%eax
  801224:	8b 00                	mov    (%eax),%eax
  801226:	83 f8 0f             	cmp    $0xf,%eax
  801229:	75 07                	jne    801232 <strsplit+0x6c>
		{
			return 0;
  80122b:	b8 00 00 00 00       	mov    $0x0,%eax
  801230:	eb 66                	jmp    801298 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801232:	8b 45 14             	mov    0x14(%ebp),%eax
  801235:	8b 00                	mov    (%eax),%eax
  801237:	8d 48 01             	lea    0x1(%eax),%ecx
  80123a:	8b 55 14             	mov    0x14(%ebp),%edx
  80123d:	89 0a                	mov    %ecx,(%edx)
  80123f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801246:	8b 45 10             	mov    0x10(%ebp),%eax
  801249:	01 c2                	add    %eax,%edx
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801250:	eb 03                	jmp    801255 <strsplit+0x8f>
			string++;
  801252:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	84 c0                	test   %al,%al
  80125c:	74 8b                	je     8011e9 <strsplit+0x23>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	0f be c0             	movsbl %al,%eax
  801266:	50                   	push   %eax
  801267:	ff 75 0c             	pushl  0xc(%ebp)
  80126a:	e8 d4 fa ff ff       	call   800d43 <strchr>
  80126f:	83 c4 08             	add    $0x8,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	74 dc                	je     801252 <strsplit+0x8c>
			string++;
	}
  801276:	e9 6e ff ff ff       	jmp    8011e9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127c:	8b 45 14             	mov    0x14(%ebp),%eax
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801293:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	68 3c 22 80 00       	push   $0x80223c
  8012a8:	68 3f 01 00 00       	push   $0x13f
  8012ad:	68 5e 22 80 00       	push   $0x80225e
  8012b2:	e8 69 06 00 00       	call   801920 <_panic>

008012b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	57                   	push   %edi
  8012bb:	56                   	push   %esi
  8012bc:	53                   	push   %ebx
  8012bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012d2:	cd 30                	int    $0x30
  8012d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    

008012e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	52                   	push   %edx
  8012fa:	ff 75 0c             	pushl  0xc(%ebp)
  8012fd:	50                   	push   %eax
  8012fe:	6a 00                	push   $0x0
  801300:	e8 b2 ff ff ff       	call   8012b7 <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	90                   	nop
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_cgetc>:

int
sys_cgetc(void)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 02                	push   $0x2
  80131a:	e8 98 ff ff ff       	call   8012b7 <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 03                	push   $0x3
  801333:	e8 7f ff ff ff       	call   8012b7 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	90                   	nop
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 04                	push   $0x4
  80134d:	e8 65 ff ff ff       	call   8012b7 <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80135b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	52                   	push   %edx
  801368:	50                   	push   %eax
  801369:	6a 08                	push   $0x8
  80136b:	e8 47 ff ff ff       	call   8012b7 <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80137a:	8b 75 18             	mov    0x18(%ebp),%esi
  80137d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	51                   	push   %ecx
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	6a 09                	push   $0x9
  801390:	e8 22 ff ff ff       	call   8012b7 <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139b:	5b                   	pop    %ebx
  80139c:	5e                   	pop    %esi
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    

0080139f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	52                   	push   %edx
  8013af:	50                   	push   %eax
  8013b0:	6a 0a                	push   $0xa
  8013b2:	e8 00 ff ff ff       	call   8012b7 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	ff 75 0c             	pushl  0xc(%ebp)
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	6a 0b                	push   $0xb
  8013cd:	e8 e5 fe ff ff       	call   8012b7 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 0c                	push   $0xc
  8013e6:	e8 cc fe ff ff       	call   8012b7 <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 0d                	push   $0xd
  8013ff:	e8 b3 fe ff ff       	call   8012b7 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 0e                	push   $0xe
  801418:	e8 9a fe ff ff       	call   8012b7 <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 0f                	push   $0xf
  801431:	e8 81 fe ff ff       	call   8012b7 <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	ff 75 08             	pushl  0x8(%ebp)
  801449:	6a 10                	push   $0x10
  80144b:	e8 67 fe ff ff       	call   8012b7 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 11                	push   $0x11
  801464:	e8 4e fe ff ff       	call   8012b7 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	90                   	nop
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_cputc>:

void
sys_cputc(const char c)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80147b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	50                   	push   %eax
  801488:	6a 01                	push   $0x1
  80148a:	e8 28 fe ff ff       	call   8012b7 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 14                	push   $0x14
  8014a4:	e8 0e fe ff ff       	call   8012b7 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	51                   	push   %ecx
  8014c8:	52                   	push   %edx
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	50                   	push   %eax
  8014cd:	6a 15                	push   $0x15
  8014cf:	e8 e3 fd ff ff       	call   8012b7 <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	52                   	push   %edx
  8014e9:	50                   	push   %eax
  8014ea:	6a 16                	push   $0x16
  8014ec:	e8 c6 fd ff ff       	call   8012b7 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	51                   	push   %ecx
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	6a 17                	push   $0x17
  80150b:	e8 a7 fd ff ff       	call   8012b7 <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	52                   	push   %edx
  801525:	50                   	push   %eax
  801526:	6a 18                	push   $0x18
  801528:	e8 8a fd ff ff       	call   8012b7 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	6a 00                	push   $0x0
  80153a:	ff 75 14             	pushl  0x14(%ebp)
  80153d:	ff 75 10             	pushl  0x10(%ebp)
  801540:	ff 75 0c             	pushl  0xc(%ebp)
  801543:	50                   	push   %eax
  801544:	6a 19                	push   $0x19
  801546:	e8 6c fd ff ff       	call   8012b7 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	50                   	push   %eax
  80155f:	6a 1a                	push   $0x1a
  801561:	e8 51 fd ff ff       	call   8012b7 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	50                   	push   %eax
  80157b:	6a 1b                	push   $0x1b
  80157d:	e8 35 fd ff ff       	call   8012b7 <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 05                	push   $0x5
  801596:	e8 1c fd ff ff       	call   8012b7 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 06                	push   $0x6
  8015af:	e8 03 fd ff ff       	call   8012b7 <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 07                	push   $0x7
  8015c8:	e8 ea fc ff ff       	call   8012b7 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_exit_env>:


void sys_exit_env(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 1c                	push   $0x1c
  8015e1:	e8 d1 fc ff ff       	call   8012b7 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	90                   	nop
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015f5:	8d 50 04             	lea    0x4(%eax),%edx
  8015f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	52                   	push   %edx
  801602:	50                   	push   %eax
  801603:	6a 1d                	push   $0x1d
  801605:	e8 ad fc ff ff       	call   8012b7 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
	return result;
  80160d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801610:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801613:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801616:	89 01                	mov    %eax,(%ecx)
  801618:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	c9                   	leave  
  80161f:	c2 04 00             	ret    $0x4

00801622 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	ff 75 10             	pushl  0x10(%ebp)
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	6a 13                	push   $0x13
  801634:	e8 7e fc ff ff       	call   8012b7 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
	return ;
  80163c:	90                   	nop
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_rcr2>:
uint32 sys_rcr2()
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 1e                	push   $0x1e
  80164e:	e8 64 fc ff ff       	call   8012b7 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 04             	sub    $0x4,%esp
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801664:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	50                   	push   %eax
  801671:	6a 1f                	push   $0x1f
  801673:	e8 3f fc ff ff       	call   8012b7 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
	return ;
  80167b:	90                   	nop
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <rsttst>:
void rsttst()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 21                	push   $0x21
  80168d:	e8 25 fc ff ff       	call   8012b7 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
	return ;
  801695:	90                   	nop
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016a4:	8b 55 18             	mov    0x18(%ebp),%edx
  8016a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 10             	pushl  0x10(%ebp)
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	6a 20                	push   $0x20
  8016b8:	e8 fa fb ff ff       	call   8012b7 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c0:	90                   	nop
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <chktst>:
void chktst(uint32 n)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 22                	push   $0x22
  8016d3:	e8 df fb ff ff       	call   8012b7 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016db:	90                   	nop
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <inctst>:

void inctst()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 23                	push   $0x23
  8016ed:	e8 c5 fb ff ff       	call   8012b7 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f5:	90                   	nop
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <gettst>:
uint32 gettst()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 24                	push   $0x24
  801707:	e8 ab fb ff ff       	call   8012b7 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 25                	push   $0x25
  801723:	e8 8f fb ff ff       	call   8012b7 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
  80172b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80172e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801732:	75 07                	jne    80173b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801734:	b8 01 00 00 00       	mov    $0x1,%eax
  801739:	eb 05                	jmp    801740 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 25                	push   $0x25
  801754:	e8 5e fb ff ff       	call   8012b7 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
  80175c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80175f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801763:	75 07                	jne    80176c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801765:	b8 01 00 00 00       	mov    $0x1,%eax
  80176a:	eb 05                	jmp    801771 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 25                	push   $0x25
  801785:	e8 2d fb ff ff       	call   8012b7 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
  80178d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801790:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801794:	75 07                	jne    80179d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801796:	b8 01 00 00 00       	mov    $0x1,%eax
  80179b:	eb 05                	jmp    8017a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80179d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 25                	push   $0x25
  8017b6:	e8 fc fa ff ff       	call   8012b7 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
  8017be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017c1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017c5:	75 07                	jne    8017ce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cc:	eb 05                	jmp    8017d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 26                	push   $0x26
  8017e5:	e8 cd fa ff ff       	call   8012b7 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ed:	90                   	nop
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	53                   	push   %ebx
  801803:	51                   	push   %ecx
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 27                	push   $0x27
  801808:	e8 aa fa ff ff       	call   8012b7 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	52                   	push   %edx
  801825:	50                   	push   %eax
  801826:	6a 28                	push   $0x28
  801828:	e8 8a fa ff ff       	call   8012b7 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801835:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	51                   	push   %ecx
  801841:	ff 75 10             	pushl  0x10(%ebp)
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	6a 29                	push   $0x29
  801848:	e8 6a fa ff ff       	call   8012b7 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 12                	push   $0x12
  801864:	e8 4e fa ff ff       	call   8012b7 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 2a                	push   $0x2a
  801882:	e8 30 fa ff ff       	call   8012b7 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
	return;
  80188a:	90                   	nop
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 6b 22 80 00       	push   $0x80226b
  80189b:	68 2e 01 00 00       	push   $0x12e
  8018a0:	68 7f 22 80 00       	push   $0x80227f
  8018a5:	e8 76 00 00 00       	call   801920 <_panic>

008018aa <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 6b 22 80 00       	push   $0x80226b
  8018b8:	68 35 01 00 00       	push   $0x135
  8018bd:	68 7f 22 80 00       	push   $0x80227f
  8018c2:	e8 59 00 00 00       	call   801920 <_panic>

008018c7 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 6b 22 80 00       	push   $0x80226b
  8018d5:	68 3b 01 00 00       	push   $0x13b
  8018da:	68 7f 22 80 00       	push   $0x80227f
  8018df:	e8 3c 00 00 00       	call   801920 <_panic>

008018e4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018f0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018f4:	83 ec 0c             	sub    $0xc,%esp
  8018f7:	50                   	push   %eax
  8018f8:	e8 72 fb ff ff       	call   80146f <sys_cputc>
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <getchar>:


int
getchar(void)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801909:	e8 fd f9 ff ff       	call   80130b <sys_cgetc>
  80190e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <iscons>:

int iscons(int fdnum)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801919:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80191e:	5d                   	pop    %ebp
  80191f:	c3                   	ret    

00801920 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801926:	8d 45 10             	lea    0x10(%ebp),%eax
  801929:	83 c0 04             	add    $0x4,%eax
  80192c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80192f:	a1 24 30 80 00       	mov    0x803024,%eax
  801934:	85 c0                	test   %eax,%eax
  801936:	74 16                	je     80194e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801938:	a1 24 30 80 00       	mov    0x803024,%eax
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	50                   	push   %eax
  801941:	68 90 22 80 00       	push   $0x802290
  801946:	e8 ca e9 ff ff       	call   800315 <cprintf>
  80194b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80194e:	a1 00 30 80 00       	mov    0x803000,%eax
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	50                   	push   %eax
  80195a:	68 95 22 80 00       	push   $0x802295
  80195f:	e8 b1 e9 ff ff       	call   800315 <cprintf>
  801964:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 f4             	pushl  -0xc(%ebp)
  801970:	50                   	push   %eax
  801971:	e8 34 e9 ff ff       	call   8002aa <vcprintf>
  801976:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	6a 00                	push   $0x0
  80197e:	68 b1 22 80 00       	push   $0x8022b1
  801983:	e8 22 e9 ff ff       	call   8002aa <vcprintf>
  801988:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80198b:	e8 a3 e8 ff ff       	call   800233 <exit>

	// should not return here
	while (1) ;
  801990:	eb fe                	jmp    801990 <_panic+0x70>

00801992 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801998:	a1 04 30 80 00       	mov    0x803004,%eax
  80199d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a6:	39 c2                	cmp    %eax,%edx
  8019a8:	74 14                	je     8019be <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	68 b4 22 80 00       	push   $0x8022b4
  8019b2:	6a 26                	push   $0x26
  8019b4:	68 00 23 80 00       	push   $0x802300
  8019b9:	e8 62 ff ff ff       	call   801920 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019cc:	e9 c5 00 00 00       	jmp    801a96 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	01 d0                	add    %edx,%eax
  8019e0:	8b 00                	mov    (%eax),%eax
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	75 08                	jne    8019ee <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019e6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019e9:	e9 a5 00 00 00       	jmp    801a93 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019fc:	eb 69                	jmp    801a67 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019fe:	a1 04 30 80 00       	mov    0x803004,%eax
  801a03:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a0c:	89 d0                	mov    %edx,%eax
  801a0e:	01 c0                	add    %eax,%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	c1 e0 03             	shl    $0x3,%eax
  801a15:	01 c8                	add    %ecx,%eax
  801a17:	8a 40 04             	mov    0x4(%eax),%al
  801a1a:	84 c0                	test   %al,%al
  801a1c:	75 46                	jne    801a64 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a1e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a23:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a2c:	89 d0                	mov    %edx,%eax
  801a2e:	01 c0                	add    %eax,%eax
  801a30:	01 d0                	add    %edx,%eax
  801a32:	c1 e0 03             	shl    $0x3,%eax
  801a35:	01 c8                	add    %ecx,%eax
  801a37:	8b 00                	mov    (%eax),%eax
  801a39:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a44:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a49:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	01 c8                	add    %ecx,%eax
  801a55:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a57:	39 c2                	cmp    %eax,%edx
  801a59:	75 09                	jne    801a64 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a5b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a62:	eb 15                	jmp    801a79 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a64:	ff 45 e8             	incl   -0x18(%ebp)
  801a67:	a1 04 30 80 00       	mov    0x803004,%eax
  801a6c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a75:	39 c2                	cmp    %eax,%edx
  801a77:	77 85                	ja     8019fe <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a7d:	75 14                	jne    801a93 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	68 0c 23 80 00       	push   $0x80230c
  801a87:	6a 3a                	push   $0x3a
  801a89:	68 00 23 80 00       	push   $0x802300
  801a8e:	e8 8d fe ff ff       	call   801920 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a93:	ff 45 f0             	incl   -0x10(%ebp)
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a9c:	0f 8c 2f ff ff ff    	jl     8019d1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aa2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aa9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ab0:	eb 26                	jmp    801ad8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ab2:	a1 04 30 80 00       	mov    0x803004,%eax
  801ab7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801abd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac0:	89 d0                	mov    %edx,%eax
  801ac2:	01 c0                	add    %eax,%eax
  801ac4:	01 d0                	add    %edx,%eax
  801ac6:	c1 e0 03             	shl    $0x3,%eax
  801ac9:	01 c8                	add    %ecx,%eax
  801acb:	8a 40 04             	mov    0x4(%eax),%al
  801ace:	3c 01                	cmp    $0x1,%al
  801ad0:	75 03                	jne    801ad5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ad2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ad5:	ff 45 e0             	incl   -0x20(%ebp)
  801ad8:	a1 04 30 80 00       	mov    0x803004,%eax
  801add:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae6:	39 c2                	cmp    %eax,%edx
  801ae8:	77 c8                	ja     801ab2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af0:	74 14                	je     801b06 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	68 60 23 80 00       	push   $0x802360
  801afa:	6a 44                	push   $0x44
  801afc:	68 00 23 80 00       	push   $0x802300
  801b01:	e8 1a fe ff ff       	call   801920 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    
  801b09:	66 90                	xchg   %ax,%ax
  801b0b:	90                   	nop

00801b0c <__udivdi3>:
  801b0c:	55                   	push   %ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b23:	89 ca                	mov    %ecx,%edx
  801b25:	89 f8                	mov    %edi,%eax
  801b27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b2b:	85 f6                	test   %esi,%esi
  801b2d:	75 2d                	jne    801b5c <__udivdi3+0x50>
  801b2f:	39 cf                	cmp    %ecx,%edi
  801b31:	77 65                	ja     801b98 <__udivdi3+0x8c>
  801b33:	89 fd                	mov    %edi,%ebp
  801b35:	85 ff                	test   %edi,%edi
  801b37:	75 0b                	jne    801b44 <__udivdi3+0x38>
  801b39:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	f7 f7                	div    %edi
  801b42:	89 c5                	mov    %eax,%ebp
  801b44:	31 d2                	xor    %edx,%edx
  801b46:	89 c8                	mov    %ecx,%eax
  801b48:	f7 f5                	div    %ebp
  801b4a:	89 c1                	mov    %eax,%ecx
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	f7 f5                	div    %ebp
  801b50:	89 cf                	mov    %ecx,%edi
  801b52:	89 fa                	mov    %edi,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	39 ce                	cmp    %ecx,%esi
  801b5e:	77 28                	ja     801b88 <__udivdi3+0x7c>
  801b60:	0f bd fe             	bsr    %esi,%edi
  801b63:	83 f7 1f             	xor    $0x1f,%edi
  801b66:	75 40                	jne    801ba8 <__udivdi3+0x9c>
  801b68:	39 ce                	cmp    %ecx,%esi
  801b6a:	72 0a                	jb     801b76 <__udivdi3+0x6a>
  801b6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b70:	0f 87 9e 00 00 00    	ja     801c14 <__udivdi3+0x108>
  801b76:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7b:	89 fa                	mov    %edi,%edx
  801b7d:	83 c4 1c             	add    $0x1c,%esp
  801b80:	5b                   	pop    %ebx
  801b81:	5e                   	pop    %esi
  801b82:	5f                   	pop    %edi
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    
  801b85:	8d 76 00             	lea    0x0(%esi),%esi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	31 c0                	xor    %eax,%eax
  801b8c:	89 fa                	mov    %edi,%edx
  801b8e:	83 c4 1c             	add    $0x1c,%esp
  801b91:	5b                   	pop    %ebx
  801b92:	5e                   	pop    %esi
  801b93:	5f                   	pop    %edi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
  801b96:	66 90                	xchg   %ax,%ax
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	f7 f7                	div    %edi
  801b9c:	31 ff                	xor    %edi,%edi
  801b9e:	89 fa                	mov    %edi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bad:	89 eb                	mov    %ebp,%ebx
  801baf:	29 fb                	sub    %edi,%ebx
  801bb1:	89 f9                	mov    %edi,%ecx
  801bb3:	d3 e6                	shl    %cl,%esi
  801bb5:	89 c5                	mov    %eax,%ebp
  801bb7:	88 d9                	mov    %bl,%cl
  801bb9:	d3 ed                	shr    %cl,%ebp
  801bbb:	89 e9                	mov    %ebp,%ecx
  801bbd:	09 f1                	or     %esi,%ecx
  801bbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bc3:	89 f9                	mov    %edi,%ecx
  801bc5:	d3 e0                	shl    %cl,%eax
  801bc7:	89 c5                	mov    %eax,%ebp
  801bc9:	89 d6                	mov    %edx,%esi
  801bcb:	88 d9                	mov    %bl,%cl
  801bcd:	d3 ee                	shr    %cl,%esi
  801bcf:	89 f9                	mov    %edi,%ecx
  801bd1:	d3 e2                	shl    %cl,%edx
  801bd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd7:	88 d9                	mov    %bl,%cl
  801bd9:	d3 e8                	shr    %cl,%eax
  801bdb:	09 c2                	or     %eax,%edx
  801bdd:	89 d0                	mov    %edx,%eax
  801bdf:	89 f2                	mov    %esi,%edx
  801be1:	f7 74 24 0c          	divl   0xc(%esp)
  801be5:	89 d6                	mov    %edx,%esi
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	f7 e5                	mul    %ebp
  801beb:	39 d6                	cmp    %edx,%esi
  801bed:	72 19                	jb     801c08 <__udivdi3+0xfc>
  801bef:	74 0b                	je     801bfc <__udivdi3+0xf0>
  801bf1:	89 d8                	mov    %ebx,%eax
  801bf3:	31 ff                	xor    %edi,%edi
  801bf5:	e9 58 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c00:	89 f9                	mov    %edi,%ecx
  801c02:	d3 e2                	shl    %cl,%edx
  801c04:	39 c2                	cmp    %eax,%edx
  801c06:	73 e9                	jae    801bf1 <__udivdi3+0xe5>
  801c08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c0b:	31 ff                	xor    %edi,%edi
  801c0d:	e9 40 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	31 c0                	xor    %eax,%eax
  801c16:	e9 37 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801c1b:	90                   	nop

00801c1c <__umoddi3>:
  801c1c:	55                   	push   %ebp
  801c1d:	57                   	push   %edi
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 1c             	sub    $0x1c,%esp
  801c23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c3b:	89 f3                	mov    %esi,%ebx
  801c3d:	89 fa                	mov    %edi,%edx
  801c3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c43:	89 34 24             	mov    %esi,(%esp)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	75 1a                	jne    801c64 <__umoddi3+0x48>
  801c4a:	39 f7                	cmp    %esi,%edi
  801c4c:	0f 86 a2 00 00 00    	jbe    801cf4 <__umoddi3+0xd8>
  801c52:	89 c8                	mov    %ecx,%eax
  801c54:	89 f2                	mov    %esi,%edx
  801c56:	f7 f7                	div    %edi
  801c58:	89 d0                	mov    %edx,%eax
  801c5a:	31 d2                	xor    %edx,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	39 f0                	cmp    %esi,%eax
  801c66:	0f 87 ac 00 00 00    	ja     801d18 <__umoddi3+0xfc>
  801c6c:	0f bd e8             	bsr    %eax,%ebp
  801c6f:	83 f5 1f             	xor    $0x1f,%ebp
  801c72:	0f 84 ac 00 00 00    	je     801d24 <__umoddi3+0x108>
  801c78:	bf 20 00 00 00       	mov    $0x20,%edi
  801c7d:	29 ef                	sub    %ebp,%edi
  801c7f:	89 fe                	mov    %edi,%esi
  801c81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c85:	89 e9                	mov    %ebp,%ecx
  801c87:	d3 e0                	shl    %cl,%eax
  801c89:	89 d7                	mov    %edx,%edi
  801c8b:	89 f1                	mov    %esi,%ecx
  801c8d:	d3 ef                	shr    %cl,%edi
  801c8f:	09 c7                	or     %eax,%edi
  801c91:	89 e9                	mov    %ebp,%ecx
  801c93:	d3 e2                	shl    %cl,%edx
  801c95:	89 14 24             	mov    %edx,(%esp)
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	d3 e0                	shl    %cl,%eax
  801c9c:	89 c2                	mov    %eax,%edx
  801c9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca2:	d3 e0                	shl    %cl,%eax
  801ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cac:	89 f1                	mov    %esi,%ecx
  801cae:	d3 e8                	shr    %cl,%eax
  801cb0:	09 d0                	or     %edx,%eax
  801cb2:	d3 eb                	shr    %cl,%ebx
  801cb4:	89 da                	mov    %ebx,%edx
  801cb6:	f7 f7                	div    %edi
  801cb8:	89 d3                	mov    %edx,%ebx
  801cba:	f7 24 24             	mull   (%esp)
  801cbd:	89 c6                	mov    %eax,%esi
  801cbf:	89 d1                	mov    %edx,%ecx
  801cc1:	39 d3                	cmp    %edx,%ebx
  801cc3:	0f 82 87 00 00 00    	jb     801d50 <__umoddi3+0x134>
  801cc9:	0f 84 91 00 00 00    	je     801d60 <__umoddi3+0x144>
  801ccf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cd3:	29 f2                	sub    %esi,%edx
  801cd5:	19 cb                	sbb    %ecx,%ebx
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cdd:	d3 e0                	shl    %cl,%eax
  801cdf:	89 e9                	mov    %ebp,%ecx
  801ce1:	d3 ea                	shr    %cl,%edx
  801ce3:	09 d0                	or     %edx,%eax
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 eb                	shr    %cl,%ebx
  801ce9:	89 da                	mov    %ebx,%edx
  801ceb:	83 c4 1c             	add    $0x1c,%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5e                   	pop    %esi
  801cf0:	5f                   	pop    %edi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    
  801cf3:	90                   	nop
  801cf4:	89 fd                	mov    %edi,%ebp
  801cf6:	85 ff                	test   %edi,%edi
  801cf8:	75 0b                	jne    801d05 <__umoddi3+0xe9>
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	31 d2                	xor    %edx,%edx
  801d01:	f7 f7                	div    %edi
  801d03:	89 c5                	mov    %eax,%ebp
  801d05:	89 f0                	mov    %esi,%eax
  801d07:	31 d2                	xor    %edx,%edx
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 c8                	mov    %ecx,%eax
  801d0d:	f7 f5                	div    %ebp
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	e9 44 ff ff ff       	jmp    801c5a <__umoddi3+0x3e>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	89 c8                	mov    %ecx,%eax
  801d1a:	89 f2                	mov    %esi,%edx
  801d1c:	83 c4 1c             	add    $0x1c,%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    
  801d24:	3b 04 24             	cmp    (%esp),%eax
  801d27:	72 06                	jb     801d2f <__umoddi3+0x113>
  801d29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d2d:	77 0f                	ja     801d3e <__umoddi3+0x122>
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	29 f9                	sub    %edi,%ecx
  801d33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d37:	89 14 24             	mov    %edx,(%esp)
  801d3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d42:	8b 14 24             	mov    (%esp),%edx
  801d45:	83 c4 1c             	add    $0x1c,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5f                   	pop    %edi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    
  801d4d:	8d 76 00             	lea    0x0(%esi),%esi
  801d50:	2b 04 24             	sub    (%esp),%eax
  801d53:	19 fa                	sbb    %edi,%edx
  801d55:	89 d1                	mov    %edx,%ecx
  801d57:	89 c6                	mov    %eax,%esi
  801d59:	e9 71 ff ff ff       	jmp    801ccf <__umoddi3+0xb3>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d64:	72 ea                	jb     801d50 <__umoddi3+0x134>
  801d66:	89 d9                	mov    %ebx,%ecx
  801d68:	e9 62 ff ff ff       	jmp    801ccf <__umoddi3+0xb3>
