
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
  800041:	68 20 1b 80 00       	push   $0x801b20
  800046:	e8 46 02 00 00       	call   800291 <atomic_cprintf>
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
  800057:	e8 8b 12 00 00       	call   8012e7 <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800070:	01 c8                	add    %ecx,%eax
  800072:	01 c0                	add    %eax,%eax
  800074:	01 d0                	add    %edx,%eax
  800076:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80007d:	01 c8                	add    %ecx,%eax
  80007f:	01 d0                	add    %edx,%eax
  800081:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800086:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80008b:	a1 20 30 80 00       	mov    0x803020,%eax
  800090:	8a 40 20             	mov    0x20(%eax),%al
  800093:	84 c0                	test   %al,%al
  800095:	74 0d                	je     8000a4 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	83 c0 20             	add    $0x20,%eax
  80009f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a8:	7e 0a                	jle    8000b4 <libmain+0x63>
		binaryname = argv[0];
  8000aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ad:	8b 00                	mov    (%eax),%eax
  8000af:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ba:	ff 75 08             	pushl  0x8(%ebp)
  8000bd:	e8 76 ff ff ff       	call   800038 <_main>
  8000c2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000c5:	e8 a1 0f 00 00       	call   80106b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 64 1b 80 00       	push   $0x801b64
  8000d2:	e8 8d 01 00 00       	call   800264 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000da:	a1 20 30 80 00       	mov    0x803020,%eax
  8000df:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ea:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	52                   	push   %edx
  8000f4:	50                   	push   %eax
  8000f5:	68 8c 1b 80 00       	push   $0x801b8c
  8000fa:	e8 65 01 00 00       	call   800264 <cprintf>
  8000ff:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800102:	a1 20 30 80 00       	mov    0x803020,%eax
  800107:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80010d:	a1 20 30 80 00       	mov    0x803020,%eax
  800112:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800118:	a1 20 30 80 00       	mov    0x803020,%eax
  80011d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800123:	51                   	push   %ecx
  800124:	52                   	push   %edx
  800125:	50                   	push   %eax
  800126:	68 b4 1b 80 00       	push   $0x801bb4
  80012b:	e8 34 01 00 00       	call   800264 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800133:	a1 20 30 80 00       	mov    0x803020,%eax
  800138:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	50                   	push   %eax
  800142:	68 0c 1c 80 00       	push   $0x801c0c
  800147:	e8 18 01 00 00       	call   800264 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 64 1b 80 00       	push   $0x801b64
  800157:	e8 08 01 00 00       	call   800264 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80015f:	e8 21 0f 00 00       	call   801085 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800164:	e8 19 00 00 00       	call   800182 <exit>
}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	6a 00                	push   $0x0
  800177:	e8 37 11 00 00       	call   8012b3 <sys_destroy_env>
  80017c:	83 c4 10             	add    $0x10,%esp
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <exit>:

void
exit(void)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800188:	e8 8c 11 00 00       	call   801319 <sys_exit_env>
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800196:	8b 45 0c             	mov    0xc(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	8d 48 01             	lea    0x1(%eax),%ecx
  80019e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a1:	89 0a                	mov    %ecx,(%edx)
  8001a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a6:	88 d1                	mov    %dl,%cl
  8001a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b9:	75 2c                	jne    8001e7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001bb:	a0 c0 68 81 00       	mov    0x8168c0,%al
  8001c0:	0f b6 c0             	movzbl %al,%eax
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	8b 12                	mov    (%edx),%edx
  8001c8:	89 d1                	mov    %edx,%ecx
  8001ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cd:	83 c2 08             	add    $0x8,%edx
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	50                   	push   %eax
  8001d4:	51                   	push   %ecx
  8001d5:	52                   	push   %edx
  8001d6:	e8 4e 0e 00 00       	call   801029 <sys_cputs>
  8001db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	8b 40 04             	mov    0x4(%eax),%eax
  8001ed:	8d 50 01             	lea    0x1(%eax),%edx
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800202:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800209:	00 00 00 
	b.cnt = 0;
  80020c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800213:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800216:	ff 75 0c             	pushl  0xc(%ebp)
  800219:	ff 75 08             	pushl  0x8(%ebp)
  80021c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800222:	50                   	push   %eax
  800223:	68 90 01 80 00       	push   $0x800190
  800228:	e8 11 02 00 00       	call   80043e <vprintfmt>
  80022d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800230:	a0 c0 68 81 00       	mov    0x8168c0,%al
  800235:	0f b6 c0             	movzbl %al,%eax
  800238:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	50                   	push   %eax
  800242:	52                   	push   %edx
  800243:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800249:	83 c0 08             	add    $0x8,%eax
  80024c:	50                   	push   %eax
  80024d:	e8 d7 0d 00 00       	call   801029 <sys_cputs>
  800252:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800255:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
	return b.cnt;
  80025c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80026a:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
	va_start(ap, fmt);
  800271:	8d 45 0c             	lea    0xc(%ebp),%eax
  800274:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800277:	8b 45 08             	mov    0x8(%ebp),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 75 f4             	pushl  -0xc(%ebp)
  800280:	50                   	push   %eax
  800281:	e8 73 ff ff ff       	call   8001f9 <vcprintf>
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800297:	e8 cf 0d 00 00       	call   80106b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80029c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 48 ff ff ff       	call   8001f9 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002b7:	e8 c9 0d 00 00       	call   801085 <sys_unlock_cons>
	return cnt;
  8002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	53                   	push   %ebx
  8002c5:	83 ec 14             	sub    $0x14,%esp
  8002c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002df:	77 55                	ja     800336 <printnum+0x75>
  8002e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e4:	72 05                	jb     8002eb <printnum+0x2a>
  8002e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e9:	77 4b                	ja     800336 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f9:	52                   	push   %edx
  8002fa:	50                   	push   %eax
  8002fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800301:	e8 a6 15 00 00       	call   8018ac <__udivdi3>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	ff 75 20             	pushl  0x20(%ebp)
  80030f:	53                   	push   %ebx
  800310:	ff 75 18             	pushl  0x18(%ebp)
  800313:	52                   	push   %edx
  800314:	50                   	push   %eax
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 a1 ff ff ff       	call   8002c1 <printnum>
  800320:	83 c4 20             	add    $0x20,%esp
  800323:	eb 1a                	jmp    80033f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 20             	pushl  0x20(%ebp)
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	ff d0                	call   *%eax
  800333:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800336:	ff 4d 1c             	decl   0x1c(%ebp)
  800339:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80033d:	7f e6                	jg     800325 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800342:	bb 00 00 00 00       	mov    $0x0,%ebx
  800347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80034d:	53                   	push   %ebx
  80034e:	51                   	push   %ecx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	e8 66 16 00 00       	call   8019bc <__umoddi3>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	05 34 1e 80 00       	add    $0x801e34,%eax
  80035e:	8a 00                	mov    (%eax),%al
  800360:	0f be c0             	movsbl %al,%eax
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	ff 75 0c             	pushl  0xc(%ebp)
  800369:	50                   	push   %eax
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	ff d0                	call   *%eax
  80036f:	83 c4 10             	add    $0x10,%esp
}
  800372:	90                   	nop
  800373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80037b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037f:	7e 1c                	jle    80039d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 50 08             	lea    0x8(%eax),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 10                	mov    %edx,(%eax)
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	83 e8 08             	sub    $0x8,%eax
  800396:	8b 50 04             	mov    0x4(%eax),%edx
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	eb 40                	jmp    8003dd <getuint+0x65>
	else if (lflag)
  80039d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a1:	74 1e                	je     8003c1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	8d 50 04             	lea    0x4(%eax),%edx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	89 10                	mov    %edx,(%eax)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	83 e8 04             	sub    $0x4,%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bf:	eb 1c                	jmp    8003dd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	8d 50 04             	lea    0x4(%eax),%edx
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	89 10                	mov    %edx,(%eax)
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	83 e8 04             	sub    $0x4,%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e6:	7e 1c                	jle    800404 <getint+0x25>
		return va_arg(*ap, long long);
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 08             	lea    0x8(%eax),%edx
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	83 e8 08             	sub    $0x8,%eax
  8003fd:	8b 50 04             	mov    0x4(%eax),%edx
  800400:	8b 00                	mov    (%eax),%eax
  800402:	eb 38                	jmp    80043c <getint+0x5d>
	else if (lflag)
  800404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800408:	74 1a                	je     800424 <getint+0x45>
		return va_arg(*ap, long);
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	8d 50 04             	lea    0x4(%eax),%edx
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	89 10                	mov    %edx,(%eax)
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	83 e8 04             	sub    $0x4,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	99                   	cltd   
  800422:	eb 18                	jmp    80043c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	8d 50 04             	lea    0x4(%eax),%edx
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	89 10                	mov    %edx,(%eax)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	83 e8 04             	sub    $0x4,%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	99                   	cltd   
}
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800446:	eb 17                	jmp    80045f <vprintfmt+0x21>
			if (ch == '\0')
  800448:	85 db                	test   %ebx,%ebx
  80044a:	0f 84 c1 03 00 00    	je     800811 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	53                   	push   %ebx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	8d 50 01             	lea    0x1(%eax),%edx
  800465:	89 55 10             	mov    %edx,0x10(%ebp)
  800468:	8a 00                	mov    (%eax),%al
  80046a:	0f b6 d8             	movzbl %al,%ebx
  80046d:	83 fb 25             	cmp    $0x25,%ebx
  800470:	75 d6                	jne    800448 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800472:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80047d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800484:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80048b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 45 10             	mov    0x10(%ebp),%eax
  800495:	8d 50 01             	lea    0x1(%eax),%edx
  800498:	89 55 10             	mov    %edx,0x10(%ebp)
  80049b:	8a 00                	mov    (%eax),%al
  80049d:	0f b6 d8             	movzbl %al,%ebx
  8004a0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a3:	83 f8 5b             	cmp    $0x5b,%eax
  8004a6:	0f 87 3d 03 00 00    	ja     8007e9 <vprintfmt+0x3ab>
  8004ac:	8b 04 85 58 1e 80 00 	mov    0x801e58(,%eax,4),%eax
  8004b3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b9:	eb d7                	jmp    800492 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004bb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004bf:	eb d1                	jmp    800492 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cb:	89 d0                	mov    %edx,%eax
  8004cd:	c1 e0 02             	shl    $0x2,%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	01 c0                	add    %eax,%eax
  8004d4:	01 d8                	add    %ebx,%eax
  8004d6:	83 e8 30             	sub    $0x30,%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	8a 00                	mov    (%eax),%al
  8004e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8004e7:	7e 3e                	jle    800527 <vprintfmt+0xe9>
  8004e9:	83 fb 39             	cmp    $0x39,%ebx
  8004ec:	7f 39                	jg     800527 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ee:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f1:	eb d5                	jmp    8004c8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	83 c0 04             	add    $0x4,%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 e8 04             	sub    $0x4,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800507:	eb 1f                	jmp    800528 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80050d:	79 83                	jns    800492 <vprintfmt+0x54>
				width = 0;
  80050f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800516:	e9 77 ff ff ff       	jmp    800492 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80051b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800522:	e9 6b ff ff ff       	jmp    800492 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800527:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800528:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052c:	0f 89 60 ff ff ff    	jns    800492 <vprintfmt+0x54>
				width = precision, precision = -1;
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800538:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80053f:	e9 4e ff ff ff       	jmp    800492 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800544:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800547:	e9 46 ff ff ff       	jmp    800492 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	83 c0 04             	add    $0x4,%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	83 e8 04             	sub    $0x4,%eax
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 0c             	pushl  0xc(%ebp)
  800563:	50                   	push   %eax
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	ff d0                	call   *%eax
  800569:	83 c4 10             	add    $0x10,%esp
			break;
  80056c:	e9 9b 02 00 00       	jmp    80080c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	83 c0 04             	add    $0x4,%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 e8 04             	sub    $0x4,%eax
  800580:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800582:	85 db                	test   %ebx,%ebx
  800584:	79 02                	jns    800588 <vprintfmt+0x14a>
				err = -err;
  800586:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800588:	83 fb 64             	cmp    $0x64,%ebx
  80058b:	7f 0b                	jg     800598 <vprintfmt+0x15a>
  80058d:	8b 34 9d a0 1c 80 00 	mov    0x801ca0(,%ebx,4),%esi
  800594:	85 f6                	test   %esi,%esi
  800596:	75 19                	jne    8005b1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800598:	53                   	push   %ebx
  800599:	68 45 1e 80 00       	push   $0x801e45
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	ff 75 08             	pushl  0x8(%ebp)
  8005a4:	e8 70 02 00 00       	call   800819 <printfmt>
  8005a9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005ac:	e9 5b 02 00 00       	jmp    80080c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b1:	56                   	push   %esi
  8005b2:	68 4e 1e 80 00       	push   $0x801e4e
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	ff 75 08             	pushl  0x8(%ebp)
  8005bd:	e8 57 02 00 00       	call   800819 <printfmt>
  8005c2:	83 c4 10             	add    $0x10,%esp
			break;
  8005c5:	e9 42 02 00 00       	jmp    80080c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 e8 04             	sub    $0x4,%eax
  8005d9:	8b 30                	mov    (%eax),%esi
  8005db:	85 f6                	test   %esi,%esi
  8005dd:	75 05                	jne    8005e4 <vprintfmt+0x1a6>
				p = "(null)";
  8005df:	be 51 1e 80 00       	mov    $0x801e51,%esi
			if (width > 0 && padc != '-')
  8005e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e8:	7e 6d                	jle    800657 <vprintfmt+0x219>
  8005ea:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005ee:	74 67                	je     800657 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	50                   	push   %eax
  8005f7:	56                   	push   %esi
  8005f8:	e8 1e 03 00 00       	call   80091b <strnlen>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800603:	eb 16                	jmp    80061b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800605:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	50                   	push   %eax
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	ff d0                	call   *%eax
  800615:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800618:	ff 4d e4             	decl   -0x1c(%ebp)
  80061b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061f:	7f e4                	jg     800605 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800621:	eb 34                	jmp    800657 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800623:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800627:	74 1c                	je     800645 <vprintfmt+0x207>
  800629:	83 fb 1f             	cmp    $0x1f,%ebx
  80062c:	7e 05                	jle    800633 <vprintfmt+0x1f5>
  80062e:	83 fb 7e             	cmp    $0x7e,%ebx
  800631:	7e 12                	jle    800645 <vprintfmt+0x207>
					putch('?', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	6a 3f                	push   $0x3f
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	eb 0f                	jmp    800654 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	53                   	push   %ebx
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800654:	ff 4d e4             	decl   -0x1c(%ebp)
  800657:	89 f0                	mov    %esi,%eax
  800659:	8d 70 01             	lea    0x1(%eax),%esi
  80065c:	8a 00                	mov    (%eax),%al
  80065e:	0f be d8             	movsbl %al,%ebx
  800661:	85 db                	test   %ebx,%ebx
  800663:	74 24                	je     800689 <vprintfmt+0x24b>
  800665:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800669:	78 b8                	js     800623 <vprintfmt+0x1e5>
  80066b:	ff 4d e0             	decl   -0x20(%ebp)
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	79 af                	jns    800623 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	eb 13                	jmp    800689 <vprintfmt+0x24b>
				putch(' ', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	6a 20                	push   $0x20
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800686:	ff 4d e4             	decl   -0x1c(%ebp)
  800689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068d:	7f e7                	jg     800676 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80068f:	e9 78 01 00 00       	jmp    80080c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 e8             	pushl  -0x18(%ebp)
  80069a:	8d 45 14             	lea    0x14(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	e8 3c fd ff ff       	call   8003df <getint>
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	85 d2                	test   %edx,%edx
  8006b4:	79 23                	jns    8006d9 <vprintfmt+0x29b>
				putch('-', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	6a 2d                	push   $0x2d
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006cc:	f7 d8                	neg    %eax
  8006ce:	83 d2 00             	adc    $0x0,%edx
  8006d1:	f7 da                	neg    %edx
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e0:	e9 bc 00 00 00       	jmp    8007a1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	e8 84 fc ff ff       	call   800378 <getuint>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800704:	e9 98 00 00 00       	jmp    8007a1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	6a 58                	push   $0x58
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	6a 58                	push   $0x58
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	6a 58                	push   $0x58
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	ff d0                	call   *%eax
  800736:	83 c4 10             	add    $0x10,%esp
			break;
  800739:	e9 ce 00 00 00       	jmp    80080c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	6a 30                	push   $0x30
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	ff d0                	call   *%eax
  80074b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 78                	push   $0x78
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	83 c0 04             	add    $0x4,%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800772:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800779:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800780:	eb 1f                	jmp    8007a1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 e8             	pushl  -0x18(%ebp)
  800788:	8d 45 14             	lea    0x14(%ebp),%eax
  80078b:	50                   	push   %eax
  80078c:	e8 e7 fb ff ff       	call   800378 <getuint>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800797:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80079a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	52                   	push   %edx
  8007ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007af:	50                   	push   %eax
  8007b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 00 fb ff ff       	call   8002c1 <printnum>
  8007c1:	83 c4 20             	add    $0x20,%esp
			break;
  8007c4:	eb 46                	jmp    80080c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			break;
  8007d5:	eb 35                	jmp    80080c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007d7:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
			break;
  8007de:	eb 2c                	jmp    80080c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007e0:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
			break;
  8007e7:	eb 23                	jmp    80080c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 0c             	pushl  0xc(%ebp)
  8007ef:	6a 25                	push   $0x25
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f9:	ff 4d 10             	decl   0x10(%ebp)
  8007fc:	eb 03                	jmp    800801 <vprintfmt+0x3c3>
  8007fe:	ff 4d 10             	decl   0x10(%ebp)
  800801:	8b 45 10             	mov    0x10(%ebp),%eax
  800804:	48                   	dec    %eax
  800805:	8a 00                	mov    (%eax),%al
  800807:	3c 25                	cmp    $0x25,%al
  800809:	75 f3                	jne    8007fe <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80080b:	90                   	nop
		}
	}
  80080c:	e9 35 fc ff ff       	jmp    800446 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800811:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800815:	5b                   	pop    %ebx
  800816:	5e                   	pop    %esi
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80081f:	8d 45 10             	lea    0x10(%ebp),%eax
  800822:	83 c0 04             	add    $0x4,%eax
  800825:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800828:	8b 45 10             	mov    0x10(%ebp),%eax
  80082b:	ff 75 f4             	pushl  -0xc(%ebp)
  80082e:	50                   	push   %eax
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	ff 75 08             	pushl  0x8(%ebp)
  800835:	e8 04 fc ff ff       	call   80043e <vprintfmt>
  80083a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80083d:	90                   	nop
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800843:	8b 45 0c             	mov    0xc(%ebp),%eax
  800846:	8b 40 08             	mov    0x8(%eax),%eax
  800849:	8d 50 01             	lea    0x1(%eax),%edx
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800852:	8b 45 0c             	mov    0xc(%ebp),%eax
  800855:	8b 10                	mov    (%eax),%edx
  800857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085a:	8b 40 04             	mov    0x4(%eax),%eax
  80085d:	39 c2                	cmp    %eax,%edx
  80085f:	73 12                	jae    800873 <sprintputch+0x33>
		*b->buf++ = ch;
  800861:	8b 45 0c             	mov    0xc(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	8d 48 01             	lea    0x1(%eax),%ecx
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 0a                	mov    %ecx,(%edx)
  80086e:	8b 55 08             	mov    0x8(%ebp),%edx
  800871:	88 10                	mov    %dl,(%eax)
}
  800873:	90                   	nop
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800882:	8b 45 0c             	mov    0xc(%ebp),%eax
  800885:	8d 50 ff             	lea    -0x1(%eax),%edx
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	01 d0                	add    %edx,%eax
  80088d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800897:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80089b:	74 06                	je     8008a3 <vsnprintf+0x2d>
  80089d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a1:	7f 07                	jg     8008aa <vsnprintf+0x34>
		return -E_INVAL;
  8008a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8008a8:	eb 20                	jmp    8008ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008aa:	ff 75 14             	pushl  0x14(%ebp)
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	50                   	push   %eax
  8008b4:	68 40 08 80 00       	push   $0x800840
  8008b9:	e8 80 fb ff ff       	call   80043e <vprintfmt>
  8008be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d5:	83 c0 04             	add    $0x4,%eax
  8008d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008db:	8b 45 10             	mov    0x10(%ebp),%eax
  8008de:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 89 ff ff ff       	call   800876 <vsnprintf>
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800905:	eb 06                	jmp    80090d <strlen+0x15>
		n++;
  800907:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80090a:	ff 45 08             	incl   0x8(%ebp)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8a 00                	mov    (%eax),%al
  800912:	84 c0                	test   %al,%al
  800914:	75 f1                	jne    800907 <strlen+0xf>
		n++;
	return n;
  800916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800928:	eb 09                	jmp    800933 <strnlen+0x18>
		n++;
  80092a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092d:	ff 45 08             	incl   0x8(%ebp)
  800930:	ff 4d 0c             	decl   0xc(%ebp)
  800933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800937:	74 09                	je     800942 <strnlen+0x27>
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	84 c0                	test   %al,%al
  800940:	75 e8                	jne    80092a <strnlen+0xf>
		n++;
	return n;
  800942:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800953:	90                   	nop
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8d 50 01             	lea    0x1(%eax),%edx
  80095a:	89 55 08             	mov    %edx,0x8(%ebp)
  80095d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800960:	8d 4a 01             	lea    0x1(%edx),%ecx
  800963:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800966:	8a 12                	mov    (%edx),%dl
  800968:	88 10                	mov    %dl,(%eax)
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	84 c0                	test   %al,%al
  80096e:	75 e4                	jne    800954 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800970:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800981:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800988:	eb 1f                	jmp    8009a9 <strncpy+0x34>
		*dst++ = *src;
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8d 50 01             	lea    0x1(%eax),%edx
  800990:	89 55 08             	mov    %edx,0x8(%ebp)
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8a 12                	mov    (%edx),%dl
  800998:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8a 00                	mov    (%eax),%al
  80099f:	84 c0                	test   %al,%al
  8009a1:	74 03                	je     8009a6 <strncpy+0x31>
			src++;
  8009a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a6:	ff 45 fc             	incl   -0x4(%ebp)
  8009a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009af:	72 d9                	jb     80098a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c6:	74 30                	je     8009f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009c8:	eb 16                	jmp    8009e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009dc:	8a 12                	mov    (%edx),%dl
  8009de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e0:	ff 4d 10             	decl   0x10(%ebp)
  8009e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e7:	74 09                	je     8009f2 <strlcpy+0x3c>
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	8a 00                	mov    (%eax),%al
  8009ee:	84 c0                	test   %al,%al
  8009f0:	75 d8                	jne    8009ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009fe:	29 c2                	sub    %eax,%edx
  800a00:	89 d0                	mov    %edx,%eax
}
  800a02:	c9                   	leave  
  800a03:	c3                   	ret    

00800a04 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a07:	eb 06                	jmp    800a0f <strcmp+0xb>
		p++, q++;
  800a09:	ff 45 08             	incl   0x8(%ebp)
  800a0c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8a 00                	mov    (%eax),%al
  800a14:	84 c0                	test   %al,%al
  800a16:	74 0e                	je     800a26 <strcmp+0x22>
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8a 10                	mov    (%eax),%dl
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	8a 00                	mov    (%eax),%al
  800a22:	38 c2                	cmp    %al,%dl
  800a24:	74 e3                	je     800a09 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	0f b6 d0             	movzbl %al,%edx
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	0f b6 c0             	movzbl %al,%eax
  800a36:	29 c2                	sub    %eax,%edx
  800a38:	89 d0                	mov    %edx,%eax
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a3f:	eb 09                	jmp    800a4a <strncmp+0xe>
		n--, p++, q++;
  800a41:	ff 4d 10             	decl   0x10(%ebp)
  800a44:	ff 45 08             	incl   0x8(%ebp)
  800a47:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4e:	74 17                	je     800a67 <strncmp+0x2b>
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8a 00                	mov    (%eax),%al
  800a55:	84 c0                	test   %al,%al
  800a57:	74 0e                	je     800a67 <strncmp+0x2b>
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8a 10                	mov    (%eax),%dl
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	38 c2                	cmp    %al,%dl
  800a65:	74 da                	je     800a41 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6b:	75 07                	jne    800a74 <strncmp+0x38>
		return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	eb 14                	jmp    800a88 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	0f b6 d0             	movzbl %al,%edx
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	8a 00                	mov    (%eax),%al
  800a81:	0f b6 c0             	movzbl %al,%eax
  800a84:	29 c2                	sub    %eax,%edx
  800a86:	89 d0                	mov    %edx,%eax
}
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 04             	sub    $0x4,%esp
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a96:	eb 12                	jmp    800aaa <strchr+0x20>
		if (*s == c)
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aa0:	75 05                	jne    800aa7 <strchr+0x1d>
			return (char *) s;
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	eb 11                	jmp    800ab8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aa7:	ff 45 08             	incl   0x8(%ebp)
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8a 00                	mov    (%eax),%al
  800aaf:	84 c0                	test   %al,%al
  800ab1:	75 e5                	jne    800a98 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac6:	eb 0d                	jmp    800ad5 <strfind+0x1b>
		if (*s == c)
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad0:	74 0e                	je     800ae0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad2:	ff 45 08             	incl   0x8(%ebp)
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8a 00                	mov    (%eax),%al
  800ada:	84 c0                	test   %al,%al
  800adc:	75 ea                	jne    800ac8 <strfind+0xe>
  800ade:	eb 01                	jmp    800ae1 <strfind+0x27>
		if (*s == c)
			break;
  800ae0:	90                   	nop
	return (char *) s;
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800af8:	eb 0e                	jmp    800b08 <memset+0x22>
		*p++ = c;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b08:	ff 4d f8             	decl   -0x8(%ebp)
  800b0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b0f:	79 e9                	jns    800afa <memset+0x14>
		*p++ = c;

	return v;
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b14:	c9                   	leave  
  800b15:	c3                   	ret    

