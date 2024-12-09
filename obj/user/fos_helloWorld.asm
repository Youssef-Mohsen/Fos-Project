
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
  800041:	68 40 1b 80 00       	push   $0x801b40
  800046:	e8 5c 02 00 00       	call   8002a7 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 25 1b 80 00       	mov    0x801b25,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 68 1b 80 00       	push   $0x801b68
  80005c:	e8 46 02 00 00       	call   8002a7 <atomic_cprintf>
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
  80006d:	e8 8b 12 00 00       	call   8012fd <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 03             	shl    $0x3,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800086:	01 c8                	add    %ecx,%eax
  800088:	01 c0                	add    %eax,%eax
  80008a:	01 d0                	add    %edx,%eax
  80008c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800093:	01 c8                	add    %ecx,%eax
  800095:	01 d0                	add    %edx,%eax
  800097:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009c:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a6:	8a 40 20             	mov    0x20(%eax),%al
  8000a9:	84 c0                	test   %al,%al
  8000ab:	74 0d                	je     8000ba <libmain+0x53>
		binaryname = myEnv->prog_name;
  8000ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b2:	83 c0 20             	add    $0x20,%eax
  8000b5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000be:	7e 0a                	jle    8000ca <libmain+0x63>
		binaryname = argv[0];
  8000c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c3:	8b 00                	mov    (%eax),%eax
  8000c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	ff 75 0c             	pushl  0xc(%ebp)
  8000d0:	ff 75 08             	pushl  0x8(%ebp)
  8000d3:	e8 60 ff ff ff       	call   800038 <_main>
  8000d8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000db:	e8 a1 0f 00 00       	call   801081 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 94 1b 80 00       	push   $0x801b94
  8000e8:	e8 8d 01 00 00       	call   80027a <cprintf>
  8000ed:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800100:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	52                   	push   %edx
  80010a:	50                   	push   %eax
  80010b:	68 bc 1b 80 00       	push   $0x801bbc
  800110:	e8 65 01 00 00       	call   80027a <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800118:	a1 04 30 80 00       	mov    0x803004,%eax
  80011d:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800123:	a1 04 30 80 00       	mov    0x803004,%eax
  800128:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80012e:	a1 04 30 80 00       	mov    0x803004,%eax
  800133:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800139:	51                   	push   %ecx
  80013a:	52                   	push   %edx
  80013b:	50                   	push   %eax
  80013c:	68 e4 1b 80 00       	push   $0x801be4
  800141:	e8 34 01 00 00       	call   80027a <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800149:	a1 04 30 80 00       	mov    0x803004,%eax
  80014e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800154:	83 ec 08             	sub    $0x8,%esp
  800157:	50                   	push   %eax
  800158:	68 3c 1c 80 00       	push   $0x801c3c
  80015d:	e8 18 01 00 00       	call   80027a <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 94 1b 80 00       	push   $0x801b94
  80016d:	e8 08 01 00 00       	call   80027a <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800175:	e8 21 0f 00 00       	call   80109b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80017a:	e8 19 00 00 00       	call   800198 <exit>
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	e8 37 11 00 00       	call   8012c9 <sys_destroy_env>
  800192:	83 c4 10             	add    $0x10,%esp
}
  800195:	90                   	nop
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <exit>:

void
exit(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019e:	e8 8c 11 00 00       	call   80132f <sys_exit_env>
}
  8001a3:	90                   	nop
  8001a4:	c9                   	leave  
  8001a5:	c3                   	ret    

008001a6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001af:	8b 00                	mov    (%eax),%eax
  8001b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b7:	89 0a                	mov    %ecx,(%edx)
  8001b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bc:	88 d1                	mov    %dl,%cl
  8001be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c8:	8b 00                	mov    (%eax),%eax
  8001ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cf:	75 2c                	jne    8001fd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001d1:	a0 08 30 80 00       	mov    0x803008,%al
  8001d6:	0f b6 c0             	movzbl %al,%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	8b 12                	mov    (%edx),%edx
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e3:	83 c2 08             	add    $0x8,%edx
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	50                   	push   %eax
  8001ea:	51                   	push   %ecx
  8001eb:	52                   	push   %edx
  8001ec:	e8 4e 0e 00 00       	call   80103f <sys_cputs>
  8001f1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	8b 40 04             	mov    0x4(%eax),%eax
  800203:	8d 50 01             	lea    0x1(%eax),%edx
  800206:	8b 45 0c             	mov    0xc(%ebp),%eax
  800209:	89 50 04             	mov    %edx,0x4(%eax)
}
  80020c:	90                   	nop
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800218:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021f:	00 00 00 
	b.cnt = 0;
  800222:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800229:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80022c:	ff 75 0c             	pushl  0xc(%ebp)
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800238:	50                   	push   %eax
  800239:	68 a6 01 80 00       	push   $0x8001a6
  80023e:	e8 11 02 00 00       	call   800454 <vprintfmt>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800246:	a0 08 30 80 00       	mov    0x803008,%al
  80024b:	0f b6 c0             	movzbl %al,%eax
  80024e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	50                   	push   %eax
  800258:	52                   	push   %edx
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	83 c0 08             	add    $0x8,%eax
  800262:	50                   	push   %eax
  800263:	e8 d7 0d 00 00       	call   80103f <sys_cputs>
  800268:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80026b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800272:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800280:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800287:	8d 45 0c             	lea    0xc(%ebp),%eax
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	ff 75 f4             	pushl  -0xc(%ebp)
  800296:	50                   	push   %eax
  800297:	e8 73 ff ff ff       	call   80020f <vcprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002ad:	e8 cf 0d 00 00       	call   801081 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002b2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 48 ff ff ff       	call   80020f <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002cd:	e8 c9 0d 00 00       	call   80109b <sys_unlock_cons>
	return cnt;
  8002d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	53                   	push   %ebx
  8002db:	83 ec 14             	sub    $0x14,%esp
  8002de:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f5:	77 55                	ja     80034c <printnum+0x75>
  8002f7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002fa:	72 05                	jb     800301 <printnum+0x2a>
  8002fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ff:	77 4b                	ja     80034c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800301:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800304:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800307:	8b 45 18             	mov    0x18(%ebp),%eax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	52                   	push   %edx
  800310:	50                   	push   %eax
  800311:	ff 75 f4             	pushl  -0xc(%ebp)
  800314:	ff 75 f0             	pushl  -0x10(%ebp)
  800317:	e8 a8 15 00 00       	call   8018c4 <__udivdi3>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	83 ec 04             	sub    $0x4,%esp
  800322:	ff 75 20             	pushl  0x20(%ebp)
  800325:	53                   	push   %ebx
  800326:	ff 75 18             	pushl  0x18(%ebp)
  800329:	52                   	push   %edx
  80032a:	50                   	push   %eax
  80032b:	ff 75 0c             	pushl  0xc(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 a1 ff ff ff       	call   8002d7 <printnum>
  800336:	83 c4 20             	add    $0x20,%esp
  800339:	eb 1a                	jmp    800355 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 20             	pushl  0x20(%ebp)
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	ff d0                	call   *%eax
  800349:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034c:	ff 4d 1c             	decl   0x1c(%ebp)
  80034f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800353:	7f e6                	jg     80033b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800355:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800358:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800363:	53                   	push   %ebx
  800364:	51                   	push   %ecx
  800365:	52                   	push   %edx
  800366:	50                   	push   %eax
  800367:	e8 68 16 00 00       	call   8019d4 <__umoddi3>
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	05 74 1e 80 00       	add    $0x801e74,%eax
  800374:	8a 00                	mov    (%eax),%al
  800376:	0f be c0             	movsbl %al,%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	50                   	push   %eax
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	ff d0                	call   *%eax
  800385:	83 c4 10             	add    $0x10,%esp
}
  800388:	90                   	nop
  800389:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800391:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800395:	7e 1c                	jle    8003b3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	8d 50 08             	lea    0x8(%eax),%edx
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	89 10                	mov    %edx,(%eax)
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	83 e8 08             	sub    $0x8,%eax
  8003ac:	8b 50 04             	mov    0x4(%eax),%edx
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	eb 40                	jmp    8003f3 <getuint+0x65>
	else if (lflag)
  8003b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b7:	74 1e                	je     8003d7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	8d 50 04             	lea    0x4(%eax),%edx
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 10                	mov    %edx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	83 e8 04             	sub    $0x4,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d5:	eb 1c                	jmp    8003f3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	8d 50 04             	lea    0x4(%eax),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	89 10                	mov    %edx,(%eax)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	83 e8 04             	sub    $0x4,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f3:	5d                   	pop    %ebp
  8003f4:	c3                   	ret    

