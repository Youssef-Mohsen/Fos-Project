
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
  80005b:	e8 5a 02 00 00       	call   8002ba <cprintf>
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
  800092:	e8 23 02 00 00       	call   8002ba <cprintf>
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
  8000b5:	e8 83 12 00 00       	call   80133d <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	c1 e0 02             	shl    $0x2,%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	01 c0                	add    %eax,%eax
  8000c9:	01 d0                	add    %edx,%eax
  8000cb:	c1 e0 02             	shl    $0x2,%eax
  8000ce:	01 d0                	add    %edx,%eax
  8000d0:	01 c0                	add    %eax,%eax
  8000d2:	01 d0                	add    %edx,%eax
  8000d4:	c1 e0 04             	shl    $0x4,%eax
  8000d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dc:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e6:	8a 40 20             	mov    0x20(%eax),%al
  8000e9:	84 c0                	test   %al,%al
  8000eb:	74 0d                	je     8000fa <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8000ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f2:	83 c0 20             	add    $0x20,%eax
  8000f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000fe:	7e 0a                	jle    80010a <libmain+0x5b>
		binaryname = argv[0];
  800100:	8b 45 0c             	mov    0xc(%ebp),%eax
  800103:	8b 00                	mov    (%eax),%eax
  800105:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	ff 75 0c             	pushl  0xc(%ebp)
  800110:	ff 75 08             	pushl  0x8(%ebp)
  800113:	e8 20 ff ff ff       	call   800038 <_main>
  800118:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80011b:	e8 a1 0f 00 00       	call   8010c1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 00 1b 80 00       	push   $0x801b00
  800128:	e8 8d 01 00 00       	call   8002ba <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800130:	a1 04 30 80 00       	mov    0x803004,%eax
  800135:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80013b:	a1 04 30 80 00       	mov    0x803004,%eax
  800140:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	52                   	push   %edx
  80014a:	50                   	push   %eax
  80014b:	68 28 1b 80 00       	push   $0x801b28
  800150:	e8 65 01 00 00       	call   8002ba <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800158:	a1 04 30 80 00       	mov    0x803004,%eax
  80015d:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800163:	a1 04 30 80 00       	mov    0x803004,%eax
  800168:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80016e:	a1 04 30 80 00       	mov    0x803004,%eax
  800173:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800179:	51                   	push   %ecx
  80017a:	52                   	push   %edx
  80017b:	50                   	push   %eax
  80017c:	68 50 1b 80 00       	push   $0x801b50
  800181:	e8 34 01 00 00       	call   8002ba <cprintf>
  800186:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800189:	a1 04 30 80 00       	mov    0x803004,%eax
  80018e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	50                   	push   %eax
  800198:	68 a8 1b 80 00       	push   $0x801ba8
  80019d:	e8 18 01 00 00       	call   8002ba <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	68 00 1b 80 00       	push   $0x801b00
  8001ad:	e8 08 01 00 00       	call   8002ba <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001b5:	e8 21 0f 00 00       	call   8010db <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001ba:	e8 19 00 00 00       	call   8001d8 <exit>
}
  8001bf:	90                   	nop
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	6a 00                	push   $0x0
  8001cd:	e8 37 11 00 00       	call   801309 <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
}
  8001d5:	90                   	nop
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <exit>:

void
exit(void)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001de:	e8 8c 11 00 00       	call   80136f <sys_exit_env>
}
  8001e3:	90                   	nop
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	8b 00                	mov    (%eax),%eax
  8001f1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f7:	89 0a                	mov    %ecx,(%edx)
  8001f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fc:	88 d1                	mov    %dl,%cl
  8001fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800201:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800205:	8b 45 0c             	mov    0xc(%ebp),%eax
  800208:	8b 00                	mov    (%eax),%eax
  80020a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020f:	75 2c                	jne    80023d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800211:	a0 08 30 80 00       	mov    0x803008,%al
  800216:	0f b6 c0             	movzbl %al,%eax
  800219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021c:	8b 12                	mov    (%edx),%edx
  80021e:	89 d1                	mov    %edx,%ecx
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	83 c2 08             	add    $0x8,%edx
  800226:	83 ec 04             	sub    $0x4,%esp
  800229:	50                   	push   %eax
  80022a:	51                   	push   %ecx
  80022b:	52                   	push   %edx
  80022c:	e8 4e 0e 00 00       	call   80107f <sys_cputs>
  800231:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	8b 40 04             	mov    0x4(%eax),%eax
  800243:	8d 50 01             	lea    0x1(%eax),%edx
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
  800249:	89 50 04             	mov    %edx,0x4(%eax)
}
  80024c:	90                   	nop
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800258:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025f:	00 00 00 
	b.cnt = 0;
  800262:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800269:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80026c:	ff 75 0c             	pushl  0xc(%ebp)
  80026f:	ff 75 08             	pushl  0x8(%ebp)
  800272:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	68 e6 01 80 00       	push   $0x8001e6
  80027e:	e8 11 02 00 00       	call   800494 <vprintfmt>
  800283:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800286:	a0 08 30 80 00       	mov    0x803008,%al
  80028b:	0f b6 c0             	movzbl %al,%eax
  80028e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	50                   	push   %eax
  800298:	52                   	push   %edx
  800299:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029f:	83 c0 08             	add    $0x8,%eax
  8002a2:	50                   	push   %eax
  8002a3:	e8 d7 0d 00 00       	call   80107f <sys_cputs>
  8002a8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ab:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002c7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d6:	50                   	push   %eax
  8002d7:	e8 73 ff ff ff       	call   80024f <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002ed:	e8 cf 0d 00 00       	call   8010c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800301:	50                   	push   %eax
  800302:	e8 48 ff ff ff       	call   80024f <vcprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80030d:	e8 c9 0d 00 00       	call   8010db <sys_unlock_cons>
	return cnt;
  800312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	53                   	push   %ebx
  80031b:	83 ec 14             	sub    $0x14,%esp
  80031e:	8b 45 10             	mov    0x10(%ebp),%eax
  800321:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800324:	8b 45 14             	mov    0x14(%ebp),%eax
  800327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032a:	8b 45 18             	mov    0x18(%ebp),%eax
  80032d:	ba 00 00 00 00       	mov    $0x0,%edx
  800332:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800335:	77 55                	ja     80038c <printnum+0x75>
  800337:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033a:	72 05                	jb     800341 <printnum+0x2a>
  80033c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80033f:	77 4b                	ja     80038c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800341:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800344:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800347:	8b 45 18             	mov    0x18(%ebp),%eax
  80034a:	ba 00 00 00 00       	mov    $0x0,%edx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	ff 75 f4             	pushl  -0xc(%ebp)
  800354:	ff 75 f0             	pushl  -0x10(%ebp)
  800357:	e8 0c 15 00 00       	call   801868 <__udivdi3>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 20             	pushl  0x20(%ebp)
  800365:	53                   	push   %ebx
  800366:	ff 75 18             	pushl  0x18(%ebp)
  800369:	52                   	push   %edx
  80036a:	50                   	push   %eax
  80036b:	ff 75 0c             	pushl  0xc(%ebp)
  80036e:	ff 75 08             	pushl  0x8(%ebp)
  800371:	e8 a1 ff ff ff       	call   800317 <printnum>
  800376:	83 c4 20             	add    $0x20,%esp
  800379:	eb 1a                	jmp    800395 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037b:	83 ec 08             	sub    $0x8,%esp
  80037e:	ff 75 0c             	pushl  0xc(%ebp)
  800381:	ff 75 20             	pushl  0x20(%ebp)
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	ff d0                	call   *%eax
  800389:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038c:	ff 4d 1c             	decl   0x1c(%ebp)
  80038f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800393:	7f e6                	jg     80037b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800398:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a3:	53                   	push   %ebx
  8003a4:	51                   	push   %ecx
  8003a5:	52                   	push   %edx
  8003a6:	50                   	push   %eax
  8003a7:	e8 cc 15 00 00       	call   801978 <__umoddi3>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	05 d4 1d 80 00       	add    $0x801dd4,%eax
  8003b4:	8a 00                	mov    (%eax),%al
  8003b6:	0f be c0             	movsbl %al,%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	ff d0                	call   *%eax
  8003c5:	83 c4 10             	add    $0x10,%esp
}
  8003c8:	90                   	nop
  8003c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d5:	7e 1c                	jle    8003f3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 08             	lea    0x8(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 08             	sub    $0x8,%eax
  8003ec:	8b 50 04             	mov    0x4(%eax),%edx
  8003ef:	8b 00                	mov    (%eax),%eax
  8003f1:	eb 40                	jmp    800433 <getuint+0x65>
	else if (lflag)
  8003f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f7:	74 1e                	je     800417 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 04             	sub    $0x4,%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	ba 00 00 00 00       	mov    $0x0,%edx
  800415:	eb 1c                	jmp    800433 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	8d 50 04             	lea    0x4(%eax),%edx
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	89 10                	mov    %edx,(%eax)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	83 e8 04             	sub    $0x4,%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800438:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80043c:	7e 1c                	jle    80045a <getint+0x25>
		return va_arg(*ap, long long);
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	8d 50 08             	lea    0x8(%eax),%edx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	89 10                	mov    %edx,(%eax)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	83 e8 08             	sub    $0x8,%eax
  800453:	8b 50 04             	mov    0x4(%eax),%edx
  800456:	8b 00                	mov    (%eax),%eax
  800458:	eb 38                	jmp    800492 <getint+0x5d>
	else if (lflag)
  80045a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80045e:	74 1a                	je     80047a <getint+0x45>
		return va_arg(*ap, long);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 50 04             	lea    0x4(%eax),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 10                	mov    %edx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 e8 04             	sub    $0x4,%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	99                   	cltd   
  800478:	eb 18                	jmp    800492 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	8d 50 04             	lea    0x4(%eax),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	89 10                	mov    %edx,(%eax)
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	83 e8 04             	sub    $0x4,%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	99                   	cltd   
}
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    