00800b16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b28:	eb 16                	jmp    800b40 <memcpy+0x2a>
		*d++ = *s++;
  800b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b2d:	8d 50 01             	lea    0x1(%eax),%edx
  800b30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3c:	8a 12                	mov    (%edx),%dl
  800b3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b46:	89 55 10             	mov    %edx,0x10(%ebp)
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	75 dd                	jne    800b2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6a:	73 50                	jae    800bbc <memmove+0x6a>
  800b6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	01 d0                	add    %edx,%eax
  800b74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b77:	76 43                	jbe    800bbc <memmove+0x6a>
		s += n;
  800b79:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b85:	eb 10                	jmp    800b97 <memmove+0x45>
			*--d = *--s;
  800b87:	ff 4d f8             	decl   -0x8(%ebp)
  800b8a:	ff 4d fc             	decl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	8a 10                	mov    (%eax),%dl
  800b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba0:	85 c0                	test   %eax,%eax
  800ba2:	75 e3                	jne    800b87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba4:	eb 23                	jmp    800bc9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba9:	8d 50 01             	lea    0x1(%eax),%edx
  800bac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800baf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb8:	8a 12                	mov    (%edx),%dl
  800bba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc5:	85 c0                	test   %eax,%eax
  800bc7:	75 dd                	jne    800ba6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be0:	eb 2a                	jmp    800c0c <memcmp+0x3e>
		if (*s1 != *s2)
  800be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be5:	8a 10                	mov    (%eax),%dl
  800be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	38 c2                	cmp    %al,%dl
  800bee:	74 16                	je     800c06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	0f b6 d0             	movzbl %al,%edx
  800bf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	0f b6 c0             	movzbl %al,%eax
  800c00:	29 c2                	sub    %eax,%edx
  800c02:	89 d0                	mov    %edx,%eax
  800c04:	eb 18                	jmp    800c1e <memcmp+0x50>
		s1++, s2++;
  800c06:	ff 45 fc             	incl   -0x4(%ebp)
  800c09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c12:	89 55 10             	mov    %edx,0x10(%ebp)
  800c15:	85 c0                	test   %eax,%eax
  800c17:	75 c9                	jne    800be2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2c:	01 d0                	add    %edx,%eax
  800c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c31:	eb 15                	jmp    800c48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	0f b6 d0             	movzbl %al,%edx
  800c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3e:	0f b6 c0             	movzbl %al,%eax
  800c41:	39 c2                	cmp    %eax,%edx
  800c43:	74 0d                	je     800c52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c45:	ff 45 08             	incl   0x8(%ebp)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c4e:	72 e3                	jb     800c33 <memfind+0x13>
  800c50:	eb 01                	jmp    800c53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c52:	90                   	nop
	return (void *) s;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6c:	eb 03                	jmp    800c71 <strtol+0x19>
		s++;
  800c6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3c 20                	cmp    $0x20,%al
  800c78:	74 f4                	je     800c6e <strtol+0x16>
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	3c 09                	cmp    $0x9,%al
  800c81:	74 eb                	je     800c6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	3c 2b                	cmp    $0x2b,%al
  800c8a:	75 05                	jne    800c91 <strtol+0x39>
		s++;
  800c8c:	ff 45 08             	incl   0x8(%ebp)
  800c8f:	eb 13                	jmp    800ca4 <strtol+0x4c>
	else if (*s == '-')
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	3c 2d                	cmp    $0x2d,%al
  800c98:	75 0a                	jne    800ca4 <strtol+0x4c>
		s++, neg = 1;
  800c9a:	ff 45 08             	incl   0x8(%ebp)
  800c9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca8:	74 06                	je     800cb0 <strtol+0x58>
  800caa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cae:	75 20                	jne    800cd0 <strtol+0x78>
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	3c 30                	cmp    $0x30,%al
  800cb7:	75 17                	jne    800cd0 <strtol+0x78>
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	40                   	inc    %eax
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	3c 78                	cmp    $0x78,%al
  800cc1:	75 0d                	jne    800cd0 <strtol+0x78>
		s += 2, base = 16;
  800cc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cce:	eb 28                	jmp    800cf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd4:	75 15                	jne    800ceb <strtol+0x93>
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 30                	cmp    $0x30,%al
  800cdd:	75 0c                	jne    800ceb <strtol+0x93>
		s++, base = 8;
  800cdf:	ff 45 08             	incl   0x8(%ebp)
  800ce2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ce9:	eb 0d                	jmp    800cf8 <strtol+0xa0>
	else if (base == 0)
  800ceb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cef:	75 07                	jne    800cf8 <strtol+0xa0>
		base = 10;
  800cf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	3c 2f                	cmp    $0x2f,%al
  800cff:	7e 19                	jle    800d1a <strtol+0xc2>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	3c 39                	cmp    $0x39,%al
  800d08:	7f 10                	jg     800d1a <strtol+0xc2>
			dig = *s - '0';
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	0f be c0             	movsbl %al,%eax
  800d12:	83 e8 30             	sub    $0x30,%eax
  800d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d18:	eb 42                	jmp    800d5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	3c 60                	cmp    $0x60,%al
  800d21:	7e 19                	jle    800d3c <strtol+0xe4>
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	3c 7a                	cmp    $0x7a,%al
  800d2a:	7f 10                	jg     800d3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f be c0             	movsbl %al,%eax
  800d34:	83 e8 57             	sub    $0x57,%eax
  800d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3a:	eb 20                	jmp    800d5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	3c 40                	cmp    $0x40,%al
  800d43:	7e 39                	jle    800d7e <strtol+0x126>
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 5a                	cmp    $0x5a,%al
  800d4c:	7f 30                	jg     800d7e <strtol+0x126>
			dig = *s - 'A' + 10;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	0f be c0             	movsbl %al,%eax
  800d56:	83 e8 37             	sub    $0x37,%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d62:	7d 19                	jge    800d7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d6e:	89 c2                	mov    %eax,%edx
  800d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d73:	01 d0                	add    %edx,%eax
  800d75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d78:	e9 7b ff ff ff       	jmp    800cf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d82:	74 08                	je     800d8c <strtol+0x134>
		*endptr = (char *) s;
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d90:	74 07                	je     800d99 <strtol+0x141>
  800d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d95:	f7 d8                	neg    %eax
  800d97:	eb 03                	jmp    800d9c <strtol+0x144>
  800d99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <ltostr>:

void
ltostr(long value, char *str)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db6:	79 13                	jns    800dcb <ltostr+0x2d>
	{
		neg = 1;
  800db8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd3:	99                   	cltd   
  800dd4:	f7 f9                	idiv   %ecx
  800dd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	89 c2                	mov    %eax,%edx
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	01 d0                	add    %edx,%eax
  800de9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dec:	83 c2 30             	add    $0x30,%edx
  800def:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800df9:	f7 e9                	imul   %ecx
  800dfb:	c1 fa 02             	sar    $0x2,%edx
  800dfe:	89 c8                	mov    %ecx,%eax
  800e00:	c1 f8 1f             	sar    $0x1f,%eax
  800e03:	29 c2                	sub    %eax,%edx
  800e05:	89 d0                	mov    %edx,%eax
  800e07:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0e:	75 bb                	jne    800dcb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1a:	48                   	dec    %eax
  800e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e22:	74 3d                	je     800e61 <ltostr+0xc3>
		start = 1 ;
  800e24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e2b:	eb 34                	jmp    800e61 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	01 d0                	add    %edx,%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	01 c2                	add    %eax,%edx
  800e42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	01 c8                	add    %ecx,%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	01 c2                	add    %eax,%edx
  800e56:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e59:	88 02                	mov    %al,(%edx)
		start++ ;
  800e5b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e5e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e67:	7c c4                	jl     800e2d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e69:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	01 d0                	add    %edx,%eax
  800e71:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e74:	90                   	nop
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e7d:	ff 75 08             	pushl  0x8(%ebp)
  800e80:	e8 73 fa ff ff       	call   8008f8 <strlen>
  800e85:	83 c4 04             	add    $0x4,%esp
  800e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	e8 65 fa ff ff       	call   8008f8 <strlen>
  800e93:	83 c4 04             	add    $0x4,%esp
  800e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea7:	eb 17                	jmp    800ec0 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ea9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	01 c2                	add    %eax,%edx
  800eb1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	01 c8                	add    %ecx,%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ebd:	ff 45 fc             	incl   -0x4(%ebp)
  800ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ec6:	7c e1                	jl     800ea9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ec8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ecf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ed6:	eb 1f                	jmp    800ef7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edb:	8d 50 01             	lea    0x1(%eax),%edx
  800ede:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee1:	89 c2                	mov    %eax,%edx
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 c2                	add    %eax,%edx
  800ee8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	01 c8                	add    %ecx,%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ef4:	ff 45 f8             	incl   -0x8(%ebp)
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800efd:	7c d9                	jl     800ed8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800eff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	01 d0                	add    %edx,%eax
  800f07:	c6 00 00             	movb   $0x0,(%eax)
}
  800f0a:	90                   	nop
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	8b 00                	mov    (%eax),%eax
  800f1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f30:	eb 0c                	jmp    800f3e <strsplit+0x31>
			*string++ = 0;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	84 c0                	test   %al,%al
  800f45:	74 18                	je     800f5f <strsplit+0x52>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	0f be c0             	movsbl %al,%eax
  800f4f:	50                   	push   %eax
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	e8 32 fb ff ff       	call   800a8a <strchr>
  800f58:	83 c4 08             	add    $0x8,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	75 d3                	jne    800f32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	74 5a                	je     800fc2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f68:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	83 f8 0f             	cmp    $0xf,%eax
  800f70:	75 07                	jne    800f79 <strsplit+0x6c>
		{
			return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
  800f77:	eb 66                	jmp    800fdf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8b 00                	mov    (%eax),%eax
  800f7e:	8d 48 01             	lea    0x1(%eax),%ecx
  800f81:	8b 55 14             	mov    0x14(%ebp),%edx
  800f84:	89 0a                	mov    %ecx,(%edx)
  800f86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 c2                	add    %eax,%edx
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f97:	eb 03                	jmp    800f9c <strsplit+0x8f>
			string++;
  800f99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 8b                	je     800f30 <strsplit+0x23>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f be c0             	movsbl %al,%eax
  800fad:	50                   	push   %eax
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	e8 d4 fa ff ff       	call   800a8a <strchr>
  800fb6:	83 c4 08             	add    $0x8,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	74 dc                	je     800f99 <strsplit+0x8c>
			string++;
	}
  800fbd:	e9 6e ff ff ff       	jmp    800f30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fc2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	8b 00                	mov    (%eax),%eax
  800fc8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 d0                	add    %edx,%eax
  800fd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fda:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800fe7:	83 ec 04             	sub    $0x4,%esp
  800fea:	68 c8 1f 80 00       	push   $0x801fc8
  800fef:	68 3f 01 00 00       	push   $0x13f
  800ff4:	68 ea 1f 80 00       	push   $0x801fea
  800ff9:	e8 c5 06 00 00       	call   8016c3 <_panic>

