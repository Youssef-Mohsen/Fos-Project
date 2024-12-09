
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
  80003e:	e8 32 13 00 00       	call   801375 <sys_getenvindex>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800046:	e8 43 13 00 00       	call   80138e <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("Cust %d: outside the shop\n", id);
	struct semaphore shopCapacitySem = get_semaphore(parentenvID, "shopCapacity");
  80004e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 c0 3d 80 00       	push   $0x803dc0
  800059:	ff 75 f0             	pushl  -0x10(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 63 17 00 00       	call   8017c5 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = get_semaphore(parentenvID, "depend");
  800065:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 cd 3d 80 00       	push   $0x803dcd
  800070:	ff 75 f0             	pushl  -0x10(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 4c 17 00 00       	call   8017c5 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(shopCapacitySem);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 ec             	pushl  -0x14(%ebp)
  800082:	e8 89 17 00 00       	call   801810 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Cust %d: inside the shop\n", id) ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	ff 75 f4             	pushl  -0xc(%ebp)
  800090:	68 d4 3d 80 00       	push   $0x803dd4
  800095:	e8 58 02 00 00       	call   8002f2 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 e8 03 00 00       	push   $0x3e8
  8000a5:	e8 65 18 00 00       	call   80190f <env_sleep>
  8000aa:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(shopCapacitySem);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b3:	e8 da 17 00 00       	call   801892 <signal_semaphore>
  8000b8:	83 c4 10             	add    $0x10,%esp

	cprintf("Cust %d: exit the shop\n", id);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c1:	68 ee 3d 80 00       	push   $0x803dee
  8000c6:	e8 27 02 00 00       	call   8002f2 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(dependSem);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d4:	e8 b9 17 00 00       	call   801892 <signal_semaphore>
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
  8000e5:	e8 8b 12 00 00       	call   801375 <sys_getenvindex>
  8000ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f0:	89 d0                	mov    %edx,%eax
  8000f2:	c1 e0 03             	shl    $0x3,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8000fe:	01 c8                	add    %ecx,%eax
  800100:	01 c0                	add    %eax,%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80010b:	01 c8                	add    %ecx,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8a 40 20             	mov    0x20(%eax),%al
  800121:	84 c0                	test   %al,%al
  800123:	74 0d                	je     800132 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800125:	a1 20 50 80 00       	mov    0x805020,%eax
  80012a:	83 c0 20             	add    $0x20,%eax
  80012d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800136:	7e 0a                	jle    800142 <libmain+0x63>
		binaryname = argv[0];
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	ff 75 0c             	pushl  0xc(%ebp)
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	e8 e8 fe ff ff       	call   800038 <_main>
  800150:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800153:	e8 a1 0f 00 00       	call   8010f9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	68 20 3e 80 00       	push   $0x803e20
  800160:	e8 8d 01 00 00       	call   8002f2 <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800168:	a1 20 50 80 00       	mov    0x805020,%eax
  80016d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800173:	a1 20 50 80 00       	mov    0x805020,%eax
  800178:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	52                   	push   %edx
  800182:	50                   	push   %eax
  800183:	68 48 3e 80 00       	push   $0x803e48
  800188:	e8 65 01 00 00       	call   8002f2 <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800190:	a1 20 50 80 00       	mov    0x805020,%eax
  800195:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80019b:	a1 20 50 80 00       	mov    0x805020,%eax
  8001a0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ab:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001b1:	51                   	push   %ecx
  8001b2:	52                   	push   %edx
  8001b3:	50                   	push   %eax
  8001b4:	68 70 3e 80 00       	push   $0x803e70
  8001b9:	e8 34 01 00 00       	call   8002f2 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c6:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	68 c8 3e 80 00       	push   $0x803ec8
  8001d5:	e8 18 01 00 00       	call   8002f2 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 20 3e 80 00       	push   $0x803e20
  8001e5:	e8 08 01 00 00       	call   8002f2 <cprintf>
  8001ea:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001ed:	e8 21 0f 00 00       	call   801113 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001f2:	e8 19 00 00 00       	call   800210 <exit>
}
  8001f7:	90                   	nop
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    

008001fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	6a 00                	push   $0x0
  800205:	e8 37 11 00 00       	call   801341 <sys_destroy_env>
  80020a:	83 c4 10             	add    $0x10,%esp
}
  80020d:	90                   	nop
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <exit>:

void
exit(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800216:	e8 8c 11 00 00       	call   8013a7 <sys_exit_env>
}
  80021b:	90                   	nop
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	8b 00                	mov    (%eax),%eax
  800229:	8d 48 01             	lea    0x1(%eax),%ecx
  80022c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022f:	89 0a                	mov    %ecx,(%edx)
  800231:	8b 55 08             	mov    0x8(%ebp),%edx
  800234:	88 d1                	mov    %dl,%cl
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	8b 00                	mov    (%eax),%eax
  800242:	3d ff 00 00 00       	cmp    $0xff,%eax
  800247:	75 2c                	jne    800275 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800249:	a0 28 50 80 00       	mov    0x805028,%al
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	8b 55 0c             	mov    0xc(%ebp),%edx
  800254:	8b 12                	mov    (%edx),%edx
  800256:	89 d1                	mov    %edx,%ecx
  800258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025b:	83 c2 08             	add    $0x8,%edx
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	50                   	push   %eax
  800262:	51                   	push   %ecx
  800263:	52                   	push   %edx
  800264:	e8 4e 0e 00 00       	call   8010b7 <sys_cputs>
  800269:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	8b 40 04             	mov    0x4(%eax),%eax
  80027b:	8d 50 01             	lea    0x1(%eax),%edx
  80027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800281:	89 50 04             	mov    %edx,0x4(%eax)
}
  800284:	90                   	nop
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800290:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800297:	00 00 00 
	b.cnt = 0;
  80029a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	68 1e 02 80 00       	push   $0x80021e
  8002b6:	e8 11 02 00 00       	call   8004cc <vprintfmt>
  8002bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002be:	a0 28 50 80 00       	mov    0x805028,%al
  8002c3:	0f b6 c0             	movzbl %al,%eax
  8002c6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002cc:	83 ec 04             	sub    $0x4,%esp
  8002cf:	50                   	push   %eax
  8002d0:	52                   	push   %edx
  8002d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d7:	83 c0 08             	add    $0x8,%eax
  8002da:	50                   	push   %eax
  8002db:	e8 d7 0d 00 00       	call   8010b7 <sys_cputs>
  8002e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8002ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f8:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8002ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800302:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800305:	8b 45 08             	mov    0x8(%ebp),%eax
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	50                   	push   %eax
  80030f:	e8 73 ff ff ff       	call   800287 <vcprintf>
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800325:	e8 cf 0d 00 00       	call   8010f9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80032a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 48 ff ff ff       	call   800287 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800345:	e8 c9 0d 00 00       	call   801113 <sys_unlock_cons>
	return cnt;
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	53                   	push   %ebx
  800353:	83 ec 14             	sub    $0x14,%esp
  800356:	8b 45 10             	mov    0x10(%ebp),%eax
  800359:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	8b 45 18             	mov    0x18(%ebp),%eax
  800365:	ba 00 00 00 00       	mov    $0x0,%edx
  80036a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036d:	77 55                	ja     8003c4 <printnum+0x75>
  80036f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800372:	72 05                	jb     800379 <printnum+0x2a>
  800374:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800377:	77 4b                	ja     8003c4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800379:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80037c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037f:	8b 45 18             	mov    0x18(%ebp),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
  800387:	52                   	push   %edx
  800388:	50                   	push   %eax
  800389:	ff 75 f4             	pushl  -0xc(%ebp)
  80038c:	ff 75 f0             	pushl  -0x10(%ebp)
  80038f:	e8 b4 37 00 00       	call   803b48 <__udivdi3>
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	ff 75 20             	pushl  0x20(%ebp)
  80039d:	53                   	push   %ebx
  80039e:	ff 75 18             	pushl  0x18(%ebp)
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	ff 75 0c             	pushl  0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 a1 ff ff ff       	call   80034f <printnum>
  8003ae:	83 c4 20             	add    $0x20,%esp
  8003b1:	eb 1a                	jmp    8003cd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	ff 75 0c             	pushl  0xc(%ebp)
  8003b9:	ff 75 20             	pushl  0x20(%ebp)
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	ff d0                	call   *%eax
  8003c1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c4:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003cb:	7f e6                	jg     8003b3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003db:	53                   	push   %ebx
  8003dc:	51                   	push   %ecx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	e8 74 38 00 00       	call   803c58 <__umoddi3>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	05 f4 40 80 00       	add    $0x8040f4,%eax
  8003ec:	8a 00                	mov    (%eax),%al
  8003ee:	0f be c0             	movsbl %al,%eax
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	50                   	push   %eax
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	ff d0                	call   *%eax
  8003fd:	83 c4 10             	add    $0x10,%esp
}
  800400:	90                   	nop
  800401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800409:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040d:	7e 1c                	jle    80042b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 50 08             	lea    0x8(%eax),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	89 10                	mov    %edx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	83 e8 08             	sub    $0x8,%eax
  800424:	8b 50 04             	mov    0x4(%eax),%edx
  800427:	8b 00                	mov    (%eax),%eax
  800429:	eb 40                	jmp    80046b <getuint+0x65>
	else if (lflag)
  80042b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042f:	74 1e                	je     80044f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	8d 50 04             	lea    0x4(%eax),%edx
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	89 10                	mov    %edx,(%eax)
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	83 e8 04             	sub    $0x4,%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	eb 1c                	jmp    80046b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	8d 50 04             	lea    0x4(%eax),%edx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	89 10                	mov    %edx,(%eax)
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	83 e8 04             	sub    $0x4,%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800470:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800474:	7e 1c                	jle    800492 <getint+0x25>
		return va_arg(*ap, long long);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 50 08             	lea    0x8(%eax),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 10                	mov    %edx,(%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	83 e8 08             	sub    $0x8,%eax
  80048b:	8b 50 04             	mov    0x4(%eax),%edx
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	eb 38                	jmp    8004ca <getint+0x5d>
	else if (lflag)
  800492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800496:	74 1a                	je     8004b2 <getint+0x45>
		return va_arg(*ap, long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 04             	lea    0x4(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 04             	sub    $0x4,%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	99                   	cltd   
  8004b0:	eb 18                	jmp    8004ca <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 10                	mov    %edx,(%eax)
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	83 e8 04             	sub    $0x4,%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
}
  8004ca:	5d                   	pop    %ebp
  8004cb:	c3                   	ret    

008004cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	56                   	push   %esi
  8004d0:	53                   	push   %ebx
  8004d1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d4:	eb 17                	jmp    8004ed <vprintfmt+0x21>
			if (ch == '\0')
  8004d6:	85 db                	test   %ebx,%ebx
  8004d8:	0f 84 c1 03 00 00    	je     80089f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	ff 75 0c             	pushl  0xc(%ebp)
  8004e4:	53                   	push   %ebx
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	ff d0                	call   *%eax
  8004ea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f0:	8d 50 01             	lea    0x1(%eax),%edx
  8004f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f6:	8a 00                	mov    (%eax),%al
  8004f8:	0f b6 d8             	movzbl %al,%ebx
  8004fb:	83 fb 25             	cmp    $0x25,%ebx
  8004fe:	75 d6                	jne    8004d6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800500:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800504:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80050b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800512:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800519:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 50 01             	lea    0x1(%eax),%edx
  800526:	89 55 10             	mov    %edx,0x10(%ebp)
  800529:	8a 00                	mov    (%eax),%al
  80052b:	0f b6 d8             	movzbl %al,%ebx
  80052e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800531:	83 f8 5b             	cmp    $0x5b,%eax
  800534:	0f 87 3d 03 00 00    	ja     800877 <vprintfmt+0x3ab>
  80053a:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
  800541:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800543:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800547:	eb d7                	jmp    800520 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800549:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80054d:	eb d1                	jmp    800520 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800556:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800559:	89 d0                	mov    %edx,%eax
  80055b:	c1 e0 02             	shl    $0x2,%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	01 d8                	add    %ebx,%eax
  800564:	83 e8 30             	sub    $0x30,%eax
  800567:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80056a:	8b 45 10             	mov    0x10(%ebp),%eax
  80056d:	8a 00                	mov    (%eax),%al
  80056f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800572:	83 fb 2f             	cmp    $0x2f,%ebx
  800575:	7e 3e                	jle    8005b5 <vprintfmt+0xe9>
  800577:	83 fb 39             	cmp    $0x39,%ebx
  80057a:	7f 39                	jg     8005b5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80057f:	eb d5                	jmp    800556 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	83 c0 04             	add    $0x4,%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	83 e8 04             	sub    $0x4,%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800595:	eb 1f                	jmp    8005b6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800597:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059b:	79 83                	jns    800520 <vprintfmt+0x54>
				width = 0;
  80059d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a4:	e9 77 ff ff ff       	jmp    800520 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b0:	e9 6b ff ff ff       	jmp    800520 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ba:	0f 89 60 ff ff ff    	jns    800520 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005cd:	e9 4e ff ff ff       	jmp    800520 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d5:	e9 46 ff ff ff       	jmp    800520 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	83 c0 04             	add    $0x4,%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 e8 04             	sub    $0x4,%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	ff 75 0c             	pushl  0xc(%ebp)
  8005f1:	50                   	push   %eax
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	ff d0                	call   *%eax
  8005f7:	83 c4 10             	add    $0x10,%esp
			break;
  8005fa:	e9 9b 02 00 00       	jmp    80089a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	83 c0 04             	add    $0x4,%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	83 e8 04             	sub    $0x4,%eax
  80060e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800610:	85 db                	test   %ebx,%ebx
  800612:	79 02                	jns    800616 <vprintfmt+0x14a>
				err = -err;
  800614:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800616:	83 fb 64             	cmp    $0x64,%ebx
  800619:	7f 0b                	jg     800626 <vprintfmt+0x15a>
  80061b:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  800622:	85 f6                	test   %esi,%esi
  800624:	75 19                	jne    80063f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800626:	53                   	push   %ebx
  800627:	68 05 41 80 00       	push   $0x804105
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 08             	pushl  0x8(%ebp)
  800632:	e8 70 02 00 00       	call   8008a7 <printfmt>
  800637:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80063a:	e9 5b 02 00 00       	jmp    80089a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063f:	56                   	push   %esi
  800640:	68 0e 41 80 00       	push   $0x80410e
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 57 02 00 00       	call   8008a7 <printfmt>
  800650:	83 c4 10             	add    $0x10,%esp
			break;
  800653:	e9 42 02 00 00       	jmp    80089a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	83 c0 04             	add    $0x4,%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 e8 04             	sub    $0x4,%eax
  800667:	8b 30                	mov    (%eax),%esi
  800669:	85 f6                	test   %esi,%esi
  80066b:	75 05                	jne    800672 <vprintfmt+0x1a6>
				p = "(null)";
  80066d:	be 11 41 80 00       	mov    $0x804111,%esi
			if (width > 0 && padc != '-')
  800672:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800676:	7e 6d                	jle    8006e5 <vprintfmt+0x219>
  800678:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80067c:	74 67                	je     8006e5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	50                   	push   %eax
  800685:	56                   	push   %esi
  800686:	e8 1e 03 00 00       	call   8009a9 <strnlen>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800691:	eb 16                	jmp    8006a9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800693:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	50                   	push   %eax
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ad:	7f e4                	jg     800693 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006af:	eb 34                	jmp    8006e5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b5:	74 1c                	je     8006d3 <vprintfmt+0x207>
  8006b7:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ba:	7e 05                	jle    8006c1 <vprintfmt+0x1f5>
  8006bc:	83 fb 7e             	cmp    $0x7e,%ebx
  8006bf:	7e 12                	jle    8006d3 <vprintfmt+0x207>
					putch('?', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	6a 3f                	push   $0x3f
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	eb 0f                	jmp    8006e2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 0c             	pushl  0xc(%ebp)
  8006d9:	53                   	push   %ebx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	ff d0                	call   *%eax
  8006df:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e5:	89 f0                	mov    %esi,%eax
  8006e7:	8d 70 01             	lea    0x1(%eax),%esi
  8006ea:	8a 00                	mov    (%eax),%al
  8006ec:	0f be d8             	movsbl %al,%ebx
  8006ef:	85 db                	test   %ebx,%ebx
  8006f1:	74 24                	je     800717 <vprintfmt+0x24b>
  8006f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f7:	78 b8                	js     8006b1 <vprintfmt+0x1e5>
  8006f9:	ff 4d e0             	decl   -0x20(%ebp)
  8006fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800700:	79 af                	jns    8006b1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800702:	eb 13                	jmp    800717 <vprintfmt+0x24b>
				putch(' ', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 20                	push   $0x20
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800714:	ff 4d e4             	decl   -0x1c(%ebp)
  800717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071b:	7f e7                	jg     800704 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80071d:	e9 78 01 00 00       	jmp    80089a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 e8             	pushl  -0x18(%ebp)
  800728:	8d 45 14             	lea    0x14(%ebp),%eax
  80072b:	50                   	push   %eax
  80072c:	e8 3c fd ff ff       	call   80046d <getint>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800737:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80073a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800740:	85 d2                	test   %edx,%edx
  800742:	79 23                	jns    800767 <vprintfmt+0x29b>
				putch('-', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 2d                	push   $0x2d
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075a:	f7 d8                	neg    %eax
  80075c:	83 d2 00             	adc    $0x0,%edx
  80075f:	f7 da                	neg    %edx
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800764:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800767:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076e:	e9 bc 00 00 00       	jmp    80082f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 e8             	pushl  -0x18(%ebp)
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	e8 84 fc ff ff       	call   800406 <getuint>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800788:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80078b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800792:	e9 98 00 00 00       	jmp    80082f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 58                	push   $0x58
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	6a 58                	push   $0x58
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	ff 75 0c             	pushl  0xc(%ebp)
  8007bd:	6a 58                	push   $0x58
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	ff d0                	call   *%eax
  8007c4:	83 c4 10             	add    $0x10,%esp
			break;
  8007c7:	e9 ce 00 00 00       	jmp    80089a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	6a 30                	push   $0x30
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	ff d0                	call   *%eax
  8007d9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 78                	push   $0x78
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 c0 04             	add    $0x4,%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 e8 04             	sub    $0x4,%eax
  8007fb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800807:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80080e:	eb 1f                	jmp    80082f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 e8             	pushl  -0x18(%ebp)
  800816:	8d 45 14             	lea    0x14(%ebp),%eax
  800819:	50                   	push   %eax
  80081a:	e8 e7 fb ff ff       	call   800406 <getuint>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800825:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800828:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800836:	83 ec 04             	sub    $0x4,%esp
  800839:	52                   	push   %edx
  80083a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083d:	50                   	push   %eax
  80083e:	ff 75 f4             	pushl  -0xc(%ebp)
  800841:	ff 75 f0             	pushl  -0x10(%ebp)
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	ff 75 08             	pushl  0x8(%ebp)
  80084a:	e8 00 fb ff ff       	call   80034f <printnum>
  80084f:	83 c4 20             	add    $0x20,%esp
			break;
  800852:	eb 46                	jmp    80089a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			break;
  800863:	eb 35                	jmp    80089a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800865:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80086c:	eb 2c                	jmp    80089a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80086e:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800875:	eb 23                	jmp    80089a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 25                	push   $0x25
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800887:	ff 4d 10             	decl   0x10(%ebp)
  80088a:	eb 03                	jmp    80088f <vprintfmt+0x3c3>
  80088c:	ff 4d 10             	decl   0x10(%ebp)
  80088f:	8b 45 10             	mov    0x10(%ebp),%eax
  800892:	48                   	dec    %eax
  800893:	8a 00                	mov    (%eax),%al
  800895:	3c 25                	cmp    $0x25,%al
  800897:	75 f3                	jne    80088c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800899:	90                   	nop
		}
	}
  80089a:	e9 35 fc ff ff       	jmp    8004d4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80089f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 04 fc ff ff       	call   8004cc <vprintfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008cb:	90                   	nop
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d4:	8b 40 08             	mov    0x8(%eax),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 10                	mov    (%eax),%edx
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	8b 40 04             	mov    0x4(%eax),%eax
  8008eb:	39 c2                	cmp    %eax,%edx
  8008ed:	73 12                	jae    800901 <sprintputch+0x33>
		*b->buf++ = ch;
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	89 0a                	mov    %ecx,(%edx)
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	88 10                	mov    %dl,(%eax)
}
  800901:	90                   	nop
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800910:	8b 45 0c             	mov    0xc(%ebp),%eax
  800913:	8d 50 ff             	lea    -0x1(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	01 d0                	add    %edx,%eax
  80091b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800925:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800929:	74 06                	je     800931 <vsnprintf+0x2d>
  80092b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092f:	7f 07                	jg     800938 <vsnprintf+0x34>
		return -E_INVAL;
  800931:	b8 03 00 00 00       	mov    $0x3,%eax
  800936:	eb 20                	jmp    800958 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800938:	ff 75 14             	pushl  0x14(%ebp)
  80093b:	ff 75 10             	pushl  0x10(%ebp)
  80093e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 ce 08 80 00       	push   $0x8008ce
  800947:	e8 80 fb ff ff       	call   8004cc <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80094f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800952:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800955:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800960:	8d 45 10             	lea    0x10(%ebp),%eax
  800963:	83 c0 04             	add    $0x4,%eax
  800966:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800969:	8b 45 10             	mov    0x10(%ebp),%eax
  80096c:	ff 75 f4             	pushl  -0xc(%ebp)
  80096f:	50                   	push   %eax
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 89 ff ff ff       	call   800904 <vsnprintf>
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800981:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80098c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800993:	eb 06                	jmp    80099b <strlen+0x15>
		n++;
  800995:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800998:	ff 45 08             	incl   0x8(%ebp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	84 c0                	test   %al,%al
  8009a2:	75 f1                	jne    800995 <strlen+0xf>
		n++;
	return n;
  8009a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009b6:	eb 09                	jmp    8009c1 <strnlen+0x18>
		n++;
  8009b8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bb:	ff 45 08             	incl   0x8(%ebp)
  8009be:	ff 4d 0c             	decl   0xc(%ebp)
  8009c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c5:	74 09                	je     8009d0 <strnlen+0x27>
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8a 00                	mov    (%eax),%al
  8009cc:	84 c0                	test   %al,%al
  8009ce:	75 e8                	jne    8009b8 <strnlen+0xf>
		n++;
	return n;
  8009d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009e1:	90                   	nop
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8d 50 01             	lea    0x1(%eax),%edx
  8009e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f4:	8a 12                	mov    (%edx),%dl
  8009f6:	88 10                	mov    %dl,(%eax)
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	84 c0                	test   %al,%al
  8009fc:	75 e4                	jne    8009e2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a16:	eb 1f                	jmp    800a37 <strncpy+0x34>
		*dst++ = *src;
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8d 50 01             	lea    0x1(%eax),%edx
  800a1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	8a 12                	mov    (%edx),%dl
  800a26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	84 c0                	test   %al,%al
  800a2f:	74 03                	je     800a34 <strncpy+0x31>
			src++;
  800a31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a34:	ff 45 fc             	incl   -0x4(%ebp)
  800a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a3d:	72 d9                	jb     800a18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a54:	74 30                	je     800a86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a56:	eb 16                	jmp    800a6e <strlcpy+0x2a>
			*dst++ = *src++;
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8d 50 01             	lea    0x1(%eax),%edx
  800a5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6a:	8a 12                	mov    (%edx),%dl
  800a6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a6e:	ff 4d 10             	decl   0x10(%ebp)
  800a71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a75:	74 09                	je     800a80 <strlcpy+0x3c>
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	84 c0                	test   %al,%al
  800a7e:	75 d8                	jne    800a58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a86:	8b 55 08             	mov    0x8(%ebp),%edx
  800a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8c:	29 c2                	sub    %eax,%edx
  800a8e:	89 d0                	mov    %edx,%eax
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a95:	eb 06                	jmp    800a9d <strcmp+0xb>
		p++, q++;
  800a97:	ff 45 08             	incl   0x8(%ebp)
  800a9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	84 c0                	test   %al,%al
  800aa4:	74 0e                	je     800ab4 <strcmp+0x22>
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 10                	mov    (%eax),%dl
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	38 c2                	cmp    %al,%dl
  800ab2:	74 e3                	je     800a97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	0f b6 d0             	movzbl %al,%edx
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	8a 00                	mov    (%eax),%al
  800ac1:	0f b6 c0             	movzbl %al,%eax
  800ac4:	29 c2                	sub    %eax,%edx
  800ac6:	89 d0                	mov    %edx,%eax
}
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800acd:	eb 09                	jmp    800ad8 <strncmp+0xe>
		n--, p++, q++;
  800acf:	ff 4d 10             	decl   0x10(%ebp)
  800ad2:	ff 45 08             	incl   0x8(%ebp)
  800ad5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ad8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800adc:	74 17                	je     800af5 <strncmp+0x2b>
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	84 c0                	test   %al,%al
  800ae5:	74 0e                	je     800af5 <strncmp+0x2b>
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 10                	mov    (%eax),%dl
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	38 c2                	cmp    %al,%dl
  800af3:	74 da                	je     800acf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800af5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af9:	75 07                	jne    800b02 <strncmp+0x38>
		return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
  800b00:	eb 14                	jmp    800b16 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f b6 d0             	movzbl %al,%edx
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	8a 00                	mov    (%eax),%al
  800b0f:	0f b6 c0             	movzbl %al,%eax
  800b12:	29 c2                	sub    %eax,%edx
  800b14:	89 d0                	mov    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b24:	eb 12                	jmp    800b38 <strchr+0x20>
		if (*s == c)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8a 00                	mov    (%eax),%al
  800b2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b2e:	75 05                	jne    800b35 <strchr+0x1d>
			return (char *) s;
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	eb 11                	jmp    800b46 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b35:	ff 45 08             	incl   0x8(%ebp)
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	84 c0                	test   %al,%al
  800b3f:	75 e5                	jne    800b26 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 04             	sub    $0x4,%esp
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b54:	eb 0d                	jmp    800b63 <strfind+0x1b>
		if (*s == c)
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b5e:	74 0e                	je     800b6e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b60:	ff 45 08             	incl   0x8(%ebp)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	84 c0                	test   %al,%al
  800b6a:	75 ea                	jne    800b56 <strfind+0xe>
  800b6c:	eb 01                	jmp    800b6f <strfind+0x27>
		if (*s == c)
			break;
  800b6e:	90                   	nop
	return (char *) s;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b80:	8b 45 10             	mov    0x10(%ebp),%eax
  800b83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b86:	eb 0e                	jmp    800b96 <memset+0x22>
		*p++ = c;
  800b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b94:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b96:	ff 4d f8             	decl   -0x8(%ebp)
  800b99:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b9d:	79 e9                	jns    800b88 <memset+0x14>
		*p++ = c;

	return v;
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bb6:	eb 16                	jmp    800bce <memcpy+0x2a>
		*d++ = *s++;
  800bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbb:	8d 50 01             	lea    0x1(%eax),%edx
  800bbe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bca:	8a 12                	mov    (%edx),%dl
  800bcc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd4:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	75 dd                	jne    800bb8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bf8:	73 50                	jae    800c4a <memmove+0x6a>
  800bfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800c00:	01 d0                	add    %edx,%eax
  800c02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c05:	76 43                	jbe    800c4a <memmove+0x6a>
		s += n;
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c13:	eb 10                	jmp    800c25 <memmove+0x45>
			*--d = *--s;
  800c15:	ff 4d f8             	decl   -0x8(%ebp)
  800c18:	ff 4d fc             	decl   -0x4(%ebp)
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c1e:	8a 10                	mov    (%eax),%dl
  800c20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c23:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	75 e3                	jne    800c15 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c32:	eb 23                	jmp    800c57 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c43:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c46:	8a 12                	mov    (%edx),%dl
  800c48:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	75 dd                	jne    800c34 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c6e:	eb 2a                	jmp    800c9a <memcmp+0x3e>
		if (*s1 != *s2)
  800c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c73:	8a 10                	mov    (%eax),%dl
  800c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	38 c2                	cmp    %al,%dl
  800c7c:	74 16                	je     800c94 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	0f b6 d0             	movzbl %al,%edx
  800c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	0f b6 c0             	movzbl %al,%eax
  800c8e:	29 c2                	sub    %eax,%edx
  800c90:	89 d0                	mov    %edx,%eax
  800c92:	eb 18                	jmp    800cac <memcmp+0x50>
		s1++, s2++;
  800c94:	ff 45 fc             	incl   -0x4(%ebp)
  800c97:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	75 c9                	jne    800c70 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cbf:	eb 15                	jmp    800cd6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	0f b6 d0             	movzbl %al,%edx
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	39 c2                	cmp    %eax,%edx
  800cd1:	74 0d                	je     800ce0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cd3:	ff 45 08             	incl   0x8(%ebp)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cdc:	72 e3                	jb     800cc1 <memfind+0x13>
  800cde:	eb 01                	jmp    800ce1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ce0:	90                   	nop
	return (void *) s;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cf3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfa:	eb 03                	jmp    800cff <strtol+0x19>
		s++;
  800cfc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	3c 20                	cmp    $0x20,%al
  800d06:	74 f4                	je     800cfc <strtol+0x16>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	3c 09                	cmp    $0x9,%al
  800d0f:	74 eb                	je     800cfc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	3c 2b                	cmp    $0x2b,%al
  800d18:	75 05                	jne    800d1f <strtol+0x39>
		s++;
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	eb 13                	jmp    800d32 <strtol+0x4c>
	else if (*s == '-')
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 2d                	cmp    $0x2d,%al
  800d26:	75 0a                	jne    800d32 <strtol+0x4c>
		s++, neg = 1;
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d36:	74 06                	je     800d3e <strtol+0x58>
  800d38:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d3c:	75 20                	jne    800d5e <strtol+0x78>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	3c 30                	cmp    $0x30,%al
  800d45:	75 17                	jne    800d5e <strtol+0x78>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	40                   	inc    %eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 78                	cmp    $0x78,%al
  800d4f:	75 0d                	jne    800d5e <strtol+0x78>
		s += 2, base = 16;
  800d51:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d55:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d5c:	eb 28                	jmp    800d86 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d62:	75 15                	jne    800d79 <strtol+0x93>
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	3c 30                	cmp    $0x30,%al
  800d6b:	75 0c                	jne    800d79 <strtol+0x93>
		s++, base = 8;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d77:	eb 0d                	jmp    800d86 <strtol+0xa0>
	else if (base == 0)
  800d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7d:	75 07                	jne    800d86 <strtol+0xa0>
		base = 10;
  800d7f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3c 2f                	cmp    $0x2f,%al
  800d8d:	7e 19                	jle    800da8 <strtol+0xc2>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	3c 39                	cmp    $0x39,%al
  800d96:	7f 10                	jg     800da8 <strtol+0xc2>
			dig = *s - '0';
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	0f be c0             	movsbl %al,%eax
  800da0:	83 e8 30             	sub    $0x30,%eax
  800da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800da6:	eb 42                	jmp    800dea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 60                	cmp    $0x60,%al
  800daf:	7e 19                	jle    800dca <strtol+0xe4>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	3c 7a                	cmp    $0x7a,%al
  800db8:	7f 10                	jg     800dca <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f be c0             	movsbl %al,%eax
  800dc2:	83 e8 57             	sub    $0x57,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc8:	eb 20                	jmp    800dea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 40                	cmp    $0x40,%al
  800dd1:	7e 39                	jle    800e0c <strtol+0x126>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 5a                	cmp    $0x5a,%al
  800dda:	7f 30                	jg     800e0c <strtol+0x126>
			dig = *s - 'A' + 10;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 37             	sub    $0x37,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ded:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df0:	7d 19                	jge    800e0b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dfc:	89 c2                	mov    %eax,%edx
  800dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e01:	01 d0                	add    %edx,%eax
  800e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e06:	e9 7b ff ff ff       	jmp    800d86 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e0b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e10:	74 08                	je     800e1a <strtol+0x134>
		*endptr = (char *) s;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e1e:	74 07                	je     800e27 <strtol+0x141>
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	f7 d8                	neg    %eax
  800e25:	eb 03                	jmp    800e2a <strtol+0x144>
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <ltostr>:

void
ltostr(long value, char *str)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e44:	79 13                	jns    800e59 <ltostr+0x2d>
	{
		neg = 1;
  800e46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e53:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e56:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e61:	99                   	cltd   
  800e62:	f7 f9                	idiv   %ecx
  800e64:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6a:	8d 50 01             	lea    0x1(%eax),%edx
  800e6d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	01 d0                	add    %edx,%eax
  800e77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e7a:	83 c2 30             	add    $0x30,%edx
  800e7d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e82:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e87:	f7 e9                	imul   %ecx
  800e89:	c1 fa 02             	sar    $0x2,%edx
  800e8c:	89 c8                	mov    %ecx,%eax
  800e8e:	c1 f8 1f             	sar    $0x1f,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
  800e95:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9c:	75 bb                	jne    800e59 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea8:	48                   	dec    %eax
  800ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800eac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eb0:	74 3d                	je     800eef <ltostr+0xc3>
		start = 1 ;
  800eb2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800eb9:	eb 34                	jmp    800eef <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	01 d0                	add    %edx,%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	01 c2                	add    %eax,%edx
  800ed0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	01 c8                	add    %ecx,%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	01 c2                	add    %eax,%edx
  800ee4:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ee7:	88 02                	mov    %al,(%edx)
		start++ ;
  800ee9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ef5:	7c c4                	jl     800ebb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ef7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	01 d0                	add    %edx,%eax
  800eff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f02:	90                   	nop
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 73 fa ff ff       	call   800986 <strlen>
  800f13:	83 c4 04             	add    $0x4,%esp
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f19:	ff 75 0c             	pushl  0xc(%ebp)
  800f1c:	e8 65 fa ff ff       	call   800986 <strlen>
  800f21:	83 c4 04             	add    $0x4,%esp
  800f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f35:	eb 17                	jmp    800f4e <strcconcat+0x49>
		final[s] = str1[s] ;
  800f37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	01 c2                	add    %eax,%edx
  800f3f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	01 c8                	add    %ecx,%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f4b:	ff 45 fc             	incl   -0x4(%ebp)
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f54:	7c e1                	jl     800f37 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f56:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f64:	eb 1f                	jmp    800f85 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f69:	8d 50 01             	lea    0x1(%eax),%edx
  800f6c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	8b 45 10             	mov    0x10(%ebp),%eax
  800f74:	01 c2                	add    %eax,%edx
  800f76:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	01 c8                	add    %ecx,%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f82:	ff 45 f8             	incl   -0x8(%ebp)
  800f85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c d9                	jl     800f66 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800faa:	8b 00                	mov    (%eax),%eax
  800fac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 d0                	add    %edx,%eax
  800fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fbe:	eb 0c                	jmp    800fcc <strsplit+0x31>
			*string++ = 0;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8d 50 01             	lea    0x1(%eax),%edx
  800fc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	84 c0                	test   %al,%al
  800fd3:	74 18                	je     800fed <strsplit+0x52>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	0f be c0             	movsbl %al,%eax
  800fdd:	50                   	push   %eax
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	e8 32 fb ff ff       	call   800b18 <strchr>
  800fe6:	83 c4 08             	add    $0x8,%esp
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	75 d3                	jne    800fc0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	84 c0                	test   %al,%al
  800ff4:	74 5a                	je     801050 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff9:	8b 00                	mov    (%eax),%eax
  800ffb:	83 f8 0f             	cmp    $0xf,%eax
  800ffe:	75 07                	jne    801007 <strsplit+0x6c>
		{
			return 0;
  801000:	b8 00 00 00 00       	mov    $0x0,%eax
  801005:	eb 66                	jmp    80106d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	8d 48 01             	lea    0x1(%eax),%ecx
  80100f:	8b 55 14             	mov    0x14(%ebp),%edx
  801012:	89 0a                	mov    %ecx,(%edx)
  801014:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80101b:	8b 45 10             	mov    0x10(%ebp),%eax
  80101e:	01 c2                	add    %eax,%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801025:	eb 03                	jmp    80102a <strsplit+0x8f>
			string++;
  801027:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	74 8b                	je     800fbe <strsplit+0x23>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	0f be c0             	movsbl %al,%eax
  80103b:	50                   	push   %eax
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	e8 d4 fa ff ff       	call   800b18 <strchr>
  801044:	83 c4 08             	add    $0x8,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	74 dc                	je     801027 <strsplit+0x8c>
			string++;
	}
  80104b:	e9 6e ff ff ff       	jmp    800fbe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801050:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	8b 00                	mov    (%eax),%eax
  801056:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80105d:	8b 45 10             	mov    0x10(%ebp),%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801068:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801075:	83 ec 04             	sub    $0x4,%esp
  801078:	68 88 42 80 00       	push   $0x804288
  80107d:	68 3f 01 00 00       	push   $0x13f
  801082:	68 aa 42 80 00       	push   $0x8042aa
  801087:	e8 37 09 00 00       	call   8019c3 <_panic>

0080108c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	57                   	push   %edi
  801090:	56                   	push   %esi
  801091:	53                   	push   %ebx
  801092:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80109e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010a7:	cd 30                	int    $0x30
  8010a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 04             	sub    $0x4,%esp
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	52                   	push   %edx
  8010cf:	ff 75 0c             	pushl  0xc(%ebp)
  8010d2:	50                   	push   %eax
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 b2 ff ff ff       	call   80108c <syscall>
  8010da:	83 c4 18             	add    $0x18,%esp
}
  8010dd:	90                   	nop
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 00                	push   $0x0
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 02                	push   $0x2
  8010ef:	e8 98 ff ff ff       	call   80108c <syscall>
  8010f4:	83 c4 18             	add    $0x18,%esp
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	6a 03                	push   $0x3
  801108:	e8 7f ff ff ff       	call   80108c <syscall>
  80110d:	83 c4 18             	add    $0x18,%esp
}
  801110:	90                   	nop
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801116:	6a 00                	push   $0x0
  801118:	6a 00                	push   $0x0
  80111a:	6a 00                	push   $0x0
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 04                	push   $0x4
  801122:	e8 65 ff ff ff       	call   80108c <syscall>
  801127:	83 c4 18             	add    $0x18,%esp
}
  80112a:	90                   	nop
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801130:	8b 55 0c             	mov    0xc(%ebp),%edx
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	6a 08                	push   $0x8
  801140:	e8 47 ff ff ff       	call   80108c <syscall>
  801145:	83 c4 18             	add    $0x18,%esp
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80114f:	8b 75 18             	mov    0x18(%ebp),%esi
  801152:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801155:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	51                   	push   %ecx
  801161:	52                   	push   %edx
  801162:	50                   	push   %eax
  801163:	6a 09                	push   $0x9
  801165:	e8 22 ff ff ff       	call   80108c <syscall>
  80116a:	83 c4 18             	add    $0x18,%esp
}
  80116d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801170:	5b                   	pop    %ebx
  801171:	5e                   	pop    %esi
  801172:	5d                   	pop    %ebp
  801173:	c3                   	ret    

