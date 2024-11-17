
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
  80003e:	e8 2a 13 00 00       	call   80136d <sys_getenvindex>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800046:	e8 3b 13 00 00       	call   801386 <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("Cust %d: outside the shop\n", id);
	struct semaphore shopCapacitySem = get_semaphore(parentenvID, "shopCapacity");
  80004e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 1c 80 00       	push   $0x801c40
  800059:	ff 75 f0             	pushl  -0x10(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 65 16 00 00       	call   8016c7 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = get_semaphore(parentenvID, "depend");
  800065:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 4d 1c 80 00       	push   $0x801c4d
  800070:	ff 75 f0             	pushl  -0x10(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 4e 16 00 00       	call   8016c7 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(shopCapacitySem);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 ec             	pushl  -0x14(%ebp)
  800082:	e8 5a 16 00 00       	call   8016e1 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Cust %d: inside the shop\n", id) ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	ff 75 f4             	pushl  -0xc(%ebp)
  800090:	68 54 1c 80 00       	push   $0x801c54
  800095:	e8 50 02 00 00       	call   8002ea <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 e8 03 00 00       	push   $0x3e8
  8000a5:	e8 76 16 00 00       	call   801720 <env_sleep>
  8000aa:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(shopCapacitySem);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b3:	e8 43 16 00 00       	call   8016fb <signal_semaphore>
  8000b8:	83 c4 10             	add    $0x10,%esp

	cprintf("Cust %d: exit the shop\n", id);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c1:	68 6e 1c 80 00       	push   $0x801c6e
  8000c6:	e8 1f 02 00 00       	call   8002ea <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(dependSem);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d4:	e8 22 16 00 00       	call   8016fb <signal_semaphore>
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
  8000e5:	e8 83 12 00 00       	call   80136d <sys_getenvindex>
  8000ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f0:	89 d0                	mov    %edx,%eax
  8000f2:	c1 e0 02             	shl    $0x2,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	01 c0                	add    %eax,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	c1 e0 02             	shl    $0x2,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	01 c0                	add    %eax,%eax
  800102:	01 d0                	add    %edx,%eax
  800104:	c1 e0 04             	shl    $0x4,%eax
  800107:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010c:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800111:	a1 04 30 80 00       	mov    0x803004,%eax
  800116:	8a 40 20             	mov    0x20(%eax),%al
  800119:	84 c0                	test   %al,%al
  80011b:	74 0d                	je     80012a <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80011d:	a1 04 30 80 00       	mov    0x803004,%eax
  800122:	83 c0 20             	add    $0x20,%eax
  800125:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012e:	7e 0a                	jle    80013a <libmain+0x5b>
		binaryname = argv[0];
  800130:	8b 45 0c             	mov    0xc(%ebp),%eax
  800133:	8b 00                	mov    (%eax),%eax
  800135:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	ff 75 0c             	pushl  0xc(%ebp)
  800140:	ff 75 08             	pushl  0x8(%ebp)
  800143:	e8 f0 fe ff ff       	call   800038 <_main>
  800148:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80014b:	e8 a1 0f 00 00       	call   8010f1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 a0 1c 80 00       	push   $0x801ca0
  800158:	e8 8d 01 00 00       	call   8002ea <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800160:	a1 04 30 80 00       	mov    0x803004,%eax
  800165:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80016b:	a1 04 30 80 00       	mov    0x803004,%eax
  800170:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800176:	83 ec 04             	sub    $0x4,%esp
  800179:	52                   	push   %edx
  80017a:	50                   	push   %eax
  80017b:	68 c8 1c 80 00       	push   $0x801cc8
  800180:	e8 65 01 00 00       	call   8002ea <cprintf>
  800185:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800188:	a1 04 30 80 00       	mov    0x803004,%eax
  80018d:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800193:	a1 04 30 80 00       	mov    0x803004,%eax
  800198:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80019e:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a3:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001a9:	51                   	push   %ecx
  8001aa:	52                   	push   %edx
  8001ab:	50                   	push   %eax
  8001ac:	68 f0 1c 80 00       	push   $0x801cf0
  8001b1:	e8 34 01 00 00       	call   8002ea <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001be:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	50                   	push   %eax
  8001c8:	68 48 1d 80 00       	push   $0x801d48
  8001cd:	e8 18 01 00 00       	call   8002ea <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 a0 1c 80 00       	push   $0x801ca0
  8001dd:	e8 08 01 00 00       	call   8002ea <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001e5:	e8 21 0f 00 00       	call   80110b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001ea:	e8 19 00 00 00       	call   800208 <exit>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	e8 37 11 00 00       	call   801339 <sys_destroy_env>
  800202:	83 c4 10             	add    $0x10,%esp
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <exit>:

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020e:	e8 8c 11 00 00       	call   80139f <sys_exit_env>
}
  800213:	90                   	nop
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021f:	8b 00                	mov    (%eax),%eax
  800221:	8d 48 01             	lea    0x1(%eax),%ecx
  800224:	8b 55 0c             	mov    0xc(%ebp),%edx
  800227:	89 0a                	mov    %ecx,(%edx)
  800229:	8b 55 08             	mov    0x8(%ebp),%edx
  80022c:	88 d1                	mov    %dl,%cl
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800235:	8b 45 0c             	mov    0xc(%ebp),%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023f:	75 2c                	jne    80026d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800241:	a0 08 30 80 00       	mov    0x803008,%al
  800246:	0f b6 c0             	movzbl %al,%eax
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	8b 12                	mov    (%edx),%edx
  80024e:	89 d1                	mov    %edx,%ecx
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	83 c2 08             	add    $0x8,%edx
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	50                   	push   %eax
  80025a:	51                   	push   %ecx
  80025b:	52                   	push   %edx
  80025c:	e8 4e 0e 00 00       	call   8010af <sys_cputs>
  800261:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800264:	8b 45 0c             	mov    0xc(%ebp),%eax
  800267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80026d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800270:	8b 40 04             	mov    0x4(%eax),%eax
  800273:	8d 50 01             	lea    0x1(%eax),%edx
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	89 50 04             	mov    %edx,0x4(%eax)
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800288:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028f:	00 00 00 
	b.cnt = 0;
  800292:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800299:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80029c:	ff 75 0c             	pushl  0xc(%ebp)
  80029f:	ff 75 08             	pushl  0x8(%ebp)
  8002a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a8:	50                   	push   %eax
  8002a9:	68 16 02 80 00       	push   $0x800216
  8002ae:	e8 11 02 00 00       	call   8004c4 <vprintfmt>
  8002b3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b6:	a0 08 30 80 00       	mov    0x803008,%al
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c4:	83 ec 04             	sub    $0x4,%esp
  8002c7:	50                   	push   %eax
  8002c8:	52                   	push   %edx
  8002c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cf:	83 c0 08             	add    $0x8,%eax
  8002d2:	50                   	push   %eax
  8002d3:	e8 d7 0d 00 00       	call   8010af <sys_cputs>
  8002d8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002db:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e8:	c9                   	leave  
  8002e9:	c3                   	ret    

008002ea <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 73 ff ff ff       	call   80027f <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80031d:	e8 cf 0d 00 00       	call   8010f1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800322:	8d 45 0c             	lea    0xc(%ebp),%eax
  800325:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 75 f4             	pushl  -0xc(%ebp)
  800331:	50                   	push   %eax
  800332:	e8 48 ff ff ff       	call   80027f <vcprintf>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80033d:	e8 c9 0d 00 00       	call   80110b <sys_unlock_cons>
	return cnt;
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800345:	c9                   	leave  
  800346:	c3                   	ret    

00800347 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	53                   	push   %ebx
  80034b:	83 ec 14             	sub    $0x14,%esp
  80034e:	8b 45 10             	mov    0x10(%ebp),%eax
  800351:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800354:	8b 45 14             	mov    0x14(%ebp),%eax
  800357:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035a:	8b 45 18             	mov    0x18(%ebp),%eax
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
  800362:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800365:	77 55                	ja     8003bc <printnum+0x75>
  800367:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036a:	72 05                	jb     800371 <printnum+0x2a>
  80036c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036f:	77 4b                	ja     8003bc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800371:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800374:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800377:	8b 45 18             	mov    0x18(%ebp),%eax
  80037a:	ba 00 00 00 00       	mov    $0x0,%edx
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	ff 75 f4             	pushl  -0xc(%ebp)
  800384:	ff 75 f0             	pushl  -0x10(%ebp)
  800387:	e8 34 16 00 00       	call   8019c0 <__udivdi3>
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	83 ec 04             	sub    $0x4,%esp
  800392:	ff 75 20             	pushl  0x20(%ebp)
  800395:	53                   	push   %ebx
  800396:	ff 75 18             	pushl  0x18(%ebp)
  800399:	52                   	push   %edx
  80039a:	50                   	push   %eax
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 a1 ff ff ff       	call   800347 <printnum>
  8003a6:	83 c4 20             	add    $0x20,%esp
  8003a9:	eb 1a                	jmp    8003c5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	ff 75 0c             	pushl  0xc(%ebp)
  8003b1:	ff 75 20             	pushl  0x20(%ebp)
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	ff d0                	call   *%eax
  8003b9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bc:	ff 4d 1c             	decl   0x1c(%ebp)
  8003bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c3:	7f e6                	jg     8003ab <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d3:	53                   	push   %ebx
  8003d4:	51                   	push   %ecx
  8003d5:	52                   	push   %edx
  8003d6:	50                   	push   %eax
  8003d7:	e8 f4 16 00 00       	call   801ad0 <__umoddi3>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	05 74 1f 80 00       	add    $0x801f74,%eax
  8003e4:	8a 00                	mov    (%eax),%al
  8003e6:	0f be c0             	movsbl %al,%eax
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	50                   	push   %eax
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	ff d0                	call   *%eax
  8003f5:	83 c4 10             	add    $0x10,%esp
}
  8003f8:	90                   	nop
  8003f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800401:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800405:	7e 1c                	jle    800423 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	8d 50 08             	lea    0x8(%eax),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	89 10                	mov    %edx,(%eax)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	83 e8 08             	sub    $0x8,%eax
  80041c:	8b 50 04             	mov    0x4(%eax),%edx
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	eb 40                	jmp    800463 <getuint+0x65>
	else if (lflag)
  800423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800427:	74 1e                	je     800447 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	8d 50 04             	lea    0x4(%eax),%edx
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 10                	mov    %edx,(%eax)
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	83 e8 04             	sub    $0x4,%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	ba 00 00 00 00       	mov    $0x0,%edx
  800445:	eb 1c                	jmp    800463 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	8d 50 04             	lea    0x4(%eax),%edx
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	83 e8 04             	sub    $0x4,%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    

