
obj/user/dummy_process:     file format elf32-i386


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
  800031:	e8 8d 00 00 00       	call   8000c3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void high_complexity_function();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	high_complexity_function() ;
  80003e:	e8 03 00 00 00       	call   800046 <high_complexity_function>
	return;
  800043:	90                   	nop
}
  800044:	c9                   	leave  
  800045:	c3                   	ret    

00800046 <high_complexity_function>:

void high_complexity_function()
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 38             	sub    $0x38,%esp
	uint32 end1 = RAND(0, 5000);
  80004c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	50                   	push   %eax
  800053:	e8 5b 13 00 00       	call   8013b3 <sys_get_virtual_time>
  800058:	83 c4 0c             	add    $0xc,%esp
  80005b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80005e:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800063:	ba 00 00 00 00       	mov    $0x0,%edx
  800068:	f7 f1                	div    %ecx
  80006a:	89 55 e8             	mov    %edx,-0x18(%ebp)
	uint32 end2 = RAND(0, 5000);
  80006d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	50                   	push   %eax
  800074:	e8 3a 13 00 00       	call   8013b3 <sys_get_virtual_time>
  800079:	83 c4 0c             	add    $0xc,%esp
  80007c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80007f:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800084:	ba 00 00 00 00       	mov    $0x0,%edx
  800089:	f7 f1                	div    %ecx
  80008b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int x = 10;
  80008e:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)
	for(int i = 0; i <= end1; i++)
  800095:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80009c:	eb 1a                	jmp    8000b8 <high_complexity_function+0x72>
	{
		for(int i = 0; i <= end2; i++)
  80009e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000a5:	eb 06                	jmp    8000ad <high_complexity_function+0x67>
		{
			{
				 x++;
  8000a7:	ff 45 f4             	incl   -0xc(%ebp)
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
	{
		for(int i = 0; i <= end2; i++)
  8000aa:	ff 45 ec             	incl   -0x14(%ebp)
  8000ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b3:	76 f2                	jbe    8000a7 <high_complexity_function+0x61>
void high_complexity_function()
{
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
  8000b5:	ff 45 f0             	incl   -0x10(%ebp)
  8000b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000bb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8000be:	76 de                	jbe    80009e <high_complexity_function+0x58>
			{
				 x++;
			}
		}
	}
}
  8000c0:	90                   	nop
  8000c1:	c9                   	leave  
  8000c2:	c3                   	ret    

008000c3 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c9:	e8 99 12 00 00       	call   801367 <sys_getenvindex>
  8000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d4:	89 d0                	mov    %edx,%eax
  8000d6:	c1 e0 06             	shl    $0x6,%eax
  8000d9:	29 d0                	sub    %edx,%eax
  8000db:	c1 e0 02             	shl    $0x2,%eax
  8000de:	01 d0                	add    %edx,%eax
  8000e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e7:	01 c8                	add    %ecx,%eax
  8000e9:	c1 e0 03             	shl    $0x3,%eax
  8000ec:	01 d0                	add    %edx,%eax
  8000ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000f5:	29 c2                	sub    %eax,%edx
  8000f7:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800106:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010b:	a1 04 30 80 00       	mov    0x803004,%eax
  800110:	8a 40 20             	mov    0x20(%eax),%al
  800113:	84 c0                	test   %al,%al
  800115:	74 0d                	je     800124 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800117:	a1 04 30 80 00       	mov    0x803004,%eax
  80011c:	83 c0 20             	add    $0x20,%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800128:	7e 0a                	jle    800134 <libmain+0x71>
		binaryname = argv[0];
  80012a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012d:	8b 00                	mov    (%eax),%eax
  80012f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 0c             	pushl  0xc(%ebp)
  80013a:	ff 75 08             	pushl  0x8(%ebp)
  80013d:	e8 f6 fe ff ff       	call   800038 <_main>
  800142:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800145:	e8 a1 0f 00 00       	call   8010eb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 18 1b 80 00       	push   $0x801b18
  800152:	e8 8d 01 00 00       	call   8002e4 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015a:	a1 04 30 80 00       	mov    0x803004,%eax
  80015f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800165:	a1 04 30 80 00       	mov    0x803004,%eax
  80016a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800170:	83 ec 04             	sub    $0x4,%esp
  800173:	52                   	push   %edx
  800174:	50                   	push   %eax
  800175:	68 40 1b 80 00       	push   $0x801b40
  80017a:	e8 65 01 00 00       	call   8002e4 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800182:	a1 04 30 80 00       	mov    0x803004,%eax
  800187:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80018d:	a1 04 30 80 00       	mov    0x803004,%eax
  800192:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800198:	a1 04 30 80 00       	mov    0x803004,%eax
  80019d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8001a3:	51                   	push   %ecx
  8001a4:	52                   	push   %edx
  8001a5:	50                   	push   %eax
  8001a6:	68 68 1b 80 00       	push   $0x801b68
  8001ab:	e8 34 01 00 00       	call   8002e4 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b8:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 c0 1b 80 00       	push   $0x801bc0
  8001c7:	e8 18 01 00 00       	call   8002e4 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 18 1b 80 00       	push   $0x801b18
  8001d7:	e8 08 01 00 00       	call   8002e4 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8001df:	e8 21 0f 00 00       	call   801105 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8001e4:	e8 19 00 00 00       	call   800202 <exit>
}
  8001e9:	90                   	nop
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	6a 00                	push   $0x0
  8001f7:	e8 37 11 00 00       	call   801333 <sys_destroy_env>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <exit>:

void
exit(void)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800208:	e8 8c 11 00 00       	call   801399 <sys_exit_env>
}
  80020d:	90                   	nop
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800216:	8b 45 0c             	mov    0xc(%ebp),%eax
  800219:	8b 00                	mov    (%eax),%eax
  80021b:	8d 48 01             	lea    0x1(%eax),%ecx
  80021e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800221:	89 0a                	mov    %ecx,(%edx)
  800223:	8b 55 08             	mov    0x8(%ebp),%edx
  800226:	88 d1                	mov    %dl,%cl
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	3d ff 00 00 00       	cmp    $0xff,%eax
  800239:	75 2c                	jne    800267 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80023b:	a0 08 30 80 00       	mov    0x803008,%al
  800240:	0f b6 c0             	movzbl %al,%eax
  800243:	8b 55 0c             	mov    0xc(%ebp),%edx
  800246:	8b 12                	mov    (%edx),%edx
  800248:	89 d1                	mov    %edx,%ecx
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024d:	83 c2 08             	add    $0x8,%edx
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	50                   	push   %eax
  800254:	51                   	push   %ecx
  800255:	52                   	push   %edx
  800256:	e8 4e 0e 00 00       	call   8010a9 <sys_cputs>
  80025b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026a:	8b 40 04             	mov    0x4(%eax),%eax
  80026d:	8d 50 01             	lea    0x1(%eax),%edx
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
  800273:	89 50 04             	mov    %edx,0x4(%eax)
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800293:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	68 10 02 80 00       	push   $0x800210
  8002a8:	e8 11 02 00 00       	call   8004be <vprintfmt>
  8002ad:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b0:	a0 08 30 80 00       	mov    0x803008,%al
  8002b5:	0f b6 c0             	movzbl %al,%eax
  8002b8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	50                   	push   %eax
  8002c2:	52                   	push   %edx
  8002c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c9:	83 c0 08             	add    $0x8,%eax
  8002cc:	50                   	push   %eax
  8002cd:	e8 d7 0d 00 00       	call   8010a9 <sys_cputs>
  8002d2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8002dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ea:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8002f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800300:	50                   	push   %eax
  800301:	e8 73 ff ff ff       	call   800279 <vcprintf>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800317:	e8 cf 0d 00 00       	call   8010eb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80031c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 f4             	pushl  -0xc(%ebp)
  80032b:	50                   	push   %eax
  80032c:	e8 48 ff ff ff       	call   800279 <vcprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800337:	e8 c9 0d 00 00       	call   801105 <sys_unlock_cons>
	return cnt;
  80033c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	53                   	push   %ebx
  800345:	83 ec 14             	sub    $0x14,%esp
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800354:	8b 45 18             	mov    0x18(%ebp),%eax
  800357:	ba 00 00 00 00       	mov    $0x0,%edx
  80035c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035f:	77 55                	ja     8003b6 <printnum+0x75>
  800361:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800364:	72 05                	jb     80036b <printnum+0x2a>
  800366:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800369:	77 4b                	ja     8003b6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80036e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800371:	8b 45 18             	mov    0x18(%ebp),%eax
  800374:	ba 00 00 00 00       	mov    $0x0,%edx
  800379:	52                   	push   %edx
  80037a:	50                   	push   %eax
  80037b:	ff 75 f4             	pushl  -0xc(%ebp)
  80037e:	ff 75 f0             	pushl  -0x10(%ebp)
  800381:	e8 0e 15 00 00       	call   801894 <__udivdi3>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	ff 75 20             	pushl  0x20(%ebp)
  80038f:	53                   	push   %ebx
  800390:	ff 75 18             	pushl  0x18(%ebp)
  800393:	52                   	push   %edx
  800394:	50                   	push   %eax
  800395:	ff 75 0c             	pushl  0xc(%ebp)
  800398:	ff 75 08             	pushl  0x8(%ebp)
  80039b:	e8 a1 ff ff ff       	call   800341 <printnum>
  8003a0:	83 c4 20             	add    $0x20,%esp
  8003a3:	eb 1a                	jmp    8003bf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	ff 75 20             	pushl  0x20(%ebp)
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	ff d0                	call   *%eax
  8003b3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003bd:	7f e6                	jg     8003a5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003bf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003cd:	53                   	push   %ebx
  8003ce:	51                   	push   %ecx
  8003cf:	52                   	push   %edx
  8003d0:	50                   	push   %eax
  8003d1:	e8 ce 15 00 00       	call   8019a4 <__umoddi3>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	05 f4 1d 80 00       	add    $0x801df4,%eax
  8003de:	8a 00                	mov    (%eax),%al
  8003e0:	0f be c0             	movsbl %al,%eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	ff d0                	call   *%eax
  8003ef:	83 c4 10             	add    $0x10,%esp
}
  8003f2:	90                   	nop
  8003f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ff:	7e 1c                	jle    80041d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	8d 50 08             	lea    0x8(%eax),%edx
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
  80040c:	89 10                	mov    %edx,(%eax)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 e8 08             	sub    $0x8,%eax
  800416:	8b 50 04             	mov    0x4(%eax),%edx
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	eb 40                	jmp    80045d <getuint+0x65>
	else if (lflag)
  80041d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800421:	74 1e                	je     800441 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	8d 50 04             	lea    0x4(%eax),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	89 10                	mov    %edx,(%eax)
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	83 e8 04             	sub    $0x4,%eax
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	eb 1c                	jmp    80045d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 50 04             	lea    0x4(%eax),%edx
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	89 10                	mov    %edx,(%eax)
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	83 e8 04             	sub    $0x4,%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800462:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800466:	7e 1c                	jle    800484 <getint+0x25>
		return va_arg(*ap, long long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 08             	lea    0x8(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 08             	sub    $0x8,%eax
  80047d:	8b 50 04             	mov    0x4(%eax),%edx
  800480:	8b 00                	mov    (%eax),%eax
  800482:	eb 38                	jmp    8004bc <getint+0x5d>
	else if (lflag)
  800484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800488:	74 1a                	je     8004a4 <getint+0x45>
		return va_arg(*ap, long);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	8d 50 04             	lea    0x4(%eax),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 10                	mov    %edx,(%eax)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	83 e8 04             	sub    $0x4,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	99                   	cltd   
  8004a2:	eb 18                	jmp    8004bc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	89 10                	mov    %edx,(%eax)
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	83 e8 04             	sub    $0x4,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	99                   	cltd   
}
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	56                   	push   %esi
  8004c2:	53                   	push   %ebx
  8004c3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c6:	eb 17                	jmp    8004df <vprintfmt+0x21>
			if (ch == '\0')
  8004c8:	85 db                	test   %ebx,%ebx
  8004ca:	0f 84 c1 03 00 00    	je     800891 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	ff 75 0c             	pushl  0xc(%ebp)
  8004d6:	53                   	push   %ebx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	ff d0                	call   *%eax
  8004dc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	8d 50 01             	lea    0x1(%eax),%edx
  8004e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e8:	8a 00                	mov    (%eax),%al
  8004ea:	0f b6 d8             	movzbl %al,%ebx
  8004ed:	83 fb 25             	cmp    $0x25,%ebx
  8004f0:	75 d6                	jne    8004c8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800504:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80050b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8b 45 10             	mov    0x10(%ebp),%eax
  800515:	8d 50 01             	lea    0x1(%eax),%edx
  800518:	89 55 10             	mov    %edx,0x10(%ebp)
  80051b:	8a 00                	mov    (%eax),%al
  80051d:	0f b6 d8             	movzbl %al,%ebx
  800520:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800523:	83 f8 5b             	cmp    $0x5b,%eax
  800526:	0f 87 3d 03 00 00    	ja     800869 <vprintfmt+0x3ab>
  80052c:	8b 04 85 18 1e 80 00 	mov    0x801e18(,%eax,4),%eax
  800533:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800535:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800539:	eb d7                	jmp    800512 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80053b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80053f:	eb d1                	jmp    800512 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800541:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054b:	89 d0                	mov    %edx,%eax
  80054d:	c1 e0 02             	shl    $0x2,%eax
  800550:	01 d0                	add    %edx,%eax
  800552:	01 c0                	add    %eax,%eax
  800554:	01 d8                	add    %ebx,%eax
  800556:	83 e8 30             	sub    $0x30,%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80055c:	8b 45 10             	mov    0x10(%ebp),%eax
  80055f:	8a 00                	mov    (%eax),%al
  800561:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800564:	83 fb 2f             	cmp    $0x2f,%ebx
  800567:	7e 3e                	jle    8005a7 <vprintfmt+0xe9>
  800569:	83 fb 39             	cmp    $0x39,%ebx
  80056c:	7f 39                	jg     8005a7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800571:	eb d5                	jmp    800548 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 14             	mov    %eax,0x14(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	83 e8 04             	sub    $0x4,%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800587:	eb 1f                	jmp    8005a8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80058d:	79 83                	jns    800512 <vprintfmt+0x54>
				width = 0;
  80058f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800596:	e9 77 ff ff ff       	jmp    800512 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80059b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a2:	e9 6b ff ff ff       	jmp    800512 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005a7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ac:	0f 89 60 ff ff ff    	jns    800512 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005bf:	e9 4e ff ff ff       	jmp    800512 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005c7:	e9 46 ff ff ff       	jmp    800512 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 c0 04             	add    $0x4,%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 e8 04             	sub    $0x4,%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	50                   	push   %eax
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	ff d0                	call   *%eax
  8005e9:	83 c4 10             	add    $0x10,%esp
			break;
  8005ec:	e9 9b 02 00 00       	jmp    80088c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 c0 04             	add    $0x4,%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	83 e8 04             	sub    $0x4,%eax
  800600:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800602:	85 db                	test   %ebx,%ebx
  800604:	79 02                	jns    800608 <vprintfmt+0x14a>
				err = -err;
  800606:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800608:	83 fb 64             	cmp    $0x64,%ebx
  80060b:	7f 0b                	jg     800618 <vprintfmt+0x15a>
  80060d:	8b 34 9d 60 1c 80 00 	mov    0x801c60(,%ebx,4),%esi
  800614:	85 f6                	test   %esi,%esi
  800616:	75 19                	jne    800631 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800618:	53                   	push   %ebx
  800619:	68 05 1e 80 00       	push   $0x801e05
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	ff 75 08             	pushl  0x8(%ebp)
  800624:	e8 70 02 00 00       	call   800899 <printfmt>
  800629:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80062c:	e9 5b 02 00 00       	jmp    80088c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800631:	56                   	push   %esi
  800632:	68 0e 1e 80 00       	push   $0x801e0e
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	ff 75 08             	pushl  0x8(%ebp)
  80063d:	e8 57 02 00 00       	call   800899 <printfmt>
  800642:	83 c4 10             	add    $0x10,%esp
			break;
  800645:	e9 42 02 00 00       	jmp    80088c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 c0 04             	add    $0x4,%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 e8 04             	sub    $0x4,%eax
  800659:	8b 30                	mov    (%eax),%esi
  80065b:	85 f6                	test   %esi,%esi
  80065d:	75 05                	jne    800664 <vprintfmt+0x1a6>
				p = "(null)";
  80065f:	be 11 1e 80 00       	mov    $0x801e11,%esi
			if (width > 0 && padc != '-')
  800664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800668:	7e 6d                	jle    8006d7 <vprintfmt+0x219>
  80066a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80066e:	74 67                	je     8006d7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	50                   	push   %eax
  800677:	56                   	push   %esi
  800678:	e8 1e 03 00 00       	call   80099b <strnlen>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800683:	eb 16                	jmp    80069b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800685:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	50                   	push   %eax
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	ff d0                	call   *%eax
  800695:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800698:	ff 4d e4             	decl   -0x1c(%ebp)
  80069b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069f:	7f e4                	jg     800685 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a1:	eb 34                	jmp    8006d7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a7:	74 1c                	je     8006c5 <vprintfmt+0x207>
  8006a9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ac:	7e 05                	jle    8006b3 <vprintfmt+0x1f5>
  8006ae:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b1:	7e 12                	jle    8006c5 <vprintfmt+0x207>
					putch('?', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	6a 3f                	push   $0x3f
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	eb 0f                	jmp    8006d4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	53                   	push   %ebx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d7:	89 f0                	mov    %esi,%eax
  8006d9:	8d 70 01             	lea    0x1(%eax),%esi
  8006dc:	8a 00                	mov    (%eax),%al
  8006de:	0f be d8             	movsbl %al,%ebx
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	74 24                	je     800709 <vprintfmt+0x24b>
  8006e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e9:	78 b8                	js     8006a3 <vprintfmt+0x1e5>
  8006eb:	ff 4d e0             	decl   -0x20(%ebp)
  8006ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f2:	79 af                	jns    8006a3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f4:	eb 13                	jmp    800709 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	6a 20                	push   $0x20
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	ff d0                	call   *%eax
  800703:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800706:	ff 4d e4             	decl   -0x1c(%ebp)
  800709:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070d:	7f e7                	jg     8006f6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80070f:	e9 78 01 00 00       	jmp    80088c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	ff 75 e8             	pushl  -0x18(%ebp)
  80071a:	8d 45 14             	lea    0x14(%ebp),%eax
  80071d:	50                   	push   %eax
  80071e:	e8 3c fd ff ff       	call   80045f <getint>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800729:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80072c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800732:	85 d2                	test   %edx,%edx
  800734:	79 23                	jns    800759 <vprintfmt+0x29b>
				putch('-', putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	6a 2d                	push   $0x2d
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	ff d0                	call   *%eax
  800743:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074c:	f7 d8                	neg    %eax
  80074e:	83 d2 00             	adc    $0x0,%edx
  800751:	f7 da                	neg    %edx
  800753:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800756:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800759:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800760:	e9 bc 00 00 00       	jmp    800821 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 e8             	pushl  -0x18(%ebp)
  80076b:	8d 45 14             	lea    0x14(%ebp),%eax
  80076e:	50                   	push   %eax
  80076f:	e8 84 fc ff ff       	call   8003f8 <getuint>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80077d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800784:	e9 98 00 00 00       	jmp    800821 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	6a 58                	push   $0x58
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	ff d0                	call   *%eax
  800796:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 58                	push   $0x58
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 58                	push   $0x58
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			break;
  8007b9:	e9 ce 00 00 00       	jmp    80088c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	6a 30                	push   $0x30
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	ff d0                	call   *%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 78                	push   $0x78
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 c0 04             	add    $0x4,%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800800:	eb 1f                	jmp    800821 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 e8             	pushl  -0x18(%ebp)
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
  80080b:	50                   	push   %eax
  80080c:	e8 e7 fb ff ff       	call   8003f8 <getuint>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800817:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80081a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800821:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	52                   	push   %edx
  80082c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80082f:	50                   	push   %eax
  800830:	ff 75 f4             	pushl  -0xc(%ebp)
  800833:	ff 75 f0             	pushl  -0x10(%ebp)
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	ff 75 08             	pushl  0x8(%ebp)
  80083c:	e8 00 fb ff ff       	call   800341 <printnum>
  800841:	83 c4 20             	add    $0x20,%esp
			break;
  800844:	eb 46                	jmp    80088c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	53                   	push   %ebx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	ff d0                	call   *%eax
  800852:	83 c4 10             	add    $0x10,%esp
			break;
  800855:	eb 35                	jmp    80088c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800857:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80085e:	eb 2c                	jmp    80088c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800860:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800867:	eb 23                	jmp    80088c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	6a 25                	push   $0x25
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800879:	ff 4d 10             	decl   0x10(%ebp)
  80087c:	eb 03                	jmp    800881 <vprintfmt+0x3c3>
  80087e:	ff 4d 10             	decl   0x10(%ebp)
  800881:	8b 45 10             	mov    0x10(%ebp),%eax
  800884:	48                   	dec    %eax
  800885:	8a 00                	mov    (%eax),%al
  800887:	3c 25                	cmp    $0x25,%al
  800889:	75 f3                	jne    80087e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80088b:	90                   	nop
		}
	}
  80088c:	e9 35 fc ff ff       	jmp    8004c6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800891:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800892:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800895:	5b                   	pop    %ebx
  800896:	5e                   	pop    %esi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80089f:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a2:	83 c0 04             	add    $0x4,%eax
  8008a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 04 fc ff ff       	call   8004be <vprintfmt>
  8008ba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008bd:	90                   	nop
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c6:	8b 40 08             	mov    0x8(%eax),%eax
  8008c9:	8d 50 01             	lea    0x1(%eax),%edx
  8008cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	8b 40 04             	mov    0x4(%eax),%eax
  8008dd:	39 c2                	cmp    %eax,%edx
  8008df:	73 12                	jae    8008f3 <sprintputch+0x33>
		*b->buf++ = ch;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 0a                	mov    %ecx,(%edx)
  8008ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f1:	88 10                	mov    %dl,(%eax)
}
  8008f3:	90                   	nop
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800902:	8b 45 0c             	mov    0xc(%ebp),%eax
  800905:	8d 50 ff             	lea    -0x1(%eax),%edx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800917:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80091b:	74 06                	je     800923 <vsnprintf+0x2d>
  80091d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800921:	7f 07                	jg     80092a <vsnprintf+0x34>
		return -E_INVAL;
  800923:	b8 03 00 00 00       	mov    $0x3,%eax
  800928:	eb 20                	jmp    80094a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80092a:	ff 75 14             	pushl  0x14(%ebp)
  80092d:	ff 75 10             	pushl  0x10(%ebp)
  800930:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800933:	50                   	push   %eax
  800934:	68 c0 08 80 00       	push   $0x8008c0
  800939:	e8 80 fb ff ff       	call   8004be <vprintfmt>
  80093e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800944:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800947:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800952:	8d 45 10             	lea    0x10(%ebp),%eax
  800955:	83 c0 04             	add    $0x4,%eax
  800958:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80095b:	8b 45 10             	mov    0x10(%ebp),%eax
  80095e:	ff 75 f4             	pushl  -0xc(%ebp)
  800961:	50                   	push   %eax
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	ff 75 08             	pushl  0x8(%ebp)
  800968:	e8 89 ff ff ff       	call   8008f6 <vsnprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80097e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800985:	eb 06                	jmp    80098d <strlen+0x15>
		n++;
  800987:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80098a:	ff 45 08             	incl   0x8(%ebp)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8a 00                	mov    (%eax),%al
  800992:	84 c0                	test   %al,%al
  800994:	75 f1                	jne    800987 <strlen+0xf>
		n++;
	return n;
  800996:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a8:	eb 09                	jmp    8009b3 <strnlen+0x18>
		n++;
  8009aa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ad:	ff 45 08             	incl   0x8(%ebp)
  8009b0:	ff 4d 0c             	decl   0xc(%ebp)
  8009b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009b7:	74 09                	je     8009c2 <strnlen+0x27>
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8a 00                	mov    (%eax),%al
  8009be:	84 c0                	test   %al,%al
  8009c0:	75 e8                	jne    8009aa <strnlen+0xf>
		n++;
	return n;
  8009c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    

008009c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009d3:	90                   	nop
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009e6:	8a 12                	mov    (%edx),%dl
  8009e8:	88 10                	mov    %dl,(%eax)
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	84 c0                	test   %al,%al
  8009ee:	75 e4                	jne    8009d4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a08:	eb 1f                	jmp    800a29 <strncpy+0x34>
		*dst++ = *src;
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8d 50 01             	lea    0x1(%eax),%edx
  800a10:	89 55 08             	mov    %edx,0x8(%ebp)
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a16:	8a 12                	mov    (%edx),%dl
  800a18:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1d:	8a 00                	mov    (%eax),%al
  800a1f:	84 c0                	test   %al,%al
  800a21:	74 03                	je     800a26 <strncpy+0x31>
			src++;
  800a23:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a26:	ff 45 fc             	incl   -0x4(%ebp)
  800a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a2c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a2f:	72 d9                	jb     800a0a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a46:	74 30                	je     800a78 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a48:	eb 16                	jmp    800a60 <strlcpy+0x2a>
			*dst++ = *src++;
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8d 50 01             	lea    0x1(%eax),%edx
  800a50:	89 55 08             	mov    %edx,0x8(%ebp)
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a5c:	8a 12                	mov    (%edx),%dl
  800a5e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a60:	ff 4d 10             	decl   0x10(%ebp)
  800a63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a67:	74 09                	je     800a72 <strlcpy+0x3c>
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	84 c0                	test   %al,%al
  800a70:	75 d8                	jne    800a4a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a78:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	29 c2                	sub    %eax,%edx
  800a80:	89 d0                	mov    %edx,%eax
}
  800a82:	c9                   	leave  
  800a83:	c3                   	ret    