00801174 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	52                   	push   %edx
  801184:	50                   	push   %eax
  801185:	6a 0a                	push   $0xa
  801187:	e8 00 ff ff ff       	call   80108c <syscall>
  80118c:	83 c4 18             	add    $0x18,%esp
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	6a 0b                	push   $0xb
  8011a2:	e8 e5 fe ff ff       	call   80108c <syscall>
  8011a7:	83 c4 18             	add    $0x18,%esp
}
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 0c                	push   $0xc
  8011bb:	e8 cc fe ff ff       	call   80108c <syscall>
  8011c0:	83 c4 18             	add    $0x18,%esp
}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 0d                	push   $0xd
  8011d4:	e8 b3 fe ff ff       	call   80108c <syscall>
  8011d9:	83 c4 18             	add    $0x18,%esp
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 0e                	push   $0xe
  8011ed:	e8 9a fe ff ff       	call   80108c <syscall>
  8011f2:	83 c4 18             	add    $0x18,%esp
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 00                	push   $0x0
  8011fe:	6a 00                	push   $0x0
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	6a 0f                	push   $0xf
  801206:	e8 81 fe ff ff       	call   80108c <syscall>
  80120b:	83 c4 18             	add    $0x18,%esp
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	ff 75 08             	pushl  0x8(%ebp)
  80121e:	6a 10                	push   $0x10
  801220:	e8 67 fe ff ff       	call   80108c <syscall>
  801225:	83 c4 18             	add    $0x18,%esp
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 11                	push   $0x11
  801239:	e8 4e fe ff ff       	call   80108c <syscall>
  80123e:	83 c4 18             	add    $0x18,%esp
}
  801241:	90                   	nop
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <sys_cputc>:

void
sys_cputc(const char c)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801250:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	50                   	push   %eax
  80125d:	6a 01                	push   $0x1
  80125f:	e8 28 fe ff ff       	call   80108c <syscall>
  801264:	83 c4 18             	add    $0x18,%esp
}
  801267:	90                   	nop
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	6a 00                	push   $0x0
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 14                	push   $0x14
  801279:	e8 0e fe ff ff       	call   80108c <syscall>
  80127e:	83 c4 18             	add    $0x18,%esp
}
  801281:	90                   	nop
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801290:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801293:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	6a 00                	push   $0x0
  80129c:	51                   	push   %ecx
  80129d:	52                   	push   %edx
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	50                   	push   %eax
  8012a2:	6a 15                	push   $0x15
  8012a4:	e8 e3 fd ff ff       	call   80108c <syscall>
  8012a9:	83 c4 18             	add    $0x18,%esp
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	52                   	push   %edx
  8012be:	50                   	push   %eax
  8012bf:	6a 16                	push   $0x16
  8012c1:	e8 c6 fd ff ff       	call   80108c <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	51                   	push   %ecx
  8012dc:	52                   	push   %edx
  8012dd:	50                   	push   %eax
  8012de:	6a 17                	push   $0x17
  8012e0:	e8 a7 fd ff ff       	call   80108c <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	52                   	push   %edx
  8012fa:	50                   	push   %eax
  8012fb:	6a 18                	push   $0x18
  8012fd:	e8 8a fd ff ff       	call   80108c <syscall>
  801302:	83 c4 18             	add    $0x18,%esp
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	6a 00                	push   $0x0
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	50                   	push   %eax
  801319:	6a 19                	push   $0x19
  80131b:	e8 6c fd ff ff       	call   80108c <syscall>
  801320:	83 c4 18             	add    $0x18,%esp
}
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	50                   	push   %eax
  801334:	6a 1a                	push   $0x1a
  801336:	e8 51 fd ff ff       	call   80108c <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	90                   	nop
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	50                   	push   %eax
  801350:	6a 1b                	push   $0x1b
  801352:	e8 35 fd ff ff       	call   80108c <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 05                	push   $0x5
  80136b:	e8 1c fd ff ff       	call   80108c <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 06                	push   $0x6
  801384:	e8 03 fd ff ff       	call   80108c <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 07                	push   $0x7
  80139d:	e8 ea fc ff ff       	call   80108c <syscall>
  8013a2:	83 c4 18             	add    $0x18,%esp
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 1c                	push   $0x1c
  8013b6:	e8 d1 fc ff ff       	call   80108c <syscall>
  8013bb:	83 c4 18             	add    $0x18,%esp
}
  8013be:	90                   	nop
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ca:	8d 50 04             	lea    0x4(%eax),%edx
  8013cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	52                   	push   %edx
  8013d7:	50                   	push   %eax
  8013d8:	6a 1d                	push   $0x1d
  8013da:	e8 ad fc ff ff       	call   80108c <syscall>
  8013df:	83 c4 18             	add    $0x18,%esp
	return result;
  8013e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013eb:	89 01                	mov    %eax,(%ecx)
  8013ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	c9                   	leave  
  8013f4:	c2 04 00             	ret    $0x4

008013f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	ff 75 10             	pushl  0x10(%ebp)
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	ff 75 08             	pushl  0x8(%ebp)
  801407:	6a 13                	push   $0x13
  801409:	e8 7e fc ff ff       	call   80108c <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
	return ;
  801411:	90                   	nop
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_rcr2>:
uint32 sys_rcr2()
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 1e                	push   $0x1e
  801423:	e8 64 fc ff ff       	call   80108c <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801439:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	50                   	push   %eax
  801446:	6a 1f                	push   $0x1f
  801448:	e8 3f fc ff ff       	call   80108c <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
	return ;
  801450:	90                   	nop
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <rsttst>:
void rsttst()
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 21                	push   $0x21
  801462:	e8 25 fc ff ff       	call   80108c <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
	return ;
  80146a:	90                   	nop
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 04             	sub    $0x4,%esp
  801473:	8b 45 14             	mov    0x14(%ebp),%eax
  801476:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801479:	8b 55 18             	mov    0x18(%ebp),%edx
  80147c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801480:	52                   	push   %edx
  801481:	50                   	push   %eax
  801482:	ff 75 10             	pushl  0x10(%ebp)
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	ff 75 08             	pushl  0x8(%ebp)
  80148b:	6a 20                	push   $0x20
  80148d:	e8 fa fb ff ff       	call   80108c <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
	return ;
  801495:	90                   	nop
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <chktst>:
void chktst(uint32 n)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	6a 22                	push   $0x22
  8014a8:	e8 df fb ff ff       	call   80108c <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b0:	90                   	nop
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <inctst>:

void inctst()
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 23                	push   $0x23
  8014c2:	e8 c5 fb ff ff       	call   80108c <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ca:	90                   	nop
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <gettst>:
uint32 gettst()
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 24                	push   $0x24
  8014dc:	e8 ab fb ff ff       	call   80108c <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  8014f8:	e8 8f fb ff ff       	call   80108c <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
  801500:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801503:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801507:	75 07                	jne    801510 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801509:	b8 01 00 00 00       	mov    $0x1,%eax
  80150e:	eb 05                	jmp    801515 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 25                	push   $0x25
  801529:	e8 5e fb ff ff       	call   80108c <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
  801531:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801534:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801538:	75 07                	jne    801541 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80153a:	b8 01 00 00 00       	mov    $0x1,%eax
  80153f:	eb 05                	jmp    801546 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 25                	push   $0x25
  80155a:	e8 2d fb ff ff       	call   80108c <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
  801562:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801565:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801569:	75 07                	jne    801572 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80156b:	b8 01 00 00 00       	mov    $0x1,%eax
  801570:	eb 05                	jmp    801577 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 25                	push   $0x25
  80158b:	e8 fc fa ff ff       	call   80108c <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
  801593:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801596:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80159a:	75 07                	jne    8015a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80159c:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a1:	eb 05                	jmp    8015a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	ff 75 08             	pushl  0x8(%ebp)
  8015b8:	6a 26                	push   $0x26
  8015ba:	e8 cd fa ff ff       	call   80108c <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c2:	90                   	nop
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	6a 00                	push   $0x0
  8015d7:	53                   	push   %ebx
  8015d8:	51                   	push   %ecx
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 27                	push   $0x27
  8015dd:	e8 aa fa ff ff       	call   80108c <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	6a 28                	push   $0x28
  8015fd:	e8 8a fa ff ff       	call   80108c <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80160a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	51                   	push   %ecx
  801616:	ff 75 10             	pushl  0x10(%ebp)
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	6a 29                	push   $0x29
  80161d:	e8 6a fa ff ff       	call   80108c <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	ff 75 10             	pushl  0x10(%ebp)
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	6a 12                	push   $0x12
  801639:	e8 4e fa ff ff       	call   80108c <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return ;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801647:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	52                   	push   %edx
  801654:	50                   	push   %eax
  801655:	6a 2a                	push   $0x2a
  801657:	e8 30 fa ff ff       	call   80108c <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
	return;
  80165f:	90                   	nop
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	50                   	push   %eax
  801671:	6a 2b                	push   $0x2b
  801673:	e8 14 fa ff ff       	call   80108c <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	6a 2c                	push   $0x2c
  80168e:	e8 f9 f9 ff ff       	call   80108c <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
	return;
  801696:	90                   	nop
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	6a 2d                	push   $0x2d
  8016aa:	e8 dd f9 ff ff       	call   80108c <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
	return;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 2e                	push   $0x2e
  8016c7:	e8 c0 f9 ff ff       	call   80108c <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
  8016cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	50                   	push   %eax
  8016e6:	6a 2f                	push   $0x2f
  8016e8:	e8 9f f9 ff ff       	call   80108c <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	52                   	push   %edx
  801703:	50                   	push   %eax
  801704:	6a 30                	push   $0x30
  801706:	e8 81 f9 ff ff       	call   80108c <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	50                   	push   %eax
  801723:	6a 31                	push   $0x31
  801725:	e8 62 f9 ff ff       	call   80108c <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
  80172d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801730:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	50                   	push   %eax
  801744:	6a 32                	push   $0x32
  801746:	e8 41 f9 ff ff       	call   80108c <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
	return;
  80174e:	90                   	nop
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  801757:	83 ec 04             	sub    $0x4,%esp
  80175a:	6a 01                	push   $0x1
  80175c:	6a 04                	push   $0x4
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	e8 7a 07 00 00       	call   801ee0 <smalloc>
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  80176c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801770:	75 14                	jne    801786 <create_semaphore+0x35>
  801772:	83 ec 04             	sub    $0x4,%esp
  801775:	68 b7 42 80 00       	push   $0x8042b7
  80177a:	6a 0d                	push   $0xd
  80177c:	68 d4 42 80 00       	push   $0x8042d4
  801781:	e8 3d 02 00 00       	call   8019c3 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	8b 00                	mov    (%eax),%eax
  801791:	8b 55 10             	mov    0x10(%ebp),%edx
  801794:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	50                   	push   %eax
  8017a0:	e8 32 ff ff ff       	call   8016d7 <sys_init_queue>
  8017a5:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 12                	mov    (%edx),%edx
  8017bc:	89 10                	mov    %edx,(%eax)
}
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	c9                   	leave  
  8017c2:	c2 04 00             	ret    $0x4

008017c5 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 10             	pushl  0x10(%ebp)
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	e8 ac 07 00 00       	call   801f85 <sget>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  8017df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e3:	75 14                	jne    8017f9 <get_semaphore+0x34>
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	68 e4 42 80 00       	push   $0x8042e4
  8017ed:	6a 1f                	push   $0x1f
  8017ef:	68 d4 42 80 00       	push   $0x8042d4
  8017f4:	e8 ca 01 00 00       	call   8019c3 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801805:	8b 12                	mov    (%edx),%edx
  801807:	89 10                	mov    %edx,(%eax)
}
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	c9                   	leave  
  80180d:	c2 04 00             	ret    $0x4

00801810 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  801816:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	83 c0 14             	add    $0x14,%eax
  801823:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801829:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80182c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80182f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801832:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801835:	f0 87 02             	lock xchg %eax,(%edx)
  801838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80183b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80183f:	75 dc                	jne    80181d <wait_semaphore+0xd>

		    sem.semdata->count--;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8b 50 10             	mov    0x10(%eax),%edx
  801847:	4a                   	dec    %edx
  801848:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8b 40 10             	mov    0x10(%eax),%eax
  801851:	85 c0                	test   %eax,%eax
  801853:	79 30                	jns    801885 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  801855:	e8 5b fe ff ff       	call   8016b5 <sys_get_cpu_process>
  80185a:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	ff 75 f0             	pushl  -0x10(%ebp)
  801866:	50                   	push   %eax
  801867:	e8 87 fe ff ff       	call   8016f3 <sys_enqueue>
  80186c:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  80186f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801872:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  801883:	eb 0a                	jmp    80188f <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  80188f:	90                   	nop
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  801898:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	83 c0 14             	add    $0x14,%eax
  8018a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8018b7:	f0 87 02             	lock xchg %eax,(%edx)
  8018ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018c1:	75 dc                	jne    80189f <signal_semaphore+0xd>
	    sem.semdata->count++;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 50 10             	mov    0x10(%eax),%edx
  8018c9:	42                   	inc    %edx
  8018ca:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 40 10             	mov    0x10(%eax),%eax
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	7f 20                	jg     8018f7 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	50                   	push   %eax
  8018de:	e8 2e fe ff ff       	call   801711 <sys_dequeue>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ef:	e8 41 fe ff ff       	call   801735 <sys_sched_insert_ready>
  8018f4:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801901:	90                   	nop
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	8b 40 10             	mov    0x10(%eax),%eax
}
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    

0080190f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801915:	8b 55 08             	mov    0x8(%ebp),%edx
  801918:	89 d0                	mov    %edx,%eax
  80191a:	c1 e0 02             	shl    $0x2,%eax
  80191d:	01 d0                	add    %edx,%eax
  80191f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801926:	01 d0                	add    %edx,%eax
  801928:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192f:	01 d0                	add    %edx,%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	01 d0                	add    %edx,%eax
  80193a:	c1 e0 04             	shl    $0x4,%eax
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801947:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80194a:	83 ec 0c             	sub    $0xc,%esp
  80194d:	50                   	push   %eax
  80194e:	e8 6e fa ff ff       	call   8013c1 <sys_get_virtual_time>
  801953:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801956:	eb 41                	jmp    801999 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801958:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	50                   	push   %eax
  80195f:	e8 5d fa ff ff       	call   8013c1 <sys_get_virtual_time>
  801964:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801967:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80196a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80196d:	29 c2                	sub    %eax,%edx
  80196f:	89 d0                	mov    %edx,%eax
  801971:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801974:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197a:	89 d1                	mov    %edx,%ecx
  80197c:	29 c1                	sub    %eax,%ecx
  80197e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801984:	39 c2                	cmp    %eax,%edx
  801986:	0f 97 c0             	seta   %al
  801989:	0f b6 c0             	movzbl %al,%eax
  80198c:	29 c1                	sub    %eax,%ecx
  80198e:	89 c8                	mov    %ecx,%eax
  801990:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801993:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801996:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199f:	72 b7                	jb     801958 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019b1:	eb 03                	jmp    8019b6 <busy_wait+0x12>
  8019b3:	ff 45 fc             	incl   -0x4(%ebp)
  8019b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019bc:	72 f5                	jb     8019b3 <busy_wait+0xf>
	return i;
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019c9:	8d 45 10             	lea    0x10(%ebp),%eax
  8019cc:	83 c0 04             	add    $0x4,%eax
  8019cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	74 16                	je     8019f1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019e0:	83 ec 08             	sub    $0x8,%esp
  8019e3:	50                   	push   %eax
  8019e4:	68 04 43 80 00       	push   $0x804304
  8019e9:	e8 04 e9 ff ff       	call   8002f2 <cprintf>
  8019ee:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019f1:	a1 00 50 80 00       	mov    0x805000,%eax
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	68 09 43 80 00       	push   $0x804309
  801a02:	e8 eb e8 ff ff       	call   8002f2 <cprintf>
  801a07:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	ff 75 f4             	pushl  -0xc(%ebp)
  801a13:	50                   	push   %eax
  801a14:	e8 6e e8 ff ff       	call   800287 <vcprintf>
  801a19:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	6a 00                	push   $0x0
  801a21:	68 25 43 80 00       	push   $0x804325
  801a26:	e8 5c e8 ff ff       	call   800287 <vcprintf>
  801a2b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a2e:	e8 dd e7 ff ff       	call   800210 <exit>

	// should not return here
	while (1) ;
  801a33:	eb fe                	jmp    801a33 <_panic+0x70>

