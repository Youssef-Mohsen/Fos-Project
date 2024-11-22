
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 e0 1a 80 00       	push   $0x801ae0
  80005b:	e8 62 02 00 00       	call   8002c2 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 e3 1a 80 00       	push   $0x801ae3
  800092:	e8 2b 02 00 00       	call   8002c2 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000b5:	e8 8b 12 00 00       	call   801345 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	c1 e0 03             	shl    $0x3,%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000ce:	01 c8                	add    %ecx,%eax
  8000d0:	01 c0                	add    %eax,%eax
  8000d2:	01 d0                	add    %edx,%eax
  8000d4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000db:	01 c8                	add    %ecx,%eax
  8000dd:	01 d0                	add    %edx,%eax
  8000df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e4:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ee:	8a 40 20             	mov    0x20(%eax),%al
  8000f1:	84 c0                	test   %al,%al
  8000f3:	74 0d                	je     800102 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fa:	83 c0 20             	add    $0x20,%eax
  8000fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800106:	7e 0a                	jle    800112 <libmain+0x63>
		binaryname = argv[0];
  800108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010b:	8b 00                	mov    (%eax),%eax
  80010d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	ff 75 0c             	pushl  0xc(%ebp)
  800118:	ff 75 08             	pushl  0x8(%ebp)
  80011b:	e8 18 ff ff ff       	call   800038 <_main>
  800120:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800123:	e8 a1 0f 00 00       	call   8010c9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	68 00 1b 80 00       	push   $0x801b00
  800130:	e8 8d 01 00 00       	call   8002c2 <cprintf>
  800135:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800138:	a1 04 30 80 00       	mov    0x803004,%eax
  80013d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800143:	a1 04 30 80 00       	mov    0x803004,%eax
  800148:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	52                   	push   %edx
  800152:	50                   	push   %eax
  800153:	68 28 1b 80 00       	push   $0x801b28
  800158:	e8 65 01 00 00       	call   8002c2 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800160:	a1 04 30 80 00       	mov    0x803004,%eax
  800165:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80016b:	a1 04 30 80 00       	mov    0x803004,%eax
  800170:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800176:	a1 04 30 80 00       	mov    0x803004,%eax
  80017b:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800181:	51                   	push   %ecx
  800182:	52                   	push   %edx
  800183:	50                   	push   %eax
  800184:	68 50 1b 80 00       	push   $0x801b50
  800189:	e8 34 01 00 00       	call   8002c2 <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800191:	a1 04 30 80 00       	mov    0x803004,%eax
  800196:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	50                   	push   %eax
  8001a0:	68 a8 1b 80 00       	push   $0x801ba8
  8001a5:	e8 18 01 00 00       	call   8002c2 <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 00 1b 80 00       	push   $0x801b00
  8001b5:	e8 08 01 00 00       	call   8002c2 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001bd:	e8 21 0f 00 00       	call   8010e3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001c2:	e8 19 00 00 00       	call   8001e0 <exit>
}
  8001c7:	90                   	nop
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	6a 00                	push   $0x0
  8001d5:	e8 37 11 00 00       	call   801311 <sys_destroy_env>
  8001da:	83 c4 10             	add    $0x10,%esp
}
  8001dd:	90                   	nop
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <exit>:

void
exit(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001e6:	e8 8c 11 00 00       	call   801377 <sys_exit_env>
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	8b 00                	mov    (%eax),%eax
  8001f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 0a                	mov    %ecx,(%edx)
  800201:	8b 55 08             	mov    0x8(%ebp),%edx
  800204:	88 d1                	mov    %dl,%cl
  800206:	8b 55 0c             	mov    0xc(%ebp),%edx
  800209:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	3d ff 00 00 00       	cmp    $0xff,%eax
  800217:	75 2c                	jne    800245 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800219:	a0 08 30 80 00       	mov    0x803008,%al
  80021e:	0f b6 c0             	movzbl %al,%eax
  800221:	8b 55 0c             	mov    0xc(%ebp),%edx
  800224:	8b 12                	mov    (%edx),%edx
  800226:	89 d1                	mov    %edx,%ecx
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	83 c2 08             	add    $0x8,%edx
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	50                   	push   %eax
  800232:	51                   	push   %ecx
  800233:	52                   	push   %edx
  800234:	e8 4e 0e 00 00       	call   801087 <sys_cputs>
  800239:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80023c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	8b 40 04             	mov    0x4(%eax),%eax
  80024b:	8d 50 01             	lea    0x1(%eax),%edx
  80024e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800251:	89 50 04             	mov    %edx,0x4(%eax)
}
  800254:	90                   	nop
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800260:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800267:	00 00 00 
	b.cnt = 0;
  80026a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800271:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800280:	50                   	push   %eax
  800281:	68 ee 01 80 00       	push   $0x8001ee
  800286:	e8 11 02 00 00       	call   80049c <vprintfmt>
  80028b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80028e:	a0 08 30 80 00       	mov    0x803008,%al
  800293:	0f b6 c0             	movzbl %al,%eax
  800296:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	50                   	push   %eax
  8002a0:	52                   	push   %edx
  8002a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a7:	83 c0 08             	add    $0x8,%eax
  8002aa:	50                   	push   %eax
  8002ab:	e8 d7 0d 00 00       	call   801087 <sys_cputs>
  8002b0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	ff 75 f4             	pushl  -0xc(%ebp)
  8002de:	50                   	push   %eax
  8002df:	e8 73 ff ff ff       	call   800257 <vcprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002f5:	e8 cf 0d 00 00       	call   8010c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	ff 75 f4             	pushl  -0xc(%ebp)
  800309:	50                   	push   %eax
  80030a:	e8 48 ff ff ff       	call   800257 <vcprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800315:	e8 c9 0d 00 00       	call   8010e3 <sys_unlock_cons>
	return cnt;
  80031a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	53                   	push   %ebx
  800323:	83 ec 14             	sub    $0x14,%esp
  800326:	8b 45 10             	mov    0x10(%ebp),%eax
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80032c:	8b 45 14             	mov    0x14(%ebp),%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	8b 45 18             	mov    0x18(%ebp),%eax
  800335:	ba 00 00 00 00       	mov    $0x0,%edx
  80033a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033d:	77 55                	ja     800394 <printnum+0x75>
  80033f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800342:	72 05                	jb     800349 <printnum+0x2a>
  800344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800347:	77 4b                	ja     800394 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800349:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80034c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034f:	8b 45 18             	mov    0x18(%ebp),%eax
  800352:	ba 00 00 00 00       	mov    $0x0,%edx
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	ff 75 f4             	pushl  -0xc(%ebp)
  80035c:	ff 75 f0             	pushl  -0x10(%ebp)
  80035f:	e8 0c 15 00 00       	call   801870 <__udivdi3>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	ff 75 20             	pushl  0x20(%ebp)
  80036d:	53                   	push   %ebx
  80036e:	ff 75 18             	pushl  0x18(%ebp)
  800371:	52                   	push   %edx
  800372:	50                   	push   %eax
  800373:	ff 75 0c             	pushl  0xc(%ebp)
  800376:	ff 75 08             	pushl  0x8(%ebp)
  800379:	e8 a1 ff ff ff       	call   80031f <printnum>
  80037e:	83 c4 20             	add    $0x20,%esp
  800381:	eb 1a                	jmp    80039d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	ff 75 0c             	pushl  0xc(%ebp)
  800389:	ff 75 20             	pushl  0x20(%ebp)
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	ff d0                	call   *%eax
  800391:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800394:	ff 4d 1c             	decl   0x1c(%ebp)
  800397:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80039b:	7f e6                	jg     800383 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	53                   	push   %ebx
  8003ac:	51                   	push   %ecx
  8003ad:	52                   	push   %edx
  8003ae:	50                   	push   %eax
  8003af:	e8 cc 15 00 00       	call   801980 <__umoddi3>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	05 d4 1d 80 00       	add    $0x801dd4,%eax
  8003bc:	8a 00                	mov    (%eax),%al
  8003be:	0f be c0             	movsbl %al,%eax
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	50                   	push   %eax
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	ff d0                	call   *%eax
  8003cd:	83 c4 10             	add    $0x10,%esp
}
  8003d0:	90                   	nop
  8003d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003dd:	7e 1c                	jle    8003fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	8d 50 08             	lea    0x8(%eax),%edx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	89 10                	mov    %edx,(%eax)
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	83 e8 08             	sub    $0x8,%eax
  8003f4:	8b 50 04             	mov    0x4(%eax),%edx
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	eb 40                	jmp    80043b <getuint+0x65>
	else if (lflag)
  8003fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ff:	74 1e                	je     80041f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	8d 50 04             	lea    0x4(%eax),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	89 10                	mov    %edx,(%eax)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 e8 04             	sub    $0x4,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
  80041d:	eb 1c                	jmp    80043b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 10                	mov    %edx,(%eax)
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	83 e8 04             	sub    $0x4,%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800440:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800444:	7e 1c                	jle    800462 <getint+0x25>
		return va_arg(*ap, long long);
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	8d 50 08             	lea    0x8(%eax),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 10                	mov    %edx,(%eax)
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	83 e8 08             	sub    $0x8,%eax
  80045b:	8b 50 04             	mov    0x4(%eax),%edx
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	eb 38                	jmp    80049a <getint+0x5d>
	else if (lflag)
  800462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800466:	74 1a                	je     800482 <getint+0x45>
		return va_arg(*ap, long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 04             	lea    0x4(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 04             	sub    $0x4,%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	99                   	cltd   
  800480:	eb 18                	jmp    80049a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 04             	lea    0x4(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 04             	sub    $0x4,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	99                   	cltd   
}
  80049a:	5d                   	pop    %ebp
  80049b:	c3                   	ret    

0080049c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	56                   	push   %esi
  8004a0:	53                   	push   %ebx
  8004a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a4:	eb 17                	jmp    8004bd <vprintfmt+0x21>
			if (ch == '\0')
  8004a6:	85 db                	test   %ebx,%ebx
  8004a8:	0f 84 c1 03 00 00    	je     80086f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	53                   	push   %ebx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	ff d0                	call   *%eax
  8004ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c0:	8d 50 01             	lea    0x1(%eax),%edx
  8004c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c6:	8a 00                	mov    (%eax),%al
  8004c8:	0f b6 d8             	movzbl %al,%ebx
  8004cb:	83 fb 25             	cmp    $0x25,%ebx
  8004ce:	75 d6                	jne    8004a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f9:	8a 00                	mov    (%eax),%al
  8004fb:	0f b6 d8             	movzbl %al,%ebx
  8004fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800501:	83 f8 5b             	cmp    $0x5b,%eax
  800504:	0f 87 3d 03 00 00    	ja     800847 <vprintfmt+0x3ab>
  80050a:	8b 04 85 f8 1d 80 00 	mov    0x801df8(,%eax,4),%eax
  800511:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800513:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800517:	eb d7                	jmp    8004f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800519:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80051d:	eb d1                	jmp    8004f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800529:	89 d0                	mov    %edx,%eax
  80052b:	c1 e0 02             	shl    $0x2,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	01 c0                	add    %eax,%eax
  800532:	01 d8                	add    %ebx,%eax
  800534:	83 e8 30             	sub    $0x30,%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80053a:	8b 45 10             	mov    0x10(%ebp),%eax
  80053d:	8a 00                	mov    (%eax),%al
  80053f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800542:	83 fb 2f             	cmp    $0x2f,%ebx
  800545:	7e 3e                	jle    800585 <vprintfmt+0xe9>
  800547:	83 fb 39             	cmp    $0x39,%ebx
  80054a:	7f 39                	jg     800585 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80054f:	eb d5                	jmp    800526 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	83 c0 04             	add    $0x4,%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 e8 04             	sub    $0x4,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800565:	eb 1f                	jmp    800586 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056b:	79 83                	jns    8004f0 <vprintfmt+0x54>
				width = 0;
  80056d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800574:	e9 77 ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800579:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800580:	e9 6b ff ff ff       	jmp    8004f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800585:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800586:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058a:	0f 89 60 ff ff ff    	jns    8004f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800596:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80059d:	e9 4e ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005a5:	e9 46 ff ff ff       	jmp    8004f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	83 c0 04             	add    $0x4,%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	83 e8 04             	sub    $0x4,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	50                   	push   %eax
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	ff d0                	call   *%eax
  8005c7:	83 c4 10             	add    $0x10,%esp
			break;
  8005ca:	e9 9b 02 00 00       	jmp    80086a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	83 c0 04             	add    $0x4,%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005e0:	85 db                	test   %ebx,%ebx
  8005e2:	79 02                	jns    8005e6 <vprintfmt+0x14a>
				err = -err;
  8005e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e6:	83 fb 64             	cmp    $0x64,%ebx
  8005e9:	7f 0b                	jg     8005f6 <vprintfmt+0x15a>
  8005eb:	8b 34 9d 40 1c 80 00 	mov    0x801c40(,%ebx,4),%esi
  8005f2:	85 f6                	test   %esi,%esi
  8005f4:	75 19                	jne    80060f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f6:	53                   	push   %ebx
  8005f7:	68 e5 1d 80 00       	push   $0x801de5
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	ff 75 08             	pushl  0x8(%ebp)
  800602:	e8 70 02 00 00       	call   800877 <printfmt>
  800607:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80060a:	e9 5b 02 00 00       	jmp    80086a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060f:	56                   	push   %esi
  800610:	68 ee 1d 80 00       	push   $0x801dee
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	ff 75 08             	pushl  0x8(%ebp)
  80061b:	e8 57 02 00 00       	call   800877 <printfmt>
  800620:	83 c4 10             	add    $0x10,%esp
			break;
  800623:	e9 42 02 00 00       	jmp    80086a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 14             	mov    %eax,0x14(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	83 e8 04             	sub    $0x4,%eax
  800637:	8b 30                	mov    (%eax),%esi
  800639:	85 f6                	test   %esi,%esi
  80063b:	75 05                	jne    800642 <vprintfmt+0x1a6>
				p = "(null)";
  80063d:	be f1 1d 80 00       	mov    $0x801df1,%esi
			if (width > 0 && padc != '-')
  800642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800646:	7e 6d                	jle    8006b5 <vprintfmt+0x219>
  800648:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80064c:	74 67                	je     8006b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	50                   	push   %eax
  800655:	56                   	push   %esi
  800656:	e8 1e 03 00 00       	call   800979 <strnlen>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800661:	eb 16                	jmp    800679 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800663:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	ff 4d e4             	decl   -0x1c(%ebp)
  800679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067d:	7f e4                	jg     800663 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067f:	eb 34                	jmp    8006b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800681:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800685:	74 1c                	je     8006a3 <vprintfmt+0x207>
  800687:	83 fb 1f             	cmp    $0x1f,%ebx
  80068a:	7e 05                	jle    800691 <vprintfmt+0x1f5>
  80068c:	83 fb 7e             	cmp    $0x7e,%ebx
  80068f:	7e 12                	jle    8006a3 <vprintfmt+0x207>
					putch('?', putdat);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 0c             	pushl  0xc(%ebp)
  800697:	6a 3f                	push   $0x3f
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	ff d0                	call   *%eax
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	eb 0f                	jmp    8006b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 0c             	pushl  0xc(%ebp)
  8006a9:	53                   	push   %ebx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	ff d0                	call   *%eax
  8006af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	8d 70 01             	lea    0x1(%eax),%esi
  8006ba:	8a 00                	mov    (%eax),%al
  8006bc:	0f be d8             	movsbl %al,%ebx
  8006bf:	85 db                	test   %ebx,%ebx
  8006c1:	74 24                	je     8006e7 <vprintfmt+0x24b>
  8006c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c7:	78 b8                	js     800681 <vprintfmt+0x1e5>
  8006c9:	ff 4d e0             	decl   -0x20(%ebp)
  8006cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d0:	79 af                	jns    800681 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d2:	eb 13                	jmp    8006e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	6a 20                	push   $0x20
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	ff d0                	call   *%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006eb:	7f e7                	jg     8006d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ed:	e9 78 01 00 00       	jmp    80086a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	e8 3c fd ff ff       	call   80043d <getint>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800707:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80070a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800710:	85 d2                	test   %edx,%edx
  800712:	79 23                	jns    800737 <vprintfmt+0x29b>
				putch('-', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 2d                	push   $0x2d
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072a:	f7 d8                	neg    %eax
  80072c:	83 d2 00             	adc    $0x0,%edx
  80072f:	f7 da                	neg    %edx
  800731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800734:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800737:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80073e:	e9 bc 00 00 00       	jmp    8007ff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 e8             	pushl  -0x18(%ebp)
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	e8 84 fc ff ff       	call   8003d6 <getuint>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800758:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80075b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800762:	e9 98 00 00 00       	jmp    8007ff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	6a 58                	push   $0x58
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	6a 58                	push   $0x58
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 58                	push   $0x58
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
			break;
  800797:	e9 ce 00 00 00       	jmp    80086a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 30                	push   $0x30
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 0c             	pushl  0xc(%ebp)
  8007b2:	6a 78                	push   $0x78
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	83 c0 04             	add    $0x4,%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007de:	eb 1f                	jmp    8007ff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	e8 e7 fb ff ff       	call   8003d6 <getuint>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	52                   	push   %edx
  80080a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80080d:	50                   	push   %eax
  80080e:	ff 75 f4             	pushl  -0xc(%ebp)
  800811:	ff 75 f0             	pushl  -0x10(%ebp)
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	ff 75 08             	pushl  0x8(%ebp)
  80081a:	e8 00 fb ff ff       	call   80031f <printnum>
  80081f:	83 c4 20             	add    $0x20,%esp
			break;
  800822:	eb 46                	jmp    80086a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	eb 35                	jmp    80086a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800835:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80083c:	eb 2c                	jmp    80086a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80083e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800845:	eb 23                	jmp    80086a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	6a 25                	push   $0x25
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800857:	ff 4d 10             	decl   0x10(%ebp)
  80085a:	eb 03                	jmp    80085f <vprintfmt+0x3c3>
  80085c:	ff 4d 10             	decl   0x10(%ebp)
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	48                   	dec    %eax
  800863:	8a 00                	mov    (%eax),%al
  800865:	3c 25                	cmp    $0x25,%al
  800867:	75 f3                	jne    80085c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800869:	90                   	nop
		}
	}
  80086a:	e9 35 fc ff ff       	jmp    8004a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80086f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800870:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800873:	5b                   	pop    %ebx
  800874:	5e                   	pop    %esi
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80087d:	8d 45 10             	lea    0x10(%ebp),%eax
  800880:	83 c0 04             	add    $0x4,%eax
  800883:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800886:	8b 45 10             	mov    0x10(%ebp),%eax
  800889:	ff 75 f4             	pushl  -0xc(%ebp)
  80088c:	50                   	push   %eax
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	ff 75 08             	pushl  0x8(%ebp)
  800893:	e8 04 fc ff ff       	call   80049c <vprintfmt>
  800898:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80089b:	90                   	nop
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a4:	8b 40 08             	mov    0x8(%eax),%eax
  8008a7:	8d 50 01             	lea    0x1(%eax),%edx
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	8b 10                	mov    (%eax),%edx
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 40 04             	mov    0x4(%eax),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	73 12                	jae    8008d1 <sprintputch+0x33>
		*b->buf++ = ch;
  8008bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	89 0a                	mov    %ecx,(%edx)
  8008cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008cf:	88 10                	mov    %dl,(%eax)
}
  8008d1:	90                   	nop
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    

008008d4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	01 d0                	add    %edx,%eax
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f9:	74 06                	je     800901 <vsnprintf+0x2d>
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	7f 07                	jg     800908 <vsnprintf+0x34>
		return -E_INVAL;
  800901:	b8 03 00 00 00       	mov    $0x3,%eax
  800906:	eb 20                	jmp    800928 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 9e 08 80 00       	push   $0x80089e
  800917:	e8 80 fb ff ff       	call   80049c <vprintfmt>
  80091c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80091f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800922:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800925:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800930:	8d 45 10             	lea    0x10(%ebp),%eax
  800933:	83 c0 04             	add    $0x4,%eax
  800936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	ff 75 f4             	pushl  -0xc(%ebp)
  80093f:	50                   	push   %eax
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	ff 75 08             	pushl  0x8(%ebp)
  800946:	e8 89 ff ff ff       	call   8008d4 <vsnprintf>
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800951:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    

00800956 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80095c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800963:	eb 06                	jmp    80096b <strlen+0x15>
		n++;
  800965:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800968:	ff 45 08             	incl   0x8(%ebp)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8a 00                	mov    (%eax),%al
  800970:	84 c0                	test   %al,%al
  800972:	75 f1                	jne    800965 <strlen+0xf>
		n++;
	return n;
  800974:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800986:	eb 09                	jmp    800991 <strnlen+0x18>
		n++;
  800988:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098b:	ff 45 08             	incl   0x8(%ebp)
  80098e:	ff 4d 0c             	decl   0xc(%ebp)
  800991:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800995:	74 09                	je     8009a0 <strnlen+0x27>
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8a 00                	mov    (%eax),%al
  80099c:	84 c0                	test   %al,%al
  80099e:	75 e8                	jne    800988 <strnlen+0xf>
		n++;
	return n;
  8009a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009b1:	90                   	nop
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8d 50 01             	lea    0x1(%eax),%edx
  8009b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c4:	8a 12                	mov    (%edx),%dl
  8009c6:	88 10                	mov    %dl,(%eax)
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	84 c0                	test   %al,%al
  8009cc:	75 e4                	jne    8009b2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e6:	eb 1f                	jmp    800a07 <strncpy+0x34>
		*dst++ = *src;
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	8a 12                	mov    (%edx),%dl
  8009f6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	8a 00                	mov    (%eax),%al
  8009fd:	84 c0                	test   %al,%al
  8009ff:	74 03                	je     800a04 <strncpy+0x31>
			src++;
  800a01:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a04:	ff 45 fc             	incl   -0x4(%ebp)
  800a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a0d:	72 d9                	jb     8009e8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a24:	74 30                	je     800a56 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a26:	eb 16                	jmp    800a3e <strlcpy+0x2a>
			*dst++ = *src++;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8d 50 01             	lea    0x1(%eax),%edx
  800a2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a34:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a37:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a3a:	8a 12                	mov    (%edx),%dl
  800a3c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a3e:	ff 4d 10             	decl   0x10(%ebp)
  800a41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a45:	74 09                	je     800a50 <strlcpy+0x3c>
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	75 d8                	jne    800a28 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a56:	8b 55 08             	mov    0x8(%ebp),%edx
  800a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a5c:	29 c2                	sub    %eax,%edx
  800a5e:	89 d0                	mov    %edx,%eax
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    

00800a62 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a65:	eb 06                	jmp    800a6d <strcmp+0xb>
		p++, q++;
  800a67:	ff 45 08             	incl   0x8(%ebp)
  800a6a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	74 0e                	je     800a84 <strcmp+0x22>
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8a 10                	mov    (%eax),%dl
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	38 c2                	cmp    %al,%dl
  800a82:	74 e3                	je     800a67 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8a 00                	mov    (%eax),%al
  800a89:	0f b6 d0             	movzbl %al,%edx
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f b6 c0             	movzbl %al,%eax
  800a94:	29 c2                	sub    %eax,%edx
  800a96:	89 d0                	mov    %edx,%eax
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a9d:	eb 09                	jmp    800aa8 <strncmp+0xe>
		n--, p++, q++;
  800a9f:	ff 4d 10             	decl   0x10(%ebp)
  800aa2:	ff 45 08             	incl   0x8(%ebp)
  800aa5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aac:	74 17                	je     800ac5 <strncmp+0x2b>
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	84 c0                	test   %al,%al
  800ab5:	74 0e                	je     800ac5 <strncmp+0x2b>
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8a 10                	mov    (%eax),%dl
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	38 c2                	cmp    %al,%dl
  800ac3:	74 da                	je     800a9f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ac5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac9:	75 07                	jne    800ad2 <strncmp+0x38>
		return 0;
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad0:	eb 14                	jmp    800ae6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8a 00                	mov    (%eax),%al
  800ad7:	0f b6 d0             	movzbl %al,%edx
  800ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  800add:	8a 00                	mov    (%eax),%al
  800adf:	0f b6 c0             	movzbl %al,%eax
  800ae2:	29 c2                	sub    %eax,%edx
  800ae4:	89 d0                	mov    %edx,%eax
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800af4:	eb 12                	jmp    800b08 <strchr+0x20>
		if (*s == c)
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800afe:	75 05                	jne    800b05 <strchr+0x1d>
			return (char *) s;
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	eb 11                	jmp    800b16 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b05:	ff 45 08             	incl   0x8(%ebp)
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	84 c0                	test   %al,%al
  800b0f:	75 e5                	jne    800af6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b24:	eb 0d                	jmp    800b33 <strfind+0x1b>
		if (*s == c)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b2e:	74 0e                	je     800b3e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b30:	ff 45 08             	incl   0x8(%ebp)
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	84 c0                	test   %al,%al
  800b3a:	75 ea                	jne    800b26 <strfind+0xe>
  800b3c:	eb 01                	jmp    800b3f <strfind+0x27>
		if (*s == c)
			break;
  800b3e:	90                   	nop
	return (char *) s;
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b50:	8b 45 10             	mov    0x10(%ebp),%eax
  800b53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b56:	eb 0e                	jmp    800b66 <memset+0x22>
		*p++ = c;
  800b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5b:	8d 50 01             	lea    0x1(%eax),%edx
  800b5e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b64:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b66:	ff 4d f8             	decl   -0x8(%ebp)
  800b69:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b6d:	79 e9                	jns    800b58 <memset+0x14>
		*p++ = c;

	return v;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b86:	eb 16                	jmp    800b9e <memcpy+0x2a>
		*d++ = *s++;
  800b88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b97:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b9a:	8a 12                	mov    (%edx),%dl
  800b9c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba7:	85 c0                	test   %eax,%eax
  800ba9:	75 dd                	jne    800b88 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc8:	73 50                	jae    800c1a <memmove+0x6a>
  800bca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	01 d0                	add    %edx,%eax
  800bd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd5:	76 43                	jbe    800c1a <memmove+0x6a>
		s += n;
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800be0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800be3:	eb 10                	jmp    800bf5 <memmove+0x45>
			*--d = *--s;
  800be5:	ff 4d f8             	decl   -0x8(%ebp)
  800be8:	ff 4d fc             	decl   -0x4(%ebp)
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bee:	8a 10                	mov    (%eax),%dl
  800bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	75 e3                	jne    800be5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c02:	eb 23                	jmp    800c27 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c07:	8d 50 01             	lea    0x1(%eax),%edx
  800c0a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c13:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c16:	8a 12                	mov    (%edx),%dl
  800c18:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c20:	89 55 10             	mov    %edx,0x10(%ebp)
  800c23:	85 c0                	test   %eax,%eax
  800c25:	75 dd                	jne    800c04 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c3e:	eb 2a                	jmp    800c6a <memcmp+0x3e>
		if (*s1 != *s2)
  800c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c43:	8a 10                	mov    (%eax),%dl
  800c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	38 c2                	cmp    %al,%dl
  800c4c:	74 16                	je     800c64 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	0f b6 d0             	movzbl %al,%edx
  800c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	0f b6 c0             	movzbl %al,%eax
  800c5e:	29 c2                	sub    %eax,%edx
  800c60:	89 d0                	mov    %edx,%eax
  800c62:	eb 18                	jmp    800c7c <memcmp+0x50>
		s1++, s2++;
  800c64:	ff 45 fc             	incl   -0x4(%ebp)
  800c67:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c70:	89 55 10             	mov    %edx,0x10(%ebp)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	75 c9                	jne    800c40 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	01 d0                	add    %edx,%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c8f:	eb 15                	jmp    800ca6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	0f b6 d0             	movzbl %al,%edx
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	0f b6 c0             	movzbl %al,%eax
  800c9f:	39 c2                	cmp    %eax,%edx
  800ca1:	74 0d                	je     800cb0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca3:	ff 45 08             	incl   0x8(%ebp)
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cac:	72 e3                	jb     800c91 <memfind+0x13>
  800cae:	eb 01                	jmp    800cb1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cb0:	90                   	nop
	return (void *) s;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    

00800cb6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cc3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cca:	eb 03                	jmp    800ccf <strtol+0x19>
		s++;
  800ccc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3c 20                	cmp    $0x20,%al
  800cd6:	74 f4                	je     800ccc <strtol+0x16>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	3c 09                	cmp    $0x9,%al
  800cdf:	74 eb                	je     800ccc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	3c 2b                	cmp    $0x2b,%al
  800ce8:	75 05                	jne    800cef <strtol+0x39>
		s++;
  800cea:	ff 45 08             	incl   0x8(%ebp)
  800ced:	eb 13                	jmp    800d02 <strtol+0x4c>
	else if (*s == '-')
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 2d                	cmp    $0x2d,%al
  800cf6:	75 0a                	jne    800d02 <strtol+0x4c>
		s++, neg = 1;
  800cf8:	ff 45 08             	incl   0x8(%ebp)
  800cfb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d06:	74 06                	je     800d0e <strtol+0x58>
  800d08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d0c:	75 20                	jne    800d2e <strtol+0x78>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 30                	cmp    $0x30,%al
  800d15:	75 17                	jne    800d2e <strtol+0x78>
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	40                   	inc    %eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	3c 78                	cmp    $0x78,%al
  800d1f:	75 0d                	jne    800d2e <strtol+0x78>
		s += 2, base = 16;
  800d21:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d25:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d2c:	eb 28                	jmp    800d56 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d32:	75 15                	jne    800d49 <strtol+0x93>
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3c 30                	cmp    $0x30,%al
  800d3b:	75 0c                	jne    800d49 <strtol+0x93>
		s++, base = 8;
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d47:	eb 0d                	jmp    800d56 <strtol+0xa0>
	else if (base == 0)
  800d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4d:	75 07                	jne    800d56 <strtol+0xa0>
		base = 10;
  800d4f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 2f                	cmp    $0x2f,%al
  800d5d:	7e 19                	jle    800d78 <strtol+0xc2>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 39                	cmp    $0x39,%al
  800d66:	7f 10                	jg     800d78 <strtol+0xc2>
			dig = *s - '0';
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f be c0             	movsbl %al,%eax
  800d70:	83 e8 30             	sub    $0x30,%eax
  800d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d76:	eb 42                	jmp    800dba <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 60                	cmp    $0x60,%al
  800d7f:	7e 19                	jle    800d9a <strtol+0xe4>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3c 7a                	cmp    $0x7a,%al
  800d88:	7f 10                	jg     800d9a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be c0             	movsbl %al,%eax
  800d92:	83 e8 57             	sub    $0x57,%eax
  800d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d98:	eb 20                	jmp    800dba <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 40                	cmp    $0x40,%al
  800da1:	7e 39                	jle    800ddc <strtol+0x126>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 5a                	cmp    $0x5a,%al
  800daa:	7f 30                	jg     800ddc <strtol+0x126>
			dig = *s - 'A' + 10;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f be c0             	movsbl %al,%eax
  800db4:	83 e8 37             	sub    $0x37,%eax
  800db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc0:	7d 19                	jge    800ddb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dcc:	89 c2                	mov    %eax,%edx
  800dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dd6:	e9 7b ff ff ff       	jmp    800d56 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ddb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ddc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de0:	74 08                	je     800dea <strtol+0x134>
		*endptr = (char *) s;
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dee:	74 07                	je     800df7 <strtol+0x141>
  800df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df3:	f7 d8                	neg    %eax
  800df5:	eb 03                	jmp    800dfa <strtol+0x144>
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <ltostr>:

void
ltostr(long value, char *str)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e14:	79 13                	jns    800e29 <ltostr+0x2d>
	{
		neg = 1;
  800e16:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e23:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e26:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e31:	99                   	cltd   
  800e32:	f7 f9                	idiv   %ecx
  800e34:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3a:	8d 50 01             	lea    0x1(%eax),%edx
  800e3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e4a:	83 c2 30             	add    $0x30,%edx
  800e4d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e52:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e57:	f7 e9                	imul   %ecx
  800e59:	c1 fa 02             	sar    $0x2,%edx
  800e5c:	89 c8                	mov    %ecx,%eax
  800e5e:	c1 f8 1f             	sar    $0x1f,%eax
  800e61:	29 c2                	sub    %eax,%edx
  800e63:	89 d0                	mov    %edx,%eax
  800e65:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e6c:	75 bb                	jne    800e29 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	48                   	dec    %eax
  800e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e80:	74 3d                	je     800ebf <ltostr+0xc3>
		start = 1 ;
  800e82:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e89:	eb 34                	jmp    800ebf <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	01 d0                	add    %edx,%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 c2                	add    %eax,%edx
  800ea0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	01 c8                	add    %ecx,%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	01 c2                	add    %eax,%edx
  800eb4:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eb7:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ebc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ec5:	7c c4                	jl     800e8b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ec7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed2:	90                   	nop
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800edb:	ff 75 08             	pushl  0x8(%ebp)
  800ede:	e8 73 fa ff ff       	call   800956 <strlen>
  800ee3:	83 c4 04             	add    $0x4,%esp
  800ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	e8 65 fa ff ff       	call   800956 <strlen>
  800ef1:	83 c4 04             	add    $0x4,%esp
  800ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f05:	eb 17                	jmp    800f1e <strcconcat+0x49>
		final[s] = str1[s] ;
  800f07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	01 c2                	add    %eax,%edx
  800f0f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	01 c8                	add    %ecx,%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f1b:	ff 45 fc             	incl   -0x4(%ebp)
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f24:	7c e1                	jl     800f07 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f26:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f34:	eb 1f                	jmp    800f55 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 c2                	add    %eax,%edx
  800f46:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	01 c8                	add    %ecx,%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f52:	ff 45 f8             	incl   -0x8(%ebp)
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5b:	7c d9                	jl     800f36 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	c6 00 00             	movb   $0x0,(%eax)
}
  800f68:	90                   	nop
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f77:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7a:	8b 00                	mov    (%eax),%eax
  800f7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	01 d0                	add    %edx,%eax
  800f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f8e:	eb 0c                	jmp    800f9c <strsplit+0x31>
			*string++ = 0;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8d 50 01             	lea    0x1(%eax),%edx
  800f96:	89 55 08             	mov    %edx,0x8(%ebp)
  800f99:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 18                	je     800fbd <strsplit+0x52>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f be c0             	movsbl %al,%eax
  800fad:	50                   	push   %eax
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	e8 32 fb ff ff       	call   800ae8 <strchr>
  800fb6:	83 c4 08             	add    $0x8,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	75 d3                	jne    800f90 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	84 c0                	test   %al,%al
  800fc4:	74 5a                	je     801020 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	8b 00                	mov    (%eax),%eax
  800fcb:	83 f8 0f             	cmp    $0xf,%eax
  800fce:	75 07                	jne    800fd7 <strsplit+0x6c>
		{
			return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd5:	eb 66                	jmp    80103d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fda:	8b 00                	mov    (%eax),%eax
  800fdc:	8d 48 01             	lea    0x1(%eax),%ecx
  800fdf:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe2:	89 0a                	mov    %ecx,(%edx)
  800fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	01 c2                	add    %eax,%edx
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff5:	eb 03                	jmp    800ffa <strsplit+0x8f>
			string++;
  800ff7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	74 8b                	je     800f8e <strsplit+0x23>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	50                   	push   %eax
  80100c:	ff 75 0c             	pushl  0xc(%ebp)
  80100f:	e8 d4 fa ff ff       	call   800ae8 <strchr>
  801014:	83 c4 08             	add    $0x8,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	74 dc                	je     800ff7 <strsplit+0x8c>
			string++;
	}
  80101b:	e9 6e ff ff ff       	jmp    800f8e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801020:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801021:	8b 45 14             	mov    0x14(%ebp),%eax
  801024:	8b 00                	mov    (%eax),%eax
  801026:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801038:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	68 68 1f 80 00       	push   $0x801f68
  80104d:	68 3f 01 00 00       	push   $0x13f
  801052:	68 8a 1f 80 00       	push   $0x801f8a
  801057:	e8 29 06 00 00       	call   801685 <_panic>

0080105c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	57                   	push   %edi
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
  801062:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80106e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801071:	8b 7d 18             	mov    0x18(%ebp),%edi
  801074:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801077:	cd 30                	int    $0x30
  801079:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 04             	sub    $0x4,%esp
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801093:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	52                   	push   %edx
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	50                   	push   %eax
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 b2 ff ff ff       	call   80105c <syscall>
  8010aa:	83 c4 18             	add    $0x18,%esp
}
  8010ad:	90                   	nop
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 00                	push   $0x0
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 02                	push   $0x2
  8010bf:	e8 98 ff ff ff       	call   80105c <syscall>
  8010c4:	83 c4 18             	add    $0x18,%esp
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 00                	push   $0x0
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 03                	push   $0x3
  8010d8:	e8 7f ff ff ff       	call   80105c <syscall>
  8010dd:	83 c4 18             	add    $0x18,%esp
}
  8010e0:	90                   	nop
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010e6:	6a 00                	push   $0x0
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	6a 00                	push   $0x0
  8010f0:	6a 04                	push   $0x4
  8010f2:	e8 65 ff ff ff       	call   80105c <syscall>
  8010f7:	83 c4 18             	add    $0x18,%esp
}
  8010fa:	90                   	nop
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801100:	8b 55 0c             	mov    0xc(%ebp),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	52                   	push   %edx
  80110d:	50                   	push   %eax
  80110e:	6a 08                	push   $0x8
  801110:	e8 47 ff ff ff       	call   80105c <syscall>
  801115:	83 c4 18             	add    $0x18,%esp
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80111f:	8b 75 18             	mov    0x18(%ebp),%esi
  801122:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801125:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	51                   	push   %ecx
  801131:	52                   	push   %edx
  801132:	50                   	push   %eax
  801133:	6a 09                	push   $0x9
  801135:	e8 22 ff ff ff       	call   80105c <syscall>
  80113a:	83 c4 18             	add    $0x18,%esp
}
  80113d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5d                   	pop    %ebp
  801143:	c3                   	ret    