008003f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003fc:	7e 1c                	jle    80041a <getint+0x25>
		return va_arg(*ap, long long);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	8d 50 08             	lea    0x8(%eax),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	89 10                	mov    %edx,(%eax)
  80040b:	8b 45 08             	mov    0x8(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	83 e8 08             	sub    $0x8,%eax
  800413:	8b 50 04             	mov    0x4(%eax),%edx
  800416:	8b 00                	mov    (%eax),%eax
  800418:	eb 38                	jmp    800452 <getint+0x5d>
	else if (lflag)
  80041a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80041e:	74 1a                	je     80043a <getint+0x45>
		return va_arg(*ap, long);
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	8d 50 04             	lea    0x4(%eax),%edx
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	89 10                	mov    %edx,(%eax)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	83 e8 04             	sub    $0x4,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	99                   	cltd   
  800438:	eb 18                	jmp    800452 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	8d 50 04             	lea    0x4(%eax),%edx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	89 10                	mov    %edx,(%eax)
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	83 e8 04             	sub    $0x4,%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	99                   	cltd   
}
  800452:	5d                   	pop    %ebp
  800453:	c3                   	ret    

00800454 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	56                   	push   %esi
  800458:	53                   	push   %ebx
  800459:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045c:	eb 17                	jmp    800475 <vprintfmt+0x21>
			if (ch == '\0')
  80045e:	85 db                	test   %ebx,%ebx
  800460:	0f 84 c1 03 00 00    	je     800827 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	ff 75 0c             	pushl  0xc(%ebp)
  80046c:	53                   	push   %ebx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	ff d0                	call   *%eax
  800472:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800475:	8b 45 10             	mov    0x10(%ebp),%eax
  800478:	8d 50 01             	lea    0x1(%eax),%edx
  80047b:	89 55 10             	mov    %edx,0x10(%ebp)
  80047e:	8a 00                	mov    (%eax),%al
  800480:	0f b6 d8             	movzbl %al,%ebx
  800483:	83 fb 25             	cmp    $0x25,%ebx
  800486:	75 d6                	jne    80045e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800488:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80048c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800493:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ab:	8d 50 01             	lea    0x1(%eax),%edx
  8004ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b1:	8a 00                	mov    (%eax),%al
  8004b3:	0f b6 d8             	movzbl %al,%ebx
  8004b6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b9:	83 f8 5b             	cmp    $0x5b,%eax
  8004bc:	0f 87 3d 03 00 00    	ja     8007ff <vprintfmt+0x3ab>
  8004c2:	8b 04 85 98 1e 80 00 	mov    0x801e98(,%eax,4),%eax
  8004c9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004cb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004cf:	eb d7                	jmp    8004a8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004d5:	eb d1                	jmp    8004a8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	c1 e0 02             	shl    $0x2,%eax
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	01 c0                	add    %eax,%eax
  8004ea:	01 d8                	add    %ebx,%eax
  8004ec:	83 e8 30             	sub    $0x30,%eax
  8004ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f5:	8a 00                	mov    (%eax),%al
  8004f7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004fa:	83 fb 2f             	cmp    $0x2f,%ebx
  8004fd:	7e 3e                	jle    80053d <vprintfmt+0xe9>
  8004ff:	83 fb 39             	cmp    $0x39,%ebx
  800502:	7f 39                	jg     80053d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800504:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800507:	eb d5                	jmp    8004de <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	83 c0 04             	add    $0x4,%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	83 e8 04             	sub    $0x4,%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80051d:	eb 1f                	jmp    80053e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80051f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800523:	79 83                	jns    8004a8 <vprintfmt+0x54>
				width = 0;
  800525:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80052c:	e9 77 ff ff ff       	jmp    8004a8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800531:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800538:	e9 6b ff ff ff       	jmp    8004a8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80053d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80053e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800542:	0f 89 60 ff ff ff    	jns    8004a8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800555:	e9 4e ff ff ff       	jmp    8004a8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80055a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80055d:	e9 46 ff ff ff       	jmp    8004a8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	83 c0 04             	add    $0x4,%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	83 e8 04             	sub    $0x4,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	8b 45 08             	mov    0x8(%ebp),%eax
  80057d:	ff d0                	call   *%eax
  80057f:	83 c4 10             	add    $0x10,%esp
			break;
  800582:	e9 9b 02 00 00       	jmp    800822 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	83 c0 04             	add    $0x4,%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	83 e8 04             	sub    $0x4,%eax
  800596:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800598:	85 db                	test   %ebx,%ebx
  80059a:	79 02                	jns    80059e <vprintfmt+0x14a>
				err = -err;
  80059c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80059e:	83 fb 64             	cmp    $0x64,%ebx
  8005a1:	7f 0b                	jg     8005ae <vprintfmt+0x15a>
  8005a3:	8b 34 9d e0 1c 80 00 	mov    0x801ce0(,%ebx,4),%esi
  8005aa:	85 f6                	test   %esi,%esi
  8005ac:	75 19                	jne    8005c7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ae:	53                   	push   %ebx
  8005af:	68 85 1e 80 00       	push   $0x801e85
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	ff 75 08             	pushl  0x8(%ebp)
  8005ba:	e8 70 02 00 00       	call   80082f <printfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005c2:	e9 5b 02 00 00       	jmp    800822 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005c7:	56                   	push   %esi
  8005c8:	68 8e 1e 80 00       	push   $0x801e8e
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 57 02 00 00       	call   80082f <printfmt>
  8005d8:	83 c4 10             	add    $0x10,%esp
			break;
  8005db:	e9 42 02 00 00       	jmp    800822 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 30                	mov    (%eax),%esi
  8005f1:	85 f6                	test   %esi,%esi
  8005f3:	75 05                	jne    8005fa <vprintfmt+0x1a6>
				p = "(null)";
  8005f5:	be 91 1e 80 00       	mov    $0x801e91,%esi
			if (width > 0 && padc != '-')
  8005fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fe:	7e 6d                	jle    80066d <vprintfmt+0x219>
  800600:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800604:	74 67                	je     80066d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	50                   	push   %eax
  80060d:	56                   	push   %esi
  80060e:	e8 1e 03 00 00       	call   800931 <strnlen>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800619:	eb 16                	jmp    800631 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80061b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	50                   	push   %eax
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	ff d0                	call   *%eax
  80062b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80062e:	ff 4d e4             	decl   -0x1c(%ebp)
  800631:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800635:	7f e4                	jg     80061b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800637:	eb 34                	jmp    80066d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800639:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063d:	74 1c                	je     80065b <vprintfmt+0x207>
  80063f:	83 fb 1f             	cmp    $0x1f,%ebx
  800642:	7e 05                	jle    800649 <vprintfmt+0x1f5>
  800644:	83 fb 7e             	cmp    $0x7e,%ebx
  800647:	7e 12                	jle    80065b <vprintfmt+0x207>
					putch('?', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	6a 3f                	push   $0x3f
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	ff d0                	call   *%eax
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	eb 0f                	jmp    80066a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	ff 75 0c             	pushl  0xc(%ebp)
  800661:	53                   	push   %ebx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	ff d0                	call   *%eax
  800667:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066a:	ff 4d e4             	decl   -0x1c(%ebp)
  80066d:	89 f0                	mov    %esi,%eax
  80066f:	8d 70 01             	lea    0x1(%eax),%esi
  800672:	8a 00                	mov    (%eax),%al
  800674:	0f be d8             	movsbl %al,%ebx
  800677:	85 db                	test   %ebx,%ebx
  800679:	74 24                	je     80069f <vprintfmt+0x24b>
  80067b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067f:	78 b8                	js     800639 <vprintfmt+0x1e5>
  800681:	ff 4d e0             	decl   -0x20(%ebp)
  800684:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800688:	79 af                	jns    800639 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068a:	eb 13                	jmp    80069f <vprintfmt+0x24b>
				putch(' ', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	ff 75 0c             	pushl  0xc(%ebp)
  800692:	6a 20                	push   $0x20
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80069c:	ff 4d e4             	decl   -0x1c(%ebp)
  80069f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a3:	7f e7                	jg     80068c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006a5:	e9 78 01 00 00       	jmp    800822 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8006b0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b3:	50                   	push   %eax
  8006b4:	e8 3c fd ff ff       	call   8003f5 <getint>
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c8:	85 d2                	test   %edx,%edx
  8006ca:	79 23                	jns    8006ef <vprintfmt+0x29b>
				putch('-', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	6a 2d                	push   $0x2d
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	ff d0                	call   *%eax
  8006d9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e2:	f7 d8                	neg    %eax
  8006e4:	83 d2 00             	adc    $0x0,%edx
  8006e7:	f7 da                	neg    %edx
  8006e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f6:	e9 bc 00 00 00       	jmp    8007b7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 e8             	pushl  -0x18(%ebp)
  800701:	8d 45 14             	lea    0x14(%ebp),%eax
  800704:	50                   	push   %eax
  800705:	e8 84 fc ff ff       	call   80038e <getuint>
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800710:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800713:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80071a:	e9 98 00 00 00       	jmp    8007b7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 58                	push   $0x58
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 58                	push   $0x58
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 0c             	pushl  0xc(%ebp)
  800745:	6a 58                	push   $0x58
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	ff d0                	call   *%eax
  80074c:	83 c4 10             	add    $0x10,%esp
			break;
  80074f:	e9 ce 00 00 00       	jmp    800822 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	6a 30                	push   $0x30
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 78                	push   $0x78
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	83 c0 04             	add    $0x4,%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	83 e8 04             	sub    $0x4,%eax
  800783:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800788:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80078f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800796:	eb 1f                	jmp    8007b7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 e8             	pushl  -0x18(%ebp)
  80079e:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a1:	50                   	push   %eax
  8007a2:	e8 e7 fb ff ff       	call   80038e <getuint>
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	52                   	push   %edx
  8007c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c5:	50                   	push   %eax
  8007c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	ff 75 08             	pushl  0x8(%ebp)
  8007d2:	e8 00 fb ff ff       	call   8002d7 <printnum>
  8007d7:	83 c4 20             	add    $0x20,%esp
			break;
  8007da:	eb 46                	jmp    800822 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	53                   	push   %ebx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
			break;
  8007eb:	eb 35                	jmp    800822 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007ed:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8007f4:	eb 2c                	jmp    800822 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007f6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8007fd:	eb 23                	jmp    800822 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	6a 25                	push   $0x25
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080f:	ff 4d 10             	decl   0x10(%ebp)
  800812:	eb 03                	jmp    800817 <vprintfmt+0x3c3>
  800814:	ff 4d 10             	decl   0x10(%ebp)
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	48                   	dec    %eax
  80081b:	8a 00                	mov    (%eax),%al
  80081d:	3c 25                	cmp    $0x25,%al
  80081f:	75 f3                	jne    800814 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800821:	90                   	nop
		}
	}
  800822:	e9 35 fc ff ff       	jmp    80045c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800827:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800828:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80082b:	5b                   	pop    %ebx
  80082c:	5e                   	pop    %esi
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800835:	8d 45 10             	lea    0x10(%ebp),%eax
  800838:	83 c0 04             	add    $0x4,%eax
  80083b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 04 fc ff ff       	call   800454 <vprintfmt>
  800850:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800853:	90                   	nop
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	8b 40 08             	mov    0x8(%eax),%eax
  80085f:	8d 50 01             	lea    0x1(%eax),%edx
  800862:	8b 45 0c             	mov    0xc(%ebp),%eax
  800865:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086b:	8b 10                	mov    (%eax),%edx
  80086d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800870:	8b 40 04             	mov    0x4(%eax),%eax
  800873:	39 c2                	cmp    %eax,%edx
  800875:	73 12                	jae    800889 <sprintputch+0x33>
		*b->buf++ = ch;
  800877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	8d 48 01             	lea    0x1(%eax),%ecx
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800882:	89 0a                	mov    %ecx,(%edx)
  800884:	8b 55 08             	mov    0x8(%ebp),%edx
  800887:	88 10                	mov    %dl,(%eax)
}
  800889:	90                   	nop
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	01 d0                	add    %edx,%eax
  8008a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008b1:	74 06                	je     8008b9 <vsnprintf+0x2d>
  8008b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b7:	7f 07                	jg     8008c0 <vsnprintf+0x34>
		return -E_INVAL;
  8008b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8008be:	eb 20                	jmp    8008e0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c0:	ff 75 14             	pushl  0x14(%ebp)
  8008c3:	ff 75 10             	pushl  0x10(%ebp)
  8008c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c9:	50                   	push   %eax
  8008ca:	68 56 08 80 00       	push   $0x800856
  8008cf:	e8 80 fb ff ff       	call   800454 <vprintfmt>
  8008d4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	ff 75 08             	pushl  0x8(%ebp)
  8008fe:	e8 89 ff ff ff       	call   80088c <vsnprintf>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800909:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    

