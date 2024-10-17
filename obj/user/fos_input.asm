
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 20 1e 80 00       	push   $0x801e20
  80005e:	e8 2c 0a 00 00       	call   800a8f <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 7f 0e 00 00       	call   800ef8 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 3f 18 00 00       	call   8018cb <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 3c 1e 80 00       	push   $0x801e3c
  80009e:	e8 ec 09 00 00       	call   800a8f <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 3f 0e 00 00       	call   800ef8 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 59 1e 80 00       	push   $0x801e59
  8000d0:	e8 54 02 00 00       	call   800329 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 a1 14 00 00       	call   801587 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 06             	shl    $0x6,%eax
  8000f1:	29 d0                	sub    %edx,%eax
  8000f3:	c1 e0 02             	shl    $0x2,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000ff:	01 c8                	add    %ecx,%eax
  800101:	c1 e0 03             	shl    $0x3,%eax
  800104:	01 d0                	add    %edx,%eax
  800106:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80010d:	29 c2                	sub    %eax,%edx
  80010f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800116:	89 c2                	mov    %eax,%edx
  800118:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80011e:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800123:	a1 04 30 80 00       	mov    0x803004,%eax
  800128:	8a 40 20             	mov    0x20(%eax),%al
  80012b:	84 c0                	test   %al,%al
  80012d:	74 0d                	je     80013c <libmain+0x61>
		binaryname = myEnv->prog_name;
  80012f:	a1 04 30 80 00       	mov    0x803004,%eax
  800134:	83 c0 20             	add    $0x20,%eax
  800137:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800140:	7e 0a                	jle    80014c <libmain+0x71>
		binaryname = argv[0];
  800142:	8b 45 0c             	mov    0xc(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	ff 75 08             	pushl  0x8(%ebp)
  800155:	e8 de fe ff ff       	call   800038 <_main>
  80015a:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80015d:	e8 a9 11 00 00       	call   80130b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 8c 1e 80 00       	push   $0x801e8c
  80016a:	e8 8d 01 00 00       	call   8002fc <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800172:	a1 04 30 80 00       	mov    0x803004,%eax
  800177:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80017d:	a1 04 30 80 00       	mov    0x803004,%eax
  800182:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	52                   	push   %edx
  80018c:	50                   	push   %eax
  80018d:	68 b4 1e 80 00       	push   $0x801eb4
  800192:	e8 65 01 00 00       	call   8002fc <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80019a:	a1 04 30 80 00       	mov    0x803004,%eax
  80019f:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8001b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001bb:	51                   	push   %ecx
  8001bc:	52                   	push   %edx
  8001bd:	50                   	push   %eax
  8001be:	68 dc 1e 80 00       	push   $0x801edc
  8001c3:	e8 34 01 00 00       	call   8002fc <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d0:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	50                   	push   %eax
  8001da:	68 34 1f 80 00       	push   $0x801f34
  8001df:	e8 18 01 00 00       	call   8002fc <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	68 8c 1e 80 00       	push   $0x801e8c
  8001ef:	e8 08 01 00 00       	call   8002fc <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001f7:	e8 29 11 00 00       	call   801325 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001fc:	e8 19 00 00 00       	call   80021a <exit>
}
  800201:	90                   	nop
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	6a 00                	push   $0x0
  80020f:	e8 3f 13 00 00       	call   801553 <sys_destroy_env>
  800214:	83 c4 10             	add    $0x10,%esp
}
  800217:	90                   	nop
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <exit>:

void
exit(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800220:	e8 94 13 00 00       	call   8015b9 <sys_exit_env>
}
  800225:	90                   	nop
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800231:	8b 00                	mov    (%eax),%eax
  800233:	8d 48 01             	lea    0x1(%eax),%ecx
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	89 0a                	mov    %ecx,(%edx)
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	88 d1                	mov    %dl,%cl
  800240:	8b 55 0c             	mov    0xc(%ebp),%edx
  800243:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800251:	75 2c                	jne    80027f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800253:	a0 08 30 80 00       	mov    0x803008,%al
  800258:	0f b6 c0             	movzbl %al,%eax
  80025b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025e:	8b 12                	mov    (%edx),%edx
  800260:	89 d1                	mov    %edx,%ecx
  800262:	8b 55 0c             	mov    0xc(%ebp),%edx
  800265:	83 c2 08             	add    $0x8,%edx
  800268:	83 ec 04             	sub    $0x4,%esp
  80026b:	50                   	push   %eax
  80026c:	51                   	push   %ecx
  80026d:	52                   	push   %edx
  80026e:	e8 56 10 00 00       	call   8012c9 <sys_cputs>
  800273:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	8b 40 04             	mov    0x4(%eax),%eax
  800285:	8d 50 01             	lea    0x1(%eax),%edx
  800288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80028e:	90                   	nop
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a1:	00 00 00 
	b.cnt = 0;
  8002a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ae:	ff 75 0c             	pushl  0xc(%ebp)
  8002b1:	ff 75 08             	pushl  0x8(%ebp)
  8002b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	68 28 02 80 00       	push   $0x800228
  8002c0:	e8 11 02 00 00       	call   8004d6 <vprintfmt>
  8002c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c8:	a0 08 30 80 00       	mov    0x803008,%al
  8002cd:	0f b6 c0             	movzbl %al,%eax
  8002d0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	50                   	push   %eax
  8002da:	52                   	push   %edx
  8002db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e1:	83 c0 08             	add    $0x8,%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 df 0f 00 00       	call   8012c9 <sys_cputs>
  8002ea:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ed:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    

