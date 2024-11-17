
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
  800041:	68 80 1a 80 00       	push   $0x801a80
  800046:	e8 3e 02 00 00       	call   800289 <atomic_cprintf>
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
  800057:	e8 83 12 00 00       	call   8012df <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 02             	shl    $0x2,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 02             	shl    $0x2,%eax
  800070:	01 d0                	add    %edx,%eax
  800072:	01 c0                	add    %eax,%eax
  800074:	01 d0                	add    %edx,%eax
  800076:	c1 e0 04             	shl    $0x4,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800083:	a1 20 30 80 00       	mov    0x803020,%eax
  800088:	8a 40 20             	mov    0x20(%eax),%al
  80008b:	84 c0                	test   %al,%al
  80008d:	74 0d                	je     80009c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80008f:	a1 20 30 80 00       	mov    0x803020,%eax
  800094:	83 c0 20             	add    $0x20,%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x5b>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	ff 75 0c             	pushl  0xc(%ebp)
  8000b2:	ff 75 08             	pushl  0x8(%ebp)
  8000b5:	e8 7e ff ff ff       	call   800038 <_main>
  8000ba:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000bd:	e8 a1 0f 00 00       	call   801063 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 c4 1a 80 00       	push   $0x801ac4
  8000ca:	e8 8d 01 00 00       	call   80025c <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	52                   	push   %edx
  8000ec:	50                   	push   %eax
  8000ed:	68 ec 1a 80 00       	push   $0x801aec
  8000f2:	e8 65 01 00 00       	call   80025c <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ff:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800105:	a1 20 30 80 00       	mov    0x803020,%eax
  80010a:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80011b:	51                   	push   %ecx
  80011c:	52                   	push   %edx
  80011d:	50                   	push   %eax
  80011e:	68 14 1b 80 00       	push   $0x801b14
  800123:	e8 34 01 00 00       	call   80025c <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80012b:	a1 20 30 80 00       	mov    0x803020,%eax
  800130:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	50                   	push   %eax
  80013a:	68 6c 1b 80 00       	push   $0x801b6c
  80013f:	e8 18 01 00 00       	call   80025c <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 c4 1a 80 00       	push   $0x801ac4
  80014f:	e8 08 01 00 00       	call   80025c <cprintf>
  800154:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800157:	e8 21 0f 00 00       	call   80107d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80015c:	e8 19 00 00 00       	call   80017a <exit>
}
  800161:	90                   	nop
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 00                	push   $0x0
  80016f:	e8 37 11 00 00       	call   8012ab <sys_destroy_env>
  800174:	83 c4 10             	add    $0x10,%esp
}
  800177:	90                   	nop
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <exit>:

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800180:	e8 8c 11 00 00       	call   801311 <sys_exit_env>
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	8d 48 01             	lea    0x1(%eax),%ecx
  800196:	8b 55 0c             	mov    0xc(%ebp),%edx
  800199:	89 0a                	mov    %ecx,(%edx)
  80019b:	8b 55 08             	mov    0x8(%ebp),%edx
  80019e:	88 d1                	mov    %dl,%cl
  8001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001aa:	8b 00                	mov    (%eax),%eax
  8001ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b1:	75 2c                	jne    8001df <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001b3:	a0 c0 68 81 00       	mov    0x8168c0,%al
  8001b8:	0f b6 c0             	movzbl %al,%eax
  8001bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001be:	8b 12                	mov    (%edx),%edx
  8001c0:	89 d1                	mov    %edx,%ecx
  8001c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c5:	83 c2 08             	add    $0x8,%edx
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	50                   	push   %eax
  8001cc:	51                   	push   %ecx
  8001cd:	52                   	push   %edx
  8001ce:	e8 4e 0e 00 00       	call   801021 <sys_cputs>
  8001d3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e2:	8b 40 04             	mov    0x4(%eax),%eax
  8001e5:	8d 50 01             	lea    0x1(%eax),%edx
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001ee:	90                   	nop
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800201:	00 00 00 
	b.cnt = 0;
  800204:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021a:	50                   	push   %eax
  80021b:	68 88 01 80 00       	push   $0x800188
  800220:	e8 11 02 00 00       	call   800436 <vprintfmt>
  800225:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800228:	a0 c0 68 81 00       	mov    0x8168c0,%al
  80022d:	0f b6 c0             	movzbl %al,%eax
  800230:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	50                   	push   %eax
  80023a:	52                   	push   %edx
  80023b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800241:	83 c0 08             	add    $0x8,%eax
  800244:	50                   	push   %eax
  800245:	e8 d7 0d 00 00       	call   801021 <sys_cputs>
  80024a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80024d:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
	return b.cnt;
  800254:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    

0080025c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800262:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
	va_start(ap, fmt);
  800269:	8d 45 0c             	lea    0xc(%ebp),%eax
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	ff 75 f4             	pushl  -0xc(%ebp)
  800278:	50                   	push   %eax
  800279:	e8 73 ff ff ff       	call   8001f1 <vcprintf>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800284:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80028f:	e8 cf 0d 00 00       	call   801063 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800294:	8d 45 0c             	lea    0xc(%ebp),%eax
  800297:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a3:	50                   	push   %eax
  8002a4:	e8 48 ff ff ff       	call   8001f1 <vcprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002af:	e8 c9 0d 00 00       	call   80107d <sys_unlock_cons>
	return cnt;
  8002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	53                   	push   %ebx
  8002bd:	83 ec 14             	sub    $0x14,%esp
  8002c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8002cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002d7:	77 55                	ja     80032e <printnum+0x75>
  8002d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002dc:	72 05                	jb     8002e3 <printnum+0x2a>
  8002de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e1:	77 4b                	ja     80032e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002e6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f1:	52                   	push   %edx
  8002f2:	50                   	push   %eax
  8002f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8002f9:	e8 0a 15 00 00       	call   801808 <__udivdi3>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	ff 75 20             	pushl  0x20(%ebp)
  800307:	53                   	push   %ebx
  800308:	ff 75 18             	pushl  0x18(%ebp)
  80030b:	52                   	push   %edx
  80030c:	50                   	push   %eax
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	e8 a1 ff ff ff       	call   8002b9 <printnum>
  800318:	83 c4 20             	add    $0x20,%esp
  80031b:	eb 1a                	jmp    800337 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 20             	pushl  0x20(%ebp)
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	ff d0                	call   *%eax
  80032b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032e:	ff 4d 1c             	decl   0x1c(%ebp)
  800331:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800335:	7f e6                	jg     80031d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800337:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800345:	53                   	push   %ebx
  800346:	51                   	push   %ecx
  800347:	52                   	push   %edx
  800348:	50                   	push   %eax
  800349:	e8 ca 15 00 00       	call   801918 <__umoddi3>
  80034e:	83 c4 10             	add    $0x10,%esp
  800351:	05 94 1d 80 00       	add    $0x801d94,%eax
  800356:	8a 00                	mov    (%eax),%al
  800358:	0f be c0             	movsbl %al,%eax
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	50                   	push   %eax
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	ff d0                	call   *%eax
  800367:	83 c4 10             	add    $0x10,%esp
}
  80036a:	90                   	nop
  80036b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800373:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800377:	7e 1c                	jle    800395 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	8d 50 08             	lea    0x8(%eax),%edx
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 10                	mov    %edx,(%eax)
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	83 e8 08             	sub    $0x8,%eax
  80038e:	8b 50 04             	mov    0x4(%eax),%edx
  800391:	8b 00                	mov    (%eax),%eax
  800393:	eb 40                	jmp    8003d5 <getuint+0x65>
	else if (lflag)
  800395:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800399:	74 1e                	je     8003b9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	8d 50 04             	lea    0x4(%eax),%edx
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	89 10                	mov    %edx,(%eax)
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	83 e8 04             	sub    $0x4,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	eb 1c                	jmp    8003d5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
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
}
  8003d5:	5d                   	pop    %ebp
  8003d6:	c3                   	ret    

008003d7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003de:	7e 1c                	jle    8003fc <getint+0x25>
		return va_arg(*ap, long long);
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	8d 50 08             	lea    0x8(%eax),%edx
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	89 10                	mov    %edx,(%eax)
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 e8 08             	sub    $0x8,%eax
  8003f5:	8b 50 04             	mov    0x4(%eax),%edx
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	eb 38                	jmp    800434 <getint+0x5d>
	else if (lflag)
  8003fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800400:	74 1a                	je     80041c <getint+0x45>
		return va_arg(*ap, long);
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	8d 50 04             	lea    0x4(%eax),%edx
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 10                	mov    %edx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	83 e8 04             	sub    $0x4,%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	99                   	cltd   
  80041a:	eb 18                	jmp    800434 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	8d 50 04             	lea    0x4(%eax),%edx
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 10                	mov    %edx,(%eax)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	83 e8 04             	sub    $0x4,%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	99                   	cltd   
}
  800434:	5d                   	pop    %ebp
  800435:	c3                   	ret    

