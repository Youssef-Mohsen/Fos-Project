
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
  800056:	68 00 1b 80 00       	push   $0x801b00
  80005b:	e8 70 02 00 00       	call   8002d0 <cprintf>
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
  80008d:	68 03 1b 80 00       	push   $0x801b03
  800092:	e8 39 02 00 00       	call   8002d0 <cprintf>
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
  8000b5:	e8 99 12 00 00       	call   801353 <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	c1 e0 06             	shl    $0x6,%eax
  8000c5:	29 d0                	sub    %edx,%eax
  8000c7:	c1 e0 02             	shl    $0x2,%eax
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000d3:	01 c8                	add    %ecx,%eax
  8000d5:	c1 e0 03             	shl    $0x3,%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000e1:	29 c2                	sub    %eax,%edx
  8000e3:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000ea:	89 c2                	mov    %eax,%edx
  8000ec:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000f2:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fc:	8a 40 20             	mov    0x20(%eax),%al
  8000ff:	84 c0                	test   %al,%al
  800101:	74 0d                	je     800110 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800103:	a1 04 30 80 00       	mov    0x803004,%eax
  800108:	83 c0 20             	add    $0x20,%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800114:	7e 0a                	jle    800120 <libmain+0x71>
		binaryname = argv[0];
  800116:	8b 45 0c             	mov    0xc(%ebp),%eax
  800119:	8b 00                	mov    (%eax),%eax
  80011b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	e8 0a ff ff ff       	call   800038 <_main>
  80012e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800131:	e8 a1 0f 00 00       	call   8010d7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 20 1b 80 00       	push   $0x801b20
  80013e:	e8 8d 01 00 00       	call   8002d0 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800146:	a1 04 30 80 00       	mov    0x803004,%eax
  80014b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800151:	a1 04 30 80 00       	mov    0x803004,%eax
  800156:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	68 48 1b 80 00       	push   $0x801b48
  800166:	e8 65 01 00 00       	call   8002d0 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016e:	a1 04 30 80 00       	mov    0x803004,%eax
  800173:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800179:	a1 04 30 80 00       	mov    0x803004,%eax
  80017e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800184:	a1 04 30 80 00       	mov    0x803004,%eax
  800189:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80018f:	51                   	push   %ecx
  800190:	52                   	push   %edx
  800191:	50                   	push   %eax
  800192:	68 70 1b 80 00       	push   $0x801b70
  800197:	e8 34 01 00 00       	call   8002d0 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019f:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a4:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 c8 1b 80 00       	push   $0x801bc8
  8001b3:	e8 18 01 00 00       	call   8002d0 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 20 1b 80 00       	push   $0x801b20
  8001c3:	e8 08 01 00 00       	call   8002d0 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001cb:	e8 21 0f 00 00       	call   8010f1 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001d0:	e8 19 00 00 00       	call   8001ee <exit>
}
  8001d5:	90                   	nop
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	6a 00                	push   $0x0
  8001e3:	e8 37 11 00 00       	call   80131f <sys_destroy_env>
  8001e8:	83 c4 10             	add    $0x10,%esp
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <exit>:

void
exit(void)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f4:	e8 8c 11 00 00       	call   801385 <sys_exit_env>
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	8d 48 01             	lea    0x1(%eax),%ecx
  80020a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020d:	89 0a                	mov    %ecx,(%edx)
  80020f:	8b 55 08             	mov    0x8(%ebp),%edx
  800212:	88 d1                	mov    %dl,%cl
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021e:	8b 00                	mov    (%eax),%eax
  800220:	3d ff 00 00 00       	cmp    $0xff,%eax
  800225:	75 2c                	jne    800253 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800227:	a0 08 30 80 00       	mov    0x803008,%al
  80022c:	0f b6 c0             	movzbl %al,%eax
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	8b 12                	mov    (%edx),%edx
  800234:	89 d1                	mov    %edx,%ecx
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	83 c2 08             	add    $0x8,%edx
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	50                   	push   %eax
  800240:	51                   	push   %ecx
  800241:	52                   	push   %edx
  800242:	e8 4e 0e 00 00       	call   801095 <sys_cputs>
  800247:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80024a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800253:	8b 45 0c             	mov    0xc(%ebp),%eax
  800256:	8b 40 04             	mov    0x4(%eax),%eax
  800259:	8d 50 01             	lea    0x1(%eax),%edx
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800262:	90                   	nop
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800275:	00 00 00 
	b.cnt = 0;
  800278:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	68 fc 01 80 00       	push   $0x8001fc
  800294:	e8 11 02 00 00       	call   8004aa <vprintfmt>
  800299:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80029c:	a0 08 30 80 00       	mov    0x803008,%al
  8002a1:	0f b6 c0             	movzbl %al,%eax
  8002a4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	50                   	push   %eax
  8002ae:	52                   	push   %edx
  8002af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b5:	83 c0 08             	add    $0x8,%eax
  8002b8:	50                   	push   %eax
  8002b9:	e8 d7 0d 00 00       	call   801095 <sys_cputs>
  8002be:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002c1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002d6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	83 ec 08             	sub    $0x8,%esp
  8002e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ec:	50                   	push   %eax
  8002ed:	e8 73 ff ff ff       	call   800265 <vcprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800303:	e8 cf 0d 00 00       	call   8010d7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800308:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 f4             	pushl  -0xc(%ebp)
  800317:	50                   	push   %eax
  800318:	e8 48 ff ff ff       	call   800265 <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800323:	e8 c9 0d 00 00       	call   8010f1 <sys_unlock_cons>
	return cnt;
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	53                   	push   %ebx
  800331:	83 ec 14             	sub    $0x14,%esp
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80033a:	8b 45 14             	mov    0x14(%ebp),%eax
  80033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800340:	8b 45 18             	mov    0x18(%ebp),%eax
  800343:	ba 00 00 00 00       	mov    $0x0,%edx
  800348:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034b:	77 55                	ja     8003a2 <printnum+0x75>
  80034d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800350:	72 05                	jb     800357 <printnum+0x2a>
  800352:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800355:	77 4b                	ja     8003a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800357:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80035a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035d:	8b 45 18             	mov    0x18(%ebp),%eax
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	52                   	push   %edx
  800366:	50                   	push   %eax
  800367:	ff 75 f4             	pushl  -0xc(%ebp)
  80036a:	ff 75 f0             	pushl  -0x10(%ebp)
  80036d:	e8 0e 15 00 00       	call   801880 <__udivdi3>
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	ff 75 20             	pushl  0x20(%ebp)
  80037b:	53                   	push   %ebx
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 a1 ff ff ff       	call   80032d <printnum>
  80038c:	83 c4 20             	add    $0x20,%esp
  80038f:	eb 1a                	jmp    8003ab <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 20             	pushl  0x20(%ebp)
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	ff d0                	call   *%eax
  80039f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a2:	ff 4d 1c             	decl   0x1c(%ebp)
  8003a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a9:	7f e6                	jg     800391 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b9:	53                   	push   %ebx
  8003ba:	51                   	push   %ecx
  8003bb:	52                   	push   %edx
  8003bc:	50                   	push   %eax
  8003bd:	e8 ce 15 00 00       	call   801990 <__umoddi3>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	05 f4 1d 80 00       	add    $0x801df4,%eax
  8003ca:	8a 00                	mov    (%eax),%al
  8003cc:	0f be c0             	movsbl %al,%eax
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	50                   	push   %eax
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	ff d0                	call   *%eax
  8003db:	83 c4 10             	add    $0x10,%esp
}
  8003de:	90                   	nop
  8003df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003eb:	7e 1c                	jle    800409 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	8d 50 08             	lea    0x8(%eax),%edx
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	89 10                	mov    %edx,(%eax)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	83 e8 08             	sub    $0x8,%eax
  800402:	8b 50 04             	mov    0x4(%eax),%edx
  800405:	8b 00                	mov    (%eax),%eax
  800407:	eb 40                	jmp    800449 <getuint+0x65>
	else if (lflag)
  800409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040d:	74 1e                	je     80042d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 50 04             	lea    0x4(%eax),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	89 10                	mov    %edx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	83 e8 04             	sub    $0x4,%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	ba 00 00 00 00       	mov    $0x0,%edx
  80042b:	eb 1c                	jmp    800449 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
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
}
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800452:	7e 1c                	jle    800470 <getint+0x25>
		return va_arg(*ap, long long);
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	8d 50 08             	lea    0x8(%eax),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	89 10                	mov    %edx,(%eax)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	83 e8 08             	sub    $0x8,%eax
  800469:	8b 50 04             	mov    0x4(%eax),%edx
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	eb 38                	jmp    8004a8 <getint+0x5d>
	else if (lflag)
  800470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800474:	74 1a                	je     800490 <getint+0x45>
		return va_arg(*ap, long);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 50 04             	lea    0x4(%eax),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 10                	mov    %edx,(%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	83 e8 04             	sub    $0x4,%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	99                   	cltd   
  80048e:	eb 18                	jmp    8004a8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	99                   	cltd   
}
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    

