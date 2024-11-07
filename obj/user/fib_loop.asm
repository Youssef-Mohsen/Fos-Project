
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 00 1f 80 00       	push   $0x801f00
  800057:	e8 b9 0a 00 00       	call   800b15 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 0c 0f 00 00       	call   800f7e <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 b2 12 00 00       	call   80133a <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 b3 12 00 00       	call   801363 <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 1e 1f 80 00       	push   $0x801f1e
  8000c1:	e8 e9 02 00 00       	call   8003af <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 a7 17 00 00       	call   801875 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80017d:	e8 b5 15 00 00       	call   801737 <sys_getenvindex>
  800182:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800188:	89 d0                	mov    %edx,%eax
  80018a:	c1 e0 02             	shl    $0x2,%eax
  80018d:	01 d0                	add    %edx,%eax
  80018f:	01 c0                	add    %eax,%eax
  800191:	01 d0                	add    %edx,%eax
  800193:	c1 e0 02             	shl    $0x2,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	01 d0                	add    %edx,%eax
  80019c:	c1 e0 04             	shl    $0x4,%eax
  80019f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a4:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ae:	8a 40 20             	mov    0x20(%eax),%al
  8001b1:	84 c0                	test   %al,%al
  8001b3:	74 0d                	je     8001c2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8001b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ba:	83 c0 20             	add    $0x20,%eax
  8001bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c6:	7e 0a                	jle    8001d2 <libmain+0x5b>
		binaryname = argv[0];
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	8b 00                	mov    (%eax),%eax
  8001cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	e8 58 fe ff ff       	call   800038 <_main>
  8001e0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001e3:	e8 d3 12 00 00       	call   8014bb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	68 4c 1f 80 00       	push   $0x801f4c
  8001f0:	e8 8d 01 00 00       	call   800382 <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fd:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800203:	a1 04 30 80 00       	mov    0x803004,%eax
  800208:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80020e:	83 ec 04             	sub    $0x4,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	68 74 1f 80 00       	push   $0x801f74
  800218:	e8 65 01 00 00       	call   800382 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800220:	a1 04 30 80 00       	mov    0x803004,%eax
  800225:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80022b:	a1 04 30 80 00       	mov    0x803004,%eax
  800230:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800236:	a1 04 30 80 00       	mov    0x803004,%eax
  80023b:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800241:	51                   	push   %ecx
  800242:	52                   	push   %edx
  800243:	50                   	push   %eax
  800244:	68 9c 1f 80 00       	push   $0x801f9c
  800249:	e8 34 01 00 00       	call   800382 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800251:	a1 04 30 80 00       	mov    0x803004,%eax
  800256:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	50                   	push   %eax
  800260:	68 f4 1f 80 00       	push   $0x801ff4
  800265:	e8 18 01 00 00       	call   800382 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	68 4c 1f 80 00       	push   $0x801f4c
  800275:	e8 08 01 00 00       	call   800382 <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80027d:	e8 53 12 00 00       	call   8014d5 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800282:	e8 19 00 00 00       	call   8002a0 <exit>
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 00                	push   $0x0
  800295:	e8 69 14 00 00       	call   801703 <sys_destroy_env>
  80029a:	83 c4 10             	add    $0x10,%esp
}
  80029d:	90                   	nop
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <exit>:

void
exit(void)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a6:	e8 be 14 00 00       	call   801769 <sys_exit_env>
}
  8002ab:	90                   	nop
  8002ac:	c9                   	leave  
  8002ad:	c3                   	ret    

008002ae <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	8b 00                	mov    (%eax),%eax
  8002b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8002bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bf:	89 0a                	mov    %ecx,(%edx)
  8002c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c4:	88 d1                	mov    %dl,%cl
  8002c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	8b 00                	mov    (%eax),%eax
  8002d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d7:	75 2c                	jne    800305 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d9:	a0 08 30 80 00       	mov    0x803008,%al
  8002de:	0f b6 c0             	movzbl %al,%eax
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	8b 12                	mov    (%edx),%edx
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002eb:	83 c2 08             	add    $0x8,%edx
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	50                   	push   %eax
  8002f2:	51                   	push   %ecx
  8002f3:	52                   	push   %edx
  8002f4:	e8 80 11 00 00       	call   801479 <sys_cputs>
  8002f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	8b 40 04             	mov    0x4(%eax),%eax
  80030b:	8d 50 01             	lea    0x1(%eax),%edx
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	89 50 04             	mov    %edx,0x4(%eax)
}
  800314:	90                   	nop
  800315:	c9                   	leave  
  800316:	c3                   	ret    

00800317 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800320:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800327:	00 00 00 
	b.cnt = 0;
  80032a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800331:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800334:	ff 75 0c             	pushl  0xc(%ebp)
  800337:	ff 75 08             	pushl  0x8(%ebp)
  80033a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	68 ae 02 80 00       	push   $0x8002ae
  800346:	e8 11 02 00 00       	call   80055c <vprintfmt>
  80034b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80034e:	a0 08 30 80 00       	mov    0x803008,%al
  800353:	0f b6 c0             	movzbl %al,%eax
  800356:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	50                   	push   %eax
  800360:	52                   	push   %edx
  800361:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800367:	83 c0 08             	add    $0x8,%eax
  80036a:	50                   	push   %eax
  80036b:	e8 09 11 00 00       	call   801479 <sys_cputs>
  800370:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800373:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80037a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800388:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80038f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	ff 75 f4             	pushl  -0xc(%ebp)
  80039e:	50                   	push   %eax
  80039f:	e8 73 ff ff ff       	call   800317 <vcprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
  8003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    

008003af <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003b5:	e8 01 11 00 00       	call   8014bb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	e8 48 ff ff ff       	call   800317 <vcprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003d5:	e8 fb 10 00 00       	call   8014d5 <sys_unlock_cons>
	return cnt;
  8003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003dd:	c9                   	leave  
  8003de:	c3                   	ret    

008003df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	53                   	push   %ebx
  8003e3:	83 ec 14             	sub    $0x14,%esp
  8003e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fd:	77 55                	ja     800454 <printnum+0x75>
  8003ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800402:	72 05                	jb     800409 <printnum+0x2a>
  800404:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800407:	77 4b                	ja     800454 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800409:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80040c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80040f:	8b 45 18             	mov    0x18(%ebp),%eax
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
  800417:	52                   	push   %edx
  800418:	50                   	push   %eax
  800419:	ff 75 f4             	pushl  -0xc(%ebp)
  80041c:	ff 75 f0             	pushl  -0x10(%ebp)
  80041f:	e8 78 18 00 00       	call   801c9c <__udivdi3>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	ff 75 20             	pushl  0x20(%ebp)
  80042d:	53                   	push   %ebx
  80042e:	ff 75 18             	pushl  0x18(%ebp)
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	ff 75 0c             	pushl  0xc(%ebp)
  800436:	ff 75 08             	pushl  0x8(%ebp)
  800439:	e8 a1 ff ff ff       	call   8003df <printnum>
  80043e:	83 c4 20             	add    $0x20,%esp
  800441:	eb 1a                	jmp    80045d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	ff 75 0c             	pushl  0xc(%ebp)
  800449:	ff 75 20             	pushl  0x20(%ebp)
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	ff d0                	call   *%eax
  800451:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800454:	ff 4d 1c             	decl   0x1c(%ebp)
  800457:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80045b:	7f e6                	jg     800443 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800460:	bb 00 00 00 00       	mov    $0x0,%ebx
  800465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800468:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80046b:	53                   	push   %ebx
  80046c:	51                   	push   %ecx
  80046d:	52                   	push   %edx
  80046e:	50                   	push   %eax
  80046f:	e8 38 19 00 00       	call   801dac <__umoddi3>
  800474:	83 c4 10             	add    $0x10,%esp
  800477:	05 34 22 80 00       	add    $0x802234,%eax
  80047c:	8a 00                	mov    (%eax),%al
  80047e:	0f be c0             	movsbl %al,%eax
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	50                   	push   %eax
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	ff d0                	call   *%eax
  80048d:	83 c4 10             	add    $0x10,%esp
}
  800490:	90                   	nop
  800491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800499:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80049d:	7e 1c                	jle    8004bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	8d 50 08             	lea    0x8(%eax),%edx
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	89 10                	mov    %edx,(%eax)
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	83 e8 08             	sub    $0x8,%eax
  8004b4:	8b 50 04             	mov    0x4(%eax),%edx
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	eb 40                	jmp    8004fb <getuint+0x65>
	else if (lflag)
  8004bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bf:	74 1e                	je     8004df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	8d 50 04             	lea    0x4(%eax),%edx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 10                	mov    %edx,(%eax)
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	83 e8 04             	sub    $0x4,%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	eb 1c                	jmp    8004fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	8d 50 04             	lea    0x4(%eax),%edx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	89 10                	mov    %edx,(%eax)
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	83 e8 04             	sub    $0x4,%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800500:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800504:	7e 1c                	jle    800522 <getint+0x25>
		return va_arg(*ap, long long);
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	8d 50 08             	lea    0x8(%eax),%edx
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	89 10                	mov    %edx,(%eax)
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	83 e8 08             	sub    $0x8,%eax
  80051b:	8b 50 04             	mov    0x4(%eax),%edx
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	eb 38                	jmp    80055a <getint+0x5d>
	else if (lflag)
  800522:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800526:	74 1a                	je     800542 <getint+0x45>
		return va_arg(*ap, long);
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	8d 50 04             	lea    0x4(%eax),%edx
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	89 10                	mov    %edx,(%eax)
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	83 e8 04             	sub    $0x4,%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	99                   	cltd   
  800540:	eb 18                	jmp    80055a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	89 10                	mov    %edx,(%eax)
  80054f:	8b 45 08             	mov    0x8(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	83 e8 04             	sub    $0x4,%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	99                   	cltd   
}
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    

