
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 a0 1a 80 00       	push   $0x801aa0
  800046:	e8 54 02 00 00       	call   80029f <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 99 12 00 00       	call   8012f5 <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 06             	shl    $0x6,%eax
  800067:	29 d0                	sub    %edx,%eax
  800069:	c1 e0 02             	shl    $0x2,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800075:	01 c8                	add    %ecx,%eax
  800077:	c1 e0 03             	shl    $0x3,%eax
  80007a:	01 d0                	add    %edx,%eax
  80007c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800083:	29 c2                	sub    %eax,%edx
  800085:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80008c:	89 c2                	mov    %eax,%edx
  80008e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800094:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8a 40 20             	mov    0x20(%eax),%al
  8000a1:	84 c0                	test   %al,%al
  8000a3:	74 0d                	je     8000b2 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000aa:	83 c0 20             	add    $0x20,%eax
  8000ad:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b6:	7e 0a                	jle    8000c2 <libmain+0x71>
		binaryname = argv[0];
  8000b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	ff 75 0c             	pushl  0xc(%ebp)
  8000c8:	ff 75 08             	pushl  0x8(%ebp)
  8000cb:	e8 68 ff ff ff       	call   800038 <_main>
  8000d0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d3:	e8 a1 0f 00 00       	call   801079 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 e4 1a 80 00       	push   $0x801ae4
  8000e0:	e8 8d 01 00 00       	call   800272 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ed:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8000f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f8:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	52                   	push   %edx
  800102:	50                   	push   %eax
  800103:	68 0c 1b 80 00       	push   $0x801b0c
  800108:	e8 65 01 00 00       	call   800272 <cprintf>
  80010d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80011b:	a1 20 30 80 00       	mov    0x803020,%eax
  800120:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800126:	a1 20 30 80 00       	mov    0x803020,%eax
  80012b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800131:	51                   	push   %ecx
  800132:	52                   	push   %edx
  800133:	50                   	push   %eax
  800134:	68 34 1b 80 00       	push   $0x801b34
  800139:	e8 34 01 00 00       	call   800272 <cprintf>
  80013e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800141:	a1 20 30 80 00       	mov    0x803020,%eax
  800146:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	68 8c 1b 80 00       	push   $0x801b8c
  800155:	e8 18 01 00 00       	call   800272 <cprintf>
  80015a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 e4 1a 80 00       	push   $0x801ae4
  800165:	e8 08 01 00 00       	call   800272 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80016d:	e8 21 0f 00 00       	call   801093 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800172:	e8 19 00 00 00       	call   800190 <exit>
}
  800177:	90                   	nop
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 37 11 00 00       	call   8012c1 <sys_destroy_env>
  80018a:	83 c4 10             	add    $0x10,%esp
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <exit>:

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800196:	e8 8c 11 00 00       	call   801327 <sys_exit_env>
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	8b 00                	mov    (%eax),%eax
  8001a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001af:	89 0a                	mov    %ecx,(%edx)
  8001b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b4:	88 d1                	mov    %dl,%cl
  8001b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c0:	8b 00                	mov    (%eax),%eax
  8001c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c7:	75 2c                	jne    8001f5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c9:	a0 c0 68 81 00       	mov    0x8168c0,%al
  8001ce:	0f b6 c0             	movzbl %al,%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	8b 12                	mov    (%edx),%edx
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	83 c2 08             	add    $0x8,%edx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	50                   	push   %eax
  8001e2:	51                   	push   %ecx
  8001e3:	52                   	push   %edx
  8001e4:	e8 4e 0e 00 00       	call   801037 <sys_cputs>
  8001e9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f8:	8b 40 04             	mov    0x4(%eax),%eax
  8001fb:	8d 50 01             	lea    0x1(%eax),%edx
  8001fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800201:	89 50 04             	mov    %edx,0x4(%eax)
}
  800204:	90                   	nop
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800210:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800217:	00 00 00 
	b.cnt = 0;
  80021a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800221:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800224:	ff 75 0c             	pushl  0xc(%ebp)
  800227:	ff 75 08             	pushl  0x8(%ebp)
  80022a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800230:	50                   	push   %eax
  800231:	68 9e 01 80 00       	push   $0x80019e
  800236:	e8 11 02 00 00       	call   80044c <vprintfmt>
  80023b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80023e:	a0 c0 68 81 00       	mov    0x8168c0,%al
  800243:	0f b6 c0             	movzbl %al,%eax
  800246:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	50                   	push   %eax
  800250:	52                   	push   %edx
  800251:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800257:	83 c0 08             	add    $0x8,%eax
  80025a:	50                   	push   %eax
  80025b:	e8 d7 0d 00 00       	call   801037 <sys_cputs>
  800260:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800263:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
	return b.cnt;
  80026a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800278:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
	va_start(ap, fmt);
  80027f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	ff 75 f4             	pushl  -0xc(%ebp)
  80028e:	50                   	push   %eax
  80028f:	e8 73 ff ff ff       	call   800207 <vcprintf>
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80029a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002a5:	e8 cf 0d 00 00       	call   801079 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b9:	50                   	push   %eax
  8002ba:	e8 48 ff ff ff       	call   800207 <vcprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002c5:	e8 c9 0d 00 00       	call   801093 <sys_unlock_cons>
	return cnt;
  8002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 14             	sub    $0x14,%esp
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ed:	77 55                	ja     800344 <printnum+0x75>
  8002ef:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f2:	72 05                	jb     8002f9 <printnum+0x2a>
  8002f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002f7:	77 4b                	ja     800344 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ff:	8b 45 18             	mov    0x18(%ebp),%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
  800307:	52                   	push   %edx
  800308:	50                   	push   %eax
  800309:	ff 75 f4             	pushl  -0xc(%ebp)
  80030c:	ff 75 f0             	pushl  -0x10(%ebp)
  80030f:	e8 10 15 00 00       	call   801824 <__udivdi3>
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	ff 75 20             	pushl  0x20(%ebp)
  80031d:	53                   	push   %ebx
  80031e:	ff 75 18             	pushl  0x18(%ebp)
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 a1 ff ff ff       	call   8002cf <printnum>
  80032e:	83 c4 20             	add    $0x20,%esp
  800331:	eb 1a                	jmp    80034d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 0c             	pushl  0xc(%ebp)
  800339:	ff 75 20             	pushl  0x20(%ebp)
  80033c:	8b 45 08             	mov    0x8(%ebp),%eax
  80033f:	ff d0                	call   *%eax
  800341:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800344:	ff 4d 1c             	decl   0x1c(%ebp)
  800347:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80034b:	7f e6                	jg     800333 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800350:	bb 00 00 00 00       	mov    $0x0,%ebx
  800355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80035b:	53                   	push   %ebx
  80035c:	51                   	push   %ecx
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	e8 d0 15 00 00       	call   801934 <__umoddi3>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	05 b4 1d 80 00       	add    $0x801db4,%eax
  80036c:	8a 00                	mov    (%eax),%al
  80036e:	0f be c0             	movsbl %al,%eax
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	50                   	push   %eax
  800378:	8b 45 08             	mov    0x8(%ebp),%eax
  80037b:	ff d0                	call   *%eax
  80037d:	83 c4 10             	add    $0x10,%esp
}
  800380:	90                   	nop
  800381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800389:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80038d:	7e 1c                	jle    8003ab <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	8d 50 08             	lea    0x8(%eax),%edx
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	89 10                	mov    %edx,(%eax)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	83 e8 08             	sub    $0x8,%eax
  8003a4:	8b 50 04             	mov    0x4(%eax),%edx
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	eb 40                	jmp    8003eb <getuint+0x65>
	else if (lflag)
  8003ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003af:	74 1e                	je     8003cf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	8d 50 04             	lea    0x4(%eax),%edx
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	89 10                	mov    %edx,(%eax)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	83 e8 04             	sub    $0x4,%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cd:	eb 1c                	jmp    8003eb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	8d 50 04             	lea    0x4(%eax),%edx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	89 10                	mov    %edx,(%eax)
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	83 e8 04             	sub    $0x4,%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f4:	7e 1c                	jle    800412 <getint+0x25>
		return va_arg(*ap, long long);
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	8d 50 08             	lea    0x8(%eax),%edx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	89 10                	mov    %edx,(%eax)
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	83 e8 08             	sub    $0x8,%eax
  80040b:	8b 50 04             	mov    0x4(%eax),%edx
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	eb 38                	jmp    80044a <getint+0x5d>
	else if (lflag)
  800412:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800416:	74 1a                	je     800432 <getint+0x45>
		return va_arg(*ap, long);
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	8d 50 04             	lea    0x4(%eax),%edx
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	89 10                	mov    %edx,(%eax)
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	83 e8 04             	sub    $0x4,%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	99                   	cltd   
  800430:	eb 18                	jmp    80044a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	8d 50 04             	lea    0x4(%eax),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	89 10                	mov    %edx,(%eax)
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	83 e8 04             	sub    $0x4,%eax
  800447:	8b 00                	mov    (%eax),%eax
  800449:	99                   	cltd   
}
  80044a:	5d                   	pop    %ebp
  80044b:	c3                   	ret    