00801a35 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a3b:	a1 20 50 80 00       	mov    0x805020,%eax
  801a40:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	39 c2                	cmp    %eax,%edx
  801a4b:	74 14                	je     801a61 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 28 43 80 00       	push   $0x804328
  801a55:	6a 26                	push   $0x26
  801a57:	68 74 43 80 00       	push   $0x804374
  801a5c:	e8 62 ff ff ff       	call   8019c3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a6f:	e9 c5 00 00 00       	jmp    801b39 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	01 d0                	add    %edx,%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	85 c0                	test   %eax,%eax
  801a87:	75 08                	jne    801a91 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a89:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a8c:	e9 a5 00 00 00       	jmp    801b36 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a91:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a98:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a9f:	eb 69                	jmp    801b0a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801aa1:	a1 20 50 80 00       	mov    0x805020,%eax
  801aa6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801aac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aaf:	89 d0                	mov    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d0                	add    %edx,%eax
  801ab5:	c1 e0 03             	shl    $0x3,%eax
  801ab8:	01 c8                	add    %ecx,%eax
  801aba:	8a 40 04             	mov    0x4(%eax),%al
  801abd:	84 c0                	test   %al,%al
  801abf:	75 46                	jne    801b07 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ac1:	a1 20 50 80 00       	mov    0x805020,%eax
  801ac6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801acc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	01 c0                	add    %eax,%eax
  801ad3:	01 d0                	add    %edx,%eax
  801ad5:	c1 e0 03             	shl    $0x3,%eax
  801ad8:	01 c8                	add    %ecx,%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ae7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aec:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	01 c8                	add    %ecx,%eax
  801af8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801afa:	39 c2                	cmp    %eax,%edx
  801afc:	75 09                	jne    801b07 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801afe:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b05:	eb 15                	jmp    801b1c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b07:	ff 45 e8             	incl   -0x18(%ebp)
  801b0a:	a1 20 50 80 00       	mov    0x805020,%eax
  801b0f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b18:	39 c2                	cmp    %eax,%edx
  801b1a:	77 85                	ja     801aa1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b20:	75 14                	jne    801b36 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 80 43 80 00       	push   $0x804380
  801b2a:	6a 3a                	push   $0x3a
  801b2c:	68 74 43 80 00       	push   $0x804374
  801b31:	e8 8d fe ff ff       	call   8019c3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b36:	ff 45 f0             	incl   -0x10(%ebp)
  801b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b3f:	0f 8c 2f ff ff ff    	jl     801a74 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b53:	eb 26                	jmp    801b7b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b55:	a1 20 50 80 00       	mov    0x805020,%eax
  801b5a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801b60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b63:	89 d0                	mov    %edx,%eax
  801b65:	01 c0                	add    %eax,%eax
  801b67:	01 d0                	add    %edx,%eax
  801b69:	c1 e0 03             	shl    $0x3,%eax
  801b6c:	01 c8                	add    %ecx,%eax
  801b6e:	8a 40 04             	mov    0x4(%eax),%al
  801b71:	3c 01                	cmp    $0x1,%al
  801b73:	75 03                	jne    801b78 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b75:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b78:	ff 45 e0             	incl   -0x20(%ebp)
  801b7b:	a1 20 50 80 00       	mov    0x805020,%eax
  801b80:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b89:	39 c2                	cmp    %eax,%edx
  801b8b:	77 c8                	ja     801b55 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b93:	74 14                	je     801ba9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 d4 43 80 00       	push   $0x8043d4
  801b9d:	6a 44                	push   $0x44
  801b9f:	68 74 43 80 00       	push   $0x804374
  801ba4:	e8 1a fe ff ff       	call   8019c3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ba9:	90                   	nop
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	e8 a5 fa ff ff       	call   801662 <sys_sbrk>
  801bbd:	83 c4 10             	add    $0x10,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bcc:	75 0a                	jne    801bd8 <malloc+0x16>
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd3:	e9 07 02 00 00       	jmp    801ddf <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801bd8:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  801be2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be5:	01 d0                	add    %edx,%eax
  801be7:	48                   	dec    %eax
  801be8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801beb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bee:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf3:	f7 75 dc             	divl   -0x24(%ebp)
  801bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf9:	29 d0                	sub    %edx,%eax
  801bfb:	c1 e8 0c             	shr    $0xc,%eax
  801bfe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801c01:	a1 20 50 80 00       	mov    0x805020,%eax
  801c06:	8b 40 78             	mov    0x78(%eax),%eax
  801c09:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801c0e:	29 c2                	sub    %eax,%edx
  801c10:	89 d0                	mov    %edx,%eax
  801c12:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801c15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c1d:	c1 e8 0c             	shr    $0xc,%eax
  801c20:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801c2a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c31:	77 42                	ja     801c75 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c33:	e8 ae f8 ff ff       	call   8014e6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	74 16                	je     801c52 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801c3c:	83 ec 0c             	sub    $0xc,%esp
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	e8 18 08 00 00       	call   80245f <alloc_block_FF>
  801c47:	83 c4 10             	add    $0x10,%esp
  801c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c4d:	e9 8a 01 00 00       	jmp    801ddc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801c52:	e8 c0 f8 ff ff       	call   801517 <sys_isUHeapPlacementStrategyBESTFIT>
  801c57:	85 c0                	test   %eax,%eax
  801c59:	0f 84 7d 01 00 00    	je     801ddc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	ff 75 08             	pushl  0x8(%ebp)
  801c65:	e8 b1 0c 00 00       	call   80291b <alloc_block_BF>
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c70:	e9 67 01 00 00       	jmp    801ddc <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801c75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c78:	48                   	dec    %eax
  801c79:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c7c:	0f 86 53 01 00 00    	jbe    801dd5 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801c82:	a1 20 50 80 00       	mov    0x805020,%eax
  801c87:	8b 40 78             	mov    0x78(%eax),%eax
  801c8a:	05 00 10 00 00       	add    $0x1000,%eax
  801c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801c92:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801c99:	e9 de 00 00 00       	jmp    801d7c <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801c9e:	a1 20 50 80 00       	mov    0x805020,%eax
  801ca3:	8b 40 78             	mov    0x78(%eax),%eax
  801ca6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca9:	29 c2                	sub    %eax,%edx
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cb2:	c1 e8 0c             	shr    $0xc,%eax
  801cb5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	0f 85 ab 00 00 00    	jne    801d6f <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc7:	05 00 10 00 00       	add    $0x1000,%eax
  801ccc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801ccf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801cd6:	eb 47                	jmp    801d1f <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801cd8:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801cdf:	76 0a                	jbe    801ceb <malloc+0x129>
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	e9 f4 00 00 00       	jmp    801ddf <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801ceb:	a1 20 50 80 00       	mov    0x805020,%eax
  801cf0:	8b 40 78             	mov    0x78(%eax),%eax
  801cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf6:	29 c2                	sub    %eax,%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cff:	c1 e8 0c             	shr    $0xc,%eax
  801d02:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	74 08                	je     801d15 <malloc+0x153>
					{
						
						i = j;
  801d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801d13:	eb 5a                	jmp    801d6f <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801d15:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801d1c:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d22:	48                   	dec    %eax
  801d23:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801d26:	77 b0                	ja     801cd8 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801d28:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801d2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801d36:	eb 2f                	jmp    801d67 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d3b:	c1 e0 0c             	shl    $0xc,%eax
  801d3e:	89 c2                	mov    %eax,%edx
  801d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d43:	01 c2                	add    %eax,%edx
  801d45:	a1 20 50 80 00       	mov    0x805020,%eax
  801d4a:	8b 40 78             	mov    0x78(%eax),%eax
  801d4d:	29 c2                	sub    %eax,%edx
  801d4f:	89 d0                	mov    %edx,%eax
  801d51:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d56:	c1 e8 0c             	shr    $0xc,%eax
  801d59:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801d60:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801d64:	ff 45 e0             	incl   -0x20(%ebp)
  801d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d6a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d6d:	72 c9                	jb     801d38 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801d6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d73:	75 16                	jne    801d8b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801d75:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801d7c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801d83:	0f 86 15 ff ff ff    	jbe    801c9e <malloc+0xdc>
  801d89:	eb 01                	jmp    801d8c <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801d8b:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801d8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d90:	75 07                	jne    801d99 <malloc+0x1d7>
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
  801d97:	eb 46                	jmp    801ddf <malloc+0x21d>
		ptr = (void*)i;
  801d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801d9f:	a1 20 50 80 00       	mov    0x805020,%eax
  801da4:	8b 40 78             	mov    0x78(%eax),%eax
  801da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801daa:	29 c2                	sub    %eax,%edx
  801dac:	89 d0                	mov    %edx,%eax
  801dae:	2d 00 10 00 00       	sub    $0x1000,%eax
  801db3:	c1 e8 0c             	shr    $0xc,%eax
  801db6:	89 c2                	mov    %eax,%edx
  801db8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dbb:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801dc2:	83 ec 08             	sub    $0x8,%esp
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801dcb:	e8 c9 f8 ff ff       	call   801699 <sys_allocate_user_mem>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	eb 07                	jmp    801ddc <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb 03                	jmp    801ddf <malloc+0x21d>
	}
	return ptr;
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801de7:	a1 20 50 80 00       	mov    0x805020,%eax
  801dec:	8b 40 78             	mov    0x78(%eax),%eax
  801def:	05 00 10 00 00       	add    $0x1000,%eax
  801df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801df7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801dfe:	a1 20 50 80 00       	mov    0x805020,%eax
  801e03:	8b 50 78             	mov    0x78(%eax),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	39 c2                	cmp    %eax,%edx
  801e0b:	76 24                	jbe    801e31 <free+0x50>
		size = get_block_size(va);
  801e0d:	83 ec 0c             	sub    $0xc,%esp
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	e8 c7 02 00 00       	call   8020df <get_block_size>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	e8 d7 14 00 00       	call   803300 <free_block>
  801e29:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801e2c:	e9 ac 00 00 00       	jmp    801edd <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e37:	0f 82 89 00 00 00    	jb     801ec6 <free+0xe5>
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801e45:	77 7f                	ja     801ec6 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801e47:	8b 55 08             	mov    0x8(%ebp),%edx
  801e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  801e4f:	8b 40 78             	mov    0x78(%eax),%eax
  801e52:	29 c2                	sub    %eax,%edx
  801e54:	89 d0                	mov    %edx,%eax
  801e56:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e5b:	c1 e8 0c             	shr    $0xc,%eax
  801e5e:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801e65:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e6b:	c1 e0 0c             	shl    $0xc,%eax
  801e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801e71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e78:	eb 42                	jmp    801ebc <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	c1 e0 0c             	shl    $0xc,%eax
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	01 c2                	add    %eax,%edx
  801e87:	a1 20 50 80 00       	mov    0x805020,%eax
  801e8c:	8b 40 78             	mov    0x78(%eax),%eax
  801e8f:	29 c2                	sub    %eax,%edx
  801e91:	89 d0                	mov    %edx,%eax
  801e93:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e98:	c1 e8 0c             	shr    $0xc,%eax
  801e9b:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801ea2:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	83 ec 08             	sub    $0x8,%esp
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	e8 c7 f7 ff ff       	call   80167d <sys_free_user_mem>
  801eb6:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801eb9:	ff 45 f4             	incl   -0xc(%ebp)
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ec2:	72 b6                	jb     801e7a <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801ec4:	eb 17                	jmp    801edd <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	68 20 44 80 00       	push   $0x804420
  801ece:	68 87 00 00 00       	push   $0x87
  801ed3:	68 4a 44 80 00       	push   $0x80444a
  801ed8:	e8 e6 fa ff ff       	call   8019c3 <_panic>
	}
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 28             	sub    $0x28,%esp
  801ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801eec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ef0:	75 0a                	jne    801efc <smalloc+0x1c>
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	e9 87 00 00 00       	jmp    801f83 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f02:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	39 d0                	cmp    %edx,%eax
  801f11:	73 02                	jae    801f15 <smalloc+0x35>
  801f13:	89 d0                	mov    %edx,%eax
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	50                   	push   %eax
  801f19:	e8 a4 fc ff ff       	call   801bc2 <malloc>
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801f24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f28:	75 07                	jne    801f31 <smalloc+0x51>
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	eb 52                	jmp    801f83 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801f31:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f35:	ff 75 ec             	pushl  -0x14(%ebp)
  801f38:	50                   	push   %eax
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	ff 75 08             	pushl  0x8(%ebp)
  801f3f:	e8 40 f3 ff ff       	call   801284 <sys_createSharedObject>
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801f4a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f4e:	74 06                	je     801f56 <smalloc+0x76>
  801f50:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f54:	75 07                	jne    801f5d <smalloc+0x7d>
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	eb 26                	jmp    801f83 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f60:	a1 20 50 80 00       	mov    0x805020,%eax
  801f65:	8b 40 78             	mov    0x78(%eax),%eax
  801f68:	29 c2                	sub    %eax,%edx
  801f6a:	89 d0                	mov    %edx,%eax
  801f6c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f71:	c1 e8 0c             	shr    $0xc,%eax
  801f74:	89 c2                	mov    %eax,%edx
  801f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f79:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 15 f3 ff ff       	call   8012ae <sys_getSizeOfSharedObject>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f9f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fa3:	75 07                	jne    801fac <sget+0x27>
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	eb 7f                	jmp    80202b <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fb9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	39 d0                	cmp    %edx,%eax
  801fc1:	73 02                	jae    801fc5 <sget+0x40>
  801fc3:	89 d0                	mov    %edx,%eax
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	50                   	push   %eax
  801fc9:	e8 f4 fb ff ff       	call   801bc2 <malloc>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fd8:	75 07                	jne    801fe1 <sget+0x5c>
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb 4a                	jmp    80202b <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fe7:	ff 75 0c             	pushl  0xc(%ebp)
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 d9 f2 ff ff       	call   8012cb <sys_getSharedObject>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801ff8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ffb:	a1 20 50 80 00       	mov    0x805020,%eax
  802000:	8b 40 78             	mov    0x78(%eax),%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
  802007:	2d 00 10 00 00       	sub    $0x1000,%eax
  80200c:	c1 e8 0c             	shr    $0xc,%eax
  80200f:	89 c2                	mov    %eax,%edx
  802011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802014:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80201b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80201f:	75 07                	jne    802028 <sget+0xa3>
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	eb 03                	jmp    80202b <sget+0xa6>
	return ptr;
  802028:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	a1 20 50 80 00       	mov    0x805020,%eax
  80203b:	8b 40 78             	mov    0x78(%eax),%eax
  80203e:	29 c2                	sub    %eax,%edx
  802040:	89 d0                	mov    %edx,%eax
  802042:	2d 00 10 00 00       	sub    $0x1000,%eax
  802047:	c1 e8 0c             	shr    $0xc,%eax
  80204a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802051:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	ff 75 08             	pushl  0x8(%ebp)
  80205a:	ff 75 f4             	pushl  -0xc(%ebp)
  80205d:	e8 88 f2 ff ff       	call   8012ea <sys_freeSharedObject>
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 58 44 80 00       	push   $0x804458
  802079:	68 e4 00 00 00       	push   $0xe4
  80207e:	68 4a 44 80 00       	push   $0x80444a
  802083:	e8 3b f9 ff ff       	call   8019c3 <_panic>

00802088 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	68 7e 44 80 00       	push   $0x80447e
  802096:	68 f0 00 00 00       	push   $0xf0
  80209b:	68 4a 44 80 00       	push   $0x80444a
  8020a0:	e8 1e f9 ff ff       	call   8019c3 <_panic>

008020a5 <shrink>:

}
void shrink(uint32 newSize)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	68 7e 44 80 00       	push   $0x80447e
  8020b3:	68 f5 00 00 00       	push   $0xf5
  8020b8:	68 4a 44 80 00       	push   $0x80444a
  8020bd:	e8 01 f9 ff ff       	call   8019c3 <_panic>

008020c2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	68 7e 44 80 00       	push   $0x80447e
  8020d0:	68 fa 00 00 00       	push   $0xfa
  8020d5:	68 4a 44 80 00       	push   $0x80444a
  8020da:	e8 e4 f8 ff ff       	call   8019c3 <_panic>

