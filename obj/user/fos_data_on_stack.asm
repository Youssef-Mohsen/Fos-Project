
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 80 1a 80 00       	push   $0x801a80
  800049:	e8 46 02 00 00       	call   800294 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 8b 12 00 00       	call   8012ea <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 03             	shl    $0x3,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800073:	01 c8                	add    %ecx,%eax
  800075:	01 c0                	add    %eax,%eax
  800077:	01 d0                	add    %edx,%eax
  800079:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800080:	01 c8                	add    %ecx,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800089:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80008e:	a1 04 30 80 00       	mov    0x803004,%eax
  800093:	8a 40 20             	mov    0x20(%eax),%al
  800096:	84 c0                	test   %al,%al
  800098:	74 0d                	je     8000a7 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80009a:	a1 04 30 80 00       	mov    0x803004,%eax
  80009f:	83 c0 20             	add    $0x20,%eax
  8000a2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ab:	7e 0a                	jle    8000b7 <libmain+0x63>
		binaryname = argv[0];
  8000ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b0:	8b 00                	mov    (%eax),%eax
  8000b2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	ff 75 0c             	pushl  0xc(%ebp)
  8000bd:	ff 75 08             	pushl  0x8(%ebp)
  8000c0:	e8 73 ff ff ff       	call   800038 <_main>
  8000c5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000c8:	e8 a1 0f 00 00       	call   80106e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 bc 1a 80 00       	push   $0x801abc
  8000d5:	e8 8d 01 00 00       	call   800267 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8000e2:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ed:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	52                   	push   %edx
  8000f7:	50                   	push   %eax
  8000f8:	68 e4 1a 80 00       	push   $0x801ae4
  8000fd:	e8 65 01 00 00       	call   800267 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800105:	a1 04 30 80 00       	mov    0x803004,%eax
  80010a:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800110:	a1 04 30 80 00       	mov    0x803004,%eax
  800115:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80011b:	a1 04 30 80 00       	mov    0x803004,%eax
  800120:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800126:	51                   	push   %ecx
  800127:	52                   	push   %edx
  800128:	50                   	push   %eax
  800129:	68 0c 1b 80 00       	push   $0x801b0c
  80012e:	e8 34 01 00 00       	call   800267 <cprintf>
  800133:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800136:	a1 04 30 80 00       	mov    0x803004,%eax
  80013b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	50                   	push   %eax
  800145:	68 64 1b 80 00       	push   $0x801b64
  80014a:	e8 18 01 00 00       	call   800267 <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	68 bc 1a 80 00       	push   $0x801abc
  80015a:	e8 08 01 00 00       	call   800267 <cprintf>
  80015f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800162:	e8 21 0f 00 00       	call   801088 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800167:	e8 19 00 00 00       	call   800185 <exit>
}
  80016c:	90                   	nop
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	6a 00                	push   $0x0
  80017a:	e8 37 11 00 00       	call   8012b6 <sys_destroy_env>
  80017f:	83 c4 10             	add    $0x10,%esp
}
  800182:	90                   	nop
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <exit>:

void
exit(void)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018b:	e8 8c 11 00 00       	call   80131c <sys_exit_env>
}
  800190:	90                   	nop
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a4:	89 0a                	mov    %ecx,(%edx)
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	88 d1                	mov    %dl,%cl
  8001ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b5:	8b 00                	mov    (%eax),%eax
  8001b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bc:	75 2c                	jne    8001ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001be:	a0 08 30 80 00       	mov    0x803008,%al
  8001c3:	0f b6 c0             	movzbl %al,%eax
  8001c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c9:	8b 12                	mov    (%edx),%edx
  8001cb:	89 d1                	mov    %edx,%ecx
  8001cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d0:	83 c2 08             	add    $0x8,%edx
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	50                   	push   %eax
  8001d7:	51                   	push   %ecx
  8001d8:	52                   	push   %edx
  8001d9:	e8 4e 0e 00 00       	call   80102c <sys_cputs>
  8001de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	8b 40 04             	mov    0x4(%eax),%eax
  8001f0:	8d 50 01             	lea    0x1(%eax),%edx
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 93 01 80 00       	push   $0x800193
  80022b:	e8 11 02 00 00       	call   800441 <vprintfmt>
  800230:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800233:	a0 08 30 80 00       	mov    0x803008,%al
  800238:	0f b6 c0             	movzbl %al,%eax
  80023b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	50                   	push   %eax
  800245:	52                   	push   %edx
  800246:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024c:	83 c0 08             	add    $0x8,%eax
  80024f:	50                   	push   %eax
  800250:	e8 d7 0d 00 00       	call   80102c <sys_cputs>
  800255:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800258:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80025f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80026d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800274:	8d 45 0c             	lea    0xc(%ebp),%eax
  800277:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80027a:	8b 45 08             	mov    0x8(%ebp),%eax
  80027d:	83 ec 08             	sub    $0x8,%esp
  800280:	ff 75 f4             	pushl  -0xc(%ebp)
  800283:	50                   	push   %eax
  800284:	e8 73 ff ff ff       	call   8001fc <vcprintf>
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80028f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80029a:	e8 cf 0d 00 00       	call   80106e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80029f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ae:	50                   	push   %eax
  8002af:	e8 48 ff ff ff       	call   8001fc <vcprintf>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002ba:	e8 c9 0d 00 00       	call   801088 <sys_unlock_cons>
	return cnt;
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	53                   	push   %ebx
  8002c8:	83 ec 14             	sub    $0x14,%esp
  8002cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8002da:	ba 00 00 00 00       	mov    $0x0,%edx
  8002df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e2:	77 55                	ja     800339 <printnum+0x75>
  8002e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e7:	72 05                	jb     8002ee <printnum+0x2a>
  8002e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ec:	77 4b                	ja     800339 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fc:	52                   	push   %edx
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800301:	ff 75 f0             	pushl  -0x10(%ebp)
  800304:	e8 0b 15 00 00       	call   801814 <__udivdi3>
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	ff 75 20             	pushl  0x20(%ebp)
  800312:	53                   	push   %ebx
  800313:	ff 75 18             	pushl  0x18(%ebp)
  800316:	52                   	push   %edx
  800317:	50                   	push   %eax
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 a1 ff ff ff       	call   8002c4 <printnum>
  800323:	83 c4 20             	add    $0x20,%esp
  800326:	eb 1a                	jmp    800342 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	ff 75 0c             	pushl  0xc(%ebp)
  80032e:	ff 75 20             	pushl  0x20(%ebp)
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	ff d0                	call   *%eax
  800336:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800339:	ff 4d 1c             	decl   0x1c(%ebp)
  80033c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800340:	7f e6                	jg     800328 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800342:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800345:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800350:	53                   	push   %ebx
  800351:	51                   	push   %ecx
  800352:	52                   	push   %edx
  800353:	50                   	push   %eax
  800354:	e8 cb 15 00 00       	call   801924 <__umoddi3>
  800359:	83 c4 10             	add    $0x10,%esp
  80035c:	05 94 1d 80 00       	add    $0x801d94,%eax
  800361:	8a 00                	mov    (%eax),%al
  800363:	0f be c0             	movsbl %al,%eax
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	50                   	push   %eax
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	ff d0                	call   *%eax
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80037e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800382:	7e 1c                	jle    8003a0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	8d 50 08             	lea    0x8(%eax),%edx
  80038c:	8b 45 08             	mov    0x8(%ebp),%eax
  80038f:	89 10                	mov    %edx,(%eax)
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	83 e8 08             	sub    $0x8,%eax
  800399:	8b 50 04             	mov    0x4(%eax),%edx
  80039c:	8b 00                	mov    (%eax),%eax
  80039e:	eb 40                	jmp    8003e0 <getuint+0x65>
	else if (lflag)
  8003a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a4:	74 1e                	je     8003c4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	8d 50 04             	lea    0x4(%eax),%edx
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 10                	mov    %edx,(%eax)
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	83 e8 04             	sub    $0x4,%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c2:	eb 1c                	jmp    8003e0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	8b 00                	mov    (%eax),%eax
  8003c9:	8d 50 04             	lea    0x4(%eax),%edx
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	89 10                	mov    %edx,(%eax)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	83 e8 04             	sub    $0x4,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e9:	7e 1c                	jle    800407 <getint+0x25>
		return va_arg(*ap, long long);
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
  800405:	eb 38                	jmp    80043f <getint+0x5d>
	else if (lflag)
  800407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040b:	74 1a                	je     800427 <getint+0x45>
		return va_arg(*ap, long);
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	8d 50 04             	lea    0x4(%eax),%edx
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	89 10                	mov    %edx,(%eax)
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	83 e8 04             	sub    $0x4,%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	99                   	cltd   
  800425:	eb 18                	jmp    80043f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	8d 50 04             	lea    0x4(%eax),%edx
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	89 10                	mov    %edx,(%eax)
  800434:	8b 45 08             	mov    0x8(%ebp),%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	83 e8 04             	sub    $0x4,%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	99                   	cltd   
}
  80043f:	5d                   	pop    %ebp
  800440:	c3                   	ret    

