
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
  800052:	68 a0 3d 80 00       	push   $0x803da0
  800057:	e8 c1 0a 00 00       	call   800b1d <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 14 0f 00 00       	call   800f86 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 ba 12 00 00       	call   801342 <malloc>
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
  8000ab:	e8 b1 14 00 00       	call   801561 <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 be 3d 80 00       	push   $0x803dbe
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 a7 1b 00 00       	call   801c75 <inctst>
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
  80017d:	e8 b5 19 00 00       	call   801b37 <sys_getenvindex>
  800182:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800188:	89 d0                	mov    %edx,%eax
  80018a:	c1 e0 03             	shl    $0x3,%eax
  80018d:	01 d0                	add    %edx,%eax
  80018f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800196:	01 c8                	add    %ecx,%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	01 d0                	add    %edx,%eax
  80019c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001a3:	01 c8                	add    %ecx,%eax
  8001a5:	01 d0                	add    %edx,%eax
  8001a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b6:	8a 40 20             	mov    0x20(%eax),%al
  8001b9:	84 c0                	test   %al,%al
  8001bb:	74 0d                	je     8001ca <libmain+0x53>
		binaryname = myEnv->prog_name;
  8001bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c2:	83 c0 20             	add    $0x20,%eax
  8001c5:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x63>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001eb:	e8 cb 16 00 00       	call   8018bb <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 ec 3d 80 00       	push   $0x803dec
  8001f8:	e8 8d 01 00 00       	call   80038a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 50 80 00       	mov    0x805020,%eax
  800205:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80020b:	a1 20 50 80 00       	mov    0x805020,%eax
  800210:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 14 3e 80 00       	push   $0x803e14
  800220:	e8 65 01 00 00       	call   80038a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 50 80 00       	mov    0x805020,%eax
  80022d:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800233:	a1 20 50 80 00       	mov    0x805020,%eax
  800238:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80023e:	a1 20 50 80 00       	mov    0x805020,%eax
  800243:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 3c 3e 80 00       	push   $0x803e3c
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 94 3e 80 00       	push   $0x803e94
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 ec 3d 80 00       	push   $0x803dec
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 4b 16 00 00       	call   8018d5 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 61 18 00 00       	call   801b03 <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 b6 18 00 00       	call   801b69 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bf:	8b 00                	mov    (%eax),%eax
  8002c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8002c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c7:	89 0a                	mov    %ecx,(%edx)
  8002c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cc:	88 d1                	mov    %dl,%cl
  8002ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d8:	8b 00                	mov    (%eax),%eax
  8002da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002df:	75 2c                	jne    80030d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002e1:	a0 28 50 80 00       	mov    0x805028,%al
  8002e6:	0f b6 c0             	movzbl %al,%eax
  8002e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ec:	8b 12                	mov    (%edx),%edx
  8002ee:	89 d1                	mov    %edx,%ecx
  8002f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f3:	83 c2 08             	add    $0x8,%edx
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	50                   	push   %eax
  8002fa:	51                   	push   %ecx
  8002fb:	52                   	push   %edx
  8002fc:	e8 78 15 00 00       	call   801879 <sys_cputs>
  800301:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	8b 40 04             	mov    0x4(%eax),%eax
  800313:	8d 50 01             	lea    0x1(%eax),%edx
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	89 50 04             	mov    %edx,0x4(%eax)
}
  80031c:	90                   	nop
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800328:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032f:	00 00 00 
	b.cnt = 0;
  800332:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800339:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800348:	50                   	push   %eax
  800349:	68 b6 02 80 00       	push   $0x8002b6
  80034e:	e8 11 02 00 00       	call   800564 <vprintfmt>
  800353:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800356:	a0 28 50 80 00       	mov    0x805028,%al
  80035b:	0f b6 c0             	movzbl %al,%eax
  80035e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	50                   	push   %eax
  800368:	52                   	push   %edx
  800369:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036f:	83 c0 08             	add    $0x8,%eax
  800372:	50                   	push   %eax
  800373:	e8 01 15 00 00       	call   801879 <sys_cputs>
  800378:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80037b:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800382:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800390:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800397:	8d 45 0c             	lea    0xc(%ebp),%eax
  80039a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a6:	50                   	push   %eax
  8003a7:	e8 73 ff ff ff       	call   80031f <vcprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003bd:	e8 f9 14 00 00       	call   8018bb <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d1:	50                   	push   %eax
  8003d2:	e8 48 ff ff ff       	call   80031f <vcprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
  8003da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003dd:	e8 f3 14 00 00       	call   8018d5 <sys_unlock_cons>
	return cnt;
  8003e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	53                   	push   %ebx
  8003eb:	83 ec 14             	sub    $0x14,%esp
  8003ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8003fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800402:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800405:	77 55                	ja     80045c <printnum+0x75>
  800407:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80040a:	72 05                	jb     800411 <printnum+0x2a>
  80040c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80040f:	77 4b                	ja     80045c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800411:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800414:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800417:	8b 45 18             	mov    0x18(%ebp),%eax
  80041a:	ba 00 00 00 00       	mov    $0x0,%edx
  80041f:	52                   	push   %edx
  800420:	50                   	push   %eax
  800421:	ff 75 f4             	pushl  -0xc(%ebp)
  800424:	ff 75 f0             	pushl  -0x10(%ebp)
  800427:	e8 0c 37 00 00       	call   803b38 <__udivdi3>
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	83 ec 04             	sub    $0x4,%esp
  800432:	ff 75 20             	pushl  0x20(%ebp)
  800435:	53                   	push   %ebx
  800436:	ff 75 18             	pushl  0x18(%ebp)
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	e8 a1 ff ff ff       	call   8003e7 <printnum>
  800446:	83 c4 20             	add    $0x20,%esp
  800449:	eb 1a                	jmp    800465 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	ff 75 20             	pushl  0x20(%ebp)
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	ff d0                	call   *%eax
  800459:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045c:	ff 4d 1c             	decl   0x1c(%ebp)
  80045f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800463:	7f e6                	jg     80044b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800465:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800468:	bb 00 00 00 00       	mov    $0x0,%ebx
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800470:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800473:	53                   	push   %ebx
  800474:	51                   	push   %ecx
  800475:	52                   	push   %edx
  800476:	50                   	push   %eax
  800477:	e8 cc 37 00 00       	call   803c48 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 d4 40 80 00       	add    $0x8040d4,%eax
  800484:	8a 00                	mov    (%eax),%al
  800486:	0f be c0             	movsbl %al,%eax
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	50                   	push   %eax
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	ff d0                	call   *%eax
  800495:	83 c4 10             	add    $0x10,%esp
}
  800498:	90                   	nop
  800499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a5:	7e 1c                	jle    8004c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 08             	lea    0x8(%eax),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	83 e8 08             	sub    $0x8,%eax
  8004bc:	8b 50 04             	mov    0x4(%eax),%edx
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	eb 40                	jmp    800503 <getuint+0x65>
	else if (lflag)
  8004c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c7:	74 1e                	je     8004e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 50 04             	lea    0x4(%eax),%edx
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	89 10                	mov    %edx,(%eax)
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	83 e8 04             	sub    $0x4,%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	eb 1c                	jmp    800503 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	8d 50 04             	lea    0x4(%eax),%edx
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	89 10                	mov    %edx,(%eax)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	83 e8 04             	sub    $0x4,%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800503:	5d                   	pop    %ebp
  800504:	c3                   	ret    

00800505 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800508:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80050c:	7e 1c                	jle    80052a <getint+0x25>
		return va_arg(*ap, long long);
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	8d 50 08             	lea    0x8(%eax),%edx
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	89 10                	mov    %edx,(%eax)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	83 e8 08             	sub    $0x8,%eax
  800523:	8b 50 04             	mov    0x4(%eax),%edx
  800526:	8b 00                	mov    (%eax),%eax
  800528:	eb 38                	jmp    800562 <getint+0x5d>
	else if (lflag)
  80052a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80052e:	74 1a                	je     80054a <getint+0x45>
		return va_arg(*ap, long);
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 50 04             	lea    0x4(%eax),%edx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	89 10                	mov    %edx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 e8 04             	sub    $0x4,%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	99                   	cltd   
  800548:	eb 18                	jmp    800562 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	8d 50 04             	lea    0x4(%eax),%edx
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	89 10                	mov    %edx,(%eax)
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	83 e8 04             	sub    $0x4,%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	99                   	cltd   
}
  800562:	5d                   	pop    %ebp
  800563:	c3                   	ret    

00800564 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	56                   	push   %esi
  800568:	53                   	push   %ebx
  800569:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80056c:	eb 17                	jmp    800585 <vprintfmt+0x21>
			if (ch == '\0')
  80056e:	85 db                	test   %ebx,%ebx
  800570:	0f 84 c1 03 00 00    	je     800937 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 0c             	pushl  0xc(%ebp)
  80057c:	53                   	push   %ebx
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	ff d0                	call   *%eax
  800582:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800585:	8b 45 10             	mov    0x10(%ebp),%eax
  800588:	8d 50 01             	lea    0x1(%eax),%edx
  80058b:	89 55 10             	mov    %edx,0x10(%ebp)
  80058e:	8a 00                	mov    (%eax),%al
  800590:	0f b6 d8             	movzbl %al,%ebx
  800593:	83 fb 25             	cmp    $0x25,%ebx
  800596:	75 d6                	jne    80056e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800598:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80059c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c1:	8a 00                	mov    (%eax),%al
  8005c3:	0f b6 d8             	movzbl %al,%ebx
  8005c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c9:	83 f8 5b             	cmp    $0x5b,%eax
  8005cc:	0f 87 3d 03 00 00    	ja     80090f <vprintfmt+0x3ab>
  8005d2:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  8005d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005df:	eb d7                	jmp    8005b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005e5:	eb d1                	jmp    8005b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f1:	89 d0                	mov    %edx,%eax
  8005f3:	c1 e0 02             	shl    $0x2,%eax
  8005f6:	01 d0                	add    %edx,%eax
  8005f8:	01 c0                	add    %eax,%eax
  8005fa:	01 d8                	add    %ebx,%eax
  8005fc:	83 e8 30             	sub    $0x30,%eax
  8005ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800602:	8b 45 10             	mov    0x10(%ebp),%eax
  800605:	8a 00                	mov    (%eax),%al
  800607:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80060a:	83 fb 2f             	cmp    $0x2f,%ebx
  80060d:	7e 3e                	jle    80064d <vprintfmt+0xe9>
  80060f:	83 fb 39             	cmp    $0x39,%ebx
  800612:	7f 39                	jg     80064d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800614:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800617:	eb d5                	jmp    8005ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	83 c0 04             	add    $0x4,%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 e8 04             	sub    $0x4,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80062d:	eb 1f                	jmp    80064e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80062f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800633:	79 83                	jns    8005b8 <vprintfmt+0x54>
				width = 0;
  800635:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80063c:	e9 77 ff ff ff       	jmp    8005b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800641:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800648:	e9 6b ff ff ff       	jmp    8005b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80064d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80064e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800652:	0f 89 60 ff ff ff    	jns    8005b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800665:	e9 4e ff ff ff       	jmp    8005b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80066a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80066d:	e9 46 ff ff ff       	jmp    8005b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	83 c0 04             	add    $0x4,%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	50                   	push   %eax
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	ff d0                	call   *%eax
  80068f:	83 c4 10             	add    $0x10,%esp
			break;
  800692:	e9 9b 02 00 00       	jmp    800932 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	83 c0 04             	add    $0x4,%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	83 e8 04             	sub    $0x4,%eax
  8006a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a8:	85 db                	test   %ebx,%ebx
  8006aa:	79 02                	jns    8006ae <vprintfmt+0x14a>
				err = -err;
  8006ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ae:	83 fb 64             	cmp    $0x64,%ebx
  8006b1:	7f 0b                	jg     8006be <vprintfmt+0x15a>
  8006b3:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 e5 40 80 00       	push   $0x8040e5
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	ff 75 08             	pushl  0x8(%ebp)
  8006ca:	e8 70 02 00 00       	call   80093f <printfmt>
  8006cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d2:	e9 5b 02 00 00       	jmp    800932 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d7:	56                   	push   %esi
  8006d8:	68 ee 40 80 00       	push   $0x8040ee
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 08             	pushl  0x8(%ebp)
  8006e3:	e8 57 02 00 00       	call   80093f <printfmt>
  8006e8:	83 c4 10             	add    $0x10,%esp
			break;
  8006eb:	e9 42 02 00 00       	jmp    800932 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	83 c0 04             	add    $0x4,%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 30                	mov    (%eax),%esi
  800701:	85 f6                	test   %esi,%esi
  800703:	75 05                	jne    80070a <vprintfmt+0x1a6>
				p = "(null)";
  800705:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  80070a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070e:	7e 6d                	jle    80077d <vprintfmt+0x219>
  800710:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800714:	74 67                	je     80077d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	50                   	push   %eax
  80071d:	56                   	push   %esi
  80071e:	e8 26 05 00 00       	call   800c49 <strnlen>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800729:	eb 16                	jmp    800741 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80072b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	50                   	push   %eax
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073e:	ff 4d e4             	decl   -0x1c(%ebp)
  800741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800745:	7f e4                	jg     80072b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800747:	eb 34                	jmp    80077d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800749:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074d:	74 1c                	je     80076b <vprintfmt+0x207>
  80074f:	83 fb 1f             	cmp    $0x1f,%ebx
  800752:	7e 05                	jle    800759 <vprintfmt+0x1f5>
  800754:	83 fb 7e             	cmp    $0x7e,%ebx
  800757:	7e 12                	jle    80076b <vprintfmt+0x207>
					putch('?', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	6a 3f                	push   $0x3f
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	ff d0                	call   *%eax
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	eb 0f                	jmp    80077a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	53                   	push   %ebx
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077a:	ff 4d e4             	decl   -0x1c(%ebp)
  80077d:	89 f0                	mov    %esi,%eax
  80077f:	8d 70 01             	lea    0x1(%eax),%esi
  800782:	8a 00                	mov    (%eax),%al
  800784:	0f be d8             	movsbl %al,%ebx
  800787:	85 db                	test   %ebx,%ebx
  800789:	74 24                	je     8007af <vprintfmt+0x24b>
  80078b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078f:	78 b8                	js     800749 <vprintfmt+0x1e5>
  800791:	ff 4d e0             	decl   -0x20(%ebp)
  800794:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800798:	79 af                	jns    800749 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079a:	eb 13                	jmp    8007af <vprintfmt+0x24b>
				putch(' ', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 20                	push   $0x20
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8007af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b3:	7f e7                	jg     80079c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007b5:	e9 78 01 00 00       	jmp    800932 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c3:	50                   	push   %eax
  8007c4:	e8 3c fd ff ff       	call   800505 <getint>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d8:	85 d2                	test   %edx,%edx
  8007da:	79 23                	jns    8007ff <vprintfmt+0x29b>
				putch('-', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 2d                	push   $0x2d
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f2:	f7 d8                	neg    %eax
  8007f4:	83 d2 00             	adc    $0x0,%edx
  8007f7:	f7 da                	neg    %edx
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800806:	e9 bc 00 00 00       	jmp    8008c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 e8             	pushl  -0x18(%ebp)
  800811:	8d 45 14             	lea    0x14(%ebp),%eax
  800814:	50                   	push   %eax
  800815:	e8 84 fc ff ff       	call   80049e <getuint>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800820:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800823:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80082a:	e9 98 00 00 00       	jmp    8008c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	6a 58                	push   $0x58
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	6a 58                	push   $0x58
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	ff d0                	call   *%eax
  80084c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	6a 58                	push   $0x58
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
			break;
  80085f:	e9 ce 00 00 00       	jmp    800932 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	6a 30                	push   $0x30
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	6a 78                	push   $0x78
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	ff d0                	call   *%eax
  800881:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	83 e8 04             	sub    $0x4,%eax
  800893:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80089f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a6:	eb 1f                	jmp    8008c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b1:	50                   	push   %eax
  8008b2:	e8 e7 fb ff ff       	call   80049e <getuint>
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	52                   	push   %edx
  8008d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	ff 75 08             	pushl  0x8(%ebp)
  8008e2:	e8 00 fb ff ff       	call   8003e7 <printnum>
  8008e7:	83 c4 20             	add    $0x20,%esp
			break;
  8008ea:	eb 46                	jmp    800932 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	53                   	push   %ebx
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
			break;
  8008fb:	eb 35                	jmp    800932 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008fd:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800904:	eb 2c                	jmp    800932 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800906:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  80090d:	eb 23                	jmp    800932 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 25                	push   $0x25
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091f:	ff 4d 10             	decl   0x10(%ebp)
  800922:	eb 03                	jmp    800927 <vprintfmt+0x3c3>
  800924:	ff 4d 10             	decl   0x10(%ebp)
  800927:	8b 45 10             	mov    0x10(%ebp),%eax
  80092a:	48                   	dec    %eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	3c 25                	cmp    $0x25,%al
  80092f:	75 f3                	jne    800924 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800931:	90                   	nop
		}
	}
  800932:	e9 35 fc ff ff       	jmp    80056c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800937:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800938:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800945:	8d 45 10             	lea    0x10(%ebp),%eax
  800948:	83 c0 04             	add    $0x4,%eax
  80094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80094e:	8b 45 10             	mov    0x10(%ebp),%eax
  800951:	ff 75 f4             	pushl  -0xc(%ebp)
  800954:	50                   	push   %eax
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 04 fc ff ff       	call   800564 <vprintfmt>
  800960:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800963:	90                   	nop
  800964:	c9                   	leave  
  800965:	c3                   	ret    

00800966 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	8b 40 08             	mov    0x8(%eax),%eax
  80096f:	8d 50 01             	lea    0x1(%eax),%edx
  800972:	8b 45 0c             	mov    0xc(%ebp),%eax
  800975:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	8b 10                	mov    (%eax),%edx
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	8b 40 04             	mov    0x4(%eax),%eax
  800983:	39 c2                	cmp    %eax,%edx
  800985:	73 12                	jae    800999 <sprintputch+0x33>
		*b->buf++ = ch;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	8d 48 01             	lea    0x1(%eax),%ecx
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	89 0a                	mov    %ecx,(%edx)
  800994:	8b 55 08             	mov    0x8(%ebp),%edx
  800997:	88 10                	mov    %dl,(%eax)
}
  800999:	90                   	nop
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	01 d0                	add    %edx,%eax
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c1:	74 06                	je     8009c9 <vsnprintf+0x2d>
  8009c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c7:	7f 07                	jg     8009d0 <vsnprintf+0x34>
		return -E_INVAL;
  8009c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ce:	eb 20                	jmp    8009f0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d0:	ff 75 14             	pushl  0x14(%ebp)
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d9:	50                   	push   %eax
  8009da:	68 66 09 80 00       	push   $0x800966
  8009df:	e8 80 fb ff ff       	call   800564 <vprintfmt>
  8009e4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009fb:	83 c0 04             	add    $0x4,%eax
  8009fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a01:	8b 45 10             	mov    0x10(%ebp),%eax
  800a04:	ff 75 f4             	pushl  -0xc(%ebp)
  800a07:	50                   	push   %eax
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	ff 75 08             	pushl  0x8(%ebp)
  800a0e:	e8 89 ff ff ff       	call   80099c <vsnprintf>
  800a13:	83 c4 10             	add    $0x10,%esp
  800a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1c:	c9                   	leave  
  800a1d:	c3                   	ret    