0080044c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	56                   	push   %esi
  800450:	53                   	push   %ebx
  800451:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800454:	eb 17                	jmp    80046d <vprintfmt+0x21>
			if (ch == '\0')
  800456:	85 db                	test   %ebx,%ebx
  800458:	0f 84 c1 03 00 00    	je     80081f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 0c             	pushl  0xc(%ebp)
  800464:	53                   	push   %ebx
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	ff d0                	call   *%eax
  80046a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046d:	8b 45 10             	mov    0x10(%ebp),%eax
  800470:	8d 50 01             	lea    0x1(%eax),%edx
  800473:	89 55 10             	mov    %edx,0x10(%ebp)
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f b6 d8             	movzbl %al,%ebx
  80047b:	83 fb 25             	cmp    $0x25,%ebx
  80047e:	75 d6                	jne    800456 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800480:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800484:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80048b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800492:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800499:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a3:	8d 50 01             	lea    0x1(%eax),%edx
  8004a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a9:	8a 00                	mov    (%eax),%al
  8004ab:	0f b6 d8             	movzbl %al,%ebx
  8004ae:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b1:	83 f8 5b             	cmp    $0x5b,%eax
  8004b4:	0f 87 3d 03 00 00    	ja     8007f7 <vprintfmt+0x3ab>
  8004ba:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  8004c1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004c7:	eb d7                	jmp    8004a0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004cd:	eb d1                	jmp    8004a0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 d0                	mov    %edx,%eax
  8004db:	c1 e0 02             	shl    $0x2,%eax
  8004de:	01 d0                	add    %edx,%eax
  8004e0:	01 c0                	add    %eax,%eax
  8004e2:	01 d8                	add    %ebx,%eax
  8004e4:	83 e8 30             	sub    $0x30,%eax
  8004e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ed:	8a 00                	mov    (%eax),%al
  8004ef:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f2:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f5:	7e 3e                	jle    800535 <vprintfmt+0xe9>
  8004f7:	83 fb 39             	cmp    $0x39,%ebx
  8004fa:	7f 39                	jg     800535 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ff:	eb d5                	jmp    8004d6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	83 c0 04             	add    $0x4,%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	83 e8 04             	sub    $0x4,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800515:	eb 1f                	jmp    800536 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800517:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051b:	79 83                	jns    8004a0 <vprintfmt+0x54>
				width = 0;
  80051d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800524:	e9 77 ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800529:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800530:	e9 6b ff ff ff       	jmp    8004a0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800535:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053a:	0f 89 60 ff ff ff    	jns    8004a0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800546:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80054d:	e9 4e ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800552:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800555:	e9 46 ff ff ff       	jmp    8004a0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 c0 04             	add    $0x4,%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	83 e8 04             	sub    $0x4,%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	ff d0                	call   *%eax
  800577:	83 c4 10             	add    $0x10,%esp
			break;
  80057a:	e9 9b 02 00 00       	jmp    80081a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	83 c0 04             	add    $0x4,%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	83 e8 04             	sub    $0x4,%eax
  80058e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800590:	85 db                	test   %ebx,%ebx
  800592:	79 02                	jns    800596 <vprintfmt+0x14a>
				err = -err;
  800594:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800596:	83 fb 64             	cmp    $0x64,%ebx
  800599:	7f 0b                	jg     8005a6 <vprintfmt+0x15a>
  80059b:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  8005a2:	85 f6                	test   %esi,%esi
  8005a4:	75 19                	jne    8005bf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a6:	53                   	push   %ebx
  8005a7:	68 c5 1d 80 00       	push   $0x801dc5
  8005ac:	ff 75 0c             	pushl  0xc(%ebp)
  8005af:	ff 75 08             	pushl  0x8(%ebp)
  8005b2:	e8 70 02 00 00       	call   800827 <printfmt>
  8005b7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005ba:	e9 5b 02 00 00       	jmp    80081a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005bf:	56                   	push   %esi
  8005c0:	68 ce 1d 80 00       	push   $0x801dce
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	e8 57 02 00 00       	call   800827 <printfmt>
  8005d0:	83 c4 10             	add    $0x10,%esp
			break;
  8005d3:	e9 42 02 00 00       	jmp    80081a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	83 c0 04             	add    $0x4,%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	83 e8 04             	sub    $0x4,%eax
  8005e7:	8b 30                	mov    (%eax),%esi
  8005e9:	85 f6                	test   %esi,%esi
  8005eb:	75 05                	jne    8005f2 <vprintfmt+0x1a6>
				p = "(null)";
  8005ed:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  8005f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f6:	7e 6d                	jle    800665 <vprintfmt+0x219>
  8005f8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005fc:	74 67                	je     800665 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	50                   	push   %eax
  800605:	56                   	push   %esi
  800606:	e8 1e 03 00 00       	call   800929 <strnlen>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800611:	eb 16                	jmp    800629 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800613:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	50                   	push   %eax
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	ff d0                	call   *%eax
  800623:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800626:	ff 4d e4             	decl   -0x1c(%ebp)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062d:	7f e4                	jg     800613 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062f:	eb 34                	jmp    800665 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800631:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800635:	74 1c                	je     800653 <vprintfmt+0x207>
  800637:	83 fb 1f             	cmp    $0x1f,%ebx
  80063a:	7e 05                	jle    800641 <vprintfmt+0x1f5>
  80063c:	83 fb 7e             	cmp    $0x7e,%ebx
  80063f:	7e 12                	jle    800653 <vprintfmt+0x207>
					putch('?', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	6a 3f                	push   $0x3f
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	ff d0                	call   *%eax
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb 0f                	jmp    800662 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	53                   	push   %ebx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	ff d0                	call   *%eax
  80065f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800662:	ff 4d e4             	decl   -0x1c(%ebp)
  800665:	89 f0                	mov    %esi,%eax
  800667:	8d 70 01             	lea    0x1(%eax),%esi
  80066a:	8a 00                	mov    (%eax),%al
  80066c:	0f be d8             	movsbl %al,%ebx
  80066f:	85 db                	test   %ebx,%ebx
  800671:	74 24                	je     800697 <vprintfmt+0x24b>
  800673:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800677:	78 b8                	js     800631 <vprintfmt+0x1e5>
  800679:	ff 4d e0             	decl   -0x20(%ebp)
  80067c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800680:	79 af                	jns    800631 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800682:	eb 13                	jmp    800697 <vprintfmt+0x24b>
				putch(' ', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	6a 20                	push   $0x20
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	ff d0                	call   *%eax
  800691:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800694:	ff 4d e4             	decl   -0x1c(%ebp)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069b:	7f e7                	jg     800684 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80069d:	e9 78 01 00 00       	jmp    80081a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	e8 3c fd ff ff       	call   8003ed <getint>
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	79 23                	jns    8006e7 <vprintfmt+0x29b>
				putch('-', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	6a 2d                	push   $0x2d
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006da:	f7 d8                	neg    %eax
  8006dc:	83 d2 00             	adc    $0x0,%edx
  8006df:	f7 da                	neg    %edx
  8006e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006ee:	e9 bc 00 00 00       	jmp    8007af <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fc:	50                   	push   %eax
  8006fd:	e8 84 fc ff ff       	call   800386 <getuint>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800708:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80070b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800712:	e9 98 00 00 00       	jmp    8007af <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 58                	push   $0x58
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	6a 58                	push   $0x58
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	6a 58                	push   $0x58
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	ff d0                	call   *%eax
  800744:	83 c4 10             	add    $0x10,%esp
			break;
  800747:	e9 ce 00 00 00       	jmp    80081a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 0c             	pushl  0xc(%ebp)
  800752:	6a 30                	push   $0x30
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	6a 78                	push   $0x78
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	83 c0 04             	add    $0x4,%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	83 e8 04             	sub    $0x4,%eax
  80077b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800787:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80078e:	eb 1f                	jmp    8007af <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 e8             	pushl  -0x18(%ebp)
  800796:	8d 45 14             	lea    0x14(%ebp),%eax
  800799:	50                   	push   %eax
  80079a:	e8 e7 fb ff ff       	call   800386 <getuint>
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007af:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b6:	83 ec 04             	sub    $0x4,%esp
  8007b9:	52                   	push   %edx
  8007ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 00 fb ff ff       	call   8002cf <printnum>
  8007cf:	83 c4 20             	add    $0x20,%esp
			break;
  8007d2:	eb 46                	jmp    80081a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	ff d0                	call   *%eax
  8007e0:	83 c4 10             	add    $0x10,%esp
			break;
  8007e3:	eb 35                	jmp    80081a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007e5:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
			break;
  8007ec:	eb 2c                	jmp    80081a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007ee:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
			break;
  8007f5:	eb 23                	jmp    80081a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	6a 25                	push   $0x25
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800807:	ff 4d 10             	decl   0x10(%ebp)
  80080a:	eb 03                	jmp    80080f <vprintfmt+0x3c3>
  80080c:	ff 4d 10             	decl   0x10(%ebp)
  80080f:	8b 45 10             	mov    0x10(%ebp),%eax
  800812:	48                   	dec    %eax
  800813:	8a 00                	mov    (%eax),%al
  800815:	3c 25                	cmp    $0x25,%al
  800817:	75 f3                	jne    80080c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800819:	90                   	nop
		}
	}
  80081a:	e9 35 fc ff ff       	jmp    800454 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80081f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800820:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800823:	5b                   	pop    %ebx
  800824:	5e                   	pop    %esi
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80082d:	8d 45 10             	lea    0x10(%ebp),%eax
  800830:	83 c0 04             	add    $0x4,%eax
  800833:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800836:	8b 45 10             	mov    0x10(%ebp),%eax
  800839:	ff 75 f4             	pushl  -0xc(%ebp)
  80083c:	50                   	push   %eax
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 04 fc ff ff       	call   80044c <vprintfmt>
  800848:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80084b:	90                   	nop
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800851:	8b 45 0c             	mov    0xc(%ebp),%eax
  800854:	8b 40 08             	mov    0x8(%eax),%eax
  800857:	8d 50 01             	lea    0x1(%eax),%edx
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	8b 10                	mov    (%eax),%edx
  800865:	8b 45 0c             	mov    0xc(%ebp),%eax
  800868:	8b 40 04             	mov    0x4(%eax),%eax
  80086b:	39 c2                	cmp    %eax,%edx
  80086d:	73 12                	jae    800881 <sprintputch+0x33>
		*b->buf++ = ch;
  80086f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	8d 48 01             	lea    0x1(%eax),%ecx
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087a:	89 0a                	mov    %ecx,(%edx)
  80087c:	8b 55 08             	mov    0x8(%ebp),%edx
  80087f:	88 10                	mov    %dl,(%eax)
}
  800881:	90                   	nop
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800890:	8b 45 0c             	mov    0xc(%ebp),%eax
  800893:	8d 50 ff             	lea    -0x1(%eax),%edx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	01 d0                	add    %edx,%eax
  80089b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008a9:	74 06                	je     8008b1 <vsnprintf+0x2d>
  8008ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008af:	7f 07                	jg     8008b8 <vsnprintf+0x34>
		return -E_INVAL;
  8008b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8008b6:	eb 20                	jmp    8008d8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b8:	ff 75 14             	pushl  0x14(%ebp)
  8008bb:	ff 75 10             	pushl  0x10(%ebp)
  8008be:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c1:	50                   	push   %eax
  8008c2:	68 4e 08 80 00       	push   $0x80084e
  8008c7:	e8 80 fb ff ff       	call   80044c <vprintfmt>
  8008cc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 89 ff ff ff       	call   800884 <vsnprintf>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80090c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800913:	eb 06                	jmp    80091b <strlen+0x15>
		n++;
  800915:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800918:	ff 45 08             	incl   0x8(%ebp)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8a 00                	mov    (%eax),%al
  800920:	84 c0                	test   %al,%al
  800922:	75 f1                	jne    800915 <strlen+0xf>
		n++;
	return n;
  800924:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800936:	eb 09                	jmp    800941 <strnlen+0x18>
		n++;
  800938:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093b:	ff 45 08             	incl   0x8(%ebp)
  80093e:	ff 4d 0c             	decl   0xc(%ebp)
  800941:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800945:	74 09                	je     800950 <strnlen+0x27>
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8a 00                	mov    (%eax),%al
  80094c:	84 c0                	test   %al,%al
  80094e:	75 e8                	jne    800938 <strnlen+0xf>
		n++;
	return n;
  800950:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800961:	90                   	nop
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8d 50 01             	lea    0x1(%eax),%edx
  800968:	89 55 08             	mov    %edx,0x8(%ebp)
  80096b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800971:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800974:	8a 12                	mov    (%edx),%dl
  800976:	88 10                	mov    %dl,(%eax)
  800978:	8a 00                	mov    (%eax),%al
  80097a:	84 c0                	test   %al,%al
  80097c:	75 e4                	jne    800962 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80097e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80098f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800996:	eb 1f                	jmp    8009b7 <strncpy+0x34>
		*dst++ = *src;
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8d 50 01             	lea    0x1(%eax),%edx
  80099e:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a4:	8a 12                	mov    (%edx),%dl
  8009a6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	8a 00                	mov    (%eax),%al
  8009ad:	84 c0                	test   %al,%al
  8009af:	74 03                	je     8009b4 <strncpy+0x31>
			src++;
  8009b1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b4:	ff 45 fc             	incl   -0x4(%ebp)
  8009b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009bd:	72 d9                	jb     800998 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d4:	74 30                	je     800a06 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009d6:	eb 16                	jmp    8009ee <strlcpy+0x2a>
			*dst++ = *src++;
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8d 50 01             	lea    0x1(%eax),%edx
  8009de:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009ea:	8a 12                	mov    (%edx),%dl
  8009ec:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009ee:	ff 4d 10             	decl   0x10(%ebp)
  8009f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f5:	74 09                	je     800a00 <strlcpy+0x3c>
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	8a 00                	mov    (%eax),%al
  8009fc:	84 c0                	test   %al,%al
  8009fe:	75 d8                	jne    8009d8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a06:	8b 55 08             	mov    0x8(%ebp),%edx
  800a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a0c:	29 c2                	sub    %eax,%edx
  800a0e:	89 d0                	mov    %edx,%eax
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a15:	eb 06                	jmp    800a1d <strcmp+0xb>
		p++, q++;
  800a17:	ff 45 08             	incl   0x8(%ebp)
  800a1a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	84 c0                	test   %al,%al
  800a24:	74 0e                	je     800a34 <strcmp+0x22>
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8a 10                	mov    (%eax),%dl
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	38 c2                	cmp    %al,%dl
  800a32:	74 e3                	je     800a17 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	0f b6 d0             	movzbl %al,%edx
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	29 c2                	sub    %eax,%edx
  800a46:	89 d0                	mov    %edx,%eax
}
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a4d:	eb 09                	jmp    800a58 <strncmp+0xe>
		n--, p++, q++;
  800a4f:	ff 4d 10             	decl   0x10(%ebp)
  800a52:	ff 45 08             	incl   0x8(%ebp)
  800a55:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5c:	74 17                	je     800a75 <strncmp+0x2b>
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	84 c0                	test   %al,%al
  800a65:	74 0e                	je     800a75 <strncmp+0x2b>
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8a 10                	mov    (%eax),%dl
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	38 c2                	cmp    %al,%dl
  800a73:	74 da                	je     800a4f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a79:	75 07                	jne    800a82 <strncmp+0x38>
		return 0;
  800a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a80:	eb 14                	jmp    800a96 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	0f b6 d0             	movzbl %al,%edx
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	0f b6 c0             	movzbl %al,%eax
  800a92:	29 c2                	sub    %eax,%edx
  800a94:	89 d0                	mov    %edx,%eax
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aa4:	eb 12                	jmp    800ab8 <strchr+0x20>
		if (*s == c)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aae:	75 05                	jne    800ab5 <strchr+0x1d>
			return (char *) s;
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	eb 11                	jmp    800ac6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab5:	ff 45 08             	incl   0x8(%ebp)
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8a 00                	mov    (%eax),%al
  800abd:	84 c0                	test   %al,%al
  800abf:	75 e5                	jne    800aa6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 04             	sub    $0x4,%esp
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad4:	eb 0d                	jmp    800ae3 <strfind+0x1b>
		if (*s == c)
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ade:	74 0e                	je     800aee <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ae0:	ff 45 08             	incl   0x8(%ebp)
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8a 00                	mov    (%eax),%al
  800ae8:	84 c0                	test   %al,%al
  800aea:	75 ea                	jne    800ad6 <strfind+0xe>
  800aec:	eb 01                	jmp    800aef <strfind+0x27>
		if (*s == c)
			break;
  800aee:	90                   	nop
	return (char *) s;
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b00:	8b 45 10             	mov    0x10(%ebp),%eax
  800b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b06:	eb 0e                	jmp    800b16 <memset+0x22>
		*p++ = c;
  800b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b0b:	8d 50 01             	lea    0x1(%eax),%edx
  800b0e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b14:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b16:	ff 4d f8             	decl   -0x8(%ebp)
  800b19:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b1d:	79 e9                	jns    800b08 <memset+0x14>
		*p++ = c;

	return v;
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b36:	eb 16                	jmp    800b4e <memcpy+0x2a>
		*d++ = *s++;
  800b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b51:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b54:	89 55 10             	mov    %edx,0x10(%ebp)
  800b57:	85 c0                	test   %eax,%eax
  800b59:	75 dd                	jne    800b38 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    

