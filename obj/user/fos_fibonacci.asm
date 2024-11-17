
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
  800057:	e8 2f 0a 00 00       	call   800a8b <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 82 0e 00 00       	call   800ef4 <strtol>
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
  80009a:	e8 86 02 00 00       	call   800325 <atomic_cprintf>
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
  8000f3:	e8 8b 14 00 00       	call   801583 <sys_getenvindex>
  8000f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	89 d0                	mov    %edx,%eax
  800100:	c1 e0 02             	shl    $0x2,%eax
  800103:	01 d0                	add    %edx,%eax
  800105:	01 c0                	add    %eax,%eax
  800107:	01 d0                	add    %edx,%eax
  800109:	c1 e0 02             	shl    $0x2,%eax
  80010c:	01 d0                	add    %edx,%eax
  80010e:	01 c0                	add    %eax,%eax
  800110:	01 d0                	add    %edx,%eax
  800112:	c1 e0 04             	shl    $0x4,%eax
  800115:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011a:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80011f:	a1 04 30 80 00       	mov    0x803004,%eax
  800124:	8a 40 20             	mov    0x20(%eax),%al
  800127:	84 c0                	test   %al,%al
  800129:	74 0d                	je     800138 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80012b:	a1 04 30 80 00       	mov    0x803004,%eax
  800130:	83 c0 20             	add    $0x20,%eax
  800133:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80013c:	7e 0a                	jle    800148 <libmain+0x5b>
		binaryname = argv[0];
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	8b 00                	mov    (%eax),%eax
  800143:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 0c             	pushl  0xc(%ebp)
  80014e:	ff 75 08             	pushl  0x8(%ebp)
  800151:	e8 e2 fe ff ff       	call   800038 <_main>
  800156:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800159:	e8 a9 11 00 00       	call   801307 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	68 b0 1d 80 00       	push   $0x801db0
  800166:	e8 8d 01 00 00       	call   8002f8 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80016e:	a1 04 30 80 00       	mov    0x803004,%eax
  800173:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800179:	a1 04 30 80 00       	mov    0x803004,%eax
  80017e:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	52                   	push   %edx
  800188:	50                   	push   %eax
  800189:	68 d8 1d 80 00       	push   $0x801dd8
  80018e:	e8 65 01 00 00       	call   8002f8 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800196:	a1 04 30 80 00       	mov    0x803004,%eax
  80019b:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a6:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001b7:	51                   	push   %ecx
  8001b8:	52                   	push   %edx
  8001b9:	50                   	push   %eax
  8001ba:	68 00 1e 80 00       	push   $0x801e00
  8001bf:	e8 34 01 00 00       	call   8002f8 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001cc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	50                   	push   %eax
  8001d6:	68 58 1e 80 00       	push   $0x801e58
  8001db:	e8 18 01 00 00       	call   8002f8 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	68 b0 1d 80 00       	push   $0x801db0
  8001eb:	e8 08 01 00 00       	call   8002f8 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001f3:	e8 29 11 00 00       	call   801321 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001f8:	e8 19 00 00 00       	call   800216 <exit>
}
  8001fd:	90                   	nop
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	6a 00                	push   $0x0
  80020b:	e8 3f 13 00 00       	call   80154f <sys_destroy_env>
  800210:	83 c4 10             	add    $0x10,%esp
}
  800213:	90                   	nop
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <exit>:

void
exit(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80021c:	e8 94 13 00 00       	call   8015b5 <sys_exit_env>
}
  800221:	90                   	nop
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022d:	8b 00                	mov    (%eax),%eax
  80022f:	8d 48 01             	lea    0x1(%eax),%ecx
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	89 0a                	mov    %ecx,(%edx)
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
  80023a:	88 d1                	mov    %dl,%cl
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800243:	8b 45 0c             	mov    0xc(%ebp),%eax
  800246:	8b 00                	mov    (%eax),%eax
  800248:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024d:	75 2c                	jne    80027b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80024f:	a0 08 30 80 00       	mov    0x803008,%al
  800254:	0f b6 c0             	movzbl %al,%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	8b 12                	mov    (%edx),%edx
  80025c:	89 d1                	mov    %edx,%ecx
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	83 c2 08             	add    $0x8,%edx
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	50                   	push   %eax
  800268:	51                   	push   %ecx
  800269:	52                   	push   %edx
  80026a:	e8 56 10 00 00       	call   8012c5 <sys_cputs>
  80026f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	8b 40 04             	mov    0x4(%eax),%eax
  800281:	8d 50 01             	lea    0x1(%eax),%edx
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 50 04             	mov    %edx,0x4(%eax)
}
  80028a:	90                   	nop
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800296:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029d:	00 00 00 
	b.cnt = 0;
  8002a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	68 24 02 80 00       	push   $0x800224
  8002bc:	e8 11 02 00 00       	call   8004d2 <vprintfmt>
  8002c1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c4:	a0 08 30 80 00       	mov    0x803008,%al
  8002c9:	0f b6 c0             	movzbl %al,%eax
  8002cc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	50                   	push   %eax
  8002d6:	52                   	push   %edx
  8002d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002dd:	83 c0 08             	add    $0x8,%eax
  8002e0:	50                   	push   %eax
  8002e1:	e8 df 0f 00 00       	call   8012c5 <sys_cputs>
  8002e6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e9:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fe:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800305:	8d 45 0c             	lea    0xc(%ebp),%eax
  800308:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	ff 75 f4             	pushl  -0xc(%ebp)
  800314:	50                   	push   %eax
  800315:	e8 73 ff ff ff       	call   80028d <vcprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80032b:	e8 d7 0f 00 00       	call   801307 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800330:	8d 45 0c             	lea    0xc(%ebp),%eax
  800333:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	ff 75 f4             	pushl  -0xc(%ebp)
  80033f:	50                   	push   %eax
  800340:	e8 48 ff ff ff       	call   80028d <vcprintf>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80034b:	e8 d1 0f 00 00       	call   801321 <sys_unlock_cons>
	return cnt;
  800350:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	53                   	push   %ebx
  800359:	83 ec 14             	sub    $0x14,%esp
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800362:	8b 45 14             	mov    0x14(%ebp),%eax
  800365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800368:	8b 45 18             	mov    0x18(%ebp),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800373:	77 55                	ja     8003ca <printnum+0x75>
  800375:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800378:	72 05                	jb     80037f <printnum+0x2a>
  80037a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037d:	77 4b                	ja     8003ca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800382:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	ba 00 00 00 00       	mov    $0x0,%edx
  80038d:	52                   	push   %edx
  80038e:	50                   	push   %eax
  80038f:	ff 75 f4             	pushl  -0xc(%ebp)
  800392:	ff 75 f0             	pushl  -0x10(%ebp)
  800395:	e8 4e 17 00 00       	call   801ae8 <__udivdi3>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	ff 75 20             	pushl  0x20(%ebp)
  8003a3:	53                   	push   %ebx
  8003a4:	ff 75 18             	pushl  0x18(%ebp)
  8003a7:	52                   	push   %edx
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ac:	ff 75 08             	pushl  0x8(%ebp)
  8003af:	e8 a1 ff ff ff       	call   800355 <printnum>
  8003b4:	83 c4 20             	add    $0x20,%esp
  8003b7:	eb 1a                	jmp    8003d3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	ff 75 20             	pushl  0x20(%ebp)
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
  8003c7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ca:	ff 4d 1c             	decl   0x1c(%ebp)
  8003cd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d1:	7f e6                	jg     8003b9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e1:	53                   	push   %ebx
  8003e2:	51                   	push   %ecx
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	e8 0e 18 00 00       	call   801bf8 <__umoddi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	05 94 20 80 00       	add    $0x802094,%eax
  8003f2:	8a 00                	mov    (%eax),%al
  8003f4:	0f be c0             	movsbl %al,%eax
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	50                   	push   %eax
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	ff d0                	call   *%eax
  800403:	83 c4 10             	add    $0x10,%esp
}
  800406:	90                   	nop
  800407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800413:	7e 1c                	jle    800431 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	8d 50 08             	lea    0x8(%eax),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	89 10                	mov    %edx,(%eax)
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	83 e8 08             	sub    $0x8,%eax
  80042a:	8b 50 04             	mov    0x4(%eax),%edx
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	eb 40                	jmp    800471 <getuint+0x65>
	else if (lflag)
  800431:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800435:	74 1e                	je     800455 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	8d 50 04             	lea    0x4(%eax),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	89 10                	mov    %edx,(%eax)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	8b 00                	mov    (%eax),%eax
  800449:	83 e8 04             	sub    $0x4,%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
  800453:	eb 1c                	jmp    800471 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	8d 50 04             	lea    0x4(%eax),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	89 10                	mov    %edx,(%eax)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	83 e8 04             	sub    $0x4,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800476:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047a:	7e 1c                	jle    800498 <getint+0x25>
		return va_arg(*ap, long long);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 50 08             	lea    0x8(%eax),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 10                	mov    %edx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	83 e8 08             	sub    $0x8,%eax
  800491:	8b 50 04             	mov    0x4(%eax),%edx
  800494:	8b 00                	mov    (%eax),%eax
  800496:	eb 38                	jmp    8004d0 <getint+0x5d>
	else if (lflag)
  800498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049c:	74 1a                	je     8004b8 <getint+0x45>
		return va_arg(*ap, long);
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	8d 50 04             	lea    0x4(%eax),%edx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	89 10                	mov    %edx,(%eax)
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	83 e8 04             	sub    $0x4,%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	99                   	cltd   
  8004b6:	eb 18                	jmp    8004d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	8d 50 04             	lea    0x4(%eax),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	89 10                	mov    %edx,(%eax)
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	83 e8 04             	sub    $0x4,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	99                   	cltd   
}
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    