008020df <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	83 e8 04             	sub    $0x4,%eax
  8020eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	83 e8 04             	sub    $0x4,%eax
  802104:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	83 e0 01             	and    $0x1,%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	0f 94 c0             	sete   %al
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80211c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802123:	8b 45 0c             	mov    0xc(%ebp),%eax
  802126:	83 f8 02             	cmp    $0x2,%eax
  802129:	74 2b                	je     802156 <alloc_block+0x40>
  80212b:	83 f8 02             	cmp    $0x2,%eax
  80212e:	7f 07                	jg     802137 <alloc_block+0x21>
  802130:	83 f8 01             	cmp    $0x1,%eax
  802133:	74 0e                	je     802143 <alloc_block+0x2d>
  802135:	eb 58                	jmp    80218f <alloc_block+0x79>
  802137:	83 f8 03             	cmp    $0x3,%eax
  80213a:	74 2d                	je     802169 <alloc_block+0x53>
  80213c:	83 f8 04             	cmp    $0x4,%eax
  80213f:	74 3b                	je     80217c <alloc_block+0x66>
  802141:	eb 4c                	jmp    80218f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	e8 11 03 00 00       	call   80245f <alloc_block_FF>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802154:	eb 4a                	jmp    8021a0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	e8 c7 19 00 00       	call   803b28 <alloc_block_NF>
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802167:	eb 37                	jmp    8021a0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 08             	pushl  0x8(%ebp)
  80216f:	e8 a7 07 00 00       	call   80291b <alloc_block_BF>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80217a:	eb 24                	jmp    8021a0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	ff 75 08             	pushl  0x8(%ebp)
  802182:	e8 84 19 00 00       	call   803b0b <alloc_block_WF>
  802187:	83 c4 10             	add    $0x10,%esp
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80218d:	eb 11                	jmp    8021a0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	68 90 44 80 00       	push   $0x804490
  802197:	e8 56 e1 ff ff       	call   8002f2 <cprintf>
  80219c:	83 c4 10             	add    $0x10,%esp
		break;
  80219f:	90                   	nop
	}
	return va;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	53                   	push   %ebx
  8021a9:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	68 b0 44 80 00       	push   $0x8044b0
  8021b4:	e8 39 e1 ff ff       	call   8002f2 <cprintf>
  8021b9:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021bc:	83 ec 0c             	sub    $0xc,%esp
  8021bf:	68 db 44 80 00       	push   $0x8044db
  8021c4:	e8 29 e1 ff ff       	call   8002f2 <cprintf>
  8021c9:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d2:	eb 37                	jmp    80220b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021da:	e8 19 ff ff ff       	call   8020f8 <is_free_block>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	0f be d8             	movsbl %al,%ebx
  8021e5:	83 ec 0c             	sub    $0xc,%esp
  8021e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021eb:	e8 ef fe ff ff       	call   8020df <get_block_size>
  8021f0:	83 c4 10             	add    $0x10,%esp
  8021f3:	83 ec 04             	sub    $0x4,%esp
  8021f6:	53                   	push   %ebx
  8021f7:	50                   	push   %eax
  8021f8:	68 f3 44 80 00       	push   $0x8044f3
  8021fd:	e8 f0 e0 ff ff       	call   8002f2 <cprintf>
  802202:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802205:	8b 45 10             	mov    0x10(%ebp),%eax
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220f:	74 07                	je     802218 <print_blocks_list+0x73>
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	eb 05                	jmp    80221d <print_blocks_list+0x78>
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	89 45 10             	mov    %eax,0x10(%ebp)
  802220:	8b 45 10             	mov    0x10(%ebp),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	75 ad                	jne    8021d4 <print_blocks_list+0x2f>
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	75 a7                	jne    8021d4 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80222d:	83 ec 0c             	sub    $0xc,%esp
  802230:	68 b0 44 80 00       	push   $0x8044b0
  802235:	e8 b8 e0 ff ff       	call   8002f2 <cprintf>
  80223a:	83 c4 10             	add    $0x10,%esp

}
  80223d:	90                   	nop
  80223e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224c:	83 e0 01             	and    $0x1,%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 03                	je     802256 <initialize_dynamic_allocator+0x13>
  802253:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802256:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80225a:	0f 84 c7 01 00 00    	je     802427 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802260:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802267:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80226a:	8b 55 08             	mov    0x8(%ebp),%edx
  80226d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802270:	01 d0                	add    %edx,%eax
  802272:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802277:	0f 87 ad 01 00 00    	ja     80242a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	0f 89 a5 01 00 00    	jns    80242d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802288:	8b 55 08             	mov    0x8(%ebp),%edx
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	01 d0                	add    %edx,%eax
  802290:	83 e8 04             	sub    $0x4,%eax
  802293:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80229f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a7:	e9 87 00 00 00       	jmp    802333 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b0:	75 14                	jne    8022c6 <initialize_dynamic_allocator+0x83>
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	68 0b 45 80 00       	push   $0x80450b
  8022ba:	6a 79                	push   $0x79
  8022bc:	68 29 45 80 00       	push   $0x804529
  8022c1:	e8 fd f6 ff ff       	call   8019c3 <_panic>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 10                	je     8022df <initialize_dynamic_allocator+0x9c>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d7:	8b 52 04             	mov    0x4(%edx),%edx
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
  8022dd:	eb 0b                	jmp    8022ea <initialize_dynamic_allocator+0xa7>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 0f                	je     802303 <initialize_dynamic_allocator+0xc0>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	8b 12                	mov    (%edx),%edx
  8022ff:	89 10                	mov    %edx,(%eax)
  802301:	eb 0a                	jmp    80230d <initialize_dynamic_allocator+0xca>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802320:	a1 38 50 80 00       	mov    0x805038,%eax
  802325:	48                   	dec    %eax
  802326:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80232b:	a1 34 50 80 00       	mov    0x805034,%eax
  802330:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	74 07                	je     802340 <initialize_dynamic_allocator+0xfd>
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	eb 05                	jmp    802345 <initialize_dynamic_allocator+0x102>
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	a3 34 50 80 00       	mov    %eax,0x805034
  80234a:	a1 34 50 80 00       	mov    0x805034,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	0f 85 55 ff ff ff    	jne    8022ac <initialize_dynamic_allocator+0x69>
  802357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235b:	0f 85 4b ff ff ff    	jne    8022ac <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802370:	a1 44 50 80 00       	mov    0x805044,%eax
  802375:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80237a:	a1 40 50 80 00       	mov    0x805040,%eax
  80237f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	83 c0 08             	add    $0x8,%eax
  80238b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	83 c0 04             	add    $0x4,%eax
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	83 ea 08             	sub    $0x8,%edx
  80239a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80239c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	01 d0                	add    %edx,%eax
  8023a4:	83 e8 08             	sub    $0x8,%eax
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	83 ea 08             	sub    $0x8,%edx
  8023ad:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c6:	75 17                	jne    8023df <initialize_dynamic_allocator+0x19c>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 44 45 80 00       	push   $0x804544
  8023d0:	68 90 00 00 00       	push   $0x90
  8023d5:	68 29 45 80 00       	push   $0x804529
  8023da:	e8 e4 f5 ff ff       	call   8019c3 <_panic>
  8023df:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	89 10                	mov    %edx,(%eax)
  8023ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	74 0d                	je     802400 <initialize_dynamic_allocator+0x1bd>
  8023f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023fb:	89 50 04             	mov    %edx,0x4(%eax)
  8023fe:	eb 08                	jmp    802408 <initialize_dynamic_allocator+0x1c5>
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	a3 30 50 80 00       	mov    %eax,0x805030
  802408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241a:	a1 38 50 80 00       	mov    0x805038,%eax
  80241f:	40                   	inc    %eax
  802420:	a3 38 50 80 00       	mov    %eax,0x805038
  802425:	eb 07                	jmp    80242e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802427:	90                   	nop
  802428:	eb 04                	jmp    80242e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80242a:	90                   	nop
  80242b:	eb 01                	jmp    80242e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80242d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802433:	8b 45 10             	mov    0x10(%ebp),%eax
  802436:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80243f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802442:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	83 e8 04             	sub    $0x4,%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	83 e0 fe             	and    $0xfffffffe,%eax
  80244f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	01 c2                	add    %eax,%edx
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	89 02                	mov    %eax,(%edx)
}
  80245c:	90                   	nop
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	83 e0 01             	and    $0x1,%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 03                	je     802472 <alloc_block_FF+0x13>
  80246f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802472:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802476:	77 07                	ja     80247f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802478:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80247f:	a1 24 50 80 00       	mov    0x805024,%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	75 73                	jne    8024fb <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	83 c0 10             	add    $0x10,%eax
  80248e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802491:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249e:	01 d0                	add    %edx,%eax
  8024a0:	48                   	dec    %eax
  8024a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ac:	f7 75 ec             	divl   -0x14(%ebp)
  8024af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b2:	29 d0                	sub    %edx,%eax
  8024b4:	c1 e8 0c             	shr    $0xc,%eax
  8024b7:	83 ec 0c             	sub    $0xc,%esp
  8024ba:	50                   	push   %eax
  8024bb:	e8 ec f6 ff ff       	call   801bac <sbrk>
  8024c0:	83 c4 10             	add    $0x10,%esp
  8024c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	6a 00                	push   $0x0
  8024cb:	e8 dc f6 ff ff       	call   801bac <sbrk>
  8024d0:	83 c4 10             	add    $0x10,%esp
  8024d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024dc:	83 ec 08             	sub    $0x8,%esp
  8024df:	50                   	push   %eax
  8024e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024e3:	e8 5b fd ff ff       	call   802243 <initialize_dynamic_allocator>
  8024e8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024eb:	83 ec 0c             	sub    $0xc,%esp
  8024ee:	68 67 45 80 00       	push   $0x804567
  8024f3:	e8 fa dd ff ff       	call   8002f2 <cprintf>
  8024f8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ff:	75 0a                	jne    80250b <alloc_block_FF+0xac>
	        return NULL;
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
  802506:	e9 0e 04 00 00       	jmp    802919 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80250b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802512:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802517:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251a:	e9 f3 02 00 00       	jmp    802812 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	ff 75 bc             	pushl  -0x44(%ebp)
  80252b:	e8 af fb ff ff       	call   8020df <get_block_size>
  802530:	83 c4 10             	add    $0x10,%esp
  802533:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	83 c0 08             	add    $0x8,%eax
  80253c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80253f:	0f 87 c5 02 00 00    	ja     80280a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	83 c0 18             	add    $0x18,%eax
  80254b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80254e:	0f 87 19 02 00 00    	ja     80276d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802554:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802557:	2b 45 08             	sub    0x8(%ebp),%eax
  80255a:	83 e8 08             	sub    $0x8,%eax
  80255d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	8d 50 08             	lea    0x8(%eax),%edx
  802566:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802569:	01 d0                	add    %edx,%eax
  80256b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	83 c0 08             	add    $0x8,%eax
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	6a 01                	push   $0x1
  802579:	50                   	push   %eax
  80257a:	ff 75 bc             	pushl  -0x44(%ebp)
  80257d:	e8 ae fe ff ff       	call   802430 <set_block_data>
  802582:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 04             	mov    0x4(%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	75 68                	jne    8025f7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80258f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802593:	75 17                	jne    8025ac <alloc_block_FF+0x14d>
  802595:	83 ec 04             	sub    $0x4,%esp
  802598:	68 44 45 80 00       	push   $0x804544
  80259d:	68 d7 00 00 00       	push   $0xd7
  8025a2:	68 29 45 80 00       	push   $0x804529
  8025a7:	e8 17 f4 ff ff       	call   8019c3 <_panic>
  8025ac:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0d                	je     8025cd <alloc_block_FF+0x16e>
  8025c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025c8:	89 50 04             	mov    %edx,0x4(%eax)
  8025cb:	eb 08                	jmp    8025d5 <alloc_block_FF+0x176>
  8025cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8025d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8025ec:	40                   	inc    %eax
  8025ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8025f2:	e9 dc 00 00 00       	jmp    8026d3 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	75 65                	jne    802665 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802600:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802604:	75 17                	jne    80261d <alloc_block_FF+0x1be>
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	68 78 45 80 00       	push   $0x804578
  80260e:	68 db 00 00 00       	push   $0xdb
  802613:	68 29 45 80 00       	push   $0x804529
  802618:	e8 a6 f3 ff ff       	call   8019c3 <_panic>
  80261d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802623:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802626:	89 50 04             	mov    %edx,0x4(%eax)
  802629:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262c:	8b 40 04             	mov    0x4(%eax),%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	74 0c                	je     80263f <alloc_block_FF+0x1e0>
  802633:	a1 30 50 80 00       	mov    0x805030,%eax
  802638:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80263b:	89 10                	mov    %edx,(%eax)
  80263d:	eb 08                	jmp    802647 <alloc_block_FF+0x1e8>
  80263f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802642:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802647:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264a:	a3 30 50 80 00       	mov    %eax,0x805030
  80264f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802652:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802658:	a1 38 50 80 00       	mov    0x805038,%eax
  80265d:	40                   	inc    %eax
  80265e:	a3 38 50 80 00       	mov    %eax,0x805038
  802663:	eb 6e                	jmp    8026d3 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802669:	74 06                	je     802671 <alloc_block_FF+0x212>
  80266b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80266f:	75 17                	jne    802688 <alloc_block_FF+0x229>
  802671:	83 ec 04             	sub    $0x4,%esp
  802674:	68 9c 45 80 00       	push   $0x80459c
  802679:	68 df 00 00 00       	push   $0xdf
  80267e:	68 29 45 80 00       	push   $0x804529
  802683:	e8 3b f3 ff ff       	call   8019c3 <_panic>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 10                	mov    (%eax),%edx
  80268d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802690:	89 10                	mov    %edx,(%eax)
  802692:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	74 0b                	je     8026a6 <alloc_block_FF+0x247>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026a3:	89 50 04             	mov    %edx,0x4(%eax)
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026ac:	89 10                	mov    %edx,(%eax)
  8026ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	75 08                	jne    8026c8 <alloc_block_FF+0x269>
  8026c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8026cd:	40                   	inc    %eax
  8026ce:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	75 17                	jne    8026f0 <alloc_block_FF+0x291>
  8026d9:	83 ec 04             	sub    $0x4,%esp
  8026dc:	68 0b 45 80 00       	push   $0x80450b
  8026e1:	68 e1 00 00 00       	push   $0xe1
  8026e6:	68 29 45 80 00       	push   $0x804529
  8026eb:	e8 d3 f2 ff ff       	call   8019c3 <_panic>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 10                	je     802709 <alloc_block_FF+0x2aa>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802701:	8b 52 04             	mov    0x4(%edx),%edx
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	eb 0b                	jmp    802714 <alloc_block_FF+0x2b5>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	a3 30 50 80 00       	mov    %eax,0x805030
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	74 0f                	je     80272d <alloc_block_FF+0x2ce>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	8b 12                	mov    (%edx),%edx
  802729:	89 10                	mov    %edx,(%eax)
  80272b:	eb 0a                	jmp    802737 <alloc_block_FF+0x2d8>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274a:	a1 38 50 80 00       	mov    0x805038,%eax
  80274f:	48                   	dec    %eax
  802750:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	6a 00                	push   $0x0
  80275a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80275d:	ff 75 b0             	pushl  -0x50(%ebp)
  802760:	e8 cb fc ff ff       	call   802430 <set_block_data>
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	e9 95 00 00 00       	jmp    802802 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	6a 01                	push   $0x1
  802772:	ff 75 b8             	pushl  -0x48(%ebp)
  802775:	ff 75 bc             	pushl  -0x44(%ebp)
  802778:	e8 b3 fc ff ff       	call   802430 <set_block_data>
  80277d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802784:	75 17                	jne    80279d <alloc_block_FF+0x33e>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 0b 45 80 00       	push   $0x80450b
  80278e:	68 e8 00 00 00       	push   $0xe8
  802793:	68 29 45 80 00       	push   $0x804529
  802798:	e8 26 f2 ff ff       	call   8019c3 <_panic>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 10                	je     8027b6 <alloc_block_FF+0x357>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ae:	8b 52 04             	mov    0x4(%edx),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 0b                	jmp    8027c1 <alloc_block_FF+0x362>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0f                	je     8027da <alloc_block_FF+0x37b>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d4:	8b 12                	mov    (%edx),%edx
  8027d6:	89 10                	mov    %edx,(%eax)
  8027d8:	eb 0a                	jmp    8027e4 <alloc_block_FF+0x385>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802802:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802805:	e9 0f 01 00 00       	jmp    802919 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80280a:	a1 34 50 80 00       	mov    0x805034,%eax
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802816:	74 07                	je     80281f <alloc_block_FF+0x3c0>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	eb 05                	jmp    802824 <alloc_block_FF+0x3c5>
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	a3 34 50 80 00       	mov    %eax,0x805034
  802829:	a1 34 50 80 00       	mov    0x805034,%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	0f 85 e9 fc ff ff    	jne    80251f <alloc_block_FF+0xc0>
  802836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283a:	0f 85 df fc ff ff    	jne    80251f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	83 c0 08             	add    $0x8,%eax
  802846:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802849:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802850:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802853:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802856:	01 d0                	add    %edx,%eax
  802858:	48                   	dec    %eax
  802859:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80285c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285f:	ba 00 00 00 00       	mov    $0x0,%edx
  802864:	f7 75 d8             	divl   -0x28(%ebp)
  802867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286a:	29 d0                	sub    %edx,%eax
  80286c:	c1 e8 0c             	shr    $0xc,%eax
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	50                   	push   %eax
  802873:	e8 34 f3 ff ff       	call   801bac <sbrk>
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80287e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802882:	75 0a                	jne    80288e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
  802889:	e9 8b 00 00 00       	jmp    802919 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80288e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802895:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802898:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289b:	01 d0                	add    %edx,%eax
  80289d:	48                   	dec    %eax
  80289e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a9:	f7 75 cc             	divl   -0x34(%ebp)
  8028ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028af:	29 d0                	sub    %edx,%eax
  8028b1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028be:	a1 40 50 80 00       	mov    0x805040,%eax
  8028c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028c9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028d6:	01 d0                	add    %edx,%eax
  8028d8:	48                   	dec    %eax
  8028d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028df:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e4:	f7 75 c4             	divl   -0x3c(%ebp)
  8028e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028ea:	29 d0                	sub    %edx,%eax
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	6a 01                	push   $0x1
  8028f1:	50                   	push   %eax
  8028f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f5:	e8 36 fb ff ff       	call   802430 <set_block_data>
  8028fa:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	ff 75 d0             	pushl  -0x30(%ebp)
  802903:	e8 f8 09 00 00       	call   803300 <free_block>
  802908:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80290b:	83 ec 0c             	sub    $0xc,%esp
  80290e:	ff 75 08             	pushl  0x8(%ebp)
  802911:	e8 49 fb ff ff       	call   80245f <alloc_block_FF>
  802916:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	83 e0 01             	and    $0x1,%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 03                	je     80292e <alloc_block_BF+0x13>
  80292b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80292e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802932:	77 07                	ja     80293b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802934:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80293b:	a1 24 50 80 00       	mov    0x805024,%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	75 73                	jne    8029b7 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	83 c0 10             	add    $0x10,%eax
  80294a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80294d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802957:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295a:	01 d0                	add    %edx,%eax
  80295c:	48                   	dec    %eax
  80295d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802963:	ba 00 00 00 00       	mov    $0x0,%edx
  802968:	f7 75 e0             	divl   -0x20(%ebp)
  80296b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80296e:	29 d0                	sub    %edx,%eax
  802970:	c1 e8 0c             	shr    $0xc,%eax
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	50                   	push   %eax
  802977:	e8 30 f2 ff ff       	call   801bac <sbrk>
  80297c:	83 c4 10             	add    $0x10,%esp
  80297f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	6a 00                	push   $0x0
  802987:	e8 20 f2 ff ff       	call   801bac <sbrk>
  80298c:	83 c4 10             	add    $0x10,%esp
  80298f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802992:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802995:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802998:	83 ec 08             	sub    $0x8,%esp
  80299b:	50                   	push   %eax
  80299c:	ff 75 d8             	pushl  -0x28(%ebp)
  80299f:	e8 9f f8 ff ff       	call   802243 <initialize_dynamic_allocator>
  8029a4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029a7:	83 ec 0c             	sub    $0xc,%esp
  8029aa:	68 67 45 80 00       	push   $0x804567
  8029af:	e8 3e d9 ff ff       	call   8002f2 <cprintf>
  8029b4:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029c5:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029db:	e9 1d 01 00 00       	jmp    802afd <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029e6:	83 ec 0c             	sub    $0xc,%esp
  8029e9:	ff 75 a8             	pushl  -0x58(%ebp)
  8029ec:	e8 ee f6 ff ff       	call   8020df <get_block_size>
  8029f1:	83 c4 10             	add    $0x10,%esp
  8029f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	83 c0 08             	add    $0x8,%eax
  8029fd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a00:	0f 87 ef 00 00 00    	ja     802af5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	83 c0 18             	add    $0x18,%eax
  802a0c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0f:	77 1d                	ja     802a2e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a14:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a17:	0f 86 d8 00 00 00    	jbe    802af5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a1d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a23:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a29:	e9 c7 00 00 00       	jmp    802af5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	83 c0 08             	add    $0x8,%eax
  802a34:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a37:	0f 85 9d 00 00 00    	jne    802ada <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	6a 01                	push   $0x1
  802a42:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a45:	ff 75 a8             	pushl  -0x58(%ebp)
  802a48:	e8 e3 f9 ff ff       	call   802430 <set_block_data>
  802a4d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a54:	75 17                	jne    802a6d <alloc_block_BF+0x152>
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 0b 45 80 00       	push   $0x80450b
  802a5e:	68 2c 01 00 00       	push   $0x12c
  802a63:	68 29 45 80 00       	push   $0x804529
  802a68:	e8 56 ef ff ff       	call   8019c3 <_panic>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 10                	je     802a86 <alloc_block_BF+0x16b>
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7e:	8b 52 04             	mov    0x4(%edx),%edx
  802a81:	89 50 04             	mov    %edx,0x4(%eax)
  802a84:	eb 0b                	jmp    802a91 <alloc_block_BF+0x176>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 04             	mov    0x4(%eax),%eax
  802a8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 0f                	je     802aaa <alloc_block_BF+0x18f>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa4:	8b 12                	mov    (%edx),%edx
  802aa6:	89 10                	mov    %edx,(%eax)
  802aa8:	eb 0a                	jmp    802ab4 <alloc_block_BF+0x199>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac7:	a1 38 50 80 00       	mov    0x805038,%eax
  802acc:	48                   	dec    %eax
  802acd:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802ad2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ad5:	e9 01 04 00 00       	jmp    802edb <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ae0:	76 13                	jbe    802af5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ae2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ae9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802aef:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802af2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802af5:	a1 34 50 80 00       	mov    0x805034,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b01:	74 07                	je     802b0a <alloc_block_BF+0x1ef>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	eb 05                	jmp    802b0f <alloc_block_BF+0x1f4>
  802b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0f:	a3 34 50 80 00       	mov    %eax,0x805034
  802b14:	a1 34 50 80 00       	mov    0x805034,%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	0f 85 bf fe ff ff    	jne    8029e0 <alloc_block_BF+0xc5>
  802b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b25:	0f 85 b5 fe ff ff    	jne    8029e0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2f:	0f 84 26 02 00 00    	je     802d5b <alloc_block_BF+0x440>
  802b35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b39:	0f 85 1c 02 00 00    	jne    802d5b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	2b 45 08             	sub    0x8(%ebp),%eax
  802b45:	83 e8 08             	sub    $0x8,%eax
  802b48:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8d 50 08             	lea    0x8(%eax),%edx
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	01 d0                	add    %edx,%eax
  802b56:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	83 c0 08             	add    $0x8,%eax
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	6a 01                	push   $0x1
  802b64:	50                   	push   %eax
  802b65:	ff 75 f0             	pushl  -0x10(%ebp)
  802b68:	e8 c3 f8 ff ff       	call   802430 <set_block_data>
  802b6d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	75 68                	jne    802be2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b7a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b7e:	75 17                	jne    802b97 <alloc_block_BF+0x27c>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 44 45 80 00       	push   $0x804544
  802b88:	68 45 01 00 00       	push   $0x145
  802b8d:	68 29 45 80 00       	push   $0x804529
  802b92:	e8 2c ee ff ff       	call   8019c3 <_panic>
  802b97:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0d                	je     802bb8 <alloc_block_BF+0x29d>
  802bab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 08                	jmp    802bc0 <alloc_block_BF+0x2a5>
  802bb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bbb:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd2:	a1 38 50 80 00       	mov    0x805038,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 38 50 80 00       	mov    %eax,0x805038
  802bdd:	e9 dc 00 00 00       	jmp    802cbe <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	75 65                	jne    802c50 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802beb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bef:	75 17                	jne    802c08 <alloc_block_BF+0x2ed>
  802bf1:	83 ec 04             	sub    $0x4,%esp
  802bf4:	68 78 45 80 00       	push   $0x804578
  802bf9:	68 4a 01 00 00       	push   $0x14a
  802bfe:	68 29 45 80 00       	push   $0x804529
  802c03:	e8 bb ed ff ff       	call   8019c3 <_panic>
  802c08:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c11:	89 50 04             	mov    %edx,0x4(%eax)
  802c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0c                	je     802c2a <alloc_block_BF+0x30f>
  802c1e:	a1 30 50 80 00       	mov    0x805030,%eax
  802c23:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	eb 08                	jmp    802c32 <alloc_block_BF+0x317>
  802c2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c35:	a3 30 50 80 00       	mov    %eax,0x805030
  802c3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c43:	a1 38 50 80 00       	mov    0x805038,%eax
  802c48:	40                   	inc    %eax
  802c49:	a3 38 50 80 00       	mov    %eax,0x805038
  802c4e:	eb 6e                	jmp    802cbe <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c54:	74 06                	je     802c5c <alloc_block_BF+0x341>
  802c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c5a:	75 17                	jne    802c73 <alloc_block_BF+0x358>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 9c 45 80 00       	push   $0x80459c
  802c64:	68 4f 01 00 00       	push   $0x14f
  802c69:	68 29 45 80 00       	push   $0x804529
  802c6e:	e8 50 ed ff ff       	call   8019c3 <_panic>
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 10                	mov    (%eax),%edx
  802c78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 0b                	je     802c91 <alloc_block_BF+0x376>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c97:	89 10                	mov    %edx,(%eax)
  802c99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	75 08                	jne    802cb3 <alloc_block_BF+0x398>
  802cab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cae:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb8:	40                   	inc    %eax
  802cb9:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc2:	75 17                	jne    802cdb <alloc_block_BF+0x3c0>
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 0b 45 80 00       	push   $0x80450b
  802ccc:	68 51 01 00 00       	push   $0x151
  802cd1:	68 29 45 80 00       	push   $0x804529
  802cd6:	e8 e8 ec ff ff       	call   8019c3 <_panic>
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 10                	je     802cf4 <alloc_block_BF+0x3d9>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cec:	8b 52 04             	mov    0x4(%edx),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 0b                	jmp    802cff <alloc_block_BF+0x3e4>
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	a3 30 50 80 00       	mov    %eax,0x805030
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 0f                	je     802d18 <alloc_block_BF+0x3fd>
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d12:	8b 12                	mov    (%edx),%edx
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	eb 0a                	jmp    802d22 <alloc_block_BF+0x407>
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 38 50 80 00       	mov    0x805038,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d40:	83 ec 04             	sub    $0x4,%esp
  802d43:	6a 00                	push   $0x0
  802d45:	ff 75 d0             	pushl  -0x30(%ebp)
  802d48:	ff 75 cc             	pushl  -0x34(%ebp)
  802d4b:	e8 e0 f6 ff ff       	call   802430 <set_block_data>
  802d50:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	e9 80 01 00 00       	jmp    802edb <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802d5b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d5f:	0f 85 9d 00 00 00    	jne    802e02 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	6a 01                	push   $0x1
  802d6a:	ff 75 ec             	pushl  -0x14(%ebp)
  802d6d:	ff 75 f0             	pushl  -0x10(%ebp)
  802d70:	e8 bb f6 ff ff       	call   802430 <set_block_data>
  802d75:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7c:	75 17                	jne    802d95 <alloc_block_BF+0x47a>
  802d7e:	83 ec 04             	sub    $0x4,%esp
  802d81:	68 0b 45 80 00       	push   $0x80450b
  802d86:	68 58 01 00 00       	push   $0x158
  802d8b:	68 29 45 80 00       	push   $0x804529
  802d90:	e8 2e ec ff ff       	call   8019c3 <_panic>
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	74 10                	je     802dae <alloc_block_BF+0x493>
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da6:	8b 52 04             	mov    0x4(%edx),%edx
  802da9:	89 50 04             	mov    %edx,0x4(%eax)
  802dac:	eb 0b                	jmp    802db9 <alloc_block_BF+0x49e>
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	8b 40 04             	mov    0x4(%eax),%eax
  802db4:	a3 30 50 80 00       	mov    %eax,0x805030
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 0f                	je     802dd2 <alloc_block_BF+0x4b7>
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcc:	8b 12                	mov    (%edx),%edx
  802dce:	89 10                	mov    %edx,(%eax)
  802dd0:	eb 0a                	jmp    802ddc <alloc_block_BF+0x4c1>
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802def:	a1 38 50 80 00       	mov    0x805038,%eax
  802df4:	48                   	dec    %eax
  802df5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	e9 d9 00 00 00       	jmp    802edb <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	83 c0 08             	add    $0x8,%eax
  802e08:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e0b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e12:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e15:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e18:	01 d0                	add    %edx,%eax
  802e1a:	48                   	dec    %eax
  802e1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e1e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e21:	ba 00 00 00 00       	mov    $0x0,%edx
  802e26:	f7 75 c4             	divl   -0x3c(%ebp)
  802e29:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e2c:	29 d0                	sub    %edx,%eax
  802e2e:	c1 e8 0c             	shr    $0xc,%eax
  802e31:	83 ec 0c             	sub    $0xc,%esp
  802e34:	50                   	push   %eax
  802e35:	e8 72 ed ff ff       	call   801bac <sbrk>
  802e3a:	83 c4 10             	add    $0x10,%esp
  802e3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e40:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e44:	75 0a                	jne    802e50 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e46:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4b:	e9 8b 00 00 00       	jmp    802edb <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e50:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e57:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e5d:	01 d0                	add    %edx,%eax
  802e5f:	48                   	dec    %eax
  802e60:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e63:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e66:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6b:	f7 75 b8             	divl   -0x48(%ebp)
  802e6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e71:	29 d0                	sub    %edx,%eax
  802e73:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e76:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e79:	01 d0                	add    %edx,%eax
  802e7b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e80:	a1 40 50 80 00       	mov    0x805040,%eax
  802e85:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e8b:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e92:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e98:	01 d0                	add    %edx,%eax
  802e9a:	48                   	dec    %eax
  802e9b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e9e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea6:	f7 75 b0             	divl   -0x50(%ebp)
  802ea9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eac:	29 d0                	sub    %edx,%eax
  802eae:	83 ec 04             	sub    $0x4,%esp
  802eb1:	6a 01                	push   $0x1
  802eb3:	50                   	push   %eax
  802eb4:	ff 75 bc             	pushl  -0x44(%ebp)
  802eb7:	e8 74 f5 ff ff       	call   802430 <set_block_data>
  802ebc:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ebf:	83 ec 0c             	sub    $0xc,%esp
  802ec2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ec5:	e8 36 04 00 00       	call   803300 <free_block>
  802eca:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ecd:	83 ec 0c             	sub    $0xc,%esp
  802ed0:	ff 75 08             	pushl  0x8(%ebp)
  802ed3:	e8 43 fa ff ff       	call   80291b <alloc_block_BF>
  802ed8:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802edb:	c9                   	leave  
  802edc:	c3                   	ret    

00802edd <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	53                   	push   %ebx
  802ee1:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802eeb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ef2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef6:	74 1e                	je     802f16 <merging+0x39>
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	e8 df f1 ff ff       	call   8020df <get_block_size>
  802f00:	83 c4 04             	add    $0x4,%esp
  802f03:	89 c2                	mov    %eax,%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	01 d0                	add    %edx,%eax
  802f0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f0d:	75 07                	jne    802f16 <merging+0x39>
		prev_is_free = 1;
  802f0f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f1a:	74 1e                	je     802f3a <merging+0x5d>
  802f1c:	ff 75 10             	pushl  0x10(%ebp)
  802f1f:	e8 bb f1 ff ff       	call   8020df <get_block_size>
  802f24:	83 c4 04             	add    $0x4,%esp
  802f27:	89 c2                	mov    %eax,%edx
  802f29:	8b 45 10             	mov    0x10(%ebp),%eax
  802f2c:	01 d0                	add    %edx,%eax
  802f2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f31:	75 07                	jne    802f3a <merging+0x5d>
		next_is_free = 1;
  802f33:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3e:	0f 84 cc 00 00 00    	je     803010 <merging+0x133>
  802f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f48:	0f 84 c2 00 00 00    	je     803010 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f4e:	ff 75 08             	pushl  0x8(%ebp)
  802f51:	e8 89 f1 ff ff       	call   8020df <get_block_size>
  802f56:	83 c4 04             	add    $0x4,%esp
  802f59:	89 c3                	mov    %eax,%ebx
  802f5b:	ff 75 10             	pushl  0x10(%ebp)
  802f5e:	e8 7c f1 ff ff       	call   8020df <get_block_size>
  802f63:	83 c4 04             	add    $0x4,%esp
  802f66:	01 c3                	add    %eax,%ebx
  802f68:	ff 75 0c             	pushl  0xc(%ebp)
  802f6b:	e8 6f f1 ff ff       	call   8020df <get_block_size>
  802f70:	83 c4 04             	add    $0x4,%esp
  802f73:	01 d8                	add    %ebx,%eax
  802f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f78:	6a 00                	push   $0x0
  802f7a:	ff 75 ec             	pushl  -0x14(%ebp)
  802f7d:	ff 75 08             	pushl  0x8(%ebp)
  802f80:	e8 ab f4 ff ff       	call   802430 <set_block_data>
  802f85:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f8c:	75 17                	jne    802fa5 <merging+0xc8>
  802f8e:	83 ec 04             	sub    $0x4,%esp
  802f91:	68 0b 45 80 00       	push   $0x80450b
  802f96:	68 7d 01 00 00       	push   $0x17d
  802f9b:	68 29 45 80 00       	push   $0x804529
  802fa0:	e8 1e ea ff ff       	call   8019c3 <_panic>
  802fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 10                	je     802fbe <merging+0xe1>
  802fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb6:	8b 52 04             	mov    0x4(%edx),%edx
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	eb 0b                	jmp    802fc9 <merging+0xec>
  802fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	8b 40 04             	mov    0x4(%eax),%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	74 0f                	je     802fe2 <merging+0x105>
  802fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdc:	8b 12                	mov    (%edx),%edx
  802fde:	89 10                	mov    %edx,(%eax)
  802fe0:	eb 0a                	jmp    802fec <merging+0x10f>
  802fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fff:	a1 38 50 80 00       	mov    0x805038,%eax
  803004:	48                   	dec    %eax
  803005:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80300a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80300b:	e9 ea 02 00 00       	jmp    8032fa <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803014:	74 3b                	je     803051 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803016:	83 ec 0c             	sub    $0xc,%esp
  803019:	ff 75 08             	pushl  0x8(%ebp)
  80301c:	e8 be f0 ff ff       	call   8020df <get_block_size>
  803021:	83 c4 10             	add    $0x10,%esp
  803024:	89 c3                	mov    %eax,%ebx
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	ff 75 10             	pushl  0x10(%ebp)
  80302c:	e8 ae f0 ff ff       	call   8020df <get_block_size>
  803031:	83 c4 10             	add    $0x10,%esp
  803034:	01 d8                	add    %ebx,%eax
  803036:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	6a 00                	push   $0x0
  80303e:	ff 75 e8             	pushl  -0x18(%ebp)
  803041:	ff 75 08             	pushl  0x8(%ebp)
  803044:	e8 e7 f3 ff ff       	call   802430 <set_block_data>
  803049:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80304c:	e9 a9 02 00 00       	jmp    8032fa <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803051:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803055:	0f 84 2d 01 00 00    	je     803188 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80305b:	83 ec 0c             	sub    $0xc,%esp
  80305e:	ff 75 10             	pushl  0x10(%ebp)
  803061:	e8 79 f0 ff ff       	call   8020df <get_block_size>
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	89 c3                	mov    %eax,%ebx
  80306b:	83 ec 0c             	sub    $0xc,%esp
  80306e:	ff 75 0c             	pushl  0xc(%ebp)
  803071:	e8 69 f0 ff ff       	call   8020df <get_block_size>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	01 d8                	add    %ebx,%eax
  80307b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	6a 00                	push   $0x0
  803083:	ff 75 e4             	pushl  -0x1c(%ebp)
  803086:	ff 75 10             	pushl  0x10(%ebp)
  803089:	e8 a2 f3 ff ff       	call   802430 <set_block_data>
  80308e:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803091:	8b 45 10             	mov    0x10(%ebp),%eax
  803094:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80309b:	74 06                	je     8030a3 <merging+0x1c6>
  80309d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030a1:	75 17                	jne    8030ba <merging+0x1dd>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 d0 45 80 00       	push   $0x8045d0
  8030ab:	68 8d 01 00 00       	push   $0x18d
  8030b0:	68 29 45 80 00       	push   $0x804529
  8030b5:	e8 09 e9 ff ff       	call   8019c3 <_panic>
  8030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030bd:	8b 50 04             	mov    0x4(%eax),%edx
  8030c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0d                	je     8030e5 <merging+0x208>
  8030d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e1:	89 10                	mov    %edx,(%eax)
  8030e3:	eb 08                	jmp    8030ed <merging+0x210>
  8030e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803105:	75 17                	jne    80311e <merging+0x241>
  803107:	83 ec 04             	sub    $0x4,%esp
  80310a:	68 0b 45 80 00       	push   $0x80450b
  80310f:	68 8e 01 00 00       	push   $0x18e
  803114:	68 29 45 80 00       	push   $0x804529
  803119:	e8 a5 e8 ff ff       	call   8019c3 <_panic>
  80311e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	74 10                	je     803137 <merging+0x25a>
  803127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80312f:	8b 52 04             	mov    0x4(%edx),%edx
  803132:	89 50 04             	mov    %edx,0x4(%eax)
  803135:	eb 0b                	jmp    803142 <merging+0x265>
  803137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	a3 30 50 80 00       	mov    %eax,0x805030
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 0f                	je     80315b <merging+0x27e>
  80314c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	8b 55 0c             	mov    0xc(%ebp),%edx
  803155:	8b 12                	mov    (%edx),%edx
  803157:	89 10                	mov    %edx,(%eax)
  803159:	eb 0a                	jmp    803165 <merging+0x288>
  80315b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803165:	8b 45 0c             	mov    0xc(%ebp),%eax
  803168:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803171:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803178:	a1 38 50 80 00       	mov    0x805038,%eax
  80317d:	48                   	dec    %eax
  80317e:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803183:	e9 72 01 00 00       	jmp    8032fa <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803188:	8b 45 10             	mov    0x10(%ebp),%eax
  80318b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80318e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803192:	74 79                	je     80320d <merging+0x330>
  803194:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803198:	74 73                	je     80320d <merging+0x330>
  80319a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319e:	74 06                	je     8031a6 <merging+0x2c9>
  8031a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031a4:	75 17                	jne    8031bd <merging+0x2e0>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 9c 45 80 00       	push   $0x80459c
  8031ae:	68 94 01 00 00       	push   $0x194
  8031b3:	68 29 45 80 00       	push   $0x804529
  8031b8:	e8 06 e8 ff ff       	call   8019c3 <_panic>
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 10                	mov    (%eax),%edx
  8031c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c5:	89 10                	mov    %edx,(%eax)
  8031c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	74 0b                	je     8031db <merging+0x2fe>
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d8:	89 50 04             	mov    %edx,0x4(%eax)
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e1:	89 10                	mov    %edx,(%eax)
  8031e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	75 08                	jne    8031fd <merging+0x320>
  8031f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803202:	40                   	inc    %eax
  803203:	a3 38 50 80 00       	mov    %eax,0x805038
  803208:	e9 ce 00 00 00       	jmp    8032db <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80320d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803211:	74 65                	je     803278 <merging+0x39b>
  803213:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803217:	75 17                	jne    803230 <merging+0x353>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 78 45 80 00       	push   $0x804578
  803221:	68 95 01 00 00       	push   $0x195
  803226:	68 29 45 80 00       	push   $0x804529
  80322b:	e8 93 e7 ff ff       	call   8019c3 <_panic>
  803230:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	74 0c                	je     803252 <merging+0x375>
  803246:	a1 30 50 80 00       	mov    0x805030,%eax
  80324b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	eb 08                	jmp    80325a <merging+0x37d>
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	a3 30 50 80 00       	mov    %eax,0x805030
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326b:	a1 38 50 80 00       	mov    0x805038,%eax
  803270:	40                   	inc    %eax
  803271:	a3 38 50 80 00       	mov    %eax,0x805038
  803276:	eb 63                	jmp    8032db <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803278:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80327c:	75 17                	jne    803295 <merging+0x3b8>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 44 45 80 00       	push   $0x804544
  803286:	68 98 01 00 00       	push   $0x198
  80328b:	68 29 45 80 00       	push   $0x804529
  803290:	e8 2e e7 ff ff       	call   8019c3 <_panic>
  803295:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80329b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 0d                	je     8032b6 <merging+0x3d9>
  8032a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	eb 08                	jmp    8032be <merging+0x3e1>
  8032b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d5:	40                   	inc    %eax
  8032d6:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	ff 75 10             	pushl  0x10(%ebp)
  8032e1:	e8 f9 ed ff ff       	call   8020df <get_block_size>
  8032e6:	83 c4 10             	add    $0x10,%esp
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	6a 00                	push   $0x0
  8032ee:	50                   	push   %eax
  8032ef:	ff 75 10             	pushl  0x10(%ebp)
  8032f2:	e8 39 f1 ff ff       	call   802430 <set_block_data>
  8032f7:	83 c4 10             	add    $0x10,%esp
	}
}
  8032fa:	90                   	nop
  8032fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032fe:	c9                   	leave  
  8032ff:	c3                   	ret    