00800a84 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a87:	eb 06                	jmp    800a8f <strcmp+0xb>
		p++, q++;
  800a89:	ff 45 08             	incl   0x8(%ebp)
  800a8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	84 c0                	test   %al,%al
  800a96:	74 0e                	je     800aa6 <strcmp+0x22>
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8a 10                	mov    (%eax),%dl
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	38 c2                	cmp    %al,%dl
  800aa4:	74 e3                	je     800a89 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	0f b6 d0             	movzbl %al,%edx
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	0f b6 c0             	movzbl %al,%eax
  800ab6:	29 c2                	sub    %eax,%edx
  800ab8:	89 d0                	mov    %edx,%eax
}
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800abf:	eb 09                	jmp    800aca <strncmp+0xe>
		n--, p++, q++;
  800ac1:	ff 4d 10             	decl   0x10(%ebp)
  800ac4:	ff 45 08             	incl   0x8(%ebp)
  800ac7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ace:	74 17                	je     800ae7 <strncmp+0x2b>
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	84 c0                	test   %al,%al
  800ad7:	74 0e                	je     800ae7 <strncmp+0x2b>
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8a 10                	mov    (%eax),%dl
  800ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	38 c2                	cmp    %al,%dl
  800ae5:	74 da                	je     800ac1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ae7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aeb:	75 07                	jne    800af4 <strncmp+0x38>
		return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	eb 14                	jmp    800b08 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	0f b6 d0             	movzbl %al,%edx
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	0f b6 c0             	movzbl %al,%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b16:	eb 12                	jmp    800b2a <strchr+0x20>
		if (*s == c)
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8a 00                	mov    (%eax),%al
  800b1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b20:	75 05                	jne    800b27 <strchr+0x1d>
			return (char *) s;
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	eb 11                	jmp    800b38 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b27:	ff 45 08             	incl   0x8(%ebp)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8a 00                	mov    (%eax),%al
  800b2f:	84 c0                	test   %al,%al
  800b31:	75 e5                	jne    800b18 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	83 ec 04             	sub    $0x4,%esp
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b46:	eb 0d                	jmp    800b55 <strfind+0x1b>
		if (*s == c)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8a 00                	mov    (%eax),%al
  800b4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b50:	74 0e                	je     800b60 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b52:	ff 45 08             	incl   0x8(%ebp)
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	75 ea                	jne    800b48 <strfind+0xe>
  800b5e:	eb 01                	jmp    800b61 <strfind+0x27>
		if (*s == c)
			break;
  800b60:	90                   	nop
	return (char *) s;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b64:	c9                   	leave  
  800b65:	c3                   	ret    