008004d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	56                   	push   %esi
  8004d6:	53                   	push   %ebx
  8004d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004da:	eb 17                	jmp    8004f3 <vprintfmt+0x21>
			if (ch == '\0')
  8004dc:	85 db                	test   %ebx,%ebx
  8004de:	0f 84 c1 03 00 00    	je     8008a5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ea:	53                   	push   %ebx
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	ff d0                	call   *%eax
  8004f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	8d 50 01             	lea    0x1(%eax),%edx
  8004f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004fc:	8a 00                	mov    (%eax),%al
  8004fe:	0f b6 d8             	movzbl %al,%ebx
  800501:	83 fb 25             	cmp    $0x25,%ebx
  800504:	75 d6                	jne    8004dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800506:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80050a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800511:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80051f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 45 10             	mov    0x10(%ebp),%eax
  800529:	8d 50 01             	lea    0x1(%eax),%edx
  80052c:	89 55 10             	mov    %edx,0x10(%ebp)
  80052f:	8a 00                	mov    (%eax),%al
  800531:	0f b6 d8             	movzbl %al,%ebx
  800534:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800537:	83 f8 5b             	cmp    $0x5b,%eax
  80053a:	0f 87 3d 03 00 00    	ja     80087d <vprintfmt+0x3ab>
  800540:	8b 04 85 b8 20 80 00 	mov    0x8020b8(,%eax,4),%eax
  800547:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800549:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80054d:	eb d7                	jmp    800526 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80054f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800553:	eb d1                	jmp    800526 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800555:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80055c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055f:	89 d0                	mov    %edx,%eax
  800561:	c1 e0 02             	shl    $0x2,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d8                	add    %ebx,%eax
  80056a:	83 e8 30             	sub    $0x30,%eax
  80056d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800570:	8b 45 10             	mov    0x10(%ebp),%eax
  800573:	8a 00                	mov    (%eax),%al
  800575:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800578:	83 fb 2f             	cmp    $0x2f,%ebx
  80057b:	7e 3e                	jle    8005bb <vprintfmt+0xe9>
  80057d:	83 fb 39             	cmp    $0x39,%ebx
  800580:	7f 39                	jg     8005bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800582:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800585:	eb d5                	jmp    80055c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	83 c0 04             	add    $0x4,%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	83 e8 04             	sub    $0x4,%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80059b:	eb 1f                	jmp    8005bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80059d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a1:	79 83                	jns    800526 <vprintfmt+0x54>
				width = 0;
  8005a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005aa:	e9 77 ff ff ff       	jmp    800526 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b6:	e9 6b ff ff ff       	jmp    800526 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c0:	0f 89 60 ff ff ff    	jns    800526 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d3:	e9 4e ff ff ff       	jmp    800526 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005db:	e9 46 ff ff ff       	jmp    800526 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	ff d0                	call   *%eax
  8005fd:	83 c4 10             	add    $0x10,%esp
			break;
  800600:	e9 9b 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	83 c0 04             	add    $0x4,%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	83 e8 04             	sub    $0x4,%eax
  800614:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800616:	85 db                	test   %ebx,%ebx
  800618:	79 02                	jns    80061c <vprintfmt+0x14a>
				err = -err;
  80061a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80061c:	83 fb 64             	cmp    $0x64,%ebx
  80061f:	7f 0b                	jg     80062c <vprintfmt+0x15a>
  800621:	8b 34 9d 00 1f 80 00 	mov    0x801f00(,%ebx,4),%esi
  800628:	85 f6                	test   %esi,%esi
  80062a:	75 19                	jne    800645 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80062c:	53                   	push   %ebx
  80062d:	68 a5 20 80 00       	push   $0x8020a5
  800632:	ff 75 0c             	pushl  0xc(%ebp)
  800635:	ff 75 08             	pushl  0x8(%ebp)
  800638:	e8 70 02 00 00       	call   8008ad <printfmt>
  80063d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800640:	e9 5b 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800645:	56                   	push   %esi
  800646:	68 ae 20 80 00       	push   $0x8020ae
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	ff 75 08             	pushl  0x8(%ebp)
  800651:	e8 57 02 00 00       	call   8008ad <printfmt>
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 42 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 30                	mov    (%eax),%esi
  80066f:	85 f6                	test   %esi,%esi
  800671:	75 05                	jne    800678 <vprintfmt+0x1a6>
				p = "(null)";
  800673:	be b1 20 80 00       	mov    $0x8020b1,%esi
			if (width > 0 && padc != '-')
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	7e 6d                	jle    8006eb <vprintfmt+0x219>
  80067e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800682:	74 67                	je     8006eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	50                   	push   %eax
  80068b:	56                   	push   %esi
  80068c:	e8 26 05 00 00       	call   800bb7 <strnlen>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800697:	eb 16                	jmp    8006af <vprintfmt+0x1dd>
					putch(padc, putdat);
  800699:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	50                   	push   %eax
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8006af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b3:	7f e4                	jg     800699 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b5:	eb 34                	jmp    8006eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006bb:	74 1c                	je     8006d9 <vprintfmt+0x207>
  8006bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c0:	7e 05                	jle    8006c7 <vprintfmt+0x1f5>
  8006c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c5:	7e 12                	jle    8006d9 <vprintfmt+0x207>
					putch('?', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	6a 3f                	push   $0x3f
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	eb 0f                	jmp    8006e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	53                   	push   %ebx
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006eb:	89 f0                	mov    %esi,%eax
  8006ed:	8d 70 01             	lea    0x1(%eax),%esi
  8006f0:	8a 00                	mov    (%eax),%al
  8006f2:	0f be d8             	movsbl %al,%ebx
  8006f5:	85 db                	test   %ebx,%ebx
  8006f7:	74 24                	je     80071d <vprintfmt+0x24b>
  8006f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fd:	78 b8                	js     8006b7 <vprintfmt+0x1e5>
  8006ff:	ff 4d e0             	decl   -0x20(%ebp)
  800702:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800706:	79 af                	jns    8006b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800708:	eb 13                	jmp    80071d <vprintfmt+0x24b>
				putch(' ', putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	6a 20                	push   $0x20
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	ff d0                	call   *%eax
  800717:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071a:	ff 4d e4             	decl   -0x1c(%ebp)
  80071d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800721:	7f e7                	jg     80070a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800723:	e9 78 01 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 e8             	pushl  -0x18(%ebp)
  80072e:	8d 45 14             	lea    0x14(%ebp),%eax
  800731:	50                   	push   %eax
  800732:	e8 3c fd ff ff       	call   800473 <getint>
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800746:	85 d2                	test   %edx,%edx
  800748:	79 23                	jns    80076d <vprintfmt+0x29b>
				putch('-', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 2d                	push   $0x2d
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80075a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800760:	f7 d8                	neg    %eax
  800762:	83 d2 00             	adc    $0x0,%edx
  800765:	f7 da                	neg    %edx
  800767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80076d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800774:	e9 bc 00 00 00       	jmp    800835 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	ff 75 e8             	pushl  -0x18(%ebp)
  80077f:	8d 45 14             	lea    0x14(%ebp),%eax
  800782:	50                   	push   %eax
  800783:	e8 84 fc ff ff       	call   80040c <getuint>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800791:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800798:	e9 98 00 00 00       	jmp    800835 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	6a 58                	push   $0x58
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	6a 58                	push   $0x58
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	6a 58                	push   $0x58
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
			break;
  8007cd:	e9 ce 00 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 30                	push   $0x30
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	6a 78                	push   $0x78
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	83 c0 04             	add    $0x4,%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	83 e8 04             	sub    $0x4,%eax
  800801:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80080d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 e8             	pushl  -0x18(%ebp)
  80081c:	8d 45 14             	lea    0x14(%ebp),%eax
  80081f:	50                   	push   %eax
  800820:	e8 e7 fb ff ff       	call   80040c <getuint>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80082e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800835:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083c:	83 ec 04             	sub    $0x4,%esp
  80083f:	52                   	push   %edx
  800840:	ff 75 e4             	pushl  -0x1c(%ebp)
  800843:	50                   	push   %eax
  800844:	ff 75 f4             	pushl  -0xc(%ebp)
  800847:	ff 75 f0             	pushl  -0x10(%ebp)
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	ff 75 08             	pushl  0x8(%ebp)
  800850:	e8 00 fb ff ff       	call   800355 <printnum>
  800855:	83 c4 20             	add    $0x20,%esp
			break;
  800858:	eb 46                	jmp    8008a0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	53                   	push   %ebx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			break;
  800869:	eb 35                	jmp    8008a0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80086b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800872:	eb 2c                	jmp    8008a0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800874:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80087b:	eb 23                	jmp    8008a0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 25                	push   $0x25
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088d:	ff 4d 10             	decl   0x10(%ebp)
  800890:	eb 03                	jmp    800895 <vprintfmt+0x3c3>
  800892:	ff 4d 10             	decl   0x10(%ebp)
  800895:	8b 45 10             	mov    0x10(%ebp),%eax
  800898:	48                   	dec    %eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	3c 25                	cmp    $0x25,%al
  80089d:	75 f3                	jne    800892 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80089f:	90                   	nop
		}
	}
  8008a0:	e9 35 fc ff ff       	jmp    8004da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008a5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b6:	83 c0 04             	add    $0x4,%eax
  8008b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c2:	50                   	push   %eax
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	ff 75 08             	pushl  0x8(%ebp)
  8008c9:	e8 04 fc ff ff       	call   8004d2 <vprintfmt>
  8008ce:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d1:	90                   	nop
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    

008008d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	8b 40 08             	mov    0x8(%eax),%eax
  8008dd:	8d 50 01             	lea    0x1(%eax),%edx
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	8b 10                	mov    (%eax),%edx
  8008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ee:	8b 40 04             	mov    0x4(%eax),%eax
  8008f1:	39 c2                	cmp    %eax,%edx
  8008f3:	73 12                	jae    800907 <sprintputch+0x33>
		*b->buf++ = ch;
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	89 0a                	mov    %ecx,(%edx)
  800902:	8b 55 08             	mov    0x8(%ebp),%edx
  800905:	88 10                	mov    %dl,(%eax)
}
  800907:	90                   	nop
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
  800919:	8d 50 ff             	lea    -0x1(%eax),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80092f:	74 06                	je     800937 <vsnprintf+0x2d>
  800931:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800935:	7f 07                	jg     80093e <vsnprintf+0x34>
		return -E_INVAL;
  800937:	b8 03 00 00 00       	mov    $0x3,%eax
  80093c:	eb 20                	jmp    80095e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093e:	ff 75 14             	pushl  0x14(%ebp)
  800941:	ff 75 10             	pushl  0x10(%ebp)
  800944:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800947:	50                   	push   %eax
  800948:	68 d4 08 80 00       	push   $0x8008d4
  80094d:	e8 80 fb ff ff       	call   8004d2 <vprintfmt>
  800952:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800958:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800966:	8d 45 10             	lea    0x10(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80096f:	8b 45 10             	mov    0x10(%ebp),%eax
  800972:	ff 75 f4             	pushl  -0xc(%ebp)
  800975:	50                   	push   %eax
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	ff 75 08             	pushl  0x8(%ebp)
  80097c:	e8 89 ff ff ff       	call   80090a <vsnprintf>
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800992:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800996:	74 13                	je     8009ab <readline+0x1f>
		cprintf("%s", prompt);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 08             	pushl  0x8(%ebp)
  80099e:	68 28 22 80 00       	push   $0x802228
  8009a3:	e8 50 f9 ff ff       	call   8002f8 <cprintf>
  8009a8:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009b2:	83 ec 0c             	sub    $0xc,%esp
  8009b5:	6a 00                	push   $0x0
  8009b7:	e8 39 0f 00 00       	call   8018f5 <iscons>
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009c2:	e8 1b 0f 00 00       	call   8018e2 <getchar>
  8009c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009ce:	79 22                	jns    8009f2 <readline+0x66>
			if (c != -E_EOF)
  8009d0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009d4:	0f 84 ad 00 00 00    	je     800a87 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e0:	68 2b 22 80 00       	push   $0x80222b
  8009e5:	e8 0e f9 ff ff       	call   8002f8 <cprintf>
  8009ea:	83 c4 10             	add    $0x10,%esp
			break;
  8009ed:	e9 95 00 00 00       	jmp    800a87 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009f2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009f6:	7e 34                	jle    800a2c <readline+0xa0>
  8009f8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009ff:	7f 2b                	jg     800a2c <readline+0xa0>
			if (echoing)
  800a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a05:	74 0e                	je     800a15 <readline+0x89>
				cputchar(c);
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	ff 75 ec             	pushl  -0x14(%ebp)
  800a0d:	e8 b1 0e 00 00       	call   8018c3 <cputchar>
  800a12:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a18:	8d 50 01             	lea    0x1(%eax),%edx
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a1e:	89 c2                	mov    %eax,%edx
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	01 d0                	add    %edx,%eax
  800a25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a28:	88 10                	mov    %dl,(%eax)
  800a2a:	eb 56                	jmp    800a82 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a2c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a30:	75 1f                	jne    800a51 <readline+0xc5>
  800a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a36:	7e 19                	jle    800a51 <readline+0xc5>
			if (echoing)
  800a38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a3c:	74 0e                	je     800a4c <readline+0xc0>
				cputchar(c);
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	ff 75 ec             	pushl  -0x14(%ebp)
  800a44:	e8 7a 0e 00 00       	call   8018c3 <cputchar>
  800a49:	83 c4 10             	add    $0x10,%esp

			i--;
  800a4c:	ff 4d f4             	decl   -0xc(%ebp)
  800a4f:	eb 31                	jmp    800a82 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a51:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a55:	74 0a                	je     800a61 <readline+0xd5>
  800a57:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a5b:	0f 85 61 ff ff ff    	jne    8009c2 <readline+0x36>
			if (echoing)
  800a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a65:	74 0e                	je     800a75 <readline+0xe9>
				cputchar(c);
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	ff 75 ec             	pushl  -0x14(%ebp)
  800a6d:	e8 51 0e 00 00       	call   8018c3 <cputchar>
  800a72:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	01 d0                	add    %edx,%eax
  800a7d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a80:	eb 06                	jmp    800a88 <readline+0xfc>
		}
	}
  800a82:	e9 3b ff ff ff       	jmp    8009c2 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a87:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a88:	90                   	nop
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a91:	e8 71 08 00 00       	call   801307 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9a:	74 13                	je     800aaf <atomic_readline+0x24>
			cprintf("%s", prompt);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	68 28 22 80 00       	push   $0x802228
  800aa7:	e8 4c f8 ff ff       	call   8002f8 <cprintf>
  800aac:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800aaf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800ab6:	83 ec 0c             	sub    $0xc,%esp
  800ab9:	6a 00                	push   $0x0
  800abb:	e8 35 0e 00 00       	call   8018f5 <iscons>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ac6:	e8 17 0e 00 00       	call   8018e2 <getchar>
  800acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ad2:	79 22                	jns    800af6 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ad4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ad8:	0f 84 ad 00 00 00    	je     800b8b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae4:	68 2b 22 80 00       	push   $0x80222b
  800ae9:	e8 0a f8 ff ff       	call   8002f8 <cprintf>
  800aee:	83 c4 10             	add    $0x10,%esp
				break;
  800af1:	e9 95 00 00 00       	jmp    800b8b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800af6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800afa:	7e 34                	jle    800b30 <atomic_readline+0xa5>
  800afc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b03:	7f 2b                	jg     800b30 <atomic_readline+0xa5>
				if (echoing)
  800b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b09:	74 0e                	je     800b19 <atomic_readline+0x8e>
					cputchar(c);
  800b0b:	83 ec 0c             	sub    $0xc,%esp
  800b0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b11:	e8 ad 0d 00 00       	call   8018c3 <cputchar>
  800b16:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1c:	8d 50 01             	lea    0x1(%eax),%edx
  800b1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b22:	89 c2                	mov    %eax,%edx
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	01 d0                	add    %edx,%eax
  800b29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b2c:	88 10                	mov    %dl,(%eax)
  800b2e:	eb 56                	jmp    800b86 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b30:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b34:	75 1f                	jne    800b55 <atomic_readline+0xca>
  800b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b3a:	7e 19                	jle    800b55 <atomic_readline+0xca>
				if (echoing)
  800b3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b40:	74 0e                	je     800b50 <atomic_readline+0xc5>
					cputchar(c);
  800b42:	83 ec 0c             	sub    $0xc,%esp
  800b45:	ff 75 ec             	pushl  -0x14(%ebp)
  800b48:	e8 76 0d 00 00       	call   8018c3 <cputchar>
  800b4d:	83 c4 10             	add    $0x10,%esp
				i--;
  800b50:	ff 4d f4             	decl   -0xc(%ebp)
  800b53:	eb 31                	jmp    800b86 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b55:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b59:	74 0a                	je     800b65 <atomic_readline+0xda>
  800b5b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b5f:	0f 85 61 ff ff ff    	jne    800ac6 <atomic_readline+0x3b>
				if (echoing)
  800b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b69:	74 0e                	je     800b79 <atomic_readline+0xee>
					cputchar(c);
  800b6b:	83 ec 0c             	sub    $0xc,%esp
  800b6e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b71:	e8 4d 0d 00 00       	call   8018c3 <cputchar>
  800b76:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b84:	eb 06                	jmp    800b8c <atomic_readline+0x101>
			}
		}
  800b86:	e9 3b ff ff ff       	jmp    800ac6 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b8b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b8c:	e8 90 07 00 00       	call   801321 <sys_unlock_cons>
}
  800b91:	90                   	nop
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba1:	eb 06                	jmp    800ba9 <strlen+0x15>
		n++;
  800ba3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba6:	ff 45 08             	incl   0x8(%ebp)
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8a 00                	mov    (%eax),%al
  800bae:	84 c0                	test   %al,%al
  800bb0:	75 f1                	jne    800ba3 <strlen+0xf>
		n++;
	return n;
  800bb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc4:	eb 09                	jmp    800bcf <strnlen+0x18>
		n++;
  800bc6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc9:	ff 45 08             	incl   0x8(%ebp)
  800bcc:	ff 4d 0c             	decl   0xc(%ebp)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 09                	je     800bde <strnlen+0x27>
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	84 c0                	test   %al,%al
  800bdc:	75 e8                	jne    800bc6 <strnlen+0xf>
		n++;
	return n;
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bef:	90                   	nop
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8d 50 01             	lea    0x1(%eax),%edx
  800bf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c02:	8a 12                	mov    (%edx),%dl
  800c04:	88 10                	mov    %dl,(%eax)
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	84 c0                	test   %al,%al
  800c0a:	75 e4                	jne    800bf0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c24:	eb 1f                	jmp    800c45 <strncpy+0x34>
		*dst++ = *src;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8d 50 01             	lea    0x1(%eax),%edx
  800c2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c32:	8a 12                	mov    (%edx),%dl
  800c34:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	84 c0                	test   %al,%al
  800c3d:	74 03                	je     800c42 <strncpy+0x31>
			src++;
  800c3f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c42:	ff 45 fc             	incl   -0x4(%ebp)
  800c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c48:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c4b:	72 d9                	jb     800c26 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c62:	74 30                	je     800c94 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c64:	eb 16                	jmp    800c7c <strlcpy+0x2a>
			*dst++ = *src++;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8d 50 01             	lea    0x1(%eax),%edx
  800c6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c78:	8a 12                	mov    (%edx),%dl
  800c7a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c7c:	ff 4d 10             	decl   0x10(%ebp)
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 09                	je     800c8e <strlcpy+0x3c>
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	84 c0                	test   %al,%al
  800c8c:	75 d8                	jne    800c66 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9a:	29 c2                	sub    %eax,%edx
  800c9c:	89 d0                	mov    %edx,%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca3:	eb 06                	jmp    800cab <strcmp+0xb>
		p++, q++;
  800ca5:	ff 45 08             	incl   0x8(%ebp)
  800ca8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	84 c0                	test   %al,%al
  800cb2:	74 0e                	je     800cc2 <strcmp+0x22>
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 e3                	je     800ca5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
}
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cdb:	eb 09                	jmp    800ce6 <strncmp+0xe>
		n--, p++, q++;
  800cdd:	ff 4d 10             	decl   0x10(%ebp)
  800ce0:	ff 45 08             	incl   0x8(%ebp)
  800ce3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cea:	74 17                	je     800d03 <strncmp+0x2b>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	84 c0                	test   %al,%al
  800cf3:	74 0e                	je     800d03 <strncmp+0x2b>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 10                	mov    (%eax),%dl
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	38 c2                	cmp    %al,%dl
  800d01:	74 da                	je     800cdd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d07:	75 07                	jne    800d10 <strncmp+0x38>
		return 0;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	eb 14                	jmp    800d24 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	0f b6 d0             	movzbl %al,%edx
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f b6 c0             	movzbl %al,%eax
  800d20:	29 c2                	sub    %eax,%edx
  800d22:	89 d0                	mov    %edx,%eax
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 04             	sub    $0x4,%esp
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d32:	eb 12                	jmp    800d46 <strchr+0x20>
		if (*s == c)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d3c:	75 05                	jne    800d43 <strchr+0x1d>
			return (char *) s;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	eb 11                	jmp    800d54 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d43:	ff 45 08             	incl   0x8(%ebp)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e5                	jne    800d34 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d54:	c9                   	leave  
  800d55:	c3                   	ret    