008004aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	56                   	push   %esi
  8004ae:	53                   	push   %ebx
  8004af:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b2:	eb 17                	jmp    8004cb <vprintfmt+0x21>
			if (ch == '\0')
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	0f 84 c1 03 00 00    	je     80087d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	53                   	push   %ebx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	ff d0                	call   *%eax
  8004c8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	8d 50 01             	lea    0x1(%eax),%edx
  8004d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d4:	8a 00                	mov    (%eax),%al
  8004d6:	0f b6 d8             	movzbl %al,%ebx
  8004d9:	83 fb 25             	cmp    $0x25,%ebx
  8004dc:	75 d6                	jne    8004b4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004de:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	8d 50 01             	lea    0x1(%eax),%edx
  800504:	89 55 10             	mov    %edx,0x10(%ebp)
  800507:	8a 00                	mov    (%eax),%al
  800509:	0f b6 d8             	movzbl %al,%ebx
  80050c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80050f:	83 f8 5b             	cmp    $0x5b,%eax
  800512:	0f 87 3d 03 00 00    	ja     800855 <vprintfmt+0x3ab>
  800518:	8b 04 85 18 1e 80 00 	mov    0x801e18(,%eax,4),%eax
  80051f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800521:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800525:	eb d7                	jmp    8004fe <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800527:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80052b:	eb d1                	jmp    8004fe <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 d8                	add    %ebx,%eax
  800542:	83 e8 30             	sub    $0x30,%eax
  800545:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800548:	8b 45 10             	mov    0x10(%ebp),%eax
  80054b:	8a 00                	mov    (%eax),%al
  80054d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800550:	83 fb 2f             	cmp    $0x2f,%ebx
  800553:	7e 3e                	jle    800593 <vprintfmt+0xe9>
  800555:	83 fb 39             	cmp    $0x39,%ebx
  800558:	7f 39                	jg     800593 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80055d:	eb d5                	jmp    800534 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 e8 04             	sub    $0x4,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800573:	eb 1f                	jmp    800594 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800579:	79 83                	jns    8004fe <vprintfmt+0x54>
				width = 0;
  80057b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800582:	e9 77 ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800587:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80058e:	e9 6b ff ff ff       	jmp    8004fe <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800593:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800594:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800598:	0f 89 60 ff ff ff    	jns    8004fe <vprintfmt+0x54>
				width = precision, precision = -1;
  80059e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005ab:	e9 4e ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b3:	e9 46 ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	83 e8 04             	sub    $0x4,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	50                   	push   %eax
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	ff d0                	call   *%eax
  8005d5:	83 c4 10             	add    $0x10,%esp
			break;
  8005d8:	e9 9b 02 00 00       	jmp    800878 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 c0 04             	add    $0x4,%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 e8 04             	sub    $0x4,%eax
  8005ec:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005ee:	85 db                	test   %ebx,%ebx
  8005f0:	79 02                	jns    8005f4 <vprintfmt+0x14a>
				err = -err;
  8005f2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005f4:	83 fb 64             	cmp    $0x64,%ebx
  8005f7:	7f 0b                	jg     800604 <vprintfmt+0x15a>
  8005f9:	8b 34 9d 60 1c 80 00 	mov    0x801c60(,%ebx,4),%esi
  800600:	85 f6                	test   %esi,%esi
  800602:	75 19                	jne    80061d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800604:	53                   	push   %ebx
  800605:	68 05 1e 80 00       	push   $0x801e05
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	ff 75 08             	pushl  0x8(%ebp)
  800610:	e8 70 02 00 00       	call   800885 <printfmt>
  800615:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800618:	e9 5b 02 00 00       	jmp    800878 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061d:	56                   	push   %esi
  80061e:	68 0e 1e 80 00       	push   $0x801e0e
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 08             	pushl  0x8(%ebp)
  800629:	e8 57 02 00 00       	call   800885 <printfmt>
  80062e:	83 c4 10             	add    $0x10,%esp
			break;
  800631:	e9 42 02 00 00       	jmp    800878 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	83 c0 04             	add    $0x4,%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 30                	mov    (%eax),%esi
  800647:	85 f6                	test   %esi,%esi
  800649:	75 05                	jne    800650 <vprintfmt+0x1a6>
				p = "(null)";
  80064b:	be 11 1e 80 00       	mov    $0x801e11,%esi
			if (width > 0 && padc != '-')
  800650:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800654:	7e 6d                	jle    8006c3 <vprintfmt+0x219>
  800656:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80065a:	74 67                	je     8006c3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	50                   	push   %eax
  800663:	56                   	push   %esi
  800664:	e8 1e 03 00 00       	call   800987 <strnlen>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80066f:	eb 16                	jmp    800687 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800671:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	ff 4d e4             	decl   -0x1c(%ebp)
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	7f e4                	jg     800671 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068d:	eb 34                	jmp    8006c3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80068f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800693:	74 1c                	je     8006b1 <vprintfmt+0x207>
  800695:	83 fb 1f             	cmp    $0x1f,%ebx
  800698:	7e 05                	jle    80069f <vprintfmt+0x1f5>
  80069a:	83 fb 7e             	cmp    $0x7e,%ebx
  80069d:	7e 12                	jle    8006b1 <vprintfmt+0x207>
					putch('?', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	6a 3f                	push   $0x3f
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	eb 0f                	jmp    8006c0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	53                   	push   %ebx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c3:	89 f0                	mov    %esi,%eax
  8006c5:	8d 70 01             	lea    0x1(%eax),%esi
  8006c8:	8a 00                	mov    (%eax),%al
  8006ca:	0f be d8             	movsbl %al,%ebx
  8006cd:	85 db                	test   %ebx,%ebx
  8006cf:	74 24                	je     8006f5 <vprintfmt+0x24b>
  8006d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d5:	78 b8                	js     80068f <vprintfmt+0x1e5>
  8006d7:	ff 4d e0             	decl   -0x20(%ebp)
  8006da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006de:	79 af                	jns    80068f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e0:	eb 13                	jmp    8006f5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 0c             	pushl  0xc(%ebp)
  8006e8:	6a 20                	push   $0x20
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	ff d0                	call   *%eax
  8006ef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f9:	7f e7                	jg     8006e2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006fb:	e9 78 01 00 00       	jmp    800878 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 e8             	pushl  -0x18(%ebp)
  800706:	8d 45 14             	lea    0x14(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	e8 3c fd ff ff       	call   80044b <getint>
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800715:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	79 23                	jns    800745 <vprintfmt+0x29b>
				putch('-', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 2d                	push   $0x2d
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800738:	f7 d8                	neg    %eax
  80073a:	83 d2 00             	adc    $0x0,%edx
  80073d:	f7 da                	neg    %edx
  80073f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800742:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800745:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074c:	e9 bc 00 00 00       	jmp    80080d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 e8             	pushl  -0x18(%ebp)
  800757:	8d 45 14             	lea    0x14(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	e8 84 fc ff ff       	call   8003e4 <getuint>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800766:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800769:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800770:	e9 98 00 00 00       	jmp    80080d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	6a 58                	push   $0x58
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	6a 58                	push   $0x58
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	ff d0                	call   *%eax
  800792:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	6a 58                	push   $0x58
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
			break;
  8007a5:	e9 ce 00 00 00       	jmp    800878 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	6a 30                	push   $0x30
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
  8007b7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	6a 78                	push   $0x78
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 c0 04             	add    $0x4,%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ec:	eb 1f                	jmp    80080d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 e7 fb ff ff       	call   8003e4 <getuint>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800803:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800806:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	52                   	push   %edx
  800818:	ff 75 e4             	pushl  -0x1c(%ebp)
  80081b:	50                   	push   %eax
  80081c:	ff 75 f4             	pushl  -0xc(%ebp)
  80081f:	ff 75 f0             	pushl  -0x10(%ebp)
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 00 fb ff ff       	call   80032d <printnum>
  80082d:	83 c4 20             	add    $0x20,%esp
			break;
  800830:	eb 46                	jmp    800878 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	53                   	push   %ebx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			break;
  800841:	eb 35                	jmp    800878 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800843:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80084a:	eb 2c                	jmp    800878 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80084c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800853:	eb 23                	jmp    800878 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 25                	push   $0x25
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800865:	ff 4d 10             	decl   0x10(%ebp)
  800868:	eb 03                	jmp    80086d <vprintfmt+0x3c3>
  80086a:	ff 4d 10             	decl   0x10(%ebp)
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	48                   	dec    %eax
  800871:	8a 00                	mov    (%eax),%al
  800873:	3c 25                	cmp    $0x25,%al
  800875:	75 f3                	jne    80086a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800877:	90                   	nop
		}
	}
  800878:	e9 35 fc ff ff       	jmp    8004b2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80087d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80087e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800881:	5b                   	pop    %ebx
  800882:	5e                   	pop    %esi
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80088b:	8d 45 10             	lea    0x10(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800894:	8b 45 10             	mov    0x10(%ebp),%eax
  800897:	ff 75 f4             	pushl  -0xc(%ebp)
  80089a:	50                   	push   %eax
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 04 fc ff ff       	call   8004aa <vprintfmt>
  8008a6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a9:	90                   	nop
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b2:	8b 40 08             	mov    0x8(%eax),%eax
  8008b5:	8d 50 01             	lea    0x1(%eax),%edx
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	8b 10                	mov    (%eax),%edx
  8008c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c6:	8b 40 04             	mov    0x4(%eax),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	73 12                	jae    8008df <sprintputch+0x33>
		*b->buf++ = ch;
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d8:	89 0a                	mov    %ecx,(%edx)
  8008da:	8b 55 08             	mov    0x8(%ebp),%edx
  8008dd:	88 10                	mov    %dl,(%eax)
}
  8008df:	90                   	nop
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800903:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800907:	74 06                	je     80090f <vsnprintf+0x2d>
  800909:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090d:	7f 07                	jg     800916 <vsnprintf+0x34>
		return -E_INVAL;
  80090f:	b8 03 00 00 00       	mov    $0x3,%eax
  800914:	eb 20                	jmp    800936 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800916:	ff 75 14             	pushl  0x14(%ebp)
  800919:	ff 75 10             	pushl  0x10(%ebp)
  80091c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091f:	50                   	push   %eax
  800920:	68 ac 08 80 00       	push   $0x8008ac
  800925:	e8 80 fb ff ff       	call   8004aa <vprintfmt>
  80092a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80092d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800930:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800933:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    

00800938 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093e:	8d 45 10             	lea    0x10(%ebp),%eax
  800941:	83 c0 04             	add    $0x4,%eax
  800944:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	ff 75 f4             	pushl  -0xc(%ebp)
  80094d:	50                   	push   %eax
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 89 ff ff ff       	call   8008e2 <vsnprintf>
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80096a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800971:	eb 06                	jmp    800979 <strlen+0x15>
		n++;
  800973:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	ff 45 08             	incl   0x8(%ebp)
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8a 00                	mov    (%eax),%al
  80097e:	84 c0                	test   %al,%al
  800980:	75 f1                	jne    800973 <strlen+0xf>
		n++;
	return n;
  800982:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800994:	eb 09                	jmp    80099f <strnlen+0x18>
		n++;
  800996:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800999:	ff 45 08             	incl   0x8(%ebp)
  80099c:	ff 4d 0c             	decl   0xc(%ebp)
  80099f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a3:	74 09                	je     8009ae <strnlen+0x27>
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8a 00                	mov    (%eax),%al
  8009aa:	84 c0                	test   %al,%al
  8009ac:	75 e8                	jne    800996 <strnlen+0xf>
		n++;
	return n;
  8009ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009bf:	90                   	nop
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8d 50 01             	lea    0x1(%eax),%edx
  8009c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009cf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d2:	8a 12                	mov    (%edx),%dl
  8009d4:	88 10                	mov    %dl,(%eax)
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	84 c0                	test   %al,%al
  8009da:	75 e4                	jne    8009c0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f4:	eb 1f                	jmp    800a15 <strncpy+0x34>
		*dst++ = *src;
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	8a 12                	mov    (%edx),%dl
  800a04:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	84 c0                	test   %al,%al
  800a0d:	74 03                	je     800a12 <strncpy+0x31>
			src++;
  800a0f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a12:	ff 45 fc             	incl   -0x4(%ebp)
  800a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a18:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a1b:	72 d9                	jb     8009f6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a32:	74 30                	je     800a64 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a34:	eb 16                	jmp    800a4c <strlcpy+0x2a>
			*dst++ = *src++;
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8d 50 01             	lea    0x1(%eax),%edx
  800a3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a45:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a48:	8a 12                	mov    (%edx),%dl
  800a4a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a4c:	ff 4d 10             	decl   0x10(%ebp)
  800a4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a53:	74 09                	je     800a5e <strlcpy+0x3c>
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	84 c0                	test   %al,%al
  800a5c:	75 d8                	jne    800a36 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a64:	8b 55 08             	mov    0x8(%ebp),%edx
  800a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a6a:	29 c2                	sub    %eax,%edx
  800a6c:	89 d0                	mov    %edx,%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a73:	eb 06                	jmp    800a7b <strcmp+0xb>
		p++, q++;
  800a75:	ff 45 08             	incl   0x8(%ebp)
  800a78:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8a 00                	mov    (%eax),%al
  800a80:	84 c0                	test   %al,%al
  800a82:	74 0e                	je     800a92 <strcmp+0x22>
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8a 10                	mov    (%eax),%dl
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	38 c2                	cmp    %al,%dl
  800a90:	74 e3                	je     800a75 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	0f b6 d0             	movzbl %al,%edx
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	0f b6 c0             	movzbl %al,%eax
  800aa2:	29 c2                	sub    %eax,%edx
  800aa4:	89 d0                	mov    %edx,%eax
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800aab:	eb 09                	jmp    800ab6 <strncmp+0xe>
		n--, p++, q++;
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	ff 45 08             	incl   0x8(%ebp)
  800ab3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ab6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aba:	74 17                	je     800ad3 <strncmp+0x2b>
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	84 c0                	test   %al,%al
  800ac3:	74 0e                	je     800ad3 <strncmp+0x2b>
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8a 10                	mov    (%eax),%dl
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	38 c2                	cmp    %al,%dl
  800ad1:	74 da                	je     800aad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad7:	75 07                	jne    800ae0 <strncmp+0x38>
		return 0;
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	eb 14                	jmp    800af4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8a 00                	mov    (%eax),%al
  800ae5:	0f b6 d0             	movzbl %al,%edx
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	0f b6 c0             	movzbl %al,%eax
  800af0:	29 c2                	sub    %eax,%edx
  800af2:	89 d0                	mov    %edx,%eax
}
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 04             	sub    $0x4,%esp
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b02:	eb 12                	jmp    800b16 <strchr+0x20>
		if (*s == c)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b0c:	75 05                	jne    800b13 <strchr+0x1d>
			return (char *) s;
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	eb 11                	jmp    800b24 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b13:	ff 45 08             	incl   0x8(%ebp)
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8a 00                	mov    (%eax),%al
  800b1b:	84 c0                	test   %al,%al
  800b1d:	75 e5                	jne    800b04 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 04             	sub    $0x4,%esp
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b32:	eb 0d                	jmp    800b41 <strfind+0x1b>
		if (*s == c)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b3c:	74 0e                	je     800b4c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b3e:	ff 45 08             	incl   0x8(%ebp)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	84 c0                	test   %al,%al
  800b48:	75 ea                	jne    800b34 <strfind+0xe>
  800b4a:	eb 01                	jmp    800b4d <strfind+0x27>
		if (*s == c)
			break;
  800b4c:	90                   	nop
	return (char *) s;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b64:	eb 0e                	jmp    800b74 <memset+0x22>
		*p++ = c;
  800b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b69:	8d 50 01             	lea    0x1(%eax),%edx
  800b6c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b74:	ff 4d f8             	decl   -0x8(%ebp)
  800b77:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b7b:	79 e9                	jns    800b66 <memset+0x14>
		*p++ = c;

	return v;
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b94:	eb 16                	jmp    800bac <memcpy+0x2a>
		*d++ = *s++;
  800b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b99:	8d 50 01             	lea    0x1(%eax),%edx
  800b9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba8:	8a 12                	mov    (%edx),%dl
  800baa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	75 dd                	jne    800b96 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd6:	73 50                	jae    800c28 <memmove+0x6a>
  800bd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800be3:	76 43                	jbe    800c28 <memmove+0x6a>
		s += n;
  800be5:	8b 45 10             	mov    0x10(%ebp),%eax
  800be8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800beb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bee:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bf1:	eb 10                	jmp    800c03 <memmove+0x45>
			*--d = *--s;
  800bf3:	ff 4d f8             	decl   -0x8(%ebp)
  800bf6:	ff 4d fc             	decl   -0x4(%ebp)
  800bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfc:	8a 10                	mov    (%eax),%dl
  800bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c01:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c09:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	75 e3                	jne    800bf3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c10:	eb 23                	jmp    800c35 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c15:	8d 50 01             	lea    0x1(%eax),%edx
  800c18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c24:	8a 12                	mov    (%edx),%dl
  800c26:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c28:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	75 dd                	jne    800c12 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c4c:	eb 2a                	jmp    800c78 <memcmp+0x3e>
		if (*s1 != *s2)
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c51:	8a 10                	mov    (%eax),%dl
  800c53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	38 c2                	cmp    %al,%dl
  800c5a:	74 16                	je     800c72 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	0f b6 d0             	movzbl %al,%edx
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	0f b6 c0             	movzbl %al,%eax
  800c6c:	29 c2                	sub    %eax,%edx
  800c6e:	89 d0                	mov    %edx,%eax
  800c70:	eb 18                	jmp    800c8a <memcmp+0x50>
		s1++, s2++;
  800c72:	ff 45 fc             	incl   -0x4(%ebp)
  800c75:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	75 c9                	jne    800c4e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	8b 45 10             	mov    0x10(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c9d:	eb 15                	jmp    800cb4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	0f b6 d0             	movzbl %al,%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	0f b6 c0             	movzbl %al,%eax
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	74 0d                	je     800cbe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cb1:	ff 45 08             	incl   0x8(%ebp)
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cba:	72 e3                	jb     800c9f <memfind+0x13>
  800cbc:	eb 01                	jmp    800cbf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cbe:	90                   	nop
	return (void *) s;
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cd1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd8:	eb 03                	jmp    800cdd <strtol+0x19>
		s++;
  800cda:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	3c 20                	cmp    $0x20,%al
  800ce4:	74 f4                	je     800cda <strtol+0x16>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	3c 09                	cmp    $0x9,%al
  800ced:	74 eb                	je     800cda <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 2b                	cmp    $0x2b,%al
  800cf6:	75 05                	jne    800cfd <strtol+0x39>
		s++;
  800cf8:	ff 45 08             	incl   0x8(%ebp)
  800cfb:	eb 13                	jmp    800d10 <strtol+0x4c>
	else if (*s == '-')
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	3c 2d                	cmp    $0x2d,%al
  800d04:	75 0a                	jne    800d10 <strtol+0x4c>
		s++, neg = 1;
  800d06:	ff 45 08             	incl   0x8(%ebp)
  800d09:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d14:	74 06                	je     800d1c <strtol+0x58>
  800d16:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d1a:	75 20                	jne    800d3c <strtol+0x78>
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	3c 30                	cmp    $0x30,%al
  800d23:	75 17                	jne    800d3c <strtol+0x78>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	40                   	inc    %eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	3c 78                	cmp    $0x78,%al
  800d2d:	75 0d                	jne    800d3c <strtol+0x78>
		s += 2, base = 16;
  800d2f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d33:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d3a:	eb 28                	jmp    800d64 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d40:	75 15                	jne    800d57 <strtol+0x93>
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3c 30                	cmp    $0x30,%al
  800d49:	75 0c                	jne    800d57 <strtol+0x93>
		s++, base = 8;
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d55:	eb 0d                	jmp    800d64 <strtol+0xa0>
	else if (base == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strtol+0xa0>
		base = 10;
  800d5d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	3c 2f                	cmp    $0x2f,%al
  800d6b:	7e 19                	jle    800d86 <strtol+0xc2>
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	3c 39                	cmp    $0x39,%al
  800d74:	7f 10                	jg     800d86 <strtol+0xc2>
			dig = *s - '0';
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f be c0             	movsbl %al,%eax
  800d7e:	83 e8 30             	sub    $0x30,%eax
  800d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d84:	eb 42                	jmp    800dc8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3c 60                	cmp    $0x60,%al
  800d8d:	7e 19                	jle    800da8 <strtol+0xe4>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	3c 7a                	cmp    $0x7a,%al
  800d96:	7f 10                	jg     800da8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f be c0             	movsbl %al,%eax
  800da0:	83 e8 57             	sub    $0x57,%eax
  800da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800da6:	eb 20                	jmp    800dc8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 40                	cmp    $0x40,%al
  800daf:	7e 39                	jle    800dea <strtol+0x126>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3c 5a                	cmp    $0x5a,%al
  800db8:	7f 30                	jg     800dea <strtol+0x126>
			dig = *s - 'A' + 10;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f be c0             	movsbl %al,%eax
  800dc2:	83 e8 37             	sub    $0x37,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dcb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dce:	7d 19                	jge    800de9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dd0:	ff 45 08             	incl   0x8(%ebp)
  800dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dda:	89 c2                	mov    %eax,%edx
  800ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ddf:	01 d0                	add    %edx,%eax
  800de1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800de4:	e9 7b ff ff ff       	jmp    800d64 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800de9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dee:	74 08                	je     800df8 <strtol+0x134>
		*endptr = (char *) s;
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800df8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dfc:	74 07                	je     800e05 <strtol+0x141>
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	f7 d8                	neg    %eax
  800e03:	eb 03                	jmp    800e08 <strtol+0x144>
  800e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <ltostr>:

void
ltostr(long value, char *str)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e22:	79 13                	jns    800e37 <ltostr+0x2d>
	{
		neg = 1;
  800e24:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e31:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e34:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e3f:	99                   	cltd   
  800e40:	f7 f9                	idiv   %ecx
  800e42:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e48:	8d 50 01             	lea    0x1(%eax),%edx
  800e4b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4e:	89 c2                	mov    %eax,%edx
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	01 d0                	add    %edx,%eax
  800e55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e58:	83 c2 30             	add    $0x30,%edx
  800e5b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e60:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e65:	f7 e9                	imul   %ecx
  800e67:	c1 fa 02             	sar    $0x2,%edx
  800e6a:	89 c8                	mov    %ecx,%eax
  800e6c:	c1 f8 1f             	sar    $0x1f,%eax
  800e6f:	29 c2                	sub    %eax,%edx
  800e71:	89 d0                	mov    %edx,%eax
  800e73:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7a:	75 bb                	jne    800e37 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e86:	48                   	dec    %eax
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8e:	74 3d                	je     800ecd <ltostr+0xc3>
		start = 1 ;
  800e90:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e97:	eb 34                	jmp    800ecd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	01 d0                	add    %edx,%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	01 c2                	add    %eax,%edx
  800eae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb4:	01 c8                	add    %ecx,%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	01 c2                	add    %eax,%edx
  800ec2:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec5:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eca:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed3:	7c c4                	jl     800e99 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ee0:	90                   	nop
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee9:	ff 75 08             	pushl  0x8(%ebp)
  800eec:	e8 73 fa ff ff       	call   800964 <strlen>
  800ef1:	83 c4 04             	add    $0x4,%esp
  800ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	e8 65 fa ff ff       	call   800964 <strlen>
  800eff:	83 c4 04             	add    $0x4,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f13:	eb 17                	jmp    800f2c <strcconcat+0x49>
		final[s] = str1[s] ;
  800f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	01 c2                	add    %eax,%edx
  800f1d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f29:	ff 45 fc             	incl   -0x4(%ebp)
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f32:	7c e1                	jl     800f15 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f34:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f3b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f42:	eb 1f                	jmp    800f63 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4d:	89 c2                	mov    %eax,%edx
  800f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f52:	01 c2                	add    %eax,%edx
  800f54:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	01 c8                	add    %ecx,%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f60:	ff 45 f8             	incl   -0x8(%ebp)
  800f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f66:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f69:	7c d9                	jl     800f44 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f71:	01 d0                	add    %edx,%eax
  800f73:	c6 00 00             	movb   $0x0,(%eax)
}
  800f76:	90                   	nop
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f85:	8b 45 14             	mov    0x14(%ebp),%eax
  800f88:	8b 00                	mov    (%eax),%eax
  800f8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9c:	eb 0c                	jmp    800faa <strsplit+0x31>
			*string++ = 0;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8d 50 01             	lea    0x1(%eax),%edx
  800fa4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	84 c0                	test   %al,%al
  800fb1:	74 18                	je     800fcb <strsplit+0x52>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f be c0             	movsbl %al,%eax
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	e8 32 fb ff ff       	call   800af6 <strchr>
  800fc4:	83 c4 08             	add    $0x8,%esp
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	75 d3                	jne    800f9e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	84 c0                	test   %al,%al
  800fd2:	74 5a                	je     80102e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	83 f8 0f             	cmp    $0xf,%eax
  800fdc:	75 07                	jne    800fe5 <strsplit+0x6c>
		{
			return 0;
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe3:	eb 66                	jmp    80104b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe8:	8b 00                	mov    (%eax),%eax
  800fea:	8d 48 01             	lea    0x1(%eax),%ecx
  800fed:	8b 55 14             	mov    0x14(%ebp),%edx
  800ff0:	89 0a                	mov    %ecx,(%edx)
  800ff2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	01 c2                	add    %eax,%edx
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801003:	eb 03                	jmp    801008 <strsplit+0x8f>
			string++;
  801005:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	84 c0                	test   %al,%al
  80100f:	74 8b                	je     800f9c <strsplit+0x23>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f be c0             	movsbl %al,%eax
  801019:	50                   	push   %eax
  80101a:	ff 75 0c             	pushl  0xc(%ebp)
  80101d:	e8 d4 fa ff ff       	call   800af6 <strchr>
  801022:	83 c4 08             	add    $0x8,%esp
  801025:	85 c0                	test   %eax,%eax
  801027:	74 dc                	je     801005 <strsplit+0x8c>
			string++;
	}
  801029:	e9 6e ff ff ff       	jmp    800f9c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80102e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80102f:	8b 45 14             	mov    0x14(%ebp),%eax
  801032:	8b 00                	mov    (%eax),%eax
  801034:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103b:	8b 45 10             	mov    0x10(%ebp),%eax
  80103e:	01 d0                	add    %edx,%eax
  801040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801046:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	68 88 1f 80 00       	push   $0x801f88
  80105b:	68 3f 01 00 00       	push   $0x13f
  801060:	68 aa 1f 80 00       	push   $0x801faa
  801065:	e8 2d 06 00 00       	call   801697 <_panic>

0080106a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8b 55 0c             	mov    0xc(%ebp),%edx
  801079:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80107c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801082:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801085:	cd 30                	int    $0x30
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	8b 45 10             	mov    0x10(%ebp),%eax
  80109e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	52                   	push   %edx
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	6a 00                	push   $0x0
  8010b3:	e8 b2 ff ff ff       	call   80106a <syscall>
  8010b8:	83 c4 18             	add    $0x18,%esp
}
  8010bb:	90                   	nop
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <sys_cgetc>:

int
sys_cgetc(void)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	6a 00                	push   $0x0
  8010c9:	6a 00                	push   $0x0
  8010cb:	6a 02                	push   $0x2
  8010cd:	e8 98 ff ff ff       	call   80106a <syscall>
  8010d2:	83 c4 18             	add    $0x18,%esp
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 03                	push   $0x3
  8010e6:	e8 7f ff ff ff       	call   80106a <syscall>
  8010eb:	83 c4 18             	add    $0x18,%esp
}
  8010ee:	90                   	nop
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 04                	push   $0x4
  801100:	e8 65 ff ff ff       	call   80106a <syscall>
  801105:	83 c4 18             	add    $0x18,%esp
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80110e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	6a 00                	push   $0x0
  801116:	6a 00                	push   $0x0
  801118:	6a 00                	push   $0x0
  80111a:	52                   	push   %edx
  80111b:	50                   	push   %eax
  80111c:	6a 08                	push   $0x8
  80111e:	e8 47 ff ff ff       	call   80106a <syscall>
  801123:	83 c4 18             	add    $0x18,%esp
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	56                   	push   %esi
  80112c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80112d:	8b 75 18             	mov    0x18(%ebp),%esi
  801130:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801133:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	56                   	push   %esi
  80113d:	53                   	push   %ebx
  80113e:	51                   	push   %ecx
  80113f:	52                   	push   %edx
  801140:	50                   	push   %eax
  801141:	6a 09                	push   $0x9
  801143:	e8 22 ff ff ff       	call   80106a <syscall>
  801148:	83 c4 18             	add    $0x18,%esp
}
  80114b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801155:	8b 55 0c             	mov    0xc(%ebp),%edx
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	52                   	push   %edx
  801162:	50                   	push   %eax
  801163:	6a 0a                	push   $0xa
  801165:	e8 00 ff ff ff       	call   80106a <syscall>
  80116a:	83 c4 18             	add    $0x18,%esp
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	6a 0b                	push   $0xb
  801180:	e8 e5 fe ff ff       	call   80106a <syscall>
  801185:	83 c4 18             	add    $0x18,%esp
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 0c                	push   $0xc
  801199:	e8 cc fe ff ff       	call   80106a <syscall>
  80119e:	83 c4 18             	add    $0x18,%esp
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 0d                	push   $0xd
  8011b2:	e8 b3 fe ff ff       	call   80106a <syscall>
  8011b7:	83 c4 18             	add    $0x18,%esp
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 0e                	push   $0xe
  8011cb:	e8 9a fe ff ff       	call   80106a <syscall>
  8011d0:	83 c4 18             	add    $0x18,%esp
}
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 0f                	push   $0xf
  8011e4:	e8 81 fe ff ff       	call   80106a <syscall>
  8011e9:	83 c4 18             	add    $0x18,%esp
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	ff 75 08             	pushl  0x8(%ebp)
  8011fc:	6a 10                	push   $0x10
  8011fe:	e8 67 fe ff ff       	call   80106a <syscall>
  801203:	83 c4 18             	add    $0x18,%esp
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 11                	push   $0x11
  801217:	e8 4e fe ff ff       	call   80106a <syscall>
  80121c:	83 c4 18             	add    $0x18,%esp
}
  80121f:	90                   	nop
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <sys_cputc>:

void
sys_cputc(const char c)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80122e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	50                   	push   %eax
  80123b:	6a 01                	push   $0x1
  80123d:	e8 28 fe ff ff       	call   80106a <syscall>
  801242:	83 c4 18             	add    $0x18,%esp
}
  801245:	90                   	nop
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 14                	push   $0x14
  801257:	e8 0e fe ff ff       	call   80106a <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 04             	sub    $0x4,%esp
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80126e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801271:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	6a 00                	push   $0x0
  80127a:	51                   	push   %ecx
  80127b:	52                   	push   %edx
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	50                   	push   %eax
  801280:	6a 15                	push   $0x15
  801282:	e8 e3 fd ff ff       	call   80106a <syscall>
  801287:	83 c4 18             	add    $0x18,%esp
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80128f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	52                   	push   %edx
  80129c:	50                   	push   %eax
  80129d:	6a 16                	push   $0x16
  80129f:	e8 c6 fd ff ff       	call   80106a <syscall>
  8012a4:	83 c4 18             	add    $0x18,%esp
}
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	51                   	push   %ecx
  8012ba:	52                   	push   %edx
  8012bb:	50                   	push   %eax
  8012bc:	6a 17                	push   $0x17
  8012be:	e8 a7 fd ff ff       	call   80106a <syscall>
  8012c3:	83 c4 18             	add    $0x18,%esp
}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	52                   	push   %edx
  8012d8:	50                   	push   %eax
  8012d9:	6a 18                	push   $0x18
  8012db:	e8 8a fd ff ff       	call   80106a <syscall>
  8012e0:	83 c4 18             	add    $0x18,%esp
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	6a 00                	push   $0x0
  8012ed:	ff 75 14             	pushl  0x14(%ebp)
  8012f0:	ff 75 10             	pushl  0x10(%ebp)
  8012f3:	ff 75 0c             	pushl  0xc(%ebp)
  8012f6:	50                   	push   %eax
  8012f7:	6a 19                	push   $0x19
  8012f9:	e8 6c fd ff ff       	call   80106a <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	50                   	push   %eax
  801312:	6a 1a                	push   $0x1a
  801314:	e8 51 fd ff ff       	call   80106a <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	90                   	nop
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	50                   	push   %eax
  80132e:	6a 1b                	push   $0x1b
  801330:	e8 35 fd ff ff       	call   80106a <syscall>
  801335:	83 c4 18             	add    $0x18,%esp
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 05                	push   $0x5
  801349:	e8 1c fd ff ff       	call   80106a <syscall>
  80134e:	83 c4 18             	add    $0x18,%esp
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 06                	push   $0x6
  801362:	e8 03 fd ff ff       	call   80106a <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 07                	push   $0x7
  80137b:	e8 ea fc ff ff       	call   80106a <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <sys_exit_env>:


void sys_exit_env(void)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 1c                	push   $0x1c
  801394:	e8 d1 fc ff ff       	call   80106a <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	90                   	nop
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013a8:	8d 50 04             	lea    0x4(%eax),%edx
  8013ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	52                   	push   %edx
  8013b5:	50                   	push   %eax
  8013b6:	6a 1d                	push   $0x1d
  8013b8:	e8 ad fc ff ff       	call   80106a <syscall>
  8013bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8013c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c9:	89 01                	mov    %eax,(%ecx)
  8013cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	c9                   	leave  
  8013d2:	c2 04 00             	ret    $0x4

008013d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	ff 75 10             	pushl  0x10(%ebp)
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	6a 13                	push   $0x13
  8013e7:	e8 7e fc ff ff       	call   80106a <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ef:	90                   	nop
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 1e                	push   $0x1e
  801401:	e8 64 fc ff ff       	call   80106a <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801417:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	50                   	push   %eax
  801424:	6a 1f                	push   $0x1f
  801426:	e8 3f fc ff ff       	call   80106a <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
	return ;
  80142e:	90                   	nop
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <rsttst>:
void rsttst()
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 21                	push   $0x21
  801440:	e8 25 fc ff ff       	call   80106a <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
	return ;
  801448:	90                   	nop
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	8b 45 14             	mov    0x14(%ebp),%eax
  801454:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801457:	8b 55 18             	mov    0x18(%ebp),%edx
  80145a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80145e:	52                   	push   %edx
  80145f:	50                   	push   %eax
  801460:	ff 75 10             	pushl  0x10(%ebp)
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	6a 20                	push   $0x20
  80146b:	e8 fa fb ff ff       	call   80106a <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
	return ;
  801473:	90                   	nop
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <chktst>:
void chktst(uint32 n)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	ff 75 08             	pushl  0x8(%ebp)
  801484:	6a 22                	push   $0x22
  801486:	e8 df fb ff ff       	call   80106a <syscall>
  80148b:	83 c4 18             	add    $0x18,%esp
	return ;
  80148e:	90                   	nop
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <inctst>:

void inctst()
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 23                	push   $0x23
  8014a0:	e8 c5 fb ff ff       	call   80106a <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a8:	90                   	nop
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <gettst>:
uint32 gettst()
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 24                	push   $0x24
  8014ba:	e8 ab fb ff ff       	call   80106a <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 25                	push   $0x25
  8014d6:	e8 8f fb ff ff       	call   80106a <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
  8014de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014e1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014e5:	75 07                	jne    8014ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ec:	eb 05                	jmp    8014f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 25                	push   $0x25
  801507:	e8 5e fb ff ff       	call   80106a <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
  80150f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801512:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801516:	75 07                	jne    80151f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801518:	b8 01 00 00 00       	mov    $0x1,%eax
  80151d:	eb 05                	jmp    801524 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 25                	push   $0x25
  801538:	e8 2d fb ff ff       	call   80106a <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
  801540:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801543:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801547:	75 07                	jne    801550 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801549:	b8 01 00 00 00       	mov    $0x1,%eax
  80154e:	eb 05                	jmp    801555 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 25                	push   $0x25
  801569:	e8 fc fa ff ff       	call   80106a <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
  801571:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801574:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801578:	75 07                	jne    801581 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80157a:	b8 01 00 00 00       	mov    $0x1,%eax
  80157f:	eb 05                	jmp    801586 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	6a 26                	push   $0x26
  801598:	e8 cd fa ff ff       	call   80106a <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a0:	90                   	nop
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	6a 00                	push   $0x0
  8015b5:	53                   	push   %ebx
  8015b6:	51                   	push   %ecx
  8015b7:	52                   	push   %edx
  8015b8:	50                   	push   %eax
  8015b9:	6a 27                	push   $0x27
  8015bb:	e8 aa fa ff ff       	call   80106a <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	52                   	push   %edx
  8015d8:	50                   	push   %eax
  8015d9:	6a 28                	push   $0x28
  8015db:	e8 8a fa ff ff       	call   80106a <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	6a 00                	push   $0x0
  8015f3:	51                   	push   %ecx
  8015f4:	ff 75 10             	pushl  0x10(%ebp)
  8015f7:	52                   	push   %edx
  8015f8:	50                   	push   %eax
  8015f9:	6a 29                	push   $0x29
  8015fb:	e8 6a fa ff ff       	call   80106a <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 10             	pushl  0x10(%ebp)
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	6a 12                	push   $0x12
  801617:	e8 4e fa ff ff       	call   80106a <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
	return ;
  80161f:	90                   	nop
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	52                   	push   %edx
  801632:	50                   	push   %eax
  801633:	6a 2a                	push   $0x2a
  801635:	e8 30 fa ff ff       	call   80106a <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
	return;
  80163d:	90                   	nop
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 b7 1f 80 00       	push   $0x801fb7
  80164e:	68 2e 01 00 00       	push   $0x12e
  801653:	68 cb 1f 80 00       	push   $0x801fcb
  801658:	e8 3a 00 00 00       	call   801697 <_panic>

