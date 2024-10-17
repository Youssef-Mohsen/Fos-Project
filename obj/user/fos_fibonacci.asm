
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
  800052:	68 80 1d 80 00       	push   $0x801d80
  800057:	e8 45 0a 00 00       	call   800aa1 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 98 0e 00 00       	call   800f0a <strtol>
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
  800095:	68 9e 1d 80 00       	push   $0x801d9e
  80009a:	e8 9c 02 00 00       	call   80033b <atomic_cprintf>
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
  8000f3:	e8 a1 14 00 00       	call   801599 <sys_getenvindex>
  8000f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	89 d0                	mov    %edx,%eax
  800100:	c1 e0 06             	shl    $0x6,%eax
  800103:	29 d0                	sub    %edx,%eax
  800105:	c1 e0 02             	shl    $0x2,%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800111:	01 c8                	add    %ecx,%eax
  800113:	c1 e0 03             	shl    $0x3,%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011f:	29 c2                	sub    %eax,%edx
  800121:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800130:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800135:	a1 04 30 80 00       	mov    0x803004,%eax
  80013a:	8a 40 20             	mov    0x20(%eax),%al
  80013d:	84 c0                	test   %al,%al
  80013f:	74 0d                	je     80014e <libmain+0x61>
		binaryname = myEnv->prog_name;
  800141:	a1 04 30 80 00       	mov    0x803004,%eax
  800146:	83 c0 20             	add    $0x20,%eax
  800149:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800152:	7e 0a                	jle    80015e <libmain+0x71>
		binaryname = argv[0];
  800154:	8b 45 0c             	mov    0xc(%ebp),%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80015e:	83 ec 08             	sub    $0x8,%esp
  800161:	ff 75 0c             	pushl  0xc(%ebp)
  800164:	ff 75 08             	pushl  0x8(%ebp)
  800167:	e8 cc fe ff ff       	call   800038 <_main>
  80016c:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80016f:	e8 a9 11 00 00       	call   80131d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	68 d0 1d 80 00       	push   $0x801dd0
  80017c:	e8 8d 01 00 00       	call   80030e <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800184:	a1 04 30 80 00       	mov    0x803004,%eax
  800189:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80018f:	a1 04 30 80 00       	mov    0x803004,%eax
  800194:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	52                   	push   %edx
  80019e:	50                   	push   %eax
  80019f:	68 f8 1d 80 00       	push   $0x801df8
  8001a4:	e8 65 01 00 00       	call   80030e <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ac:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b1:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001bc:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001c2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c7:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001cd:	51                   	push   %ecx
  8001ce:	52                   	push   %edx
  8001cf:	50                   	push   %eax
  8001d0:	68 20 1e 80 00       	push   $0x801e20
  8001d5:	e8 34 01 00 00       	call   80030e <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e2:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	50                   	push   %eax
  8001ec:	68 78 1e 80 00       	push   $0x801e78
  8001f1:	e8 18 01 00 00       	call   80030e <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	68 d0 1d 80 00       	push   $0x801dd0
  800201:	e8 08 01 00 00       	call   80030e <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800209:	e8 29 11 00 00       	call   801337 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80020e:	e8 19 00 00 00       	call   80022c <exit>
}
  800213:	90                   	nop
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	6a 00                	push   $0x0
  800221:	e8 3f 13 00 00       	call   801565 <sys_destroy_env>
  800226:	83 c4 10             	add    $0x10,%esp
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <exit>:

void
exit(void)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800232:	e8 94 13 00 00       	call   8015cb <sys_exit_env>
}
  800237:	90                   	nop
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	8d 48 01             	lea    0x1(%eax),%ecx
  800248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024b:	89 0a                	mov    %ecx,(%edx)
  80024d:	8b 55 08             	mov    0x8(%ebp),%edx
  800250:	88 d1                	mov    %dl,%cl
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
  800255:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025c:	8b 00                	mov    (%eax),%eax
  80025e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800263:	75 2c                	jne    800291 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800265:	a0 08 30 80 00       	mov    0x803008,%al
  80026a:	0f b6 c0             	movzbl %al,%eax
  80026d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800270:	8b 12                	mov    (%edx),%edx
  800272:	89 d1                	mov    %edx,%ecx
  800274:	8b 55 0c             	mov    0xc(%ebp),%edx
  800277:	83 c2 08             	add    $0x8,%edx
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	50                   	push   %eax
  80027e:	51                   	push   %ecx
  80027f:	52                   	push   %edx
  800280:	e8 56 10 00 00       	call   8012db <sys_cputs>
  800285:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
  800294:	8b 40 04             	mov    0x4(%eax),%eax
  800297:	8d 50 01             	lea    0x1(%eax),%edx
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002a0:	90                   	nop
  8002a1:	c9                   	leave  
  8002a2:	c3                   	ret    

008002a3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b3:	00 00 00 
	b.cnt = 0;
  8002b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002bd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cc:	50                   	push   %eax
  8002cd:	68 3a 02 80 00       	push   $0x80023a
  8002d2:	e8 11 02 00 00       	call   8004e8 <vprintfmt>
  8002d7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002da:	a0 08 30 80 00       	mov    0x803008,%al
  8002df:	0f b6 c0             	movzbl %al,%eax
  8002e2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	52                   	push   %edx
  8002ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f3:	83 c0 08             	add    $0x8,%eax
  8002f6:	50                   	push   %eax
  8002f7:	e8 df 0f 00 00       	call   8012db <sys_cputs>
  8002fc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ff:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800306:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800314:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80031b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	ff 75 f4             	pushl  -0xc(%ebp)
  80032a:	50                   	push   %eax
  80032b:	e8 73 ff ff ff       	call   8002a3 <vcprintf>
  800330:	83 c4 10             	add    $0x10,%esp
  800333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800336:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800341:	e8 d7 0f 00 00       	call   80131d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800346:	8d 45 0c             	lea    0xc(%ebp),%eax
  800349:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	83 ec 08             	sub    $0x8,%esp
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	50                   	push   %eax
  800356:	e8 48 ff ff ff       	call   8002a3 <vcprintf>
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800361:	e8 d1 0f 00 00       	call   801337 <sys_unlock_cons>
	return cnt;
  800366:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	53                   	push   %ebx
  80036f:	83 ec 14             	sub    $0x14,%esp
  800372:	8b 45 10             	mov    0x10(%ebp),%eax
  800375:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037e:	8b 45 18             	mov    0x18(%ebp),%eax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800389:	77 55                	ja     8003e0 <printnum+0x75>
  80038b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80038e:	72 05                	jb     800395 <printnum+0x2a>
  800390:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800393:	77 4b                	ja     8003e0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800395:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800398:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80039b:	8b 45 18             	mov    0x18(%ebp),%eax
  80039e:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a3:	52                   	push   %edx
  8003a4:	50                   	push   %eax
  8003a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ab:	e8 54 17 00 00       	call   801b04 <__udivdi3>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	ff 75 20             	pushl  0x20(%ebp)
  8003b9:	53                   	push   %ebx
  8003ba:	ff 75 18             	pushl  0x18(%ebp)
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	ff 75 0c             	pushl  0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a1 ff ff ff       	call   80036b <printnum>
  8003ca:	83 c4 20             	add    $0x20,%esp
  8003cd:	eb 1a                	jmp    8003e9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	ff 75 20             	pushl  0x20(%ebp)
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	ff d0                	call   *%eax
  8003dd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e0:	ff 4d 1c             	decl   0x1c(%ebp)
  8003e3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003e7:	7f e6                	jg     8003cf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f7:	53                   	push   %ebx
  8003f8:	51                   	push   %ecx
  8003f9:	52                   	push   %edx
  8003fa:	50                   	push   %eax
  8003fb:	e8 14 18 00 00       	call   801c14 <__umoddi3>
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	05 b4 20 80 00       	add    $0x8020b4,%eax
  800408:	8a 00                	mov    (%eax),%al
  80040a:	0f be c0             	movsbl %al,%eax
  80040d:	83 ec 08             	sub    $0x8,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	50                   	push   %eax
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	ff d0                	call   *%eax
  800419:	83 c4 10             	add    $0x10,%esp
}
  80041c:	90                   	nop
  80041d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800425:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800429:	7e 1c                	jle    800447 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	8d 50 08             	lea    0x8(%eax),%edx
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	89 10                	mov    %edx,(%eax)
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	83 e8 08             	sub    $0x8,%eax
  800440:	8b 50 04             	mov    0x4(%eax),%edx
  800443:	8b 00                	mov    (%eax),%eax
  800445:	eb 40                	jmp    800487 <getuint+0x65>
	else if (lflag)
  800447:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80044b:	74 1e                	je     80046b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	8d 50 04             	lea    0x4(%eax),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	89 10                	mov    %edx,(%eax)
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	83 e8 04             	sub    $0x4,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	ba 00 00 00 00       	mov    $0x0,%edx
  800469:	eb 1c                	jmp    800487 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	8d 50 04             	lea    0x4(%eax),%edx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	89 10                	mov    %edx,(%eax)
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	83 e8 04             	sub    $0x4,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    