00800b60 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b75:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b78:	73 50                	jae    800bca <memmove+0x6a>
  800b7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b80:	01 d0                	add    %edx,%eax
  800b82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b85:	76 43                	jbe    800bca <memmove+0x6a>
		s += n;
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b90:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b93:	eb 10                	jmp    800ba5 <memmove+0x45>
			*--d = *--s;
  800b95:	ff 4d f8             	decl   -0x8(%ebp)
  800b98:	ff 4d fc             	decl   -0x4(%ebp)
  800b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9e:	8a 10                	mov    (%eax),%dl
  800ba0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bab:	89 55 10             	mov    %edx,0x10(%ebp)
  800bae:	85 c0                	test   %eax,%eax
  800bb0:	75 e3                	jne    800b95 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb2:	eb 23                	jmp    800bd7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb7:	8d 50 01             	lea    0x1(%eax),%edx
  800bba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bc6:	8a 12                	mov    (%edx),%dl
  800bc8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd3:	85 c0                	test   %eax,%eax
  800bd5:	75 dd                	jne    800bb4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bee:	eb 2a                	jmp    800c1a <memcmp+0x3e>
		if (*s1 != *s2)
  800bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf3:	8a 10                	mov    (%eax),%dl
  800bf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	38 c2                	cmp    %al,%dl
  800bfc:	74 16                	je     800c14 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f b6 d0             	movzbl %al,%edx
  800c06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 c0             	movzbl %al,%eax
  800c0e:	29 c2                	sub    %eax,%edx
  800c10:	89 d0                	mov    %edx,%eax
  800c12:	eb 18                	jmp    800c2c <memcmp+0x50>
		s1++, s2++;
  800c14:	ff 45 fc             	incl   -0x4(%ebp)
  800c17:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c20:	89 55 10             	mov    %edx,0x10(%ebp)
  800c23:	85 c0                	test   %eax,%eax
  800c25:	75 c9                	jne    800bf0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2c:	c9                   	leave  
  800c2d:	c3                   	ret    