0080090e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800914:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091b:	eb 06                	jmp    800923 <strlen+0x15>
		n++;
  80091d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	ff 45 08             	incl   0x8(%ebp)
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8a 00                	mov    (%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	75 f1                	jne    80091d <strlen+0xf>
		n++;
	return n;
  80092c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80093e:	eb 09                	jmp    800949 <strnlen+0x18>
		n++;
  800940:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800943:	ff 45 08             	incl   0x8(%ebp)
  800946:	ff 4d 0c             	decl   0xc(%ebp)
  800949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094d:	74 09                	je     800958 <strnlen+0x27>
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8a 00                	mov    (%eax),%al
  800954:	84 c0                	test   %al,%al
  800956:	75 e8                	jne    800940 <strnlen+0xf>
		n++;
	return n;
  800958:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800969:	90                   	nop
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 08             	mov    %edx,0x8(%ebp)
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	8d 4a 01             	lea    0x1(%edx),%ecx
  800979:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80097c:	8a 12                	mov    (%edx),%dl
  80097e:	88 10                	mov    %dl,(%eax)
  800980:	8a 00                	mov    (%eax),%al
  800982:	84 c0                	test   %al,%al
  800984:	75 e4                	jne    80096a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800986:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800997:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80099e:	eb 1f                	jmp    8009bf <strncpy+0x34>
		*dst++ = *src;
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8d 50 01             	lea    0x1(%eax),%edx
  8009a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	8a 12                	mov    (%edx),%dl
  8009ae:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	84 c0                	test   %al,%al
  8009b7:	74 03                	je     8009bc <strncpy+0x31>
			src++;
  8009b9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bc:	ff 45 fc             	incl   -0x4(%ebp)
  8009bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009c5:	72 d9                	jb     8009a0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009dc:	74 30                	je     800a0e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009de:	eb 16                	jmp    8009f6 <strlcpy+0x2a>
			*dst++ = *src++;
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8d 50 01             	lea    0x1(%eax),%edx
  8009e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ef:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f2:	8a 12                	mov    (%edx),%dl
  8009f4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f6:	ff 4d 10             	decl   0x10(%ebp)
  8009f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fd:	74 09                	je     800a08 <strlcpy+0x3c>
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	84 c0                	test   %al,%al
  800a06:	75 d8                	jne    8009e0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a14:	29 c2                	sub    %eax,%edx
  800a16:	89 d0                	mov    %edx,%eax
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a1d:	eb 06                	jmp    800a25 <strcmp+0xb>
		p++, q++;
  800a1f:	ff 45 08             	incl   0x8(%ebp)
  800a22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	84 c0                	test   %al,%al
  800a2c:	74 0e                	je     800a3c <strcmp+0x22>
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8a 10                	mov    (%eax),%dl
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	38 c2                	cmp    %al,%dl
  800a3a:	74 e3                	je     800a1f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	0f b6 d0             	movzbl %al,%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	8a 00                	mov    (%eax),%al
  800a49:	0f b6 c0             	movzbl %al,%eax
  800a4c:	29 c2                	sub    %eax,%edx
  800a4e:	89 d0                	mov    %edx,%eax
}
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a55:	eb 09                	jmp    800a60 <strncmp+0xe>
		n--, p++, q++;
  800a57:	ff 4d 10             	decl   0x10(%ebp)
  800a5a:	ff 45 08             	incl   0x8(%ebp)
  800a5d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a64:	74 17                	je     800a7d <strncmp+0x2b>
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8a 00                	mov    (%eax),%al
  800a6b:	84 c0                	test   %al,%al
  800a6d:	74 0e                	je     800a7d <strncmp+0x2b>
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8a 10                	mov    (%eax),%dl
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	38 c2                	cmp    %al,%dl
  800a7b:	74 da                	je     800a57 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a81:	75 07                	jne    800a8a <strncmp+0x38>
		return 0;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
  800a88:	eb 14                	jmp    800a9e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	0f b6 d0             	movzbl %al,%edx
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	0f b6 c0             	movzbl %al,%eax
  800a9a:	29 c2                	sub    %eax,%edx
  800a9c:	89 d0                	mov    %edx,%eax
}
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 04             	sub    $0x4,%esp
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aac:	eb 12                	jmp    800ac0 <strchr+0x20>
		if (*s == c)
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab6:	75 05                	jne    800abd <strchr+0x1d>
			return (char *) s;
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	eb 11                	jmp    800ace <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800abd:	ff 45 08             	incl   0x8(%ebp)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	84 c0                	test   %al,%al
  800ac7:	75 e5                	jne    800aae <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ace:	c9                   	leave  
  800acf:	c3                   	ret    