00800489 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80048c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800490:	7e 1c                	jle    8004ae <getint+0x25>
		return va_arg(*ap, long long);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	8d 50 08             	lea    0x8(%eax),%edx
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 10                	mov    %edx,(%eax)
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 e8 08             	sub    $0x8,%eax
  8004a7:	8b 50 04             	mov    0x4(%eax),%edx
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	eb 38                	jmp    8004e6 <getint+0x5d>
	else if (lflag)
  8004ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b2:	74 1a                	je     8004ce <getint+0x45>
		return va_arg(*ap, long);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 50 04             	lea    0x4(%eax),%edx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	89 10                	mov    %edx,(%eax)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	83 e8 04             	sub    $0x4,%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	99                   	cltd   
  8004cc:	eb 18                	jmp    8004e6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	8d 50 04             	lea    0x4(%eax),%edx
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	89 10                	mov    %edx,(%eax)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	83 e8 04             	sub    $0x4,%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	99                   	cltd   
}
  8004e6:	5d                   	pop    %ebp
  8004e7:	c3                   	ret    

008004e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	56                   	push   %esi
  8004ec:	53                   	push   %ebx
  8004ed:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f0:	eb 17                	jmp    800509 <vprintfmt+0x21>
			if (ch == '\0')
  8004f2:	85 db                	test   %ebx,%ebx
  8004f4:	0f 84 c1 03 00 00    	je     8008bb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	53                   	push   %ebx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	ff d0                	call   *%eax
  800506:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800509:	8b 45 10             	mov    0x10(%ebp),%eax
  80050c:	8d 50 01             	lea    0x1(%eax),%edx
  80050f:	89 55 10             	mov    %edx,0x10(%ebp)
  800512:	8a 00                	mov    (%eax),%al
  800514:	0f b6 d8             	movzbl %al,%ebx
  800517:	83 fb 25             	cmp    $0x25,%ebx
  80051a:	75 d6                	jne    8004f2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80051c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800520:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800527:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80052e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800535:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053c:	8b 45 10             	mov    0x10(%ebp),%eax
  80053f:	8d 50 01             	lea    0x1(%eax),%edx
  800542:	89 55 10             	mov    %edx,0x10(%ebp)
  800545:	8a 00                	mov    (%eax),%al
  800547:	0f b6 d8             	movzbl %al,%ebx
  80054a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80054d:	83 f8 5b             	cmp    $0x5b,%eax
  800550:	0f 87 3d 03 00 00    	ja     800893 <vprintfmt+0x3ab>
  800556:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  80055d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80055f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800563:	eb d7                	jmp    80053c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800565:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800569:	eb d1                	jmp    80053c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800572:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800575:	89 d0                	mov    %edx,%eax
  800577:	c1 e0 02             	shl    $0x2,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	01 d8                	add    %ebx,%eax
  800580:	83 e8 30             	sub    $0x30,%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800586:	8b 45 10             	mov    0x10(%ebp),%eax
  800589:	8a 00                	mov    (%eax),%al
  80058b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80058e:	83 fb 2f             	cmp    $0x2f,%ebx
  800591:	7e 3e                	jle    8005d1 <vprintfmt+0xe9>
  800593:	83 fb 39             	cmp    $0x39,%ebx
  800596:	7f 39                	jg     8005d1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800598:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80059b:	eb d5                	jmp    800572 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	83 c0 04             	add    $0x4,%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	83 e8 04             	sub    $0x4,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005b1:	eb 1f                	jmp    8005d2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b7:	79 83                	jns    80053c <vprintfmt+0x54>
				width = 0;
  8005b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005c0:	e9 77 ff ff ff       	jmp    80053c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005c5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005cc:	e9 6b ff ff ff       	jmp    80053c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005d1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d6:	0f 89 60 ff ff ff    	jns    80053c <vprintfmt+0x54>
				width = precision, precision = -1;
  8005dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005e9:	e9 4e ff ff ff       	jmp    80053c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ee:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005f1:	e9 46 ff ff ff       	jmp    80053c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	83 c0 04             	add    $0x4,%eax
  8005fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	83 e8 04             	sub    $0x4,%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
			break;
  800616:	e9 9b 02 00 00       	jmp    8008b6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	83 c0 04             	add    $0x4,%eax
  800621:	89 45 14             	mov    %eax,0x14(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	83 e8 04             	sub    $0x4,%eax
  80062a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80062c:	85 db                	test   %ebx,%ebx
  80062e:	79 02                	jns    800632 <vprintfmt+0x14a>
				err = -err;
  800630:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800632:	83 fb 64             	cmp    $0x64,%ebx
  800635:	7f 0b                	jg     800642 <vprintfmt+0x15a>
  800637:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  80063e:	85 f6                	test   %esi,%esi
  800640:	75 19                	jne    80065b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800642:	53                   	push   %ebx
  800643:	68 c5 20 80 00       	push   $0x8020c5
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	ff 75 08             	pushl  0x8(%ebp)
  80064e:	e8 70 02 00 00       	call   8008c3 <printfmt>
  800653:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800656:	e9 5b 02 00 00       	jmp    8008b6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80065b:	56                   	push   %esi
  80065c:	68 ce 20 80 00       	push   $0x8020ce
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 08             	pushl  0x8(%ebp)
  800667:	e8 57 02 00 00       	call   8008c3 <printfmt>
  80066c:	83 c4 10             	add    $0x10,%esp
			break;
  80066f:	e9 42 02 00 00       	jmp    8008b6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	83 c0 04             	add    $0x4,%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	83 e8 04             	sub    $0x4,%eax
  800683:	8b 30                	mov    (%eax),%esi
  800685:	85 f6                	test   %esi,%esi
  800687:	75 05                	jne    80068e <vprintfmt+0x1a6>
				p = "(null)";
  800689:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  80068e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800692:	7e 6d                	jle    800701 <vprintfmt+0x219>
  800694:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800698:	74 67                	je     800701 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	50                   	push   %eax
  8006a1:	56                   	push   %esi
  8006a2:	e8 26 05 00 00       	call   800bcd <strnlen>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ad:	eb 16                	jmp    8006c5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006af:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c9:	7f e4                	jg     8006af <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cb:	eb 34                	jmp    800701 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d1:	74 1c                	je     8006ef <vprintfmt+0x207>
  8006d3:	83 fb 1f             	cmp    $0x1f,%ebx
  8006d6:	7e 05                	jle    8006dd <vprintfmt+0x1f5>
  8006d8:	83 fb 7e             	cmp    $0x7e,%ebx
  8006db:	7e 12                	jle    8006ef <vprintfmt+0x207>
					putch('?', putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	6a 3f                	push   $0x3f
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb 0f                	jmp    8006fe <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	53                   	push   %ebx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800701:	89 f0                	mov    %esi,%eax
  800703:	8d 70 01             	lea    0x1(%eax),%esi
  800706:	8a 00                	mov    (%eax),%al
  800708:	0f be d8             	movsbl %al,%ebx
  80070b:	85 db                	test   %ebx,%ebx
  80070d:	74 24                	je     800733 <vprintfmt+0x24b>
  80070f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800713:	78 b8                	js     8006cd <vprintfmt+0x1e5>
  800715:	ff 4d e0             	decl   -0x20(%ebp)
  800718:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071c:	79 af                	jns    8006cd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071e:	eb 13                	jmp    800733 <vprintfmt+0x24b>
				putch(' ', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 20                	push   $0x20
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e7                	jg     800720 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800739:	e9 78 01 00 00       	jmp    8008b6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 e8             	pushl  -0x18(%ebp)
  800744:	8d 45 14             	lea    0x14(%ebp),%eax
  800747:	50                   	push   %eax
  800748:	e8 3c fd ff ff       	call   800489 <getint>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800753:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075c:	85 d2                	test   %edx,%edx
  80075e:	79 23                	jns    800783 <vprintfmt+0x29b>
				putch('-', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	6a 2d                	push   $0x2d
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800776:	f7 d8                	neg    %eax
  800778:	83 d2 00             	adc    $0x0,%edx
  80077b:	f7 da                	neg    %edx
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800780:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800783:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078a:	e9 bc 00 00 00       	jmp    80084b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 e8             	pushl  -0x18(%ebp)
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
  800798:	50                   	push   %eax
  800799:	e8 84 fc ff ff       	call   800422 <getuint>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ae:	e9 98 00 00 00       	jmp    80084b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 58                	push   $0x58
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	6a 58                	push   $0x58
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	ff d0                	call   *%eax
  8007d0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	6a 58                	push   $0x58
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	ff d0                	call   *%eax
  8007e0:	83 c4 10             	add    $0x10,%esp
			break;
  8007e3:	e9 ce 00 00 00       	jmp    8008b6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 30                	push   $0x30
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	6a 78                	push   $0x78
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	83 c0 04             	add    $0x4,%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 e8 04             	sub    $0x4,%eax
  800817:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800819:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800823:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80082a:	eb 1f                	jmp    80084b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 e8             	pushl  -0x18(%ebp)
  800832:	8d 45 14             	lea    0x14(%ebp),%eax
  800835:	50                   	push   %eax
  800836:	e8 e7 fb ff ff       	call   800422 <getuint>
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800841:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800844:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80084b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80084f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	52                   	push   %edx
  800856:	ff 75 e4             	pushl  -0x1c(%ebp)
  800859:	50                   	push   %eax
  80085a:	ff 75 f4             	pushl  -0xc(%ebp)
  80085d:	ff 75 f0             	pushl  -0x10(%ebp)
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 00 fb ff ff       	call   80036b <printnum>
  80086b:	83 c4 20             	add    $0x20,%esp
			break;
  80086e:	eb 46                	jmp    8008b6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	53                   	push   %ebx
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			break;
  80087f:	eb 35                	jmp    8008b6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800881:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800888:	eb 2c                	jmp    8008b6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80088a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800891:	eb 23                	jmp    8008b6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	6a 25                	push   $0x25
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a3:	ff 4d 10             	decl   0x10(%ebp)
  8008a6:	eb 03                	jmp    8008ab <vprintfmt+0x3c3>
  8008a8:	ff 4d 10             	decl   0x10(%ebp)
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	48                   	dec    %eax
  8008af:	8a 00                	mov    (%eax),%al
  8008b1:	3c 25                	cmp    $0x25,%al
  8008b3:	75 f3                	jne    8008a8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008b5:	90                   	nop
		}
	}
  8008b6:	e9 35 fc ff ff       	jmp    8004f0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008bb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cc:	83 c0 04             	add    $0x4,%eax
  8008cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	ff 75 08             	pushl  0x8(%ebp)
  8008df:	e8 04 fc ff ff       	call   8004e8 <vprintfmt>
  8008e4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008e7:	90                   	nop
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f0:	8b 40 08             	mov    0x8(%eax),%eax
  8008f3:	8d 50 01             	lea    0x1(%eax),%edx
  8008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ff:	8b 10                	mov    (%eax),%edx
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	8b 40 04             	mov    0x4(%eax),%eax
  800907:	39 c2                	cmp    %eax,%edx
  800909:	73 12                	jae    80091d <sprintputch+0x33>
		*b->buf++ = ch;
  80090b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	8d 48 01             	lea    0x1(%eax),%ecx
  800913:	8b 55 0c             	mov    0xc(%ebp),%edx
  800916:	89 0a                	mov    %ecx,(%edx)
  800918:	8b 55 08             	mov    0x8(%ebp),%edx
  80091b:	88 10                	mov    %dl,(%eax)
}
  80091d:	90                   	nop
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	01 d0                	add    %edx,%eax
  800937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800945:	74 06                	je     80094d <vsnprintf+0x2d>
  800947:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094b:	7f 07                	jg     800954 <vsnprintf+0x34>
		return -E_INVAL;
  80094d:	b8 03 00 00 00       	mov    $0x3,%eax
  800952:	eb 20                	jmp    800974 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800954:	ff 75 14             	pushl  0x14(%ebp)
  800957:	ff 75 10             	pushl  0x10(%ebp)
  80095a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80095d:	50                   	push   %eax
  80095e:	68 ea 08 80 00       	push   $0x8008ea
  800963:	e8 80 fb ff ff       	call   8004e8 <vprintfmt>
  800968:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80096b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80096e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800971:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097c:	8d 45 10             	lea    0x10(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	ff 75 f4             	pushl  -0xc(%ebp)
  80098b:	50                   	push   %eax
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	e8 89 ff ff ff       	call   800920 <vsnprintf>
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8009a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ac:	74 13                	je     8009c1 <readline+0x1f>
		cprintf("%s", prompt);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 08             	pushl  0x8(%ebp)
  8009b4:	68 48 22 80 00       	push   $0x802248
  8009b9:	e8 50 f9 ff ff       	call   80030e <cprintf>
  8009be:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	6a 00                	push   $0x0
  8009cd:	e8 3d 0f 00 00       	call   80190f <iscons>
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009d8:	e8 1f 0f 00 00       	call   8018fc <getchar>
  8009dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009e4:	79 22                	jns    800a08 <readline+0x66>
			if (c != -E_EOF)
  8009e6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009ea:	0f 84 ad 00 00 00    	je     800a9d <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8009f6:	68 4b 22 80 00       	push   $0x80224b
  8009fb:	e8 0e f9 ff ff       	call   80030e <cprintf>
  800a00:	83 c4 10             	add    $0x10,%esp
			break;
  800a03:	e9 95 00 00 00       	jmp    800a9d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a08:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a0c:	7e 34                	jle    800a42 <readline+0xa0>
  800a0e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a15:	7f 2b                	jg     800a42 <readline+0xa0>
			if (echoing)
  800a17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a1b:	74 0e                	je     800a2b <readline+0x89>
				cputchar(c);
  800a1d:	83 ec 0c             	sub    $0xc,%esp
  800a20:	ff 75 ec             	pushl  -0x14(%ebp)
  800a23:	e8 b5 0e 00 00       	call   8018dd <cputchar>
  800a28:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2e:	8d 50 01             	lea    0x1(%eax),%edx
  800a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	01 d0                	add    %edx,%eax
  800a3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a3e:	88 10                	mov    %dl,(%eax)
  800a40:	eb 56                	jmp    800a98 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a42:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a46:	75 1f                	jne    800a67 <readline+0xc5>
  800a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a4c:	7e 19                	jle    800a67 <readline+0xc5>
			if (echoing)
  800a4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a52:	74 0e                	je     800a62 <readline+0xc0>
				cputchar(c);
  800a54:	83 ec 0c             	sub    $0xc,%esp
  800a57:	ff 75 ec             	pushl  -0x14(%ebp)
  800a5a:	e8 7e 0e 00 00       	call   8018dd <cputchar>
  800a5f:	83 c4 10             	add    $0x10,%esp

			i--;
  800a62:	ff 4d f4             	decl   -0xc(%ebp)
  800a65:	eb 31                	jmp    800a98 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a67:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a6b:	74 0a                	je     800a77 <readline+0xd5>
  800a6d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a71:	0f 85 61 ff ff ff    	jne    8009d8 <readline+0x36>
			if (echoing)
  800a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a7b:	74 0e                	je     800a8b <readline+0xe9>
				cputchar(c);
  800a7d:	83 ec 0c             	sub    $0xc,%esp
  800a80:	ff 75 ec             	pushl  -0x14(%ebp)
  800a83:	e8 55 0e 00 00       	call   8018dd <cputchar>
  800a88:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a96:	eb 06                	jmp    800a9e <readline+0xfc>
		}
	}
  800a98:	e9 3b ff ff ff       	jmp    8009d8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a9d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a9e:	90                   	nop
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800aa7:	e8 71 08 00 00       	call   80131d <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800aac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ab0:	74 13                	je     800ac5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	68 48 22 80 00       	push   $0x802248
  800abd:	e8 4c f8 ff ff       	call   80030e <cprintf>
  800ac2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800acc:	83 ec 0c             	sub    $0xc,%esp
  800acf:	6a 00                	push   $0x0
  800ad1:	e8 39 0e 00 00       	call   80190f <iscons>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800adc:	e8 1b 0e 00 00       	call   8018fc <getchar>
  800ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ae4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ae8:	79 22                	jns    800b0c <atomic_readline+0x6b>
				if (c != -E_EOF)
  800aea:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aee:	0f 84 ad 00 00 00    	je     800ba1 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	ff 75 ec             	pushl  -0x14(%ebp)
  800afa:	68 4b 22 80 00       	push   $0x80224b
  800aff:	e8 0a f8 ff ff       	call   80030e <cprintf>
  800b04:	83 c4 10             	add    $0x10,%esp
				break;
  800b07:	e9 95 00 00 00       	jmp    800ba1 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b0c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b10:	7e 34                	jle    800b46 <atomic_readline+0xa5>
  800b12:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b19:	7f 2b                	jg     800b46 <atomic_readline+0xa5>
				if (echoing)
  800b1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1f:	74 0e                	je     800b2f <atomic_readline+0x8e>
					cputchar(c);
  800b21:	83 ec 0c             	sub    $0xc,%esp
  800b24:	ff 75 ec             	pushl  -0x14(%ebp)
  800b27:	e8 b1 0d 00 00       	call   8018dd <cputchar>
  800b2c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b32:	8d 50 01             	lea    0x1(%eax),%edx
  800b35:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	01 d0                	add    %edx,%eax
  800b3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b42:	88 10                	mov    %dl,(%eax)
  800b44:	eb 56                	jmp    800b9c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b46:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b4a:	75 1f                	jne    800b6b <atomic_readline+0xca>
  800b4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b50:	7e 19                	jle    800b6b <atomic_readline+0xca>
				if (echoing)
  800b52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b56:	74 0e                	je     800b66 <atomic_readline+0xc5>
					cputchar(c);
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b5e:	e8 7a 0d 00 00       	call   8018dd <cputchar>
  800b63:	83 c4 10             	add    $0x10,%esp
				i--;
  800b66:	ff 4d f4             	decl   -0xc(%ebp)
  800b69:	eb 31                	jmp    800b9c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b6b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b6f:	74 0a                	je     800b7b <atomic_readline+0xda>
  800b71:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b75:	0f 85 61 ff ff ff    	jne    800adc <atomic_readline+0x3b>
				if (echoing)
  800b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b7f:	74 0e                	je     800b8f <atomic_readline+0xee>
					cputchar(c);
  800b81:	83 ec 0c             	sub    $0xc,%esp
  800b84:	ff 75 ec             	pushl  -0x14(%ebp)
  800b87:	e8 51 0d 00 00       	call   8018dd <cputchar>
  800b8c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	01 d0                	add    %edx,%eax
  800b97:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b9a:	eb 06                	jmp    800ba2 <atomic_readline+0x101>
			}
		}
  800b9c:	e9 3b ff ff ff       	jmp    800adc <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800ba1:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ba2:	e8 90 07 00 00       	call   801337 <sys_unlock_cons>
}
  800ba7:	90                   	nop
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb7:	eb 06                	jmp    800bbf <strlen+0x15>
		n++;
  800bb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbc:	ff 45 08             	incl   0x8(%ebp)
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8a 00                	mov    (%eax),%al
  800bc4:	84 c0                	test   %al,%al
  800bc6:	75 f1                	jne    800bb9 <strlen+0xf>
		n++;
	return n;
  800bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bda:	eb 09                	jmp    800be5 <strnlen+0x18>
		n++;
  800bdc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdf:	ff 45 08             	incl   0x8(%ebp)
  800be2:	ff 4d 0c             	decl   0xc(%ebp)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 09                	je     800bf4 <strnlen+0x27>
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	84 c0                	test   %al,%al
  800bf2:	75 e8                	jne    800bdc <strnlen+0xf>
		n++;
	return n;
  800bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c05:	90                   	nop
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8d 50 01             	lea    0x1(%eax),%edx
  800c0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c18:	8a 12                	mov    (%edx),%dl
  800c1a:	88 10                	mov    %dl,(%eax)
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 e4                	jne    800c06 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3a:	eb 1f                	jmp    800c5b <strncpy+0x34>
		*dst++ = *src;
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8d 50 01             	lea    0x1(%eax),%edx
  800c42:	89 55 08             	mov    %edx,0x8(%ebp)
  800c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c48:	8a 12                	mov    (%edx),%dl
  800c4a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	84 c0                	test   %al,%al
  800c53:	74 03                	je     800c58 <strncpy+0x31>
			src++;
  800c55:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c58:	ff 45 fc             	incl   -0x4(%ebp)
  800c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c61:	72 d9                	jb     800c3c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c78:	74 30                	je     800caa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7a:	eb 16                	jmp    800c92 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8d 50 01             	lea    0x1(%eax),%edx
  800c82:	89 55 08             	mov    %edx,0x8(%ebp)
  800c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c88:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8e:	8a 12                	mov    (%edx),%dl
  800c90:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c92:	ff 4d 10             	decl   0x10(%ebp)
  800c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c99:	74 09                	je     800ca4 <strlcpy+0x3c>
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	84 c0                	test   %al,%al
  800ca2:	75 d8                	jne    800c7c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800caa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb0:	29 c2                	sub    %eax,%edx
  800cb2:	89 d0                	mov    %edx,%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb9:	eb 06                	jmp    800cc1 <strcmp+0xb>
		p++, q++;
  800cbb:	ff 45 08             	incl   0x8(%ebp)
  800cbe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 0e                	je     800cd8 <strcmp+0x22>
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8a 10                	mov    (%eax),%dl
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	38 c2                	cmp    %al,%dl
  800cd6:	74 e3                	je     800cbb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 d0             	movzbl %al,%edx
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	8a 00                	mov    (%eax),%al
  800ce5:	0f b6 c0             	movzbl %al,%eax
  800ce8:	29 c2                	sub    %eax,%edx
  800cea:	89 d0                	mov    %edx,%eax
}
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf1:	eb 09                	jmp    800cfc <strncmp+0xe>
		n--, p++, q++;
  800cf3:	ff 4d 10             	decl   0x10(%ebp)
  800cf6:	ff 45 08             	incl   0x8(%ebp)
  800cf9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d00:	74 17                	je     800d19 <strncmp+0x2b>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	74 0e                	je     800d19 <strncmp+0x2b>
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 10                	mov    (%eax),%dl
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	38 c2                	cmp    %al,%dl
  800d17:	74 da                	je     800cf3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	75 07                	jne    800d26 <strncmp+0x38>
		return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d24:	eb 14                	jmp    800d3a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f b6 d0             	movzbl %al,%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f b6 c0             	movzbl %al,%eax
  800d36:	29 c2                	sub    %eax,%edx
  800d38:	89 d0                	mov    %edx,%eax
}
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 04             	sub    $0x4,%esp
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d48:	eb 12                	jmp    800d5c <strchr+0x20>
		if (*s == c)
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d52:	75 05                	jne    800d59 <strchr+0x1d>
			return (char *) s;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	eb 11                	jmp    800d6a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d59:	ff 45 08             	incl   0x8(%ebp)
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 e5                	jne    800d4a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6a:	c9                   	leave  
  800d6b:	c3                   	ret    