00800465 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800468:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046c:	7e 1c                	jle    80048a <getint+0x25>
		return va_arg(*ap, long long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 08             	lea    0x8(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 08             	sub    $0x8,%eax
  800483:	8b 50 04             	mov    0x4(%eax),%edx
  800486:	8b 00                	mov    (%eax),%eax
  800488:	eb 38                	jmp    8004c2 <getint+0x5d>
	else if (lflag)
  80048a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048e:	74 1a                	je     8004aa <getint+0x45>
		return va_arg(*ap, long);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	99                   	cltd   
  8004a8:	eb 18                	jmp    8004c2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	8d 50 04             	lea    0x4(%eax),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	89 10                	mov    %edx,(%eax)
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	83 e8 04             	sub    $0x4,%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	99                   	cltd   
}
  8004c2:	5d                   	pop    %ebp
  8004c3:	c3                   	ret    

008004c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	56                   	push   %esi
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cc:	eb 17                	jmp    8004e5 <vprintfmt+0x21>
			if (ch == '\0')
  8004ce:	85 db                	test   %ebx,%ebx
  8004d0:	0f 84 c1 03 00 00    	je     800897 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 0c             	pushl  0xc(%ebp)
  8004dc:	53                   	push   %ebx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	ff d0                	call   *%eax
  8004e2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e8:	8d 50 01             	lea    0x1(%eax),%edx
  8004eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ee:	8a 00                	mov    (%eax),%al
  8004f0:	0f b6 d8             	movzbl %al,%ebx
  8004f3:	83 fb 25             	cmp    $0x25,%ebx
  8004f6:	75 d6                	jne    8004ce <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004fc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800503:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800511:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800518:	8b 45 10             	mov    0x10(%ebp),%eax
  80051b:	8d 50 01             	lea    0x1(%eax),%edx
  80051e:	89 55 10             	mov    %edx,0x10(%ebp)
  800521:	8a 00                	mov    (%eax),%al
  800523:	0f b6 d8             	movzbl %al,%ebx
  800526:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800529:	83 f8 5b             	cmp    $0x5b,%eax
  80052c:	0f 87 3d 03 00 00    	ja     80086f <vprintfmt+0x3ab>
  800532:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  800539:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80053b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80053f:	eb d7                	jmp    800518 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800541:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800545:	eb d1                	jmp    800518 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800547:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80054e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800551:	89 d0                	mov    %edx,%eax
  800553:	c1 e0 02             	shl    $0x2,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	01 c0                	add    %eax,%eax
  80055a:	01 d8                	add    %ebx,%eax
  80055c:	83 e8 30             	sub    $0x30,%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800562:	8b 45 10             	mov    0x10(%ebp),%eax
  800565:	8a 00                	mov    (%eax),%al
  800567:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80056a:	83 fb 2f             	cmp    $0x2f,%ebx
  80056d:	7e 3e                	jle    8005ad <vprintfmt+0xe9>
  80056f:	83 fb 39             	cmp    $0x39,%ebx
  800572:	7f 39                	jg     8005ad <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800574:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800577:	eb d5                	jmp    80054e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	83 c0 04             	add    $0x4,%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	83 e8 04             	sub    $0x4,%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80058d:	eb 1f                	jmp    8005ae <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80058f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800593:	79 83                	jns    800518 <vprintfmt+0x54>
				width = 0;
  800595:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80059c:	e9 77 ff ff ff       	jmp    800518 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a8:	e9 6b ff ff ff       	jmp    800518 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ad:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b2:	0f 89 60 ff ff ff    	jns    800518 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c5:	e9 4e ff ff ff       	jmp    800518 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ca:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005cd:	e9 46 ff ff ff       	jmp    800518 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 c0 04             	add    $0x4,%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 e8 04             	sub    $0x4,%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	ff 75 0c             	pushl  0xc(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	ff d0                	call   *%eax
  8005ef:	83 c4 10             	add    $0x10,%esp
			break;
  8005f2:	e9 9b 02 00 00       	jmp    800892 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	83 c0 04             	add    $0x4,%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	83 e8 04             	sub    $0x4,%eax
  800606:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800608:	85 db                	test   %ebx,%ebx
  80060a:	79 02                	jns    80060e <vprintfmt+0x14a>
				err = -err;
  80060c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060e:	83 fb 64             	cmp    $0x64,%ebx
  800611:	7f 0b                	jg     80061e <vprintfmt+0x15a>
  800613:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  80061a:	85 f6                	test   %esi,%esi
  80061c:	75 19                	jne    800637 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80061e:	53                   	push   %ebx
  80061f:	68 85 1f 80 00       	push   $0x801f85
  800624:	ff 75 0c             	pushl  0xc(%ebp)
  800627:	ff 75 08             	pushl  0x8(%ebp)
  80062a:	e8 70 02 00 00       	call   80089f <printfmt>
  80062f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800632:	e9 5b 02 00 00       	jmp    800892 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800637:	56                   	push   %esi
  800638:	68 8e 1f 80 00       	push   $0x801f8e
  80063d:	ff 75 0c             	pushl  0xc(%ebp)
  800640:	ff 75 08             	pushl  0x8(%ebp)
  800643:	e8 57 02 00 00       	call   80089f <printfmt>
  800648:	83 c4 10             	add    $0x10,%esp
			break;
  80064b:	e9 42 02 00 00       	jmp    800892 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 c0 04             	add    $0x4,%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 30                	mov    (%eax),%esi
  800661:	85 f6                	test   %esi,%esi
  800663:	75 05                	jne    80066a <vprintfmt+0x1a6>
				p = "(null)";
  800665:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  80066a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066e:	7e 6d                	jle    8006dd <vprintfmt+0x219>
  800670:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800674:	74 67                	je     8006dd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	50                   	push   %eax
  80067d:	56                   	push   %esi
  80067e:	e8 1e 03 00 00       	call   8009a1 <strnlen>
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800689:	eb 16                	jmp    8006a1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80068b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	50                   	push   %eax
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	ff d0                	call   *%eax
  80069b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069e:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a5:	7f e4                	jg     80068b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a7:	eb 34                	jmp    8006dd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ad:	74 1c                	je     8006cb <vprintfmt+0x207>
  8006af:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b2:	7e 05                	jle    8006b9 <vprintfmt+0x1f5>
  8006b4:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b7:	7e 12                	jle    8006cb <vprintfmt+0x207>
					putch('?', putdat);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	6a 3f                	push   $0x3f
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	ff d0                	call   *%eax
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	eb 0f                	jmp    8006da <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	53                   	push   %ebx
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	ff d0                	call   *%eax
  8006d7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006da:	ff 4d e4             	decl   -0x1c(%ebp)
  8006dd:	89 f0                	mov    %esi,%eax
  8006df:	8d 70 01             	lea    0x1(%eax),%esi
  8006e2:	8a 00                	mov    (%eax),%al
  8006e4:	0f be d8             	movsbl %al,%ebx
  8006e7:	85 db                	test   %ebx,%ebx
  8006e9:	74 24                	je     80070f <vprintfmt+0x24b>
  8006eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ef:	78 b8                	js     8006a9 <vprintfmt+0x1e5>
  8006f1:	ff 4d e0             	decl   -0x20(%ebp)
  8006f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f8:	79 af                	jns    8006a9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fa:	eb 13                	jmp    80070f <vprintfmt+0x24b>
				putch(' ', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	6a 20                	push   $0x20
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	ff d0                	call   *%eax
  800709:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070c:	ff 4d e4             	decl   -0x1c(%ebp)
  80070f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800713:	7f e7                	jg     8006fc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800715:	e9 78 01 00 00       	jmp    800892 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 e8             	pushl  -0x18(%ebp)
  800720:	8d 45 14             	lea    0x14(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	e8 3c fd ff ff       	call   800465 <getint>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800738:	85 d2                	test   %edx,%edx
  80073a:	79 23                	jns    80075f <vprintfmt+0x29b>
				putch('-', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	6a 2d                	push   $0x2d
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	ff d0                	call   *%eax
  800749:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80074c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800752:	f7 d8                	neg    %eax
  800754:	83 d2 00             	adc    $0x0,%edx
  800757:	f7 da                	neg    %edx
  800759:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80075f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800766:	e9 bc 00 00 00       	jmp    800827 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 e8             	pushl  -0x18(%ebp)
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
  800774:	50                   	push   %eax
  800775:	e8 84 fc ff ff       	call   8003fe <getuint>
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800780:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800783:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078a:	e9 98 00 00 00       	jmp    800827 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	6a 58                	push   $0x58
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	ff d0                	call   *%eax
  80079c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	6a 58                	push   $0x58
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	6a 58                	push   $0x58
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	ff d0                	call   *%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
			break;
  8007bf:	e9 ce 00 00 00       	jmp    800892 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	6a 30                	push   $0x30
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 78                	push   $0x78
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007ff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800806:	eb 1f                	jmp    800827 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 e8             	pushl  -0x18(%ebp)
  80080e:	8d 45 14             	lea    0x14(%ebp),%eax
  800811:	50                   	push   %eax
  800812:	e8 e7 fb ff ff       	call   8003fe <getuint>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800820:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800827:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80082b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082e:	83 ec 04             	sub    $0x4,%esp
  800831:	52                   	push   %edx
  800832:	ff 75 e4             	pushl  -0x1c(%ebp)
  800835:	50                   	push   %eax
  800836:	ff 75 f4             	pushl  -0xc(%ebp)
  800839:	ff 75 f0             	pushl  -0x10(%ebp)
  80083c:	ff 75 0c             	pushl  0xc(%ebp)
  80083f:	ff 75 08             	pushl  0x8(%ebp)
  800842:	e8 00 fb ff ff       	call   800347 <printnum>
  800847:	83 c4 20             	add    $0x20,%esp
			break;
  80084a:	eb 46                	jmp    800892 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
			break;
  80085b:	eb 35                	jmp    800892 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80085d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800864:	eb 2c                	jmp    800892 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800866:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80086d:	eb 23                	jmp    800892 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	6a 25                	push   $0x25
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	ff d0                	call   *%eax
  80087c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087f:	ff 4d 10             	decl   0x10(%ebp)
  800882:	eb 03                	jmp    800887 <vprintfmt+0x3c3>
  800884:	ff 4d 10             	decl   0x10(%ebp)
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	48                   	dec    %eax
  80088b:	8a 00                	mov    (%eax),%al
  80088d:	3c 25                	cmp    $0x25,%al
  80088f:	75 f3                	jne    800884 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800891:	90                   	nop
		}
	}
  800892:	e9 35 fc ff ff       	jmp    8004cc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800897:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008a5:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a8:	83 c0 04             	add    $0x4,%eax
  8008ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	ff 75 08             	pushl  0x8(%ebp)
  8008bb:	e8 04 fc ff ff       	call   8004c4 <vprintfmt>
  8008c0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008c3:	90                   	nop
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    

008008c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	8b 40 08             	mov    0x8(%eax),%eax
  8008cf:	8d 50 01             	lea    0x1(%eax),%edx
  8008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008db:	8b 10                	mov    (%eax),%edx
  8008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e0:	8b 40 04             	mov    0x4(%eax),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	73 12                	jae    8008f9 <sprintputch+0x33>
		*b->buf++ = ch;
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f2:	89 0a                	mov    %ecx,(%edx)
  8008f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f7:	88 10                	mov    %dl,(%eax)
}
  8008f9:	90                   	nop
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	01 d0                	add    %edx,%eax
  800913:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800916:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800921:	74 06                	je     800929 <vsnprintf+0x2d>
  800923:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800927:	7f 07                	jg     800930 <vsnprintf+0x34>
		return -E_INVAL;
  800929:	b8 03 00 00 00       	mov    $0x3,%eax
  80092e:	eb 20                	jmp    800950 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800930:	ff 75 14             	pushl  0x14(%ebp)
  800933:	ff 75 10             	pushl  0x10(%ebp)
  800936:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800939:	50                   	push   %eax
  80093a:	68 c6 08 80 00       	push   $0x8008c6
  80093f:	e8 80 fb ff ff       	call   8004c4 <vprintfmt>
  800944:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80094a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800958:	8d 45 10             	lea    0x10(%ebp),%eax
  80095b:	83 c0 04             	add    $0x4,%eax
  80095e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	ff 75 f4             	pushl  -0xc(%ebp)
  800967:	50                   	push   %eax
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 89 ff ff ff       	call   8008fc <vsnprintf>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800979:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098b:	eb 06                	jmp    800993 <strlen+0x15>
		n++;
  80098d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800990:	ff 45 08             	incl   0x8(%ebp)
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8a 00                	mov    (%eax),%al
  800998:	84 c0                	test   %al,%al
  80099a:	75 f1                	jne    80098d <strlen+0xf>
		n++;
	return n;
  80099c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ae:	eb 09                	jmp    8009b9 <strnlen+0x18>
		n++;
  8009b0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b3:	ff 45 08             	incl   0x8(%ebp)
  8009b6:	ff 4d 0c             	decl   0xc(%ebp)
  8009b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009bd:	74 09                	je     8009c8 <strnlen+0x27>
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8a 00                	mov    (%eax),%al
  8009c4:	84 c0                	test   %al,%al
  8009c6:	75 e8                	jne    8009b0 <strnlen+0xf>
		n++;
	return n;
  8009c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009d9:	90                   	nop
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8d 50 01             	lea    0x1(%eax),%edx
  8009e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009ec:	8a 12                	mov    (%edx),%dl
  8009ee:	88 10                	mov    %dl,(%eax)
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	84 c0                	test   %al,%al
  8009f4:	75 e4                	jne    8009da <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0e:	eb 1f                	jmp    800a2f <strncpy+0x34>
		*dst++ = *src;
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8d 50 01             	lea    0x1(%eax),%edx
  800a16:	89 55 08             	mov    %edx,0x8(%ebp)
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	8a 12                	mov    (%edx),%dl
  800a1e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a23:	8a 00                	mov    (%eax),%al
  800a25:	84 c0                	test   %al,%al
  800a27:	74 03                	je     800a2c <strncpy+0x31>
			src++;
  800a29:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a2c:	ff 45 fc             	incl   -0x4(%ebp)
  800a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a32:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a35:	72 d9                	jb     800a10 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4c:	74 30                	je     800a7e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a4e:	eb 16                	jmp    800a66 <strlcpy+0x2a>
			*dst++ = *src++;
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8d 50 01             	lea    0x1(%eax),%edx
  800a56:	89 55 08             	mov    %edx,0x8(%ebp)
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a5f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a62:	8a 12                	mov    (%edx),%dl
  800a64:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a66:	ff 4d 10             	decl   0x10(%ebp)
  800a69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6d:	74 09                	je     800a78 <strlcpy+0x3c>
  800a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a72:	8a 00                	mov    (%eax),%al
  800a74:	84 c0                	test   %al,%al
  800a76:	75 d8                	jne    800a50 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a84:	29 c2                	sub    %eax,%edx
  800a86:	89 d0                	mov    %edx,%eax
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a8d:	eb 06                	jmp    800a95 <strcmp+0xb>
		p++, q++;
  800a8f:	ff 45 08             	incl   0x8(%ebp)
  800a92:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8a 00                	mov    (%eax),%al
  800a9a:	84 c0                	test   %al,%al
  800a9c:	74 0e                	je     800aac <strcmp+0x22>
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8a 10                	mov    (%eax),%dl
  800aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa6:	8a 00                	mov    (%eax),%al
  800aa8:	38 c2                	cmp    %al,%dl
  800aaa:	74 e3                	je     800a8f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	0f b6 d0             	movzbl %al,%edx
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	29 c2                	sub    %eax,%edx
  800abe:	89 d0                	mov    %edx,%eax
}
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ac5:	eb 09                	jmp    800ad0 <strncmp+0xe>
		n--, p++, q++;
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	ff 45 08             	incl   0x8(%ebp)
  800acd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad4:	74 17                	je     800aed <strncmp+0x2b>
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	84 c0                	test   %al,%al
  800add:	74 0e                	je     800aed <strncmp+0x2b>
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8a 10                	mov    (%eax),%dl
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	38 c2                	cmp    %al,%dl
  800aeb:	74 da                	je     800ac7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af1:	75 07                	jne    800afa <strncmp+0x38>
		return 0;
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
  800af8:	eb 14                	jmp    800b0e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8a 00                	mov    (%eax),%al
  800aff:	0f b6 d0             	movzbl %al,%edx
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	0f b6 c0             	movzbl %al,%eax
  800b0a:	29 c2                	sub    %eax,%edx
  800b0c:	89 d0                	mov    %edx,%eax
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b1c:	eb 12                	jmp    800b30 <strchr+0x20>
		if (*s == c)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b26:	75 05                	jne    800b2d <strchr+0x1d>
			return (char *) s;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	eb 11                	jmp    800b3e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b2d:	ff 45 08             	incl   0x8(%ebp)
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	84 c0                	test   %al,%al
  800b37:	75 e5                	jne    800b1e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 04             	sub    $0x4,%esp
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b4c:	eb 0d                	jmp    800b5b <strfind+0x1b>
		if (*s == c)
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b56:	74 0e                	je     800b66 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b58:	ff 45 08             	incl   0x8(%ebp)
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	84 c0                	test   %al,%al
  800b62:	75 ea                	jne    800b4e <strfind+0xe>
  800b64:	eb 01                	jmp    800b67 <strfind+0x27>
		if (*s == c)
			break;
  800b66:	90                   	nop
	return (char *) s;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b78:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b7e:	eb 0e                	jmp    800b8e <memset+0x22>
		*p++ = c;
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b83:	8d 50 01             	lea    0x1(%eax),%edx
  800b86:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b8e:	ff 4d f8             	decl   -0x8(%ebp)
  800b91:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b95:	79 e9                	jns    800b80 <memset+0x14>
		*p++ = c;

	return v;
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bae:	eb 16                	jmp    800bc6 <memcpy+0x2a>
		*d++ = *s++;
  800bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb3:	8d 50 01             	lea    0x1(%eax),%edx
  800bb6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bbc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bc2:	8a 12                	mov    (%edx),%dl
  800bc4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bcc:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	75 dd                	jne    800bb0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bf0:	73 50                	jae    800c42 <memmove+0x6a>
  800bf2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
  800bfa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bfd:	76 43                	jbe    800c42 <memmove+0x6a>
		s += n;
  800bff:	8b 45 10             	mov    0x10(%ebp),%eax
  800c02:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c05:	8b 45 10             	mov    0x10(%ebp),%eax
  800c08:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c0b:	eb 10                	jmp    800c1d <memmove+0x45>
			*--d = *--s;
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	ff 4d fc             	decl   -0x4(%ebp)
  800c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c16:	8a 10                	mov    (%eax),%dl
  800c18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c23:	89 55 10             	mov    %edx,0x10(%ebp)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	75 e3                	jne    800c0d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c2a:	eb 23                	jmp    800c4f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c2f:	8d 50 01             	lea    0x1(%eax),%edx
  800c32:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c3e:	8a 12                	mov    (%edx),%dl
  800c40:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c42:	8b 45 10             	mov    0x10(%ebp),%eax
  800c45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c48:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	75 dd                	jne    800c2c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c66:	eb 2a                	jmp    800c92 <memcmp+0x3e>
		if (*s1 != *s2)
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	8a 10                	mov    (%eax),%dl
  800c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c70:	8a 00                	mov    (%eax),%al
  800c72:	38 c2                	cmp    %al,%dl
  800c74:	74 16                	je     800c8c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f b6 d0             	movzbl %al,%edx
  800c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	0f b6 c0             	movzbl %al,%eax
  800c86:	29 c2                	sub    %eax,%edx
  800c88:	89 d0                	mov    %edx,%eax
  800c8a:	eb 18                	jmp    800ca4 <memcmp+0x50>
		s1++, s2++;
  800c8c:	ff 45 fc             	incl   -0x4(%ebp)
  800c8f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
  800c95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c98:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	75 c9                	jne    800c68 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb2:	01 d0                	add    %edx,%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cb7:	eb 15                	jmp    800cce <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	0f b6 d0             	movzbl %al,%edx
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	0f b6 c0             	movzbl %al,%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 0d                	je     800cd8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ccb:	ff 45 08             	incl   0x8(%ebp)
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cd4:	72 e3                	jb     800cb9 <memfind+0x13>
  800cd6:	eb 01                	jmp    800cd9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cd8:	90                   	nop
	return (void *) s;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ce4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ceb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf2:	eb 03                	jmp    800cf7 <strtol+0x19>
		s++;
  800cf4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	3c 20                	cmp    $0x20,%al
  800cfe:	74 f4                	je     800cf4 <strtol+0x16>
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	3c 09                	cmp    $0x9,%al
  800d07:	74 eb                	je     800cf4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 2b                	cmp    $0x2b,%al
  800d10:	75 05                	jne    800d17 <strtol+0x39>
		s++;
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	eb 13                	jmp    800d2a <strtol+0x4c>
	else if (*s == '-')
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	3c 2d                	cmp    $0x2d,%al
  800d1e:	75 0a                	jne    800d2a <strtol+0x4c>
		s++, neg = 1;
  800d20:	ff 45 08             	incl   0x8(%ebp)
  800d23:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2e:	74 06                	je     800d36 <strtol+0x58>
  800d30:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d34:	75 20                	jne    800d56 <strtol+0x78>
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	3c 30                	cmp    $0x30,%al
  800d3d:	75 17                	jne    800d56 <strtol+0x78>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	40                   	inc    %eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	3c 78                	cmp    $0x78,%al
  800d47:	75 0d                	jne    800d56 <strtol+0x78>
		s += 2, base = 16;
  800d49:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d4d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d54:	eb 28                	jmp    800d7e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	75 15                	jne    800d71 <strtol+0x93>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3c 30                	cmp    $0x30,%al
  800d63:	75 0c                	jne    800d71 <strtol+0x93>
		s++, base = 8;
  800d65:	ff 45 08             	incl   0x8(%ebp)
  800d68:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d6f:	eb 0d                	jmp    800d7e <strtol+0xa0>
	else if (base == 0)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	75 07                	jne    800d7e <strtol+0xa0>
		base = 10;
  800d77:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3c 2f                	cmp    $0x2f,%al
  800d85:	7e 19                	jle    800da0 <strtol+0xc2>
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3c 39                	cmp    $0x39,%al
  800d8e:	7f 10                	jg     800da0 <strtol+0xc2>
			dig = *s - '0';
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	0f be c0             	movsbl %al,%eax
  800d98:	83 e8 30             	sub    $0x30,%eax
  800d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d9e:	eb 42                	jmp    800de2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 60                	cmp    $0x60,%al
  800da7:	7e 19                	jle    800dc2 <strtol+0xe4>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	3c 7a                	cmp    $0x7a,%al
  800db0:	7f 10                	jg     800dc2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	0f be c0             	movsbl %al,%eax
  800dba:	83 e8 57             	sub    $0x57,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 20                	jmp    800de2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	3c 40                	cmp    $0x40,%al
  800dc9:	7e 39                	jle    800e04 <strtol+0x126>
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	3c 5a                	cmp    $0x5a,%al
  800dd2:	7f 30                	jg     800e04 <strtol+0x126>
			dig = *s - 'A' + 10;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f be c0             	movsbl %al,%eax
  800ddc:	83 e8 37             	sub    $0x37,%eax
  800ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de8:	7d 19                	jge    800e03 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dea:	ff 45 08             	incl   0x8(%ebp)
  800ded:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800df4:	89 c2                	mov    %eax,%edx
  800df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df9:	01 d0                	add    %edx,%eax
  800dfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dfe:	e9 7b ff ff ff       	jmp    800d7e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e03:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e08:	74 08                	je     800e12 <strtol+0x134>
		*endptr = (char *) s;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e16:	74 07                	je     800e1f <strtol+0x141>
  800e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1b:	f7 d8                	neg    %eax
  800e1d:	eb 03                	jmp    800e22 <strtol+0x144>
  800e1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <ltostr>:

void
ltostr(long value, char *str)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e3c:	79 13                	jns    800e51 <ltostr+0x2d>
	{
		neg = 1;
  800e3e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e4b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e4e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e59:	99                   	cltd   
  800e5a:	f7 f9                	idiv   %ecx
  800e5c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	8d 50 01             	lea    0x1(%eax),%edx
  800e65:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e68:	89 c2                	mov    %eax,%edx
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e72:	83 c2 30             	add    $0x30,%edx
  800e75:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e7f:	f7 e9                	imul   %ecx
  800e81:	c1 fa 02             	sar    $0x2,%edx
  800e84:	89 c8                	mov    %ecx,%eax
  800e86:	c1 f8 1f             	sar    $0x1f,%eax
  800e89:	29 c2                	sub    %eax,%edx
  800e8b:	89 d0                	mov    %edx,%eax
  800e8d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e94:	75 bb                	jne    800e51 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	48                   	dec    %eax
  800ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ea4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ea8:	74 3d                	je     800ee7 <ltostr+0xc3>
		start = 1 ;
  800eaa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800eb1:	eb 34                	jmp    800ee7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	01 c2                	add    %eax,%edx
  800ec8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	01 c8                	add    %ecx,%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ed4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eda:	01 c2                	add    %eax,%edx
  800edc:	8a 45 eb             	mov    -0x15(%ebp),%al
  800edf:	88 02                	mov    %al,(%edx)
		start++ ;
  800ee1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ee4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800eed:	7c c4                	jl     800eb3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800eef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800efa:	90                   	nop
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f03:	ff 75 08             	pushl  0x8(%ebp)
  800f06:	e8 73 fa ff ff       	call   80097e <strlen>
  800f0b:	83 c4 04             	add    $0x4,%esp
  800f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	e8 65 fa ff ff       	call   80097e <strlen>
  800f19:	83 c4 04             	add    $0x4,%esp
  800f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2d:	eb 17                	jmp    800f46 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 c2                	add    %eax,%edx
  800f37:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	01 c8                	add    %ecx,%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f43:	ff 45 fc             	incl   -0x4(%ebp)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f4c:	7c e1                	jl     800f2f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f4e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5c:	eb 1f                	jmp    800f7d <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f61:	8d 50 01             	lea    0x1(%eax),%edx
  800f64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f67:	89 c2                	mov    %eax,%edx
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	01 c2                	add    %eax,%edx
  800f6e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	01 c8                	add    %ecx,%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f7a:	ff 45 f8             	incl   -0x8(%ebp)
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f83:	7c d9                	jl     800f5e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f88:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	c6 00 00             	movb   $0x0,(%eax)
}
  800f90:	90                   	nop
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa2:	8b 00                	mov    (%eax),%eax
  800fa4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 d0                	add    %edx,%eax
  800fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb6:	eb 0c                	jmp    800fc4 <strsplit+0x31>
			*string++ = 0;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8d 50 01             	lea    0x1(%eax),%edx
  800fbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	84 c0                	test   %al,%al
  800fcb:	74 18                	je     800fe5 <strsplit+0x52>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	0f be c0             	movsbl %al,%eax
  800fd5:	50                   	push   %eax
  800fd6:	ff 75 0c             	pushl  0xc(%ebp)
  800fd9:	e8 32 fb ff ff       	call   800b10 <strchr>
  800fde:	83 c4 08             	add    $0x8,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	75 d3                	jne    800fb8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	74 5a                	je     801048 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff1:	8b 00                	mov    (%eax),%eax
  800ff3:	83 f8 0f             	cmp    $0xf,%eax
  800ff6:	75 07                	jne    800fff <strsplit+0x6c>
		{
			return 0;
  800ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffd:	eb 66                	jmp    801065 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	8b 00                	mov    (%eax),%eax
  801004:	8d 48 01             	lea    0x1(%eax),%ecx
  801007:	8b 55 14             	mov    0x14(%ebp),%edx
  80100a:	89 0a                	mov    %ecx,(%edx)
  80100c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 c2                	add    %eax,%edx
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80101d:	eb 03                	jmp    801022 <strsplit+0x8f>
			string++;
  80101f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	84 c0                	test   %al,%al
  801029:	74 8b                	je     800fb6 <strsplit+0x23>
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	0f be c0             	movsbl %al,%eax
  801033:	50                   	push   %eax
  801034:	ff 75 0c             	pushl  0xc(%ebp)
  801037:	e8 d4 fa ff ff       	call   800b10 <strchr>
  80103c:	83 c4 08             	add    $0x8,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	74 dc                	je     80101f <strsplit+0x8c>
			string++;
	}
  801043:	e9 6e ff ff ff       	jmp    800fb6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801048:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801049:	8b 45 14             	mov    0x14(%ebp),%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801055:	8b 45 10             	mov    0x10(%ebp),%eax
  801058:	01 d0                	add    %edx,%eax
  80105a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801060:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80106d:	83 ec 04             	sub    $0x4,%esp
  801070:	68 08 21 80 00       	push   $0x802108
  801075:	68 3f 01 00 00       	push   $0x13f
  80107a:	68 2a 21 80 00       	push   $0x80212a
  80107f:	e8 50 07 00 00       	call   8017d4 <_panic>

00801084 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8b 55 0c             	mov    0xc(%ebp),%edx
  801093:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801096:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801099:	8b 7d 18             	mov    0x18(%ebp),%edi
  80109c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80109f:	cd 30                	int    $0x30
  8010a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 04             	sub    $0x4,%esp
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	52                   	push   %edx
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 b2 ff ff ff       	call   801084 <syscall>
  8010d2:	83 c4 18             	add    $0x18,%esp
}
  8010d5:	90                   	nop
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 02                	push   $0x2
  8010e7:	e8 98 ff ff ff       	call   801084 <syscall>
  8010ec:	83 c4 18             	add    $0x18,%esp
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 03                	push   $0x3
  801100:	e8 7f ff ff ff       	call   801084 <syscall>
  801105:	83 c4 18             	add    $0x18,%esp
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	6a 00                	push   $0x0
  801114:	6a 00                	push   $0x0
  801116:	6a 00                	push   $0x0
  801118:	6a 04                	push   $0x4
  80111a:	e8 65 ff ff ff       	call   801084 <syscall>
  80111f:	83 c4 18             	add    $0x18,%esp
}
  801122:	90                   	nop
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	6a 00                	push   $0x0
  801130:	6a 00                	push   $0x0
  801132:	6a 00                	push   $0x0
  801134:	52                   	push   %edx
  801135:	50                   	push   %eax
  801136:	6a 08                	push   $0x8
  801138:	e8 47 ff ff ff       	call   801084 <syscall>
  80113d:	83 c4 18             	add    $0x18,%esp
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    

