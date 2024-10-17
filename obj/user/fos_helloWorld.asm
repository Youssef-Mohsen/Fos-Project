
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 a0 1a 80 00       	push   $0x801aa0
  800046:	e8 6a 02 00 00       	call   8002b5 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 99 1a 80 00       	mov    0x801a99,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 c8 1a 80 00       	push   $0x801ac8
  80005c:	e8 54 02 00 00       	call   8002b5 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80006d:	e8 99 12 00 00       	call   80130b <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 06             	shl    $0x6,%eax
  80007d:	29 d0                	sub    %edx,%eax
  80007f:	c1 e0 02             	shl    $0x2,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80008b:	01 c8                	add    %ecx,%eax
  80008d:	c1 e0 03             	shl    $0x3,%eax
  800090:	01 d0                	add    %edx,%eax
  800092:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800099:	29 c2                	sub    %eax,%edx
  80009b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000a2:	89 c2                	mov    %eax,%edx
  8000a4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8000aa:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000af:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b4:	8a 40 20             	mov    0x20(%eax),%al
  8000b7:	84 c0                	test   %al,%al
  8000b9:	74 0d                	je     8000c8 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c0:	83 c0 20             	add    $0x20,%eax
  8000c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cc:	7e 0a                	jle    8000d8 <libmain+0x71>
		binaryname = argv[0];
  8000ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d1:	8b 00                	mov    (%eax),%eax
  8000d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000d8:	83 ec 08             	sub    $0x8,%esp
  8000db:	ff 75 0c             	pushl  0xc(%ebp)
  8000de:	ff 75 08             	pushl  0x8(%ebp)
  8000e1:	e8 52 ff ff ff       	call   800038 <_main>
  8000e6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000e9:	e8 a1 0f 00 00       	call   80108f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 f4 1a 80 00       	push   $0x801af4
  8000f6:	e8 8d 01 00 00       	call   800288 <cprintf>
  8000fb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800103:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800109:	a1 04 30 80 00       	mov    0x803004,%eax
  80010e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	52                   	push   %edx
  800118:	50                   	push   %eax
  800119:	68 1c 1b 80 00       	push   $0x801b1c
  80011e:	e8 65 01 00 00       	call   800288 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800126:	a1 04 30 80 00       	mov    0x803004,%eax
  80012b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800131:	a1 04 30 80 00       	mov    0x803004,%eax
  800136:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80013c:	a1 04 30 80 00       	mov    0x803004,%eax
  800141:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800147:	51                   	push   %ecx
  800148:	52                   	push   %edx
  800149:	50                   	push   %eax
  80014a:	68 44 1b 80 00       	push   $0x801b44
  80014f:	e8 34 01 00 00       	call   800288 <cprintf>
  800154:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800157:	a1 04 30 80 00       	mov    0x803004,%eax
  80015c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	50                   	push   %eax
  800166:	68 9c 1b 80 00       	push   $0x801b9c
  80016b:	e8 18 01 00 00       	call   800288 <cprintf>
  800170:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 f4 1a 80 00       	push   $0x801af4
  80017b:	e8 08 01 00 00       	call   800288 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800183:	e8 21 0f 00 00       	call   8010a9 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800188:	e8 19 00 00 00       	call   8001a6 <exit>
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	6a 00                	push   $0x0
  80019b:	e8 37 11 00 00       	call   8012d7 <sys_destroy_env>
  8001a0:	83 c4 10             	add    $0x10,%esp
}
  8001a3:	90                   	nop
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <exit>:

void
exit(void)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ac:	e8 8c 11 00 00       	call   80133d <sys_exit_env>
}
  8001b1:	90                   	nop
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bd:	8b 00                	mov    (%eax),%eax
  8001bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8001c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c5:	89 0a                	mov    %ecx,(%edx)
  8001c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ca:	88 d1                	mov    %dl,%cl
  8001cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	8b 00                	mov    (%eax),%eax
  8001d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001dd:	75 2c                	jne    80020b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001df:	a0 08 30 80 00       	mov    0x803008,%al
  8001e4:	0f b6 c0             	movzbl %al,%eax
  8001e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ea:	8b 12                	mov    (%edx),%edx
  8001ec:	89 d1                	mov    %edx,%ecx
  8001ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f1:	83 c2 08             	add    $0x8,%edx
  8001f4:	83 ec 04             	sub    $0x4,%esp
  8001f7:	50                   	push   %eax
  8001f8:	51                   	push   %ecx
  8001f9:	52                   	push   %edx
  8001fa:	e8 4e 0e 00 00       	call   80104d <sys_cputs>
  8001ff:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
  800205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80020b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020e:	8b 40 04             	mov    0x4(%eax),%eax
  800211:	8d 50 01             	lea    0x1(%eax),%edx
  800214:	8b 45 0c             	mov    0xc(%ebp),%eax
  800217:	89 50 04             	mov    %edx,0x4(%eax)
}
  80021a:	90                   	nop
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800226:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022d:	00 00 00 
	b.cnt = 0;
  800230:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800237:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800246:	50                   	push   %eax
  800247:	68 b4 01 80 00       	push   $0x8001b4
  80024c:	e8 11 02 00 00       	call   800462 <vprintfmt>
  800251:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800254:	a0 08 30 80 00       	mov    0x803008,%al
  800259:	0f b6 c0             	movzbl %al,%eax
  80025c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	50                   	push   %eax
  800266:	52                   	push   %edx
  800267:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026d:	83 c0 08             	add    $0x8,%eax
  800270:	50                   	push   %eax
  800271:	e8 d7 0d 00 00       	call   80104d <sys_cputs>
  800276:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800279:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800280:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80028e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800295:	8d 45 0c             	lea    0xc(%ebp),%eax
  800298:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80029b:	8b 45 08             	mov    0x8(%ebp),%eax
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a4:	50                   	push   %eax
  8002a5:	e8 73 ff ff ff       	call   80021d <vcprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002bb:	e8 cf 0d 00 00       	call   80108f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 48 ff ff ff       	call   80021d <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002db:	e8 c9 0d 00 00       	call   8010a9 <sys_unlock_cons>
	return cnt;
  8002e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 14             	sub    $0x14,%esp
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800300:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800303:	77 55                	ja     80035a <printnum+0x75>
  800305:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800308:	72 05                	jb     80030f <printnum+0x2a>
  80030a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80030d:	77 4b                	ja     80035a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80030f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800312:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800315:	8b 45 18             	mov    0x18(%ebp),%eax
  800318:	ba 00 00 00 00       	mov    $0x0,%edx
  80031d:	52                   	push   %edx
  80031e:	50                   	push   %eax
  80031f:	ff 75 f4             	pushl  -0xc(%ebp)
  800322:	ff 75 f0             	pushl  -0x10(%ebp)
  800325:	e8 0e 15 00 00       	call   801838 <__udivdi3>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	83 ec 04             	sub    $0x4,%esp
  800330:	ff 75 20             	pushl  0x20(%ebp)
  800333:	53                   	push   %ebx
  800334:	ff 75 18             	pushl  0x18(%ebp)
  800337:	52                   	push   %edx
  800338:	50                   	push   %eax
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 a1 ff ff ff       	call   8002e5 <printnum>
  800344:	83 c4 20             	add    $0x20,%esp
  800347:	eb 1a                	jmp    800363 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 20             	pushl  0x20(%ebp)
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	ff d0                	call   *%eax
  800357:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80035a:	ff 4d 1c             	decl   0x1c(%ebp)
  80035d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800361:	7f e6                	jg     800349 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800363:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800366:	bb 00 00 00 00       	mov    $0x0,%ebx
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800371:	53                   	push   %ebx
  800372:	51                   	push   %ecx
  800373:	52                   	push   %edx
  800374:	50                   	push   %eax
  800375:	e8 ce 15 00 00       	call   801948 <__umoddi3>
  80037a:	83 c4 10             	add    $0x10,%esp
  80037d:	05 d4 1d 80 00       	add    $0x801dd4,%eax
  800382:	8a 00                	mov    (%eax),%al
  800384:	0f be c0             	movsbl %al,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	ff 75 0c             	pushl  0xc(%ebp)
  80038d:	50                   	push   %eax
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	ff d0                	call   *%eax
  800393:	83 c4 10             	add    $0x10,%esp
}
  800396:	90                   	nop
  800397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    

