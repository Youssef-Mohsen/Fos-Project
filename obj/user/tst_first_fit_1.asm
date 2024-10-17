
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 08 00 00 00       	call   80003e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 3000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	//cprintf("Congratulations!! test FIRST FIT (1) [PAGE ALLOCATOR] completed successfully.\n\n");
	cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);

	return;
#endif
}
  80003b:	90                   	nop
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800044:	e8 99 12 00 00       	call   8012e2 <sys_getenvindex>
  800049:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80004c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80004f:	89 d0                	mov    %edx,%eax
  800051:	c1 e0 06             	shl    $0x6,%eax
  800054:	29 d0                	sub    %edx,%eax
  800056:	c1 e0 02             	shl    $0x2,%eax
  800059:	01 d0                	add    %edx,%eax
  80005b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800062:	01 c8                	add    %ecx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800070:	29 c2                	sub    %eax,%edx
  800072:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800079:	89 c2                	mov    %eax,%edx
  80007b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800081:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800086:	a1 04 30 80 00       	mov    0x803004,%eax
  80008b:	8a 40 20             	mov    0x20(%eax),%al
  80008e:	84 c0                	test   %al,%al
  800090:	74 0d                	je     80009f <libmain+0x61>
		binaryname = myEnv->prog_name;
  800092:	a1 04 30 80 00       	mov    0x803004,%eax
  800097:	83 c0 20             	add    $0x20,%eax
  80009a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a3:	7e 0a                	jle    8000af <libmain+0x71>
		binaryname = argv[0];
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	ff 75 0c             	pushl  0xc(%ebp)
  8000b5:	ff 75 08             	pushl  0x8(%ebp)
  8000b8:	e8 7b ff ff ff       	call   800038 <_main>
  8000bd:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000c0:	e8 a1 0f 00 00       	call   801066 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 98 1a 80 00       	push   $0x801a98
  8000cd:	e8 8d 01 00 00       	call   80025f <cprintf>
  8000d2:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000da:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8000e0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e5:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	52                   	push   %edx
  8000ef:	50                   	push   %eax
  8000f0:	68 c0 1a 80 00       	push   $0x801ac0
  8000f5:	e8 65 01 00 00       	call   80025f <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800108:	a1 04 30 80 00       	mov    0x803004,%eax
  80010d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800113:	a1 04 30 80 00       	mov    0x803004,%eax
  800118:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80011e:	51                   	push   %ecx
  80011f:	52                   	push   %edx
  800120:	50                   	push   %eax
  800121:	68 e8 1a 80 00       	push   $0x801ae8
  800126:	e8 34 01 00 00       	call   80025f <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80012e:	a1 04 30 80 00       	mov    0x803004,%eax
  800133:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	50                   	push   %eax
  80013d:	68 40 1b 80 00       	push   $0x801b40
  800142:	e8 18 01 00 00       	call   80025f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 98 1a 80 00       	push   $0x801a98
  800152:	e8 08 01 00 00       	call   80025f <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80015a:	e8 21 0f 00 00       	call   801080 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80015f:	e8 19 00 00 00       	call   80017d <exit>
}
  800164:	90                   	nop
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	6a 00                	push   $0x0
  800172:	e8 37 11 00 00       	call   8012ae <sys_destroy_env>
  800177:	83 c4 10             	add    $0x10,%esp
}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <exit>:

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800183:	e8 8c 11 00 00       	call   801314 <sys_exit_env>
}
  800188:	90                   	nop
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	8d 48 01             	lea    0x1(%eax),%ecx
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 0a                	mov    %ecx,(%edx)
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	88 d1                	mov    %dl,%cl
  8001a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 2c                	jne    8001e2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001b6:	a0 08 30 80 00       	mov    0x803008,%al
  8001bb:	0f b6 c0             	movzbl %al,%eax
  8001be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c1:	8b 12                	mov    (%edx),%edx
  8001c3:	89 d1                	mov    %edx,%ecx
  8001c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c8:	83 c2 08             	add    $0x8,%edx
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	50                   	push   %eax
  8001cf:	51                   	push   %ecx
  8001d0:	52                   	push   %edx
  8001d1:	e8 4e 0e 00 00       	call   801024 <sys_cputs>
  8001d6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	8b 40 04             	mov    0x4(%eax),%eax
  8001e8:	8d 50 01             	lea    0x1(%eax),%edx
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800204:	00 00 00 
	b.cnt = 0;
  800207:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800211:	ff 75 0c             	pushl  0xc(%ebp)
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	68 8b 01 80 00       	push   $0x80018b
  800223:	e8 11 02 00 00       	call   800439 <vprintfmt>
  800228:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80022b:	a0 08 30 80 00       	mov    0x803008,%al
  800230:	0f b6 c0             	movzbl %al,%eax
  800233:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	50                   	push   %eax
  80023d:	52                   	push   %edx
  80023e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800244:	83 c0 08             	add    $0x8,%eax
  800247:	50                   	push   %eax
  800248:	e8 d7 0d 00 00       	call   801024 <sys_cputs>
  80024d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800250:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800257:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800265:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80026c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80026f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	ff 75 f4             	pushl  -0xc(%ebp)
  80027b:	50                   	push   %eax
  80027c:	e8 73 ff ff ff       	call   8001f4 <vcprintf>
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800287:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800292:	e8 cf 0d 00 00       	call   801066 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800297:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a6:	50                   	push   %eax
  8002a7:	e8 48 ff ff ff       	call   8001f4 <vcprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002b2:	e8 c9 0d 00 00       	call   801080 <sys_unlock_cons>
	return cnt;
  8002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	53                   	push   %ebx
  8002c0:	83 ec 14             	sub    $0x14,%esp
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002da:	77 55                	ja     800331 <printnum+0x75>
  8002dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002df:	72 05                	jb     8002e6 <printnum+0x2a>
  8002e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e4:	77 4b                	ja     800331 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f4:	52                   	push   %edx
  8002f5:	50                   	push   %eax
  8002f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8002fc:	e8 0f 15 00 00       	call   801810 <__udivdi3>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 20             	pushl  0x20(%ebp)
  80030a:	53                   	push   %ebx
  80030b:	ff 75 18             	pushl  0x18(%ebp)
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 a1 ff ff ff       	call   8002bc <printnum>
  80031b:	83 c4 20             	add    $0x20,%esp
  80031e:	eb 1a                	jmp    80033a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 20             	pushl  0x20(%ebp)
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	ff d0                	call   *%eax
  80032e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800331:	ff 4d 1c             	decl   0x1c(%ebp)
  800334:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800338:	7f e6                	jg     800320 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800348:	53                   	push   %ebx
  800349:	51                   	push   %ecx
  80034a:	52                   	push   %edx
  80034b:	50                   	push   %eax
  80034c:	e8 cf 15 00 00       	call   801920 <__umoddi3>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	05 74 1d 80 00       	add    $0x801d74,%eax
  800359:	8a 00                	mov    (%eax),%al
  80035b:	0f be c0             	movsbl %al,%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 0c             	pushl  0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	ff d0                	call   *%eax
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800376:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037a:	7e 1c                	jle    800398 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	8d 50 08             	lea    0x8(%eax),%edx
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	89 10                	mov    %edx,(%eax)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	83 e8 08             	sub    $0x8,%eax
  800391:	8b 50 04             	mov    0x4(%eax),%edx
  800394:	8b 00                	mov    (%eax),%eax
  800396:	eb 40                	jmp    8003d8 <getuint+0x65>
	else if (lflag)
  800398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80039c:	74 1e                	je     8003bc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	8d 50 04             	lea    0x4(%eax),%edx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	89 10                	mov    %edx,(%eax)
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	83 e8 04             	sub    $0x4,%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ba:	eb 1c                	jmp    8003d8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	8d 50 04             	lea    0x4(%eax),%edx
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	89 10                	mov    %edx,(%eax)
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 e8 04             	sub    $0x4,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e1:	7e 1c                	jle    8003ff <getint+0x25>
		return va_arg(*ap, long long);
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	8d 50 08             	lea    0x8(%eax),%edx
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	83 e8 08             	sub    $0x8,%eax
  8003f8:	8b 50 04             	mov    0x4(%eax),%edx
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	eb 38                	jmp    800437 <getint+0x5d>
	else if (lflag)
  8003ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800403:	74 1a                	je     80041f <getint+0x45>
		return va_arg(*ap, long);
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	8d 50 04             	lea    0x4(%eax),%edx
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	89 10                	mov    %edx,(%eax)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	83 e8 04             	sub    $0x4,%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	99                   	cltd   
  80041d:	eb 18                	jmp    800437 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 10                	mov    %edx,(%eax)
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	83 e8 04             	sub    $0x4,%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
}
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	56                   	push   %esi
  80043d:	53                   	push   %ebx
  80043e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800441:	eb 17                	jmp    80045a <vprintfmt+0x21>
			if (ch == '\0')
  800443:	85 db                	test   %ebx,%ebx
  800445:	0f 84 c1 03 00 00    	je     80080c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	53                   	push   %ebx
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	ff d0                	call   *%eax
  800457:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8d 50 01             	lea    0x1(%eax),%edx
  800460:	89 55 10             	mov    %edx,0x10(%ebp)
  800463:	8a 00                	mov    (%eax),%al
  800465:	0f b6 d8             	movzbl %al,%ebx
  800468:	83 fb 25             	cmp    $0x25,%ebx
  80046b:	75 d6                	jne    800443 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80046d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800471:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800478:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80047f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800486:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	8b 45 10             	mov    0x10(%ebp),%eax
  800490:	8d 50 01             	lea    0x1(%eax),%edx
  800493:	89 55 10             	mov    %edx,0x10(%ebp)
  800496:	8a 00                	mov    (%eax),%al
  800498:	0f b6 d8             	movzbl %al,%ebx
  80049b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80049e:	83 f8 5b             	cmp    $0x5b,%eax
  8004a1:	0f 87 3d 03 00 00    	ja     8007e4 <vprintfmt+0x3ab>
  8004a7:	8b 04 85 98 1d 80 00 	mov    0x801d98(,%eax,4),%eax
  8004ae:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b4:	eb d7                	jmp    80048d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004ba:	eb d1                	jmp    80048d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c6:	89 d0                	mov    %edx,%eax
  8004c8:	c1 e0 02             	shl    $0x2,%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	01 c0                	add    %eax,%eax
  8004cf:	01 d8                	add    %ebx,%eax
  8004d1:	83 e8 30             	sub    $0x30,%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	8a 00                	mov    (%eax),%al
  8004dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004df:	83 fb 2f             	cmp    $0x2f,%ebx
  8004e2:	7e 3e                	jle    800522 <vprintfmt+0xe9>
  8004e4:	83 fb 39             	cmp    $0x39,%ebx
  8004e7:	7f 39                	jg     800522 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ec:	eb d5                	jmp    8004c3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f1:	83 c0 04             	add    $0x4,%eax
  8004f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	83 e8 04             	sub    $0x4,%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800502:	eb 1f                	jmp    800523 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800508:	79 83                	jns    80048d <vprintfmt+0x54>
				width = 0;
  80050a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800511:	e9 77 ff ff ff       	jmp    80048d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800516:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051d:	e9 6b ff ff ff       	jmp    80048d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800522:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800523:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800527:	0f 89 60 ff ff ff    	jns    80048d <vprintfmt+0x54>
				width = precision, precision = -1;
  80052d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800533:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80053a:	e9 4e ff ff ff       	jmp    80048d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800542:	e9 46 ff ff ff       	jmp    80048d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	83 c0 04             	add    $0x4,%eax
  80054d:	89 45 14             	mov    %eax,0x14(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	83 e8 04             	sub    $0x4,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	ff 75 0c             	pushl  0xc(%ebp)
  80055e:	50                   	push   %eax
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	ff d0                	call   *%eax
  800564:	83 c4 10             	add    $0x10,%esp
			break;
  800567:	e9 9b 02 00 00       	jmp    800807 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 c0 04             	add    $0x4,%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 e8 04             	sub    $0x4,%eax
  80057b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80057d:	85 db                	test   %ebx,%ebx
  80057f:	79 02                	jns    800583 <vprintfmt+0x14a>
				err = -err;
  800581:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800583:	83 fb 64             	cmp    $0x64,%ebx
  800586:	7f 0b                	jg     800593 <vprintfmt+0x15a>
  800588:	8b 34 9d e0 1b 80 00 	mov    0x801be0(,%ebx,4),%esi
  80058f:	85 f6                	test   %esi,%esi
  800591:	75 19                	jne    8005ac <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800593:	53                   	push   %ebx
  800594:	68 85 1d 80 00       	push   $0x801d85
  800599:	ff 75 0c             	pushl  0xc(%ebp)
  80059c:	ff 75 08             	pushl  0x8(%ebp)
  80059f:	e8 70 02 00 00       	call   800814 <printfmt>
  8005a4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005a7:	e9 5b 02 00 00       	jmp    800807 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ac:	56                   	push   %esi
  8005ad:	68 8e 1d 80 00       	push   $0x801d8e
  8005b2:	ff 75 0c             	pushl  0xc(%ebp)
  8005b5:	ff 75 08             	pushl  0x8(%ebp)
  8005b8:	e8 57 02 00 00       	call   800814 <printfmt>
  8005bd:	83 c4 10             	add    $0x10,%esp
			break;
  8005c0:	e9 42 02 00 00       	jmp    800807 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	83 c0 04             	add    $0x4,%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	83 e8 04             	sub    $0x4,%eax
  8005d4:	8b 30                	mov    (%eax),%esi
  8005d6:	85 f6                	test   %esi,%esi
  8005d8:	75 05                	jne    8005df <vprintfmt+0x1a6>
				p = "(null)";
  8005da:	be 91 1d 80 00       	mov    $0x801d91,%esi
			if (width > 0 && padc != '-')
  8005df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e3:	7e 6d                	jle    800652 <vprintfmt+0x219>
  8005e5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e9:	74 67                	je     800652 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	50                   	push   %eax
  8005f2:	56                   	push   %esi
  8005f3:	e8 1e 03 00 00       	call   800916 <strnlen>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005fe:	eb 16                	jmp    800616 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800600:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	50                   	push   %eax
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	ff d0                	call   *%eax
  800610:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	ff 4d e4             	decl   -0x1c(%ebp)
  800616:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061a:	7f e4                	jg     800600 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061c:	eb 34                	jmp    800652 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80061e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800622:	74 1c                	je     800640 <vprintfmt+0x207>
  800624:	83 fb 1f             	cmp    $0x1f,%ebx
  800627:	7e 05                	jle    80062e <vprintfmt+0x1f5>
  800629:	83 fb 7e             	cmp    $0x7e,%ebx
  80062c:	7e 12                	jle    800640 <vprintfmt+0x207>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	ff d0                	call   *%eax
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	eb 0f                	jmp    80064f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	53                   	push   %ebx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	ff d0                	call   *%eax
  80064c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064f:	ff 4d e4             	decl   -0x1c(%ebp)
  800652:	89 f0                	mov    %esi,%eax
  800654:	8d 70 01             	lea    0x1(%eax),%esi
  800657:	8a 00                	mov    (%eax),%al
  800659:	0f be d8             	movsbl %al,%ebx
  80065c:	85 db                	test   %ebx,%ebx
  80065e:	74 24                	je     800684 <vprintfmt+0x24b>
  800660:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800664:	78 b8                	js     80061e <vprintfmt+0x1e5>
  800666:	ff 4d e0             	decl   -0x20(%ebp)
  800669:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066d:	79 af                	jns    80061e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066f:	eb 13                	jmp    800684 <vprintfmt+0x24b>
				putch(' ', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	6a 20                	push   $0x20
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	ff d0                	call   *%eax
  80067e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800681:	ff 4d e4             	decl   -0x1c(%ebp)
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	7f e7                	jg     800671 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80068a:	e9 78 01 00 00       	jmp    800807 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 e8             	pushl  -0x18(%ebp)
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	50                   	push   %eax
  800699:	e8 3c fd ff ff       	call   8003da <getint>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ad:	85 d2                	test   %edx,%edx
  8006af:	79 23                	jns    8006d4 <vprintfmt+0x29b>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	6a 2d                	push   $0x2d
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c7:	f7 d8                	neg    %eax
  8006c9:	83 d2 00             	adc    $0x0,%edx
  8006cc:	f7 da                	neg    %edx
  8006ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006db:	e9 bc 00 00 00       	jmp    80079c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	e8 84 fc ff ff       	call   800373 <getuint>
  8006ef:	83 c4 10             	add    $0x10,%esp
  8006f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006ff:	e9 98 00 00 00       	jmp    80079c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 58                	push   $0x58
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 0c             	pushl  0xc(%ebp)
  80071a:	6a 58                	push   $0x58
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	ff d0                	call   *%eax
  800721:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	6a 58                	push   $0x58
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
			break;
  800734:	e9 ce 00 00 00       	jmp    800807 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 30                	push   $0x30
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	6a 78                	push   $0x78
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800774:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80077b:	eb 1f                	jmp    80079c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 e8             	pushl  -0x18(%ebp)
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	e8 e7 fb ff ff       	call   800373 <getuint>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800792:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800795:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80079c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	83 ec 04             	sub    $0x4,%esp
  8007a6:	52                   	push   %edx
  8007a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 00 fb ff ff       	call   8002bc <printnum>
  8007bc:	83 c4 20             	add    $0x20,%esp
			break;
  8007bf:	eb 46                	jmp    800807 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
			break;
  8007d0:	eb 35                	jmp    800807 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007d2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8007d9:	eb 2c                	jmp    800807 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007db:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8007e2:	eb 23                	jmp    800807 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	6a 25                	push   $0x25
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	ff d0                	call   *%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f4:	ff 4d 10             	decl   0x10(%ebp)
  8007f7:	eb 03                	jmp    8007fc <vprintfmt+0x3c3>
  8007f9:	ff 4d 10             	decl   0x10(%ebp)
  8007fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ff:	48                   	dec    %eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	3c 25                	cmp    $0x25,%al
  800804:	75 f3                	jne    8007f9 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800806:	90                   	nop
		}
	}
  800807:	e9 35 fc ff ff       	jmp    800441 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80080c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80080d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800810:	5b                   	pop    %ebx
  800811:	5e                   	pop    %esi
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80081a:	8d 45 10             	lea    0x10(%ebp),%eax
  80081d:	83 c0 04             	add    $0x4,%eax
  800820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800823:	8b 45 10             	mov    0x10(%ebp),%eax
  800826:	ff 75 f4             	pushl  -0xc(%ebp)
  800829:	50                   	push   %eax
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	ff 75 08             	pushl  0x8(%ebp)
  800830:	e8 04 fc ff ff       	call   800439 <vprintfmt>
  800835:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800838:	90                   	nop
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	8b 40 08             	mov    0x8(%eax),%eax
  800844:	8d 50 01             	lea    0x1(%eax),%edx
  800847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80084d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800850:	8b 10                	mov    (%eax),%edx
  800852:	8b 45 0c             	mov    0xc(%ebp),%eax
  800855:	8b 40 04             	mov    0x4(%eax),%eax
  800858:	39 c2                	cmp    %eax,%edx
  80085a:	73 12                	jae    80086e <sprintputch+0x33>
		*b->buf++ = ch;
  80085c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	8d 48 01             	lea    0x1(%eax),%ecx
  800864:	8b 55 0c             	mov    0xc(%ebp),%edx
  800867:	89 0a                	mov    %ecx,(%edx)
  800869:	8b 55 08             	mov    0x8(%ebp),%edx
  80086c:	88 10                	mov    %dl,(%eax)
}
  80086e:	90                   	nop
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800880:	8d 50 ff             	lea    -0x1(%eax),%edx
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	01 d0                	add    %edx,%eax
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800892:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800896:	74 06                	je     80089e <vsnprintf+0x2d>
  800898:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80089c:	7f 07                	jg     8008a5 <vsnprintf+0x34>
		return -E_INVAL;
  80089e:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a3:	eb 20                	jmp    8008c5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a5:	ff 75 14             	pushl  0x14(%ebp)
  8008a8:	ff 75 10             	pushl  0x10(%ebp)
  8008ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ae:	50                   	push   %eax
  8008af:	68 3b 08 80 00       	push   $0x80083b
  8008b4:	e8 80 fb ff ff       	call   800439 <vprintfmt>
  8008b9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c5:	c9                   	leave  
  8008c6:	c3                   	ret    

