
obj/user/dummy_process:     file format elf32-i386


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
  800031:	e8 8d 00 00 00       	call   8000c3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void high_complexity_function();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	high_complexity_function() ;
  80003e:	e8 03 00 00 00       	call   800046 <high_complexity_function>
	return;
  800043:	90                   	nop
}
  800044:	c9                   	leave  
  800045:	c3                   	ret    

00800046 <high_complexity_function>:

void high_complexity_function()
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 38             	sub    $0x38,%esp
	uint32 end1 = RAND(0, 5000);
  80004c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	50                   	push   %eax
  800053:	e8 45 13 00 00       	call   80139d <sys_get_virtual_time>
  800058:	83 c4 0c             	add    $0xc,%esp
  80005b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80005e:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800063:	ba 00 00 00 00       	mov    $0x0,%edx
  800068:	f7 f1                	div    %ecx
  80006a:	89 55 e8             	mov    %edx,-0x18(%ebp)
	uint32 end2 = RAND(0, 5000);
  80006d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	50                   	push   %eax
  800074:	e8 24 13 00 00       	call   80139d <sys_get_virtual_time>
  800079:	83 c4 0c             	add    $0xc,%esp
  80007c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80007f:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800084:	ba 00 00 00 00       	mov    $0x0,%edx
  800089:	f7 f1                	div    %ecx
  80008b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int x = 10;
  80008e:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)
	for(int i = 0; i <= end1; i++)
  800095:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80009c:	eb 1a                	jmp    8000b8 <high_complexity_function+0x72>
	{
		for(int i = 0; i <= end2; i++)
  80009e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000a5:	eb 06                	jmp    8000ad <high_complexity_function+0x67>
		{
			{
				 x++;
  8000a7:	ff 45 f4             	incl   -0xc(%ebp)
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
	{
		for(int i = 0; i <= end2; i++)
  8000aa:	ff 45 ec             	incl   -0x14(%ebp)
  8000ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b3:	76 f2                	jbe    8000a7 <high_complexity_function+0x61>
void high_complexity_function()
{
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
  8000b5:	ff 45 f0             	incl   -0x10(%ebp)
  8000b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000bb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8000be:	76 de                	jbe    80009e <high_complexity_function+0x58>
			{
				 x++;
			}
		}
	}
}
  8000c0:	90                   	nop
  8000c1:	c9                   	leave  
  8000c2:	c3                   	ret    

008000c3 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c9:	e8 83 12 00 00       	call   801351 <sys_getenvindex>
  8000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d4:	89 d0                	mov    %edx,%eax
  8000d6:	c1 e0 02             	shl    $0x2,%eax
  8000d9:	01 d0                	add    %edx,%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	01 d0                	add    %edx,%eax
  8000df:	c1 e0 02             	shl    $0x2,%eax
  8000e2:	01 d0                	add    %edx,%eax
  8000e4:	01 c0                	add    %eax,%eax
  8000e6:	01 d0                	add    %edx,%eax
  8000e8:	c1 e0 04             	shl    $0x4,%eax
  8000eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f0:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fa:	8a 40 20             	mov    0x20(%eax),%al
  8000fd:	84 c0                	test   %al,%al
  8000ff:	74 0d                	je     80010e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800101:	a1 04 30 80 00       	mov    0x803004,%eax
  800106:	83 c0 20             	add    $0x20,%eax
  800109:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800112:	7e 0a                	jle    80011e <libmain+0x5b>
		binaryname = argv[0];
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	8b 00                	mov    (%eax),%eax
  800119:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80011e:	83 ec 08             	sub    $0x8,%esp
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	e8 0c ff ff ff       	call   800038 <_main>
  80012c:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80012f:	e8 a1 0f 00 00       	call   8010d5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 f8 1a 80 00       	push   $0x801af8
  80013c:	e8 8d 01 00 00       	call   8002ce <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800144:	a1 04 30 80 00       	mov    0x803004,%eax
  800149:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80014f:	a1 04 30 80 00       	mov    0x803004,%eax
  800154:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	52                   	push   %edx
  80015e:	50                   	push   %eax
  80015f:	68 20 1b 80 00       	push   $0x801b20
  800164:	e8 65 01 00 00       	call   8002ce <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016c:	a1 04 30 80 00       	mov    0x803004,%eax
  800171:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800177:	a1 04 30 80 00       	mov    0x803004,%eax
  80017c:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800182:	a1 04 30 80 00       	mov    0x803004,%eax
  800187:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80018d:	51                   	push   %ecx
  80018e:	52                   	push   %edx
  80018f:	50                   	push   %eax
  800190:	68 48 1b 80 00       	push   $0x801b48
  800195:	e8 34 01 00 00       	call   8002ce <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019d:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a2:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001a8:	83 ec 08             	sub    $0x8,%esp
  8001ab:	50                   	push   %eax
  8001ac:	68 a0 1b 80 00       	push   $0x801ba0
  8001b1:	e8 18 01 00 00       	call   8002ce <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 f8 1a 80 00       	push   $0x801af8
  8001c1:	e8 08 01 00 00       	call   8002ce <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001c9:	e8 21 0f 00 00       	call   8010ef <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001ce:	e8 19 00 00 00       	call   8001ec <exit>
}
  8001d3:	90                   	nop
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    

008001d6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	6a 00                	push   $0x0
  8001e1:	e8 37 11 00 00       	call   80131d <sys_destroy_env>
  8001e6:	83 c4 10             	add    $0x10,%esp
}
  8001e9:	90                   	nop
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <exit>:

void
exit(void)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f2:	e8 8c 11 00 00       	call   801383 <sys_exit_env>
}
  8001f7:	90                   	nop
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    

