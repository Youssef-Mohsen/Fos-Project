
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 b7 00 00 00       	call   8000ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];

	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 60 1d 80 00       	push   $0x801d60
  800057:	e8 37 0a 00 00       	call   800a93 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 8a 0e 00 00       	call   800efc <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("%@Fibonacci #%d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 7e 1d 80 00       	push   $0x801d7e
  80009a:	e8 8e 02 00 00       	call   80032d <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp

	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <fibonacci>:


int64 fibonacci(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
	if (n <= 1)
  8000aa:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ae:	7f 0c                	jg     8000bc <fibonacci+0x17>
		return 1 ;
  8000b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	eb 2a                	jmp    8000e6 <fibonacci+0x41>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bf:	48                   	dec    %eax
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	50                   	push   %eax
  8000c4:	e8 dc ff ff ff       	call   8000a5 <fibonacci>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d3:	83 e8 02             	sub    $0x2,%eax
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	50                   	push   %eax
  8000da:	e8 c6 ff ff ff       	call   8000a5 <fibonacci>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	01 d8                	add    %ebx,%eax
  8000e4:	11 f2                	adc    %esi,%edx
}
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000f3:	e8 93 14 00 00       	call   80158b <sys_getenvindex>
  8000f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	89 d0                	mov    %edx,%eax
  800100:	c1 e0 03             	shl    $0x3,%eax
  800103:	01 d0                	add    %edx,%eax
  800105:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80010c:	01 c8                	add    %ecx,%eax
  80010e:	01 c0                	add    %eax,%eax
  800110:	01 d0                	add    %edx,%eax
  800112:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800119:	01 c8                	add    %ecx,%eax
  80011b:	01 d0                	add    %edx,%eax
  80011d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800122:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800127:	a1 04 30 80 00       	mov    0x803004,%eax
  80012c:	8a 40 20             	mov    0x20(%eax),%al
  80012f:	84 c0                	test   %al,%al
  800131:	74 0d                	je     800140 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800133:	a1 04 30 80 00       	mov    0x803004,%eax
  800138:	83 c0 20             	add    $0x20,%eax
  80013b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800144:	7e 0a                	jle    800150 <libmain+0x63>
		binaryname = argv[0];
  800146:	8b 45 0c             	mov    0xc(%ebp),%eax
  800149:	8b 00                	mov    (%eax),%eax
  80014b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	e8 da fe ff ff       	call   800038 <_main>
  80015e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800161:	e8 a9 11 00 00       	call   80130f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 b0 1d 80 00       	push   $0x801db0
  80016e:	e8 8d 01 00 00       	call   800300 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800176:	a1 04 30 80 00       	mov    0x803004,%eax
  80017b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800181:	a1 04 30 80 00       	mov    0x803004,%eax
  800186:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	52                   	push   %edx
  800190:	50                   	push   %eax
  800191:	68 d8 1d 80 00       	push   $0x801dd8
  800196:	e8 65 01 00 00       	call   800300 <cprintf>
  80019b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80019e:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a3:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ae:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b9:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001bf:	51                   	push   %ecx
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	68 00 1e 80 00       	push   $0x801e00
  8001c7:	e8 34 01 00 00       	call   800300 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 58 1e 80 00       	push   $0x801e58
  8001e3:	e8 18 01 00 00       	call   800300 <cprintf>
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 b0 1d 80 00       	push   $0x801db0
  8001f3:	e8 08 01 00 00       	call   800300 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001fb:	e8 29 11 00 00       	call   801329 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800200:	e8 19 00 00 00       	call   80021e <exit>
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	6a 00                	push   $0x0
  800213:	e8 3f 13 00 00       	call   801557 <sys_destroy_env>
  800218:	83 c4 10             	add    $0x10,%esp
}
  80021b:	90                   	nop
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <exit>:

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800224:	e8 94 13 00 00       	call   8015bd <sys_exit_env>
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800232:	8b 45 0c             	mov    0xc(%ebp),%eax
  800235:	8b 00                	mov    (%eax),%eax
  800237:	8d 48 01             	lea    0x1(%eax),%ecx
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	89 0a                	mov    %ecx,(%edx)
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	88 d1                	mov    %dl,%cl
  800244:	8b 55 0c             	mov    0xc(%ebp),%edx
  800247:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	8b 00                	mov    (%eax),%eax
  800250:	3d ff 00 00 00       	cmp    $0xff,%eax
  800255:	75 2c                	jne    800283 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800257:	a0 08 30 80 00       	mov    0x803008,%al
  80025c:	0f b6 c0             	movzbl %al,%eax
  80025f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800262:	8b 12                	mov    (%edx),%edx
  800264:	89 d1                	mov    %edx,%ecx
  800266:	8b 55 0c             	mov    0xc(%ebp),%edx
  800269:	83 c2 08             	add    $0x8,%edx
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	50                   	push   %eax
  800270:	51                   	push   %ecx
  800271:	52                   	push   %edx
  800272:	e8 56 10 00 00       	call   8012cd <sys_cputs>
  800277:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8b 40 04             	mov    0x4(%eax),%eax
  800289:	8d 50 01             	lea    0x1(%eax),%edx
  80028c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800292:	90                   	nop
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a5:	00 00 00 
	b.cnt = 0;
  8002a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	68 2c 02 80 00       	push   $0x80022c
  8002c4:	e8 11 02 00 00       	call   8004da <vprintfmt>
  8002c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002cc:	a0 08 30 80 00       	mov    0x803008,%al
  8002d1:	0f b6 c0             	movzbl %al,%eax
  8002d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	50                   	push   %eax
  8002de:	52                   	push   %edx
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	83 c0 08             	add    $0x8,%eax
  8002e8:	50                   	push   %eax
  8002e9:	e8 df 0f 00 00       	call   8012cd <sys_cputs>
  8002ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800306:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800310:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	ff 75 f4             	pushl  -0xc(%ebp)
  80031c:	50                   	push   %eax
  80031d:	e8 73 ff ff ff       	call   800295 <vcprintf>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800333:	e8 d7 0f 00 00       	call   80130f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800338:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 48 ff ff ff       	call   800295 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800353:	e8 d1 0f 00 00       	call   801329 <sys_unlock_cons>
	return cnt;
  800358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	53                   	push   %ebx
  800361:	83 ec 14             	sub    $0x14,%esp
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80036a:	8b 45 14             	mov    0x14(%ebp),%eax
  80036d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800370:	8b 45 18             	mov    0x18(%ebp),%eax
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037b:	77 55                	ja     8003d2 <printnum+0x75>
  80037d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800380:	72 05                	jb     800387 <printnum+0x2a>
  800382:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800385:	77 4b                	ja     8003d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800387:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80038a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80038d:	8b 45 18             	mov    0x18(%ebp),%eax
  800390:	ba 00 00 00 00       	mov    $0x0,%edx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	ff 75 f4             	pushl  -0xc(%ebp)
  80039a:	ff 75 f0             	pushl  -0x10(%ebp)
  80039d:	e8 4e 17 00 00       	call   801af0 <__udivdi3>
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	ff 75 20             	pushl  0x20(%ebp)
  8003ab:	53                   	push   %ebx
  8003ac:	ff 75 18             	pushl  0x18(%ebp)
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	e8 a1 ff ff ff       	call   80035d <printnum>
  8003bc:	83 c4 20             	add    $0x20,%esp
  8003bf:	eb 1a                	jmp    8003db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	ff 75 20             	pushl  0x20(%ebp)
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	ff d0                	call   *%eax
  8003cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d9:	7f e6                	jg     8003c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e9:	53                   	push   %ebx
  8003ea:	51                   	push   %ecx
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	e8 0e 18 00 00       	call   801c00 <__umoddi3>
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	05 94 20 80 00       	add    $0x802094,%eax
  8003fa:	8a 00                	mov    (%eax),%al
  8003fc:	0f be c0             	movsbl %al,%eax
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	50                   	push   %eax
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	ff d0                	call   *%eax
  80040b:	83 c4 10             	add    $0x10,%esp
}
  80040e:	90                   	nop
  80040f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800417:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041b:	7e 1c                	jle    800439 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	8d 50 08             	lea    0x8(%eax),%edx
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	89 10                	mov    %edx,(%eax)
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	83 e8 08             	sub    $0x8,%eax
  800432:	8b 50 04             	mov    0x4(%eax),%edx
  800435:	8b 00                	mov    (%eax),%eax
  800437:	eb 40                	jmp    800479 <getuint+0x65>
	else if (lflag)
  800439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043d:	74 1e                	je     80045d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	8d 50 04             	lea    0x4(%eax),%edx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	89 10                	mov    %edx,(%eax)
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	83 e8 04             	sub    $0x4,%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	ba 00 00 00 00       	mov    $0x0,%edx
  80045b:	eb 1c                	jmp    800479 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 50 04             	lea    0x4(%eax),%edx
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	89 10                	mov    %edx,(%eax)
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	83 e8 04             	sub    $0x4,%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    