00800a1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a28:	74 13                	je     800a3d <readline+0x1f>
		cprintf("%s", prompt);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 08             	pushl  0x8(%ebp)
  800a30:	68 68 42 80 00       	push   $0x804268
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 f4 2e 00 00       	call   803942 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 d6 2e 00 00       	call   80392f <getchar>
  800a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a60:	79 22                	jns    800a84 <readline+0x66>
			if (c != -E_EOF)
  800a62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a66:	0f 84 ad 00 00 00    	je     800b19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a72:	68 6b 42 80 00       	push   $0x80426b
  800a77:	e8 0e f9 ff ff       	call   80038a <cprintf>
  800a7c:	83 c4 10             	add    $0x10,%esp
			break;
  800a7f:	e9 95 00 00 00       	jmp    800b19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a88:	7e 34                	jle    800abe <readline+0xa0>
  800a8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a91:	7f 2b                	jg     800abe <readline+0xa0>
			if (echoing)
  800a93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a97:	74 0e                	je     800aa7 <readline+0x89>
				cputchar(c);
  800a99:	83 ec 0c             	sub    $0xc,%esp
  800a9c:	ff 75 ec             	pushl  -0x14(%ebp)
  800a9f:	e8 6c 2e 00 00       	call   803910 <cputchar>
  800aa4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aaa:	8d 50 01             	lea    0x1(%eax),%edx
  800aad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab5:	01 d0                	add    %edx,%eax
  800ab7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aba:	88 10                	mov    %dl,(%eax)
  800abc:	eb 56                	jmp    800b14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800abe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ac2:	75 1f                	jne    800ae3 <readline+0xc5>
  800ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ac8:	7e 19                	jle    800ae3 <readline+0xc5>
			if (echoing)
  800aca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ace:	74 0e                	je     800ade <readline+0xc0>
				cputchar(c);
  800ad0:	83 ec 0c             	sub    $0xc,%esp
  800ad3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad6:	e8 35 2e 00 00       	call   803910 <cputchar>
  800adb:	83 c4 10             	add    $0x10,%esp

			i--;
  800ade:	ff 4d f4             	decl   -0xc(%ebp)
  800ae1:	eb 31                	jmp    800b14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ae3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ae7:	74 0a                	je     800af3 <readline+0xd5>
  800ae9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800aed:	0f 85 61 ff ff ff    	jne    800a54 <readline+0x36>
			if (echoing)
  800af3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af7:	74 0e                	je     800b07 <readline+0xe9>
				cputchar(c);
  800af9:	83 ec 0c             	sub    $0xc,%esp
  800afc:	ff 75 ec             	pushl  -0x14(%ebp)
  800aff:	e8 0c 2e 00 00       	call   803910 <cputchar>
  800b04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	01 d0                	add    %edx,%eax
  800b0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b12:	eb 06                	jmp    800b1a <readline+0xfc>
		}
	}
  800b14:	e9 3b ff ff ff       	jmp    800a54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b1a:	90                   	nop
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    

00800b1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b23:	e8 93 0d 00 00       	call   8018bb <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 68 42 80 00       	push   $0x804268
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 f0 2d 00 00       	call   803942 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 d2 2d 00 00       	call   80392f <getchar>
  800b5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b64:	79 22                	jns    800b88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b6a:	0f 84 ad 00 00 00    	je     800c1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b70:	83 ec 08             	sub    $0x8,%esp
  800b73:	ff 75 ec             	pushl  -0x14(%ebp)
  800b76:	68 6b 42 80 00       	push   $0x80426b
  800b7b:	e8 0a f8 ff ff       	call   80038a <cprintf>
  800b80:	83 c4 10             	add    $0x10,%esp
				break;
  800b83:	e9 95 00 00 00       	jmp    800c1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b8c:	7e 34                	jle    800bc2 <atomic_readline+0xa5>
  800b8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b95:	7f 2b                	jg     800bc2 <atomic_readline+0xa5>
				if (echoing)
  800b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b9b:	74 0e                	je     800bab <atomic_readline+0x8e>
					cputchar(c);
  800b9d:	83 ec 0c             	sub    $0xc,%esp
  800ba0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ba3:	e8 68 2d 00 00       	call   803910 <cputchar>
  800ba8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bae:	8d 50 01             	lea    0x1(%eax),%edx
  800bb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bb4:	89 c2                	mov    %eax,%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	01 d0                	add    %edx,%eax
  800bbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bbe:	88 10                	mov    %dl,(%eax)
  800bc0:	eb 56                	jmp    800c18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bc6:	75 1f                	jne    800be7 <atomic_readline+0xca>
  800bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bcc:	7e 19                	jle    800be7 <atomic_readline+0xca>
				if (echoing)
  800bce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd2:	74 0e                	je     800be2 <atomic_readline+0xc5>
					cputchar(c);
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800bda:	e8 31 2d 00 00       	call   803910 <cputchar>
  800bdf:	83 c4 10             	add    $0x10,%esp
				i--;
  800be2:	ff 4d f4             	decl   -0xc(%ebp)
  800be5:	eb 31                	jmp    800c18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800be7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800beb:	74 0a                	je     800bf7 <atomic_readline+0xda>
  800bed:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bf1:	0f 85 61 ff ff ff    	jne    800b58 <atomic_readline+0x3b>
				if (echoing)
  800bf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bfb:	74 0e                	je     800c0b <atomic_readline+0xee>
					cputchar(c);
  800bfd:	83 ec 0c             	sub    $0xc,%esp
  800c00:	ff 75 ec             	pushl  -0x14(%ebp)
  800c03:	e8 08 2d 00 00       	call   803910 <cputchar>
  800c08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c16:	eb 06                	jmp    800c1e <atomic_readline+0x101>
			}
		}
  800c18:	e9 3b ff ff ff       	jmp    800b58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c1e:	e8 b2 0c 00 00       	call   8018d5 <sys_unlock_cons>
}
  800c23:	90                   	nop
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c33:	eb 06                	jmp    800c3b <strlen+0x15>
		n++;
  800c35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c38:	ff 45 08             	incl   0x8(%ebp)
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	84 c0                	test   %al,%al
  800c42:	75 f1                	jne    800c35 <strlen+0xf>
		n++;
	return n;
  800c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 09                	jmp    800c61 <strnlen+0x18>
		n++;
  800c58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5b:	ff 45 08             	incl   0x8(%ebp)
  800c5e:	ff 4d 0c             	decl   0xc(%ebp)
  800c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c65:	74 09                	je     800c70 <strnlen+0x27>
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	75 e8                	jne    800c58 <strnlen+0xf>
		n++;
	return n;
  800c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c81:	90                   	nop
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8d 50 01             	lea    0x1(%eax),%edx
  800c88:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c94:	8a 12                	mov    (%edx),%dl
  800c96:	88 10                	mov    %dl,(%eax)
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	75 e4                	jne    800c82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800caf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb6:	eb 1f                	jmp    800cd7 <strncpy+0x34>
		*dst++ = *src;
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8a 12                	mov    (%edx),%dl
  800cc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	74 03                	je     800cd4 <strncpy+0x31>
			src++;
  800cd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cd4:	ff 45 fc             	incl   -0x4(%ebp)
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cdd:	72 d9                	jb     800cb8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf4:	74 30                	je     800d26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cf6:	eb 16                	jmp    800d0e <strlcpy+0x2a>
			*dst++ = *src++;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0a:	8a 12                	mov    (%edx),%dl
  800d0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	74 09                	je     800d20 <strlcpy+0x3c>
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	84 c0                	test   %al,%al
  800d1e:	75 d8                	jne    800cf8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2c:	29 c2                	sub    %eax,%edx
  800d2e:	89 d0                	mov    %edx,%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d35:	eb 06                	jmp    800d3d <strcmp+0xb>
		p++, q++;
  800d37:	ff 45 08             	incl   0x8(%ebp)
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	74 0e                	je     800d54 <strcmp+0x22>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 10                	mov    (%eax),%dl
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	38 c2                	cmp    %al,%dl
  800d52:	74 e3                	je     800d37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f b6 d0             	movzbl %al,%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f b6 c0             	movzbl %al,%eax
  800d64:	29 c2                	sub    %eax,%edx
  800d66:	89 d0                	mov    %edx,%eax
}
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d6d:	eb 09                	jmp    800d78 <strncmp+0xe>
		n--, p++, q++;
  800d6f:	ff 4d 10             	decl   0x10(%ebp)
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7c:	74 17                	je     800d95 <strncmp+0x2b>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	84 c0                	test   %al,%al
  800d85:	74 0e                	je     800d95 <strncmp+0x2b>
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 10                	mov    (%eax),%dl
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	38 c2                	cmp    %al,%dl
  800d93:	74 da                	je     800d6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d99:	75 07                	jne    800da2 <strncmp+0x38>
		return 0;
  800d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800da0:	eb 14                	jmp    800db6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	0f b6 d0             	movzbl %al,%edx
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8a 00                	mov    (%eax),%al
  800daf:	0f b6 c0             	movzbl %al,%eax
  800db2:	29 c2                	sub    %eax,%edx
  800db4:	89 d0                	mov    %edx,%eax
}
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 04             	sub    $0x4,%esp
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc4:	eb 12                	jmp    800dd8 <strchr+0x20>
		if (*s == c)
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dce:	75 05                	jne    800dd5 <strchr+0x1d>
			return (char *) s;
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	eb 11                	jmp    800de6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dd5:	ff 45 08             	incl   0x8(%ebp)
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	84 c0                	test   %al,%al
  800ddf:	75 e5                	jne    800dc6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df4:	eb 0d                	jmp    800e03 <strfind+0x1b>
		if (*s == c)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dfe:	74 0e                	je     800e0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	84 c0                	test   %al,%al
  800e0a:	75 ea                	jne    800df6 <strfind+0xe>
  800e0c:	eb 01                	jmp    800e0f <strfind+0x27>
		if (*s == c)
			break;
  800e0e:	90                   	nop
	return (char *) s;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e26:	eb 0e                	jmp    800e36 <memset+0x22>
		*p++ = c;
  800e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e34:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e3d:	79 e9                	jns    800e28 <memset+0x14>
		*p++ = c;

	return v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e56:	eb 16                	jmp    800e6e <memcpy+0x2a>
		*d++ = *s++;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5b:	8d 50 01             	lea    0x1(%eax),%edx
  800e5e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e67:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6a:	8a 12                	mov    (%edx),%dl
  800e6c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e74:	89 55 10             	mov    %edx,0x10(%ebp)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	75 dd                	jne    800e58 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e95:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e98:	73 50                	jae    800eea <memmove+0x6a>
  800e9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea0:	01 d0                	add    %edx,%eax
  800ea2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea5:	76 43                	jbe    800eea <memmove+0x6a>
		s += n;
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb3:	eb 10                	jmp    800ec5 <memmove+0x45>
			*--d = *--s;
  800eb5:	ff 4d f8             	decl   -0x8(%ebp)
  800eb8:	ff 4d fc             	decl   -0x4(%ebp)
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebe:	8a 10                	mov    (%eax),%dl
  800ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	75 e3                	jne    800eb5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed2:	eb 23                	jmp    800ef7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ed4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed7:	8d 50 01             	lea    0x1(%eax),%edx
  800eda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee6:	8a 12                	mov    (%edx),%dl
  800ee8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 dd                	jne    800ed4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f0e:	eb 2a                	jmp    800f3a <memcmp+0x3e>
		if (*s1 != *s2)
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	8a 10                	mov    (%eax),%dl
  800f15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f18:	8a 00                	mov    (%eax),%al
  800f1a:	38 c2                	cmp    %al,%dl
  800f1c:	74 16                	je     800f34 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	0f b6 d0             	movzbl %al,%edx
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	0f b6 c0             	movzbl %al,%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
  800f32:	eb 18                	jmp    800f4c <memcmp+0x50>
		s1++, s2++;
  800f34:	ff 45 fc             	incl   -0x4(%ebp)
  800f37:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f40:	89 55 10             	mov    %edx,0x10(%ebp)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	75 c9                	jne    800f10 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f5f:	eb 15                	jmp    800f76 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 d0             	movzbl %al,%edx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	0f b6 c0             	movzbl %al,%eax
  800f6f:	39 c2                	cmp    %eax,%edx
  800f71:	74 0d                	je     800f80 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f73:	ff 45 08             	incl   0x8(%ebp)
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f7c:	72 e3                	jb     800f61 <memfind+0x13>
  800f7e:	eb 01                	jmp    800f81 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f80:	90                   	nop
	return (void *) s;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9a:	eb 03                	jmp    800f9f <strtol+0x19>
		s++;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3c 20                	cmp    $0x20,%al
  800fa6:	74 f4                	je     800f9c <strtol+0x16>
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 09                	cmp    $0x9,%al
  800faf:	74 eb                	je     800f9c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 2b                	cmp    $0x2b,%al
  800fb8:	75 05                	jne    800fbf <strtol+0x39>
		s++;
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	eb 13                	jmp    800fd2 <strtol+0x4c>
	else if (*s == '-')
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 2d                	cmp    $0x2d,%al
  800fc6:	75 0a                	jne    800fd2 <strtol+0x4c>
		s++, neg = 1;
  800fc8:	ff 45 08             	incl   0x8(%ebp)
  800fcb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 06                	je     800fde <strtol+0x58>
  800fd8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fdc:	75 20                	jne    800ffe <strtol+0x78>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 30                	cmp    $0x30,%al
  800fe5:	75 17                	jne    800ffe <strtol+0x78>
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	40                   	inc    %eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 78                	cmp    $0x78,%al
  800fef:	75 0d                	jne    800ffe <strtol+0x78>
		s += 2, base = 16;
  800ff1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ff5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ffc:	eb 28                	jmp    801026 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ffe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801002:	75 15                	jne    801019 <strtol+0x93>
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 30                	cmp    $0x30,%al
  80100b:	75 0c                	jne    801019 <strtol+0x93>
		s++, base = 8;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801017:	eb 0d                	jmp    801026 <strtol+0xa0>
	else if (base == 0)
  801019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101d:	75 07                	jne    801026 <strtol+0xa0>
		base = 10;
  80101f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 2f                	cmp    $0x2f,%al
  80102d:	7e 19                	jle    801048 <strtol+0xc2>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 39                	cmp    $0x39,%al
  801036:	7f 10                	jg     801048 <strtol+0xc2>
			dig = *s - '0';
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 30             	sub    $0x30,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 42                	jmp    80108a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 60                	cmp    $0x60,%al
  80104f:	7e 19                	jle    80106a <strtol+0xe4>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 7a                	cmp    $0x7a,%al
  801058:	7f 10                	jg     80106a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 57             	sub    $0x57,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801068:	eb 20                	jmp    80108a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 40                	cmp    $0x40,%al
  801071:	7e 39                	jle    8010ac <strtol+0x126>
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	3c 5a                	cmp    $0x5a,%al
  80107a:	7f 30                	jg     8010ac <strtol+0x126>
			dig = *s - 'A' + 10;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	0f be c0             	movsbl %al,%eax
  801084:	83 e8 37             	sub    $0x37,%eax
  801087:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80108a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801090:	7d 19                	jge    8010ab <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801098:	0f af 45 10          	imul   0x10(%ebp),%eax
  80109c:	89 c2                	mov    %eax,%edx
  80109e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a1:	01 d0                	add    %edx,%eax
  8010a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010a6:	e9 7b ff ff ff       	jmp    801026 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010ab:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b0:	74 08                	je     8010ba <strtol+0x134>
		*endptr = (char *) s;
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010be:	74 07                	je     8010c7 <strtol+0x141>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c3:	f7 d8                	neg    %eax
  8010c5:	eb 03                	jmp    8010ca <strtol+0x144>
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <ltostr>:

void
ltostr(long value, char *str)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e4:	79 13                	jns    8010f9 <ltostr+0x2d>
	{
		neg = 1;
  8010e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010f3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010f6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801101:	99                   	cltd   
  801102:	f7 f9                	idiv   %ecx
  801104:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801110:	89 c2                	mov    %eax,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	01 d0                	add    %edx,%eax
  801117:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80111a:	83 c2 30             	add    $0x30,%edx
  80111d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80111f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801122:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801127:	f7 e9                	imul   %ecx
  801129:	c1 fa 02             	sar    $0x2,%edx
  80112c:	89 c8                	mov    %ecx,%eax
  80112e:	c1 f8 1f             	sar    $0x1f,%eax
  801131:	29 c2                	sub    %eax,%edx
  801133:	89 d0                	mov    %edx,%eax
  801135:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80113c:	75 bb                	jne    8010f9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xc3>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 73 fa ff ff       	call   800c26 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 65 fa ff ff       	call   800c26 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 32 fb ff ff       	call   800db8 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 d4 fa ff ff       	call   800db8 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	68 7c 42 80 00       	push   $0x80427c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 9e 42 80 00       	push   $0x80429e
  801327:	e8 20 26 00 00       	call   80394c <_panic>

0080132c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801332:	83 ec 0c             	sub    $0xc,%esp
  801335:	ff 75 08             	pushl  0x8(%ebp)
  801338:	e8 e7 0a 00 00       	call   801e24 <sys_sbrk>
  80133d:	83 c4 10             	add    $0x10,%esp
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134c:	75 0a                	jne    801358 <malloc+0x16>
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
  801353:	e9 07 02 00 00       	jmp    80155f <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801358:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80135f:	8b 55 08             	mov    0x8(%ebp),%edx
  801362:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	48                   	dec    %eax
  801368:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80136b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80136e:	ba 00 00 00 00       	mov    $0x0,%edx
  801373:	f7 75 dc             	divl   -0x24(%ebp)
  801376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801379:	29 d0                	sub    %edx,%eax
  80137b:	c1 e8 0c             	shr    $0xc,%eax
  80137e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801381:	a1 20 50 80 00       	mov    0x805020,%eax
  801386:	8b 40 78             	mov    0x78(%eax),%eax
  801389:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80138e:	29 c2                	sub    %eax,%edx
  801390:	89 d0                	mov    %edx,%eax
  801392:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801395:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801398:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139d:	c1 e8 0c             	shr    $0xc,%eax
  8013a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8013a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8013aa:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013b1:	77 42                	ja     8013f5 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013b3:	e8 f0 08 00 00       	call   801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 30 0e 00 00       	call   8021f7 <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 02 09 00 00       	call   801cd9 <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 c9 12 00 00       	call   8026b3 <alloc_block_BF>
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013f0:	e9 67 01 00 00       	jmp    80155c <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8013f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8013f8:	48                   	dec    %eax
  8013f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8013fc:	0f 86 53 01 00 00    	jbe    801555 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801402:	a1 20 50 80 00       	mov    0x805020,%eax
  801407:	8b 40 78             	mov    0x78(%eax),%eax
  80140a:	05 00 10 00 00       	add    $0x1000,%eax
  80140f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801412:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801419:	e9 de 00 00 00       	jmp    8014fc <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80141e:	a1 20 50 80 00       	mov    0x805020,%eax
  801423:	8b 40 78             	mov    0x78(%eax),%eax
  801426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801429:	29 c2                	sub    %eax,%edx
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801432:	c1 e8 0c             	shr    $0xc,%eax
  801435:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80143c:	85 c0                	test   %eax,%eax
  80143e:	0f 85 ab 00 00 00    	jne    8014ef <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801447:	05 00 10 00 00       	add    $0x1000,%eax
  80144c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80144f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801456:	eb 47                	jmp    80149f <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801458:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80145f:	76 0a                	jbe    80146b <malloc+0x129>
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	e9 f4 00 00 00       	jmp    80155f <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80146b:	a1 20 50 80 00       	mov    0x805020,%eax
  801470:	8b 40 78             	mov    0x78(%eax),%eax
  801473:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801476:	29 c2                	sub    %eax,%edx
  801478:	89 d0                	mov    %edx,%eax
  80147a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147f:	c1 e8 0c             	shr    $0xc,%eax
  801482:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801489:	85 c0                	test   %eax,%eax
  80148b:	74 08                	je     801495 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80148d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801490:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801493:	eb 5a                	jmp    8014ef <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801495:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80149c:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80149f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014a2:	48                   	dec    %eax
  8014a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014a6:	77 b0                	ja     801458 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8014a8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8014af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8014b6:	eb 2f                	jmp    8014e7 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8014b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bb:	c1 e0 0c             	shl    $0xc,%eax
  8014be:	89 c2                	mov    %eax,%edx
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8014ca:	8b 40 78             	mov    0x78(%eax),%eax
  8014cd:	29 c2                	sub    %eax,%edx
  8014cf:	89 d0                	mov    %edx,%eax
  8014d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014d6:	c1 e8 0c             	shr    $0xc,%eax
  8014d9:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8014e0:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8014e4:	ff 45 e0             	incl   -0x20(%ebp)
  8014e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8014ed:	72 c9                	jb     8014b8 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8014ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014f3:	75 16                	jne    80150b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014f5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014fc:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801503:	0f 86 15 ff ff ff    	jbe    80141e <malloc+0xdc>
  801509:	eb 01                	jmp    80150c <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80150b:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80150c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801510:	75 07                	jne    801519 <malloc+0x1d7>
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	eb 46                	jmp    80155f <malloc+0x21d>
		ptr = (void*)i;
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80151f:	a1 20 50 80 00       	mov    0x805020,%eax
  801524:	8b 40 78             	mov    0x78(%eax),%eax
  801527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80152a:	29 c2                	sub    %eax,%edx
  80152c:	89 d0                	mov    %edx,%eax
  80152e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801533:	c1 e8 0c             	shr    $0xc,%eax
  801536:	89 c2                	mov    %eax,%edx
  801538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80153b:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	ff 75 f0             	pushl  -0x10(%ebp)
  80154b:	e8 0b 09 00 00       	call   801e5b <sys_allocate_user_mem>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	eb 07                	jmp    80155c <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	eb 03                	jmp    80155f <malloc+0x21d>
	}
	return ptr;
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801567:	a1 20 50 80 00       	mov    0x805020,%eax
  80156c:	8b 40 78             	mov    0x78(%eax),%eax
  80156f:	05 00 10 00 00       	add    $0x1000,%eax
  801574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801577:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80157e:	a1 20 50 80 00       	mov    0x805020,%eax
  801583:	8b 50 78             	mov    0x78(%eax),%edx
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	39 c2                	cmp    %eax,%edx
  80158b:	76 24                	jbe    8015b1 <free+0x50>
		size = get_block_size(va);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 df 08 00 00       	call   801e77 <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 12 1b 00 00       	call   8030bb <free_block>
  8015a9:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015ac:	e9 ac 00 00 00       	jmp    80165d <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015b7:	0f 82 89 00 00 00    	jb     801646 <free+0xe5>
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8015c5:	77 7f                	ja     801646 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8015c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8015cf:	8b 40 78             	mov    0x78(%eax),%eax
  8015d2:	29 c2                	sub    %eax,%edx
  8015d4:	89 d0                	mov    %edx,%eax
  8015d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015db:	c1 e8 0c             	shr    $0xc,%eax
  8015de:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8015e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8015e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015eb:	c1 e0 0c             	shl    $0xc,%eax
  8015ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8015f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8015f8:	eb 2f                	jmp    801629 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	c1 e0 0c             	shl    $0xc,%eax
  801600:	89 c2                	mov    %eax,%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	01 c2                	add    %eax,%edx
  801607:	a1 20 50 80 00       	mov    0x805020,%eax
  80160c:	8b 40 78             	mov    0x78(%eax),%eax
  80160f:	29 c2                	sub    %eax,%edx
  801611:	89 d0                	mov    %edx,%eax
  801613:	2d 00 10 00 00       	sub    $0x1000,%eax
  801618:	c1 e8 0c             	shr    $0xc,%eax
  80161b:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801622:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801626:	ff 45 f4             	incl   -0xc(%ebp)
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80162f:	72 c9                	jb     8015fa <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	ff 75 ec             	pushl  -0x14(%ebp)
  80163a:	50                   	push   %eax
  80163b:	e8 ff 07 00 00       	call   801e3f <sys_free_user_mem>
  801640:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801643:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801644:	eb 17                	jmp    80165d <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 ac 42 80 00       	push   $0x8042ac
  80164e:	68 85 00 00 00       	push   $0x85
  801653:	68 d6 42 80 00       	push   $0x8042d6
  801658:	e8 ef 22 00 00       	call   80394c <_panic>
	}
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	83 ec 28             	sub    $0x28,%esp
  801665:	8b 45 10             	mov    0x10(%ebp),%eax
  801668:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80166b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166f:	75 0a                	jne    80167b <smalloc+0x1c>
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
  801676:	e9 9a 00 00 00       	jmp    801715 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801681:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168e:	39 d0                	cmp    %edx,%eax
  801690:	73 02                	jae    801694 <smalloc+0x35>
  801692:	89 d0                	mov    %edx,%eax
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	50                   	push   %eax
  801698:	e8 a5 fc ff ff       	call   801342 <malloc>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a7:	75 07                	jne    8016b0 <smalloc+0x51>
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 65                	jmp    801715 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016b0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b7:	50                   	push   %eax
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 83 03 00 00       	call   801a46 <sys_createSharedObject>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016c9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016cd:	74 06                	je     8016d5 <smalloc+0x76>
  8016cf:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016d3:	75 07                	jne    8016dc <smalloc+0x7d>
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 39                	jmp    801715 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	ff 75 ec             	pushl  -0x14(%ebp)
  8016e2:	68 e2 42 80 00       	push   $0x8042e2
  8016e7:	e8 9e ec ff ff       	call   80038a <cprintf>
  8016ec:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8016ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8016f7:	8b 40 78             	mov    0x78(%eax),%eax
  8016fa:	29 c2                	sub    %eax,%edx
  8016fc:	89 d0                	mov    %edx,%eax
  8016fe:	2d 00 10 00 00       	sub    $0x1000,%eax
  801703:	c1 e8 0c             	shr    $0xc,%eax
  801706:	89 c2                	mov    %eax,%edx
  801708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801712:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	ff 75 0c             	pushl  0xc(%ebp)
  801723:	ff 75 08             	pushl  0x8(%ebp)
  801726:	e8 45 03 00 00       	call   801a70 <sys_getSizeOfSharedObject>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801731:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801735:	75 07                	jne    80173e <sget+0x27>
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb 5c                	jmp    80179a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801744:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80174b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801751:	39 d0                	cmp    %edx,%eax
  801753:	7d 02                	jge    801757 <sget+0x40>
  801755:	89 d0                	mov    %edx,%eax
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	50                   	push   %eax
  80175b:	e8 e2 fb ff ff       	call   801342 <malloc>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801766:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80176a:	75 07                	jne    801773 <sget+0x5c>
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
  801771:	eb 27                	jmp    80179a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	ff 75 e8             	pushl  -0x18(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 09 03 00 00       	call   801a8d <sys_getSharedObject>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80178a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80178e:	75 07                	jne    801797 <sget+0x80>
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 03                	jmp    80179a <sget+0x83>
	return ptr;
  801797:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017aa:	8b 40 78             	mov    0x78(%eax),%eax
  8017ad:	29 c2                	sub    %eax,%edx
  8017af:	89 d0                	mov    %edx,%eax
  8017b1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b6:	c1 e8 0c             	shr    $0xc,%eax
  8017b9:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017c3:	83 ec 08             	sub    $0x8,%esp
  8017c6:	ff 75 08             	pushl  0x8(%ebp)
  8017c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cc:	e8 db 02 00 00       	call   801aac <sys_freeSharedObject>
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	68 f4 42 80 00       	push   $0x8042f4
  8017e8:	68 dd 00 00 00       	push   $0xdd
  8017ed:	68 d6 42 80 00       	push   $0x8042d6
  8017f2:	e8 55 21 00 00       	call   80394c <_panic>

008017f7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
  8017fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	68 1a 43 80 00       	push   $0x80431a
  801805:	68 e9 00 00 00       	push   $0xe9
  80180a:	68 d6 42 80 00       	push   $0x8042d6
  80180f:	e8 38 21 00 00       	call   80394c <_panic>

00801814 <shrink>:

}
void shrink(uint32 newSize)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	68 1a 43 80 00       	push   $0x80431a
  801822:	68 ee 00 00 00       	push   $0xee
  801827:	68 d6 42 80 00       	push   $0x8042d6
  80182c:	e8 1b 21 00 00       	call   80394c <_panic>

00801831 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	68 1a 43 80 00       	push   $0x80431a
  80183f:	68 f3 00 00 00       	push   $0xf3
  801844:	68 d6 42 80 00       	push   $0x8042d6
  801849:	e8 fe 20 00 00       	call   80394c <_panic>

0080184e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	57                   	push   %edi
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801860:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801863:	8b 7d 18             	mov    0x18(%ebp),%edi
  801866:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801869:	cd 30                	int    $0x30
  80186b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	5b                   	pop    %ebx
  801875:	5e                   	pop    %esi
  801876:	5f                   	pop    %edi
  801877:	5d                   	pop    %ebp
  801878:	c3                   	ret    

00801879 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801885:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	52                   	push   %edx
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	50                   	push   %eax
  801895:	6a 00                	push   $0x0
  801897:	e8 b2 ff ff ff       	call   80184e <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 02                	push   $0x2
  8018b1:	e8 98 ff ff ff       	call   80184e <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 03                	push   $0x3
  8018ca:	e8 7f ff ff ff       	call   80184e <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 04                	push   $0x4
  8018e4:	e8 65 ff ff ff       	call   80184e <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	6a 08                	push   $0x8
  801902:	e8 47 ff ff ff       	call   80184e <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801911:	8b 75 18             	mov    0x18(%ebp),%esi
  801914:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801917:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 09                	push   $0x9
  801927:	e8 22 ff ff ff       	call   80184e <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 0a                	push   $0xa
  801949:	e8 00 ff ff ff       	call   80184e <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 0b                	push   $0xb
  801964:	e8 e5 fe ff ff       	call   80184e <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 0c                	push   $0xc
  80197d:	e8 cc fe ff ff       	call   80184e <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0d                	push   $0xd
  801996:	e8 b3 fe ff ff       	call   80184e <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 0e                	push   $0xe
  8019af:	e8 9a fe ff ff       	call   80184e <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 0f                	push   $0xf
  8019c8:	e8 81 fe ff ff       	call   80184e <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 10                	push   $0x10
  8019e2:	e8 67 fe ff ff       	call   80184e <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 11                	push   $0x11
  8019fb:	e8 4e fe ff ff       	call   80184e <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	50                   	push   %eax
  801a1f:	6a 01                	push   $0x1
  801a21:	e8 28 fe ff ff       	call   80184e <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 14                	push   $0x14
  801a3b:	e8 0e fe ff ff       	call   80184e <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a55:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	51                   	push   %ecx
  801a5f:	52                   	push   %edx
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	50                   	push   %eax
  801a64:	6a 15                	push   $0x15
  801a66:	e8 e3 fd ff ff       	call   80184e <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	6a 16                	push   $0x16
  801a83:	e8 c6 fd ff ff       	call   80184e <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	51                   	push   %ecx
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 17                	push   $0x17
  801aa2:	e8 a7 fd ff ff       	call   80184e <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	52                   	push   %edx
  801abc:	50                   	push   %eax
  801abd:	6a 18                	push   $0x18
  801abf:	e8 8a fd ff ff       	call   80184e <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 14             	pushl  0x14(%ebp)
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	6a 19                	push   $0x19
  801add:	e8 6c fd ff ff       	call   80184e <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 1a                	push   $0x1a
  801af8:	e8 51 fd ff ff       	call   80184e <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	90                   	nop
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	50                   	push   %eax
  801b12:	6a 1b                	push   $0x1b
  801b14:	e8 35 fd ff ff       	call   80184e <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 05                	push   $0x5
  801b2d:	e8 1c fd ff ff       	call   80184e <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 06                	push   $0x6
  801b46:	e8 03 fd ff ff       	call   80184e <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 07                	push   $0x7
  801b5f:	e8 ea fc ff ff       	call   80184e <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_exit_env>:


void sys_exit_env(void)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 1c                	push   $0x1c
  801b78:	e8 d1 fc ff ff       	call   80184e <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b89:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8c:	8d 50 04             	lea    0x4(%eax),%edx
  801b8f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 1d                	push   $0x1d
  801b9c:	e8 ad fc ff ff       	call   80184e <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801baa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bad:	89 01                	mov    %eax,(%ecx)
  801baf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	c9                   	leave  
  801bb6:	c2 04 00             	ret    $0x4

00801bb9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 13                	push   $0x13
  801bcb:	e8 7e fc ff ff       	call   80184e <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 1e                	push   $0x1e
  801be5:	e8 64 fc ff ff       	call   80184e <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	50                   	push   %eax
  801c08:	6a 1f                	push   $0x1f
  801c0a:	e8 3f fc ff ff       	call   80184e <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <rsttst>:
void rsttst()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 21                	push   $0x21
  801c24:	e8 25 fc ff ff       	call   80184e <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	8b 45 14             	mov    0x14(%ebp),%eax
  801c38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 20                	push   $0x20
  801c4f:	e8 fa fb ff ff       	call   80184e <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <chktst>:
void chktst(uint32 n)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 22                	push   $0x22
  801c6a:	e8 df fb ff ff       	call   80184e <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c72:	90                   	nop
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <inctst>:

void inctst()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 23                	push   $0x23
  801c84:	e8 c5 fb ff ff       	call   80184e <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <gettst>:
uint32 gettst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 24                	push   $0x24
  801c9e:	e8 ab fb ff ff       	call   80184e <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 25                	push   $0x25
  801cba:	e8 8f fb ff ff       	call   80184e <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc9:	75 07                	jne    801cd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd0:	eb 05                	jmp    801cd7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 25                	push   $0x25
  801ceb:	e8 5e fb ff ff       	call   80184e <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfa:	75 07                	jne    801d03 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801d01:	eb 05                	jmp    801d08 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 25                	push   $0x25
  801d1c:	e8 2d fb ff ff       	call   80184e <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
  801d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d27:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2b:	75 07                	jne    801d34 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	eb 05                	jmp    801d39 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 25                	push   $0x25
  801d4d:	e8 fc fa ff ff       	call   80184e <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
  801d55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d58:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5c:	75 07                	jne    801d65 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	eb 05                	jmp    801d6a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	6a 26                	push   $0x26
  801d7c:	e8 cd fa ff ff       	call   80184e <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
	return ;
  801d84:	90                   	nop
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	53                   	push   %ebx
  801d9a:	51                   	push   %ecx
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 27                	push   $0x27
  801d9f:	e8 aa fa ff ff       	call   80184e <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 28                	push   $0x28
  801dbf:	e8 8a fa ff ff       	call   80184e <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dcc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	51                   	push   %ecx
  801dd8:	ff 75 10             	pushl  0x10(%ebp)
  801ddb:	52                   	push   %edx
  801ddc:	50                   	push   %eax
  801ddd:	6a 29                	push   $0x29
  801ddf:	e8 6a fa ff ff       	call   80184e <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 10             	pushl  0x10(%ebp)
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	ff 75 08             	pushl  0x8(%ebp)
  801df9:	6a 12                	push   $0x12
  801dfb:	e8 4e fa ff ff       	call   80184e <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
	return ;
  801e03:	90                   	nop
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	52                   	push   %edx
  801e16:	50                   	push   %eax
  801e17:	6a 2a                	push   $0x2a
  801e19:	e8 30 fa ff ff       	call   80184e <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	50                   	push   %eax
  801e33:	6a 2b                	push   $0x2b
  801e35:	e8 14 fa ff ff       	call   80184e <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 2c                	push   $0x2c
  801e50:	e8 f9 f9 ff ff       	call   80184e <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
	return;
  801e58:	90                   	nop
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	6a 2d                	push   $0x2d
  801e6c:	e8 dd f9 ff ff       	call   80184e <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
	return;
  801e74:	90                   	nop
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	83 e8 04             	sub    $0x4,%eax
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e89:	8b 00                	mov    (%eax),%eax
  801e8b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	83 e8 04             	sub    $0x4,%eax
  801e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea2:	8b 00                	mov    (%eax),%eax
  801ea4:	83 e0 01             	and    $0x1,%eax
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	0f 94 c0             	sete   %al
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	83 f8 02             	cmp    $0x2,%eax
  801ec1:	74 2b                	je     801eee <alloc_block+0x40>
  801ec3:	83 f8 02             	cmp    $0x2,%eax
  801ec6:	7f 07                	jg     801ecf <alloc_block+0x21>
  801ec8:	83 f8 01             	cmp    $0x1,%eax
  801ecb:	74 0e                	je     801edb <alloc_block+0x2d>
  801ecd:	eb 58                	jmp    801f27 <alloc_block+0x79>
  801ecf:	83 f8 03             	cmp    $0x3,%eax
  801ed2:	74 2d                	je     801f01 <alloc_block+0x53>
  801ed4:	83 f8 04             	cmp    $0x4,%eax
  801ed7:	74 3b                	je     801f14 <alloc_block+0x66>
  801ed9:	eb 4c                	jmp    801f27 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	e8 11 03 00 00       	call   8021f7 <alloc_block_FF>
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eec:	eb 4a                	jmp    801f38 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	e8 fa 19 00 00       	call   8038f3 <alloc_block_NF>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eff:	eb 37                	jmp    801f38 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 08             	pushl  0x8(%ebp)
  801f07:	e8 a7 07 00 00       	call   8026b3 <alloc_block_BF>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f12:	eb 24                	jmp    801f38 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	ff 75 08             	pushl  0x8(%ebp)
  801f1a:	e8 b7 19 00 00       	call   8038d6 <alloc_block_WF>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f25:	eb 11                	jmp    801f38 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	68 2c 43 80 00       	push   $0x80432c
  801f2f:	e8 56 e4 ff ff       	call   80038a <cprintf>
  801f34:	83 c4 10             	add    $0x10,%esp
		break;
  801f37:	90                   	nop
	}
	return va;
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	53                   	push   %ebx
  801f41:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	68 4c 43 80 00       	push   $0x80434c
  801f4c:	e8 39 e4 ff ff       	call   80038a <cprintf>
  801f51:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	68 77 43 80 00       	push   $0x804377
  801f5c:	e8 29 e4 ff ff       	call   80038a <cprintf>
  801f61:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6a:	eb 37                	jmp    801fa3 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f72:	e8 19 ff ff ff       	call   801e90 <is_free_block>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	0f be d8             	movsbl %al,%ebx
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 ef fe ff ff       	call   801e77 <get_block_size>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	53                   	push   %ebx
  801f8f:	50                   	push   %eax
  801f90:	68 8f 43 80 00       	push   $0x80438f
  801f95:	e8 f0 e3 ff ff       	call   80038a <cprintf>
  801f9a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	74 07                	je     801fb0 <print_blocks_list+0x73>
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 00                	mov    (%eax),%eax
  801fae:	eb 05                	jmp    801fb5 <print_blocks_list+0x78>
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb5:	89 45 10             	mov    %eax,0x10(%ebp)
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 ad                	jne    801f6c <print_blocks_list+0x2f>
  801fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc3:	75 a7                	jne    801f6c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 4c 43 80 00       	push   $0x80434c
  801fcd:	e8 b8 e3 ff ff       	call   80038a <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp

}
  801fd5:	90                   	nop
  801fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe4:	83 e0 01             	and    $0x1,%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	74 03                	je     801fee <initialize_dynamic_allocator+0x13>
  801feb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ff2:	0f 84 c7 01 00 00    	je     8021bf <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801ff8:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fff:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802002:	8b 55 08             	mov    0x8(%ebp),%edx
  802005:	8b 45 0c             	mov    0xc(%ebp),%eax
  802008:	01 d0                	add    %edx,%eax
  80200a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80200f:	0f 87 ad 01 00 00    	ja     8021c2 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	0f 89 a5 01 00 00    	jns    8021c5 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802020:	8b 55 08             	mov    0x8(%ebp),%edx
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	01 d0                	add    %edx,%eax
  802028:	83 e8 04             	sub    $0x4,%eax
  80202b:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802030:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802037:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	e9 87 00 00 00       	jmp    8020cb <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802044:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802048:	75 14                	jne    80205e <initialize_dynamic_allocator+0x83>
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	68 a7 43 80 00       	push   $0x8043a7
  802052:	6a 79                	push   $0x79
  802054:	68 c5 43 80 00       	push   $0x8043c5
  802059:	e8 ee 18 00 00       	call   80394c <_panic>
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	85 c0                	test   %eax,%eax
  802065:	74 10                	je     802077 <initialize_dynamic_allocator+0x9c>
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206f:	8b 52 04             	mov    0x4(%edx),%edx
  802072:	89 50 04             	mov    %edx,0x4(%eax)
  802075:	eb 0b                	jmp    802082 <initialize_dynamic_allocator+0xa7>
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207a:	8b 40 04             	mov    0x4(%eax),%eax
  80207d:	a3 30 50 80 00       	mov    %eax,0x805030
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 40 04             	mov    0x4(%eax),%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	74 0f                	je     80209b <initialize_dynamic_allocator+0xc0>
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 40 04             	mov    0x4(%eax),%eax
  802092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802095:	8b 12                	mov    (%edx),%edx
  802097:	89 10                	mov    %edx,(%eax)
  802099:	eb 0a                	jmp    8020a5 <initialize_dynamic_allocator+0xca>
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8020bd:	48                   	dec    %eax
  8020be:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8020c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cf:	74 07                	je     8020d8 <initialize_dynamic_allocator+0xfd>
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	eb 05                	jmp    8020dd <initialize_dynamic_allocator+0x102>
  8020d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dd:	a3 34 50 80 00       	mov    %eax,0x805034
  8020e2:	a1 34 50 80 00       	mov    0x805034,%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 85 55 ff ff ff    	jne    802044 <initialize_dynamic_allocator+0x69>
  8020ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f3:	0f 85 4b ff ff ff    	jne    802044 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802102:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802108:	a1 44 50 80 00       	mov    0x805044,%eax
  80210d:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802112:	a1 40 50 80 00       	mov    0x805040,%eax
  802117:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	83 c0 08             	add    $0x8,%eax
  802123:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	83 c0 04             	add    $0x4,%eax
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	83 ea 08             	sub    $0x8,%edx
  802132:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	83 e8 08             	sub    $0x8,%eax
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	83 ea 08             	sub    $0x8,%edx
  802145:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802153:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80215a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80215e:	75 17                	jne    802177 <initialize_dynamic_allocator+0x19c>
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 e0 43 80 00       	push   $0x8043e0
  802168:	68 90 00 00 00       	push   $0x90
  80216d:	68 c5 43 80 00       	push   $0x8043c5
  802172:	e8 d5 17 00 00       	call   80394c <_panic>
  802177:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80217d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802180:	89 10                	mov    %edx,(%eax)
  802182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	85 c0                	test   %eax,%eax
  802189:	74 0d                	je     802198 <initialize_dynamic_allocator+0x1bd>
  80218b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802190:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802193:	89 50 04             	mov    %edx,0x4(%eax)
  802196:	eb 08                	jmp    8021a0 <initialize_dynamic_allocator+0x1c5>
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b7:	40                   	inc    %eax
  8021b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8021bd:	eb 07                	jmp    8021c6 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021bf:	90                   	nop
  8021c0:	eb 04                	jmp    8021c6 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021c2:	90                   	nop
  8021c3:	eb 01                	jmp    8021c6 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021c5:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ce:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021da:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	83 e8 04             	sub    $0x4,%eax
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	83 e0 fe             	and    $0xfffffffe,%eax
  8021e7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f2:	89 02                	mov    %eax,(%edx)
}
  8021f4:	90                   	nop
  8021f5:	5d                   	pop    %ebp
  8021f6:	c3                   	ret    