00800ad0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	83 ec 04             	sub    $0x4,%esp
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800adc:	eb 0d                	jmp    800aeb <strfind+0x1b>
		if (*s == c)
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae6:	74 0e                	je     800af6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ae8:	ff 45 08             	incl   0x8(%ebp)
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	84 c0                	test   %al,%al
  800af2:	75 ea                	jne    800ade <strfind+0xe>
  800af4:	eb 01                	jmp    800af7 <strfind+0x27>
		if (*s == c)
			break;
  800af6:	90                   	nop
	return (char *) s;
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    

00800afc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b08:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b0e:	eb 0e                	jmp    800b1e <memset+0x22>
		*p++ = c;
  800b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b13:	8d 50 01             	lea    0x1(%eax),%edx
  800b16:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b1e:	ff 4d f8             	decl   -0x8(%ebp)
  800b21:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b25:	79 e9                	jns    800b10 <memset+0x14>
		*p++ = c;

	return v;
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b3e:	eb 16                	jmp    800b56 <memcpy+0x2a>
		*d++ = *s++;
  800b40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b52:	8a 12                	mov    (%edx),%dl
  800b54:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b56:	8b 45 10             	mov    0x10(%ebp),%eax
  800b59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5f:	85 c0                	test   %eax,%eax
  800b61:	75 dd                	jne    800b40 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b80:	73 50                	jae    800bd2 <memmove+0x6a>
  800b82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b85:	8b 45 10             	mov    0x10(%ebp),%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8d:	76 43                	jbe    800bd2 <memmove+0x6a>
		s += n;
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b9b:	eb 10                	jmp    800bad <memmove+0x45>
			*--d = *--s;
  800b9d:	ff 4d f8             	decl   -0x8(%ebp)
  800ba0:	ff 4d fc             	decl   -0x4(%ebp)
  800ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba6:	8a 10                	mov    (%eax),%dl
  800ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bab:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb6:	85 c0                	test   %eax,%eax
  800bb8:	75 e3                	jne    800b9d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bba:	eb 23                	jmp    800bdf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbf:	8d 50 01             	lea    0x1(%eax),%edx
  800bc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bcb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bce:	8a 12                	mov    (%edx),%dl
  800bd0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	75 dd                	jne    800bbc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be2:	c9                   	leave  
  800be3:	c3                   	ret    

00800be4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bf6:	eb 2a                	jmp    800c22 <memcmp+0x3e>
		if (*s1 != *s2)
  800bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfb:	8a 10                	mov    (%eax),%dl
  800bfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	38 c2                	cmp    %al,%dl
  800c04:	74 16                	je     800c1c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d0             	movzbl %al,%edx
  800c0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 c0             	movzbl %al,%eax
  800c16:	29 c2                	sub    %eax,%edx
  800c18:	89 d0                	mov    %edx,%eax
  800c1a:	eb 18                	jmp    800c34 <memcmp+0x50>
		s1++, s2++;
  800c1c:	ff 45 fc             	incl   -0x4(%ebp)
  800c1f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c22:	8b 45 10             	mov    0x10(%ebp),%eax
  800c25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c28:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2b:	85 c0                	test   %eax,%eax
  800c2d:	75 c9                	jne    800bf8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	01 d0                	add    %edx,%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c47:	eb 15                	jmp    800c5e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	0f b6 d0             	movzbl %al,%edx
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	0f b6 c0             	movzbl %al,%eax
  800c57:	39 c2                	cmp    %eax,%edx
  800c59:	74 0d                	je     800c68 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c5b:	ff 45 08             	incl   0x8(%ebp)
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c64:	72 e3                	jb     800c49 <memfind+0x13>
  800c66:	eb 01                	jmp    800c69 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c68:	90                   	nop
	return (void *) s;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c7b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c82:	eb 03                	jmp    800c87 <strtol+0x19>
		s++;
  800c84:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8a 00                	mov    (%eax),%al
  800c8c:	3c 20                	cmp    $0x20,%al
  800c8e:	74 f4                	je     800c84 <strtol+0x16>
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	3c 09                	cmp    $0x9,%al
  800c97:	74 eb                	je     800c84 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	3c 2b                	cmp    $0x2b,%al
  800ca0:	75 05                	jne    800ca7 <strtol+0x39>
		s++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	eb 13                	jmp    800cba <strtol+0x4c>
	else if (*s == '-')
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	3c 2d                	cmp    $0x2d,%al
  800cae:	75 0a                	jne    800cba <strtol+0x4c>
		s++, neg = 1;
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbe:	74 06                	je     800cc6 <strtol+0x58>
  800cc0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cc4:	75 20                	jne    800ce6 <strtol+0x78>
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	3c 30                	cmp    $0x30,%al
  800ccd:	75 17                	jne    800ce6 <strtol+0x78>
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	40                   	inc    %eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	3c 78                	cmp    $0x78,%al
  800cd7:	75 0d                	jne    800ce6 <strtol+0x78>
		s += 2, base = 16;
  800cd9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cdd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ce4:	eb 28                	jmp    800d0e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ce6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cea:	75 15                	jne    800d01 <strtol+0x93>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	3c 30                	cmp    $0x30,%al
  800cf3:	75 0c                	jne    800d01 <strtol+0x93>
		s++, base = 8;
  800cf5:	ff 45 08             	incl   0x8(%ebp)
  800cf8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cff:	eb 0d                	jmp    800d0e <strtol+0xa0>
	else if (base == 0)
  800d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d05:	75 07                	jne    800d0e <strtol+0xa0>
		base = 10;
  800d07:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 2f                	cmp    $0x2f,%al
  800d15:	7e 19                	jle    800d30 <strtol+0xc2>
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	3c 39                	cmp    $0x39,%al
  800d1e:	7f 10                	jg     800d30 <strtol+0xc2>
			dig = *s - '0';
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	0f be c0             	movsbl %al,%eax
  800d28:	83 e8 30             	sub    $0x30,%eax
  800d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d2e:	eb 42                	jmp    800d72 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3c 60                	cmp    $0x60,%al
  800d37:	7e 19                	jle    800d52 <strtol+0xe4>
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	3c 7a                	cmp    $0x7a,%al
  800d40:	7f 10                	jg     800d52 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f be c0             	movsbl %al,%eax
  800d4a:	83 e8 57             	sub    $0x57,%eax
  800d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d50:	eb 20                	jmp    800d72 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3c 40                	cmp    $0x40,%al
  800d59:	7e 39                	jle    800d94 <strtol+0x126>
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	3c 5a                	cmp    $0x5a,%al
  800d62:	7f 30                	jg     800d94 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f be c0             	movsbl %al,%eax
  800d6c:	83 e8 37             	sub    $0x37,%eax
  800d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d78:	7d 19                	jge    800d93 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d84:	89 c2                	mov    %eax,%edx
  800d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d89:	01 d0                	add    %edx,%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d8e:	e9 7b ff ff ff       	jmp    800d0e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d93:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d98:	74 08                	je     800da2 <strtol+0x134>
		*endptr = (char *) s;
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800da2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da6:	74 07                	je     800daf <strtol+0x141>
  800da8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dab:	f7 d8                	neg    %eax
  800dad:	eb 03                	jmp    800db2 <strtol+0x144>
  800daf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <ltostr>:

void
ltostr(long value, char *str)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dc1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcc:	79 13                	jns    800de1 <ltostr+0x2d>
	{
		neg = 1;
  800dce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ddb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dde:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de9:	99                   	cltd   
  800dea:	f7 f9                	idiv   %ecx
  800dec:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800def:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df2:	8d 50 01             	lea    0x1(%eax),%edx
  800df5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df8:	89 c2                	mov    %eax,%edx
  800dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfd:	01 d0                	add    %edx,%eax
  800dff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e02:	83 c2 30             	add    $0x30,%edx
  800e05:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0f:	f7 e9                	imul   %ecx
  800e11:	c1 fa 02             	sar    $0x2,%edx
  800e14:	89 c8                	mov    %ecx,%eax
  800e16:	c1 f8 1f             	sar    $0x1f,%eax
  800e19:	29 c2                	sub    %eax,%edx
  800e1b:	89 d0                	mov    %edx,%eax
  800e1d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e24:	75 bb                	jne    800de1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e30:	48                   	dec    %eax
  800e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e38:	74 3d                	je     800e77 <ltostr+0xc3>
		start = 1 ;
  800e3a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e41:	eb 34                	jmp    800e77 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	01 c2                	add    %eax,%edx
  800e58:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	01 c8                	add    %ecx,%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	01 c2                	add    %eax,%edx
  800e6c:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e6f:	88 02                	mov    %al,(%edx)
		start++ ;
  800e71:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e74:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e7d:	7c c4                	jl     800e43 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e7f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	01 d0                	add    %edx,%eax
  800e87:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e93:	ff 75 08             	pushl  0x8(%ebp)
  800e96:	e8 73 fa ff ff       	call   80090e <strlen>
  800e9b:	83 c4 04             	add    $0x4,%esp
  800e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea1:	ff 75 0c             	pushl  0xc(%ebp)
  800ea4:	e8 65 fa ff ff       	call   80090e <strlen>
  800ea9:	83 c4 04             	add    $0x4,%esp
  800eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebd:	eb 17                	jmp    800ed6 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 c2                	add    %eax,%edx
  800ec7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	01 c8                	add    %ecx,%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ed3:	ff 45 fc             	incl   -0x4(%ebp)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800edc:	7c e1                	jl     800ebf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ede:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ee5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800eec:	eb 1f                	jmp    800f0d <strcconcat+0x80>
		final[s++] = str2[i] ;
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8d 50 01             	lea    0x1(%eax),%edx
  800ef4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef7:	89 c2                	mov    %eax,%edx
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 c2                	add    %eax,%edx
  800efe:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	01 c8                	add    %ecx,%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f0a:	ff 45 f8             	incl   -0x8(%ebp)
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f13:	7c d9                	jl     800eee <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	01 d0                	add    %edx,%eax
  800f1d:	c6 00 00             	movb   $0x0,(%eax)
}
  800f20:	90                   	nop
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	8b 00                	mov    (%eax),%eax
  800f34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 d0                	add    %edx,%eax
  800f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f46:	eb 0c                	jmp    800f54 <strsplit+0x31>
			*string++ = 0;
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8d 50 01             	lea    0x1(%eax),%edx
  800f4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f51:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	74 18                	je     800f75 <strsplit+0x52>
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	0f be c0             	movsbl %al,%eax
  800f65:	50                   	push   %eax
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	e8 32 fb ff ff       	call   800aa0 <strchr>
  800f6e:	83 c4 08             	add    $0x8,%esp
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 d3                	jne    800f48 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	84 c0                	test   %al,%al
  800f7c:	74 5a                	je     800fd8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	8b 00                	mov    (%eax),%eax
  800f83:	83 f8 0f             	cmp    $0xf,%eax
  800f86:	75 07                	jne    800f8f <strsplit+0x6c>
		{
			return 0;
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	eb 66                	jmp    800ff5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f92:	8b 00                	mov    (%eax),%eax
  800f94:	8d 48 01             	lea    0x1(%eax),%ecx
  800f97:	8b 55 14             	mov    0x14(%ebp),%edx
  800f9a:	89 0a                	mov    %ecx,(%edx)
  800f9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 c2                	add    %eax,%edx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fad:	eb 03                	jmp    800fb2 <strsplit+0x8f>
			string++;
  800faf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	84 c0                	test   %al,%al
  800fb9:	74 8b                	je     800f46 <strsplit+0x23>
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f be c0             	movsbl %al,%eax
  800fc3:	50                   	push   %eax
  800fc4:	ff 75 0c             	pushl  0xc(%ebp)
  800fc7:	e8 d4 fa ff ff       	call   800aa0 <strchr>
  800fcc:	83 c4 08             	add    $0x8,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	74 dc                	je     800faf <strsplit+0x8c>
			string++;
	}
  800fd3:	e9 6e ff ff ff       	jmp    800f46 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fd8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ff0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	68 08 20 80 00       	push   $0x802008
  801005:	68 3f 01 00 00       	push   $0x13f
  80100a:	68 2a 20 80 00       	push   $0x80202a
  80100f:	e8 c5 06 00 00       	call   8016d9 <_panic>

00801014 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	57                   	push   %edi
  801018:	56                   	push   %esi
  801019:	53                   	push   %ebx
  80101a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801026:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801029:	8b 7d 18             	mov    0x18(%ebp),%edi
  80102c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80102f:	cd 30                	int    $0x30
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	5b                   	pop    %ebx
  80103b:	5e                   	pop    %esi
  80103c:	5f                   	pop    %edi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80104b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	6a 00                	push   $0x0
  801054:	6a 00                	push   $0x0
  801056:	52                   	push   %edx
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	50                   	push   %eax
  80105b:	6a 00                	push   $0x0
  80105d:	e8 b2 ff ff ff       	call   801014 <syscall>
  801062:	83 c4 18             	add    $0x18,%esp
}
  801065:	90                   	nop
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <sys_cgetc>:

int
sys_cgetc(void)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80106b:	6a 00                	push   $0x0
  80106d:	6a 00                	push   $0x0
  80106f:	6a 00                	push   $0x0
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	6a 02                	push   $0x2
  801077:	e8 98 ff ff ff       	call   801014 <syscall>
  80107c:	83 c4 18             	add    $0x18,%esp
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801084:	6a 00                	push   $0x0
  801086:	6a 00                	push   $0x0
  801088:	6a 00                	push   $0x0
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	6a 03                	push   $0x3
  801090:	e8 7f ff ff ff       	call   801014 <syscall>
  801095:	83 c4 18             	add    $0x18,%esp
}
  801098:	90                   	nop
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80109e:	6a 00                	push   $0x0
  8010a0:	6a 00                	push   $0x0
  8010a2:	6a 00                	push   $0x0
  8010a4:	6a 00                	push   $0x0
  8010a6:	6a 00                	push   $0x0
  8010a8:	6a 04                	push   $0x4
  8010aa:	e8 65 ff ff ff       	call   801014 <syscall>
  8010af:	83 c4 18             	add    $0x18,%esp
}
  8010b2:	90                   	nop
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	6a 00                	push   $0x0
  8010c0:	6a 00                	push   $0x0
  8010c2:	6a 00                	push   $0x0
  8010c4:	52                   	push   %edx
  8010c5:	50                   	push   %eax
  8010c6:	6a 08                	push   $0x8
  8010c8:	e8 47 ff ff ff       	call   801014 <syscall>
  8010cd:	83 c4 18             	add    $0x18,%esp
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	51                   	push   %ecx
  8010e9:	52                   	push   %edx
  8010ea:	50                   	push   %eax
  8010eb:	6a 09                	push   $0x9
  8010ed:	e8 22 ff ff ff       	call   801014 <syscall>
  8010f2:	83 c4 18             	add    $0x18,%esp
}
  8010f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	6a 00                	push   $0x0
  801107:	6a 00                	push   $0x0
  801109:	6a 00                	push   $0x0
  80110b:	52                   	push   %edx
  80110c:	50                   	push   %eax
  80110d:	6a 0a                	push   $0xa
  80110f:	e8 00 ff ff ff       	call   801014 <syscall>
  801114:	83 c4 18             	add    $0x18,%esp
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	ff 75 08             	pushl  0x8(%ebp)
  801128:	6a 0b                	push   $0xb
  80112a:	e8 e5 fe ff ff       	call   801014 <syscall>
  80112f:	83 c4 18             	add    $0x18,%esp
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	6a 0c                	push   $0xc
  801143:	e8 cc fe ff ff       	call   801014 <syscall>
  801148:	83 c4 18             	add    $0x18,%esp
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801150:	6a 00                	push   $0x0
  801152:	6a 00                	push   $0x0
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 0d                	push   $0xd
  80115c:	e8 b3 fe ff ff       	call   801014 <syscall>
  801161:	83 c4 18             	add    $0x18,%esp
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801169:	6a 00                	push   $0x0
  80116b:	6a 00                	push   $0x0
  80116d:	6a 00                	push   $0x0
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 0e                	push   $0xe
  801175:	e8 9a fe ff ff       	call   801014 <syscall>
  80117a:	83 c4 18             	add    $0x18,%esp
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 0f                	push   $0xf
  80118e:	e8 81 fe ff ff       	call   801014 <syscall>
  801193:	83 c4 18             	add    $0x18,%esp
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	ff 75 08             	pushl  0x8(%ebp)
  8011a6:	6a 10                	push   $0x10
  8011a8:	e8 67 fe ff ff       	call   801014 <syscall>
  8011ad:	83 c4 18             	add    $0x18,%esp
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 11                	push   $0x11
  8011c1:	e8 4e fe ff ff       	call   801014 <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	90                   	nop
  8011ca:	c9                   	leave  
  8011cb:	c3                   	ret    