008008c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008cd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d0:	83 c0 04             	add    $0x4,%eax
  8008d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	ff 75 08             	pushl  0x8(%ebp)
  8008e3:	e8 89 ff ff ff       	call   800871 <vsnprintf>
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800900:	eb 06                	jmp    800908 <strlen+0x15>
		n++;
  800902:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800905:	ff 45 08             	incl   0x8(%ebp)
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	84 c0                	test   %al,%al
  80090f:	75 f1                	jne    800902 <strlen+0xf>
		n++;
	return n;
  800911:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800923:	eb 09                	jmp    80092e <strnlen+0x18>
		n++;
  800925:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800928:	ff 45 08             	incl   0x8(%ebp)
  80092b:	ff 4d 0c             	decl   0xc(%ebp)
  80092e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800932:	74 09                	je     80093d <strnlen+0x27>
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8a 00                	mov    (%eax),%al
  800939:	84 c0                	test   %al,%al
  80093b:	75 e8                	jne    800925 <strnlen+0xf>
		n++;
	return n;
  80093d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80094e:	90                   	nop
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8d 50 01             	lea    0x1(%eax),%edx
  800955:	89 55 08             	mov    %edx,0x8(%ebp)
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80095e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800961:	8a 12                	mov    (%edx),%dl
  800963:	88 10                	mov    %dl,(%eax)
  800965:	8a 00                	mov    (%eax),%al
  800967:	84 c0                	test   %al,%al
  800969:	75 e4                	jne    80094f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80096b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80097c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800983:	eb 1f                	jmp    8009a4 <strncpy+0x34>
		*dst++ = *src;
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 08             	mov    %edx,0x8(%ebp)
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	8a 12                	mov    (%edx),%dl
  800993:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800995:	8b 45 0c             	mov    0xc(%ebp),%eax
  800998:	8a 00                	mov    (%eax),%al
  80099a:	84 c0                	test   %al,%al
  80099c:	74 03                	je     8009a1 <strncpy+0x31>
			src++;
  80099e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a1:	ff 45 fc             	incl   -0x4(%ebp)
  8009a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009aa:	72 d9                	jb     800985 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c1:	74 30                	je     8009f3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c3:	eb 16                	jmp    8009db <strlcpy+0x2a>
			*dst++ = *src++;
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8d 50 01             	lea    0x1(%eax),%edx
  8009cb:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d7:	8a 12                	mov    (%edx),%dl
  8009d9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009db:	ff 4d 10             	decl   0x10(%ebp)
  8009de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e2:	74 09                	je     8009ed <strlcpy+0x3c>
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	84 c0                	test   %al,%al
  8009eb:	75 d8                	jne    8009c5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f9:	29 c2                	sub    %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a02:	eb 06                	jmp    800a0a <strcmp+0xb>
		p++, q++;
  800a04:	ff 45 08             	incl   0x8(%ebp)
  800a07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	84 c0                	test   %al,%al
  800a11:	74 0e                	je     800a21 <strcmp+0x22>
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 10                	mov    (%eax),%dl
  800a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	38 c2                	cmp    %al,%dl
  800a1f:	74 e3                	je     800a04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8a 00                	mov    (%eax),%al
  800a26:	0f b6 d0             	movzbl %al,%edx
  800a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f b6 c0             	movzbl %al,%eax
  800a31:	29 c2                	sub    %eax,%edx
  800a33:	89 d0                	mov    %edx,%eax
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a3a:	eb 09                	jmp    800a45 <strncmp+0xe>
		n--, p++, q++;
  800a3c:	ff 4d 10             	decl   0x10(%ebp)
  800a3f:	ff 45 08             	incl   0x8(%ebp)
  800a42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a49:	74 17                	je     800a62 <strncmp+0x2b>
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8a 00                	mov    (%eax),%al
  800a50:	84 c0                	test   %al,%al
  800a52:	74 0e                	je     800a62 <strncmp+0x2b>
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8a 10                	mov    (%eax),%dl
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	38 c2                	cmp    %al,%dl
  800a60:	74 da                	je     800a3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a66:	75 07                	jne    800a6f <strncmp+0x38>
		return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6d:	eb 14                	jmp    800a83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	0f b6 d0             	movzbl %al,%edx
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f b6 c0             	movzbl %al,%eax
  800a7f:	29 c2                	sub    %eax,%edx
  800a81:	89 d0                	mov    %edx,%eax
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a91:	eb 12                	jmp    800aa5 <strchr+0x20>
		if (*s == c)
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8a 00                	mov    (%eax),%al
  800a98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a9b:	75 05                	jne    800aa2 <strchr+0x1d>
			return (char *) s;
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	eb 11                	jmp    800ab3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa2:	ff 45 08             	incl   0x8(%ebp)
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	84 c0                	test   %al,%al
  800aac:	75 e5                	jne    800a93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 04             	sub    $0x4,%esp
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac1:	eb 0d                	jmp    800ad0 <strfind+0x1b>
		if (*s == c)
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800acb:	74 0e                	je     800adb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800acd:	ff 45 08             	incl   0x8(%ebp)
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	84 c0                	test   %al,%al
  800ad7:	75 ea                	jne    800ac3 <strfind+0xe>
  800ad9:	eb 01                	jmp    800adc <strfind+0x27>
		if (*s == c)
			break;
  800adb:	90                   	nop
	return (char *) s;
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800aed:	8b 45 10             	mov    0x10(%ebp),%eax
  800af0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af3:	eb 0e                	jmp    800b03 <memset+0x22>
		*p++ = c;
  800af5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b03:	ff 4d f8             	decl   -0x8(%ebp)
  800b06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b0a:	79 e9                	jns    800af5 <memset+0x14>
		*p++ = c;

	return v;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b23:	eb 16                	jmp    800b3b <memcpy+0x2a>
		*d++ = *s++;
  800b25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b28:	8d 50 01             	lea    0x1(%eax),%edx
  800b2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b37:	8a 12                	mov    (%edx),%dl
  800b39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b41:	89 55 10             	mov    %edx,0x10(%ebp)
  800b44:	85 c0                	test   %eax,%eax
  800b46:	75 dd                	jne    800b25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b65:	73 50                	jae    800bb7 <memmove+0x6a>
  800b67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	01 d0                	add    %edx,%eax
  800b6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b72:	76 43                	jbe    800bb7 <memmove+0x6a>
		s += n;
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b80:	eb 10                	jmp    800b92 <memmove+0x45>
			*--d = *--s;
  800b82:	ff 4d f8             	decl   -0x8(%ebp)
  800b85:	ff 4d fc             	decl   -0x4(%ebp)
  800b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8b:	8a 10                	mov    (%eax),%dl
  800b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b92:	8b 45 10             	mov    0x10(%ebp),%eax
  800b95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b98:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9b:	85 c0                	test   %eax,%eax
  800b9d:	75 e3                	jne    800b82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b9f:	eb 23                	jmp    800bc4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba4:	8d 50 01             	lea    0x1(%eax),%edx
  800ba7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800baa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb3:	8a 12                	mov    (%edx),%dl
  800bb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc0:	85 c0                	test   %eax,%eax
  800bc2:	75 dd                	jne    800ba1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bdb:	eb 2a                	jmp    800c07 <memcmp+0x3e>
		if (*s1 != *s2)
  800bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be0:	8a 10                	mov    (%eax),%dl
  800be2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	38 c2                	cmp    %al,%dl
  800be9:	74 16                	je     800c01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	0f b6 d0             	movzbl %al,%edx
  800bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	29 c2                	sub    %eax,%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	eb 18                	jmp    800c19 <memcmp+0x50>
		s1++, s2++;
  800c01:	ff 45 fc             	incl   -0x4(%ebp)
  800c04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c10:	85 c0                	test   %eax,%eax
  800c12:	75 c9                	jne    800bdd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c21:	8b 55 08             	mov    0x8(%ebp),%edx
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	01 d0                	add    %edx,%eax
  800c29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c2c:	eb 15                	jmp    800c43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	0f b6 d0             	movzbl %al,%edx
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	0f b6 c0             	movzbl %al,%eax
  800c3c:	39 c2                	cmp    %eax,%edx
  800c3e:	74 0d                	je     800c4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c40:	ff 45 08             	incl   0x8(%ebp)
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c49:	72 e3                	jb     800c2e <memfind+0x13>
  800c4b:	eb 01                	jmp    800c4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c4d:	90                   	nop
	return (void *) s;
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c67:	eb 03                	jmp    800c6c <strtol+0x19>
		s++;
  800c69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	3c 20                	cmp    $0x20,%al
  800c73:	74 f4                	je     800c69 <strtol+0x16>
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	3c 09                	cmp    $0x9,%al
  800c7c:	74 eb                	je     800c69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	3c 2b                	cmp    $0x2b,%al
  800c85:	75 05                	jne    800c8c <strtol+0x39>
		s++;
  800c87:	ff 45 08             	incl   0x8(%ebp)
  800c8a:	eb 13                	jmp    800c9f <strtol+0x4c>
	else if (*s == '-')
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	3c 2d                	cmp    $0x2d,%al
  800c93:	75 0a                	jne    800c9f <strtol+0x4c>
		s++, neg = 1;
  800c95:	ff 45 08             	incl   0x8(%ebp)
  800c98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca3:	74 06                	je     800cab <strtol+0x58>
  800ca5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ca9:	75 20                	jne    800ccb <strtol+0x78>
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	3c 30                	cmp    $0x30,%al
  800cb2:	75 17                	jne    800ccb <strtol+0x78>
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	40                   	inc    %eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 78                	cmp    $0x78,%al
  800cbc:	75 0d                	jne    800ccb <strtol+0x78>
		s += 2, base = 16;
  800cbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cc9:	eb 28                	jmp    800cf3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccf:	75 15                	jne    800ce6 <strtol+0x93>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	3c 30                	cmp    $0x30,%al
  800cd8:	75 0c                	jne    800ce6 <strtol+0x93>
		s++, base = 8;
  800cda:	ff 45 08             	incl   0x8(%ebp)
  800cdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce4:	eb 0d                	jmp    800cf3 <strtol+0xa0>
	else if (base == 0)
  800ce6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cea:	75 07                	jne    800cf3 <strtol+0xa0>
		base = 10;
  800cec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	3c 2f                	cmp    $0x2f,%al
  800cfa:	7e 19                	jle    800d15 <strtol+0xc2>
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	3c 39                	cmp    $0x39,%al
  800d03:	7f 10                	jg     800d15 <strtol+0xc2>
			dig = *s - '0';
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f be c0             	movsbl %al,%eax
  800d0d:	83 e8 30             	sub    $0x30,%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 42                	jmp    800d57 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	3c 60                	cmp    $0x60,%al
  800d1c:	7e 19                	jle    800d37 <strtol+0xe4>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	3c 7a                	cmp    $0x7a,%al
  800d25:	7f 10                	jg     800d37 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	0f be c0             	movsbl %al,%eax
  800d2f:	83 e8 57             	sub    $0x57,%eax
  800d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d35:	eb 20                	jmp    800d57 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8a 00                	mov    (%eax),%al
  800d3c:	3c 40                	cmp    $0x40,%al
  800d3e:	7e 39                	jle    800d79 <strtol+0x126>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	3c 5a                	cmp    $0x5a,%al
  800d47:	7f 30                	jg     800d79 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f be c0             	movsbl %al,%eax
  800d51:	83 e8 37             	sub    $0x37,%eax
  800d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5d:	7d 19                	jge    800d78 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d65:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d6e:	01 d0                	add    %edx,%eax
  800d70:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d73:	e9 7b ff ff ff       	jmp    800cf3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d78:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7d:	74 08                	je     800d87 <strtol+0x134>
		*endptr = (char *) s;
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d87:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d8b:	74 07                	je     800d94 <strtol+0x141>
  800d8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d90:	f7 d8                	neg    %eax
  800d92:	eb 03                	jmp    800d97 <strtol+0x144>
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    