0080165d <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	68 b7 1f 80 00       	push   $0x801fb7
  80166b:	68 35 01 00 00       	push   $0x135
  801670:	68 cb 1f 80 00       	push   $0x801fcb
  801675:	e8 1d 00 00 00       	call   801697 <_panic>

0080167a <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	68 b7 1f 80 00       	push   $0x801fb7
  801688:	68 3b 01 00 00       	push   $0x13b
  80168d:	68 cb 1f 80 00       	push   $0x801fcb
  801692:	e8 00 00 00 00       	call   801697 <_panic>

00801697 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80169d:	8d 45 10             	lea    0x10(%ebp),%eax
  8016a0:	83 c0 04             	add    $0x4,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016a6:	a1 24 30 80 00       	mov    0x803024,%eax
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	74 16                	je     8016c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016af:	a1 24 30 80 00       	mov    0x803024,%eax
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	50                   	push   %eax
  8016b8:	68 dc 1f 80 00       	push   $0x801fdc
  8016bd:	e8 0e ec ff ff       	call   8002d0 <cprintf>
  8016c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016c5:	a1 00 30 80 00       	mov    0x803000,%eax
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	ff 75 08             	pushl  0x8(%ebp)
  8016d0:	50                   	push   %eax
  8016d1:	68 e1 1f 80 00       	push   $0x801fe1
  8016d6:	e8 f5 eb ff ff       	call   8002d0 <cprintf>
  8016db:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016de:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e7:	50                   	push   %eax
  8016e8:	e8 78 eb ff ff       	call   800265 <vcprintf>
  8016ed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016f0:	83 ec 08             	sub    $0x8,%esp
  8016f3:	6a 00                	push   $0x0
  8016f5:	68 fd 1f 80 00       	push   $0x801ffd
  8016fa:	e8 66 eb ff ff       	call   800265 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801702:	e8 e7 ea ff ff       	call   8001ee <exit>

	// should not return here
	while (1) ;
  801707:	eb fe                	jmp    801707 <_panic+0x70>