00801144 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	52                   	push   %edx
  801154:	50                   	push   %eax
  801155:	6a 0a                	push   $0xa
  801157:	e8 00 ff ff ff       	call   80105c <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	ff 75 08             	pushl  0x8(%ebp)
  801170:	6a 0b                	push   $0xb
  801172:	e8 e5 fe ff ff       	call   80105c <syscall>
  801177:	83 c4 18             	add    $0x18,%esp
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 0c                	push   $0xc
  80118b:	e8 cc fe ff ff       	call   80105c <syscall>
  801190:	83 c4 18             	add    $0x18,%esp
}
  801193:	c9                   	leave  
  801194:	c3                   	ret    

00801195 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 0d                	push   $0xd
  8011a4:	e8 b3 fe ff ff       	call   80105c <syscall>
  8011a9:	83 c4 18             	add    $0x18,%esp
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 0e                	push   $0xe
  8011bd:	e8 9a fe ff ff       	call   80105c <syscall>
  8011c2:	83 c4 18             	add    $0x18,%esp
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 0f                	push   $0xf
  8011d6:	e8 81 fe ff ff       	call   80105c <syscall>
  8011db:	83 c4 18             	add    $0x18,%esp
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	ff 75 08             	pushl  0x8(%ebp)
  8011ee:	6a 10                	push   $0x10
  8011f0:	e8 67 fe ff ff       	call   80105c <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 11                	push   $0x11
  801209:	e8 4e fe ff ff       	call   80105c <syscall>
  80120e:	83 c4 18             	add    $0x18,%esp
}
  801211:	90                   	nop
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <sys_cputc>:

void
sys_cputc(const char c)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801220:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	6a 00                	push   $0x0
  80122c:	50                   	push   %eax
  80122d:	6a 01                	push   $0x1
  80122f:	e8 28 fe ff ff       	call   80105c <syscall>
  801234:	83 c4 18             	add    $0x18,%esp
}
  801237:	90                   	nop
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 14                	push   $0x14
  801249:	e8 0e fe ff ff       	call   80105c <syscall>
  80124e:	83 c4 18             	add    $0x18,%esp
}
  801251:	90                   	nop
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801260:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801263:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	6a 00                	push   $0x0
  80126c:	51                   	push   %ecx
  80126d:	52                   	push   %edx
  80126e:	ff 75 0c             	pushl  0xc(%ebp)
  801271:	50                   	push   %eax
  801272:	6a 15                	push   $0x15
  801274:	e8 e3 fd ff ff       	call   80105c <syscall>
  801279:	83 c4 18             	add    $0x18,%esp
}
  80127c:	c9                   	leave  
  80127d:	c3                   	ret    

0080127e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801281:	8b 55 0c             	mov    0xc(%ebp),%edx
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	6a 00                	push   $0x0
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	52                   	push   %edx
  80128e:	50                   	push   %eax
  80128f:	6a 16                	push   $0x16
  801291:	e8 c6 fd ff ff       	call   80105c <syscall>
  801296:	83 c4 18             	add    $0x18,%esp
}
  801299:	c9                   	leave  
  80129a:	c3                   	ret    