008021f7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	83 e0 01             	and    $0x1,%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	74 03                	je     80220a <alloc_block_FF+0x13>
  802207:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80220a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80220e:	77 07                	ja     802217 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802210:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802217:	a1 24 50 80 00       	mov    0x805024,%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	75 73                	jne    802293 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	83 c0 10             	add    $0x10,%eax
  802226:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802229:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802230:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	48                   	dec    %eax
  802239:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80223c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223f:	ba 00 00 00 00       	mov    $0x0,%edx
  802244:	f7 75 ec             	divl   -0x14(%ebp)
  802247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80224a:	29 d0                	sub    %edx,%eax
  80224c:	c1 e8 0c             	shr    $0xc,%eax
  80224f:	83 ec 0c             	sub    $0xc,%esp
  802252:	50                   	push   %eax
  802253:	e8 d4 f0 ff ff       	call   80132c <sbrk>
  802258:	83 c4 10             	add    $0x10,%esp
  80225b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	6a 00                	push   $0x0
  802263:	e8 c4 f0 ff ff       	call   80132c <sbrk>
  802268:	83 c4 10             	add    $0x10,%esp
  80226b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80226e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802271:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	50                   	push   %eax
  802278:	ff 75 e4             	pushl  -0x1c(%ebp)
  80227b:	e8 5b fd ff ff       	call   801fdb <initialize_dynamic_allocator>
  802280:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	68 03 44 80 00       	push   $0x804403
  80228b:	e8 fa e0 ff ff       	call   80038a <cprintf>
  802290:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802297:	75 0a                	jne    8022a3 <alloc_block_FF+0xac>
	        return NULL;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	e9 0e 04 00 00       	jmp    8026b1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b2:	e9 f3 02 00 00       	jmp    8025aa <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022bd:	83 ec 0c             	sub    $0xc,%esp
  8022c0:	ff 75 bc             	pushl  -0x44(%ebp)
  8022c3:	e8 af fb ff ff       	call   801e77 <get_block_size>
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	83 c0 08             	add    $0x8,%eax
  8022d4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022d7:	0f 87 c5 02 00 00    	ja     8025a2 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	83 c0 18             	add    $0x18,%eax
  8022e3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022e6:	0f 87 19 02 00 00    	ja     802505 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8022f2:	83 e8 08             	sub    $0x8,%eax
  8022f5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8d 50 08             	lea    0x8(%eax),%edx
  8022fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802301:	01 d0                	add    %edx,%eax
  802303:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	83 c0 08             	add    $0x8,%eax
  80230c:	83 ec 04             	sub    $0x4,%esp
  80230f:	6a 01                	push   $0x1
  802311:	50                   	push   %eax
  802312:	ff 75 bc             	pushl  -0x44(%ebp)
  802315:	e8 ae fe ff ff       	call   8021c8 <set_block_data>
  80231a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	75 68                	jne    80238f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802327:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80232b:	75 17                	jne    802344 <alloc_block_FF+0x14d>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 e0 43 80 00       	push   $0x8043e0
  802335:	68 d7 00 00 00       	push   $0xd7
  80233a:	68 c5 43 80 00       	push   $0x8043c5
  80233f:	e8 08 16 00 00       	call   80394c <_panic>
  802344:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80234a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0d                	je     802365 <alloc_block_FF+0x16e>
  802358:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80235d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	eb 08                	jmp    80236d <alloc_block_FF+0x176>
  802365:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802368:	a3 30 50 80 00       	mov    %eax,0x805030
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802375:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802378:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237f:	a1 38 50 80 00       	mov    0x805038,%eax
  802384:	40                   	inc    %eax
  802385:	a3 38 50 80 00       	mov    %eax,0x805038
  80238a:	e9 dc 00 00 00       	jmp    80246b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	75 65                	jne    8023fd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802398:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80239c:	75 17                	jne    8023b5 <alloc_block_FF+0x1be>
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	68 14 44 80 00       	push   $0x804414
  8023a6:	68 db 00 00 00       	push   $0xdb
  8023ab:	68 c5 43 80 00       	push   $0x8043c5
  8023b0:	e8 97 15 00 00       	call   80394c <_panic>
  8023b5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023be:	89 50 04             	mov    %edx,0x4(%eax)
  8023c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 0c                	je     8023d7 <alloc_block_FF+0x1e0>
  8023cb:	a1 30 50 80 00       	mov    0x805030,%eax
  8023d0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d3:	89 10                	mov    %edx,(%eax)
  8023d5:	eb 08                	jmp    8023df <alloc_block_FF+0x1e8>
  8023d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8023e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f5:	40                   	inc    %eax
  8023f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8023fb:	eb 6e                	jmp    80246b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	74 06                	je     802409 <alloc_block_FF+0x212>
  802403:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802407:	75 17                	jne    802420 <alloc_block_FF+0x229>
  802409:	83 ec 04             	sub    $0x4,%esp
  80240c:	68 38 44 80 00       	push   $0x804438
  802411:	68 df 00 00 00       	push   $0xdf
  802416:	68 c5 43 80 00       	push   $0x8043c5
  80241b:	e8 2c 15 00 00       	call   80394c <_panic>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 10                	mov    (%eax),%edx
  802425:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802428:	89 10                	mov    %edx,(%eax)
  80242a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	74 0b                	je     80243e <alloc_block_FF+0x247>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802444:	89 10                	mov    %edx,(%eax)
  802446:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	75 08                	jne    802460 <alloc_block_FF+0x269>
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	a3 30 50 80 00       	mov    %eax,0x805030
  802460:	a1 38 50 80 00       	mov    0x805038,%eax
  802465:	40                   	inc    %eax
  802466:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80246b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246f:	75 17                	jne    802488 <alloc_block_FF+0x291>
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	68 a7 43 80 00       	push   $0x8043a7
  802479:	68 e1 00 00 00       	push   $0xe1
  80247e:	68 c5 43 80 00       	push   $0x8043c5
  802483:	e8 c4 14 00 00       	call   80394c <_panic>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 10                	je     8024a1 <alloc_block_FF+0x2aa>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802499:	8b 52 04             	mov    0x4(%edx),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 0b                	jmp    8024ac <alloc_block_FF+0x2b5>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 0f                	je     8024c5 <alloc_block_FF+0x2ce>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 04             	mov    0x4(%eax),%eax
  8024bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bf:	8b 12                	mov    (%edx),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	eb 0a                	jmp    8024cf <alloc_block_FF+0x2d8>
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e7:	48                   	dec    %eax
  8024e8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024ed:	83 ec 04             	sub    $0x4,%esp
  8024f0:	6a 00                	push   $0x0
  8024f2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024f5:	ff 75 b0             	pushl  -0x50(%ebp)
  8024f8:	e8 cb fc ff ff       	call   8021c8 <set_block_data>
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	e9 95 00 00 00       	jmp    80259a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802505:	83 ec 04             	sub    $0x4,%esp
  802508:	6a 01                	push   $0x1
  80250a:	ff 75 b8             	pushl  -0x48(%ebp)
  80250d:	ff 75 bc             	pushl  -0x44(%ebp)
  802510:	e8 b3 fc ff ff       	call   8021c8 <set_block_data>
  802515:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251c:	75 17                	jne    802535 <alloc_block_FF+0x33e>
  80251e:	83 ec 04             	sub    $0x4,%esp
  802521:	68 a7 43 80 00       	push   $0x8043a7
  802526:	68 e8 00 00 00       	push   $0xe8
  80252b:	68 c5 43 80 00       	push   $0x8043c5
  802530:	e8 17 14 00 00       	call   80394c <_panic>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 10                	je     80254e <alloc_block_FF+0x357>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	8b 52 04             	mov    0x4(%edx),%edx
  802549:	89 50 04             	mov    %edx,0x4(%eax)
  80254c:	eb 0b                	jmp    802559 <alloc_block_FF+0x362>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	a3 30 50 80 00       	mov    %eax,0x805030
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 0f                	je     802572 <alloc_block_FF+0x37b>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256c:	8b 12                	mov    (%edx),%edx
  80256e:	89 10                	mov    %edx,(%eax)
  802570:	eb 0a                	jmp    80257c <alloc_block_FF+0x385>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258f:	a1 38 50 80 00       	mov    0x805038,%eax
  802594:	48                   	dec    %eax
  802595:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80259a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80259d:	e9 0f 01 00 00       	jmp    8026b1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ae:	74 07                	je     8025b7 <alloc_block_FF+0x3c0>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	eb 05                	jmp    8025bc <alloc_block_FF+0x3c5>
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8025c1:	a1 34 50 80 00       	mov    0x805034,%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	0f 85 e9 fc ff ff    	jne    8022b7 <alloc_block_FF+0xc0>
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	0f 85 df fc ff ff    	jne    8022b7 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	83 c0 08             	add    $0x8,%eax
  8025de:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025e1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	48                   	dec    %eax
  8025f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fc:	f7 75 d8             	divl   -0x28(%ebp)
  8025ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802602:	29 d0                	sub    %edx,%eax
  802604:	c1 e8 0c             	shr    $0xc,%eax
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	50                   	push   %eax
  80260b:	e8 1c ed ff ff       	call   80132c <sbrk>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802616:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80261a:	75 0a                	jne    802626 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	e9 8b 00 00 00       	jmp    8026b1 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802626:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80262d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802630:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802633:	01 d0                	add    %edx,%eax
  802635:	48                   	dec    %eax
  802636:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802639:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80263c:	ba 00 00 00 00       	mov    $0x0,%edx
  802641:	f7 75 cc             	divl   -0x34(%ebp)
  802644:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802647:	29 d0                	sub    %edx,%eax
  802649:	8d 50 fc             	lea    -0x4(%eax),%edx
  80264c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80264f:	01 d0                	add    %edx,%eax
  802651:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802656:	a1 40 50 80 00       	mov    0x805040,%eax
  80265b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802661:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802668:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80266b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80266e:	01 d0                	add    %edx,%eax
  802670:	48                   	dec    %eax
  802671:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802674:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802677:	ba 00 00 00 00       	mov    $0x0,%edx
  80267c:	f7 75 c4             	divl   -0x3c(%ebp)
  80267f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802682:	29 d0                	sub    %edx,%eax
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	6a 01                	push   $0x1
  802689:	50                   	push   %eax
  80268a:	ff 75 d0             	pushl  -0x30(%ebp)
  80268d:	e8 36 fb ff ff       	call   8021c8 <set_block_data>
  802692:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	ff 75 d0             	pushl  -0x30(%ebp)
  80269b:	e8 1b 0a 00 00       	call   8030bb <free_block>
  8026a0:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	ff 75 08             	pushl  0x8(%ebp)
  8026a9:	e8 49 fb ff ff       	call   8021f7 <alloc_block_FF>
  8026ae:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	83 e0 01             	and    $0x1,%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 03                	je     8026c6 <alloc_block_BF+0x13>
  8026c3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026c6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026ca:	77 07                	ja     8026d3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026cc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026d3:	a1 24 50 80 00       	mov    0x805024,%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	75 73                	jne    80274f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	83 c0 10             	add    $0x10,%eax
  8026e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026e5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	01 d0                	add    %edx,%eax
  8026f4:	48                   	dec    %eax
  8026f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802700:	f7 75 e0             	divl   -0x20(%ebp)
  802703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802706:	29 d0                	sub    %edx,%eax
  802708:	c1 e8 0c             	shr    $0xc,%eax
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	50                   	push   %eax
  80270f:	e8 18 ec ff ff       	call   80132c <sbrk>
  802714:	83 c4 10             	add    $0x10,%esp
  802717:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80271a:	83 ec 0c             	sub    $0xc,%esp
  80271d:	6a 00                	push   $0x0
  80271f:	e8 08 ec ff ff       	call   80132c <sbrk>
  802724:	83 c4 10             	add    $0x10,%esp
  802727:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80272a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802730:	83 ec 08             	sub    $0x8,%esp
  802733:	50                   	push   %eax
  802734:	ff 75 d8             	pushl  -0x28(%ebp)
  802737:	e8 9f f8 ff ff       	call   801fdb <initialize_dynamic_allocator>
  80273c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	68 03 44 80 00       	push   $0x804403
  802747:	e8 3e dc ff ff       	call   80038a <cprintf>
  80274c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80274f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80275d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80276b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802773:	e9 1d 01 00 00       	jmp    802895 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80277e:	83 ec 0c             	sub    $0xc,%esp
  802781:	ff 75 a8             	pushl  -0x58(%ebp)
  802784:	e8 ee f6 ff ff       	call   801e77 <get_block_size>
  802789:	83 c4 10             	add    $0x10,%esp
  80278c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	83 c0 08             	add    $0x8,%eax
  802795:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802798:	0f 87 ef 00 00 00    	ja     80288d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	83 c0 18             	add    $0x18,%eax
  8027a4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a7:	77 1d                	ja     8027c6 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027af:	0f 86 d8 00 00 00    	jbe    80288d <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027b5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027bb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027c1:	e9 c7 00 00 00       	jmp    80288d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	83 c0 08             	add    $0x8,%eax
  8027cc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027cf:	0f 85 9d 00 00 00    	jne    802872 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	6a 01                	push   $0x1
  8027da:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027dd:	ff 75 a8             	pushl  -0x58(%ebp)
  8027e0:	e8 e3 f9 ff ff       	call   8021c8 <set_block_data>
  8027e5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_BF+0x152>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 a7 43 80 00       	push   $0x8043a7
  8027f6:	68 2c 01 00 00       	push   $0x12c
  8027fb:	68 c5 43 80 00       	push   $0x8043c5
  802800:	e8 47 11 00 00       	call   80394c <_panic>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	74 10                	je     80281e <alloc_block_BF+0x16b>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 52 04             	mov    0x4(%edx),%edx
  802819:	89 50 04             	mov    %edx,0x4(%eax)
  80281c:	eb 0b                	jmp    802829 <alloc_block_BF+0x176>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	a3 30 50 80 00       	mov    %eax,0x805030
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0f                	je     802842 <alloc_block_BF+0x18f>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	8b 12                	mov    (%edx),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 0a                	jmp    80284c <alloc_block_BF+0x199>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285f:	a1 38 50 80 00       	mov    0x805038,%eax
  802864:	48                   	dec    %eax
  802865:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80286a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80286d:	e9 24 04 00 00       	jmp    802c96 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802878:	76 13                	jbe    80288d <alloc_block_BF+0x1da>
					{
						internal = 1;
  80287a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802881:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802884:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802887:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80288a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80288d:	a1 34 50 80 00       	mov    0x805034,%eax
  802892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802899:	74 07                	je     8028a2 <alloc_block_BF+0x1ef>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	eb 05                	jmp    8028a7 <alloc_block_BF+0x1f4>
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a7:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	0f 85 bf fe ff ff    	jne    802778 <alloc_block_BF+0xc5>
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	0f 85 b5 fe ff ff    	jne    802778 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c7:	0f 84 26 02 00 00    	je     802af3 <alloc_block_BF+0x440>
  8028cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d1:	0f 85 1c 02 00 00    	jne    802af3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028da:	2b 45 08             	sub    0x8(%ebp),%eax
  8028dd:	83 e8 08             	sub    $0x8,%eax
  8028e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	8d 50 08             	lea    0x8(%eax),%edx
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	83 c0 08             	add    $0x8,%eax
  8028f7:	83 ec 04             	sub    $0x4,%esp
  8028fa:	6a 01                	push   $0x1
  8028fc:	50                   	push   %eax
  8028fd:	ff 75 f0             	pushl  -0x10(%ebp)
  802900:	e8 c3 f8 ff ff       	call   8021c8 <set_block_data>
  802905:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	75 68                	jne    80297a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802912:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802916:	75 17                	jne    80292f <alloc_block_BF+0x27c>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 e0 43 80 00       	push   $0x8043e0
  802920:	68 45 01 00 00       	push   $0x145
  802925:	68 c5 43 80 00       	push   $0x8043c5
  80292a:	e8 1d 10 00 00       	call   80394c <_panic>
  80292f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802935:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0d                	je     802950 <alloc_block_BF+0x29d>
  802943:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802948:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 08                	jmp    802958 <alloc_block_BF+0x2a5>
  802950:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802953:	a3 30 50 80 00       	mov    %eax,0x805030
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802960:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296a:	a1 38 50 80 00       	mov    0x805038,%eax
  80296f:	40                   	inc    %eax
  802970:	a3 38 50 80 00       	mov    %eax,0x805038
  802975:	e9 dc 00 00 00       	jmp    802a56 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	75 65                	jne    8029e8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802983:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802987:	75 17                	jne    8029a0 <alloc_block_BF+0x2ed>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 14 44 80 00       	push   $0x804414
  802991:	68 4a 01 00 00       	push   $0x14a
  802996:	68 c5 43 80 00       	push   $0x8043c5
  80299b:	e8 ac 0f 00 00       	call   80394c <_panic>
  8029a0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0c                	je     8029c2 <alloc_block_BF+0x30f>
  8029b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8029bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029be:	89 10                	mov    %edx,(%eax)
  8029c0:	eb 08                	jmp    8029ca <alloc_block_BF+0x317>
  8029c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029db:	a1 38 50 80 00       	mov    0x805038,%eax
  8029e0:	40                   	inc    %eax
  8029e1:	a3 38 50 80 00       	mov    %eax,0x805038
  8029e6:	eb 6e                	jmp    802a56 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ec:	74 06                	je     8029f4 <alloc_block_BF+0x341>
  8029ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_BF+0x358>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 38 44 80 00       	push   $0x804438
  8029fc:	68 4f 01 00 00       	push   $0x14f
  802a01:	68 c5 43 80 00       	push   $0x8043c5
  802a06:	e8 41 0f 00 00       	call   80394c <_panic>
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	8b 10                	mov    (%eax),%edx
  802a10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	74 0b                	je     802a29 <alloc_block_BF+0x376>
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a26:	89 50 04             	mov    %edx,0x4(%eax)
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a2f:	89 10                	mov    %edx,(%eax)
  802a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a37:	89 50 04             	mov    %edx,0x4(%eax)
  802a3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	75 08                	jne    802a4b <alloc_block_BF+0x398>
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a50:	40                   	inc    %eax
  802a51:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5a:	75 17                	jne    802a73 <alloc_block_BF+0x3c0>
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	68 a7 43 80 00       	push   $0x8043a7
  802a64:	68 51 01 00 00       	push   $0x151
  802a69:	68 c5 43 80 00       	push   $0x8043c5
  802a6e:	e8 d9 0e 00 00       	call   80394c <_panic>
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 10                	je     802a8c <alloc_block_BF+0x3d9>
  802a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a84:	8b 52 04             	mov    0x4(%edx),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	eb 0b                	jmp    802a97 <alloc_block_BF+0x3e4>
  802a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	a3 30 50 80 00       	mov    %eax,0x805030
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 0f                	je     802ab0 <alloc_block_BF+0x3fd>
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aaa:	8b 12                	mov    (%edx),%edx
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	eb 0a                	jmp    802aba <alloc_block_BF+0x407>
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad2:	48                   	dec    %eax
  802ad3:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	6a 00                	push   $0x0
  802add:	ff 75 d0             	pushl  -0x30(%ebp)
  802ae0:	ff 75 cc             	pushl  -0x34(%ebp)
  802ae3:	e8 e0 f6 ff ff       	call   8021c8 <set_block_data>
  802ae8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	e9 a3 01 00 00       	jmp    802c96 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802af3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802af7:	0f 85 9d 00 00 00    	jne    802b9a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	6a 01                	push   $0x1
  802b02:	ff 75 ec             	pushl  -0x14(%ebp)
  802b05:	ff 75 f0             	pushl  -0x10(%ebp)
  802b08:	e8 bb f6 ff ff       	call   8021c8 <set_block_data>
  802b0d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b14:	75 17                	jne    802b2d <alloc_block_BF+0x47a>
  802b16:	83 ec 04             	sub    $0x4,%esp
  802b19:	68 a7 43 80 00       	push   $0x8043a7
  802b1e:	68 58 01 00 00       	push   $0x158
  802b23:	68 c5 43 80 00       	push   $0x8043c5
  802b28:	e8 1f 0e 00 00       	call   80394c <_panic>
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 10                	je     802b46 <alloc_block_BF+0x493>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	8b 52 04             	mov    0x4(%edx),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)
  802b44:	eb 0b                	jmp    802b51 <alloc_block_BF+0x49e>
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 40 04             	mov    0x4(%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 0f                	je     802b6a <alloc_block_BF+0x4b7>
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b64:	8b 12                	mov    (%edx),%edx
  802b66:	89 10                	mov    %edx,(%eax)
  802b68:	eb 0a                	jmp    802b74 <alloc_block_BF+0x4c1>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b87:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8c:	48                   	dec    %eax
  802b8d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b95:	e9 fc 00 00 00       	jmp    802c96 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	83 c0 08             	add    $0x8,%eax
  802ba0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ba3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802baa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bb0:	01 d0                	add    %edx,%eax
  802bb2:	48                   	dec    %eax
  802bb3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bb6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbe:	f7 75 c4             	divl   -0x3c(%ebp)
  802bc1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bc4:	29 d0                	sub    %edx,%eax
  802bc6:	c1 e8 0c             	shr    $0xc,%eax
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	50                   	push   %eax
  802bcd:	e8 5a e7 ff ff       	call   80132c <sbrk>
  802bd2:	83 c4 10             	add    $0x10,%esp
  802bd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bd8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bdc:	75 0a                	jne    802be8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bde:	b8 00 00 00 00       	mov    $0x0,%eax
  802be3:	e9 ae 00 00 00       	jmp    802c96 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802be8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bf2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	48                   	dec    %eax
  802bf8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  802c03:	f7 75 b8             	divl   -0x48(%ebp)
  802c06:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c09:	29 d0                	sub    %edx,%eax
  802c0b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c11:	01 d0                	add    %edx,%eax
  802c13:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c18:	a1 40 50 80 00       	mov    0x805040,%eax
  802c1d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c23:	83 ec 0c             	sub    $0xc,%esp
  802c26:	68 6c 44 80 00       	push   $0x80446c
  802c2b:	e8 5a d7 ff ff       	call   80038a <cprintf>
  802c30:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c33:	83 ec 08             	sub    $0x8,%esp
  802c36:	ff 75 bc             	pushl  -0x44(%ebp)
  802c39:	68 71 44 80 00       	push   $0x804471
  802c3e:	e8 47 d7 ff ff       	call   80038a <cprintf>
  802c43:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c46:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c4d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c53:	01 d0                	add    %edx,%eax
  802c55:	48                   	dec    %eax
  802c56:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c59:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c5c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c61:	f7 75 b0             	divl   -0x50(%ebp)
  802c64:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c67:	29 d0                	sub    %edx,%eax
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	6a 01                	push   $0x1
  802c6e:	50                   	push   %eax
  802c6f:	ff 75 bc             	pushl  -0x44(%ebp)
  802c72:	e8 51 f5 ff ff       	call   8021c8 <set_block_data>
  802c77:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c7a:	83 ec 0c             	sub    $0xc,%esp
  802c7d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c80:	e8 36 04 00 00       	call   8030bb <free_block>
  802c85:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c88:	83 ec 0c             	sub    $0xc,%esp
  802c8b:	ff 75 08             	pushl  0x8(%ebp)
  802c8e:	e8 20 fa ff ff       	call   8026b3 <alloc_block_BF>
  802c93:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	53                   	push   %ebx
  802c9c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ca6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb1:	74 1e                	je     802cd1 <merging+0x39>
  802cb3:	ff 75 08             	pushl  0x8(%ebp)
  802cb6:	e8 bc f1 ff ff       	call   801e77 <get_block_size>
  802cbb:	83 c4 04             	add    $0x4,%esp
  802cbe:	89 c2                	mov    %eax,%edx
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	01 d0                	add    %edx,%eax
  802cc5:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cc8:	75 07                	jne    802cd1 <merging+0x39>
		prev_is_free = 1;
  802cca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd5:	74 1e                	je     802cf5 <merging+0x5d>
  802cd7:	ff 75 10             	pushl  0x10(%ebp)
  802cda:	e8 98 f1 ff ff       	call   801e77 <get_block_size>
  802cdf:	83 c4 04             	add    $0x4,%esp
  802ce2:	89 c2                	mov    %eax,%edx
  802ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce7:	01 d0                	add    %edx,%eax
  802ce9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cec:	75 07                	jne    802cf5 <merging+0x5d>
		next_is_free = 1;
  802cee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	0f 84 cc 00 00 00    	je     802dcb <merging+0x133>
  802cff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d03:	0f 84 c2 00 00 00    	je     802dcb <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d09:	ff 75 08             	pushl  0x8(%ebp)
  802d0c:	e8 66 f1 ff ff       	call   801e77 <get_block_size>
  802d11:	83 c4 04             	add    $0x4,%esp
  802d14:	89 c3                	mov    %eax,%ebx
  802d16:	ff 75 10             	pushl  0x10(%ebp)
  802d19:	e8 59 f1 ff ff       	call   801e77 <get_block_size>
  802d1e:	83 c4 04             	add    $0x4,%esp
  802d21:	01 c3                	add    %eax,%ebx
  802d23:	ff 75 0c             	pushl  0xc(%ebp)
  802d26:	e8 4c f1 ff ff       	call   801e77 <get_block_size>
  802d2b:	83 c4 04             	add    $0x4,%esp
  802d2e:	01 d8                	add    %ebx,%eax
  802d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d33:	6a 00                	push   $0x0
  802d35:	ff 75 ec             	pushl  -0x14(%ebp)
  802d38:	ff 75 08             	pushl  0x8(%ebp)
  802d3b:	e8 88 f4 ff ff       	call   8021c8 <set_block_data>
  802d40:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d47:	75 17                	jne    802d60 <merging+0xc8>
  802d49:	83 ec 04             	sub    $0x4,%esp
  802d4c:	68 a7 43 80 00       	push   $0x8043a7
  802d51:	68 7d 01 00 00       	push   $0x17d
  802d56:	68 c5 43 80 00       	push   $0x8043c5
  802d5b:	e8 ec 0b 00 00       	call   80394c <_panic>
  802d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 10                	je     802d79 <merging+0xe1>
  802d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6c:	8b 00                	mov    (%eax),%eax
  802d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d71:	8b 52 04             	mov    0x4(%edx),%edx
  802d74:	89 50 04             	mov    %edx,0x4(%eax)
  802d77:	eb 0b                	jmp    802d84 <merging+0xec>
  802d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7c:	8b 40 04             	mov    0x4(%eax),%eax
  802d7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0f                	je     802d9d <merging+0x105>
  802d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d97:	8b 12                	mov    (%edx),%edx
  802d99:	89 10                	mov    %edx,(%eax)
  802d9b:	eb 0a                	jmp    802da7 <merging+0x10f>
  802d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dba:	a1 38 50 80 00       	mov    0x805038,%eax
  802dbf:	48                   	dec    %eax
  802dc0:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802dc5:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dc6:	e9 ea 02 00 00       	jmp    8030b5 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcf:	74 3b                	je     802e0c <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dd1:	83 ec 0c             	sub    $0xc,%esp
  802dd4:	ff 75 08             	pushl  0x8(%ebp)
  802dd7:	e8 9b f0 ff ff       	call   801e77 <get_block_size>
  802ddc:	83 c4 10             	add    $0x10,%esp
  802ddf:	89 c3                	mov    %eax,%ebx
  802de1:	83 ec 0c             	sub    $0xc,%esp
  802de4:	ff 75 10             	pushl  0x10(%ebp)
  802de7:	e8 8b f0 ff ff       	call   801e77 <get_block_size>
  802dec:	83 c4 10             	add    $0x10,%esp
  802def:	01 d8                	add    %ebx,%eax
  802df1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	6a 00                	push   $0x0
  802df9:	ff 75 e8             	pushl  -0x18(%ebp)
  802dfc:	ff 75 08             	pushl  0x8(%ebp)
  802dff:	e8 c4 f3 ff ff       	call   8021c8 <set_block_data>
  802e04:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e07:	e9 a9 02 00 00       	jmp    8030b5 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e10:	0f 84 2d 01 00 00    	je     802f43 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e16:	83 ec 0c             	sub    $0xc,%esp
  802e19:	ff 75 10             	pushl  0x10(%ebp)
  802e1c:	e8 56 f0 ff ff       	call   801e77 <get_block_size>
  802e21:	83 c4 10             	add    $0x10,%esp
  802e24:	89 c3                	mov    %eax,%ebx
  802e26:	83 ec 0c             	sub    $0xc,%esp
  802e29:	ff 75 0c             	pushl  0xc(%ebp)
  802e2c:	e8 46 f0 ff ff       	call   801e77 <get_block_size>
  802e31:	83 c4 10             	add    $0x10,%esp
  802e34:	01 d8                	add    %ebx,%eax
  802e36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	6a 00                	push   $0x0
  802e3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e41:	ff 75 10             	pushl  0x10(%ebp)
  802e44:	e8 7f f3 ff ff       	call   8021c8 <set_block_data>
  802e49:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e56:	74 06                	je     802e5e <merging+0x1c6>
  802e58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e5c:	75 17                	jne    802e75 <merging+0x1dd>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 80 44 80 00       	push   $0x804480
  802e66:	68 8d 01 00 00       	push   $0x18d
  802e6b:	68 c5 43 80 00       	push   $0x8043c5
  802e70:	e8 d7 0a 00 00       	call   80394c <_panic>
  802e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e78:	8b 50 04             	mov    0x4(%eax),%edx
  802e7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 0d                	je     802ea0 <merging+0x208>
  802e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e96:	8b 40 04             	mov    0x4(%eax),%eax
  802e99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	eb 08                	jmp    802ea8 <merging+0x210>
  802ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb6:	40                   	inc    %eax
  802eb7:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ebc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec0:	75 17                	jne    802ed9 <merging+0x241>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 a7 43 80 00       	push   $0x8043a7
  802eca:	68 8e 01 00 00       	push   $0x18e
  802ecf:	68 c5 43 80 00       	push   $0x8043c5
  802ed4:	e8 73 0a 00 00       	call   80394c <_panic>
  802ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 10                	je     802ef2 <merging+0x25a>
  802ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eea:	8b 52 04             	mov    0x4(%edx),%edx
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	eb 0b                	jmp    802efd <merging+0x265>
  802ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	a3 30 50 80 00       	mov    %eax,0x805030
  802efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 0f                	je     802f16 <merging+0x27e>
  802f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f10:	8b 12                	mov    (%edx),%edx
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	eb 0a                	jmp    802f20 <merging+0x288>
  802f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f33:	a1 38 50 80 00       	mov    0x805038,%eax
  802f38:	48                   	dec    %eax
  802f39:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f3e:	e9 72 01 00 00       	jmp    8030b5 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f43:	8b 45 10             	mov    0x10(%ebp),%eax
  802f46:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4d:	74 79                	je     802fc8 <merging+0x330>
  802f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f53:	74 73                	je     802fc8 <merging+0x330>
  802f55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f59:	74 06                	je     802f61 <merging+0x2c9>
  802f5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f5f:	75 17                	jne    802f78 <merging+0x2e0>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 38 44 80 00       	push   $0x804438
  802f69:	68 94 01 00 00       	push   $0x194
  802f6e:	68 c5 43 80 00       	push   $0x8043c5
  802f73:	e8 d4 09 00 00       	call   80394c <_panic>
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 10                	mov    (%eax),%edx
  802f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	74 0b                	je     802f96 <merging+0x2fe>
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f93:	89 50 04             	mov    %edx,0x4(%eax)
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa4:	89 50 04             	mov    %edx,0x4(%eax)
  802fa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	75 08                	jne    802fb8 <merging+0x320>
  802fb0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb3:	a3 30 50 80 00       	mov    %eax,0x805030
  802fb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fbd:	40                   	inc    %eax
  802fbe:	a3 38 50 80 00       	mov    %eax,0x805038
  802fc3:	e9 ce 00 00 00       	jmp    803096 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fcc:	74 65                	je     803033 <merging+0x39b>
  802fce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fd2:	75 17                	jne    802feb <merging+0x353>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 14 44 80 00       	push   $0x804414
  802fdc:	68 95 01 00 00       	push   $0x195
  802fe1:	68 c5 43 80 00       	push   $0x8043c5
  802fe6:	e8 61 09 00 00       	call   80394c <_panic>
  802feb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ff1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0c                	je     80300d <merging+0x375>
  803001:	a1 30 50 80 00       	mov    0x805030,%eax
  803006:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803009:	89 10                	mov    %edx,(%eax)
  80300b:	eb 08                	jmp    803015 <merging+0x37d>
  80300d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803010:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803015:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803018:	a3 30 50 80 00       	mov    %eax,0x805030
  80301d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	a1 38 50 80 00       	mov    0x805038,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 38 50 80 00       	mov    %eax,0x805038
  803031:	eb 63                	jmp    803096 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803033:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803037:	75 17                	jne    803050 <merging+0x3b8>
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	68 e0 43 80 00       	push   $0x8043e0
  803041:	68 98 01 00 00       	push   $0x198
  803046:	68 c5 43 80 00       	push   $0x8043c5
  80304b:	e8 fc 08 00 00       	call   80394c <_panic>
  803050:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803056:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803059:	89 10                	mov    %edx,(%eax)
  80305b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0d                	je     803071 <merging+0x3d9>
  803064:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803069:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 08                	jmp    803079 <merging+0x3e1>
  803071:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803074:	a3 30 50 80 00       	mov    %eax,0x805030
  803079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 38 50 80 00       	mov    0x805038,%eax
  803090:	40                   	inc    %eax
  803091:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803096:	83 ec 0c             	sub    $0xc,%esp
  803099:	ff 75 10             	pushl  0x10(%ebp)
  80309c:	e8 d6 ed ff ff       	call   801e77 <get_block_size>
  8030a1:	83 c4 10             	add    $0x10,%esp
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	6a 00                	push   $0x0
  8030a9:	50                   	push   %eax
  8030aa:	ff 75 10             	pushl  0x10(%ebp)
  8030ad:	e8 16 f1 ff ff       	call   8021c8 <set_block_data>
  8030b2:	83 c4 10             	add    $0x10,%esp
	}
}
  8030b5:	90                   	nop
  8030b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030b9:	c9                   	leave  
  8030ba:	c3                   	ret    