00800ffe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80100d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801010:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801013:	8b 7d 18             	mov    0x18(%ebp),%edi
  801016:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801019:	cd 30                	int    $0x30
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	8b 45 10             	mov    0x10(%ebp),%eax
  801032:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801035:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	6a 00                	push   $0x0
  80103e:	6a 00                	push   $0x0
  801040:	52                   	push   %edx
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	50                   	push   %eax
  801045:	6a 00                	push   $0x0
  801047:	e8 b2 ff ff ff       	call   800ffe <syscall>
  80104c:	83 c4 18             	add    $0x18,%esp
}
  80104f:	90                   	nop
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <sys_cgetc>:

int
sys_cgetc(void)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801055:	6a 00                	push   $0x0
  801057:	6a 00                	push   $0x0
  801059:	6a 00                	push   $0x0
  80105b:	6a 00                	push   $0x0
  80105d:	6a 00                	push   $0x0
  80105f:	6a 02                	push   $0x2
  801061:	e8 98 ff ff ff       	call   800ffe <syscall>
  801066:	83 c4 18             	add    $0x18,%esp
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80106e:	6a 00                	push   $0x0
  801070:	6a 00                	push   $0x0
  801072:	6a 00                	push   $0x0
  801074:	6a 00                	push   $0x0
  801076:	6a 00                	push   $0x0
  801078:	6a 03                	push   $0x3
  80107a:	e8 7f ff ff ff       	call   800ffe <syscall>
  80107f:	83 c4 18             	add    $0x18,%esp
}
  801082:	90                   	nop
  801083:	c9                   	leave  
  801084:	c3                   	ret    

00801085 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801088:	6a 00                	push   $0x0
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	6a 00                	push   $0x0
  801090:	6a 00                	push   $0x0
  801092:	6a 04                	push   $0x4
  801094:	e8 65 ff ff ff       	call   800ffe <syscall>
  801099:	83 c4 18             	add    $0x18,%esp
}
  80109c:	90                   	nop
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	6a 00                	push   $0x0
  8010ae:	52                   	push   %edx
  8010af:	50                   	push   %eax
  8010b0:	6a 08                	push   $0x8
  8010b2:	e8 47 ff ff ff       	call   800ffe <syscall>
  8010b7:	83 c4 18             	add    $0x18,%esp
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	51                   	push   %ecx
  8010d3:	52                   	push   %edx
  8010d4:	50                   	push   %eax
  8010d5:	6a 09                	push   $0x9
  8010d7:	e8 22 ff ff ff       	call   800ffe <syscall>
  8010dc:	83 c4 18             	add    $0x18,%esp
}
  8010df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	6a 00                	push   $0x0
  8010f1:	6a 00                	push   $0x0
  8010f3:	6a 00                	push   $0x0
  8010f5:	52                   	push   %edx
  8010f6:	50                   	push   %eax
  8010f7:	6a 0a                	push   $0xa
  8010f9:	e8 00 ff ff ff       	call   800ffe <syscall>
  8010fe:	83 c4 18             	add    $0x18,%esp
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	6a 0b                	push   $0xb
  801114:	e8 e5 fe ff ff       	call   800ffe <syscall>
  801119:	83 c4 18             	add    $0x18,%esp
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801121:	6a 00                	push   $0x0
  801123:	6a 00                	push   $0x0
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	6a 0c                	push   $0xc
  80112d:	e8 cc fe ff ff       	call   800ffe <syscall>
  801132:	83 c4 18             	add    $0x18,%esp
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 0d                	push   $0xd
  801146:	e8 b3 fe ff ff       	call   800ffe <syscall>
  80114b:	83 c4 18             	add    $0x18,%esp
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 0e                	push   $0xe
  80115f:	e8 9a fe ff ff       	call   800ffe <syscall>
  801164:	83 c4 18             	add    $0x18,%esp
}
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 0f                	push   $0xf
  801178:	e8 81 fe ff ff       	call   800ffe <syscall>
  80117d:	83 c4 18             	add    $0x18,%esp
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	ff 75 08             	pushl  0x8(%ebp)
  801190:	6a 10                	push   $0x10
  801192:	e8 67 fe ff ff       	call   800ffe <syscall>
  801197:	83 c4 18             	add    $0x18,%esp
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 11                	push   $0x11
  8011ab:	e8 4e fe ff ff       	call   800ffe <syscall>
  8011b0:	83 c4 18             	add    $0x18,%esp
}
  8011b3:	90                   	nop
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	50                   	push   %eax
  8011cf:	6a 01                	push   $0x1
  8011d1:	e8 28 fe ff ff       	call   800ffe <syscall>
  8011d6:	83 c4 18             	add    $0x18,%esp
}
  8011d9:	90                   	nop
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 14                	push   $0x14
  8011eb:	e8 0e fe ff ff       	call   800ffe <syscall>
  8011f0:	83 c4 18             	add    $0x18,%esp
}
  8011f3:	90                   	nop
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 04             	sub    $0x4,%esp
  8011fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801202:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801205:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	6a 00                	push   $0x0
  80120e:	51                   	push   %ecx
  80120f:	52                   	push   %edx
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	50                   	push   %eax
  801214:	6a 15                	push   $0x15
  801216:	e8 e3 fd ff ff       	call   800ffe <syscall>
  80121b:	83 c4 18             	add    $0x18,%esp
}
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801223:	8b 55 0c             	mov    0xc(%ebp),%edx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	52                   	push   %edx
  801230:	50                   	push   %eax
  801231:	6a 16                	push   $0x16
  801233:	e8 c6 fd ff ff       	call   800ffe <syscall>
  801238:	83 c4 18             	add    $0x18,%esp
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801240:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801243:	8b 55 0c             	mov    0xc(%ebp),%edx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	51                   	push   %ecx
  80124e:	52                   	push   %edx
  80124f:	50                   	push   %eax
  801250:	6a 17                	push   $0x17
  801252:	e8 a7 fd ff ff       	call   800ffe <syscall>
  801257:	83 c4 18             	add    $0x18,%esp
}
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	52                   	push   %edx
  80126c:	50                   	push   %eax
  80126d:	6a 18                	push   $0x18
  80126f:	e8 8a fd ff ff       	call   800ffe <syscall>
  801274:	83 c4 18             	add    $0x18,%esp
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	6a 00                	push   $0x0
  801281:	ff 75 14             	pushl  0x14(%ebp)
  801284:	ff 75 10             	pushl  0x10(%ebp)
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	50                   	push   %eax
  80128b:	6a 19                	push   $0x19
  80128d:	e8 6c fd ff ff       	call   800ffe <syscall>
  801292:	83 c4 18             	add    $0x18,%esp
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	50                   	push   %eax
  8012a6:	6a 1a                	push   $0x1a
  8012a8:	e8 51 fd ff ff       	call   800ffe <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	90                   	nop
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	50                   	push   %eax
  8012c2:	6a 1b                	push   $0x1b
  8012c4:	e8 35 fd ff ff       	call   800ffe <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 05                	push   $0x5
  8012dd:	e8 1c fd ff ff       	call   800ffe <syscall>
  8012e2:	83 c4 18             	add    $0x18,%esp
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 06                	push   $0x6
  8012f6:	e8 03 fd ff ff       	call   800ffe <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 07                	push   $0x7
  80130f:	e8 ea fc ff ff       	call   800ffe <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_exit_env>:


void sys_exit_env(void)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 1c                	push   $0x1c
  801328:	e8 d1 fc ff ff       	call   800ffe <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801339:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80133c:	8d 50 04             	lea    0x4(%eax),%edx
  80133f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	52                   	push   %edx
  801349:	50                   	push   %eax
  80134a:	6a 1d                	push   $0x1d
  80134c:	e8 ad fc ff ff       	call   800ffe <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
	return result;
  801354:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135d:	89 01                	mov    %eax,(%ecx)
  80135f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	c9                   	leave  
  801366:	c2 04 00             	ret    $0x4

00801369 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	ff 75 10             	pushl  0x10(%ebp)
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	ff 75 08             	pushl  0x8(%ebp)
  801379:	6a 13                	push   $0x13
  80137b:	e8 7e fc ff ff       	call   800ffe <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
	return ;
  801383:	90                   	nop
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_rcr2>:
uint32 sys_rcr2()
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 1e                	push   $0x1e
  801395:	e8 64 fc ff ff       	call   800ffe <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013ab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	50                   	push   %eax
  8013b8:	6a 1f                	push   $0x1f
  8013ba:	e8 3f fc ff ff       	call   800ffe <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8013c2:	90                   	nop
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <rsttst>:
void rsttst()
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 21                	push   $0x21
  8013d4:	e8 25 fc ff ff       	call   800ffe <syscall>
  8013d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8013dc:	90                   	nop
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013eb:	8b 55 18             	mov    0x18(%ebp),%edx
  8013ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f2:	52                   	push   %edx
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 10             	pushl  0x10(%ebp)
  8013f7:	ff 75 0c             	pushl  0xc(%ebp)
  8013fa:	ff 75 08             	pushl  0x8(%ebp)
  8013fd:	6a 20                	push   $0x20
  8013ff:	e8 fa fb ff ff       	call   800ffe <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
	return ;
  801407:	90                   	nop
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <chktst>:
void chktst(uint32 n)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	ff 75 08             	pushl  0x8(%ebp)
  801418:	6a 22                	push   $0x22
  80141a:	e8 df fb ff ff       	call   800ffe <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
	return ;
  801422:	90                   	nop
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <inctst>:

void inctst()
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 23                	push   $0x23
  801434:	e8 c5 fb ff ff       	call   800ffe <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
	return ;
  80143c:	90                   	nop
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <gettst>:
uint32 gettst()
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 24                	push   $0x24
  80144e:	e8 ab fb ff ff       	call   800ffe <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 25                	push   $0x25
  80146a:	e8 8f fb ff ff       	call   800ffe <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
  801472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801475:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801479:	75 07                	jne    801482 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80147b:	b8 01 00 00 00       	mov    $0x1,%eax
  801480:	eb 05                	jmp    801487 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 25                	push   $0x25
  80149b:	e8 5e fb ff ff       	call   800ffe <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
  8014a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014a6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014aa:	75 07                	jne    8014b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b1:	eb 05                	jmp    8014b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 25                	push   $0x25
  8014cc:	e8 2d fb ff ff       	call   800ffe <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
  8014d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014d7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014db:	75 07                	jne    8014e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e2:	eb 05                	jmp    8014e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 25                	push   $0x25
  8014fd:	e8 fc fa ff ff       	call   800ffe <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
  801505:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801508:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80150c:	75 07                	jne    801515 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80150e:	b8 01 00 00 00       	mov    $0x1,%eax
  801513:	eb 05                	jmp    80151a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	ff 75 08             	pushl  0x8(%ebp)
  80152a:	6a 26                	push   $0x26
  80152c:	e8 cd fa ff ff       	call   800ffe <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
	return ;
  801534:	90                   	nop
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80153b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80153e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801541:	8b 55 0c             	mov    0xc(%ebp),%edx
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	53                   	push   %ebx
  80154a:	51                   	push   %ecx
  80154b:	52                   	push   %edx
  80154c:	50                   	push   %eax
  80154d:	6a 27                	push   $0x27
  80154f:	e8 aa fa ff ff       	call   800ffe <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80155f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	52                   	push   %edx
  80156c:	50                   	push   %eax
  80156d:	6a 28                	push   $0x28
  80156f:	e8 8a fa ff ff       	call   800ffe <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80157c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80157f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	51                   	push   %ecx
  801588:	ff 75 10             	pushl  0x10(%ebp)
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	6a 29                	push   $0x29
  80158f:	e8 6a fa ff ff       	call   800ffe <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	ff 75 10             	pushl  0x10(%ebp)
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	ff 75 08             	pushl  0x8(%ebp)
  8015a9:	6a 12                	push   $0x12
  8015ab:	e8 4e fa ff ff       	call   800ffe <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b3:	90                   	nop
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	52                   	push   %edx
  8015c6:	50                   	push   %eax
  8015c7:	6a 2a                	push   $0x2a
  8015c9:	e8 30 fa ff ff       	call   800ffe <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
	return;
  8015d1:	90                   	nop
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	50                   	push   %eax
  8015e3:	6a 2b                	push   $0x2b
  8015e5:	e8 14 fa ff ff       	call   800ffe <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 2c                	push   $0x2c
  801600:	e8 f9 f9 ff ff       	call   800ffe <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
	return;
  801608:	90                   	nop
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	ff 75 08             	pushl  0x8(%ebp)
  80161a:	6a 2d                	push   $0x2d
  80161c:	e8 dd f9 ff ff       	call   800ffe <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
	return;
  801624:	90                   	nop
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 2e                	push   $0x2e
  801639:	e8 c0 f9 ff ff       	call   800ffe <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801644:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	50                   	push   %eax
  801658:	6a 2f                	push   $0x2f
  80165a:	e8 9f f9 ff ff       	call   800ffe <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
	return;
  801662:	90                   	nop
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	52                   	push   %edx
  801675:	50                   	push   %eax
  801676:	6a 30                	push   $0x30
  801678:	e8 81 f9 ff ff       	call   800ffe <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	50                   	push   %eax
  801695:	6a 31                	push   $0x31
  801697:	e8 62 f9 ff ff       	call   800ffe <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
  80169f:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8016a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	50                   	push   %eax
  8016b6:	6a 32                	push   $0x32
  8016b8:	e8 41 f9 ff ff       	call   800ffe <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
	return;
  8016c0:	90                   	nop
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8016cc:	83 c0 04             	add    $0x4,%eax
  8016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016d2:	a1 e4 68 81 00       	mov    0x8168e4,%eax
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	74 16                	je     8016f1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016db:	a1 e4 68 81 00       	mov    0x8168e4,%eax
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	50                   	push   %eax
  8016e4:	68 f8 1f 80 00       	push   $0x801ff8
  8016e9:	e8 76 eb ff ff       	call   800264 <cprintf>
  8016ee:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016f1:	a1 00 30 80 00       	mov    0x803000,%eax
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	68 fd 1f 80 00       	push   $0x801ffd
  801702:	e8 5d eb ff ff       	call   800264 <cprintf>
  801707:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	ff 75 f4             	pushl  -0xc(%ebp)
  801713:	50                   	push   %eax
  801714:	e8 e0 ea ff ff       	call   8001f9 <vcprintf>
  801719:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	6a 00                	push   $0x0
  801721:	68 19 20 80 00       	push   $0x802019
  801726:	e8 ce ea ff ff       	call   8001f9 <vcprintf>
  80172b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80172e:	e8 4f ea ff ff       	call   800182 <exit>

	// should not return here
	while (1) ;
  801733:	eb fe                	jmp    801733 <_panic+0x70>