0080055c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	56                   	push   %esi
  800560:	53                   	push   %ebx
  800561:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800564:	eb 17                	jmp    80057d <vprintfmt+0x21>
			if (ch == '\0')
  800566:	85 db                	test   %ebx,%ebx
  800568:	0f 84 c1 03 00 00    	je     80092f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 0c             	pushl  0xc(%ebp)
  800574:	53                   	push   %ebx
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	ff d0                	call   *%eax
  80057a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057d:	8b 45 10             	mov    0x10(%ebp),%eax
  800580:	8d 50 01             	lea    0x1(%eax),%edx
  800583:	89 55 10             	mov    %edx,0x10(%ebp)
  800586:	8a 00                	mov    (%eax),%al
  800588:	0f b6 d8             	movzbl %al,%ebx
  80058b:	83 fb 25             	cmp    $0x25,%ebx
  80058e:	75 d6                	jne    800566 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800590:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800594:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80059b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b3:	8d 50 01             	lea    0x1(%eax),%edx
  8005b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b9:	8a 00                	mov    (%eax),%al
  8005bb:	0f b6 d8             	movzbl %al,%ebx
  8005be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c1:	83 f8 5b             	cmp    $0x5b,%eax
  8005c4:	0f 87 3d 03 00 00    	ja     800907 <vprintfmt+0x3ab>
  8005ca:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  8005d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d7                	jmp    8005b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005dd:	eb d1                	jmp    8005b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e9:	89 d0                	mov    %edx,%eax
  8005eb:	c1 e0 02             	shl    $0x2,%eax
  8005ee:	01 d0                	add    %edx,%eax
  8005f0:	01 c0                	add    %eax,%eax
  8005f2:	01 d8                	add    %ebx,%eax
  8005f4:	83 e8 30             	sub    $0x30,%eax
  8005f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fd:	8a 00                	mov    (%eax),%al
  8005ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800602:	83 fb 2f             	cmp    $0x2f,%ebx
  800605:	7e 3e                	jle    800645 <vprintfmt+0xe9>
  800607:	83 fb 39             	cmp    $0x39,%ebx
  80060a:	7f 39                	jg     800645 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80060f:	eb d5                	jmp    8005e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 c0 04             	add    $0x4,%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 e8 04             	sub    $0x4,%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800625:	eb 1f                	jmp    800646 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062b:	79 83                	jns    8005b0 <vprintfmt+0x54>
				width = 0;
  80062d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800634:	e9 77 ff ff ff       	jmp    8005b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800639:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800640:	e9 6b ff ff ff       	jmp    8005b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800645:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800646:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064a:	0f 89 60 ff ff ff    	jns    8005b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800656:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80065d:	e9 4e ff ff ff       	jmp    8005b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800662:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800665:	e9 46 ff ff ff       	jmp    8005b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 c0 04             	add    $0x4,%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	50                   	push   %eax
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	ff d0                	call   *%eax
  800687:	83 c4 10             	add    $0x10,%esp
			break;
  80068a:	e9 9b 02 00 00       	jmp    80092a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 c0 04             	add    $0x4,%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a0:	85 db                	test   %ebx,%ebx
  8006a2:	79 02                	jns    8006a6 <vprintfmt+0x14a>
				err = -err;
  8006a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a6:	83 fb 64             	cmp    $0x64,%ebx
  8006a9:	7f 0b                	jg     8006b6 <vprintfmt+0x15a>
  8006ab:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  8006b2:	85 f6                	test   %esi,%esi
  8006b4:	75 19                	jne    8006cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b6:	53                   	push   %ebx
  8006b7:	68 45 22 80 00       	push   $0x802245
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	ff 75 08             	pushl  0x8(%ebp)
  8006c2:	e8 70 02 00 00       	call   800937 <printfmt>
  8006c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006ca:	e9 5b 02 00 00       	jmp    80092a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006cf:	56                   	push   %esi
  8006d0:	68 4e 22 80 00       	push   $0x80224e
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	ff 75 08             	pushl  0x8(%ebp)
  8006db:	e8 57 02 00 00       	call   800937 <printfmt>
  8006e0:	83 c4 10             	add    $0x10,%esp
			break;
  8006e3:	e9 42 02 00 00       	jmp    80092a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	83 c0 04             	add    $0x4,%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 30                	mov    (%eax),%esi
  8006f9:	85 f6                	test   %esi,%esi
  8006fb:	75 05                	jne    800702 <vprintfmt+0x1a6>
				p = "(null)";
  8006fd:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	7e 6d                	jle    800775 <vprintfmt+0x219>
  800708:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80070c:	74 67                	je     800775 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80070e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	50                   	push   %eax
  800715:	56                   	push   %esi
  800716:	e8 26 05 00 00       	call   800c41 <strnlen>
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800721:	eb 16                	jmp    800739 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800723:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	50                   	push   %eax
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	ff d0                	call   *%eax
  800733:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800736:	ff 4d e4             	decl   -0x1c(%ebp)
  800739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073d:	7f e4                	jg     800723 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073f:	eb 34                	jmp    800775 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800741:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800745:	74 1c                	je     800763 <vprintfmt+0x207>
  800747:	83 fb 1f             	cmp    $0x1f,%ebx
  80074a:	7e 05                	jle    800751 <vprintfmt+0x1f5>
  80074c:	83 fb 7e             	cmp    $0x7e,%ebx
  80074f:	7e 12                	jle    800763 <vprintfmt+0x207>
					putch('?', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 0c             	pushl  0xc(%ebp)
  800757:	6a 3f                	push   $0x3f
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	eb 0f                	jmp    800772 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	53                   	push   %ebx
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	ff d0                	call   *%eax
  80076f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800772:	ff 4d e4             	decl   -0x1c(%ebp)
  800775:	89 f0                	mov    %esi,%eax
  800777:	8d 70 01             	lea    0x1(%eax),%esi
  80077a:	8a 00                	mov    (%eax),%al
  80077c:	0f be d8             	movsbl %al,%ebx
  80077f:	85 db                	test   %ebx,%ebx
  800781:	74 24                	je     8007a7 <vprintfmt+0x24b>
  800783:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800787:	78 b8                	js     800741 <vprintfmt+0x1e5>
  800789:	ff 4d e0             	decl   -0x20(%ebp)
  80078c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800790:	79 af                	jns    800741 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800792:	eb 13                	jmp    8007a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 0c             	pushl  0xc(%ebp)
  80079a:	6a 20                	push   $0x20
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	ff d0                	call   *%eax
  8007a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ab:	7f e7                	jg     800794 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007ad:	e9 78 01 00 00       	jmp    80092a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bb:	50                   	push   %eax
  8007bc:	e8 3c fd ff ff       	call   8004fd <getint>
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	79 23                	jns    8007f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 2d                	push   $0x2d
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ea:	f7 d8                	neg    %eax
  8007ec:	83 d2 00             	adc    $0x0,%edx
  8007ef:	f7 da                	neg    %edx
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007fe:	e9 bc 00 00 00       	jmp    8008bf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 e8             	pushl  -0x18(%ebp)
  800809:	8d 45 14             	lea    0x14(%ebp),%eax
  80080c:	50                   	push   %eax
  80080d:	e8 84 fc ff ff       	call   800496 <getuint>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800818:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80081b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800822:	e9 98 00 00 00       	jmp    8008bf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	6a 58                	push   $0x58
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	6a 58                	push   $0x58
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	6a 58                	push   $0x58
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
			break;
  800857:	e9 ce 00 00 00       	jmp    80092a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	6a 30                	push   $0x30
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 78                	push   $0x78
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 c0 04             	add    $0x4,%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 e8 04             	sub    $0x4,%eax
  80088b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80088d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800897:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80089e:	eb 1f                	jmp    8008bf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a9:	50                   	push   %eax
  8008aa:	e8 e7 fb ff ff       	call   800496 <getuint>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008bf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c6:	83 ec 04             	sub    $0x4,%esp
  8008c9:	52                   	push   %edx
  8008ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008cd:	50                   	push   %eax
  8008ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	ff 75 08             	pushl  0x8(%ebp)
  8008da:	e8 00 fb ff ff       	call   8003df <printnum>
  8008df:	83 c4 20             	add    $0x20,%esp
			break;
  8008e2:	eb 46                	jmp    80092a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
			break;
  8008f3:	eb 35                	jmp    80092a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008f5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008fc:	eb 2c                	jmp    80092a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008fe:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800905:	eb 23                	jmp    80092a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	6a 25                	push   $0x25
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800917:	ff 4d 10             	decl   0x10(%ebp)
  80091a:	eb 03                	jmp    80091f <vprintfmt+0x3c3>
  80091c:	ff 4d 10             	decl   0x10(%ebp)
  80091f:	8b 45 10             	mov    0x10(%ebp),%eax
  800922:	48                   	dec    %eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	3c 25                	cmp    $0x25,%al
  800927:	75 f3                	jne    80091c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800929:	90                   	nop
		}
	}
  80092a:	e9 35 fc ff ff       	jmp    800564 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80092f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800930:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80093d:	8d 45 10             	lea    0x10(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800946:	8b 45 10             	mov    0x10(%ebp),%eax
  800949:	ff 75 f4             	pushl  -0xc(%ebp)
  80094c:	50                   	push   %eax
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 04 fc ff ff       	call   80055c <vprintfmt>
  800958:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80095b:	90                   	nop
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    

0080095e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	8b 40 08             	mov    0x8(%eax),%eax
  800967:	8d 50 01             	lea    0x1(%eax),%edx
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8b 10                	mov    (%eax),%edx
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	8b 40 04             	mov    0x4(%eax),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	73 12                	jae    800991 <sprintputch+0x33>
		*b->buf++ = ch;
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	8d 48 01             	lea    0x1(%eax),%ecx
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	89 0a                	mov    %ecx,(%edx)
  80098c:	8b 55 08             	mov    0x8(%ebp),%edx
  80098f:	88 10                	mov    %dl,(%eax)
}
  800991:	90                   	nop
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b9:	74 06                	je     8009c1 <vsnprintf+0x2d>
  8009bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009bf:	7f 07                	jg     8009c8 <vsnprintf+0x34>
		return -E_INVAL;
  8009c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8009c6:	eb 20                	jmp    8009e8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c8:	ff 75 14             	pushl  0x14(%ebp)
  8009cb:	ff 75 10             	pushl  0x10(%ebp)
  8009ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d1:	50                   	push   %eax
  8009d2:	68 5e 09 80 00       	push   $0x80095e
  8009d7:	e8 80 fb ff ff       	call   80055c <vprintfmt>
  8009dc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009f3:	83 c0 04             	add    $0x4,%eax
  8009f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ff:	50                   	push   %eax
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 08             	pushl  0x8(%ebp)
  800a06:	e8 89 ff ff ff       	call   800994 <vsnprintf>
  800a0b:	83 c4 10             	add    $0x10,%esp
  800a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a20:	74 13                	je     800a35 <readline+0x1f>
		cprintf("%s", prompt);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	68 c8 23 80 00       	push   $0x8023c8
  800a2d:	e8 50 f9 ff ff       	call   800382 <cprintf>
  800a32:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a3c:	83 ec 0c             	sub    $0xc,%esp
  800a3f:	6a 00                	push   $0x0
  800a41:	e8 63 10 00 00       	call   801aa9 <iscons>
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a4c:	e8 45 10 00 00       	call   801a96 <getchar>
  800a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	79 22                	jns    800a7c <readline+0x66>
			if (c != -E_EOF)
  800a5a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a5e:	0f 84 ad 00 00 00    	je     800b11 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 ec             	pushl  -0x14(%ebp)
  800a6a:	68 cb 23 80 00       	push   $0x8023cb
  800a6f:	e8 0e f9 ff ff       	call   800382 <cprintf>
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 95 00 00 00       	jmp    800b11 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a7c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a80:	7e 34                	jle    800ab6 <readline+0xa0>
  800a82:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a89:	7f 2b                	jg     800ab6 <readline+0xa0>
			if (echoing)
  800a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a8f:	74 0e                	je     800a9f <readline+0x89>
				cputchar(c);
  800a91:	83 ec 0c             	sub    $0xc,%esp
  800a94:	ff 75 ec             	pushl  -0x14(%ebp)
  800a97:	e8 db 0f 00 00       	call   801a77 <cputchar>
  800a9c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aa2:	8d 50 01             	lea    0x1(%eax),%edx
  800aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aad:	01 d0                	add    %edx,%eax
  800aaf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ab2:	88 10                	mov    %dl,(%eax)
  800ab4:	eb 56                	jmp    800b0c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ab6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800aba:	75 1f                	jne    800adb <readline+0xc5>
  800abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ac0:	7e 19                	jle    800adb <readline+0xc5>
			if (echoing)
  800ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ac6:	74 0e                	je     800ad6 <readline+0xc0>
				cputchar(c);
  800ac8:	83 ec 0c             	sub    $0xc,%esp
  800acb:	ff 75 ec             	pushl  -0x14(%ebp)
  800ace:	e8 a4 0f 00 00       	call   801a77 <cputchar>
  800ad3:	83 c4 10             	add    $0x10,%esp

			i--;
  800ad6:	ff 4d f4             	decl   -0xc(%ebp)
  800ad9:	eb 31                	jmp    800b0c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800adb:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800adf:	74 0a                	je     800aeb <readline+0xd5>
  800ae1:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800ae5:	0f 85 61 ff ff ff    	jne    800a4c <readline+0x36>
			if (echoing)
  800aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aef:	74 0e                	je     800aff <readline+0xe9>
				cputchar(c);
  800af1:	83 ec 0c             	sub    $0xc,%esp
  800af4:	ff 75 ec             	pushl  -0x14(%ebp)
  800af7:	e8 7b 0f 00 00       	call   801a77 <cputchar>
  800afc:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	01 d0                	add    %edx,%eax
  800b07:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b0a:	eb 06                	jmp    800b12 <readline+0xfc>
		}
	}
  800b0c:	e9 3b ff ff ff       	jmp    800a4c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b11:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b12:	90                   	nop
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b1b:	e8 9b 09 00 00       	call   8014bb <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b24:	74 13                	je     800b39 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 08             	pushl  0x8(%ebp)
  800b2c:	68 c8 23 80 00       	push   $0x8023c8
  800b31:	e8 4c f8 ff ff       	call   800382 <cprintf>
  800b36:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b40:	83 ec 0c             	sub    $0xc,%esp
  800b43:	6a 00                	push   $0x0
  800b45:	e8 5f 0f 00 00       	call   801aa9 <iscons>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b50:	e8 41 0f 00 00       	call   801a96 <getchar>
  800b55:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b5c:	79 22                	jns    800b80 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b5e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b62:	0f 84 ad 00 00 00    	je     800c15 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b6e:	68 cb 23 80 00       	push   $0x8023cb
  800b73:	e8 0a f8 ff ff       	call   800382 <cprintf>
  800b78:	83 c4 10             	add    $0x10,%esp
				break;
  800b7b:	e9 95 00 00 00       	jmp    800c15 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b80:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b84:	7e 34                	jle    800bba <atomic_readline+0xa5>
  800b86:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b8d:	7f 2b                	jg     800bba <atomic_readline+0xa5>
				if (echoing)
  800b8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b93:	74 0e                	je     800ba3 <atomic_readline+0x8e>
					cputchar(c);
  800b95:	83 ec 0c             	sub    $0xc,%esp
  800b98:	ff 75 ec             	pushl  -0x14(%ebp)
  800b9b:	e8 d7 0e 00 00       	call   801a77 <cputchar>
  800ba0:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba6:	8d 50 01             	lea    0x1(%eax),%edx
  800ba9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bb6:	88 10                	mov    %dl,(%eax)
  800bb8:	eb 56                	jmp    800c10 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bba:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bbe:	75 1f                	jne    800bdf <atomic_readline+0xca>
  800bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bc4:	7e 19                	jle    800bdf <atomic_readline+0xca>
				if (echoing)
  800bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bca:	74 0e                	je     800bda <atomic_readline+0xc5>
					cputchar(c);
  800bcc:	83 ec 0c             	sub    $0xc,%esp
  800bcf:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd2:	e8 a0 0e 00 00       	call   801a77 <cputchar>
  800bd7:	83 c4 10             	add    $0x10,%esp
				i--;
  800bda:	ff 4d f4             	decl   -0xc(%ebp)
  800bdd:	eb 31                	jmp    800c10 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800bdf:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800be3:	74 0a                	je     800bef <atomic_readline+0xda>
  800be5:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800be9:	0f 85 61 ff ff ff    	jne    800b50 <atomic_readline+0x3b>
				if (echoing)
  800bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bf3:	74 0e                	je     800c03 <atomic_readline+0xee>
					cputchar(c);
  800bf5:	83 ec 0c             	sub    $0xc,%esp
  800bf8:	ff 75 ec             	pushl  -0x14(%ebp)
  800bfb:	e8 77 0e 00 00       	call   801a77 <cputchar>
  800c00:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c09:	01 d0                	add    %edx,%eax
  800c0b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c0e:	eb 06                	jmp    800c16 <atomic_readline+0x101>
			}
		}
  800c10:	e9 3b ff ff ff       	jmp    800b50 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c15:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c16:	e8 ba 08 00 00       	call   8014d5 <sys_unlock_cons>
}
  800c1b:	90                   	nop
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2b:	eb 06                	jmp    800c33 <strlen+0x15>
		n++;
  800c2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c30:	ff 45 08             	incl   0x8(%ebp)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	75 f1                	jne    800c2d <strlen+0xf>
		n++;
	return n;
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4e:	eb 09                	jmp    800c59 <strnlen+0x18>
		n++;
  800c50:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c53:	ff 45 08             	incl   0x8(%ebp)
  800c56:	ff 4d 0c             	decl   0xc(%ebp)
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	74 09                	je     800c68 <strnlen+0x27>
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	84 c0                	test   %al,%al
  800c66:	75 e8                	jne    800c50 <strnlen+0xf>
		n++;
	return n;
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c79:	90                   	nop
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8c:	8a 12                	mov    (%edx),%dl
  800c8e:	88 10                	mov    %dl,(%eax)
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 e4                	jne    800c7a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cae:	eb 1f                	jmp    800ccf <strncpy+0x34>
		*dst++ = *src;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8d 50 01             	lea    0x1(%eax),%edx
  800cb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	8a 12                	mov    (%edx),%dl
  800cbe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	84 c0                	test   %al,%al
  800cc7:	74 03                	je     800ccc <strncpy+0x31>
			src++;
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccc:	ff 45 fc             	incl   -0x4(%ebp)
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd5:	72 d9                	jb     800cb0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cda:	c9                   	leave  
  800cdb:	c3                   	ret    

