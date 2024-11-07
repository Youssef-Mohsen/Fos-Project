
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 00 1e 80 00       	push   $0x801e00
  80005e:	e8 16 0a 00 00       	call   800a79 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 69 0e 00 00       	call   800ee2 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 25 18 00 00       	call   8018b1 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 1c 1e 80 00       	push   $0x801e1c
  80009e:	e8 d6 09 00 00       	call   800a79 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 29 0e 00 00       	call   800ee2 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 39 1e 80 00       	push   $0x801e39
  8000d0:	e8 3e 02 00 00       	call   800313 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 8b 14 00 00       	call   801571 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 02             	shl    $0x2,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	01 c0                	add    %eax,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	c1 e0 04             	shl    $0x4,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010d:	a1 04 30 80 00       	mov    0x803004,%eax
  800112:	8a 40 20             	mov    0x20(%eax),%al
  800115:	84 c0                	test   %al,%al
  800117:	74 0d                	je     800126 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800119:	a1 04 30 80 00       	mov    0x803004,%eax
  80011e:	83 c0 20             	add    $0x20,%eax
  800121:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012a:	7e 0a                	jle    800136 <libmain+0x5b>
		binaryname = argv[0];
  80012c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012f:	8b 00                	mov    (%eax),%eax
  800131:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	e8 f4 fe ff ff       	call   800038 <_main>
  800144:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800147:	e8 a9 11 00 00       	call   8012f5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 6c 1e 80 00       	push   $0x801e6c
  800154:	e8 8d 01 00 00       	call   8002e6 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015c:	a1 04 30 80 00       	mov    0x803004,%eax
  800161:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800167:	a1 04 30 80 00       	mov    0x803004,%eax
  80016c:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	68 94 1e 80 00       	push   $0x801e94
  80017c:	e8 65 01 00 00       	call   8002e6 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800184:	a1 04 30 80 00       	mov    0x803004,%eax
  800189:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80018f:	a1 04 30 80 00       	mov    0x803004,%eax
  800194:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80019a:	a1 04 30 80 00       	mov    0x803004,%eax
  80019f:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001a5:	51                   	push   %ecx
  8001a6:	52                   	push   %edx
  8001a7:	50                   	push   %eax
  8001a8:	68 bc 1e 80 00       	push   $0x801ebc
  8001ad:	e8 34 01 00 00       	call   8002e6 <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ba:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 14 1f 80 00       	push   $0x801f14
  8001c9:	e8 18 01 00 00       	call   8002e6 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 6c 1e 80 00       	push   $0x801e6c
  8001d9:	e8 08 01 00 00       	call   8002e6 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001e1:	e8 29 11 00 00       	call   80130f <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001e6:	e8 19 00 00 00       	call   800204 <exit>
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	e8 3f 13 00 00       	call   80153d <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
}
  800201:	90                   	nop
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <exit>:

void
exit(void)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020a:	e8 94 13 00 00       	call   8015a3 <sys_exit_env>
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	8b 00                	mov    (%eax),%eax
  80021d:	8d 48 01             	lea    0x1(%eax),%ecx
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	89 0a                	mov    %ecx,(%edx)
  800225:	8b 55 08             	mov    0x8(%ebp),%edx
  800228:	88 d1                	mov    %dl,%cl
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023b:	75 2c                	jne    800269 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80023d:	a0 08 30 80 00       	mov    0x803008,%al
  800242:	0f b6 c0             	movzbl %al,%eax
  800245:	8b 55 0c             	mov    0xc(%ebp),%edx
  800248:	8b 12                	mov    (%edx),%edx
  80024a:	89 d1                	mov    %edx,%ecx
  80024c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024f:	83 c2 08             	add    $0x8,%edx
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	50                   	push   %eax
  800256:	51                   	push   %ecx
  800257:	52                   	push   %edx
  800258:	e8 56 10 00 00       	call   8012b3 <sys_cputs>
  80025d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	8b 40 04             	mov    0x4(%eax),%eax
  80026f:	8d 50 01             	lea    0x1(%eax),%edx
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	89 50 04             	mov    %edx,0x4(%eax)
}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800284:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028b:	00 00 00 
	b.cnt = 0;
  80028e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800295:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 08             	pushl  0x8(%ebp)
  80029e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a4:	50                   	push   %eax
  8002a5:	68 12 02 80 00       	push   $0x800212
  8002aa:	e8 11 02 00 00       	call   8004c0 <vprintfmt>
  8002af:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b2:	a0 08 30 80 00       	mov    0x803008,%al
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c0:	83 ec 04             	sub    $0x4,%esp
  8002c3:	50                   	push   %eax
  8002c4:	52                   	push   %edx
  8002c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cb:	83 c0 08             	add    $0x8,%eax
  8002ce:	50                   	push   %eax
  8002cf:	e8 df 0f 00 00       	call   8012b3 <sys_cputs>
  8002d4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d7:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ec:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800302:	50                   	push   %eax
  800303:	e8 73 ff ff ff       	call   80027b <vcprintf>
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800319:	e8 d7 0f 00 00       	call   8012f5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80031e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800324:	8b 45 08             	mov    0x8(%ebp),%eax
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	ff 75 f4             	pushl  -0xc(%ebp)
  80032d:	50                   	push   %eax
  80032e:	e8 48 ff ff ff       	call   80027b <vcprintf>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800339:	e8 d1 0f 00 00       	call   80130f <sys_unlock_cons>
	return cnt;
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800341:	c9                   	leave  
  800342:	c3                   	ret    

