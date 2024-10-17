
obj/user/tst_semaphore_2slave:     file format elf32-i386


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
  800031:	e8 a9 00 00 00       	call   8000df <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int id = sys_getenvindex();
  80003e:	e8 40 13 00 00       	call   801383 <sys_getenvindex>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800046:	e8 51 13 00 00       	call   80139c <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("Cust %d: outside the shop\n", id);
	struct semaphore shopCapacitySem = get_semaphore(parentenvID, "shopCapacity");
  80004e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 1c 80 00       	push   $0x801c40
  800059:	ff 75 f0             	pushl  -0x10(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 7f 16 00 00       	call   8016e1 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = get_semaphore(parentenvID, "depend");
  800065:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 4d 1c 80 00       	push   $0x801c4d
  800070:	ff 75 f0             	pushl  -0x10(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 68 16 00 00       	call   8016e1 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(shopCapacitySem);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 ec             	pushl  -0x14(%ebp)
  800082:	e8 74 16 00 00       	call   8016fb <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Cust %d: inside the shop\n", id) ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	ff 75 f4             	pushl  -0xc(%ebp)
  800090:	68 54 1c 80 00       	push   $0x801c54
  800095:	e8 66 02 00 00       	call   800300 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 e8 03 00 00       	push   $0x3e8
  8000a5:	e8 90 16 00 00       	call   80173a <env_sleep>
  8000aa:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(shopCapacitySem);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b3:	e8 5d 16 00 00       	call   801715 <signal_semaphore>
  8000b8:	83 c4 10             	add    $0x10,%esp

	cprintf("Cust %d: exit the shop\n", id);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c1:	68 6e 1c 80 00       	push   $0x801c6e
  8000c6:	e8 35 02 00 00       	call   800300 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(dependSem);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d4:	e8 3c 16 00 00       	call   801715 <signal_semaphore>
  8000d9:	83 c4 10             	add    $0x10,%esp
	return;
  8000dc:	90                   	nop
}
  8000dd:	c9                   	leave  
  8000de:	c3                   	ret    

008000df <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e5:	e8 99 12 00 00       	call   801383 <sys_getenvindex>
  8000ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f0:	89 d0                	mov    %edx,%eax
  8000f2:	c1 e0 06             	shl    $0x6,%eax
  8000f5:	29 d0                	sub    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800103:	01 c8                	add    %ecx,%eax
  800105:	c1 e0 03             	shl    $0x3,%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800111:	29 c2                	sub    %eax,%edx
  800113:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800122:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800127:	a1 04 30 80 00       	mov    0x803004,%eax
  80012c:	8a 40 20             	mov    0x20(%eax),%al
  80012f:	84 c0                	test   %al,%al
  800131:	74 0d                	je     800140 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800133:	a1 04 30 80 00       	mov    0x803004,%eax
  800138:	83 c0 20             	add    $0x20,%eax
  80013b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800144:	7e 0a                	jle    800150 <libmain+0x71>
		binaryname = argv[0];
  800146:	8b 45 0c             	mov    0xc(%ebp),%eax
  800149:	8b 00                	mov    (%eax),%eax
  80014b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	e8 da fe ff ff       	call   800038 <_main>
  80015e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800161:	e8 a1 0f 00 00       	call   801107 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 a0 1c 80 00       	push   $0x801ca0
  80016e:	e8 8d 01 00 00       	call   800300 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800176:	a1 04 30 80 00       	mov    0x803004,%eax
  80017b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800181:	a1 04 30 80 00       	mov    0x803004,%eax
  800186:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	52                   	push   %edx
  800190:	50                   	push   %eax
  800191:	68 c8 1c 80 00       	push   $0x801cc8
  800196:	e8 65 01 00 00       	call   800300 <cprintf>
  80019b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80019e:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a3:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ae:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b9:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001bf:	51                   	push   %ecx
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	68 f0 1c 80 00       	push   $0x801cf0
  8001c7:	e8 34 01 00 00       	call   800300 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d4:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	50                   	push   %eax
  8001de:	68 48 1d 80 00       	push   $0x801d48
  8001e3:	e8 18 01 00 00       	call   800300 <cprintf>
  8001e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001eb:	83 ec 0c             	sub    $0xc,%esp
  8001ee:	68 a0 1c 80 00       	push   $0x801ca0
  8001f3:	e8 08 01 00 00       	call   800300 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001fb:	e8 21 0f 00 00       	call   801121 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800200:	e8 19 00 00 00       	call   80021e <exit>
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	6a 00                	push   $0x0
  800213:	e8 37 11 00 00       	call   80134f <sys_destroy_env>
  800218:	83 c4 10             	add    $0x10,%esp
}
  80021b:	90                   	nop
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <exit>:

void
exit(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800224:	e8 8c 11 00 00       	call   8013b5 <sys_exit_env>
}
  800229:	90                   	nop
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800232:	8b 45 0c             	mov    0xc(%ebp),%eax
  800235:	8b 00                	mov    (%eax),%eax
  800237:	8d 48 01             	lea    0x1(%eax),%ecx
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	89 0a                	mov    %ecx,(%edx)
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	88 d1                	mov    %dl,%cl
  800244:	8b 55 0c             	mov    0xc(%ebp),%edx
  800247:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	8b 00                	mov    (%eax),%eax
  800250:	3d ff 00 00 00       	cmp    $0xff,%eax
  800255:	75 2c                	jne    800283 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800257:	a0 08 30 80 00       	mov    0x803008,%al
  80025c:	0f b6 c0             	movzbl %al,%eax
  80025f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800262:	8b 12                	mov    (%edx),%edx
  800264:	89 d1                	mov    %edx,%ecx
  800266:	8b 55 0c             	mov    0xc(%ebp),%edx
  800269:	83 c2 08             	add    $0x8,%edx
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	50                   	push   %eax
  800270:	51                   	push   %ecx
  800271:	52                   	push   %edx
  800272:	e8 4e 0e 00 00       	call   8010c5 <sys_cputs>
  800277:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8b 40 04             	mov    0x4(%eax),%eax
  800289:	8d 50 01             	lea    0x1(%eax),%edx
  80028c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800292:	90                   	nop
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a5:	00 00 00 
	b.cnt = 0;
  8002a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	68 2c 02 80 00       	push   $0x80022c
  8002c4:	e8 11 02 00 00       	call   8004da <vprintfmt>
  8002c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002cc:	a0 08 30 80 00       	mov    0x803008,%al
  8002d1:	0f b6 c0             	movzbl %al,%eax
  8002d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	50                   	push   %eax
  8002de:	52                   	push   %edx
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	83 c0 08             	add    $0x8,%eax
  8002e8:	50                   	push   %eax
  8002e9:	e8 d7 0d 00 00       	call   8010c5 <sys_cputs>
  8002ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800306:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800310:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	ff 75 f4             	pushl  -0xc(%ebp)
  80031c:	50                   	push   %eax
  80031d:	e8 73 ff ff ff       	call   800295 <vcprintf>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800333:	e8 cf 0d 00 00       	call   801107 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800338:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 48 ff ff ff       	call   800295 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800353:	e8 c9 0d 00 00       	call   801121 <sys_unlock_cons>
	return cnt;
  800358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	53                   	push   %ebx
  800361:	83 ec 14             	sub    $0x14,%esp
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80036a:	8b 45 14             	mov    0x14(%ebp),%eax
  80036d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800370:	8b 45 18             	mov    0x18(%ebp),%eax
  800373:	ba 00 00 00 00       	mov    $0x0,%edx
  800378:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037b:	77 55                	ja     8003d2 <printnum+0x75>
  80037d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800380:	72 05                	jb     800387 <printnum+0x2a>
  800382:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800385:	77 4b                	ja     8003d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800387:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80038a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80038d:	8b 45 18             	mov    0x18(%ebp),%eax
  800390:	ba 00 00 00 00       	mov    $0x0,%edx
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	ff 75 f4             	pushl  -0xc(%ebp)
  80039a:	ff 75 f0             	pushl  -0x10(%ebp)
  80039d:	e8 36 16 00 00       	call   8019d8 <__udivdi3>
  8003a2:	83 c4 10             	add    $0x10,%esp
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	ff 75 20             	pushl  0x20(%ebp)
  8003ab:	53                   	push   %ebx
  8003ac:	ff 75 18             	pushl  0x18(%ebp)
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	e8 a1 ff ff ff       	call   80035d <printnum>
  8003bc:	83 c4 20             	add    $0x20,%esp
  8003bf:	eb 1a                	jmp    8003db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	ff 75 20             	pushl  0x20(%ebp)
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	ff d0                	call   *%eax
  8003cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d9:	7f e6                	jg     8003c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e9:	53                   	push   %ebx
  8003ea:	51                   	push   %ecx
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	e8 f6 16 00 00       	call   801ae8 <__umoddi3>
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	05 74 1f 80 00       	add    $0x801f74,%eax
  8003fa:	8a 00                	mov    (%eax),%al
  8003fc:	0f be c0             	movsbl %al,%eax
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	50                   	push   %eax
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	ff d0                	call   *%eax
  80040b:	83 c4 10             	add    $0x10,%esp
}
  80040e:	90                   	nop
  80040f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800412:	c9                   	leave  
  800413:	c3                   	ret    