0080129b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80129e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	51                   	push   %ecx
  8012ac:	52                   	push   %edx
  8012ad:	50                   	push   %eax
  8012ae:	6a 17                	push   $0x17
  8012b0:	e8 a7 fd ff ff       	call   80105c <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	52                   	push   %edx
  8012ca:	50                   	push   %eax
  8012cb:	6a 18                	push   $0x18
  8012cd:	e8 8a fd ff ff       	call   80105c <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	6a 00                	push   $0x0
  8012df:	ff 75 14             	pushl  0x14(%ebp)
  8012e2:	ff 75 10             	pushl  0x10(%ebp)
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	50                   	push   %eax
  8012e9:	6a 19                	push   $0x19
  8012eb:	e8 6c fd ff ff       	call   80105c <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	50                   	push   %eax
  801304:	6a 1a                	push   $0x1a
  801306:	e8 51 fd ff ff       	call   80105c <syscall>
  80130b:	83 c4 18             	add    $0x18,%esp
}
  80130e:	90                   	nop
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	50                   	push   %eax
  801320:	6a 1b                	push   $0x1b
  801322:	e8 35 fd ff ff       	call   80105c <syscall>
  801327:	83 c4 18             	add    $0x18,%esp
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 05                	push   $0x5
  80133b:	e8 1c fd ff ff       	call   80105c <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 06                	push   $0x6
  801354:	e8 03 fd ff ff       	call   80105c <syscall>
  801359:	83 c4 18             	add    $0x18,%esp
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 07                	push   $0x7
  80136d:	e8 ea fc ff ff       	call   80105c <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_exit_env>:


void sys_exit_env(void)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 1c                	push   $0x1c
  801386:	e8 d1 fc ff ff       	call   80105c <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	90                   	nop
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801397:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80139a:	8d 50 04             	lea    0x4(%eax),%edx
  80139d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	52                   	push   %edx
  8013a7:	50                   	push   %eax
  8013a8:	6a 1d                	push   $0x1d
  8013aa:	e8 ad fc ff ff       	call   80105c <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
	return result;
  8013b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013bb:	89 01                	mov    %eax,(%ecx)
  8013bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	c9                   	leave  
  8013c4:	c2 04 00             	ret    $0x4

008013c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	ff 75 10             	pushl  0x10(%ebp)
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	ff 75 08             	pushl  0x8(%ebp)
  8013d7:	6a 13                	push   $0x13
  8013d9:	e8 7e fc ff ff       	call   80105c <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
	return ;
  8013e1:	90                   	nop
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 1e                	push   $0x1e
  8013f3:	e8 64 fc ff ff       	call   80105c <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801409:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	50                   	push   %eax
  801416:	6a 1f                	push   $0x1f
  801418:	e8 3f fc ff ff       	call   80105c <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
	return ;
  801420:	90                   	nop
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <rsttst>:
void rsttst()
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 21                	push   $0x21
  801432:	e8 25 fc ff ff       	call   80105c <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
	return ;
  80143a:	90                   	nop
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801449:	8b 55 18             	mov    0x18(%ebp),%edx
  80144c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801450:	52                   	push   %edx
  801451:	50                   	push   %eax
  801452:	ff 75 10             	pushl  0x10(%ebp)
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	6a 20                	push   $0x20
  80145d:	e8 fa fb ff ff       	call   80105c <syscall>
  801462:	83 c4 18             	add    $0x18,%esp
	return ;
  801465:	90                   	nop
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <chktst>:
void chktst(uint32 n)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	ff 75 08             	pushl  0x8(%ebp)
  801476:	6a 22                	push   $0x22
  801478:	e8 df fb ff ff       	call   80105c <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
	return ;
  801480:	90                   	nop
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <inctst>:

void inctst()
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 23                	push   $0x23
  801492:	e8 c5 fb ff ff       	call   80105c <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
	return ;
  80149a:	90                   	nop
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <gettst>:
uint32 gettst()
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 24                	push   $0x24
  8014ac:	e8 ab fb ff ff       	call   80105c <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 25                	push   $0x25
  8014c8:	e8 8f fb ff ff       	call   80105c <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
  8014d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014d3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014d7:	75 07                	jne    8014e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014de:	eb 05                	jmp    8014e5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 25                	push   $0x25
  8014f9:	e8 5e fb ff ff       	call   80105c <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
  801501:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801504:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801508:	75 07                	jne    801511 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80150a:	b8 01 00 00 00       	mov    $0x1,%eax
  80150f:	eb 05                	jmp    801516 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 25                	push   $0x25
  80152a:	e8 2d fb ff ff       	call   80105c <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
  801532:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801535:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801539:	75 07                	jne    801542 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80153b:	b8 01 00 00 00       	mov    $0x1,%eax
  801540:	eb 05                	jmp    801547 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 25                	push   $0x25
  80155b:	e8 fc fa ff ff       	call   80105c <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
  801563:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801566:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80156a:	75 07                	jne    801573 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80156c:	b8 01 00 00 00       	mov    $0x1,%eax
  801571:	eb 05                	jmp    801578 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	6a 26                	push   $0x26
  80158a:	e8 cd fa ff ff       	call   80105c <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
	return ;
  801592:	90                   	nop
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801599:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	6a 00                	push   $0x0
  8015a7:	53                   	push   %ebx
  8015a8:	51                   	push   %ecx
  8015a9:	52                   	push   %edx
  8015aa:	50                   	push   %eax
  8015ab:	6a 27                	push   $0x27
  8015ad:	e8 aa fa ff ff       	call   80105c <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
}
  8015b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	52                   	push   %edx
  8015ca:	50                   	push   %eax
  8015cb:	6a 28                	push   $0x28
  8015cd:	e8 8a fa ff ff       	call   80105c <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	51                   	push   %ecx
  8015e6:	ff 75 10             	pushl  0x10(%ebp)
  8015e9:	52                   	push   %edx
  8015ea:	50                   	push   %eax
  8015eb:	6a 29                	push   $0x29
  8015ed:	e8 6a fa ff ff       	call   80105c <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	ff 75 10             	pushl  0x10(%ebp)
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	6a 12                	push   $0x12
  801609:	e8 4e fa ff ff       	call   80105c <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return ;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 2a                	push   $0x2a
  801627:	e8 30 fa ff ff       	call   80105c <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
	return;
  80162f:	90                   	nop
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	50                   	push   %eax
  801641:	6a 2b                	push   $0x2b
  801643:	e8 14 fa ff ff       	call   80105c <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	6a 2c                	push   $0x2c
  80165e:	e8 f9 f9 ff ff       	call   80105c <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	6a 2d                	push   $0x2d
  80167a:	e8 dd f9 ff ff       	call   80105c <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
	return;
  801682:	90                   	nop
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80168b:	8d 45 10             	lea    0x10(%ebp),%eax
  80168e:	83 c0 04             	add    $0x4,%eax
  801691:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801694:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801699:	85 c0                	test   %eax,%eax
  80169b:	74 16                	je     8016b3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80169d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	50                   	push   %eax
  8016a6:	68 98 1f 80 00       	push   $0x801f98
  8016ab:	e8 12 ec ff ff       	call   8002c2 <cprintf>
  8016b0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016b3:	a1 00 30 80 00       	mov    0x803000,%eax
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	50                   	push   %eax
  8016bf:	68 9d 1f 80 00       	push   $0x801f9d
  8016c4:	e8 f9 eb ff ff       	call   8002c2 <cprintf>
  8016c9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d5:	50                   	push   %eax
  8016d6:	e8 7c eb ff ff       	call   800257 <vcprintf>
  8016db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	6a 00                	push   $0x0
  8016e3:	68 b9 1f 80 00       	push   $0x801fb9
  8016e8:	e8 6a eb ff ff       	call   800257 <vcprintf>
  8016ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016f0:	e8 eb ea ff ff       	call   8001e0 <exit>

	// should not return here
	while (1) ;
  8016f5:	eb fe                	jmp    8016f5 <_panic+0x70>