0080047b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800482:	7e 1c                	jle    8004a0 <getint+0x25>
		return va_arg(*ap, long long);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	8d 50 08             	lea    0x8(%eax),%edx
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	89 10                	mov    %edx,(%eax)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 e8 08             	sub    $0x8,%eax
  800499:	8b 50 04             	mov    0x4(%eax),%edx
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	eb 38                	jmp    8004d8 <getint+0x5d>
	else if (lflag)
  8004a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a4:	74 1a                	je     8004c0 <getint+0x45>
		return va_arg(*ap, long);
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	8d 50 04             	lea    0x4(%eax),%edx
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 10                	mov    %edx,(%eax)
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	83 e8 04             	sub    $0x4,%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	99                   	cltd   
  8004be:	eb 18                	jmp    8004d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 50 04             	lea    0x4(%eax),%edx
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	89 10                	mov    %edx,(%eax)
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	83 e8 04             	sub    $0x4,%eax
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	99                   	cltd   
}
  8004d8:	5d                   	pop    %ebp
  8004d9:	c3                   	ret    

008004da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	56                   	push   %esi
  8004de:	53                   	push   %ebx
  8004df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e2:	eb 17                	jmp    8004fb <vprintfmt+0x21>
			if (ch == '\0')
  8004e4:	85 db                	test   %ebx,%ebx
  8004e6:	0f 84 c1 03 00 00    	je     8008ad <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 0c             	pushl  0xc(%ebp)
  8004f2:	53                   	push   %ebx
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	ff d0                	call   *%eax
  8004f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fe:	8d 50 01             	lea    0x1(%eax),%edx
  800501:	89 55 10             	mov    %edx,0x10(%ebp)
  800504:	8a 00                	mov    (%eax),%al
  800506:	0f b6 d8             	movzbl %al,%ebx
  800509:	83 fb 25             	cmp    $0x25,%ebx
  80050c:	75 d6                	jne    8004e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800512:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800519:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800520:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800527:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 45 10             	mov    0x10(%ebp),%eax
  800531:	8d 50 01             	lea    0x1(%eax),%edx
  800534:	89 55 10             	mov    %edx,0x10(%ebp)
  800537:	8a 00                	mov    (%eax),%al
  800539:	0f b6 d8             	movzbl %al,%ebx
  80053c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80053f:	83 f8 5b             	cmp    $0x5b,%eax
  800542:	0f 87 3d 03 00 00    	ja     800885 <vprintfmt+0x3ab>
  800548:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  80054f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800551:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800555:	eb d7                	jmp    80052e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800557:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80055b:	eb d1                	jmp    80052e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800564:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	c1 e0 02             	shl    $0x2,%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d8                	add    %ebx,%eax
  800572:	83 e8 30             	sub    $0x30,%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800578:	8b 45 10             	mov    0x10(%ebp),%eax
  80057b:	8a 00                	mov    (%eax),%al
  80057d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800580:	83 fb 2f             	cmp    $0x2f,%ebx
  800583:	7e 3e                	jle    8005c3 <vprintfmt+0xe9>
  800585:	83 fb 39             	cmp    $0x39,%ebx
  800588:	7f 39                	jg     8005c3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80058d:	eb d5                	jmp    800564 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	83 c0 04             	add    $0x4,%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	83 e8 04             	sub    $0x4,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a3:	eb 1f                	jmp    8005c4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a9:	79 83                	jns    80052e <vprintfmt+0x54>
				width = 0;
  8005ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b2:	e9 77 ff ff ff       	jmp    80052e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005be:	e9 6b ff ff ff       	jmp    80052e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c8:	0f 89 60 ff ff ff    	jns    80052e <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005db:	e9 4e ff ff ff       	jmp    80052e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e3:	e9 46 ff ff ff       	jmp    80052e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 c0 04             	add    $0x4,%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
			break;
  800608:	e9 9b 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	83 c0 04             	add    $0x4,%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	83 e8 04             	sub    $0x4,%eax
  80061c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80061e:	85 db                	test   %ebx,%ebx
  800620:	79 02                	jns    800624 <vprintfmt+0x14a>
				err = -err;
  800622:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800624:	83 fb 64             	cmp    $0x64,%ebx
  800627:	7f 0b                	jg     800634 <vprintfmt+0x15a>
  800629:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  800630:	85 f6                	test   %esi,%esi
  800632:	75 19                	jne    80064d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800634:	53                   	push   %ebx
  800635:	68 a5 20 80 00       	push   $0x8020a5
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	ff 75 08             	pushl  0x8(%ebp)
  800640:	e8 70 02 00 00       	call   8008b5 <printfmt>
  800645:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800648:	e9 5b 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80064d:	56                   	push   %esi
  80064e:	68 ae 20 80 00       	push   $0x8020ae
  800653:	ff 75 0c             	pushl  0xc(%ebp)
  800656:	ff 75 08             	pushl  0x8(%ebp)
  800659:	e8 57 02 00 00       	call   8008b5 <printfmt>
  80065e:	83 c4 10             	add    $0x10,%esp
			break;
  800661:	e9 42 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	83 c0 04             	add    $0x4,%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 30                	mov    (%eax),%esi
  800677:	85 f6                	test   %esi,%esi
  800679:	75 05                	jne    800680 <vprintfmt+0x1a6>
				p = "(null)";
  80067b:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800684:	7e 6d                	jle    8006f3 <vprintfmt+0x219>
  800686:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80068a:	74 67                	je     8006f3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	56                   	push   %esi
  800694:	e8 26 05 00 00       	call   800bbf <strnlen>
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80069f:	eb 16                	jmp    8006b7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bb:	7f e4                	jg     8006a1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bd:	eb 34                	jmp    8006f3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c3:	74 1c                	je     8006e1 <vprintfmt+0x207>
  8006c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c8:	7e 05                	jle    8006cf <vprintfmt+0x1f5>
  8006ca:	83 fb 7e             	cmp    $0x7e,%ebx
  8006cd:	7e 12                	jle    8006e1 <vprintfmt+0x207>
					putch('?', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	6a 3f                	push   $0x3f
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	eb 0f                	jmp    8006f0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	53                   	push   %ebx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	8d 70 01             	lea    0x1(%eax),%esi
  8006f8:	8a 00                	mov    (%eax),%al
  8006fa:	0f be d8             	movsbl %al,%ebx
  8006fd:	85 db                	test   %ebx,%ebx
  8006ff:	74 24                	je     800725 <vprintfmt+0x24b>
  800701:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800705:	78 b8                	js     8006bf <vprintfmt+0x1e5>
  800707:	ff 4d e0             	decl   -0x20(%ebp)
  80070a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070e:	79 af                	jns    8006bf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800710:	eb 13                	jmp    800725 <vprintfmt+0x24b>
				putch(' ', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 20                	push   $0x20
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800722:	ff 4d e4             	decl   -0x1c(%ebp)
  800725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800729:	7f e7                	jg     800712 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80072b:	e9 78 01 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 e8             	pushl  -0x18(%ebp)
  800736:	8d 45 14             	lea    0x14(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	e8 3c fd ff ff       	call   80047b <getint>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800745:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074e:	85 d2                	test   %edx,%edx
  800750:	79 23                	jns    800775 <vprintfmt+0x29b>
				putch('-', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	6a 2d                	push   $0x2d
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	f7 d8                	neg    %eax
  80076a:	83 d2 00             	adc    $0x0,%edx
  80076d:	f7 da                	neg    %edx
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800772:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800775:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077c:	e9 bc 00 00 00       	jmp    80083d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 84 fc ff ff       	call   800414 <getuint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800799:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a0:	e9 98 00 00 00       	jmp    80083d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	6a 58                	push   $0x58
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	ff d0                	call   *%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 58                	push   $0x58
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	6a 58                	push   $0x58
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			break;
  8007d5:	e9 ce 00 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 30                	push   $0x30
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 78                	push   $0x78
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	83 c0 04             	add    $0x4,%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	83 e8 04             	sub    $0x4,%eax
  800809:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800815:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80081c:	eb 1f                	jmp    80083d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 e8             	pushl  -0x18(%ebp)
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	50                   	push   %eax
  800828:	e8 e7 fb ff ff       	call   800414 <getuint>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800833:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800836:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80083d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	83 ec 04             	sub    $0x4,%esp
  800847:	52                   	push   %edx
  800848:	ff 75 e4             	pushl  -0x1c(%ebp)
  80084b:	50                   	push   %eax
  80084c:	ff 75 f4             	pushl  -0xc(%ebp)
  80084f:	ff 75 f0             	pushl  -0x10(%ebp)
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 00 fb ff ff       	call   80035d <printnum>
  80085d:	83 c4 20             	add    $0x20,%esp
			break;
  800860:	eb 46                	jmp    8008a8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	53                   	push   %ebx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	eb 35                	jmp    8008a8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800873:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80087a:	eb 2c                	jmp    8008a8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80087c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800883:	eb 23                	jmp    8008a8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	6a 25                	push   $0x25
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800895:	ff 4d 10             	decl   0x10(%ebp)
  800898:	eb 03                	jmp    80089d <vprintfmt+0x3c3>
  80089a:	ff 4d 10             	decl   0x10(%ebp)
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	48                   	dec    %eax
  8008a1:	8a 00                	mov    (%eax),%al
  8008a3:	3c 25                	cmp    $0x25,%al
  8008a5:	75 f3                	jne    80089a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008a7:	90                   	nop
		}
	}
  8008a8:	e9 35 fc ff ff       	jmp    8004e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ad:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 04 fc ff ff       	call   8004da <vprintfmt>
  8008d6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d9:	90                   	nop
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	8b 40 08             	mov    0x8(%eax),%eax
  8008e5:	8d 50 01             	lea    0x1(%eax),%edx
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	8b 10                	mov    (%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	8b 40 04             	mov    0x4(%eax),%eax
  8008f9:	39 c2                	cmp    %eax,%edx
  8008fb:	73 12                	jae    80090f <sprintputch+0x33>
		*b->buf++ = ch;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 48 01             	lea    0x1(%eax),%ecx
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
  800908:	89 0a                	mov    %ecx,(%edx)
  80090a:	8b 55 08             	mov    0x8(%ebp),%edx
  80090d:	88 10                	mov    %dl,(%eax)
}
  80090f:	90                   	nop
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	8d 50 ff             	lea    -0x1(%eax),%edx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800933:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800937:	74 06                	je     80093f <vsnprintf+0x2d>
  800939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093d:	7f 07                	jg     800946 <vsnprintf+0x34>
		return -E_INVAL;
  80093f:	b8 03 00 00 00       	mov    $0x3,%eax
  800944:	eb 20                	jmp    800966 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800946:	ff 75 14             	pushl  0x14(%ebp)
  800949:	ff 75 10             	pushl  0x10(%ebp)
  80094c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094f:	50                   	push   %eax
  800950:	68 dc 08 80 00       	push   $0x8008dc
  800955:	e8 80 fb ff ff       	call   8004da <vprintfmt>
  80095a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80095d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800960:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096e:	8d 45 10             	lea    0x10(%ebp),%eax
  800971:	83 c0 04             	add    $0x4,%eax
  800974:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800977:	8b 45 10             	mov    0x10(%ebp),%eax
  80097a:	ff 75 f4             	pushl  -0xc(%ebp)
  80097d:	50                   	push   %eax
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 89 ff ff ff       	call   800912 <vsnprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80099a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80099e:	74 13                	je     8009b3 <readline+0x1f>
		cprintf("%s", prompt);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 08             	pushl  0x8(%ebp)
  8009a6:	68 28 22 80 00       	push   $0x802228
  8009ab:	e8 50 f9 ff ff       	call   800300 <cprintf>
  8009b0:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	6a 00                	push   $0x0
  8009bf:	e8 39 0f 00 00       	call   8018fd <iscons>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009ca:	e8 1b 0f 00 00       	call   8018ea <getchar>
  8009cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009d6:	79 22                	jns    8009fa <readline+0x66>
			if (c != -E_EOF)
  8009d8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009dc:	0f 84 ad 00 00 00    	je     800a8f <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e8:	68 2b 22 80 00       	push   $0x80222b
  8009ed:	e8 0e f9 ff ff       	call   800300 <cprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
			break;
  8009f5:	e9 95 00 00 00       	jmp    800a8f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009fa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009fe:	7e 34                	jle    800a34 <readline+0xa0>
  800a00:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a07:	7f 2b                	jg     800a34 <readline+0xa0>
			if (echoing)
  800a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a0d:	74 0e                	je     800a1d <readline+0x89>
				cputchar(c);
  800a0f:	83 ec 0c             	sub    $0xc,%esp
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	e8 b1 0e 00 00       	call   8018cb <cputchar>
  800a1a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a20:	8d 50 01             	lea    0x1(%eax),%edx
  800a23:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	01 d0                	add    %edx,%eax
  800a2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a30:	88 10                	mov    %dl,(%eax)
  800a32:	eb 56                	jmp    800a8a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a34:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a38:	75 1f                	jne    800a59 <readline+0xc5>
  800a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a3e:	7e 19                	jle    800a59 <readline+0xc5>
			if (echoing)
  800a40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a44:	74 0e                	je     800a54 <readline+0xc0>
				cputchar(c);
  800a46:	83 ec 0c             	sub    $0xc,%esp
  800a49:	ff 75 ec             	pushl  -0x14(%ebp)
  800a4c:	e8 7a 0e 00 00       	call   8018cb <cputchar>
  800a51:	83 c4 10             	add    $0x10,%esp

			i--;
  800a54:	ff 4d f4             	decl   -0xc(%ebp)
  800a57:	eb 31                	jmp    800a8a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a59:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a5d:	74 0a                	je     800a69 <readline+0xd5>
  800a5f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a63:	0f 85 61 ff ff ff    	jne    8009ca <readline+0x36>
			if (echoing)
  800a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a6d:	74 0e                	je     800a7d <readline+0xe9>
				cputchar(c);
  800a6f:	83 ec 0c             	sub    $0xc,%esp
  800a72:	ff 75 ec             	pushl  -0x14(%ebp)
  800a75:	e8 51 0e 00 00       	call   8018cb <cputchar>
  800a7a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a88:	eb 06                	jmp    800a90 <readline+0xfc>
		}
	}
  800a8a:	e9 3b ff ff ff       	jmp    8009ca <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a8f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a90:	90                   	nop
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a99:	e8 71 08 00 00       	call   80130f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa2:	74 13                	je     800ab7 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	68 28 22 80 00       	push   $0x802228
  800aaf:	e8 4c f8 ff ff       	call   800300 <cprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800ab7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800abe:	83 ec 0c             	sub    $0xc,%esp
  800ac1:	6a 00                	push   $0x0
  800ac3:	e8 35 0e 00 00       	call   8018fd <iscons>
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ace:	e8 17 0e 00 00       	call   8018ea <getchar>
  800ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ad6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ada:	79 22                	jns    800afe <atomic_readline+0x6b>
				if (c != -E_EOF)
  800adc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ae0:	0f 84 ad 00 00 00    	je     800b93 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	ff 75 ec             	pushl  -0x14(%ebp)
  800aec:	68 2b 22 80 00       	push   $0x80222b
  800af1:	e8 0a f8 ff ff       	call   800300 <cprintf>
  800af6:	83 c4 10             	add    $0x10,%esp
				break;
  800af9:	e9 95 00 00 00       	jmp    800b93 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800afe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b02:	7e 34                	jle    800b38 <atomic_readline+0xa5>
  800b04:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b0b:	7f 2b                	jg     800b38 <atomic_readline+0xa5>
				if (echoing)
  800b0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b11:	74 0e                	je     800b21 <atomic_readline+0x8e>
					cputchar(c);
  800b13:	83 ec 0c             	sub    $0xc,%esp
  800b16:	ff 75 ec             	pushl  -0x14(%ebp)
  800b19:	e8 ad 0d 00 00       	call   8018cb <cputchar>
  800b1e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b24:	8d 50 01             	lea    0x1(%eax),%edx
  800b27:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	01 d0                	add    %edx,%eax
  800b31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b34:	88 10                	mov    %dl,(%eax)
  800b36:	eb 56                	jmp    800b8e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b38:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b3c:	75 1f                	jne    800b5d <atomic_readline+0xca>
  800b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b42:	7e 19                	jle    800b5d <atomic_readline+0xca>
				if (echoing)
  800b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b48:	74 0e                	je     800b58 <atomic_readline+0xc5>
					cputchar(c);
  800b4a:	83 ec 0c             	sub    $0xc,%esp
  800b4d:	ff 75 ec             	pushl  -0x14(%ebp)
  800b50:	e8 76 0d 00 00       	call   8018cb <cputchar>
  800b55:	83 c4 10             	add    $0x10,%esp
				i--;
  800b58:	ff 4d f4             	decl   -0xc(%ebp)
  800b5b:	eb 31                	jmp    800b8e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b5d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b61:	74 0a                	je     800b6d <atomic_readline+0xda>
  800b63:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b67:	0f 85 61 ff ff ff    	jne    800ace <atomic_readline+0x3b>
				if (echoing)
  800b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b71:	74 0e                	je     800b81 <atomic_readline+0xee>
					cputchar(c);
  800b73:	83 ec 0c             	sub    $0xc,%esp
  800b76:	ff 75 ec             	pushl  -0x14(%ebp)
  800b79:	e8 4d 0d 00 00       	call   8018cb <cputchar>
  800b7e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b8c:	eb 06                	jmp    800b94 <atomic_readline+0x101>
			}
		}
  800b8e:	e9 3b ff ff ff       	jmp    800ace <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b93:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b94:	e8 90 07 00 00       	call   801329 <sys_unlock_cons>
}
  800b99:	90                   	nop
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba9:	eb 06                	jmp    800bb1 <strlen+0x15>
		n++;
  800bab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bae:	ff 45 08             	incl   0x8(%ebp)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8a 00                	mov    (%eax),%al
  800bb6:	84 c0                	test   %al,%al
  800bb8:	75 f1                	jne    800bab <strlen+0xf>
		n++;
	return n;
  800bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcc:	eb 09                	jmp    800bd7 <strnlen+0x18>
		n++;
  800bce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd1:	ff 45 08             	incl   0x8(%ebp)
  800bd4:	ff 4d 0c             	decl   0xc(%ebp)
  800bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdb:	74 09                	je     800be6 <strnlen+0x27>
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e8                	jne    800bce <strnlen+0xf>
		n++;
	return n;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf7:	90                   	nop
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8d 50 01             	lea    0x1(%eax),%edx
  800bfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c0a:	8a 12                	mov    (%edx),%dl
  800c0c:	88 10                	mov    %dl,(%eax)
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	84 c0                	test   %al,%al
  800c12:	75 e4                	jne    800bf8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 1f                	jmp    800c4d <strncpy+0x34>
		*dst++ = *src;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 08             	mov    %edx,0x8(%ebp)
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	8a 12                	mov    (%edx),%dl
  800c3c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	74 03                	je     800c4a <strncpy+0x31>
			src++;
  800c47:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4a:	ff 45 fc             	incl   -0x4(%ebp)
  800c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c50:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c53:	72 d9                	jb     800c2e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	74 30                	je     800c9c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c6c:	eb 16                	jmp    800c84 <strlcpy+0x2a>
			*dst++ = *src++;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8d 50 01             	lea    0x1(%eax),%edx
  800c74:	89 55 08             	mov    %edx,0x8(%ebp)
  800c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c80:	8a 12                	mov    (%edx),%dl
  800c82:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c84:	ff 4d 10             	decl   0x10(%ebp)
  800c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8b:	74 09                	je     800c96 <strlcpy+0x3c>
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 d8                	jne    800c6e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	29 c2                	sub    %eax,%edx
  800ca4:	89 d0                	mov    %edx,%eax
}
  800ca6:	c9                   	leave  
  800ca7:	c3                   	ret    

