
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
  800052:	68 60 1d 80 00       	push   $0x801d60
  800057:	e8 3e 0a 00 00       	call   800a9a <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 91 0e 00 00       	call   800f03 <strtol>
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
  800095:	68 77 1d 80 00       	push   $0x801d77
  80009a:	e8 95 02 00 00       	call   800334 <atomic_cprintf>
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
  8000fa:	e8 93 14 00 00       	call   801592 <sys_getenvindex>
  8000ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	c1 e0 03             	shl    $0x3,%eax
  80010a:	01 d0                	add    %edx,%eax
  80010c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800113:	01 c8                	add    %ecx,%eax
  800115:	01 c0                	add    %eax,%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800120:	01 c8                	add    %ecx,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800129:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012e:	a1 04 30 80 00       	mov    0x803004,%eax
  800133:	8a 40 20             	mov    0x20(%eax),%al
  800136:	84 c0                	test   %al,%al
  800138:	74 0d                	je     800147 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80013a:	a1 04 30 80 00       	mov    0x803004,%eax
  80013f:	83 c0 20             	add    $0x20,%eax
  800142:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014b:	7e 0a                	jle    800157 <libmain+0x63>
		binaryname = argv[0];
  80014d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800150:	8b 00                	mov    (%eax),%eax
  800152:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	ff 75 0c             	pushl  0xc(%ebp)
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 d3 fe ff ff       	call   800038 <_main>
  800165:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800168:	e8 a9 11 00 00       	call   801316 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 a4 1d 80 00       	push   $0x801da4
  800175:	e8 8d 01 00 00       	call   800307 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80017d:	a1 04 30 80 00       	mov    0x803004,%eax
  800182:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800188:	a1 04 30 80 00       	mov    0x803004,%eax
  80018d:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	52                   	push   %edx
  800197:	50                   	push   %eax
  800198:	68 cc 1d 80 00       	push   $0x801dcc
  80019d:	e8 65 01 00 00       	call   800307 <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b5:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c0:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001c6:	51                   	push   %ecx
  8001c7:	52                   	push   %edx
  8001c8:	50                   	push   %eax
  8001c9:	68 f4 1d 80 00       	push   $0x801df4
  8001ce:	e8 34 01 00 00       	call   800307 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001db:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	50                   	push   %eax
  8001e5:	68 4c 1e 80 00       	push   $0x801e4c
  8001ea:	e8 18 01 00 00       	call   800307 <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	68 a4 1d 80 00       	push   $0x801da4
  8001fa:	e8 08 01 00 00       	call   800307 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800202:	e8 29 11 00 00       	call   801330 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800207:	e8 19 00 00 00       	call   800225 <exit>
}
  80020c:	90                   	nop
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	6a 00                	push   $0x0
  80021a:	e8 3f 13 00 00       	call   80155e <sys_destroy_env>
  80021f:	83 c4 10             	add    $0x10,%esp
}
  800222:	90                   	nop
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <exit>:

void
exit(void)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80022b:	e8 94 13 00 00       	call   8015c4 <sys_exit_env>
}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023c:	8b 00                	mov    (%eax),%eax
  80023e:	8d 48 01             	lea    0x1(%eax),%ecx
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	89 0a                	mov    %ecx,(%edx)
  800246:	8b 55 08             	mov    0x8(%ebp),%edx
  800249:	88 d1                	mov    %dl,%cl
  80024b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800252:	8b 45 0c             	mov    0xc(%ebp),%eax
  800255:	8b 00                	mov    (%eax),%eax
  800257:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025c:	75 2c                	jne    80028a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80025e:	a0 08 30 80 00       	mov    0x803008,%al
  800263:	0f b6 c0             	movzbl %al,%eax
  800266:	8b 55 0c             	mov    0xc(%ebp),%edx
  800269:	8b 12                	mov    (%edx),%edx
  80026b:	89 d1                	mov    %edx,%ecx
  80026d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800270:	83 c2 08             	add    $0x8,%edx
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	50                   	push   %eax
  800277:	51                   	push   %ecx
  800278:	52                   	push   %edx
  800279:	e8 56 10 00 00       	call   8012d4 <sys_cputs>
  80027e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800281:	8b 45 0c             	mov    0xc(%ebp),%eax
  800284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80028a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028d:	8b 40 04             	mov    0x4(%eax),%eax
  800290:	8d 50 01             	lea    0x1(%eax),%edx
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	89 50 04             	mov    %edx,0x4(%eax)
}
  800299:	90                   	nop
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ac:	00 00 00 
	b.cnt = 0;
  8002af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b6:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b9:	ff 75 0c             	pushl  0xc(%ebp)
  8002bc:	ff 75 08             	pushl  0x8(%ebp)
  8002bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c5:	50                   	push   %eax
  8002c6:	68 33 02 80 00       	push   $0x800233
  8002cb:	e8 11 02 00 00       	call   8004e1 <vprintfmt>
  8002d0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002d3:	a0 08 30 80 00       	mov    0x803008,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	50                   	push   %eax
  8002e5:	52                   	push   %edx
  8002e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ec:	83 c0 08             	add    $0x8,%eax
  8002ef:	50                   	push   %eax
  8002f0:	e8 df 0f 00 00       	call   8012d4 <sys_cputs>
  8002f5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f8:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80030d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800314:	8d 45 0c             	lea    0xc(%ebp),%eax
  800317:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 f4             	pushl  -0xc(%ebp)
  800323:	50                   	push   %eax
  800324:	e8 73 ff ff ff       	call   80029c <vcprintf>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80032f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800332:	c9                   	leave  
  800333:	c3                   	ret    

00800334 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80033a:	e8 d7 0f 00 00       	call   801316 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80033f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800342:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	ff 75 f4             	pushl  -0xc(%ebp)
  80034e:	50                   	push   %eax
  80034f:	e8 48 ff ff ff       	call   80029c <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80035a:	e8 d1 0f 00 00       	call   801330 <sys_unlock_cons>
	return cnt;
  80035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	53                   	push   %ebx
  800368:	83 ec 14             	sub    $0x14,%esp
  80036b:	8b 45 10             	mov    0x10(%ebp),%eax
  80036e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800371:	8b 45 14             	mov    0x14(%ebp),%eax
  800374:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800377:	8b 45 18             	mov    0x18(%ebp),%eax
  80037a:	ba 00 00 00 00       	mov    $0x0,%edx
  80037f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800382:	77 55                	ja     8003d9 <printnum+0x75>
  800384:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800387:	72 05                	jb     80038e <printnum+0x2a>
  800389:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038c:	77 4b                	ja     8003d9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800394:	8b 45 18             	mov    0x18(%ebp),%eax
  800397:	ba 00 00 00 00       	mov    $0x0,%edx
  80039c:	52                   	push   %edx
  80039d:	50                   	push   %eax
  80039e:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	e8 4f 17 00 00       	call   801af8 <__udivdi3>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	83 ec 04             	sub    $0x4,%esp
  8003af:	ff 75 20             	pushl  0x20(%ebp)
  8003b2:	53                   	push   %ebx
  8003b3:	ff 75 18             	pushl  0x18(%ebp)
  8003b6:	52                   	push   %edx
  8003b7:	50                   	push   %eax
  8003b8:	ff 75 0c             	pushl  0xc(%ebp)
  8003bb:	ff 75 08             	pushl  0x8(%ebp)
  8003be:	e8 a1 ff ff ff       	call   800364 <printnum>
  8003c3:	83 c4 20             	add    $0x20,%esp
  8003c6:	eb 1a                	jmp    8003e2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 20             	pushl  0x20(%ebp)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	ff d0                	call   *%eax
  8003d6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d9:	ff 4d 1c             	decl   0x1c(%ebp)
  8003dc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003e0:	7f e6                	jg     8003c8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f0:	53                   	push   %ebx
  8003f1:	51                   	push   %ecx
  8003f2:	52                   	push   %edx
  8003f3:	50                   	push   %eax
  8003f4:	e8 0f 18 00 00       	call   801c08 <__umoddi3>
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	05 74 20 80 00       	add    $0x802074,%eax
  800401:	8a 00                	mov    (%eax),%al
  800403:	0f be c0             	movsbl %al,%eax
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	50                   	push   %eax
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	ff d0                	call   *%eax
  800412:	83 c4 10             	add    $0x10,%esp
}
  800415:	90                   	nop
  800416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800422:	7e 1c                	jle    800440 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	8d 50 08             	lea    0x8(%eax),%edx
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	89 10                	mov    %edx,(%eax)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	83 e8 08             	sub    $0x8,%eax
  800439:	8b 50 04             	mov    0x4(%eax),%edx
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	eb 40                	jmp    800480 <getuint+0x65>
	else if (lflag)
  800440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800444:	74 1e                	je     800464 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	8d 50 04             	lea    0x4(%eax),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 10                	mov    %edx,(%eax)
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	83 e8 04             	sub    $0x4,%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	ba 00 00 00 00       	mov    $0x0,%edx
  800462:	eb 1c                	jmp    800480 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	8d 50 04             	lea    0x4(%eax),%edx
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	89 10                	mov    %edx,(%eax)
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	83 e8 04             	sub    $0x4,%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800485:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800489:	7e 1c                	jle    8004a7 <getint+0x25>
		return va_arg(*ap, long long);
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	8d 50 08             	lea    0x8(%eax),%edx
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	89 10                	mov    %edx,(%eax)
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	83 e8 08             	sub    $0x8,%eax
  8004a0:	8b 50 04             	mov    0x4(%eax),%edx
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	eb 38                	jmp    8004df <getint+0x5d>
	else if (lflag)
  8004a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ab:	74 1a                	je     8004c7 <getint+0x45>
		return va_arg(*ap, long);
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	8d 50 04             	lea    0x4(%eax),%edx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	89 10                	mov    %edx,(%eax)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	83 e8 04             	sub    $0x4,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	99                   	cltd   
  8004c5:	eb 18                	jmp    8004df <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 04             	lea    0x4(%eax),%edx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 e8 04             	sub    $0x4,%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	99                   	cltd   
}
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    