00800d56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	83 ec 04             	sub    $0x4,%esp
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d62:	eb 0d                	jmp    800d71 <strfind+0x1b>
		if (*s == c)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6c:	74 0e                	je     800d7c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6e:	ff 45 08             	incl   0x8(%ebp)
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	84 c0                	test   %al,%al
  800d78:	75 ea                	jne    800d64 <strfind+0xe>
  800d7a:	eb 01                	jmp    800d7d <strfind+0x27>
		if (*s == c)
			break;
  800d7c:	90                   	nop
	return (char *) s;
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d94:	eb 0e                	jmp    800da4 <memset+0x22>
		*p++ = c;
  800d96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da4:	ff 4d f8             	decl   -0x8(%ebp)
  800da7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dab:	79 e9                	jns    800d96 <memset+0x14>
		*p++ = c;

	return v;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc4:	eb 16                	jmp    800ddc <memcpy+0x2a>
		*d++ = *s++;
  800dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc9:	8d 50 01             	lea    0x1(%eax),%edx
  800dcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd8:	8a 12                	mov    (%edx),%dl
  800dda:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de2:	89 55 10             	mov    %edx,0x10(%ebp)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	75 dd                	jne    800dc6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e03:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e06:	73 50                	jae    800e58 <memmove+0x6a>
  800e08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	01 d0                	add    %edx,%eax
  800e10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e13:	76 43                	jbe    800e58 <memmove+0x6a>
		s += n;
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e21:	eb 10                	jmp    800e33 <memmove+0x45>
			*--d = *--s;
  800e23:	ff 4d f8             	decl   -0x8(%ebp)
  800e26:	ff 4d fc             	decl   -0x4(%ebp)
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	8a 10                	mov    (%eax),%dl
  800e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e31:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e33:	8b 45 10             	mov    0x10(%ebp),%eax
  800e36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e39:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	75 e3                	jne    800e23 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e40:	eb 23                	jmp    800e65 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	8d 50 01             	lea    0x1(%eax),%edx
  800e48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e54:	8a 12                	mov    (%edx),%dl
  800e56:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e61:	85 c0                	test   %eax,%eax
  800e63:	75 dd                	jne    800e42 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e7c:	eb 2a                	jmp    800ea8 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e81:	8a 10                	mov    (%eax),%dl
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	38 c2                	cmp    %al,%dl
  800e8a:	74 16                	je     800ea2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	0f b6 d0             	movzbl %al,%edx
  800e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	0f b6 c0             	movzbl %al,%eax
  800e9c:	29 c2                	sub    %eax,%edx
  800e9e:	89 d0                	mov    %edx,%eax
  800ea0:	eb 18                	jmp    800eba <memcmp+0x50>
		s1++, s2++;
  800ea2:	ff 45 fc             	incl   -0x4(%ebp)
  800ea5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eae:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	75 c9                	jne    800e7e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec8:	01 d0                	add    %edx,%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ecd:	eb 15                	jmp    800ee4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f b6 d0             	movzbl %al,%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	0f b6 c0             	movzbl %al,%eax
  800edd:	39 c2                	cmp    %eax,%edx
  800edf:	74 0d                	je     800eee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eea:	72 e3                	jb     800ecf <memfind+0x13>
  800eec:	eb 01                	jmp    800eef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eee:	90                   	nop
	return (void *) s;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800efa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f01:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f08:	eb 03                	jmp    800f0d <strtol+0x19>
		s++;
  800f0a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 20                	cmp    $0x20,%al
  800f14:	74 f4                	je     800f0a <strtol+0x16>
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	3c 09                	cmp    $0x9,%al
  800f1d:	74 eb                	je     800f0a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 2b                	cmp    $0x2b,%al
  800f26:	75 05                	jne    800f2d <strtol+0x39>
		s++;
  800f28:	ff 45 08             	incl   0x8(%ebp)
  800f2b:	eb 13                	jmp    800f40 <strtol+0x4c>
	else if (*s == '-')
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 2d                	cmp    $0x2d,%al
  800f34:	75 0a                	jne    800f40 <strtol+0x4c>
		s++, neg = 1;
  800f36:	ff 45 08             	incl   0x8(%ebp)
  800f39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f44:	74 06                	je     800f4c <strtol+0x58>
  800f46:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f4a:	75 20                	jne    800f6c <strtol+0x78>
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	3c 30                	cmp    $0x30,%al
  800f53:	75 17                	jne    800f6c <strtol+0x78>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	40                   	inc    %eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	3c 78                	cmp    $0x78,%al
  800f5d:	75 0d                	jne    800f6c <strtol+0x78>
		s += 2, base = 16;
  800f5f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f63:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f6a:	eb 28                	jmp    800f94 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	75 15                	jne    800f87 <strtol+0x93>
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 30                	cmp    $0x30,%al
  800f79:	75 0c                	jne    800f87 <strtol+0x93>
		s++, base = 8;
  800f7b:	ff 45 08             	incl   0x8(%ebp)
  800f7e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f85:	eb 0d                	jmp    800f94 <strtol+0xa0>
	else if (base == 0)
  800f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8b:	75 07                	jne    800f94 <strtol+0xa0>
		base = 10;
  800f8d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 2f                	cmp    $0x2f,%al
  800f9b:	7e 19                	jle    800fb6 <strtol+0xc2>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 39                	cmp    $0x39,%al
  800fa4:	7f 10                	jg     800fb6 <strtol+0xc2>
			dig = *s - '0';
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f be c0             	movsbl %al,%eax
  800fae:	83 e8 30             	sub    $0x30,%eax
  800fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb4:	eb 42                	jmp    800ff8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 60                	cmp    $0x60,%al
  800fbd:	7e 19                	jle    800fd8 <strtol+0xe4>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 7a                	cmp    $0x7a,%al
  800fc6:	7f 10                	jg     800fd8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	0f be c0             	movsbl %al,%eax
  800fd0:	83 e8 57             	sub    $0x57,%eax
  800fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd6:	eb 20                	jmp    800ff8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 40                	cmp    $0x40,%al
  800fdf:	7e 39                	jle    80101a <strtol+0x126>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 5a                	cmp    $0x5a,%al
  800fe8:	7f 30                	jg     80101a <strtol+0x126>
			dig = *s - 'A' + 10;
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f be c0             	movsbl %al,%eax
  800ff2:	83 e8 37             	sub    $0x37,%eax
  800ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffe:	7d 19                	jge    801019 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	0f af 45 10          	imul   0x10(%ebp),%eax
  80100a:	89 c2                	mov    %eax,%edx
  80100c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100f:	01 d0                	add    %edx,%eax
  801011:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801014:	e9 7b ff ff ff       	jmp    800f94 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801019:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80101a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101e:	74 08                	je     801028 <strtol+0x134>
		*endptr = (char *) s;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801028:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80102c:	74 07                	je     801035 <strtol+0x141>
  80102e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801031:	f7 d8                	neg    %eax
  801033:	eb 03                	jmp    801038 <strtol+0x144>
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <ltostr>:

void
ltostr(long value, char *str)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801047:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801052:	79 13                	jns    801067 <ltostr+0x2d>
	{
		neg = 1;
  801054:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801061:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801064:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106f:	99                   	cltd   
  801070:	f7 f9                	idiv   %ecx
  801072:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801075:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801078:	8d 50 01             	lea    0x1(%eax),%edx
  80107b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107e:	89 c2                	mov    %eax,%edx
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	01 d0                	add    %edx,%eax
  801085:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801088:	83 c2 30             	add    $0x30,%edx
  80108b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801090:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801095:	f7 e9                	imul   %ecx
  801097:	c1 fa 02             	sar    $0x2,%edx
  80109a:	89 c8                	mov    %ecx,%eax
  80109c:	c1 f8 1f             	sar    $0x1f,%eax
  80109f:	29 c2                	sub    %eax,%edx
  8010a1:	89 d0                	mov    %edx,%eax
  8010a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	75 bb                	jne    801067 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b6:	48                   	dec    %eax
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010be:	74 3d                	je     8010fd <ltostr+0xc3>
		start = 1 ;
  8010c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c7:	eb 34                	jmp    8010fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	01 d0                	add    %edx,%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 c2                	add    %eax,%edx
  8010de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 c8                	add    %ecx,%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	01 c2                	add    %eax,%edx
  8010f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801100:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801103:	7c c4                	jl     8010c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801105:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	01 d0                	add    %edx,%eax
  80110d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801110:	90                   	nop
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801119:	ff 75 08             	pushl  0x8(%ebp)
  80111c:	e8 73 fa ff ff       	call   800b94 <strlen>
  801121:	83 c4 04             	add    $0x4,%esp
  801124:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801127:	ff 75 0c             	pushl  0xc(%ebp)
  80112a:	e8 65 fa ff ff       	call   800b94 <strlen>
  80112f:	83 c4 04             	add    $0x4,%esp
  801132:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80113c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801143:	eb 17                	jmp    80115c <strcconcat+0x49>
		final[s] = str1[s] ;
  801145:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	01 c2                	add    %eax,%edx
  80114d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	01 c8                	add    %ecx,%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801159:	ff 45 fc             	incl   -0x4(%ebp)
  80115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801162:	7c e1                	jl     801145 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801164:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801172:	eb 1f                	jmp    801193 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801177:	8d 50 01             	lea    0x1(%eax),%edx
  80117a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117d:	89 c2                	mov    %eax,%edx
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	01 c8                	add    %ecx,%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801190:	ff 45 f8             	incl   -0x8(%ebp)
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801199:	7c d9                	jl     801174 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 d0                	add    %edx,%eax
  8011a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a6:	90                   	nop
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8011af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b8:	8b 00                	mov    (%eax),%eax
  8011ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c4:	01 d0                	add    %edx,%eax
  8011c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011cc:	eb 0c                	jmp    8011da <strsplit+0x31>
			*string++ = 0;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8d 50 01             	lea    0x1(%eax),%edx
  8011d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	84 c0                	test   %al,%al
  8011e1:	74 18                	je     8011fb <strsplit+0x52>
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	0f be c0             	movsbl %al,%eax
  8011eb:	50                   	push   %eax
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	e8 32 fb ff ff       	call   800d26 <strchr>
  8011f4:	83 c4 08             	add    $0x8,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	75 d3                	jne    8011ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	84 c0                	test   %al,%al
  801202:	74 5a                	je     80125e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801204:	8b 45 14             	mov    0x14(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	83 f8 0f             	cmp    $0xf,%eax
  80120c:	75 07                	jne    801215 <strsplit+0x6c>
		{
			return 0;
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
  801213:	eb 66                	jmp    80127b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801215:	8b 45 14             	mov    0x14(%ebp),%eax
  801218:	8b 00                	mov    (%eax),%eax
  80121a:	8d 48 01             	lea    0x1(%eax),%ecx
  80121d:	8b 55 14             	mov    0x14(%ebp),%edx
  801220:	89 0a                	mov    %ecx,(%edx)
  801222:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801233:	eb 03                	jmp    801238 <strsplit+0x8f>
			string++;
  801235:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	84 c0                	test   %al,%al
  80123f:	74 8b                	je     8011cc <strsplit+0x23>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	0f be c0             	movsbl %al,%eax
  801249:	50                   	push   %eax
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	e8 d4 fa ff ff       	call   800d26 <strchr>
  801252:	83 c4 08             	add    $0x8,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	74 dc                	je     801235 <strsplit+0x8c>
			string++;
	}
  801259:	e9 6e ff ff ff       	jmp    8011cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801276:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801283:	83 ec 04             	sub    $0x4,%esp
  801286:	68 3c 22 80 00       	push   $0x80223c
  80128b:	68 3f 01 00 00       	push   $0x13f
  801290:	68 5e 22 80 00       	push   $0x80225e
  801295:	e8 65 06 00 00       	call   8018ff <_panic>

0080129a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012b5:	cd 30                	int    $0x30
  8012b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	5b                   	pop    %ebx
  8012c1:	5e                   	pop    %esi
  8012c2:	5f                   	pop    %edi
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	52                   	push   %edx
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	50                   	push   %eax
  8012e1:	6a 00                	push   $0x0
  8012e3:	e8 b2 ff ff ff       	call   80129a <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 02                	push   $0x2
  8012fd:	e8 98 ff ff ff       	call   80129a <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 03                	push   $0x3
  801316:	e8 7f ff ff ff       	call   80129a <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 04                	push   $0x4
  801330:	e8 65 ff ff ff       	call   80129a <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	90                   	nop
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80133e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	52                   	push   %edx
  80134b:	50                   	push   %eax
  80134c:	6a 08                	push   $0x8
  80134e:	e8 47 ff ff ff       	call   80129a <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80135d:	8b 75 18             	mov    0x18(%ebp),%esi
  801360:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801363:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801366:	8b 55 0c             	mov    0xc(%ebp),%edx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	56                   	push   %esi
  80136d:	53                   	push   %ebx
  80136e:	51                   	push   %ecx
  80136f:	52                   	push   %edx
  801370:	50                   	push   %eax
  801371:	6a 09                	push   $0x9
  801373:	e8 22 ff ff ff       	call   80129a <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    

00801382 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	52                   	push   %edx
  801392:	50                   	push   %eax
  801393:	6a 0a                	push   $0xa
  801395:	e8 00 ff ff ff       	call   80129a <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	ff 75 08             	pushl  0x8(%ebp)
  8013ae:	6a 0b                	push   $0xb
  8013b0:	e8 e5 fe ff ff       	call   80129a <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 0c                	push   $0xc
  8013c9:	e8 cc fe ff ff       	call   80129a <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 0d                	push   $0xd
  8013e2:	e8 b3 fe ff ff       	call   80129a <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 0e                	push   $0xe
  8013fb:	e8 9a fe ff ff       	call   80129a <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 0f                	push   $0xf
  801414:	e8 81 fe ff ff       	call   80129a <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	ff 75 08             	pushl  0x8(%ebp)
  80142c:	6a 10                	push   $0x10
  80142e:	e8 67 fe ff ff       	call   80129a <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 11                	push   $0x11
  801447:	e8 4e fe ff ff       	call   80129a <syscall>
  80144c:	83 c4 18             	add    $0x18,%esp
}
  80144f:	90                   	nop
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <sys_cputc>:

void
sys_cputc(const char c)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80145e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	50                   	push   %eax
  80146b:	6a 01                	push   $0x1
  80146d:	e8 28 fe ff ff       	call   80129a <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	90                   	nop
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 14                	push   $0x14
  801487:	e8 0e fe ff ff       	call   80129a <syscall>
  80148c:	83 c4 18             	add    $0x18,%esp
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	8b 45 10             	mov    0x10(%ebp),%eax
  80149b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80149e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	6a 00                	push   $0x0
  8014aa:	51                   	push   %ecx
  8014ab:	52                   	push   %edx
  8014ac:	ff 75 0c             	pushl  0xc(%ebp)
  8014af:	50                   	push   %eax
  8014b0:	6a 15                	push   $0x15
  8014b2:	e8 e3 fd ff ff       	call   80129a <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	52                   	push   %edx
  8014cc:	50                   	push   %eax
  8014cd:	6a 16                	push   $0x16
  8014cf:	e8 c6 fd ff ff       	call   80129a <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	51                   	push   %ecx
  8014ea:	52                   	push   %edx
  8014eb:	50                   	push   %eax
  8014ec:	6a 17                	push   $0x17
  8014ee:	e8 a7 fd ff ff       	call   80129a <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	6a 18                	push   $0x18
  80150b:	e8 8a fd ff ff       	call   80129a <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	6a 00                	push   $0x0
  80151d:	ff 75 14             	pushl  0x14(%ebp)
  801520:	ff 75 10             	pushl  0x10(%ebp)
  801523:	ff 75 0c             	pushl  0xc(%ebp)
  801526:	50                   	push   %eax
  801527:	6a 19                	push   $0x19
  801529:	e8 6c fd ff ff       	call   80129a <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	50                   	push   %eax
  801542:	6a 1a                	push   $0x1a
  801544:	e8 51 fd ff ff       	call   80129a <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	90                   	nop
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	50                   	push   %eax
  80155e:	6a 1b                	push   $0x1b
  801560:	e8 35 fd ff ff       	call   80129a <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 05                	push   $0x5
  801579:	e8 1c fd ff ff       	call   80129a <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 06                	push   $0x6
  801592:	e8 03 fd ff ff       	call   80129a <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 07                	push   $0x7
  8015ab:	e8 ea fc ff ff       	call   80129a <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 1c                	push   $0x1c
  8015c4:	e8 d1 fc ff ff       	call   80129a <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	90                   	nop
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015d8:	8d 50 04             	lea    0x4(%eax),%edx
  8015db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	52                   	push   %edx
  8015e5:	50                   	push   %eax
  8015e6:	6a 1d                	push   $0x1d
  8015e8:	e8 ad fc ff ff       	call   80129a <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8015f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f9:	89 01                	mov    %eax,(%ecx)
  8015fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	c9                   	leave  
  801602:	c2 04 00             	ret    $0x4

00801605 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 10             	pushl  0x10(%ebp)
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	6a 13                	push   $0x13
  801617:	e8 7e fc ff ff       	call   80129a <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
	return ;
  80161f:	90                   	nop
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_rcr2>:
uint32 sys_rcr2()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 1e                	push   $0x1e
  801631:	e8 64 fc ff ff       	call   80129a <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801647:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	50                   	push   %eax
  801654:	6a 1f                	push   $0x1f
  801656:	e8 3f fc ff ff       	call   80129a <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
	return ;
  80165e:	90                   	nop
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <rsttst>:
void rsttst()
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 21                	push   $0x21
  801670:	e8 25 fc ff ff       	call   80129a <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
	return ;
  801678:	90                   	nop
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	8b 45 14             	mov    0x14(%ebp),%eax
  801684:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801687:	8b 55 18             	mov    0x18(%ebp),%edx
  80168a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	ff 75 10             	pushl  0x10(%ebp)
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	6a 20                	push   $0x20
  80169b:	e8 fa fb ff ff       	call   80129a <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a3:	90                   	nop
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <chktst>:
void chktst(uint32 n)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	6a 22                	push   $0x22
  8016b6:	e8 df fb ff ff       	call   80129a <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016be:	90                   	nop
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <inctst>:

void inctst()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 23                	push   $0x23
  8016d0:	e8 c5 fb ff ff       	call   80129a <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d8:	90                   	nop
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <gettst>:
uint32 gettst()
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 24                	push   $0x24
  8016ea:	e8 ab fb ff ff       	call   80129a <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 25                	push   $0x25
  801706:	e8 8f fb ff ff       	call   80129a <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
  80170e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801711:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801715:	75 07                	jne    80171e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801717:	b8 01 00 00 00       	mov    $0x1,%eax
  80171c:	eb 05                	jmp    801723 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 25                	push   $0x25
  801737:	e8 5e fb ff ff       	call   80129a <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
  80173f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801742:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801746:	75 07                	jne    80174f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
  80174d:	eb 05                	jmp    801754 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 25                	push   $0x25
  801768:	e8 2d fb ff ff       	call   80129a <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801773:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801777:	75 07                	jne    801780 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801779:	b8 01 00 00 00       	mov    $0x1,%eax
  80177e:	eb 05                	jmp    801785 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 25                	push   $0x25
  801799:	e8 fc fa ff ff       	call   80129a <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017a4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017a8:	75 07                	jne    8017b1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017af:	eb 05                	jmp    8017b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 26                	push   $0x26
  8017c8:	e8 cd fa ff ff       	call   80129a <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	53                   	push   %ebx
  8017e6:	51                   	push   %ecx
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 27                	push   $0x27
  8017eb:	e8 aa fa ff ff       	call   80129a <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	52                   	push   %edx
  801808:	50                   	push   %eax
  801809:	6a 28                	push   $0x28
  80180b:	e8 8a fa ff ff       	call   80129a <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801818:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	51                   	push   %ecx
  801824:	ff 75 10             	pushl  0x10(%ebp)
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	6a 29                	push   $0x29
  80182b:	e8 6a fa ff ff       	call   80129a <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	ff 75 10             	pushl  0x10(%ebp)
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	6a 12                	push   $0x12
  801847:	e8 4e fa ff ff       	call   80129a <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
	return ;
  80184f:	90                   	nop
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 2a                	push   $0x2a
  801865:	e8 30 fa ff ff       	call   80129a <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	50                   	push   %eax
  80187f:	6a 2b                	push   $0x2b
  801881:	e8 14 fa ff ff       	call   80129a <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	6a 2c                	push   $0x2c
  80189c:	e8 f9 f9 ff ff       	call   80129a <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
	return;
  8018a4:	90                   	nop
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	ff 75 08             	pushl  0x8(%ebp)
  8018b6:	6a 2d                	push   $0x2d
  8018b8:	e8 dd f9 ff ff       	call   80129a <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
	return;
  8018c0:	90                   	nop
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018cf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	50                   	push   %eax
  8018d7:	e8 76 fb ff ff       	call   801452 <sys_cputc>
  8018dc:	83 c4 10             	add    $0x10,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <getchar>:


int
getchar(void)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8018e8:	e8 01 fa ff ff       	call   8012ee <sys_cgetc>
  8018ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <iscons>:

int iscons(int fdnum)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8018f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801905:	8d 45 10             	lea    0x10(%ebp),%eax
  801908:	83 c0 04             	add    $0x4,%eax
  80190b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80190e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801913:	85 c0                	test   %eax,%eax
  801915:	74 16                	je     80192d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801917:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80191c:	83 ec 08             	sub    $0x8,%esp
  80191f:	50                   	push   %eax
  801920:	68 6c 22 80 00       	push   $0x80226c
  801925:	e8 ce e9 ff ff       	call   8002f8 <cprintf>
  80192a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80192d:	a1 00 30 80 00       	mov    0x803000,%eax
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	50                   	push   %eax
  801939:	68 71 22 80 00       	push   $0x802271
  80193e:	e8 b5 e9 ff ff       	call   8002f8 <cprintf>
  801943:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801946:	8b 45 10             	mov    0x10(%ebp),%eax
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	ff 75 f4             	pushl  -0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	e8 38 e9 ff ff       	call   80028d <vcprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	6a 00                	push   $0x0
  80195d:	68 8d 22 80 00       	push   $0x80228d
  801962:	e8 26 e9 ff ff       	call   80028d <vcprintf>
  801967:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80196a:	e8 a7 e8 ff ff       	call   800216 <exit>

	// should not return here
	while (1) ;
  80196f:	eb fe                	jmp    80196f <_panic+0x70>

00801971 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801977:	a1 04 30 80 00       	mov    0x803004,%eax
  80197c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801982:	8b 45 0c             	mov    0xc(%ebp),%eax
  801985:	39 c2                	cmp    %eax,%edx
  801987:	74 14                	je     80199d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 90 22 80 00       	push   $0x802290
  801991:	6a 26                	push   $0x26
  801993:	68 dc 22 80 00       	push   $0x8022dc
  801998:	e8 62 ff ff ff       	call   8018ff <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80199d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019ab:	e9 c5 00 00 00       	jmp    801a75 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	01 d0                	add    %edx,%eax
  8019bf:	8b 00                	mov    (%eax),%eax
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	75 08                	jne    8019cd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019c5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019c8:	e9 a5 00 00 00       	jmp    801a72 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019db:	eb 69                	jmp    801a46 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e2:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8019e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	01 c0                	add    %eax,%eax
  8019ef:	01 d0                	add    %edx,%eax
  8019f1:	c1 e0 03             	shl    $0x3,%eax
  8019f4:	01 c8                	add    %ecx,%eax
  8019f6:	8a 40 04             	mov    0x4(%eax),%al
  8019f9:	84 c0                	test   %al,%al
  8019fb:	75 46                	jne    801a43 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019fd:	a1 04 30 80 00       	mov    0x803004,%eax
  801a02:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	01 c0                	add    %eax,%eax
  801a0f:	01 d0                	add    %edx,%eax
  801a11:	c1 e0 03             	shl    $0x3,%eax
  801a14:	01 c8                	add    %ecx,%eax
  801a16:	8b 00                	mov    (%eax),%eax
  801a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a23:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	01 c8                	add    %ecx,%eax
  801a34:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a36:	39 c2                	cmp    %eax,%edx
  801a38:	75 09                	jne    801a43 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a3a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a41:	eb 15                	jmp    801a58 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a43:	ff 45 e8             	incl   -0x18(%ebp)
  801a46:	a1 04 30 80 00       	mov    0x803004,%eax
  801a4b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a54:	39 c2                	cmp    %eax,%edx
  801a56:	77 85                	ja     8019dd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a5c:	75 14                	jne    801a72 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	68 e8 22 80 00       	push   $0x8022e8
  801a66:	6a 3a                	push   $0x3a
  801a68:	68 dc 22 80 00       	push   $0x8022dc
  801a6d:	e8 8d fe ff ff       	call   8018ff <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a72:	ff 45 f0             	incl   -0x10(%ebp)
  801a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a78:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a7b:	0f 8c 2f ff ff ff    	jl     8019b0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a8f:	eb 26                	jmp    801ab7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a91:	a1 04 30 80 00       	mov    0x803004,%eax
  801a96:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9f:	89 d0                	mov    %edx,%eax
  801aa1:	01 c0                	add    %eax,%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	c1 e0 03             	shl    $0x3,%eax
  801aa8:	01 c8                	add    %ecx,%eax
  801aaa:	8a 40 04             	mov    0x4(%eax),%al
  801aad:	3c 01                	cmp    $0x1,%al
  801aaf:	75 03                	jne    801ab4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ab1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ab4:	ff 45 e0             	incl   -0x20(%ebp)
  801ab7:	a1 04 30 80 00       	mov    0x803004,%eax
  801abc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac5:	39 c2                	cmp    %eax,%edx
  801ac7:	77 c8                	ja     801a91 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801acf:	74 14                	je     801ae5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	68 3c 23 80 00       	push   $0x80233c
  801ad9:	6a 44                	push   $0x44
  801adb:	68 dc 22 80 00       	push   $0x8022dc
  801ae0:	e8 1a fe ff ff       	call   8018ff <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <__udivdi3>:
  801ae8:	55                   	push   %ebp
  801ae9:	57                   	push   %edi
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 1c             	sub    $0x1c,%esp
  801aef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801af3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801afb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aff:	89 ca                	mov    %ecx,%edx
  801b01:	89 f8                	mov    %edi,%eax
  801b03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b07:	85 f6                	test   %esi,%esi
  801b09:	75 2d                	jne    801b38 <__udivdi3+0x50>
  801b0b:	39 cf                	cmp    %ecx,%edi
  801b0d:	77 65                	ja     801b74 <__udivdi3+0x8c>
  801b0f:	89 fd                	mov    %edi,%ebp
  801b11:	85 ff                	test   %edi,%edi
  801b13:	75 0b                	jne    801b20 <__udivdi3+0x38>
  801b15:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1a:	31 d2                	xor    %edx,%edx
  801b1c:	f7 f7                	div    %edi
  801b1e:	89 c5                	mov    %eax,%ebp
  801b20:	31 d2                	xor    %edx,%edx
  801b22:	89 c8                	mov    %ecx,%eax
  801b24:	f7 f5                	div    %ebp
  801b26:	89 c1                	mov    %eax,%ecx
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	f7 f5                	div    %ebp
  801b2c:	89 cf                	mov    %ecx,%edi
  801b2e:	89 fa                	mov    %edi,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	39 ce                	cmp    %ecx,%esi
  801b3a:	77 28                	ja     801b64 <__udivdi3+0x7c>
  801b3c:	0f bd fe             	bsr    %esi,%edi
  801b3f:	83 f7 1f             	xor    $0x1f,%edi
  801b42:	75 40                	jne    801b84 <__udivdi3+0x9c>
  801b44:	39 ce                	cmp    %ecx,%esi
  801b46:	72 0a                	jb     801b52 <__udivdi3+0x6a>
  801b48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b4c:	0f 87 9e 00 00 00    	ja     801bf0 <__udivdi3+0x108>
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	89 fa                	mov    %edi,%edx
  801b59:	83 c4 1c             	add    $0x1c,%esp
  801b5c:	5b                   	pop    %ebx
  801b5d:	5e                   	pop    %esi
  801b5e:	5f                   	pop    %edi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
  801b61:	8d 76 00             	lea    0x0(%esi),%esi
  801b64:	31 ff                	xor    %edi,%edi
  801b66:	31 c0                	xor    %eax,%eax
  801b68:	89 fa                	mov    %edi,%edx
  801b6a:	83 c4 1c             	add    $0x1c,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    
  801b72:	66 90                	xchg   %ax,%ax
  801b74:	89 d8                	mov    %ebx,%eax
  801b76:	f7 f7                	div    %edi
  801b78:	31 ff                	xor    %edi,%edi
  801b7a:	89 fa                	mov    %edi,%edx
  801b7c:	83 c4 1c             	add    $0x1c,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    
  801b84:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b89:	89 eb                	mov    %ebp,%ebx
  801b8b:	29 fb                	sub    %edi,%ebx
  801b8d:	89 f9                	mov    %edi,%ecx
  801b8f:	d3 e6                	shl    %cl,%esi
  801b91:	89 c5                	mov    %eax,%ebp
  801b93:	88 d9                	mov    %bl,%cl
  801b95:	d3 ed                	shr    %cl,%ebp
  801b97:	89 e9                	mov    %ebp,%ecx
  801b99:	09 f1                	or     %esi,%ecx
  801b9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b9f:	89 f9                	mov    %edi,%ecx
  801ba1:	d3 e0                	shl    %cl,%eax
  801ba3:	89 c5                	mov    %eax,%ebp
  801ba5:	89 d6                	mov    %edx,%esi
  801ba7:	88 d9                	mov    %bl,%cl
  801ba9:	d3 ee                	shr    %cl,%esi
  801bab:	89 f9                	mov    %edi,%ecx
  801bad:	d3 e2                	shl    %cl,%edx
  801baf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb3:	88 d9                	mov    %bl,%cl
  801bb5:	d3 e8                	shr    %cl,%eax
  801bb7:	09 c2                	or     %eax,%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	89 f2                	mov    %esi,%edx
  801bbd:	f7 74 24 0c          	divl   0xc(%esp)
  801bc1:	89 d6                	mov    %edx,%esi
  801bc3:	89 c3                	mov    %eax,%ebx
  801bc5:	f7 e5                	mul    %ebp
  801bc7:	39 d6                	cmp    %edx,%esi
  801bc9:	72 19                	jb     801be4 <__udivdi3+0xfc>
  801bcb:	74 0b                	je     801bd8 <__udivdi3+0xf0>
  801bcd:	89 d8                	mov    %ebx,%eax
  801bcf:	31 ff                	xor    %edi,%edi
  801bd1:	e9 58 ff ff ff       	jmp    801b2e <__udivdi3+0x46>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bdc:	89 f9                	mov    %edi,%ecx
  801bde:	d3 e2                	shl    %cl,%edx
  801be0:	39 c2                	cmp    %eax,%edx
  801be2:	73 e9                	jae    801bcd <__udivdi3+0xe5>
  801be4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801be7:	31 ff                	xor    %edi,%edi
  801be9:	e9 40 ff ff ff       	jmp    801b2e <__udivdi3+0x46>
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	31 c0                	xor    %eax,%eax
  801bf2:	e9 37 ff ff ff       	jmp    801b2e <__udivdi3+0x46>
  801bf7:	90                   	nop

00801bf8 <__umoddi3>:
  801bf8:	55                   	push   %ebp
  801bf9:	57                   	push   %edi
  801bfa:	56                   	push   %esi
  801bfb:	53                   	push   %ebx
  801bfc:	83 ec 1c             	sub    $0x1c,%esp
  801bff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c17:	89 f3                	mov    %esi,%ebx
  801c19:	89 fa                	mov    %edi,%edx
  801c1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c1f:	89 34 24             	mov    %esi,(%esp)
  801c22:	85 c0                	test   %eax,%eax
  801c24:	75 1a                	jne    801c40 <__umoddi3+0x48>
  801c26:	39 f7                	cmp    %esi,%edi
  801c28:	0f 86 a2 00 00 00    	jbe    801cd0 <__umoddi3+0xd8>
  801c2e:	89 c8                	mov    %ecx,%eax
  801c30:	89 f2                	mov    %esi,%edx
  801c32:	f7 f7                	div    %edi
  801c34:	89 d0                	mov    %edx,%eax
  801c36:	31 d2                	xor    %edx,%edx
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
  801c40:	39 f0                	cmp    %esi,%eax
  801c42:	0f 87 ac 00 00 00    	ja     801cf4 <__umoddi3+0xfc>
  801c48:	0f bd e8             	bsr    %eax,%ebp
  801c4b:	83 f5 1f             	xor    $0x1f,%ebp
  801c4e:	0f 84 ac 00 00 00    	je     801d00 <__umoddi3+0x108>
  801c54:	bf 20 00 00 00       	mov    $0x20,%edi
  801c59:	29 ef                	sub    %ebp,%edi
  801c5b:	89 fe                	mov    %edi,%esi
  801c5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c61:	89 e9                	mov    %ebp,%ecx
  801c63:	d3 e0                	shl    %cl,%eax
  801c65:	89 d7                	mov    %edx,%edi
  801c67:	89 f1                	mov    %esi,%ecx
  801c69:	d3 ef                	shr    %cl,%edi
  801c6b:	09 c7                	or     %eax,%edi
  801c6d:	89 e9                	mov    %ebp,%ecx
  801c6f:	d3 e2                	shl    %cl,%edx
  801c71:	89 14 24             	mov    %edx,(%esp)
  801c74:	89 d8                	mov    %ebx,%eax
  801c76:	d3 e0                	shl    %cl,%eax
  801c78:	89 c2                	mov    %eax,%edx
  801c7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7e:	d3 e0                	shl    %cl,%eax
  801c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c84:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c88:	89 f1                	mov    %esi,%ecx
  801c8a:	d3 e8                	shr    %cl,%eax
  801c8c:	09 d0                	or     %edx,%eax
  801c8e:	d3 eb                	shr    %cl,%ebx
  801c90:	89 da                	mov    %ebx,%edx
  801c92:	f7 f7                	div    %edi
  801c94:	89 d3                	mov    %edx,%ebx
  801c96:	f7 24 24             	mull   (%esp)
  801c99:	89 c6                	mov    %eax,%esi
  801c9b:	89 d1                	mov    %edx,%ecx
  801c9d:	39 d3                	cmp    %edx,%ebx
  801c9f:	0f 82 87 00 00 00    	jb     801d2c <__umoddi3+0x134>
  801ca5:	0f 84 91 00 00 00    	je     801d3c <__umoddi3+0x144>
  801cab:	8b 54 24 04          	mov    0x4(%esp),%edx
  801caf:	29 f2                	sub    %esi,%edx
  801cb1:	19 cb                	sbb    %ecx,%ebx
  801cb3:	89 d8                	mov    %ebx,%eax
  801cb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cb9:	d3 e0                	shl    %cl,%eax
  801cbb:	89 e9                	mov    %ebp,%ecx
  801cbd:	d3 ea                	shr    %cl,%edx
  801cbf:	09 d0                	or     %edx,%eax
  801cc1:	89 e9                	mov    %ebp,%ecx
  801cc3:	d3 eb                	shr    %cl,%ebx
  801cc5:	89 da                	mov    %ebx,%edx
  801cc7:	83 c4 1c             	add    $0x1c,%esp
  801cca:	5b                   	pop    %ebx
  801ccb:	5e                   	pop    %esi
  801ccc:	5f                   	pop    %edi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    
  801ccf:	90                   	nop
  801cd0:	89 fd                	mov    %edi,%ebp
  801cd2:	85 ff                	test   %edi,%edi
  801cd4:	75 0b                	jne    801ce1 <__umoddi3+0xe9>
  801cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	f7 f7                	div    %edi
  801cdf:	89 c5                	mov    %eax,%ebp
  801ce1:	89 f0                	mov    %esi,%eax
  801ce3:	31 d2                	xor    %edx,%edx
  801ce5:	f7 f5                	div    %ebp
  801ce7:	89 c8                	mov    %ecx,%eax
  801ce9:	f7 f5                	div    %ebp
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	e9 44 ff ff ff       	jmp    801c36 <__umoddi3+0x3e>
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	89 c8                	mov    %ecx,%eax
  801cf6:	89 f2                	mov    %esi,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	3b 04 24             	cmp    (%esp),%eax
  801d03:	72 06                	jb     801d0b <__umoddi3+0x113>
  801d05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d09:	77 0f                	ja     801d1a <__umoddi3+0x122>
  801d0b:	89 f2                	mov    %esi,%edx
  801d0d:	29 f9                	sub    %edi,%ecx
  801d0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d13:	89 14 24             	mov    %edx,(%esp)
  801d16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d1e:	8b 14 24             	mov    (%esp),%edx
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    
  801d29:	8d 76 00             	lea    0x0(%esi),%esi
  801d2c:	2b 04 24             	sub    (%esp),%eax
  801d2f:	19 fa                	sbb    %edi,%edx
  801d31:	89 d1                	mov    %edx,%ecx
  801d33:	89 c6                	mov    %eax,%esi
  801d35:	e9 71 ff ff ff       	jmp    801cab <__umoddi3+0xb3>
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d40:	72 ea                	jb     801d2c <__umoddi3+0x134>
  801d42:	89 d9                	mov    %ebx,%ecx
  801d44:	e9 62 ff ff ff       	jmp    801cab <__umoddi3+0xb3>