008011cc <sys_cputc>:

void
sys_cputc(const char c)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	50                   	push   %eax
  8011e5:	6a 01                	push   $0x1
  8011e7:	e8 28 fe ff ff       	call   801014 <syscall>
  8011ec:	83 c4 18             	add    $0x18,%esp
}
  8011ef:	90                   	nop
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 14                	push   $0x14
  801201:	e8 0e fe ff ff       	call   801014 <syscall>
  801206:	83 c4 18             	add    $0x18,%esp
}
  801209:	90                   	nop
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801218:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80121b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	6a 00                	push   $0x0
  801224:	51                   	push   %ecx
  801225:	52                   	push   %edx
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	50                   	push   %eax
  80122a:	6a 15                	push   $0x15
  80122c:	e8 e3 fd ff ff       	call   801014 <syscall>
  801231:	83 c4 18             	add    $0x18,%esp
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801239:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	52                   	push   %edx
  801246:	50                   	push   %eax
  801247:	6a 16                	push   $0x16
  801249:	e8 c6 fd ff ff       	call   801014 <syscall>
  80124e:	83 c4 18             	add    $0x18,%esp
}
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801256:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	51                   	push   %ecx
  801264:	52                   	push   %edx
  801265:	50                   	push   %eax
  801266:	6a 17                	push   $0x17
  801268:	e8 a7 fd ff ff       	call   801014 <syscall>
  80126d:	83 c4 18             	add    $0x18,%esp
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801275:	8b 55 0c             	mov    0xc(%ebp),%edx
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	52                   	push   %edx
  801282:	50                   	push   %eax
  801283:	6a 18                	push   $0x18
  801285:	e8 8a fd ff ff       	call   801014 <syscall>
  80128a:	83 c4 18             	add    $0x18,%esp
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	6a 00                	push   $0x0
  801297:	ff 75 14             	pushl  0x14(%ebp)
  80129a:	ff 75 10             	pushl  0x10(%ebp)
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	50                   	push   %eax
  8012a1:	6a 19                	push   $0x19
  8012a3:	e8 6c fd ff ff       	call   801014 <syscall>
  8012a8:	83 c4 18             	add    $0x18,%esp
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	50                   	push   %eax
  8012bc:	6a 1a                	push   $0x1a
  8012be:	e8 51 fd ff ff       	call   801014 <syscall>
  8012c3:	83 c4 18             	add    $0x18,%esp
}
  8012c6:	90                   	nop
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	50                   	push   %eax
  8012d8:	6a 1b                	push   $0x1b
  8012da:	e8 35 fd ff ff       	call   801014 <syscall>
  8012df:	83 c4 18             	add    $0x18,%esp
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 05                	push   $0x5
  8012f3:	e8 1c fd ff ff       	call   801014 <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 06                	push   $0x6
  80130c:	e8 03 fd ff ff       	call   801014 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 07                	push   $0x7
  801325:	e8 ea fc ff ff       	call   801014 <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_exit_env>:


void sys_exit_env(void)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 1c                	push   $0x1c
  80133e:	e8 d1 fc ff ff       	call   801014 <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	90                   	nop
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80134f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801352:	8d 50 04             	lea    0x4(%eax),%edx
  801355:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	52                   	push   %edx
  80135f:	50                   	push   %eax
  801360:	6a 1d                	push   $0x1d
  801362:	e8 ad fc ff ff       	call   801014 <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
	return result;
  80136a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801370:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801373:	89 01                	mov    %eax,(%ecx)
  801375:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	c9                   	leave  
  80137c:	c2 04 00             	ret    $0x4

0080137f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	ff 75 10             	pushl  0x10(%ebp)
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	ff 75 08             	pushl  0x8(%ebp)
  80138f:	6a 13                	push   $0x13
  801391:	e8 7e fc ff ff       	call   801014 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
	return ;
  801399:	90                   	nop
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_rcr2>:
uint32 sys_rcr2()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 1e                	push   $0x1e
  8013ab:	e8 64 fc ff ff       	call   801014 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	50                   	push   %eax
  8013ce:	6a 1f                	push   $0x1f
  8013d0:	e8 3f fc ff ff       	call   801014 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d8:	90                   	nop
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <rsttst>:
void rsttst()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 21                	push   $0x21
  8013ea:	e8 25 fc ff ff       	call   801014 <syscall>
  8013ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8013f2:	90                   	nop
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801401:	8b 55 18             	mov    0x18(%ebp),%edx
  801404:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801408:	52                   	push   %edx
  801409:	50                   	push   %eax
  80140a:	ff 75 10             	pushl  0x10(%ebp)
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	ff 75 08             	pushl  0x8(%ebp)
  801413:	6a 20                	push   $0x20
  801415:	e8 fa fb ff ff       	call   801014 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
	return ;
  80141d:	90                   	nop
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <chktst>:
void chktst(uint32 n)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	ff 75 08             	pushl  0x8(%ebp)
  80142e:	6a 22                	push   $0x22
  801430:	e8 df fb ff ff       	call   801014 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
	return ;
  801438:	90                   	nop
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <inctst>:

void inctst()
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 23                	push   $0x23
  80144a:	e8 c5 fb ff ff       	call   801014 <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
	return ;
  801452:	90                   	nop
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <gettst>:
uint32 gettst()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 24                	push   $0x24
  801464:	e8 ab fb ff ff       	call   801014 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 25                	push   $0x25
  801480:	e8 8f fb ff ff       	call   801014 <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
  801488:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80148b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80148f:	75 07                	jne    801498 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801491:	b8 01 00 00 00       	mov    $0x1,%eax
  801496:	eb 05                	jmp    80149d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 25                	push   $0x25
  8014b1:	e8 5e fb ff ff       	call   801014 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
  8014b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014c0:	75 07                	jne    8014c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c7:	eb 05                	jmp    8014ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 25                	push   $0x25
  8014e2:	e8 2d fb ff ff       	call   801014 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
  8014ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014f1:	75 07                	jne    8014fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f8:	eb 05                	jmp    8014ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 25                	push   $0x25
  801513:	e8 fc fa ff ff       	call   801014 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80151e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801522:	75 07                	jne    80152b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801524:	b8 01 00 00 00       	mov    $0x1,%eax
  801529:	eb 05                	jmp    801530 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	6a 26                	push   $0x26
  801542:	e8 cd fa ff ff       	call   801014 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
	return ;
  80154a:	90                   	nop
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801551:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	53                   	push   %ebx
  801560:	51                   	push   %ecx
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	6a 27                	push   $0x27
  801565:	e8 aa fa ff ff       	call   801014 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	52                   	push   %edx
  801582:	50                   	push   %eax
  801583:	6a 28                	push   $0x28
  801585:	e8 8a fa ff ff       	call   801014 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801592:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801595:	8b 55 0c             	mov    0xc(%ebp),%edx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	6a 00                	push   $0x0
  80159d:	51                   	push   %ecx
  80159e:	ff 75 10             	pushl  0x10(%ebp)
  8015a1:	52                   	push   %edx
  8015a2:	50                   	push   %eax
  8015a3:	6a 29                	push   $0x29
  8015a5:	e8 6a fa ff ff       	call   801014 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	ff 75 10             	pushl  0x10(%ebp)
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	6a 12                	push   $0x12
  8015c1:	e8 4e fa ff ff       	call   801014 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c9:	90                   	nop
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	52                   	push   %edx
  8015dc:	50                   	push   %eax
  8015dd:	6a 2a                	push   $0x2a
  8015df:	e8 30 fa ff ff       	call   801014 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
	return;
  8015e7:	90                   	nop
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	50                   	push   %eax
  8015f9:	6a 2b                	push   $0x2b
  8015fb:	e8 14 fa ff ff       	call   801014 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	ff 75 0c             	pushl  0xc(%ebp)
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	6a 2c                	push   $0x2c
  801616:	e8 f9 f9 ff ff       	call   801014 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
	return;
  80161e:	90                   	nop
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	ff 75 0c             	pushl  0xc(%ebp)
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	6a 2d                	push   $0x2d
  801632:	e8 dd f9 ff ff       	call   801014 <syscall>
  801637:	83 c4 18             	add    $0x18,%esp
	return;
  80163a:	90                   	nop
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 2e                	push   $0x2e
  80164f:	e8 c0 f9 ff ff       	call   801014 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
  801657:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80165a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	50                   	push   %eax
  80166e:	6a 2f                	push   $0x2f
  801670:	e8 9f f9 ff ff       	call   801014 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
	return;
  801678:	90                   	nop
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  80167e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	6a 30                	push   $0x30
  80168e:	e8 81 f9 ff ff       	call   801014 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
	return;
  801696:	90                   	nop
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	50                   	push   %eax
  8016ab:	6a 31                	push   $0x31
  8016ad:	e8 62 f9 ff ff       	call   801014 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
  8016b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	50                   	push   %eax
  8016cc:	6a 32                	push   $0x32
  8016ce:	e8 41 f9 ff ff       	call   801014 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
	return;
  8016d6:	90                   	nop
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016df:	8d 45 10             	lea    0x10(%ebp),%eax
  8016e2:	83 c0 04             	add    $0x4,%eax
  8016e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016e8:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	74 16                	je     801707 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016f1:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	50                   	push   %eax
  8016fa:	68 38 20 80 00       	push   $0x802038
  8016ff:	e8 76 eb ff ff       	call   80027a <cprintf>
  801704:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801707:	a1 00 30 80 00       	mov    0x803000,%eax
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	50                   	push   %eax
  801713:	68 3d 20 80 00       	push   $0x80203d
  801718:	e8 5d eb ff ff       	call   80027a <cprintf>
  80171d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	ff 75 f4             	pushl  -0xc(%ebp)
  801729:	50                   	push   %eax
  80172a:	e8 e0 ea ff ff       	call   80020f <vcprintf>
  80172f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	6a 00                	push   $0x0
  801737:	68 59 20 80 00       	push   $0x802059
  80173c:	e8 ce ea ff ff       	call   80020f <vcprintf>
  801741:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801744:	e8 4f ea ff ff       	call   800198 <exit>

	// should not return here
	while (1) ;
  801749:	eb fe                	jmp    801749 <_panic+0x70>

