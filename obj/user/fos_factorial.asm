
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
  800057:	e8 36 0a 00 00       	call   800a92 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 89 0e 00 00       	call   800efb <strtol>
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
  80009a:	e8 8d 02 00 00       	call   80032c <atomic_cprintf>
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
  8000fa:	e8 8b 14 00 00       	call   80158a <sys_getenvindex>
  8000ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	c1 e0 02             	shl    $0x2,%eax
  80010a:	01 d0                	add    %edx,%eax
  80010c:	01 c0                	add    %eax,%eax
  80010e:	01 d0                	add    %edx,%eax
  800110:	c1 e0 02             	shl    $0x2,%eax
  800113:	01 d0                	add    %edx,%eax
  800115:	01 c0                	add    %eax,%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	c1 e0 04             	shl    $0x4,%eax
  80011c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800121:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800126:	a1 04 30 80 00       	mov    0x803004,%eax
  80012b:	8a 40 20             	mov    0x20(%eax),%al
  80012e:	84 c0                	test   %al,%al
  800130:	74 0d                	je     80013f <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800132:	a1 04 30 80 00       	mov    0x803004,%eax
  800137:	83 c0 20             	add    $0x20,%eax
  80013a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800143:	7e 0a                	jle    80014f <libmain+0x5b>
		binaryname = argv[0];
  800145:	8b 45 0c             	mov    0xc(%ebp),%eax
  800148:	8b 00                	mov    (%eax),%eax
  80014a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	e8 db fe ff ff       	call   800038 <_main>
  80015d:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800160:	e8 a9 11 00 00       	call   80130e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 a4 1d 80 00       	push   $0x801da4
  80016d:	e8 8d 01 00 00       	call   8002ff <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800175:	a1 04 30 80 00       	mov    0x803004,%eax
  80017a:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800180:	a1 04 30 80 00       	mov    0x803004,%eax
  800185:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80018b:	83 ec 04             	sub    $0x4,%esp
  80018e:	52                   	push   %edx
  80018f:	50                   	push   %eax
  800190:	68 cc 1d 80 00       	push   $0x801dcc
  800195:	e8 65 01 00 00       	call   8002ff <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80019d:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a2:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ad:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b8:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001be:	51                   	push   %ecx
  8001bf:	52                   	push   %edx
  8001c0:	50                   	push   %eax
  8001c1:	68 f4 1d 80 00       	push   $0x801df4
  8001c6:	e8 34 01 00 00       	call   8002ff <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d3:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	50                   	push   %eax
  8001dd:	68 4c 1e 80 00       	push   $0x801e4c
  8001e2:	e8 18 01 00 00       	call   8002ff <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	68 a4 1d 80 00       	push   $0x801da4
  8001f2:	e8 08 01 00 00       	call   8002ff <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001fa:	e8 29 11 00 00       	call   801328 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001ff:	e8 19 00 00 00       	call   80021d <exit>
}
  800204:	90                   	nop
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	6a 00                	push   $0x0
  800212:	e8 3f 13 00 00       	call   801556 <sys_destroy_env>
  800217:	83 c4 10             	add    $0x10,%esp
}
  80021a:	90                   	nop
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <exit>:

void
exit(void)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800223:	e8 94 13 00 00       	call   8015bc <sys_exit_env>
}
  800228:	90                   	nop
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	8d 48 01             	lea    0x1(%eax),%ecx
  800239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023c:	89 0a                	mov    %ecx,(%edx)
  80023e:	8b 55 08             	mov    0x8(%ebp),%edx
  800241:	88 d1                	mov    %dl,%cl
  800243:	8b 55 0c             	mov    0xc(%ebp),%edx
  800246:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024d:	8b 00                	mov    (%eax),%eax
  80024f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800254:	75 2c                	jne    800282 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800256:	a0 08 30 80 00       	mov    0x803008,%al
  80025b:	0f b6 c0             	movzbl %al,%eax
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	8b 12                	mov    (%edx),%edx
  800263:	89 d1                	mov    %edx,%ecx
  800265:	8b 55 0c             	mov    0xc(%ebp),%edx
  800268:	83 c2 08             	add    $0x8,%edx
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	50                   	push   %eax
  80026f:	51                   	push   %ecx
  800270:	52                   	push   %edx
  800271:	e8 56 10 00 00       	call   8012cc <sys_cputs>
  800276:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800282:	8b 45 0c             	mov    0xc(%ebp),%eax
  800285:	8b 40 04             	mov    0x4(%eax),%eax
  800288:	8d 50 01             	lea    0x1(%eax),%edx
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a4:	00 00 00 
	b.cnt = 0;
  8002a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ae:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002bd:	50                   	push   %eax
  8002be:	68 2b 02 80 00       	push   $0x80022b
  8002c3:	e8 11 02 00 00       	call   8004d9 <vprintfmt>
  8002c8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002cb:	a0 08 30 80 00       	mov    0x803008,%al
  8002d0:	0f b6 c0             	movzbl %al,%eax
  8002d3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d9:	83 ec 04             	sub    $0x4,%esp
  8002dc:	50                   	push   %eax
  8002dd:	52                   	push   %edx
  8002de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e4:	83 c0 08             	add    $0x8,%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 df 0f 00 00       	call   8012cc <sys_cputs>
  8002ed:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f0:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800305:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80030c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	ff 75 f4             	pushl  -0xc(%ebp)
  80031b:	50                   	push   %eax
  80031c:	e8 73 ff ff ff       	call   800294 <vcprintf>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800327:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800332:	e8 d7 0f 00 00       	call   80130e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800337:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	ff 75 f4             	pushl  -0xc(%ebp)
  800346:	50                   	push   %eax
  800347:	e8 48 ff ff ff       	call   800294 <vcprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800352:	e8 d1 0f 00 00       	call   801328 <sys_unlock_cons>
	return cnt;
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	53                   	push   %ebx
  800360:	83 ec 14             	sub    $0x14,%esp
  800363:	8b 45 10             	mov    0x10(%ebp),%eax
  800366:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036f:	8b 45 18             	mov    0x18(%ebp),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
  800377:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037a:	77 55                	ja     8003d1 <printnum+0x75>
  80037c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037f:	72 05                	jb     800386 <printnum+0x2a>
  800381:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800384:	77 4b                	ja     8003d1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800386:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800389:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80038c:	8b 45 18             	mov    0x18(%ebp),%eax
  80038f:	ba 00 00 00 00       	mov    $0x0,%edx
  800394:	52                   	push   %edx
  800395:	50                   	push   %eax
  800396:	ff 75 f4             	pushl  -0xc(%ebp)
  800399:	ff 75 f0             	pushl  -0x10(%ebp)
  80039c:	e8 4f 17 00 00       	call   801af0 <__udivdi3>
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	83 ec 04             	sub    $0x4,%esp
  8003a7:	ff 75 20             	pushl  0x20(%ebp)
  8003aa:	53                   	push   %ebx
  8003ab:	ff 75 18             	pushl  0x18(%ebp)
  8003ae:	52                   	push   %edx
  8003af:	50                   	push   %eax
  8003b0:	ff 75 0c             	pushl  0xc(%ebp)
  8003b3:	ff 75 08             	pushl  0x8(%ebp)
  8003b6:	e8 a1 ff ff ff       	call   80035c <printnum>
  8003bb:	83 c4 20             	add    $0x20,%esp
  8003be:	eb 1a                	jmp    8003da <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 20             	pushl  0x20(%ebp)
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	ff d0                	call   *%eax
  8003ce:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d1:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d8:	7f e6                	jg     8003c0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003da:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e8:	53                   	push   %ebx
  8003e9:	51                   	push   %ecx
  8003ea:	52                   	push   %edx
  8003eb:	50                   	push   %eax
  8003ec:	e8 0f 18 00 00       	call   801c00 <__umoddi3>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	05 74 20 80 00       	add    $0x802074,%eax
  8003f9:	8a 00                	mov    (%eax),%al
  8003fb:	0f be c0             	movsbl %al,%eax
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	ff 75 0c             	pushl  0xc(%ebp)
  800404:	50                   	push   %eax
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	ff d0                	call   *%eax
  80040a:	83 c4 10             	add    $0x10,%esp
}
  80040d:	90                   	nop
  80040e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800411:	c9                   	leave  
  800412:	c3                   	ret    