00800cdc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 30                	je     800d1e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cee:	eb 16                	jmp    800d06 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d02:	8a 12                	mov    (%edx),%dl
  800d04:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d06:	ff 4d 10             	decl   0x10(%ebp)
  800d09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0d:	74 09                	je     800d18 <strlcpy+0x3c>
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 d8                	jne    800cf0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d24:	29 c2                	sub    %eax,%edx
  800d26:	89 d0                	mov    %edx,%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2d:	eb 06                	jmp    800d35 <strcmp+0xb>
		p++, q++;
  800d2f:	ff 45 08             	incl   0x8(%ebp)
  800d32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	74 0e                	je     800d4c <strcmp+0x22>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 10                	mov    (%eax),%dl
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	38 c2                	cmp    %al,%dl
  800d4a:	74 e3                	je     800d2f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	0f b6 d0             	movzbl %al,%edx
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f b6 c0             	movzbl %al,%eax
  800d5c:	29 c2                	sub    %eax,%edx
  800d5e:	89 d0                	mov    %edx,%eax
}
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d65:	eb 09                	jmp    800d70 <strncmp+0xe>
		n--, p++, q++;
  800d67:	ff 4d 10             	decl   0x10(%ebp)
  800d6a:	ff 45 08             	incl   0x8(%ebp)
  800d6d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d74:	74 17                	je     800d8d <strncmp+0x2b>
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	84 c0                	test   %al,%al
  800d7d:	74 0e                	je     800d8d <strncmp+0x2b>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 10                	mov    (%eax),%dl
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	38 c2                	cmp    %al,%dl
  800d8b:	74 da                	je     800d67 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d91:	75 07                	jne    800d9a <strncmp+0x38>
		return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
  800d98:	eb 14                	jmp    800dae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	0f b6 d0             	movzbl %al,%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	0f b6 c0             	movzbl %al,%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbc:	eb 12                	jmp    800dd0 <strchr+0x20>
		if (*s == c)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc6:	75 05                	jne    800dcd <strchr+0x1d>
			return (char *) s;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	eb 11                	jmp    800dde <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 e5                	jne    800dbe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 04             	sub    $0x4,%esp
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dec:	eb 0d                	jmp    800dfb <strfind+0x1b>
		if (*s == c)
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df6:	74 0e                	je     800e06 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df8:	ff 45 08             	incl   0x8(%ebp)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	84 c0                	test   %al,%al
  800e02:	75 ea                	jne    800dee <strfind+0xe>
  800e04:	eb 01                	jmp    800e07 <strfind+0x27>
		if (*s == c)
			break;
  800e06:	90                   	nop
	return (char *) s;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1e:	eb 0e                	jmp    800e2e <memset+0x22>
		*p++ = c;
  800e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e23:	8d 50 01             	lea    0x1(%eax),%edx
  800e26:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2e:	ff 4d f8             	decl   -0x8(%ebp)
  800e31:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e35:	79 e9                	jns    800e20 <memset+0x14>
		*p++ = c;

	return v;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4e:	eb 16                	jmp    800e66 <memcpy+0x2a>
		*d++ = *s++;
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e62:	8a 12                	mov    (%edx),%dl
  800e64:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e66:	8b 45 10             	mov    0x10(%ebp),%eax
  800e69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	75 dd                	jne    800e50 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e90:	73 50                	jae    800ee2 <memmove+0x6a>
  800e92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e95:	8b 45 10             	mov    0x10(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
  800e9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9d:	76 43                	jbe    800ee2 <memmove+0x6a>
		s += n;
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eab:	eb 10                	jmp    800ebd <memmove+0x45>
			*--d = *--s;
  800ead:	ff 4d f8             	decl   -0x8(%ebp)
  800eb0:	ff 4d fc             	decl   -0x4(%ebp)
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb6:	8a 10                	mov    (%eax),%dl
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	75 e3                	jne    800ead <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eca:	eb 23                	jmp    800eef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ede:	8a 12                	mov    (%edx),%dl
  800ee0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee8:	89 55 10             	mov    %edx,0x10(%ebp)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	75 dd                	jne    800ecc <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f06:	eb 2a                	jmp    800f32 <memcmp+0x3e>
		if (*s1 != *s2)
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0b:	8a 10                	mov    (%eax),%dl
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f10:	8a 00                	mov    (%eax),%al
  800f12:	38 c2                	cmp    %al,%dl
  800f14:	74 16                	je     800f2c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	0f b6 d0             	movzbl %al,%edx
  800f1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f b6 c0             	movzbl %al,%eax
  800f26:	29 c2                	sub    %eax,%edx
  800f28:	89 d0                	mov    %edx,%eax
  800f2a:	eb 18                	jmp    800f44 <memcmp+0x50>
		s1++, s2++;
  800f2c:	ff 45 fc             	incl   -0x4(%ebp)
  800f2f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f38:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	75 c9                	jne    800f08 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f52:	01 d0                	add    %edx,%eax
  800f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f57:	eb 15                	jmp    800f6e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	0f b6 c0             	movzbl %al,%eax
  800f67:	39 c2                	cmp    %eax,%edx
  800f69:	74 0d                	je     800f78 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6b:	ff 45 08             	incl   0x8(%ebp)
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f74:	72 e3                	jb     800f59 <memfind+0x13>
  800f76:	eb 01                	jmp    800f79 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f78:	90                   	nop
	return (void *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f92:	eb 03                	jmp    800f97 <strtol+0x19>
		s++;
  800f94:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3c 20                	cmp    $0x20,%al
  800f9e:	74 f4                	je     800f94 <strtol+0x16>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 09                	cmp    $0x9,%al
  800fa7:	74 eb                	je     800f94 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2b                	cmp    $0x2b,%al
  800fb0:	75 05                	jne    800fb7 <strtol+0x39>
		s++;
  800fb2:	ff 45 08             	incl   0x8(%ebp)
  800fb5:	eb 13                	jmp    800fca <strtol+0x4c>
	else if (*s == '-')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 2d                	cmp    $0x2d,%al
  800fbe:	75 0a                	jne    800fca <strtol+0x4c>
		s++, neg = 1;
  800fc0:	ff 45 08             	incl   0x8(%ebp)
  800fc3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fce:	74 06                	je     800fd6 <strtol+0x58>
  800fd0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd4:	75 20                	jne    800ff6 <strtol+0x78>
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 30                	cmp    $0x30,%al
  800fdd:	75 17                	jne    800ff6 <strtol+0x78>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	40                   	inc    %eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 78                	cmp    $0x78,%al
  800fe7:	75 0d                	jne    800ff6 <strtol+0x78>
		s += 2, base = 16;
  800fe9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff4:	eb 28                	jmp    80101e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffa:	75 15                	jne    801011 <strtol+0x93>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 30                	cmp    $0x30,%al
  801003:	75 0c                	jne    801011 <strtol+0x93>
		s++, base = 8;
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80100f:	eb 0d                	jmp    80101e <strtol+0xa0>
	else if (base == 0)
  801011:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801015:	75 07                	jne    80101e <strtol+0xa0>
		base = 10;
  801017:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 2f                	cmp    $0x2f,%al
  801025:	7e 19                	jle    801040 <strtol+0xc2>
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	3c 39                	cmp    $0x39,%al
  80102e:	7f 10                	jg     801040 <strtol+0xc2>
			dig = *s - '0';
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f be c0             	movsbl %al,%eax
  801038:	83 e8 30             	sub    $0x30,%eax
  80103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103e:	eb 42                	jmp    801082 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 60                	cmp    $0x60,%al
  801047:	7e 19                	jle    801062 <strtol+0xe4>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 7a                	cmp    $0x7a,%al
  801050:	7f 10                	jg     801062 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f be c0             	movsbl %al,%eax
  80105a:	83 e8 57             	sub    $0x57,%eax
  80105d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801060:	eb 20                	jmp    801082 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 40                	cmp    $0x40,%al
  801069:	7e 39                	jle    8010a4 <strtol+0x126>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 5a                	cmp    $0x5a,%al
  801072:	7f 30                	jg     8010a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	0f be c0             	movsbl %al,%eax
  80107c:	83 e8 37             	sub    $0x37,%eax
  80107f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801085:	3b 45 10             	cmp    0x10(%ebp),%eax
  801088:	7d 19                	jge    8010a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108a:	ff 45 08             	incl   0x8(%ebp)
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	0f af 45 10          	imul   0x10(%ebp),%eax
  801094:	89 c2                	mov    %eax,%edx
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109e:	e9 7b ff ff ff       	jmp    80101e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a8:	74 08                	je     8010b2 <strtol+0x134>
		*endptr = (char *) s;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b6:	74 07                	je     8010bf <strtol+0x141>
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	f7 d8                	neg    %eax
  8010bd:	eb 03                	jmp    8010c2 <strtol+0x144>
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dc:	79 13                	jns    8010f1 <ltostr+0x2d>
	{
		neg = 1;
  8010de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010f9:	99                   	cltd   
  8010fa:	f7 f9                	idiv   %ecx
  8010fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	8d 50 01             	lea    0x1(%eax),%edx
  801105:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801108:	89 c2                	mov    %eax,%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801112:	83 c2 30             	add    $0x30,%edx
  801115:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111f:	f7 e9                	imul   %ecx
  801121:	c1 fa 02             	sar    $0x2,%edx
  801124:	89 c8                	mov    %ecx,%eax
  801126:	c1 f8 1f             	sar    $0x1f,%eax
  801129:	29 c2                	sub    %eax,%edx
  80112b:	89 d0                	mov    %edx,%eax
  80112d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801134:	75 bb                	jne    8010f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801136:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	48                   	dec    %eax
  801141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801144:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801148:	74 3d                	je     801187 <ltostr+0xc3>
		start = 1 ;
  80114a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801151:	eb 34                	jmp    801187 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	01 c2                	add    %eax,%edx
  801168:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c8                	add    %ecx,%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801174:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	01 c2                	add    %eax,%edx
  80117c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80117f:	88 02                	mov    %al,(%edx)
		start++ ;
  801181:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801184:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80118d:	7c c4                	jl     801153 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80118f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	01 d0                	add    %edx,%eax
  801197:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119a:	90                   	nop
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a3:	ff 75 08             	pushl  0x8(%ebp)
  8011a6:	e8 73 fa ff ff       	call   800c1e <strlen>
  8011ab:	83 c4 04             	add    $0x4,%esp
  8011ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 65 fa ff ff       	call   800c1e <strlen>
  8011b9:	83 c4 04             	add    $0x4,%esp
  8011bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011cd:	eb 17                	jmp    8011e6 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 c2                	add    %eax,%edx
  8011d7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	01 c8                	add    %ecx,%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e3:	ff 45 fc             	incl   -0x4(%ebp)
  8011e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011ec:	7c e1                	jl     8011cf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011fc:	eb 1f                	jmp    80121d <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801201:	8d 50 01             	lea    0x1(%eax),%edx
  801204:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801207:	89 c2                	mov    %eax,%edx
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	01 c2                	add    %eax,%edx
  80120e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	01 c8                	add    %ecx,%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121a:	ff 45 f8             	incl   -0x8(%ebp)
  80121d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801220:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801223:	7c d9                	jl     8011fe <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801225:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801228:	8b 45 10             	mov    0x10(%ebp),%eax
  80122b:	01 d0                	add    %edx,%eax
  80122d:	c6 00 00             	movb   $0x0,(%eax)
}
  801230:	90                   	nop
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	8b 00                	mov    (%eax),%eax
  801244:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 d0                	add    %edx,%eax
  801250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801256:	eb 0c                	jmp    801264 <strsplit+0x31>
			*string++ = 0;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8d 50 01             	lea    0x1(%eax),%edx
  80125e:	89 55 08             	mov    %edx,0x8(%ebp)
  801261:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	84 c0                	test   %al,%al
  80126b:	74 18                	je     801285 <strsplit+0x52>
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	50                   	push   %eax
  801276:	ff 75 0c             	pushl  0xc(%ebp)
  801279:	e8 32 fb ff ff       	call   800db0 <strchr>
  80127e:	83 c4 08             	add    $0x8,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	75 d3                	jne    801258 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	84 c0                	test   %al,%al
  80128c:	74 5a                	je     8012e8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	8b 00                	mov    (%eax),%eax
  801293:	83 f8 0f             	cmp    $0xf,%eax
  801296:	75 07                	jne    80129f <strsplit+0x6c>
		{
			return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb 66                	jmp    801305 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012a7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012aa:	89 0a                	mov    %ecx,(%edx)
  8012ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b6:	01 c2                	add    %eax,%edx
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012bd:	eb 03                	jmp    8012c2 <strsplit+0x8f>
			string++;
  8012bf:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	84 c0                	test   %al,%al
  8012c9:	74 8b                	je     801256 <strsplit+0x23>
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	0f be c0             	movsbl %al,%eax
  8012d3:	50                   	push   %eax
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	e8 d4 fa ff ff       	call   800db0 <strchr>
  8012dc:	83 c4 08             	add    $0x8,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	74 dc                	je     8012bf <strsplit+0x8c>
			string++;
	}
  8012e3:	e9 6e ff ff ff       	jmp    801256 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012e8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	8b 00                	mov    (%eax),%eax
  8012ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	01 d0                	add    %edx,%eax
  8012fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801300:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	68 dc 23 80 00       	push   $0x8023dc
  801315:	68 3f 01 00 00       	push   $0x13f
  80131a:	68 fe 23 80 00       	push   $0x8023fe
  80131f:	e8 8f 07 00 00       	call   801ab3 <_panic>

00801324 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80132a:	83 ec 0c             	sub    $0xc,%esp
  80132d:	ff 75 08             	pushl  0x8(%ebp)
  801330:	e8 ef 06 00 00       	call   801a24 <sys_sbrk>
  801335:	83 c4 10             	add    $0x10,%esp
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	75 07                	jne    80134d <malloc+0x13>
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	eb 14                	jmp    801361 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 0c 24 80 00       	push   $0x80240c
  801355:	6a 1b                	push   $0x1b
  801357:	68 31 24 80 00       	push   $0x802431
  80135c:	e8 52 07 00 00       	call   801ab3 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	68 40 24 80 00       	push   $0x802440
  801371:	6a 29                	push   $0x29
  801373:	68 31 24 80 00       	push   $0x802431
  801378:	e8 36 07 00 00       	call   801ab3 <_panic>

0080137d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 18             	sub    $0x18,%esp
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801389:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80138d:	75 07                	jne    801396 <smalloc+0x19>
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
  801394:	eb 14                	jmp    8013aa <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	68 64 24 80 00       	push   $0x802464
  80139e:	6a 38                	push   $0x38
  8013a0:	68 31 24 80 00       	push   $0x802431
  8013a5:	e8 09 07 00 00       	call   801ab3 <_panic>
	return NULL;
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	68 8c 24 80 00       	push   $0x80248c
  8013ba:	6a 43                	push   $0x43
  8013bc:	68 31 24 80 00       	push   $0x802431
  8013c1:	e8 ed 06 00 00       	call   801ab3 <_panic>

008013c6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	68 b0 24 80 00       	push   $0x8024b0
  8013d4:	6a 5b                	push   $0x5b
  8013d6:	68 31 24 80 00       	push   $0x802431
  8013db:	e8 d3 06 00 00       	call   801ab3 <_panic>

008013e0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	68 d4 24 80 00       	push   $0x8024d4
  8013ee:	6a 72                	push   $0x72
  8013f0:	68 31 24 80 00       	push   $0x802431
  8013f5:	e8 b9 06 00 00       	call   801ab3 <_panic>

008013fa <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	68 fa 24 80 00       	push   $0x8024fa
  801408:	6a 7e                	push   $0x7e
  80140a:	68 31 24 80 00       	push   $0x802431
  80140f:	e8 9f 06 00 00       	call   801ab3 <_panic>

00801414 <shrink>:

}
void shrink(uint32 newSize)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	68 fa 24 80 00       	push   $0x8024fa
  801422:	68 83 00 00 00       	push   $0x83
  801427:	68 31 24 80 00       	push   $0x802431
  80142c:	e8 82 06 00 00       	call   801ab3 <_panic>

00801431 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	68 fa 24 80 00       	push   $0x8024fa
  80143f:	68 88 00 00 00       	push   $0x88
  801444:	68 31 24 80 00       	push   $0x802431
  801449:	e8 65 06 00 00       	call   801ab3 <_panic>

0080144e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	57                   	push   %edi
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801460:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801463:	8b 7d 18             	mov    0x18(%ebp),%edi
  801466:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801469:	cd 30                	int    $0x30
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80146e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	5b                   	pop    %ebx
  801475:	5e                   	pop    %esi
  801476:	5f                   	pop    %edi
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    

00801479 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801485:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	52                   	push   %edx
  801491:	ff 75 0c             	pushl  0xc(%ebp)
  801494:	50                   	push   %eax
  801495:	6a 00                	push   $0x0
  801497:	e8 b2 ff ff ff       	call   80144e <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
}
  80149f:	90                   	nop
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 02                	push   $0x2
  8014b1:	e8 98 ff ff ff       	call   80144e <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 03                	push   $0x3
  8014ca:	e8 7f ff ff ff       	call   80144e <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 04                	push   $0x4
  8014e4:	e8 65 ff ff ff       	call   80144e <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	52                   	push   %edx
  8014ff:	50                   	push   %eax
  801500:	6a 08                	push   $0x8
  801502:	e8 47 ff ff ff       	call   80144e <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	56                   	push   %esi
  801510:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801511:	8b 75 18             	mov    0x18(%ebp),%esi
  801514:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801517:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	56                   	push   %esi
  801521:	53                   	push   %ebx
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	6a 09                	push   $0x9
  801527:	e8 22 ff ff ff       	call   80144e <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801532:	5b                   	pop    %ebx
  801533:	5e                   	pop    %esi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	52                   	push   %edx
  801546:	50                   	push   %eax
  801547:	6a 0a                	push   $0xa
  801549:	e8 00 ff ff ff       	call   80144e <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	6a 0b                	push   $0xb
  801564:	e8 e5 fe ff ff       	call   80144e <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 0c                	push   $0xc
  80157d:	e8 cc fe ff ff       	call   80144e <syscall>
  801582:	83 c4 18             	add    $0x18,%esp
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 0d                	push   $0xd
  801596:	e8 b3 fe ff ff       	call   80144e <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 0e                	push   $0xe
  8015af:	e8 9a fe ff ff       	call   80144e <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 0f                	push   $0xf
  8015c8:	e8 81 fe ff ff       	call   80144e <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	6a 10                	push   $0x10
  8015e2:	e8 67 fe ff ff       	call   80144e <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 11                	push   $0x11
  8015fb:	e8 4e fe ff ff       	call   80144e <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
}
  801603:	90                   	nop
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <sys_cputc>:

void
sys_cputc(const char c)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801612:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	50                   	push   %eax
  80161f:	6a 01                	push   $0x1
  801621:	e8 28 fe ff ff       	call   80144e <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 14                	push   $0x14
  80163b:	e8 0e fe ff ff       	call   80144e <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	8b 45 10             	mov    0x10(%ebp),%eax
  80164f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801652:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801655:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	6a 00                	push   $0x0
  80165e:	51                   	push   %ecx
  80165f:	52                   	push   %edx
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	6a 15                	push   $0x15
  801666:	e8 e3 fd ff ff       	call   80144e <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	52                   	push   %edx
  801680:	50                   	push   %eax
  801681:	6a 16                	push   $0x16
  801683:	e8 c6 fd ff ff       	call   80144e <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801690:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801693:	8b 55 0c             	mov    0xc(%ebp),%edx
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	51                   	push   %ecx
  80169e:	52                   	push   %edx
  80169f:	50                   	push   %eax
  8016a0:	6a 17                	push   $0x17
  8016a2:	e8 a7 fd ff ff       	call   80144e <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 18                	push   $0x18
  8016bf:	e8 8a fd ff ff       	call   80144e <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 14             	pushl  0x14(%ebp)
  8016d4:	ff 75 10             	pushl  0x10(%ebp)
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	50                   	push   %eax
  8016db:	6a 19                	push   $0x19
  8016dd:	e8 6c fd ff ff       	call   80144e <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	50                   	push   %eax
  8016f6:	6a 1a                	push   $0x1a
  8016f8:	e8 51 fd ff ff       	call   80144e <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	50                   	push   %eax
  801712:	6a 1b                	push   $0x1b
  801714:	e8 35 fd ff ff       	call   80144e <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 05                	push   $0x5
  80172d:	e8 1c fd ff ff       	call   80144e <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 06                	push   $0x6
  801746:	e8 03 fd ff ff       	call   80144e <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 07                	push   $0x7
  80175f:	e8 ea fc ff ff       	call   80144e <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_exit_env>:


void sys_exit_env(void)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 1c                	push   $0x1c
  801778:	e8 d1 fc ff ff       	call   80144e <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801789:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80178c:	8d 50 04             	lea    0x4(%eax),%edx
  80178f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	52                   	push   %edx
  801799:	50                   	push   %eax
  80179a:	6a 1d                	push   $0x1d
  80179c:	e8 ad fc ff ff       	call   80144e <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
	return result;
  8017a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ad:	89 01                	mov    %eax,(%ecx)
  8017af:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	c9                   	leave  
  8017b6:	c2 04 00             	ret    $0x4

008017b9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 10             	pushl  0x10(%ebp)
  8017c3:	ff 75 0c             	pushl  0xc(%ebp)
  8017c6:	ff 75 08             	pushl  0x8(%ebp)
  8017c9:	6a 13                	push   $0x13
  8017cb:	e8 7e fc ff ff       	call   80144e <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d3:	90                   	nop
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 1e                	push   $0x1e
  8017e5:	e8 64 fc ff ff       	call   80144e <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017fb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	50                   	push   %eax
  801808:	6a 1f                	push   $0x1f
  80180a:	e8 3f fc ff ff       	call   80144e <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <rsttst>:
void rsttst()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 21                	push   $0x21
  801824:	e8 25 fc ff ff       	call   80144e <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
	return ;
  80182c:	90                   	nop
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	8b 45 14             	mov    0x14(%ebp),%eax
  801838:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80183b:	8b 55 18             	mov    0x18(%ebp),%edx
  80183e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 20                	push   $0x20
  80184f:	e8 fa fb ff ff       	call   80144e <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return ;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <chktst>:
void chktst(uint32 n)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 22                	push   $0x22
  80186a:	e8 df fb ff ff       	call   80144e <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return ;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <inctst>:

void inctst()
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 23                	push   $0x23
  801884:	e8 c5 fb ff ff       	call   80144e <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
	return ;
  80188c:	90                   	nop
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <gettst>:
uint32 gettst()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 24                	push   $0x24
  80189e:	e8 ab fb ff ff       	call   80144e <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 25                	push   $0x25
  8018ba:	e8 8f fb ff ff       	call   80144e <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
  8018c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018c5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018c9:	75 07                	jne    8018d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d0:	eb 05                	jmp    8018d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 25                	push   $0x25
  8018eb:	e8 5e fb ff ff       	call   80144e <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018f6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018fa:	75 07                	jne    801903 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801901:	eb 05                	jmp    801908 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 25                	push   $0x25
  80191c:	e8 2d fb ff ff       	call   80144e <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
  801924:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801927:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80192b:	75 07                	jne    801934 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80192d:	b8 01 00 00 00       	mov    $0x1,%eax
  801932:	eb 05                	jmp    801939 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801934:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 25                	push   $0x25
  80194d:	e8 fc fa ff ff       	call   80144e <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
  801955:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801958:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80195c:	75 07                	jne    801965 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80195e:	b8 01 00 00 00       	mov    $0x1,%eax
  801963:	eb 05                	jmp    80196a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 26                	push   $0x26
  80197c:	e8 cd fa ff ff       	call   80144e <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return ;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80198b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801991:	8b 55 0c             	mov    0xc(%ebp),%edx
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	6a 00                	push   $0x0
  801999:	53                   	push   %ebx
  80199a:	51                   	push   %ecx
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 27                	push   $0x27
  80199f:	e8 aa fa ff ff       	call   80144e <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	52                   	push   %edx
  8019bc:	50                   	push   %eax
  8019bd:	6a 28                	push   $0x28
  8019bf:	e8 8a fa ff ff       	call   80144e <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	51                   	push   %ecx
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 29                	push   $0x29
  8019df:	e8 6a fa ff ff       	call   80144e <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 10             	pushl  0x10(%ebp)
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 12                	push   $0x12
  8019fb:	e8 4e fa ff ff       	call   80144e <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
	return ;
  801a03:	90                   	nop
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	52                   	push   %edx
  801a16:	50                   	push   %eax
  801a17:	6a 2a                	push   $0x2a
  801a19:	e8 30 fa ff ff       	call   80144e <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	50                   	push   %eax
  801a33:	6a 2b                	push   $0x2b
  801a35:	e8 14 fa ff ff       	call   80144e <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	6a 2c                	push   $0x2c
  801a50:	e8 f9 f9 ff ff       	call   80144e <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
	return;
  801a58:	90                   	nop
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	ff 75 08             	pushl  0x8(%ebp)
  801a6a:	6a 2d                	push   $0x2d
  801a6c:	e8 dd f9 ff ff       	call   80144e <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
	return;
  801a74:	90                   	nop
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a83:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	50                   	push   %eax
  801a8b:	e8 76 fb ff ff       	call   801606 <sys_cputc>
  801a90:	83 c4 10             	add    $0x10,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <getchar>:


int
getchar(void)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a9c:	e8 01 fa ff ff       	call   8014a2 <sys_cgetc>
  801aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <iscons>:

int iscons(int fdnum)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801aac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ab9:	8d 45 10             	lea    0x10(%ebp),%eax
  801abc:	83 c0 04             	add    $0x4,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801ac2:	a1 24 30 80 00       	mov    0x803024,%eax
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	74 16                	je     801ae1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801acb:	a1 24 30 80 00       	mov    0x803024,%eax
  801ad0:	83 ec 08             	sub    $0x8,%esp
  801ad3:	50                   	push   %eax
  801ad4:	68 0c 25 80 00       	push   $0x80250c
  801ad9:	e8 a4 e8 ff ff       	call   800382 <cprintf>
  801ade:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801ae1:	a1 00 30 80 00       	mov    0x803000,%eax
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	50                   	push   %eax
  801aed:	68 11 25 80 00       	push   $0x802511
  801af2:	e8 8b e8 ff ff       	call   800382 <cprintf>
  801af7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	50                   	push   %eax
  801b04:	e8 0e e8 ff ff       	call   800317 <vcprintf>
  801b09:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b0c:	83 ec 08             	sub    $0x8,%esp
  801b0f:	6a 00                	push   $0x0
  801b11:	68 2d 25 80 00       	push   $0x80252d
  801b16:	e8 fc e7 ff ff       	call   800317 <vcprintf>
  801b1b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b1e:	e8 7d e7 ff ff       	call   8002a0 <exit>

	// should not return here
	while (1) ;
  801b23:	eb fe                	jmp    801b23 <_panic+0x70>

00801b25 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b2b:	a1 04 30 80 00       	mov    0x803004,%eax
  801b30:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	39 c2                	cmp    %eax,%edx
  801b3b:	74 14                	je     801b51 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b3d:	83 ec 04             	sub    $0x4,%esp
  801b40:	68 30 25 80 00       	push   $0x802530
  801b45:	6a 26                	push   $0x26
  801b47:	68 7c 25 80 00       	push   $0x80257c
  801b4c:	e8 62 ff ff ff       	call   801ab3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b5f:	e9 c5 00 00 00       	jmp    801c29 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	01 d0                	add    %edx,%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	85 c0                	test   %eax,%eax
  801b77:	75 08                	jne    801b81 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b79:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b7c:	e9 a5 00 00 00       	jmp    801c26 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b8f:	eb 69                	jmp    801bfa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b91:	a1 04 30 80 00       	mov    0x803004,%eax
  801b96:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	01 c0                	add    %eax,%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	c1 e0 03             	shl    $0x3,%eax
  801ba8:	01 c8                	add    %ecx,%eax
  801baa:	8a 40 04             	mov    0x4(%eax),%al
  801bad:	84 c0                	test   %al,%al
  801baf:	75 46                	jne    801bf7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bb1:	a1 04 30 80 00       	mov    0x803004,%eax
  801bb6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801bbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	01 c0                	add    %eax,%eax
  801bc3:	01 d0                	add    %edx,%eax
  801bc5:	c1 e0 03             	shl    $0x3,%eax
  801bc8:	01 c8                	add    %ecx,%eax
  801bca:	8b 00                	mov    (%eax),%eax
  801bcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	01 c8                	add    %ecx,%eax
  801be8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bea:	39 c2                	cmp    %eax,%edx
  801bec:	75 09                	jne    801bf7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801bee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bf5:	eb 15                	jmp    801c0c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bf7:	ff 45 e8             	incl   -0x18(%ebp)
  801bfa:	a1 04 30 80 00       	mov    0x803004,%eax
  801bff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c08:	39 c2                	cmp    %eax,%edx
  801c0a:	77 85                	ja     801b91 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c10:	75 14                	jne    801c26 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c12:	83 ec 04             	sub    $0x4,%esp
  801c15:	68 88 25 80 00       	push   $0x802588
  801c1a:	6a 3a                	push   $0x3a
  801c1c:	68 7c 25 80 00       	push   $0x80257c
  801c21:	e8 8d fe ff ff       	call   801ab3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c26:	ff 45 f0             	incl   -0x10(%ebp)
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c2f:	0f 8c 2f ff ff ff    	jl     801b64 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c43:	eb 26                	jmp    801c6b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c45:	a1 04 30 80 00       	mov    0x803004,%eax
  801c4a:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801c50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 03             	shl    $0x3,%eax
  801c5c:	01 c8                	add    %ecx,%eax
  801c5e:	8a 40 04             	mov    0x4(%eax),%al
  801c61:	3c 01                	cmp    $0x1,%al
  801c63:	75 03                	jne    801c68 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c65:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c68:	ff 45 e0             	incl   -0x20(%ebp)
  801c6b:	a1 04 30 80 00       	mov    0x803004,%eax
  801c70:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c79:	39 c2                	cmp    %eax,%edx
  801c7b:	77 c8                	ja     801c45 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c83:	74 14                	je     801c99 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c85:	83 ec 04             	sub    $0x4,%esp
  801c88:	68 dc 25 80 00       	push   $0x8025dc
  801c8d:	6a 44                	push   $0x44
  801c8f:	68 7c 25 80 00       	push   $0x80257c
  801c94:	e8 1a fe ff ff       	call   801ab3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c99:	90                   	nop
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <__udivdi3>:
  801c9c:	55                   	push   %ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
  801ca3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ca7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801caf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cb3:	89 ca                	mov    %ecx,%edx
  801cb5:	89 f8                	mov    %edi,%eax
  801cb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cbb:	85 f6                	test   %esi,%esi
  801cbd:	75 2d                	jne    801cec <__udivdi3+0x50>
  801cbf:	39 cf                	cmp    %ecx,%edi
  801cc1:	77 65                	ja     801d28 <__udivdi3+0x8c>
  801cc3:	89 fd                	mov    %edi,%ebp
  801cc5:	85 ff                	test   %edi,%edi
  801cc7:	75 0b                	jne    801cd4 <__udivdi3+0x38>
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	31 d2                	xor    %edx,%edx
  801cd0:	f7 f7                	div    %edi
  801cd2:	89 c5                	mov    %eax,%ebp
  801cd4:	31 d2                	xor    %edx,%edx
  801cd6:	89 c8                	mov    %ecx,%eax
  801cd8:	f7 f5                	div    %ebp
  801cda:	89 c1                	mov    %eax,%ecx
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	f7 f5                	div    %ebp
  801ce0:	89 cf                	mov    %ecx,%edi
  801ce2:	89 fa                	mov    %edi,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 ce                	cmp    %ecx,%esi
  801cee:	77 28                	ja     801d18 <__udivdi3+0x7c>
  801cf0:	0f bd fe             	bsr    %esi,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 40                	jne    801d38 <__udivdi3+0x9c>
  801cf8:	39 ce                	cmp    %ecx,%esi
  801cfa:	72 0a                	jb     801d06 <__udivdi3+0x6a>
  801cfc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d00:	0f 87 9e 00 00 00    	ja     801da4 <__udivdi3+0x108>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	89 fa                	mov    %edi,%edx
  801d0d:	83 c4 1c             	add    $0x1c,%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5f                   	pop    %edi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
  801d15:	8d 76 00             	lea    0x0(%esi),%esi
  801d18:	31 ff                	xor    %edi,%edi
  801d1a:	31 c0                	xor    %eax,%eax
  801d1c:	89 fa                	mov    %edi,%edx
  801d1e:	83 c4 1c             	add    $0x1c,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
  801d26:	66 90                	xchg   %ax,%ax
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	f7 f7                	div    %edi
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	89 fa                	mov    %edi,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d3d:	89 eb                	mov    %ebp,%ebx
  801d3f:	29 fb                	sub    %edi,%ebx
  801d41:	89 f9                	mov    %edi,%ecx
  801d43:	d3 e6                	shl    %cl,%esi
  801d45:	89 c5                	mov    %eax,%ebp
  801d47:	88 d9                	mov    %bl,%cl
  801d49:	d3 ed                	shr    %cl,%ebp
  801d4b:	89 e9                	mov    %ebp,%ecx
  801d4d:	09 f1                	or     %esi,%ecx
  801d4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	d3 e0                	shl    %cl,%eax
  801d57:	89 c5                	mov    %eax,%ebp
  801d59:	89 d6                	mov    %edx,%esi
  801d5b:	88 d9                	mov    %bl,%cl
  801d5d:	d3 ee                	shr    %cl,%esi
  801d5f:	89 f9                	mov    %edi,%ecx
  801d61:	d3 e2                	shl    %cl,%edx
  801d63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d67:	88 d9                	mov    %bl,%cl
  801d69:	d3 e8                	shr    %cl,%eax
  801d6b:	09 c2                	or     %eax,%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	89 f2                	mov    %esi,%edx
  801d71:	f7 74 24 0c          	divl   0xc(%esp)
  801d75:	89 d6                	mov    %edx,%esi
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	f7 e5                	mul    %ebp
  801d7b:	39 d6                	cmp    %edx,%esi
  801d7d:	72 19                	jb     801d98 <__udivdi3+0xfc>
  801d7f:	74 0b                	je     801d8c <__udivdi3+0xf0>
  801d81:	89 d8                	mov    %ebx,%eax
  801d83:	31 ff                	xor    %edi,%edi
  801d85:	e9 58 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d90:	89 f9                	mov    %edi,%ecx
  801d92:	d3 e2                	shl    %cl,%edx
  801d94:	39 c2                	cmp    %eax,%edx
  801d96:	73 e9                	jae    801d81 <__udivdi3+0xe5>
  801d98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d9b:	31 ff                	xor    %edi,%edi
  801d9d:	e9 40 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	31 c0                	xor    %eax,%eax
  801da6:	e9 37 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801dab:	90                   	nop