0080174b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801751:	a1 04 30 80 00       	mov    0x803004,%eax
  801756:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80175c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175f:	39 c2                	cmp    %eax,%edx
  801761:	74 14                	je     801777 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801763:	83 ec 04             	sub    $0x4,%esp
  801766:	68 5c 20 80 00       	push   $0x80205c
  80176b:	6a 26                	push   $0x26
  80176d:	68 a8 20 80 00       	push   $0x8020a8
  801772:	e8 62 ff ff ff       	call   8016d9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80177e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801785:	e9 c5 00 00 00       	jmp    80184f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	85 c0                	test   %eax,%eax
  80179d:	75 08                	jne    8017a7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80179f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8017a2:	e9 a5 00 00 00       	jmp    80184c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8017a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017ae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017b5:	eb 69                	jmp    801820 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8017b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017bc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	01 c0                	add    %eax,%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	c1 e0 03             	shl    $0x3,%eax
  8017ce:	01 c8                	add    %ecx,%eax
  8017d0:	8a 40 04             	mov    0x4(%eax),%al
  8017d3:	84 c0                	test   %al,%al
  8017d5:	75 46                	jne    80181d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017d7:	a1 04 30 80 00       	mov    0x803004,%eax
  8017dc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e5:	89 d0                	mov    %edx,%eax
  8017e7:	01 c0                	add    %eax,%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	c1 e0 03             	shl    $0x3,%eax
  8017ee:	01 c8                	add    %ecx,%eax
  8017f0:	8b 00                	mov    (%eax),%eax
  8017f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017fd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801802:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	01 c8                	add    %ecx,%eax
  80180e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801810:	39 c2                	cmp    %eax,%edx
  801812:	75 09                	jne    80181d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801814:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80181b:	eb 15                	jmp    801832 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80181d:	ff 45 e8             	incl   -0x18(%ebp)
  801820:	a1 04 30 80 00       	mov    0x803004,%eax
  801825:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80182b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182e:	39 c2                	cmp    %eax,%edx
  801830:	77 85                	ja     8017b7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801832:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801836:	75 14                	jne    80184c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	68 b4 20 80 00       	push   $0x8020b4
  801840:	6a 3a                	push   $0x3a
  801842:	68 a8 20 80 00       	push   $0x8020a8
  801847:	e8 8d fe ff ff       	call   8016d9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80184c:	ff 45 f0             	incl   -0x10(%ebp)
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801855:	0f 8c 2f ff ff ff    	jl     80178a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80185b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801869:	eb 26                	jmp    801891 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80186b:	a1 04 30 80 00       	mov    0x803004,%eax
  801870:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801876:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801879:	89 d0                	mov    %edx,%eax
  80187b:	01 c0                	add    %eax,%eax
  80187d:	01 d0                	add    %edx,%eax
  80187f:	c1 e0 03             	shl    $0x3,%eax
  801882:	01 c8                	add    %ecx,%eax
  801884:	8a 40 04             	mov    0x4(%eax),%al
  801887:	3c 01                	cmp    $0x1,%al
  801889:	75 03                	jne    80188e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80188b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80188e:	ff 45 e0             	incl   -0x20(%ebp)
  801891:	a1 04 30 80 00       	mov    0x803004,%eax
  801896:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80189c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189f:	39 c2                	cmp    %eax,%edx
  8018a1:	77 c8                	ja     80186b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018a9:	74 14                	je     8018bf <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 08 21 80 00       	push   $0x802108
  8018b3:	6a 44                	push   $0x44
  8018b5:	68 a8 20 80 00       	push   $0x8020a8
  8018ba:	e8 1a fe ff ff       	call   8016d9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    
  8018c2:	66 90                	xchg   %ax,%ax