00800441 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800449:	eb 17                	jmp    800462 <vprintfmt+0x21>
			if (ch == '\0')
  80044b:	85 db                	test   %ebx,%ebx
  80044d:	0f 84 c1 03 00 00    	je     800814 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	ff 75 0c             	pushl  0xc(%ebp)
  800459:	53                   	push   %ebx
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	ff d0                	call   *%eax
  80045f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800462:	8b 45 10             	mov    0x10(%ebp),%eax
  800465:	8d 50 01             	lea    0x1(%eax),%edx
  800468:	89 55 10             	mov    %edx,0x10(%ebp)
  80046b:	8a 00                	mov    (%eax),%al
  80046d:	0f b6 d8             	movzbl %al,%ebx
  800470:	83 fb 25             	cmp    $0x25,%ebx
  800473:	75 d6                	jne    80044b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800475:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800479:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800480:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800487:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80048e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800495:	8b 45 10             	mov    0x10(%ebp),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	89 55 10             	mov    %edx,0x10(%ebp)
  80049e:	8a 00                	mov    (%eax),%al
  8004a0:	0f b6 d8             	movzbl %al,%ebx
  8004a3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a6:	83 f8 5b             	cmp    $0x5b,%eax
  8004a9:	0f 87 3d 03 00 00    	ja     8007ec <vprintfmt+0x3ab>
  8004af:	8b 04 85 b8 1d 80 00 	mov    0x801db8(,%eax,4),%eax
  8004b6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004bc:	eb d7                	jmp    800495 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004be:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c2:	eb d1                	jmp    800495 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ce:	89 d0                	mov    %edx,%eax
  8004d0:	c1 e0 02             	shl    $0x2,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	01 c0                	add    %eax,%eax
  8004d7:	01 d8                	add    %ebx,%eax
  8004d9:	83 e8 30             	sub    $0x30,%eax
  8004dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	8a 00                	mov    (%eax),%al
  8004e4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004e7:	83 fb 2f             	cmp    $0x2f,%ebx
  8004ea:	7e 3e                	jle    80052a <vprintfmt+0xe9>
  8004ec:	83 fb 39             	cmp    $0x39,%ebx
  8004ef:	7f 39                	jg     80052a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f4:	eb d5                	jmp    8004cb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	83 c0 04             	add    $0x4,%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	83 e8 04             	sub    $0x4,%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80050a:	eb 1f                	jmp    80052b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80050c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800510:	79 83                	jns    800495 <vprintfmt+0x54>
				width = 0;
  800512:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800519:	e9 77 ff ff ff       	jmp    800495 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80051e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800525:	e9 6b ff ff ff       	jmp    800495 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80052a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80052b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052f:	0f 89 60 ff ff ff    	jns    800495 <vprintfmt+0x54>
				width = precision, precision = -1;
  800535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800542:	e9 4e ff ff ff       	jmp    800495 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800547:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80054a:	e9 46 ff ff ff       	jmp    800495 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	83 c0 04             	add    $0x4,%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	83 e8 04             	sub    $0x4,%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	ff 75 0c             	pushl  0xc(%ebp)
  800566:	50                   	push   %eax
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	ff d0                	call   *%eax
  80056c:	83 c4 10             	add    $0x10,%esp
			break;
  80056f:	e9 9b 02 00 00       	jmp    80080f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	83 c0 04             	add    $0x4,%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	83 e8 04             	sub    $0x4,%eax
  800583:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800585:	85 db                	test   %ebx,%ebx
  800587:	79 02                	jns    80058b <vprintfmt+0x14a>
				err = -err;
  800589:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80058b:	83 fb 64             	cmp    $0x64,%ebx
  80058e:	7f 0b                	jg     80059b <vprintfmt+0x15a>
  800590:	8b 34 9d 00 1c 80 00 	mov    0x801c00(,%ebx,4),%esi
  800597:	85 f6                	test   %esi,%esi
  800599:	75 19                	jne    8005b4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80059b:	53                   	push   %ebx
  80059c:	68 a5 1d 80 00       	push   $0x801da5
  8005a1:	ff 75 0c             	pushl  0xc(%ebp)
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	e8 70 02 00 00       	call   80081c <printfmt>
  8005ac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005af:	e9 5b 02 00 00       	jmp    80080f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b4:	56                   	push   %esi
  8005b5:	68 ae 1d 80 00       	push   $0x801dae
  8005ba:	ff 75 0c             	pushl  0xc(%ebp)
  8005bd:	ff 75 08             	pushl  0x8(%ebp)
  8005c0:	e8 57 02 00 00       	call   80081c <printfmt>
  8005c5:	83 c4 10             	add    $0x10,%esp
			break;
  8005c8:	e9 42 02 00 00       	jmp    80080f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	83 c0 04             	add    $0x4,%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	83 e8 04             	sub    $0x4,%eax
  8005dc:	8b 30                	mov    (%eax),%esi
  8005de:	85 f6                	test   %esi,%esi
  8005e0:	75 05                	jne    8005e7 <vprintfmt+0x1a6>
				p = "(null)";
  8005e2:	be b1 1d 80 00       	mov    $0x801db1,%esi
			if (width > 0 && padc != '-')
  8005e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005eb:	7e 6d                	jle    80065a <vprintfmt+0x219>
  8005ed:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f1:	74 67                	je     80065a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	50                   	push   %eax
  8005fa:	56                   	push   %esi
  8005fb:	e8 1e 03 00 00       	call   80091e <strnlen>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800606:	eb 16                	jmp    80061e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800608:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	ff d0                	call   *%eax
  800618:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061b:	ff 4d e4             	decl   -0x1c(%ebp)
  80061e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800622:	7f e4                	jg     800608 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800624:	eb 34                	jmp    80065a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800626:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062a:	74 1c                	je     800648 <vprintfmt+0x207>
  80062c:	83 fb 1f             	cmp    $0x1f,%ebx
  80062f:	7e 05                	jle    800636 <vprintfmt+0x1f5>
  800631:	83 fb 7e             	cmp    $0x7e,%ebx
  800634:	7e 12                	jle    800648 <vprintfmt+0x207>
					putch('?', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	6a 3f                	push   $0x3f
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	ff d0                	call   *%eax
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	eb 0f                	jmp    800657 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	53                   	push   %ebx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800657:	ff 4d e4             	decl   -0x1c(%ebp)
  80065a:	89 f0                	mov    %esi,%eax
  80065c:	8d 70 01             	lea    0x1(%eax),%esi
  80065f:	8a 00                	mov    (%eax),%al
  800661:	0f be d8             	movsbl %al,%ebx
  800664:	85 db                	test   %ebx,%ebx
  800666:	74 24                	je     80068c <vprintfmt+0x24b>
  800668:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066c:	78 b8                	js     800626 <vprintfmt+0x1e5>
  80066e:	ff 4d e0             	decl   -0x20(%ebp)
  800671:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800675:	79 af                	jns    800626 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800677:	eb 13                	jmp    80068c <vprintfmt+0x24b>
				putch(' ', putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	6a 20                	push   $0x20
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	ff d0                	call   *%eax
  800686:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800689:	ff 4d e4             	decl   -0x1c(%ebp)
  80068c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800690:	7f e7                	jg     800679 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800692:	e9 78 01 00 00       	jmp    80080f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 e8             	pushl  -0x18(%ebp)
  80069d:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a0:	50                   	push   %eax
  8006a1:	e8 3c fd ff ff       	call   8003e2 <getint>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b5:	85 d2                	test   %edx,%edx
  8006b7:	79 23                	jns    8006dc <vprintfmt+0x29b>
				putch('-', putdat);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	6a 2d                	push   $0x2d
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	ff d0                	call   *%eax
  8006c6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006cf:	f7 d8                	neg    %eax
  8006d1:	83 d2 00             	adc    $0x0,%edx
  8006d4:	f7 da                	neg    %edx
  8006d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e3:	e9 bc 00 00 00       	jmp    8007a4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f1:	50                   	push   %eax
  8006f2:	e8 84 fc ff ff       	call   80037b <getuint>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800700:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800707:	e9 98 00 00 00       	jmp    8007a4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	6a 58                	push   $0x58
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	ff d0                	call   *%eax
  800719:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	6a 58                	push   $0x58
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	6a 58                	push   $0x58
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	ff d0                	call   *%eax
  800739:	83 c4 10             	add    $0x10,%esp
			break;
  80073c:	e9 ce 00 00 00       	jmp    80080f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	6a 30                	push   $0x30
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	ff d0                	call   *%eax
  80074e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	6a 78                	push   $0x78
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	83 c0 04             	add    $0x4,%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800775:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80077c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800783:	eb 1f                	jmp    8007a4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 e8             	pushl  -0x18(%ebp)
  80078b:	8d 45 14             	lea    0x14(%ebp),%eax
  80078e:	50                   	push   %eax
  80078f:	e8 e7 fb ff ff       	call   80037b <getuint>
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80079d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	52                   	push   %edx
  8007af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	ff 75 08             	pushl  0x8(%ebp)
  8007bf:	e8 00 fb ff ff       	call   8002c4 <printnum>
  8007c4:	83 c4 20             	add    $0x20,%esp
			break;
  8007c7:	eb 46                	jmp    80080f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 0c             	pushl  0xc(%ebp)
  8007cf:	53                   	push   %ebx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	ff d0                	call   *%eax
  8007d5:	83 c4 10             	add    $0x10,%esp
			break;
  8007d8:	eb 35                	jmp    80080f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007da:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8007e1:	eb 2c                	jmp    80080f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007e3:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8007ea:	eb 23                	jmp    80080f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	6a 25                	push   $0x25
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	ff d0                	call   *%eax
  8007f9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fc:	ff 4d 10             	decl   0x10(%ebp)
  8007ff:	eb 03                	jmp    800804 <vprintfmt+0x3c3>
  800801:	ff 4d 10             	decl   0x10(%ebp)
  800804:	8b 45 10             	mov    0x10(%ebp),%eax
  800807:	48                   	dec    %eax
  800808:	8a 00                	mov    (%eax),%al
  80080a:	3c 25                	cmp    $0x25,%al
  80080c:	75 f3                	jne    800801 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80080e:	90                   	nop
		}
	}
  80080f:	e9 35 fc ff ff       	jmp    800449 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800814:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800815:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800818:	5b                   	pop    %ebx
  800819:	5e                   	pop    %esi
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800822:	8d 45 10             	lea    0x10(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80082b:	8b 45 10             	mov    0x10(%ebp),%eax
  80082e:	ff 75 f4             	pushl  -0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 04 fc ff ff       	call   800441 <vprintfmt>
  80083d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800840:	90                   	nop
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800846:	8b 45 0c             	mov    0xc(%ebp),%eax
  800849:	8b 40 08             	mov    0x8(%eax),%eax
  80084c:	8d 50 01             	lea    0x1(%eax),%edx
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800855:	8b 45 0c             	mov    0xc(%ebp),%eax
  800858:	8b 10                	mov    (%eax),%edx
  80085a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085d:	8b 40 04             	mov    0x4(%eax),%eax
  800860:	39 c2                	cmp    %eax,%edx
  800862:	73 12                	jae    800876 <sprintputch+0x33>
		*b->buf++ = ch;
  800864:	8b 45 0c             	mov    0xc(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	8d 48 01             	lea    0x1(%eax),%ecx
  80086c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086f:	89 0a                	mov    %ecx,(%edx)
  800871:	8b 55 08             	mov    0x8(%ebp),%edx
  800874:	88 10                	mov    %dl,(%eax)
}
  800876:	90                   	nop
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	8d 50 ff             	lea    -0x1(%eax),%edx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800893:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80089e:	74 06                	je     8008a6 <vsnprintf+0x2d>
  8008a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a4:	7f 07                	jg     8008ad <vsnprintf+0x34>
		return -E_INVAL;
  8008a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ab:	eb 20                	jmp    8008cd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ad:	ff 75 14             	pushl  0x14(%ebp)
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	68 43 08 80 00       	push   $0x800843
  8008bc:	e8 80 fb ff ff       	call   800441 <vprintfmt>
  8008c1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d8:	83 c0 04             	add    $0x4,%eax
  8008db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	ff 75 08             	pushl  0x8(%ebp)
  8008eb:	e8 89 ff ff ff       	call   800879 <vsnprintf>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    

008008fb <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800908:	eb 06                	jmp    800910 <strlen+0x15>
		n++;
  80090a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80090d:	ff 45 08             	incl   0x8(%ebp)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8a 00                	mov    (%eax),%al
  800915:	84 c0                	test   %al,%al
  800917:	75 f1                	jne    80090a <strlen+0xf>
		n++;
	return n;
  800919:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80092b:	eb 09                	jmp    800936 <strnlen+0x18>
		n++;
  80092d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800930:	ff 45 08             	incl   0x8(%ebp)
  800933:	ff 4d 0c             	decl   0xc(%ebp)
  800936:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093a:	74 09                	je     800945 <strnlen+0x27>
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8a 00                	mov    (%eax),%al
  800941:	84 c0                	test   %al,%al
  800943:	75 e8                	jne    80092d <strnlen+0xf>
		n++;
	return n;
  800945:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800956:	90                   	nop
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8d 50 01             	lea    0x1(%eax),%edx
  80095d:	89 55 08             	mov    %edx,0x8(%ebp)
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	8d 4a 01             	lea    0x1(%edx),%ecx
  800966:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800969:	8a 12                	mov    (%edx),%dl
  80096b:	88 10                	mov    %dl,(%eax)
  80096d:	8a 00                	mov    (%eax),%al
  80096f:	84 c0                	test   %al,%al
  800971:	75 e4                	jne    800957 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098b:	eb 1f                	jmp    8009ac <strncpy+0x34>
		*dst++ = *src;
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8d 50 01             	lea    0x1(%eax),%edx
  800993:	89 55 08             	mov    %edx,0x8(%ebp)
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
  800999:	8a 12                	mov    (%edx),%dl
  80099b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	84 c0                	test   %al,%al
  8009a4:	74 03                	je     8009a9 <strncpy+0x31>
			src++;
  8009a6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a9:	ff 45 fc             	incl   -0x4(%ebp)
  8009ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b2:	72 d9                	jb     80098d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009c9:	74 30                	je     8009fb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009cb:	eb 16                	jmp    8009e3 <strlcpy+0x2a>
			*dst++ = *src++;
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8d 50 01             	lea    0x1(%eax),%edx
  8009d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009dc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009df:	8a 12                	mov    (%edx),%dl
  8009e1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e3:	ff 4d 10             	decl   0x10(%ebp)
  8009e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ea:	74 09                	je     8009f5 <strlcpy+0x3c>
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	84 c0                	test   %al,%al
  8009f3:	75 d8                	jne    8009cd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a01:	29 c2                	sub    %eax,%edx
  800a03:	89 d0                	mov    %edx,%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a0a:	eb 06                	jmp    800a12 <strcmp+0xb>
		p++, q++;
  800a0c:	ff 45 08             	incl   0x8(%ebp)
  800a0f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	74 0e                	je     800a29 <strcmp+0x22>
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8a 10                	mov    (%eax),%dl
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	8a 00                	mov    (%eax),%al
  800a25:	38 c2                	cmp    %al,%dl
  800a27:	74 e3                	je     800a0c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f b6 d0             	movzbl %al,%edx
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	29 c2                	sub    %eax,%edx
  800a3b:	89 d0                	mov    %edx,%eax
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a42:	eb 09                	jmp    800a4d <strncmp+0xe>
		n--, p++, q++;
  800a44:	ff 4d 10             	decl   0x10(%ebp)
  800a47:	ff 45 08             	incl   0x8(%ebp)
  800a4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a51:	74 17                	je     800a6a <strncmp+0x2b>
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	8a 00                	mov    (%eax),%al
  800a58:	84 c0                	test   %al,%al
  800a5a:	74 0e                	je     800a6a <strncmp+0x2b>
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8a 10                	mov    (%eax),%dl
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	38 c2                	cmp    %al,%dl
  800a68:	74 da                	je     800a44 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6e:	75 07                	jne    800a77 <strncmp+0x38>
		return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	eb 14                	jmp    800a8b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	0f b6 d0             	movzbl %al,%edx
  800a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a82:	8a 00                	mov    (%eax),%al
  800a84:	0f b6 c0             	movzbl %al,%eax
  800a87:	29 c2                	sub    %eax,%edx
  800a89:	89 d0                	mov    %edx,%eax
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 04             	sub    $0x4,%esp
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a99:	eb 12                	jmp    800aad <strchr+0x20>
		if (*s == c)
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aa3:	75 05                	jne    800aaa <strchr+0x1d>
			return (char *) s;
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	eb 11                	jmp    800abb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aaa:	ff 45 08             	incl   0x8(%ebp)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	84 c0                	test   %al,%al
  800ab4:	75 e5                	jne    800a9b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	83 ec 04             	sub    $0x4,%esp
  800ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ac9:	eb 0d                	jmp    800ad8 <strfind+0x1b>
		if (*s == c)
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8a 00                	mov    (%eax),%al
  800ad0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad3:	74 0e                	je     800ae3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad5:	ff 45 08             	incl   0x8(%ebp)
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	84 c0                	test   %al,%al
  800adf:	75 ea                	jne    800acb <strfind+0xe>
  800ae1:	eb 01                	jmp    800ae4 <strfind+0x27>
		if (*s == c)
			break;
  800ae3:	90                   	nop
	return (char *) s;
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800afb:	eb 0e                	jmp    800b0b <memset+0x22>
		*p++ = c;
  800afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b0b:	ff 4d f8             	decl   -0x8(%ebp)
  800b0e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b12:	79 e9                	jns    800afd <memset+0x14>
		*p++ = c;

	return v;
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b17:	c9                   	leave  
  800b18:	c3                   	ret    

00800b19 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b2b:	eb 16                	jmp    800b43 <memcpy+0x2a>
		*d++ = *s++;
  800b2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b3f:	8a 12                	mov    (%edx),%dl
  800b41:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b43:	8b 45 10             	mov    0x10(%ebp),%eax
  800b46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b49:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4c:	85 c0                	test   %eax,%eax
  800b4e:	75 dd                	jne    800b2d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b6d:	73 50                	jae    800bbf <memmove+0x6a>
  800b6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	01 d0                	add    %edx,%eax
  800b77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7a:	76 43                	jbe    800bbf <memmove+0x6a>
		s += n;
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b88:	eb 10                	jmp    800b9a <memmove+0x45>
			*--d = *--s;
  800b8a:	ff 4d f8             	decl   -0x8(%ebp)
  800b8d:	ff 4d fc             	decl   -0x4(%ebp)
  800b90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b93:	8a 10                	mov    (%eax),%dl
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	75 e3                	jne    800b8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba7:	eb 23                	jmp    800bcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bac:	8d 50 01             	lea    0x1(%eax),%edx
  800baf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bbb:	8a 12                	mov    (%edx),%dl
  800bbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc8:	85 c0                	test   %eax,%eax
  800bca:	75 dd                	jne    800ba9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be3:	eb 2a                	jmp    800c0f <memcmp+0x3e>
		if (*s1 != *s2)
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be8:	8a 10                	mov    (%eax),%dl
  800bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	38 c2                	cmp    %al,%dl
  800bf1:	74 16                	je     800c09 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f b6 d0             	movzbl %al,%edx
  800bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f b6 c0             	movzbl %al,%eax
  800c03:	29 c2                	sub    %eax,%edx
  800c05:	89 d0                	mov    %edx,%eax
  800c07:	eb 18                	jmp    800c21 <memcmp+0x50>
		s1++, s2++;
  800c09:	ff 45 fc             	incl   -0x4(%ebp)
  800c0c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c15:	89 55 10             	mov    %edx,0x10(%ebp)
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	75 c9                	jne    800be5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2f:	01 d0                	add    %edx,%eax
  800c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c34:	eb 15                	jmp    800c4b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8a 00                	mov    (%eax),%al
  800c3b:	0f b6 d0             	movzbl %al,%edx
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	0f b6 c0             	movzbl %al,%eax
  800c44:	39 c2                	cmp    %eax,%edx
  800c46:	74 0d                	je     800c55 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c48:	ff 45 08             	incl   0x8(%ebp)
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c51:	72 e3                	jb     800c36 <memfind+0x13>
  800c53:	eb 01                	jmp    800c56 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c55:	90                   	nop
	return (void *) s;
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6f:	eb 03                	jmp    800c74 <strtol+0x19>
		s++;
  800c71:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	3c 20                	cmp    $0x20,%al
  800c7b:	74 f4                	je     800c71 <strtol+0x16>
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8a 00                	mov    (%eax),%al
  800c82:	3c 09                	cmp    $0x9,%al
  800c84:	74 eb                	je     800c71 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	3c 2b                	cmp    $0x2b,%al
  800c8d:	75 05                	jne    800c94 <strtol+0x39>
		s++;
  800c8f:	ff 45 08             	incl   0x8(%ebp)
  800c92:	eb 13                	jmp    800ca7 <strtol+0x4c>
	else if (*s == '-')
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	3c 2d                	cmp    $0x2d,%al
  800c9b:	75 0a                	jne    800ca7 <strtol+0x4c>
		s++, neg = 1;
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cab:	74 06                	je     800cb3 <strtol+0x58>
  800cad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cb1:	75 20                	jne    800cd3 <strtol+0x78>
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	3c 30                	cmp    $0x30,%al
  800cba:	75 17                	jne    800cd3 <strtol+0x78>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	40                   	inc    %eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	3c 78                	cmp    $0x78,%al
  800cc4:	75 0d                	jne    800cd3 <strtol+0x78>
		s += 2, base = 16;
  800cc6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cd1:	eb 28                	jmp    800cfb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	75 15                	jne    800cee <strtol+0x93>
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 30                	cmp    $0x30,%al
  800ce0:	75 0c                	jne    800cee <strtol+0x93>
		s++, base = 8;
  800ce2:	ff 45 08             	incl   0x8(%ebp)
  800ce5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cec:	eb 0d                	jmp    800cfb <strtol+0xa0>
	else if (base == 0)
  800cee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf2:	75 07                	jne    800cfb <strtol+0xa0>
		base = 10;
  800cf4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 2f                	cmp    $0x2f,%al
  800d02:	7e 19                	jle    800d1d <strtol+0xc2>
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	3c 39                	cmp    $0x39,%al
  800d0b:	7f 10                	jg     800d1d <strtol+0xc2>
			dig = *s - '0';
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f be c0             	movsbl %al,%eax
  800d15:	83 e8 30             	sub    $0x30,%eax
  800d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d1b:	eb 42                	jmp    800d5f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	3c 60                	cmp    $0x60,%al
  800d24:	7e 19                	jle    800d3f <strtol+0xe4>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	3c 7a                	cmp    $0x7a,%al
  800d2d:	7f 10                	jg     800d3f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	0f be c0             	movsbl %al,%eax
  800d37:	83 e8 57             	sub    $0x57,%eax
  800d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d3d:	eb 20                	jmp    800d5f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	3c 40                	cmp    $0x40,%al
  800d46:	7e 39                	jle    800d81 <strtol+0x126>
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 5a                	cmp    $0x5a,%al
  800d4f:	7f 30                	jg     800d81 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	0f be c0             	movsbl %al,%eax
  800d59:	83 e8 37             	sub    $0x37,%eax
  800d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d62:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d65:	7d 19                	jge    800d80 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d71:	89 c2                	mov    %eax,%edx
  800d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d76:	01 d0                	add    %edx,%eax
  800d78:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d7b:	e9 7b ff ff ff       	jmp    800cfb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d80:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d85:	74 08                	je     800d8f <strtol+0x134>
		*endptr = (char *) s;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d93:	74 07                	je     800d9c <strtol+0x141>
  800d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d98:	f7 d8                	neg    %eax
  800d9a:	eb 03                	jmp    800d9f <strtol+0x144>
  800d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d9f:	c9                   	leave  
  800da0:	c3                   	ret    

00800da1 <ltostr>:

void
ltostr(long value, char *str)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800da7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db9:	79 13                	jns    800dce <ltostr+0x2d>
	{
		neg = 1;
  800dbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dc8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dcb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd6:	99                   	cltd   
  800dd7:	f7 f9                	idiv   %ecx
  800dd9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8d 50 01             	lea    0x1(%eax),%edx
  800de2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de5:	89 c2                	mov    %eax,%edx
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	01 d0                	add    %edx,%eax
  800dec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800def:	83 c2 30             	add    $0x30,%edx
  800df2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dfc:	f7 e9                	imul   %ecx
  800dfe:	c1 fa 02             	sar    $0x2,%edx
  800e01:	89 c8                	mov    %ecx,%eax
  800e03:	c1 f8 1f             	sar    $0x1f,%eax
  800e06:	29 c2                	sub    %eax,%edx
  800e08:	89 d0                	mov    %edx,%eax
  800e0a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e11:	75 bb                	jne    800dce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	48                   	dec    %eax
  800e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e25:	74 3d                	je     800e64 <ltostr+0xc3>
		start = 1 ;
  800e27:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e2e:	eb 34                	jmp    800e64 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	01 d0                	add    %edx,%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	01 c2                	add    %eax,%edx
  800e45:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	01 c8                	add    %ecx,%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	01 c2                	add    %eax,%edx
  800e59:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e5c:	88 02                	mov    %al,(%edx)
		start++ ;
  800e5e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e61:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6a:	7c c4                	jl     800e30 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e6c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	01 d0                	add    %edx,%eax
  800e74:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e77:	90                   	nop
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e80:	ff 75 08             	pushl  0x8(%ebp)
  800e83:	e8 73 fa ff ff       	call   8008fb <strlen>
  800e88:	83 c4 04             	add    $0x4,%esp
  800e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	e8 65 fa ff ff       	call   8008fb <strlen>
  800e96:	83 c4 04             	add    $0x4,%esp
  800e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eaa:	eb 17                	jmp    800ec3 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb2:	01 c2                	add    %eax,%edx
  800eb4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	01 c8                	add    %ecx,%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec0:	ff 45 fc             	incl   -0x4(%ebp)
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ec9:	7c e1                	jl     800eac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ecb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ed9:	eb 1f                	jmp    800efa <strcconcat+0x80>
		final[s++] = str2[i] ;
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ede:	8d 50 01             	lea    0x1(%eax),%edx
  800ee1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 c2                	add    %eax,%edx
  800eeb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	01 c8                	add    %ecx,%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800ef7:	ff 45 f8             	incl   -0x8(%ebp)
  800efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f00:	7c d9                	jl     800edb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	01 d0                	add    %edx,%eax
  800f0a:	c6 00 00             	movb   $0x0,(%eax)
}
  800f0d:	90                   	nop
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f13:	8b 45 14             	mov    0x14(%ebp),%eax
  800f16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	01 d0                	add    %edx,%eax
  800f2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f33:	eb 0c                	jmp    800f41 <strsplit+0x31>
			*string++ = 0;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	84 c0                	test   %al,%al
  800f48:	74 18                	je     800f62 <strsplit+0x52>
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	0f be c0             	movsbl %al,%eax
  800f52:	50                   	push   %eax
  800f53:	ff 75 0c             	pushl  0xc(%ebp)
  800f56:	e8 32 fb ff ff       	call   800a8d <strchr>
  800f5b:	83 c4 08             	add    $0x8,%esp
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	75 d3                	jne    800f35 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	84 c0                	test   %al,%al
  800f69:	74 5a                	je     800fc5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6e:	8b 00                	mov    (%eax),%eax
  800f70:	83 f8 0f             	cmp    $0xf,%eax
  800f73:	75 07                	jne    800f7c <strsplit+0x6c>
		{
			return 0;
  800f75:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7a:	eb 66                	jmp    800fe2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	8d 48 01             	lea    0x1(%eax),%ecx
  800f84:	8b 55 14             	mov    0x14(%ebp),%edx
  800f87:	89 0a                	mov    %ecx,(%edx)
  800f89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	01 c2                	add    %eax,%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9a:	eb 03                	jmp    800f9f <strsplit+0x8f>
			string++;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	84 c0                	test   %al,%al
  800fa6:	74 8b                	je     800f33 <strsplit+0x23>
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	0f be c0             	movsbl %al,%eax
  800fb0:	50                   	push   %eax
  800fb1:	ff 75 0c             	pushl  0xc(%ebp)
  800fb4:	e8 d4 fa ff ff       	call   800a8d <strchr>
  800fb9:	83 c4 08             	add    $0x8,%esp
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	74 dc                	je     800f9c <strsplit+0x8c>
			string++;
	}
  800fc0:	e9 6e ff ff ff       	jmp    800f33 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fc5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc9:	8b 00                	mov    (%eax),%eax
  800fcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fdd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800fea:	83 ec 04             	sub    $0x4,%esp
  800fed:	68 28 1f 80 00       	push   $0x801f28
  800ff2:	68 3f 01 00 00       	push   $0x13f
  800ff7:	68 4a 1f 80 00       	push   $0x801f4a
  800ffc:	e8 29 06 00 00       	call   80162a <_panic>

00801001 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
  801007:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801013:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801016:	8b 7d 18             	mov    0x18(%ebp),%edi
  801019:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80101c:	cd 30                	int    $0x30
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801021:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801024:	83 c4 10             	add    $0x10,%esp
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 04             	sub    $0x4,%esp
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801038:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	6a 00                	push   $0x0
  801041:	6a 00                	push   $0x0
  801043:	52                   	push   %edx
  801044:	ff 75 0c             	pushl  0xc(%ebp)
  801047:	50                   	push   %eax
  801048:	6a 00                	push   $0x0
  80104a:	e8 b2 ff ff ff       	call   801001 <syscall>
  80104f:	83 c4 18             	add    $0x18,%esp
}
  801052:	90                   	nop
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <sys_cgetc>:

int
sys_cgetc(void)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801058:	6a 00                	push   $0x0
  80105a:	6a 00                	push   $0x0
  80105c:	6a 00                	push   $0x0
  80105e:	6a 00                	push   $0x0
  801060:	6a 00                	push   $0x0
  801062:	6a 02                	push   $0x2
  801064:	e8 98 ff ff ff       	call   801001 <syscall>
  801069:	83 c4 18             	add    $0x18,%esp
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	6a 00                	push   $0x0
  801077:	6a 00                	push   $0x0
  801079:	6a 00                	push   $0x0
  80107b:	6a 03                	push   $0x3
  80107d:	e8 7f ff ff ff       	call   801001 <syscall>
  801082:	83 c4 18             	add    $0x18,%esp
}
  801085:	90                   	nop
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80108b:	6a 00                	push   $0x0
  80108d:	6a 00                	push   $0x0
  80108f:	6a 00                	push   $0x0
  801091:	6a 00                	push   $0x0
  801093:	6a 00                	push   $0x0
  801095:	6a 04                	push   $0x4
  801097:	e8 65 ff ff ff       	call   801001 <syscall>
  80109c:	83 c4 18             	add    $0x18,%esp
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	52                   	push   %edx
  8010b2:	50                   	push   %eax
  8010b3:	6a 08                	push   $0x8
  8010b5:	e8 47 ff ff ff       	call   801001 <syscall>
  8010ba:	83 c4 18             	add    $0x18,%esp
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
  8010d5:	51                   	push   %ecx
  8010d6:	52                   	push   %edx
  8010d7:	50                   	push   %eax
  8010d8:	6a 09                	push   $0x9
  8010da:	e8 22 ff ff ff       	call   801001 <syscall>
  8010df:	83 c4 18             	add    $0x18,%esp
}
  8010e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    