00800d99 <ltostr>:

void
ltostr(long value, char *str)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800da6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db1:	79 13                	jns    800dc6 <ltostr+0x2d>
	{
		neg = 1;
  800db3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dce:	99                   	cltd   
  800dcf:	f7 f9                	idiv   %ecx
  800dd1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddd:	89 c2                	mov    %eax,%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800de7:	83 c2 30             	add    $0x30,%edx
  800dea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800def:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df4:	f7 e9                	imul   %ecx
  800df6:	c1 fa 02             	sar    $0x2,%edx
  800df9:	89 c8                	mov    %ecx,%eax
  800dfb:	c1 f8 1f             	sar    $0x1f,%eax
  800dfe:	29 c2                	sub    %eax,%edx
  800e00:	89 d0                	mov    %edx,%eax
  800e02:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e09:	75 bb                	jne    800dc6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e15:	48                   	dec    %eax
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e19:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e1d:	74 3d                	je     800e5c <ltostr+0xc3>
		start = 1 ;
  800e1f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e26:	eb 34                	jmp    800e5c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	01 d0                	add    %edx,%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	01 c2                	add    %eax,%edx
  800e3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	01 c8                	add    %ecx,%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	01 c2                	add    %eax,%edx
  800e51:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e54:	88 02                	mov    %al,(%edx)
		start++ ;
  800e56:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e59:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e62:	7c c4                	jl     800e28 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e64:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	01 d0                	add    %edx,%eax
  800e6c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e6f:	90                   	nop
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e78:	ff 75 08             	pushl  0x8(%ebp)
  800e7b:	e8 73 fa ff ff       	call   8008f3 <strlen>
  800e80:	83 c4 04             	add    $0x4,%esp
  800e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e86:	ff 75 0c             	pushl  0xc(%ebp)
  800e89:	e8 65 fa ff ff       	call   8008f3 <strlen>
  800e8e:	83 c4 04             	add    $0x4,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea2:	eb 17                	jmp    800ebb <strcconcat+0x49>
		final[s] = str1[s] ;
  800ea4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	01 c2                	add    %eax,%edx
  800eac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	01 c8                	add    %ecx,%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ec1:	7c e1                	jl     800ea4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ec3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ed1:	eb 1f                	jmp    800ef2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed6:	8d 50 01             	lea    0x1(%eax),%edx
  800ed9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800edc:	89 c2                	mov    %eax,%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 c2                	add    %eax,%edx
  800ee3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	01 c8                	add    %ecx,%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800eef:	ff 45 f8             	incl   -0x8(%ebp)
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ef8:	7c d9                	jl     800ed3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800efa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c6 00 00             	movb   $0x0,(%eax)
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f14:	8b 45 14             	mov    0x14(%ebp),%eax
  800f17:	8b 00                	mov    (%eax),%eax
  800f19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	01 d0                	add    %edx,%eax
  800f25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f2b:	eb 0c                	jmp    800f39 <strsplit+0x31>
			*string++ = 0;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 08             	mov    %edx,0x8(%ebp)
  800f36:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	84 c0                	test   %al,%al
  800f40:	74 18                	je     800f5a <strsplit+0x52>
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f be c0             	movsbl %al,%eax
  800f4a:	50                   	push   %eax
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	e8 32 fb ff ff       	call   800a85 <strchr>
  800f53:	83 c4 08             	add    $0x8,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 d3                	jne    800f2d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 5a                	je     800fbd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	8b 00                	mov    (%eax),%eax
  800f68:	83 f8 0f             	cmp    $0xf,%eax
  800f6b:	75 07                	jne    800f74 <strsplit+0x6c>
		{
			return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f72:	eb 66                	jmp    800fda <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f74:	8b 45 14             	mov    0x14(%ebp),%eax
  800f77:	8b 00                	mov    (%eax),%eax
  800f79:	8d 48 01             	lea    0x1(%eax),%ecx
  800f7c:	8b 55 14             	mov    0x14(%ebp),%edx
  800f7f:	89 0a                	mov    %ecx,(%edx)
  800f81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 c2                	add    %eax,%edx
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f92:	eb 03                	jmp    800f97 <strsplit+0x8f>
			string++;
  800f94:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 8b                	je     800f2b <strsplit+0x23>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f be c0             	movsbl %al,%eax
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	e8 d4 fa ff ff       	call   800a85 <strchr>
  800fb1:	83 c4 08             	add    $0x8,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	74 dc                	je     800f94 <strsplit+0x8c>
			string++;
	}
  800fb8:	e9 6e ff ff ff       	jmp    800f2b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fbd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc1:	8b 00                	mov    (%eax),%eax
  800fc3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 d0                	add    %edx,%eax
  800fcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fd5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	68 08 1f 80 00       	push   $0x801f08
  800fea:	68 3f 01 00 00       	push   $0x13f
  800fef:	68 2a 1f 80 00       	push   $0x801f2a
  800ff4:	e8 2d 06 00 00       	call   801626 <_panic>

00800ff9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
  800fff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8b 55 0c             	mov    0xc(%ebp),%edx
  801008:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80100b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80100e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801011:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801014:	cd 30                	int    $0x30
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801019:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	5b                   	pop    %ebx
  801020:	5e                   	pop    %esi
  801021:	5f                   	pop    %edi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 04             	sub    $0x4,%esp
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801030:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	6a 00                	push   $0x0
  801039:	6a 00                	push   $0x0
  80103b:	52                   	push   %edx
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	50                   	push   %eax
  801040:	6a 00                	push   $0x0
  801042:	e8 b2 ff ff ff       	call   800ff9 <syscall>
  801047:	83 c4 18             	add    $0x18,%esp
}
  80104a:	90                   	nop
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <sys_cgetc>:

int
sys_cgetc(void)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801050:	6a 00                	push   $0x0
  801052:	6a 00                	push   $0x0
  801054:	6a 00                	push   $0x0
  801056:	6a 00                	push   $0x0
  801058:	6a 00                	push   $0x0
  80105a:	6a 02                	push   $0x2
  80105c:	e8 98 ff ff ff       	call   800ff9 <syscall>
  801061:	83 c4 18             	add    $0x18,%esp
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801069:	6a 00                	push   $0x0
  80106b:	6a 00                	push   $0x0
  80106d:	6a 00                	push   $0x0
  80106f:	6a 00                	push   $0x0
  801071:	6a 00                	push   $0x0
  801073:	6a 03                	push   $0x3
  801075:	e8 7f ff ff ff       	call   800ff9 <syscall>
  80107a:	83 c4 18             	add    $0x18,%esp
}
  80107d:	90                   	nop
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801083:	6a 00                	push   $0x0
  801085:	6a 00                	push   $0x0
  801087:	6a 00                	push   $0x0
  801089:	6a 00                	push   $0x0
  80108b:	6a 00                	push   $0x0
  80108d:	6a 04                	push   $0x4
  80108f:	e8 65 ff ff ff       	call   800ff9 <syscall>
  801094:	83 c4 18             	add    $0x18,%esp
}
  801097:	90                   	nop
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80109d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 00                	push   $0x0
  8010a9:	52                   	push   %edx
  8010aa:	50                   	push   %eax
  8010ab:	6a 08                	push   $0x8
  8010ad:	e8 47 ff ff ff       	call   800ff9 <syscall>
  8010b2:	83 c4 18             	add    $0x18,%esp
}
  8010b5:	c9                   	leave  
  8010b6:	c3                   	ret    