00800c2e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	01 d0                	add    %edx,%eax
  800c3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c3f:	eb 15                	jmp    800c56 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d0             	movzbl %al,%edx
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	0f b6 c0             	movzbl %al,%eax
  800c4f:	39 c2                	cmp    %eax,%edx
  800c51:	74 0d                	je     800c60 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c53:	ff 45 08             	incl   0x8(%ebp)
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c5c:	72 e3                	jb     800c41 <memfind+0x13>
  800c5e:	eb 01                	jmp    800c61 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c60:	90                   	nop
	return (void *) s;
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7a:	eb 03                	jmp    800c7f <strtol+0x19>
		s++;
  800c7c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	3c 20                	cmp    $0x20,%al
  800c86:	74 f4                	je     800c7c <strtol+0x16>
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	3c 09                	cmp    $0x9,%al
  800c8f:	74 eb                	je     800c7c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	3c 2b                	cmp    $0x2b,%al
  800c98:	75 05                	jne    800c9f <strtol+0x39>
		s++;
  800c9a:	ff 45 08             	incl   0x8(%ebp)
  800c9d:	eb 13                	jmp    800cb2 <strtol+0x4c>
	else if (*s == '-')
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3c 2d                	cmp    $0x2d,%al
  800ca6:	75 0a                	jne    800cb2 <strtol+0x4c>
		s++, neg = 1;
  800ca8:	ff 45 08             	incl   0x8(%ebp)
  800cab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 06                	je     800cbe <strtol+0x58>
  800cb8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cbc:	75 20                	jne    800cde <strtol+0x78>
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3c 30                	cmp    $0x30,%al
  800cc5:	75 17                	jne    800cde <strtol+0x78>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	40                   	inc    %eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	3c 78                	cmp    $0x78,%al
  800ccf:	75 0d                	jne    800cde <strtol+0x78>
		s += 2, base = 16;
  800cd1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cd5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cdc:	eb 28                	jmp    800d06 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	75 15                	jne    800cf9 <strtol+0x93>
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	3c 30                	cmp    $0x30,%al
  800ceb:	75 0c                	jne    800cf9 <strtol+0x93>
		s++, base = 8;
  800ced:	ff 45 08             	incl   0x8(%ebp)
  800cf0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cf7:	eb 0d                	jmp    800d06 <strtol+0xa0>
	else if (base == 0)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	75 07                	jne    800d06 <strtol+0xa0>
		base = 10;
  800cff:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	3c 2f                	cmp    $0x2f,%al
  800d0d:	7e 19                	jle    800d28 <strtol+0xc2>
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	3c 39                	cmp    $0x39,%al
  800d16:	7f 10                	jg     800d28 <strtol+0xc2>
			dig = *s - '0';
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	0f be c0             	movsbl %al,%eax
  800d20:	83 e8 30             	sub    $0x30,%eax
  800d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d26:	eb 42                	jmp    800d6a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3c 60                	cmp    $0x60,%al
  800d2f:	7e 19                	jle    800d4a <strtol+0xe4>
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3c 7a                	cmp    $0x7a,%al
  800d38:	7f 10                	jg     800d4a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f be c0             	movsbl %al,%eax
  800d42:	83 e8 57             	sub    $0x57,%eax
  800d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d48:	eb 20                	jmp    800d6a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	3c 40                	cmp    $0x40,%al
  800d51:	7e 39                	jle    800d8c <strtol+0x126>
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	3c 5a                	cmp    $0x5a,%al
  800d5a:	7f 30                	jg     800d8c <strtol+0x126>
			dig = *s - 'A' + 10;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be c0             	movsbl %al,%eax
  800d64:	83 e8 37             	sub    $0x37,%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d70:	7d 19                	jge    800d8b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d78:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d7c:	89 c2                	mov    %eax,%edx
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	01 d0                	add    %edx,%eax
  800d83:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d86:	e9 7b ff ff ff       	jmp    800d06 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d8b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d90:	74 08                	je     800d9a <strtol+0x134>
		*endptr = (char *) s;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d9e:	74 07                	je     800da7 <strtol+0x141>
  800da0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da3:	f7 d8                	neg    %eax
  800da5:	eb 03                	jmp    800daa <strtol+0x144>
  800da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <ltostr>:

void
ltostr(long value, char *str)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800db2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800db9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc4:	79 13                	jns    800dd9 <ltostr+0x2d>
	{
		neg = 1;
  800dc6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dd3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dd6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de1:	99                   	cltd   
  800de2:	f7 f9                	idiv   %ecx
  800de4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	89 c2                	mov    %eax,%edx
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	01 d0                	add    %edx,%eax
  800df7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dfa:	83 c2 30             	add    $0x30,%edx
  800dfd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e02:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e07:	f7 e9                	imul   %ecx
  800e09:	c1 fa 02             	sar    $0x2,%edx
  800e0c:	89 c8                	mov    %ecx,%eax
  800e0e:	c1 f8 1f             	sar    $0x1f,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
  800e15:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e1c:	75 bb                	jne    800dd9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	48                   	dec    %eax
  800e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e30:	74 3d                	je     800e6f <ltostr+0xc3>
		start = 1 ;
  800e32:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e39:	eb 34                	jmp    800e6f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	01 d0                	add    %edx,%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	01 c2                	add    %eax,%edx
  800e50:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	01 c8                	add    %ecx,%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	01 c2                	add    %eax,%edx
  800e64:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e67:	88 02                	mov    %al,(%edx)
		start++ ;
  800e69:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e6c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e75:	7c c4                	jl     800e3b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e77:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	01 d0                	add    %edx,%eax
  800e7f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e82:	90                   	nop
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e8b:	ff 75 08             	pushl  0x8(%ebp)
  800e8e:	e8 73 fa ff ff       	call   800906 <strlen>
  800e93:	83 c4 04             	add    $0x4,%esp
  800e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	e8 65 fa ff ff       	call   800906 <strlen>
  800ea1:	83 c4 04             	add    $0x4,%esp
  800ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb5:	eb 17                	jmp    800ece <strcconcat+0x49>
		final[s] = str1[s] ;
  800eb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	01 c2                	add    %eax,%edx
  800ebf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	01 c8                	add    %ecx,%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ecb:	ff 45 fc             	incl   -0x4(%ebp)
  800ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ed4:	7c e1                	jl     800eb7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800edd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ee4:	eb 1f                	jmp    800f05 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eef:	89 c2                	mov    %eax,%edx
  800ef1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef4:	01 c2                	add    %eax,%edx
  800ef6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	01 c8                	add    %ecx,%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f02:	ff 45 f8             	incl   -0x8(%ebp)
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f0b:	7c d9                	jl     800ee6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f10:	8b 45 10             	mov    0x10(%ebp),%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	c6 00 00             	movb   $0x0,(%eax)
}
  800f18:	90                   	nop
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f27:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	01 d0                	add    %edx,%eax
  800f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3e:	eb 0c                	jmp    800f4c <strsplit+0x31>
			*string++ = 0;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8d 50 01             	lea    0x1(%eax),%edx
  800f46:	89 55 08             	mov    %edx,0x8(%ebp)
  800f49:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	84 c0                	test   %al,%al
  800f53:	74 18                	je     800f6d <strsplit+0x52>
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	0f be c0             	movsbl %al,%eax
  800f5d:	50                   	push   %eax
  800f5e:	ff 75 0c             	pushl  0xc(%ebp)
  800f61:	e8 32 fb ff ff       	call   800a98 <strchr>
  800f66:	83 c4 08             	add    $0x8,%esp
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 d3                	jne    800f40 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	84 c0                	test   %al,%al
  800f74:	74 5a                	je     800fd0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f76:	8b 45 14             	mov    0x14(%ebp),%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	83 f8 0f             	cmp    $0xf,%eax
  800f7e:	75 07                	jne    800f87 <strsplit+0x6c>
		{
			return 0;
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
  800f85:	eb 66                	jmp    800fed <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8b 00                	mov    (%eax),%eax
  800f8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800f8f:	8b 55 14             	mov    0x14(%ebp),%edx
  800f92:	89 0a                	mov    %ecx,(%edx)
  800f94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	01 c2                	add    %eax,%edx
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa5:	eb 03                	jmp    800faa <strsplit+0x8f>
			string++;
  800fa7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	84 c0                	test   %al,%al
  800fb1:	74 8b                	je     800f3e <strsplit+0x23>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f be c0             	movsbl %al,%eax
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	e8 d4 fa ff ff       	call   800a98 <strchr>
  800fc4:	83 c4 08             	add    $0x8,%esp
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	74 dc                	je     800fa7 <strsplit+0x8c>
			string++;
	}
  800fcb:	e9 6e ff ff ff       	jmp    800f3e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fd0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	8b 00                	mov    (%eax),%eax
  800fd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    

00800fef <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fef:	55                   	push   %ebp
  800ff0:	89 e5                	mov    %esp,%ebp
  800ff2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	68 48 1f 80 00       	push   $0x801f48
  800ffd:	68 3f 01 00 00       	push   $0x13f
  801002:	68 6a 1f 80 00       	push   $0x801f6a
  801007:	e8 2d 06 00 00       	call   801639 <_panic>

0080100c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80101e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801021:	8b 7d 18             	mov    0x18(%ebp),%edi
  801024:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801027:	cd 30                	int    $0x30
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80102c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80102f:	83 c4 10             	add    $0x10,%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    

00801037 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801043:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	6a 00                	push   $0x0
  80104c:	6a 00                	push   $0x0
  80104e:	52                   	push   %edx
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	50                   	push   %eax
  801053:	6a 00                	push   $0x0
  801055:	e8 b2 ff ff ff       	call   80100c <syscall>
  80105a:	83 c4 18             	add    $0x18,%esp
}
  80105d:	90                   	nop
  80105e:	c9                   	leave  
  80105f:	c3                   	ret    

00801060 <sys_cgetc>:

int
sys_cgetc(void)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801063:	6a 00                	push   $0x0
  801065:	6a 00                	push   $0x0
  801067:	6a 00                	push   $0x0
  801069:	6a 00                	push   $0x0
  80106b:	6a 00                	push   $0x0
  80106d:	6a 02                	push   $0x2
  80106f:	e8 98 ff ff ff       	call   80100c <syscall>
  801074:	83 c4 18             	add    $0x18,%esp
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80107c:	6a 00                	push   $0x0
  80107e:	6a 00                	push   $0x0
  801080:	6a 00                	push   $0x0
  801082:	6a 00                	push   $0x0
  801084:	6a 00                	push   $0x0
  801086:	6a 03                	push   $0x3
  801088:	e8 7f ff ff ff       	call   80100c <syscall>
  80108d:	83 c4 18             	add    $0x18,%esp
}
  801090:	90                   	nop
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801096:	6a 00                	push   $0x0
  801098:	6a 00                	push   $0x0
  80109a:	6a 00                	push   $0x0
  80109c:	6a 00                	push   $0x0
  80109e:	6a 00                	push   $0x0
  8010a0:	6a 04                	push   $0x4
  8010a2:	e8 65 ff ff ff       	call   80100c <syscall>
  8010a7:	83 c4 18             	add    $0x18,%esp
}
  8010aa:	90                   	nop
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	6a 00                	push   $0x0
  8010b8:	6a 00                	push   $0x0
  8010ba:	6a 00                	push   $0x0
  8010bc:	52                   	push   %edx
  8010bd:	50                   	push   %eax
  8010be:	6a 08                	push   $0x8
  8010c0:	e8 47 ff ff ff       	call   80100c <syscall>
  8010c5:	83 c4 18             	add    $0x18,%esp
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	51                   	push   %ecx
  8010e1:	52                   	push   %edx
  8010e2:	50                   	push   %eax
  8010e3:	6a 09                	push   $0x9
  8010e5:	e8 22 ff ff ff       	call   80100c <syscall>
  8010ea:	83 c4 18             	add    $0x18,%esp
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	6a 00                	push   $0x0
  8010ff:	6a 00                	push   $0x0
  801101:	6a 00                	push   $0x0
  801103:	52                   	push   %edx
  801104:	50                   	push   %eax
  801105:	6a 0a                	push   $0xa
  801107:	e8 00 ff ff ff       	call   80100c <syscall>
  80110c:	83 c4 18             	add    $0x18,%esp
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801114:	6a 00                	push   $0x0
  801116:	6a 00                	push   $0x0
  801118:	6a 00                	push   $0x0
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	6a 0b                	push   $0xb
  801122:	e8 e5 fe ff ff       	call   80100c <syscall>
  801127:	83 c4 18             	add    $0x18,%esp
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 0c                	push   $0xc
  80113b:	e8 cc fe ff ff       	call   80100c <syscall>
  801140:	83 c4 18             	add    $0x18,%esp
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801148:	6a 00                	push   $0x0
  80114a:	6a 00                	push   $0x0
  80114c:	6a 00                	push   $0x0
  80114e:	6a 00                	push   $0x0
  801150:	6a 00                	push   $0x0
  801152:	6a 0d                	push   $0xd
  801154:	e8 b3 fe ff ff       	call   80100c <syscall>
  801159:	83 c4 18             	add    $0x18,%esp
}
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801161:	6a 00                	push   $0x0
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	6a 00                	push   $0x0
  801169:	6a 00                	push   $0x0
  80116b:	6a 0e                	push   $0xe
  80116d:	e8 9a fe ff ff       	call   80100c <syscall>
  801172:	83 c4 18             	add    $0x18,%esp
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 0f                	push   $0xf
  801186:	e8 81 fe ff ff       	call   80100c <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	6a 10                	push   $0x10
  8011a0:	e8 67 fe ff ff       	call   80100c <syscall>
  8011a5:	83 c4 18             	add    $0x18,%esp
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 11                	push   $0x11
  8011b9:	e8 4e fe ff ff       	call   80100c <syscall>
  8011be:	83 c4 18             	add    $0x18,%esp
}
  8011c1:	90                   	nop
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 04             	sub    $0x4,%esp
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	50                   	push   %eax
  8011dd:	6a 01                	push   $0x1
  8011df:	e8 28 fe ff ff       	call   80100c <syscall>
  8011e4:	83 c4 18             	add    $0x18,%esp
}
  8011e7:	90                   	nop
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 14                	push   $0x14
  8011f9:	e8 0e fe ff ff       	call   80100c <syscall>
  8011fe:	83 c4 18             	add    $0x18,%esp
}
  801201:	90                   	nop
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801210:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801213:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	6a 00                	push   $0x0
  80121c:	51                   	push   %ecx
  80121d:	52                   	push   %edx
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	50                   	push   %eax
  801222:	6a 15                	push   $0x15
  801224:	e8 e3 fd ff ff       	call   80100c <syscall>
  801229:	83 c4 18             	add    $0x18,%esp
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801231:	8b 55 0c             	mov    0xc(%ebp),%edx
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	52                   	push   %edx
  80123e:	50                   	push   %eax
  80123f:	6a 16                	push   $0x16
  801241:	e8 c6 fd ff ff       	call   80100c <syscall>
  801246:	83 c4 18             	add    $0x18,%esp
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80124e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801251:	8b 55 0c             	mov    0xc(%ebp),%edx
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	51                   	push   %ecx
  80125c:	52                   	push   %edx
  80125d:	50                   	push   %eax
  80125e:	6a 17                	push   $0x17
  801260:	e8 a7 fd ff ff       	call   80100c <syscall>
  801265:	83 c4 18             	add    $0x18,%esp
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80126d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	52                   	push   %edx
  80127a:	50                   	push   %eax
  80127b:	6a 18                	push   $0x18
  80127d:	e8 8a fd ff ff       	call   80100c <syscall>
  801282:	83 c4 18             	add    $0x18,%esp
}
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	6a 00                	push   $0x0
  80128f:	ff 75 14             	pushl  0x14(%ebp)
  801292:	ff 75 10             	pushl  0x10(%ebp)
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	50                   	push   %eax
  801299:	6a 19                	push   $0x19
  80129b:	e8 6c fd ff ff       	call   80100c <syscall>
  8012a0:	83 c4 18             	add    $0x18,%esp
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	50                   	push   %eax
  8012b4:	6a 1a                	push   $0x1a
  8012b6:	e8 51 fd ff ff       	call   80100c <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	50                   	push   %eax
  8012d0:	6a 1b                	push   $0x1b
  8012d2:	e8 35 fd ff ff       	call   80100c <syscall>
  8012d7:	83 c4 18             	add    $0x18,%esp
}
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 05                	push   $0x5
  8012eb:	e8 1c fd ff ff       	call   80100c <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 06                	push   $0x6
  801304:	e8 03 fd ff ff       	call   80100c <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 07                	push   $0x7
  80131d:	e8 ea fc ff ff       	call   80100c <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_exit_env>:


void sys_exit_env(void)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 1c                	push   $0x1c
  801336:	e8 d1 fc ff ff       	call   80100c <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	90                   	nop
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801347:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80134a:	8d 50 04             	lea    0x4(%eax),%edx
  80134d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	52                   	push   %edx
  801357:	50                   	push   %eax
  801358:	6a 1d                	push   $0x1d
  80135a:	e8 ad fc ff ff       	call   80100c <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
	return result;
  801362:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801365:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801368:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136b:	89 01                	mov    %eax,(%ecx)
  80136d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	c9                   	leave  
  801374:	c2 04 00             	ret    $0x4

00801377 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	ff 75 10             	pushl  0x10(%ebp)
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	6a 13                	push   $0x13
  801389:	e8 7e fc ff ff       	call   80100c <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
	return ;
  801391:	90                   	nop
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_rcr2>:
uint32 sys_rcr2()
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 1e                	push   $0x1e
  8013a3:	e8 64 fc ff ff       	call   80100c <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	50                   	push   %eax
  8013c6:	6a 1f                	push   $0x1f
  8013c8:	e8 3f fc ff ff       	call   80100c <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d0:	90                   	nop
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <rsttst>:
void rsttst()
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 21                	push   $0x21
  8013e2:	e8 25 fc ff ff       	call   80100c <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ea:	90                   	nop
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8013fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801400:	52                   	push   %edx
  801401:	50                   	push   %eax
  801402:	ff 75 10             	pushl  0x10(%ebp)
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	6a 20                	push   $0x20
  80140d:	e8 fa fb ff ff       	call   80100c <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
	return ;
  801415:	90                   	nop
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <chktst>:
void chktst(uint32 n)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	ff 75 08             	pushl  0x8(%ebp)
  801426:	6a 22                	push   $0x22
  801428:	e8 df fb ff ff       	call   80100c <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
	return ;
  801430:	90                   	nop
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <inctst>:

void inctst()
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 23                	push   $0x23
  801442:	e8 c5 fb ff ff       	call   80100c <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
	return ;
  80144a:	90                   	nop
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <gettst>:
uint32 gettst()
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 24                	push   $0x24
  80145c:	e8 ab fb ff ff       	call   80100c <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 25                	push   $0x25
  801478:	e8 8f fb ff ff       	call   80100c <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
  801480:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801483:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801487:	75 07                	jne    801490 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801489:	b8 01 00 00 00       	mov    $0x1,%eax
  80148e:	eb 05                	jmp    801495 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 25                	push   $0x25
  8014a9:	e8 5e fb ff ff       	call   80100c <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
  8014b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014b8:	75 07                	jne    8014c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8014bf:	eb 05                	jmp    8014c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 25                	push   $0x25
  8014da:	e8 2d fb ff ff       	call   80100c <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
  8014e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014e9:	75 07                	jne    8014f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f0:	eb 05                	jmp    8014f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 25                	push   $0x25
  80150b:	e8 fc fa ff ff       	call   80100c <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
  801513:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801516:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80151a:	75 07                	jne    801523 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80151c:	b8 01 00 00 00       	mov    $0x1,%eax
  801521:	eb 05                	jmp    801528 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	6a 26                	push   $0x26
  80153a:	e8 cd fa ff ff       	call   80100c <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
	return ;
  801542:	90                   	nop
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801549:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	53                   	push   %ebx
  801558:	51                   	push   %ecx
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	6a 27                	push   $0x27
  80155d:	e8 aa fa ff ff       	call   80100c <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80156d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	52                   	push   %edx
  80157a:	50                   	push   %eax
  80157b:	6a 28                	push   $0x28
  80157d:	e8 8a fa ff ff       	call   80100c <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80158a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80158d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	51                   	push   %ecx
  801596:	ff 75 10             	pushl  0x10(%ebp)
  801599:	52                   	push   %edx
  80159a:	50                   	push   %eax
  80159b:	6a 29                	push   $0x29
  80159d:	e8 6a fa ff ff       	call   80100c <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	ff 75 10             	pushl  0x10(%ebp)
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	6a 12                	push   $0x12
  8015b9:	e8 4e fa ff ff       	call   80100c <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c1:	90                   	nop
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	52                   	push   %edx
  8015d4:	50                   	push   %eax
  8015d5:	6a 2a                	push   $0x2a
  8015d7:	e8 30 fa ff ff       	call   80100c <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
	return;
  8015df:	90                   	nop
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 77 1f 80 00       	push   $0x801f77
  8015f0:	68 2e 01 00 00       	push   $0x12e
  8015f5:	68 8b 1f 80 00       	push   $0x801f8b
  8015fa:	e8 3a 00 00 00       	call   801639 <_panic>

008015ff <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	68 77 1f 80 00       	push   $0x801f77
  80160d:	68 35 01 00 00       	push   $0x135
  801612:	68 8b 1f 80 00       	push   $0x801f8b
  801617:	e8 1d 00 00 00       	call   801639 <_panic>

0080161c <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	68 77 1f 80 00       	push   $0x801f77
  80162a:	68 3b 01 00 00       	push   $0x13b
  80162f:	68 8b 1f 80 00       	push   $0x801f8b
  801634:	e8 00 00 00 00       	call   801639 <_panic>