00800414 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800417:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80041b:	7e 1c                	jle    800439 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	8d 50 08             	lea    0x8(%eax),%edx
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	89 10                	mov    %edx,(%eax)
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	83 e8 08             	sub    $0x8,%eax
  800432:	8b 50 04             	mov    0x4(%eax),%edx
  800435:	8b 00                	mov    (%eax),%eax
  800437:	eb 40                	jmp    800479 <getuint+0x65>
	else if (lflag)
  800439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80043d:	74 1e                	je     80045d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	8d 50 04             	lea    0x4(%eax),%edx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	89 10                	mov    %edx,(%eax)
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	83 e8 04             	sub    $0x4,%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	ba 00 00 00 00       	mov    $0x0,%edx
  80045b:	eb 1c                	jmp    800479 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 50 04             	lea    0x4(%eax),%edx
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	89 10                	mov    %edx,(%eax)
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	83 e8 04             	sub    $0x4,%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    

0080047b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800482:	7e 1c                	jle    8004a0 <getint+0x25>
		return va_arg(*ap, long long);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	8d 50 08             	lea    0x8(%eax),%edx
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	89 10                	mov    %edx,(%eax)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 e8 08             	sub    $0x8,%eax
  800499:	8b 50 04             	mov    0x4(%eax),%edx
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	eb 38                	jmp    8004d8 <getint+0x5d>
	else if (lflag)
  8004a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a4:	74 1a                	je     8004c0 <getint+0x45>
		return va_arg(*ap, long);
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
  8004be:	eb 18                	jmp    8004d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 50 04             	lea    0x4(%eax),%edx
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	89 10                	mov    %edx,(%eax)
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	83 e8 04             	sub    $0x4,%eax
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	99                   	cltd   
}
  8004d8:	5d                   	pop    %ebp
  8004d9:	c3                   	ret    