008002fc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800302:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800309:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030f:	8b 45 08             	mov    0x8(%ebp),%eax
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 f4             	pushl  -0xc(%ebp)
  800318:	50                   	push   %eax
  800319:	e8 73 ff ff ff       	call   800291 <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80032f:	e8 d7 0f 00 00       	call   80130b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800334:	8d 45 0c             	lea    0xc(%ebp),%eax
  800337:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	ff 75 f4             	pushl  -0xc(%ebp)
  800343:	50                   	push   %eax
  800344:	e8 48 ff ff ff       	call   800291 <vcprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80034f:	e8 d1 0f 00 00       	call   801325 <sys_unlock_cons>
	return cnt;
  800354:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	53                   	push   %ebx
  80035d:	83 ec 14             	sub    $0x14,%esp
  800360:	8b 45 10             	mov    0x10(%ebp),%eax
  800363:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800366:	8b 45 14             	mov    0x14(%ebp),%eax
  800369:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036c:	8b 45 18             	mov    0x18(%ebp),%eax
  80036f:	ba 00 00 00 00       	mov    $0x0,%edx
  800374:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800377:	77 55                	ja     8003ce <printnum+0x75>
  800379:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80037c:	72 05                	jb     800383 <printnum+0x2a>
  80037e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800381:	77 4b                	ja     8003ce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800383:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800386:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800389:	8b 45 18             	mov    0x18(%ebp),%eax
  80038c:	ba 00 00 00 00       	mov    $0x0,%edx
  800391:	52                   	push   %edx
  800392:	50                   	push   %eax
  800393:	ff 75 f4             	pushl  -0xc(%ebp)
  800396:	ff 75 f0             	pushl  -0x10(%ebp)
  800399:	e8 06 18 00 00       	call   801ba4 <__udivdi3>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	ff 75 20             	pushl  0x20(%ebp)
  8003a7:	53                   	push   %ebx
  8003a8:	ff 75 18             	pushl  0x18(%ebp)
  8003ab:	52                   	push   %edx
  8003ac:	50                   	push   %eax
  8003ad:	ff 75 0c             	pushl  0xc(%ebp)
  8003b0:	ff 75 08             	pushl  0x8(%ebp)
  8003b3:	e8 a1 ff ff ff       	call   800359 <printnum>
  8003b8:	83 c4 20             	add    $0x20,%esp
  8003bb:	eb 1a                	jmp    8003d7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 20             	pushl  0x20(%ebp)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	ff d0                	call   *%eax
  8003cb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ce:	ff 4d 1c             	decl   0x1c(%ebp)
  8003d1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d5:	7f e6                	jg     8003bd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e5:	53                   	push   %ebx
  8003e6:	51                   	push   %ecx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	e8 c6 18 00 00       	call   801cb4 <__umoddi3>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	05 74 21 80 00       	add    $0x802174,%eax
  8003f6:	8a 00                	mov    (%eax),%al
  8003f8:	0f be c0             	movsbl %al,%eax
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 0c             	pushl  0xc(%ebp)
  800401:	50                   	push   %eax
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	ff d0                	call   *%eax
  800407:	83 c4 10             	add    $0x10,%esp
}
  80040a:	90                   	nop
  80040b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800413:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800417:	7e 1c                	jle    800435 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	8d 50 08             	lea    0x8(%eax),%edx
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	89 10                	mov    %edx,(%eax)
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	83 e8 08             	sub    $0x8,%eax
  80042e:	8b 50 04             	mov    0x4(%eax),%edx
  800431:	8b 00                	mov    (%eax),%eax
  800433:	eb 40                	jmp    800475 <getuint+0x65>
	else if (lflag)
  800435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800439:	74 1e                	je     800459 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	8d 50 04             	lea    0x4(%eax),%edx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	89 10                	mov    %edx,(%eax)
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 e8 04             	sub    $0x4,%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	eb 1c                	jmp    800475 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	8d 50 04             	lea    0x4(%eax),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	89 10                	mov    %edx,(%eax)
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	83 e8 04             	sub    $0x4,%eax
  80046e:	8b 00                	mov    (%eax),%eax
  800470:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047e:	7e 1c                	jle    80049c <getint+0x25>
		return va_arg(*ap, long long);
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	8d 50 08             	lea    0x8(%eax),%edx
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	89 10                	mov    %edx,(%eax)
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 e8 08             	sub    $0x8,%eax
  800495:	8b 50 04             	mov    0x4(%eax),%edx
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	eb 38                	jmp    8004d4 <getint+0x5d>
	else if (lflag)
  80049c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a0:	74 1a                	je     8004bc <getint+0x45>
		return va_arg(*ap, long);
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	89 10                	mov    %edx,(%eax)
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	83 e8 04             	sub    $0x4,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	99                   	cltd   
  8004ba:	eb 18                	jmp    8004d4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	8d 50 04             	lea    0x4(%eax),%edx
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	89 10                	mov    %edx,(%eax)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	83 e8 04             	sub    $0x4,%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	99                   	cltd   
}
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	56                   	push   %esi
  8004da:	53                   	push   %ebx
  8004db:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004de:	eb 17                	jmp    8004f7 <vprintfmt+0x21>
			if (ch == '\0')
  8004e0:	85 db                	test   %ebx,%ebx
  8004e2:	0f 84 c1 03 00 00    	je     8008a9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	53                   	push   %ebx
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	ff d0                	call   *%eax
  8004f4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800500:	8a 00                	mov    (%eax),%al
  800502:	0f b6 d8             	movzbl %al,%ebx
  800505:	83 fb 25             	cmp    $0x25,%ebx
  800508:	75 d6                	jne    8004e0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80050a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80050e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800515:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80051c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800523:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	8b 45 10             	mov    0x10(%ebp),%eax
  80052d:	8d 50 01             	lea    0x1(%eax),%edx
  800530:	89 55 10             	mov    %edx,0x10(%ebp)
  800533:	8a 00                	mov    (%eax),%al
  800535:	0f b6 d8             	movzbl %al,%ebx
  800538:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80053b:	83 f8 5b             	cmp    $0x5b,%eax
  80053e:	0f 87 3d 03 00 00    	ja     800881 <vprintfmt+0x3ab>
  800544:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  80054b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80054d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800551:	eb d7                	jmp    80052a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800553:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800557:	eb d1                	jmp    80052a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800559:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800560:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800563:	89 d0                	mov    %edx,%eax
  800565:	c1 e0 02             	shl    $0x2,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	01 c0                	add    %eax,%eax
  80056c:	01 d8                	add    %ebx,%eax
  80056e:	83 e8 30             	sub    $0x30,%eax
  800571:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800574:	8b 45 10             	mov    0x10(%ebp),%eax
  800577:	8a 00                	mov    (%eax),%al
  800579:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80057c:	83 fb 2f             	cmp    $0x2f,%ebx
  80057f:	7e 3e                	jle    8005bf <vprintfmt+0xe9>
  800581:	83 fb 39             	cmp    $0x39,%ebx
  800584:	7f 39                	jg     8005bf <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800586:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800589:	eb d5                	jmp    800560 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	83 c0 04             	add    $0x4,%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	83 e8 04             	sub    $0x4,%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80059f:	eb 1f                	jmp    8005c0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a5:	79 83                	jns    80052a <vprintfmt+0x54>
				width = 0;
  8005a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ae:	e9 77 ff ff ff       	jmp    80052a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005b3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005ba:	e9 6b ff ff ff       	jmp    80052a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005bf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c4:	0f 89 60 ff ff ff    	jns    80052a <vprintfmt+0x54>
				width = precision, precision = -1;
  8005ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d7:	e9 4e ff ff ff       	jmp    80052a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005dc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005df:	e9 46 ff ff ff       	jmp    80052a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	83 c0 04             	add    $0x4,%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	83 e8 04             	sub    $0x4,%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 0c             	pushl  0xc(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	ff d0                	call   *%eax
  800601:	83 c4 10             	add    $0x10,%esp
			break;
  800604:	e9 9b 02 00 00       	jmp    8008a4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	83 c0 04             	add    $0x4,%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	83 e8 04             	sub    $0x4,%eax
  800618:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80061a:	85 db                	test   %ebx,%ebx
  80061c:	79 02                	jns    800620 <vprintfmt+0x14a>
				err = -err;
  80061e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800620:	83 fb 64             	cmp    $0x64,%ebx
  800623:	7f 0b                	jg     800630 <vprintfmt+0x15a>
  800625:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  80062c:	85 f6                	test   %esi,%esi
  80062e:	75 19                	jne    800649 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800630:	53                   	push   %ebx
  800631:	68 85 21 80 00       	push   $0x802185
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 70 02 00 00       	call   8008b1 <printfmt>
  800641:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800644:	e9 5b 02 00 00       	jmp    8008a4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800649:	56                   	push   %esi
  80064a:	68 8e 21 80 00       	push   $0x80218e
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	ff 75 08             	pushl  0x8(%ebp)
  800655:	e8 57 02 00 00       	call   8008b1 <printfmt>
  80065a:	83 c4 10             	add    $0x10,%esp
			break;
  80065d:	e9 42 02 00 00       	jmp    8008a4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	83 c0 04             	add    $0x4,%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	83 e8 04             	sub    $0x4,%eax
  800671:	8b 30                	mov    (%eax),%esi
  800673:	85 f6                	test   %esi,%esi
  800675:	75 05                	jne    80067c <vprintfmt+0x1a6>
				p = "(null)";
  800677:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  80067c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800680:	7e 6d                	jle    8006ef <vprintfmt+0x219>
  800682:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800686:	74 67                	je     8006ef <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	50                   	push   %eax
  80068f:	56                   	push   %esi
  800690:	e8 26 05 00 00       	call   800bbb <strnlen>
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80069b:	eb 16                	jmp    8006b3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80069d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	50                   	push   %eax
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	ff d0                	call   *%eax
  8006ad:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b7:	7f e4                	jg     80069d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b9:	eb 34                	jmp    8006ef <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006bf:	74 1c                	je     8006dd <vprintfmt+0x207>
  8006c1:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c4:	7e 05                	jle    8006cb <vprintfmt+0x1f5>
  8006c6:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c9:	7e 12                	jle    8006dd <vprintfmt+0x207>
					putch('?', putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	6a 3f                	push   $0x3f
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	eb 0f                	jmp    8006ec <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	53                   	push   %ebx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	ff d0                	call   *%eax
  8006e9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	8d 70 01             	lea    0x1(%eax),%esi
  8006f4:	8a 00                	mov    (%eax),%al
  8006f6:	0f be d8             	movsbl %al,%ebx
  8006f9:	85 db                	test   %ebx,%ebx
  8006fb:	74 24                	je     800721 <vprintfmt+0x24b>
  8006fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800701:	78 b8                	js     8006bb <vprintfmt+0x1e5>
  800703:	ff 4d e0             	decl   -0x20(%ebp)
  800706:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070a:	79 af                	jns    8006bb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070c:	eb 13                	jmp    800721 <vprintfmt+0x24b>
				putch(' ', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	6a 20                	push   $0x20
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071e:	ff 4d e4             	decl   -0x1c(%ebp)
  800721:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800725:	7f e7                	jg     80070e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800727:	e9 78 01 00 00       	jmp    8008a4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 e8             	pushl  -0x18(%ebp)
  800732:	8d 45 14             	lea    0x14(%ebp),%eax
  800735:	50                   	push   %eax
  800736:	e8 3c fd ff ff       	call   800477 <getint>
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800741:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074a:	85 d2                	test   %edx,%edx
  80074c:	79 23                	jns    800771 <vprintfmt+0x29b>
				putch('-', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 2d                	push   $0x2d
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800764:	f7 d8                	neg    %eax
  800766:	83 d2 00             	adc    $0x0,%edx
  800769:	f7 da                	neg    %edx
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800771:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800778:	e9 bc 00 00 00       	jmp    800839 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 e8             	pushl  -0x18(%ebp)
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	e8 84 fc ff ff       	call   800410 <getuint>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800792:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800795:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80079c:	e9 98 00 00 00       	jmp    800839 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 58                	push   $0x58
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 0c             	pushl  0xc(%ebp)
  8007b7:	6a 58                	push   $0x58
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	6a 58                	push   $0x58
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	ff d0                	call   *%eax
  8007ce:	83 c4 10             	add    $0x10,%esp
			break;
  8007d1:	e9 ce 00 00 00       	jmp    8008a4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	6a 30                	push   $0x30
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	6a 78                	push   $0x78
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	83 e8 04             	sub    $0x4,%eax
  800805:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800811:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800818:	eb 1f                	jmp    800839 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 e8             	pushl  -0x18(%ebp)
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
  800823:	50                   	push   %eax
  800824:	e8 e7 fb ff ff       	call   800410 <getuint>
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800832:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800839:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80083d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800840:	83 ec 04             	sub    $0x4,%esp
  800843:	52                   	push   %edx
  800844:	ff 75 e4             	pushl  -0x1c(%ebp)
  800847:	50                   	push   %eax
  800848:	ff 75 f4             	pushl  -0xc(%ebp)
  80084b:	ff 75 f0             	pushl  -0x10(%ebp)
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	e8 00 fb ff ff       	call   800359 <printnum>
  800859:	83 c4 20             	add    $0x20,%esp
			break;
  80085c:	eb 46                	jmp    8008a4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	53                   	push   %ebx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			break;
  80086d:	eb 35                	jmp    8008a4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80086f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800876:	eb 2c                	jmp    8008a4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800878:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80087f:	eb 23                	jmp    8008a4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	6a 25                	push   $0x25
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	ff d0                	call   *%eax
  80088e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800891:	ff 4d 10             	decl   0x10(%ebp)
  800894:	eb 03                	jmp    800899 <vprintfmt+0x3c3>
  800896:	ff 4d 10             	decl   0x10(%ebp)
  800899:	8b 45 10             	mov    0x10(%ebp),%eax
  80089c:	48                   	dec    %eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	3c 25                	cmp    $0x25,%al
  8008a1:	75 f3                	jne    800896 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008a3:	90                   	nop
		}
	}
  8008a4:	e9 35 fc ff ff       	jmp    8004de <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008a9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008b7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ba:	83 c0 04             	add    $0x4,%eax
  8008bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ca:	ff 75 08             	pushl  0x8(%ebp)
  8008cd:	e8 04 fc ff ff       	call   8004d6 <vprintfmt>
  8008d2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d5:	90                   	nop
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008de:	8b 40 08             	mov    0x8(%eax),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 10                	mov    (%eax),%edx
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f2:	8b 40 04             	mov    0x4(%eax),%eax
  8008f5:	39 c2                	cmp    %eax,%edx
  8008f7:	73 12                	jae    80090b <sprintputch+0x33>
		*b->buf++ = ch;
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 48 01             	lea    0x1(%eax),%ecx
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
  800904:	89 0a                	mov    %ecx,(%edx)
  800906:	8b 55 08             	mov    0x8(%ebp),%edx
  800909:	88 10                	mov    %dl,(%eax)
}
  80090b:	90                   	nop
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	01 d0                	add    %edx,%eax
  800925:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800928:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800933:	74 06                	je     80093b <vsnprintf+0x2d>
  800935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800939:	7f 07                	jg     800942 <vsnprintf+0x34>
		return -E_INVAL;
  80093b:	b8 03 00 00 00       	mov    $0x3,%eax
  800940:	eb 20                	jmp    800962 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800942:	ff 75 14             	pushl  0x14(%ebp)
  800945:	ff 75 10             	pushl  0x10(%ebp)
  800948:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094b:	50                   	push   %eax
  80094c:	68 d8 08 80 00       	push   $0x8008d8
  800951:	e8 80 fb ff ff       	call   8004d6 <vprintfmt>
  800956:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096a:	8d 45 10             	lea    0x10(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800973:	8b 45 10             	mov    0x10(%ebp),%eax
  800976:	ff 75 f4             	pushl  -0xc(%ebp)
  800979:	50                   	push   %eax
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	ff 75 08             	pushl  0x8(%ebp)
  800980:	e8 89 ff ff ff       	call   80090e <vsnprintf>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80098b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800996:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80099a:	74 13                	je     8009af <readline+0x1f>
		cprintf("%s", prompt);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	68 08 23 80 00       	push   $0x802308
  8009a7:	e8 50 f9 ff ff       	call   8002fc <cprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009b6:	83 ec 0c             	sub    $0xc,%esp
  8009b9:	6a 00                	push   $0x0
  8009bb:	e8 f1 0f 00 00       	call   8019b1 <iscons>
  8009c0:	83 c4 10             	add    $0x10,%esp
  8009c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009c6:	e8 d3 0f 00 00       	call   80199e <getchar>
  8009cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009d2:	79 22                	jns    8009f6 <readline+0x66>
			if (c != -E_EOF)
  8009d4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009d8:	0f 84 ad 00 00 00    	je     800a8b <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8009e4:	68 0b 23 80 00       	push   $0x80230b
  8009e9:	e8 0e f9 ff ff       	call   8002fc <cprintf>
  8009ee:	83 c4 10             	add    $0x10,%esp
			break;
  8009f1:	e9 95 00 00 00       	jmp    800a8b <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009f6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009fa:	7e 34                	jle    800a30 <readline+0xa0>
  8009fc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a03:	7f 2b                	jg     800a30 <readline+0xa0>
			if (echoing)
  800a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a09:	74 0e                	je     800a19 <readline+0x89>
				cputchar(c);
  800a0b:	83 ec 0c             	sub    $0xc,%esp
  800a0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800a11:	e8 69 0f 00 00       	call   80197f <cputchar>
  800a16:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1c:	8d 50 01             	lea    0x1(%eax),%edx
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a22:	89 c2                	mov    %eax,%edx
  800a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a27:	01 d0                	add    %edx,%eax
  800a29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a2c:	88 10                	mov    %dl,(%eax)
  800a2e:	eb 56                	jmp    800a86 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a30:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a34:	75 1f                	jne    800a55 <readline+0xc5>
  800a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a3a:	7e 19                	jle    800a55 <readline+0xc5>
			if (echoing)
  800a3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a40:	74 0e                	je     800a50 <readline+0xc0>
				cputchar(c);
  800a42:	83 ec 0c             	sub    $0xc,%esp
  800a45:	ff 75 ec             	pushl  -0x14(%ebp)
  800a48:	e8 32 0f 00 00       	call   80197f <cputchar>
  800a4d:	83 c4 10             	add    $0x10,%esp

			i--;
  800a50:	ff 4d f4             	decl   -0xc(%ebp)
  800a53:	eb 31                	jmp    800a86 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a55:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a59:	74 0a                	je     800a65 <readline+0xd5>
  800a5b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a5f:	0f 85 61 ff ff ff    	jne    8009c6 <readline+0x36>
			if (echoing)
  800a65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a69:	74 0e                	je     800a79 <readline+0xe9>
				cputchar(c);
  800a6b:	83 ec 0c             	sub    $0xc,%esp
  800a6e:	ff 75 ec             	pushl  -0x14(%ebp)
  800a71:	e8 09 0f 00 00       	call   80197f <cputchar>
  800a76:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	01 d0                	add    %edx,%eax
  800a81:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a84:	eb 06                	jmp    800a8c <readline+0xfc>
		}
	}
  800a86:	e9 3b ff ff ff       	jmp    8009c6 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a8b:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a8c:	90                   	nop
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a95:	e8 71 08 00 00       	call   80130b <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9e:	74 13                	je     800ab3 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	68 08 23 80 00       	push   $0x802308
  800aab:	e8 4c f8 ff ff       	call   8002fc <cprintf>
  800ab0:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800aba:	83 ec 0c             	sub    $0xc,%esp
  800abd:	6a 00                	push   $0x0
  800abf:	e8 ed 0e 00 00       	call   8019b1 <iscons>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800aca:	e8 cf 0e 00 00       	call   80199e <getchar>
  800acf:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ad2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ad6:	79 22                	jns    800afa <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ad8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800adc:	0f 84 ad 00 00 00    	je     800b8f <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae8:	68 0b 23 80 00       	push   $0x80230b
  800aed:	e8 0a f8 ff ff       	call   8002fc <cprintf>
  800af2:	83 c4 10             	add    $0x10,%esp
				break;
  800af5:	e9 95 00 00 00       	jmp    800b8f <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800afa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800afe:	7e 34                	jle    800b34 <atomic_readline+0xa5>
  800b00:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b07:	7f 2b                	jg     800b34 <atomic_readline+0xa5>
				if (echoing)
  800b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b0d:	74 0e                	je     800b1d <atomic_readline+0x8e>
					cputchar(c);
  800b0f:	83 ec 0c             	sub    $0xc,%esp
  800b12:	ff 75 ec             	pushl  -0x14(%ebp)
  800b15:	e8 65 0e 00 00       	call   80197f <cputchar>
  800b1a:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b20:	8d 50 01             	lea    0x1(%eax),%edx
  800b23:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b26:	89 c2                	mov    %eax,%edx
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b30:	88 10                	mov    %dl,(%eax)
  800b32:	eb 56                	jmp    800b8a <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b34:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b38:	75 1f                	jne    800b59 <atomic_readline+0xca>
  800b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b3e:	7e 19                	jle    800b59 <atomic_readline+0xca>
				if (echoing)
  800b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b44:	74 0e                	je     800b54 <atomic_readline+0xc5>
					cputchar(c);
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4c:	e8 2e 0e 00 00       	call   80197f <cputchar>
  800b51:	83 c4 10             	add    $0x10,%esp
				i--;
  800b54:	ff 4d f4             	decl   -0xc(%ebp)
  800b57:	eb 31                	jmp    800b8a <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b59:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b5d:	74 0a                	je     800b69 <atomic_readline+0xda>
  800b5f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b63:	0f 85 61 ff ff ff    	jne    800aca <atomic_readline+0x3b>
				if (echoing)
  800b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b6d:	74 0e                	je     800b7d <atomic_readline+0xee>
					cputchar(c);
  800b6f:	83 ec 0c             	sub    $0xc,%esp
  800b72:	ff 75 ec             	pushl  -0x14(%ebp)
  800b75:	e8 05 0e 00 00       	call   80197f <cputchar>
  800b7a:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b88:	eb 06                	jmp    800b90 <atomic_readline+0x101>
			}
		}
  800b8a:	e9 3b ff ff ff       	jmp    800aca <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b8f:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b90:	e8 90 07 00 00       	call   801325 <sys_unlock_cons>
}
  800b95:	90                   	nop
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba5:	eb 06                	jmp    800bad <strlen+0x15>
		n++;
  800ba7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800baa:	ff 45 08             	incl   0x8(%ebp)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	75 f1                	jne    800ba7 <strlen+0xf>
		n++;
	return n;
  800bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb9:	c9                   	leave  
  800bba:	c3                   	ret    