008010b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8010bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	51                   	push   %ecx
  8010ce:	52                   	push   %edx
  8010cf:	50                   	push   %eax
  8010d0:	6a 09                	push   $0x9
  8010d2:	e8 22 ff ff ff       	call   800ff9 <syscall>
  8010d7:	83 c4 18             	add    $0x18,%esp
}
  8010da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010dd:	5b                   	pop    %ebx
  8010de:	5e                   	pop    %esi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	6a 00                	push   $0x0
  8010f0:	52                   	push   %edx
  8010f1:	50                   	push   %eax
  8010f2:	6a 0a                	push   $0xa
  8010f4:	e8 00 ff ff ff       	call   800ff9 <syscall>
  8010f9:	83 c4 18             	add    $0x18,%esp
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801101:	6a 00                	push   $0x0
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	6a 0b                	push   $0xb
  80110f:	e8 e5 fe ff ff       	call   800ff9 <syscall>
  801114:	83 c4 18             	add    $0x18,%esp
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 0c                	push   $0xc
  801128:	e8 cc fe ff ff       	call   800ff9 <syscall>
  80112d:	83 c4 18             	add    $0x18,%esp
}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 0d                	push   $0xd
  801141:	e8 b3 fe ff ff       	call   800ff9 <syscall>
  801146:	83 c4 18             	add    $0x18,%esp
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80114e:	6a 00                	push   $0x0
  801150:	6a 00                	push   $0x0
  801152:	6a 00                	push   $0x0
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 0e                	push   $0xe
  80115a:	e8 9a fe ff ff       	call   800ff9 <syscall>
  80115f:	83 c4 18             	add    $0x18,%esp
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801167:	6a 00                	push   $0x0
  801169:	6a 00                	push   $0x0
  80116b:	6a 00                	push   $0x0
  80116d:	6a 00                	push   $0x0
  80116f:	6a 00                	push   $0x0
  801171:	6a 0f                	push   $0xf
  801173:	e8 81 fe ff ff       	call   800ff9 <syscall>
  801178:	83 c4 18             	add    $0x18,%esp
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	6a 00                	push   $0x0
  801188:	ff 75 08             	pushl  0x8(%ebp)
  80118b:	6a 10                	push   $0x10
  80118d:	e8 67 fe ff ff       	call   800ff9 <syscall>
  801192:	83 c4 18             	add    $0x18,%esp
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 11                	push   $0x11
  8011a6:	e8 4e fe ff ff       	call   800ff9 <syscall>
  8011ab:	83 c4 18             	add    $0x18,%esp
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_cputc>:

void
sys_cputc(const char c)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	50                   	push   %eax
  8011ca:	6a 01                	push   $0x1
  8011cc:	e8 28 fe ff ff       	call   800ff9 <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 14                	push   $0x14
  8011e6:	e8 0e fe ff ff       	call   800ff9 <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8011fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801200:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	6a 00                	push   $0x0
  801209:	51                   	push   %ecx
  80120a:	52                   	push   %edx
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	6a 15                	push   $0x15
  801211:	e8 e3 fd ff ff       	call   800ff9 <syscall>
  801216:	83 c4 18             	add    $0x18,%esp
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80121e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	52                   	push   %edx
  80122b:	50                   	push   %eax
  80122c:	6a 16                	push   $0x16
  80122e:	e8 c6 fd ff ff       	call   800ff9 <syscall>
  801233:	83 c4 18             	add    $0x18,%esp
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80123b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80123e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	51                   	push   %ecx
  801249:	52                   	push   %edx
  80124a:	50                   	push   %eax
  80124b:	6a 17                	push   $0x17
  80124d:	e8 a7 fd ff ff       	call   800ff9 <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	52                   	push   %edx
  801267:	50                   	push   %eax
  801268:	6a 18                	push   $0x18
  80126a:	e8 8a fd ff ff       	call   800ff9 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	6a 00                	push   $0x0
  80127c:	ff 75 14             	pushl  0x14(%ebp)
  80127f:	ff 75 10             	pushl  0x10(%ebp)
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	50                   	push   %eax
  801286:	6a 19                	push   $0x19
  801288:	e8 6c fd ff ff       	call   800ff9 <syscall>
  80128d:	83 c4 18             	add    $0x18,%esp
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	50                   	push   %eax
  8012a1:	6a 1a                	push   $0x1a
  8012a3:	e8 51 fd ff ff       	call   800ff9 <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	90                   	nop
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	50                   	push   %eax
  8012bd:	6a 1b                	push   $0x1b
  8012bf:	e8 35 fd ff ff       	call   800ff9 <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 05                	push   $0x5
  8012d8:	e8 1c fd ff ff       	call   800ff9 <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 06                	push   $0x6
  8012f1:	e8 03 fd ff ff       	call   800ff9 <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 07                	push   $0x7
  80130a:	e8 ea fc ff ff       	call   800ff9 <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_exit_env>:


void sys_exit_env(void)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 1c                	push   $0x1c
  801323:	e8 d1 fc ff ff       	call   800ff9 <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	90                   	nop
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801334:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801337:	8d 50 04             	lea    0x4(%eax),%edx
  80133a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	52                   	push   %edx
  801344:	50                   	push   %eax
  801345:	6a 1d                	push   $0x1d
  801347:	e8 ad fc ff ff       	call   800ff9 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
	return result;
  80134f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801358:	89 01                	mov    %eax,(%ecx)
  80135a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	c9                   	leave  
  801361:	c2 04 00             	ret    $0x4

00801364 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	ff 75 10             	pushl  0x10(%ebp)
  80136e:	ff 75 0c             	pushl  0xc(%ebp)
  801371:	ff 75 08             	pushl  0x8(%ebp)
  801374:	6a 13                	push   $0x13
  801376:	e8 7e fc ff ff       	call   800ff9 <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
	return ;
  80137e:	90                   	nop
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_rcr2>:
uint32 sys_rcr2()
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 1e                	push   $0x1e
  801390:	e8 64 fc ff ff       	call   800ff9 <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	50                   	push   %eax
  8013b3:	6a 1f                	push   $0x1f
  8013b5:	e8 3f fc ff ff       	call   800ff9 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8013bd:	90                   	nop
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <rsttst>:
void rsttst()
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 21                	push   $0x21
  8013cf:	e8 25 fc ff ff       	call   800ff9 <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d7:	90                   	nop
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8013e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ed:	52                   	push   %edx
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 10             	pushl  0x10(%ebp)
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	ff 75 08             	pushl  0x8(%ebp)
  8013f8:	6a 20                	push   $0x20
  8013fa:	e8 fa fb ff ff       	call   800ff9 <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801402:	90                   	nop
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <chktst>:
void chktst(uint32 n)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	ff 75 08             	pushl  0x8(%ebp)
  801413:	6a 22                	push   $0x22
  801415:	e8 df fb ff ff       	call   800ff9 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
	return ;
  80141d:	90                   	nop
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <inctst>:

void inctst()
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 23                	push   $0x23
  80142f:	e8 c5 fb ff ff       	call   800ff9 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
	return ;
  801437:	90                   	nop
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <gettst>:
uint32 gettst()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 24                	push   $0x24
  801449:	e8 ab fb ff ff       	call   800ff9 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 25                	push   $0x25
  801465:	e8 8f fb ff ff       	call   800ff9 <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
  80146d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801470:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801474:	75 07                	jne    80147d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801476:	b8 01 00 00 00       	mov    $0x1,%eax
  80147b:	eb 05                	jmp    801482 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 25                	push   $0x25
  801496:	e8 5e fb ff ff       	call   800ff9 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
  80149e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014a1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014a5:	75 07                	jne    8014ae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ac:	eb 05                	jmp    8014b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 25                	push   $0x25
  8014c7:	e8 2d fb ff ff       	call   800ff9 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
  8014cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014d2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014d6:	75 07                	jne    8014df <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8014dd:	eb 05                	jmp    8014e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 25                	push   $0x25
  8014f8:	e8 fc fa ff ff       	call   800ff9 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
  801500:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801503:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801507:	75 07                	jne    801510 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801509:	b8 01 00 00 00       	mov    $0x1,%eax
  80150e:	eb 05                	jmp    801515 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	ff 75 08             	pushl  0x8(%ebp)
  801525:	6a 26                	push   $0x26
  801527:	e8 cd fa ff ff       	call   800ff9 <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
	return ;
  80152f:	90                   	nop
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801536:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801539:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	53                   	push   %ebx
  801545:	51                   	push   %ecx
  801546:	52                   	push   %edx
  801547:	50                   	push   %eax
  801548:	6a 27                	push   $0x27
  80154a:	e8 aa fa ff ff       	call   800ff9 <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
}
  801552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	6a 28                	push   $0x28
  80156a:	e8 8a fa ff ff       	call   800ff9 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801577:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80157a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	51                   	push   %ecx
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	52                   	push   %edx
  801587:	50                   	push   %eax
  801588:	6a 29                	push   $0x29
  80158a:	e8 6a fa ff ff       	call   800ff9 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	ff 75 10             	pushl  0x10(%ebp)
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	6a 12                	push   $0x12
  8015a6:	e8 4e fa ff ff       	call   800ff9 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ae:	90                   	nop
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	50                   	push   %eax
  8015c2:	6a 2a                	push   $0x2a
  8015c4:	e8 30 fa ff ff       	call   800ff9 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
	return;
  8015cc:	90                   	nop
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	68 37 1f 80 00       	push   $0x801f37
  8015dd:	68 2e 01 00 00       	push   $0x12e
  8015e2:	68 4b 1f 80 00       	push   $0x801f4b
  8015e7:	e8 3a 00 00 00       	call   801626 <_panic>

008015ec <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 37 1f 80 00       	push   $0x801f37
  8015fa:	68 35 01 00 00       	push   $0x135
  8015ff:	68 4b 1f 80 00       	push   $0x801f4b
  801604:	e8 1d 00 00 00       	call   801626 <_panic>

00801609 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 37 1f 80 00       	push   $0x801f37
  801617:	68 3b 01 00 00       	push   $0x13b
  80161c:	68 4b 1f 80 00       	push   $0x801f4b
  801621:	e8 00 00 00 00       	call   801626 <_panic>