008004da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	56                   	push   %esi
  8004de:	53                   	push   %ebx
  8004df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e2:	eb 17                	jmp    8004fb <vprintfmt+0x21>
			if (ch == '\0')
  8004e4:	85 db                	test   %ebx,%ebx
  8004e6:	0f 84 c1 03 00 00    	je     8008ad <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 0c             	pushl  0xc(%ebp)
  8004f2:	53                   	push   %ebx
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	ff d0                	call   *%eax
  8004f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fe:	8d 50 01             	lea    0x1(%eax),%edx
  800501:	89 55 10             	mov    %edx,0x10(%ebp)
  800504:	8a 00                	mov    (%eax),%al
  800506:	0f b6 d8             	movzbl %al,%ebx
  800509:	83 fb 25             	cmp    $0x25,%ebx
  80050c:	75 d6                	jne    8004e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800512:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800519:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800520:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800527:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 45 10             	mov    0x10(%ebp),%eax
  800531:	8d 50 01             	lea    0x1(%eax),%edx
  800534:	89 55 10             	mov    %edx,0x10(%ebp)
  800537:	8a 00                	mov    (%eax),%al
  800539:	0f b6 d8             	movzbl %al,%ebx
  80053c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80053f:	83 f8 5b             	cmp    $0x5b,%eax
  800542:	0f 87 3d 03 00 00    	ja     800885 <vprintfmt+0x3ab>
  800548:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  80054f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800551:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800555:	eb d7                	jmp    80052e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800557:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80055b:	eb d1                	jmp    80052e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800564:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	c1 e0 02             	shl    $0x2,%eax
  80056c:	01 d0                	add    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d8                	add    %ebx,%eax
  800572:	83 e8 30             	sub    $0x30,%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800578:	8b 45 10             	mov    0x10(%ebp),%eax
  80057b:	8a 00                	mov    (%eax),%al
  80057d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800580:	83 fb 2f             	cmp    $0x2f,%ebx
  800583:	7e 3e                	jle    8005c3 <vprintfmt+0xe9>
  800585:	83 fb 39             	cmp    $0x39,%ebx
  800588:	7f 39                	jg     8005c3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80058a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80058d:	eb d5                	jmp    800564 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	83 c0 04             	add    $0x4,%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	83 e8 04             	sub    $0x4,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a3:	eb 1f                	jmp    8005c4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a9:	79 83                	jns    80052e <vprintfmt+0x54>
				width = 0;
  8005ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b2:	e9 77 ff ff ff       	jmp    80052e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005be:	e9 6b ff ff ff       	jmp    80052e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c8:	0f 89 60 ff ff ff    	jns    80052e <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005db:	e9 4e ff ff ff       	jmp    80052e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e3:	e9 46 ff ff ff       	jmp    80052e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 c0 04             	add    $0x4,%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
			break;
  800608:	e9 9b 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	83 c0 04             	add    $0x4,%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	83 e8 04             	sub    $0x4,%eax
  80061c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80061e:	85 db                	test   %ebx,%ebx
  800620:	79 02                	jns    800624 <vprintfmt+0x14a>
				err = -err;
  800622:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800624:	83 fb 64             	cmp    $0x64,%ebx
  800627:	7f 0b                	jg     800634 <vprintfmt+0x15a>
  800629:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  800630:	85 f6                	test   %esi,%esi
  800632:	75 19                	jne    80064d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800634:	53                   	push   %ebx
  800635:	68 85 1f 80 00       	push   $0x801f85
  80063a:	ff 75 0c             	pushl  0xc(%ebp)
  80063d:	ff 75 08             	pushl  0x8(%ebp)
  800640:	e8 70 02 00 00       	call   8008b5 <printfmt>
  800645:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800648:	e9 5b 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80064d:	56                   	push   %esi
  80064e:	68 8e 1f 80 00       	push   $0x801f8e
  800653:	ff 75 0c             	pushl  0xc(%ebp)
  800656:	ff 75 08             	pushl  0x8(%ebp)
  800659:	e8 57 02 00 00       	call   8008b5 <printfmt>
  80065e:	83 c4 10             	add    $0x10,%esp
			break;
  800661:	e9 42 02 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	83 c0 04             	add    $0x4,%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 30                	mov    (%eax),%esi
  800677:	85 f6                	test   %esi,%esi
  800679:	75 05                	jne    800680 <vprintfmt+0x1a6>
				p = "(null)";
  80067b:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  800680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800684:	7e 6d                	jle    8006f3 <vprintfmt+0x219>
  800686:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80068a:	74 67                	je     8006f3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	56                   	push   %esi
  800694:	e8 1e 03 00 00       	call   8009b7 <strnlen>
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80069f:	eb 16                	jmp    8006b7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	ff d0                	call   *%eax
  8006b1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bb:	7f e4                	jg     8006a1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bd:	eb 34                	jmp    8006f3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c3:	74 1c                	je     8006e1 <vprintfmt+0x207>
  8006c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c8:	7e 05                	jle    8006cf <vprintfmt+0x1f5>
  8006ca:	83 fb 7e             	cmp    $0x7e,%ebx
  8006cd:	7e 12                	jle    8006e1 <vprintfmt+0x207>
					putch('?', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	6a 3f                	push   $0x3f
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	ff d0                	call   *%eax
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	eb 0f                	jmp    8006f0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	53                   	push   %ebx
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	8d 70 01             	lea    0x1(%eax),%esi
  8006f8:	8a 00                	mov    (%eax),%al
  8006fa:	0f be d8             	movsbl %al,%ebx
  8006fd:	85 db                	test   %ebx,%ebx
  8006ff:	74 24                	je     800725 <vprintfmt+0x24b>
  800701:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800705:	78 b8                	js     8006bf <vprintfmt+0x1e5>
  800707:	ff 4d e0             	decl   -0x20(%ebp)
  80070a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070e:	79 af                	jns    8006bf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800710:	eb 13                	jmp    800725 <vprintfmt+0x24b>
				putch(' ', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 20                	push   $0x20
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800722:	ff 4d e4             	decl   -0x1c(%ebp)
  800725:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800729:	7f e7                	jg     800712 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80072b:	e9 78 01 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 e8             	pushl  -0x18(%ebp)
  800736:	8d 45 14             	lea    0x14(%ebp),%eax
  800739:	50                   	push   %eax
  80073a:	e8 3c fd ff ff       	call   80047b <getint>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800745:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074e:	85 d2                	test   %edx,%edx
  800750:	79 23                	jns    800775 <vprintfmt+0x29b>
				putch('-', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	6a 2d                	push   $0x2d
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	f7 d8                	neg    %eax
  80076a:	83 d2 00             	adc    $0x0,%edx
  80076d:	f7 da                	neg    %edx
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800772:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800775:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077c:	e9 bc 00 00 00       	jmp    80083d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 e8             	pushl  -0x18(%ebp)
  800787:	8d 45 14             	lea    0x14(%ebp),%eax
  80078a:	50                   	push   %eax
  80078b:	e8 84 fc ff ff       	call   800414 <getuint>
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800796:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800799:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a0:	e9 98 00 00 00       	jmp    80083d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	6a 58                	push   $0x58
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	ff d0                	call   *%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 58                	push   $0x58
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	6a 58                	push   $0x58
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			break;
  8007d5:	e9 ce 00 00 00       	jmp    8008a8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 30                	push   $0x30
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 78                	push   $0x78
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	83 c0 04             	add    $0x4,%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	83 e8 04             	sub    $0x4,%eax
  800809:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800815:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80081c:	eb 1f                	jmp    80083d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 e8             	pushl  -0x18(%ebp)
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	50                   	push   %eax
  800828:	e8 e7 fb ff ff       	call   800414 <getuint>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800833:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800836:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80083d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	83 ec 04             	sub    $0x4,%esp
  800847:	52                   	push   %edx
  800848:	ff 75 e4             	pushl  -0x1c(%ebp)
  80084b:	50                   	push   %eax
  80084c:	ff 75 f4             	pushl  -0xc(%ebp)
  80084f:	ff 75 f0             	pushl  -0x10(%ebp)
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 00 fb ff ff       	call   80035d <printnum>
  80085d:	83 c4 20             	add    $0x20,%esp
			break;
  800860:	eb 46                	jmp    8008a8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	53                   	push   %ebx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	eb 35                	jmp    8008a8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800873:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80087a:	eb 2c                	jmp    8008a8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80087c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800883:	eb 23                	jmp    8008a8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	6a 25                	push   $0x25
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800895:	ff 4d 10             	decl   0x10(%ebp)
  800898:	eb 03                	jmp    80089d <vprintfmt+0x3c3>
  80089a:	ff 4d 10             	decl   0x10(%ebp)
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	48                   	dec    %eax
  8008a1:	8a 00                	mov    (%eax),%al
  8008a3:	3c 25                	cmp    $0x25,%al
  8008a5:	75 f3                	jne    80089a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008a7:	90                   	nop
		}
	}
  8008a8:	e9 35 fc ff ff       	jmp    8004e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ad:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	50                   	push   %eax
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 04 fc ff ff       	call   8004da <vprintfmt>
  8008d6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d9:	90                   	nop
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e2:	8b 40 08             	mov    0x8(%eax),%eax
  8008e5:	8d 50 01             	lea    0x1(%eax),%edx
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	8b 10                	mov    (%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	8b 40 04             	mov    0x4(%eax),%eax
  8008f9:	39 c2                	cmp    %eax,%edx
  8008fb:	73 12                	jae    80090f <sprintputch+0x33>
		*b->buf++ = ch;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 48 01             	lea    0x1(%eax),%ecx
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
  800908:	89 0a                	mov    %ecx,(%edx)
  80090a:	8b 55 08             	mov    0x8(%ebp),%edx
  80090d:	88 10                	mov    %dl,(%eax)
}
  80090f:	90                   	nop
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	8d 50 ff             	lea    -0x1(%eax),%edx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	01 d0                	add    %edx,%eax
  800929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800933:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800937:	74 06                	je     80093f <vsnprintf+0x2d>
  800939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093d:	7f 07                	jg     800946 <vsnprintf+0x34>
		return -E_INVAL;
  80093f:	b8 03 00 00 00       	mov    $0x3,%eax
  800944:	eb 20                	jmp    800966 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800946:	ff 75 14             	pushl  0x14(%ebp)
  800949:	ff 75 10             	pushl  0x10(%ebp)
  80094c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094f:	50                   	push   %eax
  800950:	68 dc 08 80 00       	push   $0x8008dc
  800955:	e8 80 fb ff ff       	call   8004da <vprintfmt>
  80095a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80095d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800960:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096e:	8d 45 10             	lea    0x10(%ebp),%eax
  800971:	83 c0 04             	add    $0x4,%eax
  800974:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800977:	8b 45 10             	mov    0x10(%ebp),%eax
  80097a:	ff 75 f4             	pushl  -0xc(%ebp)
  80097d:	50                   	push   %eax
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 89 ff ff ff       	call   800912 <vsnprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80099a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a1:	eb 06                	jmp    8009a9 <strlen+0x15>
		n++;
  8009a3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a6:	ff 45 08             	incl   0x8(%ebp)
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	84 c0                	test   %al,%al
  8009b0:	75 f1                	jne    8009a3 <strlen+0xf>
		n++;
	return n;
  8009b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c4:	eb 09                	jmp    8009cf <strnlen+0x18>
		n++;
  8009c6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c9:	ff 45 08             	incl   0x8(%ebp)
  8009cc:	ff 4d 0c             	decl   0xc(%ebp)
  8009cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d3:	74 09                	je     8009de <strnlen+0x27>
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8a 00                	mov    (%eax),%al
  8009da:	84 c0                	test   %al,%al
  8009dc:	75 e8                	jne    8009c6 <strnlen+0xf>
		n++;
	return n;
  8009de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009ef:	90                   	nop
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	8d 50 01             	lea    0x1(%eax),%edx
  8009f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a02:	8a 12                	mov    (%edx),%dl
  800a04:	88 10                	mov    %dl,(%eax)
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	84 c0                	test   %al,%al
  800a0a:	75 e4                	jne    8009f0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a24:	eb 1f                	jmp    800a45 <strncpy+0x34>
		*dst++ = *src;
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8a 12                	mov    (%edx),%dl
  800a34:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8a 00                	mov    (%eax),%al
  800a3b:	84 c0                	test   %al,%al
  800a3d:	74 03                	je     800a42 <strncpy+0x31>
			src++;
  800a3f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a42:	ff 45 fc             	incl   -0x4(%ebp)
  800a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a48:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a4b:	72 d9                	jb     800a26 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    

00800a52 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a62:	74 30                	je     800a94 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a64:	eb 16                	jmp    800a7c <strlcpy+0x2a>
			*dst++ = *src++;
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8d 50 01             	lea    0x1(%eax),%edx
  800a6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a78:	8a 12                	mov    (%edx),%dl
  800a7a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a7c:	ff 4d 10             	decl   0x10(%ebp)
  800a7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a83:	74 09                	je     800a8e <strlcpy+0x3c>
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	8a 00                	mov    (%eax),%al
  800a8a:	84 c0                	test   %al,%al
  800a8c:	75 d8                	jne    800a66 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a94:	8b 55 08             	mov    0x8(%ebp),%edx
  800a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a9a:	29 c2                	sub    %eax,%edx
  800a9c:	89 d0                	mov    %edx,%eax
}
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800aa3:	eb 06                	jmp    800aab <strcmp+0xb>
		p++, q++;
  800aa5:	ff 45 08             	incl   0x8(%ebp)
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	84 c0                	test   %al,%al
  800ab2:	74 0e                	je     800ac2 <strcmp+0x22>
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 10                	mov    (%eax),%dl
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	8a 00                	mov    (%eax),%al
  800abe:	38 c2                	cmp    %al,%dl
  800ac0:	74 e3                	je     800aa5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	0f b6 d0             	movzbl %al,%edx
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8a 00                	mov    (%eax),%al
  800acf:	0f b6 c0             	movzbl %al,%eax
  800ad2:	29 c2                	sub    %eax,%edx
  800ad4:	89 d0                	mov    %edx,%eax
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800adb:	eb 09                	jmp    800ae6 <strncmp+0xe>
		n--, p++, q++;
  800add:	ff 4d 10             	decl   0x10(%ebp)
  800ae0:	ff 45 08             	incl   0x8(%ebp)
  800ae3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ae6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aea:	74 17                	je     800b03 <strncmp+0x2b>
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	84 c0                	test   %al,%al
  800af3:	74 0e                	je     800b03 <strncmp+0x2b>
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8a 10                	mov    (%eax),%dl
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8a 00                	mov    (%eax),%al
  800aff:	38 c2                	cmp    %al,%dl
  800b01:	74 da                	je     800add <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b07:	75 07                	jne    800b10 <strncmp+0x38>
		return 0;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	eb 14                	jmp    800b24 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	0f b6 d0             	movzbl %al,%edx
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8a 00                	mov    (%eax),%al
  800b1d:	0f b6 c0             	movzbl %al,%eax
  800b20:	29 c2                	sub    %eax,%edx
  800b22:	89 d0                	mov    %edx,%eax
}
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 04             	sub    $0x4,%esp
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b32:	eb 12                	jmp    800b46 <strchr+0x20>
		if (*s == c)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b3c:	75 05                	jne    800b43 <strchr+0x1d>
			return (char *) s;
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	eb 11                	jmp    800b54 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b43:	ff 45 08             	incl   0x8(%ebp)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	84 c0                	test   %al,%al
  800b4d:	75 e5                	jne    800b34 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b62:	eb 0d                	jmp    800b71 <strfind+0x1b>
		if (*s == c)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b6c:	74 0e                	je     800b7c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b6e:	ff 45 08             	incl   0x8(%ebp)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	84 c0                	test   %al,%al
  800b78:	75 ea                	jne    800b64 <strfind+0xe>
  800b7a:	eb 01                	jmp    800b7d <strfind+0x27>
		if (*s == c)
			break;
  800b7c:	90                   	nop
	return (char *) s;
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b94:	eb 0e                	jmp    800ba4 <memset+0x22>
		*p++ = c;
  800b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b99:	8d 50 01             	lea    0x1(%eax),%edx
  800b9c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ba4:	ff 4d f8             	decl   -0x8(%ebp)
  800ba7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bab:	79 e9                	jns    800b96 <memset+0x14>
		*p++ = c;

	return v;
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bc4:	eb 16                	jmp    800bdc <memcpy+0x2a>
		*d++ = *s++;
  800bc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bc9:	8d 50 01             	lea    0x1(%eax),%edx
  800bcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bd8:	8a 12                	mov    (%edx),%dl
  800bda:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800be2:	89 55 10             	mov    %edx,0x10(%ebp)
  800be5:	85 c0                	test   %eax,%eax
  800be7:	75 dd                	jne    800bc6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c06:	73 50                	jae    800c58 <memmove+0x6a>
  800c08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	01 d0                	add    %edx,%eax
  800c10:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c13:	76 43                	jbe    800c58 <memmove+0x6a>
		s += n;
  800c15:	8b 45 10             	mov    0x10(%ebp),%eax
  800c18:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c21:	eb 10                	jmp    800c33 <memmove+0x45>
			*--d = *--s;
  800c23:	ff 4d f8             	decl   -0x8(%ebp)
  800c26:	ff 4d fc             	decl   -0x4(%ebp)
  800c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2c:	8a 10                	mov    (%eax),%dl
  800c2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c31:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c39:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	75 e3                	jne    800c23 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c40:	eb 23                	jmp    800c65 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c51:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c54:	8a 12                	mov    (%edx),%dl
  800c56:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c61:	85 c0                	test   %eax,%eax
  800c63:	75 dd                	jne    800c42 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c7c:	eb 2a                	jmp    800ca8 <memcmp+0x3e>
		if (*s1 != *s2)
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c81:	8a 10                	mov    (%eax),%dl
  800c83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	38 c2                	cmp    %al,%dl
  800c8a:	74 16                	je     800ca2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 d0             	movzbl %al,%edx
  800c94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	0f b6 c0             	movzbl %al,%eax
  800c9c:	29 c2                	sub    %eax,%edx
  800c9e:	89 d0                	mov    %edx,%eax
  800ca0:	eb 18                	jmp    800cba <memcmp+0x50>
		s1++, s2++;
  800ca2:	ff 45 fc             	incl   -0x4(%ebp)
  800ca5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cae:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	75 c9                	jne    800c7e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc8:	01 d0                	add    %edx,%eax
  800cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ccd:	eb 15                	jmp    800ce4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d0             	movzbl %al,%edx
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	0f b6 c0             	movzbl %al,%eax
  800cdd:	39 c2                	cmp    %eax,%edx
  800cdf:	74 0d                	je     800cee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ce1:	ff 45 08             	incl   0x8(%ebp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cea:	72 e3                	jb     800ccf <memfind+0x13>
  800cec:	eb 01                	jmp    800cef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cee:	90                   	nop
	return (void *) s;
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d01:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d08:	eb 03                	jmp    800d0d <strtol+0x19>
		s++;
  800d0a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 20                	cmp    $0x20,%al
  800d14:	74 f4                	je     800d0a <strtol+0x16>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 09                	cmp    $0x9,%al
  800d1d:	74 eb                	je     800d0a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 2b                	cmp    $0x2b,%al
  800d26:	75 05                	jne    800d2d <strtol+0x39>
		s++;
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	eb 13                	jmp    800d40 <strtol+0x4c>
	else if (*s == '-')
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	3c 2d                	cmp    $0x2d,%al
  800d34:	75 0a                	jne    800d40 <strtol+0x4c>
		s++, neg = 1;
  800d36:	ff 45 08             	incl   0x8(%ebp)
  800d39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d44:	74 06                	je     800d4c <strtol+0x58>
  800d46:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d4a:	75 20                	jne    800d6c <strtol+0x78>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 30                	cmp    $0x30,%al
  800d53:	75 17                	jne    800d6c <strtol+0x78>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	40                   	inc    %eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 78                	cmp    $0x78,%al
  800d5d:	75 0d                	jne    800d6c <strtol+0x78>
		s += 2, base = 16;
  800d5f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d63:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d6a:	eb 28                	jmp    800d94 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	75 15                	jne    800d87 <strtol+0x93>
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3c 30                	cmp    $0x30,%al
  800d79:	75 0c                	jne    800d87 <strtol+0x93>
		s++, base = 8;
  800d7b:	ff 45 08             	incl   0x8(%ebp)
  800d7e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d85:	eb 0d                	jmp    800d94 <strtol+0xa0>
	else if (base == 0)
  800d87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8b:	75 07                	jne    800d94 <strtol+0xa0>
		base = 10;
  800d8d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	3c 2f                	cmp    $0x2f,%al
  800d9b:	7e 19                	jle    800db6 <strtol+0xc2>
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3c 39                	cmp    $0x39,%al
  800da4:	7f 10                	jg     800db6 <strtol+0xc2>
			dig = *s - '0';
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	0f be c0             	movsbl %al,%eax
  800dae:	83 e8 30             	sub    $0x30,%eax
  800db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800db4:	eb 42                	jmp    800df8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 60                	cmp    $0x60,%al
  800dbd:	7e 19                	jle    800dd8 <strtol+0xe4>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 7a                	cmp    $0x7a,%al
  800dc6:	7f 10                	jg     800dd8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	0f be c0             	movsbl %al,%eax
  800dd0:	83 e8 57             	sub    $0x57,%eax
  800dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dd6:	eb 20                	jmp    800df8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	3c 40                	cmp    $0x40,%al
  800ddf:	7e 39                	jle    800e1a <strtol+0x126>
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	3c 5a                	cmp    $0x5a,%al
  800de8:	7f 30                	jg     800e1a <strtol+0x126>
			dig = *s - 'A' + 10;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f be c0             	movsbl %al,%eax
  800df2:	83 e8 37             	sub    $0x37,%eax
  800df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dfb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dfe:	7d 19                	jge    800e19 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e0a:	89 c2                	mov    %eax,%edx
  800e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e0f:	01 d0                	add    %edx,%eax
  800e11:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e14:	e9 7b ff ff ff       	jmp    800d94 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e19:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1e:	74 08                	je     800e28 <strtol+0x134>
		*endptr = (char *) s;
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e2c:	74 07                	je     800e35 <strtol+0x141>
  800e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e31:	f7 d8                	neg    %eax
  800e33:	eb 03                	jmp    800e38 <strtol+0x144>
  800e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <ltostr>:

void
ltostr(long value, char *str)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e52:	79 13                	jns    800e67 <ltostr+0x2d>
	{
		neg = 1;
  800e54:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e61:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e64:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e6f:	99                   	cltd   
  800e70:	f7 f9                	idiv   %ecx
  800e72:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e78:	8d 50 01             	lea    0x1(%eax),%edx
  800e7b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	01 d0                	add    %edx,%eax
  800e85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e88:	83 c2 30             	add    $0x30,%edx
  800e8b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e90:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e95:	f7 e9                	imul   %ecx
  800e97:	c1 fa 02             	sar    $0x2,%edx
  800e9a:	89 c8                	mov    %ecx,%eax
  800e9c:	c1 f8 1f             	sar    $0x1f,%eax
  800e9f:	29 c2                	sub    %eax,%edx
  800ea1:	89 d0                	mov    %edx,%eax
  800ea3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ea6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eaa:	75 bb                	jne    800e67 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800eac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800eb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb6:	48                   	dec    %eax
  800eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ebe:	74 3d                	je     800efd <ltostr+0xc3>
		start = 1 ;
  800ec0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ec7:	eb 34                	jmp    800efd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	01 d0                	add    %edx,%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ed6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	01 c2                	add    %eax,%edx
  800ede:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	01 c8                	add    %ecx,%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	01 c2                	add    %eax,%edx
  800ef2:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ef5:	88 02                	mov    %al,(%edx)
		start++ ;
  800ef7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800efa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f03:	7c c4                	jl     800ec9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f05:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f10:	90                   	nop
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f19:	ff 75 08             	pushl  0x8(%ebp)
  800f1c:	e8 73 fa ff ff       	call   800994 <strlen>
  800f21:	83 c4 04             	add    $0x4,%esp
  800f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	e8 65 fa ff ff       	call   800994 <strlen>
  800f2f:	83 c4 04             	add    $0x4,%esp
  800f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f43:	eb 17                	jmp    800f5c <strcconcat+0x49>
		final[s] = str1[s] ;
  800f45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	01 c2                	add    %eax,%edx
  800f4d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	01 c8                	add    %ecx,%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f62:	7c e1                	jl     800f45 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f72:	eb 1f                	jmp    800f93 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f7d:	89 c2                	mov    %eax,%edx
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	01 c2                	add    %eax,%edx
  800f84:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	01 c8                	add    %ecx,%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f90:	ff 45 f8             	incl   -0x8(%ebp)
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f99:	7c d9                	jl     800f74 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 d0                	add    %edx,%eax
  800fa3:	c6 00 00             	movb   $0x0,(%eax)
}
  800fa6:	90                   	nop
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fac:	8b 45 14             	mov    0x14(%ebp),%eax
  800faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb8:	8b 00                	mov    (%eax),%eax
  800fba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 d0                	add    %edx,%eax
  800fc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fcc:	eb 0c                	jmp    800fda <strsplit+0x31>
			*string++ = 0;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800fd7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	74 18                	je     800ffb <strsplit+0x52>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f be c0             	movsbl %al,%eax
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	e8 32 fb ff ff       	call   800b26 <strchr>
  800ff4:	83 c4 08             	add    $0x8,%esp
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 d3                	jne    800fce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	84 c0                	test   %al,%al
  801002:	74 5a                	je     80105e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	83 f8 0f             	cmp    $0xf,%eax
  80100c:	75 07                	jne    801015 <strsplit+0x6c>
		{
			return 0;
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	eb 66                	jmp    80107b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801015:	8b 45 14             	mov    0x14(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 48 01             	lea    0x1(%eax),%ecx
  80101d:	8b 55 14             	mov    0x14(%ebp),%edx
  801020:	89 0a                	mov    %ecx,(%edx)
  801022:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	01 c2                	add    %eax,%edx
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801033:	eb 03                	jmp    801038 <strsplit+0x8f>
			string++;
  801035:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	84 c0                	test   %al,%al
  80103f:	74 8b                	je     800fcc <strsplit+0x23>
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f be c0             	movsbl %al,%eax
  801049:	50                   	push   %eax
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	e8 d4 fa ff ff       	call   800b26 <strchr>
  801052:	83 c4 08             	add    $0x8,%esp
  801055:	85 c0                	test   %eax,%eax
  801057:	74 dc                	je     801035 <strsplit+0x8c>
			string++;
	}
  801059:	e9 6e ff ff ff       	jmp    800fcc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80105e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80105f:	8b 45 14             	mov    0x14(%ebp),%eax
  801062:	8b 00                	mov    (%eax),%eax
  801064:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801076:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	68 08 21 80 00       	push   $0x802108
  80108b:	68 3f 01 00 00       	push   $0x13f
  801090:	68 2a 21 80 00       	push   $0x80212a
  801095:	e8 54 07 00 00       	call   8017ee <_panic>

0080109a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010b5:	cd 30                	int    $0x30
  8010b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 04             	sub    $0x4,%esp
  8010cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	6a 00                	push   $0x0
  8010da:	6a 00                	push   $0x0
  8010dc:	52                   	push   %edx
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	50                   	push   %eax
  8010e1:	6a 00                	push   $0x0
  8010e3:	e8 b2 ff ff ff       	call   80109a <syscall>
  8010e8:	83 c4 18             	add    $0x18,%esp
}
  8010eb:	90                   	nop
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010f1:	6a 00                	push   $0x0
  8010f3:	6a 00                	push   $0x0
  8010f5:	6a 00                	push   $0x0
  8010f7:	6a 00                	push   $0x0
  8010f9:	6a 00                	push   $0x0
  8010fb:	6a 02                	push   $0x2
  8010fd:	e8 98 ff ff ff       	call   80109a <syscall>
  801102:	83 c4 18             	add    $0x18,%esp
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	6a 00                	push   $0x0
  801114:	6a 03                	push   $0x3
  801116:	e8 7f ff ff ff       	call   80109a <syscall>
  80111b:	83 c4 18             	add    $0x18,%esp
}
  80111e:	90                   	nop
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	6a 04                	push   $0x4
  801130:	e8 65 ff ff ff       	call   80109a <syscall>
  801135:	83 c4 18             	add    $0x18,%esp
}
  801138:	90                   	nop
  801139:	c9                   	leave  
  80113a:	c3                   	ret    

