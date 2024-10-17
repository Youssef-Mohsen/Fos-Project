
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
  800044:	68 a0 1a 80 00       	push   $0x801aa0
  800049:	e8 54 02 00 00       	call   8002a2 <atomic_cprintf>
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
  80005a:	e8 99 12 00 00       	call   8012f8 <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 06             	shl    $0x6,%eax
  80006a:	29 d0                	sub    %edx,%eax
  80006c:	c1 e0 02             	shl    $0x2,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800078:	01 c8                	add    %ecx,%eax
  80007a:	c1 e0 03             	shl    $0x3,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800086:	29 c2                	sub    %eax,%edx
  800088:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80008f:	89 c2                	mov    %eax,%edx
  800091:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800097:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009c:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a1:	8a 40 20             	mov    0x20(%eax),%al
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 0d                	je     8000b5 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8000a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ad:	83 c0 20             	add    $0x20,%eax
  8000b0:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x71>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8000c5:	83 ec 08             	sub    $0x8,%esp
  8000c8:	ff 75 0c             	pushl  0xc(%ebp)
  8000cb:	ff 75 08             	pushl  0x8(%ebp)
  8000ce:	e8 65 ff ff ff       	call   800038 <_main>
  8000d3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8000d6:	e8 a1 0f 00 00       	call   80107c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 dc 1a 80 00       	push   $0x801adc
  8000e3:	e8 8d 01 00 00       	call   800275 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f0:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8000f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000fb:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	52                   	push   %edx
  800105:	50                   	push   %eax
  800106:	68 04 1b 80 00       	push   $0x801b04
  80010b:	e8 65 01 00 00       	call   800275 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800113:	a1 04 30 80 00       	mov    0x803004,%eax
  800118:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80011e:	a1 04 30 80 00       	mov    0x803004,%eax
  800123:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800129:	a1 04 30 80 00       	mov    0x803004,%eax
  80012e:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800134:	51                   	push   %ecx
  800135:	52                   	push   %edx
  800136:	50                   	push   %eax
  800137:	68 2c 1b 80 00       	push   $0x801b2c
  80013c:	e8 34 01 00 00       	call   800275 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800144:	a1 04 30 80 00       	mov    0x803004,%eax
  800149:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	50                   	push   %eax
  800153:	68 84 1b 80 00       	push   $0x801b84
  800158:	e8 18 01 00 00       	call   800275 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	68 dc 1a 80 00       	push   $0x801adc
  800168:	e8 08 01 00 00       	call   800275 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800170:	e8 21 0f 00 00       	call   801096 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800175:	e8 19 00 00 00       	call   800193 <exit>
}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	6a 00                	push   $0x0
  800188:	e8 37 11 00 00       	call   8012c4 <sys_destroy_env>
  80018d:	83 c4 10             	add    $0x10,%esp
}
  800190:	90                   	nop
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <exit>:

void
exit(void)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800199:	e8 8c 11 00 00       	call   80132a <sys_exit_env>
}
  80019e:	90                   	nop
  80019f:	c9                   	leave  
  8001a0:	c3                   	ret    

008001a1 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001aa:	8b 00                	mov    (%eax),%eax
  8001ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8001af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b2:	89 0a                	mov    %ecx,(%edx)
  8001b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b7:	88 d1                	mov    %dl,%cl
  8001b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c3:	8b 00                	mov    (%eax),%eax
  8001c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ca:	75 2c                	jne    8001f8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001cc:	a0 08 30 80 00       	mov    0x803008,%al
  8001d1:	0f b6 c0             	movzbl %al,%eax
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	8b 12                	mov    (%edx),%edx
  8001d9:	89 d1                	mov    %edx,%ecx
  8001db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001de:	83 c2 08             	add    $0x8,%edx
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	50                   	push   %eax
  8001e5:	51                   	push   %ecx
  8001e6:	52                   	push   %edx
  8001e7:	e8 4e 0e 00 00       	call   80103a <sys_cputs>
  8001ec:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fb:	8b 40 04             	mov    0x4(%eax),%eax
  8001fe:	8d 50 01             	lea    0x1(%eax),%edx
  800201:	8b 45 0c             	mov    0xc(%ebp),%eax
  800204:	89 50 04             	mov    %edx,0x4(%eax)
}
  800207:	90                   	nop
  800208:	c9                   	leave  
  800209:	c3                   	ret    

0080020a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800213:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021a:	00 00 00 
	b.cnt = 0;
  80021d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800224:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800227:	ff 75 0c             	pushl  0xc(%ebp)
  80022a:	ff 75 08             	pushl  0x8(%ebp)
  80022d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	68 a1 01 80 00       	push   $0x8001a1
  800239:	e8 11 02 00 00       	call   80044f <vprintfmt>
  80023e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800241:	a0 08 30 80 00       	mov    0x803008,%al
  800246:	0f b6 c0             	movzbl %al,%eax
  800249:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80024f:	83 ec 04             	sub    $0x4,%esp
  800252:	50                   	push   %eax
  800253:	52                   	push   %edx
  800254:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025a:	83 c0 08             	add    $0x8,%eax
  80025d:	50                   	push   %eax
  80025e:	e8 d7 0d 00 00       	call   80103a <sys_cputs>
  800263:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800266:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80027b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800282:	8d 45 0c             	lea    0xc(%ebp),%eax
  800285:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	83 ec 08             	sub    $0x8,%esp
  80028e:	ff 75 f4             	pushl  -0xc(%ebp)
  800291:	50                   	push   %eax
  800292:	e8 73 ff ff ff       	call   80020a <vcprintf>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002a8:	e8 cf 0d 00 00       	call   80107c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002bc:	50                   	push   %eax
  8002bd:	e8 48 ff ff ff       	call   80020a <vcprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002c8:	e8 c9 0d 00 00       	call   801096 <sys_unlock_cons>
	return cnt;
  8002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 14             	sub    $0x14,%esp
  8002d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002df:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f0:	77 55                	ja     800347 <printnum+0x75>
  8002f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f5:	72 05                	jb     8002fc <printnum+0x2a>
  8002f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fa:	77 4b                	ja     800347 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800302:	8b 45 18             	mov    0x18(%ebp),%eax
  800305:	ba 00 00 00 00       	mov    $0x0,%edx
  80030a:	52                   	push   %edx
  80030b:	50                   	push   %eax
  80030c:	ff 75 f4             	pushl  -0xc(%ebp)
  80030f:	ff 75 f0             	pushl  -0x10(%ebp)
  800312:	e8 11 15 00 00       	call   801828 <__udivdi3>
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	ff 75 20             	pushl  0x20(%ebp)
  800320:	53                   	push   %ebx
  800321:	ff 75 18             	pushl  0x18(%ebp)
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	ff 75 0c             	pushl  0xc(%ebp)
  800329:	ff 75 08             	pushl  0x8(%ebp)
  80032c:	e8 a1 ff ff ff       	call   8002d2 <printnum>
  800331:	83 c4 20             	add    $0x20,%esp
  800334:	eb 1a                	jmp    800350 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 20             	pushl  0x20(%ebp)
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	ff d0                	call   *%eax
  800344:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800347:	ff 4d 1c             	decl   0x1c(%ebp)
  80034a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80034e:	7f e6                	jg     800336 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800350:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800353:	bb 00 00 00 00       	mov    $0x0,%ebx
  800358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80035e:	53                   	push   %ebx
  80035f:	51                   	push   %ecx
  800360:	52                   	push   %edx
  800361:	50                   	push   %eax
  800362:	e8 d1 15 00 00       	call   801938 <__umoddi3>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	05 b4 1d 80 00       	add    $0x801db4,%eax
  80036f:	8a 00                	mov    (%eax),%al
  800371:	0f be c0             	movsbl %al,%eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 0c             	pushl  0xc(%ebp)
  80037a:	50                   	push   %eax
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	ff d0                	call   *%eax
  800380:	83 c4 10             	add    $0x10,%esp
}
  800383:	90                   	nop
  800384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800390:	7e 1c                	jle    8003ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 50 08             	lea    0x8(%eax),%edx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	89 10                	mov    %edx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	83 e8 08             	sub    $0x8,%eax
  8003a7:	8b 50 04             	mov    0x4(%eax),%edx
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	eb 40                	jmp    8003ee <getuint+0x65>
	else if (lflag)
  8003ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b2:	74 1e                	je     8003d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	8d 50 04             	lea    0x4(%eax),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	89 10                	mov    %edx,(%eax)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	83 e8 04             	sub    $0x4,%eax
  8003c9:	8b 00                	mov    (%eax),%eax
  8003cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d0:	eb 1c                	jmp    8003ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	8d 50 04             	lea    0x4(%eax),%edx
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	89 10                	mov    %edx,(%eax)
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	83 e8 04             	sub    $0x4,%eax
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f7:	7e 1c                	jle    800415 <getint+0x25>
		return va_arg(*ap, long long);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 08             	lea    0x8(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 08             	sub    $0x8,%eax
  80040e:	8b 50 04             	mov    0x4(%eax),%edx
  800411:	8b 00                	mov    (%eax),%eax
  800413:	eb 38                	jmp    80044d <getint+0x5d>
	else if (lflag)
  800415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800419:	74 1a                	je     800435 <getint+0x45>
		return va_arg(*ap, long);
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	8d 50 04             	lea    0x4(%eax),%edx
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	89 10                	mov    %edx,(%eax)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 e8 04             	sub    $0x4,%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	99                   	cltd   
  800433:	eb 18                	jmp    80044d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	8d 50 04             	lea    0x4(%eax),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	89 10                	mov    %edx,(%eax)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	83 e8 04             	sub    $0x4,%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
}
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    