00801626 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80162c:	8d 45 10             	lea    0x10(%ebp),%eax
  80162f:	83 c0 04             	add    $0x4,%eax
  801632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801635:	a1 24 30 80 00       	mov    0x803024,%eax
  80163a:	85 c0                	test   %eax,%eax
  80163c:	74 16                	je     801654 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80163e:	a1 24 30 80 00       	mov    0x803024,%eax
  801643:	83 ec 08             	sub    $0x8,%esp
  801646:	50                   	push   %eax
  801647:	68 5c 1f 80 00       	push   $0x801f5c
  80164c:	e8 0e ec ff ff       	call   80025f <cprintf>
  801651:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801654:	a1 00 30 80 00       	mov    0x803000,%eax
  801659:	ff 75 0c             	pushl  0xc(%ebp)
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	50                   	push   %eax
  801660:	68 61 1f 80 00       	push   $0x801f61
  801665:	e8 f5 eb ff ff       	call   80025f <cprintf>
  80166a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80166d:	8b 45 10             	mov    0x10(%ebp),%eax
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 f4             	pushl  -0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	e8 78 eb ff ff       	call   8001f4 <vcprintf>
  80167c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	6a 00                	push   $0x0
  801684:	68 7d 1f 80 00       	push   $0x801f7d
  801689:	e8 66 eb ff ff       	call   8001f4 <vcprintf>
  80168e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801691:	e8 e7 ea ff ff       	call   80017d <exit>

	// should not return here
	while (1) ;
  801696:	eb fe                	jmp    801696 <_panic+0x70>

00801698 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80169e:	a1 04 30 80 00       	mov    0x803004,%eax
  8016a3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ac:	39 c2                	cmp    %eax,%edx
  8016ae:	74 14                	je     8016c4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	68 80 1f 80 00       	push   $0x801f80
  8016b8:	6a 26                	push   $0x26
  8016ba:	68 cc 1f 80 00       	push   $0x801fcc
  8016bf:	e8 62 ff ff ff       	call   801626 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016d2:	e9 c5 00 00 00       	jmp    80179c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	01 d0                	add    %edx,%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	75 08                	jne    8016f4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016ef:	e9 a5 00 00 00       	jmp    801799 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801702:	eb 69                	jmp    80176d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801704:	a1 04 30 80 00       	mov    0x803004,%eax
  801709:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80170f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801712:	89 d0                	mov    %edx,%eax
  801714:	01 c0                	add    %eax,%eax
  801716:	01 d0                	add    %edx,%eax
  801718:	c1 e0 03             	shl    $0x3,%eax
  80171b:	01 c8                	add    %ecx,%eax
  80171d:	8a 40 04             	mov    0x4(%eax),%al
  801720:	84 c0                	test   %al,%al
  801722:	75 46                	jne    80176a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801724:	a1 04 30 80 00       	mov    0x803004,%eax
  801729:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80172f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801732:	89 d0                	mov    %edx,%eax
  801734:	01 c0                	add    %eax,%eax
  801736:	01 d0                	add    %edx,%eax
  801738:	c1 e0 03             	shl    $0x3,%eax
  80173b:	01 c8                	add    %ecx,%eax
  80173d:	8b 00                	mov    (%eax),%eax
  80173f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801745:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80174a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	01 c8                	add    %ecx,%eax
  80175b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	75 09                	jne    80176a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801761:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801768:	eb 15                	jmp    80177f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80176a:	ff 45 e8             	incl   -0x18(%ebp)
  80176d:	a1 04 30 80 00       	mov    0x803004,%eax
  801772:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177b:	39 c2                	cmp    %eax,%edx
  80177d:	77 85                	ja     801704 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80177f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801783:	75 14                	jne    801799 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 d8 1f 80 00       	push   $0x801fd8
  80178d:	6a 3a                	push   $0x3a
  80178f:	68 cc 1f 80 00       	push   $0x801fcc
  801794:	e8 8d fe ff ff       	call   801626 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801799:	ff 45 f0             	incl   -0x10(%ebp)
  80179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017a2:	0f 8c 2f ff ff ff    	jl     8016d7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017b6:	eb 26                	jmp    8017de <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8017bd:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c6:	89 d0                	mov    %edx,%eax
  8017c8:	01 c0                	add    %eax,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c1 e0 03             	shl    $0x3,%eax
  8017cf:	01 c8                	add    %ecx,%eax
  8017d1:	8a 40 04             	mov    0x4(%eax),%al
  8017d4:	3c 01                	cmp    $0x1,%al
  8017d6:	75 03                	jne    8017db <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017db:	ff 45 e0             	incl   -0x20(%ebp)
  8017de:	a1 04 30 80 00       	mov    0x803004,%eax
  8017e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ec:	39 c2                	cmp    %eax,%edx
  8017ee:	77 c8                	ja     8017b8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017f6:	74 14                	je     80180c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	68 2c 20 80 00       	push   $0x80202c
  801800:	6a 44                	push   $0x44
  801802:	68 cc 1f 80 00       	push   $0x801fcc
  801807:	e8 1a fe ff ff       	call   801626 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80180c:	90                   	nop
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    
  80180f:	90                   	nop

00801810 <__udivdi3>:
  801810:	55                   	push   %ebp
  801811:	57                   	push   %edi
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	83 ec 1c             	sub    $0x1c,%esp
  801817:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80181b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80181f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801823:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801827:	89 ca                	mov    %ecx,%edx
  801829:	89 f8                	mov    %edi,%eax
  80182b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80182f:	85 f6                	test   %esi,%esi
  801831:	75 2d                	jne    801860 <__udivdi3+0x50>
  801833:	39 cf                	cmp    %ecx,%edi
  801835:	77 65                	ja     80189c <__udivdi3+0x8c>
  801837:	89 fd                	mov    %edi,%ebp
  801839:	85 ff                	test   %edi,%edi
  80183b:	75 0b                	jne    801848 <__udivdi3+0x38>
  80183d:	b8 01 00 00 00       	mov    $0x1,%eax
  801842:	31 d2                	xor    %edx,%edx
  801844:	f7 f7                	div    %edi
  801846:	89 c5                	mov    %eax,%ebp
  801848:	31 d2                	xor    %edx,%edx
  80184a:	89 c8                	mov    %ecx,%eax
  80184c:	f7 f5                	div    %ebp
  80184e:	89 c1                	mov    %eax,%ecx
  801850:	89 d8                	mov    %ebx,%eax
  801852:	f7 f5                	div    %ebp
  801854:	89 cf                	mov    %ecx,%edi
  801856:	89 fa                	mov    %edi,%edx
  801858:	83 c4 1c             	add    $0x1c,%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
  801860:	39 ce                	cmp    %ecx,%esi
  801862:	77 28                	ja     80188c <__udivdi3+0x7c>
  801864:	0f bd fe             	bsr    %esi,%edi
  801867:	83 f7 1f             	xor    $0x1f,%edi
  80186a:	75 40                	jne    8018ac <__udivdi3+0x9c>
  80186c:	39 ce                	cmp    %ecx,%esi
  80186e:	72 0a                	jb     80187a <__udivdi3+0x6a>
  801870:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801874:	0f 87 9e 00 00 00    	ja     801918 <__udivdi3+0x108>
  80187a:	b8 01 00 00 00       	mov    $0x1,%eax
  80187f:	89 fa                	mov    %edi,%edx
  801881:	83 c4 1c             	add    $0x1c,%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5f                   	pop    %edi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    
  801889:	8d 76 00             	lea    0x0(%esi),%esi
  80188c:	31 ff                	xor    %edi,%edi
  80188e:	31 c0                	xor    %eax,%eax
  801890:	89 fa                	mov    %edi,%edx
  801892:	83 c4 1c             	add    $0x1c,%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5f                   	pop    %edi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    
  80189a:	66 90                	xchg   %ax,%ax
  80189c:	89 d8                	mov    %ebx,%eax
  80189e:	f7 f7                	div    %edi
  8018a0:	31 ff                	xor    %edi,%edi
  8018a2:	89 fa                	mov    %edi,%edx
  8018a4:	83 c4 1c             	add    $0x1c,%esp
  8018a7:	5b                   	pop    %ebx
  8018a8:	5e                   	pop    %esi
  8018a9:	5f                   	pop    %edi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    
  8018ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018b1:	89 eb                	mov    %ebp,%ebx
  8018b3:	29 fb                	sub    %edi,%ebx
  8018b5:	89 f9                	mov    %edi,%ecx
  8018b7:	d3 e6                	shl    %cl,%esi
  8018b9:	89 c5                	mov    %eax,%ebp
  8018bb:	88 d9                	mov    %bl,%cl
  8018bd:	d3 ed                	shr    %cl,%ebp
  8018bf:	89 e9                	mov    %ebp,%ecx
  8018c1:	09 f1                	or     %esi,%ecx
  8018c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018c7:	89 f9                	mov    %edi,%ecx
  8018c9:	d3 e0                	shl    %cl,%eax
  8018cb:	89 c5                	mov    %eax,%ebp
  8018cd:	89 d6                	mov    %edx,%esi
  8018cf:	88 d9                	mov    %bl,%cl
  8018d1:	d3 ee                	shr    %cl,%esi
  8018d3:	89 f9                	mov    %edi,%ecx
  8018d5:	d3 e2                	shl    %cl,%edx
  8018d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018db:	88 d9                	mov    %bl,%cl
  8018dd:	d3 e8                	shr    %cl,%eax
  8018df:	09 c2                	or     %eax,%edx
  8018e1:	89 d0                	mov    %edx,%eax
  8018e3:	89 f2                	mov    %esi,%edx
  8018e5:	f7 74 24 0c          	divl   0xc(%esp)
  8018e9:	89 d6                	mov    %edx,%esi
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	f7 e5                	mul    %ebp
  8018ef:	39 d6                	cmp    %edx,%esi
  8018f1:	72 19                	jb     80190c <__udivdi3+0xfc>
  8018f3:	74 0b                	je     801900 <__udivdi3+0xf0>
  8018f5:	89 d8                	mov    %ebx,%eax
  8018f7:	31 ff                	xor    %edi,%edi
  8018f9:	e9 58 ff ff ff       	jmp    801856 <__udivdi3+0x46>
  8018fe:	66 90                	xchg   %ax,%ax
  801900:	8b 54 24 08          	mov    0x8(%esp),%edx
  801904:	89 f9                	mov    %edi,%ecx
  801906:	d3 e2                	shl    %cl,%edx
  801908:	39 c2                	cmp    %eax,%edx
  80190a:	73 e9                	jae    8018f5 <__udivdi3+0xe5>
  80190c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80190f:	31 ff                	xor    %edi,%edi
  801911:	e9 40 ff ff ff       	jmp    801856 <__udivdi3+0x46>
  801916:	66 90                	xchg   %ax,%ax
  801918:	31 c0                	xor    %eax,%eax
  80191a:	e9 37 ff ff ff       	jmp    801856 <__udivdi3+0x46>
  80191f:	90                   	nop