008016f7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016fd:	a1 04 30 80 00       	mov    0x803004,%eax
  801702:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	39 c2                	cmp    %eax,%edx
  80170d:	74 14                	je     801723 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 bc 1f 80 00       	push   $0x801fbc
  801717:	6a 26                	push   $0x26
  801719:	68 08 20 80 00       	push   $0x802008
  80171e:	e8 62 ff ff ff       	call   801685 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801723:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80172a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801731:	e9 c5 00 00 00       	jmp    8017fb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	01 d0                	add    %edx,%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	85 c0                	test   %eax,%eax
  801749:	75 08                	jne    801753 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80174b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80174e:	e9 a5 00 00 00       	jmp    8017f8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80175a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801761:	eb 69                	jmp    8017cc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801763:	a1 04 30 80 00       	mov    0x803004,%eax
  801768:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80176e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801771:	89 d0                	mov    %edx,%eax
  801773:	01 c0                	add    %eax,%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	c1 e0 03             	shl    $0x3,%eax
  80177a:	01 c8                	add    %ecx,%eax
  80177c:	8a 40 04             	mov    0x4(%eax),%al
  80177f:	84 c0                	test   %al,%al
  801781:	75 46                	jne    8017c9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801783:	a1 04 30 80 00       	mov    0x803004,%eax
  801788:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80178e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801791:	89 d0                	mov    %edx,%eax
  801793:	01 c0                	add    %eax,%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	c1 e0 03             	shl    $0x3,%eax
  80179a:	01 c8                	add    %ecx,%eax
  80179c:	8b 00                	mov    (%eax),%eax
  80179e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	01 c8                	add    %ecx,%eax
  8017ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017bc:	39 c2                	cmp    %eax,%edx
  8017be:	75 09                	jne    8017c9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017c7:	eb 15                	jmp    8017de <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017c9:	ff 45 e8             	incl   -0x18(%ebp)
  8017cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8017d1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017da:	39 c2                	cmp    %eax,%edx
  8017dc:	77 85                	ja     801763 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e2:	75 14                	jne    8017f8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 14 20 80 00       	push   $0x802014
  8017ec:	6a 3a                	push   $0x3a
  8017ee:	68 08 20 80 00       	push   $0x802008
  8017f3:	e8 8d fe ff ff       	call   801685 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8017f8:	ff 45 f0             	incl   -0x10(%ebp)
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801801:	0f 8c 2f ff ff ff    	jl     801736 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801807:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80180e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801815:	eb 26                	jmp    80183d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801817:	a1 04 30 80 00       	mov    0x803004,%eax
  80181c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801822:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801825:	89 d0                	mov    %edx,%eax
  801827:	01 c0                	add    %eax,%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	c1 e0 03             	shl    $0x3,%eax
  80182e:	01 c8                	add    %ecx,%eax
  801830:	8a 40 04             	mov    0x4(%eax),%al
  801833:	3c 01                	cmp    $0x1,%al
  801835:	75 03                	jne    80183a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801837:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80183a:	ff 45 e0             	incl   -0x20(%ebp)
  80183d:	a1 04 30 80 00       	mov    0x803004,%eax
  801842:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184b:	39 c2                	cmp    %eax,%edx
  80184d:	77 c8                	ja     801817 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801855:	74 14                	je     80186b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	68 68 20 80 00       	push   $0x802068
  80185f:	6a 44                	push   $0x44
  801861:	68 08 20 80 00       	push   $0x802008
  801866:	e8 1a fe ff ff       	call   801685 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    
  80186e:	66 90                	xchg   %ax,%ax

00801870 <__udivdi3>:
  801870:	55                   	push   %ebp
  801871:	57                   	push   %edi
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 1c             	sub    $0x1c,%esp
  801877:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80187b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80187f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801883:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801887:	89 ca                	mov    %ecx,%edx
  801889:	89 f8                	mov    %edi,%eax
  80188b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80188f:	85 f6                	test   %esi,%esi
  801891:	75 2d                	jne    8018c0 <__udivdi3+0x50>
  801893:	39 cf                	cmp    %ecx,%edi
  801895:	77 65                	ja     8018fc <__udivdi3+0x8c>
  801897:	89 fd                	mov    %edi,%ebp
  801899:	85 ff                	test   %edi,%edi
  80189b:	75 0b                	jne    8018a8 <__udivdi3+0x38>
  80189d:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a2:	31 d2                	xor    %edx,%edx
  8018a4:	f7 f7                	div    %edi
  8018a6:	89 c5                	mov    %eax,%ebp
  8018a8:	31 d2                	xor    %edx,%edx
  8018aa:	89 c8                	mov    %ecx,%eax
  8018ac:	f7 f5                	div    %ebp
  8018ae:	89 c1                	mov    %eax,%ecx
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	f7 f5                	div    %ebp
  8018b4:	89 cf                	mov    %ecx,%edi
  8018b6:	89 fa                	mov    %edi,%edx
  8018b8:	83 c4 1c             	add    $0x1c,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
  8018c0:	39 ce                	cmp    %ecx,%esi
  8018c2:	77 28                	ja     8018ec <__udivdi3+0x7c>
  8018c4:	0f bd fe             	bsr    %esi,%edi
  8018c7:	83 f7 1f             	xor    $0x1f,%edi
  8018ca:	75 40                	jne    80190c <__udivdi3+0x9c>
  8018cc:	39 ce                	cmp    %ecx,%esi
  8018ce:	72 0a                	jb     8018da <__udivdi3+0x6a>
  8018d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018d4:	0f 87 9e 00 00 00    	ja     801978 <__udivdi3+0x108>
  8018da:	b8 01 00 00 00       	mov    $0x1,%eax
  8018df:	89 fa                	mov    %edi,%edx
  8018e1:	83 c4 1c             	add    $0x1c,%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5f                   	pop    %edi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    
  8018e9:	8d 76 00             	lea    0x0(%esi),%esi
  8018ec:	31 ff                	xor    %edi,%edi
  8018ee:	31 c0                	xor    %eax,%eax
  8018f0:	89 fa                	mov    %edi,%edx
  8018f2:	83 c4 1c             	add    $0x1c,%esp
  8018f5:	5b                   	pop    %ebx
  8018f6:	5e                   	pop    %esi
  8018f7:	5f                   	pop    %edi
  8018f8:	5d                   	pop    %ebp
  8018f9:	c3                   	ret    
  8018fa:	66 90                	xchg   %ax,%ax
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	f7 f7                	div    %edi
  801900:	31 ff                	xor    %edi,%edi
  801902:	89 fa                	mov    %edi,%edx
  801904:	83 c4 1c             	add    $0x1c,%esp
  801907:	5b                   	pop    %ebx
  801908:	5e                   	pop    %esi
  801909:	5f                   	pop    %edi
  80190a:	5d                   	pop    %ebp
  80190b:	c3                   	ret    
  80190c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801911:	89 eb                	mov    %ebp,%ebx
  801913:	29 fb                	sub    %edi,%ebx
  801915:	89 f9                	mov    %edi,%ecx
  801917:	d3 e6                	shl    %cl,%esi
  801919:	89 c5                	mov    %eax,%ebp
  80191b:	88 d9                	mov    %bl,%cl
  80191d:	d3 ed                	shr    %cl,%ebp
  80191f:	89 e9                	mov    %ebp,%ecx
  801921:	09 f1                	or     %esi,%ecx
  801923:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801927:	89 f9                	mov    %edi,%ecx
  801929:	d3 e0                	shl    %cl,%eax
  80192b:	89 c5                	mov    %eax,%ebp
  80192d:	89 d6                	mov    %edx,%esi
  80192f:	88 d9                	mov    %bl,%cl
  801931:	d3 ee                	shr    %cl,%esi
  801933:	89 f9                	mov    %edi,%ecx
  801935:	d3 e2                	shl    %cl,%edx
  801937:	8b 44 24 08          	mov    0x8(%esp),%eax
  80193b:	88 d9                	mov    %bl,%cl
  80193d:	d3 e8                	shr    %cl,%eax
  80193f:	09 c2                	or     %eax,%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	89 f2                	mov    %esi,%edx
  801945:	f7 74 24 0c          	divl   0xc(%esp)
  801949:	89 d6                	mov    %edx,%esi
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	f7 e5                	mul    %ebp
  80194f:	39 d6                	cmp    %edx,%esi
  801951:	72 19                	jb     80196c <__udivdi3+0xfc>
  801953:	74 0b                	je     801960 <__udivdi3+0xf0>
  801955:	89 d8                	mov    %ebx,%eax
  801957:	31 ff                	xor    %edi,%edi
  801959:	e9 58 ff ff ff       	jmp    8018b6 <__udivdi3+0x46>
  80195e:	66 90                	xchg   %ax,%ax
  801960:	8b 54 24 08          	mov    0x8(%esp),%edx
  801964:	89 f9                	mov    %edi,%ecx
  801966:	d3 e2                	shl    %cl,%edx
  801968:	39 c2                	cmp    %eax,%edx
  80196a:	73 e9                	jae    801955 <__udivdi3+0xe5>
  80196c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80196f:	31 ff                	xor    %edi,%edi
  801971:	e9 40 ff ff ff       	jmp    8018b6 <__udivdi3+0x46>
  801976:	66 90                	xchg   %ax,%ax
  801978:	31 c0                	xor    %eax,%eax
  80197a:	e9 37 ff ff ff       	jmp    8018b6 <__udivdi3+0x46>
  80197f:	90                   	nop

