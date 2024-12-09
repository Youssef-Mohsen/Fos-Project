
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
  800053:	e8 4d 13 00 00       	call   8013a5 <sys_get_virtual_time>
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
  800074:	e8 2c 13 00 00       	call   8013a5 <sys_get_virtual_time>
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
  8000c9:	e8 8b 12 00 00       	call   801359 <sys_getenvindex>
  8000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d4:	89 d0                	mov    %edx,%eax
  8000d6:	c1 e0 03             	shl    $0x3,%eax
  8000d9:	01 d0                	add    %edx,%eax
  8000db:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000e2:	01 c8                	add    %ecx,%eax
  8000e4:	01 c0                	add    %eax,%eax
  8000e6:	01 d0                	add    %edx,%eax
  8000e8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000ef:	01 c8                	add    %ecx,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f8:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8a 40 20             	mov    0x20(%eax),%al
  800105:	84 c0                	test   %al,%al
  800107:	74 0d                	je     800116 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800109:	a1 04 30 80 00       	mov    0x803004,%eax
  80010e:	83 c0 20             	add    $0x20,%eax
  800111:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011a:	7e 0a                	jle    800126 <libmain+0x63>
		binaryname = argv[0];
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	8b 00                	mov    (%eax),%eax
  800121:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	ff 75 0c             	pushl  0xc(%ebp)
  80012c:	ff 75 08             	pushl  0x8(%ebp)
  80012f:	e8 04 ff ff ff       	call   800038 <_main>
  800134:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800137:	e8 a1 0f 00 00       	call   8010dd <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	68 b8 1b 80 00       	push   $0x801bb8
  800144:	e8 8d 01 00 00       	call   8002d6 <cprintf>
  800149:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80014c:	a1 04 30 80 00       	mov    0x803004,%eax
  800151:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800157:	a1 04 30 80 00       	mov    0x803004,%eax
  80015c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	68 e0 1b 80 00       	push   $0x801be0
  80016c:	e8 65 01 00 00       	call   8002d6 <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800174:	a1 04 30 80 00       	mov    0x803004,%eax
  800179:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80017f:	a1 04 30 80 00       	mov    0x803004,%eax
  800184:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80018a:	a1 04 30 80 00       	mov    0x803004,%eax
  80018f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800195:	51                   	push   %ecx
  800196:	52                   	push   %edx
  800197:	50                   	push   %eax
  800198:	68 08 1c 80 00       	push   $0x801c08
  80019d:	e8 34 01 00 00       	call   8002d6 <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	50                   	push   %eax
  8001b4:	68 60 1c 80 00       	push   $0x801c60
  8001b9:	e8 18 01 00 00       	call   8002d6 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 b8 1b 80 00       	push   $0x801bb8
  8001c9:	e8 08 01 00 00       	call   8002d6 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001d1:	e8 21 0f 00 00       	call   8010f7 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001d6:	e8 19 00 00 00       	call   8001f4 <exit>
}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	6a 00                	push   $0x0
  8001e9:	e8 37 11 00 00       	call   801325 <sys_destroy_env>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <exit>:

void
exit(void)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fa:	e8 8c 11 00 00       	call   80138b <sys_exit_env>
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	8b 00                	mov    (%eax),%eax
  80020d:	8d 48 01             	lea    0x1(%eax),%ecx
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	89 0a                	mov    %ecx,(%edx)
  800215:	8b 55 08             	mov    0x8(%ebp),%edx
  800218:	88 d1                	mov    %dl,%cl
  80021a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022b:	75 2c                	jne    800259 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80022d:	a0 08 30 80 00       	mov    0x803008,%al
  800232:	0f b6 c0             	movzbl %al,%eax
  800235:	8b 55 0c             	mov    0xc(%ebp),%edx
  800238:	8b 12                	mov    (%edx),%edx
  80023a:	89 d1                	mov    %edx,%ecx
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	83 c2 08             	add    $0x8,%edx
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	50                   	push   %eax
  800246:	51                   	push   %ecx
  800247:	52                   	push   %edx
  800248:	e8 4e 0e 00 00       	call   80109b <sys_cputs>
  80024d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800250:	8b 45 0c             	mov    0xc(%ebp),%eax
  800253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025c:	8b 40 04             	mov    0x4(%eax),%eax
  80025f:	8d 50 01             	lea    0x1(%eax),%edx
  800262:	8b 45 0c             	mov    0xc(%ebp),%eax
  800265:	89 50 04             	mov    %edx,0x4(%eax)
}
  800268:	90                   	nop
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800274:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027b:	00 00 00 
	b.cnt = 0;
  80027e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800285:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800288:	ff 75 0c             	pushl  0xc(%ebp)
  80028b:	ff 75 08             	pushl  0x8(%ebp)
  80028e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800294:	50                   	push   %eax
  800295:	68 02 02 80 00       	push   $0x800202
  80029a:	e8 11 02 00 00       	call   8004b0 <vprintfmt>
  80029f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a2:	a0 08 30 80 00       	mov    0x803008,%al
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	50                   	push   %eax
  8002b4:	52                   	push   %edx
  8002b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002bb:	83 c0 08             	add    $0x8,%eax
  8002be:	50                   	push   %eax
  8002bf:	e8 d7 0d 00 00       	call   80109b <sys_cputs>
  8002c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002c7:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002dc:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f2:	50                   	push   %eax
  8002f3:	e8 73 ff ff ff       	call   80026b <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800309:	e8 cf 0d 00 00       	call   8010dd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80030e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800311:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800314:	8b 45 08             	mov    0x8(%ebp),%eax
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	ff 75 f4             	pushl  -0xc(%ebp)
  80031d:	50                   	push   %eax
  80031e:	e8 48 ff ff ff       	call   80026b <vcprintf>
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800329:	e8 c9 0d 00 00       	call   8010f7 <sys_unlock_cons>
	return cnt;
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	53                   	push   %ebx
  800337:	83 ec 14             	sub    $0x14,%esp
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800340:	8b 45 14             	mov    0x14(%ebp),%eax
  800343:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800346:	8b 45 18             	mov    0x18(%ebp),%eax
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800351:	77 55                	ja     8003a8 <printnum+0x75>
  800353:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800356:	72 05                	jb     80035d <printnum+0x2a>
  800358:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035b:	77 4b                	ja     8003a8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800360:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800363:	8b 45 18             	mov    0x18(%ebp),%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	ff 75 f4             	pushl  -0xc(%ebp)
  800370:	ff 75 f0             	pushl  -0x10(%ebp)
  800373:	e8 a8 15 00 00       	call   801920 <__udivdi3>
  800378:	83 c4 10             	add    $0x10,%esp
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	ff 75 20             	pushl  0x20(%ebp)
  800381:	53                   	push   %ebx
  800382:	ff 75 18             	pushl  0x18(%ebp)
  800385:	52                   	push   %edx
  800386:	50                   	push   %eax
  800387:	ff 75 0c             	pushl  0xc(%ebp)
  80038a:	ff 75 08             	pushl  0x8(%ebp)
  80038d:	e8 a1 ff ff ff       	call   800333 <printnum>
  800392:	83 c4 20             	add    $0x20,%esp
  800395:	eb 1a                	jmp    8003b1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	ff 75 0c             	pushl  0xc(%ebp)
  80039d:	ff 75 20             	pushl  0x20(%ebp)
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	ff d0                	call   *%eax
  8003a5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003af:	7f e6                	jg     800397 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003bf:	53                   	push   %ebx
  8003c0:	51                   	push   %ecx
  8003c1:	52                   	push   %edx
  8003c2:	50                   	push   %eax
  8003c3:	e8 68 16 00 00       	call   801a30 <__umoddi3>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	05 94 1e 80 00       	add    $0x801e94,%eax
  8003d0:	8a 00                	mov    (%eax),%al
  8003d2:	0f be c0             	movsbl %al,%eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 0c             	pushl  0xc(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	ff d0                	call   *%eax
  8003e1:	83 c4 10             	add    $0x10,%esp
}
  8003e4:	90                   	nop
  8003e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