00800d6c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 04             	sub    $0x4,%esp
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d78:	eb 0d                	jmp    800d87 <strfind+0x1b>
		if (*s == c)
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d82:	74 0e                	je     800d92 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d84:	ff 45 08             	incl   0x8(%ebp)
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	84 c0                	test   %al,%al
  800d8e:	75 ea                	jne    800d7a <strfind+0xe>
  800d90:	eb 01                	jmp    800d93 <strfind+0x27>
		if (*s == c)
			break;
  800d92:	90                   	nop
	return (char *) s;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800daa:	eb 0e                	jmp    800dba <memset+0x22>
		*p++ = c;
  800dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daf:	8d 50 01             	lea    0x1(%eax),%edx
  800db2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dba:	ff 4d f8             	decl   -0x8(%ebp)
  800dbd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc1:	79 e9                	jns    800dac <memset+0x14>
		*p++ = c;

	return v;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dda:	eb 16                	jmp    800df2 <memcpy+0x2a>
		*d++ = *s++;
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8d 50 01             	lea    0x1(%eax),%edx
  800de2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800deb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dee:	8a 12                	mov    (%edx),%dl
  800df0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df2:	8b 45 10             	mov    0x10(%ebp),%eax
  800df5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	75 dd                	jne    800ddc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e19:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1c:	73 50                	jae    800e6e <memmove+0x6a>
  800e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	01 d0                	add    %edx,%eax
  800e26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e29:	76 43                	jbe    800e6e <memmove+0x6a>
		s += n;
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e31:	8b 45 10             	mov    0x10(%ebp),%eax
  800e34:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e37:	eb 10                	jmp    800e49 <memmove+0x45>
			*--d = *--s;
  800e39:	ff 4d f8             	decl   -0x8(%ebp)
  800e3c:	ff 4d fc             	decl   -0x4(%ebp)
  800e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e42:	8a 10                	mov    (%eax),%dl
  800e44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e47:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e49:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	75 e3                	jne    800e39 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e56:	eb 23                	jmp    800e7b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5b:	8d 50 01             	lea    0x1(%eax),%edx
  800e5e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e67:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6a:	8a 12                	mov    (%edx),%dl
  800e6c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e74:	89 55 10             	mov    %edx,0x10(%ebp)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	75 dd                	jne    800e58 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e92:	eb 2a                	jmp    800ebe <memcmp+0x3e>
		if (*s1 != *s2)
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	8a 10                	mov    (%eax),%dl
  800e99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	38 c2                	cmp    %al,%dl
  800ea0:	74 16                	je     800eb8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 d0             	movzbl %al,%edx
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	0f b6 c0             	movzbl %al,%eax
  800eb2:	29 c2                	sub    %eax,%edx
  800eb4:	89 d0                	mov    %edx,%eax
  800eb6:	eb 18                	jmp    800ed0 <memcmp+0x50>
		s1++, s2++;
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
  800ebb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 c9                	jne    800e94 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	01 d0                	add    %edx,%eax
  800ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee3:	eb 15                	jmp    800efa <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	0f b6 d0             	movzbl %al,%edx
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	0f b6 c0             	movzbl %al,%eax
  800ef3:	39 c2                	cmp    %eax,%edx
  800ef5:	74 0d                	je     800f04 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f00:	72 e3                	jb     800ee5 <memfind+0x13>
  800f02:	eb 01                	jmp    800f05 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f04:	90                   	nop
	return (void *) s;
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1e:	eb 03                	jmp    800f23 <strtol+0x19>
		s++;
  800f20:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 20                	cmp    $0x20,%al
  800f2a:	74 f4                	je     800f20 <strtol+0x16>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 09                	cmp    $0x9,%al
  800f33:	74 eb                	je     800f20 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 2b                	cmp    $0x2b,%al
  800f3c:	75 05                	jne    800f43 <strtol+0x39>
		s++;
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	eb 13                	jmp    800f56 <strtol+0x4c>
	else if (*s == '-')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2d                	cmp    $0x2d,%al
  800f4a:	75 0a                	jne    800f56 <strtol+0x4c>
		s++, neg = 1;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	74 06                	je     800f62 <strtol+0x58>
  800f5c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f60:	75 20                	jne    800f82 <strtol+0x78>
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	3c 30                	cmp    $0x30,%al
  800f69:	75 17                	jne    800f82 <strtol+0x78>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	40                   	inc    %eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 78                	cmp    $0x78,%al
  800f73:	75 0d                	jne    800f82 <strtol+0x78>
		s += 2, base = 16;
  800f75:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f79:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f80:	eb 28                	jmp    800faa <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	75 15                	jne    800f9d <strtol+0x93>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 30                	cmp    $0x30,%al
  800f8f:	75 0c                	jne    800f9d <strtol+0x93>
		s++, base = 8;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9b:	eb 0d                	jmp    800faa <strtol+0xa0>
	else if (base == 0)
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 07                	jne    800faa <strtol+0xa0>
		base = 10;
  800fa3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2f                	cmp    $0x2f,%al
  800fb1:	7e 19                	jle    800fcc <strtol+0xc2>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 39                	cmp    $0x39,%al
  800fba:	7f 10                	jg     800fcc <strtol+0xc2>
			dig = *s - '0';
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	0f be c0             	movsbl %al,%eax
  800fc4:	83 e8 30             	sub    $0x30,%eax
  800fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fca:	eb 42                	jmp    80100e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 60                	cmp    $0x60,%al
  800fd3:	7e 19                	jle    800fee <strtol+0xe4>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 7a                	cmp    $0x7a,%al
  800fdc:	7f 10                	jg     800fee <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f be c0             	movsbl %al,%eax
  800fe6:	83 e8 57             	sub    $0x57,%eax
  800fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fec:	eb 20                	jmp    80100e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 40                	cmp    $0x40,%al
  800ff5:	7e 39                	jle    801030 <strtol+0x126>
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3c 5a                	cmp    $0x5a,%al
  800ffe:	7f 30                	jg     801030 <strtol+0x126>
			dig = *s - 'A' + 10;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f be c0             	movsbl %al,%eax
  801008:	83 e8 37             	sub    $0x37,%eax
  80100b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801011:	3b 45 10             	cmp    0x10(%ebp),%eax
  801014:	7d 19                	jge    80102f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801025:	01 d0                	add    %edx,%eax
  801027:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102a:	e9 7b ff ff ff       	jmp    800faa <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801030:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801034:	74 08                	je     80103e <strtol+0x134>
		*endptr = (char *) s;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8b 55 08             	mov    0x8(%ebp),%edx
  80103c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801042:	74 07                	je     80104b <strtol+0x141>
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801047:	f7 d8                	neg    %eax
  801049:	eb 03                	jmp    80104e <strtol+0x144>
  80104b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <ltostr>:

void
ltostr(long value, char *str)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801064:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801068:	79 13                	jns    80107d <ltostr+0x2d>
	{
		neg = 1;
  80106a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801077:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801085:	99                   	cltd   
  801086:	f7 f9                	idiv   %ecx
  801088:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	89 c2                	mov    %eax,%edx
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109e:	83 c2 30             	add    $0x30,%edx
  8010a1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	75 bb                	jne    80107d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	48                   	dec    %eax
  8010cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d4:	74 3d                	je     801113 <ltostr+0xc3>
		start = 1 ;
  8010d6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010dd:	eb 34                	jmp    801113 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	01 d0                	add    %edx,%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 c2                	add    %eax,%edx
  8010f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	01 c8                	add    %ecx,%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801100:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	01 c2                	add    %eax,%edx
  801108:	8a 45 eb             	mov    -0x15(%ebp),%al
  80110b:	88 02                	mov    %al,(%edx)
		start++ ;
  80110d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801110:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801119:	7c c4                	jl     8010df <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80111b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801126:	90                   	nop
  801127:	c9                   	leave  
  801128:	c3                   	ret    

00801129 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112f:	ff 75 08             	pushl  0x8(%ebp)
  801132:	e8 73 fa ff ff       	call   800baa <strlen>
  801137:	83 c4 04             	add    $0x4,%esp
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	e8 65 fa ff ff       	call   800baa <strlen>
  801145:	83 c4 04             	add    $0x4,%esp
  801148:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80114b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801159:	eb 17                	jmp    801172 <strcconcat+0x49>
		final[s] = str1[s] ;
  80115b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 c2                	add    %eax,%edx
  801163:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	01 c8                	add    %ecx,%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116f:	ff 45 fc             	incl   -0x4(%ebp)
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801178:	7c e1                	jl     80115b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80117a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801181:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801188:	eb 1f                	jmp    8011a9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80118a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801193:	89 c2                	mov    %eax,%edx
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	01 c2                	add    %eax,%edx
  80119a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c8                	add    %ecx,%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a6:	ff 45 f8             	incl   -0x8(%ebp)
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011af:	7c d9                	jl     80118a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b7:	01 d0                	add    %edx,%eax
  8011b9:	c6 00 00             	movb   $0x0,(%eax)
}
  8011bc:	90                   	nop
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ce:	8b 00                	mov    (%eax),%eax
  8011d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e2:	eb 0c                	jmp    8011f0 <strsplit+0x31>
			*string++ = 0;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ed:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	84 c0                	test   %al,%al
  8011f7:	74 18                	je     801211 <strsplit+0x52>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	0f be c0             	movsbl %al,%eax
  801201:	50                   	push   %eax
  801202:	ff 75 0c             	pushl  0xc(%ebp)
  801205:	e8 32 fb ff ff       	call   800d3c <strchr>
  80120a:	83 c4 08             	add    $0x8,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	75 d3                	jne    8011e4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	84 c0                	test   %al,%al
  801218:	74 5a                	je     801274 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80121a:	8b 45 14             	mov    0x14(%ebp),%eax
  80121d:	8b 00                	mov    (%eax),%eax
  80121f:	83 f8 0f             	cmp    $0xf,%eax
  801222:	75 07                	jne    80122b <strsplit+0x6c>
		{
			return 0;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	eb 66                	jmp    801291 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80122b:	8b 45 14             	mov    0x14(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 48 01             	lea    0x1(%eax),%ecx
  801233:	8b 55 14             	mov    0x14(%ebp),%edx
  801236:	89 0a                	mov    %ecx,(%edx)
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 c2                	add    %eax,%edx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801249:	eb 03                	jmp    80124e <strsplit+0x8f>
			string++;
  80124b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	84 c0                	test   %al,%al
  801255:	74 8b                	je     8011e2 <strsplit+0x23>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	0f be c0             	movsbl %al,%eax
  80125f:	50                   	push   %eax
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	e8 d4 fa ff ff       	call   800d3c <strchr>
  801268:	83 c4 08             	add    $0x8,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	74 dc                	je     80124b <strsplit+0x8c>
			string++;
	}
  80126f:	e9 6e ff ff ff       	jmp    8011e2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801274:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801275:	8b 45 14             	mov    0x14(%ebp),%eax
  801278:	8b 00                	mov    (%eax),%eax
  80127a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	68 5c 22 80 00       	push   $0x80225c
  8012a1:	68 3f 01 00 00       	push   $0x13f
  8012a6:	68 7e 22 80 00       	push   $0x80227e
  8012ab:	e8 69 06 00 00       	call   801919 <_panic>

008012b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012cb:	cd 30                	int    $0x30
  8012cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	52                   	push   %edx
  8012f3:	ff 75 0c             	pushl  0xc(%ebp)
  8012f6:	50                   	push   %eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 b2 ff ff ff       	call   8012b0 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	90                   	nop
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <sys_cgetc>:

int
sys_cgetc(void)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 02                	push   $0x2
  801313:	e8 98 ff ff ff       	call   8012b0 <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 03                	push   $0x3
  80132c:	e8 7f ff ff ff       	call   8012b0 <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	90                   	nop
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 04                	push   $0x4
  801346:	e8 65 ff ff ff       	call   8012b0 <syscall>
  80134b:	83 c4 18             	add    $0x18,%esp
}
  80134e:	90                   	nop
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	52                   	push   %edx
  801361:	50                   	push   %eax
  801362:	6a 08                	push   $0x8
  801364:	e8 47 ff ff ff       	call   8012b0 <syscall>
  801369:	83 c4 18             	add    $0x18,%esp
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801373:	8b 75 18             	mov    0x18(%ebp),%esi
  801376:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801379:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	56                   	push   %esi
  801383:	53                   	push   %ebx
  801384:	51                   	push   %ecx
  801385:	52                   	push   %edx
  801386:	50                   	push   %eax
  801387:	6a 09                	push   $0x9
  801389:	e8 22 ff ff ff       	call   8012b0 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801394:	5b                   	pop    %ebx
  801395:	5e                   	pop    %esi
  801396:	5d                   	pop    %ebp
  801397:	c3                   	ret    