00800b66 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b78:	eb 0e                	jmp    800b88 <memset+0x22>
		*p++ = c;
  800b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7d:	8d 50 01             	lea    0x1(%eax),%edx
  800b80:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b86:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b88:	ff 4d f8             	decl   -0x8(%ebp)
  800b8b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b8f:	79 e9                	jns    800b7a <memset+0x14>
		*p++ = c;

	return v;
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ba8:	eb 16                	jmp    800bc0 <memcpy+0x2a>
		*d++ = *s++;
  800baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bbc:	8a 12                	mov    (%edx),%dl
  800bbe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc9:	85 c0                	test   %eax,%eax
  800bcb:	75 dd                	jne    800baa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd0:	c9                   	leave  
  800bd1:	c3                   	ret    

00800bd2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bea:	73 50                	jae    800c3c <memmove+0x6a>
  800bec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	01 d0                	add    %edx,%eax
  800bf4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bf7:	76 43                	jbe    800c3c <memmove+0x6a>
		s += n;
  800bf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bff:	8b 45 10             	mov    0x10(%ebp),%eax
  800c02:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c05:	eb 10                	jmp    800c17 <memmove+0x45>
			*--d = *--s;
  800c07:	ff 4d f8             	decl   -0x8(%ebp)
  800c0a:	ff 4d fc             	decl   -0x4(%ebp)
  800c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c10:	8a 10                	mov    (%eax),%dl
  800c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c15:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c20:	85 c0                	test   %eax,%eax
  800c22:	75 e3                	jne    800c07 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c24:	eb 23                	jmp    800c49 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c29:	8d 50 01             	lea    0x1(%eax),%edx
  800c2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c38:	8a 12                	mov    (%edx),%dl
  800c3a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c42:	89 55 10             	mov    %edx,0x10(%ebp)
  800c45:	85 c0                	test   %eax,%eax
  800c47:	75 dd                	jne    800c26 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c60:	eb 2a                	jmp    800c8c <memcmp+0x3e>
		if (*s1 != *s2)
  800c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c65:	8a 10                	mov    (%eax),%dl
  800c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	38 c2                	cmp    %al,%dl
  800c6e:	74 16                	je     800c86 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	0f b6 d0             	movzbl %al,%edx
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	0f b6 c0             	movzbl %al,%eax
  800c80:	29 c2                	sub    %eax,%edx
  800c82:	89 d0                	mov    %edx,%eax
  800c84:	eb 18                	jmp    800c9e <memcmp+0x50>
		s1++, s2++;
  800c86:	ff 45 fc             	incl   -0x4(%ebp)
  800c89:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c92:	89 55 10             	mov    %edx,0x10(%ebp)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	75 c9                	jne    800c62 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	01 d0                	add    %edx,%eax
  800cae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cb1:	eb 15                	jmp    800cc8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	0f b6 d0             	movzbl %al,%edx
  800cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbe:	0f b6 c0             	movzbl %al,%eax
  800cc1:	39 c2                	cmp    %eax,%edx
  800cc3:	74 0d                	je     800cd2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cce:	72 e3                	jb     800cb3 <memfind+0x13>
  800cd0:	eb 01                	jmp    800cd3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cd2:	90                   	nop
	return (void *) s;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ce5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cec:	eb 03                	jmp    800cf1 <strtol+0x19>
		s++;
  800cee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	3c 20                	cmp    $0x20,%al
  800cf8:	74 f4                	je     800cee <strtol+0x16>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	3c 09                	cmp    $0x9,%al
  800d01:	74 eb                	je     800cee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3c 2b                	cmp    $0x2b,%al
  800d0a:	75 05                	jne    800d11 <strtol+0x39>
		s++;
  800d0c:	ff 45 08             	incl   0x8(%ebp)
  800d0f:	eb 13                	jmp    800d24 <strtol+0x4c>
	else if (*s == '-')
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	3c 2d                	cmp    $0x2d,%al
  800d18:	75 0a                	jne    800d24 <strtol+0x4c>
		s++, neg = 1;
  800d1a:	ff 45 08             	incl   0x8(%ebp)
  800d1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	74 06                	je     800d30 <strtol+0x58>
  800d2a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d2e:	75 20                	jne    800d50 <strtol+0x78>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3c 30                	cmp    $0x30,%al
  800d37:	75 17                	jne    800d50 <strtol+0x78>
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	40                   	inc    %eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 78                	cmp    $0x78,%al
  800d41:	75 0d                	jne    800d50 <strtol+0x78>
		s += 2, base = 16;
  800d43:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d47:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d4e:	eb 28                	jmp    800d78 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	75 15                	jne    800d6b <strtol+0x93>
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 30                	cmp    $0x30,%al
  800d5d:	75 0c                	jne    800d6b <strtol+0x93>
		s++, base = 8;
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d69:	eb 0d                	jmp    800d78 <strtol+0xa0>
	else if (base == 0)
  800d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6f:	75 07                	jne    800d78 <strtol+0xa0>
		base = 10;
  800d71:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 2f                	cmp    $0x2f,%al
  800d7f:	7e 19                	jle    800d9a <strtol+0xc2>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3c 39                	cmp    $0x39,%al
  800d88:	7f 10                	jg     800d9a <strtol+0xc2>
			dig = *s - '0';
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be c0             	movsbl %al,%eax
  800d92:	83 e8 30             	sub    $0x30,%eax
  800d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d98:	eb 42                	jmp    800ddc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 60                	cmp    $0x60,%al
  800da1:	7e 19                	jle    800dbc <strtol+0xe4>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 7a                	cmp    $0x7a,%al
  800daa:	7f 10                	jg     800dbc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f be c0             	movsbl %al,%eax
  800db4:	83 e8 57             	sub    $0x57,%eax
  800db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dba:	eb 20                	jmp    800ddc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3c 40                	cmp    $0x40,%al
  800dc3:	7e 39                	jle    800dfe <strtol+0x126>
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	3c 5a                	cmp    $0x5a,%al
  800dcc:	7f 30                	jg     800dfe <strtol+0x126>
			dig = *s - 'A' + 10;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f be c0             	movsbl %al,%eax
  800dd6:	83 e8 37             	sub    $0x37,%eax
  800dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ddf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de2:	7d 19                	jge    800dfd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dee:	89 c2                	mov    %eax,%edx
  800df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df3:	01 d0                	add    %edx,%eax
  800df5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800df8:	e9 7b ff ff ff       	jmp    800d78 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dfd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e02:	74 08                	je     800e0c <strtol+0x134>
		*endptr = (char *) s;
  800e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e10:	74 07                	je     800e19 <strtol+0x141>
  800e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e15:	f7 d8                	neg    %eax
  800e17:	eb 03                	jmp    800e1c <strtol+0x144>
  800e19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <ltostr>:

void
ltostr(long value, char *str)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e36:	79 13                	jns    800e4b <ltostr+0x2d>
	{
		neg = 1;
  800e38:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e45:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e48:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e53:	99                   	cltd   
  800e54:	f7 f9                	idiv   %ecx
  800e56:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5c:	8d 50 01             	lea    0x1(%eax),%edx
  800e5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e62:	89 c2                	mov    %eax,%edx
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e6c:	83 c2 30             	add    $0x30,%edx
  800e6f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e74:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e79:	f7 e9                	imul   %ecx
  800e7b:	c1 fa 02             	sar    $0x2,%edx
  800e7e:	89 c8                	mov    %ecx,%eax
  800e80:	c1 f8 1f             	sar    $0x1f,%eax
  800e83:	29 c2                	sub    %eax,%edx
  800e85:	89 d0                	mov    %edx,%eax
  800e87:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e8e:	75 bb                	jne    800e4b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	48                   	dec    %eax
  800e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ea2:	74 3d                	je     800ee1 <ltostr+0xc3>
		start = 1 ;
  800ea4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800eab:	eb 34                	jmp    800ee1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	01 d0                	add    %edx,%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	01 c2                	add    %eax,%edx
  800ec2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	01 c8                	add    %ecx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	01 c2                	add    %eax,%edx
  800ed6:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ed9:	88 02                	mov    %al,(%edx)
		start++ ;
  800edb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ede:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ee7:	7c c4                	jl     800ead <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ee9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	01 d0                	add    %edx,%eax
  800ef1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ef4:	90                   	nop
  800ef5:	c9                   	leave  
  800ef6:	c3                   	ret    

00800ef7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 73 fa ff ff       	call   800978 <strlen>
  800f05:	83 c4 04             	add    $0x4,%esp
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	e8 65 fa ff ff       	call   800978 <strlen>
  800f13:	83 c4 04             	add    $0x4,%esp
  800f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f27:	eb 17                	jmp    800f40 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	01 c2                	add    %eax,%edx
  800f31:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	01 c8                	add    %ecx,%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f3d:	ff 45 fc             	incl   -0x4(%ebp)
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f46:	7c e1                	jl     800f29 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f48:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f56:	eb 1f                	jmp    800f77 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5b:	8d 50 01             	lea    0x1(%eax),%edx
  800f5e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f61:	89 c2                	mov    %eax,%edx
  800f63:	8b 45 10             	mov    0x10(%ebp),%eax
  800f66:	01 c2                	add    %eax,%edx
  800f68:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	01 c8                	add    %ecx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f74:	ff 45 f8             	incl   -0x8(%ebp)
  800f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	7c d9                	jl     800f58 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	01 d0                	add    %edx,%eax
  800f87:	c6 00 00             	movb   $0x0,(%eax)
}
  800f8a:	90                   	nop
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f90:	8b 45 14             	mov    0x14(%ebp),%eax
  800f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f99:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9c:	8b 00                	mov    (%eax),%eax
  800f9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb0:	eb 0c                	jmp    800fbe <strsplit+0x31>
			*string++ = 0;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8d 50 01             	lea    0x1(%eax),%edx
  800fb8:	89 55 08             	mov    %edx,0x8(%ebp)
  800fbb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	74 18                	je     800fdf <strsplit+0x52>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	50                   	push   %eax
  800fd0:	ff 75 0c             	pushl  0xc(%ebp)
  800fd3:	e8 32 fb ff ff       	call   800b0a <strchr>
  800fd8:	83 c4 08             	add    $0x8,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	75 d3                	jne    800fb2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	84 c0                	test   %al,%al
  800fe6:	74 5a                	je     801042 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	8b 00                	mov    (%eax),%eax
  800fed:	83 f8 0f             	cmp    $0xf,%eax
  800ff0:	75 07                	jne    800ff9 <strsplit+0x6c>
		{
			return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	eb 66                	jmp    80105f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffc:	8b 00                	mov    (%eax),%eax
  800ffe:	8d 48 01             	lea    0x1(%eax),%ecx
  801001:	8b 55 14             	mov    0x14(%ebp),%edx
  801004:	89 0a                	mov    %ecx,(%edx)
  801006:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80100d:	8b 45 10             	mov    0x10(%ebp),%eax
  801010:	01 c2                	add    %eax,%edx
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801017:	eb 03                	jmp    80101c <strsplit+0x8f>
			string++;
  801019:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	84 c0                	test   %al,%al
  801023:	74 8b                	je     800fb0 <strsplit+0x23>
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	0f be c0             	movsbl %al,%eax
  80102d:	50                   	push   %eax
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	e8 d4 fa ff ff       	call   800b0a <strchr>
  801036:	83 c4 08             	add    $0x8,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	74 dc                	je     801019 <strsplit+0x8c>
			string++;
	}
  80103d:	e9 6e ff ff ff       	jmp    800fb0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801042:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	8b 00                	mov    (%eax),%eax
  801048:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80105a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801067:	83 ec 04             	sub    $0x4,%esp
  80106a:	68 88 1f 80 00       	push   $0x801f88
  80106f:	68 3f 01 00 00       	push   $0x13f
  801074:	68 aa 1f 80 00       	push   $0x801faa
  801079:	e8 2d 06 00 00       	call   8016ab <_panic>