00803300 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803300:	55                   	push   %ebp
  803301:	89 e5                	mov    %esp,%ebp
  803303:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803306:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80330b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80330e:	a1 30 50 80 00       	mov    0x805030,%eax
  803313:	3b 45 08             	cmp    0x8(%ebp),%eax
  803316:	73 1b                	jae    803333 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803318:	a1 30 50 80 00       	mov    0x805030,%eax
  80331d:	83 ec 04             	sub    $0x4,%esp
  803320:	ff 75 08             	pushl  0x8(%ebp)
  803323:	6a 00                	push   $0x0
  803325:	50                   	push   %eax
  803326:	e8 b2 fb ff ff       	call   802edd <merging>
  80332b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80332e:	e9 8b 00 00 00       	jmp    8033be <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803333:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803338:	3b 45 08             	cmp    0x8(%ebp),%eax
  80333b:	76 18                	jbe    803355 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80333d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803342:	83 ec 04             	sub    $0x4,%esp
  803345:	ff 75 08             	pushl  0x8(%ebp)
  803348:	50                   	push   %eax
  803349:	6a 00                	push   $0x0
  80334b:	e8 8d fb ff ff       	call   802edd <merging>
  803350:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803353:	eb 69                	jmp    8033be <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803355:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80335a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335d:	eb 39                	jmp    803398 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	3b 45 08             	cmp    0x8(%ebp),%eax
  803365:	73 29                	jae    803390 <free_block+0x90>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80336f:	76 1f                	jbe    803390 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803379:	83 ec 04             	sub    $0x4,%esp
  80337c:	ff 75 08             	pushl  0x8(%ebp)
  80337f:	ff 75 f0             	pushl  -0x10(%ebp)
  803382:	ff 75 f4             	pushl  -0xc(%ebp)
  803385:	e8 53 fb ff ff       	call   802edd <merging>
  80338a:	83 c4 10             	add    $0x10,%esp
			break;
  80338d:	90                   	nop
		}
	}
}
  80338e:	eb 2e                	jmp    8033be <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803390:	a1 34 50 80 00       	mov    0x805034,%eax
  803395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339c:	74 07                	je     8033a5 <free_block+0xa5>
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	eb 05                	jmp    8033aa <free_block+0xaa>
  8033a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033aa:	a3 34 50 80 00       	mov    %eax,0x805034
  8033af:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	75 a7                	jne    80335f <free_block+0x5f>
  8033b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bc:	75 a1                	jne    80335f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033be:	90                   	nop
  8033bf:	c9                   	leave  
  8033c0:	c3                   	ret    