008001fa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800200:	8b 45 0c             	mov    0xc(%ebp),%eax
  800203:	8b 00                	mov    (%eax),%eax
  800205:	8d 48 01             	lea    0x1(%eax),%ecx
  800208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020b:	89 0a                	mov    %ecx,(%edx)
  80020d:	8b 55 08             	mov    0x8(%ebp),%edx
  800210:	88 d1                	mov    %dl,%cl
  800212:	8b 55 0c             	mov    0xc(%ebp),%edx
  800215:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021c:	8b 00                	mov    (%eax),%eax
  80021e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800223:	75 2c                	jne    800251 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800225:	a0 08 30 80 00       	mov    0x803008,%al
  80022a:	0f b6 c0             	movzbl %al,%eax
  80022d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800230:	8b 12                	mov    (%edx),%edx
  800232:	89 d1                	mov    %edx,%ecx
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	83 c2 08             	add    $0x8,%edx
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	50                   	push   %eax
  80023e:	51                   	push   %ecx
  80023f:	52                   	push   %edx
  800240:	e8 4e 0e 00 00       	call   801093 <sys_cputs>
  800245:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800251:	8b 45 0c             	mov    0xc(%ebp),%eax
  800254:	8b 40 04             	mov    0x4(%eax),%eax
  800257:	8d 50 01             	lea    0x1(%eax),%edx
  80025a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800273:	00 00 00 
	b.cnt = 0;
  800276:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800280:	ff 75 0c             	pushl  0xc(%ebp)
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	68 fa 01 80 00       	push   $0x8001fa
  800292:	e8 11 02 00 00       	call   8004a8 <vprintfmt>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80029a:	a0 08 30 80 00       	mov    0x803008,%al
  80029f:	0f b6 c0             	movzbl %al,%eax
  8002a2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	50                   	push   %eax
  8002ac:	52                   	push   %edx
  8002ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b3:	83 c0 08             	add    $0x8,%eax
  8002b6:	50                   	push   %eax
  8002b7:	e8 d7 0d 00 00       	call   801093 <sys_cputs>
  8002bc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002bf:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002d4:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ea:	50                   	push   %eax
  8002eb:	e8 73 ff ff ff       	call   800263 <vcprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800301:	e8 cf 0d 00 00       	call   8010d5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800306:	8d 45 0c             	lea    0xc(%ebp),%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	ff 75 f4             	pushl  -0xc(%ebp)
  800315:	50                   	push   %eax
  800316:	e8 48 ff ff ff       	call   800263 <vcprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800321:	e8 c9 0d 00 00       	call   8010ef <sys_unlock_cons>
	return cnt;
  800326:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	53                   	push   %ebx
  80032f:	83 ec 14             	sub    $0x14,%esp
  800332:	8b 45 10             	mov    0x10(%ebp),%eax
  800335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800338:	8b 45 14             	mov    0x14(%ebp),%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033e:	8b 45 18             	mov    0x18(%ebp),%eax
  800341:	ba 00 00 00 00       	mov    $0x0,%edx
  800346:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800349:	77 55                	ja     8003a0 <printnum+0x75>
  80034b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034e:	72 05                	jb     800355 <printnum+0x2a>
  800350:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800353:	77 4b                	ja     8003a0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800355:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800358:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035b:	8b 45 18             	mov    0x18(%ebp),%eax
  80035e:	ba 00 00 00 00       	mov    $0x0,%edx
  800363:	52                   	push   %edx
  800364:	50                   	push   %eax
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 f0             	pushl  -0x10(%ebp)
  80036b:	e8 0c 15 00 00       	call   80187c <__udivdi3>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	83 ec 04             	sub    $0x4,%esp
  800376:	ff 75 20             	pushl  0x20(%ebp)
  800379:	53                   	push   %ebx
  80037a:	ff 75 18             	pushl  0x18(%ebp)
  80037d:	52                   	push   %edx
  80037e:	50                   	push   %eax
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	e8 a1 ff ff ff       	call   80032b <printnum>
  80038a:	83 c4 20             	add    $0x20,%esp
  80038d:	eb 1a                	jmp    8003a9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038f:	83 ec 08             	sub    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	ff 75 20             	pushl  0x20(%ebp)
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
  80039b:	ff d0                	call   *%eax
  80039d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a0:	ff 4d 1c             	decl   0x1c(%ebp)
  8003a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a7:	7f e6                	jg     80038f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b7:	53                   	push   %ebx
  8003b8:	51                   	push   %ecx
  8003b9:	52                   	push   %edx
  8003ba:	50                   	push   %eax
  8003bb:	e8 cc 15 00 00       	call   80198c <__umoddi3>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	05 d4 1d 80 00       	add    $0x801dd4,%eax
  8003c8:	8a 00                	mov    (%eax),%al
  8003ca:	0f be c0             	movsbl %al,%eax
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	50                   	push   %eax
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	ff d0                	call   *%eax
  8003d9:	83 c4 10             	add    $0x10,%esp
}
  8003dc:	90                   	nop
  8003dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e9:	7e 1c                	jle    800407 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	8d 50 08             	lea    0x8(%eax),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	89 10                	mov    %edx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	83 e8 08             	sub    $0x8,%eax
  800400:	8b 50 04             	mov    0x4(%eax),%edx
  800403:	8b 00                	mov    (%eax),%eax
  800405:	eb 40                	jmp    800447 <getuint+0x65>
	else if (lflag)
  800407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040b:	74 1e                	je     80042b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	8d 50 04             	lea    0x4(%eax),%edx
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	89 10                	mov    %edx,(%eax)
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	83 e8 04             	sub    $0x4,%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	eb 1c                	jmp    800447 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	8d 50 04             	lea    0x4(%eax),%edx
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	89 10                	mov    %edx,(%eax)
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	83 e8 04             	sub    $0x4,%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800450:	7e 1c                	jle    80046e <getint+0x25>
		return va_arg(*ap, long long);
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	8d 50 08             	lea    0x8(%eax),%edx
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 10                	mov    %edx,(%eax)
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 e8 08             	sub    $0x8,%eax
  800467:	8b 50 04             	mov    0x4(%eax),%edx
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	eb 38                	jmp    8004a6 <getint+0x5d>
	else if (lflag)
  80046e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800472:	74 1a                	je     80048e <getint+0x45>
		return va_arg(*ap, long);
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	8d 50 04             	lea    0x4(%eax),%edx
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	89 10                	mov    %edx,(%eax)
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	83 e8 04             	sub    $0x4,%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	99                   	cltd   
  80048c:	eb 18                	jmp    8004a6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	8d 50 04             	lea    0x4(%eax),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 10                	mov    %edx,(%eax)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 e8 04             	sub    $0x4,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	99                   	cltd   
}
  8004a6:	5d                   	pop    %ebp
  8004a7:	c3                   	ret    

008004a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
  8004ab:	56                   	push   %esi
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b0:	eb 17                	jmp    8004c9 <vprintfmt+0x21>
			if (ch == '\0')
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	0f 84 c1 03 00 00    	je     80087b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	53                   	push   %ebx
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	ff d0                	call   *%eax
  8004c6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cc:	8d 50 01             	lea    0x1(%eax),%edx
  8004cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d2:	8a 00                	mov    (%eax),%al
  8004d4:	0f b6 d8             	movzbl %al,%ebx
  8004d7:	83 fb 25             	cmp    $0x25,%ebx
  8004da:	75 d6                	jne    8004b2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004dc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ff:	8d 50 01             	lea    0x1(%eax),%edx
  800502:	89 55 10             	mov    %edx,0x10(%ebp)
  800505:	8a 00                	mov    (%eax),%al
  800507:	0f b6 d8             	movzbl %al,%ebx
  80050a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80050d:	83 f8 5b             	cmp    $0x5b,%eax
  800510:	0f 87 3d 03 00 00    	ja     800853 <vprintfmt+0x3ab>
  800516:	8b 04 85 f8 1d 80 00 	mov    0x801df8(,%eax,4),%eax
  80051d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80051f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800523:	eb d7                	jmp    8004fc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800525:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800529:	eb d1                	jmp    8004fc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800535:	89 d0                	mov    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	01 c0                	add    %eax,%eax
  80053e:	01 d8                	add    %ebx,%eax
  800540:	83 e8 30             	sub    $0x30,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	8a 00                	mov    (%eax),%al
  80054b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80054e:	83 fb 2f             	cmp    $0x2f,%ebx
  800551:	7e 3e                	jle    800591 <vprintfmt+0xe9>
  800553:	83 fb 39             	cmp    $0x39,%ebx
  800556:	7f 39                	jg     800591 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800558:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80055b:	eb d5                	jmp    800532 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	83 e8 04             	sub    $0x4,%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800571:	eb 1f                	jmp    800592 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800573:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800577:	79 83                	jns    8004fc <vprintfmt+0x54>
				width = 0;
  800579:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800580:	e9 77 ff ff ff       	jmp    8004fc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800585:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80058c:	e9 6b ff ff ff       	jmp    8004fc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800591:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800592:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800596:	0f 89 60 ff ff ff    	jns    8004fc <vprintfmt+0x54>
				width = precision, precision = -1;
  80059c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005a9:	e9 4e ff ff ff       	jmp    8004fc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ae:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b1:	e9 46 ff ff ff       	jmp    8004fc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	83 c0 04             	add    $0x4,%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	83 e8 04             	sub    $0x4,%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 0c             	pushl  0xc(%ebp)
  8005cd:	50                   	push   %eax
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	ff d0                	call   *%eax
  8005d3:	83 c4 10             	add    $0x10,%esp
			break;
  8005d6:	e9 9b 02 00 00       	jmp    800876 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 c0 04             	add    $0x4,%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	83 e8 04             	sub    $0x4,%eax
  8005ea:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005ec:	85 db                	test   %ebx,%ebx
  8005ee:	79 02                	jns    8005f2 <vprintfmt+0x14a>
				err = -err;
  8005f0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005f2:	83 fb 64             	cmp    $0x64,%ebx
  8005f5:	7f 0b                	jg     800602 <vprintfmt+0x15a>
  8005f7:	8b 34 9d 40 1c 80 00 	mov    0x801c40(,%ebx,4),%esi
  8005fe:	85 f6                	test   %esi,%esi
  800600:	75 19                	jne    80061b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800602:	53                   	push   %ebx
  800603:	68 e5 1d 80 00       	push   $0x801de5
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 70 02 00 00       	call   800883 <printfmt>
  800613:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800616:	e9 5b 02 00 00       	jmp    800876 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061b:	56                   	push   %esi
  80061c:	68 ee 1d 80 00       	push   $0x801dee
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	ff 75 08             	pushl  0x8(%ebp)
  800627:	e8 57 02 00 00       	call   800883 <printfmt>
  80062c:	83 c4 10             	add    $0x10,%esp
			break;
  80062f:	e9 42 02 00 00       	jmp    800876 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	83 c0 04             	add    $0x4,%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	83 e8 04             	sub    $0x4,%eax
  800643:	8b 30                	mov    (%eax),%esi
  800645:	85 f6                	test   %esi,%esi
  800647:	75 05                	jne    80064e <vprintfmt+0x1a6>
				p = "(null)";
  800649:	be f1 1d 80 00       	mov    $0x801df1,%esi
			if (width > 0 && padc != '-')
  80064e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800652:	7e 6d                	jle    8006c1 <vprintfmt+0x219>
  800654:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800658:	74 67                	je     8006c1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	50                   	push   %eax
  800661:	56                   	push   %esi
  800662:	e8 1e 03 00 00       	call   800985 <strnlen>
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80066d:	eb 16                	jmp    800685 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80066f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	ff d0                	call   *%eax
  80067f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800682:	ff 4d e4             	decl   -0x1c(%ebp)
  800685:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800689:	7f e4                	jg     80066f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068b:	eb 34                	jmp    8006c1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80068d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800691:	74 1c                	je     8006af <vprintfmt+0x207>
  800693:	83 fb 1f             	cmp    $0x1f,%ebx
  800696:	7e 05                	jle    80069d <vprintfmt+0x1f5>
  800698:	83 fb 7e             	cmp    $0x7e,%ebx
  80069b:	7e 12                	jle    8006af <vprintfmt+0x207>
					putch('?', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	6a 3f                	push   $0x3f
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	ff d0                	call   *%eax
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	eb 0f                	jmp    8006be <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	53                   	push   %ebx
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	ff d0                	call   *%eax
  8006bb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006be:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c1:	89 f0                	mov    %esi,%eax
  8006c3:	8d 70 01             	lea    0x1(%eax),%esi
  8006c6:	8a 00                	mov    (%eax),%al
  8006c8:	0f be d8             	movsbl %al,%ebx
  8006cb:	85 db                	test   %ebx,%ebx
  8006cd:	74 24                	je     8006f3 <vprintfmt+0x24b>
  8006cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d3:	78 b8                	js     80068d <vprintfmt+0x1e5>
  8006d5:	ff 4d e0             	decl   -0x20(%ebp)
  8006d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006dc:	79 af                	jns    80068d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006de:	eb 13                	jmp    8006f3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	6a 20                	push   $0x20
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f7:	7f e7                	jg     8006e0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006f9:	e9 78 01 00 00       	jmp    800876 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 e8             	pushl  -0x18(%ebp)
  800704:	8d 45 14             	lea    0x14(%ebp),%eax
  800707:	50                   	push   %eax
  800708:	e8 3c fd ff ff       	call   800449 <getint>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800713:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071c:	85 d2                	test   %edx,%edx
  80071e:	79 23                	jns    800743 <vprintfmt+0x29b>
				putch('-', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 2d                	push   $0x2d
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800736:	f7 d8                	neg    %eax
  800738:	83 d2 00             	adc    $0x0,%edx
  80073b:	f7 da                	neg    %edx
  80073d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800740:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800743:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074a:	e9 bc 00 00 00       	jmp    80080b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	ff 75 e8             	pushl  -0x18(%ebp)
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
  800758:	50                   	push   %eax
  800759:	e8 84 fc ff ff       	call   8003e2 <getuint>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800764:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800767:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076e:	e9 98 00 00 00       	jmp    80080b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	6a 58                	push   $0x58
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	ff d0                	call   *%eax
  800780:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	6a 58                	push   $0x58
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	ff d0                	call   *%eax
  800790:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	6a 58                	push   $0x58
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	ff d0                	call   *%eax
  8007a0:	83 c4 10             	add    $0x10,%esp
			break;
  8007a3:	e9 ce 00 00 00       	jmp    800876 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	6a 30                	push   $0x30
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	ff d0                	call   *%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	6a 78                	push   $0x78
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	ff d0                	call   *%eax
  8007c5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	83 c0 04             	add    $0x4,%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007e3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ea:	eb 1f                	jmp    80080b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f5:	50                   	push   %eax
  8007f6:	e8 e7 fb ff ff       	call   8003e2 <getuint>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800801:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800804:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80080f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800812:	83 ec 04             	sub    $0x4,%esp
  800815:	52                   	push   %edx
  800816:	ff 75 e4             	pushl  -0x1c(%ebp)
  800819:	50                   	push   %eax
  80081a:	ff 75 f4             	pushl  -0xc(%ebp)
  80081d:	ff 75 f0             	pushl  -0x10(%ebp)
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 00 fb ff ff       	call   80032b <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
			break;
  80082e:	eb 46                	jmp    800876 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
			break;
  80083f:	eb 35                	jmp    800876 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800841:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800848:	eb 2c                	jmp    800876 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80084a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800851:	eb 23                	jmp    800876 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	6a 25                	push   $0x25
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800863:	ff 4d 10             	decl   0x10(%ebp)
  800866:	eb 03                	jmp    80086b <vprintfmt+0x3c3>
  800868:	ff 4d 10             	decl   0x10(%ebp)
  80086b:	8b 45 10             	mov    0x10(%ebp),%eax
  80086e:	48                   	dec    %eax
  80086f:	8a 00                	mov    (%eax),%al
  800871:	3c 25                	cmp    $0x25,%al
  800873:	75 f3                	jne    800868 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800875:	90                   	nop
		}
	}
  800876:	e9 35 fc ff ff       	jmp    8004b0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80087b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80087c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087f:	5b                   	pop    %ebx
  800880:	5e                   	pop    %esi
  800881:	5d                   	pop    %ebp
  800882:	c3                   	ret    