00801142 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801147:	8b 75 18             	mov    0x18(%ebp),%esi
  80114a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80114d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801150:	8b 55 0c             	mov    0xc(%ebp),%edx
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	51                   	push   %ecx
  801159:	52                   	push   %edx
  80115a:	50                   	push   %eax
  80115b:	6a 09                	push   $0x9
  80115d:	e8 22 ff ff ff       	call   801084 <syscall>
  801162:	83 c4 18             	add    $0x18,%esp
}
  801165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801168:	5b                   	pop    %ebx
  801169:	5e                   	pop    %esi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80116f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	52                   	push   %edx
  80117c:	50                   	push   %eax
  80117d:	6a 0a                	push   $0xa
  80117f:	e8 00 ff ff ff       	call   801084 <syscall>
  801184:	83 c4 18             	add    $0x18,%esp
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	ff 75 0c             	pushl  0xc(%ebp)
  801195:	ff 75 08             	pushl  0x8(%ebp)
  801198:	6a 0b                	push   $0xb
  80119a:	e8 e5 fe ff ff       	call   801084 <syscall>
  80119f:	83 c4 18             	add    $0x18,%esp
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 0c                	push   $0xc
  8011b3:	e8 cc fe ff ff       	call   801084 <syscall>
  8011b8:	83 c4 18             	add    $0x18,%esp
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 0d                	push   $0xd
  8011cc:	e8 b3 fe ff ff       	call   801084 <syscall>
  8011d1:	83 c4 18             	add    $0x18,%esp
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 0e                	push   $0xe
  8011e5:	e8 9a fe ff ff       	call   801084 <syscall>
  8011ea:	83 c4 18             	add    $0x18,%esp
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 0f                	push   $0xf
  8011fe:	e8 81 fe ff ff       	call   801084 <syscall>
  801203:	83 c4 18             	add    $0x18,%esp
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	ff 75 08             	pushl  0x8(%ebp)
  801216:	6a 10                	push   $0x10
  801218:	e8 67 fe ff ff       	call   801084 <syscall>
  80121d:	83 c4 18             	add    $0x18,%esp
}
  801220:	c9                   	leave  
  801221:	c3                   	ret    