008018c4 <__udivdi3>:
  8018c4:	55                   	push   %ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 1c             	sub    $0x1c,%esp
  8018cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018db:	89 ca                	mov    %ecx,%edx
  8018dd:	89 f8                	mov    %edi,%eax
  8018df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018e3:	85 f6                	test   %esi,%esi
  8018e5:	75 2d                	jne    801914 <__udivdi3+0x50>
  8018e7:	39 cf                	cmp    %ecx,%edi
  8018e9:	77 65                	ja     801950 <__udivdi3+0x8c>
  8018eb:	89 fd                	mov    %edi,%ebp
  8018ed:	85 ff                	test   %edi,%edi
  8018ef:	75 0b                	jne    8018fc <__udivdi3+0x38>
  8018f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f6:	31 d2                	xor    %edx,%edx
  8018f8:	f7 f7                	div    %edi
  8018fa:	89 c5                	mov    %eax,%ebp
  8018fc:	31 d2                	xor    %edx,%edx
  8018fe:	89 c8                	mov    %ecx,%eax
  801900:	f7 f5                	div    %ebp
  801902:	89 c1                	mov    %eax,%ecx
  801904:	89 d8                	mov    %ebx,%eax
  801906:	f7 f5                	div    %ebp
  801908:	89 cf                	mov    %ecx,%edi
  80190a:	89 fa                	mov    %edi,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	39 ce                	cmp    %ecx,%esi
  801916:	77 28                	ja     801940 <__udivdi3+0x7c>
  801918:	0f bd fe             	bsr    %esi,%edi
  80191b:	83 f7 1f             	xor    $0x1f,%edi
  80191e:	75 40                	jne    801960 <__udivdi3+0x9c>
  801920:	39 ce                	cmp    %ecx,%esi
  801922:	72 0a                	jb     80192e <__udivdi3+0x6a>
  801924:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801928:	0f 87 9e 00 00 00    	ja     8019cc <__udivdi3+0x108>
  80192e:	b8 01 00 00 00       	mov    $0x1,%eax
  801933:	89 fa                	mov    %edi,%edx
  801935:	83 c4 1c             	add    $0x1c,%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5f                   	pop    %edi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    
  80193d:	8d 76 00             	lea    0x0(%esi),%esi
  801940:	31 ff                	xor    %edi,%edi
  801942:	31 c0                	xor    %eax,%eax
  801944:	89 fa                	mov    %edi,%edx
  801946:	83 c4 1c             	add    $0x1c,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5f                   	pop    %edi
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    
  80194e:	66 90                	xchg   %ax,%ax
  801950:	89 d8                	mov    %ebx,%eax
  801952:	f7 f7                	div    %edi
  801954:	31 ff                	xor    %edi,%edi
  801956:	89 fa                	mov    %edi,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	bd 20 00 00 00       	mov    $0x20,%ebp
  801965:	89 eb                	mov    %ebp,%ebx
  801967:	29 fb                	sub    %edi,%ebx
  801969:	89 f9                	mov    %edi,%ecx
  80196b:	d3 e6                	shl    %cl,%esi
  80196d:	89 c5                	mov    %eax,%ebp
  80196f:	88 d9                	mov    %bl,%cl
  801971:	d3 ed                	shr    %cl,%ebp
  801973:	89 e9                	mov    %ebp,%ecx
  801975:	09 f1                	or     %esi,%ecx
  801977:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80197b:	89 f9                	mov    %edi,%ecx
  80197d:	d3 e0                	shl    %cl,%eax
  80197f:	89 c5                	mov    %eax,%ebp
  801981:	89 d6                	mov    %edx,%esi
  801983:	88 d9                	mov    %bl,%cl
  801985:	d3 ee                	shr    %cl,%esi
  801987:	89 f9                	mov    %edi,%ecx
  801989:	d3 e2                	shl    %cl,%edx
  80198b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80198f:	88 d9                	mov    %bl,%cl
  801991:	d3 e8                	shr    %cl,%eax
  801993:	09 c2                	or     %eax,%edx
  801995:	89 d0                	mov    %edx,%eax
  801997:	89 f2                	mov    %esi,%edx
  801999:	f7 74 24 0c          	divl   0xc(%esp)
  80199d:	89 d6                	mov    %edx,%esi
  80199f:	89 c3                	mov    %eax,%ebx
  8019a1:	f7 e5                	mul    %ebp
  8019a3:	39 d6                	cmp    %edx,%esi
  8019a5:	72 19                	jb     8019c0 <__udivdi3+0xfc>
  8019a7:	74 0b                	je     8019b4 <__udivdi3+0xf0>
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	31 ff                	xor    %edi,%edi
  8019ad:	e9 58 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019b8:	89 f9                	mov    %edi,%ecx
  8019ba:	d3 e2                	shl    %cl,%edx
  8019bc:	39 c2                	cmp    %eax,%edx
  8019be:	73 e9                	jae    8019a9 <__udivdi3+0xe5>
  8019c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019c3:	31 ff                	xor    %edi,%edi
  8019c5:	e9 40 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019ca:	66 90                	xchg   %ax,%ax
  8019cc:	31 c0                	xor    %eax,%eax
  8019ce:	e9 37 ff ff ff       	jmp    80190a <__udivdi3+0x46>
  8019d3:	90                   	nop

008019d4 <__umoddi3>:
  8019d4:	55                   	push   %ebp
  8019d5:	57                   	push   %edi
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f3:	89 f3                	mov    %esi,%ebx
  8019f5:	89 fa                	mov    %edi,%edx
  8019f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fb:	89 34 24             	mov    %esi,(%esp)
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	75 1a                	jne    801a1c <__umoddi3+0x48>
  801a02:	39 f7                	cmp    %esi,%edi
  801a04:	0f 86 a2 00 00 00    	jbe    801aac <__umoddi3+0xd8>
  801a0a:	89 c8                	mov    %ecx,%eax
  801a0c:	89 f2                	mov    %esi,%edx
  801a0e:	f7 f7                	div    %edi
  801a10:	89 d0                	mov    %edx,%eax
  801a12:	31 d2                	xor    %edx,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 f0                	cmp    %esi,%eax
  801a1e:	0f 87 ac 00 00 00    	ja     801ad0 <__umoddi3+0xfc>
  801a24:	0f bd e8             	bsr    %eax,%ebp
  801a27:	83 f5 1f             	xor    $0x1f,%ebp
  801a2a:	0f 84 ac 00 00 00    	je     801adc <__umoddi3+0x108>
  801a30:	bf 20 00 00 00       	mov    $0x20,%edi
  801a35:	29 ef                	sub    %ebp,%edi
  801a37:	89 fe                	mov    %edi,%esi
  801a39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a3d:	89 e9                	mov    %ebp,%ecx
  801a3f:	d3 e0                	shl    %cl,%eax
  801a41:	89 d7                	mov    %edx,%edi
  801a43:	89 f1                	mov    %esi,%ecx
  801a45:	d3 ef                	shr    %cl,%edi
  801a47:	09 c7                	or     %eax,%edi
  801a49:	89 e9                	mov    %ebp,%ecx
  801a4b:	d3 e2                	shl    %cl,%edx
  801a4d:	89 14 24             	mov    %edx,(%esp)
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	d3 e0                	shl    %cl,%eax
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5a:	d3 e0                	shl    %cl,%eax
  801a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a60:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a64:	89 f1                	mov    %esi,%ecx
  801a66:	d3 e8                	shr    %cl,%eax
  801a68:	09 d0                	or     %edx,%eax
  801a6a:	d3 eb                	shr    %cl,%ebx
  801a6c:	89 da                	mov    %ebx,%edx
  801a6e:	f7 f7                	div    %edi
  801a70:	89 d3                	mov    %edx,%ebx
  801a72:	f7 24 24             	mull   (%esp)
  801a75:	89 c6                	mov    %eax,%esi
  801a77:	89 d1                	mov    %edx,%ecx
  801a79:	39 d3                	cmp    %edx,%ebx
  801a7b:	0f 82 87 00 00 00    	jb     801b08 <__umoddi3+0x134>
  801a81:	0f 84 91 00 00 00    	je     801b18 <__umoddi3+0x144>
  801a87:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a8b:	29 f2                	sub    %esi,%edx
  801a8d:	19 cb                	sbb    %ecx,%ebx
  801a8f:	89 d8                	mov    %ebx,%eax
  801a91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 e9                	mov    %ebp,%ecx
  801a99:	d3 ea                	shr    %cl,%edx
  801a9b:	09 d0                	or     %edx,%eax
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 eb                	shr    %cl,%ebx
  801aa1:	89 da                	mov    %ebx,%edx
  801aa3:	83 c4 1c             	add    $0x1c,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5f                   	pop    %edi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    
  801aab:	90                   	nop
  801aac:	89 fd                	mov    %edi,%ebp
  801aae:	85 ff                	test   %edi,%edi
  801ab0:	75 0b                	jne    801abd <__umoddi3+0xe9>
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	31 d2                	xor    %edx,%edx
  801ab9:	f7 f7                	div    %edi
  801abb:	89 c5                	mov    %eax,%ebp
  801abd:	89 f0                	mov    %esi,%eax
  801abf:	31 d2                	xor    %edx,%edx
  801ac1:	f7 f5                	div    %ebp
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	f7 f5                	div    %ebp
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	e9 44 ff ff ff       	jmp    801a12 <__umoddi3+0x3e>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	89 c8                	mov    %ecx,%eax
  801ad2:	89 f2                	mov    %esi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	3b 04 24             	cmp    (%esp),%eax
  801adf:	72 06                	jb     801ae7 <__umoddi3+0x113>
  801ae1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ae5:	77 0f                	ja     801af6 <__umoddi3+0x122>
  801ae7:	89 f2                	mov    %esi,%edx
  801ae9:	29 f9                	sub    %edi,%ecx
  801aeb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801aef:	89 14 24             	mov    %edx,(%esp)
  801af2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801afa:	8b 14 24             	mov    (%esp),%edx
  801afd:	83 c4 1c             	add    $0x1c,%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5f                   	pop    %edi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    
  801b05:	8d 76 00             	lea    0x0(%esi),%esi
  801b08:	2b 04 24             	sub    (%esp),%eax
  801b0b:	19 fa                	sbb    %edi,%edx
  801b0d:	89 d1                	mov    %edx,%ecx
  801b0f:	89 c6                	mov    %eax,%esi
  801b11:	e9 71 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
  801b16:	66 90                	xchg   %ax,%ax
  801b18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b1c:	72 ea                	jb     801b08 <__umoddi3+0x134>
  801b1e:	89 d9                	mov    %ebx,%ecx
  801b20:	e9 62 ff ff ff       	jmp    801a87 <__umoddi3+0xb3>