008003ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f1:	7e 1c                	jle    80040f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	8b 00                	mov    (%eax),%eax
  8003f8:	8d 50 08             	lea    0x8(%eax),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	89 10                	mov    %edx,(%eax)
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	8b 00                	mov    (%eax),%eax
  800405:	83 e8 08             	sub    $0x8,%eax
  800408:	8b 50 04             	mov    0x4(%eax),%edx
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	eb 40                	jmp    80044f <getuint+0x65>
	else if (lflag)
  80040f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800413:	74 1e                	je     800433 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	89 10                	mov    %edx,(%eax)
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	83 e8 04             	sub    $0x4,%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	ba 00 00 00 00       	mov    $0x0,%edx
  800431:	eb 1c                	jmp    80044f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	8d 50 04             	lea    0x4(%eax),%edx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	83 e8 04             	sub    $0x4,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80044f:	5d                   	pop    %ebp
  800450:	c3                   	ret    

00800451 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800454:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800458:	7e 1c                	jle    800476 <getint+0x25>
		return va_arg(*ap, long long);
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	8d 50 08             	lea    0x8(%eax),%edx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	89 10                	mov    %edx,(%eax)
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	83 e8 08             	sub    $0x8,%eax
  80046f:	8b 50 04             	mov    0x4(%eax),%edx
  800472:	8b 00                	mov    (%eax),%eax
  800474:	eb 38                	jmp    8004ae <getint+0x5d>
	else if (lflag)
  800476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047a:	74 1a                	je     800496 <getint+0x45>
		return va_arg(*ap, long);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 50 04             	lea    0x4(%eax),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 10                	mov    %edx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	83 e8 04             	sub    $0x4,%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	99                   	cltd   
  800494:	eb 18                	jmp    8004ae <getint+0x5d>
	else
		return va_arg(*ap, int);
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	8d 50 04             	lea    0x4(%eax),%edx
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 10                	mov    %edx,(%eax)
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	83 e8 04             	sub    $0x4,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	99                   	cltd   
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	56                   	push   %esi
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b8:	eb 17                	jmp    8004d1 <vprintfmt+0x21>
			if (ch == '\0')
  8004ba:	85 db                	test   %ebx,%ebx
  8004bc:	0f 84 c1 03 00 00    	je     800883 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	ff 75 0c             	pushl  0xc(%ebp)
  8004c8:	53                   	push   %ebx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	ff d0                	call   *%eax
  8004ce:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d4:	8d 50 01             	lea    0x1(%eax),%edx
  8004d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8004da:	8a 00                	mov    (%eax),%al
  8004dc:	0f b6 d8             	movzbl %al,%ebx
  8004df:	83 fb 25             	cmp    $0x25,%ebx
  8004e2:	75 d6                	jne    8004ba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004e4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 45 10             	mov    0x10(%ebp),%eax
  800507:	8d 50 01             	lea    0x1(%eax),%edx
  80050a:	89 55 10             	mov    %edx,0x10(%ebp)
  80050d:	8a 00                	mov    (%eax),%al
  80050f:	0f b6 d8             	movzbl %al,%ebx
  800512:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800515:	83 f8 5b             	cmp    $0x5b,%eax
  800518:	0f 87 3d 03 00 00    	ja     80085b <vprintfmt+0x3ab>
  80051e:	8b 04 85 b8 1e 80 00 	mov    0x801eb8(,%eax,4),%eax
  800525:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800527:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80052b:	eb d7                	jmp    800504 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80052d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800531:	eb d1                	jmp    800504 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80053a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80053d:	89 d0                	mov    %edx,%eax
  80053f:	c1 e0 02             	shl    $0x2,%eax
  800542:	01 d0                	add    %edx,%eax
  800544:	01 c0                	add    %eax,%eax
  800546:	01 d8                	add    %ebx,%eax
  800548:	83 e8 30             	sub    $0x30,%eax
  80054b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80054e:	8b 45 10             	mov    0x10(%ebp),%eax
  800551:	8a 00                	mov    (%eax),%al
  800553:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800556:	83 fb 2f             	cmp    $0x2f,%ebx
  800559:	7e 3e                	jle    800599 <vprintfmt+0xe9>
  80055b:	83 fb 39             	cmp    $0x39,%ebx
  80055e:	7f 39                	jg     800599 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800560:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800563:	eb d5                	jmp    80053a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	83 c0 04             	add    $0x4,%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 e8 04             	sub    $0x4,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800579:	eb 1f                	jmp    80059a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80057b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057f:	79 83                	jns    800504 <vprintfmt+0x54>
				width = 0;
  800581:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800588:	e9 77 ff ff ff       	jmp    800504 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80058d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800594:	e9 6b ff ff ff       	jmp    800504 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800599:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80059a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059e:	0f 89 60 ff ff ff    	jns    800504 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b1:	e9 4e ff ff ff       	jmp    800504 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b9:	e9 46 ff ff ff       	jmp    800504 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 c0 04             	add    $0x4,%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 e8 04             	sub    $0x4,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	50                   	push   %eax
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	ff d0                	call   *%eax
  8005db:	83 c4 10             	add    $0x10,%esp
			break;
  8005de:	e9 9b 02 00 00       	jmp    80087e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 c0 04             	add    $0x4,%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	83 e8 04             	sub    $0x4,%eax
  8005f2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005f4:	85 db                	test   %ebx,%ebx
  8005f6:	79 02                	jns    8005fa <vprintfmt+0x14a>
				err = -err;
  8005f8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005fa:	83 fb 64             	cmp    $0x64,%ebx
  8005fd:	7f 0b                	jg     80060a <vprintfmt+0x15a>
  8005ff:	8b 34 9d 00 1d 80 00 	mov    0x801d00(,%ebx,4),%esi
  800606:	85 f6                	test   %esi,%esi
  800608:	75 19                	jne    800623 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80060a:	53                   	push   %ebx
  80060b:	68 a5 1e 80 00       	push   $0x801ea5
  800610:	ff 75 0c             	pushl  0xc(%ebp)
  800613:	ff 75 08             	pushl  0x8(%ebp)
  800616:	e8 70 02 00 00       	call   80088b <printfmt>
  80061b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80061e:	e9 5b 02 00 00       	jmp    80087e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800623:	56                   	push   %esi
  800624:	68 ae 1e 80 00       	push   $0x801eae
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	ff 75 08             	pushl  0x8(%ebp)
  80062f:	e8 57 02 00 00       	call   80088b <printfmt>
  800634:	83 c4 10             	add    $0x10,%esp
			break;
  800637:	e9 42 02 00 00       	jmp    80087e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 c0 04             	add    $0x4,%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	83 e8 04             	sub    $0x4,%eax
  80064b:	8b 30                	mov    (%eax),%esi
  80064d:	85 f6                	test   %esi,%esi
  80064f:	75 05                	jne    800656 <vprintfmt+0x1a6>
				p = "(null)";
  800651:	be b1 1e 80 00       	mov    $0x801eb1,%esi
			if (width > 0 && padc != '-')
  800656:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065a:	7e 6d                	jle    8006c9 <vprintfmt+0x219>
  80065c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800660:	74 67                	je     8006c9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	50                   	push   %eax
  800669:	56                   	push   %esi
  80066a:	e8 1e 03 00 00       	call   80098d <strnlen>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800675:	eb 16                	jmp    80068d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800677:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	50                   	push   %eax
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	ff d0                	call   *%eax
  800687:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80068a:	ff 4d e4             	decl   -0x1c(%ebp)
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800691:	7f e4                	jg     800677 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800693:	eb 34                	jmp    8006c9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800695:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800699:	74 1c                	je     8006b7 <vprintfmt+0x207>
  80069b:	83 fb 1f             	cmp    $0x1f,%ebx
  80069e:	7e 05                	jle    8006a5 <vprintfmt+0x1f5>
  8006a0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006a3:	7e 12                	jle    8006b7 <vprintfmt+0x207>
					putch('?', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	6a 3f                	push   $0x3f
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	ff d0                	call   *%eax
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	eb 0f                	jmp    8006c6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	53                   	push   %ebx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c9:	89 f0                	mov    %esi,%eax
  8006cb:	8d 70 01             	lea    0x1(%eax),%esi
  8006ce:	8a 00                	mov    (%eax),%al
  8006d0:	0f be d8             	movsbl %al,%ebx
  8006d3:	85 db                	test   %ebx,%ebx
  8006d5:	74 24                	je     8006fb <vprintfmt+0x24b>
  8006d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006db:	78 b8                	js     800695 <vprintfmt+0x1e5>
  8006dd:	ff 4d e0             	decl   -0x20(%ebp)
  8006e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e4:	79 af                	jns    800695 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e6:	eb 13                	jmp    8006fb <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	6a 20                	push   $0x20
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	ff d0                	call   *%eax
  8006f5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7f e7                	jg     8006e8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800701:	e9 78 01 00 00       	jmp    80087e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 e8             	pushl  -0x18(%ebp)
  80070c:	8d 45 14             	lea    0x14(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	e8 3c fd ff ff       	call   800451 <getint>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80071e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800724:	85 d2                	test   %edx,%edx
  800726:	79 23                	jns    80074b <vprintfmt+0x29b>
				putch('-', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	6a 2d                	push   $0x2d
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073e:	f7 d8                	neg    %eax
  800740:	83 d2 00             	adc    $0x0,%edx
  800743:	f7 da                	neg    %edx
  800745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800748:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80074b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800752:	e9 bc 00 00 00       	jmp    800813 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 e8             	pushl  -0x18(%ebp)
  80075d:	8d 45 14             	lea    0x14(%ebp),%eax
  800760:	50                   	push   %eax
  800761:	e8 84 fc ff ff       	call   8003ea <getuint>
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80076f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800776:	e9 98 00 00 00       	jmp    800813 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	6a 58                	push   $0x58
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	6a 58                	push   $0x58
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	6a 58                	push   $0x58
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
			break;
  8007ab:	e9 ce 00 00 00       	jmp    80087e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	6a 30                	push   $0x30
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	ff d0                	call   *%eax
  8007bd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	6a 78                	push   $0x78
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	83 c0 04             	add    $0x4,%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	83 e8 04             	sub    $0x4,%eax
  8007df:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f2:	eb 1f                	jmp    800813 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fd:	50                   	push   %eax
  8007fe:	e8 e7 fb ff ff       	call   8003ea <getuint>
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800809:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80080c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800813:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	52                   	push   %edx
  80081e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800821:	50                   	push   %eax
  800822:	ff 75 f4             	pushl  -0xc(%ebp)
  800825:	ff 75 f0             	pushl  -0x10(%ebp)
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 00 fb ff ff       	call   800333 <printnum>
  800833:	83 c4 20             	add    $0x20,%esp
			break;
  800836:	eb 46                	jmp    80087e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	53                   	push   %ebx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			break;
  800847:	eb 35                	jmp    80087e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800849:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800850:	eb 2c                	jmp    80087e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800852:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800859:	eb 23                	jmp    80087e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	6a 25                	push   $0x25
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	ff d0                	call   *%eax
  800868:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086b:	ff 4d 10             	decl   0x10(%ebp)
  80086e:	eb 03                	jmp    800873 <vprintfmt+0x3c3>
  800870:	ff 4d 10             	decl   0x10(%ebp)
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	48                   	dec    %eax
  800877:	8a 00                	mov    (%eax),%al
  800879:	3c 25                	cmp    $0x25,%al
  80087b:	75 f3                	jne    800870 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80087d:	90                   	nop
		}
	}
  80087e:	e9 35 fc ff ff       	jmp    8004b8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800883:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800884:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800887:	5b                   	pop    %ebx
  800888:	5e                   	pop    %esi
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800891:	8d 45 10             	lea    0x10(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a0:	50                   	push   %eax
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	e8 04 fc ff ff       	call   8004b0 <vprintfmt>
  8008ac:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008af:	90                   	nop
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 40 08             	mov    0x8(%eax),%eax
  8008bb:	8d 50 01             	lea    0x1(%eax),%edx
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	8b 10                	mov    (%eax),%edx
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	8b 40 04             	mov    0x4(%eax),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	73 12                	jae    8008e5 <sprintputch+0x33>
		*b->buf++ = ch;
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008de:	89 0a                	mov    %ecx,(%edx)
  8008e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e3:	88 10                	mov    %dl,(%eax)
}
  8008e5:	90                   	nop
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80090d:	74 06                	je     800915 <vsnprintf+0x2d>
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	7f 07                	jg     80091c <vsnprintf+0x34>
		return -E_INVAL;
  800915:	b8 03 00 00 00       	mov    $0x3,%eax
  80091a:	eb 20                	jmp    80093c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80091c:	ff 75 14             	pushl  0x14(%ebp)
  80091f:	ff 75 10             	pushl  0x10(%ebp)
  800922:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 b2 08 80 00       	push   $0x8008b2
  80092b:	e8 80 fb ff ff       	call   8004b0 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800936:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800939:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800944:	8d 45 10             	lea    0x10(%ebp),%eax
  800947:	83 c0 04             	add    $0x4,%eax
  80094a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	ff 75 f4             	pushl  -0xc(%ebp)
  800953:	50                   	push   %eax
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	e8 89 ff ff ff       	call   8008e8 <vsnprintf>
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800965:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800977:	eb 06                	jmp    80097f <strlen+0x15>
		n++;
  800979:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80097c:	ff 45 08             	incl   0x8(%ebp)
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8a 00                	mov    (%eax),%al
  800984:	84 c0                	test   %al,%al
  800986:	75 f1                	jne    800979 <strlen+0xf>
		n++;
	return n;
  800988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800993:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80099a:	eb 09                	jmp    8009a5 <strnlen+0x18>
		n++;
  80099c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099f:	ff 45 08             	incl   0x8(%ebp)
  8009a2:	ff 4d 0c             	decl   0xc(%ebp)
  8009a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a9:	74 09                	je     8009b4 <strnlen+0x27>
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	84 c0                	test   %al,%al
  8009b2:	75 e8                	jne    80099c <strnlen+0xf>
		n++;
	return n;
  8009b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009c5:	90                   	nop
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8d 50 01             	lea    0x1(%eax),%edx
  8009cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d8:	8a 12                	mov    (%edx),%dl
  8009da:	88 10                	mov    %dl,(%eax)
  8009dc:	8a 00                	mov    (%eax),%al
  8009de:	84 c0                	test   %al,%al
  8009e0:	75 e4                	jne    8009c6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 1f                	jmp    800a1b <strncpy+0x34>
		*dst++ = *src;
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8d 50 01             	lea    0x1(%eax),%edx
  800a02:	89 55 08             	mov    %edx,0x8(%ebp)
  800a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a08:	8a 12                	mov    (%edx),%dl
  800a0a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8a 00                	mov    (%eax),%al
  800a11:	84 c0                	test   %al,%al
  800a13:	74 03                	je     800a18 <strncpy+0x31>
			src++;
  800a15:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a18:	ff 45 fc             	incl   -0x4(%ebp)
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a1e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a21:	72 d9                	jb     8009fc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a38:	74 30                	je     800a6a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a3a:	eb 16                	jmp    800a52 <strlcpy+0x2a>
			*dst++ = *src++;
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8d 50 01             	lea    0x1(%eax),%edx
  800a42:	89 55 08             	mov    %edx,0x8(%ebp)
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a48:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a4e:	8a 12                	mov    (%edx),%dl
  800a50:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a52:	ff 4d 10             	decl   0x10(%ebp)
  800a55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a59:	74 09                	je     800a64 <strlcpy+0x3c>
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	8a 00                	mov    (%eax),%al
  800a60:	84 c0                	test   %al,%al
  800a62:	75 d8                	jne    800a3c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a70:	29 c2                	sub    %eax,%edx
  800a72:	89 d0                	mov    %edx,%eax
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a79:	eb 06                	jmp    800a81 <strcmp+0xb>
		p++, q++;
  800a7b:	ff 45 08             	incl   0x8(%ebp)
  800a7e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	84 c0                	test   %al,%al
  800a88:	74 0e                	je     800a98 <strcmp+0x22>
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8a 10                	mov    (%eax),%dl
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	38 c2                	cmp    %al,%dl
  800a96:	74 e3                	je     800a7b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	0f b6 d0             	movzbl %al,%edx
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	0f b6 c0             	movzbl %al,%eax
  800aa8:	29 c2                	sub    %eax,%edx
  800aaa:	89 d0                	mov    %edx,%eax
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ab1:	eb 09                	jmp    800abc <strncmp+0xe>
		n--, p++, q++;
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	ff 45 08             	incl   0x8(%ebp)
  800ab9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800abc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac0:	74 17                	je     800ad9 <strncmp+0x2b>
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	84 c0                	test   %al,%al
  800ac9:	74 0e                	je     800ad9 <strncmp+0x2b>
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8a 10                	mov    (%eax),%dl
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	38 c2                	cmp    %al,%dl
  800ad7:	74 da                	je     800ab3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ad9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800add:	75 07                	jne    800ae6 <strncmp+0x38>
		return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb 14                	jmp    800afa <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	0f b6 d0             	movzbl %al,%edx
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	0f b6 c0             	movzbl %al,%eax
  800af6:	29 c2                	sub    %eax,%edx
  800af8:	89 d0                	mov    %edx,%eax
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 04             	sub    $0x4,%esp
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b08:	eb 12                	jmp    800b1c <strchr+0x20>
		if (*s == c)
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b12:	75 05                	jne    800b19 <strchr+0x1d>
			return (char *) s;
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	eb 11                	jmp    800b2a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b19:	ff 45 08             	incl   0x8(%ebp)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	84 c0                	test   %al,%al
  800b23:	75 e5                	jne    800b0a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 04             	sub    $0x4,%esp
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b38:	eb 0d                	jmp    800b47 <strfind+0x1b>
		if (*s == c)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8a 00                	mov    (%eax),%al
  800b3f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b42:	74 0e                	je     800b52 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b44:	ff 45 08             	incl   0x8(%ebp)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	84 c0                	test   %al,%al
  800b4e:	75 ea                	jne    800b3a <strfind+0xe>
  800b50:	eb 01                	jmp    800b53 <strfind+0x27>
		if (*s == c)
			break;
  800b52:	90                   	nop
	return (char *) s;
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b64:	8b 45 10             	mov    0x10(%ebp),%eax
  800b67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b6a:	eb 0e                	jmp    800b7a <memset+0x22>
		*p++ = c;
  800b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b6f:	8d 50 01             	lea    0x1(%eax),%edx
  800b72:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b7a:	ff 4d f8             	decl   -0x8(%ebp)
  800b7d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b81:	79 e9                	jns    800b6c <memset+0x14>
		*p++ = c;

	return v;
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b9a:	eb 16                	jmp    800bb2 <memcpy+0x2a>
		*d++ = *s++;
  800b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ba2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ba5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bae:	8a 12                	mov    (%edx),%dl
  800bb0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bbb:	85 c0                	test   %eax,%eax
  800bbd:	75 dd                	jne    800b9c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bdc:	73 50                	jae    800c2e <memmove+0x6a>
  800bde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800be1:	8b 45 10             	mov    0x10(%ebp),%eax
  800be4:	01 d0                	add    %edx,%eax
  800be6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800be9:	76 43                	jbe    800c2e <memmove+0x6a>
		s += n;
  800beb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bee:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bf7:	eb 10                	jmp    800c09 <memmove+0x45>
			*--d = *--s;
  800bf9:	ff 4d f8             	decl   -0x8(%ebp)
  800bfc:	ff 4d fc             	decl   -0x4(%ebp)
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8a 10                	mov    (%eax),%dl
  800c04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c07:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c09:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c12:	85 c0                	test   %eax,%eax
  800c14:	75 e3                	jne    800bf9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c16:	eb 23                	jmp    800c3b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c2a:	8a 12                	mov    (%edx),%dl
  800c2c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	89 55 10             	mov    %edx,0x10(%ebp)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	75 dd                	jne    800c18 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c52:	eb 2a                	jmp    800c7e <memcmp+0x3e>
		if (*s1 != *s2)
  800c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c57:	8a 10                	mov    (%eax),%dl
  800c59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c5c:	8a 00                	mov    (%eax),%al
  800c5e:	38 c2                	cmp    %al,%dl
  800c60:	74 16                	je     800c78 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	0f b6 d0             	movzbl %al,%edx
  800c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	0f b6 c0             	movzbl %al,%eax
  800c72:	29 c2                	sub    %eax,%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	eb 18                	jmp    800c90 <memcmp+0x50>
		s1++, s2++;
  800c78:	ff 45 fc             	incl   -0x4(%ebp)
  800c7b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c84:	89 55 10             	mov    %edx,0x10(%ebp)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	75 c9                	jne    800c54 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9e:	01 d0                	add    %edx,%eax
  800ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ca3:	eb 15                	jmp    800cba <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	0f b6 d0             	movzbl %al,%edx
  800cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb0:	0f b6 c0             	movzbl %al,%eax
  800cb3:	39 c2                	cmp    %eax,%edx
  800cb5:	74 0d                	je     800cc4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cb7:	ff 45 08             	incl   0x8(%ebp)
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cc0:	72 e3                	jb     800ca5 <memfind+0x13>
  800cc2:	eb 01                	jmp    800cc5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cc4:	90                   	nop
	return (void *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cd7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cde:	eb 03                	jmp    800ce3 <strtol+0x19>
		s++;
  800ce0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	3c 20                	cmp    $0x20,%al
  800cea:	74 f4                	je     800ce0 <strtol+0x16>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	3c 09                	cmp    $0x9,%al
  800cf3:	74 eb                	je     800ce0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	3c 2b                	cmp    $0x2b,%al
  800cfc:	75 05                	jne    800d03 <strtol+0x39>
		s++;
  800cfe:	ff 45 08             	incl   0x8(%ebp)
  800d01:	eb 13                	jmp    800d16 <strtol+0x4c>
	else if (*s == '-')
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 2d                	cmp    $0x2d,%al
  800d0a:	75 0a                	jne    800d16 <strtol+0x4c>
		s++, neg = 1;
  800d0c:	ff 45 08             	incl   0x8(%ebp)
  800d0f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	74 06                	je     800d22 <strtol+0x58>
  800d1c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d20:	75 20                	jne    800d42 <strtol+0x78>
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3c 30                	cmp    $0x30,%al
  800d29:	75 17                	jne    800d42 <strtol+0x78>
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	40                   	inc    %eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3c 78                	cmp    $0x78,%al
  800d33:	75 0d                	jne    800d42 <strtol+0x78>
		s += 2, base = 16;
  800d35:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d39:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d40:	eb 28                	jmp    800d6a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d46:	75 15                	jne    800d5d <strtol+0x93>
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 30                	cmp    $0x30,%al
  800d4f:	75 0c                	jne    800d5d <strtol+0x93>
		s++, base = 8;
  800d51:	ff 45 08             	incl   0x8(%ebp)
  800d54:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d5b:	eb 0d                	jmp    800d6a <strtol+0xa0>
	else if (base == 0)
  800d5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d61:	75 07                	jne    800d6a <strtol+0xa0>
		base = 10;
  800d63:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	3c 2f                	cmp    $0x2f,%al
  800d71:	7e 19                	jle    800d8c <strtol+0xc2>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	3c 39                	cmp    $0x39,%al
  800d7a:	7f 10                	jg     800d8c <strtol+0xc2>
			dig = *s - '0';
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	0f be c0             	movsbl %al,%eax
  800d84:	83 e8 30             	sub    $0x30,%eax
  800d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d8a:	eb 42                	jmp    800dce <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 60                	cmp    $0x60,%al
  800d93:	7e 19                	jle    800dae <strtol+0xe4>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 7a                	cmp    $0x7a,%al
  800d9c:	7f 10                	jg     800dae <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	0f be c0             	movsbl %al,%eax
  800da6:	83 e8 57             	sub    $0x57,%eax
  800da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dac:	eb 20                	jmp    800dce <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	3c 40                	cmp    $0x40,%al
  800db5:	7e 39                	jle    800df0 <strtol+0x126>
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	3c 5a                	cmp    $0x5a,%al
  800dbe:	7f 30                	jg     800df0 <strtol+0x126>
			dig = *s - 'A' + 10;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	0f be c0             	movsbl %al,%eax
  800dc8:	83 e8 37             	sub    $0x37,%eax
  800dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd4:	7d 19                	jge    800def <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800de0:	89 c2                	mov    %eax,%edx
  800de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de5:	01 d0                	add    %edx,%eax
  800de7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dea:	e9 7b ff ff ff       	jmp    800d6a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800def:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800df0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df4:	74 08                	je     800dfe <strtol+0x134>
		*endptr = (char *) s;
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e02:	74 07                	je     800e0b <strtol+0x141>
  800e04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e07:	f7 d8                	neg    %eax
  800e09:	eb 03                	jmp    800e0e <strtol+0x144>
  800e0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <ltostr>:

void
ltostr(long value, char *str)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e1d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e28:	79 13                	jns    800e3d <ltostr+0x2d>
	{
		neg = 1;
  800e2a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e37:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e3a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e45:	99                   	cltd   
  800e46:	f7 f9                	idiv   %ecx
  800e48:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4e:	8d 50 01             	lea    0x1(%eax),%edx
  800e51:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	01 d0                	add    %edx,%eax
  800e5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e5e:	83 c2 30             	add    $0x30,%edx
  800e61:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e66:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e6b:	f7 e9                	imul   %ecx
  800e6d:	c1 fa 02             	sar    $0x2,%edx
  800e70:	89 c8                	mov    %ecx,%eax
  800e72:	c1 f8 1f             	sar    $0x1f,%eax
  800e75:	29 c2                	sub    %eax,%edx
  800e77:	89 d0                	mov    %edx,%eax
  800e79:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	75 bb                	jne    800e3d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8c:	48                   	dec    %eax
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e90:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e94:	74 3d                	je     800ed3 <ltostr+0xc3>
		start = 1 ;
  800e96:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e9d:	eb 34                	jmp    800ed3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea5:	01 d0                	add    %edx,%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	01 c2                	add    %eax,%edx
  800eb4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	01 c8                	add    %ecx,%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ec0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	01 c2                	add    %eax,%edx
  800ec8:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ecb:	88 02                	mov    %al,(%edx)
		start++ ;
  800ecd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ed0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ed9:	7c c4                	jl     800e9f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800edb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ee6:	90                   	nop
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800eef:	ff 75 08             	pushl  0x8(%ebp)
  800ef2:	e8 73 fa ff ff       	call   80096a <strlen>
  800ef7:	83 c4 04             	add    $0x4,%esp
  800efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	e8 65 fa ff ff       	call   80096a <strlen>
  800f05:	83 c4 04             	add    $0x4,%esp
  800f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f19:	eb 17                	jmp    800f32 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	01 c2                	add    %eax,%edx
  800f23:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	01 c8                	add    %ecx,%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f2f:	ff 45 fc             	incl   -0x4(%ebp)
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f38:	7c e1                	jl     800f1b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f48:	eb 1f                	jmp    800f69 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	8b 45 10             	mov    0x10(%ebp),%eax
  800f58:	01 c2                	add    %eax,%edx
  800f5a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 c8                	add    %ecx,%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f66:	ff 45 f8             	incl   -0x8(%ebp)
  800f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6f:	7c d9                	jl     800f4a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f74:	8b 45 10             	mov    0x10(%ebp),%eax
  800f77:	01 d0                	add    %edx,%eax
  800f79:	c6 00 00             	movb   $0x0,(%eax)
}
  800f7c:	90                   	nop
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f82:	8b 45 14             	mov    0x14(%ebp),%eax
  800f85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8e:	8b 00                	mov    (%eax),%eax
  800f90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa2:	eb 0c                	jmp    800fb0 <strsplit+0x31>
			*string++ = 0;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8d 50 01             	lea    0x1(%eax),%edx
  800faa:	89 55 08             	mov    %edx,0x8(%ebp)
  800fad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	84 c0                	test   %al,%al
  800fb7:	74 18                	je     800fd1 <strsplit+0x52>
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	50                   	push   %eax
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	e8 32 fb ff ff       	call   800afc <strchr>
  800fca:	83 c4 08             	add    $0x8,%esp
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	75 d3                	jne    800fa4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	84 c0                	test   %al,%al
  800fd8:	74 5a                	je     801034 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fda:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdd:	8b 00                	mov    (%eax),%eax
  800fdf:	83 f8 0f             	cmp    $0xf,%eax
  800fe2:	75 07                	jne    800feb <strsplit+0x6c>
		{
			return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe9:	eb 66                	jmp    801051 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800feb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fee:	8b 00                	mov    (%eax),%eax
  800ff0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff3:	8b 55 14             	mov    0x14(%ebp),%edx
  800ff6:	89 0a                	mov    %ecx,(%edx)
  800ff8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fff:	8b 45 10             	mov    0x10(%ebp),%eax
  801002:	01 c2                	add    %eax,%edx
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801009:	eb 03                	jmp    80100e <strsplit+0x8f>
			string++;
  80100b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	84 c0                	test   %al,%al
  801015:	74 8b                	je     800fa2 <strsplit+0x23>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	0f be c0             	movsbl %al,%eax
  80101f:	50                   	push   %eax
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	e8 d4 fa ff ff       	call   800afc <strchr>
  801028:	83 c4 08             	add    $0x8,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	74 dc                	je     80100b <strsplit+0x8c>
			string++;
	}
  80102f:	e9 6e ff ff ff       	jmp    800fa2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801034:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	8b 00                	mov    (%eax),%eax
  80103a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801041:	8b 45 10             	mov    0x10(%ebp),%eax
  801044:	01 d0                	add    %edx,%eax
  801046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80104c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	68 28 20 80 00       	push   $0x802028
  801061:	68 3f 01 00 00       	push   $0x13f
  801066:	68 4a 20 80 00       	push   $0x80204a
  80106b:	e8 c5 06 00 00       	call   801735 <_panic>

00801070 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801082:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801085:	8b 7d 18             	mov    0x18(%ebp),%edi
  801088:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80108b:	cd 30                	int    $0x30
  80108d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801090:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 04             	sub    $0x4,%esp
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010a7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	6a 00                	push   $0x0
  8010b0:	6a 00                	push   $0x0
  8010b2:	52                   	push   %edx
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	50                   	push   %eax
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 b2 ff ff ff       	call   801070 <syscall>
  8010be:	83 c4 18             	add    $0x18,%esp
}
  8010c1:	90                   	nop
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010c7:	6a 00                	push   $0x0
  8010c9:	6a 00                	push   $0x0
  8010cb:	6a 00                	push   $0x0
  8010cd:	6a 00                	push   $0x0
  8010cf:	6a 00                	push   $0x0
  8010d1:	6a 02                	push   $0x2
  8010d3:	e8 98 ff ff ff       	call   801070 <syscall>
  8010d8:	83 c4 18             	add    $0x18,%esp
}
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    