0080107e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801090:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801093:	8b 7d 18             	mov    0x18(%ebp),%edi
  801096:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801099:	cd 30                	int    $0x30
  80109b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8010b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	6a 00                	push   $0x0
  8010be:	6a 00                	push   $0x0
  8010c0:	52                   	push   %edx
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	50                   	push   %eax
  8010c5:	6a 00                	push   $0x0
  8010c7:	e8 b2 ff ff ff       	call   80107e <syscall>
  8010cc:	83 c4 18             	add    $0x18,%esp
}
  8010cf:	90                   	nop
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010d5:	6a 00                	push   $0x0
  8010d7:	6a 00                	push   $0x0
  8010d9:	6a 00                	push   $0x0
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 02                	push   $0x2
  8010e1:	e8 98 ff ff ff       	call   80107e <syscall>
  8010e6:	83 c4 18             	add    $0x18,%esp
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010ee:	6a 00                	push   $0x0
  8010f0:	6a 00                	push   $0x0
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 03                	push   $0x3
  8010fa:	e8 7f ff ff ff       	call   80107e <syscall>
  8010ff:	83 c4 18             	add    $0x18,%esp
}
  801102:	90                   	nop
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	6a 04                	push   $0x4
  801114:	e8 65 ff ff ff       	call   80107e <syscall>
  801119:	83 c4 18             	add    $0x18,%esp
}
  80111c:	90                   	nop
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801122:	8b 55 0c             	mov    0xc(%ebp),%edx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	52                   	push   %edx
  80112f:	50                   	push   %eax
  801130:	6a 08                	push   $0x8
  801132:	e8 47 ff ff ff       	call   80107e <syscall>
  801137:	83 c4 18             	add    $0x18,%esp
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801141:	8b 75 18             	mov    0x18(%ebp),%esi
  801144:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801147:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80114a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	51                   	push   %ecx
  801153:	52                   	push   %edx
  801154:	50                   	push   %eax
  801155:	6a 09                	push   $0x9
  801157:	e8 22 ff ff ff       	call   80107e <syscall>
  80115c:	83 c4 18             	add    $0x18,%esp
}
  80115f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	52                   	push   %edx
  801176:	50                   	push   %eax
  801177:	6a 0a                	push   $0xa
  801179:	e8 00 ff ff ff       	call   80107e <syscall>
  80117e:	83 c4 18             	add    $0x18,%esp
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    

