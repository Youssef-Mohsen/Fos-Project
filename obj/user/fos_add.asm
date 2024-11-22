
obj/user/fos_add:     file format elf32-i386


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
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int i1=0;
  80003e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int i2=0;
  800045:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 20 1b 80 00       	push   $0x801b20
  800058:	e8 89 0c 00 00       	call   800ce6 <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 e8             	mov    %eax,-0x18(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 22 1b 80 00       	push   $0x801b22
  80006f:	e8 72 0c 00 00       	call   800ce6 <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80007d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 24 1b 80 00       	push   $0x801b24
  80008b:	e8 8f 02 00 00       	call   80031f <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");

	int N = 100000;
  800093:	c7 45 e0 a0 86 01 00 	movl   $0x186a0,-0x20(%ebp)
	int64 sum = 0;
  80009a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = 0; i < N; ++i) {
  8000a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000af:	eb 0d                	jmp    8000be <_main+0x86>
		sum+=i ;
  8000b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b4:	99                   	cltd   
  8000b5:	01 45 f0             	add    %eax,-0x10(%ebp)
  8000b8:	11 55 f4             	adc    %edx,-0xc(%ebp)
	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
	//cprintf("number 1 + number 2 = \n");

	int N = 100000;
	int64 sum = 0;
	for (int i = 0; i < N; ++i) {
  8000bb:	ff 45 ec             	incl   -0x14(%ebp)
  8000be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000c4:	7c eb                	jl     8000b1 <_main+0x79>
		sum+=i ;
	}
	cprintf("sum 1->%d = %d\n", N, sum);
  8000c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000cf:	68 3e 1b 80 00       	push   $0x801b3e
  8000d4:	e8 19 02 00 00       	call   8002f2 <cprintf>
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
  800114:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800119:	a1 04 30 80 00       	mov    0x803004,%eax
  80011e:	8a 40 20             	mov    0x20(%eax),%al
  800121:	84 c0                	test   %al,%al
  800123:	74 0d                	je     800132 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800125:	a1 04 30 80 00       	mov    0x803004,%eax
  80012a:	83 c0 20             	add    $0x20,%eax
  80012d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800136:	7e 0a                	jle    800142 <libmain+0x63>
		binaryname = argv[0];
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	a3 00 30 80 00       	mov    %eax,0x803000

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
  80015b:	68 68 1b 80 00       	push   $0x801b68
  800160:	e8 8d 01 00 00       	call   8002f2 <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800168:	a1 04 30 80 00       	mov    0x803004,%eax
  80016d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800173:	a1 04 30 80 00       	mov    0x803004,%eax
  800178:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	52                   	push   %edx
  800182:	50                   	push   %eax
  800183:	68 90 1b 80 00       	push   $0x801b90
  800188:	e8 65 01 00 00       	call   8002f2 <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800190:	a1 04 30 80 00       	mov    0x803004,%eax
  800195:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80019b:	a1 04 30 80 00       	mov    0x803004,%eax
  8001a0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ab:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8001b1:	51                   	push   %ecx
  8001b2:	52                   	push   %edx
  8001b3:	50                   	push   %eax
  8001b4:	68 b8 1b 80 00       	push   $0x801bb8
  8001b9:	e8 34 01 00 00       	call   8002f2 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c6:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	50                   	push   %eax
  8001d0:	68 10 1c 80 00       	push   $0x801c10
  8001d5:	e8 18 01 00 00       	call   8002f2 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 68 1b 80 00       	push   $0x801b68
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
  800249:	a0 08 30 80 00       	mov    0x803008,%al
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
  8002be:	a0 08 30 80 00       	mov    0x803008,%al
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
  8002e3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
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
  8002f8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
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
  80038f:	e8 0c 15 00 00       	call   8018a0 <__udivdi3>
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
  8003df:	e8 cc 15 00 00       	call   8019b0 <__umoddi3>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	05 54 1e 80 00       	add    $0x801e54,%eax
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
  80053a:	8b 04 85 78 1e 80 00 	mov    0x801e78(,%eax,4),%eax
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
  80061b:	8b 34 9d c0 1c 80 00 	mov    0x801cc0(,%ebx,4),%esi
  800622:	85 f6                	test   %esi,%esi
  800624:	75 19                	jne    80063f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800626:	53                   	push   %ebx
  800627:	68 65 1e 80 00       	push   $0x801e65
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
  800640:	68 6e 1e 80 00       	push   $0x801e6e
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
  80066d:	be 71 1e 80 00       	mov    $0x801e71,%esi
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
  800865:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80086c:	eb 2c                	jmp    80089a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80086e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
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
  801078:	68 e8 1f 80 00       	push   $0x801fe8
  80107d:	68 3f 01 00 00       	push   $0x13f
  801082:	68 0a 20 80 00       	push   $0x80200a
  801087:	e8 29 06 00 00       	call   8016b5 <_panic>

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

008016b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8016be:	83 c0 04             	add    $0x4,%eax
  8016c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016c4:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 16                	je     8016e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016cd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	50                   	push   %eax
  8016d6:	68 18 20 80 00       	push   $0x802018
  8016db:	e8 12 ec ff ff       	call   8002f2 <cprintf>
  8016e0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016e3:	a1 00 30 80 00       	mov    0x803000,%eax
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	50                   	push   %eax
  8016ef:	68 1d 20 80 00       	push   $0x80201d
  8016f4:	e8 f9 eb ff ff       	call   8002f2 <cprintf>
  8016f9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	ff 75 f4             	pushl  -0xc(%ebp)
  801705:	50                   	push   %eax
  801706:	e8 7c eb ff ff       	call   800287 <vcprintf>
  80170b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	6a 00                	push   $0x0
  801713:	68 39 20 80 00       	push   $0x802039
  801718:	e8 6a eb ff ff       	call   800287 <vcprintf>
  80171d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801720:	e8 eb ea ff ff       	call   800210 <exit>

	// should not return here
	while (1) ;
  801725:	eb fe                	jmp    801725 <_panic+0x70>

00801727 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80172d:	a1 04 30 80 00       	mov    0x803004,%eax
  801732:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173b:	39 c2                	cmp    %eax,%edx
  80173d:	74 14                	je     801753 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 3c 20 80 00       	push   $0x80203c
  801747:	6a 26                	push   $0x26
  801749:	68 88 20 80 00       	push   $0x802088
  80174e:	e8 62 ff ff ff       	call   8016b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80175a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801761:	e9 c5 00 00 00       	jmp    80182b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	01 d0                	add    %edx,%eax
  801775:	8b 00                	mov    (%eax),%eax
  801777:	85 c0                	test   %eax,%eax
  801779:	75 08                	jne    801783 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80177b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80177e:	e9 a5 00 00 00       	jmp    801828 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801783:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80178a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801791:	eb 69                	jmp    8017fc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801793:	a1 04 30 80 00       	mov    0x803004,%eax
  801798:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80179e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017a1:	89 d0                	mov    %edx,%eax
  8017a3:	01 c0                	add    %eax,%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	c1 e0 03             	shl    $0x3,%eax
  8017aa:	01 c8                	add    %ecx,%eax
  8017ac:	8a 40 04             	mov    0x4(%eax),%al
  8017af:	84 c0                	test   %al,%al
  8017b1:	75 46                	jne    8017f9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8017b8:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8017be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c1:	89 d0                	mov    %edx,%eax
  8017c3:	01 c0                	add    %eax,%eax
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	c1 e0 03             	shl    $0x3,%eax
  8017ca:	01 c8                	add    %ecx,%eax
  8017cc:	8b 00                	mov    (%eax),%eax
  8017ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	01 c8                	add    %ecx,%eax
  8017ea:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017ec:	39 c2                	cmp    %eax,%edx
  8017ee:	75 09                	jne    8017f9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017f7:	eb 15                	jmp    80180e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017f9:	ff 45 e8             	incl   -0x18(%ebp)
  8017fc:	a1 04 30 80 00       	mov    0x803004,%eax
  801801:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180a:	39 c2                	cmp    %eax,%edx
  80180c:	77 85                	ja     801793 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80180e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801812:	75 14                	jne    801828 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 94 20 80 00       	push   $0x802094
  80181c:	6a 3a                	push   $0x3a
  80181e:	68 88 20 80 00       	push   $0x802088
  801823:	e8 8d fe ff ff       	call   8016b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801828:	ff 45 f0             	incl   -0x10(%ebp)
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801831:	0f 8c 2f ff ff ff    	jl     801766 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801837:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80183e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801845:	eb 26                	jmp    80186d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801847:	a1 04 30 80 00       	mov    0x803004,%eax
  80184c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801852:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801855:	89 d0                	mov    %edx,%eax
  801857:	01 c0                	add    %eax,%eax
  801859:	01 d0                	add    %edx,%eax
  80185b:	c1 e0 03             	shl    $0x3,%eax
  80185e:	01 c8                	add    %ecx,%eax
  801860:	8a 40 04             	mov    0x4(%eax),%al
  801863:	3c 01                	cmp    $0x1,%al
  801865:	75 03                	jne    80186a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801867:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80186a:	ff 45 e0             	incl   -0x20(%ebp)
  80186d:	a1 04 30 80 00       	mov    0x803004,%eax
  801872:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801878:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187b:	39 c2                	cmp    %eax,%edx
  80187d:	77 c8                	ja     801847 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801885:	74 14                	je     80189b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 e8 20 80 00       	push   $0x8020e8
  80188f:	6a 44                	push   $0x44
  801891:	68 88 20 80 00       	push   $0x802088
  801896:	e8 1a fe ff ff       	call   8016b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    
  80189e:	66 90                	xchg   %ax,%ax

008018a0 <__udivdi3>:
  8018a0:	55                   	push   %ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b7:	89 ca                	mov    %ecx,%edx
  8018b9:	89 f8                	mov    %edi,%eax
  8018bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018bf:	85 f6                	test   %esi,%esi
  8018c1:	75 2d                	jne    8018f0 <__udivdi3+0x50>
  8018c3:	39 cf                	cmp    %ecx,%edi
  8018c5:	77 65                	ja     80192c <__udivdi3+0x8c>
  8018c7:	89 fd                	mov    %edi,%ebp
  8018c9:	85 ff                	test   %edi,%edi
  8018cb:	75 0b                	jne    8018d8 <__udivdi3+0x38>
  8018cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d2:	31 d2                	xor    %edx,%edx
  8018d4:	f7 f7                	div    %edi
  8018d6:	89 c5                	mov    %eax,%ebp
  8018d8:	31 d2                	xor    %edx,%edx
  8018da:	89 c8                	mov    %ecx,%eax
  8018dc:	f7 f5                	div    %ebp
  8018de:	89 c1                	mov    %eax,%ecx
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	f7 f5                	div    %ebp
  8018e4:	89 cf                	mov    %ecx,%edi
  8018e6:	89 fa                	mov    %edi,%edx
  8018e8:	83 c4 1c             	add    $0x1c,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
  8018f0:	39 ce                	cmp    %ecx,%esi
  8018f2:	77 28                	ja     80191c <__udivdi3+0x7c>
  8018f4:	0f bd fe             	bsr    %esi,%edi
  8018f7:	83 f7 1f             	xor    $0x1f,%edi
  8018fa:	75 40                	jne    80193c <__udivdi3+0x9c>
  8018fc:	39 ce                	cmp    %ecx,%esi
  8018fe:	72 0a                	jb     80190a <__udivdi3+0x6a>
  801900:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801904:	0f 87 9e 00 00 00    	ja     8019a8 <__udivdi3+0x108>
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	89 fa                	mov    %edi,%edx
  801911:	83 c4 1c             	add    $0x1c,%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    
  801919:	8d 76 00             	lea    0x0(%esi),%esi
  80191c:	31 ff                	xor    %edi,%edi
  80191e:	31 c0                	xor    %eax,%eax
  801920:	89 fa                	mov    %edi,%edx
  801922:	83 c4 1c             	add    $0x1c,%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	f7 f7                	div    %edi
  801930:	31 ff                	xor    %edi,%edi
  801932:	89 fa                	mov    %edi,%edx
  801934:	83 c4 1c             	add    $0x1c,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
  80193c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801941:	89 eb                	mov    %ebp,%ebx
  801943:	29 fb                	sub    %edi,%ebx
  801945:	89 f9                	mov    %edi,%ecx
  801947:	d3 e6                	shl    %cl,%esi
  801949:	89 c5                	mov    %eax,%ebp
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 ed                	shr    %cl,%ebp
  80194f:	89 e9                	mov    %ebp,%ecx
  801951:	09 f1                	or     %esi,%ecx
  801953:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801957:	89 f9                	mov    %edi,%ecx
  801959:	d3 e0                	shl    %cl,%eax
  80195b:	89 c5                	mov    %eax,%ebp
  80195d:	89 d6                	mov    %edx,%esi
  80195f:	88 d9                	mov    %bl,%cl
  801961:	d3 ee                	shr    %cl,%esi
  801963:	89 f9                	mov    %edi,%ecx
  801965:	d3 e2                	shl    %cl,%edx
  801967:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196b:	88 d9                	mov    %bl,%cl
  80196d:	d3 e8                	shr    %cl,%eax
  80196f:	09 c2                	or     %eax,%edx
  801971:	89 d0                	mov    %edx,%eax
  801973:	89 f2                	mov    %esi,%edx
  801975:	f7 74 24 0c          	divl   0xc(%esp)
  801979:	89 d6                	mov    %edx,%esi
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	f7 e5                	mul    %ebp
  80197f:	39 d6                	cmp    %edx,%esi
  801981:	72 19                	jb     80199c <__udivdi3+0xfc>
  801983:	74 0b                	je     801990 <__udivdi3+0xf0>
  801985:	89 d8                	mov    %ebx,%eax
  801987:	31 ff                	xor    %edi,%edi
  801989:	e9 58 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  80198e:	66 90                	xchg   %ax,%ax
  801990:	8b 54 24 08          	mov    0x8(%esp),%edx
  801994:	89 f9                	mov    %edi,%ecx
  801996:	d3 e2                	shl    %cl,%edx
  801998:	39 c2                	cmp    %eax,%edx
  80199a:	73 e9                	jae    801985 <__udivdi3+0xe5>
  80199c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80199f:	31 ff                	xor    %edi,%edi
  8019a1:	e9 40 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019a6:	66 90                	xchg   %ax,%ax
  8019a8:	31 c0                	xor    %eax,%eax
  8019aa:	e9 37 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019af:	90                   	nop

008019b0 <__umoddi3>:
  8019b0:	55                   	push   %ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019cf:	89 f3                	mov    %esi,%ebx
  8019d1:	89 fa                	mov    %edi,%edx
  8019d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d7:	89 34 24             	mov    %esi,(%esp)
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	75 1a                	jne    8019f8 <__umoddi3+0x48>
  8019de:	39 f7                	cmp    %esi,%edi
  8019e0:	0f 86 a2 00 00 00    	jbe    801a88 <__umoddi3+0xd8>
  8019e6:	89 c8                	mov    %ecx,%eax
  8019e8:	89 f2                	mov    %esi,%edx
  8019ea:	f7 f7                	div    %edi
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	31 d2                	xor    %edx,%edx
  8019f0:	83 c4 1c             	add    $0x1c,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5f                   	pop    %edi
  8019f6:	5d                   	pop    %ebp
  8019f7:	c3                   	ret    
  8019f8:	39 f0                	cmp    %esi,%eax
  8019fa:	0f 87 ac 00 00 00    	ja     801aac <__umoddi3+0xfc>
  801a00:	0f bd e8             	bsr    %eax,%ebp
  801a03:	83 f5 1f             	xor    $0x1f,%ebp
  801a06:	0f 84 ac 00 00 00    	je     801ab8 <__umoddi3+0x108>
  801a0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a11:	29 ef                	sub    %ebp,%edi
  801a13:	89 fe                	mov    %edi,%esi
  801a15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a19:	89 e9                	mov    %ebp,%ecx
  801a1b:	d3 e0                	shl    %cl,%eax
  801a1d:	89 d7                	mov    %edx,%edi
  801a1f:	89 f1                	mov    %esi,%ecx
  801a21:	d3 ef                	shr    %cl,%edi
  801a23:	09 c7                	or     %eax,%edi
  801a25:	89 e9                	mov    %ebp,%ecx
  801a27:	d3 e2                	shl    %cl,%edx
  801a29:	89 14 24             	mov    %edx,(%esp)
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	d3 e0                	shl    %cl,%eax
  801a30:	89 c2                	mov    %eax,%edx
  801a32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a36:	d3 e0                	shl    %cl,%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a40:	89 f1                	mov    %esi,%ecx
  801a42:	d3 e8                	shr    %cl,%eax
  801a44:	09 d0                	or     %edx,%eax
  801a46:	d3 eb                	shr    %cl,%ebx
  801a48:	89 da                	mov    %ebx,%edx
  801a4a:	f7 f7                	div    %edi
  801a4c:	89 d3                	mov    %edx,%ebx
  801a4e:	f7 24 24             	mull   (%esp)
  801a51:	89 c6                	mov    %eax,%esi
  801a53:	89 d1                	mov    %edx,%ecx
  801a55:	39 d3                	cmp    %edx,%ebx
  801a57:	0f 82 87 00 00 00    	jb     801ae4 <__umoddi3+0x134>
  801a5d:	0f 84 91 00 00 00    	je     801af4 <__umoddi3+0x144>
  801a63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a67:	29 f2                	sub    %esi,%edx
  801a69:	19 cb                	sbb    %ecx,%ebx
  801a6b:	89 d8                	mov    %ebx,%eax
  801a6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a71:	d3 e0                	shl    %cl,%eax
  801a73:	89 e9                	mov    %ebp,%ecx
  801a75:	d3 ea                	shr    %cl,%edx
  801a77:	09 d0                	or     %edx,%eax
  801a79:	89 e9                	mov    %ebp,%ecx
  801a7b:	d3 eb                	shr    %cl,%ebx
  801a7d:	89 da                	mov    %ebx,%edx
  801a7f:	83 c4 1c             	add    $0x1c,%esp
  801a82:	5b                   	pop    %ebx
  801a83:	5e                   	pop    %esi
  801a84:	5f                   	pop    %edi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    
  801a87:	90                   	nop
  801a88:	89 fd                	mov    %edi,%ebp
  801a8a:	85 ff                	test   %edi,%edi
  801a8c:	75 0b                	jne    801a99 <__umoddi3+0xe9>
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	31 d2                	xor    %edx,%edx
  801a95:	f7 f7                	div    %edi
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 f0                	mov    %esi,%eax
  801a9b:	31 d2                	xor    %edx,%edx
  801a9d:	f7 f5                	div    %ebp
  801a9f:	89 c8                	mov    %ecx,%eax
  801aa1:	f7 f5                	div    %ebp
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	e9 44 ff ff ff       	jmp    8019ee <__umoddi3+0x3e>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 c8                	mov    %ecx,%eax
  801aae:	89 f2                	mov    %esi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	3b 04 24             	cmp    (%esp),%eax
  801abb:	72 06                	jb     801ac3 <__umoddi3+0x113>
  801abd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ac1:	77 0f                	ja     801ad2 <__umoddi3+0x122>
  801ac3:	89 f2                	mov    %esi,%edx
  801ac5:	29 f9                	sub    %edi,%ecx
  801ac7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801acb:	89 14 24             	mov    %edx,(%esp)
  801ace:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ad6:	8b 14 24             	mov    (%esp),%edx
  801ad9:	83 c4 1c             	add    $0x1c,%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    
  801ae1:	8d 76 00             	lea    0x0(%esi),%esi
  801ae4:	2b 04 24             	sub    (%esp),%eax
  801ae7:	19 fa                	sbb    %edi,%edx
  801ae9:	89 d1                	mov    %edx,%ecx
  801aeb:	89 c6                	mov    %eax,%esi
  801aed:	e9 71 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801af8:	72 ea                	jb     801ae4 <__umoddi3+0x134>
  801afa:	89 d9                	mov    %ebx,%ecx
  801afc:	e9 62 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