00800343 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	53                   	push   %ebx
  800347:	83 ec 14             	sub    $0x14,%esp
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800356:	8b 45 18             	mov    0x18(%ebp),%eax
  800359:	ba 00 00 00 00       	mov    $0x0,%edx
  80035e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800361:	77 55                	ja     8003b8 <printnum+0x75>
  800363:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800366:	72 05                	jb     80036d <printnum+0x2a>
  800368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036b:	77 4b                	ja     8003b8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800370:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800373:	8b 45 18             	mov    0x18(%ebp),%eax
  800376:	ba 00 00 00 00       	mov    $0x0,%edx
  80037b:	52                   	push   %edx
  80037c:	50                   	push   %eax
  80037d:	ff 75 f4             	pushl  -0xc(%ebp)
  800380:	ff 75 f0             	pushl  -0x10(%ebp)
  800383:	e8 04 18 00 00       	call   801b8c <__udivdi3>
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	83 ec 04             	sub    $0x4,%esp
  80038e:	ff 75 20             	pushl  0x20(%ebp)
  800391:	53                   	push   %ebx
  800392:	ff 75 18             	pushl  0x18(%ebp)
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	ff 75 0c             	pushl  0xc(%ebp)
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 a1 ff ff ff       	call   800343 <printnum>
  8003a2:	83 c4 20             	add    $0x20,%esp
  8003a5:	eb 1a                	jmp    8003c1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	ff 75 0c             	pushl  0xc(%ebp)
  8003ad:	ff 75 20             	pushl  0x20(%ebp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	ff d0                	call   *%eax
  8003b5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003bf:	7f e6                	jg     8003a7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cf:	53                   	push   %ebx
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	e8 c4 18 00 00       	call   801c9c <__umoddi3>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	05 54 21 80 00       	add    $0x802154,%eax
  8003e0:	8a 00                	mov    (%eax),%al
  8003e2:	0f be c0             	movsbl %al,%eax
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	ff 75 0c             	pushl  0xc(%ebp)
  8003eb:	50                   	push   %eax
  8003ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ef:	ff d0                	call   *%eax
  8003f1:	83 c4 10             	add    $0x10,%esp
}
  8003f4:	90                   	nop
  8003f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800401:	7e 1c                	jle    80041f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	8d 50 08             	lea    0x8(%eax),%edx
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	89 10                	mov    %edx,(%eax)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	83 e8 08             	sub    $0x8,%eax
  800418:	8b 50 04             	mov    0x4(%eax),%edx
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	eb 40                	jmp    80045f <getuint+0x65>
	else if (lflag)
  80041f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800423:	74 1e                	je     800443 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 10                	mov    %edx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	83 e8 04             	sub    $0x4,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	eb 1c                	jmp    80045f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 04             	lea    0x4(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 04             	sub    $0x4,%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045f:	5d                   	pop    %ebp
  800460:	c3                   	ret    

00800461 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800464:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800468:	7e 1c                	jle    800486 <getint+0x25>
		return va_arg(*ap, long long);
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	8d 50 08             	lea    0x8(%eax),%edx
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	89 10                	mov    %edx,(%eax)
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	83 e8 08             	sub    $0x8,%eax
  80047f:	8b 50 04             	mov    0x4(%eax),%edx
  800482:	8b 00                	mov    (%eax),%eax
  800484:	eb 38                	jmp    8004be <getint+0x5d>
	else if (lflag)
  800486:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048a:	74 1a                	je     8004a6 <getint+0x45>
		return va_arg(*ap, long);
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	8d 50 04             	lea    0x4(%eax),%edx
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	89 10                	mov    %edx,(%eax)
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	83 e8 04             	sub    $0x4,%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	99                   	cltd   
  8004a4:	eb 18                	jmp    8004be <getint+0x5d>
	else
		return va_arg(*ap, int);
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
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	56                   	push   %esi
  8004c4:	53                   	push   %ebx
  8004c5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c8:	eb 17                	jmp    8004e1 <vprintfmt+0x21>
			if (ch == '\0')
  8004ca:	85 db                	test   %ebx,%ebx
  8004cc:	0f 84 c1 03 00 00    	je     800893 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	53                   	push   %ebx
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	ff d0                	call   *%eax
  8004de:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e4:	8d 50 01             	lea    0x1(%eax),%edx
  8004e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ea:	8a 00                	mov    (%eax),%al
  8004ec:	0f b6 d8             	movzbl %al,%ebx
  8004ef:	83 fb 25             	cmp    $0x25,%ebx
  8004f2:	75 d6                	jne    8004ca <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80050d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	8d 50 01             	lea    0x1(%eax),%edx
  80051a:	89 55 10             	mov    %edx,0x10(%ebp)
  80051d:	8a 00                	mov    (%eax),%al
  80051f:	0f b6 d8             	movzbl %al,%ebx
  800522:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800525:	83 f8 5b             	cmp    $0x5b,%eax
  800528:	0f 87 3d 03 00 00    	ja     80086b <vprintfmt+0x3ab>
  80052e:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  800535:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800537:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80053b:	eb d7                	jmp    800514 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800541:	eb d1                	jmp    800514 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800543:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	89 d0                	mov    %edx,%eax
  80054f:	c1 e0 02             	shl    $0x2,%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d8                	add    %ebx,%eax
  800558:	83 e8 30             	sub    $0x30,%eax
  80055b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80055e:	8b 45 10             	mov    0x10(%ebp),%eax
  800561:	8a 00                	mov    (%eax),%al
  800563:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800566:	83 fb 2f             	cmp    $0x2f,%ebx
  800569:	7e 3e                	jle    8005a9 <vprintfmt+0xe9>
  80056b:	83 fb 39             	cmp    $0x39,%ebx
  80056e:	7f 39                	jg     8005a9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800570:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800573:	eb d5                	jmp    80054a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 c0 04             	add    $0x4,%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 e8 04             	sub    $0x4,%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800589:	eb 1f                	jmp    8005aa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80058b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058f:	79 83                	jns    800514 <vprintfmt+0x54>
				width = 0;
  800591:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800598:	e9 77 ff ff ff       	jmp    800514 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80059d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a4:	e9 6b ff ff ff       	jmp    800514 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ae:	0f 89 60 ff ff ff    	jns    800514 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c1:	e9 4e ff ff ff       	jmp    800514 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c9:	e9 46 ff ff ff       	jmp    800514 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	83 c0 04             	add    $0x4,%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 e8 04             	sub    $0x4,%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	ff d0                	call   *%eax
  8005eb:	83 c4 10             	add    $0x10,%esp
			break;
  8005ee:	e9 9b 02 00 00       	jmp    80088e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	83 c0 04             	add    $0x4,%eax
  8005f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	83 e8 04             	sub    $0x4,%eax
  800602:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800604:	85 db                	test   %ebx,%ebx
  800606:	79 02                	jns    80060a <vprintfmt+0x14a>
				err = -err;
  800608:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060a:	83 fb 64             	cmp    $0x64,%ebx
  80060d:	7f 0b                	jg     80061a <vprintfmt+0x15a>
  80060f:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  800616:	85 f6                	test   %esi,%esi
  800618:	75 19                	jne    800633 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80061a:	53                   	push   %ebx
  80061b:	68 65 21 80 00       	push   $0x802165
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	e8 70 02 00 00       	call   80089b <printfmt>
  80062b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80062e:	e9 5b 02 00 00       	jmp    80088e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800633:	56                   	push   %esi
  800634:	68 6e 21 80 00       	push   $0x80216e
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	ff 75 08             	pushl  0x8(%ebp)
  80063f:	e8 57 02 00 00       	call   80089b <printfmt>
  800644:	83 c4 10             	add    $0x10,%esp
			break;
  800647:	e9 42 02 00 00       	jmp    80088e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	83 c0 04             	add    $0x4,%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 e8 04             	sub    $0x4,%eax
  80065b:	8b 30                	mov    (%eax),%esi
  80065d:	85 f6                	test   %esi,%esi
  80065f:	75 05                	jne    800666 <vprintfmt+0x1a6>
				p = "(null)";
  800661:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066a:	7e 6d                	jle    8006d9 <vprintfmt+0x219>
  80066c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800670:	74 67                	je     8006d9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	50                   	push   %eax
  800679:	56                   	push   %esi
  80067a:	e8 26 05 00 00       	call   800ba5 <strnlen>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800685:	eb 16                	jmp    80069d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800687:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	50                   	push   %eax
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	ff d0                	call   *%eax
  800697:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069a:	ff 4d e4             	decl   -0x1c(%ebp)
  80069d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a1:	7f e4                	jg     800687 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a3:	eb 34                	jmp    8006d9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a9:	74 1c                	je     8006c7 <vprintfmt+0x207>
  8006ab:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ae:	7e 05                	jle    8006b5 <vprintfmt+0x1f5>
  8006b0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b3:	7e 12                	jle    8006c7 <vprintfmt+0x207>
					putch('?', putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	6a 3f                	push   $0x3f
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	ff d0                	call   *%eax
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	eb 0f                	jmp    8006d6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d9:	89 f0                	mov    %esi,%eax
  8006db:	8d 70 01             	lea    0x1(%eax),%esi
  8006de:	8a 00                	mov    (%eax),%al
  8006e0:	0f be d8             	movsbl %al,%ebx
  8006e3:	85 db                	test   %ebx,%ebx
  8006e5:	74 24                	je     80070b <vprintfmt+0x24b>
  8006e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006eb:	78 b8                	js     8006a5 <vprintfmt+0x1e5>
  8006ed:	ff 4d e0             	decl   -0x20(%ebp)
  8006f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f4:	79 af                	jns    8006a5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f6:	eb 13                	jmp    80070b <vprintfmt+0x24b>
				putch(' ', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	6a 20                	push   $0x20
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800708:	ff 4d e4             	decl   -0x1c(%ebp)
  80070b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070f:	7f e7                	jg     8006f8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800711:	e9 78 01 00 00       	jmp    80088e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 e8             	pushl  -0x18(%ebp)
  80071c:	8d 45 14             	lea    0x14(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	e8 3c fd ff ff       	call   800461 <getint>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800734:	85 d2                	test   %edx,%edx
  800736:	79 23                	jns    80075b <vprintfmt+0x29b>
				putch('-', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	6a 2d                	push   $0x2d
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	ff d0                	call   *%eax
  800745:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074e:	f7 d8                	neg    %eax
  800750:	83 d2 00             	adc    $0x0,%edx
  800753:	f7 da                	neg    %edx
  800755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800758:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80075b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800762:	e9 bc 00 00 00       	jmp    800823 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 e8             	pushl  -0x18(%ebp)
  80076d:	8d 45 14             	lea    0x14(%ebp),%eax
  800770:	50                   	push   %eax
  800771:	e8 84 fc ff ff       	call   8003fa <getuint>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80077f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800786:	e9 98 00 00 00       	jmp    800823 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	6a 58                	push   $0x58
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 ce 00 00 00       	jmp    80088e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	ff 75 0c             	pushl  0xc(%ebp)
  8007c6:	6a 30                	push   $0x30
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	6a 78                	push   $0x78
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	ff d0                	call   *%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	83 c0 04             	add    $0x4,%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	83 e8 04             	sub    $0x4,%eax
  8007ef:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800802:	eb 1f                	jmp    800823 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	ff 75 e8             	pushl  -0x18(%ebp)
  80080a:	8d 45 14             	lea    0x14(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	e8 e7 fb ff ff       	call   8003fa <getuint>
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80081c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800823:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	52                   	push   %edx
  80082e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800831:	50                   	push   %eax
  800832:	ff 75 f4             	pushl  -0xc(%ebp)
  800835:	ff 75 f0             	pushl  -0x10(%ebp)
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	e8 00 fb ff ff       	call   800343 <printnum>
  800843:	83 c4 20             	add    $0x20,%esp
			break;
  800846:	eb 46                	jmp    80088e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
			break;
  800857:	eb 35                	jmp    80088e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800859:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800860:	eb 2c                	jmp    80088e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800862:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800869:	eb 23                	jmp    80088e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	6a 25                	push   $0x25
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	ff d0                	call   *%eax
  800878:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087b:	ff 4d 10             	decl   0x10(%ebp)
  80087e:	eb 03                	jmp    800883 <vprintfmt+0x3c3>
  800880:	ff 4d 10             	decl   0x10(%ebp)
  800883:	8b 45 10             	mov    0x10(%ebp),%eax
  800886:	48                   	dec    %eax
  800887:	8a 00                	mov    (%eax),%al
  800889:	3c 25                	cmp    $0x25,%al
  80088b:	75 f3                	jne    800880 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80088d:	90                   	nop
		}
	}
  80088e:	e9 35 fc ff ff       	jmp    8004c8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800893:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800894:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800897:	5b                   	pop    %ebx
  800898:	5e                   	pop    %esi
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a4:	83 c0 04             	add    $0x4,%eax
  8008a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 04 fc ff ff       	call   8004c0 <vprintfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008bf:	90                   	nop
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	8b 40 08             	mov    0x8(%eax),%eax
  8008cb:	8d 50 01             	lea    0x1(%eax),%edx
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	8b 10                	mov    (%eax),%edx
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8b 40 04             	mov    0x4(%eax),%eax
  8008df:	39 c2                	cmp    %eax,%edx
  8008e1:	73 12                	jae    8008f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8008e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ee:	89 0a                	mov    %ecx,(%edx)
  8008f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f3:	88 10                	mov    %dl,(%eax)
}
  8008f5:	90                   	nop
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8d 50 ff             	lea    -0x1(%eax),%edx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	01 d0                	add    %edx,%eax
  80090f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80091d:	74 06                	je     800925 <vsnprintf+0x2d>
  80091f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800923:	7f 07                	jg     80092c <vsnprintf+0x34>
		return -E_INVAL;
  800925:	b8 03 00 00 00       	mov    $0x3,%eax
  80092a:	eb 20                	jmp    80094c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80092c:	ff 75 14             	pushl  0x14(%ebp)
  80092f:	ff 75 10             	pushl  0x10(%ebp)
  800932:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800935:	50                   	push   %eax
  800936:	68 c2 08 80 00       	push   $0x8008c2
  80093b:	e8 80 fb ff ff       	call   8004c0 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800946:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800949:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800954:	8d 45 10             	lea    0x10(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80095d:	8b 45 10             	mov    0x10(%ebp),%eax
  800960:	ff 75 f4             	pushl  -0xc(%ebp)
  800963:	50                   	push   %eax
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	e8 89 ff ff ff       	call   8008f8 <vsnprintf>
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800975:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800980:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800984:	74 13                	je     800999 <readline+0x1f>
		cprintf("%s", prompt);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 08             	pushl  0x8(%ebp)
  80098c:	68 e8 22 80 00       	push   $0x8022e8
  800991:	e8 50 f9 ff ff       	call   8002e6 <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800999:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009a0:	83 ec 0c             	sub    $0xc,%esp
  8009a3:	6a 00                	push   $0x0
  8009a5:	e8 ed 0f 00 00       	call   801997 <iscons>
  8009aa:	83 c4 10             	add    $0x10,%esp
  8009ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009b0:	e8 cf 0f 00 00       	call   801984 <getchar>
  8009b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009bc:	79 22                	jns    8009e0 <readline+0x66>
			if (c != -E_EOF)
  8009be:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009c2:	0f 84 ad 00 00 00    	je     800a75 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ce:	68 eb 22 80 00       	push   $0x8022eb
  8009d3:	e8 0e f9 ff ff       	call   8002e6 <cprintf>
  8009d8:	83 c4 10             	add    $0x10,%esp
			break;
  8009db:	e9 95 00 00 00       	jmp    800a75 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009e0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009e4:	7e 34                	jle    800a1a <readline+0xa0>
  8009e6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009ed:	7f 2b                	jg     800a1a <readline+0xa0>
			if (echoing)
  8009ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009f3:	74 0e                	je     800a03 <readline+0x89>
				cputchar(c);
  8009f5:	83 ec 0c             	sub    $0xc,%esp
  8009f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8009fb:	e8 65 0f 00 00       	call   801965 <cputchar>
  800a00:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a06:	8d 50 01             	lea    0x1(%eax),%edx
  800a09:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a0c:	89 c2                	mov    %eax,%edx
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	01 d0                	add    %edx,%eax
  800a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a16:	88 10                	mov    %dl,(%eax)
  800a18:	eb 56                	jmp    800a70 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a1a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a1e:	75 1f                	jne    800a3f <readline+0xc5>
  800a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a24:	7e 19                	jle    800a3f <readline+0xc5>
			if (echoing)
  800a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a2a:	74 0e                	je     800a3a <readline+0xc0>
				cputchar(c);
  800a2c:	83 ec 0c             	sub    $0xc,%esp
  800a2f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a32:	e8 2e 0f 00 00       	call   801965 <cputchar>
  800a37:	83 c4 10             	add    $0x10,%esp

			i--;
  800a3a:	ff 4d f4             	decl   -0xc(%ebp)
  800a3d:	eb 31                	jmp    800a70 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a3f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a43:	74 0a                	je     800a4f <readline+0xd5>
  800a45:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a49:	0f 85 61 ff ff ff    	jne    8009b0 <readline+0x36>
			if (echoing)
  800a4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a53:	74 0e                	je     800a63 <readline+0xe9>
				cputchar(c);
  800a55:	83 ec 0c             	sub    $0xc,%esp
  800a58:	ff 75 ec             	pushl  -0x14(%ebp)
  800a5b:	e8 05 0f 00 00       	call   801965 <cputchar>
  800a60:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	01 d0                	add    %edx,%eax
  800a6b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a6e:	eb 06                	jmp    800a76 <readline+0xfc>
		}
	}
  800a70:	e9 3b ff ff ff       	jmp    8009b0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a75:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a76:	90                   	nop
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a7f:	e8 71 08 00 00       	call   8012f5 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a88:	74 13                	je     800a9d <atomic_readline+0x24>
			cprintf("%s", prompt);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 08             	pushl  0x8(%ebp)
  800a90:	68 e8 22 80 00       	push   $0x8022e8
  800a95:	e8 4c f8 ff ff       	call   8002e6 <cprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800aa4:	83 ec 0c             	sub    $0xc,%esp
  800aa7:	6a 00                	push   $0x0
  800aa9:	e8 e9 0e 00 00       	call   801997 <iscons>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ab4:	e8 cb 0e 00 00       	call   801984 <getchar>
  800ab9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800abc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ac0:	79 22                	jns    800ae4 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ac2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ac6:	0f 84 ad 00 00 00    	je     800b79 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad2:	68 eb 22 80 00       	push   $0x8022eb
  800ad7:	e8 0a f8 ff ff       	call   8002e6 <cprintf>
  800adc:	83 c4 10             	add    $0x10,%esp
				break;
  800adf:	e9 95 00 00 00       	jmp    800b79 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800ae4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ae8:	7e 34                	jle    800b1e <atomic_readline+0xa5>
  800aea:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800af1:	7f 2b                	jg     800b1e <atomic_readline+0xa5>
				if (echoing)
  800af3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af7:	74 0e                	je     800b07 <atomic_readline+0x8e>
					cputchar(c);
  800af9:	83 ec 0c             	sub    $0xc,%esp
  800afc:	ff 75 ec             	pushl  -0x14(%ebp)
  800aff:	e8 61 0e 00 00       	call   801965 <cputchar>
  800b04:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b0a:	8d 50 01             	lea    0x1(%eax),%edx
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b10:	89 c2                	mov    %eax,%edx
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	01 d0                	add    %edx,%eax
  800b17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1a:	88 10                	mov    %dl,(%eax)
  800b1c:	eb 56                	jmp    800b74 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b1e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b22:	75 1f                	jne    800b43 <atomic_readline+0xca>
  800b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b28:	7e 19                	jle    800b43 <atomic_readline+0xca>
				if (echoing)
  800b2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2e:	74 0e                	je     800b3e <atomic_readline+0xc5>
					cputchar(c);
  800b30:	83 ec 0c             	sub    $0xc,%esp
  800b33:	ff 75 ec             	pushl  -0x14(%ebp)
  800b36:	e8 2a 0e 00 00       	call   801965 <cputchar>
  800b3b:	83 c4 10             	add    $0x10,%esp
				i--;
  800b3e:	ff 4d f4             	decl   -0xc(%ebp)
  800b41:	eb 31                	jmp    800b74 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b43:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b47:	74 0a                	je     800b53 <atomic_readline+0xda>
  800b49:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b4d:	0f 85 61 ff ff ff    	jne    800ab4 <atomic_readline+0x3b>
				if (echoing)
  800b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b57:	74 0e                	je     800b67 <atomic_readline+0xee>
					cputchar(c);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b5f:	e8 01 0e 00 00       	call   801965 <cputchar>
  800b64:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	01 d0                	add    %edx,%eax
  800b6f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b72:	eb 06                	jmp    800b7a <atomic_readline+0x101>
			}
		}
  800b74:	e9 3b ff ff ff       	jmp    800ab4 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b79:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b7a:	e8 90 07 00 00       	call   80130f <sys_unlock_cons>
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b8f:	eb 06                	jmp    800b97 <strlen+0x15>
		n++;
  800b91:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 f1                	jne    800b91 <strlen+0xf>
		n++;
	return n;
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb2:	eb 09                	jmp    800bbd <strnlen+0x18>
		n++;
  800bb4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb7:	ff 45 08             	incl   0x8(%ebp)
  800bba:	ff 4d 0c             	decl   0xc(%ebp)
  800bbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc1:	74 09                	je     800bcc <strnlen+0x27>
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 e8                	jne    800bb4 <strnlen+0xf>
		n++;
	return n;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bdd:	90                   	nop
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8d 50 01             	lea    0x1(%eax),%edx
  800be4:	89 55 08             	mov    %edx,0x8(%ebp)
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bf0:	8a 12                	mov    (%edx),%dl
  800bf2:	88 10                	mov    %dl,(%eax)
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	75 e4                	jne    800bde <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c12:	eb 1f                	jmp    800c33 <strncpy+0x34>
		*dst++ = *src;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8a 12                	mov    (%edx),%dl
  800c22:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 03                	je     800c30 <strncpy+0x31>
			src++;
  800c2d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c30:	ff 45 fc             	incl   -0x4(%ebp)
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c36:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c39:	72 d9                	jb     800c14 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c50:	74 30                	je     800c82 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c52:	eb 16                	jmp    800c6a <strlcpy+0x2a>
			*dst++ = *src++;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8d 50 01             	lea    0x1(%eax),%edx
  800c5a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c66:	8a 12                	mov    (%edx),%dl
  800c68:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c6a:	ff 4d 10             	decl   0x10(%ebp)
  800c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c71:	74 09                	je     800c7c <strlcpy+0x3c>
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 d8                	jne    800c54 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c88:	29 c2                	sub    %eax,%edx
  800c8a:	89 d0                	mov    %edx,%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strcmp+0xb>
		p++, q++;
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	74 0e                	je     800cb0 <strcmp+0x22>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 10                	mov    (%eax),%dl
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	38 c2                	cmp    %al,%dl
  800cae:	74 e3                	je     800c93 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	0f b6 d0             	movzbl %al,%edx
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f b6 c0             	movzbl %al,%eax
  800cc0:	29 c2                	sub    %eax,%edx
  800cc2:	89 d0                	mov    %edx,%eax
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc9:	eb 09                	jmp    800cd4 <strncmp+0xe>
		n--, p++, q++;
  800ccb:	ff 4d 10             	decl   0x10(%ebp)
  800cce:	ff 45 08             	incl   0x8(%ebp)
  800cd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 17                	je     800cf1 <strncmp+0x2b>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0e                	je     800cf1 <strncmp+0x2b>
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 10                	mov    (%eax),%dl
  800ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	38 c2                	cmp    %al,%dl
  800cef:	74 da                	je     800ccb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	75 07                	jne    800cfe <strncmp+0x38>
		return 0;
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	eb 14                	jmp    800d12 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 d0             	movzbl %al,%edx
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 c0             	movzbl %al,%eax
  800d0e:	29 c2                	sub    %eax,%edx
  800d10:	89 d0                	mov    %edx,%eax
}
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d20:	eb 12                	jmp    800d34 <strchr+0x20>
		if (*s == c)
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d2a:	75 05                	jne    800d31 <strchr+0x1d>
			return (char *) s;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	eb 11                	jmp    800d42 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 e5                	jne    800d22 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d50:	eb 0d                	jmp    800d5f <strfind+0x1b>
		if (*s == c)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5a:	74 0e                	je     800d6a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 ea                	jne    800d52 <strfind+0xe>
  800d68:	eb 01                	jmp    800d6b <strfind+0x27>
		if (*s == c)
			break;
  800d6a:	90                   	nop
	return (char *) s;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d82:	eb 0e                	jmp    800d92 <memset+0x22>
		*p++ = c;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	8d 50 01             	lea    0x1(%eax),%edx
  800d8a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d90:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d92:	ff 4d f8             	decl   -0x8(%ebp)
  800d95:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d99:	79 e9                	jns    800d84 <memset+0x14>
		*p++ = c;

	return v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800db2:	eb 16                	jmp    800dca <memcpy+0x2a>
		*d++ = *s++;
  800db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db7:	8d 50 01             	lea    0x1(%eax),%edx
  800dba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dc6:	8a 12                	mov    (%edx),%dl
  800dc8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dca:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	75 dd                	jne    800db4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df4:	73 50                	jae    800e46 <memmove+0x6a>
  800df6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e01:	76 43                	jbe    800e46 <memmove+0x6a>
		s += n;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e09:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e0f:	eb 10                	jmp    800e21 <memmove+0x45>
			*--d = *--s;
  800e11:	ff 4d f8             	decl   -0x8(%ebp)
  800e14:	ff 4d fc             	decl   -0x4(%ebp)
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1a:	8a 10                	mov    (%eax),%dl
  800e1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e27:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 e3                	jne    800e11 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e2e:	eb 23                	jmp    800e53 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e33:	8d 50 01             	lea    0x1(%eax),%edx
  800e36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 dd                	jne    800e30 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6a:	eb 2a                	jmp    800e96 <memcmp+0x3e>
		if (*s1 != *s2)
  800e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6f:	8a 10                	mov    (%eax),%dl
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	38 c2                	cmp    %al,%dl
  800e78:	74 16                	je     800e90 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8a 00                	mov    (%eax),%al
  800e7f:	0f b6 d0             	movzbl %al,%edx
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	0f b6 c0             	movzbl %al,%eax
  800e8a:	29 c2                	sub    %eax,%edx
  800e8c:	89 d0                	mov    %edx,%eax
  800e8e:	eb 18                	jmp    800ea8 <memcmp+0x50>
		s1++, s2++;
  800e90:	ff 45 fc             	incl   -0x4(%ebp)
  800e93:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	75 c9                	jne    800e6c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	01 d0                	add    %edx,%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ebb:	eb 15                	jmp    800ed2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	0f b6 c0             	movzbl %al,%eax
  800ecb:	39 c2                	cmp    %eax,%edx
  800ecd:	74 0d                	je     800edc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ed8:	72 e3                	jb     800ebd <memfind+0x13>
  800eda:	eb 01                	jmp    800edd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800edc:	90                   	nop
	return (void *) s;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee0:	c9                   	leave  
  800ee1:	c3                   	ret    