00801222 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 11                	push   $0x11
  801231:	e8 4e fe ff ff       	call   801084 <syscall>
  801236:	83 c4 18             	add    $0x18,%esp
}
  801239:	90                   	nop
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <sys_cputc>:

void
sys_cputc(const char c)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801248:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	50                   	push   %eax
  801255:	6a 01                	push   $0x1
  801257:	e8 28 fe ff ff       	call   801084 <syscall>
  80125c:	83 c4 18             	add    $0x18,%esp
}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 14                	push   $0x14
  801271:	e8 0e fe ff ff       	call   801084 <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	90                   	nop
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801288:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80128b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	6a 00                	push   $0x0
  801294:	51                   	push   %ecx
  801295:	52                   	push   %edx
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	50                   	push   %eax
  80129a:	6a 15                	push   $0x15
  80129c:	e8 e3 fd ff ff       	call   801084 <syscall>
  8012a1:	83 c4 18             	add    $0x18,%esp
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	52                   	push   %edx
  8012b6:	50                   	push   %eax
  8012b7:	6a 16                	push   $0x16
  8012b9:	e8 c6 fd ff ff       	call   801084 <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	51                   	push   %ecx
  8012d4:	52                   	push   %edx
  8012d5:	50                   	push   %eax
  8012d6:	6a 17                	push   $0x17
  8012d8:	e8 a7 fd ff ff       	call   801084 <syscall>
  8012dd:	83 c4 18             	add    $0x18,%esp
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	52                   	push   %edx
  8012f2:	50                   	push   %eax
  8012f3:	6a 18                	push   $0x18
  8012f5:	e8 8a fd ff ff       	call   801084 <syscall>
  8012fa:	83 c4 18             	add    $0x18,%esp
}
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	6a 00                	push   $0x0
  801307:	ff 75 14             	pushl  0x14(%ebp)
  80130a:	ff 75 10             	pushl  0x10(%ebp)
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	50                   	push   %eax
  801311:	6a 19                	push   $0x19
  801313:	e8 6c fd ff ff       	call   801084 <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	50                   	push   %eax
  80132c:	6a 1a                	push   $0x1a
  80132e:	e8 51 fd ff ff       	call   801084 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	50                   	push   %eax
  801348:	6a 1b                	push   $0x1b
  80134a:	e8 35 fd ff ff       	call   801084 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 05                	push   $0x5
  801363:	e8 1c fd ff ff       	call   801084 <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 06                	push   $0x6
  80137c:	e8 03 fd ff ff       	call   801084 <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 07                	push   $0x7
  801395:	e8 ea fc ff ff       	call   801084 <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_exit_env>:


void sys_exit_env(void)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 1c                	push   $0x1c
  8013ae:	e8 d1 fc ff ff       	call   801084 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	90                   	nop
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013bf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013c2:	8d 50 04             	lea    0x4(%eax),%edx
  8013c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	52                   	push   %edx
  8013cf:	50                   	push   %eax
  8013d0:	6a 1d                	push   $0x1d
  8013d2:	e8 ad fc ff ff       	call   801084 <syscall>
  8013d7:	83 c4 18             	add    $0x18,%esp
	return result;
  8013da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e3:	89 01                	mov    %eax,(%ecx)
  8013e5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	c9                   	leave  
  8013ec:	c2 04 00             	ret    $0x4

008013ef <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	ff 75 10             	pushl  0x10(%ebp)
  8013f9:	ff 75 0c             	pushl  0xc(%ebp)
  8013fc:	ff 75 08             	pushl  0x8(%ebp)
  8013ff:	6a 13                	push   $0x13
  801401:	e8 7e fc ff ff       	call   801084 <syscall>
  801406:	83 c4 18             	add    $0x18,%esp
	return ;
  801409:	90                   	nop
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <sys_rcr2>:
uint32 sys_rcr2()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 1e                	push   $0x1e
  80141b:	e8 64 fc ff ff       	call   801084 <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
}
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801431:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	50                   	push   %eax
  80143e:	6a 1f                	push   $0x1f
  801440:	e8 3f fc ff ff       	call   801084 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
	return ;
  801448:	90                   	nop
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <rsttst>:
void rsttst()
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 21                	push   $0x21
  80145a:	e8 25 fc ff ff       	call   801084 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
	return ;
  801462:	90                   	nop
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	8b 45 14             	mov    0x14(%ebp),%eax
  80146e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801471:	8b 55 18             	mov    0x18(%ebp),%edx
  801474:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801478:	52                   	push   %edx
  801479:	50                   	push   %eax
  80147a:	ff 75 10             	pushl  0x10(%ebp)
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	ff 75 08             	pushl  0x8(%ebp)
  801483:	6a 20                	push   $0x20
  801485:	e8 fa fb ff ff       	call   801084 <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
	return ;
  80148d:	90                   	nop
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <chktst>:
void chktst(uint32 n)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	ff 75 08             	pushl  0x8(%ebp)
  80149e:	6a 22                	push   $0x22
  8014a0:	e8 df fb ff ff       	call   801084 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a8:	90                   	nop
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <inctst>:

void inctst()
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 23                	push   $0x23
  8014ba:	e8 c5 fb ff ff       	call   801084 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c2:	90                   	nop
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <gettst>:
uint32 gettst()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 24                	push   $0x24
  8014d4:	e8 ab fb ff ff       	call   801084 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  8014f0:	e8 8f fb ff ff       	call   801084 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
  8014f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014fb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014ff:	75 07                	jne    801508 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801501:	b8 01 00 00 00       	mov    $0x1,%eax
  801506:	eb 05                	jmp    80150d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801521:	e8 5e fb ff ff       	call   801084 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
  801529:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80152c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801530:	75 07                	jne    801539 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801532:	b8 01 00 00 00       	mov    $0x1,%eax
  801537:	eb 05                	jmp    80153e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 25                	push   $0x25
  801552:	e8 2d fb ff ff       	call   801084 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
  80155a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80155d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801561:	75 07                	jne    80156a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801563:	b8 01 00 00 00       	mov    $0x1,%eax
  801568:	eb 05                	jmp    80156f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 25                	push   $0x25
  801583:	e8 fc fa ff ff       	call   801084 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
  80158b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80158e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801592:	75 07                	jne    80159b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801594:	b8 01 00 00 00       	mov    $0x1,%eax
  801599:	eb 05                	jmp    8015a0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	ff 75 08             	pushl  0x8(%ebp)
  8015b0:	6a 26                	push   $0x26
  8015b2:	e8 cd fa ff ff       	call   801084 <syscall>
  8015b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ba:	90                   	nop
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	6a 00                	push   $0x0
  8015cf:	53                   	push   %ebx
  8015d0:	51                   	push   %ecx
  8015d1:	52                   	push   %edx
  8015d2:	50                   	push   %eax
  8015d3:	6a 27                	push   $0x27
  8015d5:	e8 aa fa ff ff       	call   801084 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	52                   	push   %edx
  8015f2:	50                   	push   %eax
  8015f3:	6a 28                	push   $0x28
  8015f5:	e8 8a fa ff ff       	call   801084 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801602:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801605:	8b 55 0c             	mov    0xc(%ebp),%edx
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	6a 00                	push   $0x0
  80160d:	51                   	push   %ecx
  80160e:	ff 75 10             	pushl  0x10(%ebp)
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	6a 29                	push   $0x29
  801615:	e8 6a fa ff ff       	call   801084 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	ff 75 10             	pushl  0x10(%ebp)
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	6a 12                	push   $0x12
  801631:	e8 4e fa ff ff       	call   801084 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
	return ;
  801639:	90                   	nop
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 2a                	push   $0x2a
  80164f:	e8 30 fa ff ff       	call   801084 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
	return;
  801657:	90                   	nop
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	50                   	push   %eax
  801669:	6a 2b                	push   $0x2b
  80166b:	e8 14 fa ff ff       	call   801084 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	ff 75 08             	pushl  0x8(%ebp)
  801684:	6a 2c                	push   $0x2c
  801686:	e8 f9 f9 ff ff       	call   801084 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
	return;
  80168e:	90                   	nop
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 2d                	push   $0x2d
  8016a2:	e8 dd f9 ff ff       	call   801084 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
	return;
  8016aa:	90                   	nop
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	68 38 21 80 00       	push   $0x802138
  8016bb:	6a 09                	push   $0x9
  8016bd:	68 60 21 80 00       	push   $0x802160
  8016c2:	e8 0d 01 00 00       	call   8017d4 <_panic>

008016c7 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	68 70 21 80 00       	push   $0x802170
  8016d5:	6a 10                	push   $0x10
  8016d7:	68 60 21 80 00       	push   $0x802160
  8016dc:	e8 f3 00 00 00       	call   8017d4 <_panic>

008016e1 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	68 98 21 80 00       	push   $0x802198
  8016ef:	6a 18                	push   $0x18
  8016f1:	68 60 21 80 00       	push   $0x802160
  8016f6:	e8 d9 00 00 00       	call   8017d4 <_panic>