008004e1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e9:	eb 17                	jmp    800502 <vprintfmt+0x21>
			if (ch == '\0')
  8004eb:	85 db                	test   %ebx,%ebx
  8004ed:	0f 84 c1 03 00 00    	je     8008b4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	53                   	push   %ebx
  8004fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fd:	ff d0                	call   *%eax
  8004ff:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	8d 50 01             	lea    0x1(%eax),%edx
  800508:	89 55 10             	mov    %edx,0x10(%ebp)
  80050b:	8a 00                	mov    (%eax),%al
  80050d:	0f b6 d8             	movzbl %al,%ebx
  800510:	83 fb 25             	cmp    $0x25,%ebx
  800513:	75 d6                	jne    8004eb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800515:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800519:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800520:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800527:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80052e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8b 45 10             	mov    0x10(%ebp),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	89 55 10             	mov    %edx,0x10(%ebp)
  80053e:	8a 00                	mov    (%eax),%al
  800540:	0f b6 d8             	movzbl %al,%ebx
  800543:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800546:	83 f8 5b             	cmp    $0x5b,%eax
  800549:	0f 87 3d 03 00 00    	ja     80088c <vprintfmt+0x3ab>
  80054f:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  800556:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800558:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80055c:	eb d7                	jmp    800535 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800562:	eb d1                	jmp    800535 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800564:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80056b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056e:	89 d0                	mov    %edx,%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d8                	add    %ebx,%eax
  800579:	83 e8 30             	sub    $0x30,%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8a 00                	mov    (%eax),%al
  800584:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800587:	83 fb 2f             	cmp    $0x2f,%ebx
  80058a:	7e 3e                	jle    8005ca <vprintfmt+0xe9>
  80058c:	83 fb 39             	cmp    $0x39,%ebx
  80058f:	7f 39                	jg     8005ca <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800591:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800594:	eb d5                	jmp    80056b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	83 c0 04             	add    $0x4,%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	83 e8 04             	sub    $0x4,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005aa:	eb 1f                	jmp    8005cb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b0:	79 83                	jns    800535 <vprintfmt+0x54>
				width = 0;
  8005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b9:	e9 77 ff ff ff       	jmp    800535 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005be:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c5:	e9 6b ff ff ff       	jmp    800535 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ca:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cf:	0f 89 60 ff ff ff    	jns    800535 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005e2:	e9 4e ff ff ff       	jmp    800535 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005ea:	e9 46 ff ff ff       	jmp    800535 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 c0 04             	add    $0x4,%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	83 e8 04             	sub    $0x4,%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	50                   	push   %eax
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	ff d0                	call   *%eax
  80060c:	83 c4 10             	add    $0x10,%esp
			break;
  80060f:	e9 9b 02 00 00       	jmp    8008af <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 c0 04             	add    $0x4,%eax
  80061a:	89 45 14             	mov    %eax,0x14(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	83 e8 04             	sub    $0x4,%eax
  800623:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800625:	85 db                	test   %ebx,%ebx
  800627:	79 02                	jns    80062b <vprintfmt+0x14a>
				err = -err;
  800629:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80062b:	83 fb 64             	cmp    $0x64,%ebx
  80062e:	7f 0b                	jg     80063b <vprintfmt+0x15a>
  800630:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  800637:	85 f6                	test   %esi,%esi
  800639:	75 19                	jne    800654 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80063b:	53                   	push   %ebx
  80063c:	68 85 20 80 00       	push   $0x802085
  800641:	ff 75 0c             	pushl  0xc(%ebp)
  800644:	ff 75 08             	pushl  0x8(%ebp)
  800647:	e8 70 02 00 00       	call   8008bc <printfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80064f:	e9 5b 02 00 00       	jmp    8008af <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800654:	56                   	push   %esi
  800655:	68 8e 20 80 00       	push   $0x80208e
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	e8 57 02 00 00       	call   8008bc <printfmt>
  800665:	83 c4 10             	add    $0x10,%esp
			break;
  800668:	e9 42 02 00 00       	jmp    8008af <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 c0 04             	add    $0x4,%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	83 e8 04             	sub    $0x4,%eax
  80067c:	8b 30                	mov    (%eax),%esi
  80067e:	85 f6                	test   %esi,%esi
  800680:	75 05                	jne    800687 <vprintfmt+0x1a6>
				p = "(null)";
  800682:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	7e 6d                	jle    8006fa <vprintfmt+0x219>
  80068d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800691:	74 67                	je     8006fa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	50                   	push   %eax
  80069a:	56                   	push   %esi
  80069b:	e8 26 05 00 00       	call   800bc6 <strnlen>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006a6:	eb 16                	jmp    8006be <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	ff 75 0c             	pushl  0xc(%ebp)
  8006b2:	50                   	push   %eax
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bb:	ff 4d e4             	decl   -0x1c(%ebp)
  8006be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c2:	7f e4                	jg     8006a8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c4:	eb 34                	jmp    8006fa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ca:	74 1c                	je     8006e8 <vprintfmt+0x207>
  8006cc:	83 fb 1f             	cmp    $0x1f,%ebx
  8006cf:	7e 05                	jle    8006d6 <vprintfmt+0x1f5>
  8006d1:	83 fb 7e             	cmp    $0x7e,%ebx
  8006d4:	7e 12                	jle    8006e8 <vprintfmt+0x207>
					putch('?', putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	6a 3f                	push   $0x3f
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	ff d0                	call   *%eax
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	eb 0f                	jmp    8006f7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	53                   	push   %ebx
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fa:	89 f0                	mov    %esi,%eax
  8006fc:	8d 70 01             	lea    0x1(%eax),%esi
  8006ff:	8a 00                	mov    (%eax),%al
  800701:	0f be d8             	movsbl %al,%ebx
  800704:	85 db                	test   %ebx,%ebx
  800706:	74 24                	je     80072c <vprintfmt+0x24b>
  800708:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070c:	78 b8                	js     8006c6 <vprintfmt+0x1e5>
  80070e:	ff 4d e0             	decl   -0x20(%ebp)
  800711:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800715:	79 af                	jns    8006c6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800717:	eb 13                	jmp    80072c <vprintfmt+0x24b>
				putch(' ', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	6a 20                	push   $0x20
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800729:	ff 4d e4             	decl   -0x1c(%ebp)
  80072c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800730:	7f e7                	jg     800719 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800732:	e9 78 01 00 00       	jmp    8008af <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 e8             	pushl  -0x18(%ebp)
  80073d:	8d 45 14             	lea    0x14(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	e8 3c fd ff ff       	call   800482 <getint>
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80074f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800755:	85 d2                	test   %edx,%edx
  800757:	79 23                	jns    80077c <vprintfmt+0x29b>
				putch('-', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	6a 2d                	push   $0x2d
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076f:	f7 d8                	neg    %eax
  800771:	83 d2 00             	adc    $0x0,%edx
  800774:	f7 da                	neg    %edx
  800776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800779:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80077c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800783:	e9 bc 00 00 00       	jmp    800844 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 e8             	pushl  -0x18(%ebp)
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	50                   	push   %eax
  800792:	e8 84 fc ff ff       	call   80041b <getuint>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a7:	e9 98 00 00 00       	jmp    800844 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	6a 58                	push   $0x58
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	6a 58                	push   $0x58
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	ff d0                	call   *%eax
  8007c9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	6a 58                	push   $0x58
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	ff d0                	call   *%eax
  8007d9:	83 c4 10             	add    $0x10,%esp
			break;
  8007dc:	e9 ce 00 00 00       	jmp    8008af <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	6a 30                	push   $0x30
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	6a 78                	push   $0x78
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 c0 04             	add    $0x4,%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800815:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80081c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800823:	eb 1f                	jmp    800844 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 e8             	pushl  -0x18(%ebp)
  80082b:	8d 45 14             	lea    0x14(%ebp),%eax
  80082e:	50                   	push   %eax
  80082f:	e8 e7 fb ff ff       	call   80041b <getuint>
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80083d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800844:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	52                   	push   %edx
  80084f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800852:	50                   	push   %eax
  800853:	ff 75 f4             	pushl  -0xc(%ebp)
  800856:	ff 75 f0             	pushl  -0x10(%ebp)
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	ff 75 08             	pushl  0x8(%ebp)
  80085f:	e8 00 fb ff ff       	call   800364 <printnum>
  800864:	83 c4 20             	add    $0x20,%esp
			break;
  800867:	eb 46                	jmp    8008af <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	53                   	push   %ebx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
			break;
  800878:	eb 35                	jmp    8008af <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80087a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800881:	eb 2c                	jmp    8008af <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800883:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80088a:	eb 23                	jmp    8008af <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	6a 25                	push   $0x25
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	ff d0                	call   *%eax
  800899:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089c:	ff 4d 10             	decl   0x10(%ebp)
  80089f:	eb 03                	jmp    8008a4 <vprintfmt+0x3c3>
  8008a1:	ff 4d 10             	decl   0x10(%ebp)
  8008a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a7:	48                   	dec    %eax
  8008a8:	8a 00                	mov    (%eax),%al
  8008aa:	3c 25                	cmp    $0x25,%al
  8008ac:	75 f3                	jne    8008a1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008ae:	90                   	nop
		}
	}
  8008af:	e9 35 fc ff ff       	jmp    8004e9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008b4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b8:	5b                   	pop    %ebx
  8008b9:	5e                   	pop    %esi
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d1:	50                   	push   %eax
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	ff 75 08             	pushl  0x8(%ebp)
  8008d8:	e8 04 fc ff ff       	call   8004e1 <vprintfmt>
  8008dd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008e0:	90                   	nop
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	8b 40 08             	mov    0x8(%eax),%eax
  8008ec:	8d 50 01             	lea    0x1(%eax),%edx
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	8b 10                	mov    (%eax),%edx
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	8b 40 04             	mov    0x4(%eax),%eax
  800900:	39 c2                	cmp    %eax,%edx
  800902:	73 12                	jae    800916 <sprintputch+0x33>
		*b->buf++ = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 10                	mov    %dl,(%eax)
}
  800916:	90                   	nop
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8d 50 ff             	lea    -0x1(%eax),%edx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	01 d0                	add    %edx,%eax
  800930:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093e:	74 06                	je     800946 <vsnprintf+0x2d>
  800940:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800944:	7f 07                	jg     80094d <vsnprintf+0x34>
		return -E_INVAL;
  800946:	b8 03 00 00 00       	mov    $0x3,%eax
  80094b:	eb 20                	jmp    80096d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094d:	ff 75 14             	pushl  0x14(%ebp)
  800950:	ff 75 10             	pushl  0x10(%ebp)
  800953:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800956:	50                   	push   %eax
  800957:	68 e3 08 80 00       	push   $0x8008e3
  80095c:	e8 80 fb ff ff       	call   8004e1 <vprintfmt>
  800961:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800967:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80096a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800975:	8d 45 10             	lea    0x10(%ebp),%eax
  800978:	83 c0 04             	add    $0x4,%eax
  80097b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80097e:	8b 45 10             	mov    0x10(%ebp),%eax
  800981:	ff 75 f4             	pushl  -0xc(%ebp)
  800984:	50                   	push   %eax
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 89 ff ff ff       	call   800919 <vsnprintf>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800996:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8009a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a5:	74 13                	je     8009ba <readline+0x1f>
		cprintf("%s", prompt);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 08             	pushl  0x8(%ebp)
  8009ad:	68 08 22 80 00       	push   $0x802208
  8009b2:	e8 50 f9 ff ff       	call   800307 <cprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009c1:	83 ec 0c             	sub    $0xc,%esp
  8009c4:	6a 00                	push   $0x0
  8009c6:	e8 39 0f 00 00       	call   801904 <iscons>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009d1:	e8 1b 0f 00 00       	call   8018f1 <getchar>
  8009d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009dd:	79 22                	jns    800a01 <readline+0x66>
			if (c != -E_EOF)
  8009df:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009e3:	0f 84 ad 00 00 00    	je     800a96 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ef:	68 0b 22 80 00       	push   $0x80220b
  8009f4:	e8 0e f9 ff ff       	call   800307 <cprintf>
  8009f9:	83 c4 10             	add    $0x10,%esp
			break;
  8009fc:	e9 95 00 00 00       	jmp    800a96 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a01:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a05:	7e 34                	jle    800a3b <readline+0xa0>
  800a07:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a0e:	7f 2b                	jg     800a3b <readline+0xa0>
			if (echoing)
  800a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a14:	74 0e                	je     800a24 <readline+0x89>
				cputchar(c);
  800a16:	83 ec 0c             	sub    $0xc,%esp
  800a19:	ff 75 ec             	pushl  -0x14(%ebp)
  800a1c:	e8 b1 0e 00 00       	call   8018d2 <cputchar>
  800a21:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a27:	8d 50 01             	lea    0x1(%eax),%edx
  800a2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a37:	88 10                	mov    %dl,(%eax)
  800a39:	eb 56                	jmp    800a91 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a3b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a3f:	75 1f                	jne    800a60 <readline+0xc5>
  800a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a45:	7e 19                	jle    800a60 <readline+0xc5>
			if (echoing)
  800a47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a4b:	74 0e                	je     800a5b <readline+0xc0>
				cputchar(c);
  800a4d:	83 ec 0c             	sub    $0xc,%esp
  800a50:	ff 75 ec             	pushl  -0x14(%ebp)
  800a53:	e8 7a 0e 00 00       	call   8018d2 <cputchar>
  800a58:	83 c4 10             	add    $0x10,%esp

			i--;
  800a5b:	ff 4d f4             	decl   -0xc(%ebp)
  800a5e:	eb 31                	jmp    800a91 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a60:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a64:	74 0a                	je     800a70 <readline+0xd5>
  800a66:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a6a:	0f 85 61 ff ff ff    	jne    8009d1 <readline+0x36>
			if (echoing)
  800a70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a74:	74 0e                	je     800a84 <readline+0xe9>
				cputchar(c);
  800a76:	83 ec 0c             	sub    $0xc,%esp
  800a79:	ff 75 ec             	pushl  -0x14(%ebp)
  800a7c:	e8 51 0e 00 00       	call   8018d2 <cputchar>
  800a81:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	01 d0                	add    %edx,%eax
  800a8c:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a8f:	eb 06                	jmp    800a97 <readline+0xfc>
		}
	}
  800a91:	e9 3b ff ff ff       	jmp    8009d1 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a96:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a97:	90                   	nop
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800aa0:	e8 71 08 00 00       	call   801316 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800aa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa9:	74 13                	je     800abe <atomic_readline+0x24>
			cprintf("%s", prompt);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 08             	pushl  0x8(%ebp)
  800ab1:	68 08 22 80 00       	push   $0x802208
  800ab6:	e8 4c f8 ff ff       	call   800307 <cprintf>
  800abb:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800ac5:	83 ec 0c             	sub    $0xc,%esp
  800ac8:	6a 00                	push   $0x0
  800aca:	e8 35 0e 00 00       	call   801904 <iscons>
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ad5:	e8 17 0e 00 00       	call   8018f1 <getchar>
  800ada:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800add:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ae1:	79 22                	jns    800b05 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ae3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ae7:	0f 84 ad 00 00 00    	je     800b9a <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 ec             	pushl  -0x14(%ebp)
  800af3:	68 0b 22 80 00       	push   $0x80220b
  800af8:	e8 0a f8 ff ff       	call   800307 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp
				break;
  800b00:	e9 95 00 00 00       	jmp    800b9a <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b05:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b09:	7e 34                	jle    800b3f <atomic_readline+0xa5>
  800b0b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b12:	7f 2b                	jg     800b3f <atomic_readline+0xa5>
				if (echoing)
  800b14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b18:	74 0e                	je     800b28 <atomic_readline+0x8e>
					cputchar(c);
  800b1a:	83 ec 0c             	sub    $0xc,%esp
  800b1d:	ff 75 ec             	pushl  -0x14(%ebp)
  800b20:	e8 ad 0d 00 00       	call   8018d2 <cputchar>
  800b25:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b2b:	8d 50 01             	lea    0x1(%eax),%edx
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b31:	89 c2                	mov    %eax,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	01 d0                	add    %edx,%eax
  800b38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b3b:	88 10                	mov    %dl,(%eax)
  800b3d:	eb 56                	jmp    800b95 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b3f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b43:	75 1f                	jne    800b64 <atomic_readline+0xca>
  800b45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b49:	7e 19                	jle    800b64 <atomic_readline+0xca>
				if (echoing)
  800b4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4f:	74 0e                	je     800b5f <atomic_readline+0xc5>
					cputchar(c);
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	ff 75 ec             	pushl  -0x14(%ebp)
  800b57:	e8 76 0d 00 00       	call   8018d2 <cputchar>
  800b5c:	83 c4 10             	add    $0x10,%esp
				i--;
  800b5f:	ff 4d f4             	decl   -0xc(%ebp)
  800b62:	eb 31                	jmp    800b95 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b64:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b68:	74 0a                	je     800b74 <atomic_readline+0xda>
  800b6a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b6e:	0f 85 61 ff ff ff    	jne    800ad5 <atomic_readline+0x3b>
				if (echoing)
  800b74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b78:	74 0e                	je     800b88 <atomic_readline+0xee>
					cputchar(c);
  800b7a:	83 ec 0c             	sub    $0xc,%esp
  800b7d:	ff 75 ec             	pushl  -0x14(%ebp)
  800b80:	e8 4d 0d 00 00       	call   8018d2 <cputchar>
  800b85:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	01 d0                	add    %edx,%eax
  800b90:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b93:	eb 06                	jmp    800b9b <atomic_readline+0x101>
			}
		}
  800b95:	e9 3b ff ff ff       	jmp    800ad5 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b9a:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b9b:	e8 90 07 00 00       	call   801330 <sys_unlock_cons>
}
  800ba0:	90                   	nop
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb0:	eb 06                	jmp    800bb8 <strlen+0x15>
		n++;
  800bb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb5:	ff 45 08             	incl   0x8(%ebp)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	75 f1                	jne    800bb2 <strlen+0xf>
		n++;
	return n;
  800bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 09                	jmp    800bde <strnlen+0x18>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	ff 4d 0c             	decl   0xc(%ebp)
  800bde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be2:	74 09                	je     800bed <strnlen+0x27>
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	84 c0                	test   %al,%al
  800beb:	75 e8                	jne    800bd5 <strnlen+0xf>
		n++;
	return n;
  800bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfe:	90                   	nop
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 08             	mov    %edx,0x8(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c11:	8a 12                	mov    (%edx),%dl
  800c13:	88 10                	mov    %dl,(%eax)
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 e4                	jne    800bff <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c33:	eb 1f                	jmp    800c54 <strncpy+0x34>
		*dst++ = *src;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	74 03                	je     800c51 <strncpy+0x31>
			src++;
  800c4e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
  800c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5a:	72 d9                	jb     800c35 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 30                	je     800ca3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c73:	eb 16                	jmp    800c8b <strlcpy+0x2a>
			*dst++ = *src++;
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8d 50 01             	lea    0x1(%eax),%edx
  800c7b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c81:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c87:	8a 12                	mov    (%edx),%dl
  800c89:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8b:	ff 4d 10             	decl   0x10(%ebp)
  800c8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c92:	74 09                	je     800c9d <strlcpy+0x3c>
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 d8                	jne    800c75 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca9:	29 c2                	sub    %eax,%edx
  800cab:	89 d0                	mov    %edx,%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb2:	eb 06                	jmp    800cba <strcmp+0xb>
		p++, q++;
  800cb4:	ff 45 08             	incl   0x8(%ebp)
  800cb7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	74 0e                	je     800cd1 <strcmp+0x22>
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 10                	mov    (%eax),%dl
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	38 c2                	cmp    %al,%dl
  800ccf:	74 e3                	je     800cb4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 d0             	movzbl %al,%edx
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	0f b6 c0             	movzbl %al,%eax
  800ce1:	29 c2                	sub    %eax,%edx
  800ce3:	89 d0                	mov    %edx,%eax
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cea:	eb 09                	jmp    800cf5 <strncmp+0xe>
		n--, p++, q++;
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	ff 45 08             	incl   0x8(%ebp)
  800cf2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf9:	74 17                	je     800d12 <strncmp+0x2b>
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	84 c0                	test   %al,%al
  800d02:	74 0e                	je     800d12 <strncmp+0x2b>
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 10                	mov    (%eax),%dl
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	38 c2                	cmp    %al,%dl
  800d10:	74 da                	je     800cec <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	75 07                	jne    800d1f <strncmp+0x38>
		return 0;
  800d18:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1d:	eb 14                	jmp    800d33 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 d0             	movzbl %al,%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	0f b6 c0             	movzbl %al,%eax
  800d2f:	29 c2                	sub    %eax,%edx
  800d31:	89 d0                	mov    %edx,%eax
}
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 04             	sub    $0x4,%esp
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d41:	eb 12                	jmp    800d55 <strchr+0x20>
		if (*s == c)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4b:	75 05                	jne    800d52 <strchr+0x1d>
			return (char *) s;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	eb 11                	jmp    800d63 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 e5                	jne    800d43 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 04             	sub    $0x4,%esp
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d71:	eb 0d                	jmp    800d80 <strfind+0x1b>
		if (*s == c)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7b:	74 0e                	je     800d8b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 ea                	jne    800d73 <strfind+0xe>
  800d89:	eb 01                	jmp    800d8c <strfind+0x27>
		if (*s == c)
			break;
  800d8b:	90                   	nop
	return (char *) s;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da3:	eb 0e                	jmp    800db3 <memset+0x22>
		*p++ = c;
  800da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db3:	ff 4d f8             	decl   -0x8(%ebp)
  800db6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dba:	79 e9                	jns    800da5 <memset+0x14>
		*p++ = c;

	return v;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd3:	eb 16                	jmp    800deb <memcpy+0x2a>
		*d++ = *s++;
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df1:	89 55 10             	mov    %edx,0x10(%ebp)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	75 dd                	jne    800dd5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e12:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e15:	73 50                	jae    800e67 <memmove+0x6a>
  800e17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1d:	01 d0                	add    %edx,%eax
  800e1f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e22:	76 43                	jbe    800e67 <memmove+0x6a>
		s += n;
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e30:	eb 10                	jmp    800e42 <memmove+0x45>
			*--d = *--s;
  800e32:	ff 4d f8             	decl   -0x8(%ebp)
  800e35:	ff 4d fc             	decl   -0x4(%ebp)
  800e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3b:	8a 10                	mov    (%eax),%dl
  800e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e40:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e48:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	75 e3                	jne    800e32 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4f:	eb 23                	jmp    800e74 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8b:	eb 2a                	jmp    800eb7 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e90:	8a 10                	mov    (%eax),%dl
  800e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	38 c2                	cmp    %al,%dl
  800e99:	74 16                	je     800eb1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	0f b6 d0             	movzbl %al,%edx
  800ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	0f b6 c0             	movzbl %al,%eax
  800eab:	29 c2                	sub    %eax,%edx
  800ead:	89 d0                	mov    %edx,%eax
  800eaf:	eb 18                	jmp    800ec9 <memcmp+0x50>
		s1++, s2++;
  800eb1:	ff 45 fc             	incl   -0x4(%ebp)
  800eb4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 c9                	jne    800e8d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	01 d0                	add    %edx,%eax
  800ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edc:	eb 15                	jmp    800ef3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d0             	movzbl %al,%edx
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	0f b6 c0             	movzbl %al,%eax
  800eec:	39 c2                	cmp    %eax,%edx
  800eee:	74 0d                	je     800efd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef9:	72 e3                	jb     800ede <memfind+0x13>
  800efb:	eb 01                	jmp    800efe <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efd:	90                   	nop
	return (void *) s;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f10:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f17:	eb 03                	jmp    800f1c <strtol+0x19>
		s++;
  800f19:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 20                	cmp    $0x20,%al
  800f23:	74 f4                	je     800f19 <strtol+0x16>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 09                	cmp    $0x9,%al
  800f2c:	74 eb                	je     800f19 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 2b                	cmp    $0x2b,%al
  800f35:	75 05                	jne    800f3c <strtol+0x39>
		s++;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	eb 13                	jmp    800f4f <strtol+0x4c>
	else if (*s == '-')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	3c 2d                	cmp    $0x2d,%al
  800f43:	75 0a                	jne    800f4f <strtol+0x4c>
		s++, neg = 1;
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	74 06                	je     800f5b <strtol+0x58>
  800f55:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f59:	75 20                	jne    800f7b <strtol+0x78>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	3c 30                	cmp    $0x30,%al
  800f62:	75 17                	jne    800f7b <strtol+0x78>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	40                   	inc    %eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 78                	cmp    $0x78,%al
  800f6c:	75 0d                	jne    800f7b <strtol+0x78>
		s += 2, base = 16;
  800f6e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f72:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f79:	eb 28                	jmp    800fa3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 15                	jne    800f96 <strtol+0x93>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 30                	cmp    $0x30,%al
  800f88:	75 0c                	jne    800f96 <strtol+0x93>
		s++, base = 8;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f94:	eb 0d                	jmp    800fa3 <strtol+0xa0>
	else if (base == 0)
  800f96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9a:	75 07                	jne    800fa3 <strtol+0xa0>
		base = 10;
  800f9c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 2f                	cmp    $0x2f,%al
  800faa:	7e 19                	jle    800fc5 <strtol+0xc2>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3c 39                	cmp    $0x39,%al
  800fb3:	7f 10                	jg     800fc5 <strtol+0xc2>
			dig = *s - '0';
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be c0             	movsbl %al,%eax
  800fbd:	83 e8 30             	sub    $0x30,%eax
  800fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc3:	eb 42                	jmp    801007 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 60                	cmp    $0x60,%al
  800fcc:	7e 19                	jle    800fe7 <strtol+0xe4>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 7a                	cmp    $0x7a,%al
  800fd5:	7f 10                	jg     800fe7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be c0             	movsbl %al,%eax
  800fdf:	83 e8 57             	sub    $0x57,%eax
  800fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe5:	eb 20                	jmp    801007 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 40                	cmp    $0x40,%al
  800fee:	7e 39                	jle    801029 <strtol+0x126>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 5a                	cmp    $0x5a,%al
  800ff7:	7f 30                	jg     801029 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be c0             	movsbl %al,%eax
  801001:	83 e8 37             	sub    $0x37,%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100d:	7d 19                	jge    801028 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100f:	ff 45 08             	incl   0x8(%ebp)
  801012:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801015:	0f af 45 10          	imul   0x10(%ebp),%eax
  801019:	89 c2                	mov    %eax,%edx
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	01 d0                	add    %edx,%eax
  801020:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801023:	e9 7b ff ff ff       	jmp    800fa3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801028:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801029:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102d:	74 08                	je     801037 <strtol+0x134>
		*endptr = (char *) s;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801037:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103b:	74 07                	je     801044 <strtol+0x141>
  80103d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801040:	f7 d8                	neg    %eax
  801042:	eb 03                	jmp    801047 <strtol+0x144>
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <ltostr>:

void
ltostr(long value, char *str)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801056:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801061:	79 13                	jns    801076 <ltostr+0x2d>
	{
		neg = 1;
  801063:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801070:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801073:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107e:	99                   	cltd   
  80107f:	f7 f9                	idiv   %ecx
  801081:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	8d 50 01             	lea    0x1(%eax),%edx
  80108a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801097:	83 c2 30             	add    $0x30,%edx
  80109a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a4:	f7 e9                	imul   %ecx
  8010a6:	c1 fa 02             	sar    $0x2,%edx
  8010a9:	89 c8                	mov    %ecx,%eax
  8010ab:	c1 f8 1f             	sar    $0x1f,%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b9:	75 bb                	jne    801076 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	48                   	dec    %eax
  8010c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cd:	74 3d                	je     80110c <ltostr+0xc3>
		start = 1 ;
  8010cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d6:	eb 34                	jmp    80110c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 d0                	add    %edx,%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 c2                	add    %eax,%edx
  8010ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 c8                	add    %ecx,%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	01 c2                	add    %eax,%edx
  801101:	8a 45 eb             	mov    -0x15(%ebp),%al
  801104:	88 02                	mov    %al,(%edx)
		start++ ;
  801106:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801109:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801112:	7c c4                	jl     8010d8 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801114:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	01 d0                	add    %edx,%eax
  80111c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111f:	90                   	nop
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801128:	ff 75 08             	pushl  0x8(%ebp)
  80112b:	e8 73 fa ff ff       	call   800ba3 <strlen>
  801130:	83 c4 04             	add    $0x4,%esp
  801133:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	e8 65 fa ff ff       	call   800ba3 <strlen>
  80113e:	83 c4 04             	add    $0x4,%esp
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801152:	eb 17                	jmp    80116b <strcconcat+0x49>
		final[s] = str1[s] ;
  801154:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801168:	ff 45 fc             	incl   -0x4(%ebp)
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801171:	7c e1                	jl     801154 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801173:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801181:	eb 1f                	jmp    8011a2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801183:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801186:	8d 50 01             	lea    0x1(%eax),%edx
  801189:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118c:	89 c2                	mov    %eax,%edx
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	01 c2                	add    %eax,%edx
  801193:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 c8                	add    %ecx,%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119f:	ff 45 f8             	incl   -0x8(%ebp)
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a8:	7c d9                	jl     801183 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b5:	90                   	nop
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011db:	eb 0c                	jmp    8011e9 <strsplit+0x31>
			*string++ = 0;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8d 50 01             	lea    0x1(%eax),%edx
  8011e3:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	74 18                	je     80120a <strsplit+0x52>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f be c0             	movsbl %al,%eax
  8011fa:	50                   	push   %eax
  8011fb:	ff 75 0c             	pushl  0xc(%ebp)
  8011fe:	e8 32 fb ff ff       	call   800d35 <strchr>
  801203:	83 c4 08             	add    $0x8,%esp
  801206:	85 c0                	test   %eax,%eax
  801208:	75 d3                	jne    8011dd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	84 c0                	test   %al,%al
  801211:	74 5a                	je     80126d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801213:	8b 45 14             	mov    0x14(%ebp),%eax
  801216:	8b 00                	mov    (%eax),%eax
  801218:	83 f8 0f             	cmp    $0xf,%eax
  80121b:	75 07                	jne    801224 <strsplit+0x6c>
		{
			return 0;
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
  801222:	eb 66                	jmp    80128a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801224:	8b 45 14             	mov    0x14(%ebp),%eax
  801227:	8b 00                	mov    (%eax),%eax
  801229:	8d 48 01             	lea    0x1(%eax),%ecx
  80122c:	8b 55 14             	mov    0x14(%ebp),%edx
  80122f:	89 0a                	mov    %ecx,(%edx)
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 c2                	add    %eax,%edx
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801242:	eb 03                	jmp    801247 <strsplit+0x8f>
			string++;
  801244:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	84 c0                	test   %al,%al
  80124e:	74 8b                	je     8011db <strsplit+0x23>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	0f be c0             	movsbl %al,%eax
  801258:	50                   	push   %eax
  801259:	ff 75 0c             	pushl  0xc(%ebp)
  80125c:	e8 d4 fa ff ff       	call   800d35 <strchr>
  801261:	83 c4 08             	add    $0x8,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	74 dc                	je     801244 <strsplit+0x8c>
			string++;
	}
  801268:	e9 6e ff ff ff       	jmp    8011db <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126e:	8b 45 14             	mov    0x14(%ebp),%eax
  801271:	8b 00                	mov    (%eax),%eax
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801285:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	68 1c 22 80 00       	push   $0x80221c
  80129a:	68 3f 01 00 00       	push   $0x13f
  80129f:	68 3e 22 80 00       	push   $0x80223e
  8012a4:	e8 65 06 00 00       	call   80190e <_panic>

008012a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c4:	cd 30                	int    $0x30
  8012c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5f                   	pop    %edi
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    

008012d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	52                   	push   %edx
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 b2 ff ff ff       	call   8012a9 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	90                   	nop
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 02                	push   $0x2
  80130c:	e8 98 ff ff ff       	call   8012a9 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 03                	push   $0x3
  801325:	e8 7f ff ff ff       	call   8012a9 <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	90                   	nop
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 04                	push   $0x4
  80133f:	e8 65 ff ff ff       	call   8012a9 <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	90                   	nop
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 08                	push   $0x8
  80135d:	e8 47 ff ff ff       	call   8012a9 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	56                   	push   %esi
  80136b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80136c:	8b 75 18             	mov    0x18(%ebp),%esi
  80136f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801372:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	51                   	push   %ecx
  80137e:	52                   	push   %edx
  80137f:	50                   	push   %eax
  801380:	6a 09                	push   $0x9
  801382:	e8 22 ff ff ff       	call   8012a9 <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801394:	8b 55 0c             	mov    0xc(%ebp),%edx
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 0a                	push   $0xa
  8013a4:	e8 00 ff ff ff       	call   8012a9 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	ff 75 08             	pushl  0x8(%ebp)
  8013bd:	6a 0b                	push   $0xb
  8013bf:	e8 e5 fe ff ff       	call   8012a9 <syscall>
  8013c4:	83 c4 18             	add    $0x18,%esp
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 0c                	push   $0xc
  8013d8:	e8 cc fe ff ff       	call   8012a9 <syscall>
  8013dd:	83 c4 18             	add    $0x18,%esp
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 0d                	push   $0xd
  8013f1:	e8 b3 fe ff ff       	call   8012a9 <syscall>
  8013f6:	83 c4 18             	add    $0x18,%esp
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 0e                	push   $0xe
  80140a:	e8 9a fe ff ff       	call   8012a9 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 0f                	push   $0xf
  801423:	e8 81 fe ff ff       	call   8012a9 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	ff 75 08             	pushl  0x8(%ebp)
  80143b:	6a 10                	push   $0x10
  80143d:	e8 67 fe ff ff       	call   8012a9 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 11                	push   $0x11
  801456:	e8 4e fe ff ff       	call   8012a9 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	90                   	nop
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_cputc>:

void
sys_cputc(const char c)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80146d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	50                   	push   %eax
  80147a:	6a 01                	push   $0x1
  80147c:	e8 28 fe ff ff       	call   8012a9 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	90                   	nop
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 14                	push   $0x14
  801496:	e8 0e fe ff ff       	call   8012a9 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	6a 00                	push   $0x0
  8014b9:	51                   	push   %ecx
  8014ba:	52                   	push   %edx
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	50                   	push   %eax
  8014bf:	6a 15                	push   $0x15
  8014c1:	e8 e3 fd ff ff       	call   8012a9 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	52                   	push   %edx
  8014db:	50                   	push   %eax
  8014dc:	6a 16                	push   $0x16
  8014de:	e8 c6 fd ff ff       	call   8012a9 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	51                   	push   %ecx
  8014f9:	52                   	push   %edx
  8014fa:	50                   	push   %eax
  8014fb:	6a 17                	push   $0x17
  8014fd:	e8 a7 fd ff ff       	call   8012a9 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	6a 18                	push   $0x18
  80151a:	e8 8a fd ff ff       	call   8012a9 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	50                   	push   %eax
  801536:	6a 19                	push   $0x19
  801538:	e8 6c fd ff ff       	call   8012a9 <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	50                   	push   %eax
  801551:	6a 1a                	push   $0x1a
  801553:	e8 51 fd ff ff       	call   8012a9 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
}
  80155b:	90                   	nop
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	50                   	push   %eax
  80156d:	6a 1b                	push   $0x1b
  80156f:	e8 35 fd ff ff       	call   8012a9 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 05                	push   $0x5
  801588:	e8 1c fd ff ff       	call   8012a9 <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 06                	push   $0x6
  8015a1:	e8 03 fd ff ff       	call   8012a9 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 07                	push   $0x7
  8015ba:	e8 ea fc ff ff       	call   8012a9 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_exit_env>:


void sys_exit_env(void)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 1c                	push   $0x1c
  8015d3:	e8 d1 fc ff ff       	call   8012a9 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	90                   	nop
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e7:	8d 50 04             	lea    0x4(%eax),%edx
  8015ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	6a 1d                	push   $0x1d
  8015f7:	e8 ad fc ff ff       	call   8012a9 <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
	return result;
  8015ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801602:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801605:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801608:	89 01                	mov    %eax,(%ecx)
  80160a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	c9                   	leave  
  801611:	c2 04 00             	ret    $0x4

00801614 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 10             	pushl  0x10(%ebp)
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	6a 13                	push   $0x13
  801626:	e8 7e fc ff ff       	call   8012a9 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
	return ;
  80162e:	90                   	nop
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_rcr2>:
uint32 sys_rcr2()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 1e                	push   $0x1e
  801640:	e8 64 fc ff ff       	call   8012a9 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801656:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	50                   	push   %eax
  801663:	6a 1f                	push   $0x1f
  801665:	e8 3f fc ff ff       	call   8012a9 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
	return ;
  80166d:	90                   	nop
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <rsttst>:
void rsttst()
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 21                	push   $0x21
  80167f:	e8 25 fc ff ff       	call   8012a9 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
	return ;
  801687:	90                   	nop
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	8b 45 14             	mov    0x14(%ebp),%eax
  801693:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801696:	8b 55 18             	mov    0x18(%ebp),%edx
  801699:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80169d:	52                   	push   %edx
  80169e:	50                   	push   %eax
  80169f:	ff 75 10             	pushl  0x10(%ebp)
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	6a 20                	push   $0x20
  8016aa:	e8 fa fb ff ff       	call   8012a9 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <chktst>:
void chktst(uint32 n)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	6a 22                	push   $0x22
  8016c5:	e8 df fb ff ff       	call   8012a9 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cd:	90                   	nop
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <inctst>:

void inctst()
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 23                	push   $0x23
  8016df:	e8 c5 fb ff ff       	call   8012a9 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e7:	90                   	nop
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <gettst>:
uint32 gettst()
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 24                	push   $0x24
  8016f9:	e8 ab fb ff ff       	call   8012a9 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 25                	push   $0x25
  801715:	e8 8f fb ff ff       	call   8012a9 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
  80171d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801720:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801724:	75 07                	jne    80172d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801726:	b8 01 00 00 00       	mov    $0x1,%eax
  80172b:	eb 05                	jmp    801732 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 25                	push   $0x25
  801746:	e8 5e fb ff ff       	call   8012a9 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
  80174e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801751:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801755:	75 07                	jne    80175e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801757:	b8 01 00 00 00       	mov    $0x1,%eax
  80175c:	eb 05                	jmp    801763 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 25                	push   $0x25
  801777:	e8 2d fb ff ff       	call   8012a9 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
  80177f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801782:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801786:	75 07                	jne    80178f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801788:	b8 01 00 00 00       	mov    $0x1,%eax
  80178d:	eb 05                	jmp    801794 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 25                	push   $0x25
  8017a8:	e8 fc fa ff ff       	call   8012a9 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
  8017b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017b3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017b7:	75 07                	jne    8017c0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017be:	eb 05                	jmp    8017c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	6a 26                	push   $0x26
  8017d7:	e8 cd fa ff ff       	call   8012a9 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8017df:	90                   	nop
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	53                   	push   %ebx
  8017f5:	51                   	push   %ecx
  8017f6:	52                   	push   %edx
  8017f7:	50                   	push   %eax
  8017f8:	6a 27                	push   $0x27
  8017fa:	e8 aa fa ff ff       	call   8012a9 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80180a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	52                   	push   %edx
  801817:	50                   	push   %eax
  801818:	6a 28                	push   $0x28
  80181a:	e8 8a fa ff ff       	call   8012a9 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801827:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	6a 00                	push   $0x0
  801832:	51                   	push   %ecx
  801833:	ff 75 10             	pushl  0x10(%ebp)
  801836:	52                   	push   %edx
  801837:	50                   	push   %eax
  801838:	6a 29                	push   $0x29
  80183a:	e8 6a fa ff ff       	call   8012a9 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 10             	pushl  0x10(%ebp)
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	6a 12                	push   $0x12
  801856:	e8 4e fa ff ff       	call   8012a9 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
	return ;
  80185e:	90                   	nop
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 2a                	push   $0x2a
  801874:	e8 30 fa ff ff       	call   8012a9 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
	return;
  80187c:	90                   	nop
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	50                   	push   %eax
  80188e:	6a 2b                	push   $0x2b
  801890:	e8 14 fa ff ff       	call   8012a9 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 2c                	push   $0x2c
  8018ab:	e8 f9 f9 ff ff       	call   8012a9 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
	return;
  8018b3:	90                   	nop
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 2d                	push   $0x2d
  8018c7:	e8 dd f9 ff ff       	call   8012a9 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
	return;
  8018cf:	90                   	nop
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018de:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	50                   	push   %eax
  8018e6:	e8 76 fb ff ff       	call   801461 <sys_cputc>
  8018eb:	83 c4 10             	add    $0x10,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <getchar>:


int
getchar(void)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8018f7:	e8 01 fa ff ff       	call   8012fd <sys_cgetc>
  8018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <iscons>:

int iscons(int fdnum)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801907:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801914:	8d 45 10             	lea    0x10(%ebp),%eax
  801917:	83 c0 04             	add    $0x4,%eax
  80191a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80191d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801922:	85 c0                	test   %eax,%eax
  801924:	74 16                	je     80193c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801926:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	50                   	push   %eax
  80192f:	68 4c 22 80 00       	push   $0x80224c
  801934:	e8 ce e9 ff ff       	call   800307 <cprintf>
  801939:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80193c:	a1 00 30 80 00       	mov    0x803000,%eax
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	50                   	push   %eax
  801948:	68 51 22 80 00       	push   $0x802251
  80194d:	e8 b5 e9 ff ff       	call   800307 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	ff 75 f4             	pushl  -0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	e8 38 e9 ff ff       	call   80029c <vcprintf>
  801964:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801967:	83 ec 08             	sub    $0x8,%esp
  80196a:	6a 00                	push   $0x0
  80196c:	68 6d 22 80 00       	push   $0x80226d
  801971:	e8 26 e9 ff ff       	call   80029c <vcprintf>
  801976:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801979:	e8 a7 e8 ff ff       	call   800225 <exit>

	// should not return here
	while (1) ;
  80197e:	eb fe                	jmp    80197e <_panic+0x70>