0080039c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80039f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003a3:	7e 1c                	jle    8003c1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	8d 50 08             	lea    0x8(%eax),%edx
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	89 10                	mov    %edx,(%eax)
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	83 e8 08             	sub    $0x8,%eax
  8003ba:	8b 50 04             	mov    0x4(%eax),%edx
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	eb 40                	jmp    800401 <getuint+0x65>
	else if (lflag)
  8003c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003c5:	74 1e                	je     8003e5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	8d 50 04             	lea    0x4(%eax),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	89 10                	mov    %edx,(%eax)
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	83 e8 04             	sub    $0x4,%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	eb 1c                	jmp    800401 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	8d 50 04             	lea    0x4(%eax),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	89 10                	mov    %edx,(%eax)
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	83 e8 04             	sub    $0x4,%eax
  8003fa:	8b 00                	mov    (%eax),%eax
  8003fc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800401:	5d                   	pop    %ebp
  800402:	c3                   	ret    

00800403 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800406:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040a:	7e 1c                	jle    800428 <getint+0x25>
		return va_arg(*ap, long long);
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	8d 50 08             	lea    0x8(%eax),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	89 10                	mov    %edx,(%eax)
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	83 e8 08             	sub    $0x8,%eax
  800421:	8b 50 04             	mov    0x4(%eax),%edx
  800424:	8b 00                	mov    (%eax),%eax
  800426:	eb 38                	jmp    800460 <getint+0x5d>
	else if (lflag)
  800428:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042c:	74 1a                	je     800448 <getint+0x45>
		return va_arg(*ap, long);
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	8d 50 04             	lea    0x4(%eax),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	89 10                	mov    %edx,(%eax)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	83 e8 04             	sub    $0x4,%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	99                   	cltd   
  800446:	eb 18                	jmp    800460 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	8d 50 04             	lea    0x4(%eax),%edx
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	89 10                	mov    %edx,(%eax)
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	83 e8 04             	sub    $0x4,%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	99                   	cltd   
}
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	56                   	push   %esi
  800466:	53                   	push   %ebx
  800467:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80046a:	eb 17                	jmp    800483 <vprintfmt+0x21>
			if (ch == '\0')
  80046c:	85 db                	test   %ebx,%ebx
  80046e:	0f 84 c1 03 00 00    	je     800835 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	53                   	push   %ebx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	ff d0                	call   *%eax
  800480:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800483:	8b 45 10             	mov    0x10(%ebp),%eax
  800486:	8d 50 01             	lea    0x1(%eax),%edx
  800489:	89 55 10             	mov    %edx,0x10(%ebp)
  80048c:	8a 00                	mov    (%eax),%al
  80048e:	0f b6 d8             	movzbl %al,%ebx
  800491:	83 fb 25             	cmp    $0x25,%ebx
  800494:	75 d6                	jne    80046c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800496:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80049a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	8d 50 01             	lea    0x1(%eax),%edx
  8004bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004bf:	8a 00                	mov    (%eax),%al
  8004c1:	0f b6 d8             	movzbl %al,%ebx
  8004c4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004c7:	83 f8 5b             	cmp    $0x5b,%eax
  8004ca:	0f 87 3d 03 00 00    	ja     80080d <vprintfmt+0x3ab>
  8004d0:	8b 04 85 f8 1d 80 00 	mov    0x801df8(,%eax,4),%eax
  8004d7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004dd:	eb d7                	jmp    8004b6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004df:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004e3:	eb d1                	jmp    8004b6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ef:	89 d0                	mov    %edx,%eax
  8004f1:	c1 e0 02             	shl    $0x2,%eax
  8004f4:	01 d0                	add    %edx,%eax
  8004f6:	01 c0                	add    %eax,%eax
  8004f8:	01 d8                	add    %ebx,%eax
  8004fa:	83 e8 30             	sub    $0x30,%eax
  8004fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800500:	8b 45 10             	mov    0x10(%ebp),%eax
  800503:	8a 00                	mov    (%eax),%al
  800505:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800508:	83 fb 2f             	cmp    $0x2f,%ebx
  80050b:	7e 3e                	jle    80054b <vprintfmt+0xe9>
  80050d:	83 fb 39             	cmp    $0x39,%ebx
  800510:	7f 39                	jg     80054b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800512:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800515:	eb d5                	jmp    8004ec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	83 c0 04             	add    $0x4,%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	83 e8 04             	sub    $0x4,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80052b:	eb 1f                	jmp    80054c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80052d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800531:	79 83                	jns    8004b6 <vprintfmt+0x54>
				width = 0;
  800533:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80053a:	e9 77 ff ff ff       	jmp    8004b6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80053f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800546:	e9 6b ff ff ff       	jmp    8004b6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80054b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80054c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800550:	0f 89 60 ff ff ff    	jns    8004b6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800563:	e9 4e ff ff ff       	jmp    8004b6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800568:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80056b:	e9 46 ff ff ff       	jmp    8004b6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	83 c0 04             	add    $0x4,%eax
  800576:	89 45 14             	mov    %eax,0x14(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	83 e8 04             	sub    $0x4,%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	50                   	push   %eax
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	ff d0                	call   *%eax
  80058d:	83 c4 10             	add    $0x10,%esp
			break;
  800590:	e9 9b 02 00 00       	jmp    800830 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	83 c0 04             	add    $0x4,%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	83 e8 04             	sub    $0x4,%eax
  8005a4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005a6:	85 db                	test   %ebx,%ebx
  8005a8:	79 02                	jns    8005ac <vprintfmt+0x14a>
				err = -err;
  8005aa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ac:	83 fb 64             	cmp    $0x64,%ebx
  8005af:	7f 0b                	jg     8005bc <vprintfmt+0x15a>
  8005b1:	8b 34 9d 40 1c 80 00 	mov    0x801c40(,%ebx,4),%esi
  8005b8:	85 f6                	test   %esi,%esi
  8005ba:	75 19                	jne    8005d5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005bc:	53                   	push   %ebx
  8005bd:	68 e5 1d 80 00       	push   $0x801de5
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	ff 75 08             	pushl  0x8(%ebp)
  8005c8:	e8 70 02 00 00       	call   80083d <printfmt>
  8005cd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005d0:	e9 5b 02 00 00       	jmp    800830 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005d5:	56                   	push   %esi
  8005d6:	68 ee 1d 80 00       	push   $0x801dee
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	ff 75 08             	pushl  0x8(%ebp)
  8005e1:	e8 57 02 00 00       	call   80083d <printfmt>
  8005e6:	83 c4 10             	add    $0x10,%esp
			break;
  8005e9:	e9 42 02 00 00       	jmp    800830 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	83 c0 04             	add    $0x4,%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	83 e8 04             	sub    $0x4,%eax
  8005fd:	8b 30                	mov    (%eax),%esi
  8005ff:	85 f6                	test   %esi,%esi
  800601:	75 05                	jne    800608 <vprintfmt+0x1a6>
				p = "(null)";
  800603:	be f1 1d 80 00       	mov    $0x801df1,%esi
			if (width > 0 && padc != '-')
  800608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060c:	7e 6d                	jle    80067b <vprintfmt+0x219>
  80060e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800612:	74 67                	je     80067b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	56                   	push   %esi
  80061c:	e8 1e 03 00 00       	call   80093f <strnlen>
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800627:	eb 16                	jmp    80063f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800629:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	ff 75 0c             	pushl  0xc(%ebp)
  800633:	50                   	push   %eax
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80063c:	ff 4d e4             	decl   -0x1c(%ebp)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	7f e4                	jg     800629 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800645:	eb 34                	jmp    80067b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800647:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80064b:	74 1c                	je     800669 <vprintfmt+0x207>
  80064d:	83 fb 1f             	cmp    $0x1f,%ebx
  800650:	7e 05                	jle    800657 <vprintfmt+0x1f5>
  800652:	83 fb 7e             	cmp    $0x7e,%ebx
  800655:	7e 12                	jle    800669 <vprintfmt+0x207>
					putch('?', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	6a 3f                	push   $0x3f
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	ff d0                	call   *%eax
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	eb 0f                	jmp    800678 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	53                   	push   %ebx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800678:	ff 4d e4             	decl   -0x1c(%ebp)
  80067b:	89 f0                	mov    %esi,%eax
  80067d:	8d 70 01             	lea    0x1(%eax),%esi
  800680:	8a 00                	mov    (%eax),%al
  800682:	0f be d8             	movsbl %al,%ebx
  800685:	85 db                	test   %ebx,%ebx
  800687:	74 24                	je     8006ad <vprintfmt+0x24b>
  800689:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068d:	78 b8                	js     800647 <vprintfmt+0x1e5>
  80068f:	ff 4d e0             	decl   -0x20(%ebp)
  800692:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800696:	79 af                	jns    800647 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800698:	eb 13                	jmp    8006ad <vprintfmt+0x24b>
				putch(' ', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 0c             	pushl  0xc(%ebp)
  8006a0:	6a 20                	push   $0x20
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	ff d0                	call   *%eax
  8006a7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b1:	7f e7                	jg     80069a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006b3:	e9 78 01 00 00       	jmp    800830 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006be:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c1:	50                   	push   %eax
  8006c2:	e8 3c fd ff ff       	call   800403 <getint>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d6:	85 d2                	test   %edx,%edx
  8006d8:	79 23                	jns    8006fd <vprintfmt+0x29b>
				putch('-', putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	6a 2d                	push   $0x2d
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f0:	f7 d8                	neg    %eax
  8006f2:	83 d2 00             	adc    $0x0,%edx
  8006f5:	f7 da                	neg    %edx
  8006f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800704:	e9 bc 00 00 00       	jmp    8007c5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 e8             	pushl  -0x18(%ebp)
  80070f:	8d 45 14             	lea    0x14(%ebp),%eax
  800712:	50                   	push   %eax
  800713:	e8 84 fc ff ff       	call   80039c <getuint>
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800721:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800728:	e9 98 00 00 00       	jmp    8007c5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	6a 58                	push   $0x58
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	ff d0                	call   *%eax
  80073a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 58                	push   $0x58
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	6a 58                	push   $0x58
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	ff d0                	call   *%eax
  80075a:	83 c4 10             	add    $0x10,%esp
			break;
  80075d:	e9 ce 00 00 00       	jmp    800830 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	6a 30                	push   $0x30
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 78                	push   $0x78
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	83 c0 04             	add    $0x4,%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	83 e8 04             	sub    $0x4,%eax
  800791:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80079d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007a4:	eb 1f                	jmp    8007c5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8007af:	50                   	push   %eax
  8007b0:	e8 e7 fb ff ff       	call   80039c <getuint>
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	52                   	push   %edx
  8007d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	ff 75 08             	pushl  0x8(%ebp)
  8007e0:	e8 00 fb ff ff       	call   8002e5 <printnum>
  8007e5:	83 c4 20             	add    $0x20,%esp
			break;
  8007e8:	eb 46                	jmp    800830 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	53                   	push   %ebx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			break;
  8007f9:	eb 35                	jmp    800830 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007fb:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800802:	eb 2c                	jmp    800830 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800804:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80080b:	eb 23                	jmp    800830 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 25                	push   $0x25
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081d:	ff 4d 10             	decl   0x10(%ebp)
  800820:	eb 03                	jmp    800825 <vprintfmt+0x3c3>
  800822:	ff 4d 10             	decl   0x10(%ebp)
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	48                   	dec    %eax
  800829:	8a 00                	mov    (%eax),%al
  80082b:	3c 25                	cmp    $0x25,%al
  80082d:	75 f3                	jne    800822 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80082f:	90                   	nop
		}
	}
  800830:	e9 35 fc ff ff       	jmp    80046a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800835:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800836:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800839:	5b                   	pop    %ebx
  80083a:	5e                   	pop    %esi
  80083b:	5d                   	pop    %ebp
  80083c:	c3                   	ret    

0080083d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800843:	8d 45 10             	lea    0x10(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	ff 75 f4             	pushl  -0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	ff 75 08             	pushl  0x8(%ebp)
  800859:	e8 04 fc ff ff       	call   800462 <vprintfmt>
  80085e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800861:	90                   	nop
  800862:	c9                   	leave  
  800863:	c3                   	ret    

00800864 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086a:	8b 40 08             	mov    0x8(%eax),%eax
  80086d:	8d 50 01             	lea    0x1(%eax),%edx
  800870:	8b 45 0c             	mov    0xc(%ebp),%eax
  800873:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800876:	8b 45 0c             	mov    0xc(%ebp),%eax
  800879:	8b 10                	mov    (%eax),%edx
  80087b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087e:	8b 40 04             	mov    0x4(%eax),%eax
  800881:	39 c2                	cmp    %eax,%edx
  800883:	73 12                	jae    800897 <sprintputch+0x33>
		*b->buf++ = ch;
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	8d 48 01             	lea    0x1(%eax),%ecx
  80088d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800890:	89 0a                	mov    %ecx,(%edx)
  800892:	8b 55 08             	mov    0x8(%ebp),%edx
  800895:	88 10                	mov    %dl,(%eax)
}
  800897:	90                   	nop
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	01 d0                	add    %edx,%eax
  8008b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008bf:	74 06                	je     8008c7 <vsnprintf+0x2d>
  8008c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c5:	7f 07                	jg     8008ce <vsnprintf+0x34>
		return -E_INVAL;
  8008c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8008cc:	eb 20                	jmp    8008ee <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ce:	ff 75 14             	pushl  0x14(%ebp)
  8008d1:	ff 75 10             	pushl  0x10(%ebp)
  8008d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	68 64 08 80 00       	push   $0x800864
  8008dd:	e8 80 fb ff ff       	call   800462 <vprintfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800902:	ff 75 f4             	pushl  -0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	e8 89 ff ff ff       	call   80089a <vsnprintf>
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800917:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800929:	eb 06                	jmp    800931 <strlen+0x15>
		n++;
  80092b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80092e:	ff 45 08             	incl   0x8(%ebp)
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8a 00                	mov    (%eax),%al
  800936:	84 c0                	test   %al,%al
  800938:	75 f1                	jne    80092b <strlen+0xf>
		n++;
	return n;
  80093a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    

0080093f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800945:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80094c:	eb 09                	jmp    800957 <strnlen+0x18>
		n++;
  80094e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800951:	ff 45 08             	incl   0x8(%ebp)
  800954:	ff 4d 0c             	decl   0xc(%ebp)
  800957:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095b:	74 09                	je     800966 <strnlen+0x27>
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8a 00                	mov    (%eax),%al
  800962:	84 c0                	test   %al,%al
  800964:	75 e8                	jne    80094e <strnlen+0xf>
		n++;
	return n;
  800966:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800977:	90                   	nop
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	89 55 08             	mov    %edx,0x8(%ebp)
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
  800984:	8d 4a 01             	lea    0x1(%edx),%ecx
  800987:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80098a:	8a 12                	mov    (%edx),%dl
  80098c:	88 10                	mov    %dl,(%eax)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	84 c0                	test   %al,%al
  800992:	75 e4                	jne    800978 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800994:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ac:	eb 1f                	jmp    8009cd <strncpy+0x34>
		*dst++ = *src;
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8d 50 01             	lea    0x1(%eax),%edx
  8009b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8a 12                	mov    (%edx),%dl
  8009bc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	84 c0                	test   %al,%al
  8009c5:	74 03                	je     8009ca <strncpy+0x31>
			src++;
  8009c7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ca:	ff 45 fc             	incl   -0x4(%ebp)
  8009cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009d0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009d3:	72 d9                	jb     8009ae <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ea:	74 30                	je     800a1c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ec:	eb 16                	jmp    800a04 <strlcpy+0x2a>
			*dst++ = *src++;
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8d 50 01             	lea    0x1(%eax),%edx
  8009f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a00:	8a 12                	mov    (%edx),%dl
  800a02:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a04:	ff 4d 10             	decl   0x10(%ebp)
  800a07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a0b:	74 09                	je     800a16 <strlcpy+0x3c>
  800a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a10:	8a 00                	mov    (%eax),%al
  800a12:	84 c0                	test   %al,%al
  800a14:	75 d8                	jne    8009ee <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a22:	29 c2                	sub    %eax,%edx
  800a24:	89 d0                	mov    %edx,%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a2b:	eb 06                	jmp    800a33 <strcmp+0xb>
		p++, q++;
  800a2d:	ff 45 08             	incl   0x8(%ebp)
  800a30:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	84 c0                	test   %al,%al
  800a3a:	74 0e                	je     800a4a <strcmp+0x22>
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8a 10                	mov    (%eax),%dl
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8a 00                	mov    (%eax),%al
  800a46:	38 c2                	cmp    %al,%dl
  800a48:	74 e3                	je     800a2d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8a 00                	mov    (%eax),%al
  800a4f:	0f b6 d0             	movzbl %al,%edx
  800a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a55:	8a 00                	mov    (%eax),%al
  800a57:	0f b6 c0             	movzbl %al,%eax
  800a5a:	29 c2                	sub    %eax,%edx
  800a5c:	89 d0                	mov    %edx,%eax
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a63:	eb 09                	jmp    800a6e <strncmp+0xe>
		n--, p++, q++;
  800a65:	ff 4d 10             	decl   0x10(%ebp)
  800a68:	ff 45 08             	incl   0x8(%ebp)
  800a6b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a72:	74 17                	je     800a8b <strncmp+0x2b>
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	84 c0                	test   %al,%al
  800a7b:	74 0e                	je     800a8b <strncmp+0x2b>
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8a 10                	mov    (%eax),%dl
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	38 c2                	cmp    %al,%dl
  800a89:	74 da                	je     800a65 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8f:	75 07                	jne    800a98 <strncmp+0x38>
		return 0;
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	eb 14                	jmp    800aac <strncmp+0x4c>
	else
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

00800aae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aba:	eb 12                	jmp    800ace <strchr+0x20>
		if (*s == c)
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac4:	75 05                	jne    800acb <strchr+0x1d>
			return (char *) s;
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	eb 11                	jmp    800adc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800acb:	ff 45 08             	incl   0x8(%ebp)
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	84 c0                	test   %al,%al
  800ad5:	75 e5                	jne    800abc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aea:	eb 0d                	jmp    800af9 <strfind+0x1b>
		if (*s == c)
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af4:	74 0e                	je     800b04 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800af6:	ff 45 08             	incl   0x8(%ebp)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	84 c0                	test   %al,%al
  800b00:	75 ea                	jne    800aec <strfind+0xe>
  800b02:	eb 01                	jmp    800b05 <strfind+0x27>
		if (*s == c)
			break;
  800b04:	90                   	nop
	return (char *) s;
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
  800b19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b1c:	eb 0e                	jmp    800b2c <memset+0x22>
		*p++ = c;
  800b1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b21:	8d 50 01             	lea    0x1(%eax),%edx
  800b24:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b2c:	ff 4d f8             	decl   -0x8(%ebp)
  800b2f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b33:	79 e9                	jns    800b1e <memset+0x14>
		*p++ = c;

	return v;
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b4c:	eb 16                	jmp    800b64 <memcpy+0x2a>
		*d++ = *s++;
  800b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b51:	8d 50 01             	lea    0x1(%eax),%edx
  800b54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b60:	8a 12                	mov    (%edx),%dl
  800b62:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b64:	8b 45 10             	mov    0x10(%ebp),%eax
  800b67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	75 dd                	jne    800b4e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b74:	c9                   	leave  
  800b75:	c3                   	ret    

00800b76 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8e:	73 50                	jae    800be0 <memmove+0x6a>
  800b90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b93:	8b 45 10             	mov    0x10(%ebp),%eax
  800b96:	01 d0                	add    %edx,%eax
  800b98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b9b:	76 43                	jbe    800be0 <memmove+0x6a>
		s += n;
  800b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ba9:	eb 10                	jmp    800bbb <memmove+0x45>
			*--d = *--s;
  800bab:	ff 4d f8             	decl   -0x8(%ebp)
  800bae:	ff 4d fc             	decl   -0x4(%ebp)
  800bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb4:	8a 10                	mov    (%eax),%dl
  800bb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc4:	85 c0                	test   %eax,%eax
  800bc6:	75 e3                	jne    800bab <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc8:	eb 23                	jmp    800bed <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bcd:	8d 50 01             	lea    0x1(%eax),%edx
  800bd0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bdc:	8a 12                	mov    (%edx),%dl
  800bde:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be6:	89 55 10             	mov    %edx,0x10(%ebp)
  800be9:	85 c0                	test   %eax,%eax
  800beb:	75 dd                	jne    800bca <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    

00800bf2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c04:	eb 2a                	jmp    800c30 <memcmp+0x3e>
		if (*s1 != *s2)
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c09:	8a 10                	mov    (%eax),%dl
  800c0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	38 c2                	cmp    %al,%dl
  800c12:	74 16                	je     800c2a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	0f b6 d0             	movzbl %al,%edx
  800c1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	0f b6 c0             	movzbl %al,%eax
  800c24:	29 c2                	sub    %eax,%edx
  800c26:	89 d0                	mov    %edx,%eax
  800c28:	eb 18                	jmp    800c42 <memcmp+0x50>
		s1++, s2++;
  800c2a:	ff 45 fc             	incl   -0x4(%ebp)
  800c2d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c36:	89 55 10             	mov    %edx,0x10(%ebp)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	75 c9                	jne    800c06 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c50:	01 d0                	add    %edx,%eax
  800c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c55:	eb 15                	jmp    800c6c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	0f b6 d0             	movzbl %al,%edx
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	0f b6 c0             	movzbl %al,%eax
  800c65:	39 c2                	cmp    %eax,%edx
  800c67:	74 0d                	je     800c76 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c72:	72 e3                	jb     800c57 <memfind+0x13>
  800c74:	eb 01                	jmp    800c77 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c76:	90                   	nop
	return (void *) s;
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c90:	eb 03                	jmp    800c95 <strtol+0x19>
		s++;
  800c92:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	3c 20                	cmp    $0x20,%al
  800c9c:	74 f4                	je     800c92 <strtol+0x16>
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	3c 09                	cmp    $0x9,%al
  800ca5:	74 eb                	je     800c92 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	3c 2b                	cmp    $0x2b,%al
  800cae:	75 05                	jne    800cb5 <strtol+0x39>
		s++;
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	eb 13                	jmp    800cc8 <strtol+0x4c>
	else if (*s == '-')
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 2d                	cmp    $0x2d,%al
  800cbc:	75 0a                	jne    800cc8 <strtol+0x4c>
		s++, neg = 1;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	74 06                	je     800cd4 <strtol+0x58>
  800cce:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cd2:	75 20                	jne    800cf4 <strtol+0x78>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3c 30                	cmp    $0x30,%al
  800cdb:	75 17                	jne    800cf4 <strtol+0x78>
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	40                   	inc    %eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	3c 78                	cmp    $0x78,%al
  800ce5:	75 0d                	jne    800cf4 <strtol+0x78>
		s += 2, base = 16;
  800ce7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ceb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cf2:	eb 28                	jmp    800d1c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	75 15                	jne    800d0f <strtol+0x93>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	3c 30                	cmp    $0x30,%al
  800d01:	75 0c                	jne    800d0f <strtol+0x93>
		s++, base = 8;
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d0d:	eb 0d                	jmp    800d1c <strtol+0xa0>
	else if (base == 0)
  800d0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d13:	75 07                	jne    800d1c <strtol+0xa0>
		base = 10;
  800d15:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	3c 2f                	cmp    $0x2f,%al
  800d23:	7e 19                	jle    800d3e <strtol+0xc2>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 39                	cmp    $0x39,%al
  800d2c:	7f 10                	jg     800d3e <strtol+0xc2>
			dig = *s - '0';
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f be c0             	movsbl %al,%eax
  800d36:	83 e8 30             	sub    $0x30,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3c:	eb 42                	jmp    800d80 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 60                	cmp    $0x60,%al
  800d45:	7e 19                	jle    800d60 <strtol+0xe4>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3c 7a                	cmp    $0x7a,%al
  800d4e:	7f 10                	jg     800d60 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	0f be c0             	movsbl %al,%eax
  800d58:	83 e8 57             	sub    $0x57,%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d5e:	eb 20                	jmp    800d80 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3c 40                	cmp    $0x40,%al
  800d67:	7e 39                	jle    800da2 <strtol+0x126>
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 5a                	cmp    $0x5a,%al
  800d70:	7f 30                	jg     800da2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	0f be c0             	movsbl %al,%eax
  800d7a:	83 e8 37             	sub    $0x37,%eax
  800d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d86:	7d 19                	jge    800da1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d92:	89 c2                	mov    %eax,%edx
  800d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d9c:	e9 7b ff ff ff       	jmp    800d1c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800da1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800da2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da6:	74 08                	je     800db0 <strtol+0x134>
		*endptr = (char *) s;
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800db0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800db4:	74 07                	je     800dbd <strtol+0x141>
  800db6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db9:	f7 d8                	neg    %eax
  800dbb:	eb 03                	jmp    800dc0 <strtol+0x144>
  800dbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <ltostr>:

void
ltostr(long value, char *str)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	79 13                	jns    800def <ltostr+0x2d>
	{
		neg = 1;
  800ddc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800de9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dec:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800df7:	99                   	cltd   
  800df8:	f7 f9                	idiv   %ecx
  800dfa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e06:	89 c2                	mov    %eax,%edx
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e10:	83 c2 30             	add    $0x30,%edx
  800e13:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e18:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e1d:	f7 e9                	imul   %ecx
  800e1f:	c1 fa 02             	sar    $0x2,%edx
  800e22:	89 c8                	mov    %ecx,%eax
  800e24:	c1 f8 1f             	sar    $0x1f,%eax
  800e27:	29 c2                	sub    %eax,%edx
  800e29:	89 d0                	mov    %edx,%eax
  800e2b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e32:	75 bb                	jne    800def <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3e:	48                   	dec    %eax
  800e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e46:	74 3d                	je     800e85 <ltostr+0xc3>
		start = 1 ;
  800e48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e4f:	eb 34                	jmp    800e85 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	01 d0                	add    %edx,%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	01 c2                	add    %eax,%edx
  800e66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	01 c8                	add    %ecx,%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	01 c2                	add    %eax,%edx
  800e7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800e7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e8b:	7c c4                	jl     800e51 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	01 d0                	add    %edx,%eax
  800e95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e98:	90                   	nop
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ea1:	ff 75 08             	pushl  0x8(%ebp)
  800ea4:	e8 73 fa ff ff       	call   80091c <strlen>
  800ea9:	83 c4 04             	add    $0x4,%esp
  800eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	e8 65 fa ff ff       	call   80091c <strlen>
  800eb7:	83 c4 04             	add    $0x4,%esp
  800eba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ebd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ec4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecb:	eb 17                	jmp    800ee4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ecd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed3:	01 c2                	add    %eax,%edx
  800ed5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	01 c8                	add    %ecx,%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ee1:	ff 45 fc             	incl   -0x4(%ebp)
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800eea:	7c e1                	jl     800ecd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800eec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ef3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800efa:	eb 1f                	jmp    800f1b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8d 50 01             	lea    0x1(%eax),%edx
  800f02:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	01 c2                	add    %eax,%edx
  800f0c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	01 c8                	add    %ecx,%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f21:	7c d9                	jl     800efc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f26:	8b 45 10             	mov    0x10(%ebp),%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	c6 00 00             	movb   $0x0,(%eax)
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f49:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4c:	01 d0                	add    %edx,%eax
  800f4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f54:	eb 0c                	jmp    800f62 <strsplit+0x31>
			*string++ = 0;
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8d 50 01             	lea    0x1(%eax),%edx
  800f5c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	74 18                	je     800f83 <strsplit+0x52>
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f be c0             	movsbl %al,%eax
  800f73:	50                   	push   %eax
  800f74:	ff 75 0c             	pushl  0xc(%ebp)
  800f77:	e8 32 fb ff ff       	call   800aae <strchr>
  800f7c:	83 c4 08             	add    $0x8,%esp
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	75 d3                	jne    800f56 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	84 c0                	test   %al,%al
  800f8a:	74 5a                	je     800fe6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8f:	8b 00                	mov    (%eax),%eax
  800f91:	83 f8 0f             	cmp    $0xf,%eax
  800f94:	75 07                	jne    800f9d <strsplit+0x6c>
		{
			return 0;
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	eb 66                	jmp    801003 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa0:	8b 00                	mov    (%eax),%eax
  800fa2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fa5:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa8:	89 0a                	mov    %ecx,(%edx)
  800faa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 c2                	add    %eax,%edx
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fbb:	eb 03                	jmp    800fc0 <strsplit+0x8f>
			string++;
  800fbd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 8b                	je     800f54 <strsplit+0x23>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f be c0             	movsbl %al,%eax
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 0c             	pushl  0xc(%ebp)
  800fd5:	e8 d4 fa ff ff       	call   800aae <strchr>
  800fda:	83 c4 08             	add    $0x8,%esp
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	74 dc                	je     800fbd <strsplit+0x8c>
			string++;
	}
  800fe1:	e9 6e ff ff ff       	jmp    800f54 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fe6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fe7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fea:	8b 00                	mov    (%eax),%eax
  800fec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ffe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	68 68 1f 80 00       	push   $0x801f68
  801013:	68 3f 01 00 00       	push   $0x13f
  801018:	68 8a 1f 80 00       	push   $0x801f8a
  80101d:	e8 2d 06 00 00       	call   80164f <_panic>

00801022 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801031:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801034:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801037:	8b 7d 18             	mov    0x18(%ebp),%edi
  80103a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80103d:	cd 30                	int    $0x30
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801042:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	8b 45 10             	mov    0x10(%ebp),%eax
  801056:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801059:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	6a 00                	push   $0x0
  801062:	6a 00                	push   $0x0
  801064:	52                   	push   %edx
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	6a 00                	push   $0x0
  80106b:	e8 b2 ff ff ff       	call   801022 <syscall>
  801070:	83 c4 18             	add    $0x18,%esp
}
  801073:	90                   	nop
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <sys_cgetc>:

int
sys_cgetc(void)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801079:	6a 00                	push   $0x0
  80107b:	6a 00                	push   $0x0
  80107d:	6a 00                	push   $0x0
  80107f:	6a 00                	push   $0x0
  801081:	6a 00                	push   $0x0
  801083:	6a 02                	push   $0x2
  801085:	e8 98 ff ff ff       	call   801022 <syscall>
  80108a:	83 c4 18             	add    $0x18,%esp
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801092:	6a 00                	push   $0x0
  801094:	6a 00                	push   $0x0
  801096:	6a 00                	push   $0x0
  801098:	6a 00                	push   $0x0
  80109a:	6a 00                	push   $0x0
  80109c:	6a 03                	push   $0x3
  80109e:	e8 7f ff ff ff       	call   801022 <syscall>
  8010a3:	83 c4 18             	add    $0x18,%esp
}
  8010a6:	90                   	nop
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010ac:	6a 00                	push   $0x0
  8010ae:	6a 00                	push   $0x0
  8010b0:	6a 00                	push   $0x0
  8010b2:	6a 00                	push   $0x0
  8010b4:	6a 00                	push   $0x0
  8010b6:	6a 04                	push   $0x4
  8010b8:	e8 65 ff ff ff       	call   801022 <syscall>
  8010bd:	83 c4 18             	add    $0x18,%esp
}
  8010c0:	90                   	nop
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 00                	push   $0x0
  8010d2:	52                   	push   %edx
  8010d3:	50                   	push   %eax
  8010d4:	6a 08                	push   $0x8
  8010d6:	e8 47 ff ff ff       	call   801022 <syscall>
  8010db:	83 c4 18             	add    $0x18,%esp
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010e5:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	51                   	push   %ecx
  8010f7:	52                   	push   %edx
  8010f8:	50                   	push   %eax
  8010f9:	6a 09                	push   $0x9
  8010fb:	e8 22 ff ff ff       	call   801022 <syscall>
  801100:	83 c4 18             	add    $0x18,%esp
}
  801103:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80110d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	52                   	push   %edx
  80111a:	50                   	push   %eax
  80111b:	6a 0a                	push   $0xa
  80111d:	e8 00 ff ff ff       	call   801022 <syscall>
  801122:	83 c4 18             	add    $0x18,%esp
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	6a 00                	push   $0x0
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	ff 75 08             	pushl  0x8(%ebp)
  801136:	6a 0b                	push   $0xb
  801138:	e8 e5 fe ff ff       	call   801022 <syscall>
  80113d:	83 c4 18             	add    $0x18,%esp
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 0c                	push   $0xc
  801151:	e8 cc fe ff ff       	call   801022 <syscall>
  801156:	83 c4 18             	add    $0x18,%esp
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 0d                	push   $0xd
  80116a:	e8 b3 fe ff ff       	call   801022 <syscall>
  80116f:	83 c4 18             	add    $0x18,%esp
}
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 0e                	push   $0xe
  801183:	e8 9a fe ff ff       	call   801022 <syscall>
  801188:	83 c4 18             	add    $0x18,%esp
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 0f                	push   $0xf
  80119c:	e8 81 fe ff ff       	call   801022 <syscall>
  8011a1:	83 c4 18             	add    $0x18,%esp
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	ff 75 08             	pushl  0x8(%ebp)
  8011b4:	6a 10                	push   $0x10
  8011b6:	e8 67 fe ff ff       	call   801022 <syscall>
  8011bb:	83 c4 18             	add    $0x18,%esp
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 11                	push   $0x11
  8011cf:	e8 4e fe ff ff       	call   801022 <syscall>
  8011d4:	83 c4 18             	add    $0x18,%esp
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <sys_cputc>:

void
sys_cputc(const char c)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	50                   	push   %eax
  8011f3:	6a 01                	push   $0x1
  8011f5:	e8 28 fe ff ff       	call   801022 <syscall>
  8011fa:	83 c4 18             	add    $0x18,%esp
}
  8011fd:	90                   	nop
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 14                	push   $0x14
  80120f:	e8 0e fe ff ff       	call   801022 <syscall>
  801214:	83 c4 18             	add    $0x18,%esp
}
  801217:	90                   	nop
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	8b 45 10             	mov    0x10(%ebp),%eax
  801223:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801226:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801229:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	6a 00                	push   $0x0
  801232:	51                   	push   %ecx
  801233:	52                   	push   %edx
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	50                   	push   %eax
  801238:	6a 15                	push   $0x15
  80123a:	e8 e3 fd ff ff       	call   801022 <syscall>
  80123f:	83 c4 18             	add    $0x18,%esp
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	52                   	push   %edx
  801254:	50                   	push   %eax
  801255:	6a 16                	push   $0x16
  801257:	e8 c6 fd ff ff       	call   801022 <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801264:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	51                   	push   %ecx
  801272:	52                   	push   %edx
  801273:	50                   	push   %eax
  801274:	6a 17                	push   $0x17
  801276:	e8 a7 fd ff ff       	call   801022 <syscall>
  80127b:	83 c4 18             	add    $0x18,%esp
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801283:	8b 55 0c             	mov    0xc(%ebp),%edx
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	6a 00                	push   $0x0
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	52                   	push   %edx
  801290:	50                   	push   %eax
  801291:	6a 18                	push   $0x18
  801293:	e8 8a fd ff ff       	call   801022 <syscall>
  801298:	83 c4 18             	add    $0x18,%esp
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	ff 75 14             	pushl  0x14(%ebp)
  8012a8:	ff 75 10             	pushl  0x10(%ebp)
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	50                   	push   %eax
  8012af:	6a 19                	push   $0x19
  8012b1:	e8 6c fd ff ff       	call   801022 <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	50                   	push   %eax
  8012ca:	6a 1a                	push   $0x1a
  8012cc:	e8 51 fd ff ff       	call   801022 <syscall>
  8012d1:	83 c4 18             	add    $0x18,%esp
}
  8012d4:	90                   	nop
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	50                   	push   %eax
  8012e6:	6a 1b                	push   $0x1b
  8012e8:	e8 35 fd ff ff       	call   801022 <syscall>
  8012ed:	83 c4 18             	add    $0x18,%esp
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 05                	push   $0x5
  801301:	e8 1c fd ff ff       	call   801022 <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 06                	push   $0x6
  80131a:	e8 03 fd ff ff       	call   801022 <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 07                	push   $0x7
  801333:	e8 ea fc ff ff       	call   801022 <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_exit_env>:


void sys_exit_env(void)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 1c                	push   $0x1c
  80134c:	e8 d1 fc ff ff       	call   801022 <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	90                   	nop
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80135d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	52                   	push   %edx
  80136d:	50                   	push   %eax
  80136e:	6a 1d                	push   $0x1d
  801370:	e8 ad fc ff ff       	call   801022 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
	return result;
  801378:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801381:	89 01                	mov    %eax,(%ecx)
  801383:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	c9                   	leave  
  80138a:	c2 04 00             	ret    $0x4

0080138d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	ff 75 10             	pushl  0x10(%ebp)
  801397:	ff 75 0c             	pushl  0xc(%ebp)
  80139a:	ff 75 08             	pushl  0x8(%ebp)
  80139d:	6a 13                	push   $0x13
  80139f:	e8 7e fc ff ff       	call   801022 <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8013a7:	90                   	nop
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_rcr2>:
uint32 sys_rcr2()
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 1e                	push   $0x1e
  8013b9:	e8 64 fc ff ff       	call   801022 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013cf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	50                   	push   %eax
  8013dc:	6a 1f                	push   $0x1f
  8013de:	e8 3f fc ff ff       	call   801022 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8013e6:	90                   	nop
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <rsttst>:
void rsttst()
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 21                	push   $0x21
  8013f8:	e8 25 fc ff ff       	call   801022 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801400:	90                   	nop
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80140f:	8b 55 18             	mov    0x18(%ebp),%edx
  801412:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801416:	52                   	push   %edx
  801417:	50                   	push   %eax
  801418:	ff 75 10             	pushl  0x10(%ebp)
  80141b:	ff 75 0c             	pushl  0xc(%ebp)
  80141e:	ff 75 08             	pushl  0x8(%ebp)
  801421:	6a 20                	push   $0x20
  801423:	e8 fa fb ff ff       	call   801022 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
	return ;
  80142b:	90                   	nop
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <chktst>:
void chktst(uint32 n)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	ff 75 08             	pushl  0x8(%ebp)
  80143c:	6a 22                	push   $0x22
  80143e:	e8 df fb ff ff       	call   801022 <syscall>
  801443:	83 c4 18             	add    $0x18,%esp
	return ;
  801446:	90                   	nop
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <inctst>:

void inctst()
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 23                	push   $0x23
  801458:	e8 c5 fb ff ff       	call   801022 <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
	return ;
  801460:	90                   	nop
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <gettst>:
uint32 gettst()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 24                	push   $0x24
  801472:	e8 ab fb ff ff       	call   801022 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 25                	push   $0x25
  80148e:	e8 8f fb ff ff       	call   801022 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
  801496:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801499:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80149d:	75 07                	jne    8014a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80149f:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a4:	eb 05                	jmp    8014ab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 25                	push   $0x25
  8014bf:	e8 5e fb ff ff       	call   801022 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
  8014c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014ca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014ce:	75 07                	jne    8014d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d5:	eb 05                	jmp    8014dc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 25                	push   $0x25
  8014f0:	e8 2d fb ff ff       	call   801022 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
  8014f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014fb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014ff:	75 07                	jne    801508 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801501:	b8 01 00 00 00       	mov    $0x1,%eax
  801506:	eb 05                	jmp    80150d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 25                	push   $0x25
  801521:	e8 fc fa ff ff       	call   801022 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
  801529:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80152c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801530:	75 07                	jne    801539 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801532:	b8 01 00 00 00       	mov    $0x1,%eax
  801537:	eb 05                	jmp    80153e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	ff 75 08             	pushl  0x8(%ebp)
  80154e:	6a 26                	push   $0x26
  801550:	e8 cd fa ff ff       	call   801022 <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
	return ;
  801558:	90                   	nop
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80155f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801562:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801565:	8b 55 0c             	mov    0xc(%ebp),%edx
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	53                   	push   %ebx
  80156e:	51                   	push   %ecx
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	6a 27                	push   $0x27
  801573:	e8 aa fa ff ff       	call   801022 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801583:	8b 55 0c             	mov    0xc(%ebp),%edx
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	52                   	push   %edx
  801590:	50                   	push   %eax
  801591:	6a 28                	push   $0x28
  801593:	e8 8a fa ff ff       	call   801022 <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	51                   	push   %ecx
  8015ac:	ff 75 10             	pushl  0x10(%ebp)
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 29                	push   $0x29
  8015b3:	e8 6a fa ff ff       	call   801022 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	ff 75 10             	pushl  0x10(%ebp)
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	6a 12                	push   $0x12
  8015cf:	e8 4e fa ff ff       	call   801022 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d7:	90                   	nop
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	52                   	push   %edx
  8015ea:	50                   	push   %eax
  8015eb:	6a 2a                	push   $0x2a
  8015ed:	e8 30 fa ff ff       	call   801022 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
	return;
  8015f5:	90                   	nop
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 97 1f 80 00       	push   $0x801f97
  801606:	68 2e 01 00 00       	push   $0x12e
  80160b:	68 ab 1f 80 00       	push   $0x801fab
  801610:	e8 3a 00 00 00       	call   80164f <_panic>