00801639 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80163f:	8d 45 10             	lea    0x10(%ebp),%eax
  801642:	83 c0 04             	add    $0x4,%eax
  801645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801648:	a1 dc 68 81 00       	mov    0x8168dc,%eax
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 16                	je     801667 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801651:	a1 dc 68 81 00       	mov    0x8168dc,%eax
  801656:	83 ec 08             	sub    $0x8,%esp
  801659:	50                   	push   %eax
  80165a:	68 9c 1f 80 00       	push   $0x801f9c
  80165f:	e8 0e ec ff ff       	call   800272 <cprintf>
  801664:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801667:	a1 00 30 80 00       	mov    0x803000,%eax
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	50                   	push   %eax
  801673:	68 a1 1f 80 00       	push   $0x801fa1
  801678:	e8 f5 eb ff ff       	call   800272 <cprintf>
  80167d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801680:	8b 45 10             	mov    0x10(%ebp),%eax
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	ff 75 f4             	pushl  -0xc(%ebp)
  801689:	50                   	push   %eax
  80168a:	e8 78 eb ff ff       	call   800207 <vcprintf>
  80168f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	6a 00                	push   $0x0
  801697:	68 bd 1f 80 00       	push   $0x801fbd
  80169c:	e8 66 eb ff ff       	call   800207 <vcprintf>
  8016a1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016a4:	e8 e7 ea ff ff       	call   800190 <exit>

	// should not return here
	while (1) ;
  8016a9:	eb fe                	jmp    8016a9 <_panic+0x70>

008016ab <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8016b6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bf:	39 c2                	cmp    %eax,%edx
  8016c1:	74 14                	je     8016d7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	68 c0 1f 80 00       	push   $0x801fc0
  8016cb:	6a 26                	push   $0x26
  8016cd:	68 0c 20 80 00       	push   $0x80200c
  8016d2:	e8 62 ff ff ff       	call   801639 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016e5:	e9 c5 00 00 00       	jmp    8017af <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	8b 00                	mov    (%eax),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	75 08                	jne    801707 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016ff:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801702:	e9 a5 00 00 00       	jmp    8017ac <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801707:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80170e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801715:	eb 69                	jmp    801780 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801717:	a1 20 30 80 00       	mov    0x803020,%eax
  80171c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801722:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801725:	89 d0                	mov    %edx,%eax
  801727:	01 c0                	add    %eax,%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	c1 e0 03             	shl    $0x3,%eax
  80172e:	01 c8                	add    %ecx,%eax
  801730:	8a 40 04             	mov    0x4(%eax),%al
  801733:	84 c0                	test   %al,%al
  801735:	75 46                	jne    80177d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801737:	a1 20 30 80 00       	mov    0x803020,%eax
  80173c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801742:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801745:	89 d0                	mov    %edx,%eax
  801747:	01 c0                	add    %eax,%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	c1 e0 03             	shl    $0x3,%eax
  80174e:	01 c8                	add    %ecx,%eax
  801750:	8b 00                	mov    (%eax),%eax
  801752:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801755:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801758:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80175d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	01 c8                	add    %ecx,%eax
  80176e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801770:	39 c2                	cmp    %eax,%edx
  801772:	75 09                	jne    80177d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801774:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80177b:	eb 15                	jmp    801792 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80177d:	ff 45 e8             	incl   -0x18(%ebp)
  801780:	a1 20 30 80 00       	mov    0x803020,%eax
  801785:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80178b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178e:	39 c2                	cmp    %eax,%edx
  801790:	77 85                	ja     801717 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801796:	75 14                	jne    8017ac <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	68 18 20 80 00       	push   $0x802018
  8017a0:	6a 3a                	push   $0x3a
  8017a2:	68 0c 20 80 00       	push   $0x80200c
  8017a7:	e8 8d fe ff ff       	call   801639 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8017ac:	ff 45 f0             	incl   -0x10(%ebp)
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017b5:	0f 8c 2f ff ff ff    	jl     8016ea <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017c9:	eb 26                	jmp    8017f1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8017d0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017d9:	89 d0                	mov    %edx,%eax
  8017db:	01 c0                	add    %eax,%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	c1 e0 03             	shl    $0x3,%eax
  8017e2:	01 c8                	add    %ecx,%eax
  8017e4:	8a 40 04             	mov    0x4(%eax),%al
  8017e7:	3c 01                	cmp    $0x1,%al
  8017e9:	75 03                	jne    8017ee <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017eb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017ee:	ff 45 e0             	incl   -0x20(%ebp)
  8017f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8017f6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ff:	39 c2                	cmp    %eax,%edx
  801801:	77 c8                	ja     8017cb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801809:	74 14                	je     80181f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	68 6c 20 80 00       	push   $0x80206c
  801813:	6a 44                	push   $0x44
  801815:	68 0c 20 80 00       	push   $0x80200c
  80181a:	e8 1a fe ff ff       	call   801639 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    
  801822:	66 90                	xchg   %ax,%ax

00801824 <__udivdi3>:
  801824:	55                   	push   %ebp
  801825:	57                   	push   %edi
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	83 ec 1c             	sub    $0x1c,%esp
  80182b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80182f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801837:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183b:	89 ca                	mov    %ecx,%edx
  80183d:	89 f8                	mov    %edi,%eax
  80183f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801843:	85 f6                	test   %esi,%esi
  801845:	75 2d                	jne    801874 <__udivdi3+0x50>
  801847:	39 cf                	cmp    %ecx,%edi
  801849:	77 65                	ja     8018b0 <__udivdi3+0x8c>
  80184b:	89 fd                	mov    %edi,%ebp
  80184d:	85 ff                	test   %edi,%edi
  80184f:	75 0b                	jne    80185c <__udivdi3+0x38>
  801851:	b8 01 00 00 00       	mov    $0x1,%eax
  801856:	31 d2                	xor    %edx,%edx
  801858:	f7 f7                	div    %edi
  80185a:	89 c5                	mov    %eax,%ebp
  80185c:	31 d2                	xor    %edx,%edx
  80185e:	89 c8                	mov    %ecx,%eax
  801860:	f7 f5                	div    %ebp
  801862:	89 c1                	mov    %eax,%ecx
  801864:	89 d8                	mov    %ebx,%eax
  801866:	f7 f5                	div    %ebp
  801868:	89 cf                	mov    %ecx,%edi
  80186a:	89 fa                	mov    %edi,%edx
  80186c:	83 c4 1c             	add    $0x1c,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5f                   	pop    %edi
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    
  801874:	39 ce                	cmp    %ecx,%esi
  801876:	77 28                	ja     8018a0 <__udivdi3+0x7c>
  801878:	0f bd fe             	bsr    %esi,%edi
  80187b:	83 f7 1f             	xor    $0x1f,%edi
  80187e:	75 40                	jne    8018c0 <__udivdi3+0x9c>
  801880:	39 ce                	cmp    %ecx,%esi
  801882:	72 0a                	jb     80188e <__udivdi3+0x6a>
  801884:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801888:	0f 87 9e 00 00 00    	ja     80192c <__udivdi3+0x108>
  80188e:	b8 01 00 00 00       	mov    $0x1,%eax
  801893:	89 fa                	mov    %edi,%edx
  801895:	83 c4 1c             	add    $0x1c,%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5f                   	pop    %edi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
  80189d:	8d 76 00             	lea    0x0(%esi),%esi
  8018a0:	31 ff                	xor    %edi,%edi
  8018a2:	31 c0                	xor    %eax,%eax
  8018a4:	89 fa                	mov    %edi,%edx
  8018a6:	83 c4 1c             	add    $0x1c,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5f                   	pop    %edi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    
  8018ae:	66 90                	xchg   %ax,%ax
  8018b0:	89 d8                	mov    %ebx,%eax
  8018b2:	f7 f7                	div    %edi
  8018b4:	31 ff                	xor    %edi,%edi
  8018b6:	89 fa                	mov    %edi,%edx
  8018b8:	83 c4 1c             	add    $0x1c,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
  8018c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c5:	89 eb                	mov    %ebp,%ebx
  8018c7:	29 fb                	sub    %edi,%ebx
  8018c9:	89 f9                	mov    %edi,%ecx
  8018cb:	d3 e6                	shl    %cl,%esi
  8018cd:	89 c5                	mov    %eax,%ebp
  8018cf:	88 d9                	mov    %bl,%cl
  8018d1:	d3 ed                	shr    %cl,%ebp
  8018d3:	89 e9                	mov    %ebp,%ecx
  8018d5:	09 f1                	or     %esi,%ecx
  8018d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018db:	89 f9                	mov    %edi,%ecx
  8018dd:	d3 e0                	shl    %cl,%eax
  8018df:	89 c5                	mov    %eax,%ebp
  8018e1:	89 d6                	mov    %edx,%esi
  8018e3:	88 d9                	mov    %bl,%cl
  8018e5:	d3 ee                	shr    %cl,%esi
  8018e7:	89 f9                	mov    %edi,%ecx
  8018e9:	d3 e2                	shl    %cl,%edx
  8018eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018ef:	88 d9                	mov    %bl,%cl
  8018f1:	d3 e8                	shr    %cl,%eax
  8018f3:	09 c2                	or     %eax,%edx
  8018f5:	89 d0                	mov    %edx,%eax
  8018f7:	89 f2                	mov    %esi,%edx
  8018f9:	f7 74 24 0c          	divl   0xc(%esp)
  8018fd:	89 d6                	mov    %edx,%esi
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	f7 e5                	mul    %ebp
  801903:	39 d6                	cmp    %edx,%esi
  801905:	72 19                	jb     801920 <__udivdi3+0xfc>
  801907:	74 0b                	je     801914 <__udivdi3+0xf0>
  801909:	89 d8                	mov    %ebx,%eax
  80190b:	31 ff                	xor    %edi,%edi
  80190d:	e9 58 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  801912:	66 90                	xchg   %ax,%ax
  801914:	8b 54 24 08          	mov    0x8(%esp),%edx
  801918:	89 f9                	mov    %edi,%ecx
  80191a:	d3 e2                	shl    %cl,%edx
  80191c:	39 c2                	cmp    %eax,%edx
  80191e:	73 e9                	jae    801909 <__udivdi3+0xe5>
  801920:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801923:	31 ff                	xor    %edi,%edi
  801925:	e9 40 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	31 c0                	xor    %eax,%eax
  80192e:	e9 37 ff ff ff       	jmp    80186a <__udivdi3+0x46>
  801933:	90                   	nop