00800bbb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc8:	eb 09                	jmp    800bd3 <strnlen+0x18>
		n++;
  800bca:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcd:	ff 45 08             	incl   0x8(%ebp)
  800bd0:	ff 4d 0c             	decl   0xc(%ebp)
  800bd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd7:	74 09                	je     800be2 <strnlen+0x27>
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	84 c0                	test   %al,%al
  800be0:	75 e8                	jne    800bca <strnlen+0xf>
		n++;
	return n;
  800be2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be5:	c9                   	leave  
  800be6:	c3                   	ret    

00800be7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bf3:	90                   	nop
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8d 50 01             	lea    0x1(%eax),%edx
  800bfa:	89 55 08             	mov    %edx,0x8(%ebp)
  800bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c06:	8a 12                	mov    (%edx),%dl
  800c08:	88 10                	mov    %dl,(%eax)
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e4                	jne    800bf4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c28:	eb 1f                	jmp    800c49 <strncpy+0x34>
		*dst++ = *src;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8d 50 01             	lea    0x1(%eax),%edx
  800c30:	89 55 08             	mov    %edx,0x8(%ebp)
  800c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c36:	8a 12                	mov    (%edx),%dl
  800c38:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	74 03                	je     800c46 <strncpy+0x31>
			src++;
  800c43:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c46:	ff 45 fc             	incl   -0x4(%ebp)
  800c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c4f:	72 d9                	jb     800c2a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c66:	74 30                	je     800c98 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c68:	eb 16                	jmp    800c80 <strlcpy+0x2a>
			*dst++ = *src++;
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8d 50 01             	lea    0x1(%eax),%edx
  800c70:	89 55 08             	mov    %edx,0x8(%ebp)
  800c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c7c:	8a 12                	mov    (%edx),%dl
  800c7e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c80:	ff 4d 10             	decl   0x10(%ebp)
  800c83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c87:	74 09                	je     800c92 <strlcpy+0x3c>
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	84 c0                	test   %al,%al
  800c90:	75 d8                	jne    800c6a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9e:	29 c2                	sub    %eax,%edx
  800ca0:	89 d0                	mov    %edx,%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca7:	eb 06                	jmp    800caf <strcmp+0xb>
		p++, q++;
  800ca9:	ff 45 08             	incl   0x8(%ebp)
  800cac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	74 0e                	je     800cc6 <strcmp+0x22>
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 10                	mov    (%eax),%dl
  800cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	38 c2                	cmp    %al,%dl
  800cc4:	74 e3                	je     800ca9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	0f b6 d0             	movzbl %al,%edx
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	0f b6 c0             	movzbl %al,%eax
  800cd6:	29 c2                	sub    %eax,%edx
  800cd8:	89 d0                	mov    %edx,%eax
}
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cdf:	eb 09                	jmp    800cea <strncmp+0xe>
		n--, p++, q++;
  800ce1:	ff 4d 10             	decl   0x10(%ebp)
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cee:	74 17                	je     800d07 <strncmp+0x2b>
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	84 c0                	test   %al,%al
  800cf7:	74 0e                	je     800d07 <strncmp+0x2b>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 10                	mov    (%eax),%dl
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	38 c2                	cmp    %al,%dl
  800d05:	74 da                	je     800ce1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	75 07                	jne    800d14 <strncmp+0x38>
		return 0;
  800d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d12:	eb 14                	jmp    800d28 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f b6 d0             	movzbl %al,%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f b6 c0             	movzbl %al,%eax
  800d24:	29 c2                	sub    %eax,%edx
  800d26:	89 d0                	mov    %edx,%eax
}
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 04             	sub    $0x4,%esp
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d36:	eb 12                	jmp    800d4a <strchr+0x20>
		if (*s == c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d40:	75 05                	jne    800d47 <strchr+0x1d>
			return (char *) s;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	eb 11                	jmp    800d58 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d47:	ff 45 08             	incl   0x8(%ebp)
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	84 c0                	test   %al,%al
  800d51:	75 e5                	jne    800d38 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 04             	sub    $0x4,%esp
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d66:	eb 0d                	jmp    800d75 <strfind+0x1b>
		if (*s == c)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d70:	74 0e                	je     800d80 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	75 ea                	jne    800d68 <strfind+0xe>
  800d7e:	eb 01                	jmp    800d81 <strfind+0x27>
		if (*s == c)
			break;
  800d80:	90                   	nop
	return (char *) s;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d98:	eb 0e                	jmp    800da8 <memset+0x22>
		*p++ = c;
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9d:	8d 50 01             	lea    0x1(%eax),%edx
  800da0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da8:	ff 4d f8             	decl   -0x8(%ebp)
  800dab:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800daf:	79 e9                	jns    800d9a <memset+0x14>
		*p++ = c;

	return v;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc8:	eb 16                	jmp    800de0 <memcpy+0x2a>
		*d++ = *s++;
  800dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcd:	8d 50 01             	lea    0x1(%eax),%edx
  800dd0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ddc:	8a 12                	mov    (%edx),%dl
  800dde:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800de0:	8b 45 10             	mov    0x10(%ebp),%eax
  800de3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de6:	89 55 10             	mov    %edx,0x10(%ebp)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	75 dd                	jne    800dca <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e07:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0a:	73 50                	jae    800e5c <memmove+0x6a>
  800e0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e17:	76 43                	jbe    800e5c <memmove+0x6a>
		s += n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e25:	eb 10                	jmp    800e37 <memmove+0x45>
			*--d = *--s;
  800e27:	ff 4d f8             	decl   -0x8(%ebp)
  800e2a:	ff 4d fc             	decl   -0x4(%ebp)
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	8a 10                	mov    (%eax),%dl
  800e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e35:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	75 e3                	jne    800e27 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e44:	eb 23                	jmp    800e69 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e49:	8d 50 01             	lea    0x1(%eax),%edx
  800e4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e58:	8a 12                	mov    (%edx),%dl
  800e5a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e62:	89 55 10             	mov    %edx,0x10(%ebp)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	75 dd                	jne    800e46 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e80:	eb 2a                	jmp    800eac <memcmp+0x3e>
		if (*s1 != *s2)
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e85:	8a 10                	mov    (%eax),%dl
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	38 c2                	cmp    %al,%dl
  800e8e:	74 16                	je     800ea6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	0f b6 d0             	movzbl %al,%edx
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	0f b6 c0             	movzbl %al,%eax
  800ea0:	29 c2                	sub    %eax,%edx
  800ea2:	89 d0                	mov    %edx,%eax
  800ea4:	eb 18                	jmp    800ebe <memcmp+0x50>
		s1++, s2++;
  800ea6:	ff 45 fc             	incl   -0x4(%ebp)
  800ea9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 c9                	jne    800e82 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	01 d0                	add    %edx,%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed1:	eb 15                	jmp    800ee8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	0f b6 d0             	movzbl %al,%edx
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	0f b6 c0             	movzbl %al,%eax
  800ee1:	39 c2                	cmp    %eax,%edx
  800ee3:	74 0d                	je     800ef2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ee5:	ff 45 08             	incl   0x8(%ebp)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eee:	72 e3                	jb     800ed3 <memfind+0x13>
  800ef0:	eb 01                	jmp    800ef3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ef2:	90                   	nop
	return (void *) s;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0c:	eb 03                	jmp    800f11 <strtol+0x19>
		s++;
  800f0e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 20                	cmp    $0x20,%al
  800f18:	74 f4                	je     800f0e <strtol+0x16>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	3c 09                	cmp    $0x9,%al
  800f21:	74 eb                	je     800f0e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	3c 2b                	cmp    $0x2b,%al
  800f2a:	75 05                	jne    800f31 <strtol+0x39>
		s++;
  800f2c:	ff 45 08             	incl   0x8(%ebp)
  800f2f:	eb 13                	jmp    800f44 <strtol+0x4c>
	else if (*s == '-')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 2d                	cmp    $0x2d,%al
  800f38:	75 0a                	jne    800f44 <strtol+0x4c>
		s++, neg = 1;
  800f3a:	ff 45 08             	incl   0x8(%ebp)
  800f3d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f48:	74 06                	je     800f50 <strtol+0x58>
  800f4a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f4e:	75 20                	jne    800f70 <strtol+0x78>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 30                	cmp    $0x30,%al
  800f57:	75 17                	jne    800f70 <strtol+0x78>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	40                   	inc    %eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 78                	cmp    $0x78,%al
  800f61:	75 0d                	jne    800f70 <strtol+0x78>
		s += 2, base = 16;
  800f63:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f67:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f6e:	eb 28                	jmp    800f98 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f74:	75 15                	jne    800f8b <strtol+0x93>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	3c 30                	cmp    $0x30,%al
  800f7d:	75 0c                	jne    800f8b <strtol+0x93>
		s++, base = 8;
  800f7f:	ff 45 08             	incl   0x8(%ebp)
  800f82:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f89:	eb 0d                	jmp    800f98 <strtol+0xa0>
	else if (base == 0)
  800f8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8f:	75 07                	jne    800f98 <strtol+0xa0>
		base = 10;
  800f91:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 2f                	cmp    $0x2f,%al
  800f9f:	7e 19                	jle    800fba <strtol+0xc2>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 39                	cmp    $0x39,%al
  800fa8:	7f 10                	jg     800fba <strtol+0xc2>
			dig = *s - '0';
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be c0             	movsbl %al,%eax
  800fb2:	83 e8 30             	sub    $0x30,%eax
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb8:	eb 42                	jmp    800ffc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	3c 60                	cmp    $0x60,%al
  800fc1:	7e 19                	jle    800fdc <strtol+0xe4>
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	3c 7a                	cmp    $0x7a,%al
  800fca:	7f 10                	jg     800fdc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	0f be c0             	movsbl %al,%eax
  800fd4:	83 e8 57             	sub    $0x57,%eax
  800fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fda:	eb 20                	jmp    800ffc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3c 40                	cmp    $0x40,%al
  800fe3:	7e 39                	jle    80101e <strtol+0x126>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 5a                	cmp    $0x5a,%al
  800fec:	7f 30                	jg     80101e <strtol+0x126>
			dig = *s - 'A' + 10;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	0f be c0             	movsbl %al,%eax
  800ff6:	83 e8 37             	sub    $0x37,%eax
  800ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801002:	7d 19                	jge    80101d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80100e:	89 c2                	mov    %eax,%edx
  801010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801018:	e9 7b ff ff ff       	jmp    800f98 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80101d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80101e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801022:	74 08                	je     80102c <strtol+0x134>
		*endptr = (char *) s;
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80102c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801030:	74 07                	je     801039 <strtol+0x141>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	f7 d8                	neg    %eax
  801037:	eb 03                	jmp    80103c <strtol+0x144>
  801039:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <ltostr>:

void
ltostr(long value, char *str)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801044:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80104b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801056:	79 13                	jns    80106b <ltostr+0x2d>
	{
		neg = 1;
  801058:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801065:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801068:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801073:	99                   	cltd   
  801074:	f7 f9                	idiv   %ecx
  801076:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801082:	89 c2                	mov    %eax,%edx
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80108c:	83 c2 30             	add    $0x30,%edx
  80108f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801091:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801094:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801099:	f7 e9                	imul   %ecx
  80109b:	c1 fa 02             	sar    $0x2,%edx
  80109e:	89 c8                	mov    %ecx,%eax
  8010a0:	c1 f8 1f             	sar    $0x1f,%eax
  8010a3:	29 c2                	sub    %eax,%edx
  8010a5:	89 d0                	mov    %edx,%eax
  8010a7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ae:	75 bb                	jne    80106b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	48                   	dec    %eax
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c2:	74 3d                	je     801101 <ltostr+0xc3>
		start = 1 ;
  8010c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010cb:	eb 34                	jmp    801101 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 c2                	add    %eax,%edx
  8010e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	01 c8                	add    %ecx,%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	01 c2                	add    %eax,%edx
  8010f6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f9:	88 02                	mov    %al,(%edx)
		start++ ;
  8010fb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010fe:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801104:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801107:	7c c4                	jl     8010cd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801109:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801114:	90                   	nop
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 73 fa ff ff       	call   800b98 <strlen>
  801125:	83 c4 04             	add    $0x4,%esp
  801128:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	e8 65 fa ff ff       	call   800b98 <strlen>
  801133:	83 c4 04             	add    $0x4,%esp
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801147:	eb 17                	jmp    801160 <strcconcat+0x49>
		final[s] = str1[s] ;
  801149:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114c:	8b 45 10             	mov    0x10(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80115d:	ff 45 fc             	incl   -0x4(%ebp)
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801166:	7c e1                	jl     801149 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801168:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801176:	eb 1f                	jmp    801197 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801181:	89 c2                	mov    %eax,%edx
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801194:	ff 45 f8             	incl   -0x8(%ebp)
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119d:	7c d9                	jl     801178 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
}
  8011aa:	90                   	nop
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	8b 00                	mov    (%eax),%eax
  8011be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d0:	eb 0c                	jmp    8011de <strsplit+0x31>
			*string++ = 0;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8d 50 01             	lea    0x1(%eax),%edx
  8011d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011db:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	84 c0                	test   %al,%al
  8011e5:	74 18                	je     8011ff <strsplit+0x52>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f be c0             	movsbl %al,%eax
  8011ef:	50                   	push   %eax
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	e8 32 fb ff ff       	call   800d2a <strchr>
  8011f8:	83 c4 08             	add    $0x8,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	75 d3                	jne    8011d2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	84 c0                	test   %al,%al
  801206:	74 5a                	je     801262 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801208:	8b 45 14             	mov    0x14(%ebp),%eax
  80120b:	8b 00                	mov    (%eax),%eax
  80120d:	83 f8 0f             	cmp    $0xf,%eax
  801210:	75 07                	jne    801219 <strsplit+0x6c>
		{
			return 0;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
  801217:	eb 66                	jmp    80127f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801219:	8b 45 14             	mov    0x14(%ebp),%eax
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	8d 48 01             	lea    0x1(%eax),%ecx
  801221:	8b 55 14             	mov    0x14(%ebp),%edx
  801224:	89 0a                	mov    %ecx,(%edx)
  801226:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 c2                	add    %eax,%edx
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801237:	eb 03                	jmp    80123c <strsplit+0x8f>
			string++;
  801239:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 8b                	je     8011d0 <strsplit+0x23>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 d4 fa ff ff       	call   800d2a <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	74 dc                	je     801239 <strsplit+0x8c>
			string++;
	}
  80125d:	e9 6e ff ff ff       	jmp    8011d0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801262:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	8b 00                	mov    (%eax),%eax
  801268:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126f:	8b 45 10             	mov    0x10(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80127a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	68 1c 23 80 00       	push   $0x80231c
  80128f:	68 3f 01 00 00       	push   $0x13f
  801294:	68 3e 23 80 00       	push   $0x80233e
  801299:	e8 1d 07 00 00       	call   8019bb <_panic>

0080129e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	57                   	push   %edi
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
  8012a4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012b6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012b9:	cd 30                	int    $0x30
  8012bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5f                   	pop    %edi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 04             	sub    $0x4,%esp
  8012cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	52                   	push   %edx
  8012e1:	ff 75 0c             	pushl  0xc(%ebp)
  8012e4:	50                   	push   %eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	e8 b2 ff ff ff       	call   80129e <syscall>
  8012ec:	83 c4 18             	add    $0x18,%esp
}
  8012ef:	90                   	nop
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 02                	push   $0x2
  801301:	e8 98 ff ff ff       	call   80129e <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 03                	push   $0x3
  80131a:	e8 7f ff ff ff       	call   80129e <syscall>
  80131f:	83 c4 18             	add    $0x18,%esp
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 04                	push   $0x4
  801334:	e8 65 ff ff ff       	call   80129e <syscall>
  801339:	83 c4 18             	add    $0x18,%esp
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801342:	8b 55 0c             	mov    0xc(%ebp),%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	52                   	push   %edx
  80134f:	50                   	push   %eax
  801350:	6a 08                	push   $0x8
  801352:	e8 47 ff ff ff       	call   80129e <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	56                   	push   %esi
  801360:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801361:	8b 75 18             	mov    0x18(%ebp),%esi
  801364:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801367:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	51                   	push   %ecx
  801373:	52                   	push   %edx
  801374:	50                   	push   %eax
  801375:	6a 09                	push   $0x9
  801377:	e8 22 ff ff ff       	call   80129e <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801382:	5b                   	pop    %ebx
  801383:	5e                   	pop    %esi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	52                   	push   %edx
  801396:	50                   	push   %eax
  801397:	6a 0a                	push   $0xa
  801399:	e8 00 ff ff ff       	call   80129e <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	ff 75 0c             	pushl  0xc(%ebp)
  8013af:	ff 75 08             	pushl  0x8(%ebp)
  8013b2:	6a 0b                	push   $0xb
  8013b4:	e8 e5 fe ff ff       	call   80129e <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 0c                	push   $0xc
  8013cd:	e8 cc fe ff ff       	call   80129e <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	c9                   	leave  
  8013d6:	c3                   	ret    

008013d7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 0d                	push   $0xd
  8013e6:	e8 b3 fe ff ff       	call   80129e <syscall>
  8013eb:	83 c4 18             	add    $0x18,%esp
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 0e                	push   $0xe
  8013ff:	e8 9a fe ff ff       	call   80129e <syscall>
  801404:	83 c4 18             	add    $0x18,%esp
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 0f                	push   $0xf
  801418:	e8 81 fe ff ff       	call   80129e <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	ff 75 08             	pushl  0x8(%ebp)
  801430:	6a 10                	push   $0x10
  801432:	e8 67 fe ff ff       	call   80129e <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 11                	push   $0x11
  80144b:	e8 4e fe ff ff       	call   80129e <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	90                   	nop
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_cputc>:

void
sys_cputc(const char c)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801462:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	50                   	push   %eax
  80146f:	6a 01                	push   $0x1
  801471:	e8 28 fe ff ff       	call   80129e <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
}
  801479:	90                   	nop
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 14                	push   $0x14
  80148b:	e8 0e fe ff ff       	call   80129e <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	8b 45 10             	mov    0x10(%ebp),%eax
  80149f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	6a 00                	push   $0x0
  8014ae:	51                   	push   %ecx
  8014af:	52                   	push   %edx
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	6a 15                	push   $0x15
  8014b6:	e8 e3 fd ff ff       	call   80129e <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	52                   	push   %edx
  8014d0:	50                   	push   %eax
  8014d1:	6a 16                	push   $0x16
  8014d3:	e8 c6 fd ff ff       	call   80129e <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	51                   	push   %ecx
  8014ee:	52                   	push   %edx
  8014ef:	50                   	push   %eax
  8014f0:	6a 17                	push   $0x17
  8014f2:	e8 a7 fd ff ff       	call   80129e <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	52                   	push   %edx
  80150c:	50                   	push   %eax
  80150d:	6a 18                	push   $0x18
  80150f:	e8 8a fd ff ff       	call   80129e <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	ff 75 14             	pushl  0x14(%ebp)
  801524:	ff 75 10             	pushl  0x10(%ebp)
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	50                   	push   %eax
  80152b:	6a 19                	push   $0x19
  80152d:	e8 6c fd ff ff       	call   80129e <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	50                   	push   %eax
  801546:	6a 1a                	push   $0x1a
  801548:	e8 51 fd ff ff       	call   80129e <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	90                   	nop
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	50                   	push   %eax
  801562:	6a 1b                	push   $0x1b
  801564:	e8 35 fd ff ff       	call   80129e <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 05                	push   $0x5
  80157d:	e8 1c fd ff ff       	call   80129e <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 06                	push   $0x6
  801596:	e8 03 fd ff ff       	call   80129e <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 07                	push   $0x7
  8015af:	e8 ea fc ff ff       	call   80129e <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sys_exit_env>:


void sys_exit_env(void)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 1c                	push   $0x1c
  8015c8:	e8 d1 fc ff ff       	call   80129e <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015d9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015dc:	8d 50 04             	lea    0x4(%eax),%edx
  8015df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	52                   	push   %edx
  8015e9:	50                   	push   %eax
  8015ea:	6a 1d                	push   $0x1d
  8015ec:	e8 ad fc ff ff       	call   80129e <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
	return result;
  8015f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fd:	89 01                	mov    %eax,(%ecx)
  8015ff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	c9                   	leave  
  801606:	c2 04 00             	ret    $0x4

00801609 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	ff 75 10             	pushl  0x10(%ebp)
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	ff 75 08             	pushl  0x8(%ebp)
  801619:	6a 13                	push   $0x13
  80161b:	e8 7e fc ff ff       	call   80129e <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
	return ;
  801623:	90                   	nop
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_rcr2>:
uint32 sys_rcr2()
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 1e                	push   $0x1e
  801635:	e8 64 fc ff ff       	call   80129e <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80164b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	50                   	push   %eax
  801658:	6a 1f                	push   $0x1f
  80165a:	e8 3f fc ff ff       	call   80129e <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
	return ;
  801662:	90                   	nop
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <rsttst>:
void rsttst()
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 21                	push   $0x21
  801674:	e8 25 fc ff ff       	call   80129e <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
	return ;
  80167c:	90                   	nop
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	8b 45 14             	mov    0x14(%ebp),%eax
  801688:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80168b:	8b 55 18             	mov    0x18(%ebp),%edx
  80168e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	ff 75 10             	pushl  0x10(%ebp)
  801697:	ff 75 0c             	pushl  0xc(%ebp)
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	6a 20                	push   $0x20
  80169f:	e8 fa fb ff ff       	call   80129e <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a7:	90                   	nop
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <chktst>:
void chktst(uint32 n)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	6a 22                	push   $0x22
  8016ba:	e8 df fb ff ff       	call   80129e <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c2:	90                   	nop
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <inctst>:

void inctst()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 23                	push   $0x23
  8016d4:	e8 c5 fb ff ff       	call   80129e <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8016dc:	90                   	nop
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <gettst>:
uint32 gettst()
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 24                	push   $0x24
  8016ee:	e8 ab fb ff ff       	call   80129e <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 25                	push   $0x25
  80170a:	e8 8f fb ff ff       	call   80129e <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
  801712:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801715:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801719:	75 07                	jne    801722 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80171b:	b8 01 00 00 00       	mov    $0x1,%eax
  801720:	eb 05                	jmp    801727 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 25                	push   $0x25
  80173b:	e8 5e fb ff ff       	call   80129e <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
  801743:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801746:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80174a:	75 07                	jne    801753 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80174c:	b8 01 00 00 00       	mov    $0x1,%eax
  801751:	eb 05                	jmp    801758 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801753:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 25                	push   $0x25
  80176c:	e8 2d fb ff ff       	call   80129e <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
  801774:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801777:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80177b:	75 07                	jne    801784 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80177d:	b8 01 00 00 00       	mov    $0x1,%eax
  801782:	eb 05                	jmp    801789 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 25                	push   $0x25
  80179d:	e8 fc fa ff ff       	call   80129e <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
  8017a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017a8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017ac:	75 07                	jne    8017b5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b3:	eb 05                	jmp    8017ba <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	6a 26                	push   $0x26
  8017cc:	e8 cd fa ff ff       	call   80129e <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d4:	90                   	nop
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	6a 00                	push   $0x0
  8017e9:	53                   	push   %ebx
  8017ea:	51                   	push   %ecx
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 27                	push   $0x27
  8017ef:	e8 aa fa ff ff       	call   80129e <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	52                   	push   %edx
  80180c:	50                   	push   %eax
  80180d:	6a 28                	push   $0x28
  80180f:	e8 8a fa ff ff       	call   80129e <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80181c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	51                   	push   %ecx
  801828:	ff 75 10             	pushl  0x10(%ebp)
  80182b:	52                   	push   %edx
  80182c:	50                   	push   %eax
  80182d:	6a 29                	push   $0x29
  80182f:	e8 6a fa ff ff       	call   80129e <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	ff 75 10             	pushl  0x10(%ebp)
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 12                	push   $0x12
  80184b:	e8 4e fa ff ff       	call   80129e <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
	return ;
  801853:	90                   	nop
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	52                   	push   %edx
  801866:	50                   	push   %eax
  801867:	6a 2a                	push   $0x2a
  801869:	e8 30 fa ff ff       	call   80129e <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
	return;
  801871:	90                   	nop
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 4b 23 80 00       	push   $0x80234b
  801882:	68 2e 01 00 00       	push   $0x12e
  801887:	68 5f 23 80 00       	push   $0x80235f
  80188c:	e8 2a 01 00 00       	call   8019bb <_panic>

00801891 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 4b 23 80 00       	push   $0x80234b
  80189f:	68 35 01 00 00       	push   $0x135
  8018a4:	68 5f 23 80 00       	push   $0x80235f
  8018a9:	e8 0d 01 00 00       	call   8019bb <_panic>

008018ae <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 4b 23 80 00       	push   $0x80234b
  8018bc:	68 3b 01 00 00       	push   $0x13b
  8018c1:	68 5f 23 80 00       	push   $0x80235f
  8018c6:	e8 f0 00 00 00       	call   8019bb <_panic>

008018cb <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d4:	89 d0                	mov    %edx,%eax
  8018d6:	c1 e0 02             	shl    $0x2,%eax
  8018d9:	01 d0                	add    %edx,%eax
  8018db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f4:	01 d0                	add    %edx,%eax
  8018f6:	c1 e0 04             	shl    $0x4,%eax
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8018fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801903:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	50                   	push   %eax
  80190a:	e8 c4 fc ff ff       	call   8015d3 <sys_get_virtual_time>
  80190f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801912:	eb 41                	jmp    801955 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801914:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	50                   	push   %eax
  80191b:	e8 b3 fc ff ff       	call   8015d3 <sys_get_virtual_time>
  801920:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801923:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801926:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801929:	29 c2                	sub    %eax,%edx
  80192b:	89 d0                	mov    %edx,%eax
  80192d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801930:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801936:	89 d1                	mov    %edx,%ecx
  801938:	29 c1                	sub    %eax,%ecx
  80193a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80193d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801940:	39 c2                	cmp    %eax,%edx
  801942:	0f 97 c0             	seta   %al
  801945:	0f b6 c0             	movzbl %al,%eax
  801948:	29 c1                	sub    %eax,%ecx
  80194a:	89 c8                	mov    %ecx,%eax
  80194c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80194f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801952:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80195b:	72 b7                	jb     801914 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801966:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80196d:	eb 03                	jmp    801972 <busy_wait+0x12>
  80196f:	ff 45 fc             	incl   -0x4(%ebp)
  801972:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801975:	3b 45 08             	cmp    0x8(%ebp),%eax
  801978:	72 f5                	jb     80196f <busy_wait+0xf>
	return i;
  80197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80198b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80198f:	83 ec 0c             	sub    $0xc,%esp
  801992:	50                   	push   %eax
  801993:	e8 be fa ff ff       	call   801456 <sys_cputc>
  801998:	83 c4 10             	add    $0x10,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <getchar>:


int
getchar(void)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8019a4:	e8 49 f9 ff ff       	call   8012f2 <sys_cgetc>
  8019a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <iscons>:

int iscons(int fdnum)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8019b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8019c4:	83 c0 04             	add    $0x4,%eax
  8019c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019ca:	a1 24 30 80 00       	mov    0x803024,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 16                	je     8019e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019d3:	a1 24 30 80 00       	mov    0x803024,%eax
  8019d8:	83 ec 08             	sub    $0x8,%esp
  8019db:	50                   	push   %eax
  8019dc:	68 70 23 80 00       	push   $0x802370
  8019e1:	e8 16 e9 ff ff       	call   8002fc <cprintf>
  8019e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019e9:	a1 00 30 80 00       	mov    0x803000,%eax
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	50                   	push   %eax
  8019f5:	68 75 23 80 00       	push   $0x802375
  8019fa:	e8 fd e8 ff ff       	call   8002fc <cprintf>
  8019ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	83 ec 08             	sub    $0x8,%esp
  801a08:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0b:	50                   	push   %eax
  801a0c:	e8 80 e8 ff ff       	call   800291 <vcprintf>
  801a11:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a14:	83 ec 08             	sub    $0x8,%esp
  801a17:	6a 00                	push   $0x0
  801a19:	68 91 23 80 00       	push   $0x802391
  801a1e:	e8 6e e8 ff ff       	call   800291 <vcprintf>
  801a23:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a26:	e8 ef e7 ff ff       	call   80021a <exit>

	// should not return here
	while (1) ;
  801a2b:	eb fe                	jmp    801a2b <_panic+0x70>

00801a2d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a33:	a1 04 30 80 00       	mov    0x803004,%eax
  801a38:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a41:	39 c2                	cmp    %eax,%edx
  801a43:	74 14                	je     801a59 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	68 94 23 80 00       	push   $0x802394
  801a4d:	6a 26                	push   $0x26
  801a4f:	68 e0 23 80 00       	push   $0x8023e0
  801a54:	e8 62 ff ff ff       	call   8019bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a67:	e9 c5 00 00 00       	jmp    801b31 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	01 d0                	add    %edx,%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	75 08                	jne    801a89 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a81:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a84:	e9 a5 00 00 00       	jmp    801b2e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a89:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a97:	eb 69                	jmp    801b02 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a99:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801aa4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa7:	89 d0                	mov    %edx,%eax
  801aa9:	01 c0                	add    %eax,%eax
  801aab:	01 d0                	add    %edx,%eax
  801aad:	c1 e0 03             	shl    $0x3,%eax
  801ab0:	01 c8                	add    %ecx,%eax
  801ab2:	8a 40 04             	mov    0x4(%eax),%al
  801ab5:	84 c0                	test   %al,%al
  801ab7:	75 46                	jne    801aff <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ab9:	a1 04 30 80 00       	mov    0x803004,%eax
  801abe:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801ac4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	01 c0                	add    %eax,%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	c1 e0 03             	shl    $0x3,%eax
  801ad0:	01 c8                	add    %ecx,%eax
  801ad2:	8b 00                	mov    (%eax),%eax
  801ad4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ad7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ada:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801adf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	01 c8                	add    %ecx,%eax
  801af0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801af2:	39 c2                	cmp    %eax,%edx
  801af4:	75 09                	jne    801aff <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801af6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801afd:	eb 15                	jmp    801b14 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aff:	ff 45 e8             	incl   -0x18(%ebp)
  801b02:	a1 04 30 80 00       	mov    0x803004,%eax
  801b07:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b10:	39 c2                	cmp    %eax,%edx
  801b12:	77 85                	ja     801a99 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b18:	75 14                	jne    801b2e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	68 ec 23 80 00       	push   $0x8023ec
  801b22:	6a 3a                	push   $0x3a
  801b24:	68 e0 23 80 00       	push   $0x8023e0
  801b29:	e8 8d fe ff ff       	call   8019bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b2e:	ff 45 f0             	incl   -0x10(%ebp)
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b37:	0f 8c 2f ff ff ff    	jl     801a6c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b4b:	eb 26                	jmp    801b73 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b4d:	a1 04 30 80 00       	mov    0x803004,%eax
  801b52:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b5b:	89 d0                	mov    %edx,%eax
  801b5d:	01 c0                	add    %eax,%eax
  801b5f:	01 d0                	add    %edx,%eax
  801b61:	c1 e0 03             	shl    $0x3,%eax
  801b64:	01 c8                	add    %ecx,%eax
  801b66:	8a 40 04             	mov    0x4(%eax),%al
  801b69:	3c 01                	cmp    $0x1,%al
  801b6b:	75 03                	jne    801b70 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b6d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b70:	ff 45 e0             	incl   -0x20(%ebp)
  801b73:	a1 04 30 80 00       	mov    0x803004,%eax
  801b78:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b81:	39 c2                	cmp    %eax,%edx
  801b83:	77 c8                	ja     801b4d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b88:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b8b:	74 14                	je     801ba1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	68 40 24 80 00       	push   $0x802440
  801b95:	6a 44                	push   $0x44
  801b97:	68 e0 23 80 00       	push   $0x8023e0
  801b9c:	e8 1a fe ff ff       	call   8019bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ba1:	90                   	nop
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <__udivdi3>:
  801ba4:	55                   	push   %ebp
  801ba5:	57                   	push   %edi
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbb:	89 ca                	mov    %ecx,%edx
  801bbd:	89 f8                	mov    %edi,%eax
  801bbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bc3:	85 f6                	test   %esi,%esi
  801bc5:	75 2d                	jne    801bf4 <__udivdi3+0x50>
  801bc7:	39 cf                	cmp    %ecx,%edi
  801bc9:	77 65                	ja     801c30 <__udivdi3+0x8c>
  801bcb:	89 fd                	mov    %edi,%ebp
  801bcd:	85 ff                	test   %edi,%edi
  801bcf:	75 0b                	jne    801bdc <__udivdi3+0x38>
  801bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd6:	31 d2                	xor    %edx,%edx
  801bd8:	f7 f7                	div    %edi
  801bda:	89 c5                	mov    %eax,%ebp
  801bdc:	31 d2                	xor    %edx,%edx
  801bde:	89 c8                	mov    %ecx,%eax
  801be0:	f7 f5                	div    %ebp
  801be2:	89 c1                	mov    %eax,%ecx
  801be4:	89 d8                	mov    %ebx,%eax
  801be6:	f7 f5                	div    %ebp
  801be8:	89 cf                	mov    %ecx,%edi
  801bea:	89 fa                	mov    %edi,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	39 ce                	cmp    %ecx,%esi
  801bf6:	77 28                	ja     801c20 <__udivdi3+0x7c>
  801bf8:	0f bd fe             	bsr    %esi,%edi
  801bfb:	83 f7 1f             	xor    $0x1f,%edi
  801bfe:	75 40                	jne    801c40 <__udivdi3+0x9c>
  801c00:	39 ce                	cmp    %ecx,%esi
  801c02:	72 0a                	jb     801c0e <__udivdi3+0x6a>
  801c04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c08:	0f 87 9e 00 00 00    	ja     801cac <__udivdi3+0x108>
  801c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c13:	89 fa                	mov    %edi,%edx
  801c15:	83 c4 1c             	add    $0x1c,%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	31 ff                	xor    %edi,%edi
  801c22:	31 c0                	xor    %eax,%eax
  801c24:	89 fa                	mov    %edi,%edx
  801c26:	83 c4 1c             	add    $0x1c,%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	f7 f7                	div    %edi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	89 fa                	mov    %edi,%edx
  801c38:	83 c4 1c             	add    $0x1c,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
  801c40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c45:	89 eb                	mov    %ebp,%ebx
  801c47:	29 fb                	sub    %edi,%ebx
  801c49:	89 f9                	mov    %edi,%ecx
  801c4b:	d3 e6                	shl    %cl,%esi
  801c4d:	89 c5                	mov    %eax,%ebp
  801c4f:	88 d9                	mov    %bl,%cl
  801c51:	d3 ed                	shr    %cl,%ebp
  801c53:	89 e9                	mov    %ebp,%ecx
  801c55:	09 f1                	or     %esi,%ecx
  801c57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c5b:	89 f9                	mov    %edi,%ecx
  801c5d:	d3 e0                	shl    %cl,%eax
  801c5f:	89 c5                	mov    %eax,%ebp
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	88 d9                	mov    %bl,%cl
  801c65:	d3 ee                	shr    %cl,%esi
  801c67:	89 f9                	mov    %edi,%ecx
  801c69:	d3 e2                	shl    %cl,%edx
  801c6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c6f:	88 d9                	mov    %bl,%cl
  801c71:	d3 e8                	shr    %cl,%eax
  801c73:	09 c2                	or     %eax,%edx
  801c75:	89 d0                	mov    %edx,%eax
  801c77:	89 f2                	mov    %esi,%edx
  801c79:	f7 74 24 0c          	divl   0xc(%esp)
  801c7d:	89 d6                	mov    %edx,%esi
  801c7f:	89 c3                	mov    %eax,%ebx
  801c81:	f7 e5                	mul    %ebp
  801c83:	39 d6                	cmp    %edx,%esi
  801c85:	72 19                	jb     801ca0 <__udivdi3+0xfc>
  801c87:	74 0b                	je     801c94 <__udivdi3+0xf0>
  801c89:	89 d8                	mov    %ebx,%eax
  801c8b:	31 ff                	xor    %edi,%edi
  801c8d:	e9 58 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c98:	89 f9                	mov    %edi,%ecx
  801c9a:	d3 e2                	shl    %cl,%edx
  801c9c:	39 c2                	cmp    %eax,%edx
  801c9e:	73 e9                	jae    801c89 <__udivdi3+0xe5>
  801ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	e9 40 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	31 c0                	xor    %eax,%eax
  801cae:	e9 37 ff ff ff       	jmp    801bea <__udivdi3+0x46>
  801cb3:	90                   	nop

00801cb4 <__umoddi3>:
  801cb4:	55                   	push   %ebp
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	83 ec 1c             	sub    $0x1c,%esp
  801cbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd3:	89 f3                	mov    %esi,%ebx
  801cd5:	89 fa                	mov    %edi,%edx
  801cd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cdb:	89 34 24             	mov    %esi,(%esp)
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	75 1a                	jne    801cfc <__umoddi3+0x48>
  801ce2:	39 f7                	cmp    %esi,%edi
  801ce4:	0f 86 a2 00 00 00    	jbe    801d8c <__umoddi3+0xd8>
  801cea:	89 c8                	mov    %ecx,%eax
  801cec:	89 f2                	mov    %esi,%edx
  801cee:	f7 f7                	div    %edi
  801cf0:	89 d0                	mov    %edx,%eax
  801cf2:	31 d2                	xor    %edx,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	39 f0                	cmp    %esi,%eax
  801cfe:	0f 87 ac 00 00 00    	ja     801db0 <__umoddi3+0xfc>
  801d04:	0f bd e8             	bsr    %eax,%ebp
  801d07:	83 f5 1f             	xor    $0x1f,%ebp
  801d0a:	0f 84 ac 00 00 00    	je     801dbc <__umoddi3+0x108>
  801d10:	bf 20 00 00 00       	mov    $0x20,%edi
  801d15:	29 ef                	sub    %ebp,%edi
  801d17:	89 fe                	mov    %edi,%esi
  801d19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 e0                	shl    %cl,%eax
  801d21:	89 d7                	mov    %edx,%edi
  801d23:	89 f1                	mov    %esi,%ecx
  801d25:	d3 ef                	shr    %cl,%edi
  801d27:	09 c7                	or     %eax,%edi
  801d29:	89 e9                	mov    %ebp,%ecx
  801d2b:	d3 e2                	shl    %cl,%edx
  801d2d:	89 14 24             	mov    %edx,(%esp)
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	d3 e0                	shl    %cl,%eax
  801d34:	89 c2                	mov    %eax,%edx
  801d36:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3a:	d3 e0                	shl    %cl,%eax
  801d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d40:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d44:	89 f1                	mov    %esi,%ecx
  801d46:	d3 e8                	shr    %cl,%eax
  801d48:	09 d0                	or     %edx,%eax
  801d4a:	d3 eb                	shr    %cl,%ebx
  801d4c:	89 da                	mov    %ebx,%edx
  801d4e:	f7 f7                	div    %edi
  801d50:	89 d3                	mov    %edx,%ebx
  801d52:	f7 24 24             	mull   (%esp)
  801d55:	89 c6                	mov    %eax,%esi
  801d57:	89 d1                	mov    %edx,%ecx
  801d59:	39 d3                	cmp    %edx,%ebx
  801d5b:	0f 82 87 00 00 00    	jb     801de8 <__umoddi3+0x134>
  801d61:	0f 84 91 00 00 00    	je     801df8 <__umoddi3+0x144>
  801d67:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d6b:	29 f2                	sub    %esi,%edx
  801d6d:	19 cb                	sbb    %ecx,%ebx
  801d6f:	89 d8                	mov    %ebx,%eax
  801d71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d75:	d3 e0                	shl    %cl,%eax
  801d77:	89 e9                	mov    %ebp,%ecx
  801d79:	d3 ea                	shr    %cl,%edx
  801d7b:	09 d0                	or     %edx,%eax
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	d3 eb                	shr    %cl,%ebx
  801d81:	89 da                	mov    %ebx,%edx
  801d83:	83 c4 1c             	add    $0x1c,%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5e                   	pop    %esi
  801d88:	5f                   	pop    %edi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    
  801d8b:	90                   	nop
  801d8c:	89 fd                	mov    %edi,%ebp
  801d8e:	85 ff                	test   %edi,%edi
  801d90:	75 0b                	jne    801d9d <__umoddi3+0xe9>
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	31 d2                	xor    %edx,%edx
  801d99:	f7 f7                	div    %edi
  801d9b:	89 c5                	mov    %eax,%ebp
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	31 d2                	xor    %edx,%edx
  801da1:	f7 f5                	div    %ebp
  801da3:	89 c8                	mov    %ecx,%eax
  801da5:	f7 f5                	div    %ebp
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	e9 44 ff ff ff       	jmp    801cf2 <__umoddi3+0x3e>
  801dae:	66 90                	xchg   %ax,%ax
  801db0:	89 c8                	mov    %ecx,%eax
  801db2:	89 f2                	mov    %esi,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	3b 04 24             	cmp    (%esp),%eax
  801dbf:	72 06                	jb     801dc7 <__umoddi3+0x113>
  801dc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc5:	77 0f                	ja     801dd6 <__umoddi3+0x122>
  801dc7:	89 f2                	mov    %esi,%edx
  801dc9:	29 f9                	sub    %edi,%ecx
  801dcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dcf:	89 14 24             	mov    %edx,(%esp)
  801dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dda:	8b 14 24             	mov    (%esp),%edx
  801ddd:	83 c4 1c             	add    $0x1c,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    
  801de5:	8d 76 00             	lea    0x0(%esi),%esi
  801de8:	2b 04 24             	sub    (%esp),%eax
  801deb:	19 fa                	sbb    %edi,%edx
  801ded:	89 d1                	mov    %edx,%ecx
  801def:	89 c6                	mov    %eax,%esi
  801df1:	e9 71 ff ff ff       	jmp    801d67 <__umoddi3+0xb3>
  801df6:	66 90                	xchg   %ax,%ax
  801df8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dfc:	72 ea                	jb     801de8 <__umoddi3+0x134>
  801dfe:	89 d9                	mov    %ebx,%ecx
  801e00:	e9 62 ff ff ff       	jmp    801d67 <__umoddi3+0xb3>