00801615 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 97 1f 80 00       	push   $0x801f97
  801623:	68 35 01 00 00       	push   $0x135
  801628:	68 ab 1f 80 00       	push   $0x801fab
  80162d:	e8 1d 00 00 00       	call   80164f <_panic>

00801632 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	68 97 1f 80 00       	push   $0x801f97
  801640:	68 3b 01 00 00       	push   $0x13b
  801645:	68 ab 1f 80 00       	push   $0x801fab
  80164a:	e8 00 00 00 00       	call   80164f <_panic>

0080164f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801655:	8d 45 10             	lea    0x10(%ebp),%eax
  801658:	83 c0 04             	add    $0x4,%eax
  80165b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80165e:	a1 24 30 80 00       	mov    0x803024,%eax
  801663:	85 c0                	test   %eax,%eax
  801665:	74 16                	je     80167d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801667:	a1 24 30 80 00       	mov    0x803024,%eax
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	50                   	push   %eax
  801670:	68 bc 1f 80 00       	push   $0x801fbc
  801675:	e8 0e ec ff ff       	call   800288 <cprintf>
  80167a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80167d:	a1 00 30 80 00       	mov    0x803000,%eax
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	ff 75 08             	pushl  0x8(%ebp)
  801688:	50                   	push   %eax
  801689:	68 c1 1f 80 00       	push   $0x801fc1
  80168e:	e8 f5 eb ff ff       	call   800288 <cprintf>
  801693:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801696:	8b 45 10             	mov    0x10(%ebp),%eax
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 f4             	pushl  -0xc(%ebp)
  80169f:	50                   	push   %eax
  8016a0:	e8 78 eb ff ff       	call   80021d <vcprintf>
  8016a5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016a8:	83 ec 08             	sub    $0x8,%esp
  8016ab:	6a 00                	push   $0x0
  8016ad:	68 dd 1f 80 00       	push   $0x801fdd
  8016b2:	e8 66 eb ff ff       	call   80021d <vcprintf>
  8016b7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016ba:	e8 e7 ea ff ff       	call   8001a6 <exit>

	// should not return here
	while (1) ;
  8016bf:	eb fe                	jmp    8016bf <_panic+0x70>