00800ee2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800eef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef6:	eb 03                	jmp    800efb <strtol+0x19>
		s++;
  800ef8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 20                	cmp    $0x20,%al
  800f02:	74 f4                	je     800ef8 <strtol+0x16>
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 09                	cmp    $0x9,%al
  800f0b:	74 eb                	je     800ef8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	3c 2b                	cmp    $0x2b,%al
  800f14:	75 05                	jne    800f1b <strtol+0x39>
		s++;
  800f16:	ff 45 08             	incl   0x8(%ebp)
  800f19:	eb 13                	jmp    800f2e <strtol+0x4c>
	else if (*s == '-')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 2d                	cmp    $0x2d,%al
  800f22:	75 0a                	jne    800f2e <strtol+0x4c>
		s++, neg = 1;
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 06                	je     800f3a <strtol+0x58>
  800f34:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f38:	75 20                	jne    800f5a <strtol+0x78>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 30                	cmp    $0x30,%al
  800f41:	75 17                	jne    800f5a <strtol+0x78>
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	40                   	inc    %eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3c 78                	cmp    $0x78,%al
  800f4b:	75 0d                	jne    800f5a <strtol+0x78>
		s += 2, base = 16;
  800f4d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f51:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f58:	eb 28                	jmp    800f82 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	75 15                	jne    800f75 <strtol+0x93>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 30                	cmp    $0x30,%al
  800f67:	75 0c                	jne    800f75 <strtol+0x93>
		s++, base = 8;
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f73:	eb 0d                	jmp    800f82 <strtol+0xa0>
	else if (base == 0)
  800f75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f79:	75 07                	jne    800f82 <strtol+0xa0>
		base = 10;
  800f7b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 2f                	cmp    $0x2f,%al
  800f89:	7e 19                	jle    800fa4 <strtol+0xc2>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 39                	cmp    $0x39,%al
  800f92:	7f 10                	jg     800fa4 <strtol+0xc2>
			dig = *s - '0';
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	0f be c0             	movsbl %al,%eax
  800f9c:	83 e8 30             	sub    $0x30,%eax
  800f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa2:	eb 42                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 60                	cmp    $0x60,%al
  800fab:	7e 19                	jle    800fc6 <strtol+0xe4>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 7a                	cmp    $0x7a,%al
  800fb4:	7f 10                	jg     800fc6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	83 e8 57             	sub    $0x57,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc4:	eb 20                	jmp    800fe6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 40                	cmp    $0x40,%al
  800fcd:	7e 39                	jle    801008 <strtol+0x126>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 5a                	cmp    $0x5a,%al
  800fd6:	7f 30                	jg     801008 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 37             	sub    $0x37,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fec:	7d 19                	jge    801007 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffd:	01 d0                	add    %edx,%eax
  800fff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801002:	e9 7b ff ff ff       	jmp    800f82 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801007:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	74 08                	je     801016 <strtol+0x134>
		*endptr = (char *) s;
  80100e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80101a:	74 07                	je     801023 <strtol+0x141>
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	f7 d8                	neg    %eax
  801021:	eb 03                	jmp    801026 <strtol+0x144>
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <ltostr>:

void
ltostr(long value, char *str)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801035:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80103c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801040:	79 13                	jns    801055 <ltostr+0x2d>
	{
		neg = 1;
  801042:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80104f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801052:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80105d:	99                   	cltd   
  80105e:	f7 f9                	idiv   %ecx
  801060:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801063:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801066:	8d 50 01             	lea    0x1(%eax),%edx
  801069:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801076:	83 c2 30             	add    $0x30,%edx
  801079:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801083:	f7 e9                	imul   %ecx
  801085:	c1 fa 02             	sar    $0x2,%edx
  801088:	89 c8                	mov    %ecx,%eax
  80108a:	c1 f8 1f             	sar    $0x1f,%eax
  80108d:	29 c2                	sub    %eax,%edx
  80108f:	89 d0                	mov    %edx,%eax
  801091:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801098:	75 bb                	jne    801055 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80109a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	48                   	dec    %eax
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ac:	74 3d                	je     8010eb <ltostr+0xc3>
		start = 1 ;
  8010ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010b5:	eb 34                	jmp    8010eb <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	01 d0                	add    %edx,%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	01 c2                	add    %eax,%edx
  8010cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	01 c8                	add    %ecx,%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8010e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f1:	7c c4                	jl     8010b7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	01 d0                	add    %edx,%eax
  8010fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010fe:	90                   	nop
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	e8 73 fa ff ff       	call   800b82 <strlen>
  80110f:	83 c4 04             	add    $0x4,%esp
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	e8 65 fa ff ff       	call   800b82 <strlen>
  80111d:	83 c4 04             	add    $0x4,%esp
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80112a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801131:	eb 17                	jmp    80114a <strcconcat+0x49>
		final[s] = str1[s] ;
  801133:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	01 c2                	add    %eax,%edx
  80113b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	01 c8                	add    %ecx,%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801147:	ff 45 fc             	incl   -0x4(%ebp)
  80114a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801150:	7c e1                	jl     801133 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801152:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801159:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801160:	eb 1f                	jmp    801181 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801162:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801165:	8d 50 01             	lea    0x1(%eax),%edx
  801168:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80116b:	89 c2                	mov    %eax,%edx
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	01 c2                	add    %eax,%edx
  801172:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	01 c8                	add    %ecx,%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80117e:	ff 45 f8             	incl   -0x8(%ebp)
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801187:	7c d9                	jl     801162 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801189:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	c6 00 00             	movb   $0x0,(%eax)
}
  801194:	90                   	nop
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80119a:	8b 45 14             	mov    0x14(%ebp),%eax
  80119d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a6:	8b 00                	mov    (%eax),%eax
  8011a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ba:	eb 0c                	jmp    8011c8 <strsplit+0x31>
			*string++ = 0;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8d 50 01             	lea    0x1(%eax),%edx
  8011c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	84 c0                	test   %al,%al
  8011cf:	74 18                	je     8011e9 <strsplit+0x52>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	50                   	push   %eax
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	e8 32 fb ff ff       	call   800d14 <strchr>
  8011e2:	83 c4 08             	add    $0x8,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	75 d3                	jne    8011bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	74 5a                	je     80124c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f5:	8b 00                	mov    (%eax),%eax
  8011f7:	83 f8 0f             	cmp    $0xf,%eax
  8011fa:	75 07                	jne    801203 <strsplit+0x6c>
		{
			return 0;
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801201:	eb 66                	jmp    801269 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801203:	8b 45 14             	mov    0x14(%ebp),%eax
  801206:	8b 00                	mov    (%eax),%eax
  801208:	8d 48 01             	lea    0x1(%eax),%ecx
  80120b:	8b 55 14             	mov    0x14(%ebp),%edx
  80120e:	89 0a                	mov    %ecx,(%edx)
  801210:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	01 c2                	add    %eax,%edx
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801221:	eb 03                	jmp    801226 <strsplit+0x8f>
			string++;
  801223:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	84 c0                	test   %al,%al
  80122d:	74 8b                	je     8011ba <strsplit+0x23>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	0f be c0             	movsbl %al,%eax
  801237:	50                   	push   %eax
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	e8 d4 fa ff ff       	call   800d14 <strchr>
  801240:	83 c4 08             	add    $0x8,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	74 dc                	je     801223 <strsplit+0x8c>
			string++;
	}
  801247:	e9 6e ff ff ff       	jmp    8011ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80124c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801264:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	68 fc 22 80 00       	push   $0x8022fc
  801279:	68 3f 01 00 00       	push   $0x13f
  80127e:	68 1e 23 80 00       	push   $0x80231e
  801283:	e8 19 07 00 00       	call   8019a1 <_panic>