00801183 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801186:	6a 00                	push   $0x0
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	ff 75 08             	pushl  0x8(%ebp)
  801192:	6a 0b                	push   $0xb
  801194:	e8 e5 fe ff ff       	call   80107e <syscall>
  801199:	83 c4 18             	add    $0x18,%esp
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 0c                	push   $0xc
  8011ad:	e8 cc fe ff ff       	call   80107e <syscall>
  8011b2:	83 c4 18             	add    $0x18,%esp
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 00                	push   $0x0
  8011c0:	6a 00                	push   $0x0
  8011c2:	6a 00                	push   $0x0
  8011c4:	6a 0d                	push   $0xd
  8011c6:	e8 b3 fe ff ff       	call   80107e <syscall>
  8011cb:	83 c4 18             	add    $0x18,%esp
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 0e                	push   $0xe
  8011df:	e8 9a fe ff ff       	call   80107e <syscall>
  8011e4:	83 c4 18             	add    $0x18,%esp
}
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 00                	push   $0x0
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 0f                	push   $0xf
  8011f8:	e8 81 fe ff ff       	call   80107e <syscall>
  8011fd:	83 c4 18             	add    $0x18,%esp
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	ff 75 08             	pushl  0x8(%ebp)
  801210:	6a 10                	push   $0x10
  801212:	e8 67 fe ff ff       	call   80107e <syscall>
  801217:	83 c4 18             	add    $0x18,%esp
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 11                	push   $0x11
  80122b:	e8 4e fe ff ff       	call   80107e <syscall>
  801230:	83 c4 18             	add    $0x18,%esp
}
  801233:	90                   	nop
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <sys_cputc>:

void
sys_cputc(const char c)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801242:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	50                   	push   %eax
  80124f:	6a 01                	push   $0x1
  801251:	e8 28 fe ff ff       	call   80107e <syscall>
  801256:	83 c4 18             	add    $0x18,%esp
}
  801259:	90                   	nop
  80125a:	c9                   	leave  
  80125b:	c3                   	ret    

0080125c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 14                	push   $0x14
  80126b:	e8 0e fe ff ff       	call   80107e <syscall>
  801270:	83 c4 18             	add    $0x18,%esp
}
  801273:	90                   	nop
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801282:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801285:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	6a 00                	push   $0x0
  80128e:	51                   	push   %ecx
  80128f:	52                   	push   %edx
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	6a 15                	push   $0x15
  801296:	e8 e3 fd ff ff       	call   80107e <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	52                   	push   %edx
  8012b0:	50                   	push   %eax
  8012b1:	6a 16                	push   $0x16
  8012b3:	e8 c6 fd ff ff       	call   80107e <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	51                   	push   %ecx
  8012ce:	52                   	push   %edx
  8012cf:	50                   	push   %eax
  8012d0:	6a 17                	push   $0x17
  8012d2:	e8 a7 fd ff ff       	call   80107e <syscall>
  8012d7:	83 c4 18             	add    $0x18,%esp
}
  8012da:	c9                   	leave  
  8012db:	c3                   	ret    

008012dc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8012df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	6a 00                	push   $0x0
  8012eb:	52                   	push   %edx
  8012ec:	50                   	push   %eax
  8012ed:	6a 18                	push   $0x18
  8012ef:	e8 8a fd ff ff       	call   80107e <syscall>
  8012f4:	83 c4 18             	add    $0x18,%esp
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	6a 00                	push   $0x0
  801301:	ff 75 14             	pushl  0x14(%ebp)
  801304:	ff 75 10             	pushl  0x10(%ebp)
  801307:	ff 75 0c             	pushl  0xc(%ebp)
  80130a:	50                   	push   %eax
  80130b:	6a 19                	push   $0x19
  80130d:	e8 6c fd ff ff       	call   80107e <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	50                   	push   %eax
  801326:	6a 1a                	push   $0x1a
  801328:	e8 51 fd ff ff       	call   80107e <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	50                   	push   %eax
  801342:	6a 1b                	push   $0x1b
  801344:	e8 35 fd ff ff       	call   80107e <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 05                	push   $0x5
  80135d:	e8 1c fd ff ff       	call   80107e <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 06                	push   $0x6
  801376:	e8 03 fd ff ff       	call   80107e <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 07                	push   $0x7
  80138f:	e8 ea fc ff ff       	call   80107e <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_exit_env>:


void sys_exit_env(void)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 1c                	push   $0x1c
  8013a8:	e8 d1 fc ff ff       	call   80107e <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	90                   	nop
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8013b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013bc:	8d 50 04             	lea    0x4(%eax),%edx
  8013bf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	52                   	push   %edx
  8013c9:	50                   	push   %eax
  8013ca:	6a 1d                	push   $0x1d
  8013cc:	e8 ad fc ff ff       	call   80107e <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
	return result;
  8013d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	89 01                	mov    %eax,(%ecx)
  8013df:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	c9                   	leave  
  8013e6:	c2 04 00             	ret    $0x4