008016c1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8016cc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d5:	39 c2                	cmp    %eax,%edx
  8016d7:	74 14                	je     8016ed <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 e0 1f 80 00       	push   $0x801fe0
  8016e1:	6a 26                	push   $0x26
  8016e3:	68 2c 20 80 00       	push   $0x80202c
  8016e8:	e8 62 ff ff ff       	call   80164f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016fb:	e9 c5 00 00 00       	jmp    8017c5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	8b 00                	mov    (%eax),%eax
  801711:	85 c0                	test   %eax,%eax
  801713:	75 08                	jne    80171d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801715:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801718:	e9 a5 00 00 00       	jmp    8017c2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80171d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801724:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80172b:	eb 69                	jmp    801796 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80172d:	a1 04 30 80 00       	mov    0x803004,%eax
  801732:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801738:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80173b:	89 d0                	mov    %edx,%eax
  80173d:	01 c0                	add    %eax,%eax
  80173f:	01 d0                	add    %edx,%eax
  801741:	c1 e0 03             	shl    $0x3,%eax
  801744:	01 c8                	add    %ecx,%eax
  801746:	8a 40 04             	mov    0x4(%eax),%al
  801749:	84 c0                	test   %al,%al
  80174b:	75 46                	jne    801793 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80174d:	a1 04 30 80 00       	mov    0x803004,%eax
  801752:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801758:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80175b:	89 d0                	mov    %edx,%eax
  80175d:	01 c0                	add    %eax,%eax
  80175f:	01 d0                	add    %edx,%eax
  801761:	c1 e0 03             	shl    $0x3,%eax
  801764:	01 c8                	add    %ecx,%eax
  801766:	8b 00                	mov    (%eax),%eax
  801768:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80176b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80176e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801773:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	01 c8                	add    %ecx,%eax
  801784:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801786:	39 c2                	cmp    %eax,%edx
  801788:	75 09                	jne    801793 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80178a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801791:	eb 15                	jmp    8017a8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801793:	ff 45 e8             	incl   -0x18(%ebp)
  801796:	a1 04 30 80 00       	mov    0x803004,%eax
  80179b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a4:	39 c2                	cmp    %eax,%edx
  8017a6:	77 85                	ja     80172d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ac:	75 14                	jne    8017c2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 38 20 80 00       	push   $0x802038
  8017b6:	6a 3a                	push   $0x3a
  8017b8:	68 2c 20 80 00       	push   $0x80202c
  8017bd:	e8 8d fe ff ff       	call   80164f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8017c2:	ff 45 f0             	incl   -0x10(%ebp)
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017cb:	0f 8c 2f ff ff ff    	jl     801700 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017df:	eb 26                	jmp    801807 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8017e6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017ef:	89 d0                	mov    %edx,%eax
  8017f1:	01 c0                	add    %eax,%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	c1 e0 03             	shl    $0x3,%eax
  8017f8:	01 c8                	add    %ecx,%eax
  8017fa:	8a 40 04             	mov    0x4(%eax),%al
  8017fd:	3c 01                	cmp    $0x1,%al
  8017ff:	75 03                	jne    801804 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801801:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801804:	ff 45 e0             	incl   -0x20(%ebp)
  801807:	a1 04 30 80 00       	mov    0x803004,%eax
  80180c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801815:	39 c2                	cmp    %eax,%edx
  801817:	77 c8                	ja     8017e1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80181f:	74 14                	je     801835 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	68 8c 20 80 00       	push   $0x80208c
  801829:	6a 44                	push   $0x44
  80182b:	68 2c 20 80 00       	push   $0x80202c
  801830:	e8 1a fe ff ff       	call   80164f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <__udivdi3>:
  801838:	55                   	push   %ebp
  801839:	57                   	push   %edi
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
  80183c:	83 ec 1c             	sub    $0x1c,%esp
  80183f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801843:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80184b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184f:	89 ca                	mov    %ecx,%edx
  801851:	89 f8                	mov    %edi,%eax
  801853:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801857:	85 f6                	test   %esi,%esi
  801859:	75 2d                	jne    801888 <__udivdi3+0x50>
  80185b:	39 cf                	cmp    %ecx,%edi
  80185d:	77 65                	ja     8018c4 <__udivdi3+0x8c>
  80185f:	89 fd                	mov    %edi,%ebp
  801861:	85 ff                	test   %edi,%edi
  801863:	75 0b                	jne    801870 <__udivdi3+0x38>
  801865:	b8 01 00 00 00       	mov    $0x1,%eax
  80186a:	31 d2                	xor    %edx,%edx
  80186c:	f7 f7                	div    %edi
  80186e:	89 c5                	mov    %eax,%ebp
  801870:	31 d2                	xor    %edx,%edx
  801872:	89 c8                	mov    %ecx,%eax
  801874:	f7 f5                	div    %ebp
  801876:	89 c1                	mov    %eax,%ecx
  801878:	89 d8                	mov    %ebx,%eax
  80187a:	f7 f5                	div    %ebp
  80187c:	89 cf                	mov    %ecx,%edi
  80187e:	89 fa                	mov    %edi,%edx
  801880:	83 c4 1c             	add    $0x1c,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    
  801888:	39 ce                	cmp    %ecx,%esi
  80188a:	77 28                	ja     8018b4 <__udivdi3+0x7c>
  80188c:	0f bd fe             	bsr    %esi,%edi
  80188f:	83 f7 1f             	xor    $0x1f,%edi
  801892:	75 40                	jne    8018d4 <__udivdi3+0x9c>
  801894:	39 ce                	cmp    %ecx,%esi
  801896:	72 0a                	jb     8018a2 <__udivdi3+0x6a>
  801898:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80189c:	0f 87 9e 00 00 00    	ja     801940 <__udivdi3+0x108>
  8018a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a7:	89 fa                	mov    %edi,%edx
  8018a9:	83 c4 1c             	add    $0x1c,%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5f                   	pop    %edi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    
  8018b1:	8d 76 00             	lea    0x0(%esi),%esi
  8018b4:	31 ff                	xor    %edi,%edi
  8018b6:	31 c0                	xor    %eax,%eax
  8018b8:	89 fa                	mov    %edi,%edx
  8018ba:	83 c4 1c             	add    $0x1c,%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5f                   	pop    %edi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    
  8018c2:	66 90                	xchg   %ax,%ax
  8018c4:	89 d8                	mov    %ebx,%eax
  8018c6:	f7 f7                	div    %edi
  8018c8:	31 ff                	xor    %edi,%edi
  8018ca:	89 fa                	mov    %edi,%edx
  8018cc:	83 c4 1c             	add    $0x1c,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5f                   	pop    %edi
  8018d2:	5d                   	pop    %ebp
  8018d3:	c3                   	ret    
  8018d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018d9:	89 eb                	mov    %ebp,%ebx
  8018db:	29 fb                	sub    %edi,%ebx
  8018dd:	89 f9                	mov    %edi,%ecx
  8018df:	d3 e6                	shl    %cl,%esi
  8018e1:	89 c5                	mov    %eax,%ebp
  8018e3:	88 d9                	mov    %bl,%cl
  8018e5:	d3 ed                	shr    %cl,%ebp
  8018e7:	89 e9                	mov    %ebp,%ecx
  8018e9:	09 f1                	or     %esi,%ecx
  8018eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018ef:	89 f9                	mov    %edi,%ecx
  8018f1:	d3 e0                	shl    %cl,%eax
  8018f3:	89 c5                	mov    %eax,%ebp
  8018f5:	89 d6                	mov    %edx,%esi
  8018f7:	88 d9                	mov    %bl,%cl
  8018f9:	d3 ee                	shr    %cl,%esi
  8018fb:	89 f9                	mov    %edi,%ecx
  8018fd:	d3 e2                	shl    %cl,%edx
  8018ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  801903:	88 d9                	mov    %bl,%cl
  801905:	d3 e8                	shr    %cl,%eax
  801907:	09 c2                	or     %eax,%edx
  801909:	89 d0                	mov    %edx,%eax
  80190b:	89 f2                	mov    %esi,%edx
  80190d:	f7 74 24 0c          	divl   0xc(%esp)
  801911:	89 d6                	mov    %edx,%esi
  801913:	89 c3                	mov    %eax,%ebx
  801915:	f7 e5                	mul    %ebp
  801917:	39 d6                	cmp    %edx,%esi
  801919:	72 19                	jb     801934 <__udivdi3+0xfc>
  80191b:	74 0b                	je     801928 <__udivdi3+0xf0>
  80191d:	89 d8                	mov    %ebx,%eax
  80191f:	31 ff                	xor    %edi,%edi
  801921:	e9 58 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  801926:	66 90                	xchg   %ax,%ax
  801928:	8b 54 24 08          	mov    0x8(%esp),%edx
  80192c:	89 f9                	mov    %edi,%ecx
  80192e:	d3 e2                	shl    %cl,%edx
  801930:	39 c2                	cmp    %eax,%edx
  801932:	73 e9                	jae    80191d <__udivdi3+0xe5>
  801934:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801937:	31 ff                	xor    %edi,%edi
  801939:	e9 40 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  80193e:	66 90                	xchg   %ax,%ax
  801940:	31 c0                	xor    %eax,%eax
  801942:	e9 37 ff ff ff       	jmp    80187e <__udivdi3+0x46>
  801947:	90                   	nop