00800883 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800889:	8d 45 10             	lea    0x10(%ebp),%eax
  80088c:	83 c0 04             	add    $0x4,%eax
  80088f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800892:	8b 45 10             	mov    0x10(%ebp),%eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	50                   	push   %eax
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	ff 75 08             	pushl  0x8(%ebp)
  80089f:	e8 04 fc ff ff       	call   8004a8 <vprintfmt>
  8008a4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a7:	90                   	nop
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b0:	8b 40 08             	mov    0x8(%eax),%eax
  8008b3:	8d 50 01             	lea    0x1(%eax),%edx
  8008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 10                	mov    (%eax),%edx
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	8b 40 04             	mov    0x4(%eax),%eax
  8008c7:	39 c2                	cmp    %eax,%edx
  8008c9:	73 12                	jae    8008dd <sprintputch+0x33>
		*b->buf++ = ch;
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d6:	89 0a                	mov    %ecx,(%edx)
  8008d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8008db:	88 10                	mov    %dl,(%eax)
}
  8008dd:	90                   	nop
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800901:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800905:	74 06                	je     80090d <vsnprintf+0x2d>
  800907:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090b:	7f 07                	jg     800914 <vsnprintf+0x34>
		return -E_INVAL;
  80090d:	b8 03 00 00 00       	mov    $0x3,%eax
  800912:	eb 20                	jmp    800934 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800914:	ff 75 14             	pushl  0x14(%ebp)
  800917:	ff 75 10             	pushl  0x10(%ebp)
  80091a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091d:	50                   	push   %eax
  80091e:	68 aa 08 80 00       	push   $0x8008aa
  800923:	e8 80 fb ff ff       	call   8004a8 <vprintfmt>
  800928:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80092b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800931:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800934:	c9                   	leave  
  800935:	c3                   	ret    

00800936 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093c:	8d 45 10             	lea    0x10(%ebp),%eax
  80093f:	83 c0 04             	add    $0x4,%eax
  800942:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800945:	8b 45 10             	mov    0x10(%ebp),%eax
  800948:	ff 75 f4             	pushl  -0xc(%ebp)
  80094b:	50                   	push   %eax
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	ff 75 08             	pushl  0x8(%ebp)
  800952:	e8 89 ff ff ff       	call   8008e0 <vsnprintf>
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80095d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    