00801709 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80170f:	a1 04 30 80 00       	mov    0x803004,%eax
  801714:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	39 c2                	cmp    %eax,%edx
  80171f:	74 14                	je     801735 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	68 00 20 80 00       	push   $0x802000
  801729:	6a 26                	push   $0x26
  80172b:	68 4c 20 80 00       	push   $0x80204c
  801730:	e8 62 ff ff ff       	call   801697 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80173c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801743:	e9 c5 00 00 00       	jmp    80180d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	01 d0                	add    %edx,%eax
  801757:	8b 00                	mov    (%eax),%eax
  801759:	85 c0                	test   %eax,%eax
  80175b:	75 08                	jne    801765 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80175d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801760:	e9 a5 00 00 00       	jmp    80180a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801765:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80176c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801773:	eb 69                	jmp    8017de <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801775:	a1 04 30 80 00       	mov    0x803004,%eax
  80177a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801780:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801783:	89 d0                	mov    %edx,%eax
  801785:	01 c0                	add    %eax,%eax
  801787:	01 d0                	add    %edx,%eax
  801789:	c1 e0 03             	shl    $0x3,%eax
  80178c:	01 c8                	add    %ecx,%eax
  80178e:	8a 40 04             	mov    0x4(%eax),%al
  801791:	84 c0                	test   %al,%al
  801793:	75 46                	jne    8017db <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801795:	a1 04 30 80 00       	mov    0x803004,%eax
  80179a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	01 c0                	add    %eax,%eax
  8017a7:	01 d0                	add    %edx,%eax
  8017a9:	c1 e0 03             	shl    $0x3,%eax
  8017ac:	01 c8                	add    %ecx,%eax
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	01 c8                	add    %ecx,%eax
  8017cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017ce:	39 c2                	cmp    %eax,%edx
  8017d0:	75 09                	jne    8017db <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017d9:	eb 15                	jmp    8017f0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017db:	ff 45 e8             	incl   -0x18(%ebp)
  8017de:	a1 04 30 80 00       	mov    0x803004,%eax
  8017e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ec:	39 c2                	cmp    %eax,%edx
  8017ee:	77 85                	ja     801775 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017f4:	75 14                	jne    80180a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 58 20 80 00       	push   $0x802058
  8017fe:	6a 3a                	push   $0x3a
  801800:	68 4c 20 80 00       	push   $0x80204c
  801805:	e8 8d fe ff ff       	call   801697 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80180a:	ff 45 f0             	incl   -0x10(%ebp)
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801813:	0f 8c 2f ff ff ff    	jl     801748 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801819:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801820:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801827:	eb 26                	jmp    80184f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801829:	a1 04 30 80 00       	mov    0x803004,%eax
  80182e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801834:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801837:	89 d0                	mov    %edx,%eax
  801839:	01 c0                	add    %eax,%eax
  80183b:	01 d0                	add    %edx,%eax
  80183d:	c1 e0 03             	shl    $0x3,%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 40 04             	mov    0x4(%eax),%al
  801845:	3c 01                	cmp    $0x1,%al
  801847:	75 03                	jne    80184c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801849:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80184c:	ff 45 e0             	incl   -0x20(%ebp)
  80184f:	a1 04 30 80 00       	mov    0x803004,%eax
  801854:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80185a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185d:	39 c2                	cmp    %eax,%edx
  80185f:	77 c8                	ja     801829 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801864:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801867:	74 14                	je     80187d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 ac 20 80 00       	push   $0x8020ac
  801871:	6a 44                	push   $0x44
  801873:	68 4c 20 80 00       	push   $0x80204c
  801878:	e8 1a fe ff ff       	call   801697 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <__udivdi3>:
  801880:	55                   	push   %ebp
  801881:	57                   	push   %edi
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	83 ec 1c             	sub    $0x1c,%esp
  801887:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80188b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80188f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801893:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801897:	89 ca                	mov    %ecx,%edx
  801899:	89 f8                	mov    %edi,%eax
  80189b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80189f:	85 f6                	test   %esi,%esi
  8018a1:	75 2d                	jne    8018d0 <__udivdi3+0x50>
  8018a3:	39 cf                	cmp    %ecx,%edi
  8018a5:	77 65                	ja     80190c <__udivdi3+0x8c>
  8018a7:	89 fd                	mov    %edi,%ebp
  8018a9:	85 ff                	test   %edi,%edi
  8018ab:	75 0b                	jne    8018b8 <__udivdi3+0x38>
  8018ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b2:	31 d2                	xor    %edx,%edx
  8018b4:	f7 f7                	div    %edi
  8018b6:	89 c5                	mov    %eax,%ebp
  8018b8:	31 d2                	xor    %edx,%edx
  8018ba:	89 c8                	mov    %ecx,%eax
  8018bc:	f7 f5                	div    %ebp
  8018be:	89 c1                	mov    %eax,%ecx
  8018c0:	89 d8                	mov    %ebx,%eax
  8018c2:	f7 f5                	div    %ebp
  8018c4:	89 cf                	mov    %ecx,%edi
  8018c6:	89 fa                	mov    %edi,%edx
  8018c8:	83 c4 1c             	add    $0x1c,%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5e                   	pop    %esi
  8018cd:	5f                   	pop    %edi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    
  8018d0:	39 ce                	cmp    %ecx,%esi
  8018d2:	77 28                	ja     8018fc <__udivdi3+0x7c>
  8018d4:	0f bd fe             	bsr    %esi,%edi
  8018d7:	83 f7 1f             	xor    $0x1f,%edi
  8018da:	75 40                	jne    80191c <__udivdi3+0x9c>
  8018dc:	39 ce                	cmp    %ecx,%esi
  8018de:	72 0a                	jb     8018ea <__udivdi3+0x6a>
  8018e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018e4:	0f 87 9e 00 00 00    	ja     801988 <__udivdi3+0x108>
  8018ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ef:	89 fa                	mov    %edi,%edx
  8018f1:	83 c4 1c             	add    $0x1c,%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    
  8018f9:	8d 76 00             	lea    0x0(%esi),%esi
  8018fc:	31 ff                	xor    %edi,%edi
  8018fe:	31 c0                	xor    %eax,%eax
  801900:	89 fa                	mov    %edi,%edx
  801902:	83 c4 1c             	add    $0x1c,%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    
  80190a:	66 90                	xchg   %ax,%ax
  80190c:	89 d8                	mov    %ebx,%eax
  80190e:	f7 f7                	div    %edi
  801910:	31 ff                	xor    %edi,%edi
  801912:	89 fa                	mov    %edi,%edx
  801914:	83 c4 1c             	add    $0x1c,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
  80191c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801921:	89 eb                	mov    %ebp,%ebx
  801923:	29 fb                	sub    %edi,%ebx
  801925:	89 f9                	mov    %edi,%ecx
  801927:	d3 e6                	shl    %cl,%esi
  801929:	89 c5                	mov    %eax,%ebp
  80192b:	88 d9                	mov    %bl,%cl
  80192d:	d3 ed                	shr    %cl,%ebp
  80192f:	89 e9                	mov    %ebp,%ecx
  801931:	09 f1                	or     %esi,%ecx
  801933:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801937:	89 f9                	mov    %edi,%ecx
  801939:	d3 e0                	shl    %cl,%eax
  80193b:	89 c5                	mov    %eax,%ebp
  80193d:	89 d6                	mov    %edx,%esi
  80193f:	88 d9                	mov    %bl,%cl
  801941:	d3 ee                	shr    %cl,%esi
  801943:	89 f9                	mov    %edi,%ecx
  801945:	d3 e2                	shl    %cl,%edx
  801947:	8b 44 24 08          	mov    0x8(%esp),%eax
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 e8                	shr    %cl,%eax
  80194f:	09 c2                	or     %eax,%edx
  801951:	89 d0                	mov    %edx,%eax
  801953:	89 f2                	mov    %esi,%edx
  801955:	f7 74 24 0c          	divl   0xc(%esp)
  801959:	89 d6                	mov    %edx,%esi
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	f7 e5                	mul    %ebp
  80195f:	39 d6                	cmp    %edx,%esi
  801961:	72 19                	jb     80197c <__udivdi3+0xfc>
  801963:	74 0b                	je     801970 <__udivdi3+0xf0>
  801965:	89 d8                	mov    %ebx,%eax
  801967:	31 ff                	xor    %edi,%edi
  801969:	e9 58 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	8b 54 24 08          	mov    0x8(%esp),%edx
  801974:	89 f9                	mov    %edi,%ecx
  801976:	d3 e2                	shl    %cl,%edx
  801978:	39 c2                	cmp    %eax,%edx
  80197a:	73 e9                	jae    801965 <__udivdi3+0xe5>
  80197c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80197f:	31 ff                	xor    %edi,%edi
  801981:	e9 40 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  801986:	66 90                	xchg   %ax,%ax
  801988:	31 c0                	xor    %eax,%eax
  80198a:	e9 37 ff ff ff       	jmp    8018c6 <__udivdi3+0x46>
  80198f:	90                   	nop