00801948 <__umoddi3>:
  801948:	55                   	push   %ebp
  801949:	57                   	push   %edi
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	83 ec 1c             	sub    $0x1c,%esp
  80194f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801953:	8b 74 24 34          	mov    0x34(%esp),%esi
  801957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80195b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80195f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801963:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801967:	89 f3                	mov    %esi,%ebx
  801969:	89 fa                	mov    %edi,%edx
  80196b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80196f:	89 34 24             	mov    %esi,(%esp)
  801972:	85 c0                	test   %eax,%eax
  801974:	75 1a                	jne    801990 <__umoddi3+0x48>
  801976:	39 f7                	cmp    %esi,%edi
  801978:	0f 86 a2 00 00 00    	jbe    801a20 <__umoddi3+0xd8>
  80197e:	89 c8                	mov    %ecx,%eax
  801980:	89 f2                	mov    %esi,%edx
  801982:	f7 f7                	div    %edi
  801984:	89 d0                	mov    %edx,%eax
  801986:	31 d2                	xor    %edx,%edx
  801988:	83 c4 1c             	add    $0x1c,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    
  801990:	39 f0                	cmp    %esi,%eax
  801992:	0f 87 ac 00 00 00    	ja     801a44 <__umoddi3+0xfc>
  801998:	0f bd e8             	bsr    %eax,%ebp
  80199b:	83 f5 1f             	xor    $0x1f,%ebp
  80199e:	0f 84 ac 00 00 00    	je     801a50 <__umoddi3+0x108>
  8019a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8019a9:	29 ef                	sub    %ebp,%edi
  8019ab:	89 fe                	mov    %edi,%esi
  8019ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019b1:	89 e9                	mov    %ebp,%ecx
  8019b3:	d3 e0                	shl    %cl,%eax
  8019b5:	89 d7                	mov    %edx,%edi
  8019b7:	89 f1                	mov    %esi,%ecx
  8019b9:	d3 ef                	shr    %cl,%edi
  8019bb:	09 c7                	or     %eax,%edi
  8019bd:	89 e9                	mov    %ebp,%ecx
  8019bf:	d3 e2                	shl    %cl,%edx
  8019c1:	89 14 24             	mov    %edx,(%esp)
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	d3 e0                	shl    %cl,%eax
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019ce:	d3 e0                	shl    %cl,%eax
  8019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019d8:	89 f1                	mov    %esi,%ecx
  8019da:	d3 e8                	shr    %cl,%eax
  8019dc:	09 d0                	or     %edx,%eax
  8019de:	d3 eb                	shr    %cl,%ebx
  8019e0:	89 da                	mov    %ebx,%edx
  8019e2:	f7 f7                	div    %edi
  8019e4:	89 d3                	mov    %edx,%ebx
  8019e6:	f7 24 24             	mull   (%esp)
  8019e9:	89 c6                	mov    %eax,%esi
  8019eb:	89 d1                	mov    %edx,%ecx
  8019ed:	39 d3                	cmp    %edx,%ebx
  8019ef:	0f 82 87 00 00 00    	jb     801a7c <__umoddi3+0x134>
  8019f5:	0f 84 91 00 00 00    	je     801a8c <__umoddi3+0x144>
  8019fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019ff:	29 f2                	sub    %esi,%edx
  801a01:	19 cb                	sbb    %ecx,%ebx
  801a03:	89 d8                	mov    %ebx,%eax
  801a05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a09:	d3 e0                	shl    %cl,%eax
  801a0b:	89 e9                	mov    %ebp,%ecx
  801a0d:	d3 ea                	shr    %cl,%edx
  801a0f:	09 d0                	or     %edx,%eax
  801a11:	89 e9                	mov    %ebp,%ecx
  801a13:	d3 eb                	shr    %cl,%ebx
  801a15:	89 da                	mov    %ebx,%edx
  801a17:	83 c4 1c             	add    $0x1c,%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5f                   	pop    %edi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    
  801a1f:	90                   	nop
  801a20:	89 fd                	mov    %edi,%ebp
  801a22:	85 ff                	test   %edi,%edi
  801a24:	75 0b                	jne    801a31 <__umoddi3+0xe9>
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	31 d2                	xor    %edx,%edx
  801a2d:	f7 f7                	div    %edi
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 f0                	mov    %esi,%eax
  801a33:	31 d2                	xor    %edx,%edx
  801a35:	f7 f5                	div    %ebp
  801a37:	89 c8                	mov    %ecx,%eax
  801a39:	f7 f5                	div    %ebp
  801a3b:	89 d0                	mov    %edx,%eax
  801a3d:	e9 44 ff ff ff       	jmp    801986 <__umoddi3+0x3e>
  801a42:	66 90                	xchg   %ax,%ax
  801a44:	89 c8                	mov    %ecx,%eax
  801a46:	89 f2                	mov    %esi,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	3b 04 24             	cmp    (%esp),%eax
  801a53:	72 06                	jb     801a5b <__umoddi3+0x113>
  801a55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a59:	77 0f                	ja     801a6a <__umoddi3+0x122>
  801a5b:	89 f2                	mov    %esi,%edx
  801a5d:	29 f9                	sub    %edi,%ecx
  801a5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a63:	89 14 24             	mov    %edx,(%esp)
  801a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a6e:	8b 14 24             	mov    (%esp),%edx
  801a71:	83 c4 1c             	add    $0x1c,%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    
  801a79:	8d 76 00             	lea    0x0(%esi),%esi
  801a7c:	2b 04 24             	sub    (%esp),%eax
  801a7f:	19 fa                	sbb    %edi,%edx
  801a81:	89 d1                	mov    %edx,%ecx
  801a83:	89 c6                	mov    %eax,%esi
  801a85:	e9 71 ff ff ff       	jmp    8019fb <__umoddi3+0xb3>
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a90:	72 ea                	jb     801a7c <__umoddi3+0x134>
  801a92:	89 d9                	mov    %ebx,%ecx
  801a94:	e9 62 ff ff ff       	jmp    8019fb <__umoddi3+0xb3>