008033c1 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033c1:	55                   	push   %ebp
  8033c2:	89 e5                	mov    %esp,%ebp
  8033c4:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033c7:	ff 75 08             	pushl  0x8(%ebp)
  8033ca:	e8 10 ed ff ff       	call   8020df <get_block_size>
  8033cf:	83 c4 04             	add    $0x4,%esp
  8033d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033dc:	eb 17                	jmp    8033f5 <copy_data+0x34>
  8033de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e4:	01 c2                	add    %eax,%edx
  8033e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	01 c8                	add    %ecx,%eax
  8033ee:	8a 00                	mov    (%eax),%al
  8033f0:	88 02                	mov    %al,(%edx)
  8033f2:	ff 45 fc             	incl   -0x4(%ebp)
  8033f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033fb:	72 e1                	jb     8033de <copy_data+0x1d>
}
  8033fd:	90                   	nop
  8033fe:	c9                   	leave  
  8033ff:	c3                   	ret    

00803400 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803400:	55                   	push   %ebp
  803401:	89 e5                	mov    %esp,%ebp
  803403:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340a:	75 23                	jne    80342f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80340c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803410:	74 13                	je     803425 <realloc_block_FF+0x25>
  803412:	83 ec 0c             	sub    $0xc,%esp
  803415:	ff 75 0c             	pushl  0xc(%ebp)
  803418:	e8 42 f0 ff ff       	call   80245f <alloc_block_FF>
  80341d:	83 c4 10             	add    $0x10,%esp
  803420:	e9 e4 06 00 00       	jmp    803b09 <realloc_block_FF+0x709>
		return NULL;
  803425:	b8 00 00 00 00       	mov    $0x0,%eax
  80342a:	e9 da 06 00 00       	jmp    803b09 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80342f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803433:	75 18                	jne    80344d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803435:	83 ec 0c             	sub    $0xc,%esp
  803438:	ff 75 08             	pushl  0x8(%ebp)
  80343b:	e8 c0 fe ff ff       	call   803300 <free_block>
  803440:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803443:	b8 00 00 00 00       	mov    $0x0,%eax
  803448:	e9 bc 06 00 00       	jmp    803b09 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80344d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803451:	77 07                	ja     80345a <realloc_block_FF+0x5a>
  803453:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345d:	83 e0 01             	and    $0x1,%eax
  803460:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803463:	8b 45 0c             	mov    0xc(%ebp),%eax
  803466:	83 c0 08             	add    $0x8,%eax
  803469:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80346c:	83 ec 0c             	sub    $0xc,%esp
  80346f:	ff 75 08             	pushl  0x8(%ebp)
  803472:	e8 68 ec ff ff       	call   8020df <get_block_size>
  803477:	83 c4 10             	add    $0x10,%esp
  80347a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80347d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803480:	83 e8 08             	sub    $0x8,%eax
  803483:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	83 e8 04             	sub    $0x4,%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	83 e0 fe             	and    $0xfffffffe,%eax
  803491:	89 c2                	mov    %eax,%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	01 d0                	add    %edx,%eax
  803498:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80349b:	83 ec 0c             	sub    $0xc,%esp
  80349e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a1:	e8 39 ec ff ff       	call   8020df <get_block_size>
  8034a6:	83 c4 10             	add    $0x10,%esp
  8034a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034af:	83 e8 08             	sub    $0x8,%eax
  8034b2:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034bb:	75 08                	jne    8034c5 <realloc_block_FF+0xc5>
	{
		 return va;
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	e9 44 06 00 00       	jmp    803b09 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8034c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034cb:	0f 83 d5 03 00 00    	jae    8038a6 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034da:	83 ec 0c             	sub    $0xc,%esp
  8034dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034e0:	e8 13 ec ff ff       	call   8020f8 <is_free_block>
  8034e5:	83 c4 10             	add    $0x10,%esp
  8034e8:	84 c0                	test   %al,%al
  8034ea:	0f 84 3b 01 00 00    	je     80362b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034f6:	01 d0                	add    %edx,%eax
  8034f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	6a 01                	push   $0x1
  803500:	ff 75 f0             	pushl  -0x10(%ebp)
  803503:	ff 75 08             	pushl  0x8(%ebp)
  803506:	e8 25 ef ff ff       	call   802430 <set_block_data>
  80350b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	83 e8 04             	sub    $0x4,%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	83 e0 fe             	and    $0xfffffffe,%eax
  803519:	89 c2                	mov    %eax,%edx
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	01 d0                	add    %edx,%eax
  803520:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	6a 00                	push   $0x0
  803528:	ff 75 cc             	pushl  -0x34(%ebp)
  80352b:	ff 75 c8             	pushl  -0x38(%ebp)
  80352e:	e8 fd ee ff ff       	call   802430 <set_block_data>
  803533:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803536:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80353a:	74 06                	je     803542 <realloc_block_FF+0x142>
  80353c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803540:	75 17                	jne    803559 <realloc_block_FF+0x159>
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 9c 45 80 00       	push   $0x80459c
  80354a:	68 f6 01 00 00       	push   $0x1f6
  80354f:	68 29 45 80 00       	push   $0x804529
  803554:	e8 6a e4 ff ff       	call   8019c3 <_panic>
  803559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355c:	8b 10                	mov    (%eax),%edx
  80355e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803561:	89 10                	mov    %edx,(%eax)
  803563:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	85 c0                	test   %eax,%eax
  80356a:	74 0b                	je     803577 <realloc_block_FF+0x177>
  80356c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80357d:	89 10                	mov    %edx,(%eax)
  80357f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803582:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	85 c0                	test   %eax,%eax
  80358f:	75 08                	jne    803599 <realloc_block_FF+0x199>
  803591:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803594:	a3 30 50 80 00       	mov    %eax,0x805030
  803599:	a1 38 50 80 00       	mov    0x805038,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a8:	75 17                	jne    8035c1 <realloc_block_FF+0x1c1>
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	68 0b 45 80 00       	push   $0x80450b
  8035b2:	68 f7 01 00 00       	push   $0x1f7
  8035b7:	68 29 45 80 00       	push   $0x804529
  8035bc:	e8 02 e4 ff ff       	call   8019c3 <_panic>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	74 10                	je     8035da <realloc_block_FF+0x1da>
  8035ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d2:	8b 52 04             	mov    0x4(%edx),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	eb 0b                	jmp    8035e5 <realloc_block_FF+0x1e5>
  8035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e8:	8b 40 04             	mov    0x4(%eax),%eax
  8035eb:	85 c0                	test   %eax,%eax
  8035ed:	74 0f                	je     8035fe <realloc_block_FF+0x1fe>
  8035ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f8:	8b 12                	mov    (%edx),%edx
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	eb 0a                	jmp    803608 <realloc_block_FF+0x208>
  8035fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361b:	a1 38 50 80 00       	mov    0x805038,%eax
  803620:	48                   	dec    %eax
  803621:	a3 38 50 80 00       	mov    %eax,0x805038
  803626:	e9 73 02 00 00       	jmp    80389e <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80362b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80362f:	0f 86 69 02 00 00    	jbe    80389e <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803635:	83 ec 04             	sub    $0x4,%esp
  803638:	6a 01                	push   $0x1
  80363a:	ff 75 f0             	pushl  -0x10(%ebp)
  80363d:	ff 75 08             	pushl  0x8(%ebp)
  803640:	e8 eb ed ff ff       	call   802430 <set_block_data>
  803645:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	83 e8 04             	sub    $0x4,%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	83 e0 fe             	and    $0xfffffffe,%eax
  803653:	89 c2                	mov    %eax,%edx
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	01 d0                	add    %edx,%eax
  80365a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80365d:	a1 38 50 80 00       	mov    0x805038,%eax
  803662:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803665:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803669:	75 68                	jne    8036d3 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80366b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80366f:	75 17                	jne    803688 <realloc_block_FF+0x288>
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	68 44 45 80 00       	push   $0x804544
  803679:	68 06 02 00 00       	push   $0x206
  80367e:	68 29 45 80 00       	push   $0x804529
  803683:	e8 3b e3 ff ff       	call   8019c3 <_panic>
  803688:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80368e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803691:	89 10                	mov    %edx,(%eax)
  803693:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803696:	8b 00                	mov    (%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0d                	je     8036a9 <realloc_block_FF+0x2a9>
  80369c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a4:	89 50 04             	mov    %edx,0x4(%eax)
  8036a7:	eb 08                	jmp    8036b1 <realloc_block_FF+0x2b1>
  8036a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c8:	40                   	inc    %eax
  8036c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ce:	e9 b0 01 00 00       	jmp    803883 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036d3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036db:	76 68                	jbe    803745 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e1:	75 17                	jne    8036fa <realloc_block_FF+0x2fa>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 44 45 80 00       	push   $0x804544
  8036eb:	68 0b 02 00 00       	push   $0x20b
  8036f0:	68 29 45 80 00       	push   $0x804529
  8036f5:	e8 c9 e2 ff ff       	call   8019c3 <_panic>
  8036fa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803703:	89 10                	mov    %edx,(%eax)
  803705:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	74 0d                	je     80371b <realloc_block_FF+0x31b>
  80370e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803713:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803716:	89 50 04             	mov    %edx,0x4(%eax)
  803719:	eb 08                	jmp    803723 <realloc_block_FF+0x323>
  80371b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371e:	a3 30 50 80 00       	mov    %eax,0x805030
  803723:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803726:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80372b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803735:	a1 38 50 80 00       	mov    0x805038,%eax
  80373a:	40                   	inc    %eax
  80373b:	a3 38 50 80 00       	mov    %eax,0x805038
  803740:	e9 3e 01 00 00       	jmp    803883 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803745:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80374a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80374d:	73 68                	jae    8037b7 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80374f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803753:	75 17                	jne    80376c <realloc_block_FF+0x36c>
  803755:	83 ec 04             	sub    $0x4,%esp
  803758:	68 78 45 80 00       	push   $0x804578
  80375d:	68 10 02 00 00       	push   $0x210
  803762:	68 29 45 80 00       	push   $0x804529
  803767:	e8 57 e2 ff ff       	call   8019c3 <_panic>
  80376c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803775:	89 50 04             	mov    %edx,0x4(%eax)
  803778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377b:	8b 40 04             	mov    0x4(%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 0c                	je     80378e <realloc_block_FF+0x38e>
  803782:	a1 30 50 80 00       	mov    0x805030,%eax
  803787:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80378a:	89 10                	mov    %edx,(%eax)
  80378c:	eb 08                	jmp    803796 <realloc_block_FF+0x396>
  80378e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803791:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803799:	a3 30 50 80 00       	mov    %eax,0x805030
  80379e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ac:	40                   	inc    %eax
  8037ad:	a3 38 50 80 00       	mov    %eax,0x805038
  8037b2:	e9 cc 00 00 00       	jmp    803883 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037c6:	e9 8a 00 00 00       	jmp    803855 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ce:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037d1:	73 7a                	jae    80384d <realloc_block_FF+0x44d>
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037db:	73 70                	jae    80384d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e1:	74 06                	je     8037e9 <realloc_block_FF+0x3e9>
  8037e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037e7:	75 17                	jne    803800 <realloc_block_FF+0x400>
  8037e9:	83 ec 04             	sub    $0x4,%esp
  8037ec:	68 9c 45 80 00       	push   $0x80459c
  8037f1:	68 1a 02 00 00       	push   $0x21a
  8037f6:	68 29 45 80 00       	push   $0x804529
  8037fb:	e8 c3 e1 ff ff       	call   8019c3 <_panic>
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	8b 10                	mov    (%eax),%edx
  803805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803808:	89 10                	mov    %edx,(%eax)
  80380a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 0b                	je     80381e <realloc_block_FF+0x41e>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80381b:	89 50 04             	mov    %edx,0x4(%eax)
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803824:	89 10                	mov    %edx,(%eax)
  803826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80382c:	89 50 04             	mov    %edx,0x4(%eax)
  80382f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	75 08                	jne    803840 <realloc_block_FF+0x440>
  803838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383b:	a3 30 50 80 00       	mov    %eax,0x805030
  803840:	a1 38 50 80 00       	mov    0x805038,%eax
  803845:	40                   	inc    %eax
  803846:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80384b:	eb 36                	jmp    803883 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80384d:	a1 34 50 80 00       	mov    0x805034,%eax
  803852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803859:	74 07                	je     803862 <realloc_block_FF+0x462>
  80385b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	eb 05                	jmp    803867 <realloc_block_FF+0x467>
  803862:	b8 00 00 00 00       	mov    $0x0,%eax
  803867:	a3 34 50 80 00       	mov    %eax,0x805034
  80386c:	a1 34 50 80 00       	mov    0x805034,%eax
  803871:	85 c0                	test   %eax,%eax
  803873:	0f 85 52 ff ff ff    	jne    8037cb <realloc_block_FF+0x3cb>
  803879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387d:	0f 85 48 ff ff ff    	jne    8037cb <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803883:	83 ec 04             	sub    $0x4,%esp
  803886:	6a 00                	push   $0x0
  803888:	ff 75 d8             	pushl  -0x28(%ebp)
  80388b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80388e:	e8 9d eb ff ff       	call   802430 <set_block_data>
  803893:	83 c4 10             	add    $0x10,%esp
				return va;
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	e9 6b 02 00 00       	jmp    803b09 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	e9 63 02 00 00       	jmp    803b09 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8038a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ac:	0f 86 4d 02 00 00    	jbe    803aff <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8038b2:	83 ec 0c             	sub    $0xc,%esp
  8038b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038b8:	e8 3b e8 ff ff       	call   8020f8 <is_free_block>
  8038bd:	83 c4 10             	add    $0x10,%esp
  8038c0:	84 c0                	test   %al,%al
  8038c2:	0f 84 37 02 00 00    	je     803aff <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038cb:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038ce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038d7:	76 38                	jbe    803911 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038d9:	83 ec 0c             	sub    $0xc,%esp
  8038dc:	ff 75 0c             	pushl  0xc(%ebp)
  8038df:	e8 7b eb ff ff       	call   80245f <alloc_block_FF>
  8038e4:	83 c4 10             	add    $0x10,%esp
  8038e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038ea:	83 ec 08             	sub    $0x8,%esp
  8038ed:	ff 75 c0             	pushl  -0x40(%ebp)
  8038f0:	ff 75 08             	pushl  0x8(%ebp)
  8038f3:	e8 c9 fa ff ff       	call   8033c1 <copy_data>
  8038f8:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8038fb:	83 ec 0c             	sub    $0xc,%esp
  8038fe:	ff 75 08             	pushl  0x8(%ebp)
  803901:	e8 fa f9 ff ff       	call   803300 <free_block>
  803906:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803909:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80390c:	e9 f8 01 00 00       	jmp    803b09 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803914:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803917:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80391a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80391e:	0f 87 a0 00 00 00    	ja     8039c4 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803928:	75 17                	jne    803941 <realloc_block_FF+0x541>
  80392a:	83 ec 04             	sub    $0x4,%esp
  80392d:	68 0b 45 80 00       	push   $0x80450b
  803932:	68 38 02 00 00       	push   $0x238
  803937:	68 29 45 80 00       	push   $0x804529
  80393c:	e8 82 e0 ff ff       	call   8019c3 <_panic>
  803941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803944:	8b 00                	mov    (%eax),%eax
  803946:	85 c0                	test   %eax,%eax
  803948:	74 10                	je     80395a <realloc_block_FF+0x55a>
  80394a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803952:	8b 52 04             	mov    0x4(%edx),%edx
  803955:	89 50 04             	mov    %edx,0x4(%eax)
  803958:	eb 0b                	jmp    803965 <realloc_block_FF+0x565>
  80395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395d:	8b 40 04             	mov    0x4(%eax),%eax
  803960:	a3 30 50 80 00       	mov    %eax,0x805030
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	8b 40 04             	mov    0x4(%eax),%eax
  80396b:	85 c0                	test   %eax,%eax
  80396d:	74 0f                	je     80397e <realloc_block_FF+0x57e>
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 40 04             	mov    0x4(%eax),%eax
  803975:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803978:	8b 12                	mov    (%edx),%edx
  80397a:	89 10                	mov    %edx,(%eax)
  80397c:	eb 0a                	jmp    803988 <realloc_block_FF+0x588>
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399b:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a0:	48                   	dec    %eax
  8039a1:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ac:	01 d0                	add    %edx,%eax
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	6a 01                	push   $0x1
  8039b3:	50                   	push   %eax
  8039b4:	ff 75 08             	pushl  0x8(%ebp)
  8039b7:	e8 74 ea ff ff       	call   802430 <set_block_data>
  8039bc:	83 c4 10             	add    $0x10,%esp
  8039bf:	e9 36 01 00 00       	jmp    803afa <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039ca:	01 d0                	add    %edx,%eax
  8039cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039cf:	83 ec 04             	sub    $0x4,%esp
  8039d2:	6a 01                	push   $0x1
  8039d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8039d7:	ff 75 08             	pushl  0x8(%ebp)
  8039da:	e8 51 ea ff ff       	call   802430 <set_block_data>
  8039df:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	83 e8 04             	sub    $0x4,%eax
  8039e8:	8b 00                	mov    (%eax),%eax
  8039ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8039ed:	89 c2                	mov    %eax,%edx
  8039ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f2:	01 d0                	add    %edx,%eax
  8039f4:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fb:	74 06                	je     803a03 <realloc_block_FF+0x603>
  8039fd:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a01:	75 17                	jne    803a1a <realloc_block_FF+0x61a>
  803a03:	83 ec 04             	sub    $0x4,%esp
  803a06:	68 9c 45 80 00       	push   $0x80459c
  803a0b:	68 44 02 00 00       	push   $0x244
  803a10:	68 29 45 80 00       	push   $0x804529
  803a15:	e8 a9 df ff ff       	call   8019c3 <_panic>
  803a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1d:	8b 10                	mov    (%eax),%edx
  803a1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a22:	89 10                	mov    %edx,(%eax)
  803a24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	85 c0                	test   %eax,%eax
  803a2b:	74 0b                	je     803a38 <realloc_block_FF+0x638>
  803a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a30:	8b 00                	mov    (%eax),%eax
  803a32:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a35:	89 50 04             	mov    %edx,0x4(%eax)
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a3e:	89 10                	mov    %edx,(%eax)
  803a40:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a46:	89 50 04             	mov    %edx,0x4(%eax)
  803a49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a4c:	8b 00                	mov    (%eax),%eax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	75 08                	jne    803a5a <realloc_block_FF+0x65a>
  803a52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a55:	a3 30 50 80 00       	mov    %eax,0x805030
  803a5a:	a1 38 50 80 00       	mov    0x805038,%eax
  803a5f:	40                   	inc    %eax
  803a60:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a69:	75 17                	jne    803a82 <realloc_block_FF+0x682>
  803a6b:	83 ec 04             	sub    $0x4,%esp
  803a6e:	68 0b 45 80 00       	push   $0x80450b
  803a73:	68 45 02 00 00       	push   $0x245
  803a78:	68 29 45 80 00       	push   $0x804529
  803a7d:	e8 41 df ff ff       	call   8019c3 <_panic>
  803a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a85:	8b 00                	mov    (%eax),%eax
  803a87:	85 c0                	test   %eax,%eax
  803a89:	74 10                	je     803a9b <realloc_block_FF+0x69b>
  803a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8e:	8b 00                	mov    (%eax),%eax
  803a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a93:	8b 52 04             	mov    0x4(%edx),%edx
  803a96:	89 50 04             	mov    %edx,0x4(%eax)
  803a99:	eb 0b                	jmp    803aa6 <realloc_block_FF+0x6a6>
  803a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9e:	8b 40 04             	mov    0x4(%eax),%eax
  803aa1:	a3 30 50 80 00       	mov    %eax,0x805030
  803aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa9:	8b 40 04             	mov    0x4(%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	74 0f                	je     803abf <realloc_block_FF+0x6bf>
  803ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab3:	8b 40 04             	mov    0x4(%eax),%eax
  803ab6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab9:	8b 12                	mov    (%edx),%edx
  803abb:	89 10                	mov    %edx,(%eax)
  803abd:	eb 0a                	jmp    803ac9 <realloc_block_FF+0x6c9>
  803abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adc:	a1 38 50 80 00       	mov    0x805038,%eax
  803ae1:	48                   	dec    %eax
  803ae2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803ae7:	83 ec 04             	sub    $0x4,%esp
  803aea:	6a 00                	push   $0x0
  803aec:	ff 75 bc             	pushl  -0x44(%ebp)
  803aef:	ff 75 b8             	pushl  -0x48(%ebp)
  803af2:	e8 39 e9 ff ff       	call   802430 <set_block_data>
  803af7:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803afa:	8b 45 08             	mov    0x8(%ebp),%eax
  803afd:	eb 0a                	jmp    803b09 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803aff:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b09:	c9                   	leave  
  803b0a:	c3                   	ret    

00803b0b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b0b:	55                   	push   %ebp
  803b0c:	89 e5                	mov    %esp,%ebp
  803b0e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 08 46 80 00       	push   $0x804608
  803b19:	68 58 02 00 00       	push   $0x258
  803b1e:	68 29 45 80 00       	push   $0x804529
  803b23:	e8 9b de ff ff       	call   8019c3 <_panic>

00803b28 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b28:	55                   	push   %ebp
  803b29:	89 e5                	mov    %esp,%ebp
  803b2b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b2e:	83 ec 04             	sub    $0x4,%esp
  803b31:	68 30 46 80 00       	push   $0x804630
  803b36:	68 61 02 00 00       	push   $0x261
  803b3b:	68 29 45 80 00       	push   $0x804529
  803b40:	e8 7e de ff ff       	call   8019c3 <_panic>
  803b45:	66 90                	xchg   %ax,%ax
  803b47:	90                   	nop

00803b48 <__udivdi3>:
  803b48:	55                   	push   %ebp
  803b49:	57                   	push   %edi
  803b4a:	56                   	push   %esi
  803b4b:	53                   	push   %ebx
  803b4c:	83 ec 1c             	sub    $0x1c,%esp
  803b4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b5f:	89 ca                	mov    %ecx,%edx
  803b61:	89 f8                	mov    %edi,%eax
  803b63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b67:	85 f6                	test   %esi,%esi
  803b69:	75 2d                	jne    803b98 <__udivdi3+0x50>
  803b6b:	39 cf                	cmp    %ecx,%edi
  803b6d:	77 65                	ja     803bd4 <__udivdi3+0x8c>
  803b6f:	89 fd                	mov    %edi,%ebp
  803b71:	85 ff                	test   %edi,%edi
  803b73:	75 0b                	jne    803b80 <__udivdi3+0x38>
  803b75:	b8 01 00 00 00       	mov    $0x1,%eax
  803b7a:	31 d2                	xor    %edx,%edx
  803b7c:	f7 f7                	div    %edi
  803b7e:	89 c5                	mov    %eax,%ebp
  803b80:	31 d2                	xor    %edx,%edx
  803b82:	89 c8                	mov    %ecx,%eax
  803b84:	f7 f5                	div    %ebp
  803b86:	89 c1                	mov    %eax,%ecx
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f5                	div    %ebp
  803b8c:	89 cf                	mov    %ecx,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	39 ce                	cmp    %ecx,%esi
  803b9a:	77 28                	ja     803bc4 <__udivdi3+0x7c>
  803b9c:	0f bd fe             	bsr    %esi,%edi
  803b9f:	83 f7 1f             	xor    $0x1f,%edi
  803ba2:	75 40                	jne    803be4 <__udivdi3+0x9c>
  803ba4:	39 ce                	cmp    %ecx,%esi
  803ba6:	72 0a                	jb     803bb2 <__udivdi3+0x6a>
  803ba8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bac:	0f 87 9e 00 00 00    	ja     803c50 <__udivdi3+0x108>
  803bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb7:	89 fa                	mov    %edi,%edx
  803bb9:	83 c4 1c             	add    $0x1c,%esp
  803bbc:	5b                   	pop    %ebx
  803bbd:	5e                   	pop    %esi
  803bbe:	5f                   	pop    %edi
  803bbf:	5d                   	pop    %ebp
  803bc0:	c3                   	ret    
  803bc1:	8d 76 00             	lea    0x0(%esi),%esi
  803bc4:	31 ff                	xor    %edi,%edi
  803bc6:	31 c0                	xor    %eax,%eax
  803bc8:	89 fa                	mov    %edi,%edx
  803bca:	83 c4 1c             	add    $0x1c,%esp
  803bcd:	5b                   	pop    %ebx
  803bce:	5e                   	pop    %esi
  803bcf:	5f                   	pop    %edi
  803bd0:	5d                   	pop    %ebp
  803bd1:	c3                   	ret    
  803bd2:	66 90                	xchg   %ax,%ax
  803bd4:	89 d8                	mov    %ebx,%eax
  803bd6:	f7 f7                	div    %edi
  803bd8:	31 ff                	xor    %edi,%edi
  803bda:	89 fa                	mov    %edi,%edx
  803bdc:	83 c4 1c             	add    $0x1c,%esp
  803bdf:	5b                   	pop    %ebx
  803be0:	5e                   	pop    %esi
  803be1:	5f                   	pop    %edi
  803be2:	5d                   	pop    %ebp
  803be3:	c3                   	ret    
  803be4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803be9:	89 eb                	mov    %ebp,%ebx
  803beb:	29 fb                	sub    %edi,%ebx
  803bed:	89 f9                	mov    %edi,%ecx
  803bef:	d3 e6                	shl    %cl,%esi
  803bf1:	89 c5                	mov    %eax,%ebp
  803bf3:	88 d9                	mov    %bl,%cl
  803bf5:	d3 ed                	shr    %cl,%ebp
  803bf7:	89 e9                	mov    %ebp,%ecx
  803bf9:	09 f1                	or     %esi,%ecx
  803bfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bff:	89 f9                	mov    %edi,%ecx
  803c01:	d3 e0                	shl    %cl,%eax
  803c03:	89 c5                	mov    %eax,%ebp
  803c05:	89 d6                	mov    %edx,%esi
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 ee                	shr    %cl,%esi
  803c0b:	89 f9                	mov    %edi,%ecx
  803c0d:	d3 e2                	shl    %cl,%edx
  803c0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 e8                	shr    %cl,%eax
  803c17:	09 c2                	or     %eax,%edx
  803c19:	89 d0                	mov    %edx,%eax
  803c1b:	89 f2                	mov    %esi,%edx
  803c1d:	f7 74 24 0c          	divl   0xc(%esp)
  803c21:	89 d6                	mov    %edx,%esi
  803c23:	89 c3                	mov    %eax,%ebx
  803c25:	f7 e5                	mul    %ebp
  803c27:	39 d6                	cmp    %edx,%esi
  803c29:	72 19                	jb     803c44 <__udivdi3+0xfc>
  803c2b:	74 0b                	je     803c38 <__udivdi3+0xf0>
  803c2d:	89 d8                	mov    %ebx,%eax
  803c2f:	31 ff                	xor    %edi,%edi
  803c31:	e9 58 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c3c:	89 f9                	mov    %edi,%ecx
  803c3e:	d3 e2                	shl    %cl,%edx
  803c40:	39 c2                	cmp    %eax,%edx
  803c42:	73 e9                	jae    803c2d <__udivdi3+0xe5>
  803c44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c47:	31 ff                	xor    %edi,%edi
  803c49:	e9 40 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	31 c0                	xor    %eax,%eax
  803c52:	e9 37 ff ff ff       	jmp    803b8e <__udivdi3+0x46>
  803c57:	90                   	nop

00803c58 <__umoddi3>:
  803c58:	55                   	push   %ebp
  803c59:	57                   	push   %edi
  803c5a:	56                   	push   %esi
  803c5b:	53                   	push   %ebx
  803c5c:	83 ec 1c             	sub    $0x1c,%esp
  803c5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c77:	89 f3                	mov    %esi,%ebx
  803c79:	89 fa                	mov    %edi,%edx
  803c7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7f:	89 34 24             	mov    %esi,(%esp)
  803c82:	85 c0                	test   %eax,%eax
  803c84:	75 1a                	jne    803ca0 <__umoddi3+0x48>
  803c86:	39 f7                	cmp    %esi,%edi
  803c88:	0f 86 a2 00 00 00    	jbe    803d30 <__umoddi3+0xd8>
  803c8e:	89 c8                	mov    %ecx,%eax
  803c90:	89 f2                	mov    %esi,%edx
  803c92:	f7 f7                	div    %edi
  803c94:	89 d0                	mov    %edx,%eax
  803c96:	31 d2                	xor    %edx,%edx
  803c98:	83 c4 1c             	add    $0x1c,%esp
  803c9b:	5b                   	pop    %ebx
  803c9c:	5e                   	pop    %esi
  803c9d:	5f                   	pop    %edi
  803c9e:	5d                   	pop    %ebp
  803c9f:	c3                   	ret    
  803ca0:	39 f0                	cmp    %esi,%eax
  803ca2:	0f 87 ac 00 00 00    	ja     803d54 <__umoddi3+0xfc>
  803ca8:	0f bd e8             	bsr    %eax,%ebp
  803cab:	83 f5 1f             	xor    $0x1f,%ebp
  803cae:	0f 84 ac 00 00 00    	je     803d60 <__umoddi3+0x108>
  803cb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cb9:	29 ef                	sub    %ebp,%edi
  803cbb:	89 fe                	mov    %edi,%esi
  803cbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cc1:	89 e9                	mov    %ebp,%ecx
  803cc3:	d3 e0                	shl    %cl,%eax
  803cc5:	89 d7                	mov    %edx,%edi
  803cc7:	89 f1                	mov    %esi,%ecx
  803cc9:	d3 ef                	shr    %cl,%edi
  803ccb:	09 c7                	or     %eax,%edi
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 e2                	shl    %cl,%edx
  803cd1:	89 14 24             	mov    %edx,(%esp)
  803cd4:	89 d8                	mov    %ebx,%eax
  803cd6:	d3 e0                	shl    %cl,%eax
  803cd8:	89 c2                	mov    %eax,%edx
  803cda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cde:	d3 e0                	shl    %cl,%eax
  803ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce8:	89 f1                	mov    %esi,%ecx
  803cea:	d3 e8                	shr    %cl,%eax
  803cec:	09 d0                	or     %edx,%eax
  803cee:	d3 eb                	shr    %cl,%ebx
  803cf0:	89 da                	mov    %ebx,%edx
  803cf2:	f7 f7                	div    %edi
  803cf4:	89 d3                	mov    %edx,%ebx
  803cf6:	f7 24 24             	mull   (%esp)
  803cf9:	89 c6                	mov    %eax,%esi
  803cfb:	89 d1                	mov    %edx,%ecx
  803cfd:	39 d3                	cmp    %edx,%ebx
  803cff:	0f 82 87 00 00 00    	jb     803d8c <__umoddi3+0x134>
  803d05:	0f 84 91 00 00 00    	je     803d9c <__umoddi3+0x144>
  803d0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d0f:	29 f2                	sub    %esi,%edx
  803d11:	19 cb                	sbb    %ecx,%ebx
  803d13:	89 d8                	mov    %ebx,%eax
  803d15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d19:	d3 e0                	shl    %cl,%eax
  803d1b:	89 e9                	mov    %ebp,%ecx
  803d1d:	d3 ea                	shr    %cl,%edx
  803d1f:	09 d0                	or     %edx,%eax
  803d21:	89 e9                	mov    %ebp,%ecx
  803d23:	d3 eb                	shr    %cl,%ebx
  803d25:	89 da                	mov    %ebx,%edx
  803d27:	83 c4 1c             	add    $0x1c,%esp
  803d2a:	5b                   	pop    %ebx
  803d2b:	5e                   	pop    %esi
  803d2c:	5f                   	pop    %edi
  803d2d:	5d                   	pop    %ebp
  803d2e:	c3                   	ret    
  803d2f:	90                   	nop
  803d30:	89 fd                	mov    %edi,%ebp
  803d32:	85 ff                	test   %edi,%edi
  803d34:	75 0b                	jne    803d41 <__umoddi3+0xe9>
  803d36:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3b:	31 d2                	xor    %edx,%edx
  803d3d:	f7 f7                	div    %edi
  803d3f:	89 c5                	mov    %eax,%ebp
  803d41:	89 f0                	mov    %esi,%eax
  803d43:	31 d2                	xor    %edx,%edx
  803d45:	f7 f5                	div    %ebp
  803d47:	89 c8                	mov    %ecx,%eax
  803d49:	f7 f5                	div    %ebp
  803d4b:	89 d0                	mov    %edx,%eax
  803d4d:	e9 44 ff ff ff       	jmp    803c96 <__umoddi3+0x3e>
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	89 c8                	mov    %ecx,%eax
  803d56:	89 f2                	mov    %esi,%edx
  803d58:	83 c4 1c             	add    $0x1c,%esp
  803d5b:	5b                   	pop    %ebx
  803d5c:	5e                   	pop    %esi
  803d5d:	5f                   	pop    %edi
  803d5e:	5d                   	pop    %ebp
  803d5f:	c3                   	ret    
  803d60:	3b 04 24             	cmp    (%esp),%eax
  803d63:	72 06                	jb     803d6b <__umoddi3+0x113>
  803d65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d69:	77 0f                	ja     803d7a <__umoddi3+0x122>
  803d6b:	89 f2                	mov    %esi,%edx
  803d6d:	29 f9                	sub    %edi,%ecx
  803d6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d73:	89 14 24             	mov    %edx,(%esp)
  803d76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d7e:	8b 14 24             	mov    (%esp),%edx
  803d81:	83 c4 1c             	add    $0x1c,%esp
  803d84:	5b                   	pop    %ebx
  803d85:	5e                   	pop    %esi
  803d86:	5f                   	pop    %edi
  803d87:	5d                   	pop    %ebp
  803d88:	c3                   	ret    
  803d89:	8d 76 00             	lea    0x0(%esi),%esi
  803d8c:	2b 04 24             	sub    (%esp),%eax
  803d8f:	19 fa                	sbb    %edi,%edx
  803d91:	89 d1                	mov    %edx,%ecx
  803d93:	89 c6                	mov    %eax,%esi
  803d95:	e9 71 ff ff ff       	jmp    803d0b <__umoddi3+0xb3>
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803da0:	72 ea                	jb     803d8c <__umoddi3+0x134>
  803da2:	89 d9                	mov    %ebx,%ecx
  803da4:	e9 62 ff ff ff       	jmp    803d0b <__umoddi3+0xb3>