00801990 <__umoddi3>:
  801990:	55                   	push   %ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 1c             	sub    $0x1c,%esp
  801997:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80199b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80199f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019af:	89 f3                	mov    %esi,%ebx
  8019b1:	89 fa                	mov    %edi,%edx
  8019b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b7:	89 34 24             	mov    %esi,(%esp)
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	75 1a                	jne    8019d8 <__umoddi3+0x48>
  8019be:	39 f7                	cmp    %esi,%edi
  8019c0:	0f 86 a2 00 00 00    	jbe    801a68 <__umoddi3+0xd8>
  8019c6:	89 c8                	mov    %ecx,%eax
  8019c8:	89 f2                	mov    %esi,%edx
  8019ca:	f7 f7                	div    %edi
  8019cc:	89 d0                	mov    %edx,%eax
  8019ce:	31 d2                	xor    %edx,%edx
  8019d0:	83 c4 1c             	add    $0x1c,%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5f                   	pop    %edi
  8019d6:	5d                   	pop    %ebp
  8019d7:	c3                   	ret    
  8019d8:	39 f0                	cmp    %esi,%eax
  8019da:	0f 87 ac 00 00 00    	ja     801a8c <__umoddi3+0xfc>
  8019e0:	0f bd e8             	bsr    %eax,%ebp
  8019e3:	83 f5 1f             	xor    $0x1f,%ebp
  8019e6:	0f 84 ac 00 00 00    	je     801a98 <__umoddi3+0x108>
  8019ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8019f1:	29 ef                	sub    %ebp,%edi
  8019f3:	89 fe                	mov    %edi,%esi
  8019f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f9:	89 e9                	mov    %ebp,%ecx
  8019fb:	d3 e0                	shl    %cl,%eax
  8019fd:	89 d7                	mov    %edx,%edi
  8019ff:	89 f1                	mov    %esi,%ecx
  801a01:	d3 ef                	shr    %cl,%edi
  801a03:	09 c7                	or     %eax,%edi
  801a05:	89 e9                	mov    %ebp,%ecx
  801a07:	d3 e2                	shl    %cl,%edx
  801a09:	89 14 24             	mov    %edx,(%esp)
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	d3 e0                	shl    %cl,%eax
  801a10:	89 c2                	mov    %eax,%edx
  801a12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a16:	d3 e0                	shl    %cl,%eax
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a20:	89 f1                	mov    %esi,%ecx
  801a22:	d3 e8                	shr    %cl,%eax
  801a24:	09 d0                	or     %edx,%eax
  801a26:	d3 eb                	shr    %cl,%ebx
  801a28:	89 da                	mov    %ebx,%edx
  801a2a:	f7 f7                	div    %edi
  801a2c:	89 d3                	mov    %edx,%ebx
  801a2e:	f7 24 24             	mull   (%esp)
  801a31:	89 c6                	mov    %eax,%esi
  801a33:	89 d1                	mov    %edx,%ecx
  801a35:	39 d3                	cmp    %edx,%ebx
  801a37:	0f 82 87 00 00 00    	jb     801ac4 <__umoddi3+0x134>
  801a3d:	0f 84 91 00 00 00    	je     801ad4 <__umoddi3+0x144>
  801a43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a47:	29 f2                	sub    %esi,%edx
  801a49:	19 cb                	sbb    %ecx,%ebx
  801a4b:	89 d8                	mov    %ebx,%eax
  801a4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a51:	d3 e0                	shl    %cl,%eax
  801a53:	89 e9                	mov    %ebp,%ecx
  801a55:	d3 ea                	shr    %cl,%edx
  801a57:	09 d0                	or     %edx,%eax
  801a59:	89 e9                	mov    %ebp,%ecx
  801a5b:	d3 eb                	shr    %cl,%ebx
  801a5d:	89 da                	mov    %ebx,%edx
  801a5f:	83 c4 1c             	add    $0x1c,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5e                   	pop    %esi
  801a64:	5f                   	pop    %edi
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    
  801a67:	90                   	nop
  801a68:	89 fd                	mov    %edi,%ebp
  801a6a:	85 ff                	test   %edi,%edi
  801a6c:	75 0b                	jne    801a79 <__umoddi3+0xe9>
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	31 d2                	xor    %edx,%edx
  801a75:	f7 f7                	div    %edi
  801a77:	89 c5                	mov    %eax,%ebp
  801a79:	89 f0                	mov    %esi,%eax
  801a7b:	31 d2                	xor    %edx,%edx
  801a7d:	f7 f5                	div    %ebp
  801a7f:	89 c8                	mov    %ecx,%eax
  801a81:	f7 f5                	div    %ebp
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	e9 44 ff ff ff       	jmp    8019ce <__umoddi3+0x3e>
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	89 c8                	mov    %ecx,%eax
  801a8e:	89 f2                	mov    %esi,%edx
  801a90:	83 c4 1c             	add    $0x1c,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5f                   	pop    %edi
  801a96:	5d                   	pop    %ebp
  801a97:	c3                   	ret    
  801a98:	3b 04 24             	cmp    (%esp),%eax
  801a9b:	72 06                	jb     801aa3 <__umoddi3+0x113>
  801a9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801aa1:	77 0f                	ja     801ab2 <__umoddi3+0x122>
  801aa3:	89 f2                	mov    %esi,%edx
  801aa5:	29 f9                	sub    %edi,%ecx
  801aa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aab:	89 14 24             	mov    %edx,(%esp)
  801aae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ab6:	8b 14 24             	mov    (%esp),%edx
  801ab9:	83 c4 1c             	add    $0x1c,%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5f                   	pop    %edi
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    
  801ac1:	8d 76 00             	lea    0x0(%esi),%esi
  801ac4:	2b 04 24             	sub    (%esp),%eax
  801ac7:	19 fa                	sbb    %edi,%edx
  801ac9:	89 d1                	mov    %edx,%ecx
  801acb:	89 c6                	mov    %eax,%esi
  801acd:	e9 71 ff ff ff       	jmp    801a43 <__umoddi3+0xb3>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ad8:	72 ea                	jb     801ac4 <__umoddi3+0x134>
  801ada:	89 d9                	mov    %ebx,%ecx
  801adc:	e9 62 ff ff ff       	jmp    801a43 <__umoddi3+0xb3>