00801288 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	57                   	push   %edi
  80128c:	56                   	push   %esi
  80128d:	53                   	push   %ebx
  80128e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8b 55 0c             	mov    0xc(%ebp),%edx
  801297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80129d:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012a0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012a3:	cd 30                	int    $0x30
  8012a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5f                   	pop    %edi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 04             	sub    $0x4,%esp
  8012b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	52                   	push   %edx
  8012cb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ce:	50                   	push   %eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 b2 ff ff ff       	call   801288 <syscall>
  8012d6:	83 c4 18             	add    $0x18,%esp
}
  8012d9:	90                   	nop
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 02                	push   $0x2
  8012eb:	e8 98 ff ff ff       	call   801288 <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 03                	push   $0x3
  801304:	e8 7f ff ff ff       	call   801288 <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	90                   	nop
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 04                	push   $0x4
  80131e:	e8 65 ff ff ff       	call   801288 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80132c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	52                   	push   %edx
  801339:	50                   	push   %eax
  80133a:	6a 08                	push   $0x8
  80133c:	e8 47 ff ff ff       	call   801288 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80134b:	8b 75 18             	mov    0x18(%ebp),%esi
  80134e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801351:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	51                   	push   %ecx
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	6a 09                	push   $0x9
  801361:	e8 22 ff ff ff       	call   801288 <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136c:	5b                   	pop    %ebx
  80136d:	5e                   	pop    %esi
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801373:	8b 55 0c             	mov    0xc(%ebp),%edx
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	52                   	push   %edx
  801380:	50                   	push   %eax
  801381:	6a 0a                	push   $0xa
  801383:	e8 00 ff ff ff       	call   801288 <syscall>
  801388:	83 c4 18             	add    $0x18,%esp
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	ff 75 08             	pushl  0x8(%ebp)
  80139c:	6a 0b                	push   $0xb
  80139e:	e8 e5 fe ff ff       	call   801288 <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 0c                	push   $0xc
  8013b7:	e8 cc fe ff ff       	call   801288 <syscall>
  8013bc:	83 c4 18             	add    $0x18,%esp
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 0d                	push   $0xd
  8013d0:	e8 b3 fe ff ff       	call   801288 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 0e                	push   $0xe
  8013e9:	e8 9a fe ff ff       	call   801288 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 0f                	push   $0xf
  801402:	e8 81 fe ff ff       	call   801288 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	ff 75 08             	pushl  0x8(%ebp)
  80141a:	6a 10                	push   $0x10
  80141c:	e8 67 fe ff ff       	call   801288 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 11                	push   $0x11
  801435:	e8 4e fe ff ff       	call   801288 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_cputc>:

void
sys_cputc(const char c)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 04             	sub    $0x4,%esp
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80144c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	50                   	push   %eax
  801459:	6a 01                	push   $0x1
  80145b:	e8 28 fe ff ff       	call   801288 <syscall>
  801460:	83 c4 18             	add    $0x18,%esp
}
  801463:	90                   	nop
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 14                	push   $0x14
  801475:	e8 0e fe ff ff       	call   801288 <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	90                   	nop
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	8b 45 10             	mov    0x10(%ebp),%eax
  801489:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80148c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	51                   	push   %ecx
  801499:	52                   	push   %edx
  80149a:	ff 75 0c             	pushl  0xc(%ebp)
  80149d:	50                   	push   %eax
  80149e:	6a 15                	push   $0x15
  8014a0:	e8 e3 fd ff ff       	call   801288 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	50                   	push   %eax
  8014bb:	6a 16                	push   $0x16
  8014bd:	e8 c6 fd ff ff       	call   801288 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	51                   	push   %ecx
  8014d8:	52                   	push   %edx
  8014d9:	50                   	push   %eax
  8014da:	6a 17                	push   $0x17
  8014dc:	e8 a7 fd ff ff       	call   801288 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	52                   	push   %edx
  8014f6:	50                   	push   %eax
  8014f7:	6a 18                	push   $0x18
  8014f9:	e8 8a fd ff ff       	call   801288 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	ff 75 14             	pushl  0x14(%ebp)
  80150e:	ff 75 10             	pushl  0x10(%ebp)
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	50                   	push   %eax
  801515:	6a 19                	push   $0x19
  801517:	e8 6c fd ff ff       	call   801288 <syscall>
  80151c:	83 c4 18             	add    $0x18,%esp
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	50                   	push   %eax
  801530:	6a 1a                	push   $0x1a
  801532:	e8 51 fd ff ff       	call   801288 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	90                   	nop
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	50                   	push   %eax
  80154c:	6a 1b                	push   $0x1b
  80154e:	e8 35 fd ff ff       	call   801288 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 05                	push   $0x5
  801567:	e8 1c fd ff ff       	call   801288 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 06                	push   $0x6
  801580:	e8 03 fd ff ff       	call   801288 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 07                	push   $0x7
  801599:	e8 ea fc ff ff       	call   801288 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_exit_env>:


void sys_exit_env(void)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 1c                	push   $0x1c
  8015b2:	e8 d1 fc ff ff       	call   801288 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
}
  8015ba:	90                   	nop
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015c3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015c6:	8d 50 04             	lea    0x4(%eax),%edx
  8015c9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	52                   	push   %edx
  8015d3:	50                   	push   %eax
  8015d4:	6a 1d                	push   $0x1d
  8015d6:	e8 ad fc ff ff       	call   801288 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
	return result;
  8015de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e7:	89 01                	mov    %eax,(%ecx)
  8015e9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	c9                   	leave  
  8015f0:	c2 04 00             	ret    $0x4

008015f3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	ff 75 10             	pushl  0x10(%ebp)
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	ff 75 08             	pushl  0x8(%ebp)
  801603:	6a 13                	push   $0x13
  801605:	e8 7e fc ff ff       	call   801288 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
	return ;
  80160d:	90                   	nop
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_rcr2>:
uint32 sys_rcr2()
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 1e                	push   $0x1e
  80161f:	e8 64 fc ff ff       	call   801288 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801635:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	50                   	push   %eax
  801642:	6a 1f                	push   $0x1f
  801644:	e8 3f fc ff ff       	call   801288 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
	return ;
  80164c:	90                   	nop
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <rsttst>:
void rsttst()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 21                	push   $0x21
  80165e:	e8 25 fc ff ff       	call   801288 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return ;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 14             	mov    0x14(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801675:	8b 55 18             	mov    0x18(%ebp),%edx
  801678:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	ff 75 10             	pushl  0x10(%ebp)
  801681:	ff 75 0c             	pushl  0xc(%ebp)
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	6a 20                	push   $0x20
  801689:	e8 fa fb ff ff       	call   801288 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
	return ;
  801691:	90                   	nop
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <chktst>:
void chktst(uint32 n)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	6a 22                	push   $0x22
  8016a4:	e8 df fb ff ff       	call   801288 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ac:	90                   	nop
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <inctst>:

void inctst()
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 23                	push   $0x23
  8016be:	e8 c5 fb ff ff       	call   801288 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c6:	90                   	nop
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <gettst>:
uint32 gettst()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 24                	push   $0x24
  8016d8:	e8 ab fb ff ff       	call   801288 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 25                	push   $0x25
  8016f4:	e8 8f fb ff ff       	call   801288 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
  8016fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016ff:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801703:	75 07                	jne    80170c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801705:	b8 01 00 00 00       	mov    $0x1,%eax
  80170a:	eb 05                	jmp    801711 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 25                	push   $0x25
  801725:	e8 5e fb ff ff       	call   801288 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
  80172d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801730:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801734:	75 07                	jne    80173d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801736:	b8 01 00 00 00       	mov    $0x1,%eax
  80173b:	eb 05                	jmp    801742 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 25                	push   $0x25
  801756:	e8 2d fb ff ff       	call   801288 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
  80175e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801761:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801765:	75 07                	jne    80176e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801767:	b8 01 00 00 00       	mov    $0x1,%eax
  80176c:	eb 05                	jmp    801773 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 25                	push   $0x25
  801787:	e8 fc fa ff ff       	call   801288 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
  80178f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801792:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801796:	75 07                	jne    80179f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801798:	b8 01 00 00 00       	mov    $0x1,%eax
  80179d:	eb 05                	jmp    8017a4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 26                	push   $0x26
  8017b6:	e8 cd fa ff ff       	call   801288 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	53                   	push   %ebx
  8017d4:	51                   	push   %ecx
  8017d5:	52                   	push   %edx
  8017d6:	50                   	push   %eax
  8017d7:	6a 27                	push   $0x27
  8017d9:	e8 aa fa ff ff       	call   801288 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 28                	push   $0x28
  8017f9:	e8 8a fa ff ff       	call   801288 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801806:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	6a 00                	push   $0x0
  801811:	51                   	push   %ecx
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	52                   	push   %edx
  801816:	50                   	push   %eax
  801817:	6a 29                	push   $0x29
  801819:	e8 6a fa ff ff       	call   801288 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	ff 75 10             	pushl  0x10(%ebp)
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 12                	push   $0x12
  801835:	e8 4e fa ff ff       	call   801288 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return ;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	52                   	push   %edx
  801850:	50                   	push   %eax
  801851:	6a 2a                	push   $0x2a
  801853:	e8 30 fa ff ff       	call   801288 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
	return;
  80185b:	90                   	nop
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	50                   	push   %eax
  80186d:	6a 2b                	push   $0x2b
  80186f:	e8 14 fa ff ff       	call   801288 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	ff 75 08             	pushl  0x8(%ebp)
  801888:	6a 2c                	push   $0x2c
  80188a:	e8 f9 f9 ff ff       	call   801288 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
	return;
  801892:	90                   	nop
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 2d                	push   $0x2d
  8018a6:	e8 dd f9 ff ff       	call   801288 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ba:	89 d0                	mov    %edx,%eax
  8018bc:	c1 e0 02             	shl    $0x2,%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d1:	01 d0                	add    %edx,%eax
  8018d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	c1 e0 04             	shl    $0x4,%eax
  8018df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8018e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8018e9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8018ec:	83 ec 0c             	sub    $0xc,%esp
  8018ef:	50                   	push   %eax
  8018f0:	e8 c8 fc ff ff       	call   8015bd <sys_get_virtual_time>
  8018f5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8018f8:	eb 41                	jmp    80193b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8018fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	50                   	push   %eax
  801901:	e8 b7 fc ff ff       	call   8015bd <sys_get_virtual_time>
  801906:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80190c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801916:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191c:	89 d1                	mov    %edx,%ecx
  80191e:	29 c1                	sub    %eax,%ecx
  801920:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801926:	39 c2                	cmp    %eax,%edx
  801928:	0f 97 c0             	seta   %al
  80192b:	0f b6 c0             	movzbl %al,%eax
  80192e:	29 c1                	sub    %eax,%ecx
  801930:	89 c8                	mov    %ecx,%eax
  801932:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801935:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801938:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801941:	72 b7                	jb     8018fa <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80194c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801953:	eb 03                	jmp    801958 <busy_wait+0x12>
  801955:	ff 45 fc             	incl   -0x4(%ebp)
  801958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80195e:	72 f5                	jb     801955 <busy_wait+0xf>
	return i;
  801960:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801971:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	50                   	push   %eax
  801979:	e8 c2 fa ff ff       	call   801440 <sys_cputc>
  80197e:	83 c4 10             	add    $0x10,%esp
}
  801981:	90                   	nop
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <getchar>:


int
getchar(void)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80198a:	e8 4d f9 ff ff       	call   8012dc <sys_cgetc>
  80198f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801992:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <iscons>:

int iscons(int fdnum)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80199a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8019aa:	83 c0 04             	add    $0x4,%eax
  8019ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019b0:	a1 24 30 80 00       	mov    0x803024,%eax
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	74 16                	je     8019cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019b9:	a1 24 30 80 00       	mov    0x803024,%eax
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	50                   	push   %eax
  8019c2:	68 2c 23 80 00       	push   $0x80232c
  8019c7:	e8 1a e9 ff ff       	call   8002e6 <cprintf>
  8019cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019cf:	a1 00 30 80 00       	mov    0x803000,%eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	50                   	push   %eax
  8019db:	68 31 23 80 00       	push   $0x802331
  8019e0:	e8 01 e9 ff ff       	call   8002e6 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019eb:	83 ec 08             	sub    $0x8,%esp
  8019ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f1:	50                   	push   %eax
  8019f2:	e8 84 e8 ff ff       	call   80027b <vcprintf>
  8019f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019fa:	83 ec 08             	sub    $0x8,%esp
  8019fd:	6a 00                	push   $0x0
  8019ff:	68 4d 23 80 00       	push   $0x80234d
  801a04:	e8 72 e8 ff ff       	call   80027b <vcprintf>
  801a09:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a0c:	e8 f3 e7 ff ff       	call   800204 <exit>

	// should not return here
	while (1) ;
  801a11:	eb fe                	jmp    801a11 <_panic+0x70>

00801a13 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a19:	a1 04 30 80 00       	mov    0x803004,%eax
  801a1e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	39 c2                	cmp    %eax,%edx
  801a29:	74 14                	je     801a3f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	68 50 23 80 00       	push   $0x802350
  801a33:	6a 26                	push   $0x26
  801a35:	68 9c 23 80 00       	push   $0x80239c
  801a3a:	e8 62 ff ff ff       	call   8019a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a4d:	e9 c5 00 00 00       	jmp    801b17 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	01 d0                	add    %edx,%eax
  801a61:	8b 00                	mov    (%eax),%eax
  801a63:	85 c0                	test   %eax,%eax
  801a65:	75 08                	jne    801a6f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a67:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a6a:	e9 a5 00 00 00       	jmp    801b14 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a6f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a7d:	eb 69                	jmp    801ae8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a7f:	a1 04 30 80 00       	mov    0x803004,%eax
  801a84:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a8d:	89 d0                	mov    %edx,%eax
  801a8f:	01 c0                	add    %eax,%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	c1 e0 03             	shl    $0x3,%eax
  801a96:	01 c8                	add    %ecx,%eax
  801a98:	8a 40 04             	mov    0x4(%eax),%al
  801a9b:	84 c0                	test   %al,%al
  801a9d:	75 46                	jne    801ae5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a9f:	a1 04 30 80 00       	mov    0x803004,%eax
  801aa4:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801aaa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	01 c0                	add    %eax,%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	c1 e0 03             	shl    $0x3,%eax
  801ab6:	01 c8                	add    %ecx,%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801abd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ac5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	01 c8                	add    %ecx,%eax
  801ad6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ad8:	39 c2                	cmp    %eax,%edx
  801ada:	75 09                	jne    801ae5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801adc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ae3:	eb 15                	jmp    801afa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ae5:	ff 45 e8             	incl   -0x18(%ebp)
  801ae8:	a1 04 30 80 00       	mov    0x803004,%eax
  801aed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af6:	39 c2                	cmp    %eax,%edx
  801af8:	77 85                	ja     801a7f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801afa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801afe:	75 14                	jne    801b14 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	68 a8 23 80 00       	push   $0x8023a8
  801b08:	6a 3a                	push   $0x3a
  801b0a:	68 9c 23 80 00       	push   $0x80239c
  801b0f:	e8 8d fe ff ff       	call   8019a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b14:	ff 45 f0             	incl   -0x10(%ebp)
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b1d:	0f 8c 2f ff ff ff    	jl     801a52 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b31:	eb 26                	jmp    801b59 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b33:	a1 04 30 80 00       	mov    0x803004,%eax
  801b38:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	01 c0                	add    %eax,%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	c1 e0 03             	shl    $0x3,%eax
  801b4a:	01 c8                	add    %ecx,%eax
  801b4c:	8a 40 04             	mov    0x4(%eax),%al
  801b4f:	3c 01                	cmp    $0x1,%al
  801b51:	75 03                	jne    801b56 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b53:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b56:	ff 45 e0             	incl   -0x20(%ebp)
  801b59:	a1 04 30 80 00       	mov    0x803004,%eax
  801b5e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b67:	39 c2                	cmp    %eax,%edx
  801b69:	77 c8                	ja     801b33 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b71:	74 14                	je     801b87 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	68 fc 23 80 00       	push   $0x8023fc
  801b7b:	6a 44                	push   $0x44
  801b7d:	68 9c 23 80 00       	push   $0x80239c
  801b82:	e8 1a fe ff ff       	call   8019a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b87:	90                   	nop
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    
  801b8a:	66 90                	xchg   %ax,%ax