008016fb <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	68 c0 21 80 00       	push   $0x8021c0
  801709:	6a 20                	push   $0x20
  80170b:	68 60 21 80 00       	push   $0x802160
  801710:	e8 bf 00 00 00       	call   8017d4 <_panic>

00801715 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8b 40 10             	mov    0x10(%eax),%eax
}
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801726:	8b 55 08             	mov    0x8(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	c1 e0 02             	shl    $0x2,%eax
  80172e:	01 d0                	add    %edx,%eax
  801730:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801737:	01 d0                	add    %edx,%eax
  801739:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801740:	01 d0                	add    %edx,%eax
  801742:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801749:	01 d0                	add    %edx,%eax
  80174b:	c1 e0 04             	shl    $0x4,%eax
  80174e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801751:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801758:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	50                   	push   %eax
  80175f:	e8 55 fc ff ff       	call   8013b9 <sys_get_virtual_time>
  801764:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801767:	eb 41                	jmp    8017aa <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801769:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	50                   	push   %eax
  801770:	e8 44 fc ff ff       	call   8013b9 <sys_get_virtual_time>
  801775:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801778:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80177b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177e:	29 c2                	sub    %eax,%edx
  801780:	89 d0                	mov    %edx,%eax
  801782:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801785:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178b:	89 d1                	mov    %edx,%ecx
  80178d:	29 c1                	sub    %eax,%ecx
  80178f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801795:	39 c2                	cmp    %eax,%edx
  801797:	0f 97 c0             	seta   %al
  80179a:	0f b6 c0             	movzbl %al,%eax
  80179d:	29 c1                	sub    %eax,%ecx
  80179f:	89 c8                	mov    %ecx,%eax
  8017a1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8017a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b0:	72 b7                	jb     801769 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8017bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8017c2:	eb 03                	jmp    8017c7 <busy_wait+0x12>
  8017c4:	ff 45 fc             	incl   -0x4(%ebp)
  8017c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017cd:	72 f5                	jb     8017c4 <busy_wait+0xf>
	return i;
  8017cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017da:	8d 45 10             	lea    0x10(%ebp),%eax
  8017dd:	83 c0 04             	add    $0x4,%eax
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017e3:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	74 16                	je     801802 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017ec:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	50                   	push   %eax
  8017f5:	68 e8 21 80 00       	push   $0x8021e8
  8017fa:	e8 eb ea ff ff       	call   8002ea <cprintf>
  8017ff:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801802:	a1 00 30 80 00       	mov    0x803000,%eax
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	50                   	push   %eax
  80180e:	68 ed 21 80 00       	push   $0x8021ed
  801813:	e8 d2 ea ff ff       	call   8002ea <cprintf>
  801818:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80181b:	8b 45 10             	mov    0x10(%ebp),%eax
  80181e:	83 ec 08             	sub    $0x8,%esp
  801821:	ff 75 f4             	pushl  -0xc(%ebp)
  801824:	50                   	push   %eax
  801825:	e8 55 ea ff ff       	call   80027f <vcprintf>
  80182a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	6a 00                	push   $0x0
  801832:	68 09 22 80 00       	push   $0x802209
  801837:	e8 43 ea ff ff       	call   80027f <vcprintf>
  80183c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80183f:	e8 c4 e9 ff ff       	call   800208 <exit>

	// should not return here
	while (1) ;
  801844:	eb fe                	jmp    801844 <_panic+0x70>

00801846 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80184c:	a1 04 30 80 00       	mov    0x803004,%eax
  801851:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185a:	39 c2                	cmp    %eax,%edx
  80185c:	74 14                	je     801872 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 0c 22 80 00       	push   $0x80220c
  801866:	6a 26                	push   $0x26
  801868:	68 58 22 80 00       	push   $0x802258
  80186d:	e8 62 ff ff ff       	call   8017d4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801872:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801879:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801880:	e9 c5 00 00 00       	jmp    80194a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801888:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	01 d0                	add    %edx,%eax
  801894:	8b 00                	mov    (%eax),%eax
  801896:	85 c0                	test   %eax,%eax
  801898:	75 08                	jne    8018a2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80189a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80189d:	e9 a5 00 00 00       	jmp    801947 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018b0:	eb 69                	jmp    80191b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b7:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8018bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018c0:	89 d0                	mov    %edx,%eax
  8018c2:	01 c0                	add    %eax,%eax
  8018c4:	01 d0                	add    %edx,%eax
  8018c6:	c1 e0 03             	shl    $0x3,%eax
  8018c9:	01 c8                	add    %ecx,%eax
  8018cb:	8a 40 04             	mov    0x4(%eax),%al
  8018ce:	84 c0                	test   %al,%al
  8018d0:	75 46                	jne    801918 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d7:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8018dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	01 c0                	add    %eax,%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	c1 e0 03             	shl    $0x3,%eax
  8018e9:	01 c8                	add    %ecx,%eax
  8018eb:	8b 00                	mov    (%eax),%eax
  8018ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	01 c8                	add    %ecx,%eax
  801909:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80190b:	39 c2                	cmp    %eax,%edx
  80190d:	75 09                	jne    801918 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80190f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801916:	eb 15                	jmp    80192d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801918:	ff 45 e8             	incl   -0x18(%ebp)
  80191b:	a1 04 30 80 00       	mov    0x803004,%eax
  801920:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801926:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	77 85                	ja     8018b2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80192d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801931:	75 14                	jne    801947 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	68 64 22 80 00       	push   $0x802264
  80193b:	6a 3a                	push   $0x3a
  80193d:	68 58 22 80 00       	push   $0x802258
  801942:	e8 8d fe ff ff       	call   8017d4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801947:	ff 45 f0             	incl   -0x10(%ebp)
  80194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801950:	0f 8c 2f ff ff ff    	jl     801885 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801956:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80195d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801964:	eb 26                	jmp    80198c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801966:	a1 04 30 80 00       	mov    0x803004,%eax
  80196b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801971:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801974:	89 d0                	mov    %edx,%eax
  801976:	01 c0                	add    %eax,%eax
  801978:	01 d0                	add    %edx,%eax
  80197a:	c1 e0 03             	shl    $0x3,%eax
  80197d:	01 c8                	add    %ecx,%eax
  80197f:	8a 40 04             	mov    0x4(%eax),%al
  801982:	3c 01                	cmp    $0x1,%al
  801984:	75 03                	jne    801989 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801986:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801989:	ff 45 e0             	incl   -0x20(%ebp)
  80198c:	a1 04 30 80 00       	mov    0x803004,%eax
  801991:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199a:	39 c2                	cmp    %eax,%edx
  80199c:	77 c8                	ja     801966 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019a4:	74 14                	je     8019ba <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 b8 22 80 00       	push   $0x8022b8
  8019ae:	6a 44                	push   $0x44
  8019b0:	68 58 22 80 00       	push   $0x802258
  8019b5:	e8 1a fe ff ff       	call   8017d4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    
  8019bd:	66 90                	xchg   %ax,%ax
  8019bf:	90                   	nop

008019c0 <__udivdi3>:
  8019c0:	55                   	push   %ebp
  8019c1:	57                   	push   %edi
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 1c             	sub    $0x1c,%esp
  8019c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d7:	89 ca                	mov    %ecx,%edx
  8019d9:	89 f8                	mov    %edi,%eax
  8019db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019df:	85 f6                	test   %esi,%esi
  8019e1:	75 2d                	jne    801a10 <__udivdi3+0x50>
  8019e3:	39 cf                	cmp    %ecx,%edi
  8019e5:	77 65                	ja     801a4c <__udivdi3+0x8c>
  8019e7:	89 fd                	mov    %edi,%ebp
  8019e9:	85 ff                	test   %edi,%edi
  8019eb:	75 0b                	jne    8019f8 <__udivdi3+0x38>
  8019ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f2:	31 d2                	xor    %edx,%edx
  8019f4:	f7 f7                	div    %edi
  8019f6:	89 c5                	mov    %eax,%ebp
  8019f8:	31 d2                	xor    %edx,%edx
  8019fa:	89 c8                	mov    %ecx,%eax
  8019fc:	f7 f5                	div    %ebp
  8019fe:	89 c1                	mov    %eax,%ecx
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f5                	div    %ebp
  801a04:	89 cf                	mov    %ecx,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	39 ce                	cmp    %ecx,%esi
  801a12:	77 28                	ja     801a3c <__udivdi3+0x7c>
  801a14:	0f bd fe             	bsr    %esi,%edi
  801a17:	83 f7 1f             	xor    $0x1f,%edi
  801a1a:	75 40                	jne    801a5c <__udivdi3+0x9c>
  801a1c:	39 ce                	cmp    %ecx,%esi
  801a1e:	72 0a                	jb     801a2a <__udivdi3+0x6a>
  801a20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a24:	0f 87 9e 00 00 00    	ja     801ac8 <__udivdi3+0x108>
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	89 fa                	mov    %edi,%edx
  801a31:	83 c4 1c             	add    $0x1c,%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5f                   	pop    %edi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    
  801a39:	8d 76 00             	lea    0x0(%esi),%esi
  801a3c:	31 ff                	xor    %edi,%edi
  801a3e:	31 c0                	xor    %eax,%eax
  801a40:	89 fa                	mov    %edi,%edx
  801a42:	83 c4 1c             	add    $0x1c,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5f                   	pop    %edi
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    
  801a4a:	66 90                	xchg   %ax,%ax
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	f7 f7                	div    %edi
  801a50:	31 ff                	xor    %edi,%edi
  801a52:	89 fa                	mov    %edi,%edx
  801a54:	83 c4 1c             	add    $0x1c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
  801a5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a61:	89 eb                	mov    %ebp,%ebx
  801a63:	29 fb                	sub    %edi,%ebx
  801a65:	89 f9                	mov    %edi,%ecx
  801a67:	d3 e6                	shl    %cl,%esi
  801a69:	89 c5                	mov    %eax,%ebp
  801a6b:	88 d9                	mov    %bl,%cl
  801a6d:	d3 ed                	shr    %cl,%ebp
  801a6f:	89 e9                	mov    %ebp,%ecx
  801a71:	09 f1                	or     %esi,%ecx
  801a73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a77:	89 f9                	mov    %edi,%ecx
  801a79:	d3 e0                	shl    %cl,%eax
  801a7b:	89 c5                	mov    %eax,%ebp
  801a7d:	89 d6                	mov    %edx,%esi
  801a7f:	88 d9                	mov    %bl,%cl
  801a81:	d3 ee                	shr    %cl,%esi
  801a83:	89 f9                	mov    %edi,%ecx
  801a85:	d3 e2                	shl    %cl,%edx
  801a87:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a8b:	88 d9                	mov    %bl,%cl
  801a8d:	d3 e8                	shr    %cl,%eax
  801a8f:	09 c2                	or     %eax,%edx
  801a91:	89 d0                	mov    %edx,%eax
  801a93:	89 f2                	mov    %esi,%edx
  801a95:	f7 74 24 0c          	divl   0xc(%esp)
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	f7 e5                	mul    %ebp
  801a9f:	39 d6                	cmp    %edx,%esi
  801aa1:	72 19                	jb     801abc <__udivdi3+0xfc>
  801aa3:	74 0b                	je     801ab0 <__udivdi3+0xf0>
  801aa5:	89 d8                	mov    %ebx,%eax
  801aa7:	31 ff                	xor    %edi,%edi
  801aa9:	e9 58 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801aae:	66 90                	xchg   %ax,%ax
  801ab0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ab4:	89 f9                	mov    %edi,%ecx
  801ab6:	d3 e2                	shl    %cl,%edx
  801ab8:	39 c2                	cmp    %eax,%edx
  801aba:	73 e9                	jae    801aa5 <__udivdi3+0xe5>
  801abc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801abf:	31 ff                	xor    %edi,%edi
  801ac1:	e9 40 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801ac6:	66 90                	xchg   %ax,%ax
  801ac8:	31 c0                	xor    %eax,%eax
  801aca:	e9 37 ff ff ff       	jmp    801a06 <__udivdi3+0x46>
  801acf:	90                   	nop

00801ad0 <__umoddi3>:
  801ad0:	55                   	push   %ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801adb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801adf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ae3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ae7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aeb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aef:	89 f3                	mov    %esi,%ebx
  801af1:	89 fa                	mov    %edi,%edx
  801af3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af7:	89 34 24             	mov    %esi,(%esp)
  801afa:	85 c0                	test   %eax,%eax
  801afc:	75 1a                	jne    801b18 <__umoddi3+0x48>
  801afe:	39 f7                	cmp    %esi,%edi
  801b00:	0f 86 a2 00 00 00    	jbe    801ba8 <__umoddi3+0xd8>
  801b06:	89 c8                	mov    %ecx,%eax
  801b08:	89 f2                	mov    %esi,%edx
  801b0a:	f7 f7                	div    %edi
  801b0c:	89 d0                	mov    %edx,%eax
  801b0e:	31 d2                	xor    %edx,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	39 f0                	cmp    %esi,%eax
  801b1a:	0f 87 ac 00 00 00    	ja     801bcc <__umoddi3+0xfc>
  801b20:	0f bd e8             	bsr    %eax,%ebp
  801b23:	83 f5 1f             	xor    $0x1f,%ebp
  801b26:	0f 84 ac 00 00 00    	je     801bd8 <__umoddi3+0x108>
  801b2c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b31:	29 ef                	sub    %ebp,%edi
  801b33:	89 fe                	mov    %edi,%esi
  801b35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 e0                	shl    %cl,%eax
  801b3d:	89 d7                	mov    %edx,%edi
  801b3f:	89 f1                	mov    %esi,%ecx
  801b41:	d3 ef                	shr    %cl,%edi
  801b43:	09 c7                	or     %eax,%edi
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 e2                	shl    %cl,%edx
  801b49:	89 14 24             	mov    %edx,(%esp)
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	d3 e0                	shl    %cl,%eax
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b56:	d3 e0                	shl    %cl,%eax
  801b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b60:	89 f1                	mov    %esi,%ecx
  801b62:	d3 e8                	shr    %cl,%eax
  801b64:	09 d0                	or     %edx,%eax
  801b66:	d3 eb                	shr    %cl,%ebx
  801b68:	89 da                	mov    %ebx,%edx
  801b6a:	f7 f7                	div    %edi
  801b6c:	89 d3                	mov    %edx,%ebx
  801b6e:	f7 24 24             	mull   (%esp)
  801b71:	89 c6                	mov    %eax,%esi
  801b73:	89 d1                	mov    %edx,%ecx
  801b75:	39 d3                	cmp    %edx,%ebx
  801b77:	0f 82 87 00 00 00    	jb     801c04 <__umoddi3+0x134>
  801b7d:	0f 84 91 00 00 00    	je     801c14 <__umoddi3+0x144>
  801b83:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b87:	29 f2                	sub    %esi,%edx
  801b89:	19 cb                	sbb    %ecx,%ebx
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b91:	d3 e0                	shl    %cl,%eax
  801b93:	89 e9                	mov    %ebp,%ecx
  801b95:	d3 ea                	shr    %cl,%edx
  801b97:	09 d0                	or     %edx,%eax
  801b99:	89 e9                	mov    %ebp,%ecx
  801b9b:	d3 eb                	shr    %cl,%ebx
  801b9d:	89 da                	mov    %ebx,%edx
  801b9f:	83 c4 1c             	add    $0x1c,%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5f                   	pop    %edi
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    
  801ba7:	90                   	nop
  801ba8:	89 fd                	mov    %edi,%ebp
  801baa:	85 ff                	test   %edi,%edi
  801bac:	75 0b                	jne    801bb9 <__umoddi3+0xe9>
  801bae:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb3:	31 d2                	xor    %edx,%edx
  801bb5:	f7 f7                	div    %edi
  801bb7:	89 c5                	mov    %eax,%ebp
  801bb9:	89 f0                	mov    %esi,%eax
  801bbb:	31 d2                	xor    %edx,%edx
  801bbd:	f7 f5                	div    %ebp
  801bbf:	89 c8                	mov    %ecx,%eax
  801bc1:	f7 f5                	div    %ebp
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	e9 44 ff ff ff       	jmp    801b0e <__umoddi3+0x3e>
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	89 c8                	mov    %ecx,%eax
  801bce:	89 f2                	mov    %esi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	3b 04 24             	cmp    (%esp),%eax
  801bdb:	72 06                	jb     801be3 <__umoddi3+0x113>
  801bdd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801be1:	77 0f                	ja     801bf2 <__umoddi3+0x122>
  801be3:	89 f2                	mov    %esi,%edx
  801be5:	29 f9                	sub    %edi,%ecx
  801be7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801beb:	89 14 24             	mov    %edx,(%esp)
  801bee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bf6:	8b 14 24             	mov    (%esp),%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	2b 04 24             	sub    (%esp),%eax
  801c07:	19 fa                	sbb    %edi,%edx
  801c09:	89 d1                	mov    %edx,%ecx
  801c0b:	89 c6                	mov    %eax,%esi
  801c0d:	e9 71 ff ff ff       	jmp    801b83 <__umoddi3+0xb3>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c18:	72 ea                	jb     801c04 <__umoddi3+0x134>
  801c1a:	89 d9                	mov    %ebx,%ecx
  801c1c:	e9 62 ff ff ff       	jmp    801b83 <__umoddi3+0xb3>