0080113b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80113e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	52                   	push   %edx
  80114b:	50                   	push   %eax
  80114c:	6a 08                	push   $0x8
  80114e:	e8 47 ff ff ff       	call   80109a <syscall>
  801153:	83 c4 18             	add    $0x18,%esp
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	56                   	push   %esi
  80115c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80115d:	8b 75 18             	mov    0x18(%ebp),%esi
  801160:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801163:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801166:	8b 55 0c             	mov    0xc(%ebp),%edx
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
  80116e:	51                   	push   %ecx
  80116f:	52                   	push   %edx
  801170:	50                   	push   %eax
  801171:	6a 09                	push   $0x9
  801173:	e8 22 ff ff ff       	call   80109a <syscall>
  801178:	83 c4 18             	add    $0x18,%esp
}
  80117b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    

00801182 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801185:	8b 55 0c             	mov    0xc(%ebp),%edx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	52                   	push   %edx
  801192:	50                   	push   %eax
  801193:	6a 0a                	push   $0xa
  801195:	e8 00 ff ff ff       	call   80109a <syscall>
  80119a:	83 c4 18             	add    $0x18,%esp
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	6a 0b                	push   $0xb
  8011b0:	e8 e5 fe ff ff       	call   80109a <syscall>
  8011b5:	83 c4 18             	add    $0x18,%esp
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 00                	push   $0x0
  8011c7:	6a 0c                	push   $0xc
  8011c9:	e8 cc fe ff ff       	call   80109a <syscall>
  8011ce:	83 c4 18             	add    $0x18,%esp
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 00                	push   $0x0
  8011dc:	6a 00                	push   $0x0
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 0d                	push   $0xd
  8011e2:	e8 b3 fe ff ff       	call   80109a <syscall>
  8011e7:	83 c4 18             	add    $0x18,%esp
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 00                	push   $0x0
  8011f5:	6a 00                	push   $0x0
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 0e                	push   $0xe
  8011fb:	e8 9a fe ff ff       	call   80109a <syscall>
  801200:	83 c4 18             	add    $0x18,%esp
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 00                	push   $0x0
  801210:	6a 00                	push   $0x0
  801212:	6a 0f                	push   $0xf
  801214:	e8 81 fe ff ff       	call   80109a <syscall>
  801219:	83 c4 18             	add    $0x18,%esp
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	ff 75 08             	pushl  0x8(%ebp)
  80122c:	6a 10                	push   $0x10
  80122e:	e8 67 fe ff ff       	call   80109a <syscall>
  801233:	83 c4 18             	add    $0x18,%esp
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 11                	push   $0x11
  801247:	e8 4e fe ff ff       	call   80109a <syscall>
  80124c:	83 c4 18             	add    $0x18,%esp
}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_cputc>:

void
sys_cputc(const char c)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80125e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	50                   	push   %eax
  80126b:	6a 01                	push   $0x1
  80126d:	e8 28 fe ff ff       	call   80109a <syscall>
  801272:	83 c4 18             	add    $0x18,%esp
}
  801275:	90                   	nop
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 14                	push   $0x14
  801287:	e8 0e fe ff ff       	call   80109a <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	90                   	nop
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80129e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	6a 00                	push   $0x0
  8012aa:	51                   	push   %ecx
  8012ab:	52                   	push   %edx
  8012ac:	ff 75 0c             	pushl  0xc(%ebp)
  8012af:	50                   	push   %eax
  8012b0:	6a 15                	push   $0x15
  8012b2:	e8 e3 fd ff ff       	call   80109a <syscall>
  8012b7:	83 c4 18             	add    $0x18,%esp
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	6a 16                	push   $0x16
  8012cf:	e8 c6 fd ff ff       	call   80109a <syscall>
  8012d4:	83 c4 18             	add    $0x18,%esp
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	51                   	push   %ecx
  8012ea:	52                   	push   %edx
  8012eb:	50                   	push   %eax
  8012ec:	6a 17                	push   $0x17
  8012ee:	e8 a7 fd ff ff       	call   80109a <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	6a 18                	push   $0x18
  80130b:	e8 8a fd ff ff       	call   80109a <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	6a 00                	push   $0x0
  80131d:	ff 75 14             	pushl  0x14(%ebp)
  801320:	ff 75 10             	pushl  0x10(%ebp)
  801323:	ff 75 0c             	pushl  0xc(%ebp)
  801326:	50                   	push   %eax
  801327:	6a 19                	push   $0x19
  801329:	e8 6c fd ff ff       	call   80109a <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	50                   	push   %eax
  801342:	6a 1a                	push   $0x1a
  801344:	e8 51 fd ff ff       	call   80109a <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	90                   	nop
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	50                   	push   %eax
  80135e:	6a 1b                	push   $0x1b
  801360:	e8 35 fd ff ff       	call   80109a <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 05                	push   $0x5
  801379:	e8 1c fd ff ff       	call   80109a <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 06                	push   $0x6
  801392:	e8 03 fd ff ff       	call   80109a <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 07                	push   $0x7
  8013ab:	e8 ea fc ff ff       	call   80109a <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 1c                	push   $0x1c
  8013c4:	e8 d1 fc ff ff       	call   80109a <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013d8:	8d 50 04             	lea    0x4(%eax),%edx
  8013db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	52                   	push   %edx
  8013e5:	50                   	push   %eax
  8013e6:	6a 1d                	push   $0x1d
  8013e8:	e8 ad fc ff ff       	call   80109a <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8013f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f9:	89 01                	mov    %eax,(%ecx)
  8013fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	c9                   	leave  
  801402:	c2 04 00             	ret    $0x4