00801398 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	6a 0a                	push   $0xa
  8013ab:	e8 00 ff ff ff       	call   8012b0 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	6a 0b                	push   $0xb
  8013c6:	e8 e5 fe ff ff       	call   8012b0 <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 0c                	push   $0xc
  8013df:	e8 cc fe ff ff       	call   8012b0 <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 0d                	push   $0xd
  8013f8:	e8 b3 fe ff ff       	call   8012b0 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 0e                	push   $0xe
  801411:	e8 9a fe ff ff       	call   8012b0 <syscall>
  801416:	83 c4 18             	add    $0x18,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 0f                	push   $0xf
  80142a:	e8 81 fe ff ff       	call   8012b0 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	ff 75 08             	pushl  0x8(%ebp)
  801442:	6a 10                	push   $0x10
  801444:	e8 67 fe ff ff       	call   8012b0 <syscall>
  801449:	83 c4 18             	add    $0x18,%esp
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 11                	push   $0x11
  80145d:	e8 4e fe ff ff       	call   8012b0 <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <sys_cputc>:

void
sys_cputc(const char c)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801474:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	50                   	push   %eax
  801481:	6a 01                	push   $0x1
  801483:	e8 28 fe ff ff       	call   8012b0 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	90                   	nop
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 14                	push   $0x14
  80149d:	e8 0e fe ff ff       	call   8012b0 <syscall>
  8014a2:	83 c4 18             	add    $0x18,%esp
}
  8014a5:	90                   	nop
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014b4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	6a 00                	push   $0x0
  8014c0:	51                   	push   %ecx
  8014c1:	52                   	push   %edx
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	50                   	push   %eax
  8014c6:	6a 15                	push   $0x15
  8014c8:	e8 e3 fd ff ff       	call   8012b0 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	52                   	push   %edx
  8014e2:	50                   	push   %eax
  8014e3:	6a 16                	push   $0x16
  8014e5:	e8 c6 fd ff ff       	call   8012b0 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	51                   	push   %ecx
  801500:	52                   	push   %edx
  801501:	50                   	push   %eax
  801502:	6a 17                	push   $0x17
  801504:	e8 a7 fd ff ff       	call   8012b0 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	52                   	push   %edx
  80151e:	50                   	push   %eax
  80151f:	6a 18                	push   $0x18
  801521:	e8 8a fd ff ff       	call   8012b0 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	6a 00                	push   $0x0
  801533:	ff 75 14             	pushl  0x14(%ebp)
  801536:	ff 75 10             	pushl  0x10(%ebp)
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	50                   	push   %eax
  80153d:	6a 19                	push   $0x19
  80153f:	e8 6c fd ff ff       	call   8012b0 <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	50                   	push   %eax
  801558:	6a 1a                	push   $0x1a
  80155a:	e8 51 fd ff ff       	call   8012b0 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	90                   	nop
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	50                   	push   %eax
  801574:	6a 1b                	push   $0x1b
  801576:	e8 35 fd ff ff       	call   8012b0 <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 05                	push   $0x5
  80158f:	e8 1c fd ff ff       	call   8012b0 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 06                	push   $0x6
  8015a8:	e8 03 fd ff ff       	call   8012b0 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 07                	push   $0x7
  8015c1:	e8 ea fc ff ff       	call   8012b0 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_exit_env>:


void sys_exit_env(void)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 1c                	push   $0x1c
  8015da:	e8 d1 fc ff ff       	call   8012b0 <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	90                   	nop
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ee:	8d 50 04             	lea    0x4(%eax),%edx
  8015f1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	52                   	push   %edx
  8015fb:	50                   	push   %eax
  8015fc:	6a 1d                	push   $0x1d
  8015fe:	e8 ad fc ff ff       	call   8012b0 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return result;
  801606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801609:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160f:	89 01                	mov    %eax,(%ecx)
  801611:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	c9                   	leave  
  801618:	c2 04 00             	ret    $0x4

0080161b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	ff 75 10             	pushl  0x10(%ebp)
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	ff 75 08             	pushl  0x8(%ebp)
  80162b:	6a 13                	push   $0x13
  80162d:	e8 7e fc ff ff       	call   8012b0 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return ;
  801635:	90                   	nop
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_rcr2>:
uint32 sys_rcr2()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 1e                	push   $0x1e
  801647:	e8 64 fc ff ff       	call   8012b0 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80165d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	50                   	push   %eax
  80166a:	6a 1f                	push   $0x1f
  80166c:	e8 3f fc ff ff       	call   8012b0 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
	return ;
  801674:	90                   	nop
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <rsttst>:
void rsttst()
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 21                	push   $0x21
  801686:	e8 25 fc ff ff       	call   8012b0 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
	return ;
  80168e:	90                   	nop
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	8b 45 14             	mov    0x14(%ebp),%eax
  80169a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80169d:	8b 55 18             	mov    0x18(%ebp),%edx
  8016a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	ff 75 10             	pushl  0x10(%ebp)
  8016a9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	6a 20                	push   $0x20
  8016b1:	e8 fa fb ff ff       	call   8012b0 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b9:	90                   	nop
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <chktst>:
void chktst(uint32 n)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	6a 22                	push   $0x22
  8016cc:	e8 df fb ff ff       	call   8012b0 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <inctst>:

void inctst()
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 23                	push   $0x23
  8016e6:	e8 c5 fb ff ff       	call   8012b0 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ee:	90                   	nop
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <gettst>:
uint32 gettst()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 24                	push   $0x24
  801700:	e8 ab fb ff ff       	call   8012b0 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 25                	push   $0x25
  80171c:	e8 8f fb ff ff       	call   8012b0 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
  801724:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801727:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80172b:	75 07                	jne    801734 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80172d:	b8 01 00 00 00       	mov    $0x1,%eax
  801732:	eb 05                	jmp    801739 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 25                	push   $0x25
  80174d:	e8 5e fb ff ff       	call   8012b0 <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
  801755:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801758:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80175c:	75 07                	jne    801765 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80175e:	b8 01 00 00 00       	mov    $0x1,%eax
  801763:	eb 05                	jmp    80176a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 25                	push   $0x25
  80177e:	e8 2d fb ff ff       	call   8012b0 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
  801786:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801789:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80178d:	75 07                	jne    801796 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80178f:	b8 01 00 00 00       	mov    $0x1,%eax
  801794:	eb 05                	jmp    80179b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 25                	push   $0x25
  8017af:	e8 fc fa ff ff       	call   8012b0 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
  8017b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017ba:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017be:	75 07                	jne    8017c7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c5:	eb 05                	jmp    8017cc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 26                	push   $0x26
  8017de:	e8 cd fa ff ff       	call   8012b0 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	53                   	push   %ebx
  8017fc:	51                   	push   %ecx
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	6a 27                	push   $0x27
  801801:	e8 aa fa ff ff       	call   8012b0 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	6a 28                	push   $0x28
  801821:	e8 8a fa ff ff       	call   8012b0 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80182e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	51                   	push   %ecx
  80183a:	ff 75 10             	pushl  0x10(%ebp)
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 29                	push   $0x29
  801841:	e8 6a fa ff ff       	call   8012b0 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 10             	pushl  0x10(%ebp)
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	6a 12                	push   $0x12
  80185d:	e8 4e fa ff ff       	call   8012b0 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
	return ;
  801865:	90                   	nop
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	52                   	push   %edx
  801878:	50                   	push   %eax
  801879:	6a 2a                	push   $0x2a
  80187b:	e8 30 fa ff ff       	call   8012b0 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
	return;
  801883:	90                   	nop
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	68 8b 22 80 00       	push   $0x80228b
  801894:	68 2e 01 00 00       	push   $0x12e
  801899:	68 9f 22 80 00       	push   $0x80229f
  80189e:	e8 76 00 00 00       	call   801919 <_panic>

008018a3 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	68 8b 22 80 00       	push   $0x80228b
  8018b1:	68 35 01 00 00       	push   $0x135
  8018b6:	68 9f 22 80 00       	push   $0x80229f
  8018bb:	e8 59 00 00 00       	call   801919 <_panic>

008018c0 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 8b 22 80 00       	push   $0x80228b
  8018ce:	68 3b 01 00 00       	push   $0x13b
  8018d3:	68 9f 22 80 00       	push   $0x80229f
  8018d8:	e8 3c 00 00 00       	call   801919 <_panic>

008018dd <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018ed:	83 ec 0c             	sub    $0xc,%esp
  8018f0:	50                   	push   %eax
  8018f1:	e8 72 fb ff ff       	call   801468 <sys_cputc>
  8018f6:	83 c4 10             	add    $0x10,%esp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <getchar>:


int
getchar(void)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801902:	e8 fd f9 ff ff       	call   801304 <sys_cgetc>
  801907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <iscons>:

int iscons(int fdnum)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801912:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80191f:	8d 45 10             	lea    0x10(%ebp),%eax
  801922:	83 c0 04             	add    $0x4,%eax
  801925:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801928:	a1 24 30 80 00       	mov    0x803024,%eax
  80192d:	85 c0                	test   %eax,%eax
  80192f:	74 16                	je     801947 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801931:	a1 24 30 80 00       	mov    0x803024,%eax
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	50                   	push   %eax
  80193a:	68 b0 22 80 00       	push   $0x8022b0
  80193f:	e8 ca e9 ff ff       	call   80030e <cprintf>
  801944:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801947:	a1 00 30 80 00       	mov    0x803000,%eax
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	50                   	push   %eax
  801953:	68 b5 22 80 00       	push   $0x8022b5
  801958:	e8 b1 e9 ff ff       	call   80030e <cprintf>
  80195d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801960:	8b 45 10             	mov    0x10(%ebp),%eax
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	ff 75 f4             	pushl  -0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	e8 34 e9 ff ff       	call   8002a3 <vcprintf>
  80196f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	6a 00                	push   $0x0
  801977:	68 d1 22 80 00       	push   $0x8022d1
  80197c:	e8 22 e9 ff ff       	call   8002a3 <vcprintf>
  801981:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801984:	e8 a3 e8 ff ff       	call   80022c <exit>

	// should not return here
	while (1) ;
  801989:	eb fe                	jmp    801989 <_panic+0x70>

0080198b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801991:	a1 04 30 80 00       	mov    0x803004,%eax
  801996:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	39 c2                	cmp    %eax,%edx
  8019a1:	74 14                	je     8019b7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	68 d4 22 80 00       	push   $0x8022d4
  8019ab:	6a 26                	push   $0x26
  8019ad:	68 20 23 80 00       	push   $0x802320
  8019b2:	e8 62 ff ff ff       	call   801919 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019c5:	e9 c5 00 00 00       	jmp    801a8f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	01 d0                	add    %edx,%eax
  8019d9:	8b 00                	mov    (%eax),%eax
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	75 08                	jne    8019e7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8019df:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019e2:	e9 a5 00 00 00       	jmp    801a8c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8019e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019f5:	eb 69                	jmp    801a60 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8019fc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a05:	89 d0                	mov    %edx,%eax
  801a07:	01 c0                	add    %eax,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	c1 e0 03             	shl    $0x3,%eax
  801a0e:	01 c8                	add    %ecx,%eax
  801a10:	8a 40 04             	mov    0x4(%eax),%al
  801a13:	84 c0                	test   %al,%al
  801a15:	75 46                	jne    801a5d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a17:	a1 04 30 80 00       	mov    0x803004,%eax
  801a1c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a25:	89 d0                	mov    %edx,%eax
  801a27:	01 c0                	add    %eax,%eax
  801a29:	01 d0                	add    %edx,%eax
  801a2b:	c1 e0 03             	shl    $0x3,%eax
  801a2e:	01 c8                	add    %ecx,%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a3d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	01 c8                	add    %ecx,%eax
  801a4e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a50:	39 c2                	cmp    %eax,%edx
  801a52:	75 09                	jne    801a5d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a54:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a5b:	eb 15                	jmp    801a72 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a5d:	ff 45 e8             	incl   -0x18(%ebp)
  801a60:	a1 04 30 80 00       	mov    0x803004,%eax
  801a65:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6e:	39 c2                	cmp    %eax,%edx
  801a70:	77 85                	ja     8019f7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a76:	75 14                	jne    801a8c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	68 2c 23 80 00       	push   $0x80232c
  801a80:	6a 3a                	push   $0x3a
  801a82:	68 20 23 80 00       	push   $0x802320
  801a87:	e8 8d fe ff ff       	call   801919 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a8c:	ff 45 f0             	incl   -0x10(%ebp)
  801a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a92:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a95:	0f 8c 2f ff ff ff    	jl     8019ca <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801aa9:	eb 26                	jmp    801ad1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801aab:	a1 04 30 80 00       	mov    0x803004,%eax
  801ab0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801ab6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab9:	89 d0                	mov    %edx,%eax
  801abb:	01 c0                	add    %eax,%eax
  801abd:	01 d0                	add    %edx,%eax
  801abf:	c1 e0 03             	shl    $0x3,%eax
  801ac2:	01 c8                	add    %ecx,%eax
  801ac4:	8a 40 04             	mov    0x4(%eax),%al
  801ac7:	3c 01                	cmp    $0x1,%al
  801ac9:	75 03                	jne    801ace <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801acb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ace:	ff 45 e0             	incl   -0x20(%ebp)
  801ad1:	a1 04 30 80 00       	mov    0x803004,%eax
  801ad6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801adf:	39 c2                	cmp    %eax,%edx
  801ae1:	77 c8                	ja     801aab <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ae9:	74 14                	je     801aff <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	68 80 23 80 00       	push   $0x802380
  801af3:	6a 44                	push   $0x44
  801af5:	68 20 23 80 00       	push   $0x802320
  801afa:	e8 1a fe ff ff       	call   801919 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    
  801b02:	66 90                	xchg   %ax,%ax