00800413 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800416:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041a:	7e 1c                	jle    800438 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 08             	lea    0x8(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 08             	sub    $0x8,%eax
  800431:	8b 50 04             	mov    0x4(%eax),%edx
  800434:	8b 00                	mov    (%eax),%eax
  800436:	eb 40                	jmp    800478 <getuint+0x65>
	else if (lflag)
  800438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043c:	74 1e                	je     80045c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	8d 50 04             	lea    0x4(%eax),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	89 10                	mov    %edx,(%eax)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	83 e8 04             	sub    $0x4,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	ba 00 00 00 00       	mov    $0x0,%edx
  80045a:	eb 1c                	jmp    800478 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	8d 50 04             	lea    0x4(%eax),%edx
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	89 10                	mov    %edx,(%eax)
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	83 e8 04             	sub    $0x4,%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800478:	5d                   	pop    %ebp
  800479:	c3                   	ret    

0080047a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800481:	7e 1c                	jle    80049f <getint+0x25>
		return va_arg(*ap, long long);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	8d 50 08             	lea    0x8(%eax),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 10                	mov    %edx,(%eax)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	83 e8 08             	sub    $0x8,%eax
  800498:	8b 50 04             	mov    0x4(%eax),%edx
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	eb 38                	jmp    8004d7 <getint+0x5d>
	else if (lflag)
  80049f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a3:	74 1a                	je     8004bf <getint+0x45>
		return va_arg(*ap, long);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	99                   	cltd   
  8004bd:	eb 18                	jmp    8004d7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	8d 50 04             	lea    0x4(%eax),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 10                	mov    %edx,(%eax)
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	83 e8 04             	sub    $0x4,%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	99                   	cltd   
}
  8004d7:	5d                   	pop    %ebp
  8004d8:	c3                   	ret    