00801980 <__umoddi3>:
  801980:	55                   	push   %ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80198b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80198f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801993:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801997:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80199b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80199f:	89 f3                	mov    %esi,%ebx
  8019a1:	89 fa                	mov    %edi,%edx
  8019a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019a7:	89 34 24             	mov    %esi,(%esp)
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	75 1a                	jne    8019c8 <__umoddi3+0x48>
  8019ae:	39 f7                	cmp    %esi,%edi
  8019b0:	0f 86 a2 00 00 00    	jbe    801a58 <__umoddi3+0xd8>
  8019b6:	89 c8                	mov    %ecx,%eax
  8019b8:	89 f2                	mov    %esi,%edx
  8019ba:	f7 f7                	div    %edi
  8019bc:	89 d0                	mov    %edx,%eax
  8019be:	31 d2                	xor    %edx,%edx
  8019c0:	83 c4 1c             	add    $0x1c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
  8019c8:	39 f0                	cmp    %esi,%eax
  8019ca:	0f 87 ac 00 00 00    	ja     801a7c <__umoddi3+0xfc>
  8019d0:	0f bd e8             	bsr    %eax,%ebp
  8019d3:	83 f5 1f             	xor    $0x1f,%ebp
  8019d6:	0f 84 ac 00 00 00    	je     801a88 <__umoddi3+0x108>
  8019dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8019e1:	29 ef                	sub    %ebp,%edi
  8019e3:	89 fe                	mov    %edi,%esi
  8019e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019e9:	89 e9                	mov    %ebp,%ecx
  8019eb:	d3 e0                	shl    %cl,%eax
  8019ed:	89 d7                	mov    %edx,%edi
  8019ef:	89 f1                	mov    %esi,%ecx
  8019f1:	d3 ef                	shr    %cl,%edi
  8019f3:	09 c7                	or     %eax,%edi
  8019f5:	89 e9                	mov    %ebp,%ecx
  8019f7:	d3 e2                	shl    %cl,%edx
  8019f9:	89 14 24             	mov    %edx,(%esp)
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	d3 e0                	shl    %cl,%eax
  801a00:	89 c2                	mov    %eax,%edx
  801a02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a06:	d3 e0                	shl    %cl,%eax
  801a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a10:	89 f1                	mov    %esi,%ecx
  801a12:	d3 e8                	shr    %cl,%eax
  801a14:	09 d0                	or     %edx,%eax
  801a16:	d3 eb                	shr    %cl,%ebx
  801a18:	89 da                	mov    %ebx,%edx
  801a1a:	f7 f7                	div    %edi
  801a1c:	89 d3                	mov    %edx,%ebx
  801a1e:	f7 24 24             	mull   (%esp)
  801a21:	89 c6                	mov    %eax,%esi
  801a23:	89 d1                	mov    %edx,%ecx
  801a25:	39 d3                	cmp    %edx,%ebx
  801a27:	0f 82 87 00 00 00    	jb     801ab4 <__umoddi3+0x134>
  801a2d:	0f 84 91 00 00 00    	je     801ac4 <__umoddi3+0x144>
  801a33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a37:	29 f2                	sub    %esi,%edx
  801a39:	19 cb                	sbb    %ecx,%ebx
  801a3b:	89 d8                	mov    %ebx,%eax
  801a3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a41:	d3 e0                	shl    %cl,%eax
  801a43:	89 e9                	mov    %ebp,%ecx
  801a45:	d3 ea                	shr    %cl,%edx
  801a47:	09 d0                	or     %edx,%eax
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 eb                	shr    %cl,%ebx
  801a4d:	89 da                	mov    %ebx,%edx
  801a4f:	83 c4 1c             	add    $0x1c,%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5f                   	pop    %edi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
  801a57:	90                   	nop
  801a58:	89 fd                	mov    %edi,%ebp
  801a5a:	85 ff                	test   %edi,%edi
  801a5c:	75 0b                	jne    801a69 <__umoddi3+0xe9>
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a63:	31 d2                	xor    %edx,%edx
  801a65:	f7 f7                	div    %edi
  801a67:	89 c5                	mov    %eax,%ebp
  801a69:	89 f0                	mov    %esi,%eax
  801a6b:	31 d2                	xor    %edx,%edx
  801a6d:	f7 f5                	div    %ebp
  801a6f:	89 c8                	mov    %ecx,%eax
  801a71:	f7 f5                	div    %ebp
  801a73:	89 d0                	mov    %edx,%eax
  801a75:	e9 44 ff ff ff       	jmp    8019be <__umoddi3+0x3e>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	89 c8                	mov    %ecx,%eax
  801a7e:	89 f2                	mov    %esi,%edx
  801a80:	83 c4 1c             	add    $0x1c,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
  801a88:	3b 04 24             	cmp    (%esp),%eax
  801a8b:	72 06                	jb     801a93 <__umoddi3+0x113>
  801a8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a91:	77 0f                	ja     801aa2 <__umoddi3+0x122>
  801a93:	89 f2                	mov    %esi,%edx
  801a95:	29 f9                	sub    %edi,%ecx
  801a97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a9b:	89 14 24             	mov    %edx,(%esp)
  801a9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801aa6:	8b 14 24             	mov    (%esp),%edx
  801aa9:	83 c4 1c             	add    $0x1c,%esp
  801aac:	5b                   	pop    %ebx
  801aad:	5e                   	pop    %esi
  801aae:	5f                   	pop    %edi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    
  801ab1:	8d 76 00             	lea    0x0(%esi),%esi
  801ab4:	2b 04 24             	sub    (%esp),%eax
  801ab7:	19 fa                	sbb    %edi,%edx
  801ab9:	89 d1                	mov    %edx,%ecx
  801abb:	89 c6                	mov    %eax,%esi
  801abd:	e9 71 ff ff ff       	jmp    801a33 <__umoddi3+0xb3>
  801ac2:	66 90                	xchg   %ax,%ax
  801ac4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ac8:	72 ea                	jb     801ab4 <__umoddi3+0x134>
  801aca:	89 d9                	mov    %ebx,%ecx
  801acc:	e9 62 ff ff ff       	jmp    801a33 <__umoddi3+0xb3>