00801980 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801986:	a1 04 30 80 00       	mov    0x803004,%eax
  80198b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	39 c2                	cmp    %eax,%edx
  801996:	74 14                	je     8019ac <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	68 70 22 80 00       	push   $0x802270
  8019a0:	6a 26                	push   $0x26
  8019a2:	68 bc 22 80 00       	push   $0x8022bc
  8019a7:	e8 62 ff ff ff       	call   80190e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019ba:	e9 c5 00 00 00       	jmp    801a84 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	01 d0                	add    %edx,%eax
  8019ce:	8b 00                	mov    (%eax),%eax
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	75 08                	jne    8019dc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019d4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019d7:	e9 a5 00 00 00       	jmp    801a81 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019ea:	eb 69                	jmp    801a55 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8019f1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8019f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019fa:	89 d0                	mov    %edx,%eax
  8019fc:	01 c0                	add    %eax,%eax
  8019fe:	01 d0                	add    %edx,%eax
  801a00:	c1 e0 03             	shl    $0x3,%eax
  801a03:	01 c8                	add    %ecx,%eax
  801a05:	8a 40 04             	mov    0x4(%eax),%al
  801a08:	84 c0                	test   %al,%al
  801a0a:	75 46                	jne    801a52 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a0c:	a1 04 30 80 00       	mov    0x803004,%eax
  801a11:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	01 c0                	add    %eax,%eax
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	c1 e0 03             	shl    $0x3,%eax
  801a23:	01 c8                	add    %ecx,%eax
  801a25:	8b 00                	mov    (%eax),%eax
  801a27:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a32:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a37:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	01 c8                	add    %ecx,%eax
  801a43:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a45:	39 c2                	cmp    %eax,%edx
  801a47:	75 09                	jne    801a52 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a49:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a50:	eb 15                	jmp    801a67 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a52:	ff 45 e8             	incl   -0x18(%ebp)
  801a55:	a1 04 30 80 00       	mov    0x803004,%eax
  801a5a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a63:	39 c2                	cmp    %eax,%edx
  801a65:	77 85                	ja     8019ec <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a6b:	75 14                	jne    801a81 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	68 c8 22 80 00       	push   $0x8022c8
  801a75:	6a 3a                	push   $0x3a
  801a77:	68 bc 22 80 00       	push   $0x8022bc
  801a7c:	e8 8d fe ff ff       	call   80190e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a81:	ff 45 f0             	incl   -0x10(%ebp)
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a8a:	0f 8c 2f ff ff ff    	jl     8019bf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a97:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a9e:	eb 26                	jmp    801ac6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801aa0:	a1 04 30 80 00       	mov    0x803004,%eax
  801aa5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801aab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aae:	89 d0                	mov    %edx,%eax
  801ab0:	01 c0                	add    %eax,%eax
  801ab2:	01 d0                	add    %edx,%eax
  801ab4:	c1 e0 03             	shl    $0x3,%eax
  801ab7:	01 c8                	add    %ecx,%eax
  801ab9:	8a 40 04             	mov    0x4(%eax),%al
  801abc:	3c 01                	cmp    $0x1,%al
  801abe:	75 03                	jne    801ac3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ac0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac3:	ff 45 e0             	incl   -0x20(%ebp)
  801ac6:	a1 04 30 80 00       	mov    0x803004,%eax
  801acb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	77 c8                	ja     801aa0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ade:	74 14                	je     801af4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	68 1c 23 80 00       	push   $0x80231c
  801ae8:	6a 44                	push   $0x44
  801aea:	68 bc 22 80 00       	push   $0x8022bc
  801aef:	e8 1a fe ff ff       	call   80190e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    
  801af7:	90                   	nop