008004d9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	56                   	push   %esi
  8004dd:	53                   	push   %ebx
  8004de:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e1:	eb 17                	jmp    8004fa <vprintfmt+0x21>
			if (ch == '\0')
  8004e3:	85 db                	test   %ebx,%ebx
  8004e5:	0f 84 c1 03 00 00    	je     8008ac <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	53                   	push   %ebx
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	ff d0                	call   *%eax
  8004f7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	8d 50 01             	lea    0x1(%eax),%edx
  800500:	89 55 10             	mov    %edx,0x10(%ebp)
  800503:	8a 00                	mov    (%eax),%al
  800505:	0f b6 d8             	movzbl %al,%ebx
  800508:	83 fb 25             	cmp    $0x25,%ebx
  80050b:	75 d6                	jne    8004e3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800511:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800518:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800526:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052d:	8b 45 10             	mov    0x10(%ebp),%eax
  800530:	8d 50 01             	lea    0x1(%eax),%edx
  800533:	89 55 10             	mov    %edx,0x10(%ebp)
  800536:	8a 00                	mov    (%eax),%al
  800538:	0f b6 d8             	movzbl %al,%ebx
  80053b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80053e:	83 f8 5b             	cmp    $0x5b,%eax
  800541:	0f 87 3d 03 00 00    	ja     800884 <vprintfmt+0x3ab>
  800547:	8b 04 85 98 20 80 00 	mov    0x802098(,%eax,4),%eax
  80054e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800550:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800554:	eb d7                	jmp    80052d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800556:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80055a:	eb d1                	jmp    80052d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800563:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800566:	89 d0                	mov    %edx,%eax
  800568:	c1 e0 02             	shl    $0x2,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d8                	add    %ebx,%eax
  800571:	83 e8 30             	sub    $0x30,%eax
  800574:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8a 00                	mov    (%eax),%al
  80057c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80057f:	83 fb 2f             	cmp    $0x2f,%ebx
  800582:	7e 3e                	jle    8005c2 <vprintfmt+0xe9>
  800584:	83 fb 39             	cmp    $0x39,%ebx
  800587:	7f 39                	jg     8005c2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800589:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80058c:	eb d5                	jmp    800563 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	83 c0 04             	add    $0x4,%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	83 e8 04             	sub    $0x4,%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a2:	eb 1f                	jmp    8005c3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a8:	79 83                	jns    80052d <vprintfmt+0x54>
				width = 0;
  8005aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b1:	e9 77 ff ff ff       	jmp    80052d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005bd:	e9 6b ff ff ff       	jmp    80052d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c7:	0f 89 60 ff ff ff    	jns    80052d <vprintfmt+0x54>
				width = precision, precision = -1;
  8005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005da:	e9 4e ff ff ff       	jmp    80052d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005df:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e2:	e9 46 ff ff ff       	jmp    80052d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	83 e8 04             	sub    $0x4,%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	ff 75 0c             	pushl  0xc(%ebp)
  8005fe:	50                   	push   %eax
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	ff d0                	call   *%eax
  800604:	83 c4 10             	add    $0x10,%esp
			break;
  800607:	e9 9b 02 00 00       	jmp    8008a7 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	83 c0 04             	add    $0x4,%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	83 e8 04             	sub    $0x4,%eax
  80061b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80061d:	85 db                	test   %ebx,%ebx
  80061f:	79 02                	jns    800623 <vprintfmt+0x14a>
				err = -err;
  800621:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800623:	83 fb 64             	cmp    $0x64,%ebx
  800626:	7f 0b                	jg     800633 <vprintfmt+0x15a>
  800628:	8b 34 9d e0 1e 80 00 	mov    0x801ee0(,%ebx,4),%esi
  80062f:	85 f6                	test   %esi,%esi
  800631:	75 19                	jne    80064c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800633:	53                   	push   %ebx
  800634:	68 85 20 80 00       	push   $0x802085
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 08             	pushl  0x8(%ebp)
  80063f:	e8 70 02 00 00       	call   8008b4 <printfmt>
  800644:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800647:	e9 5b 02 00 00       	jmp    8008a7 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80064c:	56                   	push   %esi
  80064d:	68 8e 20 80 00       	push   $0x80208e
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 08             	pushl  0x8(%ebp)
  800658:	e8 57 02 00 00       	call   8008b4 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			break;
  800660:	e9 42 02 00 00       	jmp    8008a7 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	83 c0 04             	add    $0x4,%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	83 e8 04             	sub    $0x4,%eax
  800674:	8b 30                	mov    (%eax),%esi
  800676:	85 f6                	test   %esi,%esi
  800678:	75 05                	jne    80067f <vprintfmt+0x1a6>
				p = "(null)";
  80067a:	be 91 20 80 00       	mov    $0x802091,%esi
			if (width > 0 && padc != '-')
  80067f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800683:	7e 6d                	jle    8006f2 <vprintfmt+0x219>
  800685:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800689:	74 67                	je     8006f2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	50                   	push   %eax
  800692:	56                   	push   %esi
  800693:	e8 26 05 00 00       	call   800bbe <strnlen>
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80069e:	eb 16                	jmp    8006b6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	50                   	push   %eax
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	ff d0                	call   *%eax
  8006b0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b3:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ba:	7f e4                	jg     8006a0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bc:	eb 34                	jmp    8006f2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c2:	74 1c                	je     8006e0 <vprintfmt+0x207>
  8006c4:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c7:	7e 05                	jle    8006ce <vprintfmt+0x1f5>
  8006c9:	83 fb 7e             	cmp    $0x7e,%ebx
  8006cc:	7e 12                	jle    8006e0 <vprintfmt+0x207>
					putch('?', putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	ff 75 0c             	pushl  0xc(%ebp)
  8006d4:	6a 3f                	push   $0x3f
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	ff d0                	call   *%eax
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	eb 0f                	jmp    8006ef <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	53                   	push   %ebx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	ff d0                	call   *%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f2:	89 f0                	mov    %esi,%eax
  8006f4:	8d 70 01             	lea    0x1(%eax),%esi
  8006f7:	8a 00                	mov    (%eax),%al
  8006f9:	0f be d8             	movsbl %al,%ebx
  8006fc:	85 db                	test   %ebx,%ebx
  8006fe:	74 24                	je     800724 <vprintfmt+0x24b>
  800700:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800704:	78 b8                	js     8006be <vprintfmt+0x1e5>
  800706:	ff 4d e0             	decl   -0x20(%ebp)
  800709:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070d:	79 af                	jns    8006be <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070f:	eb 13                	jmp    800724 <vprintfmt+0x24b>
				putch(' ', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	6a 20                	push   $0x20
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800721:	ff 4d e4             	decl   -0x1c(%ebp)
  800724:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800728:	7f e7                	jg     800711 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80072a:	e9 78 01 00 00       	jmp    8008a7 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 e8             	pushl  -0x18(%ebp)
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
  800738:	50                   	push   %eax
  800739:	e8 3c fd ff ff       	call   80047a <getint>
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800744:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074d:	85 d2                	test   %edx,%edx
  80074f:	79 23                	jns    800774 <vprintfmt+0x29b>
				putch('-', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	6a 2d                	push   $0x2d
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800767:	f7 d8                	neg    %eax
  800769:	83 d2 00             	adc    $0x0,%edx
  80076c:	f7 da                	neg    %edx
  80076e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800771:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800774:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077b:	e9 bc 00 00 00       	jmp    80083c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 e8             	pushl  -0x18(%ebp)
  800786:	8d 45 14             	lea    0x14(%ebp),%eax
  800789:	50                   	push   %eax
  80078a:	e8 84 fc ff ff       	call   800413 <getuint>
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800795:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800798:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80079f:	e9 98 00 00 00       	jmp    80083c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	6a 58                	push   $0x58
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	6a 58                	push   $0x58
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	6a 58                	push   $0x58
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
			break;
  8007d4:	e9 ce 00 00 00       	jmp    8008a7 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	ff 75 0c             	pushl  0xc(%ebp)
  8007df:	6a 30                	push   $0x30
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	ff d0                	call   *%eax
  8007e6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 0c             	pushl  0xc(%ebp)
  8007ef:	6a 78                	push   $0x78
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800814:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80081b:	eb 1f                	jmp    80083c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 e8             	pushl  -0x18(%ebp)
  800823:	8d 45 14             	lea    0x14(%ebp),%eax
  800826:	50                   	push   %eax
  800827:	e8 e7 fb ff ff       	call   800413 <getuint>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800832:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800835:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80083c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	52                   	push   %edx
  800847:	ff 75 e4             	pushl  -0x1c(%ebp)
  80084a:	50                   	push   %eax
  80084b:	ff 75 f4             	pushl  -0xc(%ebp)
  80084e:	ff 75 f0             	pushl  -0x10(%ebp)
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	ff 75 08             	pushl  0x8(%ebp)
  800857:	e8 00 fb ff ff       	call   80035c <printnum>
  80085c:	83 c4 20             	add    $0x20,%esp
			break;
  80085f:	eb 46                	jmp    8008a7 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	53                   	push   %ebx
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	eb 35                	jmp    8008a7 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800872:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800879:	eb 2c                	jmp    8008a7 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80087b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800882:	eb 23                	jmp    8008a7 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	6a 25                	push   $0x25
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	ff d0                	call   *%eax
  800891:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800894:	ff 4d 10             	decl   0x10(%ebp)
  800897:	eb 03                	jmp    80089c <vprintfmt+0x3c3>
  800899:	ff 4d 10             	decl   0x10(%ebp)
  80089c:	8b 45 10             	mov    0x10(%ebp),%eax
  80089f:	48                   	dec    %eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	3c 25                	cmp    $0x25,%al
  8008a4:	75 f3                	jne    800899 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008a6:	90                   	nop
		}
	}
  8008a7:	e9 35 fc ff ff       	jmp    8004e1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ac:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b0:	5b                   	pop    %ebx
  8008b1:	5e                   	pop    %esi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8008bd:	83 c0 04             	add    $0x4,%eax
  8008c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c9:	50                   	push   %eax
  8008ca:	ff 75 0c             	pushl  0xc(%ebp)
  8008cd:	ff 75 08             	pushl  0x8(%ebp)
  8008d0:	e8 04 fc ff ff       	call   8004d9 <vprintfmt>
  8008d5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d8:	90                   	nop
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	8b 40 08             	mov    0x8(%eax),%eax
  8008e4:	8d 50 01             	lea    0x1(%eax),%edx
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f0:	8b 10                	mov    (%eax),%edx
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	8b 40 04             	mov    0x4(%eax),%eax
  8008f8:	39 c2                	cmp    %eax,%edx
  8008fa:	73 12                	jae    80090e <sprintputch+0x33>
		*b->buf++ = ch;
  8008fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	8d 48 01             	lea    0x1(%eax),%ecx
  800904:	8b 55 0c             	mov    0xc(%ebp),%edx
  800907:	89 0a                	mov    %ecx,(%edx)
  800909:	8b 55 08             	mov    0x8(%ebp),%edx
  80090c:	88 10                	mov    %dl,(%eax)
}
  80090e:	90                   	nop
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8d 50 ff             	lea    -0x1(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	01 d0                	add    %edx,%eax
  800928:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800932:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800936:	74 06                	je     80093e <vsnprintf+0x2d>
  800938:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093c:	7f 07                	jg     800945 <vsnprintf+0x34>
		return -E_INVAL;
  80093e:	b8 03 00 00 00       	mov    $0x3,%eax
  800943:	eb 20                	jmp    800965 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800945:	ff 75 14             	pushl  0x14(%ebp)
  800948:	ff 75 10             	pushl  0x10(%ebp)
  80094b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	68 db 08 80 00       	push   $0x8008db
  800954:	e8 80 fb ff ff       	call   8004d9 <vprintfmt>
  800959:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80095c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800962:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096d:	8d 45 10             	lea    0x10(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800976:	8b 45 10             	mov    0x10(%ebp),%eax
  800979:	ff 75 f4             	pushl  -0xc(%ebp)
  80097c:	50                   	push   %eax
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	ff 75 08             	pushl  0x8(%ebp)
  800983:	e8 89 ff ff ff       	call   800911 <vsnprintf>
  800988:	83 c4 10             	add    $0x10,%esp
  80098b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80098e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800999:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80099d:	74 13                	je     8009b2 <readline+0x1f>
		cprintf("%s", prompt);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	68 08 22 80 00       	push   $0x802208
  8009aa:	e8 50 f9 ff ff       	call   8002ff <cprintf>
  8009af:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009b9:	83 ec 0c             	sub    $0xc,%esp
  8009bc:	6a 00                	push   $0x0
  8009be:	e8 39 0f 00 00       	call   8018fc <iscons>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009c9:	e8 1b 0f 00 00       	call   8018e9 <getchar>
  8009ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009d5:	79 22                	jns    8009f9 <readline+0x66>
			if (c != -E_EOF)
  8009d7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009db:	0f 84 ad 00 00 00    	je     800a8e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009e1:	83 ec 08             	sub    $0x8,%esp
  8009e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e7:	68 0b 22 80 00       	push   $0x80220b
  8009ec:	e8 0e f9 ff ff       	call   8002ff <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp
			break;
  8009f4:	e9 95 00 00 00       	jmp    800a8e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009f9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009fd:	7e 34                	jle    800a33 <readline+0xa0>
  8009ff:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a06:	7f 2b                	jg     800a33 <readline+0xa0>
			if (echoing)
  800a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a0c:	74 0e                	je     800a1c <readline+0x89>
				cputchar(c);
  800a0e:	83 ec 0c             	sub    $0xc,%esp
  800a11:	ff 75 ec             	pushl  -0x14(%ebp)
  800a14:	e8 b1 0e 00 00       	call   8018ca <cputchar>
  800a19:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1f:	8d 50 01             	lea    0x1(%eax),%edx
  800a22:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a25:	89 c2                	mov    %eax,%edx
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	01 d0                	add    %edx,%eax
  800a2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a2f:	88 10                	mov    %dl,(%eax)
  800a31:	eb 56                	jmp    800a89 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a33:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a37:	75 1f                	jne    800a58 <readline+0xc5>
  800a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a3d:	7e 19                	jle    800a58 <readline+0xc5>
			if (echoing)
  800a3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a43:	74 0e                	je     800a53 <readline+0xc0>
				cputchar(c);
  800a45:	83 ec 0c             	sub    $0xc,%esp
  800a48:	ff 75 ec             	pushl  -0x14(%ebp)
  800a4b:	e8 7a 0e 00 00       	call   8018ca <cputchar>
  800a50:	83 c4 10             	add    $0x10,%esp

			i--;
  800a53:	ff 4d f4             	decl   -0xc(%ebp)
  800a56:	eb 31                	jmp    800a89 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a58:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a5c:	74 0a                	je     800a68 <readline+0xd5>
  800a5e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a62:	0f 85 61 ff ff ff    	jne    8009c9 <readline+0x36>
			if (echoing)
  800a68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a6c:	74 0e                	je     800a7c <readline+0xe9>
				cputchar(c);
  800a6e:	83 ec 0c             	sub    $0xc,%esp
  800a71:	ff 75 ec             	pushl  -0x14(%ebp)
  800a74:	e8 51 0e 00 00       	call   8018ca <cputchar>
  800a79:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	01 d0                	add    %edx,%eax
  800a84:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a87:	eb 06                	jmp    800a8f <readline+0xfc>
		}
	}
  800a89:	e9 3b ff ff ff       	jmp    8009c9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a8e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a8f:	90                   	nop
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a98:	e8 71 08 00 00       	call   80130e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa1:	74 13                	je     800ab6 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 08             	pushl  0x8(%ebp)
  800aa9:	68 08 22 80 00       	push   $0x802208
  800aae:	e8 4c f8 ff ff       	call   8002ff <cprintf>
  800ab3:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800abd:	83 ec 0c             	sub    $0xc,%esp
  800ac0:	6a 00                	push   $0x0
  800ac2:	e8 35 0e 00 00       	call   8018fc <iscons>
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800acd:	e8 17 0e 00 00       	call   8018e9 <getchar>
  800ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ad9:	79 22                	jns    800afd <atomic_readline+0x6b>
				if (c != -E_EOF)
  800adb:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800adf:	0f 84 ad 00 00 00    	je     800b92 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 ec             	pushl  -0x14(%ebp)
  800aeb:	68 0b 22 80 00       	push   $0x80220b
  800af0:	e8 0a f8 ff ff       	call   8002ff <cprintf>
  800af5:	83 c4 10             	add    $0x10,%esp
				break;
  800af8:	e9 95 00 00 00       	jmp    800b92 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800afd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b01:	7e 34                	jle    800b37 <atomic_readline+0xa5>
  800b03:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b0a:	7f 2b                	jg     800b37 <atomic_readline+0xa5>
				if (echoing)
  800b0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b10:	74 0e                	je     800b20 <atomic_readline+0x8e>
					cputchar(c);
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	ff 75 ec             	pushl  -0x14(%ebp)
  800b18:	e8 ad 0d 00 00       	call   8018ca <cputchar>
  800b1d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b23:	8d 50 01             	lea    0x1(%eax),%edx
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2e:	01 d0                	add    %edx,%eax
  800b30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b33:	88 10                	mov    %dl,(%eax)
  800b35:	eb 56                	jmp    800b8d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b37:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b3b:	75 1f                	jne    800b5c <atomic_readline+0xca>
  800b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b41:	7e 19                	jle    800b5c <atomic_readline+0xca>
				if (echoing)
  800b43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b47:	74 0e                	je     800b57 <atomic_readline+0xc5>
					cputchar(c);
  800b49:	83 ec 0c             	sub    $0xc,%esp
  800b4c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4f:	e8 76 0d 00 00       	call   8018ca <cputchar>
  800b54:	83 c4 10             	add    $0x10,%esp
				i--;
  800b57:	ff 4d f4             	decl   -0xc(%ebp)
  800b5a:	eb 31                	jmp    800b8d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b5c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b60:	74 0a                	je     800b6c <atomic_readline+0xda>
  800b62:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b66:	0f 85 61 ff ff ff    	jne    800acd <atomic_readline+0x3b>
				if (echoing)
  800b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b70:	74 0e                	je     800b80 <atomic_readline+0xee>
					cputchar(c);
  800b72:	83 ec 0c             	sub    $0xc,%esp
  800b75:	ff 75 ec             	pushl  -0x14(%ebp)
  800b78:	e8 4d 0d 00 00       	call   8018ca <cputchar>
  800b7d:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b8b:	eb 06                	jmp    800b93 <atomic_readline+0x101>
			}
		}
  800b8d:	e9 3b ff ff ff       	jmp    800acd <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b92:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b93:	e8 90 07 00 00       	call   801328 <sys_unlock_cons>
}
  800b98:	90                   	nop
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba8:	eb 06                	jmp    800bb0 <strlen+0x15>
		n++;
  800baa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 f1                	jne    800baa <strlen+0xf>
		n++;
	return n;
  800bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcb:	eb 09                	jmp    800bd6 <strnlen+0x18>
		n++;
  800bcd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	ff 45 08             	incl   0x8(%ebp)
  800bd3:	ff 4d 0c             	decl   0xc(%ebp)
  800bd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bda:	74 09                	je     800be5 <strnlen+0x27>
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8a 00                	mov    (%eax),%al
  800be1:	84 c0                	test   %al,%al
  800be3:	75 e8                	jne    800bcd <strnlen+0xf>
		n++;
	return n;
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf6:	90                   	nop
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8d 50 01             	lea    0x1(%eax),%edx
  800bfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c06:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c09:	8a 12                	mov    (%edx),%dl
  800c0b:	88 10                	mov    %dl,(%eax)
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	84 c0                	test   %al,%al
  800c11:	75 e4                	jne    800bf7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2b:	eb 1f                	jmp    800c4c <strncpy+0x34>
		*dst++ = *src;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8d 50 01             	lea    0x1(%eax),%edx
  800c33:	89 55 08             	mov    %edx,0x8(%ebp)
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	8a 12                	mov    (%edx),%dl
  800c3b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	74 03                	je     800c49 <strncpy+0x31>
			src++;
  800c46:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c49:	ff 45 fc             	incl   -0x4(%ebp)
  800c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c52:	72 d9                	jb     800c2d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c54:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c69:	74 30                	je     800c9b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c6b:	eb 16                	jmp    800c83 <strlcpy+0x2a>
			*dst++ = *src++;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	89 55 08             	mov    %edx,0x8(%ebp)
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7f:	8a 12                	mov    (%edx),%dl
  800c81:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c83:	ff 4d 10             	decl   0x10(%ebp)
  800c86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8a:	74 09                	je     800c95 <strlcpy+0x3c>
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 d8                	jne    800c6d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca1:	29 c2                	sub    %eax,%edx
  800ca3:	89 d0                	mov    %edx,%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800caa:	eb 06                	jmp    800cb2 <strcmp+0xb>
		p++, q++;
  800cac:	ff 45 08             	incl   0x8(%ebp)
  800caf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	84 c0                	test   %al,%al
  800cb9:	74 0e                	je     800cc9 <strcmp+0x22>
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 10                	mov    (%eax),%dl
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	38 c2                	cmp    %al,%dl
  800cc7:	74 e3                	je     800cac <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	0f b6 d0             	movzbl %al,%edx
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	0f b6 c0             	movzbl %al,%eax
  800cd9:	29 c2                	sub    %eax,%edx
  800cdb:	89 d0                	mov    %edx,%eax
}
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce2:	eb 09                	jmp    800ced <strncmp+0xe>
		n--, p++, q++;
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	ff 45 08             	incl   0x8(%ebp)
  800cea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ced:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf1:	74 17                	je     800d0a <strncmp+0x2b>
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	84 c0                	test   %al,%al
  800cfa:	74 0e                	je     800d0a <strncmp+0x2b>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 10                	mov    (%eax),%dl
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	38 c2                	cmp    %al,%dl
  800d08:	74 da                	je     800ce4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	75 07                	jne    800d17 <strncmp+0x38>
		return 0;
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
  800d15:	eb 14                	jmp    800d2b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	0f b6 d0             	movzbl %al,%edx
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	29 c2                	sub    %eax,%edx
  800d29:	89 d0                	mov    %edx,%eax
}
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 04             	sub    $0x4,%esp
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d39:	eb 12                	jmp    800d4d <strchr+0x20>
		if (*s == c)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d43:	75 05                	jne    800d4a <strchr+0x1d>
			return (char *) s;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	eb 11                	jmp    800d5b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 e5                	jne    800d3b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 04             	sub    $0x4,%esp
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d69:	eb 0d                	jmp    800d78 <strfind+0x1b>
		if (*s == c)
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d73:	74 0e                	je     800d83 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 ea                	jne    800d6b <strfind+0xe>
  800d81:	eb 01                	jmp    800d84 <strfind+0x27>
		if (*s == c)
			break;
  800d83:	90                   	nop
	return (char *) s;
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d95:	8b 45 10             	mov    0x10(%ebp),%eax
  800d98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d9b:	eb 0e                	jmp    800dab <memset+0x22>
		*p++ = c;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da0:	8d 50 01             	lea    0x1(%eax),%edx
  800da3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dab:	ff 4d f8             	decl   -0x8(%ebp)
  800dae:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db2:	79 e9                	jns    800d9d <memset+0x14>
		*p++ = c;

	return v;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dcb:	eb 16                	jmp    800de3 <memcpy+0x2a>
		*d++ = *s++;
  800dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd0:	8d 50 01             	lea    0x1(%eax),%edx
  800dd3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ddc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ddf:	8a 12                	mov    (%edx),%dl
  800de1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	75 dd                	jne    800dcd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0d:	73 50                	jae    800e5f <memmove+0x6a>
  800e0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1a:	76 43                	jbe    800e5f <memmove+0x6a>
		s += n;
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e28:	eb 10                	jmp    800e3a <memmove+0x45>
			*--d = *--s;
  800e2a:	ff 4d f8             	decl   -0x8(%ebp)
  800e2d:	ff 4d fc             	decl   -0x4(%ebp)
  800e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e33:	8a 10                	mov    (%eax),%dl
  800e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e38:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e40:	89 55 10             	mov    %edx,0x10(%ebp)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	75 e3                	jne    800e2a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e47:	eb 23                	jmp    800e6c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4c:	8d 50 01             	lea    0x1(%eax),%edx
  800e4f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e58:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e5b:	8a 12                	mov    (%edx),%dl
  800e5d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e65:	89 55 10             	mov    %edx,0x10(%ebp)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	75 dd                	jne    800e49 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e83:	eb 2a                	jmp    800eaf <memcmp+0x3e>
		if (*s1 != *s2)
  800e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e88:	8a 10                	mov    (%eax),%dl
  800e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	38 c2                	cmp    %al,%dl
  800e91:	74 16                	je     800ea9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	0f b6 d0             	movzbl %al,%edx
  800e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	0f b6 c0             	movzbl %al,%eax
  800ea3:	29 c2                	sub    %eax,%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	eb 18                	jmp    800ec1 <memcmp+0x50>
		s1++, s2++;
  800ea9:	ff 45 fc             	incl   -0x4(%ebp)
  800eac:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	75 c9                	jne    800e85 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 d0                	add    %edx,%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed4:	eb 15                	jmp    800eeb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	0f b6 d0             	movzbl %al,%edx
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	0f b6 c0             	movzbl %al,%eax
  800ee4:	39 c2                	cmp    %eax,%edx
  800ee6:	74 0d                	je     800ef5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ee8:	ff 45 08             	incl   0x8(%ebp)
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef1:	72 e3                	jb     800ed6 <memfind+0x13>
  800ef3:	eb 01                	jmp    800ef6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ef5:	90                   	nop
	return (void *) s;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0f:	eb 03                	jmp    800f14 <strtol+0x19>
		s++;
  800f11:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	3c 20                	cmp    $0x20,%al
  800f1b:	74 f4                	je     800f11 <strtol+0x16>
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	8a 00                	mov    (%eax),%al
  800f22:	3c 09                	cmp    $0x9,%al
  800f24:	74 eb                	je     800f11 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 2b                	cmp    $0x2b,%al
  800f2d:	75 05                	jne    800f34 <strtol+0x39>
		s++;
  800f2f:	ff 45 08             	incl   0x8(%ebp)
  800f32:	eb 13                	jmp    800f47 <strtol+0x4c>
	else if (*s == '-')
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 2d                	cmp    $0x2d,%al
  800f3b:	75 0a                	jne    800f47 <strtol+0x4c>
		s++, neg = 1;
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4b:	74 06                	je     800f53 <strtol+0x58>
  800f4d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f51:	75 20                	jne    800f73 <strtol+0x78>
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 30                	cmp    $0x30,%al
  800f5a:	75 17                	jne    800f73 <strtol+0x78>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	40                   	inc    %eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	3c 78                	cmp    $0x78,%al
  800f64:	75 0d                	jne    800f73 <strtol+0x78>
		s += 2, base = 16;
  800f66:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f6a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f71:	eb 28                	jmp    800f9b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f77:	75 15                	jne    800f8e <strtol+0x93>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 30                	cmp    $0x30,%al
  800f80:	75 0c                	jne    800f8e <strtol+0x93>
		s++, base = 8;
  800f82:	ff 45 08             	incl   0x8(%ebp)
  800f85:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f8c:	eb 0d                	jmp    800f9b <strtol+0xa0>
	else if (base == 0)
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	75 07                	jne    800f9b <strtol+0xa0>
		base = 10;
  800f94:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 2f                	cmp    $0x2f,%al
  800fa2:	7e 19                	jle    800fbd <strtol+0xc2>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 39                	cmp    $0x39,%al
  800fab:	7f 10                	jg     800fbd <strtol+0xc2>
			dig = *s - '0';
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f be c0             	movsbl %al,%eax
  800fb5:	83 e8 30             	sub    $0x30,%eax
  800fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbb:	eb 42                	jmp    800fff <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	3c 60                	cmp    $0x60,%al
  800fc4:	7e 19                	jle    800fdf <strtol+0xe4>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 7a                	cmp    $0x7a,%al
  800fcd:	7f 10                	jg     800fdf <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	0f be c0             	movsbl %al,%eax
  800fd7:	83 e8 57             	sub    $0x57,%eax
  800fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fdd:	eb 20                	jmp    800fff <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 40                	cmp    $0x40,%al
  800fe6:	7e 39                	jle    801021 <strtol+0x126>
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 5a                	cmp    $0x5a,%al
  800fef:	7f 30                	jg     801021 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	0f be c0             	movsbl %al,%eax
  800ff9:	83 e8 37             	sub    $0x37,%eax
  800ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801002:	3b 45 10             	cmp    0x10(%ebp),%eax
  801005:	7d 19                	jge    801020 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801007:	ff 45 08             	incl   0x8(%ebp)
  80100a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801011:	89 c2                	mov    %eax,%edx
  801013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80101b:	e9 7b ff ff ff       	jmp    800f9b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801020:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801021:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801025:	74 08                	je     80102f <strtol+0x134>
		*endptr = (char *) s;
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80102f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801033:	74 07                	je     80103c <strtol+0x141>
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	f7 d8                	neg    %eax
  80103a:	eb 03                	jmp    80103f <strtol+0x144>
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <ltostr>:

void
ltostr(long value, char *str)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80104e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	79 13                	jns    80106e <ltostr+0x2d>
	{
		neg = 1;
  80105b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801068:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80106b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801076:	99                   	cltd   
  801077:	f7 f9                	idiv   %ecx
  801079:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80107c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107f:	8d 50 01             	lea    0x1(%eax),%edx
  801082:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801085:	89 c2                	mov    %eax,%edx
  801087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80108f:	83 c2 30             	add    $0x30,%edx
  801092:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801094:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801097:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80109c:	f7 e9                	imul   %ecx
  80109e:	c1 fa 02             	sar    $0x2,%edx
  8010a1:	89 c8                	mov    %ecx,%eax
  8010a3:	c1 f8 1f             	sar    $0x1f,%eax
  8010a6:	29 c2                	sub    %eax,%edx
  8010a8:	89 d0                	mov    %edx,%eax
  8010aa:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	75 bb                	jne    80106e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	48                   	dec    %eax
  8010be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c5:	74 3d                	je     801104 <ltostr+0xc3>
		start = 1 ;
  8010c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ce:	eb 34                	jmp    801104 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	01 d0                	add    %edx,%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	01 c2                	add    %eax,%edx
  8010e5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 c8                	add    %ecx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	01 c2                	add    %eax,%edx
  8010f9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010fc:	88 02                	mov    %al,(%edx)
		start++ ;
  8010fe:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801101:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80110a:	7c c4                	jl     8010d0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80110c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801117:	90                   	nop
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801120:	ff 75 08             	pushl  0x8(%ebp)
  801123:	e8 73 fa ff ff       	call   800b9b <strlen>
  801128:	83 c4 04             	add    $0x4,%esp
  80112b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	e8 65 fa ff ff       	call   800b9b <strlen>
  801136:	83 c4 04             	add    $0x4,%esp
  801139:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80113c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80114a:	eb 17                	jmp    801163 <strcconcat+0x49>
		final[s] = str1[s] ;
  80114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 c2                	add    %eax,%edx
  801154:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	01 c8                	add    %ecx,%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801160:	ff 45 fc             	incl   -0x4(%ebp)
  801163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801166:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801169:	7c e1                	jl     80114c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80116b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801172:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801179:	eb 1f                	jmp    80119a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80117b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117e:	8d 50 01             	lea    0x1(%eax),%edx
  801181:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801184:	89 c2                	mov    %eax,%edx
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 c2                	add    %eax,%edx
  80118b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801191:	01 c8                	add    %ecx,%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801197:	ff 45 f8             	incl   -0x8(%ebp)
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a0:	7c d9                	jl     80117b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ad:	90                   	nop
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bf:	8b 00                	mov    (%eax),%eax
  8011c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d3:	eb 0c                	jmp    8011e1 <strsplit+0x31>
			*string++ = 0;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8d 50 01             	lea    0x1(%eax),%edx
  8011db:	89 55 08             	mov    %edx,0x8(%ebp)
  8011de:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	84 c0                	test   %al,%al
  8011e8:	74 18                	je     801202 <strsplit+0x52>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	0f be c0             	movsbl %al,%eax
  8011f2:	50                   	push   %eax
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	e8 32 fb ff ff       	call   800d2d <strchr>
  8011fb:	83 c4 08             	add    $0x8,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	75 d3                	jne    8011d5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	84 c0                	test   %al,%al
  801209:	74 5a                	je     801265 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80120b:	8b 45 14             	mov    0x14(%ebp),%eax
  80120e:	8b 00                	mov    (%eax),%eax
  801210:	83 f8 0f             	cmp    $0xf,%eax
  801213:	75 07                	jne    80121c <strsplit+0x6c>
		{
			return 0;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb 66                	jmp    801282 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80121c:	8b 45 14             	mov    0x14(%ebp),%eax
  80121f:	8b 00                	mov    (%eax),%eax
  801221:	8d 48 01             	lea    0x1(%eax),%ecx
  801224:	8b 55 14             	mov    0x14(%ebp),%edx
  801227:	89 0a                	mov    %ecx,(%edx)
  801229:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 c2                	add    %eax,%edx
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123a:	eb 03                	jmp    80123f <strsplit+0x8f>
			string++;
  80123c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	84 c0                	test   %al,%al
  801246:	74 8b                	je     8011d3 <strsplit+0x23>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f be c0             	movsbl %al,%eax
  801250:	50                   	push   %eax
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	e8 d4 fa ff ff       	call   800d2d <strchr>
  801259:	83 c4 08             	add    $0x8,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 dc                	je     80123c <strsplit+0x8c>
			string++;
	}
  801260:	e9 6e ff ff ff       	jmp    8011d3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801265:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801272:	8b 45 10             	mov    0x10(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80127d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	68 1c 22 80 00       	push   $0x80221c
  801292:	68 3f 01 00 00       	push   $0x13f
  801297:	68 3e 22 80 00       	push   $0x80223e
  80129c:	e8 65 06 00 00       	call   801906 <_panic>

008012a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012bc:	cd 30                	int    $0x30
  8012be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 04             	sub    $0x4,%esp
  8012d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	52                   	push   %edx
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	50                   	push   %eax
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 b2 ff ff ff       	call   8012a1 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 02                	push   $0x2
  801304:	e8 98 ff ff ff       	call   8012a1 <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 03                	push   $0x3
  80131d:	e8 7f ff ff ff       	call   8012a1 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	90                   	nop
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 04                	push   $0x4
  801337:	e8 65 ff ff ff       	call   8012a1 <syscall>
  80133c:	83 c4 18             	add    $0x18,%esp
}
  80133f:	90                   	nop
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	52                   	push   %edx
  801352:	50                   	push   %eax
  801353:	6a 08                	push   $0x8
  801355:	e8 47 ff ff ff       	call   8012a1 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801364:	8b 75 18             	mov    0x18(%ebp),%esi
  801367:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80136a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	56                   	push   %esi
  801374:	53                   	push   %ebx
  801375:	51                   	push   %ecx
  801376:	52                   	push   %edx
  801377:	50                   	push   %eax
  801378:	6a 09                	push   $0x9
  80137a:	e8 22 ff ff ff       	call   8012a1 <syscall>
  80137f:	83 c4 18             	add    $0x18,%esp
}
  801382:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80138c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	52                   	push   %edx
  801399:	50                   	push   %eax
  80139a:	6a 0a                	push   $0xa
  80139c:	e8 00 ff ff ff       	call   8012a1 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	6a 0b                	push   $0xb
  8013b7:	e8 e5 fe ff ff       	call   8012a1 <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 0c                	push   $0xc
  8013d0:	e8 cc fe ff ff       	call   8012a1 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 0d                	push   $0xd
  8013e9:	e8 b3 fe ff ff       	call   8012a1 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 0e                	push   $0xe
  801402:	e8 9a fe ff ff       	call   8012a1 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 0f                	push   $0xf
  80141b:	e8 81 fe ff ff       	call   8012a1 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	ff 75 08             	pushl  0x8(%ebp)
  801433:	6a 10                	push   $0x10
  801435:	e8 67 fe ff ff       	call   8012a1 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 11                	push   $0x11
  80144e:	e8 4e fe ff ff       	call   8012a1 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	90                   	nop
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_cputc>:

void
sys_cputc(const char c)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	83 ec 04             	sub    $0x4,%esp
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801465:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	50                   	push   %eax
  801472:	6a 01                	push   $0x1
  801474:	e8 28 fe ff ff       	call   8012a1 <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	90                   	nop
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 14                	push   $0x14
  80148e:	e8 0e fe ff ff       	call   8012a1 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	6a 00                	push   $0x0
  8014b1:	51                   	push   %ecx
  8014b2:	52                   	push   %edx
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	50                   	push   %eax
  8014b7:	6a 15                	push   $0x15
  8014b9:	e8 e3 fd ff ff       	call   8012a1 <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	52                   	push   %edx
  8014d3:	50                   	push   %eax
  8014d4:	6a 16                	push   $0x16
  8014d6:	e8 c6 fd ff ff       	call   8012a1 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	51                   	push   %ecx
  8014f1:	52                   	push   %edx
  8014f2:	50                   	push   %eax
  8014f3:	6a 17                	push   $0x17
  8014f5:	e8 a7 fd ff ff       	call   8012a1 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	52                   	push   %edx
  80150f:	50                   	push   %eax
  801510:	6a 18                	push   $0x18
  801512:	e8 8a fd ff ff       	call   8012a1 <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	ff 75 14             	pushl  0x14(%ebp)
  801527:	ff 75 10             	pushl  0x10(%ebp)
  80152a:	ff 75 0c             	pushl  0xc(%ebp)
  80152d:	50                   	push   %eax
  80152e:	6a 19                	push   $0x19
  801530:	e8 6c fd ff ff       	call   8012a1 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	50                   	push   %eax
  801549:	6a 1a                	push   $0x1a
  80154b:	e8 51 fd ff ff       	call   8012a1 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	90                   	nop
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	50                   	push   %eax
  801565:	6a 1b                	push   $0x1b
  801567:	e8 35 fd ff ff       	call   8012a1 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 05                	push   $0x5
  801580:	e8 1c fd ff ff       	call   8012a1 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 06                	push   $0x6
  801599:	e8 03 fd ff ff       	call   8012a1 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 07                	push   $0x7
  8015b2:	e8 ea fc ff ff       	call   8012a1 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_exit_env>:


void sys_exit_env(void)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 1c                	push   $0x1c
  8015cb:	e8 d1 fc ff ff       	call   8012a1 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015df:	8d 50 04             	lea    0x4(%eax),%edx
  8015e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	52                   	push   %edx
  8015ec:	50                   	push   %eax
  8015ed:	6a 1d                	push   $0x1d
  8015ef:	e8 ad fc ff ff       	call   8012a1 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8015f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	89 01                	mov    %eax,(%ecx)
  801602:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	c9                   	leave  
  801609:	c2 04 00             	ret    $0x4

0080160c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	ff 75 08             	pushl  0x8(%ebp)
  80161c:	6a 13                	push   $0x13
  80161e:	e8 7e fc ff ff       	call   8012a1 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
	return ;
  801626:	90                   	nop
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_rcr2>:
uint32 sys_rcr2()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 1e                	push   $0x1e
  801638:	e8 64 fc ff ff       	call   8012a1 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80164e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	50                   	push   %eax
  80165b:	6a 1f                	push   $0x1f
  80165d:	e8 3f fc ff ff       	call   8012a1 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <rsttst>:
void rsttst()
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 21                	push   $0x21
  801677:	e8 25 fc ff ff       	call   8012a1 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
	return ;
  80167f:	90                   	nop
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	8b 45 14             	mov    0x14(%ebp),%eax
  80168b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80168e:	8b 55 18             	mov    0x18(%ebp),%edx
  801691:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	ff 75 10             	pushl  0x10(%ebp)
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 20                	push   $0x20
  8016a2:	e8 fa fb ff ff       	call   8012a1 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016aa:	90                   	nop
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <chktst>:
void chktst(uint32 n)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	6a 22                	push   $0x22
  8016bd:	e8 df fb ff ff       	call   8012a1 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c5:	90                   	nop
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <inctst>:

void inctst()
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 23                	push   $0x23
  8016d7:	e8 c5 fb ff ff       	call   8012a1 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016df:	90                   	nop
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <gettst>:
uint32 gettst()
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 24                	push   $0x24
  8016f1:	e8 ab fb ff ff       	call   8012a1 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 25                	push   $0x25
  80170d:	e8 8f fb ff ff       	call   8012a1 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
  801715:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801718:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80171c:	75 07                	jne    801725 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80171e:	b8 01 00 00 00       	mov    $0x1,%eax
  801723:	eb 05                	jmp    80172a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 25                	push   $0x25
  80173e:	e8 5e fb ff ff       	call   8012a1 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
  801746:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801749:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80174d:	75 07                	jne    801756 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80174f:	b8 01 00 00 00       	mov    $0x1,%eax
  801754:	eb 05                	jmp    80175b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 25                	push   $0x25
  80176f:	e8 2d fb ff ff       	call   8012a1 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
  801777:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80177a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80177e:	75 07                	jne    801787 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801780:	b8 01 00 00 00       	mov    $0x1,%eax
  801785:	eb 05                	jmp    80178c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 25                	push   $0x25
  8017a0:	e8 fc fa ff ff       	call   8012a1 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
  8017a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017af:	75 07                	jne    8017b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b6:	eb 05                	jmp    8017bd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	6a 26                	push   $0x26
  8017cf:	e8 cd fa ff ff       	call   8012a1 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d7:	90                   	nop
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	53                   	push   %ebx
  8017ed:	51                   	push   %ecx
  8017ee:	52                   	push   %edx
  8017ef:	50                   	push   %eax
  8017f0:	6a 27                	push   $0x27
  8017f2:	e8 aa fa ff ff       	call   8012a1 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 28                	push   $0x28
  801812:	e8 8a fa ff ff       	call   8012a1 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80181f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	51                   	push   %ecx
  80182b:	ff 75 10             	pushl  0x10(%ebp)
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 29                	push   $0x29
  801832:	e8 6a fa ff ff       	call   8012a1 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 10             	pushl  0x10(%ebp)
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 12                	push   $0x12
  80184e:	e8 4e fa ff ff       	call   8012a1 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 2a                	push   $0x2a
  80186c:	e8 30 fa ff ff       	call   8012a1 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
	return;
  801874:	90                   	nop
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 2b                	push   $0x2b
  801888:	e8 14 fa ff ff       	call   8012a1 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 2c                	push   $0x2c
  8018a3:	e8 f9 f9 ff ff       	call   8012a1 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 2d                	push   $0x2d
  8018bf:	e8 dd f9 ff ff       	call   8012a1 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	50                   	push   %eax
  8018de:	e8 76 fb ff ff       	call   801459 <sys_cputc>
  8018e3:	83 c4 10             	add    $0x10,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <getchar>:


int
getchar(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8018ef:	e8 01 fa ff ff       	call   8012f5 <sys_cgetc>
  8018f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <iscons>:

int iscons(int fdnum)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8018ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80190c:	8d 45 10             	lea    0x10(%ebp),%eax
  80190f:	83 c0 04             	add    $0x4,%eax
  801912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801915:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80191a:	85 c0                	test   %eax,%eax
  80191c:	74 16                	je     801934 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80191e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	50                   	push   %eax
  801927:	68 4c 22 80 00       	push   $0x80224c
  80192c:	e8 ce e9 ff ff       	call   8002ff <cprintf>
  801931:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801934:	a1 00 30 80 00       	mov    0x803000,%eax
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	50                   	push   %eax
  801940:	68 51 22 80 00       	push   $0x802251
  801945:	e8 b5 e9 ff ff       	call   8002ff <cprintf>
  80194a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80194d:	8b 45 10             	mov    0x10(%ebp),%eax
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	ff 75 f4             	pushl  -0xc(%ebp)
  801956:	50                   	push   %eax
  801957:	e8 38 e9 ff ff       	call   800294 <vcprintf>
  80195c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	6a 00                	push   $0x0
  801964:	68 6d 22 80 00       	push   $0x80226d
  801969:	e8 26 e9 ff ff       	call   800294 <vcprintf>
  80196e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801971:	e8 a7 e8 ff ff       	call   80021d <exit>

	// should not return here
	while (1) ;
  801976:	eb fe                	jmp    801976 <_panic+0x70>

00801978 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80197e:	a1 04 30 80 00       	mov    0x803004,%eax
  801983:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	39 c2                	cmp    %eax,%edx
  80198e:	74 14                	je     8019a4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	68 70 22 80 00       	push   $0x802270
  801998:	6a 26                	push   $0x26
  80199a:	68 bc 22 80 00       	push   $0x8022bc
  80199f:	e8 62 ff ff ff       	call   801906 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019b2:	e9 c5 00 00 00       	jmp    801a7c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	01 d0                	add    %edx,%eax
  8019c6:	8b 00                	mov    (%eax),%eax
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	75 08                	jne    8019d4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019cc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019cf:	e9 a5 00 00 00       	jmp    801a79 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019e2:	eb 69                	jmp    801a4d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e9:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8019ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f2:	89 d0                	mov    %edx,%eax
  8019f4:	01 c0                	add    %eax,%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	c1 e0 03             	shl    $0x3,%eax
  8019fb:	01 c8                	add    %ecx,%eax
  8019fd:	8a 40 04             	mov    0x4(%eax),%al
  801a00:	84 c0                	test   %al,%al
  801a02:	75 46                	jne    801a4a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a04:	a1 04 30 80 00       	mov    0x803004,%eax
  801a09:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a12:	89 d0                	mov    %edx,%eax
  801a14:	01 c0                	add    %eax,%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	c1 e0 03             	shl    $0x3,%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a2a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	01 c8                	add    %ecx,%eax
  801a3b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a3d:	39 c2                	cmp    %eax,%edx
  801a3f:	75 09                	jne    801a4a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a41:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a48:	eb 15                	jmp    801a5f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a4a:	ff 45 e8             	incl   -0x18(%ebp)
  801a4d:	a1 04 30 80 00       	mov    0x803004,%eax
  801a52:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5b:	39 c2                	cmp    %eax,%edx
  801a5d:	77 85                	ja     8019e4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a63:	75 14                	jne    801a79 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	68 c8 22 80 00       	push   $0x8022c8
  801a6d:	6a 3a                	push   $0x3a
  801a6f:	68 bc 22 80 00       	push   $0x8022bc
  801a74:	e8 8d fe ff ff       	call   801906 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a79:	ff 45 f0             	incl   -0x10(%ebp)
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a82:	0f 8c 2f ff ff ff    	jl     8019b7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a96:	eb 26                	jmp    801abe <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a98:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aa6:	89 d0                	mov    %edx,%eax
  801aa8:	01 c0                	add    %eax,%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	c1 e0 03             	shl    $0x3,%eax
  801aaf:	01 c8                	add    %ecx,%eax
  801ab1:	8a 40 04             	mov    0x4(%eax),%al
  801ab4:	3c 01                	cmp    $0x1,%al
  801ab6:	75 03                	jne    801abb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801abb:	ff 45 e0             	incl   -0x20(%ebp)
  801abe:	a1 04 30 80 00       	mov    0x803004,%eax
  801ac3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acc:	39 c2                	cmp    %eax,%edx
  801ace:	77 c8                	ja     801a98 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ad6:	74 14                	je     801aec <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	68 1c 23 80 00       	push   $0x80231c
  801ae0:	6a 44                	push   $0x44
  801ae2:	68 bc 22 80 00       	push   $0x8022bc
  801ae7:	e8 1a fe ff ff       	call   801906 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
  801aef:	90                   	nop

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