00800436 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	56                   	push   %esi
  80043a:	53                   	push   %ebx
  80043b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80043e:	eb 17                	jmp    800457 <vprintfmt+0x21>
			if (ch == '\0')
  800440:	85 db                	test   %ebx,%ebx
  800442:	0f 84 c1 03 00 00    	je     800809 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	ff 75 0c             	pushl  0xc(%ebp)
  80044e:	53                   	push   %ebx
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	ff d0                	call   *%eax
  800454:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800457:	8b 45 10             	mov    0x10(%ebp),%eax
  80045a:	8d 50 01             	lea    0x1(%eax),%edx
  80045d:	89 55 10             	mov    %edx,0x10(%ebp)
  800460:	8a 00                	mov    (%eax),%al
  800462:	0f b6 d8             	movzbl %al,%ebx
  800465:	83 fb 25             	cmp    $0x25,%ebx
  800468:	75 d6                	jne    800440 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80046a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80046e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800475:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80047c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800483:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 45 10             	mov    0x10(%ebp),%eax
  80048d:	8d 50 01             	lea    0x1(%eax),%edx
  800490:	89 55 10             	mov    %edx,0x10(%ebp)
  800493:	8a 00                	mov    (%eax),%al
  800495:	0f b6 d8             	movzbl %al,%ebx
  800498:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80049b:	83 f8 5b             	cmp    $0x5b,%eax
  80049e:	0f 87 3d 03 00 00    	ja     8007e1 <vprintfmt+0x3ab>
  8004a4:	8b 04 85 b8 1d 80 00 	mov    0x801db8(,%eax,4),%eax
  8004ab:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b1:	eb d7                	jmp    80048a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004b7:	eb d1                	jmp    80048a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c3:	89 d0                	mov    %edx,%eax
  8004c5:	c1 e0 02             	shl    $0x2,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	01 c0                	add    %eax,%eax
  8004cc:	01 d8                	add    %ebx,%eax
  8004ce:	83 e8 30             	sub    $0x30,%eax
  8004d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d7:	8a 00                	mov    (%eax),%al
  8004d9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004dc:	83 fb 2f             	cmp    $0x2f,%ebx
  8004df:	7e 3e                	jle    80051f <vprintfmt+0xe9>
  8004e1:	83 fb 39             	cmp    $0x39,%ebx
  8004e4:	7f 39                	jg     80051f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e9:	eb d5                	jmp    8004c0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	83 c0 04             	add    $0x4,%eax
  8004f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	83 e8 04             	sub    $0x4,%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8004ff:	eb 1f                	jmp    800520 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800501:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800505:	79 83                	jns    80048a <vprintfmt+0x54>
				width = 0;
  800507:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80050e:	e9 77 ff ff ff       	jmp    80048a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800513:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051a:	e9 6b ff ff ff       	jmp    80048a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80051f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800524:	0f 89 60 ff ff ff    	jns    80048a <vprintfmt+0x54>
				width = precision, precision = -1;
  80052a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800530:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800537:	e9 4e ff ff ff       	jmp    80048a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80053f:	e9 46 ff ff ff       	jmp    80048a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	83 c0 04             	add    $0x4,%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	83 e8 04             	sub    $0x4,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 0c             	pushl  0xc(%ebp)
  80055b:	50                   	push   %eax
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	ff d0                	call   *%eax
  800561:	83 c4 10             	add    $0x10,%esp
			break;
  800564:	e9 9b 02 00 00       	jmp    800804 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	83 e8 04             	sub    $0x4,%eax
  800578:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80057a:	85 db                	test   %ebx,%ebx
  80057c:	79 02                	jns    800580 <vprintfmt+0x14a>
				err = -err;
  80057e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 fb 64             	cmp    $0x64,%ebx
  800583:	7f 0b                	jg     800590 <vprintfmt+0x15a>
  800585:	8b 34 9d 00 1c 80 00 	mov    0x801c00(,%ebx,4),%esi
  80058c:	85 f6                	test   %esi,%esi
  80058e:	75 19                	jne    8005a9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800590:	53                   	push   %ebx
  800591:	68 a5 1d 80 00       	push   $0x801da5
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	ff 75 08             	pushl  0x8(%ebp)
  80059c:	e8 70 02 00 00       	call   800811 <printfmt>
  8005a1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005a4:	e9 5b 02 00 00       	jmp    800804 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005a9:	56                   	push   %esi
  8005aa:	68 ae 1d 80 00       	push   $0x801dae
  8005af:	ff 75 0c             	pushl  0xc(%ebp)
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 57 02 00 00       	call   800811 <printfmt>
  8005ba:	83 c4 10             	add    $0x10,%esp
			break;
  8005bd:	e9 42 02 00 00       	jmp    800804 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	83 c0 04             	add    $0x4,%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 e8 04             	sub    $0x4,%eax
  8005d1:	8b 30                	mov    (%eax),%esi
  8005d3:	85 f6                	test   %esi,%esi
  8005d5:	75 05                	jne    8005dc <vprintfmt+0x1a6>
				p = "(null)";
  8005d7:	be b1 1d 80 00       	mov    $0x801db1,%esi
			if (width > 0 && padc != '-')
  8005dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e0:	7e 6d                	jle    80064f <vprintfmt+0x219>
  8005e2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005e6:	74 67                	je     80064f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	50                   	push   %eax
  8005ef:	56                   	push   %esi
  8005f0:	e8 1e 03 00 00       	call   800913 <strnlen>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8005fb:	eb 16                	jmp    800613 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8005fd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	50                   	push   %eax
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	ff d0                	call   *%eax
  80060d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800610:	ff 4d e4             	decl   -0x1c(%ebp)
  800613:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800617:	7f e4                	jg     8005fd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800619:	eb 34                	jmp    80064f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061f:	74 1c                	je     80063d <vprintfmt+0x207>
  800621:	83 fb 1f             	cmp    $0x1f,%ebx
  800624:	7e 05                	jle    80062b <vprintfmt+0x1f5>
  800626:	83 fb 7e             	cmp    $0x7e,%ebx
  800629:	7e 12                	jle    80063d <vprintfmt+0x207>
					putch('?', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	6a 3f                	push   $0x3f
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
  80063b:	eb 0f                	jmp    80064c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	53                   	push   %ebx
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064c:	ff 4d e4             	decl   -0x1c(%ebp)
  80064f:	89 f0                	mov    %esi,%eax
  800651:	8d 70 01             	lea    0x1(%eax),%esi
  800654:	8a 00                	mov    (%eax),%al
  800656:	0f be d8             	movsbl %al,%ebx
  800659:	85 db                	test   %ebx,%ebx
  80065b:	74 24                	je     800681 <vprintfmt+0x24b>
  80065d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800661:	78 b8                	js     80061b <vprintfmt+0x1e5>
  800663:	ff 4d e0             	decl   -0x20(%ebp)
  800666:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066a:	79 af                	jns    80061b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066c:	eb 13                	jmp    800681 <vprintfmt+0x24b>
				putch(' ', putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	ff 75 0c             	pushl  0xc(%ebp)
  800674:	6a 20                	push   $0x20
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	ff d0                	call   *%eax
  80067b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067e:	ff 4d e4             	decl   -0x1c(%ebp)
  800681:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800685:	7f e7                	jg     80066e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800687:	e9 78 01 00 00       	jmp    800804 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	ff 75 e8             	pushl  -0x18(%ebp)
  800692:	8d 45 14             	lea    0x14(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 3c fd ff ff       	call   8003d7 <getint>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006aa:	85 d2                	test   %edx,%edx
  8006ac:	79 23                	jns    8006d1 <vprintfmt+0x29b>
				putch('-', putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	ff 75 0c             	pushl  0xc(%ebp)
  8006b4:	6a 2d                	push   $0x2d
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	ff d0                	call   *%eax
  8006bb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c4:	f7 d8                	neg    %eax
  8006c6:	83 d2 00             	adc    $0x0,%edx
  8006c9:	f7 da                	neg    %edx
  8006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006d8:	e9 bc 00 00 00       	jmp    800799 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e6:	50                   	push   %eax
  8006e7:	e8 84 fc ff ff       	call   800370 <getuint>
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006fc:	e9 98 00 00 00       	jmp    800799 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	6a 58                	push   $0x58
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	6a 58                	push   $0x58
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	ff d0                	call   *%eax
  80071e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	6a 58                	push   $0x58
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
			break;
  800731:	e9 ce 00 00 00       	jmp    800804 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	6a 30                	push   $0x30
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	ff d0                	call   *%eax
  800743:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 78                	push   $0x78
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	83 c0 04             	add    $0x4,%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	83 e8 04             	sub    $0x4,%eax
  800765:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800771:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800778:	eb 1f                	jmp    800799 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 e8             	pushl  -0x18(%ebp)
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	e8 e7 fb ff ff       	call   800370 <getuint>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800792:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800799:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80079d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a0:	83 ec 04             	sub    $0x4,%esp
  8007a3:	52                   	push   %edx
  8007a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007a7:	50                   	push   %eax
  8007a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 00 fb ff ff       	call   8002b9 <printnum>
  8007b9:	83 c4 20             	add    $0x20,%esp
			break;
  8007bc:	eb 46                	jmp    800804 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	53                   	push   %ebx
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
			break;
  8007cd:	eb 35                	jmp    800804 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007cf:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
			break;
  8007d6:	eb 2c                	jmp    800804 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007d8:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
			break;
  8007df:	eb 23                	jmp    800804 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	6a 25                	push   $0x25
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f1:	ff 4d 10             	decl   0x10(%ebp)
  8007f4:	eb 03                	jmp    8007f9 <vprintfmt+0x3c3>
  8007f6:	ff 4d 10             	decl   0x10(%ebp)
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	48                   	dec    %eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	3c 25                	cmp    $0x25,%al
  800801:	75 f3                	jne    8007f6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800803:	90                   	nop
		}
	}
  800804:	e9 35 fc ff ff       	jmp    80043e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800809:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80080a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5d                   	pop    %ebp
  800810:	c3                   	ret    

00800811 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800811:	55                   	push   %ebp
  800812:	89 e5                	mov    %esp,%ebp
  800814:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800817:	8d 45 10             	lea    0x10(%ebp),%eax
  80081a:	83 c0 04             	add    $0x4,%eax
  80081d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	ff 75 f4             	pushl  -0xc(%ebp)
  800826:	50                   	push   %eax
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	ff 75 08             	pushl  0x8(%ebp)
  80082d:	e8 04 fc ff ff       	call   800436 <vprintfmt>
  800832:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800835:	90                   	nop
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083e:	8b 40 08             	mov    0x8(%eax),%eax
  800841:	8d 50 01             	lea    0x1(%eax),%edx
  800844:	8b 45 0c             	mov    0xc(%ebp),%eax
  800847:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084d:	8b 10                	mov    (%eax),%edx
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	8b 40 04             	mov    0x4(%eax),%eax
  800855:	39 c2                	cmp    %eax,%edx
  800857:	73 12                	jae    80086b <sprintputch+0x33>
		*b->buf++ = ch;
  800859:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	8d 48 01             	lea    0x1(%eax),%ecx
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
  800864:	89 0a                	mov    %ecx,(%edx)
  800866:	8b 55 08             	mov    0x8(%ebp),%edx
  800869:	88 10                	mov    %dl,(%eax)
}
  80086b:	90                   	nop
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	01 d0                	add    %edx,%eax
  800885:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800893:	74 06                	je     80089b <vsnprintf+0x2d>
  800895:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800899:	7f 07                	jg     8008a2 <vsnprintf+0x34>
		return -E_INVAL;
  80089b:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a0:	eb 20                	jmp    8008c2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a2:	ff 75 14             	pushl  0x14(%ebp)
  8008a5:	ff 75 10             	pushl  0x10(%ebp)
  8008a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ab:	50                   	push   %eax
  8008ac:	68 38 08 80 00       	push   $0x800838
  8008b1:	e8 80 fb ff ff       	call   800436 <vprintfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cd:	83 c0 04             	add    $0x4,%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 89 ff ff ff       	call   80086e <vsnprintf>
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008fd:	eb 06                	jmp    800905 <strlen+0x15>
		n++;
  8008ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800902:	ff 45 08             	incl   0x8(%ebp)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8a 00                	mov    (%eax),%al
  80090a:	84 c0                	test   %al,%al
  80090c:	75 f1                	jne    8008ff <strlen+0xf>
		n++;
	return n;
  80090e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800911:	c9                   	leave  
  800912:	c3                   	ret    

00800913 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800919:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800920:	eb 09                	jmp    80092b <strnlen+0x18>
		n++;
  800922:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	ff 45 08             	incl   0x8(%ebp)
  800928:	ff 4d 0c             	decl   0xc(%ebp)
  80092b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092f:	74 09                	je     80093a <strnlen+0x27>
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8a 00                	mov    (%eax),%al
  800936:	84 c0                	test   %al,%al
  800938:	75 e8                	jne    800922 <strnlen+0xf>
		n++;
	return n;
  80093a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80093d:	c9                   	leave  
  80093e:	c3                   	ret    

0080093f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80094b:	90                   	nop
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	89 55 08             	mov    %edx,0x8(%ebp)
  800955:	8b 55 0c             	mov    0xc(%ebp),%edx
  800958:	8d 4a 01             	lea    0x1(%edx),%ecx
  80095b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80095e:	8a 12                	mov    (%edx),%dl
  800960:	88 10                	mov    %dl,(%eax)
  800962:	8a 00                	mov    (%eax),%al
  800964:	84 c0                	test   %al,%al
  800966:	75 e4                	jne    80094c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800968:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800980:	eb 1f                	jmp    8009a1 <strncpy+0x34>
		*dst++ = *src;
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8d 50 01             	lea    0x1(%eax),%edx
  800988:	89 55 08             	mov    %edx,0x8(%ebp)
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098e:	8a 12                	mov    (%edx),%dl
  800990:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800992:	8b 45 0c             	mov    0xc(%ebp),%eax
  800995:	8a 00                	mov    (%eax),%al
  800997:	84 c0                	test   %al,%al
  800999:	74 03                	je     80099e <strncpy+0x31>
			src++;
  80099b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099e:	ff 45 fc             	incl   -0x4(%ebp)
  8009a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009a7:	72 d9                	jb     800982 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009be:	74 30                	je     8009f0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c0:	eb 16                	jmp    8009d8 <strlcpy+0x2a>
			*dst++ = *src++;
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8d 50 01             	lea    0x1(%eax),%edx
  8009c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009d4:	8a 12                	mov    (%edx),%dl
  8009d6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d8:	ff 4d 10             	decl   0x10(%ebp)
  8009db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009df:	74 09                	je     8009ea <strlcpy+0x3c>
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	8a 00                	mov    (%eax),%al
  8009e6:	84 c0                	test   %al,%al
  8009e8:	75 d8                	jne    8009c2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009f6:	29 c2                	sub    %eax,%edx
  8009f8:	89 d0                	mov    %edx,%eax
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009ff:	eb 06                	jmp    800a07 <strcmp+0xb>
		p++, q++;
  800a01:	ff 45 08             	incl   0x8(%ebp)
  800a04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8a 00                	mov    (%eax),%al
  800a0c:	84 c0                	test   %al,%al
  800a0e:	74 0e                	je     800a1e <strcmp+0x22>
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8a 10                	mov    (%eax),%dl
  800a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a18:	8a 00                	mov    (%eax),%al
  800a1a:	38 c2                	cmp    %al,%dl
  800a1c:	74 e3                	je     800a01 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f b6 d0             	movzbl %al,%edx
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	0f b6 c0             	movzbl %al,%eax
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	89 d0                	mov    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a37:	eb 09                	jmp    800a42 <strncmp+0xe>
		n--, p++, q++;
  800a39:	ff 4d 10             	decl   0x10(%ebp)
  800a3c:	ff 45 08             	incl   0x8(%ebp)
  800a3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a46:	74 17                	je     800a5f <strncmp+0x2b>
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	84 c0                	test   %al,%al
  800a4f:	74 0e                	je     800a5f <strncmp+0x2b>
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8a 10                	mov    (%eax),%dl
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8a 00                	mov    (%eax),%al
  800a5b:	38 c2                	cmp    %al,%dl
  800a5d:	74 da                	je     800a39 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a63:	75 07                	jne    800a6c <strncmp+0x38>
		return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6a:	eb 14                	jmp    800a80 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	0f b6 d0             	movzbl %al,%edx
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	0f b6 c0             	movzbl %al,%eax
  800a7c:	29 c2                	sub    %eax,%edx
  800a7e:	89 d0                	mov    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 04             	sub    $0x4,%esp
  800a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a8e:	eb 12                	jmp    800aa2 <strchr+0x20>
		if (*s == c)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a98:	75 05                	jne    800a9f <strchr+0x1d>
			return (char *) s;
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	eb 11                	jmp    800ab0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9f:	ff 45 08             	incl   0x8(%ebp)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	84 c0                	test   %al,%al
  800aa9:	75 e5                	jne    800a90 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800abe:	eb 0d                	jmp    800acd <strfind+0x1b>
		if (*s == c)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ac8:	74 0e                	je     800ad8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aca:	ff 45 08             	incl   0x8(%ebp)
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8a 00                	mov    (%eax),%al
  800ad2:	84 c0                	test   %al,%al
  800ad4:	75 ea                	jne    800ac0 <strfind+0xe>
  800ad6:	eb 01                	jmp    800ad9 <strfind+0x27>
		if (*s == c)
			break;
  800ad8:	90                   	nop
	return (char *) s;
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800aea:	8b 45 10             	mov    0x10(%ebp),%eax
  800aed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af0:	eb 0e                	jmp    800b00 <memset+0x22>
		*p++ = c;
  800af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af5:	8d 50 01             	lea    0x1(%eax),%edx
  800af8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afe:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b00:	ff 4d f8             	decl   -0x8(%ebp)
  800b03:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b07:	79 e9                	jns    800af2 <memset+0x14>
		*p++ = c;

	return v;
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b20:	eb 16                	jmp    800b38 <memcpy+0x2a>
		*d++ = *s++;
  800b22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b25:	8d 50 01             	lea    0x1(%eax),%edx
  800b28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b31:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b34:	8a 12                	mov    (%edx),%dl
  800b36:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b38:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b41:	85 c0                	test   %eax,%eax
  800b43:	75 dd                	jne    800b22 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b62:	73 50                	jae    800bb4 <memmove+0x6a>
  800b64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	01 d0                	add    %edx,%eax
  800b6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6f:	76 43                	jbe    800bb4 <memmove+0x6a>
		s += n;
  800b71:	8b 45 10             	mov    0x10(%ebp),%eax
  800b74:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b77:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b7d:	eb 10                	jmp    800b8f <memmove+0x45>
			*--d = *--s;
  800b7f:	ff 4d f8             	decl   -0x8(%ebp)
  800b82:	ff 4d fc             	decl   -0x4(%ebp)
  800b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b88:	8a 10                	mov    (%eax),%dl
  800b8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b8d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b95:	89 55 10             	mov    %edx,0x10(%ebp)
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	75 e3                	jne    800b7f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b9c:	eb 23                	jmp    800bc1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba1:	8d 50 01             	lea    0x1(%eax),%edx
  800ba4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ba7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800baa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bad:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb0:	8a 12                	mov    (%edx),%dl
  800bb2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bba:	89 55 10             	mov    %edx,0x10(%ebp)
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 dd                	jne    800b9e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bd8:	eb 2a                	jmp    800c04 <memcmp+0x3e>
		if (*s1 != *s2)
  800bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdd:	8a 10                	mov    (%eax),%dl
  800bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	38 c2                	cmp    %al,%dl
  800be6:	74 16                	je     800bfe <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	0f b6 d0             	movzbl %al,%edx
  800bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	29 c2                	sub    %eax,%edx
  800bfa:	89 d0                	mov    %edx,%eax
  800bfc:	eb 18                	jmp    800c16 <memcmp+0x50>
		s1++, s2++;
  800bfe:	ff 45 fc             	incl   -0x4(%ebp)
  800c01:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c04:	8b 45 10             	mov    0x10(%ebp),%eax
  800c07:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	75 c9                	jne    800bda <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c21:	8b 45 10             	mov    0x10(%ebp),%eax
  800c24:	01 d0                	add    %edx,%eax
  800c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c29:	eb 15                	jmp    800c40 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f b6 d0             	movzbl %al,%edx
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	0f b6 c0             	movzbl %al,%eax
  800c39:	39 c2                	cmp    %eax,%edx
  800c3b:	74 0d                	je     800c4a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c3d:	ff 45 08             	incl   0x8(%ebp)
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c46:	72 e3                	jb     800c2b <memfind+0x13>
  800c48:	eb 01                	jmp    800c4b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c4a:	90                   	nop
	return (void *) s;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c64:	eb 03                	jmp    800c69 <strtol+0x19>
		s++;
  800c66:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8a 00                	mov    (%eax),%al
  800c6e:	3c 20                	cmp    $0x20,%al
  800c70:	74 f4                	je     800c66 <strtol+0x16>
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	3c 09                	cmp    $0x9,%al
  800c79:	74 eb                	je     800c66 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	3c 2b                	cmp    $0x2b,%al
  800c82:	75 05                	jne    800c89 <strtol+0x39>
		s++;
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	eb 13                	jmp    800c9c <strtol+0x4c>
	else if (*s == '-')
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	3c 2d                	cmp    $0x2d,%al
  800c90:	75 0a                	jne    800c9c <strtol+0x4c>
		s++, neg = 1;
  800c92:	ff 45 08             	incl   0x8(%ebp)
  800c95:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca0:	74 06                	je     800ca8 <strtol+0x58>
  800ca2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800ca6:	75 20                	jne    800cc8 <strtol+0x78>
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	3c 30                	cmp    $0x30,%al
  800caf:	75 17                	jne    800cc8 <strtol+0x78>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	40                   	inc    %eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3c 78                	cmp    $0x78,%al
  800cb9:	75 0d                	jne    800cc8 <strtol+0x78>
		s += 2, base = 16;
  800cbb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cbf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cc6:	eb 28                	jmp    800cf0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccc:	75 15                	jne    800ce3 <strtol+0x93>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	3c 30                	cmp    $0x30,%al
  800cd5:	75 0c                	jne    800ce3 <strtol+0x93>
		s++, base = 8;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce1:	eb 0d                	jmp    800cf0 <strtol+0xa0>
	else if (base == 0)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	75 07                	jne    800cf0 <strtol+0xa0>
		base = 10;
  800ce9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	3c 2f                	cmp    $0x2f,%al
  800cf7:	7e 19                	jle    800d12 <strtol+0xc2>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	3c 39                	cmp    $0x39,%al
  800d00:	7f 10                	jg     800d12 <strtol+0xc2>
			dig = *s - '0';
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	0f be c0             	movsbl %al,%eax
  800d0a:	83 e8 30             	sub    $0x30,%eax
  800d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d10:	eb 42                	jmp    800d54 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 60                	cmp    $0x60,%al
  800d19:	7e 19                	jle    800d34 <strtol+0xe4>
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	3c 7a                	cmp    $0x7a,%al
  800d22:	7f 10                	jg     800d34 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	0f be c0             	movsbl %al,%eax
  800d2c:	83 e8 57             	sub    $0x57,%eax
  800d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d32:	eb 20                	jmp    800d54 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3c 40                	cmp    $0x40,%al
  800d3b:	7e 39                	jle    800d76 <strtol+0x126>
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	3c 5a                	cmp    $0x5a,%al
  800d44:	7f 30                	jg     800d76 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f be c0             	movsbl %al,%eax
  800d4e:	83 e8 37             	sub    $0x37,%eax
  800d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d57:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5a:	7d 19                	jge    800d75 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d66:	89 c2                	mov    %eax,%edx
  800d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d6b:	01 d0                	add    %edx,%eax
  800d6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d70:	e9 7b ff ff ff       	jmp    800cf0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d75:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7a:	74 08                	je     800d84 <strtol+0x134>
		*endptr = (char *) s;
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d84:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d88:	74 07                	je     800d91 <strtol+0x141>
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	f7 d8                	neg    %eax
  800d8f:	eb 03                	jmp    800d94 <strtol+0x144>
  800d91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <ltostr>:

void
ltostr(long value, char *str)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800da3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dae:	79 13                	jns    800dc3 <ltostr+0x2d>
	{
		neg = 1;
  800db0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dbd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dcb:	99                   	cltd   
  800dcc:	f7 f9                	idiv   %ecx
  800dce:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd4:	8d 50 01             	lea    0x1(%eax),%edx
  800dd7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dda:	89 c2                	mov    %eax,%edx
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	01 d0                	add    %edx,%eax
  800de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800de4:	83 c2 30             	add    $0x30,%edx
  800de7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dec:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df1:	f7 e9                	imul   %ecx
  800df3:	c1 fa 02             	sar    $0x2,%edx
  800df6:	89 c8                	mov    %ecx,%eax
  800df8:	c1 f8 1f             	sar    $0x1f,%eax
  800dfb:	29 c2                	sub    %eax,%edx
  800dfd:	89 d0                	mov    %edx,%eax
  800dff:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e06:	75 bb                	jne    800dc3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e12:	48                   	dec    %eax
  800e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e1a:	74 3d                	je     800e59 <ltostr+0xc3>
		start = 1 ;
  800e1c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e23:	eb 34                	jmp    800e59 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e38:	01 c2                	add    %eax,%edx
  800e3a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	01 c8                	add    %ecx,%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	01 c2                	add    %eax,%edx
  800e4e:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e51:	88 02                	mov    %al,(%edx)
		start++ ;
  800e53:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e56:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e5f:	7c c4                	jl     800e25 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e61:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e6c:	90                   	nop
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e75:	ff 75 08             	pushl  0x8(%ebp)
  800e78:	e8 73 fa ff ff       	call   8008f0 <strlen>
  800e7d:	83 c4 04             	add    $0x4,%esp
  800e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	e8 65 fa ff ff       	call   8008f0 <strlen>
  800e8b:	83 c4 04             	add    $0x4,%esp
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9f:	eb 17                	jmp    800eb8 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ea1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	01 c2                	add    %eax,%edx
  800ea9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	01 c8                	add    %ecx,%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ebe:	7c e1                	jl     800ea1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ec0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ec7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ece:	eb 1f                	jmp    800eef <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	8d 50 01             	lea    0x1(%eax),%edx
  800ed6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	01 c2                	add    %eax,%edx
  800ee0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	01 c8                	add    %ecx,%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800eec:	ff 45 f8             	incl   -0x8(%ebp)
  800eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ef5:	7c d9                	jl     800ed0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ef7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	01 d0                	add    %edx,%eax
  800eff:	c6 00 00             	movb   $0x0,(%eax)
}
  800f02:	90                   	nop
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f08:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f11:	8b 45 14             	mov    0x14(%ebp),%eax
  800f14:	8b 00                	mov    (%eax),%eax
  800f16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f28:	eb 0c                	jmp    800f36 <strsplit+0x31>
			*string++ = 0;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 08             	mov    %edx,0x8(%ebp)
  800f33:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	84 c0                	test   %al,%al
  800f3d:	74 18                	je     800f57 <strsplit+0x52>
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f be c0             	movsbl %al,%eax
  800f47:	50                   	push   %eax
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	e8 32 fb ff ff       	call   800a82 <strchr>
  800f50:	83 c4 08             	add    $0x8,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 d3                	jne    800f2a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	84 c0                	test   %al,%al
  800f5e:	74 5a                	je     800fba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f60:	8b 45 14             	mov    0x14(%ebp),%eax
  800f63:	8b 00                	mov    (%eax),%eax
  800f65:	83 f8 0f             	cmp    $0xf,%eax
  800f68:	75 07                	jne    800f71 <strsplit+0x6c>
		{
			return 0;
  800f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6f:	eb 66                	jmp    800fd7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f71:	8b 45 14             	mov    0x14(%ebp),%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	8d 48 01             	lea    0x1(%eax),%ecx
  800f79:	8b 55 14             	mov    0x14(%ebp),%edx
  800f7c:	89 0a                	mov    %ecx,(%edx)
  800f7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	01 c2                	add    %eax,%edx
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f8f:	eb 03                	jmp    800f94 <strsplit+0x8f>
			string++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 8b                	je     800f28 <strsplit+0x23>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f be c0             	movsbl %al,%eax
  800fa5:	50                   	push   %eax
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	e8 d4 fa ff ff       	call   800a82 <strchr>
  800fae:	83 c4 08             	add    $0x8,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	74 dc                	je     800f91 <strsplit+0x8c>
			string++;
	}
  800fb5:	e9 6e ff ff ff       	jmp    800f28 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	8b 00                	mov    (%eax),%eax
  800fc0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	01 d0                	add    %edx,%eax
  800fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800fdf:	83 ec 04             	sub    $0x4,%esp
  800fe2:	68 28 1f 80 00       	push   $0x801f28
  800fe7:	68 3f 01 00 00       	push   $0x13f
  800fec:	68 4a 1f 80 00       	push   $0x801f4a
  800ff1:	e8 29 06 00 00       	call   80161f <_panic>

00800ff6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8b 55 0c             	mov    0xc(%ebp),%edx
  801005:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801008:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80100b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80100e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801011:	cd 30                	int    $0x30
  801013:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 04             	sub    $0x4,%esp
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80102d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	6a 00                	push   $0x0
  801036:	6a 00                	push   $0x0
  801038:	52                   	push   %edx
  801039:	ff 75 0c             	pushl  0xc(%ebp)
  80103c:	50                   	push   %eax
  80103d:	6a 00                	push   $0x0
  80103f:	e8 b2 ff ff ff       	call   800ff6 <syscall>
  801044:	83 c4 18             	add    $0x18,%esp
}
  801047:	90                   	nop
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <sys_cgetc>:

int
sys_cgetc(void)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80104d:	6a 00                	push   $0x0
  80104f:	6a 00                	push   $0x0
  801051:	6a 00                	push   $0x0
  801053:	6a 00                	push   $0x0
  801055:	6a 00                	push   $0x0
  801057:	6a 02                	push   $0x2
  801059:	e8 98 ff ff ff       	call   800ff6 <syscall>
  80105e:	83 c4 18             	add    $0x18,%esp
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801066:	6a 00                	push   $0x0
  801068:	6a 00                	push   $0x0
  80106a:	6a 00                	push   $0x0
  80106c:	6a 00                	push   $0x0
  80106e:	6a 00                	push   $0x0
  801070:	6a 03                	push   $0x3
  801072:	e8 7f ff ff ff       	call   800ff6 <syscall>
  801077:	83 c4 18             	add    $0x18,%esp
}
  80107a:	90                   	nop
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801080:	6a 00                	push   $0x0
  801082:	6a 00                	push   $0x0
  801084:	6a 00                	push   $0x0
  801086:	6a 00                	push   $0x0
  801088:	6a 00                	push   $0x0
  80108a:	6a 04                	push   $0x4
  80108c:	e8 65 ff ff ff       	call   800ff6 <syscall>
  801091:	83 c4 18             	add    $0x18,%esp
}
  801094:	90                   	nop
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	6a 00                	push   $0x0
  8010a2:	6a 00                	push   $0x0
  8010a4:	6a 00                	push   $0x0
  8010a6:	52                   	push   %edx
  8010a7:	50                   	push   %eax
  8010a8:	6a 08                	push   $0x8
  8010aa:	e8 47 ff ff ff       	call   800ff6 <syscall>
  8010af:	83 c4 18             	add    $0x18,%esp
}
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8010bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
  8010ca:	51                   	push   %ecx
  8010cb:	52                   	push   %edx
  8010cc:	50                   	push   %eax
  8010cd:	6a 09                	push   $0x9
  8010cf:	e8 22 ff ff ff       	call   800ff6 <syscall>
  8010d4:	83 c4 18             	add    $0x18,%esp
}
  8010d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	52                   	push   %edx
  8010ee:	50                   	push   %eax
  8010ef:	6a 0a                	push   $0xa
  8010f1:	e8 00 ff ff ff       	call   800ff6 <syscall>
  8010f6:	83 c4 18             	add    $0x18,%esp
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	ff 75 0c             	pushl  0xc(%ebp)
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	6a 0b                	push   $0xb
  80110c:	e8 e5 fe ff ff       	call   800ff6 <syscall>
  801111:	83 c4 18             	add    $0x18,%esp
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	6a 00                	push   $0x0
  80111f:	6a 00                	push   $0x0
  801121:	6a 00                	push   $0x0
  801123:	6a 0c                	push   $0xc
  801125:	e8 cc fe ff ff       	call   800ff6 <syscall>
  80112a:	83 c4 18             	add    $0x18,%esp
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 0d                	push   $0xd
  80113e:	e8 b3 fe ff ff       	call   800ff6 <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 0e                	push   $0xe
  801157:	e8 9a fe ff ff       	call   800ff6 <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 0f                	push   $0xf
  801170:	e8 81 fe ff ff       	call   800ff6 <syscall>
  801175:	83 c4 18             	add    $0x18,%esp
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	ff 75 08             	pushl  0x8(%ebp)
  801188:	6a 10                	push   $0x10
  80118a:	e8 67 fe ff ff       	call   800ff6 <syscall>
  80118f:	83 c4 18             	add    $0x18,%esp
}
  801192:	c9                   	leave  
  801193:	c3                   	ret    