00801934 <__umoddi3>:
  801934:	55                   	push   %ebp
  801935:	57                   	push   %edi
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	83 ec 1c             	sub    $0x1c,%esp
  80193b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80193f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801943:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801947:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80194b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801953:	89 f3                	mov    %esi,%ebx
  801955:	89 fa                	mov    %edi,%edx
  801957:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195b:	89 34 24             	mov    %esi,(%esp)
  80195e:	85 c0                	test   %eax,%eax
  801960:	75 1a                	jne    80197c <__umoddi3+0x48>
  801962:	39 f7                	cmp    %esi,%edi
  801964:	0f 86 a2 00 00 00    	jbe    801a0c <__umoddi3+0xd8>
  80196a:	89 c8                	mov    %ecx,%eax
  80196c:	89 f2                	mov    %esi,%edx
  80196e:	f7 f7                	div    %edi
  801970:	89 d0                	mov    %edx,%eax
  801972:	31 d2                	xor    %edx,%edx
  801974:	83 c4 1c             	add    $0x1c,%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    
  80197c:	39 f0                	cmp    %esi,%eax
  80197e:	0f 87 ac 00 00 00    	ja     801a30 <__umoddi3+0xfc>
  801984:	0f bd e8             	bsr    %eax,%ebp
  801987:	83 f5 1f             	xor    $0x1f,%ebp
  80198a:	0f 84 ac 00 00 00    	je     801a3c <__umoddi3+0x108>
  801990:	bf 20 00 00 00       	mov    $0x20,%edi
  801995:	29 ef                	sub    %ebp,%edi
  801997:	89 fe                	mov    %edi,%esi
  801999:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80199d:	89 e9                	mov    %ebp,%ecx
  80199f:	d3 e0                	shl    %cl,%eax
  8019a1:	89 d7                	mov    %edx,%edi
  8019a3:	89 f1                	mov    %esi,%ecx
  8019a5:	d3 ef                	shr    %cl,%edi
  8019a7:	09 c7                	or     %eax,%edi
  8019a9:	89 e9                	mov    %ebp,%ecx
  8019ab:	d3 e2                	shl    %cl,%edx
  8019ad:	89 14 24             	mov    %edx,(%esp)
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	d3 e0                	shl    %cl,%eax
  8019b4:	89 c2                	mov    %eax,%edx
  8019b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ba:	d3 e0                	shl    %cl,%eax
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c4:	89 f1                	mov    %esi,%ecx
  8019c6:	d3 e8                	shr    %cl,%eax
  8019c8:	09 d0                	or     %edx,%eax
  8019ca:	d3 eb                	shr    %cl,%ebx
  8019cc:	89 da                	mov    %ebx,%edx
  8019ce:	f7 f7                	div    %edi
  8019d0:	89 d3                	mov    %edx,%ebx
  8019d2:	f7 24 24             	mull   (%esp)
  8019d5:	89 c6                	mov    %eax,%esi
  8019d7:	89 d1                	mov    %edx,%ecx
  8019d9:	39 d3                	cmp    %edx,%ebx
  8019db:	0f 82 87 00 00 00    	jb     801a68 <__umoddi3+0x134>
  8019e1:	0f 84 91 00 00 00    	je     801a78 <__umoddi3+0x144>
  8019e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019eb:	29 f2                	sub    %esi,%edx
  8019ed:	19 cb                	sbb    %ecx,%ebx
  8019ef:	89 d8                	mov    %ebx,%eax
  8019f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f5:	d3 e0                	shl    %cl,%eax
  8019f7:	89 e9                	mov    %ebp,%ecx
  8019f9:	d3 ea                	shr    %cl,%edx
  8019fb:	09 d0                	or     %edx,%eax
  8019fd:	89 e9                	mov    %ebp,%ecx
  8019ff:	d3 eb                	shr    %cl,%ebx
  801a01:	89 da                	mov    %ebx,%edx
  801a03:	83 c4 1c             	add    $0x1c,%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5f                   	pop    %edi
  801a09:	5d                   	pop    %ebp
  801a0a:	c3                   	ret    
  801a0b:	90                   	nop
  801a0c:	89 fd                	mov    %edi,%ebp
  801a0e:	85 ff                	test   %edi,%edi
  801a10:	75 0b                	jne    801a1d <__umoddi3+0xe9>
  801a12:	b8 01 00 00 00       	mov    $0x1,%eax
  801a17:	31 d2                	xor    %edx,%edx
  801a19:	f7 f7                	div    %edi
  801a1b:	89 c5                	mov    %eax,%ebp
  801a1d:	89 f0                	mov    %esi,%eax
  801a1f:	31 d2                	xor    %edx,%edx
  801a21:	f7 f5                	div    %ebp
  801a23:	89 c8                	mov    %ecx,%eax
  801a25:	f7 f5                	div    %ebp
  801a27:	89 d0                	mov    %edx,%eax
  801a29:	e9 44 ff ff ff       	jmp    801972 <__umoddi3+0x3e>
  801a2e:	66 90                	xchg   %ax,%ax
  801a30:	89 c8                	mov    %ecx,%eax
  801a32:	89 f2                	mov    %esi,%edx
  801a34:	83 c4 1c             	add    $0x1c,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
  801a3c:	3b 04 24             	cmp    (%esp),%eax
  801a3f:	72 06                	jb     801a47 <__umoddi3+0x113>
  801a41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a45:	77 0f                	ja     801a56 <__umoddi3+0x122>
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	29 f9                	sub    %edi,%ecx
  801a4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a4f:	89 14 24             	mov    %edx,(%esp)
  801a52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a56:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a5a:	8b 14 24             	mov    (%esp),%edx
  801a5d:	83 c4 1c             	add    $0x1c,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    
  801a65:	8d 76 00             	lea    0x0(%esi),%esi
  801a68:	2b 04 24             	sub    (%esp),%eax
  801a6b:	19 fa                	sbb    %edi,%edx
  801a6d:	89 d1                	mov    %edx,%ecx
  801a6f:	89 c6                	mov    %eax,%esi
  801a71:	e9 71 ff ff ff       	jmp    8019e7 <__umoddi3+0xb3>
  801a76:	66 90                	xchg   %ax,%ax
  801a78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a7c:	72 ea                	jb     801a68 <__umoddi3+0x134>
  801a7e:	89 d9                	mov    %ebx,%ecx
  801a80:	e9 62 ff ff ff       	jmp    8019e7 <__umoddi3+0xb3>