00800ca8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cab:	eb 06                	jmp    800cb3 <strcmp+0xb>
		p++, q++;
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	74 0e                	je     800cca <strcmp+0x22>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 10                	mov    (%eax),%dl
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	38 c2                	cmp    %al,%dl
  800cc8:	74 e3                	je     800cad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 d0             	movzbl %al,%edx
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	29 c2                	sub    %eax,%edx
  800cdc:	89 d0                	mov    %edx,%eax
}
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce3:	eb 09                	jmp    800cee <strncmp+0xe>
		n--, p++, q++;
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf2:	74 17                	je     800d0b <strncmp+0x2b>
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	84 c0                	test   %al,%al
  800cfb:	74 0e                	je     800d0b <strncmp+0x2b>
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 10                	mov    (%eax),%dl
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	38 c2                	cmp    %al,%dl
  800d09:	74 da                	je     800ce5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0f:	75 07                	jne    800d18 <strncmp+0x38>
		return 0;
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	eb 14                	jmp    800d2c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	29 c2                	sub    %eax,%edx
  800d2a:	89 d0                	mov    %edx,%eax
}
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d3a:	eb 12                	jmp    800d4e <strchr+0x20>
		if (*s == c)
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d44:	75 05                	jne    800d4b <strchr+0x1d>
			return (char *) s;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	eb 11                	jmp    800d5c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	75 e5                	jne    800d3c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d6a:	eb 0d                	jmp    800d79 <strfind+0x1b>
		if (*s == c)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d74:	74 0e                	je     800d84 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 ea                	jne    800d6c <strfind+0xe>
  800d82:	eb 01                	jmp    800d85 <strfind+0x27>
		if (*s == c)
			break;
  800d84:	90                   	nop
	return (char *) s;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d9c:	eb 0e                	jmp    800dac <memset+0x22>
		*p++ = c;
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dac:	ff 4d f8             	decl   -0x8(%ebp)
  800daf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db3:	79 e9                	jns    800d9e <memset+0x14>
		*p++ = c;

	return v;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dcc:	eb 16                	jmp    800de4 <memcpy+0x2a>
		*d++ = *s++;
  800dce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ddd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de0:	8a 12                	mov    (%edx),%dl
  800de2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dea:	89 55 10             	mov    %edx,0x10(%ebp)
  800ded:	85 c0                	test   %eax,%eax
  800def:	75 dd                	jne    800dce <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0e:	73 50                	jae    800e60 <memmove+0x6a>
  800e10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	01 d0                	add    %edx,%eax
  800e18:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1b:	76 43                	jbe    800e60 <memmove+0x6a>
		s += n;
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e29:	eb 10                	jmp    800e3b <memmove+0x45>
			*--d = *--s;
  800e2b:	ff 4d f8             	decl   -0x8(%ebp)
  800e2e:	ff 4d fc             	decl   -0x4(%ebp)
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	8a 10                	mov    (%eax),%dl
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 e3                	jne    800e2b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e48:	eb 23                	jmp    800e6d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4d:	8d 50 01             	lea    0x1(%eax),%edx
  800e50:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e59:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e5c:	8a 12                	mov    (%edx),%dl
  800e5e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e66:	89 55 10             	mov    %edx,0x10(%ebp)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	75 dd                	jne    800e4a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e84:	eb 2a                	jmp    800eb0 <memcmp+0x3e>
		if (*s1 != *s2)
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	8a 10                	mov    (%eax),%dl
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	38 c2                	cmp    %al,%dl
  800e92:	74 16                	je     800eaa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	0f b6 d0             	movzbl %al,%edx
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	0f b6 c0             	movzbl %al,%eax
  800ea4:	29 c2                	sub    %eax,%edx
  800ea6:	89 d0                	mov    %edx,%eax
  800ea8:	eb 18                	jmp    800ec2 <memcmp+0x50>
		s1++, s2++;
  800eaa:	ff 45 fc             	incl   -0x4(%ebp)
  800ead:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 c9                	jne    800e86 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	01 d0                	add    %edx,%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed5:	eb 15                	jmp    800eec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	0f b6 d0             	movzbl %al,%edx
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	0f b6 c0             	movzbl %al,%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	74 0d                	je     800ef6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef2:	72 e3                	jb     800ed7 <memfind+0x13>
  800ef4:	eb 01                	jmp    800ef7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ef6:	90                   	nop
	return (void *) s;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f10:	eb 03                	jmp    800f15 <strtol+0x19>
		s++;
  800f12:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	3c 20                	cmp    $0x20,%al
  800f1c:	74 f4                	je     800f12 <strtol+0x16>
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 09                	cmp    $0x9,%al
  800f25:	74 eb                	je     800f12 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 2b                	cmp    $0x2b,%al
  800f2e:	75 05                	jne    800f35 <strtol+0x39>
		s++;
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	eb 13                	jmp    800f48 <strtol+0x4c>
	else if (*s == '-')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 2d                	cmp    $0x2d,%al
  800f3c:	75 0a                	jne    800f48 <strtol+0x4c>
		s++, neg = 1;
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 06                	je     800f54 <strtol+0x58>
  800f4e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f52:	75 20                	jne    800f74 <strtol+0x78>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	3c 30                	cmp    $0x30,%al
  800f5b:	75 17                	jne    800f74 <strtol+0x78>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	40                   	inc    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 78                	cmp    $0x78,%al
  800f65:	75 0d                	jne    800f74 <strtol+0x78>
		s += 2, base = 16;
  800f67:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f6b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f72:	eb 28                	jmp    800f9c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f78:	75 15                	jne    800f8f <strtol+0x93>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 30                	cmp    $0x30,%al
  800f81:	75 0c                	jne    800f8f <strtol+0x93>
		s++, base = 8;
  800f83:	ff 45 08             	incl   0x8(%ebp)
  800f86:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f8d:	eb 0d                	jmp    800f9c <strtol+0xa0>
	else if (base == 0)
  800f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f93:	75 07                	jne    800f9c <strtol+0xa0>
		base = 10;
  800f95:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	3c 2f                	cmp    $0x2f,%al
  800fa3:	7e 19                	jle    800fbe <strtol+0xc2>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	3c 39                	cmp    $0x39,%al
  800fac:	7f 10                	jg     800fbe <strtol+0xc2>
			dig = *s - '0';
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f be c0             	movsbl %al,%eax
  800fb6:	83 e8 30             	sub    $0x30,%eax
  800fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbc:	eb 42                	jmp    801000 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 60                	cmp    $0x60,%al
  800fc5:	7e 19                	jle    800fe0 <strtol+0xe4>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	3c 7a                	cmp    $0x7a,%al
  800fce:	7f 10                	jg     800fe0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	0f be c0             	movsbl %al,%eax
  800fd8:	83 e8 57             	sub    $0x57,%eax
  800fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fde:	eb 20                	jmp    801000 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 40                	cmp    $0x40,%al
  800fe7:	7e 39                	jle    801022 <strtol+0x126>
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 5a                	cmp    $0x5a,%al
  800ff0:	7f 30                	jg     801022 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f be c0             	movsbl %al,%eax
  800ffa:	83 e8 37             	sub    $0x37,%eax
  800ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801003:	3b 45 10             	cmp    0x10(%ebp),%eax
  801006:	7d 19                	jge    801021 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801012:	89 c2                	mov    %eax,%edx
  801014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80101c:	e9 7b ff ff ff       	jmp    800f9c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801021:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801022:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801026:	74 08                	je     801030 <strtol+0x134>
		*endptr = (char *) s;
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801030:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801034:	74 07                	je     80103d <strtol+0x141>
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	f7 d8                	neg    %eax
  80103b:	eb 03                	jmp    801040 <strtol+0x144>
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <ltostr>:

void
ltostr(long value, char *str)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80104f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80105a:	79 13                	jns    80106f <ltostr+0x2d>
	{
		neg = 1;
  80105c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801069:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80106c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801077:	99                   	cltd   
  801078:	f7 f9                	idiv   %ecx
  80107a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	89 c2                	mov    %eax,%edx
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801090:	83 c2 30             	add    $0x30,%edx
  801093:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801095:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801098:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109d:	f7 e9                	imul   %ecx
  80109f:	c1 fa 02             	sar    $0x2,%edx
  8010a2:	89 c8                	mov    %ecx,%eax
  8010a4:	c1 f8 1f             	sar    $0x1f,%eax
  8010a7:	29 c2                	sub    %eax,%edx
  8010a9:	89 d0                	mov    %edx,%eax
  8010ab:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b2:	75 bb                	jne    80106f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010be:	48                   	dec    %eax
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c6:	74 3d                	je     801105 <ltostr+0xc3>
		start = 1 ;
  8010c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010cf:	eb 34                	jmp    801105 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 c2                	add    %eax,%edx
  8010e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	01 c8                	add    %ecx,%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010fd:	88 02                	mov    %al,(%edx)
		start++ ;
  8010ff:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801102:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801108:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110b:	7c c4                	jl     8010d1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80110d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801121:	ff 75 08             	pushl  0x8(%ebp)
  801124:	e8 73 fa ff ff       	call   800b9c <strlen>
  801129:	83 c4 04             	add    $0x4,%esp
  80112c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	e8 65 fa ff ff       	call   800b9c <strlen>
  801137:	83 c4 04             	add    $0x4,%esp
  80113a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80113d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80114b:	eb 17                	jmp    801164 <strcconcat+0x49>
		final[s] = str1[s] ;
  80114d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801161:	ff 45 fc             	incl   -0x4(%ebp)
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80116a:	7c e1                	jl     80114d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80116c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801173:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80117a:	eb 1f                	jmp    80119b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80117c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801185:	89 c2                	mov    %eax,%edx
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	01 c2                	add    %eax,%edx
  80118c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	01 c8                	add    %ecx,%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801198:	ff 45 f8             	incl   -0x8(%ebp)
  80119b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a1:	7c d9                	jl     80117c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a9:	01 d0                	add    %edx,%eax
  8011ab:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c0:	8b 00                	mov    (%eax),%eax
  8011c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	01 d0                	add    %edx,%eax
  8011ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d4:	eb 0c                	jmp    8011e2 <strsplit+0x31>
			*string++ = 0;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8d 50 01             	lea    0x1(%eax),%edx
  8011dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8011df:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 18                	je     801203 <strsplit+0x52>
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	0f be c0             	movsbl %al,%eax
  8011f3:	50                   	push   %eax
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	e8 32 fb ff ff       	call   800d2e <strchr>
  8011fc:	83 c4 08             	add    $0x8,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	75 d3                	jne    8011d6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	84 c0                	test   %al,%al
  80120a:	74 5a                	je     801266 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80120c:	8b 45 14             	mov    0x14(%ebp),%eax
  80120f:	8b 00                	mov    (%eax),%eax
  801211:	83 f8 0f             	cmp    $0xf,%eax
  801214:	75 07                	jne    80121d <strsplit+0x6c>
		{
			return 0;
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
  80121b:	eb 66                	jmp    801283 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80121d:	8b 45 14             	mov    0x14(%ebp),%eax
  801220:	8b 00                	mov    (%eax),%eax
  801222:	8d 48 01             	lea    0x1(%eax),%ecx
  801225:	8b 55 14             	mov    0x14(%ebp),%edx
  801228:	89 0a                	mov    %ecx,(%edx)
  80122a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	01 c2                	add    %eax,%edx
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123b:	eb 03                	jmp    801240 <strsplit+0x8f>
			string++;
  80123d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	84 c0                	test   %al,%al
  801247:	74 8b                	je     8011d4 <strsplit+0x23>
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	0f be c0             	movsbl %al,%eax
  801251:	50                   	push   %eax
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 d4 fa ff ff       	call   800d2e <strchr>
  80125a:	83 c4 08             	add    $0x8,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	74 dc                	je     80123d <strsplit+0x8c>
			string++;
	}
  801261:	e9 6e ff ff ff       	jmp    8011d4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801266:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 d0                	add    %edx,%eax
  801278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80127e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	68 3c 22 80 00       	push   $0x80223c
  801293:	68 3f 01 00 00       	push   $0x13f
  801298:	68 5e 22 80 00       	push   $0x80225e
  80129d:	e8 65 06 00 00       	call   801907 <_panic>

008012a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	57                   	push   %edi
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012bd:	cd 30                	int    $0x30
  8012bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	5b                   	pop    %ebx
  8012c9:	5e                   	pop    %esi
  8012ca:	5f                   	pop    %edi
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	52                   	push   %edx
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	50                   	push   %eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	e8 b2 ff ff ff       	call   8012a2 <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	90                   	nop
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 02                	push   $0x2
  801305:	e8 98 ff ff ff       	call   8012a2 <syscall>
  80130a:	83 c4 18             	add    $0x18,%esp
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 03                	push   $0x3
  80131e:	e8 7f ff ff ff       	call   8012a2 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 04                	push   $0x4
  801338:	e8 65 ff ff ff       	call   8012a2 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	90                   	nop
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801346:	8b 55 0c             	mov    0xc(%ebp),%edx
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	52                   	push   %edx
  801353:	50                   	push   %eax
  801354:	6a 08                	push   $0x8
  801356:	e8 47 ff ff ff       	call   8012a2 <syscall>
  80135b:	83 c4 18             	add    $0x18,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	56                   	push   %esi
  801364:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801365:	8b 75 18             	mov    0x18(%ebp),%esi
  801368:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80136b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	51                   	push   %ecx
  801377:	52                   	push   %edx
  801378:	50                   	push   %eax
  801379:	6a 09                	push   $0x9
  80137b:	e8 22 ff ff ff       	call   8012a2 <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	52                   	push   %edx
  80139a:	50                   	push   %eax
  80139b:	6a 0a                	push   $0xa
  80139d:	e8 00 ff ff ff       	call   8012a2 <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	ff 75 08             	pushl  0x8(%ebp)
  8013b6:	6a 0b                	push   $0xb
  8013b8:	e8 e5 fe ff ff       	call   8012a2 <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 0c                	push   $0xc
  8013d1:	e8 cc fe ff ff       	call   8012a2 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 0d                	push   $0xd
  8013ea:	e8 b3 fe ff ff       	call   8012a2 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 0e                	push   $0xe
  801403:	e8 9a fe ff ff       	call   8012a2 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 0f                	push   $0xf
  80141c:	e8 81 fe ff ff       	call   8012a2 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	6a 10                	push   $0x10
  801436:	e8 67 fe ff ff       	call   8012a2 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 11                	push   $0x11
  80144f:	e8 4e fe ff ff       	call   8012a2 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_cputc>:

void
sys_cputc(const char c)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801466:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	50                   	push   %eax
  801473:	6a 01                	push   $0x1
  801475:	e8 28 fe ff ff       	call   8012a2 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	90                   	nop
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 14                	push   $0x14
  80148f:	e8 0e fe ff ff       	call   8012a2 <syscall>
  801494:	83 c4 18             	add    $0x18,%esp
}
  801497:	90                   	nop
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	6a 00                	push   $0x0
  8014b2:	51                   	push   %ecx
  8014b3:	52                   	push   %edx
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	50                   	push   %eax
  8014b8:	6a 15                	push   $0x15
  8014ba:	e8 e3 fd ff ff       	call   8012a2 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	52                   	push   %edx
  8014d4:	50                   	push   %eax
  8014d5:	6a 16                	push   $0x16
  8014d7:	e8 c6 fd ff ff       	call   8012a2 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	51                   	push   %ecx
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	6a 17                	push   $0x17
  8014f6:	e8 a7 fd ff ff       	call   8012a2 <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	52                   	push   %edx
  801510:	50                   	push   %eax
  801511:	6a 18                	push   $0x18
  801513:	e8 8a fd ff ff       	call   8012a2 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	6a 00                	push   $0x0
  801525:	ff 75 14             	pushl  0x14(%ebp)
  801528:	ff 75 10             	pushl  0x10(%ebp)
  80152b:	ff 75 0c             	pushl  0xc(%ebp)
  80152e:	50                   	push   %eax
  80152f:	6a 19                	push   $0x19
  801531:	e8 6c fd ff ff       	call   8012a2 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	50                   	push   %eax
  80154a:	6a 1a                	push   $0x1a
  80154c:	e8 51 fd ff ff       	call   8012a2 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	90                   	nop
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	50                   	push   %eax
  801566:	6a 1b                	push   $0x1b
  801568:	e8 35 fd ff ff       	call   8012a2 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 05                	push   $0x5
  801581:	e8 1c fd ff ff       	call   8012a2 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 06                	push   $0x6
  80159a:	e8 03 fd ff ff       	call   8012a2 <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 07                	push   $0x7
  8015b3:	e8 ea fc ff ff       	call   8012a2 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_exit_env>:


void sys_exit_env(void)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 1c                	push   $0x1c
  8015cc:	e8 d1 fc ff ff       	call   8012a2 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	90                   	nop
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e0:	8d 50 04             	lea    0x4(%eax),%edx
  8015e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	52                   	push   %edx
  8015ed:	50                   	push   %eax
  8015ee:	6a 1d                	push   $0x1d
  8015f0:	e8 ad fc ff ff       	call   8012a2 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8015f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801601:	89 01                	mov    %eax,(%ecx)
  801603:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	c9                   	leave  
  80160a:	c2 04 00             	ret    $0x4

0080160d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 10             	pushl  0x10(%ebp)
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	6a 13                	push   $0x13
  80161f:	e8 7e fc ff ff       	call   8012a2 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return ;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_rcr2>:
uint32 sys_rcr2()
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 1e                	push   $0x1e
  801639:	e8 64 fc ff ff       	call   8012a2 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80164f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	50                   	push   %eax
  80165c:	6a 1f                	push   $0x1f
  80165e:	e8 3f fc ff ff       	call   8012a2 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return ;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <rsttst>:
void rsttst()
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 21                	push   $0x21
  801678:	e8 25 fc ff ff       	call   8012a2 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return ;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80168f:	8b 55 18             	mov    0x18(%ebp),%edx
  801692:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801696:	52                   	push   %edx
  801697:	50                   	push   %eax
  801698:	ff 75 10             	pushl  0x10(%ebp)
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	ff 75 08             	pushl  0x8(%ebp)
  8016a1:	6a 20                	push   $0x20
  8016a3:	e8 fa fb ff ff       	call   8012a2 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ab:	90                   	nop
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <chktst>:
void chktst(uint32 n)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	ff 75 08             	pushl  0x8(%ebp)
  8016bc:	6a 22                	push   $0x22
  8016be:	e8 df fb ff ff       	call   8012a2 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c6:	90                   	nop
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <inctst>:

void inctst()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 23                	push   $0x23
  8016d8:	e8 c5 fb ff ff       	call   8012a2 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e0:	90                   	nop
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <gettst>:
uint32 gettst()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 24                	push   $0x24
  8016f2:	e8 ab fb ff ff       	call   8012a2 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 25                	push   $0x25
  80170e:	e8 8f fb ff ff       	call   8012a2 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
  801716:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801719:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80171d:	75 07                	jne    801726 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80171f:	b8 01 00 00 00       	mov    $0x1,%eax
  801724:	eb 05                	jmp    80172b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 25                	push   $0x25
  80173f:	e8 5e fb ff ff       	call   8012a2 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
  801747:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80174a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80174e:	75 07                	jne    801757 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801750:	b8 01 00 00 00       	mov    $0x1,%eax
  801755:	eb 05                	jmp    80175c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 25                	push   $0x25
  801770:	e8 2d fb ff ff       	call   8012a2 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
  801778:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80177b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80177f:	75 07                	jne    801788 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801781:	b8 01 00 00 00       	mov    $0x1,%eax
  801786:	eb 05                	jmp    80178d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 25                	push   $0x25
  8017a1:	e8 fc fa ff ff       	call   8012a2 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
  8017a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017b0:	75 07                	jne    8017b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b7:	eb 05                	jmp    8017be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	6a 26                	push   $0x26
  8017d0:	e8 cd fa ff ff       	call   8012a2 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	53                   	push   %ebx
  8017ee:	51                   	push   %ecx
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 27                	push   $0x27
  8017f3:	e8 aa fa ff ff       	call   8012a2 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 28                	push   $0x28
  801813:	e8 8a fa ff ff       	call   8012a2 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801820:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	51                   	push   %ecx
  80182c:	ff 75 10             	pushl  0x10(%ebp)
  80182f:	52                   	push   %edx
  801830:	50                   	push   %eax
  801831:	6a 29                	push   $0x29
  801833:	e8 6a fa ff ff       	call   8012a2 <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 12                	push   $0x12
  80184f:	e8 4e fa ff ff       	call   8012a2 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return ;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 2a                	push   $0x2a
  80186d:	e8 30 fa ff ff       	call   8012a2 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
	return;
  801875:	90                   	nop
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	50                   	push   %eax
  801887:	6a 2b                	push   $0x2b
  801889:	e8 14 fa ff ff       	call   8012a2 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	6a 2c                	push   $0x2c
  8018a4:	e8 f9 f9 ff ff       	call   8012a2 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return;
  8018ac:	90                   	nop
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	6a 2d                	push   $0x2d
  8018c0:	e8 dd f9 ff ff       	call   8012a2 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
	return;
  8018c8:	90                   	nop
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018d7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	50                   	push   %eax
  8018df:	e8 76 fb ff ff       	call   80145a <sys_cputc>
  8018e4:	83 c4 10             	add    $0x10,%esp
}
  8018e7:	90                   	nop
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <getchar>:


int
getchar(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8018f0:	e8 01 fa ff ff       	call   8012f6 <sys_cgetc>
  8018f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8018f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <iscons>:

int iscons(int fdnum)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801900:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80190d:	8d 45 10             	lea    0x10(%ebp),%eax
  801910:	83 c0 04             	add    $0x4,%eax
  801913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801916:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80191b:	85 c0                	test   %eax,%eax
  80191d:	74 16                	je     801935 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80191f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	50                   	push   %eax
  801928:	68 6c 22 80 00       	push   $0x80226c
  80192d:	e8 ce e9 ff ff       	call   800300 <cprintf>
  801932:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801935:	a1 00 30 80 00       	mov    0x803000,%eax
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	50                   	push   %eax
  801941:	68 71 22 80 00       	push   $0x802271
  801946:	e8 b5 e9 ff ff       	call   800300 <cprintf>
  80194b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80194e:	8b 45 10             	mov    0x10(%ebp),%eax
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	ff 75 f4             	pushl  -0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	e8 38 e9 ff ff       	call   800295 <vcprintf>
  80195d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	6a 00                	push   $0x0
  801965:	68 8d 22 80 00       	push   $0x80228d
  80196a:	e8 26 e9 ff ff       	call   800295 <vcprintf>
  80196f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801972:	e8 a7 e8 ff ff       	call   80021e <exit>

	// should not return here
	while (1) ;
  801977:	eb fe                	jmp    801977 <_panic+0x70>

00801979 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80197f:	a1 04 30 80 00       	mov    0x803004,%eax
  801984:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	39 c2                	cmp    %eax,%edx
  80198f:	74 14                	je     8019a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 90 22 80 00       	push   $0x802290
  801999:	6a 26                	push   $0x26
  80199b:	68 dc 22 80 00       	push   $0x8022dc
  8019a0:	e8 62 ff ff ff       	call   801907 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019b3:	e9 c5 00 00 00       	jmp    801a7d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	8b 00                	mov    (%eax),%eax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	75 08                	jne    8019d5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019d0:	e9 a5 00 00 00       	jmp    801a7a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019e3:	eb 69                	jmp    801a4e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ea:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8019f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f3:	89 d0                	mov    %edx,%eax
  8019f5:	01 c0                	add    %eax,%eax
  8019f7:	01 d0                	add    %edx,%eax
  8019f9:	c1 e0 03             	shl    $0x3,%eax
  8019fc:	01 c8                	add    %ecx,%eax
  8019fe:	8a 40 04             	mov    0x4(%eax),%al
  801a01:	84 c0                	test   %al,%al
  801a03:	75 46                	jne    801a4b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a05:	a1 04 30 80 00       	mov    0x803004,%eax
  801a0a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 03             	shl    $0x3,%eax
  801a1c:	01 c8                	add    %ecx,%eax
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a2b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a30:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	01 c8                	add    %ecx,%eax
  801a3c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a3e:	39 c2                	cmp    %eax,%edx
  801a40:	75 09                	jne    801a4b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a42:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a49:	eb 15                	jmp    801a60 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a4b:	ff 45 e8             	incl   -0x18(%ebp)
  801a4e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a53:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	77 85                	ja     8019e5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a64:	75 14                	jne    801a7a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 e8 22 80 00       	push   $0x8022e8
  801a6e:	6a 3a                	push   $0x3a
  801a70:	68 dc 22 80 00       	push   $0x8022dc
  801a75:	e8 8d fe ff ff       	call   801907 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a7a:	ff 45 f0             	incl   -0x10(%ebp)
  801a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a80:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a83:	0f 8c 2f ff ff ff    	jl     8019b8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a97:	eb 26                	jmp    801abf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a99:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801aa4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aa7:	89 d0                	mov    %edx,%eax
  801aa9:	01 c0                	add    %eax,%eax
  801aab:	01 d0                	add    %edx,%eax
  801aad:	c1 e0 03             	shl    $0x3,%eax
  801ab0:	01 c8                	add    %ecx,%eax
  801ab2:	8a 40 04             	mov    0x4(%eax),%al
  801ab5:	3c 01                	cmp    $0x1,%al
  801ab7:	75 03                	jne    801abc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ab9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801abc:	ff 45 e0             	incl   -0x20(%ebp)
  801abf:	a1 04 30 80 00       	mov    0x803004,%eax
  801ac4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acd:	39 c2                	cmp    %eax,%edx
  801acf:	77 c8                	ja     801a99 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ad7:	74 14                	je     801aed <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 3c 23 80 00       	push   $0x80233c
  801ae1:	6a 44                	push   $0x44
  801ae3:	68 dc 22 80 00       	push   $0x8022dc
  801ae8:	e8 1a fe ff ff       	call   801907 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <__udivdi3>:
  801af0:	55                   	push   %ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 1c             	sub    $0x1c,%esp
  801af7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801afb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b07:	89 ca                	mov    %ecx,%edx
  801b09:	89 f8                	mov    %edi,%eax
  801b0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b0f:	85 f6                	test   %esi,%esi
  801b11:	75 2d                	jne    801b40 <__udivdi3+0x50>
  801b13:	39 cf                	cmp    %ecx,%edi
  801b15:	77 65                	ja     801b7c <__udivdi3+0x8c>
  801b17:	89 fd                	mov    %edi,%ebp
  801b19:	85 ff                	test   %edi,%edi
  801b1b:	75 0b                	jne    801b28 <__udivdi3+0x38>
  801b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b22:	31 d2                	xor    %edx,%edx
  801b24:	f7 f7                	div    %edi
  801b26:	89 c5                	mov    %eax,%ebp
  801b28:	31 d2                	xor    %edx,%edx
  801b2a:	89 c8                	mov    %ecx,%eax
  801b2c:	f7 f5                	div    %ebp
  801b2e:	89 c1                	mov    %eax,%ecx
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	f7 f5                	div    %ebp
  801b34:	89 cf                	mov    %ecx,%edi
  801b36:	89 fa                	mov    %edi,%edx
  801b38:	83 c4 1c             	add    $0x1c,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    
  801b40:	39 ce                	cmp    %ecx,%esi
  801b42:	77 28                	ja     801b6c <__udivdi3+0x7c>
  801b44:	0f bd fe             	bsr    %esi,%edi
  801b47:	83 f7 1f             	xor    $0x1f,%edi
  801b4a:	75 40                	jne    801b8c <__udivdi3+0x9c>
  801b4c:	39 ce                	cmp    %ecx,%esi
  801b4e:	72 0a                	jb     801b5a <__udivdi3+0x6a>
  801b50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b54:	0f 87 9e 00 00 00    	ja     801bf8 <__udivdi3+0x108>
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	89 fa                	mov    %edi,%edx
  801b61:	83 c4 1c             	add    $0x1c,%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
  801b69:	8d 76 00             	lea    0x0(%esi),%esi
  801b6c:	31 ff                	xor    %edi,%edi
  801b6e:	31 c0                	xor    %eax,%eax
  801b70:	89 fa                	mov    %edi,%edx
  801b72:	83 c4 1c             	add    $0x1c,%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5e                   	pop    %esi
  801b77:	5f                   	pop    %edi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    
  801b7a:	66 90                	xchg   %ax,%ax
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	f7 f7                	div    %edi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	89 fa                	mov    %edi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b91:	89 eb                	mov    %ebp,%ebx
  801b93:	29 fb                	sub    %edi,%ebx
  801b95:	89 f9                	mov    %edi,%ecx
  801b97:	d3 e6                	shl    %cl,%esi
  801b99:	89 c5                	mov    %eax,%ebp
  801b9b:	88 d9                	mov    %bl,%cl
  801b9d:	d3 ed                	shr    %cl,%ebp
  801b9f:	89 e9                	mov    %ebp,%ecx
  801ba1:	09 f1                	or     %esi,%ecx
  801ba3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ba7:	89 f9                	mov    %edi,%ecx
  801ba9:	d3 e0                	shl    %cl,%eax
  801bab:	89 c5                	mov    %eax,%ebp
  801bad:	89 d6                	mov    %edx,%esi
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 ee                	shr    %cl,%esi
  801bb3:	89 f9                	mov    %edi,%ecx
  801bb5:	d3 e2                	shl    %cl,%edx
  801bb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bbb:	88 d9                	mov    %bl,%cl
  801bbd:	d3 e8                	shr    %cl,%eax
  801bbf:	09 c2                	or     %eax,%edx
  801bc1:	89 d0                	mov    %edx,%eax
  801bc3:	89 f2                	mov    %esi,%edx
  801bc5:	f7 74 24 0c          	divl   0xc(%esp)
  801bc9:	89 d6                	mov    %edx,%esi
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	f7 e5                	mul    %ebp
  801bcf:	39 d6                	cmp    %edx,%esi
  801bd1:	72 19                	jb     801bec <__udivdi3+0xfc>
  801bd3:	74 0b                	je     801be0 <__udivdi3+0xf0>
  801bd5:	89 d8                	mov    %ebx,%eax
  801bd7:	31 ff                	xor    %edi,%edi
  801bd9:	e9 58 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bde:	66 90                	xchg   %ax,%ax
  801be0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801be4:	89 f9                	mov    %edi,%ecx
  801be6:	d3 e2                	shl    %cl,%edx
  801be8:	39 c2                	cmp    %eax,%edx
  801bea:	73 e9                	jae    801bd5 <__udivdi3+0xe5>
  801bec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bef:	31 ff                	xor    %edi,%edi
  801bf1:	e9 40 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	31 c0                	xor    %eax,%eax
  801bfa:	e9 37 ff ff ff       	jmp    801b36 <__udivdi3+0x46>
  801bff:	90                   	nop

00801c00 <__umoddi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c1f:	89 f3                	mov    %esi,%ebx
  801c21:	89 fa                	mov    %edi,%edx
  801c23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c27:	89 34 24             	mov    %esi,(%esp)
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	75 1a                	jne    801c48 <__umoddi3+0x48>
  801c2e:	39 f7                	cmp    %esi,%edi
  801c30:	0f 86 a2 00 00 00    	jbe    801cd8 <__umoddi3+0xd8>
  801c36:	89 c8                	mov    %ecx,%eax
  801c38:	89 f2                	mov    %esi,%edx
  801c3a:	f7 f7                	div    %edi
  801c3c:	89 d0                	mov    %edx,%eax
  801c3e:	31 d2                	xor    %edx,%edx
  801c40:	83 c4 1c             	add    $0x1c,%esp
  801c43:	5b                   	pop    %ebx
  801c44:	5e                   	pop    %esi
  801c45:	5f                   	pop    %edi
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    
  801c48:	39 f0                	cmp    %esi,%eax
  801c4a:	0f 87 ac 00 00 00    	ja     801cfc <__umoddi3+0xfc>
  801c50:	0f bd e8             	bsr    %eax,%ebp
  801c53:	83 f5 1f             	xor    $0x1f,%ebp
  801c56:	0f 84 ac 00 00 00    	je     801d08 <__umoddi3+0x108>
  801c5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c61:	29 ef                	sub    %ebp,%edi
  801c63:	89 fe                	mov    %edi,%esi
  801c65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c69:	89 e9                	mov    %ebp,%ecx
  801c6b:	d3 e0                	shl    %cl,%eax
  801c6d:	89 d7                	mov    %edx,%edi
  801c6f:	89 f1                	mov    %esi,%ecx
  801c71:	d3 ef                	shr    %cl,%edi
  801c73:	09 c7                	or     %eax,%edi
  801c75:	89 e9                	mov    %ebp,%ecx
  801c77:	d3 e2                	shl    %cl,%edx
  801c79:	89 14 24             	mov    %edx,(%esp)
  801c7c:	89 d8                	mov    %ebx,%eax
  801c7e:	d3 e0                	shl    %cl,%eax
  801c80:	89 c2                	mov    %eax,%edx
  801c82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c86:	d3 e0                	shl    %cl,%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c90:	89 f1                	mov    %esi,%ecx
  801c92:	d3 e8                	shr    %cl,%eax
  801c94:	09 d0                	or     %edx,%eax
  801c96:	d3 eb                	shr    %cl,%ebx
  801c98:	89 da                	mov    %ebx,%edx
  801c9a:	f7 f7                	div    %edi
  801c9c:	89 d3                	mov    %edx,%ebx
  801c9e:	f7 24 24             	mull   (%esp)
  801ca1:	89 c6                	mov    %eax,%esi
  801ca3:	89 d1                	mov    %edx,%ecx
  801ca5:	39 d3                	cmp    %edx,%ebx
  801ca7:	0f 82 87 00 00 00    	jb     801d34 <__umoddi3+0x134>
  801cad:	0f 84 91 00 00 00    	je     801d44 <__umoddi3+0x144>
  801cb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cb7:	29 f2                	sub    %esi,%edx
  801cb9:	19 cb                	sbb    %ecx,%ebx
  801cbb:	89 d8                	mov    %ebx,%eax
  801cbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cc1:	d3 e0                	shl    %cl,%eax
  801cc3:	89 e9                	mov    %ebp,%ecx
  801cc5:	d3 ea                	shr    %cl,%edx
  801cc7:	09 d0                	or     %edx,%eax
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	d3 eb                	shr    %cl,%ebx
  801ccd:	89 da                	mov    %ebx,%edx
  801ccf:	83 c4 1c             	add    $0x1c,%esp
  801cd2:	5b                   	pop    %ebx
  801cd3:	5e                   	pop    %esi
  801cd4:	5f                   	pop    %edi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    
  801cd7:	90                   	nop
  801cd8:	89 fd                	mov    %edi,%ebp
  801cda:	85 ff                	test   %edi,%edi
  801cdc:	75 0b                	jne    801ce9 <__umoddi3+0xe9>
  801cde:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce3:	31 d2                	xor    %edx,%edx
  801ce5:	f7 f7                	div    %edi
  801ce7:	89 c5                	mov    %eax,%ebp
  801ce9:	89 f0                	mov    %esi,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f5                	div    %ebp
  801cef:	89 c8                	mov    %ecx,%eax
  801cf1:	f7 f5                	div    %ebp
  801cf3:	89 d0                	mov    %edx,%eax
  801cf5:	e9 44 ff ff ff       	jmp    801c3e <__umoddi3+0x3e>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	89 c8                	mov    %ecx,%eax
  801cfe:	89 f2                	mov    %esi,%edx
  801d00:	83 c4 1c             	add    $0x1c,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    
  801d08:	3b 04 24             	cmp    (%esp),%eax
  801d0b:	72 06                	jb     801d13 <__umoddi3+0x113>
  801d0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d11:	77 0f                	ja     801d22 <__umoddi3+0x122>
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	29 f9                	sub    %edi,%ecx
  801d17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d1b:	89 14 24             	mov    %edx,(%esp)
  801d1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d26:	8b 14 24             	mov    (%esp),%edx
  801d29:	83 c4 1c             	add    $0x1c,%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    
  801d31:	8d 76 00             	lea    0x0(%esi),%esi
  801d34:	2b 04 24             	sub    (%esp),%eax
  801d37:	19 fa                	sbb    %edi,%edx
  801d39:	89 d1                	mov    %edx,%ecx
  801d3b:	89 c6                	mov    %eax,%esi
  801d3d:	e9 71 ff ff ff       	jmp    801cb3 <__umoddi3+0xb3>
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d48:	72 ea                	jb     801d34 <__umoddi3+0x134>
  801d4a:	89 d9                	mov    %ebx,%ecx
  801d4c:	e9 62 ff ff ff       	jmp    801cb3 <__umoddi3+0xb3>