00801b04 <__udivdi3>:
  801b04:	55                   	push   %ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1b:	89 ca                	mov    %ecx,%edx
  801b1d:	89 f8                	mov    %edi,%eax
  801b1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b23:	85 f6                	test   %esi,%esi
  801b25:	75 2d                	jne    801b54 <__udivdi3+0x50>
  801b27:	39 cf                	cmp    %ecx,%edi
  801b29:	77 65                	ja     801b90 <__udivdi3+0x8c>
  801b2b:	89 fd                	mov    %edi,%ebp
  801b2d:	85 ff                	test   %edi,%edi
  801b2f:	75 0b                	jne    801b3c <__udivdi3+0x38>
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	f7 f7                	div    %edi
  801b3a:	89 c5                	mov    %eax,%ebp
  801b3c:	31 d2                	xor    %edx,%edx
  801b3e:	89 c8                	mov    %ecx,%eax
  801b40:	f7 f5                	div    %ebp
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	f7 f5                	div    %ebp
  801b48:	89 cf                	mov    %ecx,%edi
  801b4a:	89 fa                	mov    %edi,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	77 28                	ja     801b80 <__udivdi3+0x7c>
  801b58:	0f bd fe             	bsr    %esi,%edi
  801b5b:	83 f7 1f             	xor    $0x1f,%edi
  801b5e:	75 40                	jne    801ba0 <__udivdi3+0x9c>
  801b60:	39 ce                	cmp    %ecx,%esi
  801b62:	72 0a                	jb     801b6e <__udivdi3+0x6a>
  801b64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b68:	0f 87 9e 00 00 00    	ja     801c0c <__udivdi3+0x108>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	89 fa                	mov    %edi,%edx
  801b75:	83 c4 1c             	add    $0x1c,%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5f                   	pop    %edi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
  801b7d:	8d 76 00             	lea    0x0(%esi),%esi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	31 c0                	xor    %eax,%eax
  801b84:	89 fa                	mov    %edi,%edx
  801b86:	83 c4 1c             	add    $0x1c,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f7                	div    %edi
  801b94:	31 ff                	xor    %edi,%edi
  801b96:	89 fa                	mov    %edi,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba5:	89 eb                	mov    %ebp,%ebx
  801ba7:	29 fb                	sub    %edi,%ebx
  801ba9:	89 f9                	mov    %edi,%ecx
  801bab:	d3 e6                	shl    %cl,%esi
  801bad:	89 c5                	mov    %eax,%ebp
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 ed                	shr    %cl,%ebp
  801bb3:	89 e9                	mov    %ebp,%ecx
  801bb5:	09 f1                	or     %esi,%ecx
  801bb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e0                	shl    %cl,%eax
  801bbf:	89 c5                	mov    %eax,%ebp
  801bc1:	89 d6                	mov    %edx,%esi
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 ee                	shr    %cl,%esi
  801bc7:	89 f9                	mov    %edi,%ecx
  801bc9:	d3 e2                	shl    %cl,%edx
  801bcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bcf:	88 d9                	mov    %bl,%cl
  801bd1:	d3 e8                	shr    %cl,%eax
  801bd3:	09 c2                	or     %eax,%edx
  801bd5:	89 d0                	mov    %edx,%eax
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	f7 74 24 0c          	divl   0xc(%esp)
  801bdd:	89 d6                	mov    %edx,%esi
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	f7 e5                	mul    %ebp
  801be3:	39 d6                	cmp    %edx,%esi
  801be5:	72 19                	jb     801c00 <__udivdi3+0xfc>
  801be7:	74 0b                	je     801bf4 <__udivdi3+0xf0>
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	31 ff                	xor    %edi,%edi
  801bed:	e9 58 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bf8:	89 f9                	mov    %edi,%ecx
  801bfa:	d3 e2                	shl    %cl,%edx
  801bfc:	39 c2                	cmp    %eax,%edx
  801bfe:	73 e9                	jae    801be9 <__udivdi3+0xe5>
  801c00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c03:	31 ff                	xor    %edi,%edi
  801c05:	e9 40 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	31 c0                	xor    %eax,%eax
  801c0e:	e9 37 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c13:	90                   	nop

00801c14 <__umoddi3>:
  801c14:	55                   	push   %ebp
  801c15:	57                   	push   %edi
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	83 ec 1c             	sub    $0x1c,%esp
  801c1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c33:	89 f3                	mov    %esi,%ebx
  801c35:	89 fa                	mov    %edi,%edx
  801c37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3b:	89 34 24             	mov    %esi,(%esp)
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	75 1a                	jne    801c5c <__umoddi3+0x48>
  801c42:	39 f7                	cmp    %esi,%edi
  801c44:	0f 86 a2 00 00 00    	jbe    801cec <__umoddi3+0xd8>
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	89 f2                	mov    %esi,%edx
  801c4e:	f7 f7                	div    %edi
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	31 d2                	xor    %edx,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 f0                	cmp    %esi,%eax
  801c5e:	0f 87 ac 00 00 00    	ja     801d10 <__umoddi3+0xfc>
  801c64:	0f bd e8             	bsr    %eax,%ebp
  801c67:	83 f5 1f             	xor    $0x1f,%ebp
  801c6a:	0f 84 ac 00 00 00    	je     801d1c <__umoddi3+0x108>
  801c70:	bf 20 00 00 00       	mov    $0x20,%edi
  801c75:	29 ef                	sub    %ebp,%edi
  801c77:	89 fe                	mov    %edi,%esi
  801c79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e0                	shl    %cl,%eax
  801c81:	89 d7                	mov    %edx,%edi
  801c83:	89 f1                	mov    %esi,%ecx
  801c85:	d3 ef                	shr    %cl,%edi
  801c87:	09 c7                	or     %eax,%edi
  801c89:	89 e9                	mov    %ebp,%ecx
  801c8b:	d3 e2                	shl    %cl,%edx
  801c8d:	89 14 24             	mov    %edx,(%esp)
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	d3 e0                	shl    %cl,%eax
  801c94:	89 c2                	mov    %eax,%edx
  801c96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9a:	d3 e0                	shl    %cl,%eax
  801c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca4:	89 f1                	mov    %esi,%ecx
  801ca6:	d3 e8                	shr    %cl,%eax
  801ca8:	09 d0                	or     %edx,%eax
  801caa:	d3 eb                	shr    %cl,%ebx
  801cac:	89 da                	mov    %ebx,%edx
  801cae:	f7 f7                	div    %edi
  801cb0:	89 d3                	mov    %edx,%ebx
  801cb2:	f7 24 24             	mull   (%esp)
  801cb5:	89 c6                	mov    %eax,%esi
  801cb7:	89 d1                	mov    %edx,%ecx
  801cb9:	39 d3                	cmp    %edx,%ebx
  801cbb:	0f 82 87 00 00 00    	jb     801d48 <__umoddi3+0x134>
  801cc1:	0f 84 91 00 00 00    	je     801d58 <__umoddi3+0x144>
  801cc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ccb:	29 f2                	sub    %esi,%edx
  801ccd:	19 cb                	sbb    %ecx,%ebx
  801ccf:	89 d8                	mov    %ebx,%eax
  801cd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd5:	d3 e0                	shl    %cl,%eax
  801cd7:	89 e9                	mov    %ebp,%ecx
  801cd9:	d3 ea                	shr    %cl,%edx
  801cdb:	09 d0                	or     %edx,%eax
  801cdd:	89 e9                	mov    %ebp,%ecx
  801cdf:	d3 eb                	shr    %cl,%ebx
  801ce1:	89 da                	mov    %ebx,%edx
  801ce3:	83 c4 1c             	add    $0x1c,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
  801ceb:	90                   	nop
  801cec:	89 fd                	mov    %edi,%ebp
  801cee:	85 ff                	test   %edi,%edi
  801cf0:	75 0b                	jne    801cfd <__umoddi3+0xe9>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	31 d2                	xor    %edx,%edx
  801cf9:	f7 f7                	div    %edi
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 f0                	mov    %esi,%eax
  801cff:	31 d2                	xor    %edx,%edx
  801d01:	f7 f5                	div    %ebp
  801d03:	89 c8                	mov    %ecx,%eax
  801d05:	f7 f5                	div    %ebp
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	e9 44 ff ff ff       	jmp    801c52 <__umoddi3+0x3e>
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	89 c8                	mov    %ecx,%eax
  801d12:	89 f2                	mov    %esi,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	3b 04 24             	cmp    (%esp),%eax
  801d1f:	72 06                	jb     801d27 <__umoddi3+0x113>
  801d21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d25:	77 0f                	ja     801d36 <__umoddi3+0x122>
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	29 f9                	sub    %edi,%ecx
  801d2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d2f:	89 14 24             	mov    %edx,(%esp)
  801d32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d3a:	8b 14 24             	mov    (%esp),%edx
  801d3d:	83 c4 1c             	add    $0x1c,%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
  801d45:	8d 76 00             	lea    0x0(%esi),%esi
  801d48:	2b 04 24             	sub    (%esp),%eax
  801d4b:	19 fa                	sbb    %edi,%edx
  801d4d:	89 d1                	mov    %edx,%ecx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	e9 71 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d5c:	72 ea                	jb     801d48 <__umoddi3+0x134>
  801d5e:	89 d9                	mov    %ebx,%ecx
  801d60:	e9 62 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