00801735 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80173b:	a1 20 30 80 00       	mov    0x803020,%eax
  801740:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	39 c2                	cmp    %eax,%edx
  80174b:	74 14                	je     801761 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 1c 20 80 00       	push   $0x80201c
  801755:	6a 26                	push   $0x26
  801757:	68 68 20 80 00       	push   $0x802068
  80175c:	e8 62 ff ff ff       	call   8016c3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801761:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801768:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80176f:	e9 c5 00 00 00       	jmp    801839 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801777:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	01 d0                	add    %edx,%eax
  801783:	8b 00                	mov    (%eax),%eax
  801785:	85 c0                	test   %eax,%eax
  801787:	75 08                	jne    801791 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801789:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80178c:	e9 a5 00 00 00       	jmp    801836 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801791:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801798:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80179f:	eb 69                	jmp    80180a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8017a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8017a6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017af:	89 d0                	mov    %edx,%eax
  8017b1:	01 c0                	add    %eax,%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	c1 e0 03             	shl    $0x3,%eax
  8017b8:	01 c8                	add    %ecx,%eax
  8017ba:	8a 40 04             	mov    0x4(%eax),%al
  8017bd:	84 c0                	test   %al,%al
  8017bf:	75 46                	jne    801807 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8017c6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017cf:	89 d0                	mov    %edx,%eax
  8017d1:	01 c0                	add    %eax,%eax
  8017d3:	01 d0                	add    %edx,%eax
  8017d5:	c1 e0 03             	shl    $0x3,%eax
  8017d8:	01 c8                	add    %ecx,%eax
  8017da:	8b 00                	mov    (%eax),%eax
  8017dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	01 c8                	add    %ecx,%eax
  8017f8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017fa:	39 c2                	cmp    %eax,%edx
  8017fc:	75 09                	jne    801807 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017fe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801805:	eb 15                	jmp    80181c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801807:	ff 45 e8             	incl   -0x18(%ebp)
  80180a:	a1 20 30 80 00       	mov    0x803020,%eax
  80180f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801818:	39 c2                	cmp    %eax,%edx
  80181a:	77 85                	ja     8017a1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80181c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801820:	75 14                	jne    801836 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 74 20 80 00       	push   $0x802074
  80182a:	6a 3a                	push   $0x3a
  80182c:	68 68 20 80 00       	push   $0x802068
  801831:	e8 8d fe ff ff       	call   8016c3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801836:	ff 45 f0             	incl   -0x10(%ebp)
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80183f:	0f 8c 2f ff ff ff    	jl     801774 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801845:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80184c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801853:	eb 26                	jmp    80187b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801855:	a1 20 30 80 00       	mov    0x803020,%eax
  80185a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801860:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801863:	89 d0                	mov    %edx,%eax
  801865:	01 c0                	add    %eax,%eax
  801867:	01 d0                	add    %edx,%eax
  801869:	c1 e0 03             	shl    $0x3,%eax
  80186c:	01 c8                	add    %ecx,%eax
  80186e:	8a 40 04             	mov    0x4(%eax),%al
  801871:	3c 01                	cmp    $0x1,%al
  801873:	75 03                	jne    801878 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801875:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801878:	ff 45 e0             	incl   -0x20(%ebp)
  80187b:	a1 20 30 80 00       	mov    0x803020,%eax
  801880:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801889:	39 c2                	cmp    %eax,%edx
  80188b:	77 c8                	ja     801855 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801890:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801893:	74 14                	je     8018a9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 c8 20 80 00       	push   $0x8020c8
  80189d:	6a 44                	push   $0x44
  80189f:	68 68 20 80 00       	push   $0x802068
  8018a4:	e8 1a fe ff ff       	call   8016c3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8018a9:	90                   	nop
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <__udivdi3>:
  8018ac:	55                   	push   %ebp
  8018ad:	57                   	push   %edi
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 1c             	sub    $0x1c,%esp
  8018b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018c3:	89 ca                	mov    %ecx,%edx
  8018c5:	89 f8                	mov    %edi,%eax
  8018c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018cb:	85 f6                	test   %esi,%esi
  8018cd:	75 2d                	jne    8018fc <__udivdi3+0x50>
  8018cf:	39 cf                	cmp    %ecx,%edi
  8018d1:	77 65                	ja     801938 <__udivdi3+0x8c>
  8018d3:	89 fd                	mov    %edi,%ebp
  8018d5:	85 ff                	test   %edi,%edi
  8018d7:	75 0b                	jne    8018e4 <__udivdi3+0x38>
  8018d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018de:	31 d2                	xor    %edx,%edx
  8018e0:	f7 f7                	div    %edi
  8018e2:	89 c5                	mov    %eax,%ebp
  8018e4:	31 d2                	xor    %edx,%edx
  8018e6:	89 c8                	mov    %ecx,%eax
  8018e8:	f7 f5                	div    %ebp
  8018ea:	89 c1                	mov    %eax,%ecx
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	f7 f5                	div    %ebp
  8018f0:	89 cf                	mov    %ecx,%edi
  8018f2:	89 fa                	mov    %edi,%edx
  8018f4:	83 c4 1c             	add    $0x1c,%esp
  8018f7:	5b                   	pop    %ebx
  8018f8:	5e                   	pop    %esi
  8018f9:	5f                   	pop    %edi
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    
  8018fc:	39 ce                	cmp    %ecx,%esi
  8018fe:	77 28                	ja     801928 <__udivdi3+0x7c>
  801900:	0f bd fe             	bsr    %esi,%edi
  801903:	83 f7 1f             	xor    $0x1f,%edi
  801906:	75 40                	jne    801948 <__udivdi3+0x9c>
  801908:	39 ce                	cmp    %ecx,%esi
  80190a:	72 0a                	jb     801916 <__udivdi3+0x6a>
  80190c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801910:	0f 87 9e 00 00 00    	ja     8019b4 <__udivdi3+0x108>
  801916:	b8 01 00 00 00       	mov    $0x1,%eax
  80191b:	89 fa                	mov    %edi,%edx
  80191d:	83 c4 1c             	add    $0x1c,%esp
  801920:	5b                   	pop    %ebx
  801921:	5e                   	pop    %esi
  801922:	5f                   	pop    %edi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    
  801925:	8d 76 00             	lea    0x0(%esi),%esi
  801928:	31 ff                	xor    %edi,%edi
  80192a:	31 c0                	xor    %eax,%eax
  80192c:	89 fa                	mov    %edi,%edx
  80192e:	83 c4 1c             	add    $0x1c,%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5f                   	pop    %edi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    
  801936:	66 90                	xchg   %ax,%ax
  801938:	89 d8                	mov    %ebx,%eax
  80193a:	f7 f7                	div    %edi
  80193c:	31 ff                	xor    %edi,%edi
  80193e:	89 fa                	mov    %edi,%edx
  801940:	83 c4 1c             	add    $0x1c,%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5f                   	pop    %edi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    
  801948:	bd 20 00 00 00       	mov    $0x20,%ebp
  80194d:	89 eb                	mov    %ebp,%ebx
  80194f:	29 fb                	sub    %edi,%ebx
  801951:	89 f9                	mov    %edi,%ecx
  801953:	d3 e6                	shl    %cl,%esi
  801955:	89 c5                	mov    %eax,%ebp
  801957:	88 d9                	mov    %bl,%cl
  801959:	d3 ed                	shr    %cl,%ebp
  80195b:	89 e9                	mov    %ebp,%ecx
  80195d:	09 f1                	or     %esi,%ecx
  80195f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801963:	89 f9                	mov    %edi,%ecx
  801965:	d3 e0                	shl    %cl,%eax
  801967:	89 c5                	mov    %eax,%ebp
  801969:	89 d6                	mov    %edx,%esi
  80196b:	88 d9                	mov    %bl,%cl
  80196d:	d3 ee                	shr    %cl,%esi
  80196f:	89 f9                	mov    %edi,%ecx
  801971:	d3 e2                	shl    %cl,%edx
  801973:	8b 44 24 08          	mov    0x8(%esp),%eax
  801977:	88 d9                	mov    %bl,%cl
  801979:	d3 e8                	shr    %cl,%eax
  80197b:	09 c2                	or     %eax,%edx
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	89 f2                	mov    %esi,%edx
  801981:	f7 74 24 0c          	divl   0xc(%esp)
  801985:	89 d6                	mov    %edx,%esi
  801987:	89 c3                	mov    %eax,%ebx
  801989:	f7 e5                	mul    %ebp
  80198b:	39 d6                	cmp    %edx,%esi
  80198d:	72 19                	jb     8019a8 <__udivdi3+0xfc>
  80198f:	74 0b                	je     80199c <__udivdi3+0xf0>
  801991:	89 d8                	mov    %ebx,%eax
  801993:	31 ff                	xor    %edi,%edi
  801995:	e9 58 ff ff ff       	jmp    8018f2 <__udivdi3+0x46>
  80199a:	66 90                	xchg   %ax,%ax
  80199c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019a0:	89 f9                	mov    %edi,%ecx
  8019a2:	d3 e2                	shl    %cl,%edx
  8019a4:	39 c2                	cmp    %eax,%edx
  8019a6:	73 e9                	jae    801991 <__udivdi3+0xe5>
  8019a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019ab:	31 ff                	xor    %edi,%edi
  8019ad:	e9 40 ff ff ff       	jmp    8018f2 <__udivdi3+0x46>
  8019b2:	66 90                	xchg   %ax,%ax
  8019b4:	31 c0                	xor    %eax,%eax
  8019b6:	e9 37 ff ff ff       	jmp    8018f2 <__udivdi3+0x46>
  8019bb:	90                   	nop