00801405 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	ff 75 10             	pushl  0x10(%ebp)
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	6a 13                	push   $0x13
  801417:	e8 7e fc ff ff       	call   80109a <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
	return ;
  80141f:	90                   	nop
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <sys_rcr2>:
uint32 sys_rcr2()
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 1e                	push   $0x1e
  801431:	e8 64 fc ff ff       	call   80109a <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801447:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	50                   	push   %eax
  801454:	6a 1f                	push   $0x1f
  801456:	e8 3f fc ff ff       	call   80109a <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
	return ;
  80145e:	90                   	nop
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <rsttst>:
void rsttst()
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 21                	push   $0x21
  801470:	e8 25 fc ff ff       	call   80109a <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
	return ;
  801478:	90                   	nop
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	8b 45 14             	mov    0x14(%ebp),%eax
  801484:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801487:	8b 55 18             	mov    0x18(%ebp),%edx
  80148a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80148e:	52                   	push   %edx
  80148f:	50                   	push   %eax
  801490:	ff 75 10             	pushl  0x10(%ebp)
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	ff 75 08             	pushl  0x8(%ebp)
  801499:	6a 20                	push   $0x20
  80149b:	e8 fa fb ff ff       	call   80109a <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a3:	90                   	nop
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <chktst>:
void chktst(uint32 n)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	6a 22                	push   $0x22
  8014b6:	e8 df fb ff ff       	call   80109a <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8014be:	90                   	nop
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <inctst>:

void inctst()
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 23                	push   $0x23
  8014d0:	e8 c5 fb ff ff       	call   80109a <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d8:	90                   	nop
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <gettst>:
uint32 gettst()
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 24                	push   $0x24
  8014ea:	e8 ab fb ff ff       	call   80109a <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 25                	push   $0x25
  801506:	e8 8f fb ff ff       	call   80109a <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801511:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801515:	75 07                	jne    80151e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801517:	b8 01 00 00 00       	mov    $0x1,%eax
  80151c:	eb 05                	jmp    801523 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 25                	push   $0x25
  801537:	e8 5e fb ff ff       	call   80109a <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
  80153f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801542:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801546:	75 07                	jne    80154f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801548:	b8 01 00 00 00       	mov    $0x1,%eax
  80154d:	eb 05                	jmp    801554 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 25                	push   $0x25
  801568:	e8 2d fb ff ff       	call   80109a <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
  801570:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801573:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801577:	75 07                	jne    801580 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801579:	b8 01 00 00 00       	mov    $0x1,%eax
  80157e:	eb 05                	jmp    801585 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 25                	push   $0x25
  801599:	e8 fc fa ff ff       	call   80109a <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
  8015a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015a4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015a8:	75 07                	jne    8015b1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8015af:	eb 05                	jmp    8015b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	ff 75 08             	pushl  0x8(%ebp)
  8015c6:	6a 26                	push   $0x26
  8015c8:	e8 cd fa ff ff       	call   80109a <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d0:	90                   	nop
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	53                   	push   %ebx
  8015e6:	51                   	push   %ecx
  8015e7:	52                   	push   %edx
  8015e8:	50                   	push   %eax
  8015e9:	6a 27                	push   $0x27
  8015eb:	e8 aa fa ff ff       	call   80109a <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	52                   	push   %edx
  801608:	50                   	push   %eax
  801609:	6a 28                	push   $0x28
  80160b:	e8 8a fa ff ff       	call   80109a <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801618:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80161b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	6a 00                	push   $0x0
  801623:	51                   	push   %ecx
  801624:	ff 75 10             	pushl  0x10(%ebp)
  801627:	52                   	push   %edx
  801628:	50                   	push   %eax
  801629:	6a 29                	push   $0x29
  80162b:	e8 6a fa ff ff       	call   80109a <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	ff 75 10             	pushl  0x10(%ebp)
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	6a 12                	push   $0x12
  801647:	e8 4e fa ff ff       	call   80109a <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
	return ;
  80164f:	90                   	nop
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	52                   	push   %edx
  801662:	50                   	push   %eax
  801663:	6a 2a                	push   $0x2a
  801665:	e8 30 fa ff ff       	call   80109a <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
	return;
  80166d:	90                   	nop
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	68 37 21 80 00       	push   $0x802137
  80167e:	68 2e 01 00 00       	push   $0x12e
  801683:	68 4b 21 80 00       	push   $0x80214b
  801688:	e8 61 01 00 00       	call   8017ee <_panic>

0080168d <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	68 37 21 80 00       	push   $0x802137
  80169b:	68 35 01 00 00       	push   $0x135
  8016a0:	68 4b 21 80 00       	push   $0x80214b
  8016a5:	e8 44 01 00 00       	call   8017ee <_panic>

008016aa <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	68 37 21 80 00       	push   $0x802137
  8016b8:	68 3b 01 00 00       	push   $0x13b
  8016bd:	68 4b 21 80 00       	push   $0x80214b
  8016c2:	e8 27 01 00 00       	call   8017ee <_panic>

008016c7 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	68 5c 21 80 00       	push   $0x80215c
  8016d5:	6a 09                	push   $0x9
  8016d7:	68 84 21 80 00       	push   $0x802184
  8016dc:	e8 0d 01 00 00       	call   8017ee <_panic>

008016e1 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	68 94 21 80 00       	push   $0x802194
  8016ef:	6a 10                	push   $0x10
  8016f1:	68 84 21 80 00       	push   $0x802184
  8016f6:	e8 f3 00 00 00       	call   8017ee <_panic>

008016fb <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	68 bc 21 80 00       	push   $0x8021bc
  801709:	6a 18                	push   $0x18
  80170b:	68 84 21 80 00       	push   $0x802184
  801710:	e8 d9 00 00 00       	call   8017ee <_panic>

00801715 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 e4 21 80 00       	push   $0x8021e4
  801723:	6a 20                	push   $0x20
  801725:	68 84 21 80 00       	push   $0x802184
  80172a:	e8 bf 00 00 00       	call   8017ee <_panic>