00801b8c <__udivdi3>:
  801b8c:	55                   	push   %ebp
  801b8d:	57                   	push   %edi
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 1c             	sub    $0x1c,%esp
  801b93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ba3:	89 ca                	mov    %ecx,%edx
  801ba5:	89 f8                	mov    %edi,%eax
  801ba7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bab:	85 f6                	test   %esi,%esi
  801bad:	75 2d                	jne    801bdc <__udivdi3+0x50>
  801baf:	39 cf                	cmp    %ecx,%edi
  801bb1:	77 65                	ja     801c18 <__udivdi3+0x8c>
  801bb3:	89 fd                	mov    %edi,%ebp
  801bb5:	85 ff                	test   %edi,%edi
  801bb7:	75 0b                	jne    801bc4 <__udivdi3+0x38>
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	31 d2                	xor    %edx,%edx
  801bc0:	f7 f7                	div    %edi
  801bc2:	89 c5                	mov    %eax,%ebp
  801bc4:	31 d2                	xor    %edx,%edx
  801bc6:	89 c8                	mov    %ecx,%eax
  801bc8:	f7 f5                	div    %ebp
  801bca:	89 c1                	mov    %eax,%ecx
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	f7 f5                	div    %ebp
  801bd0:	89 cf                	mov    %ecx,%edi
  801bd2:	89 fa                	mov    %edi,%edx
  801bd4:	83 c4 1c             	add    $0x1c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	39 ce                	cmp    %ecx,%esi
  801bde:	77 28                	ja     801c08 <__udivdi3+0x7c>
  801be0:	0f bd fe             	bsr    %esi,%edi
  801be3:	83 f7 1f             	xor    $0x1f,%edi
  801be6:	75 40                	jne    801c28 <__udivdi3+0x9c>
  801be8:	39 ce                	cmp    %ecx,%esi
  801bea:	72 0a                	jb     801bf6 <__udivdi3+0x6a>
  801bec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf0:	0f 87 9e 00 00 00    	ja     801c94 <__udivdi3+0x108>
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	89 fa                	mov    %edi,%edx
  801bfd:	83 c4 1c             	add    $0x1c,%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
  801c05:	8d 76 00             	lea    0x0(%esi),%esi
  801c08:	31 ff                	xor    %edi,%edi
  801c0a:	31 c0                	xor    %eax,%eax
  801c0c:	89 fa                	mov    %edi,%edx
  801c0e:	83 c4 1c             	add    $0x1c,%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5e                   	pop    %esi
  801c13:	5f                   	pop    %edi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    
  801c16:	66 90                	xchg   %ax,%ax
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	f7 f7                	div    %edi
  801c1c:	31 ff                	xor    %edi,%edi
  801c1e:	89 fa                	mov    %edi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c2d:	89 eb                	mov    %ebp,%ebx
  801c2f:	29 fb                	sub    %edi,%ebx
  801c31:	89 f9                	mov    %edi,%ecx
  801c33:	d3 e6                	shl    %cl,%esi
  801c35:	89 c5                	mov    %eax,%ebp
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 ed                	shr    %cl,%ebp
  801c3b:	89 e9                	mov    %ebp,%ecx
  801c3d:	09 f1                	or     %esi,%ecx
  801c3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c43:	89 f9                	mov    %edi,%ecx
  801c45:	d3 e0                	shl    %cl,%eax
  801c47:	89 c5                	mov    %eax,%ebp
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	88 d9                	mov    %bl,%cl
  801c4d:	d3 ee                	shr    %cl,%esi
  801c4f:	89 f9                	mov    %edi,%ecx
  801c51:	d3 e2                	shl    %cl,%edx
  801c53:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c57:	88 d9                	mov    %bl,%cl
  801c59:	d3 e8                	shr    %cl,%eax
  801c5b:	09 c2                	or     %eax,%edx
  801c5d:	89 d0                	mov    %edx,%eax
  801c5f:	89 f2                	mov    %esi,%edx
  801c61:	f7 74 24 0c          	divl   0xc(%esp)
  801c65:	89 d6                	mov    %edx,%esi
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	f7 e5                	mul    %ebp
  801c6b:	39 d6                	cmp    %edx,%esi
  801c6d:	72 19                	jb     801c88 <__udivdi3+0xfc>
  801c6f:	74 0b                	je     801c7c <__udivdi3+0xf0>
  801c71:	89 d8                	mov    %ebx,%eax
  801c73:	31 ff                	xor    %edi,%edi
  801c75:	e9 58 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c80:	89 f9                	mov    %edi,%ecx
  801c82:	d3 e2                	shl    %cl,%edx
  801c84:	39 c2                	cmp    %eax,%edx
  801c86:	73 e9                	jae    801c71 <__udivdi3+0xe5>
  801c88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c8b:	31 ff                	xor    %edi,%edi
  801c8d:	e9 40 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	31 c0                	xor    %eax,%eax
  801c96:	e9 37 ff ff ff       	jmp    801bd2 <__udivdi3+0x46>
  801c9b:	90                   	nop

00801c9c <__umoddi3>:
  801c9c:	55                   	push   %ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
  801ca3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801caf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cbb:	89 f3                	mov    %esi,%ebx
  801cbd:	89 fa                	mov    %edi,%edx
  801cbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc3:	89 34 24             	mov    %esi,(%esp)
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	75 1a                	jne    801ce4 <__umoddi3+0x48>
  801cca:	39 f7                	cmp    %esi,%edi
  801ccc:	0f 86 a2 00 00 00    	jbe    801d74 <__umoddi3+0xd8>
  801cd2:	89 c8                	mov    %ecx,%eax
  801cd4:	89 f2                	mov    %esi,%edx
  801cd6:	f7 f7                	div    %edi
  801cd8:	89 d0                	mov    %edx,%eax
  801cda:	31 d2                	xor    %edx,%edx
  801cdc:	83 c4 1c             	add    $0x1c,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    
  801ce4:	39 f0                	cmp    %esi,%eax
  801ce6:	0f 87 ac 00 00 00    	ja     801d98 <__umoddi3+0xfc>
  801cec:	0f bd e8             	bsr    %eax,%ebp
  801cef:	83 f5 1f             	xor    $0x1f,%ebp
  801cf2:	0f 84 ac 00 00 00    	je     801da4 <__umoddi3+0x108>
  801cf8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cfd:	29 ef                	sub    %ebp,%edi
  801cff:	89 fe                	mov    %edi,%esi
  801d01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d05:	89 e9                	mov    %ebp,%ecx
  801d07:	d3 e0                	shl    %cl,%eax
  801d09:	89 d7                	mov    %edx,%edi
  801d0b:	89 f1                	mov    %esi,%ecx
  801d0d:	d3 ef                	shr    %cl,%edi
  801d0f:	09 c7                	or     %eax,%edi
  801d11:	89 e9                	mov    %ebp,%ecx
  801d13:	d3 e2                	shl    %cl,%edx
  801d15:	89 14 24             	mov    %edx,(%esp)
  801d18:	89 d8                	mov    %ebx,%eax
  801d1a:	d3 e0                	shl    %cl,%eax
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d22:	d3 e0                	shl    %cl,%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2c:	89 f1                	mov    %esi,%ecx
  801d2e:	d3 e8                	shr    %cl,%eax
  801d30:	09 d0                	or     %edx,%eax
  801d32:	d3 eb                	shr    %cl,%ebx
  801d34:	89 da                	mov    %ebx,%edx
  801d36:	f7 f7                	div    %edi
  801d38:	89 d3                	mov    %edx,%ebx
  801d3a:	f7 24 24             	mull   (%esp)
  801d3d:	89 c6                	mov    %eax,%esi
  801d3f:	89 d1                	mov    %edx,%ecx
  801d41:	39 d3                	cmp    %edx,%ebx
  801d43:	0f 82 87 00 00 00    	jb     801dd0 <__umoddi3+0x134>
  801d49:	0f 84 91 00 00 00    	je     801de0 <__umoddi3+0x144>
  801d4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d53:	29 f2                	sub    %esi,%edx
  801d55:	19 cb                	sbb    %ecx,%ebx
  801d57:	89 d8                	mov    %ebx,%eax
  801d59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d5d:	d3 e0                	shl    %cl,%eax
  801d5f:	89 e9                	mov    %ebp,%ecx
  801d61:	d3 ea                	shr    %cl,%edx
  801d63:	09 d0                	or     %edx,%eax
  801d65:	89 e9                	mov    %ebp,%ecx
  801d67:	d3 eb                	shr    %cl,%ebx
  801d69:	89 da                	mov    %ebx,%edx
  801d6b:	83 c4 1c             	add    $0x1c,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5f                   	pop    %edi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    
  801d73:	90                   	nop
  801d74:	89 fd                	mov    %edi,%ebp
  801d76:	85 ff                	test   %edi,%edi
  801d78:	75 0b                	jne    801d85 <__umoddi3+0xe9>
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	31 d2                	xor    %edx,%edx
  801d81:	f7 f7                	div    %edi
  801d83:	89 c5                	mov    %eax,%ebp
  801d85:	89 f0                	mov    %esi,%eax
  801d87:	31 d2                	xor    %edx,%edx
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 c8                	mov    %ecx,%eax
  801d8d:	f7 f5                	div    %ebp
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	e9 44 ff ff ff       	jmp    801cda <__umoddi3+0x3e>
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	89 c8                	mov    %ecx,%eax
  801d9a:	89 f2                	mov    %esi,%edx
  801d9c:	83 c4 1c             	add    $0x1c,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5e                   	pop    %esi
  801da1:	5f                   	pop    %edi
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    
  801da4:	3b 04 24             	cmp    (%esp),%eax
  801da7:	72 06                	jb     801daf <__umoddi3+0x113>
  801da9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dad:	77 0f                	ja     801dbe <__umoddi3+0x122>
  801daf:	89 f2                	mov    %esi,%edx
  801db1:	29 f9                	sub    %edi,%ecx
  801db3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db7:	89 14 24             	mov    %edx,(%esp)
  801dba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dc2:	8b 14 24             	mov    (%esp),%edx
  801dc5:	83 c4 1c             	add    $0x1c,%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5f                   	pop    %edi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    
  801dcd:	8d 76 00             	lea    0x0(%esi),%esi
  801dd0:	2b 04 24             	sub    (%esp),%eax
  801dd3:	19 fa                	sbb    %edi,%edx
  801dd5:	89 d1                	mov    %edx,%ecx
  801dd7:	89 c6                	mov    %eax,%esi
  801dd9:	e9 71 ff ff ff       	jmp    801d4f <__umoddi3+0xb3>
  801dde:	66 90                	xchg   %ax,%ax
  801de0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de4:	72 ea                	jb     801dd0 <__umoddi3+0x134>
  801de6:	89 d9                	mov    %ebx,%ecx
  801de8:	e9 62 ff ff ff       	jmp    801d4f <__umoddi3+0xb3>