008019bc <__umoddi3>:
  8019bc:	55                   	push   %ebp
  8019bd:	57                   	push   %edi
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	83 ec 1c             	sub    $0x1c,%esp
  8019c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019db:	89 f3                	mov    %esi,%ebx
  8019dd:	89 fa                	mov    %edi,%edx
  8019df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019e3:	89 34 24             	mov    %esi,(%esp)
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	75 1a                	jne    801a04 <__umoddi3+0x48>
  8019ea:	39 f7                	cmp    %esi,%edi
  8019ec:	0f 86 a2 00 00 00    	jbe    801a94 <__umoddi3+0xd8>
  8019f2:	89 c8                	mov    %ecx,%eax
  8019f4:	89 f2                	mov    %esi,%edx
  8019f6:	f7 f7                	div    %edi
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	31 d2                	xor    %edx,%edx
  8019fc:	83 c4 1c             	add    $0x1c,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5f                   	pop    %edi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    
  801a04:	39 f0                	cmp    %esi,%eax
  801a06:	0f 87 ac 00 00 00    	ja     801ab8 <__umoddi3+0xfc>
  801a0c:	0f bd e8             	bsr    %eax,%ebp
  801a0f:	83 f5 1f             	xor    $0x1f,%ebp
  801a12:	0f 84 ac 00 00 00    	je     801ac4 <__umoddi3+0x108>
  801a18:	bf 20 00 00 00       	mov    $0x20,%edi
  801a1d:	29 ef                	sub    %ebp,%edi
  801a1f:	89 fe                	mov    %edi,%esi
  801a21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a25:	89 e9                	mov    %ebp,%ecx
  801a27:	d3 e0                	shl    %cl,%eax
  801a29:	89 d7                	mov    %edx,%edi
  801a2b:	89 f1                	mov    %esi,%ecx
  801a2d:	d3 ef                	shr    %cl,%edi
  801a2f:	09 c7                	or     %eax,%edi
  801a31:	89 e9                	mov    %ebp,%ecx
  801a33:	d3 e2                	shl    %cl,%edx
  801a35:	89 14 24             	mov    %edx,(%esp)
  801a38:	89 d8                	mov    %ebx,%eax
  801a3a:	d3 e0                	shl    %cl,%eax
  801a3c:	89 c2                	mov    %eax,%edx
  801a3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a42:	d3 e0                	shl    %cl,%eax
  801a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4c:	89 f1                	mov    %esi,%ecx
  801a4e:	d3 e8                	shr    %cl,%eax
  801a50:	09 d0                	or     %edx,%eax
  801a52:	d3 eb                	shr    %cl,%ebx
  801a54:	89 da                	mov    %ebx,%edx
  801a56:	f7 f7                	div    %edi
  801a58:	89 d3                	mov    %edx,%ebx
  801a5a:	f7 24 24             	mull   (%esp)
  801a5d:	89 c6                	mov    %eax,%esi
  801a5f:	89 d1                	mov    %edx,%ecx
  801a61:	39 d3                	cmp    %edx,%ebx
  801a63:	0f 82 87 00 00 00    	jb     801af0 <__umoddi3+0x134>
  801a69:	0f 84 91 00 00 00    	je     801b00 <__umoddi3+0x144>
  801a6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a73:	29 f2                	sub    %esi,%edx
  801a75:	19 cb                	sbb    %ecx,%ebx
  801a77:	89 d8                	mov    %ebx,%eax
  801a79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a7d:	d3 e0                	shl    %cl,%eax
  801a7f:	89 e9                	mov    %ebp,%ecx
  801a81:	d3 ea                	shr    %cl,%edx
  801a83:	09 d0                	or     %edx,%eax
  801a85:	89 e9                	mov    %ebp,%ecx
  801a87:	d3 eb                	shr    %cl,%ebx
  801a89:	89 da                	mov    %ebx,%edx
  801a8b:	83 c4 1c             	add    $0x1c,%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5f                   	pop    %edi
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    
  801a93:	90                   	nop
  801a94:	89 fd                	mov    %edi,%ebp
  801a96:	85 ff                	test   %edi,%edi
  801a98:	75 0b                	jne    801aa5 <__umoddi3+0xe9>
  801a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9f:	31 d2                	xor    %edx,%edx
  801aa1:	f7 f7                	div    %edi
  801aa3:	89 c5                	mov    %eax,%ebp
  801aa5:	89 f0                	mov    %esi,%eax
  801aa7:	31 d2                	xor    %edx,%edx
  801aa9:	f7 f5                	div    %ebp
  801aab:	89 c8                	mov    %ecx,%eax
  801aad:	f7 f5                	div    %ebp
  801aaf:	89 d0                	mov    %edx,%eax
  801ab1:	e9 44 ff ff ff       	jmp    8019fa <__umoddi3+0x3e>
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	89 c8                	mov    %ecx,%eax
  801aba:	89 f2                	mov    %esi,%edx
  801abc:	83 c4 1c             	add    $0x1c,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
  801ac4:	3b 04 24             	cmp    (%esp),%eax
  801ac7:	72 06                	jb     801acf <__umoddi3+0x113>
  801ac9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801acd:	77 0f                	ja     801ade <__umoddi3+0x122>
  801acf:	89 f2                	mov    %esi,%edx
  801ad1:	29 f9                	sub    %edi,%ecx
  801ad3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ad7:	89 14 24             	mov    %edx,(%esp)
  801ada:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ade:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ae2:	8b 14 24             	mov    (%esp),%edx
  801ae5:	83 c4 1c             	add    $0x1c,%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5e                   	pop    %esi
  801aea:	5f                   	pop    %edi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    
  801aed:	8d 76 00             	lea    0x0(%esi),%esi
  801af0:	2b 04 24             	sub    (%esp),%eax
  801af3:	19 fa                	sbb    %edi,%edx
  801af5:	89 d1                	mov    %edx,%ecx
  801af7:	89 c6                	mov    %eax,%esi
  801af9:	e9 71 ff ff ff       	jmp    801a6f <__umoddi3+0xb3>
  801afe:	66 90                	xchg   %ax,%ax
  801b00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b04:	72 ea                	jb     801af0 <__umoddi3+0x134>
  801b06:	89 d9                	mov    %ebx,%ecx
  801b08:	e9 62 ff ff ff       	jmp    801a6f <__umoddi3+0xb3>