00800962 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80096f:	eb 06                	jmp    800977 <strlen+0x15>
		n++;
  800971:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800974:	ff 45 08             	incl   0x8(%ebp)
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	84 c0                	test   %al,%al
  80097e:	75 f1                	jne    800971 <strlen+0xf>
		n++;
	return n;
  800980:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800992:	eb 09                	jmp    80099d <strnlen+0x18>
		n++;
  800994:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800997:	ff 45 08             	incl   0x8(%ebp)
  80099a:	ff 4d 0c             	decl   0xc(%ebp)
  80099d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a1:	74 09                	je     8009ac <strnlen+0x27>
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	84 c0                	test   %al,%al
  8009aa:	75 e8                	jne    800994 <strnlen+0xf>
		n++;
	return n;
  8009ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009bd:	90                   	nop
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8d 50 01             	lea    0x1(%eax),%edx
  8009c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d0:	8a 12                	mov    (%edx),%dl
  8009d2:	88 10                	mov    %dl,(%eax)
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	84 c0                	test   %al,%al
  8009d8:	75 e4                	jne    8009be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f2:	eb 1f                	jmp    800a13 <strncpy+0x34>
		*dst++ = *src;
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8d 50 01             	lea    0x1(%eax),%edx
  8009fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8009fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a00:	8a 12                	mov    (%edx),%dl
  800a02:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8a 00                	mov    (%eax),%al
  800a09:	84 c0                	test   %al,%al
  800a0b:	74 03                	je     800a10 <strncpy+0x31>
			src++;
  800a0d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a10:	ff 45 fc             	incl   -0x4(%ebp)
  800a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a16:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a19:	72 d9                	jb     8009f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a30:	74 30                	je     800a62 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a32:	eb 16                	jmp    800a4a <strlcpy+0x2a>
			*dst++ = *src++;
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8d 50 01             	lea    0x1(%eax),%edx
  800a3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a46:	8a 12                	mov    (%edx),%dl
  800a48:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a4a:	ff 4d 10             	decl   0x10(%ebp)
  800a4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a51:	74 09                	je     800a5c <strlcpy+0x3c>
  800a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a56:	8a 00                	mov    (%eax),%al
  800a58:	84 c0                	test   %al,%al
  800a5a:	75 d8                	jne    800a34 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a62:	8b 55 08             	mov    0x8(%ebp),%edx
  800a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 d0                	mov    %edx,%eax
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a71:	eb 06                	jmp    800a79 <strcmp+0xb>
		p++, q++;
  800a73:	ff 45 08             	incl   0x8(%ebp)
  800a76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8a 00                	mov    (%eax),%al
  800a7e:	84 c0                	test   %al,%al
  800a80:	74 0e                	je     800a90 <strcmp+0x22>
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	8a 10                	mov    (%eax),%dl
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	38 c2                	cmp    %al,%dl
  800a8e:	74 e3                	je     800a73 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	0f b6 d0             	movzbl %al,%edx
  800a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	0f b6 c0             	movzbl %al,%eax
  800aa0:	29 c2                	sub    %eax,%edx
  800aa2:	89 d0                	mov    %edx,%eax
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800aa9:	eb 09                	jmp    800ab4 <strncmp+0xe>
		n--, p++, q++;
  800aab:	ff 4d 10             	decl   0x10(%ebp)
  800aae:	ff 45 08             	incl   0x8(%ebp)
  800ab1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ab4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab8:	74 17                	je     800ad1 <strncmp+0x2b>
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	84 c0                	test   %al,%al
  800ac1:	74 0e                	je     800ad1 <strncmp+0x2b>
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 10                	mov    (%eax),%dl
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	38 c2                	cmp    %al,%dl
  800acf:	74 da                	je     800aab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ad1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad5:	75 07                	jne    800ade <strncmp+0x38>
		return 0;
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	eb 14                	jmp    800af2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	0f b6 d0             	movzbl %al,%edx
  800ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	0f b6 c0             	movzbl %al,%eax
  800aee:	29 c2                	sub    %eax,%edx
  800af0:	89 d0                	mov    %edx,%eax
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b00:	eb 12                	jmp    800b14 <strchr+0x20>
		if (*s == c)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b0a:	75 05                	jne    800b11 <strchr+0x1d>
			return (char *) s;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	eb 11                	jmp    800b22 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 e5                	jne    800b02 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 04             	sub    $0x4,%esp
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b30:	eb 0d                	jmp    800b3f <strfind+0x1b>
		if (*s == c)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b3a:	74 0e                	je     800b4a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b3c:	ff 45 08             	incl   0x8(%ebp)
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8a 00                	mov    (%eax),%al
  800b44:	84 c0                	test   %al,%al
  800b46:	75 ea                	jne    800b32 <strfind+0xe>
  800b48:	eb 01                	jmp    800b4b <strfind+0x27>
		if (*s == c)
			break;
  800b4a:	90                   	nop
	return (char *) s;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b62:	eb 0e                	jmp    800b72 <memset+0x22>
		*p++ = c;
  800b64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b67:	8d 50 01             	lea    0x1(%eax),%edx
  800b6a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b72:	ff 4d f8             	decl   -0x8(%ebp)
  800b75:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b79:	79 e9                	jns    800b64 <memset+0x14>
		*p++ = c;

	return v;
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b92:	eb 16                	jmp    800baa <memcpy+0x2a>
		*d++ = *s++;
  800b94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b97:	8d 50 01             	lea    0x1(%eax),%edx
  800b9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba6:	8a 12                	mov    (%edx),%dl
  800ba8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	75 dd                	jne    800b94 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd4:	73 50                	jae    800c26 <memmove+0x6a>
  800bd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdc:	01 d0                	add    %edx,%eax
  800bde:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800be1:	76 43                	jbe    800c26 <memmove+0x6a>
		s += n;
  800be3:	8b 45 10             	mov    0x10(%ebp),%eax
  800be6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800be9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bef:	eb 10                	jmp    800c01 <memmove+0x45>
			*--d = *--s;
  800bf1:	ff 4d f8             	decl   -0x8(%ebp)
  800bf4:	ff 4d fc             	decl   -0x4(%ebp)
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfa:	8a 10                	mov    (%eax),%dl
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c01:	8b 45 10             	mov    0x10(%ebp),%eax
  800c04:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c07:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	75 e3                	jne    800bf1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c0e:	eb 23                	jmp    800c33 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c13:	8d 50 01             	lea    0x1(%eax),%edx
  800c16:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c1f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c22:	8a 12                	mov    (%edx),%dl
  800c24:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c26:	8b 45 10             	mov    0x10(%ebp),%eax
  800c29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	75 dd                	jne    800c10 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c4a:	eb 2a                	jmp    800c76 <memcmp+0x3e>
		if (*s1 != *s2)
  800c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4f:	8a 10                	mov    (%eax),%dl
  800c51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c54:	8a 00                	mov    (%eax),%al
  800c56:	38 c2                	cmp    %al,%dl
  800c58:	74 16                	je     800c70 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	0f b6 d0             	movzbl %al,%edx
  800c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	0f b6 c0             	movzbl %al,%eax
  800c6a:	29 c2                	sub    %eax,%edx
  800c6c:	89 d0                	mov    %edx,%eax
  800c6e:	eb 18                	jmp    800c88 <memcmp+0x50>
		s1++, s2++;
  800c70:	ff 45 fc             	incl   -0x4(%ebp)
  800c73:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c76:	8b 45 10             	mov    0x10(%ebp),%eax
  800c79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	75 c9                	jne    800c4c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
  800c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c9b:	eb 15                	jmp    800cb2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	0f b6 d0             	movzbl %al,%edx
  800ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca8:	0f b6 c0             	movzbl %al,%eax
  800cab:	39 c2                	cmp    %eax,%edx
  800cad:	74 0d                	je     800cbc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cb8:	72 e3                	jb     800c9d <memfind+0x13>
  800cba:	eb 01                	jmp    800cbd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cbc:	90                   	nop
	return (void *) s;
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ccf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd6:	eb 03                	jmp    800cdb <strtol+0x19>
		s++;
  800cd8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	3c 20                	cmp    $0x20,%al
  800ce2:	74 f4                	je     800cd8 <strtol+0x16>
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	3c 09                	cmp    $0x9,%al
  800ceb:	74 eb                	je     800cd8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	3c 2b                	cmp    $0x2b,%al
  800cf4:	75 05                	jne    800cfb <strtol+0x39>
		s++;
  800cf6:	ff 45 08             	incl   0x8(%ebp)
  800cf9:	eb 13                	jmp    800d0e <strtol+0x4c>
	else if (*s == '-')
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 2d                	cmp    $0x2d,%al
  800d02:	75 0a                	jne    800d0e <strtol+0x4c>
		s++, neg = 1;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d12:	74 06                	je     800d1a <strtol+0x58>
  800d14:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d18:	75 20                	jne    800d3a <strtol+0x78>
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	3c 30                	cmp    $0x30,%al
  800d21:	75 17                	jne    800d3a <strtol+0x78>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	40                   	inc    %eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	3c 78                	cmp    $0x78,%al
  800d2b:	75 0d                	jne    800d3a <strtol+0x78>
		s += 2, base = 16;
  800d2d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d31:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d38:	eb 28                	jmp    800d62 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	75 15                	jne    800d55 <strtol+0x93>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	3c 30                	cmp    $0x30,%al
  800d47:	75 0c                	jne    800d55 <strtol+0x93>
		s++, base = 8;
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d53:	eb 0d                	jmp    800d62 <strtol+0xa0>
	else if (base == 0)
  800d55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d59:	75 07                	jne    800d62 <strtol+0xa0>
		base = 10;
  800d5b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	3c 2f                	cmp    $0x2f,%al
  800d69:	7e 19                	jle    800d84 <strtol+0xc2>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	3c 39                	cmp    $0x39,%al
  800d72:	7f 10                	jg     800d84 <strtol+0xc2>
			dig = *s - '0';
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	0f be c0             	movsbl %al,%eax
  800d7c:	83 e8 30             	sub    $0x30,%eax
  800d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d82:	eb 42                	jmp    800dc6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	3c 60                	cmp    $0x60,%al
  800d8b:	7e 19                	jle    800da6 <strtol+0xe4>
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	3c 7a                	cmp    $0x7a,%al
  800d94:	7f 10                	jg     800da6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	0f be c0             	movsbl %al,%eax
  800d9e:	83 e8 57             	sub    $0x57,%eax
  800da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800da4:	eb 20                	jmp    800dc6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	3c 40                	cmp    $0x40,%al
  800dad:	7e 39                	jle    800de8 <strtol+0x126>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	3c 5a                	cmp    $0x5a,%al
  800db6:	7f 30                	jg     800de8 <strtol+0x126>
			dig = *s - 'A' + 10;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	0f be c0             	movsbl %al,%eax
  800dc0:	83 e8 37             	sub    $0x37,%eax
  800dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dcc:	7d 19                	jge    800de7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd8:	89 c2                	mov    %eax,%edx
  800dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ddd:	01 d0                	add    %edx,%eax
  800ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800de2:	e9 7b ff ff ff       	jmp    800d62 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800de7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	74 08                	je     800df6 <strtol+0x134>
		*endptr = (char *) s;
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dfa:	74 07                	je     800e03 <strtol+0x141>
  800dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dff:	f7 d8                	neg    %eax
  800e01:	eb 03                	jmp    800e06 <strtol+0x144>
  800e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <ltostr>:

void
ltostr(long value, char *str)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e20:	79 13                	jns    800e35 <ltostr+0x2d>
	{
		neg = 1;
  800e22:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e2f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e32:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e3d:	99                   	cltd   
  800e3e:	f7 f9                	idiv   %ecx
  800e40:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e46:	8d 50 01             	lea    0x1(%eax),%edx
  800e49:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4c:	89 c2                	mov    %eax,%edx
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	01 d0                	add    %edx,%eax
  800e53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e56:	83 c2 30             	add    $0x30,%edx
  800e59:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e63:	f7 e9                	imul   %ecx
  800e65:	c1 fa 02             	sar    $0x2,%edx
  800e68:	89 c8                	mov    %ecx,%eax
  800e6a:	c1 f8 1f             	sar    $0x1f,%eax
  800e6d:	29 c2                	sub    %eax,%edx
  800e6f:	89 d0                	mov    %edx,%eax
  800e71:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e78:	75 bb                	jne    800e35 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e84:	48                   	dec    %eax
  800e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e8c:	74 3d                	je     800ecb <ltostr+0xc3>
		start = 1 ;
  800e8e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e95:	eb 34                	jmp    800ecb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	01 d0                	add    %edx,%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	01 c2                	add    %eax,%edx
  800eac:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	01 c8                	add    %ecx,%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	01 c2                	add    %eax,%edx
  800ec0:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ec3:	88 02                	mov    %al,(%edx)
		start++ ;
  800ec5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ece:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed1:	7c c4                	jl     800e97 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ed3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	01 d0                	add    %edx,%eax
  800edb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ede:	90                   	nop
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee7:	ff 75 08             	pushl  0x8(%ebp)
  800eea:	e8 73 fa ff ff       	call   800962 <strlen>
  800eef:	83 c4 04             	add    $0x4,%esp
  800ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	e8 65 fa ff ff       	call   800962 <strlen>
  800efd:	83 c4 04             	add    $0x4,%esp
  800f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f11:	eb 17                	jmp    800f2a <strcconcat+0x49>
		final[s] = str1[s] ;
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8b 45 10             	mov    0x10(%ebp),%eax
  800f19:	01 c2                	add    %eax,%edx
  800f1b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	01 c8                	add    %ecx,%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f27:	ff 45 fc             	incl   -0x4(%ebp)
  800f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f30:	7c e1                	jl     800f13 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f40:	eb 1f                	jmp    800f61 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8d 50 01             	lea    0x1(%eax),%edx
  800f48:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4b:	89 c2                	mov    %eax,%edx
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 c2                	add    %eax,%edx
  800f52:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 c8                	add    %ecx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f5e:	ff 45 f8             	incl   -0x8(%ebp)
  800f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f64:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f67:	7c d9                	jl     800f42 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	c6 00 00             	movb   $0x0,(%eax)
}
  800f74:	90                   	nop
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	8b 00                	mov    (%eax),%eax
  800f88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f9a:	eb 0c                	jmp    800fa8 <strsplit+0x31>
			*string++ = 0;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8d 50 01             	lea    0x1(%eax),%edx
  800fa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	84 c0                	test   %al,%al
  800faf:	74 18                	je     800fc9 <strsplit+0x52>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	0f be c0             	movsbl %al,%eax
  800fb9:	50                   	push   %eax
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	e8 32 fb ff ff       	call   800af4 <strchr>
  800fc2:	83 c4 08             	add    $0x8,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	75 d3                	jne    800f9c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	84 c0                	test   %al,%al
  800fd0:	74 5a                	je     80102c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	8b 00                	mov    (%eax),%eax
  800fd7:	83 f8 0f             	cmp    $0xf,%eax
  800fda:	75 07                	jne    800fe3 <strsplit+0x6c>
		{
			return 0;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	eb 66                	jmp    801049 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fe3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe6:	8b 00                	mov    (%eax),%eax
  800fe8:	8d 48 01             	lea    0x1(%eax),%ecx
  800feb:	8b 55 14             	mov    0x14(%ebp),%edx
  800fee:	89 0a                	mov    %ecx,(%edx)
  800ff0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 c2                	add    %eax,%edx
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801001:	eb 03                	jmp    801006 <strsplit+0x8f>
			string++;
  801003:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	74 8b                	je     800f9a <strsplit+0x23>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	0f be c0             	movsbl %al,%eax
  801017:	50                   	push   %eax
  801018:	ff 75 0c             	pushl  0xc(%ebp)
  80101b:	e8 d4 fa ff ff       	call   800af4 <strchr>
  801020:	83 c4 08             	add    $0x8,%esp
  801023:	85 c0                	test   %eax,%eax
  801025:	74 dc                	je     801003 <strsplit+0x8c>
			string++;
	}
  801027:	e9 6e ff ff ff       	jmp    800f9a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80102c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80102d:	8b 45 14             	mov    0x14(%ebp),%eax
  801030:	8b 00                	mov    (%eax),%eax
  801032:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	01 d0                	add    %edx,%eax
  80103e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801044:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	68 68 1f 80 00       	push   $0x801f68
  801059:	68 3f 01 00 00       	push   $0x13f
  80105e:	68 8a 1f 80 00       	push   $0x801f8a
  801063:	e8 29 06 00 00       	call   801691 <_panic>

00801068 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	53                   	push   %ebx
  80106e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8b 55 0c             	mov    0xc(%ebp),%edx
  801077:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80107a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80107d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801080:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801083:	cd 30                	int    $0x30
  801085:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801088:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5f                   	pop    %edi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80109f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	6a 00                	push   $0x0
  8010a8:	6a 00                	push   $0x0
  8010aa:	52                   	push   %edx
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	50                   	push   %eax
  8010af:	6a 00                	push   $0x0
  8010b1:	e8 b2 ff ff ff       	call   801068 <syscall>
  8010b6:	83 c4 18             	add    $0x18,%esp
}
  8010b9:	90                   	nop
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	6a 00                	push   $0x0
  8010c7:	6a 00                	push   $0x0
  8010c9:	6a 02                	push   $0x2
  8010cb:	e8 98 ff ff ff       	call   801068 <syscall>
  8010d0:	83 c4 18             	add    $0x18,%esp
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010d8:	6a 00                	push   $0x0
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 03                	push   $0x3
  8010e4:	e8 7f ff ff ff       	call   801068 <syscall>
  8010e9:	83 c4 18             	add    $0x18,%esp
}
  8010ec:	90                   	nop
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 04                	push   $0x4
  8010fe:	e8 65 ff ff ff       	call   801068 <syscall>
  801103:	83 c4 18             	add    $0x18,%esp
}
  801106:	90                   	nop
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80110c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	6a 00                	push   $0x0
  801114:	6a 00                	push   $0x0
  801116:	6a 00                	push   $0x0
  801118:	52                   	push   %edx
  801119:	50                   	push   %eax
  80111a:	6a 08                	push   $0x8
  80111c:	e8 47 ff ff ff       	call   801068 <syscall>
  801121:	83 c4 18             	add    $0x18,%esp
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80112b:	8b 75 18             	mov    0x18(%ebp),%esi
  80112e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801131:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801134:	8b 55 0c             	mov    0xc(%ebp),%edx
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
  80113c:	51                   	push   %ecx
  80113d:	52                   	push   %edx
  80113e:	50                   	push   %eax
  80113f:	6a 09                	push   $0x9
  801141:	e8 22 ff ff ff       	call   801068 <syscall>
  801146:	83 c4 18             	add    $0x18,%esp
}
  801149:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801153:	8b 55 0c             	mov    0xc(%ebp),%edx
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	52                   	push   %edx
  801160:	50                   	push   %eax
  801161:	6a 0a                	push   $0xa
  801163:	e8 00 ff ff ff       	call   801068 <syscall>
  801168:	83 c4 18             	add    $0x18,%esp
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	ff 75 08             	pushl  0x8(%ebp)
  80117c:	6a 0b                	push   $0xb
  80117e:	e8 e5 fe ff ff       	call   801068 <syscall>
  801183:	83 c4 18             	add    $0x18,%esp
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	6a 00                	push   $0x0
  801195:	6a 0c                	push   $0xc
  801197:	e8 cc fe ff ff       	call   801068 <syscall>
  80119c:	83 c4 18             	add    $0x18,%esp
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 0d                	push   $0xd
  8011b0:	e8 b3 fe ff ff       	call   801068 <syscall>
  8011b5:	83 c4 18             	add    $0x18,%esp
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 0e                	push   $0xe
  8011c9:	e8 9a fe ff ff       	call   801068 <syscall>
  8011ce:	83 c4 18             	add    $0x18,%esp
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 0f                	push   $0xf
  8011e2:	e8 81 fe ff ff       	call   801068 <syscall>
  8011e7:	83 c4 18             	add    $0x18,%esp
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	6a 10                	push   $0x10
  8011fc:	e8 67 fe ff ff       	call   801068 <syscall>
  801201:	83 c4 18             	add    $0x18,%esp
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 11                	push   $0x11
  801215:	e8 4e fe ff ff       	call   801068 <syscall>
  80121a:	83 c4 18             	add    $0x18,%esp
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sys_cputc>:

void
sys_cputc(const char c)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80122c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	50                   	push   %eax
  801239:	6a 01                	push   $0x1
  80123b:	e8 28 fe ff ff       	call   801068 <syscall>
  801240:	83 c4 18             	add    $0x18,%esp
}
  801243:	90                   	nop
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	6a 14                	push   $0x14
  801255:	e8 0e fe ff ff       	call   801068 <syscall>
  80125a:	83 c4 18             	add    $0x18,%esp
}
  80125d:	90                   	nop
  80125e:	c9                   	leave  
  80125f:	c3                   	ret    

00801260 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80126c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80126f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	6a 00                	push   $0x0
  801278:	51                   	push   %ecx
  801279:	52                   	push   %edx
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	50                   	push   %eax
  80127e:	6a 15                	push   $0x15
  801280:	e8 e3 fd ff ff       	call   801068 <syscall>
  801285:	83 c4 18             	add    $0x18,%esp
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80128d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	52                   	push   %edx
  80129a:	50                   	push   %eax
  80129b:	6a 16                	push   $0x16
  80129d:	e8 c6 fd ff ff       	call   801068 <syscall>
  8012a2:	83 c4 18             	add    $0x18,%esp
}
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	51                   	push   %ecx
  8012b8:	52                   	push   %edx
  8012b9:	50                   	push   %eax
  8012ba:	6a 17                	push   $0x17
  8012bc:	e8 a7 fd ff ff       	call   801068 <syscall>
  8012c1:	83 c4 18             	add    $0x18,%esp
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	52                   	push   %edx
  8012d6:	50                   	push   %eax
  8012d7:	6a 18                	push   $0x18
  8012d9:	e8 8a fd ff ff       	call   801068 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	ff 75 14             	pushl  0x14(%ebp)
  8012ee:	ff 75 10             	pushl  0x10(%ebp)
  8012f1:	ff 75 0c             	pushl  0xc(%ebp)
  8012f4:	50                   	push   %eax
  8012f5:	6a 19                	push   $0x19
  8012f7:	e8 6c fd ff ff       	call   801068 <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	50                   	push   %eax
  801310:	6a 1a                	push   $0x1a
  801312:	e8 51 fd ff ff       	call   801068 <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	90                   	nop
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	50                   	push   %eax
  80132c:	6a 1b                	push   $0x1b
  80132e:	e8 35 fd ff ff       	call   801068 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 05                	push   $0x5
  801347:	e8 1c fd ff ff       	call   801068 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 06                	push   $0x6
  801360:	e8 03 fd ff ff       	call   801068 <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 07                	push   $0x7
  801379:	e8 ea fc ff ff       	call   801068 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_exit_env>:


void sys_exit_env(void)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 1c                	push   $0x1c
  801392:	e8 d1 fc ff ff       	call   801068 <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	90                   	nop
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013a6:	8d 50 04             	lea    0x4(%eax),%edx
  8013a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	52                   	push   %edx
  8013b3:	50                   	push   %eax
  8013b4:	6a 1d                	push   $0x1d
  8013b6:	e8 ad fc ff ff       	call   801068 <syscall>
  8013bb:	83 c4 18             	add    $0x18,%esp
	return result;
  8013be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c7:	89 01                	mov    %eax,(%ecx)
  8013c9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	c9                   	leave  
  8013d0:	c2 04 00             	ret    $0x4

008013d3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	ff 75 10             	pushl  0x10(%ebp)
  8013dd:	ff 75 0c             	pushl  0xc(%ebp)
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	6a 13                	push   $0x13
  8013e5:	e8 7e fc ff ff       	call   801068 <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ed:	90                   	nop
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 1e                	push   $0x1e
  8013ff:	e8 64 fc ff ff       	call   801068 <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801415:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	50                   	push   %eax
  801422:	6a 1f                	push   $0x1f
  801424:	e8 3f fc ff ff       	call   801068 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
	return ;
  80142c:	90                   	nop
}
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <rsttst>:
void rsttst()
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 21                	push   $0x21
  80143e:	e8 25 fc ff ff       	call   801068 <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
	return ;
  801446:	90                   	nop
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	8b 45 14             	mov    0x14(%ebp),%eax
  801452:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801455:	8b 55 18             	mov    0x18(%ebp),%edx
  801458:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80145c:	52                   	push   %edx
  80145d:	50                   	push   %eax
  80145e:	ff 75 10             	pushl  0x10(%ebp)
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	6a 20                	push   $0x20
  801469:	e8 fa fb ff ff       	call   801068 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
	return ;
  801471:	90                   	nop
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <chktst>:
void chktst(uint32 n)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	ff 75 08             	pushl  0x8(%ebp)
  801482:	6a 22                	push   $0x22
  801484:	e8 df fb ff ff       	call   801068 <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
	return ;
  80148c:	90                   	nop
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <inctst>:

void inctst()
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 23                	push   $0x23
  80149e:	e8 c5 fb ff ff       	call   801068 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a6:	90                   	nop
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <gettst>:
uint32 gettst()
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 24                	push   $0x24
  8014b8:	e8 ab fb ff ff       	call   801068 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 25                	push   $0x25
  8014d4:	e8 8f fb ff ff       	call   801068 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
  8014dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014df:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014e3:	75 07                	jne    8014ec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ea:	eb 05                	jmp    8014f1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 25                	push   $0x25
  801505:	e8 5e fb ff ff       	call   801068 <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
  80150d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801510:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801514:	75 07                	jne    80151d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801516:	b8 01 00 00 00       	mov    $0x1,%eax
  80151b:	eb 05                	jmp    801522 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 25                	push   $0x25
  801536:	e8 2d fb ff ff       	call   801068 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
  80153e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801541:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801545:	75 07                	jne    80154e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801547:	b8 01 00 00 00       	mov    $0x1,%eax
  80154c:	eb 05                	jmp    801553 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 25                	push   $0x25
  801567:	e8 fc fa ff ff       	call   801068 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
  80156f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801572:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801576:	75 07                	jne    80157f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801578:	b8 01 00 00 00       	mov    $0x1,%eax
  80157d:	eb 05                	jmp    801584 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	6a 26                	push   $0x26
  801596:	e8 cd fa ff ff       	call   801068 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
	return ;
  80159e:	90                   	nop
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	53                   	push   %ebx
  8015b4:	51                   	push   %ecx
  8015b5:	52                   	push   %edx
  8015b6:	50                   	push   %eax
  8015b7:	6a 27                	push   $0x27
  8015b9:	e8 aa fa ff ff       	call   801068 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	52                   	push   %edx
  8015d6:	50                   	push   %eax
  8015d7:	6a 28                	push   $0x28
  8015d9:	e8 8a fa ff ff       	call   801068 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	6a 00                	push   $0x0
  8015f1:	51                   	push   %ecx
  8015f2:	ff 75 10             	pushl  0x10(%ebp)
  8015f5:	52                   	push   %edx
  8015f6:	50                   	push   %eax
  8015f7:	6a 29                	push   $0x29
  8015f9:	e8 6a fa ff ff       	call   801068 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	ff 75 10             	pushl  0x10(%ebp)
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	6a 12                	push   $0x12
  801615:	e8 4e fa ff ff       	call   801068 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
	return ;
  80161d:	90                   	nop
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	6a 2a                	push   $0x2a
  801633:	e8 30 fa ff ff       	call   801068 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
	return;
  80163b:	90                   	nop
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	50                   	push   %eax
  80164d:	6a 2b                	push   $0x2b
  80164f:	e8 14 fa ff ff       	call   801068 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	6a 2c                	push   $0x2c
  80166a:	e8 f9 f9 ff ff       	call   801068 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
	return;
  801672:	90                   	nop
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	ff 75 08             	pushl  0x8(%ebp)
  801684:	6a 2d                	push   $0x2d
  801686:	e8 dd f9 ff ff       	call   801068 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
	return;
  80168e:	90                   	nop
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801697:	8d 45 10             	lea    0x10(%ebp),%eax
  80169a:	83 c0 04             	add    $0x4,%eax
  80169d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016a0:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 16                	je     8016bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016a9:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	50                   	push   %eax
  8016b2:	68 98 1f 80 00       	push   $0x801f98
  8016b7:	e8 12 ec ff ff       	call   8002ce <cprintf>
  8016bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016bf:	a1 00 30 80 00       	mov    0x803000,%eax
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	68 9d 1f 80 00       	push   $0x801f9d
  8016d0:	e8 f9 eb ff ff       	call   8002ce <cprintf>
  8016d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e1:	50                   	push   %eax
  8016e2:	e8 7c eb ff ff       	call   800263 <vcprintf>
  8016e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	6a 00                	push   $0x0
  8016ef:	68 b9 1f 80 00       	push   $0x801fb9
  8016f4:	e8 6a eb ff ff       	call   800263 <vcprintf>
  8016f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016fc:	e8 eb ea ff ff       	call   8001ec <exit>

	// should not return here
	while (1) ;
  801701:	eb fe                	jmp    801701 <_panic+0x70>