008010dd <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 00                	push   $0x0
  8010e6:	6a 00                	push   $0x0
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 03                	push   $0x3
  8010ec:	e8 7f ff ff ff       	call   801070 <syscall>
  8010f1:	83 c4 18             	add    $0x18,%esp
}
  8010f4:	90                   	nop
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 04                	push   $0x4
  801106:	e8 65 ff ff ff       	call   801070 <syscall>
  80110b:	83 c4 18             	add    $0x18,%esp
}
  80110e:	90                   	nop
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801114:	8b 55 0c             	mov    0xc(%ebp),%edx
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	52                   	push   %edx
  801121:	50                   	push   %eax
  801122:	6a 08                	push   $0x8
  801124:	e8 47 ff ff ff       	call   801070 <syscall>
  801129:	83 c4 18             	add    $0x18,%esp
}
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    

0080112e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801133:	8b 75 18             	mov    0x18(%ebp),%esi
  801136:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801139:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80113c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
  801144:	51                   	push   %ecx
  801145:	52                   	push   %edx
  801146:	50                   	push   %eax
  801147:	6a 09                	push   $0x9
  801149:	e8 22 ff ff ff       	call   801070 <syscall>
  80114e:	83 c4 18             	add    $0x18,%esp
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80115b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	6a 00                	push   $0x0
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	52                   	push   %edx
  801168:	50                   	push   %eax
  801169:	6a 0a                	push   $0xa
  80116b:	e8 00 ff ff ff       	call   801070 <syscall>
  801170:	83 c4 18             	add    $0x18,%esp
}
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	ff 75 08             	pushl  0x8(%ebp)
  801184:	6a 0b                	push   $0xb
  801186:	e8 e5 fe ff ff       	call   801070 <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 0c                	push   $0xc
  80119f:	e8 cc fe ff ff       	call   801070 <syscall>
  8011a4:	83 c4 18             	add    $0x18,%esp
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 0d                	push   $0xd
  8011b8:	e8 b3 fe ff ff       	call   801070 <syscall>
  8011bd:	83 c4 18             	add    $0x18,%esp
}
  8011c0:	c9                   	leave  
  8011c1:	c3                   	ret    