00800494 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	56                   	push   %esi
  800498:	53                   	push   %ebx
  800499:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049c:	eb 17                	jmp    8004b5 <vprintfmt+0x21>
			if (ch == '\0')
  80049e:	85 db                	test   %ebx,%ebx
  8004a0:	0f 84 c1 03 00 00    	je     800867 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	ff 75 0c             	pushl  0xc(%ebp)
  8004ac:	53                   	push   %ebx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	ff d0                	call   *%eax
  8004b2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b8:	8d 50 01             	lea    0x1(%eax),%edx
  8004bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8004be:	8a 00                	mov    (%eax),%al
  8004c0:	0f b6 d8             	movzbl %al,%ebx
  8004c3:	83 fb 25             	cmp    $0x25,%ebx
  8004c6:	75 d6                	jne    80049e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004c8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004cc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004eb:	8d 50 01             	lea    0x1(%eax),%edx
  8004ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f1:	8a 00                	mov    (%eax),%al
  8004f3:	0f b6 d8             	movzbl %al,%ebx
  8004f6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f9:	83 f8 5b             	cmp    $0x5b,%eax
  8004fc:	0f 87 3d 03 00 00    	ja     80083f <vprintfmt+0x3ab>
  800502:	8b 04 85 f8 1d 80 00 	mov    0x801df8(,%eax,4),%eax
  800509:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80050b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80050f:	eb d7                	jmp    8004e8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800511:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800515:	eb d1                	jmp    8004e8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800517:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80051e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	c1 e0 02             	shl    $0x2,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	01 c0                	add    %eax,%eax
  80052a:	01 d8                	add    %ebx,%eax
  80052c:	83 e8 30             	sub    $0x30,%eax
  80052f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800532:	8b 45 10             	mov    0x10(%ebp),%eax
  800535:	8a 00                	mov    (%eax),%al
  800537:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80053a:	83 fb 2f             	cmp    $0x2f,%ebx
  80053d:	7e 3e                	jle    80057d <vprintfmt+0xe9>
  80053f:	83 fb 39             	cmp    $0x39,%ebx
  800542:	7f 39                	jg     80057d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800544:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800547:	eb d5                	jmp    80051e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	83 c0 04             	add    $0x4,%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	83 e8 04             	sub    $0x4,%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80055d:	eb 1f                	jmp    80057e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80055f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800563:	79 83                	jns    8004e8 <vprintfmt+0x54>
				width = 0;
  800565:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80056c:	e9 77 ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800571:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800578:	e9 6b ff ff ff       	jmp    8004e8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80057d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80057e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800582:	0f 89 60 ff ff ff    	jns    8004e8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800595:	e9 4e ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80059d:	e9 46 ff ff ff       	jmp    8004e8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	83 c0 04             	add    $0x4,%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	83 e8 04             	sub    $0x4,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bd:	ff d0                	call   *%eax
  8005bf:	83 c4 10             	add    $0x10,%esp
			break;
  8005c2:	e9 9b 02 00 00       	jmp    800862 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 c0 04             	add    $0x4,%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	83 e8 04             	sub    $0x4,%eax
  8005d6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005d8:	85 db                	test   %ebx,%ebx
  8005da:	79 02                	jns    8005de <vprintfmt+0x14a>
				err = -err;
  8005dc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005de:	83 fb 64             	cmp    $0x64,%ebx
  8005e1:	7f 0b                	jg     8005ee <vprintfmt+0x15a>
  8005e3:	8b 34 9d 40 1c 80 00 	mov    0x801c40(,%ebx,4),%esi
  8005ea:	85 f6                	test   %esi,%esi
  8005ec:	75 19                	jne    800607 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ee:	53                   	push   %ebx
  8005ef:	68 e5 1d 80 00       	push   $0x801de5
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	ff 75 08             	pushl  0x8(%ebp)
  8005fa:	e8 70 02 00 00       	call   80086f <printfmt>
  8005ff:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800602:	e9 5b 02 00 00       	jmp    800862 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800607:	56                   	push   %esi
  800608:	68 ee 1d 80 00       	push   $0x801dee
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	ff 75 08             	pushl  0x8(%ebp)
  800613:	e8 57 02 00 00       	call   80086f <printfmt>
  800618:	83 c4 10             	add    $0x10,%esp
			break;
  80061b:	e9 42 02 00 00       	jmp    800862 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 c0 04             	add    $0x4,%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 30                	mov    (%eax),%esi
  800631:	85 f6                	test   %esi,%esi
  800633:	75 05                	jne    80063a <vprintfmt+0x1a6>
				p = "(null)";
  800635:	be f1 1d 80 00       	mov    $0x801df1,%esi
			if (width > 0 && padc != '-')
  80063a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063e:	7e 6d                	jle    8006ad <vprintfmt+0x219>
  800640:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800644:	74 67                	je     8006ad <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	50                   	push   %eax
  80064d:	56                   	push   %esi
  80064e:	e8 1e 03 00 00       	call   800971 <strnlen>
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800659:	eb 16                	jmp    800671 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80065b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	ff d0                	call   *%eax
  80066b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80066e:	ff 4d e4             	decl   -0x1c(%ebp)
  800671:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800675:	7f e4                	jg     80065b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800677:	eb 34                	jmp    8006ad <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800679:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067d:	74 1c                	je     80069b <vprintfmt+0x207>
  80067f:	83 fb 1f             	cmp    $0x1f,%ebx
  800682:	7e 05                	jle    800689 <vprintfmt+0x1f5>
  800684:	83 fb 7e             	cmp    $0x7e,%ebx
  800687:	7e 12                	jle    80069b <vprintfmt+0x207>
					putch('?', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	6a 3f                	push   $0x3f
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	ff d0                	call   *%eax
  800696:	83 c4 10             	add    $0x10,%esp
  800699:	eb 0f                	jmp    8006aa <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	53                   	push   %ebx
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	ff d0                	call   *%eax
  8006a7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	8d 70 01             	lea    0x1(%eax),%esi
  8006b2:	8a 00                	mov    (%eax),%al
  8006b4:	0f be d8             	movsbl %al,%ebx
  8006b7:	85 db                	test   %ebx,%ebx
  8006b9:	74 24                	je     8006df <vprintfmt+0x24b>
  8006bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006bf:	78 b8                	js     800679 <vprintfmt+0x1e5>
  8006c1:	ff 4d e0             	decl   -0x20(%ebp)
  8006c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c8:	79 af                	jns    800679 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ca:	eb 13                	jmp    8006df <vprintfmt+0x24b>
				putch(' ', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	6a 20                	push   $0x20
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e3:	7f e7                	jg     8006cc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006e5:	e9 78 01 00 00       	jmp    800862 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	e8 3c fd ff ff       	call   800435 <getint>
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800708:	85 d2                	test   %edx,%edx
  80070a:	79 23                	jns    80072f <vprintfmt+0x29b>
				putch('-', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	6a 2d                	push   $0x2d
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80071c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800722:	f7 d8                	neg    %eax
  800724:	83 d2 00             	adc    $0x0,%edx
  800727:	f7 da                	neg    %edx
  800729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80072f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800736:	e9 bc 00 00 00       	jmp    8007f7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 e8             	pushl  -0x18(%ebp)
  800741:	8d 45 14             	lea    0x14(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	e8 84 fc ff ff       	call   8003ce <getuint>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800750:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800753:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075a:	e9 98 00 00 00       	jmp    8007f7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 58                	push   $0x58
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 0c             	pushl  0xc(%ebp)
  800775:	6a 58                	push   $0x58
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	ff d0                	call   *%eax
  80077c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	6a 58                	push   $0x58
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	ff d0                	call   *%eax
  80078c:	83 c4 10             	add    $0x10,%esp
			break;
  80078f:	e9 ce 00 00 00       	jmp    800862 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	6a 30                	push   $0x30
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	6a 78                	push   $0x78
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d8:	83 ec 08             	sub    $0x8,%esp
  8007db:	ff 75 e8             	pushl  -0x18(%ebp)
  8007de:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	e8 e7 fb ff ff       	call   8003ce <getuint>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	52                   	push   %edx
  800802:	ff 75 e4             	pushl  -0x1c(%ebp)
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 00 fb ff ff       	call   800317 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
			break;
  80081a:	eb 46                	jmp    800862 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	53                   	push   %ebx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
			break;
  80082b:	eb 35                	jmp    800862 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80082d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800834:	eb 2c                	jmp    800862 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800836:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80083d:	eb 23                	jmp    800862 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	6a 25                	push   $0x25
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084f:	ff 4d 10             	decl   0x10(%ebp)
  800852:	eb 03                	jmp    800857 <vprintfmt+0x3c3>
  800854:	ff 4d 10             	decl   0x10(%ebp)
  800857:	8b 45 10             	mov    0x10(%ebp),%eax
  80085a:	48                   	dec    %eax
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	3c 25                	cmp    $0x25,%al
  80085f:	75 f3                	jne    800854 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800861:	90                   	nop
		}
	}
  800862:	e9 35 fc ff ff       	jmp    80049c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800867:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800875:	8d 45 10             	lea    0x10(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	ff 75 f4             	pushl  -0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	e8 04 fc ff ff       	call   800494 <vprintfmt>
  800890:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800893:	90                   	nop
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 40 08             	mov    0x8(%eax),%eax
  80089f:	8d 50 01             	lea    0x1(%eax),%edx
  8008a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ab:	8b 10                	mov    (%eax),%edx
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	8b 40 04             	mov    0x4(%eax),%eax
  8008b3:	39 c2                	cmp    %eax,%edx
  8008b5:	73 12                	jae    8008c9 <sprintputch+0x33>
		*b->buf++ = ch;
  8008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c2:	89 0a                	mov    %ecx,(%edx)
  8008c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c7:	88 10                	mov    %dl,(%eax)
}
  8008c9:	90                   	nop
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	01 d0                	add    %edx,%eax
  8008e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f1:	74 06                	je     8008f9 <vsnprintf+0x2d>
  8008f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f7:	7f 07                	jg     800900 <vsnprintf+0x34>
		return -E_INVAL;
  8008f9:	b8 03 00 00 00       	mov    $0x3,%eax
  8008fe:	eb 20                	jmp    800920 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800900:	ff 75 14             	pushl  0x14(%ebp)
  800903:	ff 75 10             	pushl  0x10(%ebp)
  800906:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800909:	50                   	push   %eax
  80090a:	68 96 08 80 00       	push   $0x800896
  80090f:	e8 80 fb ff ff       	call   800494 <vprintfmt>
  800914:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80091d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800920:	c9                   	leave  
  800921:	c3                   	ret    

00800922 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800928:	8d 45 10             	lea    0x10(%ebp),%eax
  80092b:	83 c0 04             	add    $0x4,%eax
  80092e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800931:	8b 45 10             	mov    0x10(%ebp),%eax
  800934:	ff 75 f4             	pushl  -0xc(%ebp)
  800937:	50                   	push   %eax
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	ff 75 08             	pushl  0x8(%ebp)
  80093e:	e8 89 ff ff ff       	call   8008cc <vsnprintf>
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80095b:	eb 06                	jmp    800963 <strlen+0x15>
		n++;
  80095d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800960:	ff 45 08             	incl   0x8(%ebp)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8a 00                	mov    (%eax),%al
  800968:	84 c0                	test   %al,%al
  80096a:	75 f1                	jne    80095d <strlen+0xf>
		n++;
	return n;
  80096c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800977:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097e:	eb 09                	jmp    800989 <strnlen+0x18>
		n++;
  800980:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800983:	ff 45 08             	incl   0x8(%ebp)
  800986:	ff 4d 0c             	decl   0xc(%ebp)
  800989:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098d:	74 09                	je     800998 <strnlen+0x27>
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8a 00                	mov    (%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 e8                	jne    800980 <strnlen+0xf>
		n++;
	return n;
  800998:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009a9:	90                   	nop
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009bc:	8a 12                	mov    (%edx),%dl
  8009be:	88 10                	mov    %dl,(%eax)
  8009c0:	8a 00                	mov    (%eax),%al
  8009c2:	84 c0                	test   %al,%al
  8009c4:	75 e4                	jne    8009aa <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009de:	eb 1f                	jmp    8009ff <strncpy+0x34>
		*dst++ = *src;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8d 50 01             	lea    0x1(%eax),%edx
  8009e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	8a 12                	mov    (%edx),%dl
  8009ee:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	84 c0                	test   %al,%al
  8009f7:	74 03                	je     8009fc <strncpy+0x31>
			src++;
  8009f9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
  8009ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a02:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a05:	72 d9                	jb     8009e0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a1c:	74 30                	je     800a4e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a1e:	eb 16                	jmp    800a36 <strlcpy+0x2a>
			*dst++ = *src++;
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8d 50 01             	lea    0x1(%eax),%edx
  800a26:	89 55 08             	mov    %edx,0x8(%ebp)
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a2f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a32:	8a 12                	mov    (%edx),%dl
  800a34:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a36:	ff 4d 10             	decl   0x10(%ebp)
  800a39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a3d:	74 09                	je     800a48 <strlcpy+0x3c>
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 d8                	jne    800a20 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a54:	29 c2                	sub    %eax,%edx
  800a56:	89 d0                	mov    %edx,%eax
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a5d:	eb 06                	jmp    800a65 <strcmp+0xb>
		p++, q++;
  800a5f:	ff 45 08             	incl   0x8(%ebp)
  800a62:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	84 c0                	test   %al,%al
  800a6c:	74 0e                	je     800a7c <strcmp+0x22>
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8a 10                	mov    (%eax),%dl
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	38 c2                	cmp    %al,%dl
  800a7a:	74 e3                	je     800a5f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8a 00                	mov    (%eax),%al
  800a81:	0f b6 d0             	movzbl %al,%edx
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	8a 00                	mov    (%eax),%al
  800a89:	0f b6 c0             	movzbl %al,%eax
  800a8c:	29 c2                	sub    %eax,%edx
  800a8e:	89 d0                	mov    %edx,%eax
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a95:	eb 09                	jmp    800aa0 <strncmp+0xe>
		n--, p++, q++;
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	ff 45 08             	incl   0x8(%ebp)
  800a9d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa4:	74 17                	je     800abd <strncmp+0x2b>
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	84 c0                	test   %al,%al
  800aad:	74 0e                	je     800abd <strncmp+0x2b>
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8a 10                	mov    (%eax),%dl
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	38 c2                	cmp    %al,%dl
  800abb:	74 da                	je     800a97 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800abd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac1:	75 07                	jne    800aca <strncmp+0x38>
		return 0;
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	eb 14                	jmp    800ade <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	0f b6 d0             	movzbl %al,%edx
  800ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad5:	8a 00                	mov    (%eax),%al
  800ad7:	0f b6 c0             	movzbl %al,%eax
  800ada:	29 c2                	sub    %eax,%edx
  800adc:	89 d0                	mov    %edx,%eax
}
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 04             	sub    $0x4,%esp
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aec:	eb 12                	jmp    800b00 <strchr+0x20>
		if (*s == c)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af6:	75 05                	jne    800afd <strchr+0x1d>
			return (char *) s;
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	eb 11                	jmp    800b0e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800afd:	ff 45 08             	incl   0x8(%ebp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	84 c0                	test   %al,%al
  800b07:	75 e5                	jne    800aee <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b1c:	eb 0d                	jmp    800b2b <strfind+0x1b>
		if (*s == c)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b26:	74 0e                	je     800b36 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b28:	ff 45 08             	incl   0x8(%ebp)
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	84 c0                	test   %al,%al
  800b32:	75 ea                	jne    800b1e <strfind+0xe>
  800b34:	eb 01                	jmp    800b37 <strfind+0x27>
		if (*s == c)
			break;
  800b36:	90                   	nop
	return (char *) s;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b48:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b4e:	eb 0e                	jmp    800b5e <memset+0x22>
		*p++ = c;
  800b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b53:	8d 50 01             	lea    0x1(%eax),%edx
  800b56:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b5e:	ff 4d f8             	decl   -0x8(%ebp)
  800b61:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b65:	79 e9                	jns    800b50 <memset+0x14>
		*p++ = c;

	return v;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b7e:	eb 16                	jmp    800b96 <memcpy+0x2a>
		*d++ = *s++;
  800b80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b83:	8d 50 01             	lea    0x1(%eax),%edx
  800b86:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b8f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b92:	8a 12                	mov    (%edx),%dl
  800b94:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b96:	8b 45 10             	mov    0x10(%ebp),%eax
  800b99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9f:	85 c0                	test   %eax,%eax
  800ba1:	75 dd                	jne    800b80 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc0:	73 50                	jae    800c12 <memmove+0x6a>
  800bc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc8:	01 d0                	add    %edx,%eax
  800bca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bcd:	76 43                	jbe    800c12 <memmove+0x6a>
		s += n;
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bdb:	eb 10                	jmp    800bed <memmove+0x45>
			*--d = *--s;
  800bdd:	ff 4d f8             	decl   -0x8(%ebp)
  800be0:	ff 4d fc             	decl   -0x4(%ebp)
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be6:	8a 10                	mov    (%eax),%dl
  800be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800beb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bed:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf6:	85 c0                	test   %eax,%eax
  800bf8:	75 e3                	jne    800bdd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfa:	eb 23                	jmp    800c1f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c36:	eb 2a                	jmp    800c62 <memcmp+0x3e>
		if (*s1 != *s2)
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3b:	8a 10                	mov    (%eax),%dl
  800c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	38 c2                	cmp    %al,%dl
  800c44:	74 16                	je     800c5c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d0             	movzbl %al,%edx
  800c4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	0f b6 c0             	movzbl %al,%eax
  800c56:	29 c2                	sub    %eax,%edx
  800c58:	89 d0                	mov    %edx,%eax
  800c5a:	eb 18                	jmp    800c74 <memcmp+0x50>
		s1++, s2++;
  800c5c:	ff 45 fc             	incl   -0x4(%ebp)
  800c5f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	75 c9                	jne    800c38 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c87:	eb 15                	jmp    800c9e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	0f b6 d0             	movzbl %al,%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	0f b6 c0             	movzbl %al,%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 0d                	je     800ca8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c9b:	ff 45 08             	incl   0x8(%ebp)
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ca4:	72 e3                	jb     800c89 <memfind+0x13>
  800ca6:	eb 01                	jmp    800ca9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ca8:	90                   	nop
	return (void *) s;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc2:	eb 03                	jmp    800cc7 <strtol+0x19>
		s++;
  800cc4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	3c 20                	cmp    $0x20,%al
  800cce:	74 f4                	je     800cc4 <strtol+0x16>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	3c 09                	cmp    $0x9,%al
  800cd7:	74 eb                	je     800cc4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 2b                	cmp    $0x2b,%al
  800ce0:	75 05                	jne    800ce7 <strtol+0x39>
		s++;
  800ce2:	ff 45 08             	incl   0x8(%ebp)
  800ce5:	eb 13                	jmp    800cfa <strtol+0x4c>
	else if (*s == '-')
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 2d                	cmp    $0x2d,%al
  800cee:	75 0a                	jne    800cfa <strtol+0x4c>
		s++, neg = 1;
  800cf0:	ff 45 08             	incl   0x8(%ebp)
  800cf3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfe:	74 06                	je     800d06 <strtol+0x58>
  800d00:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d04:	75 20                	jne    800d26 <strtol+0x78>
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	3c 30                	cmp    $0x30,%al
  800d0d:	75 17                	jne    800d26 <strtol+0x78>
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	40                   	inc    %eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	3c 78                	cmp    $0x78,%al
  800d17:	75 0d                	jne    800d26 <strtol+0x78>
		s += 2, base = 16;
  800d19:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d1d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d24:	eb 28                	jmp    800d4e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	75 15                	jne    800d41 <strtol+0x93>
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3c 30                	cmp    $0x30,%al
  800d33:	75 0c                	jne    800d41 <strtol+0x93>
		s++, base = 8;
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d3f:	eb 0d                	jmp    800d4e <strtol+0xa0>
	else if (base == 0)
  800d41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d45:	75 07                	jne    800d4e <strtol+0xa0>
		base = 10;
  800d47:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 2f                	cmp    $0x2f,%al
  800d55:	7e 19                	jle    800d70 <strtol+0xc2>
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	3c 39                	cmp    $0x39,%al
  800d5e:	7f 10                	jg     800d70 <strtol+0xc2>
			dig = *s - '0';
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	0f be c0             	movsbl %al,%eax
  800d68:	83 e8 30             	sub    $0x30,%eax
  800d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d6e:	eb 42                	jmp    800db2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 60                	cmp    $0x60,%al
  800d77:	7e 19                	jle    800d92 <strtol+0xe4>
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	3c 7a                	cmp    $0x7a,%al
  800d80:	7f 10                	jg     800d92 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f be c0             	movsbl %al,%eax
  800d8a:	83 e8 57             	sub    $0x57,%eax
  800d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d90:	eb 20                	jmp    800db2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 40                	cmp    $0x40,%al
  800d99:	7e 39                	jle    800dd4 <strtol+0x126>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	3c 5a                	cmp    $0x5a,%al
  800da2:	7f 30                	jg     800dd4 <strtol+0x126>
			dig = *s - 'A' + 10;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f be c0             	movsbl %al,%eax
  800dac:	83 e8 37             	sub    $0x37,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800db8:	7d 19                	jge    800dd3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dba:	ff 45 08             	incl   0x8(%ebp)
  800dbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc4:	89 c2                	mov    %eax,%edx
  800dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc9:	01 d0                	add    %edx,%eax
  800dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dce:	e9 7b ff ff ff       	jmp    800d4e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dd3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd8:	74 08                	je     800de2 <strtol+0x134>
		*endptr = (char *) s;
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800de6:	74 07                	je     800def <strtol+0x141>
  800de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800deb:	f7 d8                	neg    %eax
  800ded:	eb 03                	jmp    800df2 <strtol+0x144>
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <ltostr>:

void
ltostr(long value, char *str)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e01:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0c:	79 13                	jns    800e21 <ltostr+0x2d>
	{
		neg = 1;
  800e0e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e1b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e1e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e29:	99                   	cltd   
  800e2a:	f7 f9                	idiv   %ecx
  800e2c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e32:	8d 50 01             	lea    0x1(%eax),%edx
  800e35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e38:	89 c2                	mov    %eax,%edx
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e42:	83 c2 30             	add    $0x30,%edx
  800e45:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e4f:	f7 e9                	imul   %ecx
  800e51:	c1 fa 02             	sar    $0x2,%edx
  800e54:	89 c8                	mov    %ecx,%eax
  800e56:	c1 f8 1f             	sar    $0x1f,%eax
  800e59:	29 c2                	sub    %eax,%edx
  800e5b:	89 d0                	mov    %edx,%eax
  800e5d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e64:	75 bb                	jne    800e21 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	48                   	dec    %eax
  800e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e78:	74 3d                	je     800eb7 <ltostr+0xc3>
		start = 1 ;
  800e7a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e81:	eb 34                	jmp    800eb7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	01 d0                	add    %edx,%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	01 c2                	add    %eax,%edx
  800e98:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	01 c8                	add    %ecx,%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	01 c2                	add    %eax,%edx
  800eac:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eaf:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eb4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ebd:	7c c4                	jl     800e83 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ebf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eca:	90                   	nop
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ed3:	ff 75 08             	pushl  0x8(%ebp)
  800ed6:	e8 73 fa ff ff       	call   80094e <strlen>
  800edb:	83 c4 04             	add    $0x4,%esp
  800ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	e8 65 fa ff ff       	call   80094e <strlen>
  800ee9:	83 c4 04             	add    $0x4,%esp
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ef6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efd:	eb 17                	jmp    800f16 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	01 c2                	add    %eax,%edx
  800f07:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	01 c8                	add    %ecx,%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f13:	ff 45 fc             	incl   -0x4(%ebp)
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f1c:	7c e1                	jl     800eff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f2c:	eb 1f                	jmp    800f4d <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	8d 50 01             	lea    0x1(%eax),%edx
  800f34:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f37:	89 c2                	mov    %eax,%edx
  800f39:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3c:	01 c2                	add    %eax,%edx
  800f3e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	01 c8                	add    %ecx,%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f4a:	ff 45 f8             	incl   -0x8(%ebp)
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f53:	7c d9                	jl     800f2e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	c6 00 00             	movb   $0x0,(%eax)
}
  800f60:	90                   	nop
  800f61:	c9                   	leave  
  800f62:	c3                   	ret    

00800f63 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f72:	8b 00                	mov    (%eax),%eax
  800f74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f86:	eb 0c                	jmp    800f94 <strsplit+0x31>
			*string++ = 0;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8d 50 01             	lea    0x1(%eax),%edx
  800f8e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f91:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 18                	je     800fb5 <strsplit+0x52>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f be c0             	movsbl %al,%eax
  800fa5:	50                   	push   %eax
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	e8 32 fb ff ff       	call   800ae0 <strchr>
  800fae:	83 c4 08             	add    $0x8,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	75 d3                	jne    800f88 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	84 c0                	test   %al,%al
  800fbc:	74 5a                	je     801018 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	83 f8 0f             	cmp    $0xf,%eax
  800fc6:	75 07                	jne    800fcf <strsplit+0x6c>
		{
			return 0;
  800fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcd:	eb 66                	jmp    801035 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fcf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd7:	8b 55 14             	mov    0x14(%ebp),%edx
  800fda:	89 0a                	mov    %ecx,(%edx)
  800fdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	01 c2                	add    %eax,%edx
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fed:	eb 03                	jmp    800ff2 <strsplit+0x8f>
			string++;
  800fef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	84 c0                	test   %al,%al
  800ff9:	74 8b                	je     800f86 <strsplit+0x23>
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f be c0             	movsbl %al,%eax
  801003:	50                   	push   %eax
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	e8 d4 fa ff ff       	call   800ae0 <strchr>
  80100c:	83 c4 08             	add    $0x8,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	74 dc                	je     800fef <strsplit+0x8c>
			string++;
	}
  801013:	e9 6e ff ff ff       	jmp    800f86 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801018:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801019:	8b 45 14             	mov    0x14(%ebp),%eax
  80101c:	8b 00                	mov    (%eax),%eax
  80101e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801030:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80103d:	83 ec 04             	sub    $0x4,%esp
  801040:	68 68 1f 80 00       	push   $0x801f68
  801045:	68 3f 01 00 00       	push   $0x13f
  80104a:	68 8a 1f 80 00       	push   $0x801f8a
  80104f:	e8 29 06 00 00       	call   80167d <_panic>

00801054 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	57                   	push   %edi
  801058:	56                   	push   %esi
  801059:	53                   	push   %ebx
  80105a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801066:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801069:	8b 7d 18             	mov    0x18(%ebp),%edi
  80106c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80106f:	cd 30                	int    $0x30
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 04             	sub    $0x4,%esp
  801085:	8b 45 10             	mov    0x10(%ebp),%eax
  801088:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80108b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	6a 00                	push   $0x0
  801094:	6a 00                	push   $0x0
  801096:	52                   	push   %edx
  801097:	ff 75 0c             	pushl  0xc(%ebp)
  80109a:	50                   	push   %eax
  80109b:	6a 00                	push   $0x0
  80109d:	e8 b2 ff ff ff       	call   801054 <syscall>
  8010a2:	83 c4 18             	add    $0x18,%esp
}
  8010a5:	90                   	nop
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	6a 00                	push   $0x0
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 02                	push   $0x2
  8010b7:	e8 98 ff ff ff       	call   801054 <syscall>
  8010bc:	83 c4 18             	add    $0x18,%esp
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 00                	push   $0x0
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 03                	push   $0x3
  8010d0:	e8 7f ff ff ff       	call   801054 <syscall>
  8010d5:	83 c4 18             	add    $0x18,%esp
}
  8010d8:	90                   	nop
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 00                	push   $0x0
  8010e6:	6a 00                	push   $0x0
  8010e8:	6a 04                	push   $0x4
  8010ea:	e8 65 ff ff ff       	call   801054 <syscall>
  8010ef:	83 c4 18             	add    $0x18,%esp
}
  8010f2:	90                   	nop
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	52                   	push   %edx
  801105:	50                   	push   %eax
  801106:	6a 08                	push   $0x8
  801108:	e8 47 ff ff ff       	call   801054 <syscall>
  80110d:	83 c4 18             	add    $0x18,%esp
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801117:	8b 75 18             	mov    0x18(%ebp),%esi
  80111a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80111d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801120:	8b 55 0c             	mov    0xc(%ebp),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	51                   	push   %ecx
  801129:	52                   	push   %edx
  80112a:	50                   	push   %eax
  80112b:	6a 09                	push   $0x9
  80112d:	e8 22 ff ff ff       	call   801054 <syscall>
  801132:	83 c4 18             	add    $0x18,%esp
}
  801135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80113f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	52                   	push   %edx
  80114c:	50                   	push   %eax
  80114d:	6a 0a                	push   $0xa
  80114f:	e8 00 ff ff ff       	call   801054 <syscall>
  801154:	83 c4 18             	add    $0x18,%esp
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	ff 75 0c             	pushl  0xc(%ebp)
  801165:	ff 75 08             	pushl  0x8(%ebp)
  801168:	6a 0b                	push   $0xb
  80116a:	e8 e5 fe ff ff       	call   801054 <syscall>
  80116f:	83 c4 18             	add    $0x18,%esp
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 0c                	push   $0xc
  801183:	e8 cc fe ff ff       	call   801054 <syscall>
  801188:	83 c4 18             	add    $0x18,%esp
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 0d                	push   $0xd
  80119c:	e8 b3 fe ff ff       	call   801054 <syscall>
  8011a1:	83 c4 18             	add    $0x18,%esp
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 0e                	push   $0xe
  8011b5:	e8 9a fe ff ff       	call   801054 <syscall>
  8011ba:	83 c4 18             	add    $0x18,%esp
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 0f                	push   $0xf
  8011ce:	e8 81 fe ff ff       	call   801054 <syscall>
  8011d3:	83 c4 18             	add    $0x18,%esp
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	ff 75 08             	pushl  0x8(%ebp)
  8011e6:	6a 10                	push   $0x10
  8011e8:	e8 67 fe ff ff       	call   801054 <syscall>
  8011ed:	83 c4 18             	add    $0x18,%esp
}
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 11                	push   $0x11
  801201:	e8 4e fe ff ff       	call   801054 <syscall>
  801206:	83 c4 18             	add    $0x18,%esp
}
  801209:	90                   	nop
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <sys_cputc>:

void
sys_cputc(const char c)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801218:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	50                   	push   %eax
  801225:	6a 01                	push   $0x1
  801227:	e8 28 fe ff ff       	call   801054 <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 14                	push   $0x14
  801241:	e8 0e fe ff ff       	call   801054 <syscall>
  801246:	83 c4 18             	add    $0x18,%esp
}
  801249:	90                   	nop
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	8b 45 10             	mov    0x10(%ebp),%eax
  801255:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801258:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80125b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	6a 00                	push   $0x0
  801264:	51                   	push   %ecx
  801265:	52                   	push   %edx
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	50                   	push   %eax
  80126a:	6a 15                	push   $0x15
  80126c:	e8 e3 fd ff ff       	call   801054 <syscall>
  801271:	83 c4 18             	add    $0x18,%esp
}
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	52                   	push   %edx
  801286:	50                   	push   %eax
  801287:	6a 16                	push   $0x16
  801289:	e8 c6 fd ff ff       	call   801054 <syscall>
  80128e:	83 c4 18             	add    $0x18,%esp
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801296:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	51                   	push   %ecx
  8012a4:	52                   	push   %edx
  8012a5:	50                   	push   %eax
  8012a6:	6a 17                	push   $0x17
  8012a8:	e8 a7 fd ff ff       	call   801054 <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	52                   	push   %edx
  8012c2:	50                   	push   %eax
  8012c3:	6a 18                	push   $0x18
  8012c5:	e8 8a fd ff ff       	call   801054 <syscall>
  8012ca:	83 c4 18             	add    $0x18,%esp
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	ff 75 14             	pushl  0x14(%ebp)
  8012da:	ff 75 10             	pushl  0x10(%ebp)
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	50                   	push   %eax
  8012e1:	6a 19                	push   $0x19
  8012e3:	e8 6c fd ff ff       	call   801054 <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	50                   	push   %eax
  8012fc:	6a 1a                	push   $0x1a
  8012fe:	e8 51 fd ff ff       	call   801054 <syscall>
  801303:	83 c4 18             	add    $0x18,%esp
}
  801306:	90                   	nop
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	50                   	push   %eax
  801318:	6a 1b                	push   $0x1b
  80131a:	e8 35 fd ff ff       	call   801054 <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 05                	push   $0x5
  801333:	e8 1c fd ff ff       	call   801054 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 06                	push   $0x6
  80134c:	e8 03 fd ff ff       	call   801054 <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 07                	push   $0x7
  801365:	e8 ea fc ff ff       	call   801054 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_exit_env>:


void sys_exit_env(void)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 1c                	push   $0x1c
  80137e:	e8 d1 fc ff ff       	call   801054 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	90                   	nop
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80138f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801392:	8d 50 04             	lea    0x4(%eax),%edx
  801395:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	52                   	push   %edx
  80139f:	50                   	push   %eax
  8013a0:	6a 1d                	push   $0x1d
  8013a2:	e8 ad fc ff ff       	call   801054 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8013aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b3:	89 01                	mov    %eax,(%ecx)
  8013b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	c9                   	leave  
  8013bc:	c2 04 00             	ret    $0x4

008013bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	ff 75 10             	pushl  0x10(%ebp)
  8013c9:	ff 75 0c             	pushl  0xc(%ebp)
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	6a 13                	push   $0x13
  8013d1:	e8 7e fc ff ff       	call   801054 <syscall>
  8013d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d9:	90                   	nop
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 1e                	push   $0x1e
  8013eb:	e8 64 fc ff ff       	call   801054 <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801401:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	50                   	push   %eax
  80140e:	6a 1f                	push   $0x1f
  801410:	e8 3f fc ff ff       	call   801054 <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
	return ;
  801418:	90                   	nop
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <rsttst>:
void rsttst()
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 21                	push   $0x21
  80142a:	e8 25 fc ff ff       	call   801054 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
	return ;
  801432:	90                   	nop
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 04             	sub    $0x4,%esp
  80143b:	8b 45 14             	mov    0x14(%ebp),%eax
  80143e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801441:	8b 55 18             	mov    0x18(%ebp),%edx
  801444:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801448:	52                   	push   %edx
  801449:	50                   	push   %eax
  80144a:	ff 75 10             	pushl  0x10(%ebp)
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	ff 75 08             	pushl  0x8(%ebp)
  801453:	6a 20                	push   $0x20
  801455:	e8 fa fb ff ff       	call   801054 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
	return ;
  80145d:	90                   	nop
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <chktst>:
void chktst(uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	ff 75 08             	pushl  0x8(%ebp)
  80146e:	6a 22                	push   $0x22
  801470:	e8 df fb ff ff       	call   801054 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
	return ;
  801478:	90                   	nop
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <inctst>:

void inctst()
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 23                	push   $0x23
  80148a:	e8 c5 fb ff ff       	call   801054 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
	return ;
  801492:	90                   	nop
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <gettst>:
uint32 gettst()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 24                	push   $0x24
  8014a4:	e8 ab fb ff ff       	call   801054 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 25                	push   $0x25
  8014c0:	e8 8f fb ff ff       	call   801054 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
  8014c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014cb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014cf:	75 07                	jne    8014d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d6:	eb 05                	jmp    8014dd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 25                	push   $0x25
  8014f1:	e8 5e fb ff ff       	call   801054 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
  8014f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014fc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801500:	75 07                	jne    801509 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801502:	b8 01 00 00 00       	mov    $0x1,%eax
  801507:	eb 05                	jmp    80150e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 25                	push   $0x25
  801522:	e8 2d fb ff ff       	call   801054 <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
  80152a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80152d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801531:	75 07                	jne    80153a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801533:	b8 01 00 00 00       	mov    $0x1,%eax
  801538:	eb 05                	jmp    80153f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 25                	push   $0x25
  801553:	e8 fc fa ff ff       	call   801054 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
  80155b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80155e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801562:	75 07                	jne    80156b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801564:	b8 01 00 00 00       	mov    $0x1,%eax
  801569:	eb 05                	jmp    801570 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	6a 26                	push   $0x26
  801582:	e8 cd fa ff ff       	call   801054 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
	return ;
  80158a:	90                   	nop
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	6a 00                	push   $0x0
  80159f:	53                   	push   %ebx
  8015a0:	51                   	push   %ecx
  8015a1:	52                   	push   %edx
  8015a2:	50                   	push   %eax
  8015a3:	6a 27                	push   $0x27
  8015a5:	e8 aa fa ff ff       	call   801054 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	52                   	push   %edx
  8015c2:	50                   	push   %eax
  8015c3:	6a 28                	push   $0x28
  8015c5:	e8 8a fa ff ff       	call   801054 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	51                   	push   %ecx
  8015de:	ff 75 10             	pushl  0x10(%ebp)
  8015e1:	52                   	push   %edx
  8015e2:	50                   	push   %eax
  8015e3:	6a 29                	push   $0x29
  8015e5:	e8 6a fa ff ff       	call   801054 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	ff 75 10             	pushl  0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	6a 12                	push   $0x12
  801601:	e8 4e fa ff ff       	call   801054 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
	return ;
  801609:	90                   	nop
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80160f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	52                   	push   %edx
  80161c:	50                   	push   %eax
  80161d:	6a 2a                	push   $0x2a
  80161f:	e8 30 fa ff ff       	call   801054 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	50                   	push   %eax
  801639:	6a 2b                	push   $0x2b
  80163b:	e8 14 fa ff ff       	call   801054 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	ff 75 08             	pushl  0x8(%ebp)
  801654:	6a 2c                	push   $0x2c
  801656:	e8 f9 f9 ff ff       	call   801054 <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
	return;
  80165e:	90                   	nop
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 2d                	push   $0x2d
  801672:	e8 dd f9 ff ff       	call   801054 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801683:	8d 45 10             	lea    0x10(%ebp),%eax
  801686:	83 c0 04             	add    $0x4,%eax
  801689:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80168c:	a1 24 30 80 00       	mov    0x803024,%eax
  801691:	85 c0                	test   %eax,%eax
  801693:	74 16                	je     8016ab <_panic+0x2e>
		cprintf("%s: ", argv0);
  801695:	a1 24 30 80 00       	mov    0x803024,%eax
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	50                   	push   %eax
  80169e:	68 98 1f 80 00       	push   $0x801f98
  8016a3:	e8 12 ec ff ff       	call   8002ba <cprintf>
  8016a8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016ab:	a1 00 30 80 00       	mov    0x803000,%eax
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	50                   	push   %eax
  8016b7:	68 9d 1f 80 00       	push   $0x801f9d
  8016bc:	e8 f9 eb ff ff       	call   8002ba <cprintf>
  8016c1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8016cd:	50                   	push   %eax
  8016ce:	e8 7c eb ff ff       	call   80024f <vcprintf>
  8016d3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	6a 00                	push   $0x0
  8016db:	68 b9 1f 80 00       	push   $0x801fb9
  8016e0:	e8 6a eb ff ff       	call   80024f <vcprintf>
  8016e5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016e8:	e8 eb ea ff ff       	call   8001d8 <exit>

	// should not return here
	while (1) ;
  8016ed:	eb fe                	jmp    8016ed <_panic+0x70>

008016ef <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8016fa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	39 c2                	cmp    %eax,%edx
  801705:	74 14                	je     80171b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801707:	83 ec 04             	sub    $0x4,%esp
  80170a:	68 bc 1f 80 00       	push   $0x801fbc
  80170f:	6a 26                	push   $0x26
  801711:	68 08 20 80 00       	push   $0x802008
  801716:	e8 62 ff ff ff       	call   80167d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80171b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801722:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801729:	e9 c5 00 00 00       	jmp    8017f3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	01 d0                	add    %edx,%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	85 c0                	test   %eax,%eax
  801741:	75 08                	jne    80174b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801743:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801746:	e9 a5 00 00 00       	jmp    8017f0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80174b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801752:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801759:	eb 69                	jmp    8017c4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80175b:	a1 04 30 80 00       	mov    0x803004,%eax
  801760:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801766:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801769:	89 d0                	mov    %edx,%eax
  80176b:	01 c0                	add    %eax,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	c1 e0 03             	shl    $0x3,%eax
  801772:	01 c8                	add    %ecx,%eax
  801774:	8a 40 04             	mov    0x4(%eax),%al
  801777:	84 c0                	test   %al,%al
  801779:	75 46                	jne    8017c1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80177b:	a1 04 30 80 00       	mov    0x803004,%eax
  801780:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801786:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801789:	89 d0                	mov    %edx,%eax
  80178b:	01 c0                	add    %eax,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	c1 e0 03             	shl    $0x3,%eax
  801792:	01 c8                	add    %ecx,%eax
  801794:	8b 00                	mov    (%eax),%eax
  801796:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801799:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80179c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	01 c8                	add    %ecx,%eax
  8017b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017b4:	39 c2                	cmp    %eax,%edx
  8017b6:	75 09                	jne    8017c1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017bf:	eb 15                	jmp    8017d6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017c1:	ff 45 e8             	incl   -0x18(%ebp)
  8017c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8017c9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d2:	39 c2                	cmp    %eax,%edx
  8017d4:	77 85                	ja     80175b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017da:	75 14                	jne    8017f0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 14 20 80 00       	push   $0x802014
  8017e4:	6a 3a                	push   $0x3a
  8017e6:	68 08 20 80 00       	push   $0x802008
  8017eb:	e8 8d fe ff ff       	call   80167d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8017f0:	ff 45 f0             	incl   -0x10(%ebp)
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017f9:	0f 8c 2f ff ff ff    	jl     80172e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801806:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80180d:	eb 26                	jmp    801835 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80180f:	a1 04 30 80 00       	mov    0x803004,%eax
  801814:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80181a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80181d:	89 d0                	mov    %edx,%eax
  80181f:	01 c0                	add    %eax,%eax
  801821:	01 d0                	add    %edx,%eax
  801823:	c1 e0 03             	shl    $0x3,%eax
  801826:	01 c8                	add    %ecx,%eax
  801828:	8a 40 04             	mov    0x4(%eax),%al
  80182b:	3c 01                	cmp    $0x1,%al
  80182d:	75 03                	jne    801832 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80182f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801832:	ff 45 e0             	incl   -0x20(%ebp)
  801835:	a1 04 30 80 00       	mov    0x803004,%eax
  80183a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801843:	39 c2                	cmp    %eax,%edx
  801845:	77 c8                	ja     80180f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80184d:	74 14                	je     801863 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	68 68 20 80 00       	push   $0x802068
  801857:	6a 44                	push   $0x44
  801859:	68 08 20 80 00       	push   $0x802008
  80185e:	e8 1a fe ff ff       	call   80167d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801863:	90                   	nop
  801864:	c9                   	leave  
  801865:	c3                   	ret    
  801866:	66 90                	xchg   %ax,%ax

00801868 <__udivdi3>:
  801868:	55                   	push   %ebp
  801869:	57                   	push   %edi
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
  80186c:	83 ec 1c             	sub    $0x1c,%esp
  80186f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801873:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80187b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187f:	89 ca                	mov    %ecx,%edx
  801881:	89 f8                	mov    %edi,%eax
  801883:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801887:	85 f6                	test   %esi,%esi
  801889:	75 2d                	jne    8018b8 <__udivdi3+0x50>
  80188b:	39 cf                	cmp    %ecx,%edi
  80188d:	77 65                	ja     8018f4 <__udivdi3+0x8c>
  80188f:	89 fd                	mov    %edi,%ebp
  801891:	85 ff                	test   %edi,%edi
  801893:	75 0b                	jne    8018a0 <__udivdi3+0x38>
  801895:	b8 01 00 00 00       	mov    $0x1,%eax
  80189a:	31 d2                	xor    %edx,%edx
  80189c:	f7 f7                	div    %edi
  80189e:	89 c5                	mov    %eax,%ebp
  8018a0:	31 d2                	xor    %edx,%edx
  8018a2:	89 c8                	mov    %ecx,%eax
  8018a4:	f7 f5                	div    %ebp
  8018a6:	89 c1                	mov    %eax,%ecx
  8018a8:	89 d8                	mov    %ebx,%eax
  8018aa:	f7 f5                	div    %ebp
  8018ac:	89 cf                	mov    %ecx,%edi
  8018ae:	89 fa                	mov    %edi,%edx
  8018b0:	83 c4 1c             	add    $0x1c,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5f                   	pop    %edi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    
  8018b8:	39 ce                	cmp    %ecx,%esi
  8018ba:	77 28                	ja     8018e4 <__udivdi3+0x7c>
  8018bc:	0f bd fe             	bsr    %esi,%edi
  8018bf:	83 f7 1f             	xor    $0x1f,%edi
  8018c2:	75 40                	jne    801904 <__udivdi3+0x9c>
  8018c4:	39 ce                	cmp    %ecx,%esi
  8018c6:	72 0a                	jb     8018d2 <__udivdi3+0x6a>
  8018c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018cc:	0f 87 9e 00 00 00    	ja     801970 <__udivdi3+0x108>
  8018d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d7:	89 fa                	mov    %edi,%edx
  8018d9:	83 c4 1c             	add    $0x1c,%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5f                   	pop    %edi
  8018df:	5d                   	pop    %ebp
  8018e0:	c3                   	ret    
  8018e1:	8d 76 00             	lea    0x0(%esi),%esi
  8018e4:	31 ff                	xor    %edi,%edi
  8018e6:	31 c0                	xor    %eax,%eax
  8018e8:	89 fa                	mov    %edi,%edx
  8018ea:	83 c4 1c             	add    $0x1c,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
  8018f2:	66 90                	xchg   %ax,%ax
  8018f4:	89 d8                	mov    %ebx,%eax
  8018f6:	f7 f7                	div    %edi
  8018f8:	31 ff                	xor    %edi,%edi
  8018fa:	89 fa                	mov    %edi,%edx
  8018fc:	83 c4 1c             	add    $0x1c,%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5f                   	pop    %edi
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    
  801904:	bd 20 00 00 00       	mov    $0x20,%ebp
  801909:	89 eb                	mov    %ebp,%ebx
  80190b:	29 fb                	sub    %edi,%ebx
  80190d:	89 f9                	mov    %edi,%ecx
  80190f:	d3 e6                	shl    %cl,%esi
  801911:	89 c5                	mov    %eax,%ebp
  801913:	88 d9                	mov    %bl,%cl
  801915:	d3 ed                	shr    %cl,%ebp
  801917:	89 e9                	mov    %ebp,%ecx
  801919:	09 f1                	or     %esi,%ecx
  80191b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80191f:	89 f9                	mov    %edi,%ecx
  801921:	d3 e0                	shl    %cl,%eax
  801923:	89 c5                	mov    %eax,%ebp
  801925:	89 d6                	mov    %edx,%esi
  801927:	88 d9                	mov    %bl,%cl
  801929:	d3 ee                	shr    %cl,%esi
  80192b:	89 f9                	mov    %edi,%ecx
  80192d:	d3 e2                	shl    %cl,%edx
  80192f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801933:	88 d9                	mov    %bl,%cl
  801935:	d3 e8                	shr    %cl,%eax
  801937:	09 c2                	or     %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	89 f2                	mov    %esi,%edx
  80193d:	f7 74 24 0c          	divl   0xc(%esp)
  801941:	89 d6                	mov    %edx,%esi
  801943:	89 c3                	mov    %eax,%ebx
  801945:	f7 e5                	mul    %ebp
  801947:	39 d6                	cmp    %edx,%esi
  801949:	72 19                	jb     801964 <__udivdi3+0xfc>
  80194b:	74 0b                	je     801958 <__udivdi3+0xf0>
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	31 ff                	xor    %edi,%edi
  801951:	e9 58 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  801956:	66 90                	xchg   %ax,%ax
  801958:	8b 54 24 08          	mov    0x8(%esp),%edx
  80195c:	89 f9                	mov    %edi,%ecx
  80195e:	d3 e2                	shl    %cl,%edx
  801960:	39 c2                	cmp    %eax,%edx
  801962:	73 e9                	jae    80194d <__udivdi3+0xe5>
  801964:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801967:	31 ff                	xor    %edi,%edi
  801969:	e9 40 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  80196e:	66 90                	xchg   %ax,%ax
  801970:	31 c0                	xor    %eax,%eax
  801972:	e9 37 ff ff ff       	jmp    8018ae <__udivdi3+0x46>
  801977:	90                   	nop

00801978 <__umoddi3>:
  801978:	55                   	push   %ebp
  801979:	57                   	push   %edi
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801983:	8b 74 24 34          	mov    0x34(%esp),%esi
  801987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80198b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80198f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801993:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801997:	89 f3                	mov    %esi,%ebx
  801999:	89 fa                	mov    %edi,%edx
  80199b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199f:	89 34 24             	mov    %esi,(%esp)
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	75 1a                	jne    8019c0 <__umoddi3+0x48>
  8019a6:	39 f7                	cmp    %esi,%edi
  8019a8:	0f 86 a2 00 00 00    	jbe    801a50 <__umoddi3+0xd8>
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	89 f2                	mov    %esi,%edx
  8019b2:	f7 f7                	div    %edi
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	31 d2                	xor    %edx,%edx
  8019b8:	83 c4 1c             	add    $0x1c,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5f                   	pop    %edi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    
  8019c0:	39 f0                	cmp    %esi,%eax
  8019c2:	0f 87 ac 00 00 00    	ja     801a74 <__umoddi3+0xfc>
  8019c8:	0f bd e8             	bsr    %eax,%ebp
  8019cb:	83 f5 1f             	xor    $0x1f,%ebp
  8019ce:	0f 84 ac 00 00 00    	je     801a80 <__umoddi3+0x108>
  8019d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019d9:	29 ef                	sub    %ebp,%edi
  8019db:	89 fe                	mov    %edi,%esi
  8019dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019e1:	89 e9                	mov    %ebp,%ecx
  8019e3:	d3 e0                	shl    %cl,%eax
  8019e5:	89 d7                	mov    %edx,%edi
  8019e7:	89 f1                	mov    %esi,%ecx
  8019e9:	d3 ef                	shr    %cl,%edi
  8019eb:	09 c7                	or     %eax,%edi
  8019ed:	89 e9                	mov    %ebp,%ecx
  8019ef:	d3 e2                	shl    %cl,%edx
  8019f1:	89 14 24             	mov    %edx,(%esp)
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	d3 e0                	shl    %cl,%eax
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019fe:	d3 e0                	shl    %cl,%eax
  801a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a08:	89 f1                	mov    %esi,%ecx
  801a0a:	d3 e8                	shr    %cl,%eax
  801a0c:	09 d0                	or     %edx,%eax
  801a0e:	d3 eb                	shr    %cl,%ebx
  801a10:	89 da                	mov    %ebx,%edx
  801a12:	f7 f7                	div    %edi
  801a14:	89 d3                	mov    %edx,%ebx
  801a16:	f7 24 24             	mull   (%esp)
  801a19:	89 c6                	mov    %eax,%esi
  801a1b:	89 d1                	mov    %edx,%ecx
  801a1d:	39 d3                	cmp    %edx,%ebx
  801a1f:	0f 82 87 00 00 00    	jb     801aac <__umoddi3+0x134>
  801a25:	0f 84 91 00 00 00    	je     801abc <__umoddi3+0x144>
  801a2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a2f:	29 f2                	sub    %esi,%edx
  801a31:	19 cb                	sbb    %ecx,%ebx
  801a33:	89 d8                	mov    %ebx,%eax
  801a35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 e9                	mov    %ebp,%ecx
  801a3d:	d3 ea                	shr    %cl,%edx
  801a3f:	09 d0                	or     %edx,%eax
  801a41:	89 e9                	mov    %ebp,%ecx
  801a43:	d3 eb                	shr    %cl,%ebx
  801a45:	89 da                	mov    %ebx,%edx
  801a47:	83 c4 1c             	add    $0x1c,%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5f                   	pop    %edi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    
  801a4f:	90                   	nop
  801a50:	89 fd                	mov    %edi,%ebp
  801a52:	85 ff                	test   %edi,%edi
  801a54:	75 0b                	jne    801a61 <__umoddi3+0xe9>
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5b:	31 d2                	xor    %edx,%edx
  801a5d:	f7 f7                	div    %edi
  801a5f:	89 c5                	mov    %eax,%ebp
  801a61:	89 f0                	mov    %esi,%eax
  801a63:	31 d2                	xor    %edx,%edx
  801a65:	f7 f5                	div    %ebp
  801a67:	89 c8                	mov    %ecx,%eax
  801a69:	f7 f5                	div    %ebp
  801a6b:	89 d0                	mov    %edx,%eax
  801a6d:	e9 44 ff ff ff       	jmp    8019b6 <__umoddi3+0x3e>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	89 c8                	mov    %ecx,%eax
  801a76:	89 f2                	mov    %esi,%edx
  801a78:	83 c4 1c             	add    $0x1c,%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    
  801a80:	3b 04 24             	cmp    (%esp),%eax
  801a83:	72 06                	jb     801a8b <__umoddi3+0x113>
  801a85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a89:	77 0f                	ja     801a9a <__umoddi3+0x122>
  801a8b:	89 f2                	mov    %esi,%edx
  801a8d:	29 f9                	sub    %edi,%ecx
  801a8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a93:	89 14 24             	mov    %edx,(%esp)
  801a96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a9e:	8b 14 24             	mov    (%esp),%edx
  801aa1:	83 c4 1c             	add    $0x1c,%esp
  801aa4:	5b                   	pop    %ebx
  801aa5:	5e                   	pop    %esi
  801aa6:	5f                   	pop    %edi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    
  801aa9:	8d 76 00             	lea    0x0(%esi),%esi
  801aac:	2b 04 24             	sub    (%esp),%eax
  801aaf:	19 fa                	sbb    %edi,%edx
  801ab1:	89 d1                	mov    %edx,%ecx
  801ab3:	89 c6                	mov    %eax,%esi
  801ab5:	e9 71 ff ff ff       	jmp    801a2b <__umoddi3+0xb3>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ac0:	72 ea                	jb     801aac <__umoddi3+0x134>
  801ac2:	89 d9                	mov    %ebx,%ecx
  801ac4:	e9 62 ff ff ff       	jmp    801a2b <__umoddi3+0xb3>