008013e9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	ff 75 10             	pushl  0x10(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	6a 13                	push   $0x13
  8013fb:	e8 7e fc ff ff       	call   80107e <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
	return ;
  801403:	90                   	nop
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_rcr2>:
uint32 sys_rcr2()
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 1e                	push   $0x1e
  801415:	e8 64 fc ff ff       	call   80107e <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80142b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	50                   	push   %eax
  801438:	6a 1f                	push   $0x1f
  80143a:	e8 3f fc ff ff       	call   80107e <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
	return ;
  801442:	90                   	nop
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <rsttst>:
void rsttst()
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 21                	push   $0x21
  801454:	e8 25 fc ff ff       	call   80107e <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
	return ;
  80145c:	90                   	nop
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 14             	mov    0x14(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80146b:	8b 55 18             	mov    0x18(%ebp),%edx
  80146e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801472:	52                   	push   %edx
  801473:	50                   	push   %eax
  801474:	ff 75 10             	pushl  0x10(%ebp)
  801477:	ff 75 0c             	pushl  0xc(%ebp)
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	6a 20                	push   $0x20
  80147f:	e8 fa fb ff ff       	call   80107e <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
	return ;
  801487:	90                   	nop
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <chktst>:
void chktst(uint32 n)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	ff 75 08             	pushl  0x8(%ebp)
  801498:	6a 22                	push   $0x22
  80149a:	e8 df fb ff ff       	call   80107e <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a2:	90                   	nop
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <inctst>:

void inctst()
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 23                	push   $0x23
  8014b4:	e8 c5 fb ff ff       	call   80107e <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bc:	90                   	nop
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <gettst>:
uint32 gettst()
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 24                	push   $0x24
  8014ce:	e8 ab fb ff ff       	call   80107e <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 25                	push   $0x25
  8014ea:	e8 8f fb ff ff       	call   80107e <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
  8014f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014f5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014f9:	75 07                	jne    801502 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801500:	eb 05                	jmp    801507 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801502:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 25                	push   $0x25
  80151b:	e8 5e fb ff ff       	call   80107e <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
  801523:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801526:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80152a:	75 07                	jne    801533 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80152c:	b8 01 00 00 00       	mov    $0x1,%eax
  801531:	eb 05                	jmp    801538 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 25                	push   $0x25
  80154c:	e8 2d fb ff ff       	call   80107e <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801557:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80155b:	75 07                	jne    801564 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80155d:	b8 01 00 00 00       	mov    $0x1,%eax
  801562:	eb 05                	jmp    801569 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 25                	push   $0x25
  80157d:	e8 fc fa ff ff       	call   80107e <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
  801585:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801588:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80158c:	75 07                	jne    801595 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80158e:	b8 01 00 00 00       	mov    $0x1,%eax
  801593:	eb 05                	jmp    80159a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	6a 26                	push   $0x26
  8015ac:	e8 cd fa ff ff       	call   80107e <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b4:	90                   	nop
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8015bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	6a 00                	push   $0x0
  8015c9:	53                   	push   %ebx
  8015ca:	51                   	push   %ecx
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	6a 27                	push   $0x27
  8015cf:	e8 aa fa ff ff       	call   80107e <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	52                   	push   %edx
  8015ec:	50                   	push   %eax
  8015ed:	6a 28                	push   $0x28
  8015ef:	e8 8a fa ff ff       	call   80107e <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8015fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	6a 00                	push   $0x0
  801607:	51                   	push   %ecx
  801608:	ff 75 10             	pushl  0x10(%ebp)
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	6a 29                	push   $0x29
  80160f:	e8 6a fa ff ff       	call   80107e <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	ff 75 10             	pushl  0x10(%ebp)
  801623:	ff 75 0c             	pushl  0xc(%ebp)
  801626:	ff 75 08             	pushl  0x8(%ebp)
  801629:	6a 12                	push   $0x12
  80162b:	e8 4e fa ff ff       	call   80107e <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
	return ;
  801633:	90                   	nop
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	52                   	push   %edx
  801646:	50                   	push   %eax
  801647:	6a 2a                	push   $0x2a
  801649:	e8 30 fa ff ff       	call   80107e <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
	return;
  801651:	90                   	nop
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	68 b7 1f 80 00       	push   $0x801fb7
  801662:	68 2e 01 00 00       	push   $0x12e
  801667:	68 cb 1f 80 00       	push   $0x801fcb
  80166c:	e8 3a 00 00 00       	call   8016ab <_panic>

00801671 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 b7 1f 80 00       	push   $0x801fb7
  80167f:	68 35 01 00 00       	push   $0x135
  801684:	68 cb 1f 80 00       	push   $0x801fcb
  801689:	e8 1d 00 00 00       	call   8016ab <_panic>

0080168e <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	68 b7 1f 80 00       	push   $0x801fb7
  80169c:	68 3b 01 00 00       	push   $0x13b
  8016a1:	68 cb 1f 80 00       	push   $0x801fcb
  8016a6:	e8 00 00 00 00       	call   8016ab <_panic>

008016ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8016b4:	83 c0 04             	add    $0x4,%eax
  8016b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016ba:	a1 24 30 80 00       	mov    0x803024,%eax
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	74 16                	je     8016d9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016c3:	a1 24 30 80 00       	mov    0x803024,%eax
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	50                   	push   %eax
  8016cc:	68 dc 1f 80 00       	push   $0x801fdc
  8016d1:	e8 0e ec ff ff       	call   8002e4 <cprintf>
  8016d6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016d9:	a1 00 30 80 00       	mov    0x803000,%eax
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	68 e1 1f 80 00       	push   $0x801fe1
  8016ea:	e8 f5 eb ff ff       	call   8002e4 <cprintf>
  8016ef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fb:	50                   	push   %eax
  8016fc:	e8 78 eb ff ff       	call   800279 <vcprintf>
  801701:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	6a 00                	push   $0x0
  801709:	68 fd 1f 80 00       	push   $0x801ffd
  80170e:	e8 66 eb ff ff       	call   800279 <vcprintf>
  801713:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801716:	e8 e7 ea ff ff       	call   800202 <exit>

	// should not return here
	while (1) ;
  80171b:	eb fe                	jmp    80171b <_panic+0x70>

0080171d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801723:	a1 04 30 80 00       	mov    0x803004,%eax
  801728:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	39 c2                	cmp    %eax,%edx
  801733:	74 14                	je     801749 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 00 20 80 00       	push   $0x802000
  80173d:	6a 26                	push   $0x26
  80173f:	68 4c 20 80 00       	push   $0x80204c
  801744:	e8 62 ff ff ff       	call   8016ab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801750:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801757:	e9 c5 00 00 00       	jmp    801821 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	85 c0                	test   %eax,%eax
  80176f:	75 08                	jne    801779 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801771:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801774:	e9 a5 00 00 00       	jmp    80181e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801779:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801780:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801787:	eb 69                	jmp    8017f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801789:	a1 04 30 80 00       	mov    0x803004,%eax
  80178e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801794:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801797:	89 d0                	mov    %edx,%eax
  801799:	01 c0                	add    %eax,%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	c1 e0 03             	shl    $0x3,%eax
  8017a0:	01 c8                	add    %ecx,%eax
  8017a2:	8a 40 04             	mov    0x4(%eax),%al
  8017a5:	84 c0                	test   %al,%al
  8017a7:	75 46                	jne    8017ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8017ae:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8017b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b7:	89 d0                	mov    %edx,%eax
  8017b9:	01 c0                	add    %eax,%eax
  8017bb:	01 d0                	add    %edx,%eax
  8017bd:	c1 e0 03             	shl    $0x3,%eax
  8017c0:	01 c8                	add    %ecx,%eax
  8017c2:	8b 00                	mov    (%eax),%eax
  8017c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	01 c8                	add    %ecx,%eax
  8017e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017e2:	39 c2                	cmp    %eax,%edx
  8017e4:	75 09                	jne    8017ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017ed:	eb 15                	jmp    801804 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017ef:	ff 45 e8             	incl   -0x18(%ebp)
  8017f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8017f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801800:	39 c2                	cmp    %eax,%edx
  801802:	77 85                	ja     801789 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801804:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801808:	75 14                	jne    80181e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 58 20 80 00       	push   $0x802058
  801812:	6a 3a                	push   $0x3a
  801814:	68 4c 20 80 00       	push   $0x80204c
  801819:	e8 8d fe ff ff       	call   8016ab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80181e:	ff 45 f0             	incl   -0x10(%ebp)
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801827:	0f 8c 2f ff ff ff    	jl     80175c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80182d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801834:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80183b:	eb 26                	jmp    801863 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80183d:	a1 04 30 80 00       	mov    0x803004,%eax
  801842:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801848:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	01 c0                	add    %eax,%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	c1 e0 03             	shl    $0x3,%eax
  801854:	01 c8                	add    %ecx,%eax
  801856:	8a 40 04             	mov    0x4(%eax),%al
  801859:	3c 01                	cmp    $0x1,%al
  80185b:	75 03                	jne    801860 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80185d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801860:	ff 45 e0             	incl   -0x20(%ebp)
  801863:	a1 04 30 80 00       	mov    0x803004,%eax
  801868:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	39 c2                	cmp    %eax,%edx
  801873:	77 c8                	ja     80183d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80187b:	74 14                	je     801891 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	68 ac 20 80 00       	push   $0x8020ac
  801885:	6a 44                	push   $0x44
  801887:	68 4c 20 80 00       	push   $0x80204c
  80188c:	e8 1a fe ff ff       	call   8016ab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801891:	90                   	nop
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <__udivdi3>:
  801894:	55                   	push   %ebp
  801895:	57                   	push   %edi
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	83 ec 1c             	sub    $0x1c,%esp
  80189b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80189f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ab:	89 ca                	mov    %ecx,%edx
  8018ad:	89 f8                	mov    %edi,%eax
  8018af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018b3:	85 f6                	test   %esi,%esi
  8018b5:	75 2d                	jne    8018e4 <__udivdi3+0x50>
  8018b7:	39 cf                	cmp    %ecx,%edi
  8018b9:	77 65                	ja     801920 <__udivdi3+0x8c>
  8018bb:	89 fd                	mov    %edi,%ebp
  8018bd:	85 ff                	test   %edi,%edi
  8018bf:	75 0b                	jne    8018cc <__udivdi3+0x38>
  8018c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c6:	31 d2                	xor    %edx,%edx
  8018c8:	f7 f7                	div    %edi
  8018ca:	89 c5                	mov    %eax,%ebp
  8018cc:	31 d2                	xor    %edx,%edx
  8018ce:	89 c8                	mov    %ecx,%eax
  8018d0:	f7 f5                	div    %ebp
  8018d2:	89 c1                	mov    %eax,%ecx
  8018d4:	89 d8                	mov    %ebx,%eax
  8018d6:	f7 f5                	div    %ebp
  8018d8:	89 cf                	mov    %ecx,%edi
  8018da:	89 fa                	mov    %edi,%edx
  8018dc:	83 c4 1c             	add    $0x1c,%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5f                   	pop    %edi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    
  8018e4:	39 ce                	cmp    %ecx,%esi
  8018e6:	77 28                	ja     801910 <__udivdi3+0x7c>
  8018e8:	0f bd fe             	bsr    %esi,%edi
  8018eb:	83 f7 1f             	xor    $0x1f,%edi
  8018ee:	75 40                	jne    801930 <__udivdi3+0x9c>
  8018f0:	39 ce                	cmp    %ecx,%esi
  8018f2:	72 0a                	jb     8018fe <__udivdi3+0x6a>
  8018f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018f8:	0f 87 9e 00 00 00    	ja     80199c <__udivdi3+0x108>
  8018fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801903:	89 fa                	mov    %edi,%edx
  801905:	83 c4 1c             	add    $0x1c,%esp
  801908:	5b                   	pop    %ebx
  801909:	5e                   	pop    %esi
  80190a:	5f                   	pop    %edi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
  80190d:	8d 76 00             	lea    0x0(%esi),%esi
  801910:	31 ff                	xor    %edi,%edi
  801912:	31 c0                	xor    %eax,%eax
  801914:	89 fa                	mov    %edi,%edx
  801916:	83 c4 1c             	add    $0x1c,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5e                   	pop    %esi
  80191b:	5f                   	pop    %edi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    
  80191e:	66 90                	xchg   %ax,%ax
  801920:	89 d8                	mov    %ebx,%eax
  801922:	f7 f7                	div    %edi
  801924:	31 ff                	xor    %edi,%edi
  801926:	89 fa                	mov    %edi,%edx
  801928:	83 c4 1c             	add    $0x1c,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5f                   	pop    %edi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
  801930:	bd 20 00 00 00       	mov    $0x20,%ebp
  801935:	89 eb                	mov    %ebp,%ebx
  801937:	29 fb                	sub    %edi,%ebx
  801939:	89 f9                	mov    %edi,%ecx
  80193b:	d3 e6                	shl    %cl,%esi
  80193d:	89 c5                	mov    %eax,%ebp
  80193f:	88 d9                	mov    %bl,%cl
  801941:	d3 ed                	shr    %cl,%ebp
  801943:	89 e9                	mov    %ebp,%ecx
  801945:	09 f1                	or     %esi,%ecx
  801947:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80194b:	89 f9                	mov    %edi,%ecx
  80194d:	d3 e0                	shl    %cl,%eax
  80194f:	89 c5                	mov    %eax,%ebp
  801951:	89 d6                	mov    %edx,%esi
  801953:	88 d9                	mov    %bl,%cl
  801955:	d3 ee                	shr    %cl,%esi
  801957:	89 f9                	mov    %edi,%ecx
  801959:	d3 e2                	shl    %cl,%edx
  80195b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80195f:	88 d9                	mov    %bl,%cl
  801961:	d3 e8                	shr    %cl,%eax
  801963:	09 c2                	or     %eax,%edx
  801965:	89 d0                	mov    %edx,%eax
  801967:	89 f2                	mov    %esi,%edx
  801969:	f7 74 24 0c          	divl   0xc(%esp)
  80196d:	89 d6                	mov    %edx,%esi
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	f7 e5                	mul    %ebp
  801973:	39 d6                	cmp    %edx,%esi
  801975:	72 19                	jb     801990 <__udivdi3+0xfc>
  801977:	74 0b                	je     801984 <__udivdi3+0xf0>
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	31 ff                	xor    %edi,%edi
  80197d:	e9 58 ff ff ff       	jmp    8018da <__udivdi3+0x46>
  801982:	66 90                	xchg   %ax,%ax
  801984:	8b 54 24 08          	mov    0x8(%esp),%edx
  801988:	89 f9                	mov    %edi,%ecx
  80198a:	d3 e2                	shl    %cl,%edx
  80198c:	39 c2                	cmp    %eax,%edx
  80198e:	73 e9                	jae    801979 <__udivdi3+0xe5>
  801990:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801993:	31 ff                	xor    %edi,%edi
  801995:	e9 40 ff ff ff       	jmp    8018da <__udivdi3+0x46>
  80199a:	66 90                	xchg   %ax,%ax
  80199c:	31 c0                	xor    %eax,%eax
  80199e:	e9 37 ff ff ff       	jmp    8018da <__udivdi3+0x46>
  8019a3:	90                   	nop

008019a4 <__umoddi3>:
  8019a4:	55                   	push   %ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 1c             	sub    $0x1c,%esp
  8019ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019c3:	89 f3                	mov    %esi,%ebx
  8019c5:	89 fa                	mov    %edi,%edx
  8019c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019cb:	89 34 24             	mov    %esi,(%esp)
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	75 1a                	jne    8019ec <__umoddi3+0x48>
  8019d2:	39 f7                	cmp    %esi,%edi
  8019d4:	0f 86 a2 00 00 00    	jbe    801a7c <__umoddi3+0xd8>
  8019da:	89 c8                	mov    %ecx,%eax
  8019dc:	89 f2                	mov    %esi,%edx
  8019de:	f7 f7                	div    %edi
  8019e0:	89 d0                	mov    %edx,%eax
  8019e2:	31 d2                	xor    %edx,%edx
  8019e4:	83 c4 1c             	add    $0x1c,%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5e                   	pop    %esi
  8019e9:	5f                   	pop    %edi
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    
  8019ec:	39 f0                	cmp    %esi,%eax
  8019ee:	0f 87 ac 00 00 00    	ja     801aa0 <__umoddi3+0xfc>
  8019f4:	0f bd e8             	bsr    %eax,%ebp
  8019f7:	83 f5 1f             	xor    $0x1f,%ebp
  8019fa:	0f 84 ac 00 00 00    	je     801aac <__umoddi3+0x108>
  801a00:	bf 20 00 00 00       	mov    $0x20,%edi
  801a05:	29 ef                	sub    %ebp,%edi
  801a07:	89 fe                	mov    %edi,%esi
  801a09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a0d:	89 e9                	mov    %ebp,%ecx
  801a0f:	d3 e0                	shl    %cl,%eax
  801a11:	89 d7                	mov    %edx,%edi
  801a13:	89 f1                	mov    %esi,%ecx
  801a15:	d3 ef                	shr    %cl,%edi
  801a17:	09 c7                	or     %eax,%edi
  801a19:	89 e9                	mov    %ebp,%ecx
  801a1b:	d3 e2                	shl    %cl,%edx
  801a1d:	89 14 24             	mov    %edx,(%esp)
  801a20:	89 d8                	mov    %ebx,%eax
  801a22:	d3 e0                	shl    %cl,%eax
  801a24:	89 c2                	mov    %eax,%edx
  801a26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2a:	d3 e0                	shl    %cl,%eax
  801a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a34:	89 f1                	mov    %esi,%ecx
  801a36:	d3 e8                	shr    %cl,%eax
  801a38:	09 d0                	or     %edx,%eax
  801a3a:	d3 eb                	shr    %cl,%ebx
  801a3c:	89 da                	mov    %ebx,%edx
  801a3e:	f7 f7                	div    %edi
  801a40:	89 d3                	mov    %edx,%ebx
  801a42:	f7 24 24             	mull   (%esp)
  801a45:	89 c6                	mov    %eax,%esi
  801a47:	89 d1                	mov    %edx,%ecx
  801a49:	39 d3                	cmp    %edx,%ebx
  801a4b:	0f 82 87 00 00 00    	jb     801ad8 <__umoddi3+0x134>
  801a51:	0f 84 91 00 00 00    	je     801ae8 <__umoddi3+0x144>
  801a57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a5b:	29 f2                	sub    %esi,%edx
  801a5d:	19 cb                	sbb    %ecx,%ebx
  801a5f:	89 d8                	mov    %ebx,%eax
  801a61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a65:	d3 e0                	shl    %cl,%eax
  801a67:	89 e9                	mov    %ebp,%ecx
  801a69:	d3 ea                	shr    %cl,%edx
  801a6b:	09 d0                	or     %edx,%eax
  801a6d:	89 e9                	mov    %ebp,%ecx
  801a6f:	d3 eb                	shr    %cl,%ebx
  801a71:	89 da                	mov    %ebx,%edx
  801a73:	83 c4 1c             	add    $0x1c,%esp
  801a76:	5b                   	pop    %ebx
  801a77:	5e                   	pop    %esi
  801a78:	5f                   	pop    %edi
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    
  801a7b:	90                   	nop
  801a7c:	89 fd                	mov    %edi,%ebp
  801a7e:	85 ff                	test   %edi,%edi
  801a80:	75 0b                	jne    801a8d <__umoddi3+0xe9>
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
  801a87:	31 d2                	xor    %edx,%edx
  801a89:	f7 f7                	div    %edi
  801a8b:	89 c5                	mov    %eax,%ebp
  801a8d:	89 f0                	mov    %esi,%eax
  801a8f:	31 d2                	xor    %edx,%edx
  801a91:	f7 f5                	div    %ebp
  801a93:	89 c8                	mov    %ecx,%eax
  801a95:	f7 f5                	div    %ebp
  801a97:	89 d0                	mov    %edx,%eax
  801a99:	e9 44 ff ff ff       	jmp    8019e2 <__umoddi3+0x3e>
  801a9e:	66 90                	xchg   %ax,%ax
  801aa0:	89 c8                	mov    %ecx,%eax
  801aa2:	89 f2                	mov    %esi,%edx
  801aa4:	83 c4 1c             	add    $0x1c,%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5f                   	pop    %edi
  801aaa:	5d                   	pop    %ebp
  801aab:	c3                   	ret    
  801aac:	3b 04 24             	cmp    (%esp),%eax
  801aaf:	72 06                	jb     801ab7 <__umoddi3+0x113>
  801ab1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ab5:	77 0f                	ja     801ac6 <__umoddi3+0x122>
  801ab7:	89 f2                	mov    %esi,%edx
  801ab9:	29 f9                	sub    %edi,%ecx
  801abb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801abf:	89 14 24             	mov    %edx,(%esp)
  801ac2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801aca:	8b 14 24             	mov    (%esp),%edx
  801acd:	83 c4 1c             	add    $0x1c,%esp
  801ad0:	5b                   	pop    %ebx
  801ad1:	5e                   	pop    %esi
  801ad2:	5f                   	pop    %edi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    
  801ad5:	8d 76 00             	lea    0x0(%esi),%esi
  801ad8:	2b 04 24             	sub    (%esp),%eax
  801adb:	19 fa                	sbb    %edi,%edx
  801add:	89 d1                	mov    %edx,%ecx
  801adf:	89 c6                	mov    %eax,%esi
  801ae1:	e9 71 ff ff ff       	jmp    801a57 <__umoddi3+0xb3>
  801ae6:	66 90                	xchg   %ax,%ax
  801ae8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801aec:	72 ea                	jb     801ad8 <__umoddi3+0x134>
  801aee:	89 d9                	mov    %ebx,%ecx
  801af0:	e9 62 ff ff ff       	jmp    801a57 <__umoddi3+0xb3>