00801194 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 11                	push   $0x11
  8011a3:	e8 4e fe ff ff       	call   800ff6 <syscall>
  8011a8:	83 c4 18             	add    $0x18,%esp
}
  8011ab:	90                   	nop
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <sys_cputc>:

void
sys_cputc(const char c)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	50                   	push   %eax
  8011c7:	6a 01                	push   $0x1
  8011c9:	e8 28 fe ff ff       	call   800ff6 <syscall>
  8011ce:	83 c4 18             	add    $0x18,%esp
}
  8011d1:	90                   	nop
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 14                	push   $0x14
  8011e3:	e8 0e fe ff ff       	call   800ff6 <syscall>
  8011e8:	83 c4 18             	add    $0x18,%esp
}
  8011eb:	90                   	nop
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8011fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8011fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	6a 00                	push   $0x0
  801206:	51                   	push   %ecx
  801207:	52                   	push   %edx
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	50                   	push   %eax
  80120c:	6a 15                	push   $0x15
  80120e:	e8 e3 fd ff ff       	call   800ff6 <syscall>
  801213:	83 c4 18             	add    $0x18,%esp
}
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	52                   	push   %edx
  801228:	50                   	push   %eax
  801229:	6a 16                	push   $0x16
  80122b:	e8 c6 fd ff ff       	call   800ff6 <syscall>
  801230:	83 c4 18             	add    $0x18,%esp
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801238:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80123b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	51                   	push   %ecx
  801246:	52                   	push   %edx
  801247:	50                   	push   %eax
  801248:	6a 17                	push   $0x17
  80124a:	e8 a7 fd ff ff       	call   800ff6 <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	52                   	push   %edx
  801264:	50                   	push   %eax
  801265:	6a 18                	push   $0x18
  801267:	e8 8a fd ff ff       	call   800ff6 <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	6a 00                	push   $0x0
  801279:	ff 75 14             	pushl  0x14(%ebp)
  80127c:	ff 75 10             	pushl  0x10(%ebp)
  80127f:	ff 75 0c             	pushl  0xc(%ebp)
  801282:	50                   	push   %eax
  801283:	6a 19                	push   $0x19
  801285:	e8 6c fd ff ff       	call   800ff6 <syscall>
  80128a:	83 c4 18             	add    $0x18,%esp
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	50                   	push   %eax
  80129e:	6a 1a                	push   $0x1a
  8012a0:	e8 51 fd ff ff       	call   800ff6 <syscall>
  8012a5:	83 c4 18             	add    $0x18,%esp
}
  8012a8:	90                   	nop
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	50                   	push   %eax
  8012ba:	6a 1b                	push   $0x1b
  8012bc:	e8 35 fd ff ff       	call   800ff6 <syscall>
  8012c1:	83 c4 18             	add    $0x18,%esp
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 05                	push   $0x5
  8012d5:	e8 1c fd ff ff       	call   800ff6 <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 06                	push   $0x6
  8012ee:	e8 03 fd ff ff       	call   800ff6 <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 07                	push   $0x7
  801307:	e8 ea fc ff ff       	call   800ff6 <syscall>
  80130c:	83 c4 18             	add    $0x18,%esp
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_exit_env>:


void sys_exit_env(void)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 1c                	push   $0x1c
  801320:	e8 d1 fc ff ff       	call   800ff6 <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	90                   	nop
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801331:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801334:	8d 50 04             	lea    0x4(%eax),%edx
  801337:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	52                   	push   %edx
  801341:	50                   	push   %eax
  801342:	6a 1d                	push   $0x1d
  801344:	e8 ad fc ff ff       	call   800ff6 <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
	return result;
  80134c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801352:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801355:	89 01                	mov    %eax,(%ecx)
  801357:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	c9                   	leave  
  80135e:	c2 04 00             	ret    $0x4

00801361 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	ff 75 10             	pushl  0x10(%ebp)
  80136b:	ff 75 0c             	pushl  0xc(%ebp)
  80136e:	ff 75 08             	pushl  0x8(%ebp)
  801371:	6a 13                	push   $0x13
  801373:	e8 7e fc ff ff       	call   800ff6 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
	return ;
  80137b:	90                   	nop
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_rcr2>:
uint32 sys_rcr2()
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 1e                	push   $0x1e
  80138d:	e8 64 fc ff ff       	call   800ff6 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013a3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	50                   	push   %eax
  8013b0:	6a 1f                	push   $0x1f
  8013b2:	e8 3f fc ff ff       	call   800ff6 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ba:	90                   	nop
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <rsttst>:
void rsttst()
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 21                	push   $0x21
  8013cc:	e8 25 fc ff ff       	call   800ff6 <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d4:	90                   	nop
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013e3:	8b 55 18             	mov    0x18(%ebp),%edx
  8013e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013ea:	52                   	push   %edx
  8013eb:	50                   	push   %eax
  8013ec:	ff 75 10             	pushl  0x10(%ebp)
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	6a 20                	push   $0x20
  8013f7:	e8 fa fb ff ff       	call   800ff6 <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ff:	90                   	nop
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <chktst>:
void chktst(uint32 n)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	ff 75 08             	pushl  0x8(%ebp)
  801410:	6a 22                	push   $0x22
  801412:	e8 df fb ff ff       	call   800ff6 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
	return ;
  80141a:	90                   	nop
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <inctst>:

void inctst()
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 23                	push   $0x23
  80142c:	e8 c5 fb ff ff       	call   800ff6 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
	return ;
  801434:	90                   	nop
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <gettst>:
uint32 gettst()
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 24                	push   $0x24
  801446:	e8 ab fb ff ff       	call   800ff6 <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 25                	push   $0x25
  801462:	e8 8f fb ff ff       	call   800ff6 <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
  80146a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80146d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801471:	75 07                	jne    80147a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801473:	b8 01 00 00 00       	mov    $0x1,%eax
  801478:	eb 05                	jmp    80147f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 25                	push   $0x25
  801493:	e8 5e fb ff ff       	call   800ff6 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
  80149b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80149e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014a2:	75 07                	jne    8014ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8014a9:	eb 05                	jmp    8014b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 25                	push   $0x25
  8014c4:	e8 2d fb ff ff       	call   800ff6 <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
  8014cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014d3:	75 07                	jne    8014dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8014da:	eb 05                	jmp    8014e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 25                	push   $0x25
  8014f5:	e8 fc fa ff ff       	call   800ff6 <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
  8014fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801500:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801504:	75 07                	jne    80150d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801506:	b8 01 00 00 00       	mov    $0x1,%eax
  80150b:	eb 05                	jmp    801512 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	ff 75 08             	pushl  0x8(%ebp)
  801522:	6a 26                	push   $0x26
  801524:	e8 cd fa ff ff       	call   800ff6 <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
	return ;
  80152c:	90                   	nop
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801533:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	6a 00                	push   $0x0
  801541:	53                   	push   %ebx
  801542:	51                   	push   %ecx
  801543:	52                   	push   %edx
  801544:	50                   	push   %eax
  801545:	6a 27                	push   $0x27
  801547:	e8 aa fa ff ff       	call   800ff6 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	6a 28                	push   $0x28
  801567:	e8 8a fa ff ff       	call   800ff6 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801574:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	6a 00                	push   $0x0
  80157f:	51                   	push   %ecx
  801580:	ff 75 10             	pushl  0x10(%ebp)
  801583:	52                   	push   %edx
  801584:	50                   	push   %eax
  801585:	6a 29                	push   $0x29
  801587:	e8 6a fa ff ff       	call   800ff6 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	ff 75 10             	pushl  0x10(%ebp)
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	6a 12                	push   $0x12
  8015a3:	e8 4e fa ff ff       	call   800ff6 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ab:	90                   	nop
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	52                   	push   %edx
  8015be:	50                   	push   %eax
  8015bf:	6a 2a                	push   $0x2a
  8015c1:	e8 30 fa ff ff       	call   800ff6 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
	return;
  8015c9:	90                   	nop
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	50                   	push   %eax
  8015db:	6a 2b                	push   $0x2b
  8015dd:	e8 14 fa ff ff       	call   800ff6 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 2c                	push   $0x2c
  8015f8:	e8 f9 f9 ff ff       	call   800ff6 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
	return;
  801600:	90                   	nop
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	6a 2d                	push   $0x2d
  801614:	e8 dd f9 ff ff       	call   800ff6 <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
	return;
  80161c:	90                   	nop
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801625:	8d 45 10             	lea    0x10(%ebp),%eax
  801628:	83 c0 04             	add    $0x4,%eax
  80162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80162e:	a1 e4 68 81 00       	mov    0x8168e4,%eax
  801633:	85 c0                	test   %eax,%eax
  801635:	74 16                	je     80164d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801637:	a1 e4 68 81 00       	mov    0x8168e4,%eax
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	50                   	push   %eax
  801640:	68 58 1f 80 00       	push   $0x801f58
  801645:	e8 12 ec ff ff       	call   80025c <cprintf>
  80164a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80164d:	a1 00 30 80 00       	mov    0x803000,%eax
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	50                   	push   %eax
  801659:	68 5d 1f 80 00       	push   $0x801f5d
  80165e:	e8 f9 eb ff ff       	call   80025c <cprintf>
  801663:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	ff 75 f4             	pushl  -0xc(%ebp)
  80166f:	50                   	push   %eax
  801670:	e8 7c eb ff ff       	call   8001f1 <vcprintf>
  801675:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	6a 00                	push   $0x0
  80167d:	68 79 1f 80 00       	push   $0x801f79
  801682:	e8 6a eb ff ff       	call   8001f1 <vcprintf>
  801687:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80168a:	e8 eb ea ff ff       	call   80017a <exit>

	// should not return here
	while (1) ;
  80168f:	eb fe                	jmp    80168f <_panic+0x70>