008011c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 0e                	push   $0xe
  8011d1:	e8 9a fe ff ff       	call   801070 <syscall>
  8011d6:	83 c4 18             	add    $0x18,%esp
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 0f                	push   $0xf
  8011ea:	e8 81 fe ff ff       	call   801070 <syscall>
  8011ef:	83 c4 18             	add    $0x18,%esp
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	ff 75 08             	pushl  0x8(%ebp)
  801202:	6a 10                	push   $0x10
  801204:	e8 67 fe ff ff       	call   801070 <syscall>
  801209:	83 c4 18             	add    $0x18,%esp
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 11                	push   $0x11
  80121d:	e8 4e fe ff ff       	call   801070 <syscall>
  801222:	83 c4 18             	add    $0x18,%esp
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_cputc>:

void
sys_cputc(const char c)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801234:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	50                   	push   %eax
  801241:	6a 01                	push   $0x1
  801243:	e8 28 fe ff ff       	call   801070 <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	90                   	nop
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801251:	6a 00                	push   $0x0
  801253:	6a 00                	push   $0x0
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 14                	push   $0x14
  80125d:	e8 0e fe ff ff       	call   801070 <syscall>
  801262:	83 c4 18             	add    $0x18,%esp
}
  801265:	90                   	nop
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801274:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801277:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	6a 00                	push   $0x0
  801280:	51                   	push   %ecx
  801281:	52                   	push   %edx
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	50                   	push   %eax
  801286:	6a 15                	push   $0x15
  801288:	e8 e3 fd ff ff       	call   801070 <syscall>
  80128d:	83 c4 18             	add    $0x18,%esp
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801295:	8b 55 0c             	mov    0xc(%ebp),%edx
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	52                   	push   %edx
  8012a2:	50                   	push   %eax
  8012a3:	6a 16                	push   $0x16
  8012a5:	e8 c6 fd ff ff       	call   801070 <syscall>
  8012aa:	83 c4 18             	add    $0x18,%esp
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	51                   	push   %ecx
  8012c0:	52                   	push   %edx
  8012c1:	50                   	push   %eax
  8012c2:	6a 17                	push   $0x17
  8012c4:	e8 a7 fd ff ff       	call   801070 <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	52                   	push   %edx
  8012de:	50                   	push   %eax
  8012df:	6a 18                	push   $0x18
  8012e1:	e8 8a fd ff ff       	call   801070 <syscall>
  8012e6:	83 c4 18             	add    $0x18,%esp
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	6a 00                	push   $0x0
  8012f3:	ff 75 14             	pushl  0x14(%ebp)
  8012f6:	ff 75 10             	pushl  0x10(%ebp)
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	50                   	push   %eax
  8012fd:	6a 19                	push   $0x19
  8012ff:	e8 6c fd ff ff       	call   801070 <syscall>
  801304:	83 c4 18             	add    $0x18,%esp
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	50                   	push   %eax
  801318:	6a 1a                	push   $0x1a
  80131a:	e8 51 fd ff ff       	call   801070 <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	50                   	push   %eax
  801334:	6a 1b                	push   $0x1b
  801336:	e8 35 fd ff ff       	call   801070 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 05                	push   $0x5
  80134f:	e8 1c fd ff ff       	call   801070 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 06                	push   $0x6
  801368:	e8 03 fd ff ff       	call   801070 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 07                	push   $0x7
  801381:	e8 ea fc ff ff       	call   801070 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_exit_env>:


void sys_exit_env(void)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 1c                	push   $0x1c
  80139a:	e8 d1 fc ff ff       	call   801070 <syscall>
  80139f:	83 c4 18             	add    $0x18,%esp
}
  8013a2:	90                   	nop
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ae:	8d 50 04             	lea    0x4(%eax),%edx
  8013b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	52                   	push   %edx
  8013bb:	50                   	push   %eax
  8013bc:	6a 1d                	push   $0x1d
  8013be:	e8 ad fc ff ff       	call   801070 <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
	return result;
  8013c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cf:	89 01                	mov    %eax,(%ecx)
  8013d1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	c9                   	leave  
  8013d8:	c2 04 00             	ret    $0x4

008013db <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	ff 75 10             	pushl  0x10(%ebp)
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	ff 75 08             	pushl  0x8(%ebp)
  8013eb:	6a 13                	push   $0x13
  8013ed:	e8 7e fc ff ff       	call   801070 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8013f5:	90                   	nop
}
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 1e                	push   $0x1e
  801407:	e8 64 fc ff ff       	call   801070 <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80141d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	50                   	push   %eax
  80142a:	6a 1f                	push   $0x1f
  80142c:	e8 3f fc ff ff       	call   801070 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
	return ;
  801434:	90                   	nop
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <rsttst>:
void rsttst()
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 21                	push   $0x21
  801446:	e8 25 fc ff ff       	call   801070 <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
	return ;
  80144e:	90                   	nop
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80145d:	8b 55 18             	mov    0x18(%ebp),%edx
  801460:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801464:	52                   	push   %edx
  801465:	50                   	push   %eax
  801466:	ff 75 10             	pushl  0x10(%ebp)
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	ff 75 08             	pushl  0x8(%ebp)
  80146f:	6a 20                	push   $0x20
  801471:	e8 fa fb ff ff       	call   801070 <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
	return ;
  801479:	90                   	nop
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <chktst>:
void chktst(uint32 n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	ff 75 08             	pushl  0x8(%ebp)
  80148a:	6a 22                	push   $0x22
  80148c:	e8 df fb ff ff       	call   801070 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
	return ;
  801494:	90                   	nop
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <inctst>:

void inctst()
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 23                	push   $0x23
  8014a6:	e8 c5 fb ff ff       	call   801070 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ae:	90                   	nop
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <gettst>:
uint32 gettst()
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 24                	push   $0x24
  8014c0:	e8 ab fb ff ff       	call   801070 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 25                	push   $0x25
  8014dc:	e8 8f fb ff ff       	call   801070 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
  8014e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014e7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014eb:	75 07                	jne    8014f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f2:	eb 05                	jmp    8014f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 25                	push   $0x25
  80150d:	e8 5e fb ff ff       	call   801070 <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
  801515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801518:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80151c:	75 07                	jne    801525 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80151e:	b8 01 00 00 00       	mov    $0x1,%eax
  801523:	eb 05                	jmp    80152a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 25                	push   $0x25
  80153e:	e8 2d fb ff ff       	call   801070 <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
  801546:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801549:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80154d:	75 07                	jne    801556 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80154f:	b8 01 00 00 00       	mov    $0x1,%eax
  801554:	eb 05                	jmp    80155b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 25                	push   $0x25
  80156f:	e8 fc fa ff ff       	call   801070 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
  801577:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80157a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80157e:	75 07                	jne    801587 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801580:	b8 01 00 00 00       	mov    $0x1,%eax
  801585:	eb 05                	jmp    80158c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	6a 26                	push   $0x26
  80159e:	e8 cd fa ff ff       	call   801070 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a6:	90                   	nop
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	6a 00                	push   $0x0
  8015bb:	53                   	push   %ebx
  8015bc:	51                   	push   %ecx
  8015bd:	52                   	push   %edx
  8015be:	50                   	push   %eax
  8015bf:	6a 27                	push   $0x27
  8015c1:	e8 aa fa ff ff       	call   801070 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	52                   	push   %edx
  8015de:	50                   	push   %eax
  8015df:	6a 28                	push   $0x28
  8015e1:	e8 8a fa ff ff       	call   801070 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	51                   	push   %ecx
  8015fa:	ff 75 10             	pushl  0x10(%ebp)
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	6a 29                	push   $0x29
  801601:	e8 6a fa ff ff       	call   801070 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	ff 75 10             	pushl  0x10(%ebp)
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	6a 12                	push   $0x12
  80161d:	e8 4e fa ff ff       	call   801070 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
	return ;
  801625:	90                   	nop
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80162b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	52                   	push   %edx
  801638:	50                   	push   %eax
  801639:	6a 2a                	push   $0x2a
  80163b:	e8 30 fa ff ff       	call   801070 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
	return;
  801643:	90                   	nop
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	50                   	push   %eax
  801655:	6a 2b                	push   $0x2b
  801657:	e8 14 fa ff ff       	call   801070 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 2c                	push   $0x2c
  801672:	e8 f9 f9 ff ff       	call   801070 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	6a 2d                	push   $0x2d
  80168e:	e8 dd f9 ff ff       	call   801070 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
	return;
  801696:	90                   	nop
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 2e                	push   $0x2e
  8016ab:	e8 c0 f9 ff ff       	call   801070 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
  8016b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8016b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	50                   	push   %eax
  8016ca:	6a 2f                	push   $0x2f
  8016cc:	e8 9f f9 ff ff       	call   801070 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	6a 30                	push   $0x30
  8016ea:	e8 81 f9 ff ff       	call   801070 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
	return;
  8016f2:	90                   	nop
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	50                   	push   %eax
  801707:	6a 31                	push   $0x31
  801709:	e8 62 f9 ff ff       	call   801070 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
  801711:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801714:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	50                   	push   %eax
  801728:	6a 32                	push   $0x32
  80172a:	e8 41 f9 ff ff       	call   801070 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
	return;
  801732:	90                   	nop
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80173b:	8d 45 10             	lea    0x10(%ebp),%eax
  80173e:	83 c0 04             	add    $0x4,%eax
  801741:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801744:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 16                	je     801763 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80174d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801752:	83 ec 08             	sub    $0x8,%esp
  801755:	50                   	push   %eax
  801756:	68 58 20 80 00       	push   $0x802058
  80175b:	e8 76 eb ff ff       	call   8002d6 <cprintf>
  801760:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801763:	a1 00 30 80 00       	mov    0x803000,%eax
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	50                   	push   %eax
  80176f:	68 5d 20 80 00       	push   $0x80205d
  801774:	e8 5d eb ff ff       	call   8002d6 <cprintf>
  801779:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	ff 75 f4             	pushl  -0xc(%ebp)
  801785:	50                   	push   %eax
  801786:	e8 e0 ea ff ff       	call   80026b <vcprintf>
  80178b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	6a 00                	push   $0x0
  801793:	68 79 20 80 00       	push   $0x802079
  801798:	e8 ce ea ff ff       	call   80026b <vcprintf>
  80179d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017a0:	e8 4f ea ff ff       	call   8001f4 <exit>

	// should not return here
	while (1) ;
  8017a5:	eb fe                	jmp    8017a5 <_panic+0x70>

008017a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8017b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 14                	je     8017d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 7c 20 80 00       	push   $0x80207c
  8017c7:	6a 26                	push   $0x26
  8017c9:	68 c8 20 80 00       	push   $0x8020c8
  8017ce:	e8 62 ff ff ff       	call   801735 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8017d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8017da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017e1:	e9 c5 00 00 00       	jmp    8018ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8017e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	8b 00                	mov    (%eax),%eax
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	75 08                	jne    801803 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8017fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8017fe:	e9 a5 00 00 00       	jmp    8018a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801803:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80180a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801811:	eb 69                	jmp    80187c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801813:	a1 04 30 80 00       	mov    0x803004,%eax
  801818:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80181e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801821:	89 d0                	mov    %edx,%eax
  801823:	01 c0                	add    %eax,%eax
  801825:	01 d0                	add    %edx,%eax
  801827:	c1 e0 03             	shl    $0x3,%eax
  80182a:	01 c8                	add    %ecx,%eax
  80182c:	8a 40 04             	mov    0x4(%eax),%al
  80182f:	84 c0                	test   %al,%al
  801831:	75 46                	jne    801879 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801833:	a1 04 30 80 00       	mov    0x803004,%eax
  801838:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80183e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801841:	89 d0                	mov    %edx,%eax
  801843:	01 c0                	add    %eax,%eax
  801845:	01 d0                	add    %edx,%eax
  801847:	c1 e0 03             	shl    $0x3,%eax
  80184a:	01 c8                	add    %ecx,%eax
  80184c:	8b 00                	mov    (%eax),%eax
  80184e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801851:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801859:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	01 c8                	add    %ecx,%eax
  80186a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80186c:	39 c2                	cmp    %eax,%edx
  80186e:	75 09                	jne    801879 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801870:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801877:	eb 15                	jmp    80188e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801879:	ff 45 e8             	incl   -0x18(%ebp)
  80187c:	a1 04 30 80 00       	mov    0x803004,%eax
  801881:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188a:	39 c2                	cmp    %eax,%edx
  80188c:	77 85                	ja     801813 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80188e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801892:	75 14                	jne    8018a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 d4 20 80 00       	push   $0x8020d4
  80189c:	6a 3a                	push   $0x3a
  80189e:	68 c8 20 80 00       	push   $0x8020c8
  8018a3:	e8 8d fe ff ff       	call   801735 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018a8:	ff 45 f0             	incl   -0x10(%ebp)
  8018ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018b1:	0f 8c 2f ff ff ff    	jl     8017e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018c5:	eb 26                	jmp    8018ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8018c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8018cc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8018d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018d5:	89 d0                	mov    %edx,%eax
  8018d7:	01 c0                	add    %eax,%eax
  8018d9:	01 d0                	add    %edx,%eax
  8018db:	c1 e0 03             	shl    $0x3,%eax
  8018de:	01 c8                	add    %ecx,%eax
  8018e0:	8a 40 04             	mov    0x4(%eax),%al
  8018e3:	3c 01                	cmp    $0x1,%al
  8018e5:	75 03                	jne    8018ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8018e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018ea:	ff 45 e0             	incl   -0x20(%ebp)
  8018ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8018f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fb:	39 c2                	cmp    %eax,%edx
  8018fd:	77 c8                	ja     8018c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801905:	74 14                	je     80191b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 28 21 80 00       	push   $0x802128
  80190f:	6a 44                	push   $0x44
  801911:	68 c8 20 80 00       	push   $0x8020c8
  801916:	e8 1a fe ff ff       	call   801735 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80191b:	90                   	nop
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    
  80191e:	66 90                	xchg   %ax,%ax

00801920 <__udivdi3>:
  801920:	55                   	push   %ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 1c             	sub    $0x1c,%esp
  801927:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80192b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80192f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801933:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801937:	89 ca                	mov    %ecx,%edx
  801939:	89 f8                	mov    %edi,%eax
  80193b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80193f:	85 f6                	test   %esi,%esi
  801941:	75 2d                	jne    801970 <__udivdi3+0x50>
  801943:	39 cf                	cmp    %ecx,%edi
  801945:	77 65                	ja     8019ac <__udivdi3+0x8c>
  801947:	89 fd                	mov    %edi,%ebp
  801949:	85 ff                	test   %edi,%edi
  80194b:	75 0b                	jne    801958 <__udivdi3+0x38>
  80194d:	b8 01 00 00 00       	mov    $0x1,%eax
  801952:	31 d2                	xor    %edx,%edx
  801954:	f7 f7                	div    %edi
  801956:	89 c5                	mov    %eax,%ebp
  801958:	31 d2                	xor    %edx,%edx
  80195a:	89 c8                	mov    %ecx,%eax
  80195c:	f7 f5                	div    %ebp
  80195e:	89 c1                	mov    %eax,%ecx
  801960:	89 d8                	mov    %ebx,%eax
  801962:	f7 f5                	div    %ebp
  801964:	89 cf                	mov    %ecx,%edi
  801966:	89 fa                	mov    %edi,%edx
  801968:	83 c4 1c             	add    $0x1c,%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
  801970:	39 ce                	cmp    %ecx,%esi
  801972:	77 28                	ja     80199c <__udivdi3+0x7c>
  801974:	0f bd fe             	bsr    %esi,%edi
  801977:	83 f7 1f             	xor    $0x1f,%edi
  80197a:	75 40                	jne    8019bc <__udivdi3+0x9c>
  80197c:	39 ce                	cmp    %ecx,%esi
  80197e:	72 0a                	jb     80198a <__udivdi3+0x6a>
  801980:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801984:	0f 87 9e 00 00 00    	ja     801a28 <__udivdi3+0x108>
  80198a:	b8 01 00 00 00       	mov    $0x1,%eax
  80198f:	89 fa                	mov    %edi,%edx
  801991:	83 c4 1c             	add    $0x1c,%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5f                   	pop    %edi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    
  801999:	8d 76 00             	lea    0x0(%esi),%esi
  80199c:	31 ff                	xor    %edi,%edi
  80199e:	31 c0                	xor    %eax,%eax
  8019a0:	89 fa                	mov    %edi,%edx
  8019a2:	83 c4 1c             	add    $0x1c,%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
  8019aa:	66 90                	xchg   %ax,%ax
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	f7 f7                	div    %edi
  8019b0:	31 ff                	xor    %edi,%edi
  8019b2:	89 fa                	mov    %edi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019c1:	89 eb                	mov    %ebp,%ebx
  8019c3:	29 fb                	sub    %edi,%ebx
  8019c5:	89 f9                	mov    %edi,%ecx
  8019c7:	d3 e6                	shl    %cl,%esi
  8019c9:	89 c5                	mov    %eax,%ebp
  8019cb:	88 d9                	mov    %bl,%cl
  8019cd:	d3 ed                	shr    %cl,%ebp
  8019cf:	89 e9                	mov    %ebp,%ecx
  8019d1:	09 f1                	or     %esi,%ecx
  8019d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019d7:	89 f9                	mov    %edi,%ecx
  8019d9:	d3 e0                	shl    %cl,%eax
  8019db:	89 c5                	mov    %eax,%ebp
  8019dd:	89 d6                	mov    %edx,%esi
  8019df:	88 d9                	mov    %bl,%cl
  8019e1:	d3 ee                	shr    %cl,%esi
  8019e3:	89 f9                	mov    %edi,%ecx
  8019e5:	d3 e2                	shl    %cl,%edx
  8019e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019eb:	88 d9                	mov    %bl,%cl
  8019ed:	d3 e8                	shr    %cl,%eax
  8019ef:	09 c2                	or     %eax,%edx
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	89 f2                	mov    %esi,%edx
  8019f5:	f7 74 24 0c          	divl   0xc(%esp)
  8019f9:	89 d6                	mov    %edx,%esi
  8019fb:	89 c3                	mov    %eax,%ebx
  8019fd:	f7 e5                	mul    %ebp
  8019ff:	39 d6                	cmp    %edx,%esi
  801a01:	72 19                	jb     801a1c <__udivdi3+0xfc>
  801a03:	74 0b                	je     801a10 <__udivdi3+0xf0>
  801a05:	89 d8                	mov    %ebx,%eax
  801a07:	31 ff                	xor    %edi,%edi
  801a09:	e9 58 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a0e:	66 90                	xchg   %ax,%ax
  801a10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a14:	89 f9                	mov    %edi,%ecx
  801a16:	d3 e2                	shl    %cl,%edx
  801a18:	39 c2                	cmp    %eax,%edx
  801a1a:	73 e9                	jae    801a05 <__udivdi3+0xe5>
  801a1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a1f:	31 ff                	xor    %edi,%edi
  801a21:	e9 40 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a26:	66 90                	xchg   %ax,%ax
  801a28:	31 c0                	xor    %eax,%eax
  801a2a:	e9 37 ff ff ff       	jmp    801966 <__udivdi3+0x46>
  801a2f:	90                   	nop

00801a30 <__umoddi3>:
  801a30:	55                   	push   %ebp
  801a31:	57                   	push   %edi
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 1c             	sub    $0x1c,%esp
  801a37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a4f:	89 f3                	mov    %esi,%ebx
  801a51:	89 fa                	mov    %edi,%edx
  801a53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a57:	89 34 24             	mov    %esi,(%esp)
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	75 1a                	jne    801a78 <__umoddi3+0x48>
  801a5e:	39 f7                	cmp    %esi,%edi
  801a60:	0f 86 a2 00 00 00    	jbe    801b08 <__umoddi3+0xd8>
  801a66:	89 c8                	mov    %ecx,%eax
  801a68:	89 f2                	mov    %esi,%edx
  801a6a:	f7 f7                	div    %edi
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	31 d2                	xor    %edx,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	39 f0                	cmp    %esi,%eax
  801a7a:	0f 87 ac 00 00 00    	ja     801b2c <__umoddi3+0xfc>
  801a80:	0f bd e8             	bsr    %eax,%ebp
  801a83:	83 f5 1f             	xor    $0x1f,%ebp
  801a86:	0f 84 ac 00 00 00    	je     801b38 <__umoddi3+0x108>
  801a8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a91:	29 ef                	sub    %ebp,%edi
  801a93:	89 fe                	mov    %edi,%esi
  801a95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a99:	89 e9                	mov    %ebp,%ecx
  801a9b:	d3 e0                	shl    %cl,%eax
  801a9d:	89 d7                	mov    %edx,%edi
  801a9f:	89 f1                	mov    %esi,%ecx
  801aa1:	d3 ef                	shr    %cl,%edi
  801aa3:	09 c7                	or     %eax,%edi
  801aa5:	89 e9                	mov    %ebp,%ecx
  801aa7:	d3 e2                	shl    %cl,%edx
  801aa9:	89 14 24             	mov    %edx,(%esp)
  801aac:	89 d8                	mov    %ebx,%eax
  801aae:	d3 e0                	shl    %cl,%eax
  801ab0:	89 c2                	mov    %eax,%edx
  801ab2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab6:	d3 e0                	shl    %cl,%eax
  801ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ac0:	89 f1                	mov    %esi,%ecx
  801ac2:	d3 e8                	shr    %cl,%eax
  801ac4:	09 d0                	or     %edx,%eax
  801ac6:	d3 eb                	shr    %cl,%ebx
  801ac8:	89 da                	mov    %ebx,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d3                	mov    %edx,%ebx
  801ace:	f7 24 24             	mull   (%esp)
  801ad1:	89 c6                	mov    %eax,%esi
  801ad3:	89 d1                	mov    %edx,%ecx
  801ad5:	39 d3                	cmp    %edx,%ebx
  801ad7:	0f 82 87 00 00 00    	jb     801b64 <__umoddi3+0x134>
  801add:	0f 84 91 00 00 00    	je     801b74 <__umoddi3+0x144>
  801ae3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ae7:	29 f2                	sub    %esi,%edx
  801ae9:	19 cb                	sbb    %ecx,%ebx
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801af1:	d3 e0                	shl    %cl,%eax
  801af3:	89 e9                	mov    %ebp,%ecx
  801af5:	d3 ea                	shr    %cl,%edx
  801af7:	09 d0                	or     %edx,%eax
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 eb                	shr    %cl,%ebx
  801afd:	89 da                	mov    %ebx,%edx
  801aff:	83 c4 1c             	add    $0x1c,%esp
  801b02:	5b                   	pop    %ebx
  801b03:	5e                   	pop    %esi
  801b04:	5f                   	pop    %edi
  801b05:	5d                   	pop    %ebp
  801b06:	c3                   	ret    
  801b07:	90                   	nop
  801b08:	89 fd                	mov    %edi,%ebp
  801b0a:	85 ff                	test   %edi,%edi
  801b0c:	75 0b                	jne    801b19 <__umoddi3+0xe9>
  801b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b13:	31 d2                	xor    %edx,%edx
  801b15:	f7 f7                	div    %edi
  801b17:	89 c5                	mov    %eax,%ebp
  801b19:	89 f0                	mov    %esi,%eax
  801b1b:	31 d2                	xor    %edx,%edx
  801b1d:	f7 f5                	div    %ebp
  801b1f:	89 c8                	mov    %ecx,%eax
  801b21:	f7 f5                	div    %ebp
  801b23:	89 d0                	mov    %edx,%eax
  801b25:	e9 44 ff ff ff       	jmp    801a6e <__umoddi3+0x3e>
  801b2a:	66 90                	xchg   %ax,%ax
  801b2c:	89 c8                	mov    %ecx,%eax
  801b2e:	89 f2                	mov    %esi,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	3b 04 24             	cmp    (%esp),%eax
  801b3b:	72 06                	jb     801b43 <__umoddi3+0x113>
  801b3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b41:	77 0f                	ja     801b52 <__umoddi3+0x122>
  801b43:	89 f2                	mov    %esi,%edx
  801b45:	29 f9                	sub    %edi,%ecx
  801b47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b4b:	89 14 24             	mov    %edx,(%esp)
  801b4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b56:	8b 14 24             	mov    (%esp),%edx
  801b59:	83 c4 1c             	add    $0x1c,%esp
  801b5c:	5b                   	pop    %ebx
  801b5d:	5e                   	pop    %esi
  801b5e:	5f                   	pop    %edi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
  801b61:	8d 76 00             	lea    0x0(%esi),%esi
  801b64:	2b 04 24             	sub    (%esp),%eax
  801b67:	19 fa                	sbb    %edi,%edx
  801b69:	89 d1                	mov    %edx,%ecx
  801b6b:	89 c6                	mov    %eax,%esi
  801b6d:	e9 71 ff ff ff       	jmp    801ae3 <__umoddi3+0xb3>
  801b72:	66 90                	xchg   %ax,%ax
  801b74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b78:	72 ea                	jb     801b64 <__umoddi3+0x134>
  801b7a:	89 d9                	mov    %ebx,%ecx
  801b7c:	e9 62 ff ff ff       	jmp    801ae3 <__umoddi3+0xb3>