008030bb <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030bb:	55                   	push   %ebp
  8030bc:	89 e5                	mov    %esp,%ebp
  8030be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8030ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d1:	73 1b                	jae    8030ee <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030d3:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	ff 75 08             	pushl  0x8(%ebp)
  8030de:	6a 00                	push   $0x0
  8030e0:	50                   	push   %eax
  8030e1:	e8 b2 fb ff ff       	call   802c98 <merging>
  8030e6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e9:	e9 8b 00 00 00       	jmp    803179 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f6:	76 18                	jbe    803110 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	ff 75 08             	pushl  0x8(%ebp)
  803103:	50                   	push   %eax
  803104:	6a 00                	push   $0x0
  803106:	e8 8d fb ff ff       	call   802c98 <merging>
  80310b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80310e:	eb 69                	jmp    803179 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803110:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803118:	eb 39                	jmp    803153 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803120:	73 29                	jae    80314b <free_block+0x90>
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312a:	76 1f                	jbe    80314b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	ff 75 08             	pushl  0x8(%ebp)
  80313a:	ff 75 f0             	pushl  -0x10(%ebp)
  80313d:	ff 75 f4             	pushl  -0xc(%ebp)
  803140:	e8 53 fb ff ff       	call   802c98 <merging>
  803145:	83 c4 10             	add    $0x10,%esp
			break;
  803148:	90                   	nop
		}
	}
}
  803149:	eb 2e                	jmp    803179 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80314b:	a1 34 50 80 00       	mov    0x805034,%eax
  803150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803157:	74 07                	je     803160 <free_block+0xa5>
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	eb 05                	jmp    803165 <free_block+0xaa>
  803160:	b8 00 00 00 00       	mov    $0x0,%eax
  803165:	a3 34 50 80 00       	mov    %eax,0x805034
  80316a:	a1 34 50 80 00       	mov    0x805034,%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	75 a7                	jne    80311a <free_block+0x5f>
  803173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803177:	75 a1                	jne    80311a <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803179:	90                   	nop
  80317a:	c9                   	leave  
  80317b:	c3                   	ret    

0080317c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803182:	ff 75 08             	pushl  0x8(%ebp)
  803185:	e8 ed ec ff ff       	call   801e77 <get_block_size>
  80318a:	83 c4 04             	add    $0x4,%esp
  80318d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803197:	eb 17                	jmp    8031b0 <copy_data+0x34>
  803199:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80319c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319f:	01 c2                	add    %eax,%edx
  8031a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	01 c8                	add    %ecx,%eax
  8031a9:	8a 00                	mov    (%eax),%al
  8031ab:	88 02                	mov    %al,(%edx)
  8031ad:	ff 45 fc             	incl   -0x4(%ebp)
  8031b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031b6:	72 e1                	jb     803199 <copy_data+0x1d>
}
  8031b8:	90                   	nop
  8031b9:	c9                   	leave  
  8031ba:	c3                   	ret    