00801af8 <__udivdi3>:
  801af8:	55                   	push   %ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b0f:	89 ca                	mov    %ecx,%edx
  801b11:	89 f8                	mov    %edi,%eax
  801b13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b17:	85 f6                	test   %esi,%esi
  801b19:	75 2d                	jne    801b48 <__udivdi3+0x50>
  801b1b:	39 cf                	cmp    %ecx,%edi
  801b1d:	77 65                	ja     801b84 <__udivdi3+0x8c>
  801b1f:	89 fd                	mov    %edi,%ebp
  801b21:	85 ff                	test   %edi,%edi
  801b23:	75 0b                	jne    801b30 <__udivdi3+0x38>
  801b25:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	f7 f7                	div    %edi
  801b2e:	89 c5                	mov    %eax,%ebp
  801b30:	31 d2                	xor    %edx,%edx
  801b32:	89 c8                	mov    %ecx,%eax
  801b34:	f7 f5                	div    %ebp
  801b36:	89 c1                	mov    %eax,%ecx
  801b38:	89 d8                	mov    %ebx,%eax
  801b3a:	f7 f5                	div    %ebp
  801b3c:	89 cf                	mov    %ecx,%edi
  801b3e:	89 fa                	mov    %edi,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	39 ce                	cmp    %ecx,%esi
  801b4a:	77 28                	ja     801b74 <__udivdi3+0x7c>
  801b4c:	0f bd fe             	bsr    %esi,%edi
  801b4f:	83 f7 1f             	xor    $0x1f,%edi
  801b52:	75 40                	jne    801b94 <__udivdi3+0x9c>
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	72 0a                	jb     801b62 <__udivdi3+0x6a>
  801b58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b5c:	0f 87 9e 00 00 00    	ja     801c00 <__udivdi3+0x108>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	89 fa                	mov    %edi,%edx
  801b69:	83 c4 1c             	add    $0x1c,%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5e                   	pop    %esi
  801b6e:	5f                   	pop    %edi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    
  801b71:	8d 76 00             	lea    0x0(%esi),%esi
  801b74:	31 ff                	xor    %edi,%edi
  801b76:	31 c0                	xor    %eax,%eax
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	83 c4 1c             	add    $0x1c,%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	f7 f7                	div    %edi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	89 fa                	mov    %edi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b99:	89 eb                	mov    %ebp,%ebx
  801b9b:	29 fb                	sub    %edi,%ebx
  801b9d:	89 f9                	mov    %edi,%ecx
  801b9f:	d3 e6                	shl    %cl,%esi
  801ba1:	89 c5                	mov    %eax,%ebp
  801ba3:	88 d9                	mov    %bl,%cl
  801ba5:	d3 ed                	shr    %cl,%ebp
  801ba7:	89 e9                	mov    %ebp,%ecx
  801ba9:	09 f1                	or     %esi,%ecx
  801bab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801baf:	89 f9                	mov    %edi,%ecx
  801bb1:	d3 e0                	shl    %cl,%eax
  801bb3:	89 c5                	mov    %eax,%ebp
  801bb5:	89 d6                	mov    %edx,%esi
  801bb7:	88 d9                	mov    %bl,%cl
  801bb9:	d3 ee                	shr    %cl,%esi
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e2                	shl    %cl,%edx
  801bbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 e8                	shr    %cl,%eax
  801bc7:	09 c2                	or     %eax,%edx
  801bc9:	89 d0                	mov    %edx,%eax
  801bcb:	89 f2                	mov    %esi,%edx
  801bcd:	f7 74 24 0c          	divl   0xc(%esp)
  801bd1:	89 d6                	mov    %edx,%esi
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	f7 e5                	mul    %ebp
  801bd7:	39 d6                	cmp    %edx,%esi
  801bd9:	72 19                	jb     801bf4 <__udivdi3+0xfc>
  801bdb:	74 0b                	je     801be8 <__udivdi3+0xf0>
  801bdd:	89 d8                	mov    %ebx,%eax
  801bdf:	31 ff                	xor    %edi,%edi
  801be1:	e9 58 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bec:	89 f9                	mov    %edi,%ecx
  801bee:	d3 e2                	shl    %cl,%edx
  801bf0:	39 c2                	cmp    %eax,%edx
  801bf2:	73 e9                	jae    801bdd <__udivdi3+0xe5>
  801bf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bf7:	31 ff                	xor    %edi,%edi
  801bf9:	e9 40 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	31 c0                	xor    %eax,%eax
  801c02:	e9 37 ff ff ff       	jmp    801b3e <__udivdi3+0x46>
  801c07:	90                   	nop

00801c08 <__umoddi3>:
  801c08:	55                   	push   %ebp
  801c09:	57                   	push   %edi
  801c0a:	56                   	push   %esi
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 1c             	sub    $0x1c,%esp
  801c0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c27:	89 f3                	mov    %esi,%ebx
  801c29:	89 fa                	mov    %edi,%edx
  801c2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c2f:	89 34 24             	mov    %esi,(%esp)
  801c32:	85 c0                	test   %eax,%eax
  801c34:	75 1a                	jne    801c50 <__umoddi3+0x48>
  801c36:	39 f7                	cmp    %esi,%edi
  801c38:	0f 86 a2 00 00 00    	jbe    801ce0 <__umoddi3+0xd8>
  801c3e:	89 c8                	mov    %ecx,%eax
  801c40:	89 f2                	mov    %esi,%edx
  801c42:	f7 f7                	div    %edi
  801c44:	89 d0                	mov    %edx,%eax
  801c46:	31 d2                	xor    %edx,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 f0                	cmp    %esi,%eax
  801c52:	0f 87 ac 00 00 00    	ja     801d04 <__umoddi3+0xfc>
  801c58:	0f bd e8             	bsr    %eax,%ebp
  801c5b:	83 f5 1f             	xor    $0x1f,%ebp
  801c5e:	0f 84 ac 00 00 00    	je     801d10 <__umoddi3+0x108>
  801c64:	bf 20 00 00 00       	mov    $0x20,%edi
  801c69:	29 ef                	sub    %ebp,%edi
  801c6b:	89 fe                	mov    %edi,%esi
  801c6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c71:	89 e9                	mov    %ebp,%ecx
  801c73:	d3 e0                	shl    %cl,%eax
  801c75:	89 d7                	mov    %edx,%edi
  801c77:	89 f1                	mov    %esi,%ecx
  801c79:	d3 ef                	shr    %cl,%edi
  801c7b:	09 c7                	or     %eax,%edi
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e2                	shl    %cl,%edx
  801c81:	89 14 24             	mov    %edx,(%esp)
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	d3 e0                	shl    %cl,%eax
  801c88:	89 c2                	mov    %eax,%edx
  801c8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c8e:	d3 e0                	shl    %cl,%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c98:	89 f1                	mov    %esi,%ecx
  801c9a:	d3 e8                	shr    %cl,%eax
  801c9c:	09 d0                	or     %edx,%eax
  801c9e:	d3 eb                	shr    %cl,%ebx
  801ca0:	89 da                	mov    %ebx,%edx
  801ca2:	f7 f7                	div    %edi
  801ca4:	89 d3                	mov    %edx,%ebx
  801ca6:	f7 24 24             	mull   (%esp)
  801ca9:	89 c6                	mov    %eax,%esi
  801cab:	89 d1                	mov    %edx,%ecx
  801cad:	39 d3                	cmp    %edx,%ebx
  801caf:	0f 82 87 00 00 00    	jb     801d3c <__umoddi3+0x134>
  801cb5:	0f 84 91 00 00 00    	je     801d4c <__umoddi3+0x144>
  801cbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cbf:	29 f2                	sub    %esi,%edx
  801cc1:	19 cb                	sbb    %ecx,%ebx
  801cc3:	89 d8                	mov    %ebx,%eax
  801cc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cc9:	d3 e0                	shl    %cl,%eax
  801ccb:	89 e9                	mov    %ebp,%ecx
  801ccd:	d3 ea                	shr    %cl,%edx
  801ccf:	09 d0                	or     %edx,%eax
  801cd1:	89 e9                	mov    %ebp,%ecx
  801cd3:	d3 eb                	shr    %cl,%ebx
  801cd5:	89 da                	mov    %ebx,%edx
  801cd7:	83 c4 1c             	add    $0x1c,%esp
  801cda:	5b                   	pop    %ebx
  801cdb:	5e                   	pop    %esi
  801cdc:	5f                   	pop    %edi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    
  801cdf:	90                   	nop
  801ce0:	89 fd                	mov    %edi,%ebp
  801ce2:	85 ff                	test   %edi,%edi
  801ce4:	75 0b                	jne    801cf1 <__umoddi3+0xe9>
  801ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f7                	div    %edi
  801cef:	89 c5                	mov    %eax,%ebp
  801cf1:	89 f0                	mov    %esi,%eax
  801cf3:	31 d2                	xor    %edx,%edx
  801cf5:	f7 f5                	div    %ebp
  801cf7:	89 c8                	mov    %ecx,%eax
  801cf9:	f7 f5                	div    %ebp
  801cfb:	89 d0                	mov    %edx,%eax
  801cfd:	e9 44 ff ff ff       	jmp    801c46 <__umoddi3+0x3e>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	89 c8                	mov    %ecx,%eax
  801d06:	89 f2                	mov    %esi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	3b 04 24             	cmp    (%esp),%eax
  801d13:	72 06                	jb     801d1b <__umoddi3+0x113>
  801d15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d19:	77 0f                	ja     801d2a <__umoddi3+0x122>
  801d1b:	89 f2                	mov    %esi,%edx
  801d1d:	29 f9                	sub    %edi,%ecx
  801d1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d23:	89 14 24             	mov    %edx,(%esp)
  801d26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d2e:	8b 14 24             	mov    (%esp),%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d 76 00             	lea    0x0(%esi),%esi
  801d3c:	2b 04 24             	sub    (%esp),%eax
  801d3f:	19 fa                	sbb    %edi,%edx
  801d41:	89 d1                	mov    %edx,%ecx
  801d43:	89 c6                	mov    %eax,%esi
  801d45:	e9 71 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d50:	72 ea                	jb     801d3c <__umoddi3+0x134>
  801d52:	89 d9                	mov    %ebx,%ecx
  801d54:	e9 62 ff ff ff       	jmp    801cbb <__umoddi3+0xb3>