0080172f <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8b 40 10             	mov    0x10(%eax),%eax
}
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801740:	8b 55 08             	mov    0x8(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	c1 e0 02             	shl    $0x2,%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801751:	01 d0                	add    %edx,%eax
  801753:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175a:	01 d0                	add    %edx,%eax
  80175c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801763:	01 d0                	add    %edx,%eax
  801765:	c1 e0 04             	shl    $0x4,%eax
  801768:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80176b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801772:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	50                   	push   %eax
  801779:	e8 51 fc ff ff       	call   8013cf <sys_get_virtual_time>
  80177e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801781:	eb 41                	jmp    8017c4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801783:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801786:	83 ec 0c             	sub    $0xc,%esp
  801789:	50                   	push   %eax
  80178a:	e8 40 fc ff ff       	call   8013cf <sys_get_virtual_time>
  80178f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801792:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801795:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801798:	29 c2                	sub    %eax,%edx
  80179a:	89 d0                	mov    %edx,%eax
  80179c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80179f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a5:	89 d1                	mov    %edx,%ecx
  8017a7:	29 c1                	sub    %eax,%ecx
  8017a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017af:	39 c2                	cmp    %eax,%edx
  8017b1:	0f 97 c0             	seta   %al
  8017b4:	0f b6 c0             	movzbl %al,%eax
  8017b7:	29 c1                	sub    %eax,%ecx
  8017b9:	89 c8                	mov    %ecx,%eax
  8017bb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8017be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017ca:	72 b7                	jb     801783 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8017d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8017dc:	eb 03                	jmp    8017e1 <busy_wait+0x12>
  8017de:	ff 45 fc             	incl   -0x4(%ebp)
  8017e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017e7:	72 f5                	jb     8017de <busy_wait+0xf>
	return i;
  8017e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f7:	83 c0 04             	add    $0x4,%eax
  8017fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017fd:	a1 24 30 80 00       	mov    0x803024,%eax
  801802:	85 c0                	test   %eax,%eax
  801804:	74 16                	je     80181c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801806:	a1 24 30 80 00       	mov    0x803024,%eax
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	50                   	push   %eax
  80180f:	68 0c 22 80 00       	push   $0x80220c
  801814:	e8 e7 ea ff ff       	call   800300 <cprintf>
  801819:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80181c:	a1 00 30 80 00       	mov    0x803000,%eax
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	ff 75 08             	pushl  0x8(%ebp)
  801827:	50                   	push   %eax
  801828:	68 11 22 80 00       	push   $0x802211
  80182d:	e8 ce ea ff ff       	call   800300 <cprintf>
  801832:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 f4             	pushl  -0xc(%ebp)
  80183e:	50                   	push   %eax
  80183f:	e8 51 ea ff ff       	call   800295 <vcprintf>
  801844:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	6a 00                	push   $0x0
  80184c:	68 2d 22 80 00       	push   $0x80222d
  801851:	e8 3f ea ff ff       	call   800295 <vcprintf>
  801856:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801859:	e8 c0 e9 ff ff       	call   80021e <exit>

	// should not return here
	while (1) ;
  80185e:	eb fe                	jmp    80185e <_panic+0x70>

00801860 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801866:	a1 04 30 80 00       	mov    0x803004,%eax
  80186b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801871:	8b 45 0c             	mov    0xc(%ebp),%eax
  801874:	39 c2                	cmp    %eax,%edx
  801876:	74 14                	je     80188c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	68 30 22 80 00       	push   $0x802230
  801880:	6a 26                	push   $0x26
  801882:	68 7c 22 80 00       	push   $0x80227c
  801887:	e8 62 ff ff ff       	call   8017ee <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80188c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801893:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80189a:	e9 c5 00 00 00       	jmp    801964 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	01 d0                	add    %edx,%eax
  8018ae:	8b 00                	mov    (%eax),%eax
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	75 08                	jne    8018bc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018b4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018b7:	e9 a5 00 00 00       	jmp    801961 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ca:	eb 69                	jmp    801935 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	01 c0                	add    %eax,%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c1 e0 03             	shl    $0x3,%eax
  8018e3:	01 c8                	add    %ecx,%eax
  8018e5:	8a 40 04             	mov    0x4(%eax),%al
  8018e8:	84 c0                	test   %al,%al
  8018ea:	75 46                	jne    801932 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8018f1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018fa:	89 d0                	mov    %edx,%eax
  8018fc:	01 c0                	add    %eax,%eax
  8018fe:	01 d0                	add    %edx,%eax
  801900:	c1 e0 03             	shl    $0x3,%eax
  801903:	01 c8                	add    %ecx,%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80190a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80190d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801912:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801917:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	01 c8                	add    %ecx,%eax
  801923:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801925:	39 c2                	cmp    %eax,%edx
  801927:	75 09                	jne    801932 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801929:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801930:	eb 15                	jmp    801947 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801932:	ff 45 e8             	incl   -0x18(%ebp)
  801935:	a1 04 30 80 00       	mov    0x803004,%eax
  80193a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801943:	39 c2                	cmp    %eax,%edx
  801945:	77 85                	ja     8018cc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801947:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80194b:	75 14                	jne    801961 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	68 88 22 80 00       	push   $0x802288
  801955:	6a 3a                	push   $0x3a
  801957:	68 7c 22 80 00       	push   $0x80227c
  80195c:	e8 8d fe ff ff       	call   8017ee <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801961:	ff 45 f0             	incl   -0x10(%ebp)
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80196a:	0f 8c 2f ff ff ff    	jl     80189f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801970:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801977:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80197e:	eb 26                	jmp    8019a6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801980:	a1 04 30 80 00       	mov    0x803004,%eax
  801985:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80198b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80198e:	89 d0                	mov    %edx,%eax
  801990:	01 c0                	add    %eax,%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	c1 e0 03             	shl    $0x3,%eax
  801997:	01 c8                	add    %ecx,%eax
  801999:	8a 40 04             	mov    0x4(%eax),%al
  80199c:	3c 01                	cmp    $0x1,%al
  80199e:	75 03                	jne    8019a3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a3:	ff 45 e0             	incl   -0x20(%ebp)
  8019a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ab:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b4:	39 c2                	cmp    %eax,%edx
  8019b6:	77 c8                	ja     801980 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019be:	74 14                	je     8019d4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	68 dc 22 80 00       	push   $0x8022dc
  8019c8:	6a 44                	push   $0x44
  8019ca:	68 7c 22 80 00       	push   $0x80227c
  8019cf:	e8 1a fe ff ff       	call   8017ee <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    
  8019d7:	90                   	nop

008019d8 <__udivdi3>:
  8019d8:	55                   	push   %ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 1c             	sub    $0x1c,%esp
  8019df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ef:	89 ca                	mov    %ecx,%edx
  8019f1:	89 f8                	mov    %edi,%eax
  8019f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019f7:	85 f6                	test   %esi,%esi
  8019f9:	75 2d                	jne    801a28 <__udivdi3+0x50>
  8019fb:	39 cf                	cmp    %ecx,%edi
  8019fd:	77 65                	ja     801a64 <__udivdi3+0x8c>
  8019ff:	89 fd                	mov    %edi,%ebp
  801a01:	85 ff                	test   %edi,%edi
  801a03:	75 0b                	jne    801a10 <__udivdi3+0x38>
  801a05:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0a:	31 d2                	xor    %edx,%edx
  801a0c:	f7 f7                	div    %edi
  801a0e:	89 c5                	mov    %eax,%ebp
  801a10:	31 d2                	xor    %edx,%edx
  801a12:	89 c8                	mov    %ecx,%eax
  801a14:	f7 f5                	div    %ebp
  801a16:	89 c1                	mov    %eax,%ecx
  801a18:	89 d8                	mov    %ebx,%eax
  801a1a:	f7 f5                	div    %ebp
  801a1c:	89 cf                	mov    %ecx,%edi
  801a1e:	89 fa                	mov    %edi,%edx
  801a20:	83 c4 1c             	add    $0x1c,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    
  801a28:	39 ce                	cmp    %ecx,%esi
  801a2a:	77 28                	ja     801a54 <__udivdi3+0x7c>
  801a2c:	0f bd fe             	bsr    %esi,%edi
  801a2f:	83 f7 1f             	xor    $0x1f,%edi
  801a32:	75 40                	jne    801a74 <__udivdi3+0x9c>
  801a34:	39 ce                	cmp    %ecx,%esi
  801a36:	72 0a                	jb     801a42 <__udivdi3+0x6a>
  801a38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a3c:	0f 87 9e 00 00 00    	ja     801ae0 <__udivdi3+0x108>
  801a42:	b8 01 00 00 00       	mov    $0x1,%eax
  801a47:	89 fa                	mov    %edi,%edx
  801a49:	83 c4 1c             	add    $0x1c,%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
  801a51:	8d 76 00             	lea    0x0(%esi),%esi
  801a54:	31 ff                	xor    %edi,%edi
  801a56:	31 c0                	xor    %eax,%eax
  801a58:	89 fa                	mov    %edi,%edx
  801a5a:	83 c4 1c             	add    $0x1c,%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5f                   	pop    %edi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	89 d8                	mov    %ebx,%eax
  801a66:	f7 f7                	div    %edi
  801a68:	31 ff                	xor    %edi,%edi
  801a6a:	89 fa                	mov    %edi,%edx
  801a6c:	83 c4 1c             	add    $0x1c,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5f                   	pop    %edi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
  801a74:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a79:	89 eb                	mov    %ebp,%ebx
  801a7b:	29 fb                	sub    %edi,%ebx
  801a7d:	89 f9                	mov    %edi,%ecx
  801a7f:	d3 e6                	shl    %cl,%esi
  801a81:	89 c5                	mov    %eax,%ebp
  801a83:	88 d9                	mov    %bl,%cl
  801a85:	d3 ed                	shr    %cl,%ebp
  801a87:	89 e9                	mov    %ebp,%ecx
  801a89:	09 f1                	or     %esi,%ecx
  801a8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a8f:	89 f9                	mov    %edi,%ecx
  801a91:	d3 e0                	shl    %cl,%eax
  801a93:	89 c5                	mov    %eax,%ebp
  801a95:	89 d6                	mov    %edx,%esi
  801a97:	88 d9                	mov    %bl,%cl
  801a99:	d3 ee                	shr    %cl,%esi
  801a9b:	89 f9                	mov    %edi,%ecx
  801a9d:	d3 e2                	shl    %cl,%edx
  801a9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa3:	88 d9                	mov    %bl,%cl
  801aa5:	d3 e8                	shr    %cl,%eax
  801aa7:	09 c2                	or     %eax,%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	89 f2                	mov    %esi,%edx
  801aad:	f7 74 24 0c          	divl   0xc(%esp)
  801ab1:	89 d6                	mov    %edx,%esi
  801ab3:	89 c3                	mov    %eax,%ebx
  801ab5:	f7 e5                	mul    %ebp
  801ab7:	39 d6                	cmp    %edx,%esi
  801ab9:	72 19                	jb     801ad4 <__udivdi3+0xfc>
  801abb:	74 0b                	je     801ac8 <__udivdi3+0xf0>
  801abd:	89 d8                	mov    %ebx,%eax
  801abf:	31 ff                	xor    %edi,%edi
  801ac1:	e9 58 ff ff ff       	jmp    801a1e <__udivdi3+0x46>
  801ac6:	66 90                	xchg   %ax,%ax
  801ac8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801acc:	89 f9                	mov    %edi,%ecx
  801ace:	d3 e2                	shl    %cl,%edx
  801ad0:	39 c2                	cmp    %eax,%edx
  801ad2:	73 e9                	jae    801abd <__udivdi3+0xe5>
  801ad4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ad7:	31 ff                	xor    %edi,%edi
  801ad9:	e9 40 ff ff ff       	jmp    801a1e <__udivdi3+0x46>
  801ade:	66 90                	xchg   %ax,%ax
  801ae0:	31 c0                	xor    %eax,%eax
  801ae2:	e9 37 ff ff ff       	jmp    801a1e <__udivdi3+0x46>
  801ae7:	90                   	nop

00801ae8 <__umoddi3>:
  801ae8:	55                   	push   %ebp
  801ae9:	57                   	push   %edi
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 1c             	sub    $0x1c,%esp
  801aef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801af3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b07:	89 f3                	mov    %esi,%ebx
  801b09:	89 fa                	mov    %edi,%edx
  801b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b0f:	89 34 24             	mov    %esi,(%esp)
  801b12:	85 c0                	test   %eax,%eax
  801b14:	75 1a                	jne    801b30 <__umoddi3+0x48>
  801b16:	39 f7                	cmp    %esi,%edi
  801b18:	0f 86 a2 00 00 00    	jbe    801bc0 <__umoddi3+0xd8>
  801b1e:	89 c8                	mov    %ecx,%eax
  801b20:	89 f2                	mov    %esi,%edx
  801b22:	f7 f7                	div    %edi
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	31 d2                	xor    %edx,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	39 f0                	cmp    %esi,%eax
  801b32:	0f 87 ac 00 00 00    	ja     801be4 <__umoddi3+0xfc>
  801b38:	0f bd e8             	bsr    %eax,%ebp
  801b3b:	83 f5 1f             	xor    $0x1f,%ebp
  801b3e:	0f 84 ac 00 00 00    	je     801bf0 <__umoddi3+0x108>
  801b44:	bf 20 00 00 00       	mov    $0x20,%edi
  801b49:	29 ef                	sub    %ebp,%edi
  801b4b:	89 fe                	mov    %edi,%esi
  801b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 e0                	shl    %cl,%eax
  801b55:	89 d7                	mov    %edx,%edi
  801b57:	89 f1                	mov    %esi,%ecx
  801b59:	d3 ef                	shr    %cl,%edi
  801b5b:	09 c7                	or     %eax,%edi
  801b5d:	89 e9                	mov    %ebp,%ecx
  801b5f:	d3 e2                	shl    %cl,%edx
  801b61:	89 14 24             	mov    %edx,(%esp)
  801b64:	89 d8                	mov    %ebx,%eax
  801b66:	d3 e0                	shl    %cl,%eax
  801b68:	89 c2                	mov    %eax,%edx
  801b6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6e:	d3 e0                	shl    %cl,%eax
  801b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b74:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b78:	89 f1                	mov    %esi,%ecx
  801b7a:	d3 e8                	shr    %cl,%eax
  801b7c:	09 d0                	or     %edx,%eax
  801b7e:	d3 eb                	shr    %cl,%ebx
  801b80:	89 da                	mov    %ebx,%edx
  801b82:	f7 f7                	div    %edi
  801b84:	89 d3                	mov    %edx,%ebx
  801b86:	f7 24 24             	mull   (%esp)
  801b89:	89 c6                	mov    %eax,%esi
  801b8b:	89 d1                	mov    %edx,%ecx
  801b8d:	39 d3                	cmp    %edx,%ebx
  801b8f:	0f 82 87 00 00 00    	jb     801c1c <__umoddi3+0x134>
  801b95:	0f 84 91 00 00 00    	je     801c2c <__umoddi3+0x144>
  801b9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b9f:	29 f2                	sub    %esi,%edx
  801ba1:	19 cb                	sbb    %ecx,%ebx
  801ba3:	89 d8                	mov    %ebx,%eax
  801ba5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ba9:	d3 e0                	shl    %cl,%eax
  801bab:	89 e9                	mov    %ebp,%ecx
  801bad:	d3 ea                	shr    %cl,%edx
  801baf:	09 d0                	or     %edx,%eax
  801bb1:	89 e9                	mov    %ebp,%ecx
  801bb3:	d3 eb                	shr    %cl,%ebx
  801bb5:	89 da                	mov    %ebx,%edx
  801bb7:	83 c4 1c             	add    $0x1c,%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    
  801bbf:	90                   	nop
  801bc0:	89 fd                	mov    %edi,%ebp
  801bc2:	85 ff                	test   %edi,%edi
  801bc4:	75 0b                	jne    801bd1 <__umoddi3+0xe9>
  801bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcb:	31 d2                	xor    %edx,%edx
  801bcd:	f7 f7                	div    %edi
  801bcf:	89 c5                	mov    %eax,%ebp
  801bd1:	89 f0                	mov    %esi,%eax
  801bd3:	31 d2                	xor    %edx,%edx
  801bd5:	f7 f5                	div    %ebp
  801bd7:	89 c8                	mov    %ecx,%eax
  801bd9:	f7 f5                	div    %ebp
  801bdb:	89 d0                	mov    %edx,%eax
  801bdd:	e9 44 ff ff ff       	jmp    801b26 <__umoddi3+0x3e>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	89 c8                	mov    %ecx,%eax
  801be6:	89 f2                	mov    %esi,%edx
  801be8:	83 c4 1c             	add    $0x1c,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5f                   	pop    %edi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
  801bf0:	3b 04 24             	cmp    (%esp),%eax
  801bf3:	72 06                	jb     801bfb <__umoddi3+0x113>
  801bf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bf9:	77 0f                	ja     801c0a <__umoddi3+0x122>
  801bfb:	89 f2                	mov    %esi,%edx
  801bfd:	29 f9                	sub    %edi,%ecx
  801bff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c03:	89 14 24             	mov    %edx,(%esp)
  801c06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c0e:	8b 14 24             	mov    (%esp),%edx
  801c11:	83 c4 1c             	add    $0x1c,%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5f                   	pop    %edi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    
  801c19:	8d 76 00             	lea    0x0(%esi),%esi
  801c1c:	2b 04 24             	sub    (%esp),%eax
  801c1f:	19 fa                	sbb    %edi,%edx
  801c21:	89 d1                	mov    %edx,%ecx
  801c23:	89 c6                	mov    %eax,%esi
  801c25:	e9 71 ff ff ff       	jmp    801b9b <__umoddi3+0xb3>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c30:	72 ea                	jb     801c1c <__umoddi3+0x134>
  801c32:	89 d9                	mov    %ebx,%ecx
  801c34:	e9 62 ff ff ff       	jmp    801b9b <__umoddi3+0xb3>