008031bb <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031bb:	55                   	push   %ebp
  8031bc:	89 e5                	mov    %esp,%ebp
  8031be:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c5:	75 23                	jne    8031ea <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031cb:	74 13                	je     8031e0 <realloc_block_FF+0x25>
  8031cd:	83 ec 0c             	sub    $0xc,%esp
  8031d0:	ff 75 0c             	pushl  0xc(%ebp)
  8031d3:	e8 1f f0 ff ff       	call   8021f7 <alloc_block_FF>
  8031d8:	83 c4 10             	add    $0x10,%esp
  8031db:	e9 f4 06 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
		return NULL;
  8031e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e5:	e9 ea 06 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ee:	75 18                	jne    803208 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031f0:	83 ec 0c             	sub    $0xc,%esp
  8031f3:	ff 75 08             	pushl  0x8(%ebp)
  8031f6:	e8 c0 fe ff ff       	call   8030bb <free_block>
  8031fb:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803203:	e9 cc 06 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803208:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80320c:	77 07                	ja     803215 <realloc_block_FF+0x5a>
  80320e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803215:	8b 45 0c             	mov    0xc(%ebp),%eax
  803218:	83 e0 01             	and    $0x1,%eax
  80321b:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80321e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803221:	83 c0 08             	add    $0x8,%eax
  803224:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803227:	83 ec 0c             	sub    $0xc,%esp
  80322a:	ff 75 08             	pushl  0x8(%ebp)
  80322d:	e8 45 ec ff ff       	call   801e77 <get_block_size>
  803232:	83 c4 10             	add    $0x10,%esp
  803235:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	83 e8 08             	sub    $0x8,%eax
  80323e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	83 e8 04             	sub    $0x4,%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	83 e0 fe             	and    $0xfffffffe,%eax
  80324c:	89 c2                	mov    %eax,%edx
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	01 d0                	add    %edx,%eax
  803253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803256:	83 ec 0c             	sub    $0xc,%esp
  803259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80325c:	e8 16 ec ff ff       	call   801e77 <get_block_size>
  803261:	83 c4 10             	add    $0x10,%esp
  803264:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326a:	83 e8 08             	sub    $0x8,%eax
  80326d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803270:	8b 45 0c             	mov    0xc(%ebp),%eax
  803273:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803276:	75 08                	jne    803280 <realloc_block_FF+0xc5>
	{
		 return va;
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	e9 54 06 00 00       	jmp    8038d4 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803280:	8b 45 0c             	mov    0xc(%ebp),%eax
  803283:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803286:	0f 83 e5 03 00 00    	jae    803671 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803292:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803295:	83 ec 0c             	sub    $0xc,%esp
  803298:	ff 75 e4             	pushl  -0x1c(%ebp)
  80329b:	e8 f0 eb ff ff       	call   801e90 <is_free_block>
  8032a0:	83 c4 10             	add    $0x10,%esp
  8032a3:	84 c0                	test   %al,%al
  8032a5:	0f 84 3b 01 00 00    	je     8033e6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032b1:	01 d0                	add    %edx,%eax
  8032b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	6a 01                	push   $0x1
  8032bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8032be:	ff 75 08             	pushl  0x8(%ebp)
  8032c1:	e8 02 ef ff ff       	call   8021c8 <set_block_data>
  8032c6:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	83 e8 04             	sub    $0x4,%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8032d4:	89 c2                	mov    %eax,%edx
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	01 d0                	add    %edx,%eax
  8032db:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	6a 00                	push   $0x0
  8032e3:	ff 75 cc             	pushl  -0x34(%ebp)
  8032e6:	ff 75 c8             	pushl  -0x38(%ebp)
  8032e9:	e8 da ee ff ff       	call   8021c8 <set_block_data>
  8032ee:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f5:	74 06                	je     8032fd <realloc_block_FF+0x142>
  8032f7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032fb:	75 17                	jne    803314 <realloc_block_FF+0x159>
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 38 44 80 00       	push   $0x804438
  803305:	68 f6 01 00 00       	push   $0x1f6
  80330a:	68 c5 43 80 00       	push   $0x8043c5
  80330f:	e8 38 06 00 00       	call   80394c <_panic>
  803314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803317:	8b 10                	mov    (%eax),%edx
  803319:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0b                	je     803332 <realloc_block_FF+0x177>
  803327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803335:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80333d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	75 08                	jne    803354 <realloc_block_FF+0x199>
  80334c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80334f:	a3 30 50 80 00       	mov    %eax,0x805030
  803354:	a1 38 50 80 00       	mov    0x805038,%eax
  803359:	40                   	inc    %eax
  80335a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80335f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803363:	75 17                	jne    80337c <realloc_block_FF+0x1c1>
  803365:	83 ec 04             	sub    $0x4,%esp
  803368:	68 a7 43 80 00       	push   $0x8043a7
  80336d:	68 f7 01 00 00       	push   $0x1f7
  803372:	68 c5 43 80 00       	push   $0x8043c5
  803377:	e8 d0 05 00 00       	call   80394c <_panic>
  80337c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337f:	8b 00                	mov    (%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 10                	je     803395 <realloc_block_FF+0x1da>
  803385:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80338d:	8b 52 04             	mov    0x4(%edx),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	eb 0b                	jmp    8033a0 <realloc_block_FF+0x1e5>
  803395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803398:	8b 40 04             	mov    0x4(%eax),%eax
  80339b:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a3:	8b 40 04             	mov    0x4(%eax),%eax
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	74 0f                	je     8033b9 <realloc_block_FF+0x1fe>
  8033aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ad:	8b 40 04             	mov    0x4(%eax),%eax
  8033b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b3:	8b 12                	mov    (%edx),%edx
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	eb 0a                	jmp    8033c3 <realloc_block_FF+0x208>
  8033b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033db:	48                   	dec    %eax
  8033dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8033e1:	e9 83 02 00 00       	jmp    803669 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033e6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033ea:	0f 86 69 02 00 00    	jbe    803659 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	6a 01                	push   $0x1
  8033f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8033f8:	ff 75 08             	pushl  0x8(%ebp)
  8033fb:	e8 c8 ed ff ff       	call   8021c8 <set_block_data>
  803400:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	83 e8 04             	sub    $0x4,%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	83 e0 fe             	and    $0xfffffffe,%eax
  80340e:	89 c2                	mov    %eax,%edx
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	01 d0                	add    %edx,%eax
  803415:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803418:	a1 38 50 80 00       	mov    0x805038,%eax
  80341d:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803420:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803424:	75 68                	jne    80348e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803426:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80342a:	75 17                	jne    803443 <realloc_block_FF+0x288>
  80342c:	83 ec 04             	sub    $0x4,%esp
  80342f:	68 e0 43 80 00       	push   $0x8043e0
  803434:	68 06 02 00 00       	push   $0x206
  803439:	68 c5 43 80 00       	push   $0x8043c5
  80343e:	e8 09 05 00 00       	call   80394c <_panic>
  803443:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803449:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 0d                	je     803464 <realloc_block_FF+0x2a9>
  803457:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80345c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345f:	89 50 04             	mov    %edx,0x4(%eax)
  803462:	eb 08                	jmp    80346c <realloc_block_FF+0x2b1>
  803464:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803467:	a3 30 50 80 00       	mov    %eax,0x805030
  80346c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803474:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347e:	a1 38 50 80 00       	mov    0x805038,%eax
  803483:	40                   	inc    %eax
  803484:	a3 38 50 80 00       	mov    %eax,0x805038
  803489:	e9 b0 01 00 00       	jmp    80363e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80348e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803493:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803496:	76 68                	jbe    803500 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803498:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349c:	75 17                	jne    8034b5 <realloc_block_FF+0x2fa>
  80349e:	83 ec 04             	sub    $0x4,%esp
  8034a1:	68 e0 43 80 00       	push   $0x8043e0
  8034a6:	68 0b 02 00 00       	push   $0x20b
  8034ab:	68 c5 43 80 00       	push   $0x8043c5
  8034b0:	e8 97 04 00 00       	call   80394c <_panic>
  8034b5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0d                	je     8034d6 <realloc_block_FF+0x31b>
  8034c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d1:	89 50 04             	mov    %edx,0x4(%eax)
  8034d4:	eb 08                	jmp    8034de <realloc_block_FF+0x323>
  8034d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f5:	40                   	inc    %eax
  8034f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8034fb:	e9 3e 01 00 00       	jmp    80363e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803500:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803505:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803508:	73 68                	jae    803572 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80350a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80350e:	75 17                	jne    803527 <realloc_block_FF+0x36c>
  803510:	83 ec 04             	sub    $0x4,%esp
  803513:	68 14 44 80 00       	push   $0x804414
  803518:	68 10 02 00 00       	push   $0x210
  80351d:	68 c5 43 80 00       	push   $0x8043c5
  803522:	e8 25 04 00 00       	call   80394c <_panic>
  803527:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80352d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803530:	89 50 04             	mov    %edx,0x4(%eax)
  803533:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0c                	je     803549 <realloc_block_FF+0x38e>
  80353d:	a1 30 50 80 00       	mov    0x805030,%eax
  803542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803545:	89 10                	mov    %edx,(%eax)
  803547:	eb 08                	jmp    803551 <realloc_block_FF+0x396>
  803549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	a3 30 50 80 00       	mov    %eax,0x805030
  803559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803562:	a1 38 50 80 00       	mov    0x805038,%eax
  803567:	40                   	inc    %eax
  803568:	a3 38 50 80 00       	mov    %eax,0x805038
  80356d:	e9 cc 00 00 00       	jmp    80363e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803579:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80357e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803581:	e9 8a 00 00 00       	jmp    803610 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80358c:	73 7a                	jae    803608 <realloc_block_FF+0x44d>
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803596:	73 70                	jae    803608 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359c:	74 06                	je     8035a4 <realloc_block_FF+0x3e9>
  80359e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035a2:	75 17                	jne    8035bb <realloc_block_FF+0x400>
  8035a4:	83 ec 04             	sub    $0x4,%esp
  8035a7:	68 38 44 80 00       	push   $0x804438
  8035ac:	68 1a 02 00 00       	push   $0x21a
  8035b1:	68 c5 43 80 00       	push   $0x8043c5
  8035b6:	e8 91 03 00 00       	call   80394c <_panic>
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	8b 10                	mov    (%eax),%edx
  8035c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c3:	89 10                	mov    %edx,(%eax)
  8035c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 0b                	je     8035d9 <realloc_block_FF+0x41e>
  8035ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035df:	89 10                	mov    %edx,(%eax)
  8035e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	75 08                	jne    8035fb <realloc_block_FF+0x440>
  8035f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803600:	40                   	inc    %eax
  803601:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803606:	eb 36                	jmp    80363e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803608:	a1 34 50 80 00       	mov    0x805034,%eax
  80360d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803614:	74 07                	je     80361d <realloc_block_FF+0x462>
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	eb 05                	jmp    803622 <realloc_block_FF+0x467>
  80361d:	b8 00 00 00 00       	mov    $0x0,%eax
  803622:	a3 34 50 80 00       	mov    %eax,0x805034
  803627:	a1 34 50 80 00       	mov    0x805034,%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	0f 85 52 ff ff ff    	jne    803586 <realloc_block_FF+0x3cb>
  803634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803638:	0f 85 48 ff ff ff    	jne    803586 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80363e:	83 ec 04             	sub    $0x4,%esp
  803641:	6a 00                	push   $0x0
  803643:	ff 75 d8             	pushl  -0x28(%ebp)
  803646:	ff 75 d4             	pushl  -0x2c(%ebp)
  803649:	e8 7a eb ff ff       	call   8021c8 <set_block_data>
  80364e:	83 c4 10             	add    $0x10,%esp
				return va;
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	e9 7b 02 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803659:	83 ec 0c             	sub    $0xc,%esp
  80365c:	68 b5 44 80 00       	push   $0x8044b5
  803661:	e8 24 cd ff ff       	call   80038a <cprintf>
  803666:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	e9 63 02 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803671:	8b 45 0c             	mov    0xc(%ebp),%eax
  803674:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803677:	0f 86 4d 02 00 00    	jbe    8038ca <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80367d:	83 ec 0c             	sub    $0xc,%esp
  803680:	ff 75 e4             	pushl  -0x1c(%ebp)
  803683:	e8 08 e8 ff ff       	call   801e90 <is_free_block>
  803688:	83 c4 10             	add    $0x10,%esp
  80368b:	84 c0                	test   %al,%al
  80368d:	0f 84 37 02 00 00    	je     8038ca <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803693:	8b 45 0c             	mov    0xc(%ebp),%eax
  803696:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803699:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80369c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80369f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036a2:	76 38                	jbe    8036dc <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036a4:	83 ec 0c             	sub    $0xc,%esp
  8036a7:	ff 75 08             	pushl  0x8(%ebp)
  8036aa:	e8 0c fa ff ff       	call   8030bb <free_block>
  8036af:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036b2:	83 ec 0c             	sub    $0xc,%esp
  8036b5:	ff 75 0c             	pushl  0xc(%ebp)
  8036b8:	e8 3a eb ff ff       	call   8021f7 <alloc_block_FF>
  8036bd:	83 c4 10             	add    $0x10,%esp
  8036c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036c3:	83 ec 08             	sub    $0x8,%esp
  8036c6:	ff 75 c0             	pushl  -0x40(%ebp)
  8036c9:	ff 75 08             	pushl  0x8(%ebp)
  8036cc:	e8 ab fa ff ff       	call   80317c <copy_data>
  8036d1:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036d4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036d7:	e9 f8 01 00 00       	jmp    8038d4 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036df:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036e5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036e9:	0f 87 a0 00 00 00    	ja     80378f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036f3:	75 17                	jne    80370c <realloc_block_FF+0x551>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 a7 43 80 00       	push   $0x8043a7
  8036fd:	68 38 02 00 00       	push   $0x238
  803702:	68 c5 43 80 00       	push   $0x8043c5
  803707:	e8 40 02 00 00       	call   80394c <_panic>
  80370c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 10                	je     803725 <realloc_block_FF+0x56a>
  803715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80371d:	8b 52 04             	mov    0x4(%edx),%edx
  803720:	89 50 04             	mov    %edx,0x4(%eax)
  803723:	eb 0b                	jmp    803730 <realloc_block_FF+0x575>
  803725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	a3 30 50 80 00       	mov    %eax,0x805030
  803730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0f                	je     803749 <realloc_block_FF+0x58e>
  80373a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803743:	8b 12                	mov    (%edx),%edx
  803745:	89 10                	mov    %edx,(%eax)
  803747:	eb 0a                	jmp    803753 <realloc_block_FF+0x598>
  803749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803766:	a1 38 50 80 00       	mov    0x805038,%eax
  80376b:	48                   	dec    %eax
  80376c:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803771:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803777:	01 d0                	add    %edx,%eax
  803779:	83 ec 04             	sub    $0x4,%esp
  80377c:	6a 01                	push   $0x1
  80377e:	50                   	push   %eax
  80377f:	ff 75 08             	pushl  0x8(%ebp)
  803782:	e8 41 ea ff ff       	call   8021c8 <set_block_data>
  803787:	83 c4 10             	add    $0x10,%esp
  80378a:	e9 36 01 00 00       	jmp    8038c5 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80378f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803792:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803795:	01 d0                	add    %edx,%eax
  803797:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80379a:	83 ec 04             	sub    $0x4,%esp
  80379d:	6a 01                	push   $0x1
  80379f:	ff 75 f0             	pushl  -0x10(%ebp)
  8037a2:	ff 75 08             	pushl  0x8(%ebp)
  8037a5:	e8 1e ea ff ff       	call   8021c8 <set_block_data>
  8037aa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	83 e8 04             	sub    $0x4,%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8037b8:	89 c2                	mov    %eax,%edx
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	01 d0                	add    %edx,%eax
  8037bf:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c6:	74 06                	je     8037ce <realloc_block_FF+0x613>
  8037c8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037cc:	75 17                	jne    8037e5 <realloc_block_FF+0x62a>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 38 44 80 00       	push   $0x804438
  8037d6:	68 44 02 00 00       	push   $0x244
  8037db:	68 c5 43 80 00       	push   $0x8043c5
  8037e0:	e8 67 01 00 00       	call   80394c <_panic>
  8037e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e8:	8b 10                	mov    (%eax),%edx
  8037ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0b                	je     803803 <realloc_block_FF+0x648>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803809:	89 10                	mov    %edx,(%eax)
  80380b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80380e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803811:	89 50 04             	mov    %edx,0x4(%eax)
  803814:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	85 c0                	test   %eax,%eax
  80381b:	75 08                	jne    803825 <realloc_block_FF+0x66a>
  80381d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803820:	a3 30 50 80 00       	mov    %eax,0x805030
  803825:	a1 38 50 80 00       	mov    0x805038,%eax
  80382a:	40                   	inc    %eax
  80382b:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803834:	75 17                	jne    80384d <realloc_block_FF+0x692>
  803836:	83 ec 04             	sub    $0x4,%esp
  803839:	68 a7 43 80 00       	push   $0x8043a7
  80383e:	68 45 02 00 00       	push   $0x245
  803843:	68 c5 43 80 00       	push   $0x8043c5
  803848:	e8 ff 00 00 00       	call   80394c <_panic>
  80384d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	74 10                	je     803866 <realloc_block_FF+0x6ab>
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	8b 00                	mov    (%eax),%eax
  80385b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385e:	8b 52 04             	mov    0x4(%edx),%edx
  803861:	89 50 04             	mov    %edx,0x4(%eax)
  803864:	eb 0b                	jmp    803871 <realloc_block_FF+0x6b6>
  803866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	a3 30 50 80 00       	mov    %eax,0x805030
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 40 04             	mov    0x4(%eax),%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	74 0f                	je     80388a <realloc_block_FF+0x6cf>
  80387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387e:	8b 40 04             	mov    0x4(%eax),%eax
  803881:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803884:	8b 12                	mov    (%edx),%edx
  803886:	89 10                	mov    %edx,(%eax)
  803888:	eb 0a                	jmp    803894 <realloc_block_FF+0x6d9>
  80388a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ac:	48                   	dec    %eax
  8038ad:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038b2:	83 ec 04             	sub    $0x4,%esp
  8038b5:	6a 00                	push   $0x0
  8038b7:	ff 75 bc             	pushl  -0x44(%ebp)
  8038ba:	ff 75 b8             	pushl  -0x48(%ebp)
  8038bd:	e8 06 e9 ff ff       	call   8021c8 <set_block_data>
  8038c2:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	eb 0a                	jmp    8038d4 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038ca:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038d4:	c9                   	leave  
  8038d5:	c3                   	ret    

008038d6 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038d6:	55                   	push   %ebp
  8038d7:	89 e5                	mov    %esp,%ebp
  8038d9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038dc:	83 ec 04             	sub    $0x4,%esp
  8038df:	68 bc 44 80 00       	push   $0x8044bc
  8038e4:	68 58 02 00 00       	push   $0x258
  8038e9:	68 c5 43 80 00       	push   $0x8043c5
  8038ee:	e8 59 00 00 00       	call   80394c <_panic>

008038f3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038f3:	55                   	push   %ebp
  8038f4:	89 e5                	mov    %esp,%ebp
  8038f6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	68 e4 44 80 00       	push   $0x8044e4
  803901:	68 61 02 00 00       	push   $0x261
  803906:	68 c5 43 80 00       	push   $0x8043c5
  80390b:	e8 3c 00 00 00       	call   80394c <_panic>

00803910 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803910:	55                   	push   %ebp
  803911:	89 e5                	mov    %esp,%ebp
  803913:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803916:	8b 45 08             	mov    0x8(%ebp),%eax
  803919:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80391c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803920:	83 ec 0c             	sub    $0xc,%esp
  803923:	50                   	push   %eax
  803924:	e8 dd e0 ff ff       	call   801a06 <sys_cputc>
  803929:	83 c4 10             	add    $0x10,%esp
}
  80392c:	90                   	nop
  80392d:	c9                   	leave  
  80392e:	c3                   	ret    

0080392f <getchar>:


int
getchar(void)
{
  80392f:	55                   	push   %ebp
  803930:	89 e5                	mov    %esp,%ebp
  803932:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803935:	e8 68 df ff ff       	call   8018a2 <sys_cgetc>
  80393a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80393d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803940:	c9                   	leave  
  803941:	c3                   	ret    

00803942 <iscons>:

int iscons(int fdnum)
{
  803942:	55                   	push   %ebp
  803943:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803945:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    

0080394c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80394c:	55                   	push   %ebp
  80394d:	89 e5                	mov    %esp,%ebp
  80394f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803952:	8d 45 10             	lea    0x10(%ebp),%eax
  803955:	83 c0 04             	add    $0x4,%eax
  803958:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80395b:	a1 60 50 98 00       	mov    0x985060,%eax
  803960:	85 c0                	test   %eax,%eax
  803962:	74 16                	je     80397a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803964:	a1 60 50 98 00       	mov    0x985060,%eax
  803969:	83 ec 08             	sub    $0x8,%esp
  80396c:	50                   	push   %eax
  80396d:	68 0c 45 80 00       	push   $0x80450c
  803972:	e8 13 ca ff ff       	call   80038a <cprintf>
  803977:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80397a:	a1 00 50 80 00       	mov    0x805000,%eax
  80397f:	ff 75 0c             	pushl  0xc(%ebp)
  803982:	ff 75 08             	pushl  0x8(%ebp)
  803985:	50                   	push   %eax
  803986:	68 11 45 80 00       	push   $0x804511
  80398b:	e8 fa c9 ff ff       	call   80038a <cprintf>
  803990:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803993:	8b 45 10             	mov    0x10(%ebp),%eax
  803996:	83 ec 08             	sub    $0x8,%esp
  803999:	ff 75 f4             	pushl  -0xc(%ebp)
  80399c:	50                   	push   %eax
  80399d:	e8 7d c9 ff ff       	call   80031f <vcprintf>
  8039a2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039a5:	83 ec 08             	sub    $0x8,%esp
  8039a8:	6a 00                	push   $0x0
  8039aa:	68 2d 45 80 00       	push   $0x80452d
  8039af:	e8 6b c9 ff ff       	call   80031f <vcprintf>
  8039b4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039b7:	e8 ec c8 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  8039bc:	eb fe                	jmp    8039bc <_panic+0x70>

008039be <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039be:	55                   	push   %ebp
  8039bf:	89 e5                	mov    %esp,%ebp
  8039c1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8039c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d2:	39 c2                	cmp    %eax,%edx
  8039d4:	74 14                	je     8039ea <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039d6:	83 ec 04             	sub    $0x4,%esp
  8039d9:	68 30 45 80 00       	push   $0x804530
  8039de:	6a 26                	push   $0x26
  8039e0:	68 7c 45 80 00       	push   $0x80457c
  8039e5:	e8 62 ff ff ff       	call   80394c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039f8:	e9 c5 00 00 00       	jmp    803ac2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	01 d0                	add    %edx,%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	75 08                	jne    803a1a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a12:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a15:	e9 a5 00 00 00       	jmp    803abf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a28:	eb 69                	jmp    803a93 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a2a:	a1 20 50 80 00       	mov    0x805020,%eax
  803a2f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a38:	89 d0                	mov    %edx,%eax
  803a3a:	01 c0                	add    %eax,%eax
  803a3c:	01 d0                	add    %edx,%eax
  803a3e:	c1 e0 03             	shl    $0x3,%eax
  803a41:	01 c8                	add    %ecx,%eax
  803a43:	8a 40 04             	mov    0x4(%eax),%al
  803a46:	84 c0                	test   %al,%al
  803a48:	75 46                	jne    803a90 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a4a:	a1 20 50 80 00       	mov    0x805020,%eax
  803a4f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a58:	89 d0                	mov    %edx,%eax
  803a5a:	01 c0                	add    %eax,%eax
  803a5c:	01 d0                	add    %edx,%eax
  803a5e:	c1 e0 03             	shl    $0x3,%eax
  803a61:	01 c8                	add    %ecx,%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a70:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a75:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	01 c8                	add    %ecx,%eax
  803a81:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a83:	39 c2                	cmp    %eax,%edx
  803a85:	75 09                	jne    803a90 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a87:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a8e:	eb 15                	jmp    803aa5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a90:	ff 45 e8             	incl   -0x18(%ebp)
  803a93:	a1 20 50 80 00       	mov    0x805020,%eax
  803a98:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa1:	39 c2                	cmp    %eax,%edx
  803aa3:	77 85                	ja     803a2a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803aa9:	75 14                	jne    803abf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803aab:	83 ec 04             	sub    $0x4,%esp
  803aae:	68 88 45 80 00       	push   $0x804588
  803ab3:	6a 3a                	push   $0x3a
  803ab5:	68 7c 45 80 00       	push   $0x80457c
  803aba:	e8 8d fe ff ff       	call   80394c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803abf:	ff 45 f0             	incl   -0x10(%ebp)
  803ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ac8:	0f 8c 2f ff ff ff    	jl     8039fd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ace:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ad5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803adc:	eb 26                	jmp    803b04 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ade:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ae9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aec:	89 d0                	mov    %edx,%eax
  803aee:	01 c0                	add    %eax,%eax
  803af0:	01 d0                	add    %edx,%eax
  803af2:	c1 e0 03             	shl    $0x3,%eax
  803af5:	01 c8                	add    %ecx,%eax
  803af7:	8a 40 04             	mov    0x4(%eax),%al
  803afa:	3c 01                	cmp    $0x1,%al
  803afc:	75 03                	jne    803b01 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803afe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b01:	ff 45 e0             	incl   -0x20(%ebp)
  803b04:	a1 20 50 80 00       	mov    0x805020,%eax
  803b09:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b12:	39 c2                	cmp    %eax,%edx
  803b14:	77 c8                	ja     803ade <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b19:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b1c:	74 14                	je     803b32 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b1e:	83 ec 04             	sub    $0x4,%esp
  803b21:	68 dc 45 80 00       	push   $0x8045dc
  803b26:	6a 44                	push   $0x44
  803b28:	68 7c 45 80 00       	push   $0x80457c
  803b2d:	e8 1a fe ff ff       	call   80394c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b32:	90                   	nop
  803b33:	c9                   	leave  
  803b34:	c3                   	ret    
  803b35:	66 90                	xchg   %ax,%ax
  803b37:	90                   	nop

00803b38 <__udivdi3>:
  803b38:	55                   	push   %ebp
  803b39:	57                   	push   %edi
  803b3a:	56                   	push   %esi
  803b3b:	53                   	push   %ebx
  803b3c:	83 ec 1c             	sub    $0x1c,%esp
  803b3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b4f:	89 ca                	mov    %ecx,%edx
  803b51:	89 f8                	mov    %edi,%eax
  803b53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b57:	85 f6                	test   %esi,%esi
  803b59:	75 2d                	jne    803b88 <__udivdi3+0x50>
  803b5b:	39 cf                	cmp    %ecx,%edi
  803b5d:	77 65                	ja     803bc4 <__udivdi3+0x8c>
  803b5f:	89 fd                	mov    %edi,%ebp
  803b61:	85 ff                	test   %edi,%edi
  803b63:	75 0b                	jne    803b70 <__udivdi3+0x38>
  803b65:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6a:	31 d2                	xor    %edx,%edx
  803b6c:	f7 f7                	div    %edi
  803b6e:	89 c5                	mov    %eax,%ebp
  803b70:	31 d2                	xor    %edx,%edx
  803b72:	89 c8                	mov    %ecx,%eax
  803b74:	f7 f5                	div    %ebp
  803b76:	89 c1                	mov    %eax,%ecx
  803b78:	89 d8                	mov    %ebx,%eax
  803b7a:	f7 f5                	div    %ebp
  803b7c:	89 cf                	mov    %ecx,%edi
  803b7e:	89 fa                	mov    %edi,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	39 ce                	cmp    %ecx,%esi
  803b8a:	77 28                	ja     803bb4 <__udivdi3+0x7c>
  803b8c:	0f bd fe             	bsr    %esi,%edi
  803b8f:	83 f7 1f             	xor    $0x1f,%edi
  803b92:	75 40                	jne    803bd4 <__udivdi3+0x9c>
  803b94:	39 ce                	cmp    %ecx,%esi
  803b96:	72 0a                	jb     803ba2 <__udivdi3+0x6a>
  803b98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b9c:	0f 87 9e 00 00 00    	ja     803c40 <__udivdi3+0x108>
  803ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba7:	89 fa                	mov    %edi,%edx
  803ba9:	83 c4 1c             	add    $0x1c,%esp
  803bac:	5b                   	pop    %ebx
  803bad:	5e                   	pop    %esi
  803bae:	5f                   	pop    %edi
  803baf:	5d                   	pop    %ebp
  803bb0:	c3                   	ret    
  803bb1:	8d 76 00             	lea    0x0(%esi),%esi
  803bb4:	31 ff                	xor    %edi,%edi
  803bb6:	31 c0                	xor    %eax,%eax
  803bb8:	89 fa                	mov    %edi,%edx
  803bba:	83 c4 1c             	add    $0x1c,%esp
  803bbd:	5b                   	pop    %ebx
  803bbe:	5e                   	pop    %esi
  803bbf:	5f                   	pop    %edi
  803bc0:	5d                   	pop    %ebp
  803bc1:	c3                   	ret    
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	89 d8                	mov    %ebx,%eax
  803bc6:	f7 f7                	div    %edi
  803bc8:	31 ff                	xor    %edi,%edi
  803bca:	89 fa                	mov    %edi,%edx
  803bcc:	83 c4 1c             	add    $0x1c,%esp
  803bcf:	5b                   	pop    %ebx
  803bd0:	5e                   	pop    %esi
  803bd1:	5f                   	pop    %edi
  803bd2:	5d                   	pop    %ebp
  803bd3:	c3                   	ret    
  803bd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bd9:	89 eb                	mov    %ebp,%ebx
  803bdb:	29 fb                	sub    %edi,%ebx
  803bdd:	89 f9                	mov    %edi,%ecx
  803bdf:	d3 e6                	shl    %cl,%esi
  803be1:	89 c5                	mov    %eax,%ebp
  803be3:	88 d9                	mov    %bl,%cl
  803be5:	d3 ed                	shr    %cl,%ebp
  803be7:	89 e9                	mov    %ebp,%ecx
  803be9:	09 f1                	or     %esi,%ecx
  803beb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bef:	89 f9                	mov    %edi,%ecx
  803bf1:	d3 e0                	shl    %cl,%eax
  803bf3:	89 c5                	mov    %eax,%ebp
  803bf5:	89 d6                	mov    %edx,%esi
  803bf7:	88 d9                	mov    %bl,%cl
  803bf9:	d3 ee                	shr    %cl,%esi
  803bfb:	89 f9                	mov    %edi,%ecx
  803bfd:	d3 e2                	shl    %cl,%edx
  803bff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c03:	88 d9                	mov    %bl,%cl
  803c05:	d3 e8                	shr    %cl,%eax
  803c07:	09 c2                	or     %eax,%edx
  803c09:	89 d0                	mov    %edx,%eax
  803c0b:	89 f2                	mov    %esi,%edx
  803c0d:	f7 74 24 0c          	divl   0xc(%esp)
  803c11:	89 d6                	mov    %edx,%esi
  803c13:	89 c3                	mov    %eax,%ebx
  803c15:	f7 e5                	mul    %ebp
  803c17:	39 d6                	cmp    %edx,%esi
  803c19:	72 19                	jb     803c34 <__udivdi3+0xfc>
  803c1b:	74 0b                	je     803c28 <__udivdi3+0xf0>
  803c1d:	89 d8                	mov    %ebx,%eax
  803c1f:	31 ff                	xor    %edi,%edi
  803c21:	e9 58 ff ff ff       	jmp    803b7e <__udivdi3+0x46>
  803c26:	66 90                	xchg   %ax,%ax
  803c28:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c2c:	89 f9                	mov    %edi,%ecx
  803c2e:	d3 e2                	shl    %cl,%edx
  803c30:	39 c2                	cmp    %eax,%edx
  803c32:	73 e9                	jae    803c1d <__udivdi3+0xe5>
  803c34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c37:	31 ff                	xor    %edi,%edi
  803c39:	e9 40 ff ff ff       	jmp    803b7e <__udivdi3+0x46>
  803c3e:	66 90                	xchg   %ax,%ax
  803c40:	31 c0                	xor    %eax,%eax
  803c42:	e9 37 ff ff ff       	jmp    803b7e <__udivdi3+0x46>
  803c47:	90                   	nop

00803c48 <__umoddi3>:
  803c48:	55                   	push   %ebp
  803c49:	57                   	push   %edi
  803c4a:	56                   	push   %esi
  803c4b:	53                   	push   %ebx
  803c4c:	83 ec 1c             	sub    $0x1c,%esp
  803c4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c53:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c67:	89 f3                	mov    %esi,%ebx
  803c69:	89 fa                	mov    %edi,%edx
  803c6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c6f:	89 34 24             	mov    %esi,(%esp)
  803c72:	85 c0                	test   %eax,%eax
  803c74:	75 1a                	jne    803c90 <__umoddi3+0x48>
  803c76:	39 f7                	cmp    %esi,%edi
  803c78:	0f 86 a2 00 00 00    	jbe    803d20 <__umoddi3+0xd8>
  803c7e:	89 c8                	mov    %ecx,%eax
  803c80:	89 f2                	mov    %esi,%edx
  803c82:	f7 f7                	div    %edi
  803c84:	89 d0                	mov    %edx,%eax
  803c86:	31 d2                	xor    %edx,%edx
  803c88:	83 c4 1c             	add    $0x1c,%esp
  803c8b:	5b                   	pop    %ebx
  803c8c:	5e                   	pop    %esi
  803c8d:	5f                   	pop    %edi
  803c8e:	5d                   	pop    %ebp
  803c8f:	c3                   	ret    
  803c90:	39 f0                	cmp    %esi,%eax
  803c92:	0f 87 ac 00 00 00    	ja     803d44 <__umoddi3+0xfc>
  803c98:	0f bd e8             	bsr    %eax,%ebp
  803c9b:	83 f5 1f             	xor    $0x1f,%ebp
  803c9e:	0f 84 ac 00 00 00    	je     803d50 <__umoddi3+0x108>
  803ca4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ca9:	29 ef                	sub    %ebp,%edi
  803cab:	89 fe                	mov    %edi,%esi
  803cad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 e0                	shl    %cl,%eax
  803cb5:	89 d7                	mov    %edx,%edi
  803cb7:	89 f1                	mov    %esi,%ecx
  803cb9:	d3 ef                	shr    %cl,%edi
  803cbb:	09 c7                	or     %eax,%edi
  803cbd:	89 e9                	mov    %ebp,%ecx
  803cbf:	d3 e2                	shl    %cl,%edx
  803cc1:	89 14 24             	mov    %edx,(%esp)
  803cc4:	89 d8                	mov    %ebx,%eax
  803cc6:	d3 e0                	shl    %cl,%eax
  803cc8:	89 c2                	mov    %eax,%edx
  803cca:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cce:	d3 e0                	shl    %cl,%eax
  803cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cd8:	89 f1                	mov    %esi,%ecx
  803cda:	d3 e8                	shr    %cl,%eax
  803cdc:	09 d0                	or     %edx,%eax
  803cde:	d3 eb                	shr    %cl,%ebx
  803ce0:	89 da                	mov    %ebx,%edx
  803ce2:	f7 f7                	div    %edi
  803ce4:	89 d3                	mov    %edx,%ebx
  803ce6:	f7 24 24             	mull   (%esp)
  803ce9:	89 c6                	mov    %eax,%esi
  803ceb:	89 d1                	mov    %edx,%ecx
  803ced:	39 d3                	cmp    %edx,%ebx
  803cef:	0f 82 87 00 00 00    	jb     803d7c <__umoddi3+0x134>
  803cf5:	0f 84 91 00 00 00    	je     803d8c <__umoddi3+0x144>
  803cfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cff:	29 f2                	sub    %esi,%edx
  803d01:	19 cb                	sbb    %ecx,%ebx
  803d03:	89 d8                	mov    %ebx,%eax
  803d05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d09:	d3 e0                	shl    %cl,%eax
  803d0b:	89 e9                	mov    %ebp,%ecx
  803d0d:	d3 ea                	shr    %cl,%edx
  803d0f:	09 d0                	or     %edx,%eax
  803d11:	89 e9                	mov    %ebp,%ecx
  803d13:	d3 eb                	shr    %cl,%ebx
  803d15:	89 da                	mov    %ebx,%edx
  803d17:	83 c4 1c             	add    $0x1c,%esp
  803d1a:	5b                   	pop    %ebx
  803d1b:	5e                   	pop    %esi
  803d1c:	5f                   	pop    %edi
  803d1d:	5d                   	pop    %ebp
  803d1e:	c3                   	ret    
  803d1f:	90                   	nop
  803d20:	89 fd                	mov    %edi,%ebp
  803d22:	85 ff                	test   %edi,%edi
  803d24:	75 0b                	jne    803d31 <__umoddi3+0xe9>
  803d26:	b8 01 00 00 00       	mov    $0x1,%eax
  803d2b:	31 d2                	xor    %edx,%edx
  803d2d:	f7 f7                	div    %edi
  803d2f:	89 c5                	mov    %eax,%ebp
  803d31:	89 f0                	mov    %esi,%eax
  803d33:	31 d2                	xor    %edx,%edx
  803d35:	f7 f5                	div    %ebp
  803d37:	89 c8                	mov    %ecx,%eax
  803d39:	f7 f5                	div    %ebp
  803d3b:	89 d0                	mov    %edx,%eax
  803d3d:	e9 44 ff ff ff       	jmp    803c86 <__umoddi3+0x3e>
  803d42:	66 90                	xchg   %ax,%ax
  803d44:	89 c8                	mov    %ecx,%eax
  803d46:	89 f2                	mov    %esi,%edx
  803d48:	83 c4 1c             	add    $0x1c,%esp
  803d4b:	5b                   	pop    %ebx
  803d4c:	5e                   	pop    %esi
  803d4d:	5f                   	pop    %edi
  803d4e:	5d                   	pop    %ebp
  803d4f:	c3                   	ret    
  803d50:	3b 04 24             	cmp    (%esp),%eax
  803d53:	72 06                	jb     803d5b <__umoddi3+0x113>
  803d55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d59:	77 0f                	ja     803d6a <__umoddi3+0x122>
  803d5b:	89 f2                	mov    %esi,%edx
  803d5d:	29 f9                	sub    %edi,%ecx
  803d5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d63:	89 14 24             	mov    %edx,(%esp)
  803d66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d6e:	8b 14 24             	mov    (%esp),%edx
  803d71:	83 c4 1c             	add    $0x1c,%esp
  803d74:	5b                   	pop    %ebx
  803d75:	5e                   	pop    %esi
  803d76:	5f                   	pop    %edi
  803d77:	5d                   	pop    %ebp
  803d78:	c3                   	ret    
  803d79:	8d 76 00             	lea    0x0(%esi),%esi
  803d7c:	2b 04 24             	sub    (%esp),%eax
  803d7f:	19 fa                	sbb    %edi,%edx
  803d81:	89 d1                	mov    %edx,%ecx
  803d83:	89 c6                	mov    %eax,%esi
  803d85:	e9 71 ff ff ff       	jmp    803cfb <__umoddi3+0xb3>
  803d8a:	66 90                	xchg   %ax,%ax
  803d8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d90:	72 ea                	jb     803d7c <__umoddi3+0x134>
  803d92:	89 d9                	mov    %ebx,%ecx
  803d94:	e9 62 ff ff ff       	jmp    803cfb <__umoddi3+0xb3>