00801691 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801697:	a1 20 30 80 00       	mov    0x803020,%eax
  80169c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	39 c2                	cmp    %eax,%edx
  8016a7:	74 14                	je     8016bd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 7c 1f 80 00       	push   $0x801f7c
  8016b1:	6a 26                	push   $0x26
  8016b3:	68 c8 1f 80 00       	push   $0x801fc8
  8016b8:	e8 62 ff ff ff       	call   80161f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016cb:	e9 c5 00 00 00       	jmp    801795 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	75 08                	jne    8016ed <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016e5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016e8:	e9 a5 00 00 00       	jmp    801792 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016fb:	eb 69                	jmp    801766 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016fd:	a1 20 30 80 00       	mov    0x803020,%eax
  801702:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801708:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	01 c0                	add    %eax,%eax
  80170f:	01 d0                	add    %edx,%eax
  801711:	c1 e0 03             	shl    $0x3,%eax
  801714:	01 c8                	add    %ecx,%eax
  801716:	8a 40 04             	mov    0x4(%eax),%al
  801719:	84 c0                	test   %al,%al
  80171b:	75 46                	jne    801763 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80171d:	a1 20 30 80 00       	mov    0x803020,%eax
  801722:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801728:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80172b:	89 d0                	mov    %edx,%eax
  80172d:	01 c0                	add    %eax,%eax
  80172f:	01 d0                	add    %edx,%eax
  801731:	c1 e0 03             	shl    $0x3,%eax
  801734:	01 c8                	add    %ecx,%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80173b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80173e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801743:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	01 c8                	add    %ecx,%eax
  801754:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801756:	39 c2                	cmp    %eax,%edx
  801758:	75 09                	jne    801763 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80175a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801761:	eb 15                	jmp    801778 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801763:	ff 45 e8             	incl   -0x18(%ebp)
  801766:	a1 20 30 80 00       	mov    0x803020,%eax
  80176b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801774:	39 c2                	cmp    %eax,%edx
  801776:	77 85                	ja     8016fd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80177c:	75 14                	jne    801792 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 d4 1f 80 00       	push   $0x801fd4
  801786:	6a 3a                	push   $0x3a
  801788:	68 c8 1f 80 00       	push   $0x801fc8
  80178d:	e8 8d fe ff ff       	call   80161f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801792:	ff 45 f0             	incl   -0x10(%ebp)
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801798:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80179b:	0f 8c 2f ff ff ff    	jl     8016d0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017af:	eb 26                	jmp    8017d7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8017b6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8017bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	01 c0                	add    %eax,%eax
  8017c3:	01 d0                	add    %edx,%eax
  8017c5:	c1 e0 03             	shl    $0x3,%eax
  8017c8:	01 c8                	add    %ecx,%eax
  8017ca:	8a 40 04             	mov    0x4(%eax),%al
  8017cd:	3c 01                	cmp    $0x1,%al
  8017cf:	75 03                	jne    8017d4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017d1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017d4:	ff 45 e0             	incl   -0x20(%ebp)
  8017d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8017dc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e5:	39 c2                	cmp    %eax,%edx
  8017e7:	77 c8                	ja     8017b1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017ef:	74 14                	je     801805 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 28 20 80 00       	push   $0x802028
  8017f9:	6a 44                	push   $0x44
  8017fb:	68 c8 1f 80 00       	push   $0x801fc8
  801800:	e8 1a fe ff ff       	call   80161f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801805:	90                   	nop
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <__udivdi3>:
  801808:	55                   	push   %ebp
  801809:	57                   	push   %edi
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
  80180c:	83 ec 1c             	sub    $0x1c,%esp
  80180f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801813:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801817:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80181b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80181f:	89 ca                	mov    %ecx,%edx
  801821:	89 f8                	mov    %edi,%eax
  801823:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801827:	85 f6                	test   %esi,%esi
  801829:	75 2d                	jne    801858 <__udivdi3+0x50>
  80182b:	39 cf                	cmp    %ecx,%edi
  80182d:	77 65                	ja     801894 <__udivdi3+0x8c>
  80182f:	89 fd                	mov    %edi,%ebp
  801831:	85 ff                	test   %edi,%edi
  801833:	75 0b                	jne    801840 <__udivdi3+0x38>
  801835:	b8 01 00 00 00       	mov    $0x1,%eax
  80183a:	31 d2                	xor    %edx,%edx
  80183c:	f7 f7                	div    %edi
  80183e:	89 c5                	mov    %eax,%ebp
  801840:	31 d2                	xor    %edx,%edx
  801842:	89 c8                	mov    %ecx,%eax
  801844:	f7 f5                	div    %ebp
  801846:	89 c1                	mov    %eax,%ecx
  801848:	89 d8                	mov    %ebx,%eax
  80184a:	f7 f5                	div    %ebp
  80184c:	89 cf                	mov    %ecx,%edi
  80184e:	89 fa                	mov    %edi,%edx
  801850:	83 c4 1c             	add    $0x1c,%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5f                   	pop    %edi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    
  801858:	39 ce                	cmp    %ecx,%esi
  80185a:	77 28                	ja     801884 <__udivdi3+0x7c>
  80185c:	0f bd fe             	bsr    %esi,%edi
  80185f:	83 f7 1f             	xor    $0x1f,%edi
  801862:	75 40                	jne    8018a4 <__udivdi3+0x9c>
  801864:	39 ce                	cmp    %ecx,%esi
  801866:	72 0a                	jb     801872 <__udivdi3+0x6a>
  801868:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80186c:	0f 87 9e 00 00 00    	ja     801910 <__udivdi3+0x108>
  801872:	b8 01 00 00 00       	mov    $0x1,%eax
  801877:	89 fa                	mov    %edi,%edx
  801879:	83 c4 1c             	add    $0x1c,%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5f                   	pop    %edi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    
  801881:	8d 76 00             	lea    0x0(%esi),%esi
  801884:	31 ff                	xor    %edi,%edi
  801886:	31 c0                	xor    %eax,%eax
  801888:	89 fa                	mov    %edi,%edx
  80188a:	83 c4 1c             	add    $0x1c,%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5f                   	pop    %edi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    
  801892:	66 90                	xchg   %ax,%ax
  801894:	89 d8                	mov    %ebx,%eax
  801896:	f7 f7                	div    %edi
  801898:	31 ff                	xor    %edi,%edi
  80189a:	89 fa                	mov    %edi,%edx
  80189c:	83 c4 1c             	add    $0x1c,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5f                   	pop    %edi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    
  8018a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018a9:	89 eb                	mov    %ebp,%ebx
  8018ab:	29 fb                	sub    %edi,%ebx
  8018ad:	89 f9                	mov    %edi,%ecx
  8018af:	d3 e6                	shl    %cl,%esi
  8018b1:	89 c5                	mov    %eax,%ebp
  8018b3:	88 d9                	mov    %bl,%cl
  8018b5:	d3 ed                	shr    %cl,%ebp
  8018b7:	89 e9                	mov    %ebp,%ecx
  8018b9:	09 f1                	or     %esi,%ecx
  8018bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018bf:	89 f9                	mov    %edi,%ecx
  8018c1:	d3 e0                	shl    %cl,%eax
  8018c3:	89 c5                	mov    %eax,%ebp
  8018c5:	89 d6                	mov    %edx,%esi
  8018c7:	88 d9                	mov    %bl,%cl
  8018c9:	d3 ee                	shr    %cl,%esi
  8018cb:	89 f9                	mov    %edi,%ecx
  8018cd:	d3 e2                	shl    %cl,%edx
  8018cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018d3:	88 d9                	mov    %bl,%cl
  8018d5:	d3 e8                	shr    %cl,%eax
  8018d7:	09 c2                	or     %eax,%edx
  8018d9:	89 d0                	mov    %edx,%eax
  8018db:	89 f2                	mov    %esi,%edx
  8018dd:	f7 74 24 0c          	divl   0xc(%esp)
  8018e1:	89 d6                	mov    %edx,%esi
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	f7 e5                	mul    %ebp
  8018e7:	39 d6                	cmp    %edx,%esi
  8018e9:	72 19                	jb     801904 <__udivdi3+0xfc>
  8018eb:	74 0b                	je     8018f8 <__udivdi3+0xf0>
  8018ed:	89 d8                	mov    %ebx,%eax
  8018ef:	31 ff                	xor    %edi,%edi
  8018f1:	e9 58 ff ff ff       	jmp    80184e <__udivdi3+0x46>
  8018f6:	66 90                	xchg   %ax,%ax
  8018f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018fc:	89 f9                	mov    %edi,%ecx
  8018fe:	d3 e2                	shl    %cl,%edx
  801900:	39 c2                	cmp    %eax,%edx
  801902:	73 e9                	jae    8018ed <__udivdi3+0xe5>
  801904:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801907:	31 ff                	xor    %edi,%edi
  801909:	e9 40 ff ff ff       	jmp    80184e <__udivdi3+0x46>
  80190e:	66 90                	xchg   %ax,%ax
  801910:	31 c0                	xor    %eax,%eax
  801912:	e9 37 ff ff ff       	jmp    80184e <__udivdi3+0x46>
  801917:	90                   	nop