00801703 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801709:	a1 04 30 80 00       	mov    0x803004,%eax
  80170e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801714:	8b 45 0c             	mov    0xc(%ebp),%eax
  801717:	39 c2                	cmp    %eax,%edx
  801719:	74 14                	je     80172f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 bc 1f 80 00       	push   $0x801fbc
  801723:	6a 26                	push   $0x26
  801725:	68 08 20 80 00       	push   $0x802008
  80172a:	e8 62 ff ff ff       	call   801691 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80172f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801736:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80173d:	e9 c5 00 00 00       	jmp    801807 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	01 d0                	add    %edx,%eax
  801751:	8b 00                	mov    (%eax),%eax
  801753:	85 c0                	test   %eax,%eax
  801755:	75 08                	jne    80175f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801757:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80175a:	e9 a5 00 00 00       	jmp    801804 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80175f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801766:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80176d:	eb 69                	jmp    8017d8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80176f:	a1 04 30 80 00       	mov    0x803004,%eax
  801774:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80177a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80177d:	89 d0                	mov    %edx,%eax
  80177f:	01 c0                	add    %eax,%eax
  801781:	01 d0                	add    %edx,%eax
  801783:	c1 e0 03             	shl    $0x3,%eax
  801786:	01 c8                	add    %ecx,%eax
  801788:	8a 40 04             	mov    0x4(%eax),%al
  80178b:	84 c0                	test   %al,%al
  80178d:	75 46                	jne    8017d5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80178f:	a1 04 30 80 00       	mov    0x803004,%eax
  801794:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80179a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	01 c0                	add    %eax,%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	c1 e0 03             	shl    $0x3,%eax
  8017a6:	01 c8                	add    %ecx,%eax
  8017a8:	8b 00                	mov    (%eax),%eax
  8017aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	01 c8                	add    %ecx,%eax
  8017c6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017c8:	39 c2                	cmp    %eax,%edx
  8017ca:	75 09                	jne    8017d5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017cc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017d3:	eb 15                	jmp    8017ea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017d5:	ff 45 e8             	incl   -0x18(%ebp)
  8017d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8017dd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e6:	39 c2                	cmp    %eax,%edx
  8017e8:	77 85                	ja     80176f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ee:	75 14                	jne    801804 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 14 20 80 00       	push   $0x802014
  8017f8:	6a 3a                	push   $0x3a
  8017fa:	68 08 20 80 00       	push   $0x802008
  8017ff:	e8 8d fe ff ff       	call   801691 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801804:	ff 45 f0             	incl   -0x10(%ebp)
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80180d:	0f 8c 2f ff ff ff    	jl     801742 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80181a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801821:	eb 26                	jmp    801849 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801823:	a1 04 30 80 00       	mov    0x803004,%eax
  801828:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80182e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801831:	89 d0                	mov    %edx,%eax
  801833:	01 c0                	add    %eax,%eax
  801835:	01 d0                	add    %edx,%eax
  801837:	c1 e0 03             	shl    $0x3,%eax
  80183a:	01 c8                	add    %ecx,%eax
  80183c:	8a 40 04             	mov    0x4(%eax),%al
  80183f:	3c 01                	cmp    $0x1,%al
  801841:	75 03                	jne    801846 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801843:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801846:	ff 45 e0             	incl   -0x20(%ebp)
  801849:	a1 04 30 80 00       	mov    0x803004,%eax
  80184e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801857:	39 c2                	cmp    %eax,%edx
  801859:	77 c8                	ja     801823 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801861:	74 14                	je     801877 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 68 20 80 00       	push   $0x802068
  80186b:	6a 44                	push   $0x44
  80186d:	68 08 20 80 00       	push   $0x802008
  801872:	e8 1a fe ff ff       	call   801691 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    
  80187a:	66 90                	xchg   %ax,%ax

0080187c <__udivdi3>:
  80187c:	55                   	push   %ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 1c             	sub    $0x1c,%esp
  801883:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801887:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80188b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80188f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801893:	89 ca                	mov    %ecx,%edx
  801895:	89 f8                	mov    %edi,%eax
  801897:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80189b:	85 f6                	test   %esi,%esi
  80189d:	75 2d                	jne    8018cc <__udivdi3+0x50>
  80189f:	39 cf                	cmp    %ecx,%edi
  8018a1:	77 65                	ja     801908 <__udivdi3+0x8c>
  8018a3:	89 fd                	mov    %edi,%ebp
  8018a5:	85 ff                	test   %edi,%edi
  8018a7:	75 0b                	jne    8018b4 <__udivdi3+0x38>
  8018a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ae:	31 d2                	xor    %edx,%edx
  8018b0:	f7 f7                	div    %edi
  8018b2:	89 c5                	mov    %eax,%ebp
  8018b4:	31 d2                	xor    %edx,%edx
  8018b6:	89 c8                	mov    %ecx,%eax
  8018b8:	f7 f5                	div    %ebp
  8018ba:	89 c1                	mov    %eax,%ecx
  8018bc:	89 d8                	mov    %ebx,%eax
  8018be:	f7 f5                	div    %ebp
  8018c0:	89 cf                	mov    %ecx,%edi
  8018c2:	89 fa                	mov    %edi,%edx
  8018c4:	83 c4 1c             	add    $0x1c,%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5f                   	pop    %edi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    
  8018cc:	39 ce                	cmp    %ecx,%esi
  8018ce:	77 28                	ja     8018f8 <__udivdi3+0x7c>
  8018d0:	0f bd fe             	bsr    %esi,%edi
  8018d3:	83 f7 1f             	xor    $0x1f,%edi
  8018d6:	75 40                	jne    801918 <__udivdi3+0x9c>
  8018d8:	39 ce                	cmp    %ecx,%esi
  8018da:	72 0a                	jb     8018e6 <__udivdi3+0x6a>
  8018dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018e0:	0f 87 9e 00 00 00    	ja     801984 <__udivdi3+0x108>
  8018e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018eb:	89 fa                	mov    %edi,%edx
  8018ed:	83 c4 1c             	add    $0x1c,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5e                   	pop    %esi
  8018f2:	5f                   	pop    %edi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
  8018f5:	8d 76 00             	lea    0x0(%esi),%esi
  8018f8:	31 ff                	xor    %edi,%edi
  8018fa:	31 c0                	xor    %eax,%eax
  8018fc:	89 fa                	mov    %edi,%edx
  8018fe:	83 c4 1c             	add    $0x1c,%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    
  801906:	66 90                	xchg   %ax,%ax
  801908:	89 d8                	mov    %ebx,%eax
  80190a:	f7 f7                	div    %edi
  80190c:	31 ff                	xor    %edi,%edi
  80190e:	89 fa                	mov    %edi,%edx
  801910:	83 c4 1c             	add    $0x1c,%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    
  801918:	bd 20 00 00 00       	mov    $0x20,%ebp
  80191d:	89 eb                	mov    %ebp,%ebx
  80191f:	29 fb                	sub    %edi,%ebx
  801921:	89 f9                	mov    %edi,%ecx
  801923:	d3 e6                	shl    %cl,%esi
  801925:	89 c5                	mov    %eax,%ebp
  801927:	88 d9                	mov    %bl,%cl
  801929:	d3 ed                	shr    %cl,%ebp
  80192b:	89 e9                	mov    %ebp,%ecx
  80192d:	09 f1                	or     %esi,%ecx
  80192f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801933:	89 f9                	mov    %edi,%ecx
  801935:	d3 e0                	shl    %cl,%eax
  801937:	89 c5                	mov    %eax,%ebp
  801939:	89 d6                	mov    %edx,%esi
  80193b:	88 d9                	mov    %bl,%cl
  80193d:	d3 ee                	shr    %cl,%esi
  80193f:	89 f9                	mov    %edi,%ecx
  801941:	d3 e2                	shl    %cl,%edx
  801943:	8b 44 24 08          	mov    0x8(%esp),%eax
  801947:	88 d9                	mov    %bl,%cl
  801949:	d3 e8                	shr    %cl,%eax
  80194b:	09 c2                	or     %eax,%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	89 f2                	mov    %esi,%edx
  801951:	f7 74 24 0c          	divl   0xc(%esp)
  801955:	89 d6                	mov    %edx,%esi
  801957:	89 c3                	mov    %eax,%ebx
  801959:	f7 e5                	mul    %ebp
  80195b:	39 d6                	cmp    %edx,%esi
  80195d:	72 19                	jb     801978 <__udivdi3+0xfc>
  80195f:	74 0b                	je     80196c <__udivdi3+0xf0>
  801961:	89 d8                	mov    %ebx,%eax
  801963:	31 ff                	xor    %edi,%edi
  801965:	e9 58 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  80196a:	66 90                	xchg   %ax,%ax
  80196c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801970:	89 f9                	mov    %edi,%ecx
  801972:	d3 e2                	shl    %cl,%edx
  801974:	39 c2                	cmp    %eax,%edx
  801976:	73 e9                	jae    801961 <__udivdi3+0xe5>
  801978:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80197b:	31 ff                	xor    %edi,%edi
  80197d:	e9 40 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  801982:	66 90                	xchg   %ax,%ax
  801984:	31 c0                	xor    %eax,%eax
  801986:	e9 37 ff ff ff       	jmp    8018c2 <__udivdi3+0x46>
  80198b:	90                   	nop