0080044f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800457:	eb 17                	jmp    800470 <vprintfmt+0x21>
			if (ch == '\0')
  800459:	85 db                	test   %ebx,%ebx
  80045b:	0f 84 c1 03 00 00    	je     800822 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	ff 75 0c             	pushl  0xc(%ebp)
  800467:	53                   	push   %ebx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	ff d0                	call   *%eax
  80046d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800470:	8b 45 10             	mov    0x10(%ebp),%eax
  800473:	8d 50 01             	lea    0x1(%eax),%edx
  800476:	89 55 10             	mov    %edx,0x10(%ebp)
  800479:	8a 00                	mov    (%eax),%al
  80047b:	0f b6 d8             	movzbl %al,%ebx
  80047e:	83 fb 25             	cmp    $0x25,%ebx
  800481:	75 d6                	jne    800459 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800483:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800487:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80048e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800495:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80049c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a6:	8d 50 01             	lea    0x1(%eax),%edx
  8004a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ac:	8a 00                	mov    (%eax),%al
  8004ae:	0f b6 d8             	movzbl %al,%ebx
  8004b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b4:	83 f8 5b             	cmp    $0x5b,%eax
  8004b7:	0f 87 3d 03 00 00    	ja     8007fa <vprintfmt+0x3ab>
  8004bd:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  8004c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004ca:	eb d7                	jmp    8004a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004d0:	eb d1                	jmp    8004a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004dc:	89 d0                	mov    %edx,%eax
  8004de:	c1 e0 02             	shl    $0x2,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	01 c0                	add    %eax,%eax
  8004e5:	01 d8                	add    %ebx,%eax
  8004e7:	83 e8 30             	sub    $0x30,%eax
  8004ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f0:	8a 00                	mov    (%eax),%al
  8004f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f8:	7e 3e                	jle    800538 <vprintfmt+0xe9>
  8004fa:	83 fb 39             	cmp    $0x39,%ebx
  8004fd:	7f 39                	jg     800538 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800502:	eb d5                	jmp    8004d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	83 c0 04             	add    $0x4,%eax
  80050a:	89 45 14             	mov    %eax,0x14(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	83 e8 04             	sub    $0x4,%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800518:	eb 1f                	jmp    800539 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80051e:	79 83                	jns    8004a3 <vprintfmt+0x54>
				width = 0;
  800520:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800527:	e9 77 ff ff ff       	jmp    8004a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80052c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800533:	e9 6b ff ff ff       	jmp    8004a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800538:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800539:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053d:	0f 89 60 ff ff ff    	jns    8004a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800549:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800550:	e9 4e ff ff ff       	jmp    8004a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800555:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800558:	e9 46 ff ff ff       	jmp    8004a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	83 e8 04             	sub    $0x4,%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	50                   	push   %eax
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	ff d0                	call   *%eax
  80057a:	83 c4 10             	add    $0x10,%esp
			break;
  80057d:	e9 9b 02 00 00       	jmp    80081d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	83 c0 04             	add    $0x4,%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	83 e8 04             	sub    $0x4,%eax
  800591:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800593:	85 db                	test   %ebx,%ebx
  800595:	79 02                	jns    800599 <vprintfmt+0x14a>
				err = -err;
  800597:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800599:	83 fb 64             	cmp    $0x64,%ebx
  80059c:	7f 0b                	jg     8005a9 <vprintfmt+0x15a>
  80059e:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  8005a5:	85 f6                	test   %esi,%esi
  8005a7:	75 19                	jne    8005c2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a9:	53                   	push   %ebx
  8005aa:	68 c5 1d 80 00       	push   $0x801dc5
  8005af:	ff 75 0c             	pushl  0xc(%ebp)
  8005b2:	ff 75 08             	pushl  0x8(%ebp)
  8005b5:	e8 70 02 00 00       	call   80082a <printfmt>
  8005ba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005bd:	e9 5b 02 00 00       	jmp    80081d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005c2:	56                   	push   %esi
  8005c3:	68 ce 1d 80 00       	push   $0x801dce
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	e8 57 02 00 00       	call   80082a <printfmt>
  8005d3:	83 c4 10             	add    $0x10,%esp
			break;
  8005d6:	e9 42 02 00 00       	jmp    80081d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 c0 04             	add    $0x4,%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	83 e8 04             	sub    $0x4,%eax
  8005ea:	8b 30                	mov    (%eax),%esi
  8005ec:	85 f6                	test   %esi,%esi
  8005ee:	75 05                	jne    8005f5 <vprintfmt+0x1a6>
				p = "(null)";
  8005f0:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  8005f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f9:	7e 6d                	jle    800668 <vprintfmt+0x219>
  8005fb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005ff:	74 67                	je     800668 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	50                   	push   %eax
  800608:	56                   	push   %esi
  800609:	e8 1e 03 00 00       	call   80092c <strnlen>
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800614:	eb 16                	jmp    80062c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800616:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	ff 75 0c             	pushl  0xc(%ebp)
  800620:	50                   	push   %eax
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	ff d0                	call   *%eax
  800626:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800629:	ff 4d e4             	decl   -0x1c(%ebp)
  80062c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800630:	7f e4                	jg     800616 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800632:	eb 34                	jmp    800668 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800638:	74 1c                	je     800656 <vprintfmt+0x207>
  80063a:	83 fb 1f             	cmp    $0x1f,%ebx
  80063d:	7e 05                	jle    800644 <vprintfmt+0x1f5>
  80063f:	83 fb 7e             	cmp    $0x7e,%ebx
  800642:	7e 12                	jle    800656 <vprintfmt+0x207>
					putch('?', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	6a 3f                	push   $0x3f
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
  800654:	eb 0f                	jmp    800665 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	ff 75 0c             	pushl  0xc(%ebp)
  80065c:	53                   	push   %ebx
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	ff d0                	call   *%eax
  800662:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800665:	ff 4d e4             	decl   -0x1c(%ebp)
  800668:	89 f0                	mov    %esi,%eax
  80066a:	8d 70 01             	lea    0x1(%eax),%esi
  80066d:	8a 00                	mov    (%eax),%al
  80066f:	0f be d8             	movsbl %al,%ebx
  800672:	85 db                	test   %ebx,%ebx
  800674:	74 24                	je     80069a <vprintfmt+0x24b>
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	78 b8                	js     800634 <vprintfmt+0x1e5>
  80067c:	ff 4d e0             	decl   -0x20(%ebp)
  80067f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800683:	79 af                	jns    800634 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800685:	eb 13                	jmp    80069a <vprintfmt+0x24b>
				putch(' ', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	ff 75 0c             	pushl  0xc(%ebp)
  80068d:	6a 20                	push   $0x20
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	ff d0                	call   *%eax
  800694:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800697:	ff 4d e4             	decl   -0x1c(%ebp)
  80069a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069e:	7f e7                	jg     800687 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006a0:	e9 78 01 00 00       	jmp    80081d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ae:	50                   	push   %eax
  8006af:	e8 3c fd ff ff       	call   8003f0 <getint>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	85 d2                	test   %edx,%edx
  8006c5:	79 23                	jns    8006ea <vprintfmt+0x29b>
				putch('-', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	6a 2d                	push   $0x2d
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006dd:	f7 d8                	neg    %eax
  8006df:	83 d2 00             	adc    $0x0,%edx
  8006e2:	f7 da                	neg    %edx
  8006e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006ea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f1:	e9 bc 00 00 00       	jmp    8007b2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ff:	50                   	push   %eax
  800700:	e8 84 fc ff ff       	call   800389 <getuint>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80070e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800715:	e9 98 00 00 00       	jmp    8007b2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 58                	push   $0x58
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	6a 58                	push   $0x58
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	ff d0                	call   *%eax
  800737:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	6a 58                	push   $0x58
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	ff d0                	call   *%eax
  800747:	83 c4 10             	add    $0x10,%esp
			break;
  80074a:	e9 ce 00 00 00       	jmp    80081d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	ff 75 0c             	pushl  0xc(%ebp)
  800755:	6a 30                	push   $0x30
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 78                	push   $0x78
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	83 c0 04             	add    $0x4,%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	83 e8 04             	sub    $0x4,%eax
  80077e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800783:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80078a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800791:	eb 1f                	jmp    8007b2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800793:	83 ec 08             	sub    $0x8,%esp
  800796:	ff 75 e8             	pushl  -0x18(%ebp)
  800799:	8d 45 14             	lea    0x14(%ebp),%eax
  80079c:	50                   	push   %eax
  80079d:	e8 e7 fb ff ff       	call   800389 <getuint>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	52                   	push   %edx
  8007bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c0:	50                   	push   %eax
  8007c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 00 fb ff ff       	call   8002d2 <printnum>
  8007d2:	83 c4 20             	add    $0x20,%esp
			break;
  8007d5:	eb 46                	jmp    80081d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	53                   	push   %ebx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
			break;
  8007e6:	eb 35                	jmp    80081d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007e8:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8007ef:	eb 2c                	jmp    80081d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007f1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8007f8:	eb 23                	jmp    80081d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 25                	push   $0x25
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	ff d0                	call   *%eax
  800807:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080a:	ff 4d 10             	decl   0x10(%ebp)
  80080d:	eb 03                	jmp    800812 <vprintfmt+0x3c3>
  80080f:	ff 4d 10             	decl   0x10(%ebp)
  800812:	8b 45 10             	mov    0x10(%ebp),%eax
  800815:	48                   	dec    %eax
  800816:	8a 00                	mov    (%eax),%al
  800818:	3c 25                	cmp    $0x25,%al
  80081a:	75 f3                	jne    80080f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80081c:	90                   	nop
		}
	}
  80081d:	e9 35 fc ff ff       	jmp    800457 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800822:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800823:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800826:	5b                   	pop    %ebx
  800827:	5e                   	pop    %esi
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800830:	8d 45 10             	lea    0x10(%ebp),%eax
  800833:	83 c0 04             	add    $0x4,%eax
  800836:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800839:	8b 45 10             	mov    0x10(%ebp),%eax
  80083c:	ff 75 f4             	pushl  -0xc(%ebp)
  80083f:	50                   	push   %eax
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	ff 75 08             	pushl  0x8(%ebp)
  800846:	e8 04 fc ff ff       	call   80044f <vprintfmt>
  80084b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80084e:	90                   	nop
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800854:	8b 45 0c             	mov    0xc(%ebp),%eax
  800857:	8b 40 08             	mov    0x8(%eax),%eax
  80085a:	8d 50 01             	lea    0x1(%eax),%edx
  80085d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800860:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
  800866:	8b 10                	mov    (%eax),%edx
  800868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086b:	8b 40 04             	mov    0x4(%eax),%eax
  80086e:	39 c2                	cmp    %eax,%edx
  800870:	73 12                	jae    800884 <sprintputch+0x33>
		*b->buf++ = ch;
  800872:	8b 45 0c             	mov    0xc(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	8d 48 01             	lea    0x1(%eax),%ecx
  80087a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087d:	89 0a                	mov    %ecx,(%edx)
  80087f:	8b 55 08             	mov    0x8(%ebp),%edx
  800882:	88 10                	mov    %dl,(%eax)
}
  800884:	90                   	nop
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800893:	8b 45 0c             	mov    0xc(%ebp),%eax
  800896:	8d 50 ff             	lea    -0x1(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	01 d0                	add    %edx,%eax
  80089e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ac:	74 06                	je     8008b4 <vsnprintf+0x2d>
  8008ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b2:	7f 07                	jg     8008bb <vsnprintf+0x34>
		return -E_INVAL;
  8008b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8008b9:	eb 20                	jmp    8008db <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bb:	ff 75 14             	pushl  0x14(%ebp)
  8008be:	ff 75 10             	pushl  0x10(%ebp)
  8008c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c4:	50                   	push   %eax
  8008c5:	68 51 08 80 00       	push   $0x800851
  8008ca:	e8 80 fb ff ff       	call   80044f <vprintfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f2:	50                   	push   %eax
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 89 ff ff ff       	call   800887 <vsnprintf>
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80090f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800916:	eb 06                	jmp    80091e <strlen+0x15>
		n++;
  800918:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80091b:	ff 45 08             	incl   0x8(%ebp)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8a 00                	mov    (%eax),%al
  800923:	84 c0                	test   %al,%al
  800925:	75 f1                	jne    800918 <strlen+0xf>
		n++;
	return n;
  800927:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800932:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800939:	eb 09                	jmp    800944 <strnlen+0x18>
		n++;
  80093b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093e:	ff 45 08             	incl   0x8(%ebp)
  800941:	ff 4d 0c             	decl   0xc(%ebp)
  800944:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800948:	74 09                	je     800953 <strnlen+0x27>
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	84 c0                	test   %al,%al
  800951:	75 e8                	jne    80093b <strnlen+0xf>
		n++;
	return n;
  800953:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800964:	90                   	nop
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8d 50 01             	lea    0x1(%eax),%edx
  80096b:	89 55 08             	mov    %edx,0x8(%ebp)
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	8d 4a 01             	lea    0x1(%edx),%ecx
  800974:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800977:	8a 12                	mov    (%edx),%dl
  800979:	88 10                	mov    %dl,(%eax)
  80097b:	8a 00                	mov    (%eax),%al
  80097d:	84 c0                	test   %al,%al
  80097f:	75 e4                	jne    800965 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800981:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800992:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800999:	eb 1f                	jmp    8009ba <strncpy+0x34>
		*dst++ = *src;
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8d 50 01             	lea    0x1(%eax),%edx
  8009a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8a 12                	mov    (%edx),%dl
  8009a9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 03                	je     8009b7 <strncpy+0x31>
			src++;
  8009b4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b7:	ff 45 fc             	incl   -0x4(%ebp)
  8009ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009c0:	72 d9                	jb     80099b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d7:	74 30                	je     800a09 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009d9:	eb 16                	jmp    8009f1 <strlcpy+0x2a>
			*dst++ = *src++;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8d 50 01             	lea    0x1(%eax),%edx
  8009e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009ed:	8a 12                	mov    (%edx),%dl
  8009ef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f1:	ff 4d 10             	decl   0x10(%ebp)
  8009f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f8:	74 09                	je     800a03 <strlcpy+0x3c>
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	84 c0                	test   %al,%al
  800a01:	75 d8                	jne    8009db <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a09:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a0f:	29 c2                	sub    %eax,%edx
  800a11:	89 d0                	mov    %edx,%eax
}
  800a13:	c9                   	leave  
  800a14:	c3                   	ret    

00800a15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a18:	eb 06                	jmp    800a20 <strcmp+0xb>
		p++, q++;
  800a1a:	ff 45 08             	incl   0x8(%ebp)
  800a1d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8a 00                	mov    (%eax),%al
  800a25:	84 c0                	test   %al,%al
  800a27:	74 0e                	je     800a37 <strcmp+0x22>
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8a 10                	mov    (%eax),%dl
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	38 c2                	cmp    %al,%dl
  800a35:	74 e3                	je     800a1a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8a 00                	mov    (%eax),%al
  800a3c:	0f b6 d0             	movzbl %al,%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	0f b6 c0             	movzbl %al,%eax
  800a47:	29 c2                	sub    %eax,%edx
  800a49:	89 d0                	mov    %edx,%eax
}
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a50:	eb 09                	jmp    800a5b <strncmp+0xe>
		n--, p++, q++;
  800a52:	ff 4d 10             	decl   0x10(%ebp)
  800a55:	ff 45 08             	incl   0x8(%ebp)
  800a58:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5f:	74 17                	je     800a78 <strncmp+0x2b>
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	84 c0                	test   %al,%al
  800a68:	74 0e                	je     800a78 <strncmp+0x2b>
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8a 10                	mov    (%eax),%dl
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	38 c2                	cmp    %al,%dl
  800a76:	74 da                	je     800a52 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a7c:	75 07                	jne    800a85 <strncmp+0x38>
		return 0;
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	eb 14                	jmp    800a99 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	8a 00                	mov    (%eax),%al
  800a8a:	0f b6 d0             	movzbl %al,%edx
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	8a 00                	mov    (%eax),%al
  800a92:	0f b6 c0             	movzbl %al,%eax
  800a95:	29 c2                	sub    %eax,%edx
  800a97:	89 d0                	mov    %edx,%eax
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 04             	sub    $0x4,%esp
  800aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aa7:	eb 12                	jmp    800abb <strchr+0x20>
		if (*s == c)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab1:	75 05                	jne    800ab8 <strchr+0x1d>
			return (char *) s;
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	eb 11                	jmp    800ac9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab8:	ff 45 08             	incl   0x8(%ebp)
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 e5                	jne    800aa9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    

00800acb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	83 ec 04             	sub    $0x4,%esp
  800ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad7:	eb 0d                	jmp    800ae6 <strfind+0x1b>
		if (*s == c)
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae1:	74 0e                	je     800af1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ae3:	ff 45 08             	incl   0x8(%ebp)
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	84 c0                	test   %al,%al
  800aed:	75 ea                	jne    800ad9 <strfind+0xe>
  800aef:	eb 01                	jmp    800af2 <strfind+0x27>
		if (*s == c)
			break;
  800af1:	90                   	nop
	return (char *) s;
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b03:	8b 45 10             	mov    0x10(%ebp),%eax
  800b06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b09:	eb 0e                	jmp    800b19 <memset+0x22>
		*p++ = c;
  800b0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b0e:	8d 50 01             	lea    0x1(%eax),%edx
  800b11:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b19:	ff 4d f8             	decl   -0x8(%ebp)
  800b1c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b20:	79 e9                	jns    800b0b <memset+0x14>
		*p++ = c;

	return v;
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b39:	eb 16                	jmp    800b51 <memcpy+0x2a>
		*d++ = *s++;
  800b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b4d:	8a 12                	mov    (%edx),%dl
  800b4f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b51:	8b 45 10             	mov    0x10(%ebp),%eax
  800b54:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b57:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	75 dd                	jne    800b3b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b78:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7b:	73 50                	jae    800bcd <memmove+0x6a>
  800b7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b88:	76 43                	jbe    800bcd <memmove+0x6a>
		s += n;
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b96:	eb 10                	jmp    800ba8 <memmove+0x45>
			*--d = *--s;
  800b98:	ff 4d f8             	decl   -0x8(%ebp)
  800b9b:	ff 4d fc             	decl   -0x4(%ebp)
  800b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba1:	8a 10                	mov    (%eax),%dl
  800ba3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bae:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	75 e3                	jne    800b98 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb5:	eb 23                	jmp    800bda <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bba:	8d 50 01             	lea    0x1(%eax),%edx
  800bbd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bc9:	8a 12                	mov    (%edx),%dl
  800bcb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	85 c0                	test   %eax,%eax
  800bd8:	75 dd                	jne    800bb7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bf1:	eb 2a                	jmp    800c1d <memcmp+0x3e>
		if (*s1 != *s2)
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf6:	8a 10                	mov    (%eax),%dl
  800bf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bfb:	8a 00                	mov    (%eax),%al
  800bfd:	38 c2                	cmp    %al,%dl
  800bff:	74 16                	je     800c17 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	0f b6 d0             	movzbl %al,%edx
  800c09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	0f b6 c0             	movzbl %al,%eax
  800c11:	29 c2                	sub    %eax,%edx
  800c13:	89 d0                	mov    %edx,%eax
  800c15:	eb 18                	jmp    800c2f <memcmp+0x50>
		s1++, s2++;
  800c17:	ff 45 fc             	incl   -0x4(%ebp)
  800c1a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c23:	89 55 10             	mov    %edx,0x10(%ebp)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	75 c9                	jne    800bf3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c37:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3d:	01 d0                	add    %edx,%eax
  800c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c42:	eb 15                	jmp    800c59 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	0f b6 d0             	movzbl %al,%edx
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	0f b6 c0             	movzbl %al,%eax
  800c52:	39 c2                	cmp    %eax,%edx
  800c54:	74 0d                	je     800c63 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c56:	ff 45 08             	incl   0x8(%ebp)
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c5f:	72 e3                	jb     800c44 <memfind+0x13>
  800c61:	eb 01                	jmp    800c64 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c63:	90                   	nop
	return (void *) s;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c76:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7d:	eb 03                	jmp    800c82 <strtol+0x19>
		s++;
  800c7f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	3c 20                	cmp    $0x20,%al
  800c89:	74 f4                	je     800c7f <strtol+0x16>
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	3c 09                	cmp    $0x9,%al
  800c92:	74 eb                	je     800c7f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	3c 2b                	cmp    $0x2b,%al
  800c9b:	75 05                	jne    800ca2 <strtol+0x39>
		s++;
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	eb 13                	jmp    800cb5 <strtol+0x4c>
	else if (*s == '-')
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	3c 2d                	cmp    $0x2d,%al
  800ca9:	75 0a                	jne    800cb5 <strtol+0x4c>
		s++, neg = 1;
  800cab:	ff 45 08             	incl   0x8(%ebp)
  800cae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb9:	74 06                	je     800cc1 <strtol+0x58>
  800cbb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cbf:	75 20                	jne    800ce1 <strtol+0x78>
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	3c 30                	cmp    $0x30,%al
  800cc8:	75 17                	jne    800ce1 <strtol+0x78>
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	40                   	inc    %eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	3c 78                	cmp    $0x78,%al
  800cd2:	75 0d                	jne    800ce1 <strtol+0x78>
		s += 2, base = 16;
  800cd4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cd8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cdf:	eb 28                	jmp    800d09 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ce1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce5:	75 15                	jne    800cfc <strtol+0x93>
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 30                	cmp    $0x30,%al
  800cee:	75 0c                	jne    800cfc <strtol+0x93>
		s++, base = 8;
  800cf0:	ff 45 08             	incl   0x8(%ebp)
  800cf3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cfa:	eb 0d                	jmp    800d09 <strtol+0xa0>
	else if (base == 0)
  800cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d00:	75 07                	jne    800d09 <strtol+0xa0>
		base = 10;
  800d02:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 2f                	cmp    $0x2f,%al
  800d10:	7e 19                	jle    800d2b <strtol+0xc2>
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 39                	cmp    $0x39,%al
  800d19:	7f 10                	jg     800d2b <strtol+0xc2>
			dig = *s - '0';
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	0f be c0             	movsbl %al,%eax
  800d23:	83 e8 30             	sub    $0x30,%eax
  800d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d29:	eb 42                	jmp    800d6d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	3c 60                	cmp    $0x60,%al
  800d32:	7e 19                	jle    800d4d <strtol+0xe4>
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3c 7a                	cmp    $0x7a,%al
  800d3b:	7f 10                	jg     800d4d <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f be c0             	movsbl %al,%eax
  800d45:	83 e8 57             	sub    $0x57,%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d4b:	eb 20                	jmp    800d6d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3c 40                	cmp    $0x40,%al
  800d54:	7e 39                	jle    800d8f <strtol+0x126>
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 5a                	cmp    $0x5a,%al
  800d5d:	7f 30                	jg     800d8f <strtol+0x126>
			dig = *s - 'A' + 10;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	0f be c0             	movsbl %al,%eax
  800d67:	83 e8 37             	sub    $0x37,%eax
  800d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d70:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d73:	7d 19                	jge    800d8e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d7f:	89 c2                	mov    %eax,%edx
  800d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d89:	e9 7b ff ff ff       	jmp    800d09 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d8e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 08                	je     800d9d <strtol+0x134>
		*endptr = (char *) s;
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da1:	74 07                	je     800daa <strtol+0x141>
  800da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da6:	f7 d8                	neg    %eax
  800da8:	eb 03                	jmp    800dad <strtol+0x144>
  800daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <ltostr>:

void
ltostr(long value, char *str)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800db5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc7:	79 13                	jns    800ddc <ltostr+0x2d>
	{
		neg = 1;
  800dc9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dd6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dd9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de4:	99                   	cltd   
  800de5:	f7 f9                	idiv   %ecx
  800de7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	89 c2                	mov    %eax,%edx
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	01 d0                	add    %edx,%eax
  800dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dfd:	83 c2 30             	add    $0x30,%edx
  800e00:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e05:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0a:	f7 e9                	imul   %ecx
  800e0c:	c1 fa 02             	sar    $0x2,%edx
  800e0f:	89 c8                	mov    %ecx,%eax
  800e11:	c1 f8 1f             	sar    $0x1f,%eax
  800e14:	29 c2                	sub    %eax,%edx
  800e16:	89 d0                	mov    %edx,%eax
  800e18:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e1f:	75 bb                	jne    800ddc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2b:	48                   	dec    %eax
  800e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e33:	74 3d                	je     800e72 <ltostr+0xc3>
		start = 1 ;
  800e35:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e3c:	eb 34                	jmp    800e72 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	01 d0                	add    %edx,%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	01 c2                	add    %eax,%edx
  800e53:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	01 c8                	add    %ecx,%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	01 c2                	add    %eax,%edx
  800e67:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e6a:	88 02                	mov    %al,(%edx)
		start++ ;
  800e6c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e6f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e78:	7c c4                	jl     800e3e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e7a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e80:	01 d0                	add    %edx,%eax
  800e82:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e85:	90                   	nop
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 73 fa ff ff       	call   800909 <strlen>
  800e96:	83 c4 04             	add    $0x4,%esp
  800e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e9c:	ff 75 0c             	pushl  0xc(%ebp)
  800e9f:	e8 65 fa ff ff       	call   800909 <strlen>
  800ea4:	83 c4 04             	add    $0x4,%esp
  800ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 17                	jmp    800ed1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	01 c2                	add    %eax,%edx
  800ec2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	01 c8                	add    %ecx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ece:	ff 45 fc             	incl   -0x4(%ebp)
  800ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ed7:	7c e1                	jl     800eba <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ee0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ee7:	eb 1f                	jmp    800f08 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eec:	8d 50 01             	lea    0x1(%eax),%edx
  800eef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef2:	89 c2                	mov    %eax,%edx
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	01 c2                	add    %eax,%edx
  800ef9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	01 c8                	add    %ecx,%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f05:	ff 45 f8             	incl   -0x8(%ebp)
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f0e:	7c d9                	jl     800ee9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f13:	8b 45 10             	mov    0x10(%ebp),%eax
  800f16:	01 d0                	add    %edx,%eax
  800f18:	c6 00 00             	movb   $0x0,(%eax)
}
  800f1b:	90                   	nop
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f21:	8b 45 14             	mov    0x14(%ebp),%eax
  800f24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2d:	8b 00                	mov    (%eax),%eax
  800f2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f36:	8b 45 10             	mov    0x10(%ebp),%eax
  800f39:	01 d0                	add    %edx,%eax
  800f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f41:	eb 0c                	jmp    800f4f <strsplit+0x31>
			*string++ = 0;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8d 50 01             	lea    0x1(%eax),%edx
  800f49:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	84 c0                	test   %al,%al
  800f56:	74 18                	je     800f70 <strsplit+0x52>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f be c0             	movsbl %al,%eax
  800f60:	50                   	push   %eax
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	e8 32 fb ff ff       	call   800a9b <strchr>
  800f69:	83 c4 08             	add    $0x8,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	75 d3                	jne    800f43 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	84 c0                	test   %al,%al
  800f77:	74 5a                	je     800fd3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8b 00                	mov    (%eax),%eax
  800f7e:	83 f8 0f             	cmp    $0xf,%eax
  800f81:	75 07                	jne    800f8a <strsplit+0x6c>
		{
			return 0;
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	eb 66                	jmp    800ff0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8d:	8b 00                	mov    (%eax),%eax
  800f8f:	8d 48 01             	lea    0x1(%eax),%ecx
  800f92:	8b 55 14             	mov    0x14(%ebp),%edx
  800f95:	89 0a                	mov    %ecx,(%edx)
  800f97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 c2                	add    %eax,%edx
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa8:	eb 03                	jmp    800fad <strsplit+0x8f>
			string++;
  800faa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	84 c0                	test   %al,%al
  800fb4:	74 8b                	je     800f41 <strsplit+0x23>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f be c0             	movsbl %al,%eax
  800fbe:	50                   	push   %eax
  800fbf:	ff 75 0c             	pushl  0xc(%ebp)
  800fc2:	e8 d4 fa ff ff       	call   800a9b <strchr>
  800fc7:	83 c4 08             	add    $0x8,%esp
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	74 dc                	je     800faa <strsplit+0x8c>
			string++;
	}
  800fce:	e9 6e ff ff ff       	jmp    800f41 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fd3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800feb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800ff8:	83 ec 04             	sub    $0x4,%esp
  800ffb:	68 48 1f 80 00       	push   $0x801f48
  801000:	68 3f 01 00 00       	push   $0x13f
  801005:	68 6a 1f 80 00       	push   $0x801f6a
  80100a:	e8 2d 06 00 00       	call   80163c <_panic>

0080100f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
  801015:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801021:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801024:	8b 7d 18             	mov    0x18(%ebp),%edi
  801027:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80102a:	cd 30                	int    $0x30
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80102f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 04             	sub    $0x4,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801046:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	6a 00                	push   $0x0
  80104f:	6a 00                	push   $0x0
  801051:	52                   	push   %edx
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	50                   	push   %eax
  801056:	6a 00                	push   $0x0
  801058:	e8 b2 ff ff ff       	call   80100f <syscall>
  80105d:	83 c4 18             	add    $0x18,%esp
}
  801060:	90                   	nop
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <sys_cgetc>:

int
sys_cgetc(void)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801066:	6a 00                	push   $0x0
  801068:	6a 00                	push   $0x0
  80106a:	6a 00                	push   $0x0
  80106c:	6a 00                	push   $0x0
  80106e:	6a 00                	push   $0x0
  801070:	6a 02                	push   $0x2
  801072:	e8 98 ff ff ff       	call   80100f <syscall>
  801077:	83 c4 18             	add    $0x18,%esp
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80107f:	6a 00                	push   $0x0
  801081:	6a 00                	push   $0x0
  801083:	6a 00                	push   $0x0
  801085:	6a 00                	push   $0x0
  801087:	6a 00                	push   $0x0
  801089:	6a 03                	push   $0x3
  80108b:	e8 7f ff ff ff       	call   80100f <syscall>
  801090:	83 c4 18             	add    $0x18,%esp
}
  801093:	90                   	nop
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801099:	6a 00                	push   $0x0
  80109b:	6a 00                	push   $0x0
  80109d:	6a 00                	push   $0x0
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 00                	push   $0x0
  8010a3:	6a 04                	push   $0x4
  8010a5:	e8 65 ff ff ff       	call   80100f <syscall>
  8010aa:	83 c4 18             	add    $0x18,%esp
}
  8010ad:	90                   	nop
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	52                   	push   %edx
  8010c0:	50                   	push   %eax
  8010c1:	6a 08                	push   $0x8
  8010c3:	e8 47 ff ff ff       	call   80100f <syscall>
  8010c8:	83 c4 18             	add    $0x18,%esp
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	51                   	push   %ecx
  8010e4:	52                   	push   %edx
  8010e5:	50                   	push   %eax
  8010e6:	6a 09                	push   $0x9
  8010e8:	e8 22 ff ff ff       	call   80100f <syscall>
  8010ed:	83 c4 18             	add    $0x18,%esp
}
  8010f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	52                   	push   %edx
  801107:	50                   	push   %eax
  801108:	6a 0a                	push   $0xa
  80110a:	e8 00 ff ff ff       	call   80100f <syscall>
  80110f:	83 c4 18             	add    $0x18,%esp
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	ff 75 08             	pushl  0x8(%ebp)
  801123:	6a 0b                	push   $0xb
  801125:	e8 e5 fe ff ff       	call   80100f <syscall>
  80112a:	83 c4 18             	add    $0x18,%esp
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801132:	6a 00                	push   $0x0
  801134:	6a 00                	push   $0x0
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 0c                	push   $0xc
  80113e:	e8 cc fe ff ff       	call   80100f <syscall>
  801143:	83 c4 18             	add    $0x18,%esp
}
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 0d                	push   $0xd
  801157:	e8 b3 fe ff ff       	call   80100f <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 0e                	push   $0xe
  801170:	e8 9a fe ff ff       	call   80100f <syscall>
  801175:	83 c4 18             	add    $0x18,%esp
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 0f                	push   $0xf
  801189:	e8 81 fe ff ff       	call   80100f <syscall>
  80118e:	83 c4 18             	add    $0x18,%esp
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	ff 75 08             	pushl  0x8(%ebp)
  8011a1:	6a 10                	push   $0x10
  8011a3:	e8 67 fe ff ff       	call   80100f <syscall>
  8011a8:	83 c4 18             	add    $0x18,%esp
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 11                	push   $0x11
  8011bc:	e8 4e fe ff ff       	call   80100f <syscall>
  8011c1:	83 c4 18             	add    $0x18,%esp
}
  8011c4:	90                   	nop
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	50                   	push   %eax
  8011e0:	6a 01                	push   $0x1
  8011e2:	e8 28 fe ff ff       	call   80100f <syscall>
  8011e7:	83 c4 18             	add    $0x18,%esp
}
  8011ea:	90                   	nop
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 14                	push   $0x14
  8011fc:	e8 0e fe ff ff       	call   80100f <syscall>
  801201:	83 c4 18             	add    $0x18,%esp
}
  801204:	90                   	nop
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	8b 45 10             	mov    0x10(%ebp),%eax
  801210:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801213:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801216:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	6a 00                	push   $0x0
  80121f:	51                   	push   %ecx
  801220:	52                   	push   %edx
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	50                   	push   %eax
  801225:	6a 15                	push   $0x15
  801227:	e8 e3 fd ff ff       	call   80100f <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	52                   	push   %edx
  801241:	50                   	push   %eax
  801242:	6a 16                	push   $0x16
  801244:	e8 c6 fd ff ff       	call   80100f <syscall>
  801249:	83 c4 18             	add    $0x18,%esp
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801251:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801254:	8b 55 0c             	mov    0xc(%ebp),%edx
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	51                   	push   %ecx
  80125f:	52                   	push   %edx
  801260:	50                   	push   %eax
  801261:	6a 17                	push   $0x17
  801263:	e8 a7 fd ff ff       	call   80100f <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801270:	8b 55 0c             	mov    0xc(%ebp),%edx
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	52                   	push   %edx
  80127d:	50                   	push   %eax
  80127e:	6a 18                	push   $0x18
  801280:	e8 8a fd ff ff       	call   80100f <syscall>
  801285:	83 c4 18             	add    $0x18,%esp
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	6a 00                	push   $0x0
  801292:	ff 75 14             	pushl  0x14(%ebp)
  801295:	ff 75 10             	pushl  0x10(%ebp)
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	6a 19                	push   $0x19
  80129e:	e8 6c fd ff ff       	call   80100f <syscall>
  8012a3:	83 c4 18             	add    $0x18,%esp
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	50                   	push   %eax
  8012b7:	6a 1a                	push   $0x1a
  8012b9:	e8 51 fd ff ff       	call   80100f <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	90                   	nop
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	50                   	push   %eax
  8012d3:	6a 1b                	push   $0x1b
  8012d5:	e8 35 fd ff ff       	call   80100f <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 05                	push   $0x5
  8012ee:	e8 1c fd ff ff       	call   80100f <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 06                	push   $0x6
  801307:	e8 03 fd ff ff       	call   80100f <syscall>
  80130c:	83 c4 18             	add    $0x18,%esp
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 07                	push   $0x7
  801320:	e8 ea fc ff ff       	call   80100f <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_exit_env>:


void sys_exit_env(void)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 1c                	push   $0x1c
  801339:	e8 d1 fc ff ff       	call   80100f <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	90                   	nop
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80134a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80134d:	8d 50 04             	lea    0x4(%eax),%edx
  801350:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 1d                	push   $0x1d
  80135d:	e8 ad fc ff ff       	call   80100f <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
	return result;
  801365:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801368:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136e:	89 01                	mov    %eax,(%ecx)
  801370:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	c9                   	leave  
  801377:	c2 04 00             	ret    $0x4

0080137a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	ff 75 10             	pushl  0x10(%ebp)
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	6a 13                	push   $0x13
  80138c:	e8 7e fc ff ff       	call   80100f <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
	return ;
  801394:	90                   	nop
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_rcr2>:
uint32 sys_rcr2()
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 1e                	push   $0x1e
  8013a6:	e8 64 fc ff ff       	call   80100f <syscall>
  8013ab:	83 c4 18             	add    $0x18,%esp
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013bc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	50                   	push   %eax
  8013c9:	6a 1f                	push   $0x1f
  8013cb:	e8 3f fc ff ff       	call   80100f <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d3:	90                   	nop
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <rsttst>:
void rsttst()
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 21                	push   $0x21
  8013e5:	e8 25 fc ff ff       	call   80100f <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ed:	90                   	nop
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013fc:	8b 55 18             	mov    0x18(%ebp),%edx
  8013ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801403:	52                   	push   %edx
  801404:	50                   	push   %eax
  801405:	ff 75 10             	pushl  0x10(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	ff 75 08             	pushl  0x8(%ebp)
  80140e:	6a 20                	push   $0x20
  801410:	e8 fa fb ff ff       	call   80100f <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
	return ;
  801418:	90                   	nop
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <chktst>:
void chktst(uint32 n)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	6a 22                	push   $0x22
  80142b:	e8 df fb ff ff       	call   80100f <syscall>
  801430:	83 c4 18             	add    $0x18,%esp
	return ;
  801433:	90                   	nop
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <inctst>:

void inctst()
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 23                	push   $0x23
  801445:	e8 c5 fb ff ff       	call   80100f <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
	return ;
  80144d:	90                   	nop
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <gettst>:
uint32 gettst()
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 24                	push   $0x24
  80145f:	e8 ab fb ff ff       	call   80100f <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 25                	push   $0x25
  80147b:	e8 8f fb ff ff       	call   80100f <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
  801483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801486:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80148a:	75 07                	jne    801493 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80148c:	b8 01 00 00 00       	mov    $0x1,%eax
  801491:	eb 05                	jmp    801498 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 25                	push   $0x25
  8014ac:	e8 5e fb ff ff       	call   80100f <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
  8014b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014b7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014bb:	75 07                	jne    8014c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c2:	eb 05                	jmp    8014c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 25                	push   $0x25
  8014dd:	e8 2d fb ff ff       	call   80100f <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
  8014e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014e8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014ec:	75 07                	jne    8014f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f3:	eb 05                	jmp    8014fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 25                	push   $0x25
  80150e:	e8 fc fa ff ff       	call   80100f <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
  801516:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801519:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80151d:	75 07                	jne    801526 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80151f:	b8 01 00 00 00       	mov    $0x1,%eax
  801524:	eb 05                	jmp    80152b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	6a 26                	push   $0x26
  80153d:	e8 cd fa ff ff       	call   80100f <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
	return ;
  801545:	90                   	nop
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80154c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801552:	8b 55 0c             	mov    0xc(%ebp),%edx
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	6a 00                	push   $0x0
  80155a:	53                   	push   %ebx
  80155b:	51                   	push   %ecx
  80155c:	52                   	push   %edx
  80155d:	50                   	push   %eax
  80155e:	6a 27                	push   $0x27
  801560:	e8 aa fa ff ff       	call   80100f <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	52                   	push   %edx
  80157d:	50                   	push   %eax
  80157e:	6a 28                	push   $0x28
  801580:	e8 8a fa ff ff       	call   80100f <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80158d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	51                   	push   %ecx
  801599:	ff 75 10             	pushl  0x10(%ebp)
  80159c:	52                   	push   %edx
  80159d:	50                   	push   %eax
  80159e:	6a 29                	push   $0x29
  8015a0:	e8 6a fa ff ff       	call   80100f <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	ff 75 10             	pushl  0x10(%ebp)
  8015b4:	ff 75 0c             	pushl  0xc(%ebp)
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	6a 12                	push   $0x12
  8015bc:	e8 4e fa ff ff       	call   80100f <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c4:	90                   	nop
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8015ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	52                   	push   %edx
  8015d7:	50                   	push   %eax
  8015d8:	6a 2a                	push   $0x2a
  8015da:	e8 30 fa ff ff       	call   80100f <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
	return;
  8015e2:	90                   	nop
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 77 1f 80 00       	push   $0x801f77
  8015f3:	68 2e 01 00 00       	push   $0x12e
  8015f8:	68 8b 1f 80 00       	push   $0x801f8b
  8015fd:	e8 3a 00 00 00       	call   80163c <_panic>

00801602 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	68 77 1f 80 00       	push   $0x801f77
  801610:	68 35 01 00 00       	push   $0x135
  801615:	68 8b 1f 80 00       	push   $0x801f8b
  80161a:	e8 1d 00 00 00       	call   80163c <_panic>

0080161f <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 77 1f 80 00       	push   $0x801f77
  80162d:	68 3b 01 00 00       	push   $0x13b
  801632:	68 8b 1f 80 00       	push   $0x801f8b
  801637:	e8 00 00 00 00       	call   80163c <_panic>

0080163c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801642:	8d 45 10             	lea    0x10(%ebp),%eax
  801645:	83 c0 04             	add    $0x4,%eax
  801648:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80164b:	a1 24 30 80 00       	mov    0x803024,%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	74 16                	je     80166a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801654:	a1 24 30 80 00       	mov    0x803024,%eax
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	50                   	push   %eax
  80165d:	68 9c 1f 80 00       	push   $0x801f9c
  801662:	e8 0e ec ff ff       	call   800275 <cprintf>
  801667:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80166a:	a1 00 30 80 00       	mov    0x803000,%eax
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	50                   	push   %eax
  801676:	68 a1 1f 80 00       	push   $0x801fa1
  80167b:	e8 f5 eb ff ff       	call   800275 <cprintf>
  801680:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801683:	8b 45 10             	mov    0x10(%ebp),%eax
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	ff 75 f4             	pushl  -0xc(%ebp)
  80168c:	50                   	push   %eax
  80168d:	e8 78 eb ff ff       	call   80020a <vcprintf>
  801692:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	6a 00                	push   $0x0
  80169a:	68 bd 1f 80 00       	push   $0x801fbd
  80169f:	e8 66 eb ff ff       	call   80020a <vcprintf>
  8016a4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8016a7:	e8 e7 ea ff ff       	call   800193 <exit>

	// should not return here
	while (1) ;
  8016ac:	eb fe                	jmp    8016ac <_panic+0x70>

008016ae <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8016b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8016b9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	39 c2                	cmp    %eax,%edx
  8016c4:	74 14                	je     8016da <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	68 c0 1f 80 00       	push   $0x801fc0
  8016ce:	6a 26                	push   $0x26
  8016d0:	68 0c 20 80 00       	push   $0x80200c
  8016d5:	e8 62 ff ff ff       	call   80163c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8016da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8016e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016e8:	e9 c5 00 00 00       	jmp    8017b2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	8b 00                	mov    (%eax),%eax
  8016fe:	85 c0                	test   %eax,%eax
  801700:	75 08                	jne    80170a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801702:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801705:	e9 a5 00 00 00       	jmp    8017af <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80170a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801711:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801718:	eb 69                	jmp    801783 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80171a:	a1 04 30 80 00       	mov    0x803004,%eax
  80171f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801725:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	01 c0                	add    %eax,%eax
  80172c:	01 d0                	add    %edx,%eax
  80172e:	c1 e0 03             	shl    $0x3,%eax
  801731:	01 c8                	add    %ecx,%eax
  801733:	8a 40 04             	mov    0x4(%eax),%al
  801736:	84 c0                	test   %al,%al
  801738:	75 46                	jne    801780 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80173a:	a1 04 30 80 00       	mov    0x803004,%eax
  80173f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801745:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801748:	89 d0                	mov    %edx,%eax
  80174a:	01 c0                	add    %eax,%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	c1 e0 03             	shl    $0x3,%eax
  801751:	01 c8                	add    %ecx,%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801758:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80175b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801760:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	01 c8                	add    %ecx,%eax
  801771:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801773:	39 c2                	cmp    %eax,%edx
  801775:	75 09                	jne    801780 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801777:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80177e:	eb 15                	jmp    801795 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801780:	ff 45 e8             	incl   -0x18(%ebp)
  801783:	a1 04 30 80 00       	mov    0x803004,%eax
  801788:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80178e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801791:	39 c2                	cmp    %eax,%edx
  801793:	77 85                	ja     80171a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801795:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801799:	75 14                	jne    8017af <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 18 20 80 00       	push   $0x802018
  8017a3:	6a 3a                	push   $0x3a
  8017a5:	68 0c 20 80 00       	push   $0x80200c
  8017aa:	e8 8d fe ff ff       	call   80163c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8017af:	ff 45 f0             	incl   -0x10(%ebp)
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8017b8:	0f 8c 2f ff ff ff    	jl     8016ed <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8017be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017cc:	eb 26                	jmp    8017f4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8017ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8017d3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017dc:	89 d0                	mov    %edx,%eax
  8017de:	01 c0                	add    %eax,%eax
  8017e0:	01 d0                	add    %edx,%eax
  8017e2:	c1 e0 03             	shl    $0x3,%eax
  8017e5:	01 c8                	add    %ecx,%eax
  8017e7:	8a 40 04             	mov    0x4(%eax),%al
  8017ea:	3c 01                	cmp    $0x1,%al
  8017ec:	75 03                	jne    8017f1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8017ee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017f1:	ff 45 e0             	incl   -0x20(%ebp)
  8017f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801802:	39 c2                	cmp    %eax,%edx
  801804:	77 c8                	ja     8017ce <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801809:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80180c:	74 14                	je     801822 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 6c 20 80 00       	push   $0x80206c
  801816:	6a 44                	push   $0x44
  801818:	68 0c 20 80 00       	push   $0x80200c
  80181d:	e8 1a fe ff ff       	call   80163c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801822:	90                   	nop
  801823:	c9                   	leave  
  801824:	c3                   	ret    
  801825:	66 90                	xchg   %ax,%ax
  801827:	90                   	nop

00801828 <__udivdi3>:
  801828:	55                   	push   %ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 1c             	sub    $0x1c,%esp
  80182f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801833:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801837:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80183b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183f:	89 ca                	mov    %ecx,%edx
  801841:	89 f8                	mov    %edi,%eax
  801843:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801847:	85 f6                	test   %esi,%esi
  801849:	75 2d                	jne    801878 <__udivdi3+0x50>
  80184b:	39 cf                	cmp    %ecx,%edi
  80184d:	77 65                	ja     8018b4 <__udivdi3+0x8c>
  80184f:	89 fd                	mov    %edi,%ebp
  801851:	85 ff                	test   %edi,%edi
  801853:	75 0b                	jne    801860 <__udivdi3+0x38>
  801855:	b8 01 00 00 00       	mov    $0x1,%eax
  80185a:	31 d2                	xor    %edx,%edx
  80185c:	f7 f7                	div    %edi
  80185e:	89 c5                	mov    %eax,%ebp
  801860:	31 d2                	xor    %edx,%edx
  801862:	89 c8                	mov    %ecx,%eax
  801864:	f7 f5                	div    %ebp
  801866:	89 c1                	mov    %eax,%ecx
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	f7 f5                	div    %ebp
  80186c:	89 cf                	mov    %ecx,%edi
  80186e:	89 fa                	mov    %edi,%edx
  801870:	83 c4 1c             	add    $0x1c,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    
  801878:	39 ce                	cmp    %ecx,%esi
  80187a:	77 28                	ja     8018a4 <__udivdi3+0x7c>
  80187c:	0f bd fe             	bsr    %esi,%edi
  80187f:	83 f7 1f             	xor    $0x1f,%edi
  801882:	75 40                	jne    8018c4 <__udivdi3+0x9c>
  801884:	39 ce                	cmp    %ecx,%esi
  801886:	72 0a                	jb     801892 <__udivdi3+0x6a>
  801888:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80188c:	0f 87 9e 00 00 00    	ja     801930 <__udivdi3+0x108>
  801892:	b8 01 00 00 00       	mov    $0x1,%eax
  801897:	89 fa                	mov    %edi,%edx
  801899:	83 c4 1c             	add    $0x1c,%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5f                   	pop    %edi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    
  8018a1:	8d 76 00             	lea    0x0(%esi),%esi
  8018a4:	31 ff                	xor    %edi,%edi
  8018a6:	31 c0                	xor    %eax,%eax
  8018a8:	89 fa                	mov    %edi,%edx
  8018aa:	83 c4 1c             	add    $0x1c,%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    
  8018b2:	66 90                	xchg   %ax,%ax
  8018b4:	89 d8                	mov    %ebx,%eax
  8018b6:	f7 f7                	div    %edi
  8018b8:	31 ff                	xor    %edi,%edi
  8018ba:	89 fa                	mov    %edi,%edx
  8018bc:	83 c4 1c             	add    $0x1c,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    
  8018c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8018c9:	89 eb                	mov    %ebp,%ebx
  8018cb:	29 fb                	sub    %edi,%ebx
  8018cd:	89 f9                	mov    %edi,%ecx
  8018cf:	d3 e6                	shl    %cl,%esi
  8018d1:	89 c5                	mov    %eax,%ebp
  8018d3:	88 d9                	mov    %bl,%cl
  8018d5:	d3 ed                	shr    %cl,%ebp
  8018d7:	89 e9                	mov    %ebp,%ecx
  8018d9:	09 f1                	or     %esi,%ecx
  8018db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018df:	89 f9                	mov    %edi,%ecx
  8018e1:	d3 e0                	shl    %cl,%eax
  8018e3:	89 c5                	mov    %eax,%ebp
  8018e5:	89 d6                	mov    %edx,%esi
  8018e7:	88 d9                	mov    %bl,%cl
  8018e9:	d3 ee                	shr    %cl,%esi
  8018eb:	89 f9                	mov    %edi,%ecx
  8018ed:	d3 e2                	shl    %cl,%edx
  8018ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018f3:	88 d9                	mov    %bl,%cl
  8018f5:	d3 e8                	shr    %cl,%eax
  8018f7:	09 c2                	or     %eax,%edx
  8018f9:	89 d0                	mov    %edx,%eax
  8018fb:	89 f2                	mov    %esi,%edx
  8018fd:	f7 74 24 0c          	divl   0xc(%esp)
  801901:	89 d6                	mov    %edx,%esi
  801903:	89 c3                	mov    %eax,%ebx
  801905:	f7 e5                	mul    %ebp
  801907:	39 d6                	cmp    %edx,%esi
  801909:	72 19                	jb     801924 <__udivdi3+0xfc>
  80190b:	74 0b                	je     801918 <__udivdi3+0xf0>
  80190d:	89 d8                	mov    %ebx,%eax
  80190f:	31 ff                	xor    %edi,%edi
  801911:	e9 58 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  801916:	66 90                	xchg   %ax,%ax
  801918:	8b 54 24 08          	mov    0x8(%esp),%edx
  80191c:	89 f9                	mov    %edi,%ecx
  80191e:	d3 e2                	shl    %cl,%edx
  801920:	39 c2                	cmp    %eax,%edx
  801922:	73 e9                	jae    80190d <__udivdi3+0xe5>
  801924:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801927:	31 ff                	xor    %edi,%edi
  801929:	e9 40 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  80192e:	66 90                	xchg   %ax,%ax
  801930:	31 c0                	xor    %eax,%eax
  801932:	e9 37 ff ff ff       	jmp    80186e <__udivdi3+0x46>
  801937:	90                   	nop

00801938 <__umoddi3>:
  801938:	55                   	push   %ebp
  801939:	57                   	push   %edi
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
  80193c:	83 ec 1c             	sub    $0x1c,%esp
  80193f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801943:	8b 74 24 34          	mov    0x34(%esp),%esi
  801947:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80194b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80194f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801953:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801957:	89 f3                	mov    %esi,%ebx
  801959:	89 fa                	mov    %edi,%edx
  80195b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80195f:	89 34 24             	mov    %esi,(%esp)
  801962:	85 c0                	test   %eax,%eax
  801964:	75 1a                	jne    801980 <__umoddi3+0x48>
  801966:	39 f7                	cmp    %esi,%edi
  801968:	0f 86 a2 00 00 00    	jbe    801a10 <__umoddi3+0xd8>
  80196e:	89 c8                	mov    %ecx,%eax
  801970:	89 f2                	mov    %esi,%edx
  801972:	f7 f7                	div    %edi
  801974:	89 d0                	mov    %edx,%eax
  801976:	31 d2                	xor    %edx,%edx
  801978:	83 c4 1c             	add    $0x1c,%esp
  80197b:	5b                   	pop    %ebx
  80197c:	5e                   	pop    %esi
  80197d:	5f                   	pop    %edi
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    
  801980:	39 f0                	cmp    %esi,%eax
  801982:	0f 87 ac 00 00 00    	ja     801a34 <__umoddi3+0xfc>
  801988:	0f bd e8             	bsr    %eax,%ebp
  80198b:	83 f5 1f             	xor    $0x1f,%ebp
  80198e:	0f 84 ac 00 00 00    	je     801a40 <__umoddi3+0x108>
  801994:	bf 20 00 00 00       	mov    $0x20,%edi
  801999:	29 ef                	sub    %ebp,%edi
  80199b:	89 fe                	mov    %edi,%esi
  80199d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019a1:	89 e9                	mov    %ebp,%ecx
  8019a3:	d3 e0                	shl    %cl,%eax
  8019a5:	89 d7                	mov    %edx,%edi
  8019a7:	89 f1                	mov    %esi,%ecx
  8019a9:	d3 ef                	shr    %cl,%edi
  8019ab:	09 c7                	or     %eax,%edi
  8019ad:	89 e9                	mov    %ebp,%ecx
  8019af:	d3 e2                	shl    %cl,%edx
  8019b1:	89 14 24             	mov    %edx,(%esp)
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	d3 e0                	shl    %cl,%eax
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019be:	d3 e0                	shl    %cl,%eax
  8019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c8:	89 f1                	mov    %esi,%ecx
  8019ca:	d3 e8                	shr    %cl,%eax
  8019cc:	09 d0                	or     %edx,%eax
  8019ce:	d3 eb                	shr    %cl,%ebx
  8019d0:	89 da                	mov    %ebx,%edx
  8019d2:	f7 f7                	div    %edi
  8019d4:	89 d3                	mov    %edx,%ebx
  8019d6:	f7 24 24             	mull   (%esp)
  8019d9:	89 c6                	mov    %eax,%esi
  8019db:	89 d1                	mov    %edx,%ecx
  8019dd:	39 d3                	cmp    %edx,%ebx
  8019df:	0f 82 87 00 00 00    	jb     801a6c <__umoddi3+0x134>
  8019e5:	0f 84 91 00 00 00    	je     801a7c <__umoddi3+0x144>
  8019eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8019ef:	29 f2                	sub    %esi,%edx
  8019f1:	19 cb                	sbb    %ecx,%ebx
  8019f3:	89 d8                	mov    %ebx,%eax
  8019f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8019f9:	d3 e0                	shl    %cl,%eax
  8019fb:	89 e9                	mov    %ebp,%ecx
  8019fd:	d3 ea                	shr    %cl,%edx
  8019ff:	09 d0                	or     %edx,%eax
  801a01:	89 e9                	mov    %ebp,%ecx
  801a03:	d3 eb                	shr    %cl,%ebx
  801a05:	89 da                	mov    %ebx,%edx
  801a07:	83 c4 1c             	add    $0x1c,%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5f                   	pop    %edi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    
  801a0f:	90                   	nop
  801a10:	89 fd                	mov    %edi,%ebp
  801a12:	85 ff                	test   %edi,%edi
  801a14:	75 0b                	jne    801a21 <__umoddi3+0xe9>
  801a16:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1b:	31 d2                	xor    %edx,%edx
  801a1d:	f7 f7                	div    %edi
  801a1f:	89 c5                	mov    %eax,%ebp
  801a21:	89 f0                	mov    %esi,%eax
  801a23:	31 d2                	xor    %edx,%edx
  801a25:	f7 f5                	div    %ebp
  801a27:	89 c8                	mov    %ecx,%eax
  801a29:	f7 f5                	div    %ebp
  801a2b:	89 d0                	mov    %edx,%eax
  801a2d:	e9 44 ff ff ff       	jmp    801976 <__umoddi3+0x3e>
  801a32:	66 90                	xchg   %ax,%ax
  801a34:	89 c8                	mov    %ecx,%eax
  801a36:	89 f2                	mov    %esi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	3b 04 24             	cmp    (%esp),%eax
  801a43:	72 06                	jb     801a4b <__umoddi3+0x113>
  801a45:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801a49:	77 0f                	ja     801a5a <__umoddi3+0x122>
  801a4b:	89 f2                	mov    %esi,%edx
  801a4d:	29 f9                	sub    %edi,%ecx
  801a4f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801a53:	89 14 24             	mov    %edx,(%esp)
  801a56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a5a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801a5e:	8b 14 24             	mov    (%esp),%edx
  801a61:	83 c4 1c             	add    $0x1c,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
  801a69:	8d 76 00             	lea    0x0(%esi),%esi
  801a6c:	2b 04 24             	sub    (%esp),%eax
  801a6f:	19 fa                	sbb    %edi,%edx
  801a71:	89 d1                	mov    %edx,%ecx
  801a73:	89 c6                	mov    %eax,%esi
  801a75:	e9 71 ff ff ff       	jmp    8019eb <__umoddi3+0xb3>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a80:	72 ea                	jb     801a6c <__umoddi3+0x134>
  801a82:	89 d9                	mov    %ebx,%ecx
  801a84:	e9 62 ff ff ff       	jmp    8019eb <__umoddi3+0xb3>