00801918 <__umoddi3>:
  801918:	55                   	push   %ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 1c             	sub    $0x1c,%esp
  80191f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801923:	8b 74 24 34          	mov    0x34(%esp),%esi
  801927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80192b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80192f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801933:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801937:	89 f3                	mov    %esi,%ebx
  801939:	89 fa                	mov    %edi,%edx
  80193b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80193f:	89 34 24             	mov    %esi,(%esp)
  801942:	85 c0                	test   %eax,%eax
  801944:	75 1a                	jne    801960 <__umoddi3+0x48>
  801946:	39 f7                	cmp    %esi,%edi
  801948:	0f 86 a2 00 00 00    	jbe    8019f0 <__umoddi3+0xd8>
  80194e:	89 c8                	mov    %ecx,%eax
  801950:	89 f2                	mov    %esi,%edx
  801952:	f7 f7                	div    %edi
  801954:	89 d0                	mov    %edx,%eax
  801956:	31 d2                	xor    %edx,%edx
  801958:	83 c4 1c             	add    $0x1c,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
  801960:	39 f0                	cmp    %esi,%eax
  801962:	0f 87 ac 00 00 00    	ja     801a14 <__umoddi3+0xfc>
  801968:	0f bd e8             	bsr    %eax,%ebp
  80196b:	83 f5 1f             	xor    $0x1f,%ebp
  80196e:	0f 84 ac 00 00 00    	je     801a20 <__umoddi3+0x108>
  801974:	bf 20 00 00 00       	mov    $0x20,%edi
  801979:	29 ef                	sub    %ebp,%edi
  80197b:	89 fe                	mov    %edi,%esi
  80197d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801981:	89 e9                	mov    %ebp,%ecx
  801983:	d3 e0                	shl    %cl,%eax
  801985:	89 d7                	mov    %edx,%edi
  801987:	89 f1                	mov    %esi,%ecx
  801989:	d3 ef                	shr    %cl,%edi
  80198b:	09 c7                	or     %eax,%edi
  80198d:	89 e9                	mov    %ebp,%ecx
  80198f:	d3 e2                	shl    %cl,%edx
  801991:	89 14 24             	mov    %edx,(%esp)
  801994:	89 d8                	mov    %ebx,%eax
  801996:	d3 e0                	shl    %cl,%eax
  801998:	89 c2                	mov    %eax,%edx
  80199a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80199e:	d3 e0                	shl    %cl,%eax
  8019a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019a8:	89 f1                	mov    %esi,%ecx
  8019aa:	d3 e8                	shr    %cl,%eax
  8019ac:	09 d0                	or     %edx,%eax
  8019ae:	d3 eb                	shr    %cl,%ebx
  8019b0:	89 da                	mov    %ebx,%edx
  8019b2:	f7 f7                	div    %edi
  8019b4:	89 d3                	mov    %edx,%ebx
  8019b6:	f7 24 24             	mull   (%esp)
  8019b9:	89 c6                	mov    %eax,%esi
  8019bb:	89 d1                	mov    %edx,%ecx
  8019bd:	39 d3                	cmp    %edx,%ebx
  8019bf:	0f 82 87 00 00 00    	jb     801a4c <__umoddi3+0x134>
  8019c5:	0f 84 91 00 00 00    	je     801a5c <__umoddi3+0x144>
  8019cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019cf:	29 f2                	sub    %esi,%edx
  8019d1:	19 cb                	sbb    %ecx,%ebx
  8019d3:	89 d8                	mov    %ebx,%eax
  8019d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019d9:	d3 e0                	shl    %cl,%eax
  8019db:	89 e9                	mov    %ebp,%ecx
  8019dd:	d3 ea                	shr    %cl,%edx
  8019df:	09 d0                	or     %edx,%eax
  8019e1:	89 e9                	mov    %ebp,%ecx
  8019e3:	d3 eb                	shr    %cl,%ebx
  8019e5:	89 da                	mov    %ebx,%edx
  8019e7:	83 c4 1c             	add    $0x1c,%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5f                   	pop    %edi
  8019ed:	5d                   	pop    %ebp
  8019ee:	c3                   	ret    
  8019ef:	90                   	nop
  8019f0:	89 fd                	mov    %edi,%ebp
  8019f2:	85 ff                	test   %edi,%edi
  8019f4:	75 0b                	jne    801a01 <__umoddi3+0xe9>
  8019f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fb:	31 d2                	xor    %edx,%edx
  8019fd:	f7 f7                	div    %edi
  8019ff:	89 c5                	mov    %eax,%ebp
  801a01:	89 f0                	mov    %esi,%eax
  801a03:	31 d2                	xor    %edx,%edx
  801a05:	f7 f5                	div    %ebp
  801a07:	89 c8                	mov    %ecx,%eax
  801a09:	f7 f5                	div    %ebp
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	e9 44 ff ff ff       	jmp    801956 <__umoddi3+0x3e>
  801a12:	66 90                	xchg   %ax,%ax
  801a14:	89 c8                	mov    %ecx,%eax
  801a16:	89 f2                	mov    %esi,%edx
  801a18:	83 c4 1c             	add    $0x1c,%esp
  801a1b:	5b                   	pop    %ebx
  801a1c:	5e                   	pop    %esi
  801a1d:	5f                   	pop    %edi
  801a1e:	5d                   	pop    %ebp
  801a1f:	c3                   	ret    
  801a20:	3b 04 24             	cmp    (%esp),%eax
  801a23:	72 06                	jb     801a2b <__umoddi3+0x113>
  801a25:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a29:	77 0f                	ja     801a3a <__umoddi3+0x122>
  801a2b:	89 f2                	mov    %esi,%edx
  801a2d:	29 f9                	sub    %edi,%ecx
  801a2f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a33:	89 14 24             	mov    %edx,(%esp)
  801a36:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a3a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a3e:	8b 14 24             	mov    (%esp),%edx
  801a41:	83 c4 1c             	add    $0x1c,%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5e                   	pop    %esi
  801a46:	5f                   	pop    %edi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    
  801a49:	8d 76 00             	lea    0x0(%esi),%esi
  801a4c:	2b 04 24             	sub    (%esp),%eax
  801a4f:	19 fa                	sbb    %edi,%edx
  801a51:	89 d1                	mov    %edx,%ecx
  801a53:	89 c6                	mov    %eax,%esi
  801a55:	e9 71 ff ff ff       	jmp    8019cb <__umoddi3+0xb3>
  801a5a:	66 90                	xchg   %ax,%ax
  801a5c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a60:	72 ea                	jb     801a4c <__umoddi3+0x134>
  801a62:	89 d9                	mov    %ebx,%ecx
  801a64:	e9 62 ff ff ff       	jmp    8019cb <__umoddi3+0xb3>