0080198c <__umoddi3>:
  80198c:	55                   	push   %ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
  801993:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801997:	8b 74 24 34          	mov    0x34(%esp),%esi
  80199b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80199f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ab:	89 f3                	mov    %esi,%ebx
  8019ad:	89 fa                	mov    %edi,%edx
  8019af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b3:	89 34 24             	mov    %esi,(%esp)
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	75 1a                	jne    8019d4 <__umoddi3+0x48>
  8019ba:	39 f7                	cmp    %esi,%edi
  8019bc:	0f 86 a2 00 00 00    	jbe    801a64 <__umoddi3+0xd8>
  8019c2:	89 c8                	mov    %ecx,%eax
  8019c4:	89 f2                	mov    %esi,%edx
  8019c6:	f7 f7                	div    %edi
  8019c8:	89 d0                	mov    %edx,%eax
  8019ca:	31 d2                	xor    %edx,%edx
  8019cc:	83 c4 1c             	add    $0x1c,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    
  8019d4:	39 f0                	cmp    %esi,%eax
  8019d6:	0f 87 ac 00 00 00    	ja     801a88 <__umoddi3+0xfc>
  8019dc:	0f bd e8             	bsr    %eax,%ebp
  8019df:	83 f5 1f             	xor    $0x1f,%ebp
  8019e2:	0f 84 ac 00 00 00    	je     801a94 <__umoddi3+0x108>
  8019e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8019ed:	29 ef                	sub    %ebp,%edi
  8019ef:	89 fe                	mov    %edi,%esi
  8019f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019f5:	89 e9                	mov    %ebp,%ecx
  8019f7:	d3 e0                	shl    %cl,%eax
  8019f9:	89 d7                	mov    %edx,%edi
  8019fb:	89 f1                	mov    %esi,%ecx
  8019fd:	d3 ef                	shr    %cl,%edi
  8019ff:	09 c7                	or     %eax,%edi
  801a01:	89 e9                	mov    %ebp,%ecx
  801a03:	d3 e2                	shl    %cl,%edx
  801a05:	89 14 24             	mov    %edx,(%esp)
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	d3 e0                	shl    %cl,%eax
  801a0c:	89 c2                	mov    %eax,%edx
  801a0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a12:	d3 e0                	shl    %cl,%eax
  801a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a18:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a1c:	89 f1                	mov    %esi,%ecx
  801a1e:	d3 e8                	shr    %cl,%eax
  801a20:	09 d0                	or     %edx,%eax
  801a22:	d3 eb                	shr    %cl,%ebx
  801a24:	89 da                	mov    %ebx,%edx
  801a26:	f7 f7                	div    %edi
  801a28:	89 d3                	mov    %edx,%ebx
  801a2a:	f7 24 24             	mull   (%esp)
  801a2d:	89 c6                	mov    %eax,%esi
  801a2f:	89 d1                	mov    %edx,%ecx
  801a31:	39 d3                	cmp    %edx,%ebx
  801a33:	0f 82 87 00 00 00    	jb     801ac0 <__umoddi3+0x134>
  801a39:	0f 84 91 00 00 00    	je     801ad0 <__umoddi3+0x144>
  801a3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a43:	29 f2                	sub    %esi,%edx
  801a45:	19 cb                	sbb    %ecx,%ebx
  801a47:	89 d8                	mov    %ebx,%eax
  801a49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a4d:	d3 e0                	shl    %cl,%eax
  801a4f:	89 e9                	mov    %ebp,%ecx
  801a51:	d3 ea                	shr    %cl,%edx
  801a53:	09 d0                	or     %edx,%eax
  801a55:	89 e9                	mov    %ebp,%ecx
  801a57:	d3 eb                	shr    %cl,%ebx
  801a59:	89 da                	mov    %ebx,%edx
  801a5b:	83 c4 1c             	add    $0x1c,%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    
  801a63:	90                   	nop
  801a64:	89 fd                	mov    %edi,%ebp
  801a66:	85 ff                	test   %edi,%edi
  801a68:	75 0b                	jne    801a75 <__umoddi3+0xe9>
  801a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6f:	31 d2                	xor    %edx,%edx
  801a71:	f7 f7                	div    %edi
  801a73:	89 c5                	mov    %eax,%ebp
  801a75:	89 f0                	mov    %esi,%eax
  801a77:	31 d2                	xor    %edx,%edx
  801a79:	f7 f5                	div    %ebp
  801a7b:	89 c8                	mov    %ecx,%eax
  801a7d:	f7 f5                	div    %ebp
  801a7f:	89 d0                	mov    %edx,%eax
  801a81:	e9 44 ff ff ff       	jmp    8019ca <__umoddi3+0x3e>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	89 c8                	mov    %ecx,%eax
  801a8a:	89 f2                	mov    %esi,%edx
  801a8c:	83 c4 1c             	add    $0x1c,%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5f                   	pop    %edi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
  801a94:	3b 04 24             	cmp    (%esp),%eax
  801a97:	72 06                	jb     801a9f <__umoddi3+0x113>
  801a99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a9d:	77 0f                	ja     801aae <__umoddi3+0x122>
  801a9f:	89 f2                	mov    %esi,%edx
  801aa1:	29 f9                	sub    %edi,%ecx
  801aa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aa7:	89 14 24             	mov    %edx,(%esp)
  801aaa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aae:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ab2:	8b 14 24             	mov    (%esp),%edx
  801ab5:	83 c4 1c             	add    $0x1c,%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5f                   	pop    %edi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    
  801abd:	8d 76 00             	lea    0x0(%esi),%esi
  801ac0:	2b 04 24             	sub    (%esp),%eax
  801ac3:	19 fa                	sbb    %edi,%edx
  801ac5:	89 d1                	mov    %edx,%ecx
  801ac7:	89 c6                	mov    %eax,%esi
  801ac9:	e9 71 ff ff ff       	jmp    801a3f <__umoddi3+0xb3>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ad4:	72 ea                	jb     801ac0 <__umoddi3+0x134>
  801ad6:	89 d9                	mov    %ebx,%ecx
  801ad8:	e9 62 ff ff ff       	jmp    801a3f <__umoddi3+0xb3>