008010e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	52                   	push   %edx
  8010f9:	50                   	push   %eax
  8010fa:	6a 0a                	push   $0xa
  8010fc:	e8 00 ff ff ff       	call   801001 <syscall>
  801101:	83 c4 18             	add    $0x18,%esp
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801109:	6a 00                	push   $0x0
  80110b:	6a 00                	push   $0x0
  80110d:	6a 00                	push   $0x0
  80110f:	ff 75 0c             	pushl  0xc(%ebp)
  801112:	ff 75 08             	pushl  0x8(%ebp)
  801115:	6a 0b                	push   $0xb
  801117:	e8 e5 fe ff ff       	call   801001 <syscall>
  80111c:	83 c4 18             	add    $0x18,%esp
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	6a 0c                	push   $0xc
  801130:	e8 cc fe ff ff       	call   801001 <syscall>
  801135:	83 c4 18             	add    $0x18,%esp
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 0d                	push   $0xd
  801149:	e8 b3 fe ff ff       	call   801001 <syscall>
  80114e:	83 c4 18             	add    $0x18,%esp
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 0e                	push   $0xe
  801162:	e8 9a fe ff ff       	call   801001 <syscall>
  801167:	83 c4 18             	add    $0x18,%esp
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 0f                	push   $0xf
  80117b:	e8 81 fe ff ff       	call   801001 <syscall>
  801180:	83 c4 18             	add    $0x18,%esp
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	6a 10                	push   $0x10
  801195:	e8 67 fe ff ff       	call   801001 <syscall>
  80119a:	83 c4 18             	add    $0x18,%esp
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 11                	push   $0x11
  8011ae:	e8 4e fe ff ff       	call   801001 <syscall>
  8011b3:	83 c4 18             	add    $0x18,%esp
}
  8011b6:	90                   	nop
  8011b7:	c9                   	leave  
  8011b8:	c3                   	ret    