00801920 <__umoddi3>:
  801920:	55                   	push   %ebp
  801921:	57                   	push   %edi
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 1c             	sub    $0x1c,%esp
  801927:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80192b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80192f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801933:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801937:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80193b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80193f:	89 f3                	mov    %esi,%ebx
  801941:	89 fa                	mov    %edi,%edx
  801943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801947:	89 34 24             	mov    %esi,(%esp)
  80194a:	85 c0                	test   %eax,%eax
  80194c:	75 1a                	jne    801968 <__umoddi3+0x48>
  80194e:	39 f7                	cmp    %esi,%edi
  801950:	0f 86 a2 00 00 00    	jbe    8019f8 <__umoddi3+0xd8>
  801956:	89 c8                	mov    %ecx,%eax
  801958:	89 f2                	mov    %esi,%edx
  80195a:	f7 f7                	div    %edi
  80195c:	89 d0                	mov    %edx,%eax
  80195e:	31 d2                	xor    %edx,%edx
  801960:	83 c4 1c             	add    $0x1c,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
  801968:	39 f0                	cmp    %esi,%eax
  80196a:	0f 87 ac 00 00 00    	ja     801a1c <__umoddi3+0xfc>
  801970:	0f bd e8             	bsr    %eax,%ebp
  801973:	83 f5 1f             	xor    $0x1f,%ebp
  801976:	0f 84 ac 00 00 00    	je     801a28 <__umoddi3+0x108>
  80197c:	bf 20 00 00 00       	mov    $0x20,%edi
  801981:	29 ef                	sub    %ebp,%edi
  801983:	89 fe                	mov    %edi,%esi
  801985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801989:	89 e9                	mov    %ebp,%ecx
  80198b:	d3 e0                	shl    %cl,%eax
  80198d:	89 d7                	mov    %edx,%edi
  80198f:	89 f1                	mov    %esi,%ecx
  801991:	d3 ef                	shr    %cl,%edi
  801993:	09 c7                	or     %eax,%edi
  801995:	89 e9                	mov    %ebp,%ecx
  801997:	d3 e2                	shl    %cl,%edx
  801999:	89 14 24             	mov    %edx,(%esp)
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	d3 e0                	shl    %cl,%eax
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019a6:	d3 e0                	shl    %cl,%eax
  8019a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b0:	89 f1                	mov    %esi,%ecx
  8019b2:	d3 e8                	shr    %cl,%eax
  8019b4:	09 d0                	or     %edx,%eax
  8019b6:	d3 eb                	shr    %cl,%ebx
  8019b8:	89 da                	mov    %ebx,%edx
  8019ba:	f7 f7                	div    %edi
  8019bc:	89 d3                	mov    %edx,%ebx
  8019be:	f7 24 24             	mull   (%esp)
  8019c1:	89 c6                	mov    %eax,%esi
  8019c3:	89 d1                	mov    %edx,%ecx
  8019c5:	39 d3                	cmp    %edx,%ebx
  8019c7:	0f 82 87 00 00 00    	jb     801a54 <__umoddi3+0x134>
  8019cd:	0f 84 91 00 00 00    	je     801a64 <__umoddi3+0x144>
  8019d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019d7:	29 f2                	sub    %esi,%edx
  8019d9:	19 cb                	sbb    %ecx,%ebx
  8019db:	89 d8                	mov    %ebx,%eax
  8019dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019e1:	d3 e0                	shl    %cl,%eax
  8019e3:	89 e9                	mov    %ebp,%ecx
  8019e5:	d3 ea                	shr    %cl,%edx
  8019e7:	09 d0                	or     %edx,%eax
  8019e9:	89 e9                	mov    %ebp,%ecx
  8019eb:	d3 eb                	shr    %cl,%ebx
  8019ed:	89 da                	mov    %ebx,%edx
  8019ef:	83 c4 1c             	add    $0x1c,%esp
  8019f2:	5b                   	pop    %ebx
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
  8019f7:	90                   	nop
  8019f8:	89 fd                	mov    %edi,%ebp
  8019fa:	85 ff                	test   %edi,%edi
  8019fc:	75 0b                	jne    801a09 <__umoddi3+0xe9>
  8019fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801a03:	31 d2                	xor    %edx,%edx
  801a05:	f7 f7                	div    %edi
  801a07:	89 c5                	mov    %eax,%ebp
  801a09:	89 f0                	mov    %esi,%eax
  801a0b:	31 d2                	xor    %edx,%edx
  801a0d:	f7 f5                	div    %ebp
  801a0f:	89 c8                	mov    %ecx,%eax
  801a11:	f7 f5                	div    %ebp
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	e9 44 ff ff ff       	jmp    80195e <__umoddi3+0x3e>
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	89 c8                	mov    %ecx,%eax
  801a1e:	89 f2                	mov    %esi,%edx
  801a20:	83 c4 1c             	add    $0x1c,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    
  801a28:	3b 04 24             	cmp    (%esp),%eax
  801a2b:	72 06                	jb     801a33 <__umoddi3+0x113>
  801a2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a31:	77 0f                	ja     801a42 <__umoddi3+0x122>
  801a33:	89 f2                	mov    %esi,%edx
  801a35:	29 f9                	sub    %edi,%ecx
  801a37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a3b:	89 14 24             	mov    %edx,(%esp)
  801a3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a42:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a46:	8b 14 24             	mov    (%esp),%edx
  801a49:	83 c4 1c             	add    $0x1c,%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
  801a51:	8d 76 00             	lea    0x0(%esi),%esi
  801a54:	2b 04 24             	sub    (%esp),%eax
  801a57:	19 fa                	sbb    %edi,%edx
  801a59:	89 d1                	mov    %edx,%ecx
  801a5b:	89 c6                	mov    %eax,%esi
  801a5d:	e9 71 ff ff ff       	jmp    8019d3 <__umoddi3+0xb3>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a68:	72 ea                	jb     801a54 <__umoddi3+0x134>
  801a6a:	89 d9                	mov    %ebx,%ecx
  801a6c:	e9 62 ff ff ff       	jmp    8019d3 <__umoddi3+0xb3>