00801dac <__umoddi3>:
  801dac:	55                   	push   %ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
  801db3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801db7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dcb:	89 f3                	mov    %esi,%ebx
  801dcd:	89 fa                	mov    %edi,%edx
  801dcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd3:	89 34 24             	mov    %esi,(%esp)
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	75 1a                	jne    801df4 <__umoddi3+0x48>
  801dda:	39 f7                	cmp    %esi,%edi
  801ddc:	0f 86 a2 00 00 00    	jbe    801e84 <__umoddi3+0xd8>
  801de2:	89 c8                	mov    %ecx,%eax
  801de4:	89 f2                	mov    %esi,%edx
  801de6:	f7 f7                	div    %edi
  801de8:	89 d0                	mov    %edx,%eax
  801dea:	31 d2                	xor    %edx,%edx
  801dec:	83 c4 1c             	add    $0x1c,%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    
  801df4:	39 f0                	cmp    %esi,%eax
  801df6:	0f 87 ac 00 00 00    	ja     801ea8 <__umoddi3+0xfc>
  801dfc:	0f bd e8             	bsr    %eax,%ebp
  801dff:	83 f5 1f             	xor    $0x1f,%ebp
  801e02:	0f 84 ac 00 00 00    	je     801eb4 <__umoddi3+0x108>
  801e08:	bf 20 00 00 00       	mov    $0x20,%edi
  801e0d:	29 ef                	sub    %ebp,%edi
  801e0f:	89 fe                	mov    %edi,%esi
  801e11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e15:	89 e9                	mov    %ebp,%ecx
  801e17:	d3 e0                	shl    %cl,%eax
  801e19:	89 d7                	mov    %edx,%edi
  801e1b:	89 f1                	mov    %esi,%ecx
  801e1d:	d3 ef                	shr    %cl,%edi
  801e1f:	09 c7                	or     %eax,%edi
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e2                	shl    %cl,%edx
  801e25:	89 14 24             	mov    %edx,(%esp)
  801e28:	89 d8                	mov    %ebx,%eax
  801e2a:	d3 e0                	shl    %cl,%eax
  801e2c:	89 c2                	mov    %eax,%edx
  801e2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e32:	d3 e0                	shl    %cl,%eax
  801e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e3c:	89 f1                	mov    %esi,%ecx
  801e3e:	d3 e8                	shr    %cl,%eax
  801e40:	09 d0                	or     %edx,%eax
  801e42:	d3 eb                	shr    %cl,%ebx
  801e44:	89 da                	mov    %ebx,%edx
  801e46:	f7 f7                	div    %edi
  801e48:	89 d3                	mov    %edx,%ebx
  801e4a:	f7 24 24             	mull   (%esp)
  801e4d:	89 c6                	mov    %eax,%esi
  801e4f:	89 d1                	mov    %edx,%ecx
  801e51:	39 d3                	cmp    %edx,%ebx
  801e53:	0f 82 87 00 00 00    	jb     801ee0 <__umoddi3+0x134>
  801e59:	0f 84 91 00 00 00    	je     801ef0 <__umoddi3+0x144>
  801e5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e63:	29 f2                	sub    %esi,%edx
  801e65:	19 cb                	sbb    %ecx,%ebx
  801e67:	89 d8                	mov    %ebx,%eax
  801e69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e6d:	d3 e0                	shl    %cl,%eax
  801e6f:	89 e9                	mov    %ebp,%ecx
  801e71:	d3 ea                	shr    %cl,%edx
  801e73:	09 d0                	or     %edx,%eax
  801e75:	89 e9                	mov    %ebp,%ecx
  801e77:	d3 eb                	shr    %cl,%ebx
  801e79:	89 da                	mov    %ebx,%edx
  801e7b:	83 c4 1c             	add    $0x1c,%esp
  801e7e:	5b                   	pop    %ebx
  801e7f:	5e                   	pop    %esi
  801e80:	5f                   	pop    %edi
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    
  801e83:	90                   	nop
  801e84:	89 fd                	mov    %edi,%ebp
  801e86:	85 ff                	test   %edi,%edi
  801e88:	75 0b                	jne    801e95 <__umoddi3+0xe9>
  801e8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8f:	31 d2                	xor    %edx,%edx
  801e91:	f7 f7                	div    %edi
  801e93:	89 c5                	mov    %eax,%ebp
  801e95:	89 f0                	mov    %esi,%eax
  801e97:	31 d2                	xor    %edx,%edx
  801e99:	f7 f5                	div    %ebp
  801e9b:	89 c8                	mov    %ecx,%eax
  801e9d:	f7 f5                	div    %ebp
  801e9f:	89 d0                	mov    %edx,%eax
  801ea1:	e9 44 ff ff ff       	jmp    801dea <__umoddi3+0x3e>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	89 c8                	mov    %ecx,%eax
  801eaa:	89 f2                	mov    %esi,%edx
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    
  801eb4:	3b 04 24             	cmp    (%esp),%eax
  801eb7:	72 06                	jb     801ebf <__umoddi3+0x113>
  801eb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ebd:	77 0f                	ja     801ece <__umoddi3+0x122>
  801ebf:	89 f2                	mov    %esi,%edx
  801ec1:	29 f9                	sub    %edi,%ecx
  801ec3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ec7:	89 14 24             	mov    %edx,(%esp)
  801eca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ece:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed2:	8b 14 24             	mov    (%esp),%edx
  801ed5:	83 c4 1c             	add    $0x1c,%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	2b 04 24             	sub    (%esp),%eax
  801ee3:	19 fa                	sbb    %edi,%edx
  801ee5:	89 d1                	mov    %edx,%ecx
  801ee7:	89 c6                	mov    %eax,%esi
  801ee9:	e9 71 ff ff ff       	jmp    801e5f <__umoddi3+0xb3>
  801eee:	66 90                	xchg   %ax,%ax
  801ef0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ef4:	72 ea                	jb     801ee0 <__umoddi3+0x134>
  801ef6:	89 d9                	mov    %ebx,%ecx
  801ef8:	e9 62 ff ff ff       	jmp    801e5f <__umoddi3+0xb3>