008011b9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	50                   	push   %eax
  8011d2:	6a 01                	push   $0x1
  8011d4:	e8 28 fe ff ff       	call   801001 <syscall>
  8011d9:	83 c4 18             	add    $0x18,%esp
}
  8011dc:	90                   	nop
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 14                	push   $0x14
  8011ee:	e8 0e fe ff ff       	call   801001 <syscall>
  8011f3:	83 c4 18             	add    $0x18,%esp
}
  8011f6:	90                   	nop
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801205:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801208:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	6a 00                	push   $0x0
  801211:	51                   	push   %ecx
  801212:	52                   	push   %edx
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	50                   	push   %eax
  801217:	6a 15                	push   $0x15
  801219:	e8 e3 fd ff ff       	call   801001 <syscall>
  80121e:	83 c4 18             	add    $0x18,%esp
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	52                   	push   %edx
  801233:	50                   	push   %eax
  801234:	6a 16                	push   $0x16
  801236:	e8 c6 fd ff ff       	call   801001 <syscall>
  80123b:	83 c4 18             	add    $0x18,%esp
}
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801243:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801246:	8b 55 0c             	mov    0xc(%ebp),%edx
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	51                   	push   %ecx
  801251:	52                   	push   %edx
  801252:	50                   	push   %eax
  801253:	6a 17                	push   $0x17
  801255:	e8 a7 fd ff ff       	call   801001 <syscall>
  80125a:	83 c4 18             	add    $0x18,%esp
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801262:	8b 55 0c             	mov    0xc(%ebp),%edx
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	52                   	push   %edx
  80126f:	50                   	push   %eax
  801270:	6a 18                	push   $0x18
  801272:	e8 8a fd ff ff       	call   801001 <syscall>
  801277:	83 c4 18             	add    $0x18,%esp
}
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	ff 75 14             	pushl  0x14(%ebp)
  801287:	ff 75 10             	pushl  0x10(%ebp)
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	50                   	push   %eax
  80128e:	6a 19                	push   $0x19
  801290:	e8 6c fd ff ff       	call   801001 <syscall>
  801295:	83 c4 18             	add    $0x18,%esp
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	50                   	push   %eax
  8012a9:	6a 1a                	push   $0x1a
  8012ab:	e8 51 fd ff ff       	call   801001 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	50                   	push   %eax
  8012c5:	6a 1b                	push   $0x1b
  8012c7:	e8 35 fd ff ff       	call   801001 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 05                	push   $0x5
  8012e0:	e8 1c fd ff ff       	call   801001 <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 06                	push   $0x6
  8012f9:	e8 03 fd ff ff       	call   801001 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 07                	push   $0x7
  801312:	e8 ea fc ff ff       	call   801001 <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_exit_env>:


void sys_exit_env(void)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 1c                	push   $0x1c
  80132b:	e8 d1 fc ff ff       	call   801001 <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	90                   	nop
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80133c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80133f:	8d 50 04             	lea    0x4(%eax),%edx
  801342:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	52                   	push   %edx
  80134c:	50                   	push   %eax
  80134d:	6a 1d                	push   $0x1d
  80134f:	e8 ad fc ff ff       	call   801001 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
	return result;
  801357:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801360:	89 01                	mov    %eax,(%ecx)
  801362:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	c9                   	leave  
  801369:	c2 04 00             	ret    $0x4

0080136c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	ff 75 10             	pushl  0x10(%ebp)
  801376:	ff 75 0c             	pushl  0xc(%ebp)
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	6a 13                	push   $0x13
  80137e:	e8 7e fc ff ff       	call   801001 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
	return ;
  801386:	90                   	nop
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_rcr2>:
uint32 sys_rcr2()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 1e                	push   $0x1e
  801398:	e8 64 fc ff ff       	call   801001 <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013ae:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	50                   	push   %eax
  8013bb:	6a 1f                	push   $0x1f
  8013bd:	e8 3f fc ff ff       	call   801001 <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8013c5:	90                   	nop
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <rsttst>:
void rsttst()
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 21                	push   $0x21
  8013d7:	e8 25 fc ff ff       	call   801001 <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8013df:	90                   	nop
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013ee:	8b 55 18             	mov    0x18(%ebp),%edx
  8013f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f5:	52                   	push   %edx
  8013f6:	50                   	push   %eax
  8013f7:	ff 75 10             	pushl  0x10(%ebp)
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	6a 20                	push   $0x20
  801402:	e8 fa fb ff ff       	call   801001 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
	return ;
  80140a:	90                   	nop
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <chktst>:
void chktst(uint32 n)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	ff 75 08             	pushl  0x8(%ebp)
  80141b:	6a 22                	push   $0x22
  80141d:	e8 df fb ff ff       	call   801001 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
	return ;
  801425:	90                   	nop
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <inctst>:

void inctst()
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 23                	push   $0x23
  801437:	e8 c5 fb ff ff       	call   801001 <syscall>
  80143c:	83 c4 18             	add    $0x18,%esp
	return ;
  80143f:	90                   	nop
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <gettst>:
uint32 gettst()
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 24                	push   $0x24
  801451:	e8 ab fb ff ff       	call   801001 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 25                	push   $0x25
  80146d:	e8 8f fb ff ff       	call   801001 <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
  801475:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801478:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80147c:	75 07                	jne    801485 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80147e:	b8 01 00 00 00       	mov    $0x1,%eax
  801483:	eb 05                	jmp    80148a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 25                	push   $0x25
  80149e:	e8 5e fb ff ff       	call   801001 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
  8014a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014a9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014ad:	75 07                	jne    8014b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014af:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b4:	eb 05                	jmp    8014bb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 25                	push   $0x25
  8014cf:	e8 2d fb ff ff       	call   801001 <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
  8014d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014da:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014de:	75 07                	jne    8014e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e5:	eb 05                	jmp    8014ec <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 25                	push   $0x25
  801500:	e8 fc fa ff ff       	call   801001 <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80150b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80150f:	75 07                	jne    801518 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801511:	b8 01 00 00 00       	mov    $0x1,%eax
  801516:	eb 05                	jmp    80151d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	ff 75 08             	pushl  0x8(%ebp)
  80152d:	6a 26                	push   $0x26
  80152f:	e8 cd fa ff ff       	call   801001 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
	return ;
  801537:	90                   	nop
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80153e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801541:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801544:	8b 55 0c             	mov    0xc(%ebp),%edx
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	6a 00                	push   $0x0
  80154c:	53                   	push   %ebx
  80154d:	51                   	push   %ecx
  80154e:	52                   	push   %edx
  80154f:	50                   	push   %eax
  801550:	6a 27                	push   $0x27
  801552:	e8 aa fa ff ff       	call   801001 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	52                   	push   %edx
  80156f:	50                   	push   %eax
  801570:	6a 28                	push   $0x28
  801572:	e8 8a fa ff ff       	call   801001 <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80157f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801582:	8b 55 0c             	mov    0xc(%ebp),%edx
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	6a 00                	push   $0x0
  80158a:	51                   	push   %ecx
  80158b:	ff 75 10             	pushl  0x10(%ebp)
  80158e:	52                   	push   %edx
  80158f:	50                   	push   %eax
  801590:	6a 29                	push   $0x29
  801592:	e8 6a fa ff ff       	call   801001 <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	ff 75 10             	pushl  0x10(%ebp)
  8015a6:	ff 75 0c             	pushl  0xc(%ebp)
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	6a 12                	push   $0x12
  8015ae:	e8 4e fa ff ff       	call   801001 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b6:	90                   	nop
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	52                   	push   %edx
  8015c9:	50                   	push   %eax
  8015ca:	6a 2a                	push   $0x2a
  8015cc:	e8 30 fa ff ff       	call   801001 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
	return;
  8015d4:	90                   	nop
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	50                   	push   %eax
  8015e6:	6a 2b                	push   $0x2b
  8015e8:	e8 14 fa ff ff       	call   801001 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	6a 2c                	push   $0x2c
  801603:	e8 f9 f9 ff ff       	call   801001 <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
	return;
  80160b:	90                   	nop
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	ff 75 0c             	pushl  0xc(%ebp)
  80161a:	ff 75 08             	pushl  0x8(%ebp)
  80161d:	6a 2d                	push   $0x2d
  80161f:	e8 dd f9 ff ff       	call   801001 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801630:	8d 45 10             	lea    0x10(%ebp),%eax
  801633:	83 c0 04             	add    $0x4,%eax
  801636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801639:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80163e:	85 c0                	test   %eax,%eax
  801640:	74 16                	je     801658 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801642:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	50                   	push   %eax
  80164b:	68 58 1f 80 00       	push   $0x801f58
  801650:	e8 12 ec ff ff       	call   800267 <cprintf>
  801655:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801658:	a1 00 30 80 00       	mov    0x803000,%eax
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	50                   	push   %eax
  801664:	68 5d 1f 80 00       	push   $0x801f5d
  801669:	e8 f9 eb ff ff       	call   800267 <cprintf>
  80166e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	ff 75 f4             	pushl  -0xc(%ebp)
  80167a:	50                   	push   %eax
  80167b:	e8 7c eb ff ff       	call   8001fc <vcprintf>
  801680:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	6a 00                	push   $0x0
  801688:	68 79 1f 80 00       	push   $0x801f79
  80168d:	e8 6a eb ff ff       	call   8001fc <vcprintf>
  801692:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801695:	e8 eb ea ff ff       	call   800185 <exit>

	// should not return here
	while (1) ;
  80169a:	eb fe                	jmp    80169a <_panic+0x70>

0080169c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016a2:	a1 04 30 80 00       	mov    0x803004,%eax
  8016a7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8016ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b0:	39 c2                	cmp    %eax,%edx
  8016b2:	74 14                	je     8016c8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 7c 1f 80 00       	push   $0x801f7c
  8016bc:	6a 26                	push   $0x26
  8016be:	68 c8 1f 80 00       	push   $0x801fc8
  8016c3:	e8 62 ff ff ff       	call   80162a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016d6:	e9 c5 00 00 00       	jmp    8017a0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	75 08                	jne    8016f8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8016f0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016f3:	e9 a5 00 00 00       	jmp    80179d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8016f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801706:	eb 69                	jmp    801771 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801708:	a1 04 30 80 00       	mov    0x803004,%eax
  80170d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801713:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801716:	89 d0                	mov    %edx,%eax
  801718:	01 c0                	add    %eax,%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	c1 e0 03             	shl    $0x3,%eax
  80171f:	01 c8                	add    %ecx,%eax
  801721:	8a 40 04             	mov    0x4(%eax),%al
  801724:	84 c0                	test   %al,%al
  801726:	75 46                	jne    80176e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801728:	a1 04 30 80 00       	mov    0x803004,%eax
  80172d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801733:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	01 c0                	add    %eax,%eax
  80173a:	01 d0                	add    %edx,%eax
  80173c:	c1 e0 03             	shl    $0x3,%eax
  80173f:	01 c8                	add    %ecx,%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801746:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80174e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	01 c8                	add    %ecx,%eax
  80175f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801761:	39 c2                	cmp    %eax,%edx
  801763:	75 09                	jne    80176e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801765:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80176c:	eb 15                	jmp    801783 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80176e:	ff 45 e8             	incl   -0x18(%ebp)
  801771:	a1 04 30 80 00       	mov    0x803004,%eax
  801776:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80177c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177f:	39 c2                	cmp    %eax,%edx
  801781:	77 85                	ja     801708 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801783:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801787:	75 14                	jne    80179d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 d4 1f 80 00       	push   $0x801fd4
  801791:	6a 3a                	push   $0x3a
  801793:	68 c8 1f 80 00       	push   $0x801fc8
  801798:	e8 8d fe ff ff       	call   80162a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80179d:	ff 45 f0             	incl   -0x10(%ebp)
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017a6:	0f 8c 2f ff ff ff    	jl     8016db <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017ba:	eb 26                	jmp    8017e2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8017c1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017ca:	89 d0                	mov    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d0                	add    %edx,%eax
  8017d0:	c1 e0 03             	shl    $0x3,%eax
  8017d3:	01 c8                	add    %ecx,%eax
  8017d5:	8a 40 04             	mov    0x4(%eax),%al
  8017d8:	3c 01                	cmp    $0x1,%al
  8017da:	75 03                	jne    8017df <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017dc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017df:	ff 45 e0             	incl   -0x20(%ebp)
  8017e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8017e7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f0:	39 c2                	cmp    %eax,%edx
  8017f2:	77 c8                	ja     8017bc <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017fa:	74 14                	je     801810 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	68 28 20 80 00       	push   $0x802028
  801804:	6a 44                	push   $0x44
  801806:	68 c8 1f 80 00       	push   $0x801fc8
  80180b:	e8 1a fe ff ff       	call   80162a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    
  801813:	90                   	nop

00801814 <__udivdi3>:
  801814:	55                   	push   %ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
  801818:	83 ec 1c             	sub    $0x1c,%esp
  80181b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80181f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182b:	89 ca                	mov    %ecx,%edx
  80182d:	89 f8                	mov    %edi,%eax
  80182f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801833:	85 f6                	test   %esi,%esi
  801835:	75 2d                	jne    801864 <__udivdi3+0x50>
  801837:	39 cf                	cmp    %ecx,%edi
  801839:	77 65                	ja     8018a0 <__udivdi3+0x8c>
  80183b:	89 fd                	mov    %edi,%ebp
  80183d:	85 ff                	test   %edi,%edi
  80183f:	75 0b                	jne    80184c <__udivdi3+0x38>
  801841:	b8 01 00 00 00       	mov    $0x1,%eax
  801846:	31 d2                	xor    %edx,%edx
  801848:	f7 f7                	div    %edi
  80184a:	89 c5                	mov    %eax,%ebp
  80184c:	31 d2                	xor    %edx,%edx
  80184e:	89 c8                	mov    %ecx,%eax
  801850:	f7 f5                	div    %ebp
  801852:	89 c1                	mov    %eax,%ecx
  801854:	89 d8                	mov    %ebx,%eax
  801856:	f7 f5                	div    %ebp
  801858:	89 cf                	mov    %ecx,%edi
  80185a:	89 fa                	mov    %edi,%edx
  80185c:	83 c4 1c             	add    $0x1c,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    
  801864:	39 ce                	cmp    %ecx,%esi
  801866:	77 28                	ja     801890 <__udivdi3+0x7c>
  801868:	0f bd fe             	bsr    %esi,%edi
  80186b:	83 f7 1f             	xor    $0x1f,%edi
  80186e:	75 40                	jne    8018b0 <__udivdi3+0x9c>
  801870:	39 ce                	cmp    %ecx,%esi
  801872:	72 0a                	jb     80187e <__udivdi3+0x6a>
  801874:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801878:	0f 87 9e 00 00 00    	ja     80191c <__udivdi3+0x108>
  80187e:	b8 01 00 00 00       	mov    $0x1,%eax
  801883:	89 fa                	mov    %edi,%edx
  801885:	83 c4 1c             	add    $0x1c,%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5f                   	pop    %edi
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    
  80188d:	8d 76 00             	lea    0x0(%esi),%esi
  801890:	31 ff                	xor    %edi,%edi
  801892:	31 c0                	xor    %eax,%eax
  801894:	89 fa                	mov    %edi,%edx
  801896:	83 c4 1c             	add    $0x1c,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5f                   	pop    %edi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    
  80189e:	66 90                	xchg   %ax,%ax
  8018a0:	89 d8                	mov    %ebx,%eax
  8018a2:	f7 f7                	div    %edi
  8018a4:	31 ff                	xor    %edi,%edi
  8018a6:	89 fa                	mov    %edi,%edx
  8018a8:	83 c4 1c             	add    $0x1c,%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5f                   	pop    %edi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
  8018b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018b5:	89 eb                	mov    %ebp,%ebx
  8018b7:	29 fb                	sub    %edi,%ebx
  8018b9:	89 f9                	mov    %edi,%ecx
  8018bb:	d3 e6                	shl    %cl,%esi
  8018bd:	89 c5                	mov    %eax,%ebp
  8018bf:	88 d9                	mov    %bl,%cl
  8018c1:	d3 ed                	shr    %cl,%ebp
  8018c3:	89 e9                	mov    %ebp,%ecx
  8018c5:	09 f1                	or     %esi,%ecx
  8018c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018cb:	89 f9                	mov    %edi,%ecx
  8018cd:	d3 e0                	shl    %cl,%eax
  8018cf:	89 c5                	mov    %eax,%ebp
  8018d1:	89 d6                	mov    %edx,%esi
  8018d3:	88 d9                	mov    %bl,%cl
  8018d5:	d3 ee                	shr    %cl,%esi
  8018d7:	89 f9                	mov    %edi,%ecx
  8018d9:	d3 e2                	shl    %cl,%edx
  8018db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018df:	88 d9                	mov    %bl,%cl
  8018e1:	d3 e8                	shr    %cl,%eax
  8018e3:	09 c2                	or     %eax,%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	89 f2                	mov    %esi,%edx
  8018e9:	f7 74 24 0c          	divl   0xc(%esp)
  8018ed:	89 d6                	mov    %edx,%esi
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	f7 e5                	mul    %ebp
  8018f3:	39 d6                	cmp    %edx,%esi
  8018f5:	72 19                	jb     801910 <__udivdi3+0xfc>
  8018f7:	74 0b                	je     801904 <__udivdi3+0xf0>
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	31 ff                	xor    %edi,%edi
  8018fd:	e9 58 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  801902:	66 90                	xchg   %ax,%ax
  801904:	8b 54 24 08          	mov    0x8(%esp),%edx
  801908:	89 f9                	mov    %edi,%ecx
  80190a:	d3 e2                	shl    %cl,%edx
  80190c:	39 c2                	cmp    %eax,%edx
  80190e:	73 e9                	jae    8018f9 <__udivdi3+0xe5>
  801910:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801913:	31 ff                	xor    %edi,%edi
  801915:	e9 40 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  80191a:	66 90                	xchg   %ax,%ax
  80191c:	31 c0                	xor    %eax,%eax
  80191e:	e9 37 ff ff ff       	jmp    80185a <__udivdi3+0x46>
  801923:	90                   	nop

00801924 <__umoddi3>:
  801924:	55                   	push   %ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 1c             	sub    $0x1c,%esp
  80192b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80192f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801937:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80193b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80193f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801943:	89 f3                	mov    %esi,%ebx
  801945:	89 fa                	mov    %edi,%edx
  801947:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80194b:	89 34 24             	mov    %esi,(%esp)
  80194e:	85 c0                	test   %eax,%eax
  801950:	75 1a                	jne    80196c <__umoddi3+0x48>
  801952:	39 f7                	cmp    %esi,%edi
  801954:	0f 86 a2 00 00 00    	jbe    8019fc <__umoddi3+0xd8>
  80195a:	89 c8                	mov    %ecx,%eax
  80195c:	89 f2                	mov    %esi,%edx
  80195e:	f7 f7                	div    %edi
  801960:	89 d0                	mov    %edx,%eax
  801962:	31 d2                	xor    %edx,%edx
  801964:	83 c4 1c             	add    $0x1c,%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
  80196c:	39 f0                	cmp    %esi,%eax
  80196e:	0f 87 ac 00 00 00    	ja     801a20 <__umoddi3+0xfc>
  801974:	0f bd e8             	bsr    %eax,%ebp
  801977:	83 f5 1f             	xor    $0x1f,%ebp
  80197a:	0f 84 ac 00 00 00    	je     801a2c <__umoddi3+0x108>
  801980:	bf 20 00 00 00       	mov    $0x20,%edi
  801985:	29 ef                	sub    %ebp,%edi
  801987:	89 fe                	mov    %edi,%esi
  801989:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80198d:	89 e9                	mov    %ebp,%ecx
  80198f:	d3 e0                	shl    %cl,%eax
  801991:	89 d7                	mov    %edx,%edi
  801993:	89 f1                	mov    %esi,%ecx
  801995:	d3 ef                	shr    %cl,%edi
  801997:	09 c7                	or     %eax,%edi
  801999:	89 e9                	mov    %ebp,%ecx
  80199b:	d3 e2                	shl    %cl,%edx
  80199d:	89 14 24             	mov    %edx,(%esp)
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	d3 e0                	shl    %cl,%eax
  8019a4:	89 c2                	mov    %eax,%edx
  8019a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019aa:	d3 e0                	shl    %cl,%eax
  8019ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b4:	89 f1                	mov    %esi,%ecx
  8019b6:	d3 e8                	shr    %cl,%eax
  8019b8:	09 d0                	or     %edx,%eax
  8019ba:	d3 eb                	shr    %cl,%ebx
  8019bc:	89 da                	mov    %ebx,%edx
  8019be:	f7 f7                	div    %edi
  8019c0:	89 d3                	mov    %edx,%ebx
  8019c2:	f7 24 24             	mull   (%esp)
  8019c5:	89 c6                	mov    %eax,%esi
  8019c7:	89 d1                	mov    %edx,%ecx
  8019c9:	39 d3                	cmp    %edx,%ebx
  8019cb:	0f 82 87 00 00 00    	jb     801a58 <__umoddi3+0x134>
  8019d1:	0f 84 91 00 00 00    	je     801a68 <__umoddi3+0x144>
  8019d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019db:	29 f2                	sub    %esi,%edx
  8019dd:	19 cb                	sbb    %ecx,%ebx
  8019df:	89 d8                	mov    %ebx,%eax
  8019e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019e5:	d3 e0                	shl    %cl,%eax
  8019e7:	89 e9                	mov    %ebp,%ecx
  8019e9:	d3 ea                	shr    %cl,%edx
  8019eb:	09 d0                	or     %edx,%eax
  8019ed:	89 e9                	mov    %ebp,%ecx
  8019ef:	d3 eb                	shr    %cl,%ebx
  8019f1:	89 da                	mov    %ebx,%edx
  8019f3:	83 c4 1c             	add    $0x1c,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5f                   	pop    %edi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    
  8019fb:	90                   	nop
  8019fc:	89 fd                	mov    %edi,%ebp
  8019fe:	85 ff                	test   %edi,%edi
  801a00:	75 0b                	jne    801a0d <__umoddi3+0xe9>
  801a02:	b8 01 00 00 00       	mov    $0x1,%eax
  801a07:	31 d2                	xor    %edx,%edx
  801a09:	f7 f7                	div    %edi
  801a0b:	89 c5                	mov    %eax,%ebp
  801a0d:	89 f0                	mov    %esi,%eax
  801a0f:	31 d2                	xor    %edx,%edx
  801a11:	f7 f5                	div    %ebp
  801a13:	89 c8                	mov    %ecx,%eax
  801a15:	f7 f5                	div    %ebp
  801a17:	89 d0                	mov    %edx,%eax
  801a19:	e9 44 ff ff ff       	jmp    801962 <__umoddi3+0x3e>
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	89 c8                	mov    %ecx,%eax
  801a22:	89 f2                	mov    %esi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	3b 04 24             	cmp    (%esp),%eax
  801a2f:	72 06                	jb     801a37 <__umoddi3+0x113>
  801a31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a35:	77 0f                	ja     801a46 <__umoddi3+0x122>
  801a37:	89 f2                	mov    %esi,%edx
  801a39:	29 f9                	sub    %edi,%ecx
  801a3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a3f:	89 14 24             	mov    %edx,(%esp)
  801a42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a4a:	8b 14 24             	mov    (%esp),%edx
  801a4d:	83 c4 1c             	add    $0x1c,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    
  801a55:	8d 76 00             	lea    0x0(%esi),%esi
  801a58:	2b 04 24             	sub    (%esp),%eax
  801a5b:	19 fa                	sbb    %edi,%edx
  801a5d:	89 d1                	mov    %edx,%ecx
  801a5f:	89 c6                	mov    %eax,%esi
  801a61:	e9 71 ff ff ff       	jmp    8019d7 <__umoddi3+0xb3>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a6c:	72 ea                	jb     801a58 <__umoddi3+0x134>
  801a6e:	89 d9                	mov    %ebx,%ecx
  801a70:	e9 62 ff ff ff       	jmp    8019d7 <__umoddi3+0xb3>
